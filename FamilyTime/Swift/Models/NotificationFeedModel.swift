//
//  NotificationFeedModel.swift
//  FamilyTime
//
//  Created by Rizwan-Apps on 09/12/2022.
//  Copyright © 2022 YumyApps. All rights reserved.
//

import Foundation


// MARK: - NOTIFICATIONS
struct NotificationFeedModel: Codable {
    let feedData: [FeedDatum]
    let encodedURL: String
    //let message: String
    let status: Int

    enum CodingKeys: String, CodingKey {
        case feedData = "feed_data"
        case encodedURL = "encoded_url"
        //case message
        case status
    }
}

// MARK: - FeedDatum
struct FeedDatum: Codable {
    let id, newsFeedsID: Int
    let name, event, feedData, title: String
    let imageURL: String
    let feedSnippet, titleColor, feedSnippetColor, cardColor: String
    let readMoreColor, timeColor, actionText: String
    let isActive: Int
    let startDate, endDate: String
    let customerCriteria: Int
    let billingStatus: String
    let audienceLanguage, audienceCountry: String?
    let platformID, lang: String
    let sortOrder, notificationType, limit: Int
    let triggerPoint: String?
    let autoServe, frequency: Int
    let createdAt, updatedAt, country, feedDataLanguage: String
    let newsFeedDate, googleInAppSubID, appleInAppSubID: String
    let fsSubURL: String
    let paddleSubURL: String
    let dashboardSubURL: String
    let webCta, packageName, couponCode: String

    enum CodingKeys: String, CodingKey {
        case id
        case newsFeedsID = "news_feeds_id"
        case name, event
        case feedData = "feed_data"
        case title
        case imageURL = "image_url"
        case feedSnippet = "feed_snippet"
        case titleColor = "title_color"
        case feedSnippetColor = "feed_snippet_color"
        case cardColor = "card_color"
        case readMoreColor = "read_more_color"
        case timeColor = "time_color"
        case actionText = "action_text"
        case isActive = "is_active"
        case startDate = "start_date"
        case endDate = "end_date"
        case customerCriteria = "customer_criteria"
        case billingStatus = "billing_status"
        case audienceLanguage = "audience_language"
        case audienceCountry = "audience_country"
        case platformID = "platform_id"
        case lang
        case sortOrder = "sort_order"
        case notificationType = "notification_type"
        case limit
        case triggerPoint = "trigger_point"
        case autoServe = "auto_serve"
        case frequency
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case country
        case feedDataLanguage = "feed_data_language"
        case newsFeedDate = "news_feed_date"
        case googleInAppSubID = "google_in_app_sub_id"
        case appleInAppSubID = "apple_in_app_sub_id"
        case fsSubURL = "fs_sub_url"
        case paddleSubURL = "paddle_sub_url"
        case dashboardSubURL = "dashboard_sub_url"
        case webCta = "web_cta"
        case packageName, couponCode
    }
}



// MARK: - WelcomeElement
struct Feed_Data_Model: Codable {
    let type: String
    let bgColor, data, textColor: String?
    let topMargin: Int?
    let textAlignment: String?
    let phoneURL, tabletURL: String?
    let clickListener: String?
    let rightMargin, leftMargin, rightPadding, leftPadding: Int?
    let topPadding, bottomPadding: Int?

    enum CodingKeys: String, CodingKey {
        case type, bgColor, data, textColor, topMargin, textAlignment
        case phoneURL = "phoneUrl"
        case tabletURL = "tabletUrl"
        case clickListener, rightMargin, leftMargin, rightPadding, leftPadding, topPadding, bottomPadding
    }
}

typealias Welcome = [Feed_Data_Model]
