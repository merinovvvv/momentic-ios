//
//  CommentTableViewCell.swift
//  Momentic
//
//  Created by ChatGPT on 12/23/25.
//

import UIKit

final class CommentTableViewCell: UITableViewCell {
    
    // MARK: - Callbacks
    
    var onLikeTap: ((String) -> Void)?
    private var messageID: String?
    
    // MARK: - UI
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .readexPro(size: 12, weight: .medium)
        label.textColor = UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1)
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = .readexPro(size: 16, weight: .light)
        label.textColor = UIColor(red: 46/255, green: 46/255, blue: 46/255, alpha: 1)
        label.numberOfLines = 0
        return label
    }()
    
    private let metaLabel: UILabel = {
        let label = UILabel()
        label.font = .readexPro(size: 12, weight: .light)
        label.textColor = UIColor(red: 140/255, green: 140/255, blue: 140/255, alpha: 1)
        return label
    }()
    
    private let replyLabel: UILabel = {
        let label = UILabel()
        label.font = .readexPro(size: 12, weight: .medium)
        label.textColor = UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1)
        label.text = "Reply"
        return label
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton(type: .custom) // Изменено на .custom
        button.adjustsImageWhenHighlighted = false
        button.backgroundColor = .clear
        return button
    }()
    
    private let likeCountLabel: UILabel = {
        let label = UILabel()
        label.font = .readexPro(size: 12, weight: .medium)
        label.textColor = UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    
    private let likeStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 4
        return stack
    }()
    
    private let textStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 7
        stack.alignment = .leading
        return stack
    }()
    
    private let metaStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        return stack
    }()
    
    private var avatarSizeConstraint: NSLayoutConstraint?
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.image = nil
        usernameLabel.text = nil
        messageLabel.text = nil
        metaLabel.text = nil
        likeCountLabel.text = nil
    }
    
    // MARK: - Configuration
    
    func configure(with message: ChatMessage) {
        messageID = message.id
        usernameLabel.text = message.author
        messageLabel.text = message.text
        metaLabel.text = message.relativeTimeDescription
        replyLabel.text = "Reply"
        
        let heartColor = UIColor(red: 217/255, green: 54/255, blue: 87/255, alpha: 1)
        let faintHeartColor = UIColor(red: 217/255, green: 54/255, blue: 87/255, alpha: 0.20)
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .regular)
        
        // Устанавливаем правильное изображение в зависимости от состояния
        if message.likedByMe {
            let image = UIImage(systemName: "heart.fill", withConfiguration: config)?.withRenderingMode(.alwaysTemplate)
            likeButton.setImage(image, for: .normal)
            likeButton.tintColor = heartColor
            likeCountLabel.textColor = heartColor
        } else {
            let image = UIImage(systemName: "heart", withConfiguration: config)?.withRenderingMode(.alwaysTemplate)
            likeButton.setImage(image, for: .normal)
            likeButton.tintColor = faintHeartColor
            likeCountLabel.textColor = UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1)
        }
        
        likeCountLabel.text = formatCount(message.likeCount)
        
        // Basic threaded look support: shrink avatar when prefixed
        let isChild = message.author.contains(".")
        let avatarSize: CGFloat = isChild ? 20 : 32
        avatarImageView.layer.cornerRadius = avatarSize / 2
        avatarSizeConstraint?.constant = avatarSize
        
        if let url = message.avatarURL {
            loadImage(from: url)
        } else {
            avatarImageView.backgroundColor = UIColor(white: 0.9, alpha: 1)
        }
    }
    
    // MARK: - Private
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(avatarImageView)
        contentView.addSubview(textStack)
        contentView.addSubview(likeStack)
        
        [usernameLabel, messageLabel, metaStack].forEach { textStack.addArrangedSubview($0) }
        [metaLabel, replyLabel].forEach { metaStack.addArrangedSubview($0) }
        [likeButton, likeCountLabel].forEach { likeStack.addArrangedSubview($0) }
        
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        textStack.translatesAutoresizingMaskIntoConstraints = false
        likeStack.translatesAutoresizingMaskIntoConstraints = false
        
        avatarSizeConstraint = avatarImageView.widthAnchor.constraint(equalToConstant: 32)
        
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            avatarSizeConstraint!,
            
            textStack.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),
            textStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            textStack.trailingAnchor.constraint(lessThanOrEqualTo: likeStack.leadingAnchor, constant: -12),
            
            likeStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            likeStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            likeStack.widthAnchor.constraint(equalToConstant: 48),
            
            contentView.bottomAnchor.constraint(equalTo: textStack.bottomAnchor, constant: 8)
        ])
        
        likeButton.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)
    }
    
    private func formatCount(_ count: Int) -> String {
        if count >= 1_000_000 {
            return String(format: "%.1fm", Double(count) / 1_000_000)
        } else if count >= 1000 {
            return String(format: "%.0fk", Double(count) / 1000)
        } else {
            return "\(count)"
        }
    }
    
    private func loadImage(from url: URL) {
        ImageCache.shared.load(url: url) { [weak self] image in
            self?.avatarImageView.image = image
        }
    }
    
    @objc private func likeTapped() {
        guard let messageID else { return }
        onLikeTap?(messageID)
    }
}

// MARK: - Image Cache

private final class ImageCache {
    static let shared = ImageCache()
    private let cache = NSCache<NSURL, UIImage>()
    
    func load(url: URL, completion: @escaping (UIImage?) -> Void) {
        if let cached = cache.object(forKey: url as NSURL) {
            completion(cached)
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data, let image = UIImage(data: data) else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            self?.cache.setObject(image, forKey: url as NSURL)
            DispatchQueue.main.async { completion(image) }
        }.resume()
    }
}
