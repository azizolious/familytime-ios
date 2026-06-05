//
//  SummaryViewController.swift
//  FamilyTime
//
//  Created by YumyApps on 23/11/2021.
//  Copyright © 2021 YumyApps. All rights reserved.
//
import UIKit

class SummaryViewController: UIViewController {
    
    @IBOutlet weak var selectDurationButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var selectedTimeLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var totalMessagesLabel: UILabel!
    @IBOutlet weak var totalMessagesValue: UILabel!
    @IBOutlet weak var talkTimeLabel: UILabel!
    @IBOutlet weak var talkTimeValue: UILabel!
    @IBOutlet weak var appUsageLabel: UILabel!
    @IBOutlet weak var appUsageValue: UILabel!
    @IBOutlet weak var newAppsLabel: UILabel!
    @IBOutlet weak var newAppsValue: UILabel!
    @IBOutlet weak var newlyAddedContactsLabel: UILabel!
    @IBOutlet weak var newlyAddedContactsValue: UILabel!
    @IBOutlet weak var timeBankLabel: UILabel!
    @IBOutlet weak var timeBankValue: UILabel!
    @IBOutlet weak var totalMessagesButton: UIButton!
    @IBOutlet weak var talkTimeButton: UIButton!
    @IBOutlet weak var appUsageButton: UIButton!
    @IBOutlet weak var newAppsButton: UIButton!
    @IBOutlet weak var newlyAddedContactsButton: UIButton!
    @IBOutlet weak var timeBankButton: UIButton!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationValue: UILabel!
    @IBOutlet weak var messagesView: UIView!
    @IBOutlet weak var talkTimeView: UIView!
    @IBOutlet weak var appUsageView: UIView!
    @IBOutlet weak var newAppsView: UIView!
    @IBOutlet weak var contactsView: UIView!
    @IBOutlet weak var timeBankView: UIView!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var mymainView: UIView!
    
    //MARK: VARIABLES
    var app_usage_time = "0"
    var contacts_count = "0"
    var time_bank = "0"
    var total_call_duration = "0"
    var total_installapplist = "0"
    var total_sms = "0"
    var day_count = 0
    var toDate = Date()
    var fromDate = Date()
    let delegate = UIApplication.shared.delegate as? AppDelegate
    let child_Id = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
    var lastSelectedTimeRange: TimeRange = .today
    private var package_id : String = ""
    private var package_name : String = ""
    private var device : String = ""
    var isIOS: Bool = false
    let identifiersToUse = ["call_logs", "sms", "contacts", "location_history", "apps_list", "phone_usage", "fun_time"]
    
