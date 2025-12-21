//
//  ProfileInfoViewModelTests.swift
//  MomenticTests
//
//  Created by Yaraslau Merynau on 12.10.25.
//

import XCTest
@testable import Momentic

final class ProfileInfoViewModelTests: XCTestCase {
    
    var sut: ProfileInfoViewModel!
    var mockNetworkHandler: MockNetworkHandler!
    var mockTokenStorage: MockAccessTokenStorage!
    
    override func setUp() {
        super.setUp()
        mockNetworkHandler = MockNetworkHandler()
        mockTokenStorage = MockAccessTokenStorage()
        sut = ProfileInfoViewModel(networkHandler: mockNetworkHandler, tokenStorage: mockTokenStorage)
    }
    
    override func tearDown() {
        sut = nil
        mockNetworkHandler = nil
        mockTokenStorage = nil
        super.tearDown()
    }
    
    // MARK: - Validation Tests
    
    func testIsValidName_ValidName_ReturnsTrue() {
        // Given
        sut.name = "John"
        
        // When
        let result = sut.isValidName()
        
        // Then
        XCTAssertTrue(result)
    }
    
    func testIsValidName_EmptyName_ReturnsFalse() {
        // Given
        sut.name = ""
        
        // When
        let result = sut.isValidName()
        
        // Then
        XCTAssertFalse(result)
    }
    
    func testIsValidName_NilName_ReturnsFalse() {
        // Given
        sut.name = nil
        
        // When
        let result = sut.isValidName()
        
        // Then
        XCTAssertFalse(result)
    }
    
    func testIsValidSurname_ValidSurname_ReturnsTrue() {
        // Given
        sut.surname = "Doe"
        
        // When
        let result = sut.isValidSurname()
        
        // Then
        XCTAssertTrue(result)
    }
    
    func testIsValidBio_ValidBio_ReturnsTrue() {
        // Given
        sut.bio = "This is a valid bio"
        
        // When
        let result = sut.isValidBio()
        
        // Then
        XCTAssertTrue(result)
    }
    
    func testIsValidBio_TooLong_ReturnsFalse() {
        // Given
        sut.bio = String(repeating: "a", count: 501)
        
        // When
        let result = sut.isValidBio()
        
        // Then
        XCTAssertFalse(result)
    }
    
    func testIsValidBio_Exactly500_ReturnsTrue() {
        // Given
        sut.bio = String(repeating: "a", count: 500)
        
        // When
        let result = sut.isValidBio()
        
        // Then
        XCTAssertTrue(result)
    }
    
    // MARK: - Submit Tests
    
    func testSetInfo_InvalidName_CallsValidationError() {
        // Given
        sut.name = ""
        sut.surname = "Doe"
        sut.bio = "Bio"
        var validationErrors: [FormError]?
        let expectation = expectation(description: "Validation error called")
        sut.onValidationErrors = { errors in
            validationErrors = errors
            expectation.fulfill()
        }
        
        // When
        sut.setInfo()
        
        // Then
        waitForExpectations(timeout: 1.0)
        XCTAssertNotNil(validationErrors)
        XCTAssertTrue(validationErrors?.contains(.invalidName) ?? false)
    }
    
    func testSetInfo_ValidInfo_CallsNetworkHandler() {
        // Given
        sut.name = "John"
        sut.surname = "Doe"
        sut.bio = "Bio"
        mockTokenStorage.storedToken = AccessToken(accessToken: "token", refreshToken: "refresh")
        mockNetworkHandler.shouldSucceed = true
        
        // When
        sut.setInfo()
        
        // Then
        let expectation = expectation(description: "Network request completed")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
        XCTAssertEqual(mockNetworkHandler.requestCallCount, 1)
    }
}

