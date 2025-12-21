//
//  VerificationCodeViewModelTests.swift
//  MomenticTests
//
//  Created by Yaraslau Merynau on 12.10.25.
//

import XCTest
@testable import Momentic

final class VerificationCodeViewModelTests: XCTestCase {
    
    var sut: VerificationCodeViewModel!
    var mockNetworkHandler: MockNetworkHandler!
    var mockTokenStorage: MockAccessTokenStorage!
    
    override func setUp() {
        super.setUp()
        mockNetworkHandler = MockNetworkHandler()
        mockTokenStorage = MockAccessTokenStorage()
        sut = VerificationCodeViewModel(
            email: "test.user@bsu.by",
            password: "Password123",
            networkHandler: mockNetworkHandler,
            tokenStorage: mockTokenStorage
        )
    }
    
    override func tearDown() {
        sut = nil
        mockNetworkHandler = nil
        mockTokenStorage = nil
        super.tearDown()
    }
    
    // MARK: - Verify Code Tests
    
    func testVerifyCode_ValidCode_CallsNetworkHandler() {
        // Given
        let code = "123456"
        mockNetworkHandler.shouldSucceed = true
        let response = VerificationResponse(success: true, message: "Success", token: AccessToken(accessToken: "token", refreshToken: "refresh"))
        mockNetworkHandler.mockResponse = response
        
        // When
        sut.verifyCode(code: code)
        
        // Then
        let expectation = expectation(description: "Verification completed")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
        XCTAssertEqual(mockNetworkHandler.requestCallCount, 1)
    }
    
    func testVerifyCode_SuccessfulVerification_SavesToken() {
        // Given
        let code = "123456"
        mockNetworkHandler.shouldSucceed = true
        let token = AccessToken(accessToken: "test_token", refreshToken: "test_refresh")
        let response = VerificationResponse(success: true, message: "Success", token: token)
        mockNetworkHandler.mockResponse = response
        var successCalled = false
        sut.onVerificationSuccess = {
            successCalled = true
        }
        
        // When
        sut.verifyCode(code: code)
        
        // Then
        let expectation = expectation(description: "Verification completed")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
        XCTAssertEqual(mockTokenStorage.saveCallCount, 1)
        XCTAssertTrue(successCalled)
    }
    
    func testVerifyCode_InvalidCode_CallsInvalidCode() {
        // Given
        let code = "000000"
        mockNetworkHandler.shouldSucceed = true
        let response = VerificationResponse(success: false, message: "Invalid code", token: nil)
        mockNetworkHandler.mockResponse = response
        var invalidCodeCalled = false
        var errorMessage: String?
        sut.onInvalidCode = { message in
            invalidCodeCalled = true
            errorMessage = message
        }
        
        // When
        sut.verifyCode(code: code)
        
        // Then
        let expectation = expectation(description: "Invalid code handled")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
        XCTAssertTrue(invalidCodeCalled)
        XCTAssertEqual(errorMessage, "Invalid code")
    }
    
    // MARK: - Resend Code Tests
    
    func testResendCode_CallsNetworkHandler() {
        // Given
        mockNetworkHandler.shouldSucceed = true
        let response = VerificationResponse(success: true, message: "Code resent", token: nil)
        mockNetworkHandler.mockResponse = response
        
        // When
        sut.resendCode()
        
        // Then
        let expectation = expectation(description: "Resend completed")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
        XCTAssertEqual(mockNetworkHandler.requestCallCount, 1)
    }
    
    func testResendCode_Success_CallsOnResendSuccess() {
        // Given
        mockNetworkHandler.shouldSucceed = true
        let response = VerificationResponse(success: true, message: "Code resent", token: nil)
        mockNetworkHandler.mockResponse = response
        var successCalled = false
        sut.onResendVerificationSuccess = {
            successCalled = true
        }
        
        // When
        sut.resendCode()
        
        // Then
        let expectation = expectation(description: "Resend completed")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
        XCTAssertTrue(successCalled)
    }
}

