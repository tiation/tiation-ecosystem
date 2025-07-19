//
//  IntegratedApp.swift
//  TiationShell - Complete app with backend integration
//

import SwiftUI
import Combine
import Network

// MARK: - Main App

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

// MARK: - Content View

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @State private var showingAddServer = false
    @State private var selectedServer: Server?
    
    var body: some View {
        NavigationView {
            List {
                // Servers Section
                Section(header: Text("SSH Servers")) {
                    ForEach(appState.servers) { server in
                        ServerRow(server: server) {
                            if appState.currentConnection?.server.id == server.id {
                                appState.disconnect()
                            } else {
                                appState.connect(to: server)
                            }
                        }
                        .foregroundColor(appState.currentConnection?.server.id == server.id ? .green : .primary)
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            appState.deleteServer(appState.servers[index])
                        }
                    }
                }
                
                // Connection Status
                if let connection = appState.currentConnection {
                    Section(header: Text("Connected to \(connection.server.name)")) {
                        HStack {
                            Image(systemName: "wifi")
                                .foregroundColor(.green)
                            Text("Connected")
                            Spacer()
                            Button("Disconnect") {
                                appState.disconnect()
                            }
                            .foregroundColor(.red)
                        }
                        
                        // Current Directory
                        if !appState.currentDirectory.isEmpty {
                            ForEach(appState.currentDirectory) { item in
                                FileItemRow(item: item) {
                                    if item.isDirectory {
                                        appState.listDirectory(item.path)
                                    }
                                }
                            }
                        }
                    }
                }
                
                // Active Transfers
                if !appState.activeTransfers.isEmpty {
                    Section(header: Text("Active Transfers")) {
                        ForEach(appState.activeTransfers) { transfer in
                            TransferRow(transfer: transfer) {
                                appState.cancelTransfer(transfer.id)
                            }
                        }
                    }
                }
                
                // SSH Keys
                Section(header: Text("SSH Keys")) {
                    ForEach(appState.sshKeys, id: \.name) { key in
                        HStack {
                            Image(systemName: key.isEncrypted ? "lock.fill" : "key.fill")
                                .foregroundColor(key.isEncrypted ? .orange : .blue)
                            Text(key.name)
                            Spacer()
                            Text(key.createdAt, style: .date)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("TiationShell")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddServer = true }) {
                        Image(systemName: "plus.circle.fill")
                    }
                }
            }
            .sheet(isPresented: $showingAddServer) {
                AddServerView()
                    .environmentObject(appState)
            }
        }
        .alert("Connection Error", isPresented: .constant(appState.connectionError != nil)) {
            Button("OK") {
                appState.connectionError = nil
            }
        } message: {
            Text(appState.connectionError?.localizedDescription ?? "Unknown error")
        }
    }
}

// MARK: - Server Row

struct ServerRow: View {
    let server: Server
    let onTap: () -> Void
    @EnvironmentObject var appState: AppState
    
    var isConnected: Bool {
        appState.currentConnection?.server.id == server.id
    }
    
    var body: some View {
        HStack {
            Image(systemName: "server.rack")
                .foregroundColor(isConnected ? .green : .blue)
            
            VStack(alignment: .leading) {
                Text(server.name)
                    .font(.headline)
                Text("\(server.username)@\(server.host):\(server.port)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if appState.isConnecting && !isConnected {
                ProgressView()
                    .scaleEffect(0.8)
            } else {
                Image(systemName: isConnected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isConnected ? .green : .gray)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture(perform: onTap)
    }
}

// MARK: - File Item Row

struct FileItemRow: View {
    let item: FileItem
    let onTap: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: item.icon)
                .foregroundColor(item.isDirectory ? .blue : .gray)
            
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.body)
                
                HStack {
                    if let permissions = item.permissions {
                        Text(permissions)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    
                    if !item.isDirectory {
                        Text(item.formattedSize)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Spacer()
            
            if item.isDirectory {
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .font(.caption)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture(perform: onTap)
    }
}

// MARK: - Transfer Row

struct TransferRow: View {
    let transfer: FileTransfer
    let onCancel: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: transfer.type == .upload ? "arrow.up.circle" : "arrow.down.circle")
                    .foregroundColor(transfer.type == .upload ? .blue : .green)
                
                Text(URL(fileURLWithPath: transfer.localPath).lastPathComponent)
                    .font(.subheadline)
                    .lineLimit(1)
                
                Spacer()
                
                if transfer.status == .inProgress {
                    Button(action: onCancel) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red)
                    }
                }
            }
            
