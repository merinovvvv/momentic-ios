//
//  AuthViewController.swift
//  Momentic
//
//  Created by Yaraslau Merynau on 29.09.25.
//

import UIKit

final class AuthViewController: UIViewController {
    
    //MARK: - Properties
    
    var authMode: AuthMode = .signUp
    
    //MARK: - Constants
    
    private enum Constants {
        
        //MARK: - Constraints
        
        static let appIconImageViewTopSpacing: CGFloat = 175
        static let appIconImageViewWidth: CGFloat = 60
        static let appIconImageViewHeight: CGFloat = 90
        
        static let authLabelTopSpacing: CGFloat = 36
        
        static let authStackTopSpacing: CGFloat = 32
        static let authStackHorizontalSpacing: CGFloat = 16
        
        static let authTextFieldHeight: CGFloat = 52
        
        static let authButtonTopSpacing: CGFloat = 40
        static let authButtonHorizontalSpacing: CGFloat = 16
        static let authButtonHeight: CGFloat = 52
        
        static let errorLabelTopSpacing: CGFloat = 4
        
        static let authInfoLabelInnerHorizontalSpacing: CGFloat = 8
        
        //MARK: - Values
        
        static let authLabelFontSize: CGFloat = 44
        
        static let authInfoLabelFontSize: CGFloat = 20
        
        static let authTextFieldCornerRadius: CGFloat = 16
        static let authTextFieldPlaceholderFontSize: CGFloat = 16
        
        static let innerStackSpacing: CGFloat = 10
        static let authStackSpacing: CGFloat = 16
        
        static let authButtonCornerRadius: CGFloat = 16
        static let authButtonFontSize: CGFloat = 16
        
        static let authTextFieldPadding: CGFloat = 20
        static let authTextFieldBorderWidth: CGFloat = 2
        
        static let errorLabelFontSize: CGFloat = 12
        
    }
    
    //MARK: - UI Properties
    
    private let appIconImageView: UIImageView = UIImageView()
    
    private let authLabel: UILabel = UILabel()
    
    private let authStack: UIStackView = UIStackView()
    
    private let emailStack: UIStackView = UIStackView()
    private let emailLabel: UILabel = UILabel()
    private let emailTextField: UITextField = UITextField()
    
    private let passwordStack: UIStackView = UIStackView()
    private let passwordLabel: UILabel = UILabel()
    private let passwordTextField: UITextField = UITextField()
    
    private let authButton: UIButton = UIButton(type: .system)
    
    private let wrongEmailLabel: UILabel = UILabel()
    private let wrongPasswordLabel: UILabel = UILabel()
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }
}

//MARK: - Setup UI
private extension AuthViewController {
    func setupUI() {
        setupViewHierarchy()
        setupConstraints()
        configureViews()
    }
    
    func setupViewHierarchy() {
        view.addSubview(appIconImageView)
        view.addSubview(authLabel)
        view.addSubview(authStack)
        
        authStack.addArrangedSubview(emailStack)
        
        let emailLabelContainer = createLabelContainer(for: emailLabel)
        emailStack.addArrangedSubview(emailLabelContainer)
        emailStack.addArrangedSubview(emailTextField)
        emailStack.addArrangedSubview(wrongEmailLabel)
        
        authStack.addArrangedSubview(passwordStack)
        
        let passwordLabelContainer = createLabelContainer(for: passwordLabel)
        passwordStack.addArrangedSubview(passwordLabelContainer)
        passwordStack.addArrangedSubview(passwordTextField)
        passwordStack.addArrangedSubview(wrongPasswordLabel)
        
        view.addSubview(authButton)
    }
    
