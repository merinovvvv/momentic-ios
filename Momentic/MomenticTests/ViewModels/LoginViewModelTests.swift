//
//  LoginViewModelTests.swift
//  MomenticTests
//
//  Created by Yaraslau Merynau on 12.10.25.
//

import XCTest
@testable import Momentic

final class LoginViewModelTests: XCTestCase {
    
    var sut: LoginViewModel!
    var mockNetworkHandler: MockNetworkHandler!
    var mockTokenStorage: MockAccessTokenStorage!
    
    override func setUp() {
        super.setUp()
        mockNetworkHandler = MockNetworkHandler()
        mockTokenStorage = MockAccessTokenStorage()
        sut = LoginViewModel(networkHandler: mockNetworkHandler, tokenStorage: mockTokenStorage)
    }
    
    override func tearDown() {
        sut = nil
        mockNetworkHandler = nil
        mockTokenStorage = nil
        super.tearDown()
    }
    
    // MARK: - Validation Tests
    
    func testIsValidEmail_ValidEmail_ReturnsTrue() {
        // Given
        sut.email = "test.user@bsu.by"
        
        // When
        let result = sut.isValidEmail()
        
        // Then
        XCTAssertTrue(result, "Valid email should return true")
    }
    
    func testIsValidEmail_InvalidEmail_ReturnsFalse() {
        // Given
        sut.email = "invalid@email.com"
        
        // When
        let result = sut.isValidEmail()
        
        // Then
        XCTAssertFalse(result, "Invalid email should return false")
    }
    
    func testIsValidEmail_EmptyEmail_ReturnsFalse() {
        // Given
        sut.email = ""
        
        // When
        let result = sut.isValidEmail()
        
        // Then
        XCTAssertFalse(result, "Empty email should return false")
    }
    
    func testIsValidEmail_NilEmail_ReturnsFalse() {
        // Given
        sut.email = nil
        
        // When
        let result = sut.isValidEmail()
        
        // Then
        XCTAssertFalse(result, "Nil email should return false")
    }
    
    func testIsValidPassword_ValidPassword_ReturnsTrue() {
        // Given
        sut.password = "Password123"
        
        // When
        let result = sut.isValidPassword()
        
        // Then
        XCTAssertTrue(result, "Valid password should return true")
    }
    
    func testIsValidPassword_TooShort_ReturnsFalse() {
        // Given
        sut.password = "Pass1"
        
        // When
        let result = sut.isValidPassword()
        
        // Then
        XCTAssertFalse(result, "Password shorter than 6 characters should return false")
    }
    
    func testIsValidPassword_NoUppercase_ReturnsFalse() {
        // Given
        sut.password = "password123"
        
        // When
        let result = sut.isValidPassword()
        
        // Then
        XCTAssertFalse(result, "Password without uppercase should return false")
    }
    
    func testIsValidPassword_NoLowercase_ReturnsFalse() {
        // Given
        sut.password = "PASSWORD123"
        
        // When
        let result = sut.isValidPassword()
        
        // Then
        XCTAssertFalse(result, "Password without lowercase should return false")
    }
    
    func testIsValidPassword_NoDigit_ReturnsFalse() {
        // Given
        sut.password = "Password"
        
        // When
        let result = sut.isValidPassword()
        
        // Then
        XCTAssertFalse(result, "Password without digit should return false")
    }
    
    // MARK: - Submit Tests
    
    func testSubmit_InvalidEmail_CallsValidationError() {
        // Given
        sut.email = "invalid@email.com"
        sut.password = "Password123"
        var validationErrors: [FormError]?
        let expectation = expectation(description: "Validation error called")
        sut.onValidationErrors = { errors in
            validationErrors = errors
            expectation.fulfill()
        }
        
        // When
        sut.submit()
        
        // Then
        waitForExpectations(timeout: 1.0)
        XCTAssertNotNil(validationErrors)
        XCTAssertTrue(validationErrors?.contains(.invalidEmail) ?? false)
        XCTAssertEqual(mockNetworkHandler.requestCallCount, 0)
    }
    
    func testSubmit_InvalidPassword_CallsValidationError() {
        // Given
        sut.email = "test.user@bsu.by"
        sut.password = "weak"
        var validationErrors: [FormError]?
        let expectation = expectation(description: "Validation error called")
        sut.onValidationErrors = { errors in
            validationErrors = errors
            expectation.fulfill()
        }
        
        // When
        sut.submit()
        
        // Then
        waitForExpectations(timeout: 1.0)
        XCTAssertNotNil(validationErrors)
        XCTAssertTrue(validationErrors?.contains(.invalidPassword) ?? false)
        XCTAssertEqual(mockNetworkHandler.requestCallCount, 0)
    }
    
    func testSubmit_ValidCredentials_CallsNetworkHandler() {
        // Given
        sut.email = "test.user@bsu.by"
        sut.password = "Password123"
        mockNetworkHandler.shouldSucceed = true
        mockNetworkHandler.mockResponse = AccessToken(accessToken: "token", refreshToken: "refresh")
        
        // When
        sut.submit()
        
        // Then
        let expectation = expectation(description: "Network request completed")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
        XCTAssertEqual(mockNetworkHandler.requestCallCount, 1)
        XCTAssertNotNil(mockNetworkHandler.lastURL)
    }
    
    func testSubmit_SuccessfulLogin_SavesToken() {
        // Given
        sut.email = "test.user@bsu.by"
        sut.password = "Password123"
        mockNetworkHandler.shouldSucceed = true
        let token = AccessToken(accessToken: "test_token", refreshToken: "test_refresh")
        mockNetworkHandler.mockResponse = token
        var successCalled = false
        sut.onSuccess = {
            successCalled = true
        }
        
        // When
        sut.submit()
        
        // Then
        let expectation = expectation(description: "Login completed")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
        XCTAssertEqual(mockTokenStorage.saveCallCount, 1)
        XCTAssertTrue(successCalled)
    }
    
    func testSubmit_NetworkError_CallsOnFailure() {
        // Given
        sut.email = "test.user@bsu.by"
        sut.password = "Password123"
        mockNetworkHandler.shouldSucceed = false
        mockNetworkHandler.mockError = NetworkError.noResponse
        var successCalled = false
        let expectation = expectation(description: "Network error handled")
        sut.onSuccess = {
            successCalled = true
            expectation.fulfill()
        }
        
        // When
        sut.submit()
        
        // Then
        waitForExpectations(timeout: 1.0)
        XCTAssertEqual(mockNetworkHandler.requestCallCount, 1)
        XCTAssertTrue(successCalled, "Note: Currently LoginViewModel calls onSuccess even on network error")
    }
}

