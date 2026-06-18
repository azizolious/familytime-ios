//
//  HomeResponse.swift
//  FamilyTime
//
//  Created by Usama-Apps on 31/10/2022.
//  Copyright © 2022 YumyApps. All rights reserved.
//

import Foundation

// MARK: - HomeResponse
class HomeResponse: NSObject,Codable {
    var status: Bool?
    var message: String?
    var data: HomeData?

    init(status: Bool?, message: String?, data: HomeData?) {
        self.status = status
        self.message = message
        self.data = data
    }
}

// MARK: - DataClass
class HomeData: NSObject,Codable {
    var appConfig: [String]?
    //var defaultPromotions: DefaultPromotions?
    var subscription: Subscription?
    var children: [ChildData]?
    var versionInfo: VersionInfo?
    var coParent: [CoParent]?
    var launchNotification, setupComplete, isPhoneLocked, isInternetOff: Int?
    var trial: Trial?

    enum CodingKeys: String, CodingKey {
        case appConfig = "app_config"
        //case defaultPromotions = "default_promotions"
        case subscription, children
        case versionInfo = "version_info"
        case coParent = "co_parent"
        case launchNotification = "launch_notification"
        case setupComplete = "setup_complete"
        case isPhoneLocked = "is_phone_locked"
        case isInternetOff = "is_internet_off"
        case trial
    }
//defaultPromotions: DefaultPromotions?, subscription:
    init(appConfig: [String]?, subscription: Subscription?, children: [ChildData]?, versionInfo: VersionInfo?, coParent: [CoParent]?, launchNotification: Int?, setupComplete: Int?, isPhoneLocked: Int?, isInternetOff: Int?, trial: Trial?) {
        self.appConfig = appConfig
        //self.defaultPromotions = defaultPromotions
        self.subscription = subscription
        self.children = children
        self.versionInfo = versionInfo
        self.coParent = coParent
        self.launchNotification = launchNotification
        self.setupComplete = setupComplete
        self.isPhoneLocked = isPhoneLocked
        self.isInternetOff = isInternetOff
        self.trial = trial
    }
}

// MARK: - Child
class ChildData: NSObject,Codable {
    var childInfo: ChildInfo?
    var preferences: [PreferenceData]?
    var dailyLimit: DailyLimit?

    enum CodingKeys: String, CodingKey {
        case childInfo = "child_info"
        case preferences
        case dailyLimit = "daily_limit"
    }

    init(childInfo: ChildInfo?, preferences: [PreferenceData]?, dailyLimit: DailyLimit?) {
        self.childInfo = childInfo
        self.preferences = preferences
        self.dailyLimit = dailyLimit
    }
}

// MARK: - ChildInfo
class ChildInfo: NSObject,Codable {
    var childID: Int?
    var name: String?
    var birthday: String?
    var gender, relationship: String?
    var email, phone: String?
    var plateformID: Int?
    var device: String?
    var planID, packageID: Int?
    var package: String?
    var duration, expiryDate, remainingDays, coverImgSrc: String?
    var profileImgSrc: String?
    var color: String?
    var phonelockStatus, active, deleted: Int?
    var deletedBy: String?
    var superUserID: Int?
    var activationCode, dateCreated: String?
    var dateModified, pushToken: String?
    var childEnrolled: Int?
    var childMdmHash: String?
    var isProductionBuild: Int?
    var versionNumber, versionCode: String?
    var subscriptionID, schoolID, campusID, classID: String?
    var resellerID: Int?
    var timeZone: String?
    var isForgetMe: Int?
    var apiToken: String?
    var activationDate: String?
    var createdAt, updatedAt, uniqueDeviceID, agent: String?
    var newSubscriptionID, priority, deviceID: Int?
    var batteryRemaining: String?
    var wifiName: String?
    var deviceManufacturer, deviceName, deviceModel, deviceOS: String?
    var deviceLanguage: String?
    var deviceTimezone, deviceImei: String?
    var appVersion, appBuild: String?
    
