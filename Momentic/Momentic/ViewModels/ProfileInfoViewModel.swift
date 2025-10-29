//
//  ProfileInfoViewModel.swift
//  Momentic
//
//  Created by Yaraslau Merynau on 9.10.25.
//

import Foundation

final class ProfileInfoViewModel {
    
    //MARK: - Private properties
    
    private let networkHandler: NetworkHandler
    private let tokenStorage: AccessTokenStorage
    
    //MARK: - Init
    
    init(networkHandler: NetworkHandler, tokenStorage: AccessTokenStorage) {
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
            onValidationErrors?(validationErrors)
            return
        }
        
        let route = NetworkRoutes.updateProfile
        let method = route.httpMethod
        
        guard let url = route.url else {
            onFailure?(ConfigurationError.nilObject)
            return
        }
        
        let jsonDictionary = UserInfo(name: name ?? "", surname: surname ?? "", bio: bio, token: tokenStorage.get()?.accessToken ?? "")
        
        networkHandler.request(
            url,
            jsonDictionary: jsonDictionary,
            httpMethod: method.rawValue,
        ) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self?.onSuccess?()
                case .failure(let error):
                    self?.onFailure?(error)
                }
            }
        }
    }
    
    //MARK: - Private Methods
    private func isValidName() -> Bool {
        guard let name, !name.isEmpty else {
            return false
        }
        return true
    }
    
    private func isValidSurname() -> Bool {
        guard let surname, !surname.isEmpty else {
            return false
        }
        return true
    }
    
    func isValidBio() -> Bool {
        guard let bio, !bio.isEmpty && !(bio == NSLocalizedString("bio_textview_placeholder", comment: "Bio TextView placeholder")), bio.count <= 500 else {
            return false
        }
        
        return true
    }
}
