//
//  AndroidDailyLimitVC.swift
//  FamilyTime
//
//  Created by iOS Dev Sana-Ullah on 06/12/2018.
//  Copyright © 2018 YumyApps. All rights reserved.
//

import UIKit

protocol DailyLimitAppCellDelegate {
    func didSettingsChanged(_ isActive: Bool, indexPath: IndexPath?)
}

protocol DailyLimitClockCellDelegate {
    func didTimeIntervalChanged(_ intrval: String?)
    func didAutoNewChanged(_ autoNew: Bool)
    func didRadianChanged(_ radian: String)
}
struct DailyAppLimitSeconds {
    static var limtData = 0
}
class AndroidDailyLimitVC: UIViewController {
    var limitDuration: String = ""
    let child_Id = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
    
    class DailyLimitAppCell: UITableViewCell {
        var appImageView: UIImageView?
        var app: AppLimits?
        var featureStatus = false
        var indexPath: IndexPath?
        var delegate: DailyLimitAppCellDelegate?
        var switchView: UISwitch?
        
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            selectionStyle  = .none
            backgroundColor = UIColor.white
            tintColor       = UIColor.red
            textLabel?.backgroundColor  = UIColor.clear
            textLabel?.textColor        = UIColor.darkGray
            textLabel?.textAlignment    = .left
            appImageView = UIImageView(frame: CGRect.zero)
            contentView.addSubview(appImageView!)
//            selectiveBorderFlag   = UInt(AUISelectiveBordersFlagBottom)
//            selectiveBordersColor = UIColor.lightGray.withAlphaComponent(0.5)
//            selectiveBordersWidth = 0.5
            switchView = UISwitch(frame: CGRect(x: 0, y: 0, width: 51, height: 25))
            switchView?.onTintColor = UIColor.FTLightPink
            contentView.addSubview(switchView!)
            switchView?.addTarget(self, action: #selector(self.handleStatusChange(_:)), for: .valueChanged)
            clipsToBounds = true
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        //----MADE PRIVATE FUNCTION BECAUSE IT CONFLICTS OBJC SETTER-----//
        //        func setApp(_ app: DailyLimitApp?) {
//        func setupApp(_ app: AppLimits?) {
//            self.app = app
//            textLabel?.text = app?.appName
//            if app?.inDailyLimit == 0 {
//                switchView?.isOn = false
//            } else if app?.inDailyLimit == 1 {
//                switchView?.isOn = true
//            }
//        }
        func setupApp(_ app: InstalledApp) {
           // self.app = app
            textLabel?.text = app.appName
            if app.inDailyLimit == 0 {
                switchView?.isOn = false
            } else if app.inDailyLimit == 1 {
                switchView?.isOn = true
            }
        }
        
        
        override func layoutSubviews() {
            super.layoutSubviews()
            if UIView.appearance().semanticContentAttribute == .forceLeftToRight{
                if SwiftFTUtils.isDeviceiPhoneFamily() {
                    textLabel?.textAlignment    = .left
                    appImageView?.frame = CGRect(x: 15.0, y: contentView.bounds.midY - 15.0, width: 16.0, height: 32.0)
                } else {
                    appImageView?.frame = CGRect(x: 15.0, y: contentView.bounds.midY - 22.5, width: 27.5, height: 55.0)
                }
                switchView?.frame = CGRect(x: contentView.bounds.maxX - 66.0, y: contentView.bounds.midY - 10.5, width: 51, height: 31)
                //----MANUALLY ADDED DEFAULT VALUE 30 IN X VALUE, ---?? 30---RIGHT BELOW--//
                textLabel?.frame = CGRect(x: (appImageView?.frame.maxX ?? 30) + 20.0, y: 0.0, width: contentView.bounds.maxX - 10 - (appImageView?.frame.maxX)! - 20 - 56, height: contentView.bounds.height)
            } else {
                
                if SwiftFTUtils.isDeviceiPhoneFamily() {
                    textLabel?.textAlignment    = .right
                    appImageView?.frame = CGRect(x: contentView.bounds.maxX - 26.0, y: contentView.bounds.midY - 20.0, width: 16.0, height: 32.0)
                } else {
                    appImageView?.frame = CGRect(x: 15.0, y: contentView.bounds.midY - 27.5, width: 27.5, height: 55.0)
                }
                switchView?.frame = CGRect(x: 15.0, y: contentView.bounds.midY - 15.5, width: 51, height: 31)
                //----MANUALLY ADDED DEFAULT VALUE 30 IN X VALUE, ---?? 30---RIGHT BELOW--//
                textLabel?.frame = CGRect(x: switchView?.frame.maxX ?? 30.0 + 20.0, y: 0.0, width: contentView.bounds.maxX - 20.0 - (appImageView?.frame.width)! - 51.0 - 20.0, height: contentView.bounds.height)
            }
           
        }
        
        
        //----MADE PRIVATE FUNCTION BECAUSE IT CONFLICTS OBJC SETTER-----//
        private func setFeatureStatus(_ featureStatus: Bool) {
            self.featureStatus = featureStatus
            switchView?.isEnabled = featureStatus
        }
        
        
        @objc func handleStatusChange(_ switchView: UISwitch?) {
            delegate?.didSettingsChanged(switchView?.isOn ?? true, indexPath: indexPath)
        }
        
        
        override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
        }
        
        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
        }
    }
    
    
    
    class DailyLimitClockCell: UITableViewCell, TenClockDelegate {
        var clock: TenClock?
        var bottomLabel: UILabel?
        var switchView: UISwitch?
        var topImageView: UIImageView?
        var topLabel: UILabel?
        var delegate: DailyLimitClockCellDelegate?
        
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
//            self.init(style: style, reuseIdentifier: reuseIdentifier)
            
            selectionStyle  = .none
            backgroundColor = UIColor.white
            tintColor       = UIColor.red
            clipsToBounds   = true
            
            
            self.topImageView = UIImageView(image: UIImage(named: "ipad_ic_clock"))
            contentView.addSubview(topImageView!)
            
            clock = TenClock(frame: CGRect(x: 0.0, y: 30.0, width: contentView.bounds.width, height: contentView.bounds.height * 0.79))
            let startDate     = SwiftCommonUtility.shared.getGeorgianStartDate()
            clock?.startDate  = startDate
            
            
            clock?.endDate          = startDate
            clock?.centerTextColor  = .FTDarkGray //UIColor.ftDarkGray() FTDarkGray
            clock?.tintColor        = .FTLightPink
            clock?.delegate         = self
//            clock?.shouldMoveTail   = false;
            clock?.update()
            contentView.addSubview(clock!)
            
            bottomLabel             = UILabel(frame: CGRect.zero)
            bottomLabel?.textColor  = .FTLightGray //UIColor.ftLightGray()
            bottomLabel?.text       = "daily_app_limit_switch_2".localized
            bottomLabel?.font       = UIFont(name: "OpenSans", size: 16)
            bottomLabel?.numberOfLines = 2
//            bottomLabel?.backgroundColor = .systemPink
            contentView.addSubview(bottomLabel!)
            bottomLabel?.adjustsFontSizeToFitWidth = false
            
            
            switchView = UISwitch(frame: CGRect.zero)
            switchView?.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
            switchView?.onTintColor = .FTLightPink //UIColor.ftLightPink()
            switchView?.addTarget(self, action: #selector(self.handleSwitcValueChanged(_:)), for: .valueChanged)
            contentView.addSubview(switchView!)
            
            
            topLabel = UILabel(frame: CGRect.zero)
            topLabel?.textColor = .FTDarkGray //UIColor.ftDarkGray()
            topLabel?.text      = "daily_app_limit_content_1".localized
            topLabel?.font      = UIFont(name: "OpenSans", size: 16)
            contentView.addSubview(topLabel!)
        }
        
        
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        @objc func timesUpdated(_ clock: TenClock, startDate: Date, endDate: Date) {
            var interval: Int? = nil
            interval = Int(endDate.timeIntervalSince(startDate))
            let hours: Int = (interval ?? 0) / (60 * 60)
            let remainingInterval: Int = (interval ?? 0) % (60 * 60)
            let minutes: Int = remainingInterval / 60
            print(String(format: "%02ld:%02ld", hours, minutes))
            let hourToSeconds = hours * 60 * 60
            let mintToSeconds = minutes * 60
            print(hourToSeconds, mintToSeconds)
            
            let finalTimeOfLimits = hourToSeconds + mintToSeconds
            print(finalTimeOfLimits)
            DailyAppLimitSeconds.limtData = finalTimeOfLimits
            
            
            if(startDate == endDate){
                clock.isEnabled = true
            }
            
            delegate?.didTimeIntervalChanged(String(format: "%02ld:%02ld", hours, minutes))
            delegate?.didRadianChanged(getRadian(minute: minutes, hour: hours))
        }
        
        
        
        @objc func handleSwitcValueChanged(_ sender: UISwitch?) {
            delegate?.didAutoNewChanged((sender?.isOn)!)
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
                
                topImageView?.frame = CGRect(x: self.contentView.frame.size.width - 15 - 24, y: 15, width: 24, height: 24)
                topLabel?.frame     = CGRect(x: self.contentView.frame.size.width - 24 - 10 - 10 - 200, y: 15, width: 200, height: 24)
                clock?.frame        = CGRect(x: 0.0, y: 50.0, width: contentView.bounds.width, height: contentView.bounds.height * 0.79)
                bottomLabel?.frame  = CGRect(x: 15.0 + 51.0 + 10.0, y: contentView.bounds.height - 60, width: contentView.bounds.width - 90, height: 60)
                
                switchView?.frame   = CGRect(x: 15.0, y: contentView.bounds.height - 60, width: 51, height: 31)
                switchView?.center.y = bottomLabel?.center.y ?? contentView.bounds.height - 60
                topLabel?.adjustsFontSizeToFitWidth = true
                
            } else {
                
                topImageView?.frame = CGRect(x: 15, y: 15, width: 24, height: 24)
                topLabel?.frame     = CGRect(x: topImageView!.frame.maxX + 10, y: 15, width: contentView.bounds.width / 2.0, height: 24)
                clock?.frame        = CGRect(x: 0.0, y: 50.0, width: contentView.bounds.width, height: contentView.bounds.height * 0.79)
                bottomLabel?.frame  = CGRect(x: 15.0, y: contentView.bounds.height - 60, width: contentView.bounds.width - 90, height: 60)
                switchView?.frame   = CGRect(x: contentView.bounds.width - 66.0, y: contentView.bounds.height - 60, width: 51, height: 31)
                switchView?.center.y = bottomLabel?.center.y ?? contentView.bounds.height - 60
                topLabel?.adjustsFontSizeToFitWidth = true
                
            }
            
        }
        
        private func getRadian(minute:Int,hour:Int) -> String {
            let minuteRadian : Double = Double(minute) * 0.004361
            let hourRadian :Double = Double(hour) * 0.2617
            let totalValue = minuteRadian + hourRadian
            print("Radian value is,\(totalValue)")
            return "\(totalValue)"
        }
    }
    
    
    
    var tableView: ConditionallyScrollingTableView?
    var dataSource: [AnyHashable] = []
    var refreshControl: UIRefreshControl?
    //var delegate: AppDelegate?
    var headerLabel: UILabel?
    var headerSwitch: UISwitch?
