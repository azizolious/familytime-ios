//
//  ControlAppsListModel.swift
//  FamilyTime
//
//  Created by Sufyan on 18/10/2023.
//  Copyright © 2023 YumyApps. All rights reserved.
//

import Foundation

struct ControlAppListModel: Codable {
    var installedApps: [InstalledApp]?

    enum CodingKeys: String, CodingKey {
        case installedApps = "installed_apps"
    }
    
    private func getChildApp() -> [InstalledApp]? {
        let childID = UserDefaults.standard.integer(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        let apps = installedApps?.filter({$0.childID == childID})
        return apps
    }
    
    func getLimitedApp()-> [InstalledApp]? {
        let aps = getChildApp()
        let limited = aps?.filter({$0.appLimit == "1"})
        return limited
    }
    func getNonLimitedApp()-> [InstalledApp]? {
        let apps = getChildApp()
        let limited = apps?.filter({$0.appLimit == "0"})
        let sorted = limited?.sorted(by: {$0.appsTime!.getDateFromStr() > $1.appsTime!.getDateFromStr()})
        return sorted
    }
    
}

// MARK: - InstalledApp
struct InstalledApp: Codable {
    var installedappID: Int?
    var appName, appPackageName: String?
    var size, isBlacklisted, isMonitor: Int?
    var appCategory: String?
    var childID, superUserID, inDailyLimit: Int?
    var appIcon: String?
    var uninstalled: Int?
    var monday, mondayRemainingLimit, tuesday, tuesdayRemainingLimit: Int?
    var wednesday, wednesdayRemainingLimit, thursday, thursdayRemainingLimit: Int?
    var friday, fridayRemainingLimit, saturday, saturdayRemainingLimit: Int?
    var sunday, sundayRemainingLimit: Int?
    var dateModified, dateCreated, appLimit: String?
    var deleted: Int?
    var appsTime, createdAt, updatedAt: String?
    var isSelected: Bool? = false

    enum CodingKeys: String, CodingKey {
        case installedappID = "installedapp_id"
        case appName = "app_name"
        case appPackageName = "app_package_name"
        case size
        case isBlacklisted = "is_blacklisted"
        case isMonitor = "is_monitor"
        case appCategory = "app_category"
        case childID = "child_id"
        case superUserID = "super_user_id"
        case inDailyLimit = "in_daily_limit"
        case appIcon = "app_icon"
        case uninstalled, monday
        case mondayRemainingLimit = "monday_remaining_limit"
        case tuesday
        case tuesdayRemainingLimit = "tuesday_remaining_limit"
        case wednesday
        case wednesdayRemainingLimit = "wednesday_remaining_limit"
        case thursday
        case thursdayRemainingLimit = "thursday_remaining_limit"
        case friday
        case fridayRemainingLimit = "friday_remaining_limit"
        case saturday
        case saturdayRemainingLimit = "saturday_remaining_limit"
        case sunday
        case sundayRemainingLimit = "sunday_remaining_limit"
        case appLimit = "app_limit"
        case dateCreated = "date_created"
        case dateModified = "date_modified"
        case deleted
        case appsTime = "apps_time"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    func getHours()->Int {
        let hours = getAddedSec()
        let returnValue = hours/3600
        return returnValue
    }
    func getAddedSec() -> Int{
        let limitedSec = (monday ?? 0) + (tuesday ?? 0)
        let addSec = limitedSec + (wednesday ?? 0)
        let addNext = addSec + (thursday ?? 0)
        let addFri = addNext + (friday ?? 0)
        let addSat = addFri + (saturday ?? 0)
        let addSun = addSat + (sunday ?? 0)
        return addSun
    }
    func getMinutes()->Int {
        let totalHours = getAddedSec()
        let min = (totalHours % 3600) / 60
        return min
    }
    
    func getLimitedTime() -> String {
        let hour = getHours()
        let min = getMinutes()
        let str = "\(hour)h \(min)m"
        return str
    }
    func getTimeForSpecificDay(seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let str = "\(hours)h \(minutes)min"
        return str
    }
}
extension String {
    func getDateFromStr() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        if let date = dateFormatter.date(from: self) {
            print(date)
            return date
        } else {
            print("Error: Unable to convert the string to a Date.")
        }
        return Date()
    }
}
