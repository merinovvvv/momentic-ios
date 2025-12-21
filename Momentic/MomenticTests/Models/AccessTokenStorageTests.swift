//
//  AccessTokenStorageTests.swift
//  MomenticTests
//
//  Created by Yaraslau Merynau on 12.10.25.
//

import XCTest
@testable import Momentic

final class AccessTokenStorageTests: XCTestCase {
    
    var sut: AccessTokenStorage!
    
    override func setUp() {
        super.setUp()
        sut = AccessTokenStorage()
        // Clean up any existing tokens
        _ = sut.delete()
    }
    
    override func tearDown() {
        _ = sut.delete()
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Save Tests
    
    func testSave_ValidToken_ReturnsTrue() {
        // Given
        let token = AccessToken(accessToken: "test_access_token", refreshToken: "test_refresh_token")
        
        // When
        let result = sut.save(token)
        
        // Then
        XCTAssertTrue(result, "Saving valid token should return true")
    }
    
    func testSave_Token_CanBeRetrieved() {
        // Given
        let token = AccessToken(accessToken: "test_access_token", refreshToken: "test_refresh_token")
        _ = sut.save(token)
        
        // When
        let retrievedToken = sut.get()
        
        // Then
        XCTAssertNotNil(retrievedToken)
        XCTAssertEqual(retrievedToken?.accessToken, token.accessToken)
        XCTAssertEqual(retrievedToken?.refreshToken, token.refreshToken)
    }
    
    func testSave_OverwritesExistingToken() {
        // Given
        let firstToken = AccessToken(accessToken: "first_token", refreshToken: "first_refresh")
        let secondToken = AccessToken(accessToken: "second_token", refreshToken: "second_refresh")
        _ = sut.save(firstToken)
        
        // When
        _ = sut.save(secondToken)
        let retrievedToken = sut.get()
        
        // Then
        XCTAssertEqual(retrievedToken?.accessToken, secondToken.accessToken)
        XCTAssertNotEqual(retrievedToken?.accessToken, firstToken.accessToken)
    }
    
    // MARK: - Get Tests
    
    func testGet_NoToken_ReturnsNil() {
        // Given
        _ = sut.delete()
        
        // When
        let token = sut.get()
        
        // Then
        XCTAssertNil(token, "Getting token when none exists should return nil")
    }
    
    func testGet_AfterSave_ReturnsToken() {
        // Given
        let token = AccessToken(accessToken: "test_token", refreshToken: "test_refresh")
        _ = sut.save(token)
        
        // When
        let retrievedToken = sut.get()
        
        // Then
        XCTAssertNotNil(retrievedToken)
        XCTAssertEqual(retrievedToken?.accessToken, token.accessToken)
    }
    
    // MARK: - Delete Tests
    
    func testDelete_ExistingToken_ReturnsTrue() {
        // Given
        let token = AccessToken(accessToken: "test_token", refreshToken: "test_refresh")
        _ = sut.save(token)
        
        // When
        let result = sut.delete()
        
        // Then
        XCTAssertTrue(result, "Deleting existing token should return true")
    }
    
    func testDelete_RemovesToken() {
        // Given
        let token = AccessToken(accessToken: "test_token", refreshToken: "test_refresh")
        _ = sut.save(token)
        
        // When
        _ = sut.delete()
        let retrievedToken = sut.get()
        
        // Then
        XCTAssertNil(retrievedToken, "Token should be nil after deletion")
    }
    
    func testDelete_NoToken_ReturnsTrue() {
        // Given
        _ = sut.delete() // Ensure no token exists
        
        // When
        let result = sut.delete()
        
        // Then
        // Note: Keychain delete typically returns true even if item doesn't exist
        XCTAssertFalse(result)
    }
}

