//
//  TiationShellApp.swift
//  TiationShell
//
//  Main app entry point with full SSH functionality
//

import SwiftUI
import Combine

@main
struct TiationShellApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .onAppear {
                    appState.initialize()
                }
        }
    }
}

// MARK: - App State

class AppState: ObservableObject {
    @Published var servers: [Server] = []
    @Published var localMounts: [LocalMount] = []
    @Published var activeTransfers: [FileTransfer] = []
    @Published var currentConnection: SSHConnection?
    @Published var isConnecting = false
    @Published var connectionError: Error?
    
    private let sshService = SSHService.shared
    private let keychainService = KeychainService.shared
    private var cancellables = Set<AnyCancellable>()
    
    private let serversKey = "com.tiation.servers"
    private let mountsKey = "com.tiation.mounts"
    
    func initialize() {
        loadServers()
        loadLocalMounts()
        setupFileProviderDomain()
    }
    
    // MARK: - Server Management
    
    func loadServers() {
        if let data = UserDefaults.standard.data(forKey: serversKey),
           let decoded = try? JSONDecoder().decode([Server].self, from: data) {
            servers = decoded
        }
    }
    
    func saveServers() {
        if let encoded = try? JSONEncoder().encode(servers) {
            UserDefaults.standard.set(encoded, forKey: serversKey)
        }
    }
    
    func addServer(_ server: Server) {
        servers.append(server)
        saveServers()
        
        // Save credentials to keychain
        do {
            try keychainService.saveServerCredentials(server)
        } catch {
            print("Failed to save credentials: \(error)")
        }
    }
    
    func updateServer(_ server: Server) {
        if let index = servers.firstIndex(where: { $0.id == server.id }) {
            servers[index] = server
            saveServers()
            
            // Update credentials
            do {
                try keychainService.saveServerCredentials(server)
            } catch {
                print("Failed to update credentials: \(error)")
            }
        }
    }
    
    func deleteServer(_ server: Server) {
        servers.removeAll { $0.id == server.id }
        saveServers()
        
        // Remove credentials
        do {
            try keychainService.deleteServerCredentials(for: server.id)
        } catch {
            print("Failed to delete credentials: \(error)")
        }
        
        // Disconnect if connected
        if currentConnection?.server.id == server.id {
            disconnect()
        }
    }
    
    // MARK: - Connection Management
    
