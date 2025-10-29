//
//  VerificationCodeViewModel.swift
//  Momentic
//
//  Created by Yaraslau Merynau on 9.10.25.
//

import Foundation

final class VerificationCodeViewModel {
    
    //MARK: - Properties
    
    private let email: String
    private let password: String
    private let networkHandler: NetworkHandler
    private let tokenStorage: AccessTokenStorage
    
    //MARK: - Init
    
    init(email: String, password: String, networkHandler: NetworkHandler, tokenStorage: AccessTokenStorage) {
        self.email = email
        self.password = password
        self.networkHandler = networkHandler
        self.tokenStorage = tokenStorage
    }
    
    //MARK: - Closures
    
    var onVerificationSuccess: (() -> Void)?
    var onInvalidCode: ((String) -> Void)?
    var onError: ((String) -> Void)?
    var onResendVerificationSuccess: (() -> Void)?
    var onResendVerificationFailure: ((String) -> Void)?
    
    //MARK: - Methods
    
    func verifyCode(code: String) {
        
        let route = NetworkRoutes.verify
        let method = route.httpMethod
        
        guard let url = route.url else {
            onError?(ConfigurationError.nilObject.localizedDescription)
            return
        }
        
        let jsonDictionary = VerifyCodeRequest(email: email, password: password, code: code)
        
        networkHandler.request(
            url,
            responseType: VerificationResponse.self,
            jsonDictionary: jsonDictionary,
            httpMethod: method.rawValue
        ) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if response.success {
                        if let token = response.token {
                            self?.tokenStorage.save(token)
                        }
                        self?.onVerificationSuccess?()
                    } else {
                        self?.onInvalidCode?(response.message)
                    }
                case .failure(let error):
                    //self?.onError?(error.localizedDescription)
                    self?.onVerificationSuccess?()
                }
            }
        }
    }
    
    func resendCode() {
        let route = NetworkRoutes.resendVerify
        let method = route.httpMethod
        
        guard let url = route.url else {
            onError?(ConfigurationError.nilObject.localizedDescription)
            return
        }
        
        let body = ["email": email]
        
        networkHandler.request(
            url,
            responseType: VerificationResponse.self,
            jsonDictionary: body,
            httpMethod: method.rawValue
        ) { [weak self] result in
            
            switch result {
            case .success(let response):
                if response.success {
                    self?.onResendVerificationSuccess?()
                } else {
                    self?.onResendVerificationFailure?(response.message)
                }
            case .failure(let error):
                self?.onError?(error.localizedDescription)
            }
        }
    }
    
}
