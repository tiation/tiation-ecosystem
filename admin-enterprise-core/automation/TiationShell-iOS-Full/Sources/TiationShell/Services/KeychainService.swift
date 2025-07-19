//
//  KeychainService.swift
//  TiationShell
//
//  Secure credential storage using iOS Keychain
//

import Foundation
import KeychainAccess
import Combine

// MARK: - Keychain Service Protocol

protocol KeychainServiceProtocol {
    func saveServerCredentials(_ server: Server) throws
    func loadServerCredentials(for serverId: UUID) throws -> ServerCredentials?
    func deleteServerCredentials(for serverId: UUID) throws
    func saveSSHKey(privateKey: Data, publicKey: Data?, name: String) throws -> String
    func loadSSHKey(name: String) throws -> SSHKeyPair?
    func deleteSSHKey(name: String) throws
    func listSSHKeys() throws -> [String]
}

// MARK: - Models

struct ServerCredentials: Codable {
    let serverId: UUID
    let password: String?
    let sshKeyName: String?
}

struct SSHKeyPair: Codable {
    let name: String
    let privateKey: Data
    let publicKey: Data?
    let createdAt: Date
}

// MARK: - Keychain Service Implementation

class KeychainService: KeychainServiceProtocol {
    static let shared = KeychainService()
    
    private let keychain: Keychain
    private let serverCredentialsPrefix = "com.tiation.server."
    private let sshKeyPrefix = "com.tiation.sshkey."
    
    private init() {
        keychain = Keychain(service: "com.tiation.TiationShell")
            .accessibility(.afterFirstUnlockThisDeviceOnly)
            .synchronizable(false)
    }
    
    // MARK: - Server Credentials
    
    func saveServerCredentials(_ server: Server) throws {
        var credentials: ServerCredentials
        
        switch server.authMethod {
        case .password(let password):
            credentials = ServerCredentials(
                serverId: server.id,
                password: password,
                sshKeyName: nil
            )
            
        case .publicKey(let keyPath):
            // Extract key name from path
            let keyName = URL(fileURLWithPath: keyPath).lastPathComponent
            credentials = ServerCredentials(
                serverId: server.id,
                password: nil,
                sshKeyName: keyName
            )
        }
        
        let data = try JSONEncoder().encode(credentials)
        try keychain.set(data, key: serverCredentialsKey(for: server.id))
    }
    
    func loadServerCredentials(for serverId: UUID) throws -> ServerCredentials? {
        guard let data = try keychain.getData(serverCredentialsKey(for: serverId)) else {
            return nil
        }
        return try JSONDecoder().decode(ServerCredentials.self, from: data)
    }
    
    func deleteServerCredentials(for serverId: UUID) throws {
        try keychain.remove(serverCredentialsKey(for: serverId))
    }
    
    // MARK: - SSH Keys
    
    func saveSSHKey(privateKey: Data, publicKey: Data?, name: String) throws -> String {
        let keyPair = SSHKeyPair(
            name: name,
            privateKey: privateKey,
            publicKey: publicKey,
            createdAt: Date()
        )
        
        let data = try JSONEncoder().encode(keyPair)
        let keyName = sanitizeKeyName(name)
        try keychain.set(data, key: sshKeyKey(for: keyName))
        
        // Save to Documents directory for SSH library access
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let sshKeysPath = documentsPath.appendingPathComponent("TiationShell/ssh_keys", isDirectory: true)
        
        try FileManager.default.createDirectory(at: sshKeysPath, withIntermediateDirectories: true)
        
        let privateKeyPath = sshKeysPath.appendingPathComponent(keyName)
        try privateKey.write(to: privateKeyPath)
        
        // Set proper permissions (600)
        try FileManager.default.setAttributes([.posixPermissions: 0o600], ofItemAtPath: privateKeyPath.path)
        
        if let publicKey = publicKey {
            let publicKeyPath = sshKeysPath.appendingPathComponent("\(keyName).pub")
            try publicKey.write(to: publicKeyPath)
        }
        
        return privateKeyPath.path
    }
    
    func loadSSHKey(name: String) throws -> SSHKeyPair? {
        let keyName = sanitizeKeyName(name)
        guard let data = try keychain.getData(sshKeyKey(for: keyName)) else {
            return nil
        }
        return try JSONDecoder().decode(SSHKeyPair.self, from: data)
    }
    
    func deleteSSHKey(name: String) throws {
        let keyName = sanitizeKeyName(name)
        try keychain.remove(sshKeyKey(for: keyName))
        
        // Also remove from file system
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let sshKeysPath = documentsPath.appendingPathComponent("TiationShell/ssh_keys", isDirectory: true)
        let privateKeyPath = sshKeysPath.appendingPathComponent(keyName)
        let publicKeyPath = sshKeysPath.appendingPathComponent("\(keyName).pub")
        
        try? FileManager.default.removeItem(at: privateKeyPath)
        try? FileManager.default.removeItem(at: publicKeyPath)
    }
    
    func listSSHKeys() throws -> [String] {
        let allKeys = try keychain.allKeys()
        return allKeys
            .filter { $0.hasPrefix(sshKeyPrefix) }
            .compactMap { key in
                let name = key.replacingOccurrences(of: sshKeyPrefix, with: "")
                return name.isEmpty ? nil : name
            }
    }
    
    // MARK: - Private Methods
    
    private func serverCredentialsKey(for serverId: UUID) -> String {
        return "\(serverCredentialsPrefix)\(serverId.uuidString)"
    }
    
    private func sshKeyKey(for name: String) -> String {
        return "\(sshKeyPrefix)\(name)"
    }
    
    private func sanitizeKeyName(_ name: String) -> String {
        return name
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: " ", with: "_")
            .replacingOccurrences(of: ".", with: "_")
    }
}

// MARK: - Server Extension for Keychain

extension Server {
    var authMethod: AuthMethod {
        get {
            // This should be stored in the server model
            return _authMethod ?? .password("")
        }
        set {
            _authMethod = newValue
        }
    }
    
    private var _authMethod: AuthMethod? {
        get { return nil } // Placeholder
        set { } // Placeholder
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
                throw DecodingError.dataCorruptedError(forKey: .type, in: container, debugDescription: "Unknown auth method type")
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
