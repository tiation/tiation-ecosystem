//
//  FileTransferService.swift
//  TiationShell
//
//  File transfer management with SFTP-like functionality
//

import Foundation
import Combine
import UniformTypeIdentifiers

// MARK: - File Transfer Service Protocol

protocol FileTransferServiceProtocol {
    func upload(fileURL: URL, to remotePath: String, on connection: SSHConnection) -> AnyPublisher<TransferProgress, Error>
    func download(from remotePath: String, to localURL: URL, on connection: SSHConnection) -> AnyPublisher<TransferProgress, Error>
    func cancelTransfer(_ transferId: UUID)
    func getActiveTransfers() -> [FileTransfer]
    func syncDirectory(localPath: URL, remotePath: String, on connection: SSHConnection) -> AnyPublisher<SyncResult, Error>
}

// MARK: - File Transfer Service

class FileTransferService: FileTransferServiceProtocol {
    static let shared = FileTransferService()
    
    private var activeTransfers: [UUID: TransferOperation] = [:]
    private let transferQueue = DispatchQueue(label: "com.tiation.transfer", attributes: .concurrent)
    private let chunkSize = 1024 * 1024 // 1MB chunks
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        setupTransferMonitoring()
    }
    
    // MARK: - Upload
    
    func upload(fileURL: URL, to remotePath: String, on connection: SSHConnection) -> AnyPublisher<TransferProgress, Error> {
        return Future<TransferProgress, Error> { [weak self] promise in
            guard let self = self else { return }
            
            // Validate file exists
            guard FileManager.default.fileExists(atPath: fileURL.path) else {
                promise(.failure(TransferError.fileNotFound(fileURL.path)))
                return
            }
            
            // Get file size
            guard let fileSize = try? FileManager.default.attributesOfItem(atPath: fileURL.path)[.size] as? Int64 else {
                promise(.failure(TransferError.invalidFile("Cannot determine file size")))
                return
            }
            
            // Create transfer operation
            let transfer = FileTransfer(
                id: UUID(),
                type: .upload,
                localPath: fileURL.path,
                remotePath: remotePath,
                serverId: connection.server.id,
                totalBytes: fileSize,
                transferredBytes: 0,
                status: .pending,
                startedAt: Date()
            )
            
            let operation = TransferOperation(
                transfer: transfer,
                connection: connection,
                progressSubject: PassthroughSubject<TransferProgress, Error>()
            )
            
            self.transferQueue.async(flags: .barrier) {
                self.activeTransfers[transfer.id] = operation
            }
            
            // Start upload
            self.performUpload(operation: operation)
            
            // Return progress publisher
            promise(.success(TransferProgress(transfer: transfer, progress: 0)))
            
            // Subscribe to progress updates
            operation.progressSubject
                .sink(
                    receiveCompletion: { _ in },
                    receiveValue: { progress in
                        promise(.success(progress))
                    }
                )
                .store(in: &self.cancellables)
        }.eraseToAnyPublisher()
    }
    
    // MARK: - Download
    
    func download(from remotePath: String, to localURL: URL, on connection: SSHConnection) -> AnyPublisher<TransferProgress, Error> {
        return Future<TransferProgress, Error> { [weak self] promise in
            guard let self = self else { return }
            
            // Create parent directory if needed
            let parentDirectory = localURL.deletingLastPathComponent()
            do {
                try FileManager.default.createDirectory(at: parentDirectory, withIntermediateDirectories: true)
            } catch {
                promise(.failure(TransferError.cannotCreateDirectory(error.localizedDescription)))
                return
            }
            
            // Get remote file size (mock for now)
            let fileSize: Int64 = 1024 * 1024 * 10 // 10MB mock size
            
            // Create transfer operation
            let transfer = FileTransfer(
                id: UUID(),
                type: .download,
                localPath: localURL.path,
                remotePath: remotePath,
                serverId: connection.server.id,
                totalBytes: fileSize,
                transferredBytes: 0,
                status: .pending,
                startedAt: Date()
            )
            
            let operation = TransferOperation(
                transfer: transfer,
                connection: connection,
                progressSubject: PassthroughSubject<TransferProgress, Error>()
            )
            
            self.transferQueue.async(flags: .barrier) {
                self.activeTransfers[transfer.id] = operation
            }
            
            // Start download
            self.performDownload(operation: operation)
            
            // Return initial progress
            promise(.success(TransferProgress(transfer: transfer, progress: 0)))
            
            // Subscribe to progress updates
            operation.progressSubject
                .sink(
                    receiveCompletion: { _ in },
                    receiveValue: { progress in
                        promise(.success(progress))
                    }
                )
                .store(in: &self.cancellables)
        }.eraseToAnyPublisher()
    }
    
    // MARK: - Directory Sync
    
    func syncDirectory(localPath: URL, remotePath: String, on connection: SSHConnection) -> AnyPublisher<SyncResult, Error> {
        return Future<SyncResult, Error> { [weak self] promise in
            guard let self = self else { return }
            
            self.transferQueue.async {
                // Get local files
                guard let localFiles = try? FileManager.default.contentsOfDirectory(
                    at: localPath,
                    includingPropertiesForKeys: [.isDirectoryKey, .fileSizeKey]
                ) else {
                    promise(.failure(TransferError.cannotReadDirectory(localPath.path)))
                    return
                }
                
                // Mock remote files for now
                let remoteFiles = self.mockRemoteFiles(at: remotePath)
                
                // Calculate differences
                let syncResult = self.calculateSyncOperations(
                    localFiles: localFiles,
                    remoteFiles: remoteFiles,
                    localPath: localPath,
                    remotePath: remotePath
                )
                
                promise(.success(syncResult))
            }
        }.eraseToAnyPublisher()
    }
    
    // MARK: - Transfer Management
    
    func cancelTransfer(_ transferId: UUID) {
        transferQueue.async(flags: .barrier) { [weak self] in
            if let operation = self?.activeTransfers[transferId] {
                operation.isCancelled = true
                operation.transfer.status = .cancelled
                operation.progressSubject.send(completion: .failure(TransferError.cancelled))
                self?.activeTransfers.removeValue(forKey: transferId)
            }
        }
    }
    
    func getActiveTransfers() -> [FileTransfer] {
        return transferQueue.sync {
            activeTransfers.values.map { $0.transfer }
        }
    }
    
    // MARK: - Private Methods
    
    private func performUpload(operation: TransferOperation) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            // Update status
            self.updateTransferStatus(operation.transfer.id, status: .inProgress)
            
            // Open file for reading
            guard let fileHandle = FileHandle(forReadingAtPath: operation.transfer.localPath) else {
                self.handleTransferError(operation: operation, error: TransferError.cannotOpenFile)
                return
            }
            
            defer { fileHandle.closeFile() }
            
            // Simulate upload with chunks
            var totalBytesTransferred: Int64 = 0
            
            while !operation.isCancelled {
                // Read chunk
                let chunkData = fileHandle.readData(ofLength: self.chunkSize)
                
                if chunkData.isEmpty {
                    // End of file
                    break
                }
                
                // Simulate network transfer
                Thread.sleep(forTimeInterval: 0.1) // Simulate network delay
                
                // Update progress
                totalBytesTransferred += Int64(chunkData.count)
                let progress = Double(totalBytesTransferred) / Double(operation.transfer.totalBytes)
                
                self.updateTransferProgress(
                    operation: operation,
                    bytesTransferred: totalBytesTransferred,
                    progress: progress
                )
                
                // Check if transfer is complete
                if totalBytesTransferred >= operation.transfer.totalBytes {
                    self.completeTransfer(operation: operation)
                    break
                }
            }
            
            if operation.isCancelled {
                self.handleTransferCancellation(operation: operation)
            }
        }
    }
    
    private func performDownload(operation: TransferOperation) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            // Update status
            self.updateTransferStatus(operation.transfer.id, status: .inProgress)
            
            // Create file for writing
            FileManager.default.createFile(atPath: operation.transfer.localPath, contents: nil)
            
            guard let fileHandle = FileHandle(forWritingAtPath: operation.transfer.localPath) else {
                self.handleTransferError(operation: operation, error: TransferError.cannotCreateFile)
                return
            }
            
            defer { fileHandle.closeFile() }
            
            // Simulate download with chunks
            var totalBytesTransferred: Int64 = 0
            
            while !operation.isCancelled && totalBytesTransferred < operation.transfer.totalBytes {
                // Generate mock chunk data
                let remainingBytes = operation.transfer.totalBytes - totalBytesTransferred
                let chunkSize = min(Int64(self.chunkSize), remainingBytes)
                let chunkData = Data(repeating: 0, count: Int(chunkSize))
                
                // Write chunk to file
                fileHandle.write(chunkData)
                
                // Simulate network transfer
                Thread.sleep(forTimeInterval: 0.1) // Simulate network delay
                
                // Update progress
                totalBytesTransferred += chunkSize
                let progress = Double(totalBytesTransferred) / Double(operation.transfer.totalBytes)
                
                self.updateTransferProgress(
                    operation: operation,
                    bytesTransferred: totalBytesTransferred,
                    progress: progress
                )
            }
            
            if operation.isCancelled {
                self.handleTransferCancellation(operation: operation)
                // Clean up partial file
                try? FileManager.default.removeItem(atPath: operation.transfer.localPath)
            } else {
                self.completeTransfer(operation: operation)
            }
        }
    }
    
    private func updateTransferStatus(_ transferId: UUID, status: FileTransfer.TransferStatus) {
        transferQueue.async(flags: .barrier) { [weak self] in
            if var operation = self?.activeTransfers[transferId] {
                operation.transfer.status = status
                self?.activeTransfers[transferId] = operation
            }
        }
    }
    
    private func updateTransferProgress(operation: TransferOperation, bytesTransferred: Int64, progress: Double) {
        transferQueue.async(flags: .barrier) { [weak self] in
            if var op = self?.activeTransfers[operation.transfer.id] {
                op.transfer.transferredBytes = bytesTransferred
                self?.activeTransfers[operation.transfer.id] = op
                
                let transferProgress = TransferProgress(
                    transfer: op.transfer,
                    progress: progress
                )
                
                DispatchQueue.main.async {
                    operation.progressSubject.send(transferProgress)
                }
            }
        }
    }
    
    private func completeTransfer(operation: TransferOperation) {
        transferQueue.async(flags: .barrier) { [weak self] in
            if var op = self?.activeTransfers[operation.transfer.id] {
                op.transfer.status = .completed
                op.transfer.completedAt = Date()
                self?.activeTransfers.removeValue(forKey: operation.transfer.id)
                
                let finalProgress = TransferProgress(
                    transfer: op.transfer,
                    progress: 1.0
                )
                
                DispatchQueue.main.async {
                    operation.progressSubject.send(finalProgress)
                    operation.progressSubject.send(completion: .finished)
                }
            }
        }
    }
    
    private func handleTransferError(operation: TransferOperation, error: Error) {
        transferQueue.async(flags: .barrier) { [weak self] in
            if var op = self?.activeTransfers[operation.transfer.id] {
                op.transfer.status = .failed
                op.transfer.error = error.localizedDescription
                op.transfer.completedAt = Date()
                self?.activeTransfers.removeValue(forKey: operation.transfer.id)
                
                DispatchQueue.main.async {
                    operation.progressSubject.send(completion: .failure(error))
                }
            }
        }
    }
    
    private func handleTransferCancellation(operation: TransferOperation) {
        transferQueue.async(flags: .barrier) { [weak self] in
            self?.activeTransfers.removeValue(forKey: operation.transfer.id)
            
            DispatchQueue.main.async {
                operation.progressSubject.send(completion: .failure(TransferError.cancelled))
            }
        }
    }
    
    private func setupTransferMonitoring() {
        // Monitor transfers and clean up completed ones
        Timer.publish(every: 30, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.cleanupCompletedTransfers()
            }
            .store(in: &cancellables)
    }
    
    private func cleanupCompletedTransfers() {
        transferQueue.async(flags: .barrier) { [weak self] in
            self?.activeTransfers = self?.activeTransfers.filter { _, operation in
                operation.transfer.status == .pending || operation.transfer.status == .inProgress
            } ?? [:]
        }
    }
    
    private func mockRemoteFiles(at path: String) -> [RemoteFile] {
        return [
            RemoteFile(name: "test.txt", path: "\(path)/test.txt", size: 1024, isDirectory: false),
            RemoteFile(name: "documents", path: "\(path)/documents", size: nil, isDirectory: true),
            RemoteFile(name: "backup.zip", path: "\(path)/backup.zip", size: 1024 * 1024, isDirectory: false)
        ]
    }
    
    private func calculateSyncOperations(localFiles: [URL], remoteFiles: [RemoteFile], localPath: URL, remotePath: String) -> SyncResult {
        var toUpload: [URL] = []
        var toDownload: [RemoteFile] = []
        var conflicts: [SyncConflict] = []
        
        // Simple sync logic - in production this would be more sophisticated
        let localFileNames = Set(localFiles.map { $0.lastPathComponent })
        let remoteFileNames = Set(remoteFiles.map { $0.name })
        
        // Files to upload (exist locally but not remotely)
        toUpload = localFiles.filter { !remoteFileNames.contains($0.lastPathComponent) }
        
        // Files to download (exist remotely but not locally)
        toDownload = remoteFiles.filter { !localFileNames.contains($0.name) }
        
        // Detect conflicts (files that exist in both places)
        for localFile in localFiles {
            if remoteFileNames.contains(localFile.lastPathComponent) {
                // In production, compare timestamps and sizes
                conflicts.append(SyncConflict(
                    fileName: localFile.lastPathComponent,
                    localPath: localFile.path,
                    remotePath: "\(remotePath)/\(localFile.lastPathComponent)",
                    resolution: .keepLocal
                ))
            }
        }
        
        return SyncResult(
            toUpload: toUpload,
            toDownload: toDownload,
            conflicts: conflicts,
            totalFiles: localFiles.count + remoteFiles.count
        )
    }
}

