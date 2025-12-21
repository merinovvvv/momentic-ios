//
//  MockNetworkHandler.swift
//  MomenticTests
//
//  Created by Yaraslau Merynau on 12.10.25.
//

import Foundation
@testable import Momentic

final class MockNetworkHandler: NetworkHandlerProtocol {
    
    var requestCallCount = 0
    var uploadDataCallCount = 0
    var shouldSucceed = true
    var mockError: Error?
    var mockData: Data?
    var mockResponse: Any?
    var lastURL: URL?
    var lastHTTPMethod: String?
    var lastJSONDictionary: Encodable?
    
    func request(
        _ url: URL,
        jsonDictionary: Encodable? = nil,
        httpMethod: String = HTTPMethod.get.rawValue,
        contentType: String? = ContentType.json.rawValue,
        accessToken: String? = nil,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        requestCallCount += 1
        lastURL = url
        lastHTTPMethod = httpMethod
        lastJSONDictionary = jsonDictionary
        
        if shouldSucceed {
            if let mockData = mockData {
                completion(.success(mockData))
            } else {
                completion(.success(Data()))
            }
        } else {
            let error = mockError ?? NetworkError.noResponse
            completion(.failure(error))
        }
    }
    
    func request<ResponseType: Decodable>(
        _ url: URL,
        responseType: ResponseType.Type,
        jsonDictionary: Encodable? = nil,
        httpMethod: String = HTTPMethod.get.rawValue,
        contentType: String? = ContentType.json.rawValue,
        accessToken: String? = nil,
        completion: @escaping (Result<ResponseType, Error>) -> Void
    ) {
        requestCallCount += 1
        lastURL = url
        lastHTTPMethod = httpMethod
        lastJSONDictionary = jsonDictionary
        
        if shouldSucceed {
            if let mockResponse = mockResponse as? ResponseType {
                completion(.success(mockResponse))
            } else if let mockData = mockData,
                      let decoded = try? JSONDecoder().decode(ResponseType.self, from: mockData) {
                completion(.success(decoded))
            } else {
                completion(.failure(NetworkError.decodingError))
            }
        } else {
            let error = mockError ?? NetworkError.noResponse
            completion(.failure(error))
        }
    }
    
    func uploadData(
        _ url: URL,
        data: Data,
        httpMethod: String = HTTPMethod.put.rawValue,
        contentType: String,
        accessToken: String? = nil,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        uploadDataCallCount += 1
        lastURL = url
        lastHTTPMethod = httpMethod
        
        if shouldSucceed {
            completion(.success(Data()))
        } else {
            let error = mockError ?? NetworkError.noResponse
            completion(.failure(error))
        }
    }
}

