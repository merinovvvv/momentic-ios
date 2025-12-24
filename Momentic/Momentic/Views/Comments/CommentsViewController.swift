//
//  CommentsViewController.swift
//  Momentic
//
//  Created by ChatGPT on 12/23/25.
//

import UIKit

protocol CommentsViewControllerDelegate: AnyObject {
    func commentsViewController(_ controller: CommentsViewController, didUpdateCount count: Int)
}

final class CommentsViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: CommentsViewModelProtocol
    private var messages: [ChatMessage] = []
    weak var delegate: CommentsViewControllerDelegate?
    
    // MARK: - UI
    
    private let dimView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        return view
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 32
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        return view
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .readexPro(size: 20, weight: .regular)
        label.textColor = UIColor(red: 46/255, green: 46/255, blue: 46/255, alpha: 1)
        label.text = "0 comments"
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .white
        return tableView
    }()
    
    private let inputContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let textFieldContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
        view.layer.cornerRadius = 16
        return view
    }()
    
    private let messageTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Input here..."
        textField.font = .readexPro(size: 16, weight: .light)
        textField.textColor = UIColor(red: 46/255, green: 46/255, blue: 46/255, alpha: 1)
        textField.returnKeyType = .send
        textField.enablesReturnKeyAutomatically = true
        return textField
    }()
    
    private let emojiButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 26, weight: .regular)
        button.setImage(UIImage(systemName: "face.smiling", withConfiguration: config), for: .normal)
        button.tintColor = UIColor(red: 140/255, green: 140/255, blue: 140/255, alpha: 1)
        return button
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .semibold)
        button.setImage(UIImage(systemName: "paperplane.fill", withConfiguration: config), for: .normal)
        button.tintColor = UIColor(red: 46/255, green: 46/255, blue: 46/255, alpha: 1)
        return button
    }()
    
    private var containerTopConstraint: NSLayoutConstraint?
    private var inputBottomConstraint: NSLayoutConstraint?
    
    // MARK: - Init
    
    init(viewModel: CommentsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        headerLabel.text = viewModel.messageCountText()
        bind()
        viewModel.start()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterKeyboardNotifications()
        viewModel.stop()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.backgroundColor = .clear
        
        [dimView, containerView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissSelf))
        dimView.addGestureRecognizer(tapGesture)
        
        containerView.addSubview(headerLabel)
        containerView.addSubview(tableView)
        containerView.addSubview(inputContainer)
        
        [headerLabel, tableView, inputContainer].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        inputContainer.addSubview(textFieldContainer)
        inputContainer.addSubview(emojiButton)
        inputContainer.addSubview(sendButton)
        textFieldContainer.translatesAutoresizingMaskIntoConstraints = false
        emojiButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        
        textFieldContainer.addSubview(messageTextField)
        messageTextField.translatesAutoresizingMaskIntoConstraints = false
        messageTextField.delegate = self
        sendButton.addTarget(self, action: #selector(sendCurrentMessage), for: .touchUpInside)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: "CommentTableViewCell")
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
        
        containerTopConstraint = containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 160)
        inputBottomConstraint = inputContainer.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20) // lifted higher
        
        NSLayoutConstraint.activate([
            dimView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimView.topAnchor.constraint(equalTo: view.topAnchor),
            dimView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerTopConstraint!,
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            headerLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            headerLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            headerLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            inputContainer.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            inputContainer.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            inputContainer.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            inputBottomConstraint!,
            
            textFieldContainer.leadingAnchor.constraint(equalTo: inputContainer.leadingAnchor),
            textFieldContainer.topAnchor.constraint(equalTo: inputContainer.topAnchor),
            textFieldContainer.bottomAnchor.constraint(equalTo: inputContainer.bottomAnchor, constant: -8),
            
            messageTextField.leadingAnchor.constraint(equalTo: textFieldContainer.leadingAnchor, constant: 16),
            messageTextField.trailingAnchor.constraint(equalTo: textFieldContainer.trailingAnchor, constant: -16),
            messageTextField.topAnchor.constraint(equalTo: textFieldContainer.topAnchor, constant: 12),
            messageTextField.bottomAnchor.constraint(equalTo: textFieldContainer.bottomAnchor, constant: -12),
            
            emojiButton.leadingAnchor.constraint(equalTo: textFieldContainer.trailingAnchor, constant: 12),
            emojiButton.centerYAnchor.constraint(equalTo: textFieldContainer.centerYAnchor),
            emojiButton.widthAnchor.constraint(equalToConstant: 32),
            emojiButton.heightAnchor.constraint(equalToConstant: 32),
            
            sendButton.leadingAnchor.constraint(equalTo: emojiButton.trailingAnchor, constant: 12),
            sendButton.trailingAnchor.constraint(equalTo: inputContainer.trailingAnchor),
            sendButton.centerYAnchor.constraint(equalTo: textFieldContainer.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 32),
            sendButton.heightAnchor.constraint(equalToConstant: 32),
            
            textFieldContainer.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    private func bind() {
        viewModel.onMessagesUpdated = { [weak self] messages in
            guard let self else { return }
            self.messages = messages
            self.headerLabel.text = self.viewModel.messageCountText()
            self.tableView.reloadData()
            self.scrollToBottom()
            self.delegate?.commentsViewController(self, didUpdateCount: messages.count)
        }
    }
    
    private func scrollToBottom() {
        guard !messages.isEmpty else { return }
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    // MARK: - Actions
    
    @objc private func dismissSelf() {
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDataSource & Delegate

extension CommentsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as? CommentTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: messages[indexPath.row])
        cell.onLikeTap = { [weak self] id in
            self?.viewModel.toggleReaction(for: id)
        }
        return cell
    }
}

// MARK: - UITextFieldDelegate

extension CommentsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendCurrentMessage()
        return true
    }
    
    @objc private func sendCurrentMessage() {
        guard let text = messageTextField.text else { return }
        viewModel.sendMessage(text: text)
        messageTextField.text = ""
    }
}

// MARK: - Keyboard Handling

private extension CommentsViewController {
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    func unregisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        else { return }
        
        let keyboardHeight = keyboardFrame.height - view.safeAreaInsets.bottom
        inputBottomConstraint?.constant = -(keyboardHeight + 8)
        
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        inputBottomConstraint?.constant = -20 // match resting position, keep input field higher
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
}
