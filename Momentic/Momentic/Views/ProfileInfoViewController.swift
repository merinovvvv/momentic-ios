//
//  ProfileInfoViewController.swift
//  Momentic
//
//  Created by Yaraslau Merynau on 30.09.25.
//

import UIKit

final class ProfileInfoViewController: UIViewController {
    
    //MARK: - Properties
    
    //MARK: - Constants
    
    private enum Constants {
        
        //MARK: - Constraints
        
        static let profileInfoLabelTopSpacing: CGFloat = 192
        static let profileInfoLabelHorizontalSpacing: CGFloat = 16
        
        static let profileInfoStackTopSpacing: CGFloat = 32
        static let profileInfoStackHorizontalSpacing: CGFloat = 16
        
        static let signUpButtonTopSpacing: CGFloat = 60
        static let signUpButtonHorizontalSpacing: CGFloat = 16
        static let signUpButtonHeight: CGFloat = 52
        
        static let nameTextFieldHeight: CGFloat = 52
        
        static let bioTextFieldHeight: CGFloat = 112
        
        //MARK: - Values
        
        static let profileInfoLabelFontSize: CGFloat = 44
        
        static let labelFontSize: CGFloat = 20
        
        static let textFieldFontSize: CGFloat = 16
        static let textFieldCornerRadius: CGFloat = 16
        static let textFieldContentPadding: CGFloat = 20
        
        static let signUpButtonTitleFontSize: CGFloat = 16
        static let signUpButtonCornerRadius: CGFloat = 16
        
        static let innerStackSpacing: CGFloat = 10
        static let profileStackSpacing: CGFloat = 36
        
        static let nameLabelInnerHorizontalSpacing: CGFloat = 8
        
    }
    
    //MARK: - UI Properties
    
    private let profileInfoLabel: UILabel = UILabel()
    
    private let profileInfoStack: UIStackView = UIStackView()
    private let fullNameStack: UIStackView = UIStackView()
    
    private let nameStack: UIStackView = UIStackView()
    private let nameLabel: UILabel = UILabel()
    private let nameTextField: UITextField = UITextField()
    
    private let surnameStack: UIStackView = UIStackView()
    private let surnameLabel: UILabel = UILabel()
    private let surnameTextField: UITextField = UITextField()
    
    private let bioStack: UIStackView = UIStackView()
    private let bioLabel: UILabel = UILabel()
    private let bioTextView: PaddedTextView = PaddedTextView()
    
    private let signUpButton: UIButton = UIButton(type: .system)
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }
}

//MARK: - Setup UI
private extension ProfileInfoViewController {
    func setupUI() {
        setupViewHierarchy()
        setupConstraints()
        configureViews()
    }
    
    func setupViewHierarchy() {
        [profileInfoLabel, profileInfoStack, signUpButton].forEach { view.addSubview($0) }
        
        profileInfoStack.addArrangedSubview(fullNameStack)
        
        fullNameStack.addArrangedSubview(nameStack)
        fullNameStack.addArrangedSubview(surnameStack)
        
        profileInfoStack.addArrangedSubview(bioStack)
        
        let nameLabelContainer = createLabelContainer(for: nameLabel)
        nameStack.addArrangedSubview(nameLabelContainer)
        nameStack.addArrangedSubview(nameTextField)
        
        let surnameLabelContainer = createLabelContainer(for: surnameLabel)
        surnameStack.addArrangedSubview(surnameLabelContainer)
        surnameStack.addArrangedSubview(surnameTextField)
        
        let bioLabelContainer = createLabelContainer(for: bioLabel)
        bioStack.addArrangedSubview(bioLabelContainer)
        bioStack.addArrangedSubview(bioTextView)
    }
    
