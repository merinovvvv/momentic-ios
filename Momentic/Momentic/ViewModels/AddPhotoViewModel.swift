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
    
    //MARK: - Closures
    
    var onPhotoSaved: ((URL) -> Void)?
    var onError: ((Error) -> Void)?
    
    //MARK: - Public Methods
    
    func setSelectedImage(_ image: UIImage) {
        selectedImage = image
    }
    
    func savePhoto(_ image: UIImage) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            do {
                let url = try self?.saveImageToDocuments(image)
                DispatchQueue.main.async {
                    if let url = url {
                        self?.onPhotoSaved?(url)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self?.onError?(error)
                }
            }
        }
    }
    
    func clearSelectedPhoto() {
        selectedImage = nil
    }
    
    //MARK: - Private Methods
    
    private func saveImageToDocuments(_ image: UIImage) throws -> URL {
        guard let data = image.jpegData(compressionQuality: 0.8) else {
            throw PhotoError.compressionFailed
        }
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = "profile_photo_\(UUID().uuidString).jpg"
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        try data.write(to: fileURL)
        return fileURL
    }
}

//MARK: - PhotoError

enum PhotoError: LocalizedError {
    case compressionFailed
    case saveFailed
    case invalidImage
    
    var errorDescription: String? {
        switch self {
        case .compressionFailed:
            return NSLocalizedString("photo_compression_failed", comment: "Failed to compress photo")
        case .saveFailed:
            return NSLocalizedString("photo_save_failed", comment: "Failed to save photo")
        case .invalidImage:
            return NSLocalizedString("invalid_image", comment: "Invalid image")
        }
    }
}
