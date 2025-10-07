//
//  AppCoordinator.swift
//  Momentic
//
//  Created by Yaraslau Merynau on 7.10.25.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var flowCompletionHandler: (() -> Void)?
    
    private var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let isAuth: Bool = false
        
        if isAuth {
            showMainFlow()
        } else {
            showRegistrationFlow()
        }
    }
    
    private func showRegistrationFlow() {
        let registrationCoordinator = CoordinatorFactory().createRegistrationCoordinator(navigationController: navigationController)
        childCoordinators.append(registrationCoordinator)
        registrationCoordinator.start()
    }
    
    private func showMainFlow() {
        //TODO: - go to main
    }
}
