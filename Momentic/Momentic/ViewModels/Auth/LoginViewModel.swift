//
//  LoginViewModel.swift
//  Momentic
//
//  Created by Yaraslau Merynau on 14.10.25.
//

import Foundation

final class LoginViewModel: AuthViewModelProtocol {
    
    //MARK: - Properties
    
    var authText: String
    
    var email: String?
    var password: String?
    
    private let networkHandler: NetworkHandler
    private let tokenStorage: AccessTokenStorage
    
    //MARK: - Closures
    
    var onSuccess: (() -> Void)?
    var onFailure: ((Error) -> Void)?
    var onValidationErrors: (([FormError]) -> Void)?
    
    //MARK: - Init
    
    init(networkHandler: NetworkHandler, tokenStorage: AccessTokenStorage) {
        self.networkHandler = networkHandler
        self.tokenStorage = tokenStorage
        authText = NSLocalizedString("signin_button_text", comment: "SignIn")
    }
    
    //MARK: - Methods
    
    func submit() {
        
        var validationErrors: [FormError] = []
        
        if !isValidEmail() {
            validationErrors.append(.invalidEmail)
        }
        
        if !isValidPassword() {
            validationErrors.append(.invalidPassword)
        }
        
        if !validationErrors.isEmpty {
            onValidationErrors?(validationErrors)
            return
        }
        
        let route = NetworkRoutes.login
        let method = route.httpMethod
        
        guard let url = route.url else {
            print("No url found")
            onFailure?(ConfigurationError.nilObject)
            return
        }
        
        let jsonDictionary = UserCredentials(email: email ?? "", password: password ?? "")
        
        networkHandler.request(
            url,
            responseType: AccessToken.self,
            jsonDictionary: jsonDictionary,
            httpMethod: method.rawValue) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let token):
                        self?.tokenStorage.save(token)
                        self?.onSuccess?()
                    case .failure(let error):
                        self?.onFailure?(error)
                    }
                    
                }
            }
    }
}
