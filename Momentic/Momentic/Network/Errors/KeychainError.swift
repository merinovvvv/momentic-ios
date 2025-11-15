//
//  KeychainError.swift
//  Momentic
//
//  Created by Yaraslau Merynau on 11.10.25.
//

import Foundation

enum KeychainError: LocalizedError {
    case saveFailed
    case retrieveFailed
    case deleteFailed
    
    var errorDescription: String? {
        switch self {
        case .saveFailed:
            return "Failed to save data to secure storage"
        case .retrieveFailed:
            return "Failed to retrieve data from secure storage"
        case .deleteFailed:
            return "Failed to delete data from secure storage"
        }
    }
}
