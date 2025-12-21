//
//  NetworkHandler.swift
//  Momentic
//
//  Created by Yaraslau Merynau on 11.10.25.
//

import Foundation

//MARK: - HTTPMethod
enum HTTPMethod: String{
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

//MARK: - ContentType
enum ContentType: String{
    case json = "application/json; charset=utf-8"
    case jpeg = "image/jpeg"
}

//MARK: - NetworkHandlerProtocol
protocol NetworkHandlerProtocol {
    func request(
        _ url: URL,
        jsonDictionary: Encodable?,
        httpMethod: String,
        contentType: String?,
        accessToken: String?,
        completion: @escaping (Result<Data, Error>) -> Void
    )
    
    func request<ResponseType: Decodable>(
        _ url: URL,
        responseType: ResponseType.Type,
        jsonDictionary: Encodable?,
        httpMethod: String,
        contentType: String?,
        accessToken: String?,
        completion: @escaping (Result<ResponseType, Error>) -> Void
    )
    
    func uploadData(
        _ url: URL,
        data: Data,
        httpMethod: String,
        contentType: String,
        accessToken: String?,
        completion: @escaping (Result<Data, Error>) -> Void
    )
}

//MARK: - NetworkHandler
final class NetworkHandler: NetworkHandlerProtocol {
    
    private let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func request(
        _ url: URL,
        jsonDictionary: Encodable? = nil,
        httpMethod: String = HTTPMethod.get.rawValue,
        contentType: String? = ContentType.json.rawValue,
        accessToken: String? = nil,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        
        var urlRequest = makeURLRequest (
            with: url,
            httpMethod: httpMethod,
            contentType: contentType,
            accessToken: accessToken
        )
        
        if let jsonDictionary, let httpBody = try? JSONEncoder().encode(jsonDictionary) {
            urlRequest.httpBody = httpBody
        } else if jsonDictionary != nil {
            LoggingService.shared.error(
                "Could not encode object into JSON data",
                category: "Network",
                metadata: ["url": url.absoluteString]
            )
            completion(.failure(NetworkError.encodingError))
            return
        }
        
        urlSession.dataTask(with: urlRequest) { data, response, error in
            
            guard let data else {
                if let error {
                    let nsError = error as NSError
                    
                    var networkError: NetworkError
                    switch nsError.code {
                    case NSURLErrorNotConnectedToInternet,
                    NSURLErrorNetworkConnectionLost:
                        networkError = NetworkError.noResponse
                        
                    case NSURLErrorTimedOut:
                        networkError = NetworkError.dataError("Request timed out")
                        
                    case NSURLErrorCannotConnectToHost:
                        networkError = NetworkError.dataError("Cannot connect to server")
                        
                    default:
                        networkError = NetworkError.dataError(error.localizedDescription)
                    }
                    
                    LoggingService.shared.logError(
                        networkError,
                        category: "Network",
                        additionalMetadata: [
                            "url": url.absoluteString,
                            "method": httpMethod,
                            "error_code": String(nsError.code)
                        ]
                    )
                    
                    completion(.failure(networkError))
                    return
                }
                
                LoggingService.shared.error(
                    "No data received from server",
                    category: "Network",
                    metadata: ["url": url.absoluteString, "method": httpMethod]
                )
                completion(.failure(NetworkError.dataError("No data")))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                LoggingService.shared.error(
                    "Could not create HTTPURLResponse",
                    category: "Network",
                    metadata: ["url": urlRequest.url?.absoluteString ?? "Unknown"]
                )
                completion(.failure(NetworkError.noResponse))
                return
            }
            
            let statusCode = httpResponse.statusCode
            
            guard (200..<300).contains(statusCode) else {
                LoggingService.shared.warning(
                    "Request failed with status code \(statusCode)",
                    category: "Network",
                    metadata: [
                        "url": url.absoluteString,
                        "method": httpMethod,
                        "status_code": String(statusCode)
                    ]
                )
                completion(.failure(NetworkError.failedStatusCodeResponseData(statusCode, data)))
                return
            }
            
            LoggingService.shared.debug(
                "Request succeeded",
                category: "Network",
                metadata: [
                    "url": url.absoluteString,
                    "method": httpMethod,
                    "status_code": String(statusCode)
                ]
            )
            
            completion(.success(data))
        }.resume()
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
        request(url, jsonDictionary: jsonDictionary, httpMethod: httpMethod, contentType: contentType, accessToken: accessToken) { result in
            switch result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(responseType, from: data)
                    completion(.success(decodedData))
                } catch {
                    LoggingService.shared.logError(
                        error,
                        category: "Network",
                        additionalMetadata: [
                            "url": url.absoluteString,
                            "response_type": String(describing: responseType)
                        ]
                    )
                    completion(.failure(NetworkError.decodingError))
                    return
                }
            case .failure(let error):
                completion(.failure(error))
            }
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
        var urlRequest = makeURLRequest(
            with: url,
            httpMethod: httpMethod,
            contentType: contentType,
            accessToken: accessToken
        )
        
