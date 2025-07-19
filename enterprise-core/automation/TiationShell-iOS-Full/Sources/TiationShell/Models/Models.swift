//
//  Models.swift
//  TiationShell
//
//  Core data models
//

import Foundation

// MARK: - Server Model

struct Server: Codable, Identifiable {
    let id: UUID
    var name: String
    var host: String
    var port: Int
    var username: String
    var authMethod: AuthMethod
    var localPath: String?
    var lastConnected: Date?
    var createdAt: Date
    var modifiedAt: Date
    
    init(id: UUID = UUID(),
         name: String,
         host: String,
         port: Int = 22,
         username: String,
         authMethod: AuthMethod,
         localPath: String? = nil) {
        self.id = id
        self.name = name
        self.host = host
        self.port = port
        self.username = username
        self.authMethod = authMethod
        self.localPath = localPath
        self.lastConnected = nil
        self.createdAt = Date()
        self.modifiedAt = Date()
    }
    
    enum AuthMethod: Codable {
        case password(String)
        case publicKey(path: String)
        
        enum CodingKeys: String, CodingKey {
            case type
            case value
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let type = try container.decode(String.self, forKey: .type)
            
            switch type {
            case "password":
                let password = try container.decode(String.self, forKey: .value)
                self = .password(password)
            case "publicKey":
                let path = try container.decode(String.self, forKey: .value)
                self = .publicKey(path: path)
            default:
                throw DecodingError.dataCorruptedError(
                    forKey: .type,
                    in: container,
                    debugDescription: "Unknown auth method type"
                )
            }
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            switch self {
            case .password(let password):
                try container.encode("password", forKey: .type)
                try container.encode(password, forKey: .value)
            case .publicKey(let path):
                try container.encode("publicKey", forKey: .type)
                try container.encode(path, forKey: .value)
            }
        }
    }
}

// MARK: - File Item Model

struct FileItem: Identifiable {
    let id = UUID()
    let name: String
    let path: String
    let isDirectory: Bool
    let size: Int64?
    let modificationDate: Date?
    let permissions: String?
    let owner: String?
    let group: String?
    let isSymlink: Bool
    let symlinkTarget: String?
    
    init(name: String,
         path: String,
         isDirectory: Bool,
         size: Int64? = nil,
         modificationDate: Date? = nil,
         permissions: String? = nil,
         owner: String? = nil,
         group: String? = nil,
         isSymlink: Bool = false,
         symlinkTarget: String? = nil) {
        self.name = name
        self.path = path
        self.isDirectory = isDirectory
        self.size = size
        self.modificationDate = modificationDate
        self.permissions = permissions
        self.owner = owner
        self.group = group
        self.isSymlink = isSymlink
        self.symlinkTarget = symlinkTarget
    }
    
    var formattedSize: String {
        guard let size = size else { return "-" }
        
        let formatter = ByteCountFormatter()
        formatter.countStyle = .file
        return formatter.string(fromByteCount: size)
    }
    
    var formattedDate: String {
        guard let date = modificationDate else { return "-" }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    var icon: String {
        if isSymlink {
            return "link"
        } else if isDirectory {
            return "folder.fill"
        } else {
            // Determine icon based on file extension
            let ext = (name as NSString).pathExtension.lowercased()
            switch ext {
            case "txt", "md", "log":
                return "doc.text.fill"
            case "jpg", "jpeg", "png", "gif", "bmp":
                return "photo.fill"
            case "mp4", "mov", "avi", "mkv":
                return "video.fill"
            case "mp3", "wav", "m4a":
                return "music.note"
            case "zip", "tar", "gz", "bz2", "7z":
                return "doc.zipper"
            case "pdf":
                return "doc.fill"
            case "sh", "bash", "zsh":
                return "terminal.fill"
            case "py", "js", "swift", "java", "cpp", "c":
                return "chevron.left.forwardslash.chevron.right"
            default:
                return "doc.fill"
            }
        }
    }
}

// MARK: - Local Mount Model

struct LocalMount: Identifiable, Codable {
    let id = UUID()
    let serverName: String
    let serverId: UUID
    let remotePath: String
    let localPath: String
    let createdAt: Date
    var lastSyncedAt: Date?
    var syncEnabled: Bool
    
    init(serverName: String,
         serverId: UUID,
         remotePath: String,
         localPath: String,
         syncEnabled: Bool = false) {
        self.serverName = serverName
        self.serverId = serverId
        self.remotePath = remotePath
        self.localPath = localPath
        self.createdAt = Date()
        self.lastSyncedAt = nil
        self.syncEnabled = syncEnabled
    }
}

// MARK: - Transfer Model

struct FileTransfer: Identifiable {
    let id = UUID()
    let type: TransferType
    let localPath: String
    let remotePath: String
    let serverId: UUID
    let totalBytes: Int64
    var transferredBytes: Int64
    var status: TransferStatus
    let startedAt: Date
    var completedAt: Date?
    var error: String?
    
    enum TransferType: String, Codable {
        case upload
        case download
    }
    
    enum TransferStatus: String, Codable {
        case pending
        case inProgress
        case completed
        case failed
        case cancelled
    }
    
    var progress: Double {
        guard totalBytes > 0 else { return 0 }
        return Double(transferredBytes) / Double(totalBytes)
    }
    
    var formattedProgress: String {
        let formatter = ByteCountFormatter()
        formatter.countStyle = .file
        
        let transferred = formatter.string(fromByteCount: transferredBytes)
        let total = formatter.string(fromByteCount: totalBytes)
        
        return "\(transferred) / \(total)"
    }
}
