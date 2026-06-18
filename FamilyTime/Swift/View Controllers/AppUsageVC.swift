//
//  AppUsageVC.swift
//  FamilyTime
//
//  Created by Sana Ullah on 18/09/2019.
//  Copyright © 2019 YumyApps. All rights reserved.
//

import UIKit
import DropDown


class AppUsageVC: UIViewController {
    
    //    @IBOutlet weak var tfDropDown: DropDown!
    
    @IBOutlet weak var totalTimeLbl: UILabel!
    @IBOutlet weak var lastDayLbl:   UILabel!
    @IBOutlet weak var dateRangeLbl: UILabel!
    @IBOutlet weak var mostUsedLabel: UILabel!
    
    @IBOutlet weak var daysBtn: UIButton!
    @IBOutlet weak var tableVu: UITableView!
    
    @IBOutlet weak var noDataVu: UIView!
    @IBOutlet weak var itSeemsLikeLbl: UILabel!
    @IBOutlet weak var oopsLabel: UILabel!
    
    
    var total:Int32 = 0
    var day_count = 1
    
    var delegate : AppDelegate?
    
    var appUsageModel = AppUsageModel()
    var dropDown = DropDown()
    let child_Id = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        initialization()
    }
    func initialization(){
        
        self.title = "app_usage_title".localized
        self.mostUsedLabel.text = "app_usage_content_1".localized
//        ZendeskChatManager.trackEvent("App Usage Screen")
        itSeemsLikeLbl.text = "app_usage_content_2".localized
        self.oopsLabel.text = "oops_title".localized
        delegate = AppDelegate.getSharedAppDelegateForSwift()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LiveVisitorManager.shared.updateScreen(
            "App Usage"
        )
        if day_count == 1 {
            self.lastDayLbl.text = "date_drop_down_2".localized
            self.updateDateLabel(isToday: false)
        } else if day_count == 7 {
            self.lastDayLbl.text = "date_drop_down_3".localized
            self.updateDateLabelForMoreDays(index: 2)
        } else if day_count == 14 {
            self.lastDayLbl.text = "date_drop_down_4".localized
            self.updateDateLabelForMoreDays(index: 3)
        } else if day_count == 30 {
            self.lastDayLbl.text = "date_drop_down_5".localized
            self.updateDateLabelForMoreDays(index: 4)
        } else {
            self.lastDayLbl.text = "date_drop_down_1".localized
            self.updateDateLabel(isToday: true)
        }
        fetchAppUsage()
        //        apiCall()
        dropDownSetup()
    }
    
    func fetchAppUsage() {
        
        let calendar = Calendar.current
        var endDate: Date
        var startDate: Date
        
        switch day_count {
        case 0: // Today
            startDate = calendar.startOfDay(for: Date())
            endDate = calendar.startOfDay(for: Date()) // Same day
            
        case 1: // Yesterday
            endDate = calendar.date(byAdding: .day, value: -1, to: calendar.startOfDay(for: Date()))!
            startDate = endDate // Yesterday only
            
        case 7: // Last 7 days excluding today
            endDate = calendar.date(byAdding: .day, value: -1, to: calendar.startOfDay(for: Date()))! // Yesterday
            startDate = calendar.date(byAdding: .day, value: -7, to: endDate)! // Last 7 days from yesterday
            
        case 14: // Last 14 days excluding today
            endDate = calendar.date(byAdding: .day, value: -1, to: calendar.startOfDay(for: Date()))! // Yesterday
            startDate = calendar.date(byAdding: .day, value: -14, to: endDate)! // Last 14 days from yesterday
            
        case 30: // Last 30 days excluding today
            endDate = calendar.date(byAdding: .day, value: -1, to: calendar.startOfDay(for: Date()))! // Yesterday
            startDate = calendar.date(byAdding: .day, value: -30, to: endDate)! // Last 30 days from yesterday
            
        default:
            return // Exit the function for unsupported cases
        }
        
        fetchAppUsageDataBasedOnChildVersion(
            childID: Int(child_Id ?? "") ?? 0,
            startDate: startDate,
            endDate: endDate
        )
    }
    
    func fetchAppUsageDataBasedOnChildVersion(childID: Int, startDate: Date, endDate: Date) {
        // Fetch the child with the given ID
        guard let child = DBManager.shared.fetchChild(byID: childID) else {
            print("No child found with ID \(childID)")
            return
        }
        
        // Ensure the device is "android"
        guard let device = child.device, device.lowercased() == "android" else {
            print("Child is not using an Android device")
            return
        }
        
        // Check if the versionNumber contains ".ps" and apply the condition
        if let versionNumber = child.versionNumber, versionNumber.contains(".ps") {
            if let versionCode = child.versionCode, versionCode < "3444" {
                // Call the function for older ".ps" version
                let usage = DBManager.shared.fetchAppUsage(childID: Int(child_Id ?? "") ?? 0, startDate: startDate, endDate: endDate)
                self.populateDataWithUsage(usage: usage)
                
                return
            }
        } else {
            // Check if the versionCode is <= 4357 for non-.ps versions
            if let versionCode = child.versionCode, versionCode <= "4357" {
                // Call the function for newer version without ".ps"
                let usage = DBManager.shared.fetchAppUsage(childID: Int(child_Id ?? "") ?? 0, startDate: startDate, endDate: endDate)
                self.populateDataWithUsage(usage: usage)
                return
            }
        }
        
        // If no conditions are met, call the V1 App Usage function
        let usage = DBManager.shared.fetchV1AppUsage(childID: Int(child_Id ?? "") ?? 0, startDate: startDate, endDate: endDate)
        self.populateV1DataWithUsage(usage: usage)
    }
    
    func populateDataWithUsage(usage: [String: Any]) {
        guard let appUsage = usage["appusage"] as? [[String: Any]] else {
            print("Error: No app usage data found")
            return
        }
        
        var totalUsage: Int = 0
        let appUsageModel = AppUsageModel()
        var appUsageDictionary: [String: Int] = [:]
        for appData in appUsage {
            guard let totalAppUsage = appData["total_app_usage"] as? Int,
                  let appName = appData["app_name"] as? String else {
                print("Error: Incomplete app data")
                continue
            }
            
            if let existingUsage = appUsageDictionary[appName] {
                appUsageDictionary[appName] = existingUsage + totalAppUsage
            } else {
                appUsageDictionary[appName] = totalAppUsage
            }
            
            totalUsage += totalAppUsage
        }
        
        var appUsageInnerModels: [AppUsageInnerModel] = []
        appUsageInnerModels.removeAll()
        for (appName, totalAppUsage) in appUsageDictionary {
            let appUsageInnerModel = AppUsageInnerModel()
            appUsageInnerModel.total_app_usage = "\(totalAppUsage)"
            appUsageInnerModel.app_name = appName
            appUsageInnerModels.append(appUsageInnerModel)
        }
        
        appUsageModel.appusage = appUsageInnerModels
        self.total = Int32(totalUsage)
        self.appUsageModel = appUsageModel
        
        self.updateTotalTimeLabelWith(usage: totalUsage, andLabel: self.totalTimeLbl)
        self.tableVu.reloadData()
        self.tableVu.isHidden = (appUsageModel.appusage?.isEmpty ?? true)
    }
    
    func populateV1DataWithUsage(usage: [String: Any]) {
        guard let appUsage = usage["appusage"] as? [[String: Any]] else {
            print("Error: No app usage data found")
            return
        }
        
        var totalUsage: Int = 0
        var appUsageModel = AppUsageModel()
        var appUsageInnerModels: [AppUsageInnerModel] = []
        for appData in appUsage {
            // Ensure each dictionary contains the necessary keys
            guard let totalAppUsage = appData["total_app_usage"] as? Int,
                  let appName = appData["app_name"] as? String else {
                print("Error: Incomplete app data")
                continue
            }
            
            // Create an AppUsageInnerModel for each app entry
            let appUsageInnerModel = AppUsageInnerModel()
            appUsageInnerModel.total_app_usage = "\(totalAppUsage)"
            appUsageInnerModel.app_name = appName
            appUsageInnerModels.append(appUsageInnerModel)
            
            // Add to the total usage counter
            totalUsage += totalAppUsage
        }
        
        // Populate the app usage model and set the total usage
        appUsageModel.appusage = appUsageInnerModels
        self.total = Int32(totalUsage)
        self.appUsageModel = appUsageModel
        
        // Update the total time label and refresh the table view
        self.updateTotalTimeLabelWith(usage: totalUsage, andLabel: self.totalTimeLbl)
        self.tableVu.reloadData()
        self.tableVu.isHidden = (appUsageModel.appusage?.isEmpty ?? true)
    }
    
    
    //MARK: - UI ACTIONS
    
    @IBAction func daysAction(_ sender: Any) {
        dropDown.show()
    }
    
    @IBAction func backBtn(_ sender: Any) {
        if ((self.navigationController?.viewControllers.contains(self)) != nil) {
            self.navigationController?.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
        
    }
}