        urlRequest.httpBody = data
        
        urlSession.dataTask(with: urlRequest) { data, response, error in
            guard let data else {
                if let error {
                    let nsError = error as NSError
                    
                    var networkError: NetworkError
                    switch nsError.code {
                    case NSURLErrorNotConnectedToInternet,
                    NSURLErrorNetworkConnectionLost:
                        networkError = NetworkError.noResponse
                        
                    case NSURLErrorTimedOut:
                        networkError = NetworkError.dataError("Request timed out")
                        
                    case NSURLErrorCannotConnectToHost:
                        networkError = NetworkError.dataError("Cannot connect to server")
                        
                    default:
                        networkError = NetworkError.dataError(error.localizedDescription)
                    }
                    
                    LoggingService.shared.logError(
                        networkError,
                        category: "Network",
                        additionalMetadata: [
                            "url": url.absoluteString,
                            "method": httpMethod,
                            "error_code": String(nsError.code),
                            "operation": "upload"
                        ]
                    )
                    
                    completion(.failure(networkError))
                    return
                }
                
                LoggingService.shared.error(
                    "No data received from server during upload",
                    category: "Network",
                    metadata: ["url": url.absoluteString, "method": httpMethod, "operation": "upload"]
                )
                completion(.failure(NetworkError.dataError("No data")))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                LoggingService.shared.error(
                    "Could not create HTTPURLResponse for upload",
                    category: "Network",
                    metadata: ["url": urlRequest.url?.absoluteString ?? "Unknown", "operation": "upload"]
                )
                completion(.failure(NetworkError.noResponse))
                return
            }
            
            let statusCode = httpResponse.statusCode
            
            guard (200..<300).contains(statusCode) else {
                LoggingService.shared.warning(
                    "Upload failed with status code \(statusCode)",
                    category: "Network",
                    metadata: [
                        "url": url.absoluteString,
                        "method": httpMethod,
                        "status_code": String(statusCode),
                        "operation": "upload"
                    ]
                )
                completion(.failure(NetworkError.failedStatusCodeResponseData(statusCode, data)))
                return
            }
            
            LoggingService.shared.info(
                "Upload succeeded",
                category: "Network",
                metadata: [
                    "url": url.absoluteString,
                    "method": httpMethod,
                    "status_code": String(statusCode),
                    "operation": "upload"
                ]
            )
            
            completion(.success(data))
        }.resume()
    }
}

//MARK: - Request maker
private extension NetworkHandler {
    func makeURLRequest(
        with url: URL,
        httpMethod: String = HTTPMethod.get.rawValue,
        contentType: String? = ContentType.json.rawValue,
        accessToken: String? = nil
    ) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod
        
        if let contentType {
            urlRequest.addValue(contentType, forHTTPHeaderField: "Content-Type")
            
            if contentType.range(of: "json") != nil {
                urlRequest.addValue(contentType, forHTTPHeaderField: "Accept")
            }
        }
        
        if let accessToken {
            let authorizationKey = "Bearer ".appending(accessToken)
            urlRequest.addValue(authorizationKey, forHTTPHeaderField: "Authorization")
        }
        
        return urlRequest
    }
}
