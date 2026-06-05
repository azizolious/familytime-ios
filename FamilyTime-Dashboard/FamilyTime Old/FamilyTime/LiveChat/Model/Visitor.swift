//
//  Visitor.swift
//  FamilyTime
//
//  Created by Ahmad on 19/05/2026.
//  Copyright © 2026 YumyApps. All rights reserved.
//

import Foundation

struct Visitor: Codable {
    let id: Int?
    let name: String?
    let email: String?
    let conversationId: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case conversationId = "conversation_id"
    }
}