    enum CodingKeys: String, CodingKey {
        case childID = "child_id"
        case name, birthday, gender, relationship, email, phone
        case plateformID = "plateform_id"
        case device
        case planID = "plan_id"
        case packageID = "package_id"
        case package, duration
        case expiryDate = "expiry_date"
        case remainingDays = "remaining_days"
        case coverImgSrc = "cover_img_src"
        case profileImgSrc = "profile_img_src"
        case color
        case phonelockStatus = "phonelock_status"
        case active, deleted
        case deletedBy = "deleted_by"
        case superUserID = "super_user_id"
        case activationCode = "activation_code"
        case dateCreated = "date_created"
        case dateModified = "date_modified"
        case pushToken = "push_token"
        case childEnrolled = "child_enrolled"
        case childMdmHash = "child_mdm_hash"
        case isProductionBuild = "is_production_build"
        case versionNumber = "version_number"
        case versionCode = "version_code"
        case subscriptionID = "subscription_id"
        case schoolID = "school_id"
        case campusID = "campus_id"
        case classID = "class_id"
        case resellerID = "reseller_id"
        case timeZone = "time_zone"
        case isForgetMe = "is_forget_me"
        case apiToken = "api_token"
        case activationDate = "activation_date"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case uniqueDeviceID = "unique_device_id"
        case agent
        case newSubscriptionID = "new_subscription_id"
        case priority
        case deviceID = "device_id"
        case batteryRemaining = "battery_remaining"
        case wifiName = "wifi_name"
        case deviceManufacturer = "device_manufacturer"
        case deviceName = "device_name"
        case deviceModel = "device_model"
        case deviceOS = "device_os"
        case deviceLanguage = "device_language"
        case deviceTimezone = "device_timezone"
        case deviceImei = "device_imei"
        case appVersion = "app_version"
        case appBuild = "app_build"
    }
    
    init(childID: Int?, name: String?, birthday: String?, gender: String?, relationship: String?, email: String?, phone: String?, plateformID: Int?, device: String?, planID: Int?, packageID: Int?, package: String?, duration: String?, expiryDate: String?, remainingDays: String?, coverImgSrc: String?, profileImgSrc: String?, color: String?, phonelockStatus: Int?, active: Int?, deleted: Int?, deletedBy: String?, superUserID: Int?, activationCode: String?, dateCreated: String?, dateModified: String?, pushToken: String?, childEnrolled: Int?, childMdmHash: String?, isProductionBuild: Int?, versionNumber: String?, versionCode: String?, subscriptionID: String?, schoolID: String?, campusID: String?, classID: String?, resellerID: Int?, timeZone: String?, isForgetMe: Int?, apiToken: String?, activationDate: String?, createdAt: String?, updatedAt: String?, uniqueDeviceID: String?, agent: String?, newSubscriptionID: Int?, priority: Int?, deviceID: Int?, batteryRemaining: String?, wifiName: String?, deviceManufacturer: String?, deviceName: String?, deviceModel: String?, deviceOS: String?, deviceLanguage: String?, deviceTimezone: String?, deviceImei: String?, appVersion: String?, appBuild: String?) {
        self.childID = childID
        self.name = name
        self.birthday = birthday
        self.gender = gender
        self.relationship = relationship
        self.email = email
        self.phone = phone
        self.plateformID = plateformID
        self.device = device
        self.planID = planID
        self.packageID = packageID
        self.package = package
        self.duration = duration
        self.expiryDate = expiryDate
        self.remainingDays = remainingDays
        self.coverImgSrc = coverImgSrc
        self.profileImgSrc = profileImgSrc
        self.color = color
        self.phonelockStatus = phonelockStatus
        self.active = active
        self.deleted = deleted
        self.deletedBy = deletedBy
        self.superUserID = superUserID
        self.activationCode = activationCode
        self.dateCreated = dateCreated
        self.dateModified = dateModified
        self.pushToken = pushToken
        self.childEnrolled = childEnrolled
        self.childMdmHash = childMdmHash
        self.isProductionBuild = isProductionBuild
        self.versionNumber = versionNumber
        self.versionCode = versionCode
        self.subscriptionID = subscriptionID
        self.schoolID = schoolID
        self.campusID = campusID
        self.classID = classID
        self.resellerID = resellerID
        self.timeZone = timeZone
        self.isForgetMe = isForgetMe
        self.apiToken = apiToken
        self.activationDate = activationDate
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.uniqueDeviceID = uniqueDeviceID
        self.agent = agent
        self.newSubscriptionID = newSubscriptionID
        self.priority = priority
        self.deviceID = deviceID
        self.batteryRemaining = batteryRemaining
        self.wifiName = wifiName
        self.deviceManufacturer = deviceManufacturer
        self.deviceName = deviceName
        self.deviceModel = deviceModel
        self.deviceOS = deviceOS
        self.deviceLanguage = deviceLanguage
        self.deviceTimezone = deviceTimezone
        self.deviceImei = deviceImei
        self.appVersion = appVersion
        self.appBuild = appBuild
    }
}

// MARK: - DailyLimit
class DailyLimit: NSObject,Codable {
    var childID, duration, remaining, remainingLimit: Int?
    var autoAdd, isActive: Int?
    
    enum CodingKeys: String, CodingKey {
        case childID = "child_id"
        case duration, remaining
        case remainingLimit = "remaining_limit"
        case autoAdd = "auto_add"
        case isActive = "is_active"
    }
    