// MARK: - Supporting Types

struct TransferOperation {
    var transfer: FileTransfer
    let connection: SSHConnection
    let progressSubject: PassthroughSubject<TransferProgress, Error>
    var isCancelled: Bool = false
}

struct TransferProgress {
    let transfer: FileTransfer
    let progress: Double
    
    var percentage: Int {
        return Int(progress * 100)
    }
    
    var formattedProgress: String {
        let formatter = ByteCountFormatter()
        formatter.countStyle = .file
        
        let transferred = formatter.string(fromByteCount: transfer.transferredBytes)
        let total = formatter.string(fromByteCount: transfer.totalBytes)
        
        return "\(transferred) / \(total) (\(percentage)%)"
    }
    
    var estimatedTimeRemaining: TimeInterval? {
        guard progress > 0 && progress < 1 else { return nil }
        
        let elapsedTime = Date().timeIntervalSince(transfer.startedAt)
        let estimatedTotalTime = elapsedTime / progress
        return estimatedTotalTime - elapsedTime
    }
}

struct RemoteFile {
    let name: String
    let path: String
    let size: Int64?
    let isDirectory: Bool
}

struct SyncResult {
    let toUpload: [URL]
    let toDownload: [RemoteFile]
    let conflicts: [SyncConflict]
    let totalFiles: Int
}

struct SyncConflict {
    let fileName: String
    let localPath: String
    let remotePath: String
    let resolution: ConflictResolution
    
    enum ConflictResolution {
        case keepLocal
        case keepRemote
        case keepBoth
        case skip
    }
}

enum TransferError: LocalizedError {
    case fileNotFound(String)
    case invalidFile(String)
    case cannotOpenFile
    case cannotCreateFile
    case cannotCreateDirectory(String)
    case cannotReadDirectory(String)
    case networkError(String)
    case cancelled
    
    var errorDescription: String? {
        switch self {
        case .fileNotFound(let path):
            return "File not found: \(path)"
        case .invalidFile(let message):
            return "Invalid file: \(message)"
        case .cannotOpenFile:
            return "Cannot open file for reading"
        case .cannotCreateFile:
            return "Cannot create file for writing"
        case .cannotCreateDirectory(let message):
            return "Cannot create directory: \(message)"
        case .cannotReadDirectory(let path):
            return "Cannot read directory: \(path)"
        case .networkError(let message):
            return "Network error: \(message)"
        case .cancelled:
            return "Transfer cancelled"
        }
    }
}
