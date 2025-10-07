//
//  ModuleFactory.swift
//  Momentic
//
//  Created by Yaraslau Merynau on 7.10.25.
//

import UIKit

final class ModuleFactory {
    
    //MARK: - Registration
    
    func createWelcomeModule() -> WelcomeViewController {
        WelcomeViewController()
    }
    
    func createEnterEmailPasswordModule() -> AuthViewController {
        AuthViewController()
    }
    
    func createEnterCodeModule() -> VerificationCodeViewController {
        VerificationCodeViewController()
    }
    
    func createProfileInfoModule() -> ProfileInfoViewController {
        ProfileInfoViewController()
    }
    
    func createAddPhotoModule() -> AddPhotoViewController {
        AddPhotoViewController()
    }
    
    //MARK: - Login
    
//    func createEnterEmailPasswordModule() -> AuthViewController {
//        AuthViewController()
//    }
    
    
}
