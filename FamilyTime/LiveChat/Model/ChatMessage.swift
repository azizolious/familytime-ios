//
//  ChatMessage.swift
//  FamilyTime
//
//  Created by Ahmad on 19/05/2026.
//  Copyright © 2026 YumyApps. All rights reserved.
//

import Foundation

enum ChatMessageStatus: String, Codable {
    
    case sending
    
    case sent
    
    case failed
}

struct MessageListResponse: Codable {
    
    let data: [ChatMessage]?
    
}

struct ChatMessage: Codable, Identifiable, Equatable {

    let id: Int?
    let conversationId: Int?
    let senderType: String?
    let senderName: String?
    let message: String?
    let isRead: Bool?
    let createdAt: String?

    var localId = UUID()
    var status: ChatMessageStatus = .sent
    
    enum CodingKeys: String, CodingKey {
        case id
        case message
        case conversationId = "conversation_id"
        case senderType = "sender_type"
        case senderName = "sender_name"
        case isRead = "is_read"
        case createdAt = "created_at"
    }

    var isCurrentUser: Bool {
        senderType?.lowercased() == "visitor"
    }
    
    // MARK: - SwiftUI Stable Identity
    var stableId: String {
        
        if let id {
            
            return "server_\(id)"
        }
        
        return "local_\(localId.uuidString)"
    }
    
    // MARK: - Equatable
    static func == (
        lhs: ChatMessage,
        rhs: ChatMessage
    ) -> Bool {
        
        lhs.stableId == rhs.stableId
    }
}

struct AgentMessageSocketDTO: Codable {
    
    let id: Int
    let conversationId: Int
    let message: String
    let senderType: String
    
    enum CodingKeys: String, CodingKey {
        
        case id
        case conversationId = "conversation_id"
        case message
        case senderType = "sender_type"
    }
}
