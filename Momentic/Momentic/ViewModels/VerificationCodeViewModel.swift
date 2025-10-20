//
//  VerificationCodeViewModel.swift
//  Momentic
//
//  Created by Yaraslau Merynau on 9.10.25.
//

import Foundation

final class VerificationCodeViewModel {
    
    //MARK: - Properties
    
    private let networkHandler: NetworkHandler
    
    //MARK: - Init
    
    init(networkHandler: NetworkHandler) {
        self.networkHandler = networkHandler
    }
    
    //MARK: - Closures
    
    var onVerificationSuccess: (() -> Void)?
    var onVerificationFailure: ((String) -> Void)?
    var onResendVerificationSuccess: (() -> Void)?
    var onResendVerificationFailure: ((String) -> Void)?
    
    //MARK: - Methods
    
    func verifyCode(email: String, code: String) {
        
        let route = NetworkRoutes.verify
        let method = route.httpMethod
        
        guard let url = route.url else {
            onVerificationFailure?(ConfigurationError.nilObject.localizedDescription)
            return
        }
        
        let jsonDictionary = VerifyCodeRequest(email: email, code: code)
        
        networkHandler.request(
            url,
            responseType: VerificationResponse.self,
            jsonDictionary: jsonDictionary,
            httpMethod: method.rawValue
        ) { [weak self] result in
            switch result {
            case .success(let response):
                if response.success {
                    if let token = response.token {
                        AccessTokenStorage().save(token)
                    }
                    self?.onVerificationSuccess?()
                } else {
                    self?.onVerificationFailure?(response.message)
                }
            case .failure(let error):
                self?.onVerificationFailure?(error.localizedDescription)
            }
        }
    }
    
    func resendCode(email: String) {
        let route = NetworkRoutes.resendVerify
        let method = route.httpMethod
        
        guard let url = route.url else {
            onVerificationFailure?(ConfigurationError.nilObject.localizedDescription)
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
                self?.onVerificationFailure?(error.localizedDescription)
            }
        }
    }
    
}
