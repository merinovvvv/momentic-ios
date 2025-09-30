//
//  ViewController.swift
//  Momentic
//
//  Created by Yaraslau Merynau on 25.09.25.
//

import UIKit

final class WelcomeViewController: UIViewController {
    
    //MARK: - Constants
    
    private enum Constants {
        
        //MARK: - Constraints
        
        static let topImageViewTopSpacing: CGFloat = 112
        static let topImageViewWidth: CGFloat = 80
        static let topImageViewHeight: CGFloat = 128
        
        static let appIconImageViewTopSpacing: CGFloat = 56
        static let appIconImageViewWidth: CGFloat = 72
        static let appIconImageViewHeight: CGFloat = 110
        
        static let leftImageViewTopSpacing: CGFloat = 12
        static let leftImageViewLeadingSpacing: CGFloat = 25
        static let leftImageViewWidth: CGFloat = 90
        static let leftImageViewHeight: CGFloat = 144
        
        static let rightImageViewTopSpacing: CGFloat = 54
        static let rightImageViewTrailingSpacing: CGFloat = 25
        static let rightImageViewWidth: CGFloat = 100
        static let rightImageViewHeight: CGFloat = 160
        
        static let welcomeTitleLabelTopSpacing: CGFloat = 100
        static let welcomeSubtitleLabelTopSpacing: CGFloat = 8
        static let welcomeSubtitleHorizontalSpacing: CGFloat = 25
        
        static let signUpButtonHeight: CGFloat = 52
        
        static let signStackTopSpacing: CGFloat = 40
        static let signStackHorizontalSpacing: CGFloat = 25
        
        
        //MARK: - Values
        
        static let topImageViewRotateAngle: CGFloat = 10 * .pi / 180
        
        static let leftImageViewRotateAngle: CGFloat = 15 * .pi / 180
        
        static let rightImageViewRotateAngle: CGFloat = -10 * .pi / 180
        
        static let welcomeTitleLabelFontSize: CGFloat = 44
        
        static let welcomeSubtitleLabelFontSize: CGFloat = 16
        
        static let signUpButtonFontSize: CGFloat = 16
        static let signUpButtonCornerRadius: CGFloat = 16
        
        static let signInButtonFontSize: CGFloat = 12
        
        static let signStackSpacing: CGFloat = 8
    }
    
    //MARK: - UI Properties
    
    private let backgroundImageView: UIImageView = UIImageView()
    
    private let appIconImageView: UIImageView = UIImageView()
    
    private let topImageContainerView: UIView = UIView()
    private let topImageView: UIImageView = UIImageView()
    
    private let leftImageContainerView: UIView = UIView()
    private let leftImageView: UIImageView = UIImageView()
    
    private let rightImageContainerView: UIView = UIView()
    private let rightImageView: UIImageView = UIImageView()
    
    private let welcomeTitleLabel: UILabel = UILabel()
    private let welcomeSubtitleLabel: UILabel = UILabel()
    
    private let signStack: UIStackView = UIStackView()
    private let signUpButton: UIButton = UIButton(type: .system)
    private let signInButton: UIButton = UIButton(type: .system)
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        topImageView.transform = CGAffineTransformMakeRotation( Constants.topImageViewRotateAngle)
        leftImageView.transform = CGAffineTransformMakeRotation( Constants.leftImageViewRotateAngle)
        rightImageView.transform = CGAffineTransformMakeRotation( Constants.rightImageViewRotateAngle)
    }
}

//MARK: - Setup UI
private extension WelcomeViewController {
    func setupUI() {
        setupViewHierarchy()
        setupConstraints()
        configureViews()
    }
    
    func setupViewHierarchy() {
        [backgroundImageView, appIconImageView, topImageContainerView, leftImageContainerView, rightImageContainerView, welcomeTitleLabel, welcomeSubtitleLabel, signStack].forEach { view.addSubview($0) }
        topImageContainerView.addSubview(topImageView)
        leftImageContainerView.addSubview(leftImageView)
        rightImageContainerView.addSubview(rightImageView)
        signStack.addArrangedSubview(signUpButton)
        signStack.addArrangedSubview(signInButton)
    }
    
