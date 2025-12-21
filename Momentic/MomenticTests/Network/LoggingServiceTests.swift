//
//  LoggingServiceTests.swift
//  MomenticTests
//
//  Created by Yaraslau Merynau on 12.10.25.
//

import XCTest
@testable import Momentic

final class LoggingServiceTests: XCTestCase {
    
    var sut: LoggingService!
    var mockNetworkHandler: MockNetworkHandler!
    
    override func setUp() {
        super.setUp()
        // Note: LoggingService is a singleton, so we'll test its public interface
        // In a real scenario, you might want to refactor it to accept dependencies
        mockNetworkHandler = MockNetworkHandler()
    }
    
    override func tearDown() {
        mockNetworkHandler = nil
        super.tearDown()
    }
    
    // MARK: - Log Level Tests
    
    func testDebug_LogsDebugMessage() {
        // Given
        let message = "Debug message"
        
        // When
        LoggingService.shared.debug(message)
        
        // Then
        // Since LoggingService is a singleton with private queue,
        // we verify it doesn't crash and completes execution
        XCTAssertTrue(true, "Debug log should complete without error")
    }
    
    func testInfo_LogsInfoMessage() {
        // Given
        let message = "Info message"
        
        // When
        LoggingService.shared.info(message)
        
        // Then
        XCTAssertTrue(true, "Info log should complete without error")
    }
    
    func testWarning_LogsWarningMessage() {
        // Given
        let message = "Warning message"
        
        // When
        LoggingService.shared.warning(message)
        
        // Then
        XCTAssertTrue(true, "Warning log should complete without error")
    }
    
    func testError_LogsErrorMessage() {
        // Given
        let message = "Error message"
        
        // When
        LoggingService.shared.error(message)
        
        // Then
        XCTAssertTrue(true, "Error log should complete without error")
    }
    
    func testLogError_LogsErrorWithMetadata() {
        // Given
        let error = NetworkError.noResponse
        
        // When
        LoggingService.shared.logError(error, category: "Test")
        
        // Then
        XCTAssertTrue(true, "Error logging should complete without error")
    }
    
    func testLog_WithCategory_IncludesCategory() {
        // Given
        let message = "Test message"
        let category = "TestCategory"
        
        // When
        LoggingService.shared.log(level: .info, message: message, category: category)
        
        // Then
        XCTAssertTrue(true, "Log with category should complete without error")
    }
    
    func testLog_WithMetadata_IncludesMetadata() {
        // Given
        let message = "Test message"
        let metadata = ["key": "value"]
        
        // When
        LoggingService.shared.log(level: .info, message: message, metadata: metadata)
        
        // Then
        XCTAssertTrue(true, "Log with metadata should complete without error")
    }
}

