//
//  RegistrationCoordinator.swift
//  Momentic
//
//  Created by Yaraslau Merynau on 7.10.25.
//

import UIKit

final class RegistrationCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    
    var flowCompletionHandler: (() -> Void)?
    
    private let moduleFactory: ModuleFactory = ModuleFactory()
    private var userData: UserData = UserData(email: nil, password: nil, name: nil, surname: nil, bio: nil)
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showSignUpModule()
    }
    
    private func showSignUpModule() {
        
        let authViewModel = AuthViewModel(authMode: .signUp)
        
        let authViewController = moduleFactory.createEnterEmailPasswordModule(with: authViewModel)
        
        authViewController.completionHandler = { [weak self] userInfo in
            self?.userData.email = userInfo[0]
            self?.userData.password = userInfo[1]
            
            self?.showEnterCodeModule()
        }
        
        navigationController.pushViewController(authViewController, animated: true)
    }
    
    private func showEnterCodeModule() {
        let verificationCodeViewController = moduleFactory.createEnterCodeModule()
        
        verificationCodeViewController.completionHandler = { [weak self] _ in
            self?.showProfileInfoModule()
        }
        
        navigationController.pushViewController(verificationCodeViewController, animated: true)
    }
    
    private func showProfileInfoModule() {
        let profileInfoViewController = moduleFactory.createProfileInfoModule()
        
        profileInfoViewController.completionHandler = { [weak self] userInfo in
            self?.userData.name = userInfo[0]
            self?.userData.surname = userInfo[1]
            self?.userData.bio = userInfo[2]
            
            self?.showAddPhotoModule()
        }
        
        navigationController.pushViewController(profileInfoViewController, animated: true)
    }
    
    private func showAddPhotoModule() {
        let addPhotoViewController = moduleFactory.createAddPhotoModule()
        
        addPhotoViewController.completionHandler = { [weak self] _ in
            self?.showChoosePhotoModule()
        }
        
        navigationController.pushViewController(addPhotoViewController, animated: true)
    }
    
    private func showChoosePhotoModule() {
        //TODO: - showChoosePhotoModule
    }
}
