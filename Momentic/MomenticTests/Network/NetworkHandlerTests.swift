//
//  NetworkHandlerTests.swift
//  MomenticTests
//
//  Created by Yaraslau Merynau on 12.10.25.
//

import XCTest
@testable import Momentic

final class NetworkHandlerTests: XCTestCase {
    
    var sut: NetworkHandler!
    var mockURLSession: URLSession!
    
    override func setUp() {
        super.setUp()
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        mockURLSession = URLSession(configuration: configuration)
        sut = NetworkHandler(urlSession: mockURLSession)
    }
    
    override func tearDown() {
        MockURLProtocol.requestHandler = nil
        sut = nil
        mockURLSession = nil
        super.tearDown()
    }
    
    // MARK: - Request Tests
    
    func testRequest_SuccessfulResponse_ReturnsData() {
        // Given
        let url = URL(string: "https://example.com/api/test")!
        let expectedData = "Test Data".data(using: .utf8)!
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: url,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, expectedData)
        }
        
        let expectation = expectation(description: "Request completed")
        
        // When
        sut.request(
            url,
            jsonDictionary: nil,
            httpMethod: HTTPMethod.get.rawValue,
            contentType: ContentType.json.rawValue,
            accessToken: nil
        ) { result in
            // Then
            switch result {
            case .success(let data):
                XCTAssertEqual(data, expectedData)
                expectation.fulfill()
            case .failure:
                XCTFail("Request should succeed")
            }
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testRequest_NetworkError_ReturnsError() {
        // Given
        let url = URL(string: "https://example.com/api/test")!
        MockURLProtocol.requestHandler = { request in
            throw NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet)
        }
        
        let expectation = expectation(description: "Request failed")
        
        // When
        sut.request(
            url,
            jsonDictionary: nil,
            httpMethod: HTTPMethod.get.rawValue,
            contentType: ContentType.json.rawValue,
            accessToken: nil
        ) { result in
            // Then
            switch result {
            case .success:
                XCTFail("Request should fail")
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testRequest_NonSuccessStatusCode_ReturnsError() {
        // Given
        let url = URL(string: "https://example.com/api/test")!
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: url,
                statusCode: 404,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, Data())
        }
        
        let expectation = expectation(description: "Request failed")
        
        // When
        sut.request(
            url,
            jsonDictionary: nil,
            httpMethod: HTTPMethod.get.rawValue,
            contentType: ContentType.json.rawValue,
            accessToken: nil
        ) { result in
            // Then
            switch result {
            case .success:
                XCTFail("Request should fail with 404")
            case .failure:
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testRequest_WithAccessToken_IncludesAuthorizationHeader() {
        // Given
        let url = URL(string: "https://example.com/api/test")!
        let token = "test_token"
        var capturedRequest: URLRequest?
        
        MockURLProtocol.requestHandler = { request in
            capturedRequest = request
            let response = HTTPURLResponse(
                url: url,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, Data())
        }
        
        let expectation = expectation(description: "Request completed")
        
        // When
        sut.request(
            url,
            jsonDictionary: nil,
            httpMethod: HTTPMethod.get.rawValue,
            contentType: ContentType.json.rawValue,
            accessToken: token
        ) { _ in
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
        
        // Then
        XCTAssertNotNil(capturedRequest)
        XCTAssertEqual(capturedRequest?.value(forHTTPHeaderField: "Authorization"), "Bearer \(token)")
    }
}

// MARK: - Mock URL Protocol

class MockURLProtocol: URLProtocol {
    
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            fatalError("Handler is unavailable.")
        }
        
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {
        // Required by URLProtocol
    }
}

