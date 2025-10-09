//
//  CoordinatorFactory.swift
//  Momentic
//
//  Created by Yaraslau Merynau on 7.10.25.
//

import UIKit

final class CoordinatorFactory {
    
    func createAuthCoordinator(navigationController: UINavigationController) -> AuthCoordinator {
        AuthCoordinator(navigationController: navigationController)
    }
    
    func createAppCoordinator(navigationController: UINavigationController) -> AppCoordinator {
        AppCoordinator(navigationController: navigationController)
    }
    
    func createRegistrationCoordinator(navigationController: UINavigationController) -> RegistrationCoordinator {
        RegistrationCoordinator(navigationController: navigationController)
    }
    
    func createLoginCoordinator(navigationController: UINavigationController) -> LoginCoordinator {
        LoginCoordinator(navigationController: navigationController)
    }
}
