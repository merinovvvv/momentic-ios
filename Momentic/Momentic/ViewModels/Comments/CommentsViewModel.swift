//
//  CommentsViewModel.swift
//  Momentic
//
//  Created by ChatGPT on 12/23/25.
//

import Foundation

protocol CommentsViewModelProtocol: AnyObject {
    var onMessagesUpdated: (([ChatMessage]) -> Void)? { get set }
    var onConnectionChanged: ((ChatWebSocketService.ConnectionState) -> Void)? { get set }
    
    func start()
    func stop()
    func sendMessage(text: String)
    func messageCountText() -> String
    func toggleReaction(for messageID: String)
}

final class CommentsViewModel: CommentsViewModelProtocol {

    private(set) var videoID: String
    private let networkHandler: NetworkHandlerProtocol
    private var userAvatarURL: URL?

    
    // MARK: - Properties
    
    private let chatService: ChatWebSocketServicing
    private let store: CommentsStoring
    private var messages: [ChatMessage] = [] {
        didSet {
            store.save(messages)
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.onMessagesUpdated?(self.messages)
            }
        }
    }
    
    // Track optimistic message IDs to prevent duplicates from WebSocket
    private var pendingMessageIDs: Set<String> = []
    
    // MARK: - Callbacks
    
    var onMessagesUpdated: (([ChatMessage]) -> Void)?
    var onConnectionChanged: ((ChatWebSocketService.ConnectionState) -> Void)?
    
    // MARK: - Init
    
    init(
        videoID: String,
        userAvatarURL: URL? = nil,
        chatService: ChatWebSocketServicing = ChatWebSocketService(),
        store: CommentsStoring = CommentsStore(),
        networkHandler: NetworkHandlerProtocol = NetworkHandler()
    ) {
        self.videoID = videoID
        self.userAvatarURL = userAvatarURL
        self.networkHandler = networkHandler
        self.chatService = chatService
        self.store = store
        bind()
    }
    
    // MARK: - Public
    
    func start() {
        // Always fetch fresh comments from API when view opens
        // The fetchCommentsFromAPI will handle merging with existing messages if needed
        fetchCommentsFromAPI()
        
        // Connect WebSocket for real-time updates
        chatService.connect()
    }
    
    func stop() {
        chatService.disconnect()
    }
    
    func sendMessage(text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        let outgoing = OutgoingChatMessage(
            author: "You", // Replace with actual user when available
            text: trimmed,
            avatarURL: userAvatarURL
        )
        
        // Optimistic update: show message immediately
        let optimisticMessage = ChatMessage(
            author: outgoing.author,
            text: outgoing.text,
            avatarURL: outgoing.avatarURL,
            createdAt: outgoing.createdAt,
            likeCount: 0,
            likedByMe: false
        )
        
        // Track this optimistic message ID to prevent duplicate from WebSocket
        pendingMessageIDs.insert(optimisticMessage.id)
        messages.append(optimisticMessage)
        
        // Save to database via REST API (for persistence)
        postCommentToAPI(outgoing) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let postedMessage):
                // Replace optimistic message with server response (which has correct ID, timestamps, etc.)
                DispatchQueue.main.async {
                    // Remove old optimistic ID, add server ID
                    self.pendingMessageIDs.remove(optimisticMessage.id)
                    self.pendingMessageIDs.insert(postedMessage.id)
                    
                    if let index = self.messages.firstIndex(where: { $0.id == optimisticMessage.id }) {
                        self.messages[index] = postedMessage
                    }
                }
            case .failure:
                // Keep the optimistic message even if API fails
                // Optionally: show error to user or mark message as failed
                break
            }
        }
        
        // Optionally: Also send via WebSocket for real-time broadcasting to other users
        // (Only if your backend architecture requires it - some backends handle this automatically)
        // chatService.sendMessage(outgoing)
    }
    
    func messageCountText() -> String {
        "\(messages.count) comments"
    }
    
    func toggleReaction(for messageID: String) {
        guard let index = messages.firstIndex(where: { $0.id == messageID }) else { return }
        var message = messages[index]
        if message.likedByMe {
            message = ChatMessage(
                id: message.id,
                author: message.author,
                text: message.text,
                avatarURL: message.avatarURL,
                createdAt: message.createdAt,
                likeCount: max(0, message.likeCount - 1),
                likedByMe: false
            )
        } else {
            message = ChatMessage(
                id: message.id,
                author: message.author,
                text: message.text,
                avatarURL: message.avatarURL,
                createdAt: message.createdAt,
                likeCount: message.likeCount + 1,
                likedByMe: true
            )
        }
        messages[index] = message
    }
    
    // MARK: - Private

    func fetchCommentsFromAPI() {
        guard let url = NetworkRoutes.fetchComments(videoID: videoID).url else {
            print("⚠️ Failed to create URL for fetching comments")
            return
        }
        
        print("📡 Fetching comments from API for videoID: \(videoID)")
        networkHandler.request(
            url,
            responseType: [CommentResponseDTO].self,
            jsonDictionary: nil,
            httpMethod: NetworkRoutes.fetchComments(videoID: videoID).httpMethod.rawValue,
            contentType: ContentType.json.rawValue,
            accessToken: nil
        ) { [weak self] result in
            switch result {
            case .success(let commentDTOs):
                print("✅ Successfully fetched \(commentDTOs.count) comments from API")
                
                // Convert DTOs to ChatMessages
                let fetchedMessages = commentDTOs.map { $0.toChatMessage() }
                
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    
                    // If messages array is empty (initial load), just set the fetched messages
                    if self.messages.isEmpty {
                        self.messages = fetchedMessages
                        print("📝 Set \(fetchedMessages.count) comments (initial load)")
                    } else {
                        // Merge fetched messages with existing ones to avoid losing WebSocket messages
                        var mergedMessages = fetchedMessages
                        let fetchedIDs = Set(fetchedMessages.map { $0.id })
                        
                        // Add any existing messages that aren't in the fetched list (e.g., from WebSocket)
                        for existingMessage in self.messages {
                            if !fetchedIDs.contains(existingMessage.id) {
                                mergedMessages.append(existingMessage)
                            }
                        }
                        
                        // Sort by creation date
                        mergedMessages.sort { $0.createdAt < $1.createdAt }
                        self.messages = mergedMessages
                        print("📝 Merged to \(mergedMessages.count) total comments")
                    }
                }
            case .failure(let error):
                print("❌ Failed to fetch comments: \(error.localizedDescription)")
                // On failure, you might want to load from cache or show an error
                // For now, we'll keep existing messages (if any)
                break
            }
        }
    }

    func postCommentToAPI(_ outgoing: OutgoingChatMessage, completion: @escaping (Result<ChatMessage, Error>) -> Void) {
        guard let url = NetworkRoutes.postComment(videoID: videoID).url else { return }
        networkHandler.request(url, responseType: ChatMessage.self, jsonDictionary: outgoing, httpMethod: NetworkRoutes.postComment(videoID: videoID).httpMethod.rawValue, contentType: ContentType.json.rawValue, accessToken: nil) { result in
            completion(result)
        }
    }

    private func bind() {
        chatService.onMessage = { [weak self] message in
            guard let self = self else { return }
            
            // Prevent duplicates: don't add messages we already have (from our own sends or already fetched)
            let existingIDs = Set(self.messages.map { $0.id })
            
            // Skip if this is a pending optimistic message we sent
            if self.pendingMessageIDs.contains(message.id) {
                // This is our own message echoed back - we already have it from optimistic update
                // Remove from pending since we got the server version
                self.pendingMessageIDs.remove(message.id)
                return
            }
            
            // Skip if we already have this message
            if existingIDs.contains(message.id) {
                return
            }
            
            // Add new message from WebSocket (from other users)
            self.messages.append(message)
        }
        
        chatService.onStateChange = { [weak self] state in
            self?.onConnectionChanged?(state)
        }
    }
    
    private func loadInitialMockMessages() {
        guard messages.isEmpty else { return }
        
        let avatars: [String] = [
            "http://localhost:3845/assets/4dbdc4ed5ed05fedea5201f4e35353fb35b5d171.png",
            "http://localhost:3845/assets/6309a501402601cb10b92f269f0b36d3ace8800a.png",
            "http://localhost:3845/assets/ddb4a6122051bb695a02a255dd56db22bad146c4.png",
            "http://localhost:3845/assets/8d954b469fa92697d8b1b2bcfbdd1cc7eb6fdf82.png",
            "http://localhost:3845/assets/40b85ca6efb8ceef563f8cb0df3f408f5c7e864f.svg",
            "http://localhost:3845/assets/42d56be3f49b6f126d32340071952e83b9dd835a.png"
        ]
        
        let seed: [ChatMessage] = [
            ChatMessage(author: "Alex123", text: "This is a fantastic post! Really enjoyed reading it.", avatarURL: URL(string: avatars[0]), createdAt: Date().addingTimeInterval(-2 * 60 * 60), likeCount: 987654, likedByMe: true),
            ChatMessage(author: "Sammy88", text: "This really made me think, thank you!", avatarURL: URL(string: avatars[1]), createdAt: Date().addingTimeInterval(-30 * 60), likeCount: 456789, likedByMe: false),
            ChatMessage(author: "TaylorSwift", text: "This topic is so relevant right now!", avatarURL: URL(string: avatars[2]), createdAt: Date().addingTimeInterval(-5 * 60), likeCount: 789012, likedByMe: false),
            ChatMessage(author: "JordanDoe", text: "I completely agree with your point!", avatarURL: URL(string: avatars[3]), createdAt: Date().addingTimeInterval(-60 * 60), likeCount: 654321, likedByMe: true),
            ChatMessage(author: "ChrisParker", text: "Such an interesting read, I learned a lot!", avatarURL: URL(string: avatars[4]), createdAt: Date().addingTimeInterval(-15 * 60), likeCount: 321654, likedByMe: false),
            ChatMessage(author: "JamieLee", text: "I appreciate your thoughts on this matter.", avatarURL: URL(string: avatars[5]), createdAt: Date().addingTimeInterval(-10 * 60), likeCount: 210987, likedByMe: false)
        ]
        
        messages = seed
    }
    
    private func loadPersistedOrSeedMessages() {
        let cached = store.load()
        if cached.isEmpty {
            loadInitialMockMessages()
        } else {
            messages = cached
        }
    }
}
