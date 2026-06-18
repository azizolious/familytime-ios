//
//  SocialHistoryVM.swift
//  FamilyTime
//
//  Created by Sufyan on 21/12/2023.
//  Copyright © 2023 YumyApps. All rights reserved.
//

import Foundation

enum HistoryType: String{
    case whatsapp = "com.whatsapp"
    case bwhatsapp = "com.whatsapp.w4b"
    case bip = "com.turkcell.bip"
    case instagram = "com.instagram.android"
    case imo = "com.imo.android.imoim"
    case signal = "org.thoughtcrime.securesms"
    case twitch = "tv.twitch.android.app"
    case tiktok = "com.zhiliaoapp.musically"
}

class SocialHistoryVM: SegmentCellHandle {
    
    var tbleReloader: ()->() = {}
    var selectedSgment: AppHistorySegment = .day
    var isFrom: HistoryType = .whatsapp
    var historyArr = [SocialApp]()
    var inbox = [SocialApp]()
    var year = 0
    var groupe: [String: [SocialApp]] = [:]
    var keys:[String] = []
    var relaoding = false
    
    func initMethod() {
        self.lblDate = self.getCurrentDateString()
        if self.isFrom == .whatsapp || self.isFrom == .bwhatsapp  {
            self.inbox = self.getAllHistory()
            var groupedMessages: [String: [SocialApp]] = [:]

            for message in self.inbox {
                if var senderMessages = groupedMessages[message.contactName ?? ""] {
                    senderMessages.append(message)
                    groupedMessages[message.contactName ?? ""] = senderMessages
                } else {
                    groupedMessages[message.contactName ?? ""] = [message]
                }
            }
            self.groupe = groupedMessages
            let key = Array(groupe.keys)
            self.keys = key.sorted(by: {self.groupe[$0]?.last?.date?.getDateFromStr() ?? Date() > self.groupe[$1]?.last?.date?.getDateFromStr() ?? Date()})
        } else {
            self.historyArr = self.getSocialDataByDates(date: self.lblDate)
            getHistryAndMakeInbox()
        }
        self.tbleReloader()
    }
    
    
    func callMethodsBySegments() {
        print(currentIndex)
        switch selectedSgment {
        case .day:
            currentDateForMonth = Date()
            if buttonSelected == 0 {
                lblDate = getCurrentDateString()
            } else {
                lblDate = getPreviousDateString(day: relaoding ? 0 : buttonSelected)
                relaoding = false
            }
            self.historyArr = self.getSocialDataByDates(date: self.lblDate)
            getHistryAndMakeInbox()
        case .week:
            if !relaoding {
                currentDateForMonth = Date()
                if buttonSelected == 0 {
                    currentDate = currentDate.dayAfter
                    getPreviousSevenDays(value: -1)
                } else if buttonSelected == -1 {
                    getPreviousSevenDays(value: buttonSelected)
                } else {
                    getNextSevenDays(value: buttonSelected)
                }
            }
            relaoding = false
            getWeeklyDataFromDB()
            getHistryAndMakeInbox()
            break
        case .month:
            if !relaoding {
                if buttonSelected == 0 {
                    lblDate = getCurrentMonthString()
                    let calendar = Calendar.current
                    let currentDate = Date()
                    let currentYear = calendar.component(.year, from: currentDate)
                    year = currentYear
                } else {
                    let prev = getPreviousMonthString(day: buttonSelected)
                    lblDate = prev
                    year = Int(getPreviousMonthYear(day: buttonSelected)) ?? 2024
                }
                
            }
            relaoding = false
            let monthNu =  monthNameToInt(lblDate) ?? 11
            self.historyArr = getSocialDataByMonth(month: monthNu)
            getHistryAndMakeInbox()
            break
        }
        tbleReloader()
    }
    func getWeeklyDataFromDB() {
        historyArr.removeAll()
        for obj in setsOfDates {
            historyArr += self.getSocialDataByDates(date: obj)
        }
    }
    
    func getHistryAndMakeInbox() {
        var groupedMessages: [String: [SocialApp]] = [:]
        for message in self.historyArr {
            if var senderMessages = groupedMessages[message.contactName ?? ""] {
                senderMessages.append(message)
                groupedMessages[message.contactName ?? ""] = senderMessages
            } else {
                groupedMessages[message.contactName ?? ""] = [message]
            }
        }
        self.groupe = groupedMessages
        let key = Array(groupe.keys)
        self.keys = key.sorted(by: {self.groupe[$0]?.last?.date?.getDateFromStr() ?? Date() > self.groupe[$1]?.last?.date?.getDateFromStr() ?? Date()})
    }
    
    func monthNameToInt(_ monthName: String) -> Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        
        if let date = dateFormatter.date(from: monthName) {
            let month = Calendar.current.component(.month, from: date)
            return month
        } else {
            print("Invalid month name.")
            return nil
        }
    }
    func getSocialDataByDates(date: String) -> [SocialApp] {
        let historyDB = DBManager.shared.fetchSocialAppsHistory(appIdentifier: isFrom.rawValue, 
                                                                date: date)
        return historyDB
    }
    func getSocialAppMegs(name: String) -> [SocialApp] {
        let historyDB = DBManager.shared.fetchSocialAppsMsg(appIdentifier: isFrom.rawValue, 
                                                            thread: name)
        return historyDB
    }
    func getAllHistory() -> [SocialApp] {
        let webDB = DBManager.shared.fetchAllSocialHistory(appIdentifier: isFrom.rawValue)
        return webDB
    }
    func getSocialDataByMonth(month: Int) -> [SocialApp] {
        let socialDB = DBManager.shared.fetchSocialForMonth(month, year: year, 
                                                            appIdentifier: isFrom.rawValue)
        return socialDB
    }

    func callApiToReloadHistory(callback: @escaping()->()) {
        syncHistroy(param: "social_monitoring", callback: callback)

    }
    private func syncHistroy(param: String,callback: @escaping()->()) {
        let childId = UserDefaults.standard.integer(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        HLApiManager.reloadSocialMonitor(childId: "\(childId)", 
                                         para: param) { response, error in
            callback()
            if error == nil {
                print(response as Any)
            }else {
                print("error for reload social:",error as Any)
            }
        }
    }
}
