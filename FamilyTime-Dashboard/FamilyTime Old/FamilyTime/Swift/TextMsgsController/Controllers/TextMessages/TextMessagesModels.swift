//
//  TextMessagesModels.swift
//  FamilyTime
//
//  Created by Rao Mudassar Khalil on 14/10/2021.
//  Copyright © 2021 YumyApps. All rights reserved.
//

import Foundation

//struct TextMessagesResponse : Codable {
//    let messages : Messages?
//    let message : String?
//    let status : Int?
//}
struct MessageThreadData: Codable {
    var sms_id: Int?
    var child_id: Int?
    var thread_id: Int?
    var contact_name: String?
    var body: String?
    var sms_time: String?
    var created_at: String?// Keep as String if Core Data attribute is String
    var type: String?
    var isRead: Int? // Use Int if Core Data attribute is Int
}

// MARK: - Welcome
struct TextMessagesCodable: Codable {
    var sms: [MessageThreadData]?
}

// MARK: - Sm
struct Sm: Codable {
    var childID, threadID, smsID: Int?
    var contactName, body: String?
    var type: TypeEnum?
    var smsTime: String?
    var createdAt: String?

    enum CodingKeys: String, CodingKey {
        case childID = "child_id"
        case threadID = "thread_id"
        case smsID = "sms_id"
        case contactName = "contact_name"
        case body, type
        case smsTime = "sms_time"
        case createdAt = "created_at"
    }
}

enum TypeEnum: String, Codable {
    case received = "received"
    case sent = "sent"
}
