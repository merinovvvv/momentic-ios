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
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showSignUpModule()
    }
    
    private func showSignUpModule() {
        
        let registerViewModel = RegisterViewModel(networkHandler: .init())
        
        let registerViewController = moduleFactory.createRegisterModule(with: registerViewModel)
        
        registerViewModel.onSuccess = { [weak self] in
            guard let email = registerViewController.viewModel.email else {
                return
            }
            self?.showEnterCodeModule(email: email)
        }
        
        registerViewController.completionHandler = { credentials in
            registerViewController.viewModel.email = credentials.email
            registerViewController.viewModel.password = credentials.password
        
            registerViewModel.submit()
        }
        
        navigationController.pushViewController(registerViewController, animated: true)
    }
    
    private func showEnterCodeModule(email: String) {
        
        let verificationCodeViewModel = VerificationCodeViewModel(email: email, networkHandler: .init(), tokenStorage: .init())
        
        let verificationCodeViewController = moduleFactory.createEnterCodeModule(with: verificationCodeViewModel)
        
        verificationCodeViewController.completionHandler = { [weak self] _ in
            self?.showProfileInfoModule()
        }
        
        navigationController.pushViewController(verificationCodeViewController, animated: true)
    }
    
    private func showProfileInfoModule() {
        
        let profileInfoViewModel = ProfileInfoViewModel(networkHandler: .init())
        
        let profileInfoViewController = moduleFactory.createProfileInfoModule(with: profileInfoViewModel)
        
        profileInfoViewController.completionHandler = { [weak self] _ in
            self?.showAddPhotoModule()
        }
        
        navigationController.pushViewController(profileInfoViewController, animated: true)
    }
    
    private func showAddPhotoModule() {
        let addPhotoViewController = moduleFactory.createAddPhotoModule()
        
        addPhotoViewController.completionHandler = { [weak self] isAdding in
            if isAdding {
                self?.showChoosePhotoModule()
            } else {
                self?.flowCompletionHandler?()
            }
        }
        
        navigationController.pushViewController(addPhotoViewController, animated: true)
    }
    
    private func showChoosePhotoModule() {
        //TODO: - showChoosePhotoModule
    }
}
