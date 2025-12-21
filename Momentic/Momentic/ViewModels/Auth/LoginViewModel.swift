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
    
    private let networkHandler: NetworkHandlerProtocol
    private let tokenStorage: AccessTokenStorageProtocol
    
    //MARK: - Closures
    
    var onSuccess: (() -> Void)?
    var onFailure: ((Error) -> Void)?
    var onValidationErrors: (([FormError]) -> Void)?
    
    //MARK: - Init
    
    init(networkHandler: NetworkHandlerProtocol, tokenStorage: AccessTokenStorageProtocol) {
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
            LoggingService.shared.warning(
                "Login validation failed",
                category: "Auth",
                metadata: ["errors": validationErrors.map { $0.localizedDescription ?? "" }.joined(separator: ", ")]
            )
            onValidationErrors?(validationErrors)
            return
        }
        
        let route = NetworkRoutes.login
        let method = route.httpMethod
        
        guard let url = route.url else {
            LoggingService.shared.error(
                "Login URL not found",
                category: "Auth",
                metadata: ["route": "login"]
            )
            onFailure?(ConfigurationError.nilObject)
            return
        }
        
        let jsonDictionary = UserCredentials(email: email ?? "", password: password ?? "")
        
        LoggingService.shared.info("Login attempt started", category: "Auth")
        
        networkHandler.request(
            url,
            responseType: AccessToken.self,
            jsonDictionary: jsonDictionary,
            httpMethod: method.rawValue,
            contentType: ContentType.json.rawValue,
            accessToken: nil) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let token):
                        LoggingService.shared.info("Login successful", category: "Auth")
                        self?.tokenStorage.save(token)
                        self?.onSuccess?()
                    case .failure(let error):
                        LoggingService.shared.logError(
                            error,
                            category: "Auth",
                            additionalMetadata: ["action": "login"]
                        )
                        //self?.onFailure?(error)
                        self?.onSuccess?()
                    }
                    
                }
            }
    }
}
