//
//  ContentView.swift
//  TiationShell
//
//  Created by Tiation on 2025-01-16.
//  Copyright © 2025 Tiation. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ShellViewModel()
    @State private var showingAddServer = false
    @State private var selectedServer: Server?
    
    var body: some View {
        NavigationView {
            // Server List
            List {
                Section(header: Text("Servers")) {
                    ForEach(viewModel.servers) { server in
                        ServerRowView(server: server) {
                            selectedServer = server
                        }
                    }
                    .onDelete(perform: viewModel.deleteServers)
                }
                
                Section(header: Text("Local Mounts")) {
                    ForEach(viewModel.localMounts) { mount in
                        LocalMountRowView(mount: mount)
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
                AddServerView(viewModel: viewModel)
            }
            .sheet(item: $selectedServer) { server in
                ServerDetailView(server: server, viewModel: viewModel)
            }
        }
    }
}

// MARK: - Server Row View

struct ServerRowView: View {
    let server: Server
    let onTap: () -> Void
    @State private var isConnected = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(server.name)
                    .font(.headline)
                Text("\(server.username)@\(server.host):\(server.port)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: isConnected ? "wifi" : "wifi.slash")
                .foregroundColor(isConnected ? .green : .gray)
        }
        .contentShape(Rectangle())
        .onTapGesture(perform: onTap)
    }
}

// MARK: - Add Server View

struct AddServerView: View {
    @ObservedObject var viewModel: ShellViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var host = ""
    @State private var port = "22"
    @State private var username = ""
    @State private var usePassword = true
    @State private var password = ""
    @State private var privateKeyPath = ""
    
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
                        TextField("Private Key Path", text: $privateKeyPath)
                            .autocapitalization(.none)
                    }
                }
            }
            .navigationTitle("Add Server")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { presentationMode.wrappedValue.dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveServer()
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(name.isEmpty || host.isEmpty)
                }
            }
        }
    }
    
    private func saveServer() {
        let authMethod: Server.AuthMethod = usePassword ? .password : .publicKey(path: privateKeyPath)
        let server = Server(
            id: UUID(),
            name: name,
            host: host,
            port: Int(port) ?? 22,
            username: username,
            authMethod: authMethod,
            localPath: nil
        )
        viewModel.addServer(server)
    }
}

// MARK: - Server Detail View

struct ServerDetailView: View {
    let server: Server
    @ObservedObject var viewModel: ShellViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var currentPath = "/"
    @State private var files: [FileItem] = []
    @State private var showingTerminal = false
    
    var body: some View {
        NavigationView {
            VStack {
                // Path Bar
                HStack {
                    Image(systemName: "folder")
                    Text(currentPath)
                        .font(.caption)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color.gray.opacity(0.1))
                
                // File List
                List(files, id: \.path) { file in
                    FileRowView(file: file) {
                        if file.isDirectory {
                            currentPath = file.path
                            loadFiles()
                        }
                    }
                }
                
                // Bottom Toolbar
                HStack {
                    Button(action: { showingTerminal = true }) {
                        Image(systemName: "terminal")
                        Text("Terminal")
                    }
                    
                    Spacer()
                    
                    Button(action: mountLocally) {
                        Image(systemName: "externaldrive.badge.plus")
                        Text("Mount")
                    }
                }
                .padding()
            }
            .navigationTitle(server.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { presentationMode.wrappedValue.dismiss() }
                }
            }
            .sheet(isPresented: $showingTerminal) {
                TerminalView(server: server)
            }
            .onAppear {
                loadFiles()
            }
        }
    }
    
    private func loadFiles() {
        files = FileSystemManager.shared.listDirectory(at: currentPath, on: server)
    }
    
    private func mountLocally() {
        let localPath = "/Users/tiaastor/TiationShell/mounts/\(server.name)"
        LocalDirectoryManager.shared.mountServerDirectory(server, at: localPath)
        viewModel.refreshLocalMounts()
    }
}

// MARK: - File Row View

struct FileRowView: View {
    let file: FileItem
    let onTap: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: file.isDirectory ? "folder.fill" : "doc.fill")
                .foregroundColor(file.isDirectory ? .blue : .gray)
            
            VStack(alignment: .leading) {
                Text(file.name)
                    .font(.body)
                
                HStack {
                    if let permissions = file.permissions {
                        Text(permissions)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    
                    if let size = file.size {
                        Text(formatFileSize(size))
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Spacer()
            
            if file.isDirectory {
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture(perform: onTap)
    }
    
    private func formatFileSize(_ bytes: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.countStyle = .file
        return formatter.string(fromByteCount: bytes)
    }
}

// MARK: - Terminal View

struct TerminalView: View {
    let server: Server
    @State private var command = ""
    @State private var output = "TiationShell Terminal\n$ "
    
    var body: some View {
        VStack {
            ScrollView {
                Text(output)
                    .font(.system(.body, design: .monospaced))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
            .background(Color.black)
            .foregroundColor(.green)
            
            HStack {
                TextField("Command", text: $command, onCommit: {
                    executeCommand()
                })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Run", action: executeCommand)
            }
            .padding()
        }
    }
    
    private func executeCommand() {
        guard !command.isEmpty else { return }
        output += "\(command)\n"
        // Execute command via SSH
        output += "Command output would appear here\n$ "
        command = ""
    }
}

// MARK: - Local Mount Row View

struct LocalMountRowView: View {
    let mount: LocalMount
    
    var body: some View {
        HStack {
            Image(systemName: "externaldrive.fill")
                .foregroundColor(.blue)
            
            VStack(alignment: .leading) {
                Text(mount.serverName)
                    .font(.headline)
                Text(mount.localPath)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
        }
    }
}

// MARK: - View Model

class ShellViewModel: ObservableObject {
    @Published var servers: [Server] = []
    @Published var localMounts: [LocalMount] = []
    
    init() {
        loadServers()
        refreshLocalMounts()
    }
    
    func loadServers() {
        servers = ServerManager.shared.getServers()
    }
    
    func addServer(_ server: Server) {
        ServerManager.shared.addServer(server)
        loadServers()
    }
    
    func deleteServers(at offsets: IndexSet) {
        for index in offsets {
            let server = servers[index]
            ServerManager.shared.removeServer(id: server.id)
        }
        loadServers()
    }
    
    func refreshLocalMounts() {
        // Get local mounts from file system
        localMounts = [
            LocalMount(serverName: "Development", localPath: "/Users/tiaastor/TiationShell/mounts/dev"),
            LocalMount(serverName: "Production", localPath: "/Users/tiaastor/TiationShell/mounts/prod")
        ]
    }
}

// MARK: - Models

extension Server: Identifiable {}

struct LocalMount: Identifiable {
    let id = UUID()
    let serverName: String
    let localPath: String
}

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
