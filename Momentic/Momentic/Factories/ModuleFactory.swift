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
    
    func createLoginModule(with viewModel: LoginViewModel) -> AuthViewController {
        AuthViewController(viewModel: viewModel)
    }
    
    func createRegisterModule(with viewModel: RegisterViewModel) -> AuthViewController {
        AuthViewController(viewModel: viewModel)
    }

    func createEnterCodeModule(with viewModel: VerificationCodeViewModel) -> VerificationCodeViewController {
        VerificationCodeViewController(viewModel: viewModel)
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