extension AppUsageVC : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let appUsage = appUsageModel.appusage{
            return appUsage.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! AppUsageCell
        
        let screenWidth = UIScreen.main.bounds.width - 128 //---just width of progress view---128 for icon spaces---//
        
        print("constraint const = \(screenWidth)")
        
        //        let width = CGFloat(((arr[indexPath.row] / total) * CGFloat(screenWidth)))
        //        print("width = \(width) total = \(total) and arr = \(arr[indexPath.row])")
        //        cell.progressVuWidth.constant = width
        
        
        let app = appUsageModel.appusage[indexPath.row] as! AppUsageInnerModel
        cell.appNameLbl.text = app.app_name ?? ""
        
        let usage = (app.total_app_usage as NSString).intValue
        
        
        let width = CGFloat(((Float(usage) / Float(total)) * Float(screenWidth)))
        
        print("width = \(width) total = \(total)")
        cell.progressVuWidth.constant = width > 5 ? width : 5  //---default progress---//
        
        updateTotalTimeLabelWith(usage: Int(usage), andLabel: cell.timeLbl)
        
        return cell
    }
    
    
}


extension AppUsageVC{
    //MARK: - DATE LABEL METHODS
    func updateDateLabel(isToday:Bool = true){
        let date = isToday ? Date() : Date().dayBefore
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM"
        
        let dateStr = formatter.string(from: date)
        print("date = \(dateStr)")
        
        dateRangeLbl.text = dateStr
    }
    
