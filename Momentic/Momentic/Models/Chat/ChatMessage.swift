//
//  ChatMessage.swift
//  Momentic
//
//  Created by ChatGPT on 12/23/25.
//

import Foundation

struct ChatMessage: Codable, Equatable, Identifiable {
    
    // MARK: - Properties
    
    let id: String
    let author: String
    let text: String
    let avatarURL: URL?
    let createdAt: Date
    let likeCount: Int
    let likedByMe: Bool
    
    // MARK: - Init
    
    init(
        id: String = UUID().uuidString,
        author: String,
        text: String,
        avatarURL: URL?,
        createdAt: Date = Date(),
        likeCount: Int = 0,
        likedByMe: Bool = false
    ) {
        self.id = id
        self.author = author
        self.text = text
        self.avatarURL = avatarURL
        self.createdAt = createdAt
        self.likeCount = likeCount
        self.likedByMe = likedByMe
    }
    
    // MARK: - Codable
    
    private enum CodingKeys: String, CodingKey {
        case id
        case author
        case text
        case avatarURL = "avatar_url"
        case createdAt = "created_at"
        case likeCount = "like_count"
        case likedByMe = "liked_by_me"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id) ?? UUID().uuidString
        author = try container.decodeIfPresent(String.self, forKey: .author) ?? "Unknown"
        text = try container.decodeIfPresent(String.self, forKey: .text) ?? ""
        
        if let avatarString = try container.decodeIfPresent(String.self, forKey: .avatarURL) {
            avatarURL = URL(string: avatarString)
        } else {
            avatarURL = nil
        }
        
        let createdString = try container.decodeIfPresent(String.self, forKey: .createdAt)
        let createdTimestamp = try container.decodeIfPresent(TimeInterval.self, forKey: .createdAt)
        if let isoString = createdString, let date = ISO8601DateFormatter().date(from: isoString) {
            createdAt = date
        } else if let timestamp = createdTimestamp {
            createdAt = Date(timeIntervalSince1970: timestamp)
        } else {
            createdAt = Date()
        }
        
        likeCount = try container.decodeIfPresent(Int.self, forKey: .likeCount) ?? 0
        likedByMe = try container.decodeIfPresent(Bool.self, forKey: .likedByMe) ?? false
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(author, forKey: .author)
        try container.encode(text, forKey: .text)
        try container.encode(avatarURL?.absoluteString, forKey: .avatarURL)
        try container.encode(ISO8601DateFormatter().string(from: createdAt), forKey: .createdAt)
        try container.encode(likeCount, forKey: .likeCount)
        try container.encode(likedByMe, forKey: .likedByMe)
    }
}

// MARK: - Helpers

extension ChatMessage {
    var relativeTimeDescription: String {
        let interval = Date().timeIntervalSince(createdAt)
        let minutes = Int(interval / 60)
        let hours = minutes / 60
        
        switch (hours, minutes) {
        case (0, 0..<1):
            return "now"
        case (0, 1..<60):
            return "\(minutes)m"
        case (1, 1..<120):
            return "1h"
        default:
            return "\(max(1, hours))h"
        }
    }
}
