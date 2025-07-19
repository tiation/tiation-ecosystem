//
//  CredentialStorageService.swift
//  TiationShell
//
//  Secure credential storage using iOS Keychain
//

import Foundation
import Security
import CryptoKit

// MARK: - Credential Storage Service Protocol

protocol CredentialStorageServiceProtocol {
    func saveServerPassword(_ password: String, for server: Server) throws
    func loadServerPassword(for server: Server) -> String?
    func deleteServerPassword(for server: Server) throws
    
    func saveSSHKey(_ keyData: Data, name: String, passphrase: String?) throws -> String
    func loadSSHKey(name: String) -> (keyData: Data, passphrase: String?)?
    func deleteSSHKey(name: String) throws
    func listSSHKeys() -> [SSHKeyInfo]
    
    func saveServerCredentials(_ credentials: ServerCredentials) throws
    func loadServerCredentials(for serverId: UUID) -> ServerCredentials?
    func deleteServerCredentials(for serverId: UUID) throws
}

// MARK: - Credential Storage Service

class CredentialStorageService: CredentialStorageServiceProtocol {
    static let shared = CredentialStorageService()
    
    private let serviceName = "com.tiation.TiationShell"
    private let sshKeyPrefix = "ssh_key_"
    private let serverPasswordPrefix = "server_password_"
    private let serverCredentialsPrefix = "server_credentials_"
    private let accessGroup = "group.com.tiation.tiationshell"
    
    private init() {}
    
    // MARK: - Server Passwords
    
    func saveServerPassword(_ password: String, for server: Server) throws {
        let key = "\(serverPasswordPrefix)\(server.id.uuidString)"
        try saveToKeychain(key: key, data: password.data(using: .utf8)!, account: server.username)
    }
    
    func loadServerPassword(for server: Server) -> String? {
        let key = "\(serverPasswordPrefix)\(server.id.uuidString)"
        guard let data = loadFromKeychain(key: key, account: server.username) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    func deleteServerPassword(for server: Server) throws {
        let key = "\(serverPasswordPrefix)\(server.id.uuidString)"
        try deleteFromKeychain(key: key, account: server.username)
    }
    
    // MARK: - SSH Keys
    
    func saveSSHKey(_ keyData: Data, name: String, passphrase: String?) throws -> String {
        // Encrypt key if passphrase provided
        let encryptedData: Data
        let metadata: SSHKeyMetadata
        
        if let passphrase = passphrase {
            let encrypted = try encryptData(keyData, passphrase: passphrase)
            encryptedData = encrypted.ciphertext
            metadata = SSHKeyMetadata(
                name: name,
                createdAt: Date(),
                isEncrypted: true,
                salt: encrypted.salt
            )
        } else {
            encryptedData = keyData
            metadata = SSHKeyMetadata(
                name: name,
                createdAt: Date(),
                isEncrypted: false,
                salt: nil
            )
        }
        
        // Save encrypted key
        let keyName = "\(sshKeyPrefix)\(name)"
        try saveToKeychain(key: keyName, data: encryptedData, account: "ssh_key")
        
        // Save metadata
        let metadataKey = "\(keyName)_metadata"
        let metadataData = try JSONEncoder().encode(metadata)
        try saveToKeychain(key: metadataKey, data: metadataData, account: "ssh_key_metadata")
        
        // Save to file system for SSH library access
        let keyPath = try saveSSHKeyToFileSystem(keyData: keyData, name: name)
        
        return keyPath
    }
    
    func loadSSHKey(name: String) -> (keyData: Data, passphrase: String?)? {
        let keyName = "\(sshKeyPrefix)\(name)"
        
        // Load encrypted key
        guard let encryptedData = loadFromKeychain(key: keyName, account: "ssh_key") else { return nil }
        
        // Load metadata
        let metadataKey = "\(keyName)_metadata"
        guard let metadataData = loadFromKeychain(key: metadataKey, account: "ssh_key_metadata"),
              let metadata = try? JSONDecoder().decode(SSHKeyMetadata.self, from: metadataData) else {
            return (encryptedData, nil)
        }
        
        // Return encrypted data - caller needs to decrypt with passphrase
        return (encryptedData, metadata.isEncrypted ? "encrypted" : nil)
    }
    
    func deleteSSHKey(name: String) throws {
        let keyName = "\(sshKeyPrefix)\(name)"
        
        // Delete key
        try deleteFromKeychain(key: keyName, account: "ssh_key")
        
        // Delete metadata
        let metadataKey = "\(keyName)_metadata"
        try? deleteFromKeychain(key: metadataKey, account: "ssh_key_metadata")
        
        // Delete from file system
        try deleteSSHKeyFromFileSystem(name: name)
    }
    
    func listSSHKeys() -> [SSHKeyInfo] {
        var keys: [SSHKeyInfo] = []
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: "ssh_key_metadata",
            kSecMatchLimit as String: kSecMatchLimitAll,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecSuccess, let items = result as? [[String: Any]] {
            for item in items {
                if let key = item[kSecAttrGeneric as String] as? String,
                   key.hasPrefix(sshKeyPrefix) && key.hasSuffix("_metadata"),
                   let data = item[kSecValueData as String] as? Data,
                   let metadata = try? JSONDecoder().decode(SSHKeyMetadata.self, from: data) {
                    
                    let keyName = key
                        .replacingOccurrences(of: sshKeyPrefix, with: "")
                        .replacingOccurrences(of: "_metadata", with: "")
                    
                    keys.append(SSHKeyInfo(
                        name: keyName,
                        createdAt: metadata.createdAt,
                        isEncrypted: metadata.isEncrypted
                    ))
                }
            }
        }
        
        return keys.sorted { $0.createdAt > $1.createdAt }
    }
    
    // MARK: - Server Credentials
    
    func saveServerCredentials(_ credentials: ServerCredentials) throws {
        let key = "\(serverCredentialsPrefix)\(credentials.serverId.uuidString)"
        let data = try JSONEncoder().encode(credentials)
        try saveToKeychain(key: key, data: data, account: credentials.username)
    }
    
    func loadServerCredentials(for serverId: UUID) -> ServerCredentials? {
        let key = "\(serverCredentialsPrefix)\(serverId.uuidString)"
        
        // Try to find with any account
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrGeneric as String: key,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: true
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecSuccess, let data = result as? Data {
            return try? JSONDecoder().decode(ServerCredentials.self, from: data)
        }
        
        return nil
    }
    
    func deleteServerCredentials(for serverId: UUID) throws {
        let key = "\(serverCredentialsPrefix)\(serverId.uuidString)"
        
        // Delete all entries with this key
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrGeneric as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess && status != errSecItemNotFound {
            throw CredentialError.keychainError(status)
        }
    }
    
    // MARK: - Private Keychain Methods
    
    private func saveToKeychain(key: String, data: Data, account: String) throws {
        // Delete existing item first
        try? deleteFromKeychain(key: key, account: account)
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: account,
            kSecAttrGeneric as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly,
            kSecAttrSynchronizable as String: false
        ]
        
        if let accessGroup = accessGroup {
            var mutableQuery = query
            mutableQuery[kSecAttrAccessGroup as String] = accessGroup
            
            let status = SecItemAdd(mutableQuery as CFDictionary, nil)
            if status != errSecSuccess {
                throw CredentialError.keychainError(status)
            }
        } else {
            let status = SecItemAdd(query as CFDictionary, nil)
            if status != errSecSuccess {
                throw CredentialError.keychainError(status)
            }
        }
    }
    
