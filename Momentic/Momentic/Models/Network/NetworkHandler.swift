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
    case delete = "DELETE"
}

//MARK: - ContentType
enum ContentType: String{
    case json = "application/json; charset=utf-8"
}

//MARK: - NetworkHandler
final class NetworkHandler {
    func request(
        _ url: URL,
        jsonDictionary: Any? = nil,
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
        
        if let jsonDictionary, let httpBody = try? JSONSerialization.data(withJSONObject: jsonDictionary) {
            urlRequest.httpBody = httpBody
        } else if jsonDictionary != nil {
            print("Could not serialize object into JSON data")
            completion(.failure(ConfigurationError.serializationFailed))
        }
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            
            guard let data else {
                if let error {
                    completion(.failure(NetworkError.dataError("\(error)")))
                }
                completion(.failure(NetworkError.dataError("No data")))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Could not create HTTPURLResponse for: \(urlRequest.url?.absoluteString ?? "")")
                completion(.failure(NetworkError.noResponse))
                return
            }
            
            let statusCode = httpResponse.statusCode
            
            guard (200..<300).contains(statusCode) else {
                completion(.failure(NetworkError.failedStatusCodeResponseData(statusCode, data)))
                return
            }
            
            completion(.success(data))
        }.resume()
    }
    
    func request<ResponseType: Decodable>(
        _ url: URL,
        responseType: ResponseType.Type,
        jsonDictionary: Any? = nil,
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
                    print("Could not decode data: \(error)")
                    completion(.failure(NetworkError.decodingError))
                    return
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
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
