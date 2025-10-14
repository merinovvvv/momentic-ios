//
//  NetworkError.swift
//  Momentic
//
//  Created by Yaraslau Merynau on 11.10.25.
//

import Foundation

enum NetworkError: LocalizedError {
    
    case userError(String) //users did smth they are not supposed to (400 err)
    case dataError(String)
    case encodingError
    case decodingError
    case failedStatusCode(Int)
    case failedStatusCodeResponseData(Int, Data)
    case noResponse
    
    var errorDescription: String? {
        switch self {
        case .userError(let message):
            return message
            
        case .dataError(let message):
            return "Data error: \(message)"
            
        case .encodingError:
            return "Failed to encode request data"
            
        case .decodingError:
            return "Failed to process server response"
            
        case .failedStatusCode(let statusCode):
            return "Request failed with status code \(statusCode)"
            
        case .failedStatusCodeResponseData(let statusCode, _):
            return "Request failed with status code \(statusCode)"
            
        case .noResponse:
            return "No response from server. Please check your internet connection"
        }
    }
    
    //convenient way to retrieve data from case failedStatusCodeResponseData
    var statusCodeResponseData: (Int, Data)? {
        if case let .failedStatusCodeResponseData(statusCode, responseData) = self {
            return (statusCode, responseData)
        }
        
        return nil
    }
}
