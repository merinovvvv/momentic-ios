//
//  AuthCoordinator.swift
//  Momentic
//
//  Created by Yaraslau Merynau on 7.10.25.
//

import UIKit

final class AuthCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    
    var flowCompletionHandler: ((AuthMode) -> Void)?
    
    private let moduleFactory: ModuleFactory = ModuleFactory()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showWelcomeModule()
    }
    
    private func showWelcomeModule() {
        let welcomeViewController = moduleFactory.createWelcomeModule()
        
        welcomeViewController.completionHandler = { [weak self] authMode in
            self?.flowCompletionHandler?(authMode)
        }
        
        navigationController.pushViewController(welcomeViewController, animated: true)
    }
}
