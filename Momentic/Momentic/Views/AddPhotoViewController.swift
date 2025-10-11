//
//  AddPhotoViewController.swift
//  Momentic
//
//  Created by Yaraslau Merynau on 4.10.25.
//

import UIKit

final class AddPhotoViewController: UIViewController, FlowController {
    
    //MARK: - FlowController
    var completionHandler: ((()) -> ())?
    
    //MARK: - Properties
    
    //MARK: - Constants
    
    private enum Constants {
        
        //MARK: - Constraints
        
        static let topImageTopSpacing: CGFloat = 160
        static let topImageSize: CGSize = CGSize(width: 150, height: 150)
        static let topImageLeadingSpacing: CGFloat = 112
        
        static let rightImageTopSpacing: CGFloat = 121
        static let rightImageSize: CGSize = CGSize(width: 100, height: 100)
        static let rightImageTrailingSpacing: CGFloat = 56
        
        static let leftImageTopSpacing: CGFloat = 180
        static let leftImageSize: CGSize = CGSize(width: 75, height: 75)
        static let leftImageLeadingSpacing: CGFloat = 56
        
        static let addPhotoLabelTopSpacing: CGFloat = 52
        static let addPhotoLabelHorizontalSpacing: CGFloat = 14
        
        static let explanationLabelTopSpacing: CGFloat = 8
        static let explanationLabelLeadingSpacing: CGFloat = 14
        static let explanationLabelTrailingSpacing: CGFloat = 102
        
        static let buttonStackTopSpacing: CGFloat = 32
        static let buttonStackHorizontalSpacing: CGFloat = 14
        static let buttonStackBottomSpacing: CGFloat = 217
        
        static let addPhotoButtonHeight: CGFloat = 52
        
        static let skipStepButtonHeight: CGFloat = 15
        
        //MARK: - Values
        
        static let addPhotoLabelFontSize: CGFloat = 44
        
        static let explanationLabelFontSize: CGFloat = 16
        
        static let addPhotoButtonCornerRadius: CGFloat = 16
        static let addPhotoButtonTextFontSize: CGFloat = 16
        
        static let skipThisStepButtonTextFontSize: CGFloat = 12
        
        static let buttonStackSpacing: CGFloat = 12
    }
    
    //MARK: - UI Properties
    
    private let topImageView: UIImageView = UIImageView()
    private let leftImageView: UIImageView = UIImageView()
    private let rightImageView: UIImageView = UIImageView()
    
    private let addPhotoLabel: UILabel = UILabel()
    private let explanationLabel: UILabel = UILabel()
    
    private let buttonStack: UIStackView = UIStackView()
    private let addPhotoButton: UIButton = UIButton(type: .system)
    private let skipThisStepButton: UIButton = UIButton(type: .system)
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
}

//MARK: - Setup UI
private extension AddPhotoViewController {
    func setupUI() {
        setupViewHierarchy()
        setupConstraints()
        configureViews()
    }
    
    func setupViewHierarchy() {
        [topImageView, leftImageView, rightImageView, addPhotoLabel, explanationLabel, buttonStack].forEach {
            view.addSubview($0)
        }
        
        buttonStack.addArrangedSubview(addPhotoButton)
        buttonStack.addArrangedSubview(skipThisStepButton)
    }
    
    func setupConstraints() {
        [topImageView, leftImageView, rightImageView, addPhotoLabel, explanationLabel, buttonStack, addPhotoButton, skipThisStepButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            topImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.topImageTopSpacing),
            topImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.topImageLeadingSpacing),
            topImageView.widthAnchor.constraint(equalToConstant: Constants.topImageSize.width),
            topImageView.heightAnchor.constraint(equalToConstant: Constants.topImageSize.height),
            
