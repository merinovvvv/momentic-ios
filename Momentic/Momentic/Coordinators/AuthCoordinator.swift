//
//  AuthCoordinator.swift
//  Momentic
//
//  Created by Yaraslau Merynau on 7.10.25.
//

import UIKit

final class AuthCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var flowCompletionHandler: (() -> Void)?
    
    private let moduleFactory: ModuleFactory = ModuleFactory()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let welcomeViewController = moduleFactory.createWelcomeModule()
        
        welcomeViewController.completionHandler = { [weak self] _ in
            self?.a()
        }
        
        navigationController.pushViewController(welcomeViewController, animated: true)
    }
    
    func a() {}
    
}