    func connect(to server: Server) {
        isConnecting = true
        connectionError = nil
        
        sshService.connect(to: server)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isConnecting = false
                    if case .failure(let error) = completion {
                        self?.connectionError = error
                    }
                },
                receiveValue: { [weak self] connection in
                    self?.currentConnection = connection
                    
                    // Update last connected time
                    if var updatedServer = self?.servers.first(where: { $0.id == server.id }) {
                        updatedServer.lastConnected = Date()
                        self?.updateServer(updatedServer)
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    func disconnect() {
        if let connection = currentConnection {
            sshService.disconnect(from: connection.server)
            currentConnection = nil
        }
    }
    
    // MARK: - File Operations
    
    func listDirectory(_ path: String, on connection: SSHConnection) -> AnyPublisher<[FileItem], Error> {
        return sshService.listDirectory(path, on: connection)
    }
    
    func downloadFile(from remotePath: String, to localURL: URL) {
        guard let connection = currentConnection else { return }
        
        let transfer = FileTransfer(
            type: .download,
            localPath: localURL.path,
            remotePath: remotePath,
            serverId: connection.server.id,
            totalBytes: 0,
            transferredBytes: 0,
            status: .pending,
            startedAt: Date()
        )
        
        activeTransfers.append(transfer)
        
        sshService.downloadFile(from: remotePath, to: localURL, on: connection)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.updateTransferStatus(transfer.id, status: .failed, error: error.localizedDescription)
                    }
                },
                receiveValue: { [weak self] progress in
                    self?.updateTransferProgress(transfer.id, progress: progress)
                    if progress.isFinished {
                        self?.updateTransferStatus(transfer.id, status: .completed)
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    func uploadFile(from localURL: URL, to remotePath: String) {
        guard let connection = currentConnection else { return }
        
        let transfer = FileTransfer(
            type: .upload,
            localPath: localURL.path,
            remotePath: remotePath,
            serverId: connection.server.id,
            totalBytes: 0,
            transferredBytes: 0,
            status: .pending,
            startedAt: Date()
        )
        
        activeTransfers.append(transfer)
        
        sshService.uploadFile(from: localURL, to: remotePath, on: connection)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.updateTransferStatus(transfer.id, status: .failed, error: error.localizedDescription)
                    }
                },
                receiveValue: { [weak self] progress in
                    self?.updateTransferProgress(transfer.id, progress: progress)
                    if progress.isFinished {
                        self?.updateTransferStatus(transfer.id, status: .completed)
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    // MARK: - Local Mount Management
    
    func loadLocalMounts() {
        if let data = UserDefaults.standard.data(forKey: mountsKey),
           let decoded = try? JSONDecoder().decode([LocalMount].self, from: data) {
            localMounts = decoded
        }
    }
    
    func saveLocalMounts() {
        if let encoded = try? JSONEncoder().encode(localMounts) {
            UserDefaults.standard.set(encoded, forKey: mountsKey)
        }
    }
    
    func addLocalMount(_ mount: LocalMount) {
        localMounts.append(mount)
        saveLocalMounts()
        
        // Register with file provider
        registerFileProviderDomain(for: mount)
    }
    
    func removeLocalMount(_ mount: LocalMount) {
        localMounts.removeAll { $0.id == mount.id }
        saveLocalMounts()
        
        // Unregister from file provider
        unregisterFileProviderDomain(for: mount)
    }
    
    // MARK: - File Provider Integration
    
    private func setupFileProviderDomain() {
        // Setup file provider domains for each server
        for server in servers {
            let domain = NSFileProviderDomain(
                identifier: NSFileProviderDomainIdentifier(rawValue: server.id.uuidString),
                displayName: server.name
            )
            
            NSFileProviderManager.add(domain) { error in
                if let error = error {
                    print("Failed to add file provider domain: \(error)")
                }
            }
        }
    }
    
    private func registerFileProviderDomain(for mount: LocalMount) {
        let domain = NSFileProviderDomain(
            identifier: NSFileProviderDomainIdentifier(rawValue: mount.id.uuidString),
            displayName: mount.serverName
        )
        
        NSFileProviderManager.add(domain) { error in
            if let error = error {
                print("Failed to register file provider domain: \(error)")
            }
        }
    }
    
    private func unregisterFileProviderDomain(for mount: LocalMount) {
        NSFileProviderManager.remove(
            NSFileProviderDomain(
                identifier: NSFileProviderDomainIdentifier(rawValue: mount.id.uuidString),
                displayName: mount.serverName
            )
        ) { error in
            if let error = error {
                print("Failed to unregister file provider domain: \(error)")
            }
        }
    }
    
    // MARK: - Transfer Management
    
    private func updateTransferProgress(_ transferId: UUID, progress: Progress) {
        if let index = activeTransfers.firstIndex(where: { $0.id == transferId }) {
            activeTransfers[index].transferredBytes = progress.completedUnitCount
            activeTransfers[index].status = .inProgress
        }
    }
    
    private func updateTransferStatus(_ transferId: UUID, status: FileTransfer.TransferStatus, error: String? = nil) {
        if let index = activeTransfers.firstIndex(where: { $0.id == transferId }) {
            activeTransfers[index].status = status
            activeTransfers[index].error = error
            
            if status == .completed || status == .failed || status == .cancelled {
                activeTransfers[index].completedAt = Date()
            }
        }
    }
}