            leftImageView.topAnchor.constraint(equalTo: topImageView.topAnchor, constant: Constants.leftImageTopSpacing),
            leftImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.leftImageLeadingSpacing),
            leftImageView.widthAnchor.constraint(equalToConstant: Constants.leftImageSize.width),
            leftImageView.heightAnchor.constraint(equalToConstant: Constants.leftImageSize.height),
            
            rightImageView.topAnchor.constraint(equalTo: topImageView.topAnchor, constant: Constants.rightImageTopSpacing),
            rightImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.rightImageTrailingSpacing),
            rightImageView.widthAnchor.constraint(equalToConstant: Constants.rightImageSize.width),
            rightImageView.heightAnchor.constraint(equalToConstant: Constants.rightImageSize.height),
            
            addPhotoLabel.topAnchor.constraint(equalTo: leftImageView.bottomAnchor, constant: Constants.addPhotoLabelTopSpacing),
            addPhotoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.addPhotoLabelHorizontalSpacing),
            addPhotoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.addPhotoLabelHorizontalSpacing),
            
            explanationLabel.topAnchor.constraint(equalTo: addPhotoLabel.bottomAnchor, constant: Constants.explanationLabelTopSpacing),
            explanationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.explanationLabelLeadingSpacing),
            explanationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.explanationLabelTrailingSpacing),
            
            buttonStack.topAnchor.constraint(equalTo: explanationLabel.bottomAnchor, constant: Constants.buttonStackTopSpacing),
            buttonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.buttonStackHorizontalSpacing),
            buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.buttonStackHorizontalSpacing),
            
            addPhotoButton.heightAnchor.constraint(equalToConstant: Constants.addPhotoButtonHeight),
            
            skipThisStepButton.heightAnchor.constraint(equalToConstant: Constants.skipStepButtonHeight),
        ])
    }
    
    func configureViews() {
        topImageView.image = UIImage(named: "addPhotoTopImage")
        topImageView.contentMode = .scaleAspectFit
        
        leftImageView.image = UIImage(named: "addPhotoLeftImage")
        leftImageView.contentMode = .scaleAspectFit
        
        rightImageView.image = UIImage(named: "addPhotoRightImage")
        rightImageView.contentMode = .scaleAspectFit
        
        addPhotoLabel.text = NSLocalizedString("add_photo_title", comment: "Add photo")
        addPhotoLabel.font = UIFont.systemFont(ofSize: Constants.addPhotoLabelFontSize, weight: .medium)
        addPhotoLabel.textColor = UIColor(named: "main")
        addPhotoLabel.textAlignment = .left
        
        explanationLabel.text = NSLocalizedString("add_photo_subtitle", comment: "Add photo")
        explanationLabel.font = UIFont.systemFont(ofSize: Constants.explanationLabelFontSize, weight: .light)
        explanationLabel.textColor = UIColor(named: "subtitle")
        explanationLabel.textAlignment = .left
        explanationLabel.numberOfLines = .zero
        
        buttonStack.axis = .vertical
        buttonStack.spacing = Constants.buttonStackSpacing
        buttonStack.alignment = .fill
        buttonStack.distribution = .fill
        
        addPhotoButton.setTitle(NSLocalizedString("add_photo_title", comment: "Add photo button"), for: .normal)
        addPhotoButton.setTitleColor(.white, for: .normal)
        addPhotoButton.backgroundColor = UIColor(named: "lightGreen")
        addPhotoButton.tintColor = .white
        addPhotoButton.layer.cornerRadius = Constants.addPhotoButtonCornerRadius
        addPhotoButton.titleLabel?.font = UIFont.systemFont(ofSize: Constants.addPhotoButtonTextFontSize, weight: .medium)
        addPhotoButton.addTarget(self, action: #selector(addPhotoButtonTapped), for: .touchUpInside)
        
        skipThisStepButton.setTitle(NSLocalizedString("skip_this_step_button", comment: "Skip this step"), for: .normal)
        skipThisStepButton.setTitleColor(UIColor(named: "subtitle"), for: .normal)
        skipThisStepButton.backgroundColor = .clear
        skipThisStepButton.tintColor = UIColor(named: "subtitle")
        skipThisStepButton.titleLabel?.font = UIFont.systemFont(ofSize: Constants.skipThisStepButtonTextFontSize, weight: .medium)
        skipThisStepButton.addTarget(self, action: #selector(skipThisStepButtonTapped), for: .touchUpInside)
    }
}

//MARK: - Selectors
private extension AddPhotoViewController {
    @objc func addPhotoButtonTapped() {
        completionHandler?(())
    }
    
    @objc func skipThisStepButtonTapped() {
        //TODO: - move to the end of the registration
    }
}

