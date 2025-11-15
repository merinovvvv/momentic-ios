//
//  ConfigurationError.swift
//  Momentic
//
//  Created by Yaraslau Merynau on 11.10.25.
//

import Foundation

enum ConfigurationError: LocalizedError {
    case nilObject
    case serializationFailed
    
    var errorDescription: String? {
        switch self {
        case .nilObject:
            return "Configuration error: Required object is missing"
        case .serializationFailed:
            return "Failed to serialize data. Please check the data format"
        }
    }
}