    private func loadFromKeychain(key: String, account: String) -> Data? {
        var query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: account,
            kSecAttrGeneric as String: key,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: true
        ]
        
        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup
        }
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecSuccess {
            return result as? Data
        }
        
        return nil
    }
    
    private func deleteFromKeychain(key: String, account: String) throws {
        var query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: account,
            kSecAttrGeneric as String: key
        ]
        
        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup
        }
        
        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess && status != errSecItemNotFound {
            throw CredentialError.keychainError(status)
        }
    }
    
    // MARK: - Encryption
    
    private func encryptData(_ data: Data, passphrase: String) throws -> (ciphertext: Data, salt: Data) {
        // Generate salt
        let salt = generateSalt()
        
        // Derive key from passphrase
        let key = try deriveKey(from: passphrase, salt: salt)
        
        // Encrypt data
        let sealedBox = try AES.GCM.seal(data, using: key)
        
        guard let ciphertext = sealedBox.combined else {
            throw CredentialError.encryptionFailed
        }
        
        return (ciphertext, salt)
    }
    
    private func decryptData(_ ciphertext: Data, passphrase: String, salt: Data) throws -> Data {
        // Derive key from passphrase
        let key = try deriveKey(from: passphrase, salt: salt)
        
        // Decrypt data
        let sealedBox = try AES.GCM.SealedBox(combined: ciphertext)
        return try AES.GCM.open(sealedBox, using: key)
    }
    
    private func generateSalt() -> Data {
        var salt = Data(count: 32)
        _ = salt.withUnsafeMutableBytes { bytes in
            SecRandomCopyBytes(kSecRandomDefault, 32, bytes.baseAddress!)
        }
        return salt
    }
    
    private func deriveKey(from passphrase: String, salt: Data) throws -> SymmetricKey {
        guard let passphraseData = passphrase.data(using: .utf8) else {
            throw CredentialError.invalidPassphrase
        }
        
        let keyData = SHA256.hash(data: passphraseData + salt)
        return SymmetricKey(data: keyData)
    }
    
    // MARK: - File System Methods
    
    private func saveSSHKeyToFileSystem(keyData: Data, name: String) throws -> String {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let sshKeysPath = documentsPath.appendingPathComponent("TiationShell/ssh_keys", isDirectory: true)
        
        // Create directory if needed
        try FileManager.default.createDirectory(at: sshKeysPath, withIntermediateDirectories: true)
        
        // Save key
        let keyPath = sshKeysPath.appendingPathComponent(name)
        try keyData.write(to: keyPath)
        
        // Set permissions (600)
        try FileManager.default.setAttributes([.posixPermissions: 0o600], ofItemAtPath: keyPath.path)
        
        return keyPath.path
    }
    
    private func deleteSSHKeyFromFileSystem(name: String) throws {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let sshKeysPath = documentsPath.appendingPathComponent("TiationShell/ssh_keys", isDirectory: true)
        let keyPath = sshKeysPath.appendingPathComponent(name)
        
        try? FileManager.default.removeItem(at: keyPath)
    }
}

// MARK: - Supporting Types

struct SSHKeyMetadata: Codable {
    let name: String
    let createdAt: Date
    let isEncrypted: Bool
    let salt: Data?
}

struct SSHKeyInfo {
    let name: String
    let createdAt: Date
    let isEncrypted: Bool
}

enum CredentialError: LocalizedError {
    case keychainError(OSStatus)
    case encryptionFailed
    case decryptionFailed
    case invalidPassphrase
    case keyNotFound
    
    var errorDescription: String? {
        switch self {
        case .keychainError(let status):
            return "Keychain error: \(status)"
        case .encryptionFailed:
            return "Failed to encrypt data"
        case .decryptionFailed:
            return "Failed to decrypt data"
        case .invalidPassphrase:
            return "Invalid passphrase"
        case .keyNotFound:
            return "Key not found"
        }
    }
}
