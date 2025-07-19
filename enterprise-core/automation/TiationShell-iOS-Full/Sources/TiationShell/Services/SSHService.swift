//
//  SSHService.swift
//  TiationShell
//
//  Real SSH implementation using SwiftSH library
//

import Foundation
import SwiftSH
import Combine

// MARK: - SSH Service Protocol

protocol SSHServiceProtocol {
    func connect(to server: Server) -> AnyPublisher<SSHConnection, Error>
    func disconnect(from server: Server)
    func executeCommand(_ command: String, on connection: SSHConnection) -> AnyPublisher<String, Error>
    func listDirectory(_ path: String, on connection: SSHConnection) -> AnyPublisher<[FileItem], Error>
    func downloadFile(from remotePath: String, to localURL: URL, on connection: SSHConnection) -> AnyPublisher<Progress, Error>
    func uploadFile(from localURL: URL, to remotePath: String, on connection: SSHConnection) -> AnyPublisher<Progress, Error>
}

// MARK: - SSH Service Implementation

class SSHService: SSHServiceProtocol {
    static let shared = SSHService()
    
    private var sessions: [UUID: SSHSession] = [:]
    private let queue = DispatchQueue(label: "com.tiation.sshservice", attributes: .concurrent)
    
    private init() {}
    
    // MARK: - Connection Management
    
    func connect(to server: Server) -> AnyPublisher<SSHConnection, Error> {
        return Future<SSHConnection, Error> { [weak self] promise in
            self?.queue.async(flags: .barrier) {
                do {
                    // Create SSH session
                    let session = try self?.createSession(for: server)
                    
                    // Connect to server
                    session?.connect { error in
                        if let error = error {
                            promise(.failure(SSHError.connectionFailed(error.localizedDescription)))
                        } else {
                            // Authenticate
                            self?.authenticate(session: session!, server: server) { authError in
                                if let authError = authError {
                                    promise(.failure(authError))
                                } else {
                                    let connection = SSHConnection(
                                        id: server.id,
                                        server: server,
                                        session: session!,
                                        isConnected: true
                                    )
                                    self?.sessions[server.id] = session
                                    promise(.success(connection))
                                }
                            }
                        }
                    }
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func disconnect(from server: Server) {
        queue.async(flags: .barrier) { [weak self] in
            if let session = self?.sessions[server.id] {
                session.disconnect()
                self?.sessions.removeValue(forKey: server.id)
            }
        }
    }
    
    // MARK: - Command Execution
    
    func executeCommand(_ command: String, on connection: SSHConnection) -> AnyPublisher<String, Error> {
        return Future<String, Error> { promise in
            guard connection.isConnected else {
                promise(.failure(SSHError.notConnected))
                return
            }
            
            connection.session.execute(command) { result, error in
                if let error = error {
                    promise(.failure(SSHError.commandFailed(error.localizedDescription)))
                } else {
                    promise(.success(result ?? ""))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    // MARK: - File Operations
    
    func listDirectory(_ path: String, on connection: SSHConnection) -> AnyPublisher<[FileItem], Error> {
        let command = "ls -la \(path) | tail -n +2"
        
        return executeCommand(command, on: connection)
            .map { output in
                self.parseDirectoryListing(output, basePath: path)
            }
            .eraseToAnyPublisher()
    }
    
    func downloadFile(from remotePath: String, to localURL: URL, on connection: SSHConnection) -> AnyPublisher<Progress, Error> {
        return Future<Progress, Error> { promise in
            guard connection.isConnected else {
                promise(.failure(SSHError.notConnected))
                return
            }
            
            let progress = Progress(totalUnitCount: 100)
            
            connection.session.download(remotePath, to: localURL, progress: { (bytes, totalBytes) in
                progress.completedUnitCount = Int64(bytes)
                progress.totalUnitCount = Int64(totalBytes)
            }) { error in
                if let error = error {
                    promise(.failure(SSHError.downloadFailed(error.localizedDescription)))
                } else {
                    progress.completedUnitCount = progress.totalUnitCount
                    promise(.success(progress))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func uploadFile(from localURL: URL, to remotePath: String, on connection: SSHConnection) -> AnyPublisher<Progress, Error> {
        return Future<Progress, Error> { promise in
            guard connection.isConnected else {
                promise(.failure(SSHError.notConnected))
                return
            }
            
            let progress = Progress(totalUnitCount: 100)
            
            connection.session.upload(localURL, to: remotePath, progress: { (bytes, totalBytes) in
                progress.completedUnitCount = Int64(bytes)
                progress.totalUnitCount = Int64(totalBytes)
            }) { error in
                if let error = error {
                    promise(.failure(SSHError.uploadFailed(error.localizedDescription)))
                } else {
                    progress.completedUnitCount = progress.totalUnitCount
                    promise(.success(progress))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    // MARK: - Private Methods
    
    private func createSession(for server: Server) throws -> SSHSession {
        let session = SSHSession(host: server.host, port: Int32(server.port))
        session.timeout = 30
        return session
    }
    
    private func authenticate(session: SSHSession, server: Server, completion: @escaping (Error?) -> Void) {
        switch server.authMethod {
        case .password(let password):
            session.authenticate(username: server.username, password: password) { error in
                if let error = error {
                    completion(SSHError.authenticationFailed(error.localizedDescription))
                } else {
                    completion(nil)
                }
            }
            
        case .publicKey(let keyPath):
            let expandedPath = (keyPath as NSString).expandingTildeInPath
            session.authenticate(username: server.username, privateKey: expandedPath) { error in
                if let error = error {
                    completion(SSHError.authenticationFailed(error.localizedDescription))
                } else {
                    completion(nil)
                }
            }
        }
    }
    
    private func parseDirectoryListing(_ output: String, basePath: String) -> [FileItem] {
        let lines = output.components(separatedBy: .newlines)
        return lines.compactMap { line in
            let components = line.components(separatedBy: .whitespaces).filter { !$0.isEmpty }
            guard components.count >= 9 else { return nil }
            
            let permissions = components[0]
            let size = Int64(components[4]) ?? 0
            let name = components[8...].joined(separator: " ")
            
            // Skip . and ..
            guard name != "." && name != ".." else { return nil }
            
            let isDirectory = permissions.starts(with: "d")
            let path = basePath.hasSuffix("/") ? "\(basePath)\(name)" : "\(basePath)/\(name)"
            
            // Parse date
            let dateComponents = components[5...7].joined(separator: " ")
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d HH:mm"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            let modificationDate = dateFormatter.date(from: dateComponents)
            
            return FileItem(
                name: name,
                path: path,
                isDirectory: isDirectory,
                size: isDirectory ? nil : size,
                modificationDate: modificationDate,
                permissions: permissions
            )
        }
    }
}

// MARK: - SSH Connection Model

struct SSHConnection {
    let id: UUID
    let server: Server
    let session: SSHSession
    var isConnected: Bool
}

// MARK: - SSH Errors

enum SSHError: LocalizedError {
    case notConnected
    case connectionFailed(String)
    case authenticationFailed(String)
    case commandFailed(String)
    case downloadFailed(String)
    case uploadFailed(String)
    
    var errorDescription: String? {
        switch self {
        case .notConnected:
            return "Not connected to server"
        case .connectionFailed(let message):
            return "Connection failed: \(message)"
        case .authenticationFailed(let message):
            return "Authentication failed: \(message)"
        case .commandFailed(let message):
            return "Command failed: \(message)"
        case .downloadFailed(let message):
            return "Download failed: \(message)"
        case .uploadFailed(let message):
            return "Upload failed: \(message)"
        }
    }
}
