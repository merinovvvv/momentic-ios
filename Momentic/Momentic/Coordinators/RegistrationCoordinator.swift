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
            guard let email = registerViewController.viewModel.email,
                  let password = registerViewController.viewModel.password else {
                return
            }
            self?.showEnterCodeModule(email: email, password: password)
        }
        
        registerViewController.completionHandler = { credentials in
            registerViewController.viewModel.email = credentials.email
            registerViewController.viewModel.password = credentials.password
            
            registerViewModel.submit()
        }
        
        navigationController.pushViewController(registerViewController, animated: true)
    }
    
    private func showEnterCodeModule(email: String, password: String) {
        
        let verificationCodeViewModel = VerificationCodeViewModel(email: email, password: password, networkHandler: .init(), tokenStorage: .init())
        
        let verificationCodeViewController = moduleFactory.createEnterCodeModule(with: verificationCodeViewModel)
        
        verificationCodeViewController.completionHandler = { [weak self] _ in
            self?.showProfileInfoModule()
        }
        
        navigationController.pushViewController(verificationCodeViewController, animated: true)
    }
    
    private func showProfileInfoModule() {
        
        let profileInfoViewModel = ProfileInfoViewModel(networkHandler: .init(), tokenStorage: .init())
        
        let profileInfoViewController = moduleFactory.createProfileInfoModule(with: profileInfoViewModel)
        
        profileInfoViewController.completionHandler = { [weak self] _ in
            self?.showAddPhotoModule()
        }
        
        navigationController.pushViewController(profileInfoViewController, animated: true)
    }
    
    private func showAddPhotoModule() {
        let addPhotoViewModel = AddPhotoViewModel()
        let addPhotoViewController = moduleFactory.createAddPhotoModule(with: addPhotoViewModel)
        
        addPhotoViewController.completionHandler = { [weak self] shouldAddPhoto in
            if shouldAddPhoto {
                self?.showChoosePhotoModule(addPhotoViewController: addPhotoViewController)
            } else {
                self?.flowCompletionHandler?()
            }
        }
        
        navigationController.pushViewController(addPhotoViewController, animated: true)
    }
    
    private func showChoosePhotoModule(addPhotoViewController: AddPhotoViewController) {
        let choosePhotoViewController = moduleFactory.createChoosePhotoModule()
        
        choosePhotoViewController.completionHandler = { [weak self] result in
            switch result {
            case .success(let image):
                addPhotoViewController.handleSelectedPhoto(image)
            case .failure(let error):
                print("Photo selection error: \(error.localizedDescription)")
                self?.flowCompletionHandler?()
            }
        }
        choosePhotoViewController.modalPresentationStyle = .fullScreen
        navigationController.present(choosePhotoViewController, animated: true)
    }
}
