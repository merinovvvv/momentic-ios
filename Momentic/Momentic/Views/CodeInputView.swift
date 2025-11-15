//
//  CodeInputView.swift
//  Momentic
//
//  Created by Yaraslau Merynau on 30.09.25.
//

import UIKit

final class CodeInputView: UIView {
    
    //MARK: - Properties
    
    private let numberOfDigits: Int
    
    var code: String {
        textField.text ?? ""
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: Constants.digitViewHeight)
    }
    
    
    var onCodeComplete: ((String) -> Void)?
    
    //MARK: - Constants
    
    private enum Constants {
        
        //MARK: - Constraints
        
        //MARK: - Values
        
        static let stackSpacing: CGFloat = 12
        
        static let digitViewCornerRadius: CGFloat = 16
        static let digitViewBorderWidth: CGFloat = 4
        
        static let digitLabelFontSize: CGFloat = 44
        
        static let digitViewHeight: CGFloat = 100
    }
    
    //MARK: - UI Properties
    
    private let textField: UITextField = UITextField()
    
    private var digitViews: [UIView] = []
    
    private var digitLabels: [UILabel] = []
    
    private let stackView: UIStackView = UIStackView()
    
    //MARK: - Init
    
    init(frame: CGRect, numbetOfDigits: Int = 5) {
        self.numberOfDigits = numbetOfDigits
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public Methods
    
    func clear() {
        textField.text = ""
        updateDigitViews(with: "")
    }
    
    func startEditing() {
        textField.becomeFirstResponder()
    }
    
    func setCode(_ code: String) {
        let trimmedCode = String(code.prefix(numberOfDigits))
        textField.text = trimmedCode
        updateDigitViews(with: trimmedCode)
    }
    
    func showError() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.duration = 0.5
        animation.values = [-10, 10, -8, 8, -5, 5, 0]
        stackView.layer.add(animation, forKey: "shake")
        
        digitViews.forEach {
            $0.layer.borderColor = UIColor(named: "wrongInput")?.cgColor
        }
        
        digitLabels.forEach {
            $0.textColor = UIColor(named: "wrongInput")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.digitViews.forEach {
                $0.layer.borderColor = UIColor(named: "backgroundGray")?.cgColor
            }
            
            self?.digitLabels.forEach {
                $0.textColor = UIColor(named: "main")
            }
            
            self?.clear()
        }
    }
    
    func showSuccess() {
        digitViews.forEach {
            $0.layer.borderColor = UIColor(named: "lightGreen")?.cgColor
        }
        digitLabels.forEach {
            $0.textColor = UIColor(named: "lightGreen")
        }
    }
}

//MARK: - Setup UI

private extension CodeInputView {
    func setupUI() {
        createVisualViews()
        
        setupViewHierarchy()
        setupConstraints()
        configureViews()
    }
    
    func createVisualViews() {
        for _ in 0..<numberOfDigits {
            let containerView = createDigitView()
            let label = createDigitLabel()
            
            containerView.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
            ])
            
            digitViews.append(containerView)
            digitLabels.append(label)
            stackView.addArrangedSubview(containerView)
        }
    }
    
    func createDigitView() -> UIView {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = Constants.digitViewCornerRadius
        view.layer.borderWidth = Constants.digitViewBorderWidth
        view.layer.borderColor = UIColor(named: "backgroundGray")?.cgColor
        return view
    }
    
    func createDigitLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .readexPro(size: Constants.digitLabelFontSize, weight: .medium)
        label.textColor = UIColor(named: "main")
        return label
    }
    
    func setupViewHierarchy() {
        addSubview(textField)
        addSubview(stackView)
    }
    
    func setupConstraints() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: self.topAnchor),
            textField.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    func configureViews() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        addGestureRecognizer(tapGesture)
        
        textField.keyboardType = .numberPad
        textField.textContentType = .oneTimeCode
        textField.delegate = self
        textField.tintColor = .clear
        textField.textColor = .clear
        textField.backgroundColor = .clear
        textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
        stackView.axis = .horizontal
        stackView.spacing = Constants.stackSpacing
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.isUserInteractionEnabled = false
    }
    
    func updateDigitViews(with text: String) {
        for (index, label) in digitLabels.enumerated() {
            if index < text.count {
                let character = text[text.index(text.startIndex, offsetBy: index)]
                label.text = String(character)
            } else {
                label.text = ""
            }
        }
    }
}

//MARK: - Selectors

private extension CodeInputView {
    @objc private func textDidChange() {
        let text = textField.text ?? ""
        
        updateDigitViews(with: text)
        
        if text.count == numberOfDigits {
            onCodeComplete?(text)
            textField.resignFirstResponder()
        }
    }
    
    @objc func viewTapped() {
        textField.becomeFirstResponder()
    }
}

//MARK: - UITextFieldDelegate

extension CodeInputView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        if updatedText.count > numberOfDigits {
            return false
        }
        
        if string.isEmpty {
            return true
        }
        
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        updateDigitViews(with: textField.text ?? "")
    }
}
