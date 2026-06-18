//
//  HeartbeatResponse.swift
//  FamilyTime
//
//  Created by Ahmad on 20/05/2026.
//  Copyright © 2026 YumyApps. All rights reserved.
//

import Foundation

struct HeartbeatResponse: Codable {
    
    let state: String?
    let nextHeartbeat: Int?
    let unreadCount: Int?
    let conversationId: Int?
    
    enum CodingKeys: String, CodingKey {
        case state
        case nextHeartbeat = "next_heartbeat"
        case unreadCount = "unread_count"
        case conversationId = "conversation_id"
    }
}
