//
//  CoordinatorFactory.swift
//  Momentic
//
//  Created by Yaraslau Merynau on 7.10.25.
//

import UIKit

final class CoordinatorFactory {
    
    func createAppCoordinator(navigationController: UINavigationController) -> AppCoordinator {
        AppCoordinator(navigationController: navigationController)
    }
    
    func createRegistrationCoordinator(navigationController: UINavigationController) -> RegistrationCoordinator {
        RegistrationCoordinator(navigationController: navigationController)
    }
}
