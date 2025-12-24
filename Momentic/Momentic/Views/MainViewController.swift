//
//  MainViewController.swift
//  Momentic
//
//  Created by Yaraslau Merynau on 25.09.25.
//

import UIKit
import AVFoundation

final class MainViewController: UIViewController {
    
    //MARK: - Properties
    
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var currentVideoIndex = 0
    private var activeTab: TabType = .friends
    private let commentsStore = CommentsStore()
    
    //MARK: - Constants
    
    private enum Constants {
        
        //MARK: - Constraints
        
        static let headerTopSpacing: CGFloat = 64
        static let headerHorizontalSpacing: CGFloat = 24
        static let headerIconSize: CGFloat = 32
        
        static let menuHeaderSpacing: CGFloat = 20
        static let menuHeaderGap: CGFloat = 16
        
        static let musicPopupTopSpacing: CGFloat = 16
        static let musicPopupHorizontalSpacing: CGFloat = 8
        static let musicPopupHeight: CGFloat = 48
        static let musicPopupImageSize: CGFloat = 32
        static let musicPopupCornerRadius: CGFloat = 16
        static let musicPopupInnerSpacing: CGFloat = 12
        static let musicPopupTextSpacing: CGFloat = 2
        
        static let videoContainerTopSpacing: CGFloat = 12
        static let videoContainerBottomSpacing: CGFloat = 12
        static let videoContainerCornerRadius: CGFloat = 32
        
        static let reactionsTrailingSpacing: CGFloat = 16
        static let reactionsBottomSpacing: CGFloat = 20
        static let reactionsButtonSpacing: CGFloat = 20
        static let reactionsButtonWidth: CGFloat = 50
        
        static let infoLeadingSpacing: CGFloat = 16
        static let infoTrailingSpacing: CGFloat = 16
        static let infoBottomSpacing: CGFloat = 16
        static let infoVerticalSpacing: CGFloat = 8
        static let locationIconSize: CGFloat = 20
        static let locationSpacing: CGFloat = 8
        
        static let tabBarHeight: CGFloat = 110
        static let tabBarTopSpacing: CGFloat = 20
        static let tabBarIconSize: CGFloat = 32
        static let tabBarCreateButtonSize: CGFloat = 72
        static let tabBarLabelSpacing: CGFloat = 9
        
        //MARK: - Values
        
        static let menuHeaderFontSize: CGFloat = 26
        static let musicPopupTrackFontSize: CGFloat = 12
        static let musicPopupArtistFontSize: CGFloat = 12
        
        static let usernameFontSize: CGFloat = 20
        static let locationFontSize: CGFloat = 16
        static let captionFontSize: CGFloat = 16
        
        static let tabBarLabelFontSize: CGFloat = 12
        
        static let reactionEmojiSize: CGFloat = 32
        static let reactionCountFontSize: CGFloat = 12
    }
    
    //MARK: - UI Properties
    