    func updateDateLabelForMoreDays(index:Int){
        
        var date = Date()
        if index == 2{
            date = date.weekBefore
        }
        else if index == 3{
            date = date.fortNightBefore
        }
        else{
            date = date.monthBefore
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        
        let dateStr = formatter.string(from: date)
        print("date = \(dateStr)")
        
        dateRangeLbl.text = "\(dateStr) - \(formatter.string(from: Date.yesterday))"
    }
    
    func updateTotalTimeLabelWith(usage:Int, andLabel:UILabel){
        
        //        total = 0
        //        for appUsage in appUsageModel.appusage{
        //            let app = appUsage as! AppUsageInnerModel
        //            total = (app.total_app_usage as NSString).intValue + total
        //        }
        
        //        let hours = Int(total / 3600)
        //        let minut = Int((total % 3600) / 60)
        //        let remainingSeconds = Int((total % 3600) % 60)
        
        let (h,m,s) = secondsToHoursMinutesSeconds(seconds: usage)
        
        if h > 0{
            andLabel.text = "\(h)h, \(m)m"
        }
        else if m > 0{
            andLabel.text = "\(m)m, \(s)s"
        }
        else{
            andLabel.text = "\(s)s"
        }
    }
    
    func updateCellTimeLabel(){
        
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
}

extension AppUsageVC{
    
    //MARK: - DROPDOWN LIBRARY
    func dropDownSetup() {
        if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
            dropDown.anchorView = totalTimeLbl
        } else {
            dropDown.anchorView = daysBtn
        }
        
        dropDown.dataSource = ["date_drop_down_1".localized, "date_drop_down_2".localized, "date_drop_down_3".localized, "date_drop_down_4".localized, "date_drop_down_5".localized]
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.lastDayLbl.text = item
            
            switch index {
            case 1:
                self.day_count = 1
                self.updateDateLabel(isToday: false)
            case 2:
                self.day_count = 7
            case 3:
                self.day_count = 14
            case 4:
                self.day_count = 30
            default:
                self.day_count = 0
                self.updateDateLabel()
            }
            
            if index == 2 || index == 3 || index == 4 {
                self.updateDateLabelForMoreDays(index: index)
            }
            fetchAppUsage()
        }
    }
}

struct AppUsageModelCore: Codable {
    let appUsage: [AppUsage]?
    
    enum CodingKeys: String, CodingKey {
        case appUsage = "app_usage"
    }
}

struct AppUsageV1Model: Codable {
    let appUsage: [AppUsage]?
    
    enum CodingKeys: String, CodingKey {
        case appUsage = "app_usages"
    }
}

// MARK: - AppUsage
struct AppUsage: Codable {
    let childID: Int?
    let appName, packageName: String?
    let appUsage: Int?
    let appCategory, dateUsage: String?
    
    enum CodingKeys: String, CodingKey {
        case childID = "child_id"
        case appName = "app_name"
        case packageName = "package_name"
        case appUsage = "app_usage"
        case appCategory = "app_category"
        case dateUsage = "date_usage"
    }
}