    func setupConstraints() {
        [profileInfoLabel, profileInfoStack, signUpButton, nameTextField, surnameTextField, bioTextView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            profileInfoLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.profileInfoLabelTopSpacing),
            profileInfoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.profileInfoLabelHorizontalSpacing),
            profileInfoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.profileInfoLabelHorizontalSpacing),
            
            profileInfoStack.topAnchor.constraint(equalTo: profileInfoLabel.bottomAnchor, constant: Constants.profileInfoStackTopSpacing),
            profileInfoStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.profileInfoStackHorizontalSpacing),
            profileInfoStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.profileInfoStackHorizontalSpacing),
            
            signUpButton.topAnchor.constraint(equalTo: profileInfoStack.bottomAnchor, constant: Constants.signUpButtonTopSpacing),
            signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.signUpButtonHorizontalSpacing),
            signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.signUpButtonHorizontalSpacing),
            signUpButton.heightAnchor.constraint(equalToConstant: Constants.signUpButtonHeight),
            
            nameTextField.heightAnchor.constraint(equalToConstant: Constants.nameTextFieldHeight),
            surnameTextField.heightAnchor.constraint(equalToConstant: Constants.nameTextFieldHeight),
            
            bioTextView.heightAnchor.constraint(equalToConstant: Constants.bioTextFieldHeight)
        ])
    }
    
    func configureViews() {
        profileInfoLabel.text = NSLocalizedString("profile_info_label", comment: "Profile info label")
        profileInfoLabel.textColor = UIColor(named: "main")
        profileInfoLabel.textAlignment = .left
        profileInfoLabel.font = UIFont.systemFont(ofSize: Constants.profileInfoLabelFontSize, weight: .medium)
        
        nameLabel.text = NSLocalizedString("name_label", comment: "Name")
        surnameLabel.text = NSLocalizedString("surname_label", comment: "Surname")
        bioLabel.text = NSLocalizedString("bio_label", comment: "Bio")
        
        [nameLabel, surnameLabel, bioLabel].forEach {
            $0.textColor = UIColor(named: "main")
            $0.textAlignment = .left
            $0.font = UIFont.systemFont(ofSize: Constants.labelFontSize, weight: .regular)
        }
        
        nameTextField.placeholder = NSLocalizedString("name_textfield_placeholder", comment: "Name placeholder")
        surnameTextField.placeholder = NSLocalizedString("surname_textfield_placeholder", comment: "Surame placeholder")
    
        [nameTextField, surnameTextField].forEach {
            $0.textColor = UIColor(named: "main")
            $0.font = UIFont.systemFont(ofSize: Constants.textFieldFontSize, weight: .light)
            $0.backgroundColor = UIColor(named: "backgroundGray")
            $0.layer.cornerRadius = Constants.textFieldCornerRadius
            $0.textAlignment = .left
            
            
            let leftView = UIView(frame: CGRect(x: .zero, y: .zero, width: Constants.textFieldContentPadding, height: .zero))
            let rightView = UIView(frame: CGRect(x: .zero, y: .zero, width: Constants.textFieldContentPadding, height: .zero))
            
            $0.leftView = leftView
            $0.leftViewMode = .always
            $0.rightView = rightView
            $0.rightViewMode = .always
            
            $0.attributedPlaceholder = NSAttributedString(
                string: $0.placeholder ?? "",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "subtitle") ?? .black]
            )
        }
        
        bioTextView.textColor = UIColor(named: "main")
        bioTextView.textAlignment = .left
        bioTextView.font = UIFont.systemFont(ofSize: Constants.textFieldFontSize, weight: .light)
        bioTextView.backgroundColor = UIColor(named: "backgroundGray")
        bioTextView.layer.cornerRadius = Constants.textFieldCornerRadius
        bioTextView.placeholder = NSLocalizedString("bio_textview_placeholder", comment: "Bio TextView placeholder")
        
        [nameStack, surnameStack, bioStack].forEach {
            $0.axis = .vertical
            $0.spacing = Constants.innerStackSpacing
            $0.alignment = .fill
            $0.distribution = .fill
        }
        
        fullNameStack.axis = .horizontal
        fullNameStack.spacing = Constants.innerStackSpacing
        fullNameStack.alignment = .fill
        fullNameStack.distribution = .fillEqually
        
        profileInfoStack.axis = .vertical
        profileInfoStack.spacing = Constants.profileStackSpacing
        profileInfoStack.alignment = .fill
        profileInfoStack.distribution = .fill
        
        signUpButton.setTitle(NSLocalizedString("signup_button_text", comment: "SignUp"), for: .normal)
        signUpButton.tintColor = .white
        signUpButton.backgroundColor = UIColor(named: "main")
        signUpButton.layer.cornerRadius = Constants.signUpButtonCornerRadius
        signUpButton.titleLabel?.font = UIFont.systemFont(ofSize: Constants.signUpButtonTitleFontSize, weight: .medium)
    }
}

private extension ProfileInfoViewController {
    func createLabelContainer(for label: UILabel) -> UIView {
        let container = UIView()
        container.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: container.topAnchor),
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: Constants.nameLabelInnerHorizontalSpacing),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        return container
    }
}