            if transfer.status == .inProgress {
                ProgressView(value: transfer.progress)
                Text(transfer.formattedProgress)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Text(transfer.status.rawValue.capitalized)
                .font(.caption)
                .foregroundColor(statusColor(for: transfer.status))
        }
    }
    
    private func statusColor(for status: FileTransfer.TransferStatus) -> Color {
        switch status {
        case .pending: return .gray
        case .inProgress: return .blue
        case .completed: return .green
        case .failed: return .red
        case .cancelled: return .orange
        }
    }
}

// MARK: - Add Server View

struct AddServerView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var host = ""
    @State private var port = "22"
    @State private var username = ""
    @State private var password = ""
    @State private var usePassword = true
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Server Details")) {
                    TextField("Name", text: $name)
                    TextField("Host", text: $host)
                        .autocapitalization(.none)
                    TextField("Port", text: $port)
                        .keyboardType(.numberPad)
                    TextField("Username", text: $username)
                        .autocapitalization(.none)
                }
                
                Section(header: Text("Authentication")) {
                    Picker("Method", selection: $usePassword) {
                        Text("Password").tag(true)
                        Text("SSH Key").tag(false)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    if usePassword {
                        SecureField("Password", text: $password)
                    } else {
                        Text("Select SSH Key")
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("Add Server")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let server = Server(
                            name: name,
                            host: host,
                            port: Int(port) ?? 22,
                            username: username,
                            authMethod: usePassword ? .password(password) : .publicKey(path: "")
                        )
                        appState.addServer(server, password: usePassword ? password : nil)
                        dismiss()
                    }
                    .disabled(name.isEmpty || host.isEmpty || username.isEmpty)
                }
            }
        }
    }
}

// MARK: - Import All Backend Services

// The actual backend services would be imported here
// For testing, let's include simplified versions inline

// Simplified AppState for testing
class AppState: ObservableObject {
    @Published var servers: [Server] = [
        Server(name: "Test Server", host: "test.local", username: "demo")
    ]
    @Published var localMounts: [LocalMount] = []
    @Published var activeTransfers: [FileTransfer] = []
    @Published var currentConnection: SSHConnection?
    @Published var isConnecting = false
    @Published var connectionError: Error?
    @Published var currentDirectory: [FileItem] = []
    @Published var sshKeys: [SSHKeyInfo] = [
        SSHKeyInfo(name: "id_rsa", createdAt: Date(), isEncrypted: false),
        SSHKeyInfo(name: "deploy_key", createdAt: Date(), isEncrypted: true)
    ]
    
    func initialize() {
        print("AppState initialized")
    }
    
    func connect(to server: Server) {
        isConnecting = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.isConnecting = false
            self?.currentConnection = SSHConnection(
                id: UUID(),
                server: server,
                isConnected: true,
                connectedAt: Date(),
                session: SSHSession()
            )
            self?.listDirectory("/")
        }
    }
    
    func disconnect() {
        currentConnection = nil
        currentDirectory = []
    }
    
    func listDirectory(_ path: String) {
        currentDirectory = [
            FileItem(name: "..", path: path.components(separatedBy: "/").dropLast().joined(separator: "/"), isDirectory: true),
            FileItem(name: "Documents", path: "\(path)/Documents", isDirectory: true, permissions: "drwxr-xr-x"),
            FileItem(name: "Downloads", path: "\(path)/Downloads", isDirectory: true, permissions: "drwxr-xr-x"),
            FileItem(name: "config.json", path: "\(path)/config.json", isDirectory: false, size: 1234, permissions: "-rw-r--r--"),
            FileItem(name: "data.db", path: "\(path)/data.db", isDirectory: false, size: 567890, permissions: "-rw-r--r--")
        ]
    }
    
    func addServer(_ server: Server, password: String?) {
        servers.append(server)
    }
    
    func deleteServer(_ server: Server) {
        servers.removeAll { $0.id == server.id }
        if currentConnection?.server.id == server.id {
            disconnect()
        }
    }
    
    func cancelTransfer(_ id: UUID) {
        activeTransfers.removeAll { $0.id == id }
    }
}

// Import the models and supporting types from our backend
struct SSHConnection {
    let id: UUID
    let server: Server
    var isConnected: Bool
    var connectedAt: Date?
    let session: SSHSession
}

class SSHSession {
    func close() {}
}

struct SSHKeyInfo {
    let name: String
    let createdAt: Date
    let isEncrypted: Bool
}
