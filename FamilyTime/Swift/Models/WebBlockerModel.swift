//
//  WebBlockerModel.swift
//  FamilyTime
//
//  Created by Sufyan on 15/01/2024.
//  Copyright © 2024 YumyApps. All rights reserved.
//


import Foundation

struct WebBlockerModel: Codable {
    var webBlockers: [WebBlockerObj]?

    enum CodingKeys: String, CodingKey {
        case webBlockers = "web_blockers"
    }
}

// MARK: - WebBlocker
struct WebBlockerObj: Codable {
    var id, superUserID, childID: Int?
    var url, type: String?
    var isBlocked: Int?
    var isSelectd:Bool? = false

    enum CodingKeys: String, CodingKey {
        case id
        case superUserID = "super_user_id"
        case childID = "child_id"
        case url, type
        case isBlocked = "is_blocked"
    }
}
