//
//  AuthViewModel.swift
//  Momentic
//
//  Created by Yaraslau Merynau on 9.10.25.
//

import Foundation

final class AuthViewModel {
    
    var authMode: AuthMode
    
    //MARK: - Private
    
    private var buttonTitle: String
    
    //MARK: - Init
    
    init(authMode: AuthMode) {
        self.authMode = authMode
        switch authMode {
        case .signUp:
            buttonTitle = NSLocalizedString("signup_button_text", comment: "SignUp")
        case .signIn:
            buttonTitle = NSLocalizedString("signin_button_text", comment: "SignIn")
        }
    }
    
}
