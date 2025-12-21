//
//  AuthViewModel.swift
//  Momentic
//
//  Created by Yaraslau Merynau on 9.10.25.
//

import Foundation

final class RegisterViewModel: AuthViewModelProtocol {
    
    //MARK: - Properties
    
    var email: String?
    var password: String?
    
    var authText: String
    
    private let networkHandler: NetworkHandlerProtocol
    
    //MARK: - Closures
    
    var onSuccess: (() -> Void)?
    var onFailure: ((Error) -> Void)?
    var onValidationErrors: (([FormError]) -> Void)?
    
    //MARK: - Init
    
    init(networkHandler: NetworkHandlerProtocol) {
        self.networkHandler = networkHandler
        authText = NSLocalizedString("signup_button_text", comment: "SignUp")
    }
    
    //MARK: - Methods
    
    func submit() -> Void {
        
        var validationErrors: [FormError] = []
        
        if !isValidEmail() {
            validationErrors.append(.invalidEmail)
        }
        
        if !isValidPassword() {
            validationErrors.append(.invalidPassword)
        }
        
        if !validationErrors.isEmpty {
            LoggingService.shared.warning(
                "Registration validation failed",
                category: "Auth",
                metadata: ["errors": validationErrors.map { $0.localizedDescription ?? "" }.joined(separator: ", ")]
            )
            onValidationErrors?(validationErrors)
            return
        }
        
        let route = NetworkRoutes.register
        let method = route.httpMethod
        
        guard let url = route.url else {
            LoggingService.shared.error(
                "Registration URL not found",
                category: "Auth",
                metadata: ["route": "register"]
            )
            onFailure?(ConfigurationError.nilObject)
            return
        }
        
        let jsonDictionary = UserCredentials(email: email ?? "", password: password ?? "")
        
        LoggingService.shared.info("Registration attempt started", category: "Auth")
        
        networkHandler.request(
            url,
            jsonDictionary: jsonDictionary,
            httpMethod: method.rawValue,
            contentType: ContentType.json.rawValue,
            accessToken: nil) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(_):
                        LoggingService.shared.info("Registration successful", category: "Auth")
                        self?.onSuccess?()
                    case .failure(let error):
                        LoggingService.shared.logError(
                            error,
                            category: "Auth",
                            additionalMetadata: ["action": "register"]
                        )
                        //self?.onFailure?(error)
                        self?.onSuccess?()
                    }
                }
            }
    }
}
