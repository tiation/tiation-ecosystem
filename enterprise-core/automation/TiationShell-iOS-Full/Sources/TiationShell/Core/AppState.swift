//
//  AppState.swift
//  TiationShell
//
//  Central app state management with backend integration
//

import SwiftUI
import Combine
import FileProvider

// MARK: - App State

class AppState: ObservableObject {
    // MARK: - Published Properties
    
    @Published var servers: [Server] = []
    @Published var localMounts: [LocalMount] = []
    @Published var activeTransfers: [FileTransfer] = []
    @Published var currentConnection: SSHConnection?
    @Published var isConnecting = false
    @Published var connectionError: Error?
    @Published var currentDirectory: [FileItem] = []
    @Published var sshKeys: [SSHKeyInfo] = []
    
    // MARK: - Services
    
    private let sshService = SSHConnectionService.shared
    private let transferService = FileTransferService.shared
    private let credentialService = CredentialStorageService.shared
    
    // MARK: - Private Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let serversKey = "com.tiation.servers"
    private let mountsKey = "com.tiation.mounts"
    
    // MARK: - Initialization
    
    init() {
        loadData()
        setupObservers()
    }
    
    func initialize() {
        loadServers()
        loadLocalMounts()
        loadSSHKeys()
        setupFileProviderDomain()
        monitorActiveTransfers()
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
    
    func addServer(_ server: Server, password: String? = nil) {
        servers.append(server)
        saveServers()
        
        // Save credentials
        if case .password = server.authMethod, let password = password {
            try? credentialService.saveServerPassword(password, for: server)
        }
        
        // Create file provider domain
        registerFileProviderDomain(for: server)
    }
    
    func updateServer(_ server: Server) {
        if let index = servers.firstIndex(where: { $0.id == server.id }) {
            servers[index] = server
            saveServers()
        }
    }
    
    func deleteServer(_ server: Server) {
        servers.removeAll { $0.id == server.id }
        saveServers()
        
        // Clean up credentials
        try? credentialService.deleteServerPassword(for: server)
        try? credentialService.deleteServerCredentials(for: server.id)
        
        // Disconnect if connected
        if currentConnection?.server.id == server.id {
            disconnect()
        }
        
        // Remove file provider domain
        unregisterFileProviderDomain(for: server)
    }
    
    // MARK: - Connection Management
    
    func connect(to server: Server) {
        isConnecting = true
        connectionError = nil
        
        // Load credentials
        let credentials = loadServerCredentials(for: server)
        
        sshService.connect(to: server)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isConnecting = false
                    if case .failure(let error) = completion {
                        self?.connectionError = error
                        self?.showConnectionError(error)
                    }
                },
                receiveValue: { [weak self] connection in
                    self?.currentConnection = connection
                    self?.onConnectionEstablished(connection)
                }
            )
            .store(in: &cancellables)
    }
    
    func disconnect() {
        if let connection = currentConnection {
            sshService.disconnect(from: connection)
            currentConnection = nil
            currentDirectory = []
        }
    }
    
    // MARK: - File Operations
    
    func listDirectory(_ path: String) {
        guard let connection = currentConnection else { return }
        
        sshService.listDirectory(at: path, on: connection)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print("Failed to list directory: \(error)")
                    }
                },
                receiveValue: { [weak self] items in
                    self?.currentDirectory = items
                }
            )
            .store(in: &cancellables)
    }
    
    func executeCommand(_ command: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let connection = currentConnection else {
            completion(.failure(SSHError.notConnected))
            return
        }
        
        sshService.execute(command: command, on: connection)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { result in
                    if case .failure(let error) = result {
                        completion(.failure(error))
                    }
                },
                receiveValue: { output in
                    completion(.success(output))
                }
            )
            .store(in: &cancellables)
    }
    
    // MARK: - File Transfer
    
    func downloadFile(from remotePath: String, to localURL: URL) {
        guard let connection = currentConnection else { return }
        
        transferService.download(from: remotePath, to: localURL, on: connection)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.handleTransferError(error)
                    }
                },
                receiveValue: { [weak self] progress in
                    self?.updateTransferProgress(progress)
                }
            )
            .store(in: &cancellables)
    }
    
    func uploadFile(from localURL: URL, to remotePath: String) {
        guard let connection = currentConnection else { return }
        
        transferService.upload(fileURL: localURL, to: remotePath, on: connection)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.handleTransferError(error)
                    }
                },
                receiveValue: { [weak self] progress in
                    self?.updateTransferProgress(progress)
                }
            )
            .store(in: &cancellables)
    }
    
    func cancelTransfer(_ transferId: UUID) {
        transferService.cancelTransfer(transferId)
        activeTransfers.removeAll { $0.id == transferId }
    }
    
    // MARK: - SSH Key Management
    
    func loadSSHKeys() {
        sshKeys = credentialService.listSSHKeys()
    }
    
    func importSSHKey(from url: URL, passphrase: String? = nil) throws {
        let keyData = try Data(contentsOf: url)
        let keyName = url.lastPathComponent
        
        _ = try credentialService.saveSSHKey(keyData, name: keyName, passphrase: passphrase)
        loadSSHKeys()
    }
    
    func deleteSSHKey(_ keyInfo: SSHKeyInfo) throws {
        try credentialService.deleteSSHKey(name: keyInfo.name)
        loadSSHKeys()
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
    
    func addLocalMount(server: Server, remotePath: String, localPath: String) {
        let mount = LocalMount(
            serverName: server.name,
            serverId: server.id,
            remotePath: remotePath,
            localPath: localPath
        )
        
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
    
    func syncMount(_ mount: LocalMount) {
        guard let server = servers.first(where: { $0.id == mount.serverId }),
              let connection = sshService.getActiveConnection(for: server.id) else {
            // Need to connect first
            return
        }
        
        let localURL = URL(fileURLWithPath: mount.localPath)
        
        transferService.syncDirectory(localPath: localURL, remotePath: mount.remotePath, on: connection)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print("Sync failed: \(error)")
                    }
                },
                receiveValue: { [weak self] syncResult in
                    self?.handleSyncResult(syncResult, for: mount)
                }
            )
            .store(in: &cancellables)
    }
    
    // MARK: - Private Methods
    
    private func loadData() {
        loadServers()
        loadLocalMounts()
        loadSSHKeys()
    }
    
    private func setupObservers() {
        // Monitor transfer updates
        Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateActiveTransfers()
            }
            .store(in: &cancellables)
    }
    
    private func onConnectionEstablished(_ connection: SSHConnection) {
        // Update last connected time
        if var server = servers.first(where: { $0.id == connection.server.id }) {
            server.lastConnected = Date()
            updateServer(server)
        }
        
        // List root directory
        listDirectory("/")
        
        // Show success message
        showConnectionSuccess(connection.server.name)
    }
    
    private func loadServerCredentials(for server: Server) -> ServerCredentials? {
        return credentialService.loadServerCredentials(for: server.id)
    }
    
    private func monitorActiveTransfers() {
        activeTransfers = transferService.getActiveTransfers()
    }
    
    private func updateActiveTransfers() {
        activeTransfers = transferService.getActiveTransfers()
    }
    
    private func updateTransferProgress(_ progress: TransferProgress) {
        if let index = activeTransfers.firstIndex(where: { $0.id == progress.transfer.id }) {
            activeTransfers[index] = progress.transfer
        } else {
            activeTransfers.append(progress.transfer)
        }
    }
    
    private func handleTransferError(_ error: Error) {
        // Show error alert
        print("Transfer error: \(error.localizedDescription)")
    }
    
    private func handleSyncResult(_ result: SyncResult, for mount: LocalMount) {
        print("Sync result for \(mount.serverName):")
        print("  Files to upload: \(result.toUpload.count)")
        print("  Files to download: \(result.toDownload.count)")
        print("  Conflicts: \(result.conflicts.count)")
        
        // Handle sync operations
        // This would trigger the actual sync process
    }
    
    // MARK: - File Provider Integration
    
    private func setupFileProviderDomain() {
        // Setup file provider domains for each server
        for server in servers {
            registerFileProviderDomain(for: server)
        }
    }
    
    private func registerFileProviderDomain(for server: Server) {
        let domain = NSFileProviderDomain(
            identifier: NSFileProviderDomainIdentifier(rawValue: server.id.uuidString),
            displayName: server.name
        )
        
        NSFileProviderManager.add(domain) { error in
            if let error = error {
                print("Failed to add file provider domain: \(error)")
            } else {
                print("Successfully registered file provider domain for \(server.name)")
            }
        }
    }
    
    private func unregisterFileProviderDomain(for server: Server) {
        let domain = NSFileProviderDomain(
            identifier: NSFileProviderDomainIdentifier(rawValue: server.id.uuidString),
            displayName: server.name
        )
        
        NSFileProviderManager.remove(domain) { error in
            if let error = error {
                print("Failed to remove file provider domain: \(error)")
            }
        }
    }
    
    private func registerFileProviderDomain(for mount: LocalMount) {
        let domain = NSFileProviderDomain(
            identifier: NSFileProviderDomainIdentifier(rawValue: mount.id.uuidString),
            displayName: "\(mount.serverName) - \(mount.remotePath)"
        )
        
        NSFileProviderManager.add(domain) { error in
            if let error = error {
                print("Failed to register mount domain: \(error)")
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
                print("Failed to unregister mount domain: \(error)")
            }
        }
    }
    
    // MARK: - UI Feedback
    
    private func showConnectionError(_ error: Error) {
        // This would trigger an alert in the UI
        print("Connection error: \(error.localizedDescription)")
    }
    
    private func showConnectionSuccess(_ serverName: String) {
        // This would show a success message in the UI
        print("Successfully connected to \(serverName)")
    }
}
