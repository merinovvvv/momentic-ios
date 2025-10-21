//
//  AuthViewController.swift
//  Momentic
//
//  Created by Yaraslau Merynau on 29.09.25.
//

import UIKit

final class AuthViewController: UIViewController {
    
    //MARK: - Properties
    
    var completionHandler: ((UserCredentials) -> ())?
    var viewModel: AuthViewModelProtocol
    
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
        
        static let authButtonBottomSpacing: CGFloat = 40
        
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
        
        static let keyboardBottomPadding: CGFloat = 20
        
    }
    
    //MARK: - UI Properties
    
    private let scrollView: UIScrollView = UIScrollView()
    private let contentView: UIView = UIView()
    
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
        view.backgroundColor = .white
        setupUI()
        setupKeyboardObservers()
        setupTapGesture()
        setupBindings()
    }
    
    //MARK: - Init
    
    init(viewModel: AuthViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        removeKeyboardObservers()
    }
}

//MARK: - Setup Bindings

private extension AuthViewController {
    func setupBindings() {
        
        viewModel.onValidationErrors = { [weak self] errors in
            
            guard let strongSelf = self else { return }
            
            [strongSelf.emailTextField, strongSelf.passwordTextField].forEach {
                $0.resignFirstResponder()
                $0.text = ""
            }
            
            errors.forEach { error in
                switch error {
                case .invalidEmail:
                    strongSelf.showEmailError(error.localizedDescription)
                    
                case .invalidPassword:
                    strongSelf.showPasswordError(error.localizedDescription)
                default:
                    break
                }
            }
        }
        
        
        viewModel.onFailure = { [weak self] error in
            
            guard let strongSelf = self else { return }
            
            [strongSelf.emailTextField, strongSelf.passwordTextField].forEach {
                $0.resignFirstResponder()
                $0.text = ""
            }
            
            strongSelf.showAlert(title: "Error", message: error.localizedDescription)
        }
    }
    
