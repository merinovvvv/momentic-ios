//
//  VerificationCodeViewController.swift
//  Momentic
//
//  Created by Yaraslau Merynau on 29.09.25.
//

import UIKit

final class VerificationCodeViewController: UIViewController, FlowController {
    
    //MARK: - FlowController
    var completionHandler: ((()) -> ())?
    
    //MARK: - Properties
    
    var viewModel: VerificationCodeViewModel
    
    //MARK: - Constants
    
    private enum Constants {
        
        //MARK: - Constraints
        
        static let enterCodeLabelTopSpacing: CGFloat = 288
        static let enterCodeLabelHorizontalSpacing: CGFloat = 16
        
        static let explanationLabelTopSpacing: CGFloat = 8
        static let explanationLabelLeadingSpacing: CGFloat = 16
        static let explanationLabelTrailingSpacing: CGFloat = 100
        
        static let codeInputViewTopSpacing: CGFloat = 24
        static let codeInputViewHorizontalSpacing: CGFloat = 16
        
        static let sendAgainButtonTopSpacing: CGFloat = 16
        static let sendAgainButtonLeadingSpacing: CGFloat = 20
        static let sendAgainButtonTrailingSpacing: CGFloat = 16
        static let sendAgainButtonBottomSpacing: CGFloat = 20
        
        //MARK: - Values
        
        static let enterCodeLabelFontSize: CGFloat = 44
        
        static let explanationLabelFontSize: CGFloat = 16
        
        static let sendAgainButtonFontSize: CGFloat = 16
        
        static let animationDuration: TimeInterval = 0.3
        static let contentOffsetWhenKeyboardShown: CGFloat = 300
    }
    
    //MARK: - UI Properties
    
    private let scrollView: UIScrollView = UIScrollView()
    private let contentView: UIView = UIView()
    
    private let enterCodeLabel: UILabel = UILabel()
    
    private let explanationLabel: UILabel = UILabel()
    
    private let codeInputView: CodeInputView = CodeInputView(frame: .zero)
    
    private let sendAgainButton: UIButton = UIButton(type: .system)
    
    //MARK: - Private Methods
    
    private func setupCodeInputCallbacks() {
        codeInputView.onCodeComplete = { [weak self] code in
            self?.verifyCode(code)
        }
    }
    
    private func verifyCode(_ code: String) {
        
        //TODO: - Replace with actual verification logic
        
        let isCorrect = code == "12345"
        
        if isCorrect {
            handleSuccess()
        } else {
            handleError()
        }
    }
    
    private func handleSuccess() {
        codeInputView.showSuccess()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.completionHandler?(())
        }
    }
    
    private func handleError() {
        codeInputView.showError()
    }
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupKeyboardObservers()
        setupTapGesture()
        setupCodeInputCallbacks()
    }
    
    //MARK: - Init
    
    init(viewModel: VerificationCodeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Deinit
    
    deinit {
        removeKeyboardObservers()
    }
}

//MARK: - Setup UI
private extension VerificationCodeViewController {
    func setupUI() {
        setupViewHierarchy()
        setupConstraints()
        configureViews()
    }
    
    func setupViewHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [enterCodeLabel, explanationLabel, codeInputView, sendAgainButton].forEach { contentView.addSubview($0) }
    }
    
    func setupConstraints() {
        [scrollView, contentView, enterCodeLabel, explanationLabel, codeInputView, sendAgainButton].forEach {
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
            
            enterCodeLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: Constants.enterCodeLabelTopSpacing),
            enterCodeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.enterCodeLabelHorizontalSpacing),
            enterCodeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.enterCodeLabelHorizontalSpacing),
            
            explanationLabel.topAnchor.constraint(equalTo: enterCodeLabel.bottomAnchor, constant: Constants.explanationLabelTopSpacing),
            explanationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.explanationLabelLeadingSpacing),
            explanationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.explanationLabelTrailingSpacing),
            
            codeInputView.topAnchor.constraint(equalTo: explanationLabel.bottomAnchor, constant: Constants.codeInputViewTopSpacing),
            codeInputView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.codeInputViewHorizontalSpacing),
            codeInputView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.codeInputViewHorizontalSpacing),
            
            sendAgainButton.topAnchor.constraint(equalTo: codeInputView.bottomAnchor, constant: Constants.sendAgainButtonTopSpacing),
            sendAgainButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.sendAgainButtonLeadingSpacing),
            sendAgainButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.sendAgainButtonTrailingSpacing),
            sendAgainButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.sendAgainButtonBottomSpacing),
        ])
    }
    
    func configureViews() {
        scrollView.keyboardDismissMode = .interactive
        scrollView.showsVerticalScrollIndicator = false
        
        enterCodeLabel.text = NSLocalizedString("enter_code_text", comment: "Enter code")
        enterCodeLabel.textColor = UIColor(named: "main")
        enterCodeLabel.textAlignment = .left
        enterCodeLabel.font = UIFont.systemFont(ofSize: Constants.enterCodeLabelFontSize, weight: .medium)
        
        explanationLabel.text = NSLocalizedString("enter_code_explanation_text", comment: "Enter code explanation text")
        explanationLabel.textColor = UIColor(named: "subtitle")
        explanationLabel.textAlignment = .left
        explanationLabel.numberOfLines = .zero
        explanationLabel.font = UIFont.systemFont(ofSize: Constants.explanationLabelFontSize, weight: .light)
        
        sendAgainButton.setTitle(NSLocalizedString("send_again_button_text", comment: "Send again"), for: .normal)
        sendAgainButton.backgroundColor = .clear
        sendAgainButton.tintColor = UIColor(named: "lightGreen")
        sendAgainButton.contentHorizontalAlignment = .leading
    }
    
    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
}

//MARK: - Keyboard Handling
private extension VerificationCodeViewController {
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
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
            return
        }
        
        let keyboardHeight = keyboardFrame.height
        let contentInsets = UIEdgeInsets(top: .zero, left: .zero, bottom: keyboardHeight, right: .zero)
        
        UIView.animate(withDuration: duration) {
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
            
            let codeInputFrame = self.codeInputView.convert(self.codeInputView.bounds, to: self.scrollView)
            let targetY = codeInputFrame.origin.y - Constants.contentOffsetWhenKeyboardShown
            self.scrollView.setContentOffset(CGPoint(x: .zero, y: targetY), animated: false)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
            return
        }
        
        UIView.animate(withDuration: duration) {
            self.scrollView.contentInset = .zero
            self.scrollView.scrollIndicatorInsets = .zero
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
