//
//  ProfileInfoViewModel.swift
//  Momentic
//
//  Created by Yaraslau Merynau on 9.10.25.
//

import Foundation

final class ProfileInfoViewModel {
    
    //MARK: - Private properties
    
    private let networkHandler: NetworkHandlerProtocol
    private let tokenStorage: AccessTokenStorageProtocol
    
    //MARK: - Init
    
    init(networkHandler: NetworkHandlerProtocol, tokenStorage: AccessTokenStorageProtocol) {
        self.networkHandler = networkHandler
        self.tokenStorage = tokenStorage
    }
    
    //MARK: - Properties
    
    var name: String?
    var surname: String?
    var bio: String?
    
    //MARK: - Closures
    
    var onSuccess: (() -> Void)?
    var onFailure: ((Error) -> Void)?
    var onValidationErrors: (([FormError]) -> Void)?
    
    //MARK: - Methods
    
    func setInfo() {
        
        var validationErrors: [FormError] = []
        
        if !isValidName() {
            validationErrors.append(.invalidName)
        }
        
        if !isValidSurname() {
            validationErrors.append(.invalidSurname)
        }
        
        if !isValidBio() {
            validationErrors.append(.invalidBio)
        }
        
        if !validationErrors.isEmpty {
            LoggingService.shared.warning(
                "Profile info validation failed",
                category: "Profile",
                metadata: ["errors": validationErrors.map { $0.localizedDescription ?? "" }.joined(separator: ", ")]
            )
            onValidationErrors?(validationErrors)
            return
        }
        
        let route = NetworkRoutes.updateProfile
        let method = route.httpMethod
        
        guard let url = route.url else {
            LoggingService.shared.error(
                "Update profile URL not found",
                category: "Profile",
                metadata: ["route": "updateProfile"]
            )
            onFailure?(ConfigurationError.nilObject)
            return
        }
        
        let jsonDictionary = UserInfo(name: name ?? "", surname: surname ?? "", bio: bio, token: tokenStorage.get()?.accessToken ?? "")
        
        LoggingService.shared.info("Profile update started", category: "Profile")
        
        networkHandler.request(
            url,
            jsonDictionary: jsonDictionary,
            httpMethod: method.rawValue,
            contentType: ContentType.json.rawValue,
            accessToken: tokenStorage.get()?.accessToken
        ) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    LoggingService.shared.info("Profile update successful", category: "Profile")
                    self?.onSuccess?()
                case .failure(let error):
                    LoggingService.shared.logError(
                        error,
                        category: "Profile",
                        additionalMetadata: ["action": "update_profile"]
                    )
                    //self?.onFailure?(error)
                    self?.onSuccess?()
                }
            }
        }
    }
    
    //MARK: - Private Methods
    func isValidName() -> Bool {
        guard let name, !name.isEmpty else {
            return false
        }
        return true
    }
    
    func isValidSurname() -> Bool {
        guard let surname, !surname.isEmpty else {
            return false
        }
        return true
    }
    
    func isValidBio() -> Bool {
        guard let bio, bio.count <= 500 else {
            return false
        }

        return true
    }
}
