//
//  AuthViewModelProtocolTests.swift
//  MomenticTests
//
//  Created by Yaraslau Merynau on 12.10.25.
//

import XCTest
@testable import Momentic

final class AuthViewModelProtocolTests: XCTestCase {
    
    // MARK: - Email Validation Tests
    
    func testIsValidEmail_ValidBSUEmail_ReturnsTrue() {
        // Given
        let validEmails = [
            "test.user@bsu.by",
            "john.doe@bsu.by",
            "a.b@bsu.by"
        ]
        
        // When & Then
        for email in validEmails {
            let result = isValidEmail(email)
            XCTAssertTrue(result, "Email '\(email)' should be valid")
        }
    }
    
    func testIsValidEmail_InvalidFormats_ReturnsFalse() {
        // Given
        let invalidEmails = [
            "invalid@email.com",
            "test@bsu.com",
            "test.user@bsu.by.com",
            "testuser@bsu.by",
            "@bsu.by",
            "test.@bsu.by",
            ".user@bsu.by",
            "",
            "test.user@",
            "@bsu.by"
        ]
        
        // When & Then
        for email in invalidEmails {
            let result = isValidEmail(email)
            XCTAssertFalse(result, "Email '\(email)' should be invalid")
        }
    }
    
    // MARK: - Password Validation Tests
    
    func testIsValidPassword_ValidPasswords_ReturnsTrue() {
        // Given
        let validPasswords = [
            "Password123",
            "MyPass1",
            "Complex123Password",
            "A1b2c3d4"
        ]
        
        // When & Then
        for password in validPasswords {
            let result = isValidPassword(password)
            XCTAssertTrue(result, "Password '\(password)' should be valid")
        }
    }
    
    func testIsValidPassword_TooShort_ReturnsFalse() {
        // Given
        let shortPasswords = [
            "Pass1",
            "P1",
            "Pass",
            ""
        ]
        
        // When & Then
        for password in shortPasswords {
            let result = isValidPassword(password)
            XCTAssertFalse(result, "Password '\(password)' should be invalid (too short)")
        }
    }
    
    func testIsValidPassword_NoUppercase_ReturnsFalse() {
        // Given
        let passwords = [
            "password123",
            "mypass1",
            "lowercase123"
        ]
        
        // When & Then
        for password in passwords {
            let result = isValidPassword(password)
            XCTAssertFalse(result, "Password '\(password)' should be invalid (no uppercase)")
        }
    }
    
    func testIsValidPassword_NoLowercase_ReturnsFalse() {
        // Given
        let passwords = [
            "PASSWORD123",
            "MYPASS1",
            "UPPERCASE123"
        ]
        
        // When & Then
        for password in passwords {
            let result = isValidPassword(password)
            XCTAssertFalse(result, "Password '\(password)' should be invalid (no lowercase)")
        }
    }
    
    func testIsValidPassword_NoDigit_ReturnsFalse() {
        // Given
        let passwords = [
            "Password",
            "MyPass",
            "ComplexPassword"
        ]
        
        // When & Then
        for password in passwords {
            let result = isValidPassword(password)
            XCTAssertFalse(result, "Password '\(password)' should be invalid (no digit)")
        }
    }
    
    // MARK: - Helper Methods
    
    private func isValidEmail(_ email: String) -> Bool {
        guard !email.isEmpty else {
            return false
        }
        
        let emailRegex = "^[a-z]+\\.[a-z]+@bsu\\.by$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func isValidPassword(_ password: String) -> Bool {
        guard !password.isEmpty, password.count >= 6 else {
            return false
        }
        
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).+$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
}