    init(childID: Int?, duration: Int?, remaining: Int?, remainingLimit: Int?, autoAdd: Int?, isActive: Int?) {
        self.childID = childID
        self.duration = duration
        self.remaining = remaining
        self.remainingLimit = remainingLimit
        self.autoAdd = autoAdd
        self.isActive = isActive
    }
}

// MARK: - Preference
class PreferenceData: NSObject,Codable {
    var name: String?
    var status: Int?
    var value: String?
    //CHANGE STRING TO INT VALUE
    
    init(name: String?, status: Int?, value: String?) {
        self.name = name
        self.status = status
        self.value = value
    }
}

// MARK: - DefaultPromotions
class DefaultPromotions: NSObject,Codable {
    var inAppGoogle, inAppApple: String?
    
    enum CodingKeys: String, CodingKey {
        case inAppGoogle = "in_app_google"
        case inAppApple = "in_app_apple"
    }
    
    init(inAppGoogle: String?, inAppApple: String?) {
        self.inAppGoogle = inAppGoogle
        self.inAppApple = inAppApple
    }
}

// MARK: - Subscription
class Subscription: NSObject,Codable {
    var package, expiryDate: String?

    enum CodingKeys: String, CodingKey {
        case package
        case expiryDate = "expiry_date"
    }

    init(package: String?, expiryDate: String?) {
        self.package = package
        self.expiryDate = expiryDate
    }
}

// MARK: - Trial
class Trial: NSObject,Codable {
    var googleInAppSubID, appleInAppSubID: String?
    var subURL: String?

    enum CodingKeys: String, CodingKey {
        case googleInAppSubID = "google_in_app_sub_id"
        case appleInAppSubID = "apple_in_app_sub_id"
        case subURL = "sub_url"
    }

    init(googleInAppSubID: String?, appleInAppSubID: String?, subURL: String?) {
        self.googleInAppSubID = googleInAppSubID
        self.appleInAppSubID = appleInAppSubID
        self.subURL = subURL
    }
}

// MARK: - VersionInfo
class VersionInfo: NSObject,Codable {
    var versionNumber, versionCode: String?
    var isForcefull: Int?
    var releaseNotes: String?

    enum CodingKeys: String, CodingKey {
        case versionNumber = "version_number"
        case versionCode = "version_code"
        case isForcefull = "is_forcefull"
        case releaseNotes = "release_notes"
    }

    init(versionNumber: String?, versionCode: String?, isForcefull: Int?, releaseNotes: String?) {
        self.versionNumber = versionNumber
        self.versionCode = versionCode
        self.isForcefull = isForcefull
        self.releaseNotes = releaseNotes
    }
}

// MARK: - CoParent
class CoParent: NSObject,Codable {
    var userID: Int?
    var name, gender, email: String?
    var active, isJoined: Int?
    var relationship, color: String?
    var deleted: Int?
    var type, language: String?
    var settings: [CoParentSettings]?
    var isSuperParent: Int?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case name, gender, email, active
        case isJoined = "is_joined"
        case relationship, color, deleted, type, language, settings
        case isSuperParent = "is_super_parent"
    }

    init(userID: Int?, name: String?, gender: String?, email: String?, active: Int?, isJoined: Int?, relationship: String?, color: String?, deleted: Int?, type: String?, language: String?, settings: [CoParentSettings]?, isSuperParent: Int?) {
        self.userID = userID
        self.name = name
        self.gender = gender
        self.email = email
        self.active = active
        self.isJoined = isJoined
        self.relationship = relationship
        self.color = color
        self.deleted = deleted
        self.type = type
        self.language = language
        self.settings = settings
        self.isSuperParent = isSuperParent
    }
}

// MARK: - Setting
class CoParentSettings: NSObject,Codable {
    var id: Int?
    var type, displayName: String?
    var status: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, type
        case displayName = "display_name"
        case status
    }

    init(id: Int?, type: String?, displayName: String?, status: Int?) {
        self.id = id
        self.type = type
        self.displayName = displayName
        self.status = status
    }
}

struct Entry: Codable {
    let api, description: String
    let auth: Auth
    let https: Bool
    let cors: Cors
    let link: String
    let category: String

    enum CodingKeys: String, CodingKey {
        case api = "API"
        case description = "Description"
        case auth = "Auth"
        case https = "HTTPS"
        case cors = "Cors"
        case link = "Link"
        case category = "Category"
    }
}

enum Auth: String, Codable {
    case apiKey = "apiKey"
    case empty = ""
    case oAuth = "OAuth"
    case userAgent = "User-Agent"
    case xMashapeKey = "X-Mashape-Key"
}

enum Cors: String, Codable {
    case no = "no"
    case unknown = "unknown"
    case unkown = "unkown"
    case yes = "yes"
}
