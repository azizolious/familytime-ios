//
//  ReportsApiManager.swift
//  FamilyTime
//
//  Created by Sufyan on 01/01/2024.
//  Copyright © 2024 YumyApps. All rights reserved.
//

import Foundation

final class ReportsApiManager{
    static let Shared = ReportsApiManager()
    private init(){}
    func callAllReports(loaderView: UIView) {
        //        handleSMSApi(isFirstTime: true, startDate: nil, loaderView: loaderView)
        callSocialApi()
        callWebHisApi()
        callTikTokApi()
        callYTApi()
        loadContacts()
        getTimeBank()
        getCalls()
        callLocationHisApi()
        if DBManager.shared.isAnyOldChildExist() {
            getAppUsage()
        }
        if DBManager.shared.isAnyNewChildExist() {
            getV1AppUsage()
        }
        familyFeed()
    }
    func callDrawerReports() {
        callSocialApi()
        callWebHisApi()
        callTikTokApi()
        callYTApi()
    }
    func handleSMSApi(isFirstTime: Bool, startDate: String?, loaderView: UIView) {
        var params: [String: Any] = [:]
        if let startDate = startDate {
            params["start_date"] = startDate
        }
        CoreManager.getTextMsgs(params: params, isFirstTime: isFirstTime, loaderView: loaderView) { hasMoreData in
            if hasMoreData {
                if let latestMsgTime = DBManager.shared.getLatestTextMsgs().first?.sms_time {
                    let nextTime = self.addOneMinuteToDateString(latestMsgTime)
                    self.handleSMSApi(isFirstTime: false, startDate: nextTime, loaderView: loaderView)
                }
            }else{
                loaderVisibility(view: loaderView,show: false)
                let sms = DBManager.shared.fetchTextMsgs()
                //                SwiftFTUtils.hideHUDAdded(to: loaderView, animated: true)
            }
        }
    }
    //    func handleSMSApi() {
    //        let msgs = DBManager.shared.getLatestTextMsgs()
    //        if msgs.count == 0 {
    //            CoreManager.getTextMsgs(isFirstTime: true)
    //        } else {
    //            let time = msgs.first?.sms_time ?? ""
    //            let increaseTime = addOneMinuteToDateString(time)
    //            let param = ["start_date": increaseTime ?? ""]
    //            CoreManager.getTextMsgs(params: param, isFirstTime: false)
    //        }
    //    }
    
    func familyFeed() {
        let feed = DBManager.shared.getLatestFamilyFeed()
        if feed.count == 0 {
            CoreManager.getFamilyFeed(isFirstTime: true)
        } else {
            let time = feed.first?.requestedTime ?? ""
            let increaseTime = addOneMinuteToDateString(time)
            let param = ["start_date": increaseTime ?? ""]
            CoreManager.getFamilyFeed(params: param, isFirstTime: false)
        }
    }
    
    //    func familyFeed() {
    //        let url = HLConstants.BASE_URL_CORE_2 + "family-feed"
    //        CoreManager.networkRequest(url: url, method: .get) { (response: FamilyFeedModel?, statusCode, errorMessage) in
    //            if errorMessage == nil {
    //                if let feedData = response?.data {
    //                    print(feedData)
    ////                    DBManager.shared.deleteData(entityName: "TimeBank")
    ////                    DBManager.shared.saveTimeBank(myModelArray: timeBank)
    //                }
    //            } else {
    //                CommonModel.showAlert("alert_error".localized, msg: errorMessage)
    //            }
    //        }
    //    }
    
    func callSocialApi() {
        socialMediaCall()
    }
    func getTimeBank() {
        let url = HLConstants.BASE_URL_CORE_2 + "reports/time-bank"
        CoreManager.networkRequest(url: url, method: .get) { (response: TimeBankCodableModel?, statusCode, errorMessage) in
            if errorMessage == nil {
                if let timeBank = response?.timeBank {
                    DBManager.shared.deleteData(entityName: "TimeBank")
                    DBManager.shared.saveTimeBank(myModelArray: timeBank)
                }
            } else {
                CommonModel.showAlert("alert_error".localized, msg: errorMessage)
            }
        }
    }
    func getCalls() {
        let url = HLConstants.BASE_URL_CORE_2 + "reports/calls"
        CoreManager.networkRequest(url: url, method: .get) { (response: CallsModel?, statusCode, errorMessage) in
            if errorMessage == nil {
                if let calls = response?.calls {
                    print(calls)
                    DBManager.shared.deleteData(entityName: "Calls")
                    DBManager.shared.saveCalls(calls: calls)
                }
            } else {
                CommonModel.showAlert("alert_error".localized, msg: errorMessage)
            }
        }
    }
    
