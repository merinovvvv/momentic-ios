//
//  LoggingService.swift
//  Momentic
//
//  Created by Yaraslau Merynau on 12.10.25.
//

import Foundation
import UIKit

//MARK: - LoggingService
final class LoggingService {
    
    static let shared = LoggingService()
    
    //MARK: - Properties
    private let networkHandler: NetworkHandler
    private var logQueue: [LogEntry] = []
    private let queueLock = NSLock()
    private var batchTimer: Timer?
    private let maxBatchSize = 50
    private let batchInterval: TimeInterval = 30.0 // Send logs every 30 seconds
    private let maxQueueSize = 1000 // Maximum logs to keep in memory
    
    //MARK: - Initialization
    private init() {
        self.networkHandler = NetworkHandler()
        setupBatchTimer()
        setupAppLifecycleObservers()
    }
    
    //MARK: - Public Methods
    
    func log(level: LogLevel, message: String, category: String? = nil, metadata: [String: String]? = nil) {
        let logEntry = LogEntry(
            level: level,
            message: message,
            category: category,
            metadata: metadata
        )
        
        queueLock.lock()
        defer { queueLock.unlock() }
        
        // Prevent queue from growing too large
        if logQueue.count >= maxQueueSize {
            logQueue.removeFirst()
        }
        
        logQueue.append(logEntry)
        
        // Send immediately if batch size reached
        if logQueue.count >= maxBatchSize {
            sendLogsBatch()
        }
    }
    
    func debug(_ message: String, category: String? = nil, metadata: [String: String]? = nil) {
        log(level: .debug, message: message, category: category, metadata: metadata)
    }
    
    func info(_ message: String, category: String? = nil, metadata: [String: String]? = nil) {
        log(level: .info, message: message, category: category, metadata: metadata)
    }
    
    func warning(_ message: String, category: String? = nil, metadata: [String: String]? = nil) {
        log(level: .warning, message: message, category: category, metadata: metadata)
    }
    
    func error(_ message: String, category: String? = nil, metadata: [String: String]? = nil) {
        log(level: .error, message: message, category: category, metadata: metadata)
    }
    
    func logError(_ error: Error, category: String? = nil, additionalMetadata: [String: String]? = nil) {
        var metadata = additionalMetadata ?? [:]
        metadata["error_type"] = String(describing: type(of: error))
        metadata["error_description"] = error.localizedDescription
        
        if let nsError = error as NSError? {
            metadata["error_code"] = String(nsError.code)
            metadata["error_domain"] = nsError.domain
            if !nsError.userInfo.isEmpty {
                metadata["error_userInfo"] = String(describing: nsError.userInfo)
            }
        }
        
        self.error("Error occurred: \(error.localizedDescription)", category: category, metadata: metadata)
    }
    
    //MARK: - Private Methods
    
    private func setupBatchTimer() {
        batchTimer = Timer.scheduledTimer(withTimeInterval: batchInterval, repeats: true) { [weak self] _ in
            self?.sendLogsBatch()
        }
    }
    
    private func setupAppLifecycleObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appWillEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appWillTerminate),
            name: UIApplication.willTerminateNotification,
            object: nil
        )
    }
    
    @objc private func appWillEnterForeground() {
        info("App entered foreground", category: "AppLifecycle")
        sendLogsBatch()
    }
    
    @objc private func appDidEnterBackground() {
        info("App entered background", category: "AppLifecycle")
        sendLogsBatch()
    }
    
    @objc private func appWillTerminate() {
        info("App will terminate", category: "AppLifecycle")
        sendLogsBatchSync()
    }
    
    private func sendLogsBatch() {
        queueLock.lock()
        let logsToSend = Array(logQueue.prefix(maxBatchSize))
        logQueue.removeFirst(min(maxBatchSize, logQueue.count))
        queueLock.unlock()
        
        guard !logsToSend.isEmpty else { return }
        
        sendLogs(logsToSend)
    }
    
    private func sendLogsBatchSync() {
        queueLock.lock()
        let logsToSend = Array(logQueue)
        logQueue.removeAll()
        queueLock.unlock()
        
        guard !logsToSend.isEmpty else { return }
        
        let semaphore = DispatchSemaphore(value: 0)
        sendLogs(logsToSend) {
            semaphore.signal()
        }
        semaphore.wait(timeout: .now() + 5.0) // Wait max 5 seconds
    }
    
    private func sendLogs(_ logs: [LogEntry], completion: (() -> Void)? = nil) {
        guard let url = NetworkRoutes.logs.url else {
            // If URL is invalid, put logs back in queue
            queueLock.lock()
            logQueue.insert(contentsOf: logs, at: 0)
            queueLock.unlock()
            completion?()
            return
        }
        
        let batch = LogBatch(logs: logs)
        
        networkHandler.request(
            url,
            jsonDictionary: batch,
            httpMethod: HTTPMethod.post.rawValue
        ) { [weak self] result in
            switch result {
            case .success:
                // Logs sent successfully
                break
            case .failure(let error):
                // Put logs back in queue for retry
                self?.queueLock.lock()
                self?.logQueue.insert(contentsOf: logs, at: 0)
                self?.queueLock.unlock()
                
                // Log the error (but don't create infinite loop)
                if logs.count < 10 { // Only log if small batch to avoid recursion
                    print("Failed to send logs to server: \(error.localizedDescription)")
                }
            }
            completion?()
        }
    }
    
    deinit {
        batchTimer?.invalidate()
        NotificationCenter.default.removeObserver(self)
    }
}

