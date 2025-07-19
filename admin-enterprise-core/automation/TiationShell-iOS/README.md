# TiationShell iOS 🚀

<div align="center">
  <img src="https://via.placeholder.com/800x200/1a1a2e/16213e?text=TiationShell+iOS" alt="TiationShell iOS Banner" />
  
  <h3>Enterprise SSH & File Management for iOS</h3>
  
  [![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)](https://github.com/tiation/tiationshell-ios)
  [![Platform](https://img.shields.io/badge/platform-iOS%2014.0+-lightgrey.svg)](https://developer.apple.com/ios/)
  [![Swift](https://img.shields.io/badge/swift-5.5+-orange.svg)](https://swift.org)
  [![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
</div>

## 🌟 Overview

TiationShell iOS is a powerful SSH client and file manager for iOS devices, similar to ShellFish. It allows you to:
- Connect to remote servers via SSH
- Browse and manage remote file systems
- Access server directories locally on your iOS device
- Execute terminal commands remotely
- Sync files between your device and servers

## ✨ Features

### Core Functionality
- **🔐 SSH Connections**: Secure connections with password or SSH key authentication
- **📁 File Browser**: Navigate remote file systems with an intuitive interface
- **💾 Local Access**: Mount server directories for local access
- **⚡ Terminal Emulator**: Execute commands on remote servers
- **🔄 File Sync**: Upload/download files between device and servers
- **📱 Native iOS**: Built with SwiftUI for optimal performance

### Key Components

#### Server Management
- Add unlimited servers
- Support for custom SSH ports
- Password and SSH key authentication
- Save server configurations securely

#### File Operations
- Browse directories and files
- View file permissions and sizes
- Create, delete, and rename files/folders
- Download files to local storage
- Upload files from device

#### Local Directory Access
- Mount server directories locally
- Access remote files through iOS Files app
- Automatic synchronization options
- Offline file access

## 📱 Screenshots

<div align="center">
  <img src="https://via.placeholder.com/250x500/1a1a2e/ffffff?text=Server+List" alt="Server List" width="250"/>
  <img src="https://via.placeholder.com/250x500/1a1a2e/ffffff?text=File+Browser" alt="File Browser" width="250"/>
  <img src="https://via.placeholder.com/250x500/1a1a2e/ffffff?text=Terminal" alt="Terminal" width="250"/>
</div>

## 🚀 Getting Started

### Requirements
- iOS 14.0+
- Xcode 13.0+
- Swift 5.5+

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/tiation/tiationshell-ios.git
   cd TiationShell-iOS
   ```

2. **Open in Xcode**
   ```bash
   open TiationShell.xcodeproj
   ```

3. **Build and Run**
   - Select your target device/simulator
   - Press `Cmd+R` to build and run

### Development Setup

For command-line building:
```bash
# Compile for simulator
xcrun -sdk iphonesimulator swiftc -target arm64-apple-ios14.0-simulator \
  TiationShellApp.swift ContentView.swift TiationShellCore.swift -o TiationShell

# Create app bundle
mkdir -p TiationShell.app
cp TiationShell TiationShell.app/
cp Info.plist TiationShell.app/

# Install on simulator
xcrun simctl install booted TiationShell.app

# Launch app
xcrun simctl launch booted com.tiation.tiationshell
```

## 💻 Usage

### Adding a Server

1. Tap the **+** button in the navigation bar
2. Enter server details:
   - **Name**: Friendly name for the server
   - **Host**: Server hostname or IP address
   - **Port**: SSH port (default: 22)
   - **Username**: Your SSH username
   - **Authentication**: Choose password or SSH key

### Browsing Files

1. Tap on a server from the list
2. Navigate through directories by tapping
3. View file details and permissions
4. Long-press for file operations menu

### Using Terminal

1. Open a server connection
2. Tap the **Terminal** button
3. Enter commands and press **Run**
4. View command output in real-time

### Mounting Directories

1. Open a server connection
2. Navigate to desired directory
3. Tap **Mount** button
4. Access files through iOS Files app

## 🏗️ Architecture

```
TiationShell-iOS/
├── TiationShell/
│   ├── TiationShellApp.swift    # App entry point
│   ├── ContentView.swift        # Main UI views
│   ├── TiationShellCore.swift   # Core functionality
│   └── Info.plist              # App configuration
├── TiationShell.xcodeproj/     # Xcode project
└── README.md                   # Documentation
```

### Core Classes

- **ServerManager**: Manages server configurations
- **SSHConnectionManager**: Handles SSH connections
- **FileSystemManager**: Remote file operations
- **LocalDirectoryManager**: Local mount management
- **TerminalEmulator**: Command execution

## 🔧 Configuration

### SSH Keys

Store SSH private keys in:
```
~/Documents/TiationShell/ssh_keys/
```

### Local Mounts

Default mount location:
```
~/TiationShell/mounts/
```

## 🤝 Contributing

We welcome contributions! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

### Development Guidelines

- Follow Swift style guidelines
- Write unit tests for new features
- Update documentation as needed
- Test on multiple iOS versions

## 📚 API Reference

### Server Model
```swift
struct Server {
    let id: UUID
    var name: String
    var host: String
    var port: Int
    var username: String
    var authMethod: AuthMethod
}
```

### File Operations
```swift
// List directory
FileSystemManager.shared.listDirectory(at: path, on: server)

// Download file
FileSystemManager.shared.downloadFile(from: remotePath, to: localPath, on: server)

// Upload file
FileSystemManager.shared.uploadFile(from: localPath, to: remotePath, on: server)
```

## 🔒 Security

- All server credentials are stored in iOS Keychain
- SSH connections use industry-standard encryption
- No data is transmitted to third-party services
- Local file access requires user permission

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/tiation/tiationshell-ios/issues)
- **Email**: tiatheone@protonmail.com
- **Documentation**: [Wiki](https://github.com/tiation/tiationshell-ios/wiki)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<div align="center">
  <p>Built with ❤️ by <a href="https://tiation.com">Tiation</a></p>
  <p>Enterprise-grade SSH client for iOS</p>
</div>