//    var dashboard: DailyLimitDashboard?
    var dailyLimitsData : LimitsData?
    var duration = ""
    var radian = ""
    var autoAdd = 0
    var noContentImageView: UIImageView?
    var noContentLabel: UILabel?
    private var installedAppsList = [AppLimits]()
    var control = Control()
    var installedApp = [InstalledApp]()
    override func viewDidLoad() {
        super.viewDidLoad()
        LiveVisitorManager.shared.updateScreen(
            "Daily App Limits"
        )
        let childID = UserDefaults.standard.integer(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        //switchView.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        headerSwitch?.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        initialization()
        control = DBManager.shared.fetchAppBlockControl(identifier: "daily_app_limit")
        let state = control.state?.boolValue ?? false
        headerSwitch?.isOn = state
        let autoState = control.getAutoLimitAppValue()
        autoAdd = autoState
        let dailyLimit = DBManager.shared.getDailyLimit(childID: childID)
        self.duration = dailyLimit.duration?.intToStr() ?? ""
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        ZendeskChatManager.trackEvent("Daily Limit Screen")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        refreshControl?.endRefreshing()
//        SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
    }
        
    //MARK: - CUSTOM METHODS
    func initialization(){
        navigationItem.title = "settings_card_2_android_1".localized
        view.backgroundColor = UIColor.groupTableViewBackground
        //delegate  = AppDelegate.getSharedAppDelegateForSwift()
        setupTableVu()
        addHeaderView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.handleSave))
        loadSettings()
        triggerNotificationObserver()
        
    }
    
    func addHeaderView(){
        let headerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: view.bounds.width, height: 60.0))
        headerView.backgroundColor   = UIColor.init(red: 22, green: 151, blue: 191) //RGBCOLOR(22, 151, 191, 1) //---CHANGED FROM RGBCOLOR----//
        if UIView.appearance().semanticContentAttribute == .forceLeftToRight {
            headerLabel?.textAlignment   = .left
            headerSwitch = UISwitch(frame: CGRect(x: headerView.bounds.maxX - 66, y: headerView.bounds.midY - 15.5, width: 51, height: 31))
            headerLabel = UILabel(frame: CGRect(x: 15.0, y: 0.0, width: headerView.bounds.width - 100.0, height: headerView.bounds.height))
        } else {
            headerLabel?.textAlignment   = .right
            headerSwitch = UISwitch(frame: CGRect(x: 15.0, y: headerView.bounds.midY - 15.5, width: 51, height: 31))
            headerLabel = UILabel(frame: CGRect(x: 76.0, y: 0.0, width: headerView.bounds.width - 86.0, height: headerView.bounds.height))
        }
        headerLabel?.font            = UIFont(name: "OpenSans", size: 17)
        headerLabel?.text            = "daily_app_limit_switch_1".localized
        headerLabel?.backgroundColor = UIColor.clear
        headerLabel?.textColor       = UIColor.white
        headerSwitch?.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        headerSwitch?.addTarget(self, action: #selector(self.handleHeaderSwitch(_:)), for: .valueChanged)
        headerSwitch?.onTintColor = UIColor.init(red: 24, green: 167, blue: 225) //GL_COLOR(24, 167, 225, 1)
        headerView.addSubview(headerLabel ?? UILabel())
        headerView.addSubview(headerSwitch ?? UISwitch())
        tableView?.tableHeaderView = headerView
        
    }
    
    func setupTableVu(){
        tableView = ConditionallyScrollingTableView(frame: CGRect(x: 0.0, y: 0.0, width: view.bounds.width, height: view.bounds.height), style: .grouped)
        tableView?.delegate     = self
        tableView?.dataSource   = self
        view.addSubview(tableView!)
        tableView?.register(DailyLimitAppCell.self, forCellReuseIdentifier: "DailyLimitAppCell")
        tableView?.register(DailyLimitClockCell.self, forCellReuseIdentifier: "DailyLimitClockCell")
        tableView?.separatorStyle = .singleLine
        tableView?.sectionHeaderHeight = 10
        tableView?.sectionFooterHeight = 0
        tableView?.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }

    // MARK: - QBRefreshControlDelegate
    func addPullRefresh() {
        refreshControl = UIRefreshControl()
        tableView?.addSubview(refreshControl ?? UIRefreshControl())
        refreshControl?.addTarget(self, action: #selector(self.loadSettings), for: .valueChanged)
    }

    
    func refreshTable() {
        refreshControl?.endRefreshing()
        tableView?.reloadData()
    }
    
    private func triggerNotificationObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.dataResave(notification:)), name: Notification.Name("DAILY_APPLimit"), object: nil)
        UserDefaults.standard.set(true, forKey: "DAILY_LIMIT_NO")
    }
    
    @objc func dataResave(notification: Notification) {
        handleSave()
    }
    
    // MARK: - API
    @objc func handleSave() {
        //    let url = String(format: "%@/v2/ftd/settings/android/dailylimit/%ld", kBasUrl, delegate?.selectedDashboardChild.child_id ?? 0)
        if control.identifier == nil {
            HLApiManager.getControlApi()
            return
        }
        let conToggle = DBManager.shared.fetchAppBlockControl(identifier: "daily_app_limit")
        if conToggle.state ==  headerSwitch?.isOn.boolToInt() && conToggle.getAutoLimitAppValue() == dailyLimitsData?.isActive{
            callPutDailyLimit()
            return
        }
        SwiftFTUtils.showHUDAdded(to: self.view, withText: "Saving...", animated: true)
        HLApiManager.putControlDailyLimit(childId: control.childID ?? 0, featureId: control.featureID ?? 0, state: headerSwitch?.isOn.boolToInt() ?? 0, identifier: control.identifier ?? "", blockSt: autoAdd , callBack: { succ, err  in
            //
            UserDefaults.standard.setValue(true, forKey: "SETTING_IOS")
            if err != nil {
                SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
                CommonModel.showAlert("alert_error".localized, msg: err ?? "Nothing")
                return
            }
            //
            let dataValue = ["identifier": "auto_limit_new_apps", "status": self.autoAdd]
            
            if let jsonData = try? JSONSerialization.data(withJSONObject: dataValue, options: []),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                print(jsonString)
                DBManager.shared.fetchControlAndUpdate(identifier: "daily_app_limit", state: self.headerSwitch?.isOn.boolToInt() ?? 0, value: jsonString)
            } else {
                print("Failed to create JSON string.")
            }
            //DBManager.shared.fetchControlAndUpdate(identifier: self.control.identifier ?? "", state: self.headerSwitch?.isOn.boolToInt() ?? 0)
            self.callPutDailyLimit()
            
            
            //        UserDefaults.standard.set(true, forKey: "SETTING_IOS")
            //        let dailyLimit = DailyAppLimitSeconds.limtData - 300
            //        UserDefaults.standard.set(dailyLimit, forKey: "DAILY_LIMIT")
            //            let url = SwiftAPIConstants.kSaveAndroidDailyLimitSettings_mesh2 + "\(self.child_Id ?? "0")"
            //            guard let dailyLimitsData = self.dailyLimitsData else {
            //            CommonModel.showAlert("alert_error".localized, msg: "alert_something_wrong".localized)
            //            return
            //        }
            //        //This code is used to remove hr and min from app time limit
            //        let durationText = self.limitDuration
            //        let fullNameArr = durationText.split{$0 == " "}
            //        print(fullNameArr[0])
            //        print(fullNameArr[2])
            //        var time = "00:00"
            //        if fullNameArr.count == 3{
            //            var hours: String = String(fullNameArr[0]).replacingOccurrences(of: "time_hours".localized, with: "")
            //            var mins: String = String(fullNameArr[2]).replacingOccurrences(of: "time_mintues".localized, with: "")
            //            if hours.count < 2 {
            //                hours = "0" + hours
            //            }
            //            if mins.count < 2 {
            //                mins = "0" + mins
            //            }
            //            time = hours + ":" + mins
            //        }
            //        print(time)
            //        var appIds: [AnyHashable] = []
            //        let apps = self.installedAppsList
            //        if apps.count > 0 {
            //            for app in apps{
            //                if app.inDailyLimit == 1 {
            //                    appIds.append(["id" : app.installedappID])
            //                }
            //            }
            //        }
            //        if appIds.count == 0 && dailyLimitsData.autoAdd == 0 {
            //            let alert = UIAlertController(title: "alert_title".localized, message: "daily_app_limit_alert_content_1".localized, preferredStyle: .alert)
            //            alert.addAction(UIAlertAction(title: "ok_button".localized, style: .default, handler: { action in
            //            }))
            //            self.present(alert, animated: true, completion: nil)
            //        } else {
            //            SwiftFTUtils.showHUDAdded(to: self.view, withText: "Saving...", animated: true)
            //            let params = SwiftParamUtility.shared.androidDailyLimitSaveSettingsParams(dailyLimit: dailyLimitsData, installedApps: self.installedAppsList, duration: time, radian: self.radian)
            //
            //            print("url = \(url) and params = \(params)")
            //            SwiftFTUtils.showHUDAdded(to: self.view, withText: "Loading", animated: true)
            //            ApiManager.shared().putApi(url, params: params, controller: self, isContPresented: false) { (message, statusCode) in
            //                DispatchQueue.main.async {
            //                    UserDefaults.standard.set(true, forKey: UserDefaultsConstants.DAILY_LIMIT_RELOAD_HOME)
            //                    UserDefaults.standard.synchronize()
            //                    SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
            //                    self.viewDidDisappear(true)
            //                    //SwiftFTUtils.showSyncSettingsPopup(with: self)
            //                    CommonModel.showAlert("settings_card_5_1".localized, msg: "daily_app_limit_alert_content_2".localized)
            //                }
            //            }
            //        }
        })
    }
    func callPutDailyLimit() {
        let url = HLConstants.BASE_URL_CORE_2 + "controls/daily-limit"
        let arr = installedApp.filter({$0.inDailyLimit == 1})
        
        var ident = arr.compactMap {$0.appPackageName}
        if arr.count == 0 {
            ident = [""]
        }
        let params = ["apps":ident,
                      "child_id":self.child_Id?.integer ?? 0,
                      "duration":self.duration.integer] as [String : Any]
        SwiftFTUtils.showHUDAdded(to: self.view, withText: "Loading", animated: true)
        CoreManager.networkRequest(url: url,method: .put, params: params) { (response: EmptyResponseModel?, statusCode, msg) in
            SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
            if (200...206).contains(statusCode ?? 0) {
                self.loadDailyLimit()
                DBManager.shared.getLimitAndUpdate(duration: self.duration.integer)
                self.installedApp.forEach { app in
                    DBManager.shared.fetchAppAndUpdate(obj: app)
                }
                CommonModel.showAlert("successfull".localized, msg: "Daily limit for your child has been set, changes will take effect in few moments.".localized)
            } else {
                CommonModel.showAlert("alert_error".localized, msg: msg)
            }
        }
    }
    
    func loadDailyLimit() {
        let urrl = HLConstants.BASE_URL_CORE_2 + "controls/daily-limit"
        CoreManager.networkRequest(url: urrl, method: .get) { (response: DailyLimitCodableModel?, statusCode, message) in
            DispatchQueue.main.async {
                //MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                if (200...206).contains(statusCode ?? 0) {
                    DBManager.shared.deleteData(entityName: "DailyLimitTable")
                    DBManager.shared.saveDailyLimit(myModelArray: response?.dailyLimits ?? [])
                } else {
                    //CommonModel.showAlert("alert_error".localized, msg: message)
                }
            }
        }
    }

    @objc func loadSettings() {
        let selectedChildID = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        self.getDailyLimitsData(childID: selectedChildID ?? "")
    }
    
    //MARK: Load Installed Apps
    private func getDailyLimitsData(childID:String) {
        
        let apps = DBManager.shared.fetchDataAndConvertToModels()
        
        self.installedApp = apps
        if self.installedApp.count == 0 {
            self.addLableAndImage()
            self.addContentLabelAndImage()
        } else {
            self.updateUIForElseCase()
        }
        
        
 //       SwiftFTUtils.showHUDAdded(to: view, withText: "Loading...", animated: true)
//        HLApiManager.networkCallDailyLimits(childID: childID) { response, error in
//            if let res = response, response != nil {
//                SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
//                if let data = res[StringConstants.ResponseKeys.DATA] as? [String : Any] {
//                    let duration = data[StringConstants.ResponseKeys.DURAITON] as? String ?? ""
//                    let radian = data[StringConstants.ResponseKeys.RADAIN] as? Double ?? 0.0
//                    let remaining = data[StringConstants.ResponseKeys.REMAINING] as? Int ?? 0
//                    let autoAdd = data[StringConstants.ResponseKeys.AUTO_ADD] as? Int ?? 0
//                    let isActive = data[StringConstants.ResponseKeys.IS_ACTIVE] as? Int ?? 0
//                    let apps = data[StringConstants.ResponseKeys.APPS] as? [[String:Any]] ?? [[String:Any]]()
//                    for app in apps {
//                        let installedAppID = app[StringConstants.ResponseKeys.INSTALLED_APP_ID] as? Int ?? 0
//                        let appName = app[StringConstants.ResponseKeys.APP_NAME] as? String ?? ""
//                        let appPackageName = app[StringConstants.ResponseKeys.APP_PACKAGE_NAME] as? String ?? ""
//                        let appCategory = app[StringConstants.ResponseKeys.APP_CATEGORY] as? String ?? ""
//                        let inDailyLimit = app[StringConstants.ResponseKeys.IN_DAILY_LIMITS] as? Int ?? 0
//                        self.installedAppsList.append(AppLimits(installedappID: installedAppID, appName: appName, appPackageName: appPackageName, appCategory: appCategory, inDailyLimit: inDailyLimit))
//                    }
//                    self.dailyLimitsData = LimitsData(duration: duration, radian: radian, remaining: remaining, autoAdd: autoAdd, isActive: isActive, apps: self.installedAppsList)
//                }
//                if self.installedAppsList.count == 0 {
//                    self.addLableAndImage()
//                    self.addContentLabelAndImage()
//                } else {
//                    self.updateUIForElseCase()
//                }
//                
//            } else {
//                SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
//                CommonModel.showAlert("alert_error".localized, msg: "alert_something_wrong".localized)
//            }
//        }
    }
    
    func addLableAndImage(){
        self.noContentImageView = UIImageView(frame: CGRect(x: 236, y: 229, width: 296, height: 212))
        self.noContentImageView?.image = UIImage(named: "ipad_empty")
        self.noContentImageView?.contentMode = .scaleAspectFill
        self.view.addSubview(self.noContentImageView ?? UIImageView())
        self.noContentLabel = UILabel(frame: CGRect.zero)
        self.noContentLabel?.textColor = UIColor.lightGray
        self.noContentLabel?.textAlignment = .center
        self.noContentLabel?.numberOfLines = 0
        self.noContentLabel?.font = UIFont(name: "OpenSans", size: 16)
        let oops = "oops_title".localized
        let sec = "empty_record".localized
        self.noContentLabel?.text = "\(oops) \n\(sec)"
        self.view.addSubview(self.noContentLabel ?? UILabel())
        self.tableView?.isHidden = true
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    func addContentLabelAndImage(){
        if SwiftFTUtils.isDeviceiPhoneFamily() {
            self.noContentImageView?.frame = CGRect(x: (self.view.bounds.width - 225.0) / 2.0, y: self.view.bounds.midY - 101.0, width: 225, height: 101)
            self.noContentImageView?.image = UIImage(named: "ic_empty")
            self.noContentLabel?.frame = CGRect(x: (self.view.bounds.width - 225.0) / 2.0, y: self.noContentImageView?.frame.maxY ?? 20 + 20, width: 225, height: 150)
        } else {
            self.noContentImageView?.frame = CGRect(x: 236, y: 229, width: 296, height: 212)
            self.noContentImageView?.image = UIImage(named: "ipad_empty")
            //                    noContentLabel.frame = CGRect(x: 236, y: noContentImageView?.frame.maxY ?? <#default value#> + 20, width: 296, height: 212)
            self.noContentLabel?.frame = CGRect(x: 236, y: self.noContentImageView?.frame.maxY ?? 20 + 20, width: 296, height: 212)
        }
    }
    
    func updateUIForElseCase(){
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        self.tableView?.isHidden = false
        self.noContentImageView?.removeFromSuperview()
        self.noContentImageView = nil
        self.noContentLabel?.removeFromSuperview()
        self.noContentLabel = nil
        self.refreshTable()
        //self.duration = self.dailyLimitsData?.duration ?? ""
//        self.headerSwitch?.setOn(((self.dashboard?.data.is_active) != nil), animated: true)
        //self.headerSwitch?.setOn(((self.dailyLimitsData?.isActive == 1) ? true : false ), animated: true)
        print("\(self.duration)")
    }
}


