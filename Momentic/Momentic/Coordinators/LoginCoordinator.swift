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
        
        let loginViewModel = LoginViewModel(networkHandler: .init(), tokenStorage: .init())
        
        loginViewModel.onSuccess = { [weak self] in
            self?.showEnterCodeModule()
        }
        
        let loginViewController = moduleFactory.createLoginModule(with: loginViewModel)
        
        loginViewController.completionHandler = { credentials in
            
            loginViewController.viewModel.email = credentials.email
            loginViewController.viewModel.password = credentials.password
            
            loginViewController.viewModel.submit()
        }
        
        navigationController.pushViewController(loginViewController, animated: true)
    }
    
    private func showEnterCodeModule() {
        let verificationCodeViewController = moduleFactory.createEnterCodeModule()
        
        verificationCodeViewController.completionHandler = { [weak self] _ in
            //TODO: - finish login
            self?.flowCompletionHandler?()
        }
        
        navigationController.pushViewController(verificationCodeViewController, animated: true)
    }
}
