//
//  CommonModel.swift
//  FamilyTime
//
//  Created by Sufyan on 31/07/2024.
//  Copyright © 2024 YumyApps. All rights reserved.
//

import Foundation

enum FeedItemType {
    case tiktok
    case youtube
    case webHistory
    case call
    case sms
    case contact
    case sos
    case pickMeUp
    case appApprove
    case previousAppApprove
    case lowBattery
    case acknowledgeBattery
    case powerConnected
//    case place
    case sstRunning
    case sstStopped
    case internetScheduleRunning
    case internetScheduleStopped
    case unblockApp
    case uninstallApp
    case checkin
    case checkout
}

struct FeedItem {
    let type: FeedItemType
    let createdAt: String?
    let title: String?
    let subTitle: String?
    let miniSubtitle: String?
    let url: String?
    let subType: String?
    let childID: Int?
}

extension FeedItem {
    static func fromTikTokData(_ data: youtubeData) -> FeedItem {
        let childName = DBManager.shared.fetchChildName(byID: data.childID ?? 0) ?? "Unknown Child"
        return FeedItem(type: .tiktok, createdAt: data.timeVisit, title: data.title, subTitle: "", miniSubtitle: childName, url: data.url, subType: "", childID: data.childID)
    }
    static func fromYouTubeData(_ data: youtubeData) -> FeedItem {
        let childName = DBManager.shared.fetchChildName(byID: data.childID ?? 0) ?? "Unknown Child"
        return FeedItem(type: .youtube, createdAt: data.timeVisit, title: data.title, subTitle: "", miniSubtitle: childName, url: data.url, subType: "", childID: data.childID)
    }
    static func fromWebHistoryData(_ data: AppHistortDataModel) -> FeedItem {
        let childName = DBManager.shared.fetchChildName(byID: data.childID ?? 0) ?? "Unknown Child"
        return FeedItem(type: .webHistory, createdAt: data.timeVisit, title: data.title, subTitle: data.domain, miniSubtitle: childName, url: data.url, subType: "", childID: data.childID)
    }
    static func fromCallData(_ data: Call) -> FeedItem {
        let childName = DBManager.shared.fetchChildName(byID: data.childID ?? 0) ?? "Unknown Child"
        return FeedItem(type: .call, createdAt: data.callTime, title: "Call", subTitle: data.name, miniSubtitle: childName, url: data.duration, subType: data.type, childID: data.childID)
    }
    static func fromSmsData(_ data: MessageThreadData) -> FeedItem {
        let childName = DBManager.shared.fetchChildName(byID: data.child_id ?? 0) ?? "Unknown Child"
        return FeedItem(type: .sms, createdAt: data.sms_time, title: data.type?.capitalizedFirstLetter(), subTitle: data.contact_name, miniSubtitle: childName, url: "", subType: "", childID: data.child_id)
    }
    static func fromContactData(_ data: ContactObj) -> FeedItem {
        let childName = DBManager.shared.fetchChildName(byID: data.childID ?? 0) ?? "Unknown Child"
        return FeedItem(type: .contact, createdAt: data.contactTime, title: "Contacts", subTitle: data.name, miniSubtitle: childName, url: "", subType: "", childID: data.childID)
    }
    static func fromFamilyTimeDatum(_ datum: FamilyTime.Datum) -> FeedItem? {
        guard let jsonData = datum.data?.data(using: .utf8) else {
            return nil
        }
        let decoder = JSONDecoder()
        switch datum.type {
        case "sos":
            if let sosData = try? decoder.decode(SOSData.DataContent.self, from: jsonData) {
                return FeedItem(type: .sos, createdAt: datum.requestedTime, title: "SOS", subTitle: "", miniSubtitle: sosData.device_name, url: nil, subType: "", childID: 0)
            }
        case "pick_me_up":
            if let pickMeUpData = try? decoder.decode(SOSData.DataContent.self, from: jsonData) {
                return FeedItem(type: .pickMeUp, createdAt: datum.requestedTime, title: "Pick Me Up", subTitle: "", miniSubtitle: pickMeUpData.device_name, url: nil, subType: "", childID: 0)
                
            }
        case "charging_started":
            if let chargingStartedData = try? decoder.decode(ChargingStartedData.DataContent.self, from: jsonData) {
                return FeedItem(type: .powerConnected, createdAt: datum.requestedTime, title: "Power Connected", subTitle: chargingStartedData.percent, miniSubtitle: chargingStartedData.device_name, url: "", subType: "", childID: 0)
                
            }
        case "low_battery":
            if let lowBatteryData = try? decoder.decode(LowBatteryData.DataContent.self, from: jsonData) {
                return FeedItem(type: .lowBattery, createdAt: datum.requestedTime, title: "Low Battery", subTitle: lowBatteryData.percent, miniSubtitle: lowBatteryData.device_name, url: "", subType: "", childID: 0)
                
            }
        case "low_battery_acknowledge":
            if let lowBatteryAcknowledgeData = try? decoder.decode(BatteryData.self, from: jsonData) {
                return FeedItem(type: .acknowledgeBattery, createdAt: datum.requestedTime, title: "Acknowledged", subTitle: "", miniSubtitle: lowBatteryAcknowledgeData.device_name, url: nil, subType: "", childID: 0)
                
            }
        case "new_app_approve":
            if let appApproveData = try? decoder.decode(NewAppApproveData.DataContent.self, from: jsonData) {
                return FeedItem(type: .appApprove, createdAt: datum.requestedTime, title: "Approve New App", subTitle: appApproveData.app_name, miniSubtitle: appApproveData.device_name, url: "", subType: "", childID: 0)
            }
            
        case "previous_app_approve":
            if let appApproveData = try? decoder.decode(PreviousAppApproveData.DataContent.self, from: jsonData) {
                return FeedItem(type: .previousAppApprove, createdAt: datum.requestedTime, title: "App Access Request", subTitle: appApproveData.app_name, miniSubtitle: appApproveData.device_name, url: "", subType: "", childID: 0)
            }
        case "sst_rule_running":
            if let sstData = try? decoder.decode(SSTRuleData.DataContent.self, from: jsonData) {
                return FeedItem(type: .sstRunning, createdAt: datum.requestedTime, title: "ScreenTime Schedule", subTitle: "Running", miniSubtitle: sstData.device_name, url: "", subType: "", childID: 0)
            }
        case "sst_rule_stopped_running":
            if let sstData = try? decoder.decode(SSTRuleData.DataContent.self, from: jsonData) {
                return FeedItem(type: .sstStopped, createdAt: datum.requestedTime, title: "ScreenTime Schedule", subTitle: "Stopped", miniSubtitle: sstData.device_name, url: "", subType: "", childID: 0)
            }
        case "internet_schedule_rule_running":
            if let internetScheduleData = try? decoder.decode(InternetScheduleRuleRunningData.self, from: jsonData) {
                let childName = DBManager.shared.fetchChildName(byID: internetScheduleData.child_id ?? 0) ?? "Unknown Child"
                return FeedItem(type: .internetScheduleRunning, createdAt: internetScheduleData.requested_time, title: "Schedule Internet", subTitle: "Running", miniSubtitle: childName, url: "", subType: "", childID: 0)
            }

        case "internet_schedule_rule_stopped_running":
            if let internetScheduleData = try? decoder.decode(InternetScheduleRuleRunningData.self, from: jsonData) {
                let childName = DBManager.shared.fetchChildName(byID: internetScheduleData.child_id ?? 0) ?? "Unknown Child"
                return FeedItem(type: .internetScheduleStopped, createdAt: internetScheduleData.requested_time, title: "Schedule Internet", subTitle: "Stopped", miniSubtitle: childName, url: "", subType: "", childID: 0)
            }
        case "uninstall_app":
            if let appUninstallData = try? decoder.decode(UninstallAppData.DataContent.self, from: jsonData) {
                return FeedItem(type: .uninstallApp, createdAt: datum.requestedTime, title: "App Uninstalled", subTitle: appUninstallData.app_name, miniSubtitle: appUninstallData.device_name, url: "", subType: "", childID: 0)
            }
            
        case "checkin":
            if let checkinData = try? decoder.decode(CheckinOutData.DataContent.self, from: jsonData) {
                let childName = DBManager.shared.fetchChildName(byID: datum.childID ?? 0) ?? "Unknown Child"
                return FeedItem(type: .checkin, createdAt: datum.requestedTime, title: "Check-in", subTitle: checkinData.place_name, miniSubtitle: childName, url: "", subType: "", childID: 0)
            }
        case "checkout":
            if let checkoutData = try? decoder.decode(CheckinOutData.DataContent.self, from: jsonData) {
                let childName = DBManager.shared.fetchChildName(byID: datum.childID ?? 0) ?? "Unknown Child"
                return FeedItem(type: .checkout, createdAt: datum.requestedTime, title: "Check-out", subTitle: checkoutData.place_name, miniSubtitle: childName, url: "", subType: "", childID: 0)
            }
//        case "place":
//            if let placeData = try? decoder.decode(PlaceData.self, from: jsonData) {
//                let title: String
//                switch placeData.subtype {
//                case "checkin":
//                    title = "Check-in"
//                case "checkout":
//                    title = "Check-out"
//                default:
//                    title = "Place Update"
//                }
//                return FeedItem(type: .place, createdAt: datum.requestedTime, title: title, subTitle: "", miniSubtitle: placeData.place_name, url: nil, subType: placeData.subtype, childID: 0)
//            }
        default:
            return nil
        }
        return nil
    }
}

extension String {
    func capitalizedFirstLetter() -> String {
        guard !isEmpty else { return self }
        return prefix(1).uppercased() + dropFirst().lowercased()
    }
}