    func setupConstraints() {
        [backgroundImageView, appIconImageView, topImageContainerView, topImageView, leftImageContainerView, leftImageView, rightImageContainerView, rightImageView, welcomeTitleLabel, welcomeSubtitleLabel, signStack, signUpButton, signInButton].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            topImageView.centerXAnchor.constraint(equalTo: topImageContainerView.centerXAnchor),
            topImageView.centerYAnchor.constraint(equalTo: topImageContainerView.centerYAnchor),
            topImageView.widthAnchor.constraint(equalToConstant: Constants.topImageViewWidth),
            topImageView.heightAnchor.constraint(equalToConstant: Constants.topImageViewHeight),
            
            leftImageView.centerXAnchor.constraint(equalTo: leftImageContainerView.centerXAnchor),
            leftImageView.centerYAnchor.constraint(equalTo: leftImageContainerView.centerYAnchor),
            leftImageView.widthAnchor.constraint(equalToConstant: Constants.leftImageViewWidth),
            leftImageView.heightAnchor.constraint(equalToConstant: Constants.leftImageViewHeight),
            
            rightImageView.centerXAnchor.constraint(equalTo: rightImageContainerView.centerXAnchor),
            rightImageView.centerYAnchor.constraint(equalTo: rightImageContainerView.centerYAnchor),
            rightImageView.widthAnchor.constraint(equalToConstant: Constants.rightImageViewWidth),
            rightImageView.heightAnchor.constraint(equalToConstant: Constants.rightImageViewHeight),
            
            topImageContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            topImageContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.topImageViewTopSpacing),
            
            
            appIconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appIconImageView.topAnchor.constraint(equalTo: topImageContainerView.bottomAnchor, constant: Constants.appIconImageViewTopSpacing),
            appIconImageView.widthAnchor.constraint(equalToConstant: Constants.appIconImageViewWidth),
            appIconImageView.heightAnchor.constraint(equalToConstant: Constants.appIconImageViewHeight),
            
            leftImageContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.leftImageViewLeadingSpacing),
            leftImageContainerView.topAnchor.constraint(equalTo: topImageContainerView.bottomAnchor, constant: Constants.leftImageViewTopSpacing),
            
            rightImageContainerView.topAnchor.constraint(equalTo: topImageContainerView.bottomAnchor, constant: Constants.rightImageViewTopSpacing),
            rightImageContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.rightImageViewTrailingSpacing),
            
            welcomeTitleLabel.topAnchor.constraint(equalTo: appIconImageView.bottomAnchor, constant: Constants.welcomeTitleLabelTopSpacing),
            welcomeTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            welcomeSubtitleLabel.topAnchor.constraint(equalTo: welcomeTitleLabel.bottomAnchor, constant: Constants.welcomeSubtitleLabelTopSpacing),
            welcomeSubtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeSubtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.welcomeSubtitleHorizontalSpacing),
            welcomeSubtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.welcomeSubtitleHorizontalSpacing),
            
            signStack.topAnchor.constraint(equalTo: welcomeSubtitleLabel.bottomAnchor, constant: Constants.signStackTopSpacing),
            signStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.signStackHorizontalSpacing),
            signStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.signStackHorizontalSpacing),
            
            signUpButton.heightAnchor.constraint(equalToConstant: Constants.signUpButtonHeight),
            
        ])
        
        setupContainerSizes()
    }
    
    private func setupContainerSizes() {
        let topContainerSize = calculateRotatedSize(
            width: Constants.topImageViewWidth,
            height: Constants.topImageViewHeight,
            angle: Constants.topImageViewRotateAngle
        )
        
        let leftContainerSize = calculateRotatedSize(
            width: Constants.leftImageViewWidth,
            height: Constants.leftImageViewHeight,
            angle: Constants.leftImageViewRotateAngle
        )
        
        let rightContainerSize = calculateRotatedSize(
            width: Constants.rightImageViewWidth,
            height: Constants.rightImageViewHeight,
            angle: Constants.rightImageViewRotateAngle
        )
        
        NSLayoutConstraint.activate([
            topImageContainerView.widthAnchor.constraint(equalToConstant: topContainerSize.width),
            topImageContainerView.heightAnchor.constraint(equalToConstant: topContainerSize.height),
            
            leftImageContainerView.widthAnchor.constraint(equalToConstant: leftContainerSize.width),
            leftImageContainerView.heightAnchor.constraint(equalToConstant: leftContainerSize.height),
            
            rightImageContainerView.widthAnchor.constraint(equalToConstant: rightContainerSize.width),
            rightImageContainerView.heightAnchor.constraint(equalToConstant: rightContainerSize.height),
        ])
    }
    
    private func calculateRotatedSize(width: CGFloat, height: CGFloat, angle: CGFloat) -> CGSize {
        let cosAngle = abs(cos(angle))
        let sinAngle = abs(sin(angle))
        
        let rotatedWidth = width * cosAngle + height * sinAngle
        let rotatedHeight = width * sinAngle + height * cosAngle
        
        return CGSize(width: rotatedWidth, height: rotatedHeight)
    }
    
    func configureViews() {
        
        backgroundImageView.image = UIImage(named: "welcomeBackground")
        backgroundImageView.contentMode = .scaleAspectFill
        view.backgroundColor = .clear
        
        appIconImageView.image = UIImage(named: "appIcon")
        appIconImageView.contentMode = .scaleAspectFill
        
        topImageContainerView.backgroundColor = .blue
        
        topImageView.backgroundColor = .red
        topImageView.image = UIImage(named: "welcomeTopImage")
        topImageView.contentMode = .scaleAspectFill
        
        leftImageContainerView.backgroundColor = .blue
        
        leftImageView.backgroundColor = .red
        leftImageView.image = UIImage(named: "welcomeLeftImage")
        leftImageView.contentMode = .scaleAspectFill
        
        rightImageContainerView.backgroundColor = .blue
        
        rightImageView.backgroundColor = .red
        rightImageView.image = UIImage(named: "welcomeRightImage")
        rightImageView.contentMode = .scaleAspectFill
        
        welcomeTitleLabel.text = NSLocalizedString("welcome_title_text", comment: "Welcome message")
        welcomeTitleLabel.font = .systemFont(ofSize: Constants.welcomeTitleLabelFontSize, weight: .medium)
        welcomeTitleLabel.textColor = .main
        welcomeTitleLabel.textAlignment = .center
        
        welcomeSubtitleLabel.text = NSLocalizedString("welcome_subtitle_text", comment: "Welcome Momentic text")
        welcomeSubtitleLabel.font = .systemFont(ofSize: Constants.welcomeSubtitleLabelFontSize, weight: .light)
        welcomeSubtitleLabel.textColor = UIColor(named: "subtitle")
        welcomeSubtitleLabel.textAlignment = .center
        welcomeSubtitleLabel.numberOfLines = .zero
        
        signStack.axis = .vertical
        signStack.alignment = .fill
        signStack.spacing = Constants.signStackSpacing
        
        signUpButton.setTitle(NSLocalizedString("signup_button_text", comment: "Sign up"), for: .normal)
        signUpButton.titleLabel?.font = .systemFont(ofSize: Constants.signUpButtonFontSize, weight: .medium)
        signUpButton.backgroundColor = UIColor(named: "main")
        signUpButton.layer.cornerRadius = Constants.signUpButtonCornerRadius
        signUpButton.tintColor = .white
        signUpButton.clipsToBounds = true
        signUpButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        signInButton.setTitle(NSLocalizedString("signin_label_text", comment: "Sign in"), for: .normal)
        signInButton.titleLabel?.font = .systemFont(ofSize: Constants.signInButtonFontSize, weight: .medium)
        signInButton.backgroundColor = .clear
        signInButton.tintColor = UIColor(named: "lightGreen")
        signInButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
}

//MARK: - Selectors

private extension WelcomeViewController {
    @objc func buttonTapped() {
        navigationController?.pushViewController(AuthViewController(), animated: true)
    }
}
