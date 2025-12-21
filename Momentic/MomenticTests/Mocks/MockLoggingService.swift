//
//  MockLoggingService.swift
//  MomenticTests
//
//  Created by Yaraslau Merynau on 12.10.25.
//

import Foundation
@testable import Momentic

final class MockLoggingService {
    
    static var shared = MockLoggingService()
    
    var logCallCount = 0
    var debugCallCount = 0
    var infoCallCount = 0
    var warningCallCount = 0
    var errorCallCount = 0
    var logErrorCallCount = 0
    var loggedMessages: [String] = []
    var loggedErrors: [Error] = []
    
    func reset() {
        logCallCount = 0
        debugCallCount = 0
        infoCallCount = 0
        warningCallCount = 0
        errorCallCount = 0
        logErrorCallCount = 0
        loggedMessages.removeAll()
        loggedErrors.removeAll()
    }
    
    func log(level: LogLevel, message: String, category: String? = nil, metadata: [String: String]? = nil) {
        logCallCount += 1
        loggedMessages.append(message)
    }
    
    func debug(_ message: String, category: String? = nil, metadata: [String: String]? = nil) {
        debugCallCount += 1
        loggedMessages.append(message)
    }
    
    func info(_ message: String, category: String? = nil, metadata: [String: String]? = nil) {
        infoCallCount += 1
        loggedMessages.append(message)
    }
    
    func warning(_ message: String, category: String? = nil, metadata: [String: String]? = nil) {
        warningCallCount += 1
        loggedMessages.append(message)
    }
    
    func error(_ message: String, category: String? = nil, metadata: [String: String]? = nil) {
        errorCallCount += 1
        loggedMessages.append(message)
    }
    
    func logError(_ error: Error, category: String? = nil, additionalMetadata: [String: String]? = nil) {
        logErrorCallCount += 1
        loggedErrors.append(error)
    }
}

