//
//  SimpleApp.swift
//  TiationShell - Simplified version for immediate execution
//

import SwiftUI

@main
struct TiationShellApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    @State private var servers: [Server] = [
        Server(id: UUID(), name: "Development", host: "dev.tiation.com", port: 22, username: "developer"),
        Server(id: UUID(), name: "Production", host: "prod.tiation.com", port: 22, username: "admin")
    ]
    @State private var showingAddServer = false
    @State private var selectedServer: Server?
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("SSH Servers")) {
                    ForEach(servers) { server in
                        ServerRow(server: server) {
                            selectedServer = server
                        }
                    }
                    .onDelete { indexSet in
                        servers.remove(atOffsets: indexSet)
                    }
                }
                
                Section(header: Text("Features")) {
                    FeatureRow(icon: "lock.shield", title: "Secure Storage", subtitle: "Credentials stored in iOS Keychain")
                    FeatureRow(icon: "folder", title: "File Access", subtitle: "Browse and transfer files")
                    FeatureRow(icon: "terminal", title: "Terminal", subtitle: "Execute remote commands")
                    FeatureRow(icon: "externaldrive.connected.to.line.below", title: "Local Mount", subtitle: "Access in iOS Files app")
                }
            }
            .navigationTitle("🚀 TiationShell")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddServer = true }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                    }
                }
            }
            .sheet(isPresented: $showingAddServer) {
                AddServerSheet(servers: $servers, isPresented: $showingAddServer)
            }
            .sheet(item: $selectedServer) { server in
                ServerDetailView(server: server)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ServerRow: View {
    let server: Server
    let onTap: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: "server.rack")
                .foregroundColor(.blue)
                .frame(width: 30)
            
            VStack(alignment: .leading) {
                Text(server.name)
                    .font(.headline)
                Text("\(server.username)@\(server.host):\(server.port)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .font(.caption)
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .onTapGesture(perform: onTap)
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.green)
                .frame(width: 30)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.subheadline)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 2)
    }
}

struct AddServerSheet: View {
    @Binding var servers: [Server]
    @Binding var isPresented: Bool
    
    @State private var name = ""
    @State private var host = ""
    @State private var port = "22"
    @State private var username = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Server Details")) {
                    TextField("Name", text: $name)
                    TextField("Host", text: $host)
                        .textContentType(.URL)
                        .autocapitalization(.none)
                    TextField("Port", text: $port)
                        .keyboardType(.numberPad)
                    TextField("Username", text: $username)
                        .textContentType(.username)
                        .autocapitalization(.none)
                }
                
                Section {
                    Button("Add Server") {
                        let server = Server(
                            id: UUID(),
                            name: name,
                            host: host,
                            port: Int(port) ?? 22,
                            username: username
                        )
                        servers.append(server)
                        isPresented = false
                    }
                    .disabled(name.isEmpty || host.isEmpty || username.isEmpty)
                }
            }
            .navigationTitle("Add Server")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
            }
        }
    }
}

struct ServerDetailView: View {
    let server: Server
    @State private var currentPath = "/"
    @State private var showingTerminal = false
    
    var body: some View {
        NavigationView {
            VStack {
                // Connection Status
                HStack {
                    Image(systemName: "circle.fill")
                        .foregroundColor(.green)
                        .font(.caption)
                    Text("Connected")
                        .font(.caption)
                    Spacer()
                    Text(server.host)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                
                // File Browser
                List {
                    FileRow(name: "Documents", isDirectory: true)
                    FileRow(name: "Downloads", isDirectory: true)
                    FileRow(name: "config.json", isDirectory: false)
                    FileRow(name: "data.db", isDirectory: false)
                    FileRow(name: "logs", isDirectory: true)
                }
                
                // Action Buttons
                HStack(spacing: 20) {
                    ActionButton(icon: "terminal", title: "Terminal") {
                        showingTerminal = true
                    }
                    ActionButton(icon: "arrow.down.circle", title: "Download") {
                        // Download action
                    }
                    ActionButton(icon: "arrow.up.circle", title: "Upload") {
                        // Upload action
                    }
                    ActionButton(icon: "externaldrive.badge.plus", title: "Mount") {
                        // Mount action
                    }
                }
                .padding()
            }
            .navigationTitle(server.name)
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingTerminal) {
                TerminalView(server: server)
            }
        }
    }
}

struct FileRow: View {
    let name: String
    let isDirectory: Bool
    
    var body: some View {
        HStack {
            Image(systemName: isDirectory ? "folder.fill" : "doc.fill")
                .foregroundColor(isDirectory ? .blue : .gray)
            
            Text(name)
            
            Spacer()
            
            if isDirectory {
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .font(.caption)
            }
        }
        .padding(.vertical, 4)
    }
}

struct ActionButton: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: icon)
                    .font(.title2)
                Text(title)
                    .font(.caption)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct TerminalView: View {
    let server: Server
    @State private var command = ""
    @State private var output = "TiationShell Terminal v2.0\n$ "
    
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
                TextField("Command", text: $command)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Run") {
                    output += "\(command)\n"
                    output += "$ "
                    command = ""
                }
            }
            .padding()
        }
    }
}

// Models
struct Server: Identifiable {
    let id: UUID
    let name: String
    let host: String
    let port: Int
    let username: String
}
