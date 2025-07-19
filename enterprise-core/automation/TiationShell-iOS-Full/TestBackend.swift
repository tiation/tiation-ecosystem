//
//  TestBackend.swift
//  TiationShell - Backend services test
//

import SwiftUI
import Combine
import Network

@main
struct TestBackendApp: App {
    var body: some Scene {
        WindowGroup {
            BackendTestView()
        }
    }
}

struct BackendTestView: View {
    @StateObject private var viewModel = BackendTestViewModel()
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Backend Services Test")) {
                    // Connection Test
                    HStack {
                        Text("SSH Connection")
                        Spacer()
                        if viewModel.isConnecting {
                            ProgressView()
                        } else {
                            Text(viewModel.connectionStatus)
                                .foregroundColor(viewModel.isConnected ? .green : .gray)
                        }
                    }
                    
                    Button("Test Connection") {
                        viewModel.testConnection()
                    }
                    .disabled(viewModel.isConnecting)
                }
                
                Section(header: Text("File Transfer Test")) {
                    HStack {
                        Text("Transfer Progress")
                        Spacer()
                        Text("\(Int(viewModel.transferProgress * 100))%")
                    }
                    
                    ProgressView(value: viewModel.transferProgress)
                    
                    HStack {
                        Button("Start Upload") {
                            viewModel.testUpload()
                        }
                        .disabled(viewModel.isTransferring)
                        
                        Spacer()
                        
                        Button("Start Download") {
                            viewModel.testDownload()
                        }
                        .disabled(viewModel.isTransferring)
                    }
                }
                
                Section(header: Text("Credential Storage Test")) {
                    Button("Save Test Credentials") {
                        viewModel.testCredentialSave()
                    }
                    
                    Button("Load Test Credentials") {
                        viewModel.testCredentialLoad()
                    }
                    
                    if !viewModel.credentialStatus.isEmpty {
                        Text(viewModel.credentialStatus)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Section(header: Text("Command Execution")) {
                    TextField("Command", text: $viewModel.command)
                    
                    Button("Execute") {
                        viewModel.executeCommand()
                    }
                    .disabled(!viewModel.isConnected)
                    
                    if !viewModel.commandOutput.isEmpty {
                        Text(viewModel.commandOutput)
                            .font(.system(.caption, design: .monospaced))
                            .padding(8)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(4)
                    }
                }
                
                Section(header: Text("Status Log")) {
                    ForEach(viewModel.logMessages, id: \.self) { message in
                        Text(message)
                            .font(.caption)
                    }
                }
            }
            .navigationTitle("Backend Test")
        }
    }
}

// MARK: - View Model

class BackendTestViewModel: ObservableObject {
    @Published var connectionStatus = "Disconnected"
    @Published var isConnecting = false
    @Published var isConnected = false
    @Published var transferProgress: Double = 0
    @Published var isTransferring = false
    @Published var credentialStatus = ""
    @Published var command = "ls -la"
    @Published var commandOutput = ""
    @Published var logMessages: [String] = []
    
    private var mockConnection: MockSSHConnection?
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        log("Backend test initialized")
    }
    
    func testConnection() {
        log("Testing SSH connection...")
        isConnecting = true
        connectionStatus = "Connecting..."
        
        // Simulate connection delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.isConnecting = false
            self?.isConnected = true
            self?.connectionStatus = "Connected"
            self?.mockConnection = MockSSHConnection()
            self?.log("✅ Connection established")
        }
    }
    
    func testUpload() {
        log("Starting upload test...")
        isTransferring = true
        transferProgress = 0
        
        // Simulate upload progress
        Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .prefix(20) // 2 seconds
            .sink { [weak self] _ in
                self?.transferProgress += 0.05
                if self?.transferProgress ?? 0 >= 1.0 {
                    self?.transferProgress = 1.0
                    self?.isTransferring = false
                    self?.log("✅ Upload complete")
                }
            }
            .store(in: &cancellables)
    }
    
    func testDownload() {
        log("Starting download test...")
        isTransferring = true
        transferProgress = 0
        
        // Simulate download progress
        Timer.publish(every: 0.15, on: .main, in: .common)
            .autoconnect()
            .prefix(13) // ~2 seconds
            .sink { [weak self] _ in
                self?.transferProgress += 0.077
                if self?.transferProgress ?? 0 >= 1.0 {
                    self?.transferProgress = 1.0
                    self?.isTransferring = false
                    self?.log("✅ Download complete")
                }
            }
            .store(in: &cancellables)
    }
    
    func testCredentialSave() {
        log("Saving test credentials...")
        
        // Simulate credential save
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.credentialStatus = "Credentials saved to keychain"
            self?.log("✅ Credentials saved securely")
        }
    }
    
    func testCredentialLoad() {
        log("Loading test credentials...")
        
        // Simulate credential load
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.credentialStatus = "Loaded: user@example.com"
            self?.log("✅ Credentials loaded from keychain")
        }
    }
    
    func executeCommand() {
        guard isConnected else { return }
        
        log("Executing: \(command)")
        
        // Simulate command execution
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let command = self?.command else { return }
            
            let output: String
            switch command {
            case "ls", "ls -la":
                output = """
                total 48
                drwxr-xr-x  6 user  staff   192 Jan 16 10:30 .
                drwxr-xr-x  5 user  staff   160 Jan 16 10:30 ..
                -rw-r--r--  1 user  staff  1234 Jan 16 10:30 README.md
                drwxr-xr-x  8 user  staff   256 Jan 16 10:30 Documents
                -rw-r--r--  1 user  staff  5678 Jan 16 10:30 config.json
                """
            case "pwd":
                output = "/home/user"
            case "whoami":
                output = "testuser"
            default:
                output = "Command executed successfully"
            }
            
            self?.commandOutput = output
            self?.log("✅ Command executed")
        }
    }
    
    private func log(_ message: String) {
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
        logMessages.insert("[\(timestamp)] \(message)", at: 0)
        
        // Keep only last 10 messages
        if logMessages.count > 10 {
            logMessages.removeLast()
        }
    }
}

// MARK: - Mock Connection

struct MockSSHConnection {
    let id = UUID()
    let isConnected = true
}
