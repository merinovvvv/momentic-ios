//
//  VerificationCodeViewController.swift
//  Momentic
//
//  Created by Yaraslau Merynau on 29.09.25.
//

import UIKit

final class VerificationCodeViewController: UIViewController {
    
    //MARK: - Properties
    
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
        
        //MARK: - Values
        
        static let enterCodeLabelFontSize: CGFloat = 44
        
        static let explanationLabelFontSize: CGFloat = 16
        
        static let sendAgainButtonFontSize: CGFloat = 16
        
    }
    
    //MARK: - UI Properties
    
    private let enterCodeLabel: UILabel = UILabel()
    
    private let explanationLabel: UILabel = UILabel()
    
    private let codeInputView: CodeInputView = CodeInputView(frame: .zero)
    
    private let sendAgainButton: UIButton = UIButton(type: .system)
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
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
        [enterCodeLabel, explanationLabel, codeInputView, sendAgainButton].forEach { view.addSubview($0) }
    }
    
    func setupConstraints() {
        [enterCodeLabel, explanationLabel, codeInputView, sendAgainButton].forEach { $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            enterCodeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.enterCodeLabelTopSpacing),
            enterCodeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.enterCodeLabelHorizontalSpacing),
            enterCodeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.enterCodeLabelHorizontalSpacing),
            
            explanationLabel.topAnchor.constraint(equalTo: enterCodeLabel.bottomAnchor, constant: Constants.explanationLabelTopSpacing),
            explanationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.explanationLabelLeadingSpacing),
            explanationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.explanationLabelTrailingSpacing),
            
            codeInputView.topAnchor.constraint(equalTo: explanationLabel.bottomAnchor, constant: Constants.codeInputViewTopSpacing),
            codeInputView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.codeInputViewHorizontalSpacing),
            codeInputView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.codeInputViewHorizontalSpacing),
            
            sendAgainButton.topAnchor.constraint(equalTo: codeInputView.bottomAnchor, constant: Constants.sendAgainButtonTopSpacing),
            sendAgainButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.sendAgainButtonLeadingSpacing),
            sendAgainButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.sendAgainButtonTrailingSpacing),
        ])
    }
    
    func configureViews() {
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
}
