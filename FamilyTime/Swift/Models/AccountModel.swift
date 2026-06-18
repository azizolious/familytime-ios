//
//  AccountModel.swift
//  FamilyTime
//
//  Created by Usama-Apps on 25/11/2022.
//  Copyright © 2022 YumyApps. All rights reserved.
//

import Foundation

class AccountModel: NSObject, Codable {
    var profile: Profile?
    var billing: Billing?
    init(profile: Profile?, billing: Billing?) {
        self.profile = profile
        self.billing = billing
    }
}
// MARK: - Billing
class Billing: NSObject, Codable {
    var subscriptions: [SubscriptionsData]?
    init(subscriptions: [SubscriptionsData]?) {
        self.subscriptions = subscriptions
    }
}
// MARK: - Subscription
class SubscriptionsData: NSObject, Codable {
    var id: Int?
    var subscriptionID, startDate, endDate, plan: String?
    var product, psp: String?
    var status: Int?
    var createdAt: String?
    enum CodingKeys: String, CodingKey {
        case id
        case subscriptionID = "subscription_id"
        case startDate = "start_date"
        case endDate = "end_date"
        case plan, product, psp, status
        case createdAt = "created_at"
    }
    init(id: Int?, subscriptionID: String?, startDate: String?, endDate: String?, plan: String?, product: String?, psp: String?, status: Int?, createdAt: String?) {
        self.id = id
        self.subscriptionID = subscriptionID
        self.startDate = startDate
        self.endDate = endDate
        self.plan = plan
        self.product = product
        self.psp = psp
        self.status = status
        self.createdAt = createdAt
    }
}
// MARK: - Profile
class Profile: NSObject, Codable {
    var id: Int?
    var superUserID: Int?
    var name, gender, email: String?
    var phone: String?
    var type, language, createdAt, package: String?
    var emailVerifiedAt : String?
    var emailBounce : Int?
    var emailComplaint : Int?
    var deleted: Int?
    enum CodingKeys: String, CodingKey {
        case id
        case superUserID = "super_user_id"
        case name, gender, email, phone, type, language
        case createdAt = "created_at"
        case emailVerifiedAt = "email_verified_at"
        case emailBounce = "email_bounce"
        case emailComplaint = "email_complaint"
        case package
        case deleted
    }
    init(id: Int?, superUserID: Int?, name: String?, gender: String?, email: String?, phone: String?, type: String?, language: String?, createdAt: String?, package: String?, emailVerifiedAt:String?, emailBounce:Int?, emailComplaint: Int?) {
        self.id = id
        self.superUserID = superUserID
        self.name = name
        self.gender = gender
        self.email = email
        self.phone = phone
        self.type = type
        self.language = language
        self.createdAt = createdAt
        self.package = package
        self.emailVerifiedAt = emailVerifiedAt
        self.emailBounce = emailBounce
        self.emailComplaint = emailComplaint
    }
}
