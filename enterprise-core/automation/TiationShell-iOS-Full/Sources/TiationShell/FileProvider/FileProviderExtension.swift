//
//  FileProviderExtension.swift
//  TiationShell
//
//  File Provider Extension for iOS Files app integration
//

import FileProvider
import Combine

class FileProviderExtension: NSFileProviderExtension {
    
    private let sshService = SSHService.shared
    private var cancellables = Set<AnyCancellable>()
    private var activeConnections: [NSFileProviderItemIdentifier: SSHConnection] = [:]
    
    override init() {
        super.init()
    }
    
    // MARK: - Item Management
    
    override func item(for identifier: NSFileProviderItemIdentifier) throws -> NSFileProviderItem {
        // Parse the identifier to get server and path info
        guard let itemInfo = parseItemIdentifier(identifier) else {
            throw NSError(domain: NSCocoaErrorDomain, code: NSFileNoSuchFileError)
        }
        
        return FileProviderItem(
            identifier: identifier,
            parentIdentifier: itemInfo.parentIdentifier,
            filename: itemInfo.filename,
            typeIdentifier: itemInfo.isDirectory ? kUTTypeFolder as String : kUTTypeData as String,
            documentSize: itemInfo.size
        )
    }
    
    override func urlForItem(withPersistentIdentifier identifier: NSFileProviderItemIdentifier) -> URL? {
        guard let itemInfo = parseItemIdentifier(identifier) else {
            return nil
        }
        
        // Return a URL that represents the remote path
        return URL(string: "tiationshell://\(itemInfo.serverId)/\(itemInfo.path)")
    }
    
    override func persistentIdentifierForItem(at url: URL) -> NSFileProviderItemIdentifier? {
        // Convert URL back to identifier
        guard url.scheme == "tiationshell",
              let host = url.host,
              let serverId = UUID(uuidString: host) else {
            return nil
        }
        
        let path = url.path
        return createItemIdentifier(serverId: serverId, path: path)
    }
    
    // MARK: - Enumeration
    
    override func enumerator(for containerItemIdentifier: NSFileProviderItemIdentifier) throws -> NSFileProviderEnumerator {
        return FileProviderEnumerator(
            containerIdentifier: containerItemIdentifier,
            sshService: sshService,
            fileProviderExtension: self
        )
    }
    
    // MARK: - File Operations
    
