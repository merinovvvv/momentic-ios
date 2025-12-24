//
//  CommentResponseDTO.swift
//  Momentic
//
//  Created by Auto on 12/24/25.
//

import Foundation

// MARK: - Backend Response DTO

struct CommentResponseDTO: Codable {
    let commentId: Int
    let videoId: Int
    let userId: Int
    let nickname: String
    let avatarURL: String?
    let content: String
    let createdAt: String
    
    private enum CodingKeys: String, CodingKey {
        case commentId = "comment_id"
        case videoId = "video_id"
        case userId = "user_id"
        case nickname
        case avatarURL
        case content
        case createdAt = "created_at"
    }
}

// MARK: - Mapping to ChatMessage

extension CommentResponseDTO {
    func toChatMessage() -> ChatMessage {
        // Convert comment_id (Int) to String for id
        let id = String(commentId)
        
        // Use nickname as author, fallback to empty string if empty
        let author = nickname.isEmpty ? "Unknown" : nickname
        
        // Parse avatarURL
        let avatar: URL? = {
            if let avatarString = avatarURL, !avatarString.isEmpty {
                return URL(string: avatarString)
            }
            return nil
        }()
        
        // Parse created_at date (format: 2025-12-24T02:56:54.432509+03:00)
        let date: Date = {
            // Use DateFormatter for precise control over microseconds format
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone.current
            
            // Try with microseconds (6 digits) first
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZZZZZ"
            if let date = formatter.date(from: createdAt) {
                return date
            }
            
            // Try with milliseconds (3 digits)
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
            if let date = formatter.date(from: createdAt) {
                return date
            }
            
            // Try without fractional seconds
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
            if let date = formatter.date(from: createdAt) {
                return date
            }
            
            // Fallback: try ISO8601DateFormatter
            let isoFormatter = ISO8601DateFormatter()
            isoFormatter.formatOptions = [.withInternetDateTime, .withTimeZone]
            if let date = isoFormatter.date(from: createdAt) {
                return date
            }
            
            print("⚠️ Failed to parse date: \(createdAt), using current date")
            return Date() // Fallback to current date
        }()
        
        return ChatMessage(
            id: id,
            author: author,
            text: content,
            avatarURL: avatar,
            createdAt: date,
            likeCount: 0, // Backend doesn't provide this, default to 0
            likedByMe: false // Backend doesn't provide this, default to false
        )
    }
}

