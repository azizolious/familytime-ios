//
//  Conversation.swift
//  FamilyTime
//
//  Created by Ahmad on 19/05/2026.
//  Copyright © 2026 YumyApps. All rights reserved.
//

import Foundation

struct Conversation: Codable, Identifiable {
    let id: Int?
    let status: String?
    let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case status
        case createdAt = "created_at"
    }
}