    override func startProvidingItem(at url: URL, completionHandler: @escaping (Error?) -> Void) {
        guard let identifier = persistentIdentifierForItem(at: url),
              let itemInfo = parseItemIdentifier(identifier) else {
            completionHandler(NSError(domain: NSCocoaErrorDomain, code: NSFileNoSuchFileError))
            return
        }
        
        // Get or create connection
        getConnection(for: itemInfo.serverId) { [weak self] result in
            switch result {
            case .success(let connection):
                // Download file
                self?.sshService.downloadFile(
                    from: itemInfo.path,
                    to: url,
                    on: connection
                )
                .sink(
                    receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            completionHandler(error)
                        }
                    },
                    receiveValue: { _ in
                        completionHandler(nil)
                    }
                )
                .store(in: &self!.cancellables)
                
            case .failure(let error):
                completionHandler(error)
            }
        }
    }
    
    override func stopProvidingItem(at url: URL) {
        // Clean up any resources
        // The file at 'url' can be deleted
        try? FileManager.default.removeItem(at: url)
    }
    
    override func importDocument(at fileURL: URL, toParentItemIdentifier parentItemIdentifier: NSFileProviderItemIdentifier, completionHandler: @escaping (NSFileProviderItem?, Error?) -> Void) {
        guard let parentInfo = parseItemIdentifier(parentItemIdentifier) else {
            completionHandler(nil, NSError(domain: NSCocoaErrorDomain, code: NSFileWriteNoPermissionError))
            return
        }
        
        let filename = fileURL.lastPathComponent
        let remotePath = "\(parentInfo.path)/\(filename)"
        
        getConnection(for: parentInfo.serverId) { [weak self] result in
            switch result {
            case .success(let connection):
                self?.sshService.uploadFile(
                    from: fileURL,
                    to: remotePath,
                    on: connection
                )
                .sink(
                    receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            completionHandler(nil, error)
                        }
                    },
                    receiveValue: { _ in
                        let newIdentifier = self!.createItemIdentifier(
                            serverId: parentInfo.serverId,
                            path: remotePath
                        )
                        
                        let newItem = FileProviderItem(
                            identifier: newIdentifier,
                            parentIdentifier: parentItemIdentifier,
                            filename: filename,
                            typeIdentifier: kUTTypeData as String,
                            documentSize: nil
                        )
                        
                        completionHandler(newItem, nil)
                    }
                )
                .store(in: &self!.cancellables)
                
            case .failure(let error):
                completionHandler(nil, error)
            }
        }
    }
    
    override func createDirectory(withName directoryName: String, inParentItemIdentifier parentItemIdentifier: NSFileProviderItemIdentifier, completionHandler: @escaping (NSFileProviderItem?, Error?) -> Void) {
        guard let parentInfo = parseItemIdentifier(parentItemIdentifier) else {
            completionHandler(nil, NSError(domain: NSCocoaErrorDomain, code: NSFileWriteNoPermissionError))
            return
        }
        
        let remotePath = "\(parentInfo.path)/\(directoryName)"
        
        getConnection(for: parentInfo.serverId) { [weak self] result in
            switch result {
            case .success(let connection):
                self?.sshService.executeCommand("mkdir -p '\(remotePath)'", on: connection)
                    .sink(
                        receiveCompletion: { completion in
                            if case .failure(let error) = completion {
                                completionHandler(nil, error)
                            }
                        },
                        receiveValue: { _ in
                            let newIdentifier = self!.createItemIdentifier(
                                serverId: parentInfo.serverId,
                                path: remotePath
                            )
                            
                            let newItem = FileProviderItem(
                                identifier: newIdentifier,
                                parentIdentifier: parentItemIdentifier,
                                filename: directoryName,
                                typeIdentifier: kUTTypeFolder as String,
                                documentSize: nil
                            )
                            
                            completionHandler(newItem, nil)
                        }
                    )
                    .store(in: &self!.cancellables)
                
            case .failure(let error):
                completionHandler(nil, error)
            }
        }
    }
    
    override func deleteItem(withIdentifier itemIdentifier: NSFileProviderItemIdentifier, completionHandler: @escaping (Error?) -> Void) {
        guard let itemInfo = parseItemIdentifier(itemIdentifier) else {
            completionHandler(NSError(domain: NSCocoaErrorDomain, code: NSFileNoSuchFileError))
            return
        }
        
        getConnection(for: itemInfo.serverId) { [weak self] result in
            switch result {
            case .success(let connection):
                self?.sshService.executeCommand("rm -rf '\(itemInfo.path)'", on: connection)
                    .sink(
                        receiveCompletion: { completion in
                            if case .failure(let error) = completion {
                                completionHandler(error)
                            }
                        },
                        receiveValue: { _ in
                            completionHandler(nil)
                        }
                    )
                    .store(in: &self!.cancellables)
                
            case .failure(let error):
                completionHandler(error)
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func getConnection(for serverId: UUID, completion: @escaping (Result<SSHConnection, Error>) -> Void) {
        // Check if we have an active connection
        if let connection = activeConnections.values.first(where: { $0.server.id == serverId }) {
            completion(.success(connection))
            return
        }
        
        // Load server and connect
        guard let server = loadServer(with: serverId) else {
            completion(.failure(NSError(domain: "TiationShell", code: 404, userInfo: [NSLocalizedDescriptionKey: "Server not found"])))
            return
        }
        
        sshService.connect(to: server)
            .sink(
                receiveCompletion: { result in
                    if case .failure(let error) = result {
                        completion(.failure(error))
                    }
                },
                receiveValue: { [weak self] connection in
                    self?.activeConnections[self!.createItemIdentifier(serverId: serverId, path: "/")] = connection
                    completion(.success(connection))
                }
            )
            .store(in: &cancellables)
    }
    
    private func loadServer(with id: UUID) -> Server? {
        // This should load from persistent storage
        // For now, return nil
        return nil
    }
    
    private func createItemIdentifier(serverId: UUID, path: String) -> NSFileProviderItemIdentifier {
        return NSFileProviderItemIdentifier("\(serverId.uuidString):\(path)")
    }
    
    private func parseItemIdentifier(_ identifier: NSFileProviderItemIdentifier) -> ItemInfo? {
        let components = identifier.rawValue.split(separator: ":", maxSplits: 1)
        guard components.count == 2,
              let serverId = UUID(uuidString: String(components[0])) else {
            return nil
        }
        
        let path = String(components[1])
        let pathComponents = path.split(separator: "/")
        let filename = pathComponents.last.map(String.init) ?? ""
        let parentPath = pathComponents.dropLast().joined(separator: "/")
        
        return ItemInfo(
            serverId: serverId,
            path: path,
            filename: filename,
            parentIdentifier: createItemIdentifier(serverId: serverId, path: "/" + parentPath),
            isDirectory: false, // This should be determined from file info
            size: nil
        )
    }
    
    private struct ItemInfo {
        let serverId: UUID
        let path: String
        let filename: String
        let parentIdentifier: NSFileProviderItemIdentifier
        let isDirectory: Bool
        let size: NSNumber?
    }
}

// MARK: - File Provider Item

class FileProviderItem: NSObject, NSFileProviderItem {
    let identifier: NSFileProviderItemIdentifier
    let parentIdentifier: NSFileProviderItemIdentifier
    let filename: String
    let typeIdentifier: String
    let documentSize: NSNumber?
    
    init(identifier: NSFileProviderItemIdentifier,
         parentIdentifier: NSFileProviderItemIdentifier,
         filename: String,
         typeIdentifier: String,
         documentSize: NSNumber?) {
        self.identifier = identifier
        self.parentIdentifier = parentIdentifier
        self.filename = filename
        self.typeIdentifier = typeIdentifier
        self.documentSize = documentSize
        
        super.init()
    }
    
    var itemIdentifier: NSFileProviderItemIdentifier {
        return identifier
    }
    
    var capabilities: NSFileProviderItemCapabilities {
        if typeIdentifier == kUTTypeFolder as String {
            return [.allowsReading, .allowsContentEnumerating, .allowsAddingSubItems]
        } else {
            return [.allowsReading, .allowsWriting, .allowsDeleting, .allowsRenaming]
        }
    }
}

// MARK: - File Provider Enumerator

class FileProviderEnumerator: NSObject, NSFileProviderEnumerator {
    let containerIdentifier: NSFileProviderItemIdentifier
    let sshService: SSHServiceProtocol
    weak var fileProviderExtension: FileProviderExtension?
    
    private var cancellables = Set<AnyCancellable>()
    
    init(containerIdentifier: NSFileProviderItemIdentifier,
         sshService: SSHServiceProtocol,
         fileProviderExtension: FileProviderExtension) {
        self.containerIdentifier = containerIdentifier
        self.sshService = sshService
        self.fileProviderExtension = fileProviderExtension
        
        super.init()
    }
    
    func invalidate() {
        cancellables.removeAll()
    }
    
    func enumerateItems(for observer: NSFileProviderEnumerationObserver, startingAt page: NSFileProviderPage) {
        // Implementation would enumerate items in the directory
        // For now, just finish
        observer.finishEnumerating(upTo: nil)
    }
}
