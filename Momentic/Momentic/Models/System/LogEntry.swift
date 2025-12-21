//
//  LogEntry.swift
//  Momentic
//
//  Created by Yaraslau Merynau on 12.10.25.
//

import Foundation
import UIKit

//MARK: - LogLevel
enum LogLevel: String, Codable {
    case debug = "DEBUG"
    case info = "INFO"
    case warning = "WARNING"
    case error = "ERROR"
}

//MARK: - LogEntry
struct LogEntry: Codable {
    let level: LogLevel
    let message: String
    let timestamp: Date
    let category: String?
    let metadata: [String: String]?
    let deviceInfo: DeviceInfo
    
    init(
        level: LogLevel,
        message: String,
        category: String? = nil,
        metadata: [String: String]? = nil
    ) {
        self.level = level
        self.message = message
        self.timestamp = Date()
        self.category = category
        self.metadata = metadata
        self.deviceInfo = DeviceInfo.current
    }
}

//MARK: - DeviceInfo
struct DeviceInfo: Codable {
    let deviceModel: String
    let osVersion: String
    let appVersion: String
    let deviceId: String
    
    static var current: DeviceInfo {
        DeviceInfo(
            deviceModel: UIDevice.current.model,
            osVersion: UIDevice.current.systemVersion,
            appVersion: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown",
            deviceId: UIDevice.current.identifierForVendor?.uuidString ?? "Unknown"
        )
    }
}

//MARK: - LogBatch
struct LogBatch: Codable {
    let logs: [LogEntry]
    let batchId: String
    let timestamp: Date
    
    init(logs: [LogEntry]) {
        self.logs = logs
        self.batchId = UUID().uuidString
        self.timestamp = Date()
    }
}

