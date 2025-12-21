//
//  AddPhotoViewModelTests.swift
//  MomenticTests
//
//  Created by Yaraslau Merynau on 12.10.25.
//

import XCTest
import UIKit
@testable import Momentic

final class AddPhotoViewModelTests: XCTestCase {
    
    var sut: AddPhotoViewModel!
    var mockNetworkHandler: MockNetworkHandler!
    var mockTokenStorage: MockAccessTokenStorage!
    
    override func setUp() {
        super.setUp()
        mockNetworkHandler = MockNetworkHandler()
        mockTokenStorage = MockAccessTokenStorage()
        sut = AddPhotoViewModel(networkHandler: mockNetworkHandler, tokenStorage: mockTokenStorage)
    }
    
    override func tearDown() {
        sut = nil
        mockNetworkHandler = nil
        mockTokenStorage = nil
        super.tearDown()
    }
    
    // MARK: - Image Selection Tests
    
    func testSetSelectedImage_SetsImage() {
        // Given
        let image = createTestImage()
        
        // When
        sut.setSelectedImage(image)
        
        // Then
        XCTAssertNotNil(sut.selectedImage)
        XCTAssertEqual(sut.selectedImage?.size, image.size)
    }
    
    func testClearSelectedPhoto_RemovesImage() {
        // Given
        let image = createTestImage()
        sut.setSelectedImage(image)
        
        // When
        sut.clearSelectedPhoto()
        
        // Then
        XCTAssertNil(sut.selectedImage)
    }
    
    // MARK: - Save Photo Tests
    
    func testSavePhoto_ValidImage_CallsUpload() {
        // Given
        let image = createTestImage()
        mockNetworkHandler.shouldSucceed = true
        mockTokenStorage.storedToken = AccessToken(accessToken: "token", refreshToken: "refresh")
        var successCalled = false
        sut.onPhotoSaved = {
            successCalled = true
        }
        
        // When
        sut.savePhoto(image)
        
        // Then
        let expectation = expectation(description: "Photo upload completed")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
        XCTAssertTrue(successCalled || mockNetworkHandler.uploadDataCallCount > 0)
    }
    
    // MARK: - Helper Methods
    
    private func createTestImage() -> UIImage {
        let size = CGSize(width: 100, height: 100)
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(UIColor.red.cgColor)
        context.fill(CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