    func getAppUsage() {
        let url = HLConstants.BASE_URL_CORE_2 + "reports/app-usage"
        CoreManager.networkRequest(url: url, method: .get) { (response: AppUsageModelCore?, statusCode, errorMessage) in
            if errorMessage == nil {
                if let usage = response?.appUsage {
                    print(usage)
                    DBManager.shared.deleteData(entityName: "AppUsageCore")
                    DBManager.shared.saveAppUsage(appUsage: usage)
                }
            } else {
                CommonModel.showAlert("alert_error".localized, msg: errorMessage)
            }
        }
        
    }
    
    func getV1AppUsage() {
        // Check if app usage data already exists for this childID
        let dataExists = DBManager.shared.doesAppUsageExist()
        
        if dataExists {
            // If data exists, fetch the most recent date from Core Data
            if let mostRecentDate = DBManager.shared.getMostRecentAppUsageDate() {
                // Call the API with the most recent date
                getAppUsageWithTime(fromDate: mostRecentDate)
            } else {
                print("No Date Found.")
            }
            
        } else {
            // If no data exists, call the API without filtering by date
            getFirstTimeAppUsage()
        }
    }
    
    func getAppUsageWithTime(fromDate: String) {
        
        let url = HLConstants.BASE_URL_CORE_2 + "reports/v1/app-usage"
        
        // Append the 'fromDate' to the URL if necessary (adjust the API request format if needed)
        let apiUrl = url + "?start_date=\(fromDate)"
        
        // Make the network request to fetch app usage data
        CoreManager.networkRequest(url: apiUrl, method: .get) { (response: AppUsageV1Model?, statusCode, errorMessage) in
            if errorMessage == nil {
                // If data is received from the API
                if let usage = response?.appUsage {
                    // Remove data from Core Data for the most recent date
                    DBManager.shared.deleteDataForDate(entityName: "V1AppUsage", date: fromDate)
                    
                    // Save the new app usage data from the API to Core Data
                    DBManager.shared.saveV1AppUsage(appUsage: usage)
                    
                } else {
                    // If no data is returned from the API, stop the loop
                    print("No app usage data received from the API.")
                }
            } else {
                // Handle any error in the API request
                print("error recieved: ", errorMessage ?? "")
            }
        }
    }
    
    func getFirstTimeAppUsage() {
        let url = HLConstants.BASE_URL_CORE_2 + "reports/v1/app-usage"
        CoreManager.networkRequest(url: url, method: .get) { (response: AppUsageV1Model?, statusCode, errorMessage) in
            if errorMessage == nil {
                if let usage = response?.appUsage {
                    print(usage)
                    DBManager.shared.deleteData(entityName: "V1AppUsage")
                    DBManager.shared.saveV1AppUsage(appUsage: usage)
                    if let newMostRecentDate = usage.last?.dateUsage {
                        print("most recent time in first time: ", newMostRecentDate)
                        self.getAppUsageWithTime(fromDate: newMostRecentDate)
                    }
                }
            } else {
                print("error received: ", errorMessage ?? "")
            }
        }
    }
    
    func loadContacts() {
        let urlCore = HLConstants.BASE_URL_CORE_2 + "reports/contacts"
        let contactHis = DBManager.shared.fetchAllSocialHistory()
        if contactHis.count == 0 {
            CoreManager.networkRequest(url: urlCore, method: .get) { (response: ContactsCodableModel?, statusCode, message) in
                if let contacts = response?.contacts{
                    DBManager.shared.deleteData(entityName: "ContactsTable")
                    DBManager.shared.saveContacts(myModelArray: contacts)
                }
            }
        } else {
            let time = contactHis.first?.date ?? ""
            let increaseTime = addOneMinuteToDateString(time)
            let param = ["start_date": increaseTime ?? ""]
            CoreManager.networkRequest(url: urlCore,method: .get, params: param) { (response: ContactsCodableModel?, statusCode, message) in
                if let contacts = response?.contacts{
                    DBManager.shared.saveContacts(myModelArray: contacts)
                }
            }
        }
    }
    
    func callWebHisApi() {
        let socialHis = DBManager.shared.fetchAllSocialHistory()
        if socialHis.count == 0 {
            HLApiManager.webHistoryAPI(url: HLConstants.URLs.AppHistory.Web_History) { response, error in
                if let responseData = response?.data {
                    CoreDataUtility.delete_ChildDataFromDB(entity: CoredataKeys.Entities.APP_HISTORY_DATA)
                    DispatchQueue.main.async {
                        CoreDataUtility.saveAppHistoryData(appData: responseData)
                    }
                }
            }
        } else {
            let time = socialHis.first?.date ?? ""
            let increaseTime = addOneMinuteToDateString(time)
            let param = ["start_date": increaseTime ?? ""]
            HLApiManager.webHistoryAPI(params:param,url: HLConstants.URLs.AppHistory.Web_History) { response, error in
                if let responseData = response?.data {
                    if responseData.count != 0 {
                        DispatchQueue.main.async {
                            CoreDataUtility.saveAppHistoryData(appData: responseData)
                        }
                    }
                }
            }
        }
    }
    