    func showEmailError(_ message: String) {
        wrongEmailLabel.text = message
        wrongEmailLabel.isHidden = false
        
        emailTextField.layer.borderWidth = Constants.authTextFieldBorderWidth
        emailTextField.layer.borderColor = UIColor(named: "wrongInput")?.cgColor
        emailTextField.attributedPlaceholder = NSAttributedString(
            string: emailTextField.placeholder ?? "",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "wrongInput") ?? .red]
        )
    }
    
    func showPasswordError(_ message: String) {
        wrongPasswordLabel.text = message
        wrongPasswordLabel.isHidden = false
        
        passwordTextField.layer.borderWidth = Constants.authTextFieldBorderWidth
        passwordTextField.layer.borderColor = UIColor(named: "wrongInput")?.cgColor
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: passwordTextField.placeholder ?? "",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "wrongInput") ?? .red]
        )
    }
    
    func showAlert(title: String, message: String) {
        let errorAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        errorAlert.addAction(action)
        present(errorAlert, animated: true)
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
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(appIconImageView)
        contentView.addSubview(authLabel)
        contentView.addSubview(authStack)
        
        authStack.addArrangedSubview(emailStack)
        
        let emailLabelContainer = createLabelContainer(for: emailLabel)
        emailStack.addArrangedSubview(emailLabelContainer)
        emailStack.addArrangedSubview(emailTextField)
        let wrongEmailLabelContainer = createLabelContainer(for: wrongEmailLabel)
        emailStack.addArrangedSubview(wrongEmailLabelContainer)
        
        authStack.addArrangedSubview(passwordStack)
        
        let passwordLabelContainer = createLabelContainer(for: passwordLabel)
        passwordStack.addArrangedSubview(passwordLabelContainer)
        passwordStack.addArrangedSubview(passwordTextField)
        let wrongPasswordLabelContainer = createLabelContainer(for: wrongPasswordLabel)
        passwordStack.addArrangedSubview(wrongPasswordLabelContainer)
        
        contentView.addSubview(authButton)
    }
    
    func setupConstraints() {
        [scrollView, contentView, appIconImageView, authLabel, authStack, emailStack, emailLabel, emailTextField, passwordStack, passwordLabel, passwordTextField, authButton, wrongEmailLabel, wrongPasswordLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            appIconImageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: Constants.appIconImageViewTopSpacing),
            appIconImageView.widthAnchor.constraint(equalToConstant: Constants.appIconImageViewWidth),
            appIconImageView.heightAnchor.constraint(equalToConstant: Constants.appIconImageViewHeight),
            appIconImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            authLabel.topAnchor.constraint(equalTo: appIconImageView.bottomAnchor, constant: Constants.authLabelTopSpacing),
            authLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            authStack.topAnchor.constraint(equalTo: authLabel.bottomAnchor, constant: Constants.authStackTopSpacing),
            authStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.authStackHorizontalSpacing),
            authStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.authStackHorizontalSpacing),
            
            emailTextField.heightAnchor.constraint(equalToConstant: Constants.authTextFieldHeight),
            passwordTextField.heightAnchor.constraint(equalToConstant: Constants.authTextFieldHeight),
            
            authButton.topAnchor.constraint(equalTo: authStack.bottomAnchor, constant: Constants.authButtonTopSpacing),
            authButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.authButtonHorizontalSpacing),
            authButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.authButtonHorizontalSpacing),
            authButton.heightAnchor.constraint(equalToConstant: Constants.authButtonHeight),
            authButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.authButtonBottomSpacing),
        ])
    }
    
    func configureViews() {
        
        scrollView.keyboardDismissMode = .interactive
        
        appIconImageView.image = UIImage(named: "appIcon")
        
        authLabel.text = viewModel.authText
        authButton.setTitle(viewModel.authText, for: .normal)
        
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
        
        emailTextField.attributedPlaceholder = NSAttributedString(
            string: NSLocalizedString("email_textfield_placeholder", comment: "emailTextFieldPlaceholder"),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "subtitle") ?? .black]
        )
        
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: NSLocalizedString("password_textfield_placeholder", comment: "passwordTextFieldPlaceholder"),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "subtitle") ?? .black]
        )
        
        [emailTextField, passwordTextField].forEach {
            $0.backgroundColor = UIColor(named: "backgroundGray")
            $0.textColor = UIColor(named: "subtitle")
            $0.font = UIFont.systemFont(ofSize: Constants.authTextFieldPlaceholderFontSize, weight: .light)
            $0.layer.cornerRadius = Constants.authTextFieldCornerRadius
            $0.textAlignment = .left
            
            $0.isUserInteractionEnabled = true
            $0.isEnabled = true
            
            let leftPaddingView = UIView(frame: CGRect(x: .zero, y: .zero, width: Constants.authTextFieldPadding, height: .zero))
            let rightPaddingView = UIView(frame: CGRect(x: .zero, y: .zero, width: Constants.authTextFieldPadding, height: .zero))
            
            $0.leftView = leftPaddingView
            $0.leftViewMode = .always
            $0.rightView = rightPaddingView
            $0.rightViewMode = .always
            
            $0.delegate = self
        }
        
        passwordTextField.isSecureTextEntry = true
        passwordTextField.textContentType = .none
        //passwordTextField.autocorrectionType = .no
        passwordTextField.textContentType = UITextContentType(rawValue: "")
        
        emailTextField.textContentType = .none
        emailTextField.autocorrectionType = .no
        
        authButton.backgroundColor = UIColor(named: "main")
        authButton.tintColor = .white
        authButton.layer.cornerRadius = Constants.authButtonCornerRadius
        authButton.addTarget(self, action: #selector(authButtonTapped), for: .touchUpInside)
        
        [wrongEmailLabel, wrongPasswordLabel].forEach {
            $0.isHidden = true
            $0.textColor = UIColor(named: "wrongInput")
            $0.font = UIFont.systemFont(ofSize: Constants.errorLabelFontSize, weight: .light)
        }
    }
    
    private func createLabelContainer(for label: UILabel) -> UIView {
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

//MARK: - Keyboard Handling

private extension AuthViewController {
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
              let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else {
            return
        }
        
        let keyboardHeight = keyboardFrame.height
        
        UIView.animate(withDuration: duration, delay: .zero, options: UIView.AnimationOptions(rawValue: curve)) {
            self.scrollView.contentInset.bottom = keyboardHeight + Constants.keyboardBottomPadding
            self.scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight
            
            if let activeTextField = [self.emailTextField, self.passwordTextField].first(where: { $0.isFirstResponder }) {
                let textFieldFrame = activeTextField.convert(activeTextField.bounds, to: self.scrollView)
                self.scrollView.scrollRectToVisible(textFieldFrame, animated: false)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
              let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else {
            return
        }
        
        UIView.animate(withDuration: duration, delay: .zero, options: UIView.AnimationOptions(rawValue: curve)) {
            self.scrollView.contentInset.bottom = .zero
            self.scrollView.verticalScrollIndicatorInsets.bottom = .zero
        }
    }
    
    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

//MARK: - UITextFieldDelegate

extension AuthViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        [wrongEmailLabel, wrongPasswordLabel].forEach {
            $0.isHidden = true
        }
        resetAllTextFieldsToNormalState()
        
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            view.endEditing(true)
        }
        
        return false
    }
}

//MARK: - Selectors

private extension AuthViewController {
    @objc func authButtonTapped() {
        
        completionHandler?(UserCredentials(email: emailTextField.text ?? "", password: passwordTextField.text ?? ""))
    }
}

//MARK: - Helpers

private extension AuthViewController {
    private func resetAllTextFieldsToNormalState() {
        [emailTextField, passwordTextField].forEach { textField in
            textField.backgroundColor = UIColor(named: "backgroundGray")
            textField.layer.borderWidth = .zero
            textField.layer.borderColor = nil
            textField.textColor = UIColor(named: "subtitle")
            
            textField.attributedPlaceholder = NSAttributedString(
                string: textField.placeholder ?? "",
                attributes: [.foregroundColor: UIColor(named: "subtitle") ?? .black]
            )
        }
    }
}