    //MARK: - VIEWS LIFECYLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LiveVisitorManager.shared.updateScreen(
            "Reports"
        )
        
        // Create swipe gesture
        let swipeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleSwipeBack(_:)))
        swipeGesture.edges = .left  // Detect swipe from the left edge
        view.addGestureRecognizer(swipeGesture)
    }
    
    @objc func handleSwipeBack(_ gesture: UIScreenEdgePanGestureRecognizer) {
        
        if gesture.state == .recognized {
            // Navigate to the desired screen
            let sb = UIStoryboard(name: StoryboardConstants.Storyboards.DASHBOARD, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: StoryboardConstants.Identifiers.DASH_BOARD_VC_IDENTIFIER) as? DashboardVC
            delegate?.centerNavController = UINavigationController(rootViewController: vc ?? DashboardVC())
            delegate?.jasidePanel.centerPanel = delegate?.centerNavController
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        //        let childInfoObj = CoreDataUtility.fetchChildInfoFromDatabase(child_id: child_Id ?? "")
        self.navigationItem.title = "summary_title".localized
        self.setTextAndColor()
        fetchdata()
    }
    
    func fetchdata(){
        let contactsImageView = AddImage.addImageView(to: newlyAddedContactsLabel, imageName: "top")
        let newAppsImageView = AddImage.addImageView(to: newAppsLabel, imageName: "top")
        let locationImageView = AddImage.addImageView(to: locationLabel, imageName: "top")
        let talkTimeImageView = AddImage.addImageView(to: talkTimeLabel, imageName: "top")
        let messagesImageView = AddImage.addImageView(to: totalMessagesLabel, imageName: "top")
        let appUsageImageView = AddImage.addImageView(to: appUsageLabel, imageName: "top")
        let timeBankImageView = AddImage.addImageView(to: timeBankLabel, imageName: "top")
        
        contactsView.isHidden = true
        newAppsView.isHidden = true
        locationView.isHidden = true
        talkTimeView.isHidden = true
        messagesView.isHidden = true
        appUsageView.isHidden = true
        timeBankView.isHidden = true
        
        if let childIdString = child_Id, let childId = Int(childIdString) {
            let child_Info = DBManager.shared.fetchChild(byID: childId)
            let result = DBManager.shared.fetchChildAndPlans(byChildID: childId)
            if let child = result.child {
                print("Fetched child: \(child)")
                print("Related plans:")
                for plan in result.plans {
                    print(plan)
                    print("Plan ID: \(plan.planID)")
                    print("Identifier: \(plan.identifier ?? "N/A")")
                }
                
                let filteredPlans = result.plans.filter { plan in
                    guard let identifier = plan.identifier else {
                        return false
                    }
                    return identifiersToUse.contains(identifier)
                }
                
                for plan in filteredPlans {
                    if child.agent == "ios" {
                        switch plan.identifier {
                        case "contacts":
                            contactsView.isHidden = plan.iosReleased == 0
                            contactsImageView.isHidden = plan.status == 1
                        case "apps_list":
                            newAppsView.isHidden = plan.iosReleased == 0
                            newAppsImageView.isHidden = plan.status == 1
                        case "location_history":
                            locationView.isHidden = plan.iosReleased == 0
                            locationImageView.isHidden = plan.status == 1
                        default:
                            break
                        }
                    } else {
                        switch plan.identifier {
                        case "call_logs":
                            talkTimeView.isHidden = plan.androidReleased == 0
                            talkTimeImageView.isHidden = plan.status == 1
                        case "sms":
                            messagesView.isHidden = plan.androidReleased == 0
                            messagesImageView.isHidden = plan.status == 1
                        case "contacts":
                            contactsView.isHidden = plan.androidReleased == 0
                            contactsImageView.isHidden = plan.status == 1
                        case "location_history":
                            locationView.isHidden = plan.androidReleased == 0
                            locationImageView.isHidden = plan.status == 1
                        case "apps_list":
                            newAppsView.isHidden = plan.androidReleased == 0
                            newAppsImageView.isHidden = plan.status == 1
                        case "phone_usage":
                            appUsageView.isHidden = plan.androidReleased == 0
                            appUsageImageView.isHidden = plan.status == 1
                        case "fun_time":
                            timeBankView.isHidden = plan.androidReleased == 0
                            timeBankImageView.isHidden = plan.status == 1
                        default:
                            break
                        }
                    }
                }
            } else {
                print("Child not found")
            }
        } else {
            print("Invalid child ID")
        }
        
        let today = Date()
        let currentDate = CommonModel.currentDateForSummeryScreen(today, formate: "EEEE, MMM d, yyyy")
        let convertedDate = CommonModel.dateInDaysForSummeryScreen(currentDate)
        dateLabel.text = convertedDate
        selectedTimeLabel.text = "\("date_drop_down_1".localized), "
        let toDateCurrent = CommonModel.currentDateForSummeryScreen(toDate, formate: "EEEE, MMM d, yyyy")
        let fromDateCurrent = CommonModel.currentDateForSummeryScreen(fromDate, formate: "EEEE, MMM d, yyyy")
        let toDateConverted = CommonModel.convertedDateForSummeryScreen(toDateCurrent)
        let fromDateConverted = CommonModel.convertedDateForSummeryScreen(fromDateCurrent)
        //        self.getSummaryData(toDate:toDateConverted, fromDate: fromDateConverted)
        updateSummaryData(for: .today)
        print("Child id is ",self.delegate?.selectedDashboardChild?.child_id ?? 0)
        package_id = CoreDataUtility.fetchPackageIdFor(child_id: Int32(child_Id ?? "") ?? 0)
        package_name = CoreDataUtility.fetchPackageNameFor(child_id: Int32(child_Id ?? "") ?? 0)
        device = CoreDataUtility.fetchPackageDeviceFor(child_id: Int32(child_Id ?? "") ?? 0)
    }
    
    func setTextAndColor() {
        //        let data = CoreDataUtility.fetchDashboardFromDatabaseNEW(childssID: child_Id ?? "")
        //        for child  in data {
        //            let childInfoObj = child.childInfo
        //            print(childInfoObj?.appVersion ?? "Nil", childInfoObj?.name ?? "", childInfoObj?.gender ?? "", childInfoObj?.appBuild ?? "")
        //
        //        }
        //
        ////        let childInfoObj = CoreDataUtility.fetchChildInfoFromDatabase(child_id: child_Id ?? "")
        //
        //
        //        if let childIdString = child_Id, let childIdInt = Int(childIdString) {
        //            let childInfoObj = DBManager.shared.fetchChild(byID: childIdInt)
        //
        //        } else {
        //            // Handle the case where child_Id is nil or cannot be converted to an Int
        //            print("Invalid child ID")
        //        }
        
        self.selectDurationButton.setTitle("", for: .normal)
        self.totalMessagesButton.setTitle("", for: .normal)
        self.talkTimeButton.setTitle("", for: .normal)
        self.appUsageButton.setTitle("", for: .normal)
        self.newAppsButton.setTitle("", for: .normal)
        self.newlyAddedContactsButton.setTitle("", for: .normal)
        self.timeBankButton.setTitle("", for: .normal)
        
        self.summaryLabel.text = "summary_subtitle".localized
        self.totalMessagesLabel.text = "summary_content_1_sub_content_1".localized
        self.talkTimeLabel.text = "summary_content_1_sub_content_2".localized
        self.appUsageLabel.text = "summary_content_1_sub_content_3".localized
        self.newAppsLabel.text = "summary_content_1_sub_content_4".localized
        self.newlyAddedContactsLabel.text = "summary_content_1_sub_content_5".localized
        self.timeBankLabel.text = "summary_content_1_sub_content_6".localized
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    func updateSummaryData(for timeRange: TimeRange) {
        self.total_sms = "0"
        self.total_installapplist = "0"
        self.contacts_count = "0"
        self.app_usage_time = "0s"
        self.time_bank = "0s"
        self.total_call_duration = "0s"
        totalMessagesValue.text = "0"
        newlyAddedContactsValue.text = "0"
        talkTimeValue.text = "0s"
        newAppsValue.text = "0"
        appUsageValue.text = "0s"
        timeBankValue.text = "0s"
        locationValue.text = "0"
        let count = DBManager.shared.countMsgObjectsInTimeRange(timeRange)
        if count != 0 {
            totalMessagesValue.text = "\(count)"
        }
        //        else{
        //            ReportsApiManager.Shared.handleSMSApi()
        //            let count = DBManager.shared.countMsgObjectsInTimeRange(timeRange)
        //            totalMessagesValue.text = "\(count)"
        //        }
        
        
        let contactsCount = DBManager.shared.contactsCountInTimeRange(timeRange)
        newlyAddedContactsValue.text = "\(contactsCount)"
        
        let totalTalkTime = DBManager.shared.totalTalkTimeInTimeRange(timeRange)
        print(totalTalkTime)
        if totalTalkTime == 0 {
            self.total_call_duration = "0s"
            talkTimeValue.text = "0s"
        } else {
            let (h, m, s) = secondsToHoursMinutesSeconds(seconds: totalTalkTime)
            var components: [String] = []
            if h > 0 {
                components.append("\(h)h")
            }
            if m > 0 || h > 0 {
                components.append("\(m)m")
            }
            if s > 0 || m == 0 {
                components.append("\(s)s")
            }
            self.total_call_duration = components.joined(separator: ",")
            talkTimeValue.text = total_call_duration
        }
        
        var appUsage: Int = 0
        if DBManager.shared.checkChildIsOld(childID: Int(child_Id ?? "") ?? 0) {
            appUsage = DBManager.shared.totalAppUsageInTimeRange(timeRange)
        } else {
            appUsage = DBManager.shared.totalV1AppUsageInTimeRange(timeRange)
        }
        
        if appUsage == 0 {
            self.app_usage_time = "0s"
            appUsageValue.text = "0s"
        } else {
            let (h, m, s) = secondsToHoursMinutesSeconds(seconds: appUsage)
            var components: [String] = []
            if h > 0 {
                components.append("\(h)h")
            }
            if m > 0 || h > 0 {
                components.append("\(m)m")
            }
            if s > 0 || m == 0 {
                components.append("\(s)s")
            }
            self.app_usage_time = components.joined(separator: ",")
            appUsageValue.text = app_usage_time
        }
        let newApps = DBManager.shared.fetchInstalledAppsInTimeRange(timeRange)
        self.total_installapplist = String(newApps.count)
        self.newAppsValue.text = total_installapplist
        let timeBank = DBManager.shared.fetchTimeBank(childId: Int(child_Id ?? "") ?? 0)
        if timeBank.timeBank == 0 {
            self.time_bank = "0s"
            timeBankValue.text = "0s"
        } else {
            let (h, m, s) = secondsToHoursMinutesSeconds(seconds: timeBank.timeBank ?? 0)
            var components: [String] = []
            if h > 0 {
                components.append("\(h)h")
            }
            if m > 0 || h > 0 {
                components.append("\(m)m")
            }
            if s > 0 || m == 0 {
                components.append("\(s)s")
            }
            self.time_bank = components.joined(separator: ",")
            timeBankValue.text = time_bank
        }
        let locationHistory = DBManager.shared.fetchLocationHistoryInTimeRange(timeRange)
        let locationCount = locationHistory.count
        
        locationValue.text = "\(locationCount)"
        
    }
    func getPlan(withIdentifier identifier: String) -> PlanEntity? {
        if let childIdString = child_Id, let childId = Int(childIdString) {
            let result = DBManager.shared.fetchChildAndPlans(byChildID: childId)
            if let plan = result.plans.first(where: { $0.identifier == identifier }) {
                return plan
            } else {
                print("Plan not found for identifier: \(identifier)")
            }
        } else {
            print("Invalid child ID")
        }
        return nil
    }
    
    //MARK: - BUTTON's ACTION
    @IBAction func selectDuration(_ sender: UIButton) {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "date_drop_down_1".localized, style: .default, handler: { [self] action in
            let count = DBManager.shared.countMsgObjectsInTimeRange(.today)
            totalMessagesValue.text = "\(count)"
            let contactsCount = DBManager.shared.contactsCountInTimeRange(.today)
            newlyAddedContactsValue.text = "\(contactsCount)"
            let today = Date()
            let currentDate = CommonModel.currentDateForSummeryScreen(today, formate: "EEEE, MMM d, yyyy")
            let convertedDate = CommonModel.dateInDaysForSummeryScreen(currentDate)
            dateLabel.text = convertedDate
            selectedTimeLabel.text = "\("date_drop_down_1".localized), "
            toDate = today
            fromDate = today
            let toDateCurrent = CommonModel.currentDateForSummeryScreen(toDate, formate: "EEEE, MMM d, yyyy")
            let fromDateCurrent = CommonModel.currentDateForSummeryScreen(fromDate, formate: "EEEE, MMM d, yyyy")
            let toDateConverted = CommonModel.convertedDateForSummeryScreen(toDateCurrent)
            let fromDateConverted = CommonModel.convertedDateForSummeryScreen(fromDateCurrent)
            self.day_count = 0
            self.lastSelectedTimeRange = .today
            updateSummaryData(for: .today)
        }))
        alert.addAction(UIAlertAction(title: "date_drop_down_2".localized, style: .default, handler: { [self] action in
            let count = DBManager.shared.countMsgObjectsInTimeRange(.yesterday)
            totalMessagesValue.text = "\(count)"
            let contactsCount = DBManager.shared.contactsCountInTimeRange(.yesterday)
            newlyAddedContactsValue.text = "\(contactsCount)"
            let yesterday = Date.yesterday
            let today = Date()
            let currentDate = CommonModel.currentDateForSummeryScreen(yesterday, formate: "EEEE, MMM d, yyyy")
            let convertedDate = CommonModel.dateInDaysForSummeryScreen(currentDate)
            dateLabel.text = convertedDate
            selectedTimeLabel.text = "\("date_drop_down_2".localized), "
            toDate = yesterday
            fromDate = today
            let toDateCurrent = CommonModel.currentDateForSummeryScreen(toDate, formate: "EEEE, MMM d, yyyy")
            let fromDateCurrent = CommonModel.currentDateForSummeryScreen(fromDate, formate: "EEEE, MMM d, yyyy")
            let toDateConverted = CommonModel.convertedDateForSummeryScreen(toDateCurrent)
            let fromDateConverted = CommonModel.convertedDateForSummeryScreen(fromDateCurrent)
            self.day_count = 1
            //            self.getSummaryData(toDate: toDateConverted, fromDate:fromDateConverted)
            self.lastSelectedTimeRange = .yesterday
            updateSummaryData(for: .yesterday)
        }))
        alert.addAction(UIAlertAction(title: "date_drop_down_3".localized, style: .default, handler: { [self] action in
            let count = DBManager.shared.countMsgObjectsInTimeRange(.last7Days)
            totalMessagesValue.text = "\(count)"
            let contactsCount = DBManager.shared.contactsCountInTimeRange(.last7Days)
            newlyAddedContactsValue.text = "\(contactsCount)"
            let yesterday = Date.yesterday
            let currentDateYesterday = CommonModel.currentDateForSummeryScreen(yesterday, formate: "EEEE, MMM d, yyyy")
            let convertedYesterday = CommonModel.dateInMonthsForSummeryScreen(currentDateYesterday)
            let weekBefore = Date.weekBefore
            let currentDateWeekbefore = CommonModel.currentDateForSummeryScreen(weekBefore, formate: "EEEE, MMM d, yyyy")
            let convertedWeekbefore = CommonModel.dateInMonthsForSummeryScreen(currentDateWeekbefore)
            dateLabel.text = "\(convertedWeekbefore)-\(convertedYesterday)"
            selectedTimeLabel.text = "\("date_drop_down_3".localized), "
            toDate = weekBefore
            fromDate = yesterday
            let toDateCurrent = CommonModel.currentDateForSummeryScreen(toDate, formate: "EEEE, MMM d, yyyy")
            let fromDateCurrent = CommonModel.currentDateForSummeryScreen(fromDate, formate: "EEEE, MMM d, yyyy")
            let toDateConverted = CommonModel.convertedDateForSummeryScreen(toDateCurrent)
            let fromDateConverted = CommonModel.convertedDateForSummeryScreen(fromDateCurrent)
            self.day_count = 7
            self.lastSelectedTimeRange = .last7Days
            updateSummaryData(for: .last7Days)
        }))
        alert.addAction(UIAlertAction(title: "date_drop_down_4".localized, style: .default, handler: { [self] action in
            let count = DBManager.shared.countMsgObjectsInTimeRange(.last14Days)
            totalMessagesValue.text = "\(count)"
            let contactsCount = DBManager.shared.contactsCountInTimeRange(.last14Days)
            newlyAddedContactsValue.text = "\(contactsCount)"
            let yesterday = Date.yesterday
            let currentDateYesterday = CommonModel.currentDateForSummeryScreen(yesterday, formate: "EEEE, MMM d, yyyy")
            let convertedYesterday = CommonModel.dateInMonthsForSummeryScreen(currentDateYesterday)
            let fortNightBefore = Date.fortNightBefore
            let currentDateNightbefore = CommonModel.currentDateForSummeryScreen(fortNightBefore, formate: "EEEE, MMM d, yyyy")
            let convertedNight = CommonModel.dateInMonthsForSummeryScreen(currentDateNightbefore)
            dateLabel.text = "\(convertedNight)-\(convertedYesterday)"
            selectedTimeLabel.text = "\("date_drop_down_4".localized), "
            toDate = fortNightBefore
            fromDate = yesterday
            let toDateCurrent = CommonModel.currentDateForSummeryScreen(toDate, formate: "EEEE, MMM d, yyyy")
            let fromDateCurrent = CommonModel.currentDateForSummeryScreen(fromDate, formate: "EEEE, MMM d, yyyy")
            let toDateConverted = CommonModel.convertedDateForSummeryScreen(toDateCurrent)
            let fromDateConverted = CommonModel.convertedDateForSummeryScreen(fromDateCurrent)
            self.day_count = 14
            self.lastSelectedTimeRange = .last14Days
            updateSummaryData(for: .last14Days)
        }))
        alert.addAction(UIAlertAction(title: "date_drop_down_5".localized, style: .default, handler: { [self] action in
            let count = DBManager.shared.countMsgObjectsInTimeRange(.last30Days)
            totalMessagesValue.text = "\(count)"
            let contactsCount = DBManager.shared.contactsCountInTimeRange(.last30Days)
            newlyAddedContactsValue.text = "\(contactsCount)"
            let yesterday = Date.yesterday
            let currentDateYesterday = CommonModel.currentDateForSummeryScreen(yesterday, formate: "EEEE, MMM d, yyyy")
            let convertedYesterday = CommonModel.dateInMonthsForSummeryScreen(currentDateYesterday)
            let monthBefore = Date.monthBefore
            let currentDateMonthbefore = CommonModel.currentDateForSummeryScreen(monthBefore, formate: "EEEE, MMM d, yyyy")
            let convertedMonthbefore = CommonModel.dateInMonthsForSummeryScreen(currentDateMonthbefore)
            dateLabel.text = "\(convertedMonthbefore)-\(convertedYesterday)"
            selectedTimeLabel.text = "\("date_drop_down_5".localized), "
            toDate = monthBefore
            fromDate = yesterday
            let toDateCurrent = CommonModel.currentDateForSummeryScreen(toDate, formate: "EEEE, MMM d, yyyy")
            let fromDateCurrent = CommonModel.currentDateForSummeryScreen(fromDate, formate: "EEEE, MMM d, yyyy")
            let toDateConverted = CommonModel.convertedDateForSummeryScreen(toDateCurrent)
            let fromDateConverted = CommonModel.convertedDateForSummeryScreen(fromDateCurrent)
            self.day_count = 30
            self.lastSelectedTimeRange = .last30Days
            updateSummaryData(for: .last30Days)
        }))
        alert.addAction(UIAlertAction(title: "cancel_button".localized, style: .default, handler: { action in
            print("Cancel")
        }))
        if let presenter = alert.popoverPresentationController {
            presenter.sourceView = sender
            presenter.sourceRect = sender.bounds
            presenter.permittedArrowDirections = .up
        }
        self.present(alert, animated: true)
    }
    
    @IBAction func actionTotalMessages(_ sender: UIButton) {
        guard let plan = getPlan(withIdentifier: "sms") else {
            print("Plan not found for SMS")
            return
        }
        
        if plan.status == 0 {
            SwiftFTUtils.showSwiftPremiumPopup(on: self)
        } else {
            //                let device = self.device
            //                let packageId = self.package_id
            //                if (packageId == "3") {
            let vc = TextMessagesMainViewController()
            //delegate?.centerNavController = UINavigationController(rootViewController: vc)
            self.navigationController?.pushViewController(vc, animated: true)
            //                }
        }
        
        //        let device = self.device
        //        let packageId = self.package_id
        //        if (packageId == "3") {
        //            let vc = TextMessagesMainViewController()
        //            //delegate?.centerNavController = UINavigationController(rootViewController: vc)
        //            self.navigationController?.pushViewController(vc, animated: true)
        //        } else {
        //            SwiftFTUtils.showSwiftPremiumPopup(on: self)
        //        }
    }
    
    @IBAction func actionTalkTime(_ sender: UIButton) {
        
        guard let plan = getPlan(withIdentifier: "call_logs") else {
            // Handle case where plan is not found
            print("Plan not found for identifier: call_logs")
            return
        }
        
        if plan.status == 0 {
            // Show premium popup if status is 0
            SwiftFTUtils.showSwiftPremiumPopup(on: self)
        } else {
            // Proceed with pushing the view controller
            let storyBoard = UIStoryboard(name: "Dashboard", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "CallHistoryViewController") as? CallHistoryViewController ?? CallHistoryViewController()
            vc.day_count = self.day_count
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        //        let storyBoard = UIStoryboard(name: "Dashboard", bundle: nil)
        //        let vc = storyBoard.instantiateViewController(withIdentifier: "CallHistoryViewController") as? CallHistoryViewController ?? CallHistoryViewController()
        //        vc.day_count = self.day_count
        //        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionAppUsage(_ sender: UIButton) {
        guard let plan = getPlan(withIdentifier: "phone_usage") else {
            // Handle case where plan is not found
            print("Plan not found for identifier: phone_usage")
            return
        }
        
        if plan.status == 0 {
            // Show premium popup if status is 0
            SwiftFTUtils.showSwiftPremiumPopup(on: self)
        } else {
            // Proceed with pushing the view controller
            let sb = UIStoryboard(name: "Dashboard", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "AppUsageVC") as? AppUsageVC ?? AppUsageVC()
            vc.day_count = self.day_count
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
        
        //        let sb = UIStoryboard(name: "Dashboard", bundle: nil)
        //        let vc = sb.instantiateViewController(withIdentifier: "AppUsageVC") as? AppUsageVC ?? AppUsageVC()
        //        vc.day_count = self.day_count
        //        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionNewApps(_ sender: UIButton) {
        guard let plan = getPlan(withIdentifier: "apps_list") else {
            // Handle case where plan is not found
            print("Plan not found for identifier: apps_list")
            return
        }
        
        if plan.status == 0 {
            // Show premium popup if status is 0
            SwiftFTUtils.showSwiftPremiumPopup(on: self)
        } else {
            // Proceed with pushing the view controller
            let vc = SwiftInstalledAppsViewController(nibName: "AllInstalledAppsViewController", bundle: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        //        let vc = SwiftInstalledAppsViewController(nibName: "AllInstalledAppsViewController", bundle: nil)
        //        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionNewlyAddedContacts(_ sender: UIButton) {
        guard let plan = getPlan(withIdentifier: "contacts") else {
            // Handle case where plan is not found
            print("Plan not found for identifier: contacts")
            return
        }
        
        if plan.status == 0 {
            // Show premium popup if status is 0
            SwiftFTUtils.showSwiftPremiumPopup(on: self)
        } else {
            // Proceed with pushing the view controller
            let device = self.device
            let packageId = self.package_id
            //               if (packageId == "1") {
            //                   SwiftFTUtils.showSwiftPremiumPopup(on: self)
            //               } else {
            let vc = ContactsViewController(nibName: "ContactViewController", bundle: nil)
            vc.ishiddenBar = true
            self.navigationController?.pushViewController(vc, animated: true)
            //               }
        }
        
        
        
        //        let device = self.device
        //        let packageId = self.package_id
        //        if (packageId == "1") {
        //            SwiftFTUtils.showSwiftPremiumPopup(on: self)
        //        } else {
        //            let vc = ContactsViewController(nibName: "ContactViewController", bundle: nil)
        //            self.navigationController?.pushViewController(vc, animated: true)
        //        }
    }
    
    @IBAction func actionTimeBank(_ sender: UIButton) {
        guard let plan = getPlan(withIdentifier: "fun_time") else {
            // Handle case where plan is not found
            print("Plan not found for identifier: fun_time")
            return
        }
        
        if plan.status == 0 {
            // Show premium popup if status is 0
            SwiftFTUtils.showSwiftPremiumPopup(on: self)
        } else {
            // Proceed with pushing the view controller
            //               let packageId = self.package_id
            //               if packageId == "2" || packageId == "3" {
            let storyboardName = "MyStoryboard"
            let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
            let vc = storyboard.instantiateViewController(withIdentifier: "ClockViewController") as? ClockViewController
            if let vc = vc {
                navigationController?.pushViewController(vc, animated: true)
            }
            //               } else {
            //                   SwiftFTUtils.showSwiftPremiumPopup(on: self)
            //               }
        }
        
        //        let packageId = self.package_id
        //        if packageId == "2" || packageId == "3" {
        //            let storyboardName = "MyStoryboard"
        //            let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        //            let vc = storyboard.instantiateViewController(withIdentifier: "ClockViewController") as? ClockViewController
        //            if let vc = vc {
        //                navigationController?.pushViewController(vc, animated: true)
        //            }
        //        } else {
        //            SwiftFTUtils.showSwiftPremiumPopup(on: self)
        //        }
    }
    
    @IBAction func actionLocation(_ sender: UIButton) {
        
        guard let plan = getPlan(withIdentifier: "location_history") else {
            // Handle case where plan is not found
            print("Plan not found for identifier: apps_list")
            return
        }
        
        if plan.status == 0 {
            // Show premium popup if status is 0
            SwiftFTUtils.showSwiftPremiumPopup(on: self)
        } else {
            let vc = LocationHistoryViewController(nibName: "LocHistoryViewController", bundle: nil)
            vc.ishiddenBar = true
            //            delegate?.centerNavController = UINavigationController(rootViewController: vc)
            self.navigationController?.pushViewController(vc, animated: true)
            delegate?.jasidePanel.centerPanel = delegate?.centerNavController
        }
        
    }
    
    
}


//    func getSummaryData(toDate: String, fromDate: String) {
//        print(fromDate)
//        print(toDate)
//        SwiftFTUtils.showHUDAdded(to: self.view, withText: "", animated: true)
//        let child_Id = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
//        let url = "\(HLConstants.URLs.Child.Summary.Api)/\(child_Id ?? "")/\(toDate)/\(fromDate)"
//        HLApiManager.getSummaryData(view: self.view, urlString: url) { [self] response, status, message in
//            SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
//            if let data = response?["summary"] as? [AnyHashable] {
//                self.total_sms = "0"
//                self.total_installapplist = "0"
//                self.contacts_count = "0"
//                self.app_usage_time = "0"
//                self.time_bank = "0"
//                self.total_call_duration = "0"
//                for item in data as! [NSDictionary] {
//                    let appUsageTime = item["app_usage_time"] as? String ?? "0"
//                    let contactsCount = String(item["contacts_count"] as? Int ?? 0)
//                    let timeBank = item["time_bank"] as? String ?? "0"
//                    let totalCallDuration = String(item["total_call_duration"] as? Int ?? 0)
//                    let totalInstallAppList = String(item["total_installapplist"] as? Int ?? 0)
////                    let msgs = DBManager.shared.getLatestTextMsgs()
//                    let totalSms = String(item["total_sms"] as? Int ?? 0)
//                    var intValue = 0
//                    intValue = Int(self.total_sms)! + Int(totalSms)!
//                    self.total_sms = String(intValue)
//                    intValue = Int(self.contacts_count)! + Int(contactsCount)!
//                    self.contacts_count = String(intValue)
//                    intValue = Int(self.total_installapplist)! + Int(totalInstallAppList)!
//                    self.total_installapplist = String(intValue)
//                    intValue = Int(self.app_usage_time)! + Int(appUsageTime)!
//                    self.app_usage_time = String(intValue)
//                    intValue = Int(self.time_bank)! + Int(timeBank)!
//                    self.time_bank = String(intValue)
//                    intValue = Int(self.total_call_duration)! + Int(totalCallDuration)!
//                    self.total_call_duration = String(intValue)
//                }
//                var (h,m,s) = secondsToHoursMinutesSeconds(seconds: Int(self.app_usage_time) ?? 0)
//                if h > 0 {
//                    self.app_usage_time = "\(h)h, \(m)m"
//                } else if m > 0 {
//                    self.app_usage_time = "\(m)m, \(s)s"
//                } else {
//                    self.app_usage_time = "\(s)s"
//                }
//                (h,m,s) = secondsToHoursMinutesSeconds(seconds: Int(self.time_bank) ?? 0)
//                if h > 0 {
//                    self.time_bank = "\(h)h, \(m)m"
//                } else if m > 0 {
//                    self.time_bank = "\(m)m, \(s)s"
//                } else {
//                    self.time_bank = "\(s)s"
//                }
//                (h,m,s) = secondsToHoursMinutesSeconds(seconds: Int(self.total_call_duration) ?? 0)
//                if h > 0 {
//                    self.total_call_duration = "\(h)h, \(m)m"
//                } else if m > 0 {
//                    self.total_call_duration = "\(m)m, \(s)s"
//                } else {
//                    self.total_call_duration = "\(s)s"
//                }
//                self.appUsageValue.text = app_usage_time
//                self.talkTimeValue.text = total_call_duration
//                //self.newlyAddedContactsValue.text = contacts_count
//                //self.timeBankValue.text = time_bank
//                self.newAppsValue.text = total_installapplist
//                //self.totalMessagesValue.text = self.total_sms
//                let currentDateAndTime = Date()
//                let dateFormatter = DateFormatter()
//                let content = "summary_content_1_sub_content_7".localized
//                dateFormatter.dateFormat = "dd/MM/yy"
//                let replaced1 = content.replacingOccurrences(of: "30/12/21", with: dateFormatter.string(from: currentDateAndTime))
//                let timeFormatter = DateFormatter()
//                timeFormatter.dateFormat = "h:mm a"
//                timeFormatter.amSymbol = "AM"
//                timeFormatter.pmSymbol = "PM"
//                let time = timeFormatter.string(from: currentDateAndTime)
//                let replaced2 = replaced1.replacingOccurrences(of: "5:42 PM", with: time)
//                self.refreshTimeLabel.text = replaced2
//            } else {
//                print("Data not found...")
//            }
//        }
//    }

//    @IBAction func actionRefreshButton(_ sender: UIButton) {
//        let toDateCurrent = CommonModel.currentDateForSummeryScreen(toDate, formate: "EEEE, MMM d, yyyy")
//        let fromDateCurrent = CommonModel.currentDateForSummeryScreen(fromDate, formate: "EEEE, MMM d, yyyy")
//        let toDateConverted = CommonModel.convertedDateForSummeryScreen(toDateCurrent)
//        let fromDateConverted = CommonModel.convertedDateForSummeryScreen(fromDateCurrent)
//        //        self.getSummaryData(toDate: toDateConverted, fromDate: fromDateConverted)
//        SwiftFTUtils.showHUDAdded(to: self.view, withText: "", animated: true)
//        ReportsApiManager.Shared.callAllReports()
//        self.updateSummaryData(for: lastSelectedTimeRange)
//        SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
//
//    }

//    @IBAction func actionHelpDesk(_ sender: UIButton) {
//        let storyboard = UIStoryboard(name: "MyStoryboard", bundle: Bundle.main)
//        guard let vc = storyboard.instantiateViewController(withIdentifier: "SwiftHelpViewController") as? SwiftHelpViewController else { return }
//        navigationController?.pushViewController(vc, animated: true)
//    }

//self.refreshReportLabel.text = "summary_content_1_sub_content_8".localized
//        self.appInformationLabel.text = "summary_content_2".localized
//        self.appVersionLabel.text = "summary_content_2_sub_content_1".localized
//        self.buildLabel.text = "summary_content_2_sub_content_2".localized
//        self.helpDeskLabel.text = "summary_content_2_sub_content_3".localized
//        let device = self.device
//        if device == "iphone" {
//            self.appLogoImageView.image = UIImage(named: "yellow_apple")
//        } else {
//            self.appLogoImageView.image = UIImage(named: "yellow_android")
//        }

//        childNameLabel.text = childInfoObj.name ?? ""
//        childImage.image = (childInfoObj.gender?.lowercased() == "male") ? #imageLiteral(resourceName: "avatar_boy1") : #imageLiteral(resourceName: "popup_avatar_girl")
//        appVersionValue.text     = childInfoObj.appVersion ?? ""
//        buildValue.text          = childInfoObj.appBuild ?? ""

//            childNameLabel.text = childInfoObj?.name ?? ""
//            childImage.image = (childInfoObj?.gender?.lowercased() == "male") ? #imageLiteral(resourceName: "avatar_boy1") : #imageLiteral(resourceName: "popup_avatar_girl")
//            appVersionValue.text     = childInfoObj?.appVersion ?? ""
//            buildValue.text          = childInfoObj?.appBuild ?? ""
