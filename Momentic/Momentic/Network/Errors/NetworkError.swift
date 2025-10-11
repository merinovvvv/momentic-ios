//
//  NetworkError.swift
//  Momentic
//
//  Created by Yaraslau Merynau on 11.10.25.
//

import Foundation

enum NetworkError: Error {
    
    case userError(String) //users did smth they are not supposed to (400 err)
    case dataError(String)
    case encodingError
    case decodingError
    case failedStatusCode(Int)
    case failedStatusCodeResponseData(Int, Data)
    case noResponse
    
    //convenient way to retrieve data from case failedStatusCodeResponseData
    var statusCodeResponseData: (Int, Data)? {
        if case let .failedStatusCodeResponseData(statusCode, responseData) = self {
            return (statusCode, responseData)
        }
        
        return nil
    }
}
