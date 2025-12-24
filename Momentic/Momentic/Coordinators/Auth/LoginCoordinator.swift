//
//  LoginCoordinator.swift
//  Momentic
//
//  Created by Yaraslau Merynau on 7.10.25.
//

import UIKit

final class LoginCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var flowCompletionHandler: (() -> Void)?
    
    private let moduleFactory: ModuleFactory = ModuleFactory()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showSignInModule()
    }
    
    private func showSignInModule() {
        
        let loginViewModel = LoginViewModel(networkHandler: NetworkHandler(), tokenStorage: AccessTokenStorage())
        
        let loginViewController = moduleFactory.createLoginModule(with: loginViewModel)
        
        loginViewModel.onSuccess = { [weak self] in
            guard let email = loginViewController.viewModel.email,
            let password = loginViewController.viewModel.password else {
                return
            }
            self?.flowCompletionHandler?()
            //self?.showEnterCodeModule(email: email, password: password)
        }
        
        loginViewController.completionHandler = { (credentials: UserCredentials) in
            
            loginViewController.viewModel.email = credentials.email
            loginViewController.viewModel.password = credentials.password
            
            loginViewController.viewModel.submit()
        }
        
        navigationController.pushViewController(loginViewController, animated: true)
    }
    
//    private func showEnterCodeModule(email: String, password: String) {
//        let verificationCodeViewModel = VerificationCodeViewModel(email: email, password: password, networkHandler: NetworkHandler(), tokenStorage: AccessTokenStorage())
//        
//        let verificationCodeViewController = moduleFactory.createEnterCodeModule(with: verificationCodeViewModel)
//        
//        verificationCodeViewController.completionHandler = { [weak self] (_: Void) in
//            //TODO: - finish login
//            self?.flowCompletionHandler?()
//        }
//        
//        navigationController.pushViewController(verificationCodeViewController, animated: true)
//    }
}
