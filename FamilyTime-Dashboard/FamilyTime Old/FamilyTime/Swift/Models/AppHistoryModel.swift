//
//  AppHistoryModel.swift
//  FamilyTime
//
//  Created by Rizwan-Apps on 06/12/2022.
//  Copyright © 2022 YumyApps. All rights reserved.
//

import Foundation


// MARK: - Welcome
struct AppHistoryBase: Codable {
    let data: [AppHistortDataModel]
    enum CodingKeys: String, CodingKey {
        case data = "data"
        
    }
}

// MARK: - Datum
struct AppHistortDataModel: Codable {
    let browsinghistoryID, superUserID: Int?
    let title, domain: String?
    let url: String?
    let timeVisit: String?
    let childID: Int?
    let numberVisits, deleted: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case browsinghistoryID = "browsinghistory_id"
        case superUserID = "super_user_id"
        case title, domain, url
        case timeVisit = "time_visit"
        case numberVisits = "number_visits"
        case childID = "child_id"
        case deleted
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
//MARK:- YOUTUBE HISTORY MODEL
struct YoutubeBaseModel: Codable {
    let data: [youtubeData]?
}

// MARK: - Datum
struct youtubeData: Codable {
    let id, superUserID: Int?
    let title: String?
    let domain: String?
    let url, timeVisit: String?
    let numberVisits, childID, deleted: Int?
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case superUserID = "super_user_id"
        case title = "title"
        case domain = "domain"
        case url
        case timeVisit = "time_visit"
        case numberVisits = "number_visits"
        case childID = "child_id"
        case deleted
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

enum AtedAt: String, Codable {
    case the20221206T064410000000Z = "2022-12-06T06:44:10.000000Z"
    case the20221206T070732000000Z = "2022-12-06T07:07:32.000000Z"
}




struct SocialAppsHistoryModel: Codable {
    var socialApps: [SocialApp]?
}

// MARK: - SocialApp
struct SocialApp: Codable, Equatable {
    var childID: Int?
    var isRead: Int? = 0
    var appPackage, appName, date, contentType: String?
    var contactName, body, url, fromMe: String?

    enum CodingKeys: String, CodingKey {
        case childID = "child_id"
        case appPackage = "app_package"
        case appName = "app_name"
        case date
        case contentType = "content_type"
        case contactName = "contact_name"
        case body, url
        case fromMe = "from_me"
    }
}

