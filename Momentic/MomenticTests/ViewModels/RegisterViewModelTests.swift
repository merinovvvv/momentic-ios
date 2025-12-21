//
//  RegisterViewModelTests.swift
//  MomenticTests
//
//  Created by Yaraslau Merynau on 12.10.25.
//

import XCTest
@testable import Momentic

final class RegisterViewModelTests: XCTestCase {
    
    var sut: RegisterViewModel!
    var mockNetworkHandler: MockNetworkHandler!
    
    override func setUp() {
        super.setUp()
        mockNetworkHandler = MockNetworkHandler()
        sut = RegisterViewModel(networkHandler: mockNetworkHandler)
    }
    
    override func tearDown() {
        sut = nil
        mockNetworkHandler = nil
        super.tearDown()
    }
    
    // MARK: - Validation Tests
    
    func testIsValidEmail_ValidEmail_ReturnsTrue() {
        // Given
        sut.email = "test.user@bsu.by"
        
        // When
        let result = sut.isValidEmail()
        
        // Then
        XCTAssertTrue(result)
    }
    
    func testIsValidEmail_InvalidEmail_ReturnsFalse() {
        // Given
        sut.email = "invalid@email.com"
        
        // When
        let result = sut.isValidEmail()
        
        // Then
        XCTAssertFalse(result)
    }
    
    func testIsValidPassword_ValidPassword_ReturnsTrue() {
        // Given
        sut.password = "Password123"
        
        // When
        let result = sut.isValidPassword()
        
        // Then
        XCTAssertTrue(result)
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
    }
    
    func testSubmit_ValidCredentials_CallsNetworkHandler() {
        // Given
        sut.email = "test.user@bsu.by"
        sut.password = "Password123"
        mockNetworkHandler.shouldSucceed = true
        
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
    
    func testSubmit_SuccessfulRegistration_CallsOnSuccess() {
        // Given
        sut.email = "test.user@bsu.by"
        sut.password = "Password123"
        mockNetworkHandler.shouldSucceed = true
        var successCalled = false
        sut.onSuccess = {
            successCalled = true
        }
        
        // When
        sut.submit()
        
        // Then
        let expectation = expectation(description: "Registration completed")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
        XCTAssertTrue(successCalled)
    }
}

