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
        showEnterLoginPasswordModule()
    }
    
    private func showEnterLoginPasswordModule() {
        let authViewController = moduleFactory.createEnterEmailPasswordModule()
        
        authViewController.completionHandler = { [weak self] userInfo in
            //TODO: - add verification logic
            
            self?.showEnterCodeModule()
        }
        
        navigationController.pushViewController(authViewController, animated: true)
    }
    
    private func showEnterCodeModule() {
        let verificationCodeViewController = moduleFactory.createEnterCodeModule()
        
        verificationCodeViewController.completionHandler = { [weak self] _ in
            //TODO: - finish login
        }
        
        navigationController.pushViewController(verificationCodeViewController, animated: true)
    }
}