    private let videoContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = Constants.videoContainerCornerRadius
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.clipsToBounds = true
        return view
    }()
    
    private let headerContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let emptyIconView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let menuHeaderView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let friendsTabButton: UIButton = {
        let button = UIButton(type: .system)
        return button
    }()
    
    private let globalTabButton: UIButton = {
        let button = UIButton(type: .system)
        return button
    }()
    
    private let friendsTabLabel: UILabel = {
        let label = UILabel()
        label.text = "Friends"
        label.font = .readexPro(size: Constants.menuHeaderFontSize, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private let globalTabLabel: UILabel = {
        let label = UILabel()
        label.text = "Global"
        label.font = .readexPro(size: Constants.menuHeaderFontSize, weight: .light)
        label.textColor = .white
        return label
    }()
    
    private let friendsTabUnderline: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let globalTabUnderline: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.isHidden = true
        return view
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: Constants.headerIconSize, weight: .regular)
        button.setImage(UIImage(systemName: "magnifyingglass", withConfiguration: config), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private let musicPopupView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 46/255, green: 46/255, blue: 46/255, alpha: 1.0)
        view.layer.cornerRadius = Constants.musicPopupCornerRadius
        return view
    }()
    
    private let musicPopupImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.backgroundColor = .gray
        return imageView
    }()
    
    private let musicPopupStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constants.musicPopupTextSpacing
        stackView.alignment = .leading
        return stackView
    }()
    
    private let musicPopupTrackLabel: UILabel = {
        let label = UILabel()
        label.text = "Track name"
        label.font = .readexPro(size: Constants.musicPopupTrackFontSize, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private let musicPopupArtistLabel: UILabel = {
        let label = UILabel()
        label.text = "Queen"
        label.font = .readexPro(size: Constants.musicPopupArtistFontSize, weight: .light)
        label.textColor = .white
        return label
    }()
    
    private let reactionsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constants.reactionsButtonSpacing
        stackView.alignment = .trailing
        return stackView
    }()
    
    private let likeReactionButton = ReactionButton(emoji: "❤️", count: "0")
    private let fireReactionButton = ReactionButton(emoji: "🔥", count: "0")
    private let laughReactionButton = ReactionButton(emoji: "🤣", count: "0")
    private let angryReactionButton = ReactionButton(emoji: "😠", count: "0")
    private let commentButton = CommentReactionButton()
    
    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constants.infoVerticalSpacing
        stackView.alignment = .leading
        return stackView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Sunnyvale"
        label.font = .readexPro(size: Constants.usernameFontSize, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    private let locationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Constants.locationSpacing
        stackView.alignment = .center
        return stackView
    }()
    
    private let locationIconImageView: UIImageView = {
        let imageView = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: Constants.locationIconSize, weight: .regular)
        imageView.image = UIImage(systemName: "mappin", withConfiguration: config)
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.text = "Central Park"
        label.font = .readexPro(size: Constants.locationFontSize, weight: .light)
        label.textColor = .white
        return label
    }()
    
    private let customTabBar = CustomTabBar()
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupVideoPlayer()
        setupGestureRecognizers()
        customTabBar.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer?.frame = videoContainerView.bounds
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player?.pause()
    }
}

//MARK: - Setup UI

private extension MainViewController {
    func setupUI() {
        view.backgroundColor = .white
        setupViewHierarchy()
        setupConstraints()
        configureViews()
    }
    
