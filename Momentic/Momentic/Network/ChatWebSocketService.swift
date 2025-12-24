//
//  ChatWebSocketService.swift
//  Momentic
//
//  Created by ChatGPT on 12/23/25.
//

import Foundation

protocol ChatWebSocketServicing: AnyObject {
    var onMessage: ((ChatMessage) -> Void)? { get set }
    var onStateChange: ((ChatWebSocketService.ConnectionState) -> Void)? { get set }
    
    func connect()
    func disconnect()
    func sendMessage(_ message: OutgoingChatMessage)
}

struct OutgoingChatMessage: Encodable {
    let author: String
    let text: String
    let avatarURL: URL?
    let createdAt: Date
    
    init(author: String, text: String, avatarURL: URL?) {
        self.author = author
        self.text = text
        self.avatarURL = avatarURL
        self.createdAt = Date()
    }
}

final class ChatWebSocketService: NSObject, ChatWebSocketServicing {
    
    enum ConnectionState {
        case disconnected
        case connecting
        case connected
        case failed(Error)
    }
    
    private let url: URL
    private var webSocketTask: URLSessionWebSocketTask?
    private var pingTimer: Timer?
    private lazy var session: URLSession = {
        URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    }()
    
    var onMessage: ((ChatMessage) -> Void)?
    var onStateChange: ((ConnectionState) -> Void)?
    
    init(url: URL? = URL(string: "wss://comate-penney-biannulate.ngrok-free.dev/ws/chat")) {
        self.url = url ?? URL(string: "wss://comate-penney-biannulate.ngrok-free.dev/ws/chat")!
        super.init()
    }
    
    // MARK: - Connection
    
    func connect() {
        guard webSocketTask == nil else { return }
        onStateChange?(.connecting)
        
        let request = URLRequest(url: url)
        webSocketTask = session.webSocketTask(with: request)
        webSocketTask?.resume()
        
        listenForMessages()
        startPinging()
        onStateChange?(.connected)
    }
    
    func disconnect() {
        stopPinging()
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        webSocketTask = nil
        onStateChange?(.disconnected)
    }
    
    // MARK: - Send / Receive
    
    func sendMessage(_ message: OutgoingChatMessage) {
        guard let task = webSocketTask else { return }
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        do {
            let data = try encoder.encode(message)
            if let jsonString = String(data: data, encoding: .utf8) {
                task.send(.string(jsonString)) { [weak self] error in
                    if let error {
                        self?.onStateChange?(.failed(error))
                    }
                }
            }
        } catch {
            onStateChange?(.failed(error))
        }
    }
    
    private func listenForMessages() {
        webSocketTask?.receive { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let message):
                self.handle(message: message)
                self.listenForMessages()
            case .failure(let error):
                self.onStateChange?(.failed(error))
                self.disconnect()
            }
        }
    }
    
    private func handle(message: URLSessionWebSocketTask.Message) {
        switch message {
        case .string(let text):
            decodeAndPublish(text.data(using: .utf8))
        case .data(let data):
            decodeAndPublish(data)
        @unknown default:
            break
        }
    }
    
    private func decodeAndPublish(_ data: Data?) {
        guard let data else { return }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        if let chatMessage = try? decoder.decode(ChatMessage.self, from: data) {
            DispatchQueue.main.async { [weak self] in
                self?.onMessage?(chatMessage)
            }
        } else if let text = String(data: data, encoding: .utf8) {
            let fallback = ChatMessage(
                author: "Unknown",
                text: text,
                avatarURL: nil
            )
            DispatchQueue.main.async { [weak self] in
                self?.onMessage?(fallback)
            }
        }
    }
    
    // MARK: - Ping
    
    private func startPinging() {
        stopPinging()
        pingTimer = Timer.scheduledTimer(withTimeInterval: 20, repeats: true) { [weak self] _ in
            self?.webSocketTask?.sendPing { error in
                if let error {
                    self?.onStateChange?(.failed(error))
                }
            }
        }
    }
    
    private func stopPinging() {
        pingTimer?.invalidate()
        pingTimer = nil
    }
}

// MARK: - URLSessionWebSocketDelegate

extension ChatWebSocketService: URLSessionWebSocketDelegate {
    func urlSession(
        _ session: URLSession,
        webSocketTask: URLSessionWebSocketTask,
        didOpenWithProtocol protocol: String?
    ) {
        onStateChange?(.connected)
    }
    
    func urlSession(
        _ session: URLSession,
        webSocketTask: URLSessionWebSocketTask,
        didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
        reason: Data?
    ) {
        onStateChange?(.disconnected)
    }
}
