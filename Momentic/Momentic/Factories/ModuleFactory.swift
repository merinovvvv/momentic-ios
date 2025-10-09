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
    
    func createEnterEmailPasswordModule(with authViewModel: AuthViewModel) -> AuthViewController {
        AuthViewController(viewModel: authViewModel)
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
    
    func createMainModule() -> MainViewController {
        MainViewController()
    }
}
