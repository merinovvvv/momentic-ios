//
//  CommentsStore.swift
//  Momentic
//
//  Created by ChatGPT on 12/23/25.
//

import Foundation

protocol CommentsStoring {
    func save(_ messages: [ChatMessage])
    func load() -> [ChatMessage]
}

final class CommentsStore: CommentsStoring {
    
    private enum Constants {
        static let storageKey = "momentic.comments.cache"
    }
    
    private let userDefaults: UserDefaults
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    
    init(
        userDefaults: UserDefaults = .standard,
        encoder: JSONEncoder = {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            return encoder
        }(),
        decoder: JSONDecoder = {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return decoder
        }()
    ) {
        self.userDefaults = userDefaults
        self.encoder = encoder
        self.decoder = decoder
    }
    
    func save(_ messages: [ChatMessage]) {
        guard let data = try? encoder.encode(messages) else { return }
        userDefaults.set(data, forKey: Constants.storageKey)
    }
    
    func load() -> [ChatMessage] {
        guard let data = userDefaults.data(forKey: Constants.storageKey),
              let messages = try? decoder.decode([ChatMessage].self, from: data) else {
            return []
        }
        return messages
    }
}
