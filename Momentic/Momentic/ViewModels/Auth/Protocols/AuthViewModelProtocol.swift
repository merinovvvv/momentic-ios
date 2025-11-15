//
//  AuthViewModelProtocol.swift
//  Momentic
//
//  Created by Yaraslau Merynau on 14.10.25.
//

import Foundation

protocol AuthViewModelProtocol {
    var email: String? { get set }
    var password: String? { get set }
    
    var authText: String { get }
    
    func submit()
    
    func isValidEmail() -> Bool
    func isValidPassword() -> Bool
    
    var onSuccess: (() -> Void)? { get set }
    var onFailure: ((Error) -> Void)? { get set }
    var onValidationErrors: (([FormError]) -> Void)? { get set }
}

extension AuthViewModelProtocol {
    
    func isValidEmail() -> Bool {
        guard let email, !email.isEmpty else {
            return false
        }
        
        let emailRegex = "^[a-z]+\\.[a-z]+@bsu\\.by$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func isValidPassword() -> Bool {
        guard let password, !password.isEmpty, password.count >= 6 else {
            return false
        }
        
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).+$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
}