    func setupViewHierarchy() {
        [videoContainerView, headerContainer, reactionsStackView, infoStackView, customTabBar].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [emptyIconView, menuHeaderView, searchButton, musicPopupView].forEach {
            headerContainer.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [friendsTabButton, globalTabButton].forEach {
            menuHeaderView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        friendsTabButton.addSubview(friendsTabLabel)
        friendsTabButton.addSubview(friendsTabUnderline)
        globalTabButton.addSubview(globalTabLabel)
        globalTabButton.addSubview(globalTabUnderline)
        
        [friendsTabLabel, friendsTabUnderline, globalTabLabel, globalTabUnderline].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [musicPopupImageView, musicPopupStackView].forEach {
            musicPopupView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        musicPopupStackView.addArrangedSubview(musicPopupTrackLabel)
        musicPopupStackView.addArrangedSubview(musicPopupArtistLabel)
        
        [likeReactionButton, fireReactionButton, laughReactionButton, angryReactionButton, commentButton].forEach {
            reactionsStackView.addArrangedSubview($0)
        }
        
        infoStackView.addArrangedSubview(usernameLabel)
        infoStackView.addArrangedSubview(locationStackView)
        
        locationStackView.addArrangedSubview(locationIconImageView)
        locationStackView.addArrangedSubview(locationLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            // Video container - extends to the very top of the phone
            videoContainerView.topAnchor.constraint(equalTo: view.topAnchor),
            videoContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            videoContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            videoContainerView.bottomAnchor.constraint(equalTo: customTabBar.topAnchor, constant: -Constants.videoContainerBottomSpacing),
            
            // Header container
            headerContainer.topAnchor.constraint(equalTo: videoContainerView.topAnchor, constant: Constants.headerTopSpacing),
            headerContainer.leadingAnchor.constraint(equalTo: videoContainerView.leadingAnchor, constant: Constants.headerHorizontalSpacing),
            headerContainer.trailingAnchor.constraint(equalTo: videoContainerView.trailingAnchor, constant: -Constants.headerHorizontalSpacing),
            
            // Empty icon
            emptyIconView.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor),
            emptyIconView.centerYAnchor.constraint(equalTo: headerContainer.centerYAnchor),
            emptyIconView.widthAnchor.constraint(equalToConstant: Constants.headerIconSize),
            emptyIconView.heightAnchor.constraint(equalToConstant: Constants.headerIconSize),
            
            // Menu header
            menuHeaderView.centerXAnchor.constraint(equalTo: headerContainer.centerXAnchor),
            menuHeaderView.centerYAnchor.constraint(equalTo: headerContainer.centerYAnchor),
            menuHeaderView.topAnchor.constraint(equalTo: headerContainer.topAnchor),
            menuHeaderView.bottomAnchor.constraint(equalTo: headerContainer.bottomAnchor),
            
            // Friends tab
            friendsTabButton.leadingAnchor.constraint(equalTo: menuHeaderView.leadingAnchor),
            friendsTabButton.topAnchor.constraint(equalTo: menuHeaderView.topAnchor),
            friendsTabButton.bottomAnchor.constraint(equalTo: menuHeaderView.bottomAnchor),
            
            friendsTabLabel.leadingAnchor.constraint(equalTo: friendsTabButton.leadingAnchor),
            friendsTabLabel.topAnchor.constraint(equalTo: friendsTabButton.topAnchor, constant: 1),
            friendsTabLabel.trailingAnchor.constraint(equalTo: friendsTabButton.trailingAnchor),
            
            friendsTabUnderline.leadingAnchor.constraint(equalTo: friendsTabLabel.leadingAnchor),
            friendsTabUnderline.trailingAnchor.constraint(equalTo: friendsTabLabel.trailingAnchor),
            friendsTabUnderline.topAnchor.constraint(equalTo: friendsTabLabel.bottomAnchor, constant: 4),
            friendsTabUnderline.heightAnchor.constraint(equalToConstant: 1),
            
            // Global tab
            globalTabButton.leadingAnchor.constraint(equalTo: friendsTabButton.trailingAnchor, constant: Constants.menuHeaderSpacing),
            globalTabButton.topAnchor.constraint(equalTo: menuHeaderView.topAnchor),
            globalTabButton.bottomAnchor.constraint(equalTo: menuHeaderView.bottomAnchor),
            globalTabButton.trailingAnchor.constraint(equalTo: menuHeaderView.trailingAnchor),
            
            globalTabLabel.leadingAnchor.constraint(equalTo: globalTabButton.leadingAnchor),
            globalTabLabel.topAnchor.constraint(equalTo: globalTabButton.topAnchor, constant: 1),
            globalTabLabel.trailingAnchor.constraint(equalTo: globalTabButton.trailingAnchor),
            
            globalTabUnderline.leadingAnchor.constraint(equalTo: globalTabLabel.leadingAnchor),
            globalTabUnderline.trailingAnchor.constraint(equalTo: globalTabLabel.trailingAnchor),
            globalTabUnderline.topAnchor.constraint(equalTo: globalTabLabel.bottomAnchor, constant: 4),
            globalTabUnderline.heightAnchor.constraint(equalToConstant: 1),
            
            // Search button
            searchButton.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor),
            searchButton.centerYAnchor.constraint(equalTo: headerContainer.centerYAnchor),
            searchButton.widthAnchor.constraint(equalToConstant: Constants.headerIconSize),
            searchButton.heightAnchor.constraint(equalToConstant: Constants.headerIconSize),
            
            // Music popup - width from Friends left to Global right
            musicPopupView.topAnchor.constraint(equalTo: headerContainer.bottomAnchor, constant: Constants.musicPopupTopSpacing),
            musicPopupView.leadingAnchor.constraint(equalTo: friendsTabButton.leadingAnchor),
            musicPopupView.trailingAnchor.constraint(equalTo: globalTabButton.trailingAnchor),
            musicPopupView.heightAnchor.constraint(equalToConstant: Constants.musicPopupHeight),
            
            musicPopupImageView.leadingAnchor.constraint(equalTo: musicPopupView.leadingAnchor, constant: Constants.musicPopupHorizontalSpacing),
            musicPopupImageView.centerYAnchor.constraint(equalTo: musicPopupView.centerYAnchor),
            musicPopupImageView.widthAnchor.constraint(equalToConstant: Constants.musicPopupImageSize),
            musicPopupImageView.heightAnchor.constraint(equalToConstant: Constants.musicPopupImageSize),
            
            musicPopupStackView.leadingAnchor.constraint(equalTo: musicPopupImageView.trailingAnchor, constant: Constants.musicPopupInnerSpacing),
            musicPopupStackView.centerYAnchor.constraint(equalTo: musicPopupView.centerYAnchor),
            musicPopupStackView.trailingAnchor.constraint(equalTo: musicPopupView.trailingAnchor, constant: -Constants.musicPopupHorizontalSpacing),
            
            // Reactions stack - positioned on the right
            reactionsStackView.trailingAnchor.constraint(equalTo: videoContainerView.trailingAnchor, constant: -Constants.reactionsTrailingSpacing),
            reactionsStackView.bottomAnchor.constraint(equalTo: infoStackView.topAnchor, constant: -Constants.reactionsBottomSpacing),
            reactionsStackView.topAnchor.constraint(greaterThanOrEqualTo: musicPopupView.bottomAnchor, constant: Constants.reactionsBottomSpacing),
            
            // Info stack
            infoStackView.leadingAnchor.constraint(equalTo: videoContainerView.leadingAnchor, constant: Constants.infoLeadingSpacing),
            infoStackView.trailingAnchor.constraint(equalTo: reactionsStackView.leadingAnchor, constant: -Constants.infoTrailingSpacing),
            infoStackView.bottomAnchor.constraint(equalTo: customTabBar.topAnchor, constant: -Constants.infoBottomSpacing),
            
            // Custom tab bar
            customTabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customTabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customTabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            customTabBar.heightAnchor.constraint(equalToConstant: Constants.tabBarHeight)
        ])
    }
        
