//
//  AddPhotoViewModel.swift
//  Momentic
//
//  Created by Yaraslau Merynau on 9.10.25.
//

import UIKit

final class AddPhotoViewModel {
    
    //MARK: - Properties
    
    private(set) var selectedImage: UIImage?
    private let networkHandler: NetworkHandler
    private let tokenStorage: AccessTokenStorage
    
    //MARK: - Closures
    
    var onPhotoSaved: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    //MARK: - Init
    
    init(networkHandler: NetworkHandler, tokenStorage: AccessTokenStorage) {
        self.networkHandler = networkHandler
        self.tokenStorage = tokenStorage
    }
    
    //MARK: - Public Methods
    
    func setSelectedImage(_ image: UIImage) {
        selectedImage = image
    }
    
    func savePhoto(_ image: UIImage) {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                guard let self = self else { return }
                
                do {
                    guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                        throw PhotoError.compressionFailed
                    }
                    
                    self.uploadPhoto(imageData: imageData)
                } catch {
                    DispatchQueue.main.async {
                        self.onError?(error)
                    }
                }
            }
        }
    
    func clearSelectedPhoto() {
        selectedImage = nil
    }
    
    private func uploadPhoto(imageData: Data) {
        
        let route = NetworkRoutes.updateAvatar
        let method = route.httpMethod
        
        guard let url = route.url else {
            onError?(ConfigurationError.nilObject)
            return
        }
        
        networkHandler.uploadData(
            url,
            data: imageData,
            httpMethod: method.rawValue,
            contentType: ContentType.jpeg.rawValue,
            accessToken: tokenStorage.get()?.accessToken
        ) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.onPhotoSaved?()
                case .failure(let error):
                    //self?.onError?(error)
                    self?.onPhotoSaved?()
                }
            }
        }
    }
}

//MARK: - PhotoError

enum PhotoError: LocalizedError {
    case compressionFailed
    case uploadFailed(statusCode: Int)
    case invalidImage
    case invalidURL
    case invalidResponse
    case unauthorized
    case fileTooLarge
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .compressionFailed:
            return NSLocalizedString("photo_compression_failed", comment: "Failed to compress photo")
        case .uploadFailed(let statusCode):
            return NSLocalizedString("photo_upload_failed", comment: "Failed to upload photo. Status code: \(statusCode)")
        case .invalidImage:
            return NSLocalizedString("invalid_image", comment: "Invalid image")
        case .invalidURL:
            return NSLocalizedString("invalid_url", comment: "Invalid URL")
        case .invalidResponse:
            return NSLocalizedString("invalid_response", comment: "Invalid server response")
        case .unauthorized:
            return NSLocalizedString("unauthorized", comment: "Unauthorized. Please log in again")
        case .fileTooLarge:
            return NSLocalizedString("file_too_large", comment: "File is too large")
        case .networkError(let error):
            return error.localizedDescription
        }
    }
}
