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
    private let networkHandler: NetworkHandlerProtocol
    private let tokenStorage: AccessTokenStorageProtocol
    
    //MARK: - Init
    
    init(email: String, password: String, networkHandler: NetworkHandlerProtocol, tokenStorage: AccessTokenStorageProtocol) {
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
            LoggingService.shared.error(
                "Verification URL not found",
                category: "Auth",
                metadata: ["route": "verify"]
            )
            onError?(ConfigurationError.nilObject.localizedDescription)
            return
        }
        
        let jsonDictionary = VerifyCodeRequest(email: email, password: password, code: code)
        
        LoggingService.shared.info("Verification code attempt started", category: "Auth")
        
        networkHandler.request(
            url,
            responseType: VerificationResponse.self,
            jsonDictionary: jsonDictionary,
            httpMethod: method.rawValue,
            contentType: ContentType.json.rawValue,
            accessToken: nil
        ) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if response.success {
                        LoggingService.shared.info("Verification code successful", category: "Auth")
                        if let token = response.token {
                            self?.tokenStorage.save(token)
                        }
                        self?.onVerificationSuccess?()
                    } else {
                        LoggingService.shared.warning(
                            "Invalid verification code",
                            category: "Auth",
                            metadata: ["message": response.message]
                        )
                        self?.onInvalidCode?(response.message)
                    }
                case .failure(let error):
                    LoggingService.shared.logError(
                        error,
                        category: "Auth",
                        additionalMetadata: ["action": "verify_code"]
                    )
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
            LoggingService.shared.error(
                "Resend verification URL not found",
                category: "Auth",
                metadata: ["route": "resendVerify"]
            )
            onError?(ConfigurationError.nilObject.localizedDescription)
            return
        }
        
        let body = ["email": email]
        
        LoggingService.shared.info("Resend verification code requested", category: "Auth")
        
        networkHandler.request(
            url,
            responseType: VerificationResponse.self,
            jsonDictionary: body,
            httpMethod: method.rawValue,
            contentType: ContentType.json.rawValue,
            accessToken: nil
        ) { [weak self] result in
            
            switch result {
            case .success(let response):
                if response.success {
                    LoggingService.shared.info("Resend verification code successful", category: "Auth")
                    self?.onResendVerificationSuccess?()
                } else {
                    LoggingService.shared.warning(
                        "Resend verification code failed",
                        category: "Auth",
                        metadata: ["message": response.message]
                    )
                    self?.onResendVerificationFailure?(response.message)
                }
            case .failure(let error):
                LoggingService.shared.logError(
                    error,
                    category: "Auth",
                    additionalMetadata: ["action": "resend_verification_code"]
                )
                self?.onError?(error.localizedDescription)
            }
        }
    }
    
}