    func configureViews() {
        friendsTabButton.addTarget(self, action: #selector(friendsTabTapped), for: .touchUpInside)
        globalTabButton.addTarget(self, action: #selector(globalTabTapped), for: .touchUpInside)
        searchButton.addTarget(self, action: #selector(searchTapped), for: .touchUpInside)
        commentButton.addTarget(self, action: #selector(openCommentsTapped), for: .touchUpInside)

        likeReactionButton.addTarget(self, action: #selector(likeReactionTapped), for: .touchUpInside)
        fireReactionButton.addTarget(self, action: #selector(fireReactionTapped), for: .touchUpInside)
        laughReactionButton.addTarget(self, action: #selector(laughReactionTapped), for: .touchUpInside)
        angryReactionButton.addTarget(self, action: #selector(angryReactionTapped), for: .touchUpInside)
        
        let cachedCount = commentsStore.load().count
        commentButton.setCount("\(cachedCount)")
        
        updateTabSelection()
    }
    
    func updateTabSelection() {
        if activeTab == .friends {
            friendsTabLabel.font = .readexPro(size: Constants.menuHeaderFontSize, weight: .medium)
            friendsTabLabel.textColor = .white
            friendsTabUnderline.isHidden = false
            
            globalTabLabel.font = .readexPro(size: Constants.menuHeaderFontSize, weight: .light)
            globalTabLabel.textColor = .white
            globalTabUnderline.isHidden = true
        } else {
            friendsTabLabel.font = .readexPro(size: Constants.menuHeaderFontSize, weight: .light)
            friendsTabLabel.textColor = .white
            friendsTabUnderline.isHidden = true
            
            globalTabLabel.font = .readexPro(size: Constants.menuHeaderFontSize, weight: .medium)
            globalTabLabel.textColor = .white
            globalTabUnderline.isHidden = false
        }
    }
}

//MARK: - Video Player Setup

private extension MainViewController {
    func setupVideoPlayer() {
        // Mock video URLs - replace with your actual URLs
        let videoURLs: [URL] = [
            URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!,
            URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4")!
        ]
        
        guard !videoURLs.isEmpty else { return }
        
        let playerItem = AVPlayerItem(url: videoURLs[currentVideoIndex])
        player = AVPlayer(playerItem: playerItem)
        
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspectFill
        playerLayer?.frame = videoContainerView.bounds
        
        if let playerLayer = playerLayer {
            videoContainerView.layer.insertSublayer(playerLayer, at: 0)
        }
        
        player?.play()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerDidFinishPlaying),
            name: .AVPlayerItemDidPlayToEndTime,
            object: playerItem
        )
    }
    
    func setupGestureRecognizers() {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeUp.direction = .up
        view.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        videoContainerView.addGestureRecognizer(tap)
    }
    
    @objc func playerDidFinishPlaying() {
        player?.seek(to: .zero)
        player?.play()
    }
    
    @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        // Handle swipe gestures for video navigation
    }
    
    @objc func handleTap() {
        if player?.timeControlStatus == .playing {
            player?.pause()
        } else {
            player?.play()
        }
    }
}

//MARK: - Selectors

private extension MainViewController {
    @objc func friendsTabTapped() {
        activeTab = .friends
        updateTabSelection()
    }
    
    @objc func globalTabTapped() {
        activeTab = .global
        updateTabSelection()
    }
    
    @objc func searchTapped() {
        // Handle search action
    }
    
    @objc func openCommentsTapped() {
        let videoID = "5" // Replace with actual dynamic video ID if available
        let userAvatarURL = URL(string: "https://example.com/my-avatar.png") // Replace with actual user's avatar URL
        let commentsViewModel = CommentsViewModel(videoID: videoID, userAvatarURL: userAvatarURL)
        let commentsViewController = CommentsViewController(viewModel: commentsViewModel)
        commentsViewController.delegate = self
        commentsViewController.modalPresentationStyle = .overFullScreen
        commentsViewController.modalTransitionStyle = .crossDissolve
        present(commentsViewController, animated: true)
    }

    // MARK: - Reaction Taps
    @objc func likeReactionTapped() {
        updateReactionCount(for: likeReactionButton)
    }
    @objc func fireReactionTapped() {
        updateReactionCount(for: fireReactionButton)
    }
    @objc func laughReactionTapped() {
        updateReactionCount(for: laughReactionButton)
    }
    @objc func angryReactionTapped() {
        updateReactionCount(for: angryReactionButton)
    }
    private func updateReactionCount(for button: ReactionButton) {
        // Simple increment/decrement logic (for demonstration)
        let currentCount = Int(button.countLabel.text ?? "0") ?? 0
        button.countLabel.text = "\(currentCount + 1)"
    }

}

//MARK: - CustomTabBarDelegate

extension MainViewController: CustomTabBarDelegate {
    func tabBar(_ tabBar: CustomTabBar, didSelectTab tab: TabBarItem) {
        // Handle tab selection
    }
}

//MARK: - CommentsViewControllerDelegate

extension MainViewController: CommentsViewControllerDelegate {
    func commentsViewController(_ controller: CommentsViewController, didUpdateCount count: Int) {
        commentButton.setCount("\(count)")
    }
}

//MARK: - Tab Type

private enum TabType {
    case friends
    case global
}

//MARK: - Reaction Button

class ReactionButton: UIButton {
    private enum Constants {
        static let reactionEmojiSize: CGFloat = 32
        static let reactionCountFontSize: CGFloat = 12
        static let reactionsButtonWidth: CGFloat = 50
    }
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = .readexPro(size: Constants.reactionEmojiSize, weight: .light)
        label.textAlignment = .center
        return label
    }()
    
    let countLabel: UILabel = {
        let label = UILabel()
        label.font = .readexPro(size: Constants.reactionCountFontSize, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    init(emoji: String, count: String) {
        super.init(frame: .zero)
        
        emojiLabel.text = emoji
        countLabel.text = count
        
        [emojiLabel, countLabel].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            emojiLabel.topAnchor.constraint(equalTo: topAnchor),
            emojiLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            countLabel.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 4),
            countLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            countLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            widthAnchor.constraint(equalToConstant: Constants.reactionsButtonWidth)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Comment Reaction Button

class CommentReactionButton: UIButton {
    private enum Constants {
        static let headerIconSize: CGFloat = 32
        static let reactionCountFontSize: CGFloat = 12
        static let reactionsButtonWidth: CGFloat = 50
    }
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: Constants.headerIconSize, weight: .regular)
        imageView.image = UIImage(systemName: "message.fill", withConfiguration: config)
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = .readexPro(size: Constants.reactionCountFontSize, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "0"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [iconImageView, countLabel].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: topAnchor),
            iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: Constants.headerIconSize),
            iconImageView.heightAnchor.constraint(equalToConstant: Constants.headerIconSize),
            
            countLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 4),
            countLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            countLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            widthAnchor.constraint(equalToConstant: Constants.reactionsButtonWidth)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCount(_ text: String) {
        countLabel.text = text
    }
}

//MARK: - Custom Tab Bar

enum TabBarItem: String {
    case home = "Home"
    case friends = "Friends"
    case create = "Create"
    case rating = "Rating"
    case profile = "Profile"
}

protocol CustomTabBarDelegate: AnyObject {
    func tabBar(_ tabBar: CustomTabBar, didSelectTab tab: TabBarItem)
}

class CustomTabBar: UIView {
    
    private enum Constants {
        static let tabBarTopSpacing: CGFloat = 20
    }
    
    weak var delegate: CustomTabBarDelegate?
    
    private var selectedTab: TabBarItem = .home {
        didSet {
            updateSelection()
        }
    }
    
    private let homeButton = TabButton(item: .home, iconName: "house.fill")
    private let friendsButton = TabButton(item: .friends, iconName: "person.2.fill")
    private let createButton = CenterTabButton()
    private let ratingButton = TabButton(item: .rating, iconName: "crown.fill")
    private let profileButton = TabButton(item: .profile, iconName: "person.fill")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        
        let stackView = UIStackView(arrangedSubviews: [
            homeButton, friendsButton, createButton, ratingButton, profileButton
        ])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.tabBarTopSpacing),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
        
        [homeButton, friendsButton, ratingButton, profileButton].forEach { button in
            button.addTarget(self, action: #selector(tabButtonTapped(_:)), for: .touchUpInside)
        }
        
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        
        updateSelection()
    }
    
    @objc private func tabButtonTapped(_ sender: TabButton) {
        selectedTab = sender.item
        delegate?.tabBar(self, didSelectTab: sender.item)
    }
    
    @objc private func createButtonTapped() {
        delegate?.tabBar(self, didSelectTab: .create)
    }
    
    private func updateSelection() {
        [homeButton, friendsButton, ratingButton, profileButton].forEach { button in
            button.isSelected = button.item == selectedTab
        }
    }
}

//MARK: - Tab Button

class TabButton: UIButton {
    
    private enum Constants {
        static let tabBarIconSize: CGFloat = 32
        static let tabBarLabelFontSize: CGFloat = 12
        static let tabBarLabelSpacing: CGFloat = 9
    }
    
    let item: TabBarItem
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.font = .readexPro(size: Constants.tabBarLabelFontSize, weight: .light)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.isHidden = false
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            updateAppearance()
        }
    }
    
    init(item: TabBarItem, iconName: String) {
        self.item = item
        super.init(frame: .zero)
        
        let config = UIImage.SymbolConfiguration(pointSize: Constants.tabBarIconSize, weight: .regular)
        iconImageView.image = UIImage(systemName: iconName, withConfiguration: config)
        textLabel.text = item.rawValue
        
        [iconImageView, textLabel].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: topAnchor),
            iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: Constants.tabBarIconSize),
            iconImageView.heightAnchor.constraint(equalToConstant: Constants.tabBarIconSize),
            
            textLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: Constants.tabBarLabelSpacing),
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        updateAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateAppearance() {
        if isSelected {
            iconImageView.tintColor = UIColor(named: "lightGreen")
            textLabel.textColor = UIColor(named: "lightGreen")
            textLabel.font = .readexPro(size: Constants.tabBarLabelFontSize, weight: .medium)
        } else {
            iconImageView.tintColor = UIColor(red: 140/255, green: 140/255, blue: 140/255, alpha: 1.0)
            textLabel.textColor = UIColor(red: 140/255, green: 140/255, blue: 140/255, alpha: 1.0)
            textLabel.font = .readexPro(size: Constants.tabBarLabelFontSize, weight: .light)
        }
    }
}

//MARK: - Center Tab Button

class CenterTabButton: UIButton {
    
    private enum Constants {
        static let tabBarCreateButtonSize: CGFloat = 72
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: Constants.tabBarCreateButtonSize, height: Constants.tabBarCreateButtonSize)
    }
    
    private func setupUI() {
        backgroundColor = .white
        
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)
        let plusImage = UIImage(systemName: "plus", withConfiguration: config)
        setImage(plusImage, for: .normal)
        tintColor = .black
        
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: Constants.tabBarCreateButtonSize),
            heightAnchor.constraint(equalToConstant: Constants.tabBarCreateButtonSize)
        ])
        
        setContentHuggingPriority(.required, for: .horizontal)
        setContentCompressionResistancePriority(.required, for: .horizontal)
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.3
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animatePress(isPressed: true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animatePress(isPressed: false)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        animatePress(isPressed: false)
    }
    
    private func animatePress(isPressed: Bool) {
        UIView.animate(
            withDuration: 0.15,
            delay: 0,
            options: [.allowUserInteraction, .beginFromCurrentState],
            animations: {
                if isPressed {
                    self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                } else {
                    self.transform = .identity
                }
            },
            completion: nil
        )
    }
}