    func setupConstraints() {
        [appIconImageView, authLabel, authStack, emailStack, emailLabel, emailTextField, passwordStack, passwordLabel, passwordTextField, authButton, wrongEmailLabel, wrongPasswordLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            appIconImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.appIconImageViewTopSpacing),
            appIconImageView.widthAnchor.constraint(equalToConstant: Constants.appIconImageViewWidth),
            appIconImageView.heightAnchor.constraint(equalToConstant: Constants.appIconImageViewHeight),
            appIconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            authLabel.topAnchor.constraint(equalTo: appIconImageView.bottomAnchor, constant: Constants.authLabelTopSpacing),
            authLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            authStack.topAnchor.constraint(equalTo: authLabel.bottomAnchor, constant: Constants.authStackTopSpacing),
            authStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.authStackHorizontalSpacing),
            authStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.authStackHorizontalSpacing),
            
            emailTextField.heightAnchor.constraint(equalToConstant: Constants.authTextFieldHeight),
            passwordTextField.heightAnchor.constraint(equalToConstant: Constants.authTextFieldHeight),
            
            authButton.topAnchor.constraint(equalTo: authStack.bottomAnchor, constant: Constants.authButtonTopSpacing),
            authButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.authButtonHorizontalSpacing),
            authButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.authButtonHorizontalSpacing),
            authButton.heightAnchor.constraint(equalToConstant: Constants.authButtonHeight),
        ])
    }
    
    func configureViews() {
        appIconImageView.image = UIImage(named: "appIcon")
        
        switch authMode {
        case .signUp:
            authLabel.text = NSLocalizedString("signup_button_text", comment: "SignUp")
            authButton.setTitle(NSLocalizedString("signup_button_text", comment: "SignUp"), for: .normal)
        case .signIn:
            authLabel.text = NSLocalizedString("signin_button_text", comment: "SignIn")
            authButton.setTitle(NSLocalizedString("signin_button_text", comment: "SignIn"), for: .normal)
        }
        
        authLabel.textColor = UIColor(named: "main")
        authLabel.font = UIFont.systemFont(ofSize: Constants.authLabelFontSize, weight: .medium)
        
        authStack.axis = .vertical
        authStack.spacing = Constants.authStackSpacing
        authStack.distribution = .fill
        authStack.alignment = .fill
        
        [emailStack, passwordStack].forEach {
            $0.axis = .vertical
            $0.spacing = Constants.innerStackSpacing
            $0.distribution = .fill
            $0.alignment = .fill
        }
        
        emailStack.setCustomSpacing(Constants.errorLabelTopSpacing, after: emailTextField)
        passwordStack.setCustomSpacing(Constants.errorLabelTopSpacing, after: passwordTextField)
        
        emailLabel.text = NSLocalizedString("email_label_text", comment: "emailLabel")
        passwordLabel.text = NSLocalizedString("password_label_text", comment: "passwordLabel")
        
        [emailLabel, passwordLabel].forEach {
            $0.font = UIFont.systemFont(ofSize: Constants.authInfoLabelFontSize, weight: .regular)
            $0.textColor = UIColor(named: "main")
            $0.textAlignment = .left
        }
        
        emailTextField.placeholder = NSLocalizedString("email_textfield_placeholder", comment: "emailTextFieldPlaceholder")
        passwordTextField.placeholder = NSLocalizedString("password_textfield_placeholder", comment: "passwordTextFieldPlaceholder")
        
        [emailTextField, passwordTextField].forEach {
            $0.backgroundColor = UIColor(named: "backgroundGray")
            $0.textColor = UIColor(named: "subtitle")
            $0.font = UIFont.systemFont(ofSize: Constants.authTextFieldPlaceholderFontSize, weight: .light)
            $0.layer.cornerRadius = Constants.authTextFieldCornerRadius
            $0.textAlignment = .left
            
            let leftPaddingView = UIView(frame: CGRect(x: .zero, y: .zero, width: Constants.authTextFieldPadding, height: .zero))
            let rightPaddingView = UIView(frame: CGRect(x: .zero, y: .zero, width: Constants.authTextFieldPadding, height: .zero))
            
            $0.leftView = leftPaddingView
            $0.leftViewMode = .always
            $0.rightView = rightPaddingView
            $0.rightViewMode = .always
            
            $0.delegate = self
        }
        
        authButton.backgroundColor = UIColor(named: "main")
        authButton.tintColor = .white
        authButton.layer.cornerRadius = Constants.authButtonCornerRadius
        authButton.addTarget(self, action: #selector(authButtonTapped), for: .touchUpInside)
        
        [wrongEmailLabel, wrongPasswordLabel].forEach {
            $0.isHidden = true
            $0.textColor = UIColor(named: "wrongInput")
            $0.font = UIFont.systemFont(ofSize: Constants.errorLabelFontSize, weight: .light)
        }
        
        wrongEmailLabel.text = NSLocalizedString("email_error_text", comment: "Wrong email format")
        wrongPasswordLabel.text = NSLocalizedString("password_error_text", comment: "Wrong password format")
    }
}

//MARK: - UITextFieldDelegate

extension AuthViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        [wrongEmailLabel, wrongPasswordLabel].forEach { $0.isHidden = true }
        
        textField.backgroundColor = .white
        textField.layer.borderColor = UIColor(named: "subtitle")?.cgColor
        textField.layer.borderWidth = Constants.authTextFieldBorderWidth
        textField.textColor = UIColor(named: "main")
        
        textField.attributedPlaceholder = NSAttributedString(
            string: textField.placeholder ?? "",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "main") ?? .black]
        )
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        textField.backgroundColor = UIColor(named: "backgroundGray")
        textField.layer.borderColor = .none
        textField.layer.borderWidth = .zero
        textField.textColor = UIColor(named: "subtitle")
        
        textField.attributedPlaceholder = NSAttributedString(
            string: textField.placeholder ?? "",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "subtitle") ?? .black]
        )
    }
}

//MARK: - Selectors

private extension AuthViewController {
    @objc func authButtonTapped() {
        //TODO: - add logic
        
        [emailTextField, passwordTextField].forEach {
            
            $0.resignFirstResponder()
            
            $0.text = ""
            
            $0.layer.borderWidth = Constants.authTextFieldBorderWidth
            $0.layer.borderColor = UIColor(named: "wrongInput")?.cgColor
            $0.attributedPlaceholder = NSAttributedString(
                string: $0.placeholder ?? "",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "wrongInput") ?? .red]
            )
        }
        
        [wrongEmailLabel, wrongPasswordLabel].forEach { $0.isHidden = false }
    }
}

private extension AuthViewController {
    func createLabelContainer(for label: UILabel) -> UIView {
        let container = UIView()
        container.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: container.topAnchor),
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: Constants.authInfoLabelInnerHorizontalSpacing),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        return container
    }
}