//MARK: - Tableview Delegates and Datasources
extension AndroidDailyLimitVC : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        //return self.installedAppsList.count
        return self.installedApp.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect.zero)
        header.backgroundColor = UIColor.clear
        return header
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if Device.typeIsLike == DeviceType.iphone4 ||
                Device.typeIsLike == DeviceType.iphone5 {
                return 375
            } else {
                return 450
            }
        } else {
            if SwiftFTUtils.isDeviceiPhoneFamily() {
                return 60
            } else {
                return 75
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 1){
            let cell = tableView.dequeueReusableCell(withIdentifier: "DailyLimitAppCell", for: indexPath) as? DailyLimitAppCell
            //let app = dailyLimitsData?.apps?[indexPath.row]
            let app = installedApp[indexPath.row]
            cell?.setupApp(app)
            cell?.delegate = self
            cell?.indexPath = indexPath
            cell?.switchView?.isOn = (app.inDailyLimit == 1) ? true : false //((app?.in_daily_limit) != nil)
            cell?.switchView?.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
            cell?.appImageView?.image = UIImage(named: "ic_installed_apps")?.withRenderingMode(.alwaysTemplate)
            cell?.appImageView?.tintColor = UIColor.FTLightPink
            cell?.switchView?.isEnabled = headerSwitch?.isOn ?? false
//            if app == nil {
//                cell?.switchView?.isOn = false
//            }
            return cell ?? UITableViewCell()
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DailyLimitClockCell", for: indexPath) as? DailyLimitClockCell
            if (!duration.isEmpty){
                print(duration)
//                let hours = Int(duration[0..<2])
//                let minutes = Int(duration.substring(from: 3))
                let hours = (Int(duration) ?? 0)/3600
                let m = (Int(duration) ?? 0) % 3600
                let minutes = m/60
                print(String(format: "kaka=%li", minutes ))
                //let seconds: Int = (hours * 60 * 60) + (minutes * 60)
                let seconds: Int = (Int(duration) ?? 0)
                let startDate           = SwiftCommonUtility.shared.getGeorgianStartDate()
                cell?.clock?.startDate  = startDate
                cell?.clock?.endDate    = startDate.addingTimeInterval(TimeInterval(seconds))
                cell?.switchView?.isOn  = autoAdd.boolValue
                cell?.clock?.hoursIntt = hours 
                cell?.clock?.minutesIntt = minutes
                cell?.delegate = self
                self.tableView?.avoidingView = cell
            }
            cell?.clock?.isEnabled      = headerSwitch?.isOn ?? false
            cell?.switchView?.isEnabled = headerSwitch?.isOn ?? false
            cell?.clock?.update()
            
            self.limitDuration = cell?.clock?.titleTextLayer.string as! String
            print(self.limitDuration)
            return cell ?? UITableViewCell()
        }
    }
    
    
    @objc func handleHeaderSwitch(_ sender: UISwitch?) {
        dailyLimitsData?.isActive = (sender?.isOn)! ? 1 : 0
        
        print(sender?.isOn as Any)
        
        if sender?.isOn == true{
            UserDefaults.standard.set(true, forKey: "DAILY_LIMIT_SWITCH")
        }else{
            UserDefaults.standard.set(false, forKey: "DAILY_LIMIT_SWITCH")
        }
        tableView?.reloadData()
    }
    //44
}

