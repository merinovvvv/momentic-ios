//
//  AppCoordinator.swift
//  Momentic
//
//  Created by Yaraslau Merynau on 7.10.25.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    
    private var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let isAuth: Bool = false
        
        if isAuth {
            showMainFlow()
        } else {
            showAuthFlow()
        }
    }
    
    private func showAuthFlow() {
        let authCoordinator = CoordinatorFactory().createAuthCoordinator(navigationController: navigationController
        )
        
        authCoordinator.flowCompletionHandler = { [weak self] authMode in
            switch authMode {
            case .signIn:
                self?.showLoginFlow()
            case .signUp:
                self?.showRegistrationFlow()
            }
        }
        
        childCoordinators.append(authCoordinator)
        authCoordinator.start()
    }
    
    private func showLoginFlow() {
        let loginCoordinator = CoordinatorFactory().createLoginCoordinator(navigationController: navigationController)
        
        loginCoordinator.flowCompletionHandler = { [weak self] in
            self?.showMainFlow()
        }
        
        childCoordinators.append(loginCoordinator)
        loginCoordinator.start()
        
    }
    
    private func showRegistrationFlow() {
        let registrationCoordinator = CoordinatorFactory().createRegistrationCoordinator(navigationController: navigationController)
        
        registrationCoordinator.flowCompletionHandler = {[weak self] in
            self?.showMainFlow()
        }
        
        childCoordinators.append(registrationCoordinator)
        registrationCoordinator.start()
    }
    
    private func showMainFlow() {
        navigationController.pushViewController(MainViewController(), animated: true)
    }
}