    func callTikTokApi() {
        let socialHis = DBManager.shared.fetchAllYoutubeHistory(fetchType: .tiktok)
        if socialHis.count == 0 {
            HLApiManager.youtubeHistoyApi(url: HLConstants.URLs.AppHistory.TikToke_History) { response, error in
                if let responseData = response?.data {
                    CoreDataUtility.delete_ChildDataFromDB(entity: CoredataKeys.Entities.APP_TIKTOK_DATA)
                    DispatchQueue.main.async {
                        CoreDataUtility.saveTiktokData(appData: responseData)
                    }
                }
            }
        }else {
            let time = socialHis.first?.timeVisit ?? ""
            let increaseTime = addOneMinuteToDateString(time)
            let param = ["start_date": increaseTime ?? ""]
            HLApiManager.youtubeHistoyApi(params:param,url: HLConstants.URLs.AppHistory.TikToke_History) { response, error in
                if let responseData = response?.data {
                    if responseData.count != 0 {
                        DispatchQueue.main.async {
                            CoreDataUtility.saveTiktokData(appData: responseData)
                        }
                    }
                }
            }
        }
    }
    
    func callYTApi() {
        let socialHis = DBManager.shared.fetchAllYoutubeHistory(fetchType: .youtube)
        if socialHis.count == 0 {
            HLApiManager.youtubeHistoyApi(url: HLConstants.URLs.AppHistory.Youtube_History) { response, error in
                if let responseData = response?.data {
                    CoreDataUtility.delete_ChildDataFromDB(entity: CoredataKeys.Entities.APP_YOUTUBE_DATA)
                    DispatchQueue.main.async {
                        CoreDataUtility.saveYoutubeHistoryData(appData: responseData)
                    }
                }
            }
        }else {
            let time = socialHis.first?.timeVisit ?? ""
            let increaseTime = addOneMinuteToDateString(time)
            let param = ["start_date": increaseTime ?? ""]
            HLApiManager.youtubeHistoyApi(params:param,url: HLConstants.URLs.AppHistory.Youtube_History) { response, error in
                if let responseData = response?.data {
                    if responseData.count != 0 {
                        DispatchQueue.main.async {
                            CoreDataUtility.saveYoutubeHistoryData(appData: responseData)
                        }
                    }
                }
            }
        }
    }
    
    func socialMediaCall() {
        let obj = DBManager.shared.fetchAllSocialHistory()
        if obj.count == 0 {
            HLApiManager.socialAppsHistoryCall(url: HLConstants.URLs.AppHistory.social_History) { response, error in
                if let socialApps = response?.socialApps {
                    DispatchQueue.main.async {
                        DBManager.shared.deleteData(entityName: CoredataKeys.Entities.SOCIAL_HISTORY_DATA)
                        DBManager.shared.saveSocialHistoryToCoreData(myModelArray: socialApps)
                    }
                }
            }
        } else {
            let date = obj.last?.date ?? ""
            let dateTo = addOneMinuteToDateString(date) ?? ""
            let parameter = ["start_date":dateTo]
            HLApiManager.socialAppsHistoryCall(params: parameter,url: HLConstants.URLs.AppHistory.social_History) { response, error in
                if let socialApps = response?.socialApps {
                    if socialApps.count > 0 {
                        DispatchQueue.main.async {
                            DBManager.shared.saveSocialHistoryToCoreData(myModelArray: socialApps)
                        }
                    }
                }
            }
        }
    }
    func addOneMinuteToDateString(_ dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        if let date = dateFormatter.date(from: dateString) {
            let modifiedDate = date.addingTimeInterval(3)
            let modifiedDateString = dateFormatter.string(from: modifiedDate)
            return modifiedDateString
        } else {
            print("Invalid date string format")
            return nil
        }
    }
    func callLocationHisApi() {
        let locHis = DBManager.shared.fetchAllLocationHistory()
        let url = HLConstants.BASE_URL_CORE_2 + "reports/locations"
        if locHis.count == 0 {
            CoreManager.networkRequest(url: url, method: .get) { (response: LocationHistoryCodableModel? , statusCode, message) in
                
                if (200...210).contains(statusCode ?? 0) {
                    if let his = response?.data {
                        DBManager.shared.deleteData(entityName: "LocationsHistory")
                        DBManager.shared.saveLocationHis(myModelArray: his)
                    }
                }
            }
        } else {
            let time = locHis.first?.timeIn ?? ""
            let increaseTime = addOneMinuteToDateString(time)
            let param = ["start_date": increaseTime ?? ""]
            CoreManager.networkRequest(url: url, method: .get, params: param) { (response: LocationHistoryCodableModel? , statusCode, message) in
                if (200...210).contains(statusCode ?? 0) {
                    if let his = response?.data {
                        DBManager.shared.saveLocationHis(myModelArray: his)
                    }
                }
            }
        }
    }
}
