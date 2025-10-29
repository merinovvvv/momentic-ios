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
    
    private let networkHandler: NetworkHandler
    
    //MARK: - Closures
    
    var onSuccess: (() -> Void)?
    var onFailure: ((Error) -> Void)?
    var onValidationErrors: (([FormError]) -> Void)?
    
    //MARK: - Init
    
    init(networkHandler: NetworkHandler) {
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
            onValidationErrors?(validationErrors)
            return
        }
        
        let route = NetworkRoutes.register
        let method = route.httpMethod
        
        guard let url = route.url else {
            onFailure?(ConfigurationError.nilObject)
            return
        }
        
        let jsonDictionary = UserCredentials(email: email ?? "", password: password ?? "")
        
        networkHandler.request(
            url,
            jsonDictionary: jsonDictionary,
            httpMethod: method.rawValue) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(_):
                        self?.onSuccess?()
                    case .failure(let error):
                        //self?.onFailure?(error)
                        self?.onSuccess?()
                    }
                }
            }
    }
}
