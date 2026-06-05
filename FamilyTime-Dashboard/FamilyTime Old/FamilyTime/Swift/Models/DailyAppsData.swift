//
//  InstalledApps.swift
//  FamilyTime
//
//  Created by Usama-Apps on 28/12/2022.
//  Copyright © 2022 YumyApps. All rights reserved.
//

import Foundation

// MARK: - DailyAppsData
class DailyAppsData: NSObject,Codable {
    var limits: LimitsData?
    var status : Int?
    var message : String?
    
    init(limits: LimitsData?, message: String?, status: Int?) {
        self.limits = limits
        self.message = message
        self.status = status
    }
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
    }
}

// MARK: - DataClass
class LimitsData: NSObject,Codable {
    var duration: String?
    var radian: Double?
    var remaining, autoAdd, isActive: Int?
    var apps: [AppLimits]?

    enum CodingKeys: String, CodingKey {
        case duration, radian, remaining
        case autoAdd = "auto_add"
        case isActive = "is_active"
        case apps
    }

    init(duration: String?, radian: Double?, remaining: Int?, autoAdd: Int?, isActive: Int?, apps: [AppLimits]?) {
        self.duration = duration
        self.radian = radian
        self.remaining = remaining
        self.autoAdd = autoAdd
        self.isActive = isActive
        self.apps = apps
    }
}

// MARK: - App
class AppLimits: NSObject,Codable {
    var installedappID: Int?
    var appName, appPackageName, appCategory: String?
    var inDailyLimit: Int?

    enum CodingKeys: String, CodingKey {
        case installedappID = "installedapp_id"
        case appName = "app_name"
        case appPackageName = "app_package_name"
        case appCategory = "app_category"
        case inDailyLimit = "in_daily_limit"
    }

    init(installedappID: Int?, appName: String?, appPackageName: String?, appCategory: String?, inDailyLimit: Int?) {
        self.installedappID = installedappID
        self.appName = appName
        self.appPackageName = appPackageName
        self.appCategory = appCategory
        self.inDailyLimit = inDailyLimit
    }
}
//MOdel
struct DailyLimitCodableModel: Codable {
    var dailyLimits: [DailyLimitObj]?

    enum CodingKeys: String, CodingKey {
        case dailyLimits = "daily_limits"
    }
}

// MARK: - DailyLimit
struct DailyLimitObj: Codable {
    var childID, remainingLimit, duration: Int?

    enum CodingKeys: String, CodingKey {
        case childID = "child_id"
        case remainingLimit = "remaining_limit"
        case duration
    }
}

