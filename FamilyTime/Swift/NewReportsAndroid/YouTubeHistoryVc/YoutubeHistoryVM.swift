//
//  YoutubeHistoryVM.swift
//  FamilyTime
//
//  Created by Sufyan on 04/12/2023.
//  Copyright © 2023 YumyApps. All rights reserved.
//

import Foundation
enum AppHistorySegment {
    case day
    case week
    case month
}
    //Handle only three case for ease of code debugging, remaining reports handled by other controller
enum SocialHistoryType {
    case youtube
    case tiktok
    case web
}
class YoutubeHistoryVM: SegmentCellHandle {
    
    var tbleReloader: ()->() = {}
    var selectedSgment: AppHistorySegment = .day
    var isFrom: SocialHistoryType = .youtube
    var youtubeHistoryArr = [youtubeData]()
    var webHistoryArr = [AppHistortDataModel]()
    var year = 0
    
    func initMethod() {
        self.lblDate = self.getCurrentDateString()
        if self.isFrom == .web {
            self.webHistoryArr = self.getWebHistoryByDates(date: self.lblDate)
        } else {
            self.youtubeHistoryArr = self.getYoutubeDataByDates(date: self.lblDate)
            self.youtubeHistoryArr = self.youtubeHistoryArr.reversed()
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
                lblDate = getPreviousDateString(day: buttonSelected)
            }
            if self.isFrom == .web {
                webHistoryArr = getWebHistoryByDates(date: lblDate)
            }else{
                youtubeHistoryArr = getYoutubeDataByDates(date: lblDate)
            }
        case .week:
            currentDateForMonth = Date()
            if buttonSelected == 0 {
                currentDate = currentDate.dayAfter
                getPreviousSevenDays(value: -1)
            } else if buttonSelected == -1 {
                getPreviousSevenDays(value: buttonSelected)
            } else {
                getNextSevenDays(value: buttonSelected)
            }
            getWeeklyDataFromDB()
            break
        case .month:
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
            let monthNu =  monthNameToInt(lblDate) ?? 11
            if isFrom == .web {
                webHistoryArr = getWebByMonth(month: monthNu)
            }else {
                youtubeHistoryArr = getYoutubeDataByMonth(month:monthNu)
            }
            break
        }
        tbleReloader()
    }
    func getWeeklyDataFromDB() {
        youtubeHistoryArr.removeAll()
        webHistoryArr.removeAll()
        for obj in setsOfDates {
            if isFrom == .web {
                webHistoryArr += getWebHistoryByDates(date: obj)
            } else {
                youtubeHistoryArr += getYoutubeDataByDates(date: obj)
            }
        }
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
    func getYoutubeDataByDates(date: String) -> [youtubeData] {
        let childId = UserDefaults.standard.integer(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        let youtubeDB = DBManager.shared.fetchYoutubeHistorySevenDays(childID: "\(childId)", date: date, fetchType: isFrom)
        return youtubeDB
    }
    func getWebHistoryByDates(date: String) -> [AppHistortDataModel] {
        let childId = UserDefaults.standard.integer(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        let webDB = DBManager.shared.fetchWebHistoryData(childID: "\(childId)", date: date)
        return webDB
    }
    func getYoutubeDataByMonth(month: Int) -> [youtubeData] {
        let youtubeDB = DBManager.shared.fetchYTRecordsForMonth(month,year: year, fetchType: isFrom)
        return youtubeDB
    }
    func getWebByMonth(month: Int) -> [AppHistortDataModel] {
        let webDB = DBManager.shared.fetchWebRecordsForMonth(month, year: year)
        return webDB
    }
    func callApiToReloadHistory(callback: @escaping()->()) {
        switch isFrom {
        case .youtube:
            syncHistroy(param: "youtube_history", callback: callback)
            break
        case .tiktok:
            syncHistroy(param: "tiktok_history", callback: callback)
            break
        case .web:
            syncHistroy(param: "browsing_history", callback: callback)
            break
        }
    }
    private func syncHistroy(param: String,callback: @escaping()->()) {
        let childId = UserDefaults.standard.integer(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        HLApiManager.reloadSocialMonitor(childId: "\(childId)", para: param) { response, error in
            callback()
            if error == nil {
                print(response as Any)
            }else {
                print("error for reload social:",error as Any)
            }
        }
    }
}

class SegmentCellHandle {
    var lblDate = ""
    var setsOfDates: [String] = []
    var currentIndex = 0
    var currentDate = Date()
    var curDate = Date()
    var buttonSelected = -1
    var currentDateForMonth = Date()
    
    func getCurrentDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        dateFormatter.locale = Locale.current
        let currentDate = Date()
        let dateString = dateFormatter.string(from: currentDate)
        return dateString
    }
    func getPreviousDateString(day: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "dd MMMM yyyy"
        if let previousDate = Calendar.current.date(byAdding: .day, value: day, to: currentDate) {
            currentDate = previousDate
        }
        let dateString = dateFormatter.string(from: currentDate)
        return dateString
    }
    func getPreviousMonthString(day: Int) -> String {
        var modifiedDate = currentDateForMonth
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "MMMM"
        print(modifiedDate)
        if let previousDate = Calendar.current.date(byAdding: .month, value: day, to: modifiedDate) {
            modifiedDate = previousDate
        }
        currentDateForMonth = modifiedDate
        print(currentDateForMonth)
        let dateString = dateFormatter.string(from: modifiedDate)
        return dateString
    }
    func getPreviousMonthYear(day: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        if let previousDate = Calendar.current.date(byAdding: .month, value: day, to: currentDate) {
            currentDate = previousDate
        }
        let dateString = dateFormatter.string(from: currentDate)
        return dateString
    }
    func getCurrentMonthString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "MMMM"
        let currentDate = Date()
        let dateString = dateFormatter.string(from: currentDate)
        return dateString
    }
    func getPreviousSevenDays(value: Int) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "dd MMMM yyyy"
        var datesArray: [String] = []
        for i in 1...7 {
            if let date = Calendar.current.date(byAdding: .day, value: -i, to: currentDate) {
                datesArray.append(getStringFromDate(date))
            }
        }
        currentDate = Calendar.current.date(byAdding: .day, value: -7, to: currentDate) ?? currentDate
        curDate = currentDate.dayBefore
        let first = datesArray[0].dropLast(4)
        let sec = datesArray[6].dropLast(4)
        lblDate = sec + "- " + first
        setsOfDates = datesArray
    }
    func getNextSevenDays(value: Int) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "dd MMMM yyyy"
        var datesArray: [String] = []
        currentDate = Calendar.current.date(byAdding: .day, value: 7, to: currentDate) ?? currentDate
        curDate = Calendar.current.date(byAdding: .day, value: 7, to: curDate) ?? curDate
        for i in 1...7 {
            if let date = Calendar.current.date(byAdding: .day, value: i, to: curDate) {
                datesArray.append(getStringFromDate(date))
            }
        }
        
        let first = datesArray[0].dropLast(4)
        let sec = datesArray[6].dropLast(4)
        lblDate = first + "- " + sec
        setsOfDates = datesArray
    }
    func getDateFromString(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "dd MMMM yyyy"

        if let date = dateFormatter.date(from: dateString) {
            return date
        } else {
            print("Unable to convert string to date.")
            return nil
        }
    }
    func getStringFromDate(_ dateString: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        let date = dateFormatter.string(from: dateString)
        return date
    }
    func convertToShortTimeString(_ dateString: String, dateFormat: String, timeFormat: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = dateFormat
        
        if let date = dateFormatter.date(from: dateString) {
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = timeFormat
            let shortTimeString = timeFormatter.string(from: date)
            return shortTimeString
        } else {
            print("Invalid date format or string.")
            return nil
        }
    }
}
