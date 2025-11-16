//
//  PaddedTextView.swift
//  Momentic
//
//  Created by Yaraslau Merynau on 1.10.25.
//

import UIKit

final class PaddedTextView: UITextView {
    
    // MARK: - Properties
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let placeholderColor: UIColor = UIColor(named: "subtitle") ?? .lightGray
    
    var placeholder: String? {
        didSet {
            placeholderLabel.text = placeholder
        }
    }
    
    //MARK: - Constants
    
    private enum Constants {
        static let verticalSpacing: CGFloat = 16
        static let horizontalSpacing: CGFloat = 20
    }
    
    // MARK: - Init
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupTextView()
        setupPlaceholder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupTextView() {
        self.textContainerInset = UIEdgeInsets(top: Constants.verticalSpacing, left: Constants.horizontalSpacing, bottom: Constants.horizontalSpacing, right: Constants.verticalSpacing)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textDidChange),
            name: UITextView.textDidChangeNotification,
            object: self
        )
    }
    
    private func setupPlaceholder() {
        addSubview(placeholderLabel)
        
        placeholderLabel.textColor = placeholderColor
        
        NSLayoutConstraint.activate([
            placeholderLabel.topAnchor.constraint(equalTo: topAnchor, constant: textContainerInset.top),
            placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: textContainerInset.left + textContainer.lineFragmentPadding),
            placeholderLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -(textContainerInset.right + textContainer.lineFragmentPadding)),
        ])
        
        updatePlaceholderVisibility()
    }
    
    // MARK: - Text Change Handler
    
    @objc private func textDidChange() {
        updatePlaceholderVisibility()
    }
    
    private func updatePlaceholderVisibility() {
        placeholderLabel.isHidden = !text.isEmpty
    }
    
    // MARK: - Overrides
    
    override var text: String! {
        didSet {
            updatePlaceholderVisibility()
        }
    }
    
    override var font: UIFont? {
        didSet {
            placeholderLabel.font = font
        }
    }
    
    // MARK: - Deinit
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
