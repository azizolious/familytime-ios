//
//  UserProfile.swift
//  FamilyTime
//
//  Created by Sana-Ullah-IOS on 11/03/2020.
//  Copyright © 2020 YumyApps. All rights reserved.
//

import Foundation
import SwiftyJSON

// MARK: - UserProfile
class UserProfile: Codable {
    let userID: Int
    let name: String
    let birthday: String
    let gender, relationship, email, phone: String
    let profileImgSrc, coverImgSrc: String
    let remoteIP, remoteCountry, signupPlateform, dateCreated: String
    let dateModified, color: String
    let active, deleted: Int
    let type: String
    let superUserID: String
    let checksum, device, pushToken: String
    let isProductionBuild: Int
    let activationCode: String
    let remainingSubscriptions: String
    let billingStatus, userJourney: String
    let resellerID,package_id: Int
    let language: String
    let isJoined, isForgetMe: Bool
    let createdAt, updatedAt: String
    let myJSON: JSON
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case name, birthday, gender, relationship, email, phone
        case profileImgSrc = "profile_img_src"
        case coverImgSrc = "cover_img_src"
        case remoteIP = "remote_ip"
        case remoteCountry = "remote_country"
        case signupPlateform = "signup_plateform"
        case dateCreated = "date_created"
        case dateModified = "date_modified"
        case color, active, deleted, type
        case superUserID = "super_user_id"
        case checksum, device
        case pushToken = "push_token"
        case isProductionBuild = "is_production_build"
        case activationCode = "activation_code"
        case remainingSubscriptions = "remaining_subscriptions"
        case billingStatus = "billing_status"
        case userJourney = "user_journey"
        case resellerID = "reseller_id"
        case language
        case isJoined = "is_joined"
        case isForgetMe = "is_forget_me"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case package_id = "package_id"
        case myJSON
    }

    init() {
        self.userID = Int()
        self.name = String()
        self.birthday = String()
        self.gender = String()
        self.relationship = String()
        self.email = String()
        self.phone = String()
        self.profileImgSrc = String()
        self.coverImgSrc = String()
        self.remoteIP = String()
        self.remoteCountry = String()
        self.signupPlateform = String()
        self.dateCreated = String()
        self.dateModified = String()
        self.color = String()
        self.active = Int()
        self.deleted = Int()
        self.type = String()
        self.superUserID = String()
        self.checksum = String()
        self.device = String()
        self.pushToken = String()
        self.isProductionBuild = Int()
        self.activationCode = String()
        self.remainingSubscriptions = String()
        self.billingStatus = String()
        self.userJourney = String()
        self.resellerID = Int()
        self.language = String()
        self.isJoined = Bool()
        self.isForgetMe = Bool()
        self.createdAt = String()
        self.updatedAt = String()
        self.package_id = Int()
        self.myJSON = JSON()
    }
    
    
    init(_ data: [String:Any]) {
        let json = JSON(data)
        self.myJSON = json
        self.userID = json[CodingKeys.userID.rawValue].int ?? Int()
        self.name = json[CodingKeys.name.rawValue].string ?? String()
        self.birthday = json[CodingKeys.birthday.rawValue].string ?? String()
        self.gender = json[CodingKeys.gender.rawValue].string ?? String()
        self.relationship = json[CodingKeys.relationship.rawValue].string ?? String()
        self.email = json[CodingKeys.email.rawValue].string ?? String()
        self.phone = json[CodingKeys.phone.rawValue].string ?? String()
        self.profileImgSrc = json[CodingKeys.profileImgSrc.rawValue].string ?? String()
        self.coverImgSrc = json[CodingKeys.coverImgSrc.rawValue].string ?? String()
        self.remoteIP = json[CodingKeys.remoteIP.rawValue].string ?? String()
        self.remoteCountry = json[CodingKeys.remoteCountry.rawValue].string ?? String()
        self.signupPlateform = json[CodingKeys.signupPlateform.rawValue].string ?? String()
        self.dateCreated = json[CodingKeys.dateCreated.rawValue].string ?? String()
        self.dateModified = json[CodingKeys.dateModified.rawValue].string ?? String()
        self.color = json[CodingKeys.color.rawValue].string ?? String()
        self.active = json[CodingKeys.active.rawValue].int ?? Int()
        self.deleted = json[CodingKeys.deleted.rawValue].int ?? Int()
        self.type = json[CodingKeys.type.rawValue].string ?? String()
        self.superUserID = json[CodingKeys.superUserID.rawValue].string ?? String()
        self.checksum = json[CodingKeys.checksum.rawValue].string ?? String()
        self.device = json[CodingKeys.device.rawValue].string ?? String()
        self.pushToken = json[CodingKeys.pushToken.rawValue].string ?? String()
        self.isProductionBuild = json[CodingKeys.isProductionBuild.rawValue].int ?? Int()
        self.activationCode = json[CodingKeys.activationCode.rawValue].string ?? String()
        self.remainingSubscriptions = json[CodingKeys.remainingSubscriptions.rawValue].string ?? String()
        self.billingStatus = json[CodingKeys.billingStatus.rawValue].string ?? String()
        self.userJourney = json[CodingKeys.userJourney.rawValue].string ?? String()
        self.resellerID = json[CodingKeys.resellerID.rawValue].int ?? Int()
        self.language = json[CodingKeys.language.rawValue].string ?? String()
        self.isJoined = json[CodingKeys.isJoined.rawValue].bool ?? Bool()
        self.isForgetMe = json[CodingKeys.isForgetMe.rawValue].bool ?? Bool()
        self.createdAt = json[CodingKeys.createdAt.rawValue].string ?? String()
        self.package_id = json[CodingKeys.package_id.rawValue].int ?? Int()
        self.updatedAt = json[CodingKeys.updatedAt.rawValue].string ?? String()
    }
}