//MARK: - DailyLimitClockCell Delegates
extension AndroidDailyLimitVC : DailyLimitClockCellDelegate {
    func didRadianChanged(_ radian: String) {
        self.radian = radian
    }
    
    func didTimeIntervalChanged(_ intrval: String?) {
        let hours = Int(intrval?[0..<2] ?? "00") ?? 0
        let minutes = Int(intrval?.substring(from: 3) ?? "00") ?? 0
        let seconds: Int = (hours * 60 * 60) + (minutes * 60)
        duration = seconds.intToStr() 
        print("DURATION: \(duration)")
        tableView?.reloadData()
    }
    
    func didAutoNewChanged(_ autoNew: Bool) {
        autoAdd = autoNew.boolToInt()
        dailyLimitsData?.autoAdd = autoNew ? 1 : 0
    }
}

//MARK: - DailyLimitAppCell Delegates
extension AndroidDailyLimitVC : DailyLimitAppCellDelegate {
    func didSettingsChanged(_ isActive: Bool, indexPath: IndexPath?) {
        self.installedApp[indexPath?.row ?? 0].inDailyLimit = isActive.boolToInt()
        
        
//        let app = dailyLimitsData?.apps?[indexPath?.row ?? 0]
//        app?.inDailyLimit = isActive ? 1 : 0
//        if let anApp = app {
//            dailyLimitsData?.apps?[indexPath?.row ?? 0] = anApp
//        }
    }
}
