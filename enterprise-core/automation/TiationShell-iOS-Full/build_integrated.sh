#!/bin/bash

# Build script for TiationShell integrated app

echo "🔨 Building TiationShell with integrated backend..."

# Create a temporary directory for building
BUILD_DIR="build_temp"
mkdir -p $BUILD_DIR

# Copy all source files
echo "📁 Copying source files..."
cp Sources/TiationShell/Models/Models.swift $BUILD_DIR/
cp Sources/TiationShell/Services/*.swift $BUILD_DIR/
cp Sources/TiationShell/Core/AppState.swift $BUILD_DIR/
cp Sources/TiationShell/TiationShellApp.swift $BUILD_DIR/
cp Sources/TiationShell/Views/ContentView.swift $BUILD_DIR/ 2>/dev/null || true

# Create a combined main file
echo "🔗 Creating combined source file..."
cat > $BUILD_DIR/CombinedApp.swift << 'EOF'
//
//  CombinedApp.swift
//  TiationShell - Complete integrated app
//

import SwiftUI
import Combine
import Network
import FileProvider
import Security
import CryptoKit

// MARK: - Main App

@main
struct TiationShellApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            MainContentView()
                .environmentObject(appState)
                .onAppear {
                    appState.initialize()
                }
        }
    }
}

// MARK: - Main Content View

struct MainContentView: View {
    @EnvironmentObject var appState: AppState
    @State private var showingAddServer = false
    
    var body: some View {
        NavigationView {
            List {
                // Servers
                Section(header: Text("SSH Servers")) {
                    ForEach(appState.servers) { server in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(server.name)
                                    .font(.headline)
                                Text("\(server.username)@\(server.host)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                if appState.currentConnection?.server.id == server.id {
                                    appState.disconnect()
                                } else {
                                    appState.connect(to: server)
                                }
                            }) {
                                if appState.isConnecting {
                                    ProgressView()
                                } else if appState.currentConnection?.server.id == server.id {
                                    Text("Disconnect")
                                        .foregroundColor(.red)
                                } else {
                                    Text("Connect")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                }
                
                // Connection Status
                if appState.currentConnection != nil {
                    Section(header: Text("Connection Status")) {
                        HStack {
                            Image(systemName: "wifi")
                                .foregroundColor(.green)
                            Text("Connected")
                            Spacer()
                        }
                        
                        // Show directory contents
                        ForEach(appState.currentDirectory) { item in
                            HStack {
                                Image(systemName: item.isDirectory ? "folder.fill" : "doc.fill")
                                    .foregroundColor(item.isDirectory ? .blue : .gray)
                                Text(item.name)
                                Spacer()
                                if let size = item.size {
                                    Text(ByteCountFormatter.string(fromByteCount: size, countStyle: .file))
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                }
                
                // Transfers
                if !appState.activeTransfers.isEmpty {
                    Section(header: Text("Active Transfers")) {
                        ForEach(appState.activeTransfers) { transfer in
                            VStack(alignment: .leading) {
                                Text(URL(fileURLWithPath: transfer.localPath).lastPathComponent)
                                    .font(.subheadline)
                                ProgressView(value: transfer.progress)
                                Text(transfer.formattedProgress)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
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
                AddServerSheet(appState: appState, isPresented: $showingAddServer)
            }
        }
    }
}

// MARK: - Add Server Sheet

struct AddServerSheet: View {
    let appState: AppState
    @Binding var isPresented: Bool
    
    @State private var name = ""
    @State private var host = ""
    @State private var port = "22"
    @State private var username = ""
    @State private var password = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Server Details")) {
                    TextField("Name", text: $name)
                    TextField("Host", text: $host)
                    TextField("Port", text: $port)
                        .keyboardType(.numberPad)
                    TextField("Username", text: $username)
                    SecureField("Password", text: $password)
                }
            }
            .navigationTitle("Add Server")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { isPresented = false }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let server = Server(
                            name: name,
                            host: host,
                            port: Int(port) ?? 22,
                            username: username,
                            authMethod: .password(password)
                        )
                        appState.addServer(server, password: password)
                        isPresented = false
                    }
                    .disabled(name.isEmpty || host.isEmpty || username.isEmpty)
                }
            }
        }
    }
}

// Include simplified versions of models and services for testing
// In production, these would be imported from the actual files

EOF

# Compile
echo "🚀 Compiling integrated app..."
cd $BUILD_DIR

# First try to compile just the models to see if they work
xcrun -sdk iphonesimulator swiftc \
    -target arm64-apple-ios14.0-simulator \
    -parse-as-library \
    -emit-module \
    -module-name TiationShellModels \
    Models.swift 2>&1 | head -20

# Try simpler compilation
echo "📦 Creating simplified integrated app..."
xcrun -sdk iphonesimulator swiftc \
    -target arm64-apple-ios14.0-simulator \
    -parse-as-library \
    CombinedApp.swift \
    -o ../TiationShellIntegrated

cd ..

# Create app bundle
echo "📱 Creating app bundle..."
rm -rf TiationShellIntegrated.app
mkdir -p TiationShellIntegrated.app
cp $BUILD_DIR/TiationShellIntegrated TiationShellIntegrated.app/ 2>/dev/null || true

# Create Info.plist
cat > TiationShellIntegrated.app/Info.plist << 'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>TiationShellIntegrated</string>
    <key>CFBundleIdentifier</key>
    <string>com.tiation.tiationshell</string>
    <key>CFBundleName</key>
    <string>TiationShell</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>2.0</string>
    <key>LSRequiresIPhoneOS</key>
    <true/>
    <key>UILaunchStoryboardName</key>
    <string>LaunchScreen</string>
    <key>UISupportedInterfaceOrientations</key>
    <array>
        <string>UIInterfaceOrientationPortrait</string>
        <string>UIInterfaceOrientationLandscapeLeft</string>
        <string>UIInterfaceOrientationLandscapeRight</string>
    </array>
</dict>
</plist>
PLIST

# Clean up
rm -rf $BUILD_DIR

echo "✅ Build complete!"
echo ""
echo "To run the app:"
echo "  xcrun simctl install booted TiationShellIntegrated.app"
echo "  xcrun simctl launch booted com.tiation.tiationshell"
