//
//  LeftSidePanelVC.swift
//  FamilyTime
//
//  Created by YumyApps on 29/10/2021.
//  Copyright © 2021 YumyApps. All rights reserved.
//

import UIKit

class SettingViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: -  VARIABLES
    let delegate = UIApplication.shared.delegate as? AppDelegate
    var dataSource = NSDictionary()
    var doublePushFlag = false
    var placesCont = SwiftPlacesViewController()
    var contactWListCont = SwiftContactsWatchListViewController()
    var allKeys = [String]()
    var package_id : String = ""
    var package_name : String = ""
    var device : String = ""
    var childData_Obj: ChildData?
    
    //MARK: -  VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "settings_title".localized
        placesCont = SwiftPlacesViewController(nibName: "PlacesViewController", bundle: nil)
        contactWListCont = SwiftContactsWatchListViewController(nibName: "ContactsWatchListViewController", bundle: nil)
        tableView.register(UINib(nibName: "LeftSidesTableViewCell", bundle: nil), forCellReuseIdentifier: "LeftSidesCell")
        tableView.rowHeight = 75
        tableView.separatorStyle = .none
        // add the following string to the below array for adding Notifiction section -> "settings_card_3_title"
        self.allKeys = ["settings_card_1_title", "settings_card_2_title", "settings_card_4_title", "settings_card_5_title"]
        let child_Id = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        let chilId32 = Int32(child_Id ?? "")
        package_id = CoreDataUtility.fetchPackageIdFor(child_id: chilId32 ?? 0)
        package_name = CoreDataUtility.fetchPackageNameFor(child_id: chilId32 ?? 0)
        device = CoreDataUtility.fetchPackageDeviceFor(child_id: chilId32 ?? 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        ZendeskChatManager.trackEvent("Settings android device")
        let filePath = Bundle.main.path(forResource: "settings", ofType: "plist")
        if let data = NSDictionary(contentsOfFile: filePath ?? "") {
            self.dataSource = data
        }
        tableView.reloadData()
        self.doublePushFlag = false
    }
    
    //MARK: - Objective Functions
    @objc func updatePreference(_ indexPath: IndexPath?, value: Int) {
        var name: String?
        var includeUserId = true
        var isNotification = false //---FLAG TO HIT NOTIF API FOR SETTINGS---//
        if indexPath?.section == 0 && indexPath?.row == 0 {
            name = CoredataKeys.SettingKey.SETTING_CALL_LOGS
            includeUserId = false
        } else if indexPath?.section == 0 && indexPath?.row == 1 {
            name =  CoredataKeys.SettingKey.SETTING_SMS_LOGS
            includeUserId = false
        } else if indexPath?.section == 0 && indexPath?.row == 2 {
            name = CoredataKeys.SettingKey.SETTING_CONTACT_LOGS
            includeUserId = false
        } else if indexPath?.section == 0 && indexPath?.row == 3 {
            name = CoredataKeys.SettingKey.SETTING_LOCATION_TRACK
            includeUserId = false
        } else if indexPath?.section == 0 && indexPath?.row == 4 {
            name = CoredataKeys.SettingKey.SETTING_INSTALL_APP
            includeUserId = false
        } else if indexPath?.section == 0 && indexPath?.row == 5 {
            name = CoredataKeys.SettingKey.SETTING_SAFE_INTERNET
            includeUserId = false
        } else if indexPath?.section == 0 && indexPath?.row == 6 {
            name = CoredataKeys.SettingKey.SETTING_WEB_HISTORY
            includeUserId = false
        } else if indexPath?.section == 0 && indexPath?.row == 7 {
            name = CoredataKeys.SettingKey.SETTING_YOUTUBE_HISTORY
            includeUserId = false
        } else if indexPath?.section == 0 && indexPath?.row == 8 {
            name = CoredataKeys.SettingKey.SETTING_TIKTOK_HISTORY
            includeUserId = false
        }
//        else if indexPath?.section == 2 && indexPath?.row == 0 {
//            name = CoredataKeys.SettingKey.SETTING_PLACE_ALERT
//            includeUserId = true
//            isNotification = true
//        } else if indexPath?.section == 2 && indexPath?.row == 1 {
//            name = CoredataKeys.SettingKey.SETTING_BLOCK_ALERT
//            includeUserId = true
//            isNotification = true
//        } else if indexPath?.section == 2 && indexPath?.row == 2 {
//            name = CoredataKeys.SettingKey.SETTING_WATCHLIST_ALERT
//            includeUserId = true
//            isNotification = true
//        }
        //MARK: Make this section 3 when you uncomment the above code for section 2.
        else if indexPath?.section == 2 && indexPath?.row == 2 {
            name = CoredataKeys.SettingKey.SETTING_TOP_STACK
            includeUserId = false
            isNotification = false
        }
        var params: [String : Any] = [:]
        let userID = UserDefaults.standard.string(forKey: "userID")
        if includeUserId {
            print(value)
            params = [
                "name": name ?? "",
                "status": NSNumber(value: value),
                "value": String(format: "%i", value)
            ]
        } else {
            params = [
                "name": name ?? "",
                "status": NSNumber(value: value),
                "value": String(format: "%i", value)
            ]
        }
        print("params = \(params)")
        CommonModel.updatePreference(params, view: self, isNotification: isNotification)
    }
    
    func showPremiumAlert() {
        SwiftFTUtils.showSwiftPremiumPopup(on: self)
    }
    
    //MARK: - Helper Functions
    ////MARK: TOGLE ON SWITCHS FUNCTIONALITY
    func setSwitchState(_ indexPath: IndexPath?, cell: SettingTableViewCell?) {
        let child_Id = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        cell?.cellSwitch.isOn = false
        if indexPath?.section == 0 && indexPath?.row == 0 {
            let packageID = package_id
            var switchStatus = false
            if packageID == "2" || packageID == "3" {
                let callsPreference = CoreDataUtility.fetchPreferenceFromDatabase(child_id: child_Id ?? "")
                print(callsPreference)
                for i in callsPreference {
                    let v = i.name ?? ""
                    print(v)
                    if v == "call_logs"{
                        print(v)
                        print("STATUS:- \(i.status ?? 0)")
                        if i.status == 1 {
                            switchStatus = true
                        } else {
                            switchStatus = false
                        }
                    }
                }
                cell?.cellSwitch.isOn = switchStatus
            } else {
                cell?.cellSwitch.isOn = switchStatus
            }
        } else if indexPath?.section == 0 && indexPath?.row == 1 {
            var switchStatus = false
            let packageID = package_id
            if packageID == "3" {
                let callsPreference = CoreDataUtility.fetchPreferenceFromDatabase(child_id: child_Id ?? "")
                for i in callsPreference{
                    let v = i.name ?? ""
                    if v == "sms_logs" {
                        if i.status == 1 {
                            switchStatus = true
                        } else {
                            switchStatus = false
                        }
                    }
                }
                cell?.cellSwitch.isOn = switchStatus
            } else {
                cell?.cellSwitch.isOn = switchStatus
            }
        } else if indexPath?.section == 0 && indexPath?.row == 2 {
            let packageID = package_id
            var switchStatus = false
            if packageID == "2" || packageID == "3" {
                let callsPreference = CoreDataUtility.fetchPreferenceFromDatabase(child_id: child_Id ?? "")
                print(callsPreference)
                for i in callsPreference{
                    let v = i.name ?? ""
                    if v == "contact_logs"{
                        if i.status == 1 {
                            switchStatus = true
                        } else {
                            switchStatus = false
                        }
                    }
                }
                cell?.cellSwitch.isOn = switchStatus
            } else {
                cell?.cellSwitch.isOn = switchStatus
            }
            
        } else if indexPath?.section == 0 && indexPath?.row == 3 {
            var switchStatus = false
            let packageID = package_id
            if packageID == "2" || packageID == "3" {
                let callsPreference = CoreDataUtility.fetchPreferenceFromDatabase(child_id: child_Id ?? "")
                for i in callsPreference{
                    let v = i.name ?? ""
                    if v == "location_tracking"{
                        if i.status == 1 {
                            switchStatus = true
                        } else {
                            switchStatus = false
                        }
                    }
                }
                cell?.cellSwitch.isOn = switchStatus
            } else {
                cell?.cellSwitch.isOn = switchStatus
                
            }
        } else if indexPath?.section == 0 && indexPath?.row == 4 {
            let child_Id = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID) ?? ""
            var switchStatus = false
            let packageID = package_id
            if packageID == "2" || packageID == "3" {
                let callsPreference = CoreDataUtility.fetchPreferenceFromDatabase(child_id: child_Id)
                print(callsPreference)
                for i in callsPreference {
                    let v = i.name ?? ""
                    if v == "installed_app_logs"{
                        if i.status == 1 {
                            switchStatus = true
                        } else {
                            switchStatus = false
                        }
                    }
                }
                cell?.cellSwitch.isOn = switchStatus
            } else {
                cell?.cellSwitch.isOn = switchStatus
            }
        } else if indexPath?.section == 0 && indexPath?.row == 5 {
            let child_Id = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID) ?? ""
            var switchStatus = false
            let packageID = package_id
            if packageID == "2" || packageID == "3" {
                let callsPreference = CoreDataUtility.fetchPreferenceFromDatabase(child_id: child_Id)
                print(callsPreference)
                for i in callsPreference {
                    let v = i.name ?? ""
                    if v == "safe_internet"{
                        if i.status == 1 {
                            switchStatus = true
                        } else {
                            switchStatus = false
                        }
                    }
                }
                cell?.cellSwitch.isOn = switchStatus
            } else {
                cell?.cellSwitch.isOn = switchStatus
            }
        } else if indexPath?.section == 0 && indexPath?.row == 6 {
            if self.package_id == "1" {
                cell?.cellSwitch.isOn = false
            } else {
                let callsPreference = CoreDataUtility.fetchPreferenceFromDatabase(child_id: child_Id ?? "")
                var switchStatus = false
                for i in callsPreference{
                    let v = i.name ?? ""
                    print("WEB:- \(v)")
                    if v == "web_history"{
                        if i.status == 1 {
                            switchStatus = true
                        }else{
                            switchStatus = false
                        }
                    }
                }
                cell?.cellSwitch.isOn = switchStatus
            }
        } else if indexPath?.section == 0 && indexPath?.row == 7 {
            if self.package_id == "1" {
                cell?.cellSwitch.isOn = false
            } else {
                let callsPreference = CoreDataUtility.fetchPreferenceFromDatabase(child_id: child_Id ?? "")
                var switchStatus = false
                for i in callsPreference{
                    let v = i.name ?? ""
                    print("YOUTUBE:- \(v)")
                    if v == "yotutube_history"{
                        if i.status == 1 {
                            switchStatus = true
                        }else{
                            switchStatus = false
                        }
                    }
                }
                cell?.cellSwitch.isOn = switchStatus
            }
        } else if indexPath?.section == 0 && indexPath?.row == 8 {
            if self.package_id == "1" {
                cell?.cellSwitch.isOn = false
            } else {
                let callsPreference = CoreDataUtility.fetchPreferenceFromDatabase(child_id: child_Id ?? "")
                var switchStatus = false
                for i in callsPreference{
                    let v = i.name ?? ""
                    print("TIKTOK:- \(v)")
                    if v == "tiktok_history"{
                        if i.status == 1 {
                            switchStatus = true
                        }else{
                            switchStatus = false
                        }
                    }
                }
                cell?.cellSwitch.isOn = switchStatus
            }
        }
//        else if indexPath?.section == 2 && indexPath?.row == 0 {
//            let child_Id = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID) ?? ""
//            let callsPreference = CoreDataUtility.fetchPreferenceFromDatabase(child_id: child_Id)
//            print(callsPreference)
//            var switchStatus = false
//            for i in callsPreference{
//                let v = i.name ?? ""
//                if v == "monitor_places_alert"{
//                    if i.status == 1 {
//                        switchStatus = true
//                    } else {
//                        switchStatus = false
//                    }
//                }
//            }
//            cell?.cellSwitch.isOn = switchStatus
//        } else if indexPath?.section == 2 && indexPath?.row == 1 {
//            if self.package_id == "1" {
//                cell?.cellSwitch.isOn = false
//            } else {
//                let callsPreference = CoreDataUtility.fetchPreferenceFromDatabase(child_id: child_Id ?? "")
//                print(callsPreference)
//                var switchStatus = false
//                for i in callsPreference{
//                    let v = i.name ?? ""
//                    if v == "app_blocking_alert"{
//                        if i.status == 1 {
//                            switchStatus = true
//                        } else {
//                            switchStatus = false
//                        }
//                    }
//                }
//                cell?.cellSwitch.isOn = switchStatus
//            }
//        } else if indexPath?.section == 2 && indexPath?.row == 2 {
//            var switchStatus = false
//            let packageID = package_id
//            if packageID == "2" || packageID == "3" {
//                let callsPreference = CoreDataUtility.fetchPreferenceFromDatabase(child_id: child_Id ?? "")
//                for i in callsPreference {
//                    let v = i.name ?? ""
//                    if v == "contact_watchlist_alert" {
//                        if i.status == 1 {
//                            switchStatus = true
//                        } else {
//                            switchStatus = false
//                        }
//                    }
//                }
//                cell?.cellSwitch.isOn = switchStatus
//            } else {
//                cell?.cellSwitch.isOn = switchStatus
//            }
//        }
        //MARK: Make the this section 3 when you uncommet the above code for section 2.
        else if indexPath?.section == 2 && indexPath?.row == 2 {
            let child_Id = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID) ?? ""
            var switchStatus = false
            let packageID = package_id
            if packageID == "2" || packageID == "3" {
                let callsPreference = CoreDataUtility.fetchPreferenceFromDatabase(child_id: child_Id)
                print(callsPreference)
                for i in callsPreference {
                    let v = i.name ?? ""
                    if v == "top_stack"{
                        if i.status == 1 {
                            switchStatus = true
                        } else {
                            switchStatus = false
                        }
                    }
                }
                cell?.cellSwitch.isOn = switchStatus
            } else {
                cell?.cellSwitch.isOn = switchStatus
            }
        } else {
            cell?.cellSwitch.isOn = false
        }
    }
    
    func synSettings() {
        
//        SwiftFTUtils.showHUDAdded(to: view, withText: "Loading...".myModification(), animated: true)
//        CoreManager.syncSettings(params: ["feature": "all"]) {
//            SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
//        }
        
        let child_Id = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        SwiftFTUtils.showHUDAdded(to: view, withText: "Loading...".myModification(), animated: true)
        let url = String(format: "\(kAndroid_Sync_settings_mesh2)\(Int(child_Id ?? "") ?? -1)")
        let params = [
            "setting": "all"
        ]
        print("url to sync settings = \(url) and params = \(params)")
        ApiManager.shared().postApi(withVC: self, isPresentedCont: false, andParams: params, withApi: url) { message, statusCode in
            DispatchQueue.main.async {
                SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
                CommonModel.showAlert("settings_card_5_1".localized, msg: "sync_alert_content_1".localized)
            }
        }
    }

    //MARK: - TableView Data Sourse and Delegate
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let frame = UIScreen.main.bounds
        let view = UIView(frame: CGRect(x: 10, y: 10, width: frame.size.width, height: 40))
        view.backgroundColor = UIColor.white
        let headertitle = UILabel()
        headertitle.frame = CGRect.init(x: 10, y: 15, width: tableView.frame.width-20, height: 30)
        
        if section == 0 {
            headertitle.textColor = CommonModel.color(fromHexString: "orange")
        } else if section == 1 {
            headertitle.textColor = CommonModel.color(fromHexString: "green")
        } else if section == 2 {
            headertitle.textColor = CommonModel.color(fromHexString: "purple")
        } else if section == 3 {
            headertitle.textColor = CommonModel.color(fromHexString: "red")
        } else {
            headertitle.textColor = CommonModel.color(fromHexString: "orange")
        }
        
        headertitle.text = allKeys[section]
        headertitle.font = UIFont(name: "OpenSans", size: 20.0)
        headertitle.text = headertitle.text?.myModification()
        view.addSubview(headertitle)
        return view
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print(dataSource.count)
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("SECTIONS:- \((dataSource.value(forKey: allKeys[section]) as AnyObject).count ?? 0)")
        return (dataSource.value(forKey: allKeys[section]) as AnyObject).count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "LeftSidesCell") as? SettingTableViewCell
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "LeftSidesCell") as? SettingTableViewCell
        }
        let key = allKeys[indexPath.section]
        let items = dataSource.value(forKey: key) as? [AnyHashable]
        var label = ""
        var lImgName = ""
        var rImgName = ""
        if let item = items?[indexPath.row] as? NSDictionary {
            label = item["label"] as! String
            lImgName = item["lefticon"] as! String
            rImgName = item["righticon"] as! String
        }
        cell?.cellImage.image = UIImage(named: lImgName)
        if rImgName.count > 0 {
            cell?.cellSwitch.isHidden = false
//            let type = UserDefaults.standard.string(forKey: "userType")
//            if indexPath.section == 2 && (type == "Super") {
//                cell?.cellSwitch.isEnabled = true
//            } else if indexPath.section == 2 && (type != "Super") {
//                cell?.cellSwitch.isEnabled = false
//            }
            setSwitchState(indexPath, cell: cell)
            cell?.onSwitchChange = { cellAffected in
                if indexPath.section == 0 && indexPath.row == 0 {
                    let packageID = self.package_id
                    if packageID == "2" || packageID == "3" {
                        let indexPath = tableView.indexPath(for: cellAffected!)
                        print(String(format: "Section %ld Row : %ld", Int(indexPath?.section ?? 0), Int(indexPath?.row ?? 0)))
                        var switchStatus = 0
                        if cellAffected?.cellSwitch.isOn == true {
                            switchStatus = 1
                        }
                        let dashboardStoryBoard = UIStoryboard(name: "Dashboard", bundle: nil)
                        let vc = dashboardStoryBoard.instantiateViewController(withIdentifier: "SyncPopUpViewController") as? SyncPopUpViewController ?? SyncPopUpViewController()
                        vc.settingScreenStr = "1"
                        vc.modalPresentationStyle = .overFullScreen
                        self.present(vc, animated: true)
                        vc.callback = { message in
                            print(message)
                            if message == "YES"{
                                print(message)
                                self.updatePreference(indexPath, value: switchStatus)
                            } else {
                                print("NOTHING")
                                print(switchStatus)
                                if switchStatus == 1{
                                    cellAffected?.cellSwitch.isOn = false
                                }else{
                                    cellAffected?.cellSwitch.isOn = true
                                }
                            }
                        }
                    } else {
                        if !self.doublePushFlag {
                            self.doublePushFlag = true
                            self.showPremiumAlert()
                            cellAffected?.cellSwitch.isOn = false
                        }
                    }
                } else if indexPath.section == 0 && indexPath.row == 1 {
                    let packageID = self.package_id
                    if packageID == "3" {
                        let indexPath = tableView.indexPath(for: cellAffected!)
                        print(String(format: "Section %ld Row : %ld", Int(indexPath?.section ?? 0), Int(indexPath?.row ?? 0)))
                        var switchStatus = 0
                        if cellAffected?.cellSwitch.isOn == true {
                            switchStatus = 1
                        }
                        let dashboardStoryBoard = UIStoryboard(name: "Dashboard", bundle: nil)
                        let vc = dashboardStoryBoard.instantiateViewController(withIdentifier: "SyncPopUpViewController") as? SyncPopUpViewController ?? SyncPopUpViewController()
                        vc.settingScreenStr = "1"
                        vc.modalPresentationStyle = .overFullScreen
                        self.present(vc, animated: true)
                        vc.callback = { message in
                            print(message)
                            if message == "YES"{
                                print(message)
                                self.updatePreference(indexPath, value: switchStatus)
                            } else {
                                print("NOTHING")
                                print(switchStatus)
                                if switchStatus == 1{
                                    cellAffected?.cellSwitch.isOn = false
                                }else{
                                    cellAffected?.cellSwitch.isOn = true
                                }
                            }
                        }
                    } else {
                        if !self.doublePushFlag {
                            self.doublePushFlag = true
                            self.showPremiumAlert()
                            cellAffected?.cellSwitch.isOn = false
                        }
                    }
                } else if indexPath.section == 0 && indexPath.row == 2 {
                    let packageID = self.package_id
                    if packageID == "2" || packageID == "3" {
                        let indexPath = tableView.indexPath(for: cellAffected!)
                        var switchStatus = 0
                        if cellAffected?.cellSwitch.isOn == true {
                            switchStatus = 1
                        }
                        let dashboardStoryBoard = UIStoryboard(name: "Dashboard", bundle: nil)
                        let vc = dashboardStoryBoard.instantiateViewController(withIdentifier: "SyncPopUpViewController") as? SyncPopUpViewController ?? SyncPopUpViewController()
                        vc.settingScreenStr = "1"
                        vc.modalPresentationStyle = .overFullScreen
                        self.present(vc, animated: true)
                        vc.callback = { message in
                            print(message)
                            if message == "YES"{
                                print(message)
                                self.updatePreference(indexPath, value: switchStatus)
                            } else {
                                print("NOTHING")
                                print(switchStatus)
                                if switchStatus == 1{
                                    cellAffected?.cellSwitch.isOn = false
                                }else{
                                    cellAffected?.cellSwitch.isOn = true
                                }
                            }
                        }
                    } else {
                        if !self.doublePushFlag {
                            self.doublePushFlag = true
                            self.showPremiumAlert()
                            cellAffected?.cellSwitch.isOn = false
                        }
                    }
                } else if indexPath.section == 0 && indexPath.row == 3 {
                    let packageID = self.package_id
                    if packageID == "2" || packageID == "3" {
                        let indexPath = tableView.indexPath(for: cellAffected!)
                        print(String(format: "Section %ld Row : %ld", Int(indexPath?.section ?? 0), Int(indexPath?.row ?? 0)))
                        var switchStatus = 0
                        if cellAffected?.cellSwitch.isOn == true {
                            switchStatus = 1
                        }
                        let dashboardStoryBoard = UIStoryboard(name: "Dashboard", bundle: nil)
                        let vc = dashboardStoryBoard.instantiateViewController(withIdentifier: "SyncPopUpViewController") as? SyncPopUpViewController ?? SyncPopUpViewController()
                        vc.settingScreenStr = "1"
                        vc.modalPresentationStyle = .overFullScreen
                        self.present(vc, animated: true)
                        vc.callback = { message in
                            print(message)
                            if message == "YES"{
                                print(message)
                                self.updatePreference(indexPath, value: switchStatus)
                            } else {
                                print("NOTHING")
                                print(switchStatus)
                                if switchStatus == 1{
                                    cellAffected?.cellSwitch.isOn = false
                                }else{
                                    cellAffected?.cellSwitch.isOn = true
                                }
                            }
                        }
                    } else {
                        if !self.doublePushFlag {
                            self.doublePushFlag = true
                            self.showPremiumAlert()
                            cellAffected?.cellSwitch.isOn = false
                        }
                    }
                } else if indexPath.section == 0 && indexPath.row == 4 {
                    let packageID = self.package_id
                    if packageID == "2" || packageID == "3" {
                        let indexPath = tableView.indexPath(for: cellAffected!)
                        var switchStatus = 0
                        if cellAffected?.cellSwitch.isOn == true {
                            switchStatus = 1
                        }
                        let dashboardStoryBoard = UIStoryboard(name: "Dashboard", bundle: nil)
                        let vc = dashboardStoryBoard.instantiateViewController(withIdentifier: "SyncPopUpViewController") as? SyncPopUpViewController ?? SyncPopUpViewController()
                        vc.settingScreenStr = "1"
                        vc.modalPresentationStyle = .overFullScreen
                        self.present(vc, animated: true)
                        vc.callback = { message in
                            print(message)
                            if message == "YES"{
                                print(message)
                                self.updatePreference(indexPath, value: switchStatus)
                            } else {
                                print("NOTHING")
                                print(switchStatus)
                                if switchStatus == 1{
                                    cellAffected?.cellSwitch.isOn = false
                                }else{
                                    cellAffected?.cellSwitch.isOn = true
                                }
                            }
                        }
                    } else {
                        if !self.doublePushFlag {
                            self.doublePushFlag = true
                            self.showPremiumAlert()
                            cellAffected?.cellSwitch.isOn = false
                        }
                    }
                } else if indexPath.section == 0 && indexPath.row == 5 {
                    let packageID = self.package_id
                    if packageID == "2" || packageID == "3" {
                        let indexPath = tableView.indexPath(for: cellAffected!)
                        print(String(format: "Section %ld Row : %ld", Int(indexPath?.section ?? 0), Int(indexPath?.row ?? 0)))
                        var switchStatus = 0
                        if cellAffected?.cellSwitch.isOn == true {
                            switchStatus = 1
                        }
                        let dashboardStoryBoard = UIStoryboard(name: "Dashboard", bundle: nil)
                        let vc = dashboardStoryBoard.instantiateViewController(withIdentifier: "SyncPopUpViewController") as? SyncPopUpViewController ?? SyncPopUpViewController()
                        vc.settingScreenStr = "1"
                        vc.modalPresentationStyle = .overFullScreen
                        self.present(vc, animated: true)
                        vc.callback = { message in
                            print(message)
                            if message == "YES"{
                                print(message)
                                self.updatePreference(indexPath, value: switchStatus)
                            } else {
                                print("NOTHING")
                                print(switchStatus)
                                if switchStatus == 1{
                                    cellAffected?.cellSwitch.isOn = false
                                }else{
                                    cellAffected?.cellSwitch.isOn = true
                                }
                            }
                        }
                    } else {
                        if !self.doublePushFlag {
                            self.doublePushFlag = true
                            self.showPremiumAlert()
                            cellAffected?.cellSwitch.isOn = false
                        }
                    }
                } else if indexPath.section == 0 && indexPath.row == 6 {
                    let packageID = self.package_id
                    if packageID == "2" || packageID == "3" {
                        let indexPath = tableView.indexPath(for: cellAffected!)
                        print(String(format: "Section %ld Row : %ld", Int(indexPath?.section ?? 0), Int(indexPath?.row ?? 0)))
                        var switchStatus = 0
                        if cellAffected?.cellSwitch.isOn == true {
                            switchStatus = 1
                        }
                        let dashboardStoryBoard = UIStoryboard(name: "Dashboard", bundle: nil)
                        let vc = dashboardStoryBoard.instantiateViewController(withIdentifier: "SyncPopUpViewController") as? SyncPopUpViewController ?? SyncPopUpViewController()
                        vc.settingScreenStr = "1"
                        vc.modalPresentationStyle = .overFullScreen
                        self.present(vc, animated: true)
                        vc.callback = { message in
                            print(message)
                            if message == "YES"{
                                print(message)
                                self.updatePreference(indexPath, value: switchStatus)
                            } else {
                                print("NOTHING")
                                print(switchStatus)
                                if switchStatus == 1{
                                    cellAffected?.cellSwitch.isOn = false
                                }else{
                                    cellAffected?.cellSwitch.isOn = true
                                }
                            }
                        }
                    } else {
                        if !self.doublePushFlag {
                            self.doublePushFlag = true
                            self.showPremiumAlert()
                            cellAffected?.cellSwitch.isOn = false
                        }
                    }
                } else if indexPath.section == 0 && indexPath.row == 7 {
                    let packageID = self.package_id
                    if packageID == "2" || packageID == "3" {
                        let indexPath = tableView.indexPath(for: cellAffected!)
                        print(String(format: "Section %ld Row : %ld", Int(indexPath?.section ?? 0), Int(indexPath?.row ?? 0)))
                        var switchStatus = 0
                        if cellAffected?.cellSwitch.isOn == true {
                            switchStatus = 1
                        }
                        let dashboardStoryBoard = UIStoryboard(name: "Dashboard", bundle: nil)
                        let vc = dashboardStoryBoard.instantiateViewController(withIdentifier: "SyncPopUpViewController") as? SyncPopUpViewController ?? SyncPopUpViewController()
                        vc.settingScreenStr = "1"
                        vc.modalPresentationStyle = .overFullScreen
                        self.present(vc, animated: true)
                        vc.callback = { message in
                            print(message)
                            if message == "YES"{
                                print(message)
                                self.updatePreference(indexPath, value: switchStatus)
                            } else {
                                print("NOTHING")
                                print(switchStatus)
                                if switchStatus == 1{
                                    cellAffected?.cellSwitch.isOn = false
                                }else{
                                    cellAffected?.cellSwitch.isOn = true
                                }
                            }
                        }
                    } else {
                        if !self.doublePushFlag {
                            self.doublePushFlag = true
                            self.showPremiumAlert()
                            cellAffected?.cellSwitch.isOn = false
                        }
                    }
                } else if indexPath.section == 0 && indexPath.row == 8 {
                    let packageID = self.package_id
                    if packageID == "2" || packageID == "3" {
                        let indexPath = tableView.indexPath(for: cellAffected!)
                        print(String(format: "Section %ld Row : %ld", Int(indexPath?.section ?? 0), Int(indexPath?.row ?? 0)))
                        var switchStatus = 0
                        if cellAffected?.cellSwitch.isOn == true {
                            switchStatus = 1
                        }
                        let dashboardStoryBoard = UIStoryboard(name: "Dashboard", bundle: nil)
                        let vc = dashboardStoryBoard.instantiateViewController(withIdentifier: "SyncPopUpViewController") as? SyncPopUpViewController ?? SyncPopUpViewController()
                        vc.settingScreenStr = "1"
                        vc.modalPresentationStyle = .overFullScreen
                        self.present(vc, animated: true)
                        vc.callback = { message in
                            print(message)
                            if message == "YES"{
                                print(message)
                                self.updatePreference(indexPath, value: switchStatus)
                            } else {
                                print("NOTHING")
                                print(switchStatus)
                                if switchStatus == 1{
                                    cellAffected?.cellSwitch.isOn = false
                                }else{
                                    cellAffected?.cellSwitch.isOn = true
                                }
                            }
                        }
                    } else {
                        if !self.doublePushFlag {
                            self.doublePushFlag = true
                            self.showPremiumAlert()
                            cellAffected?.cellSwitch.isOn = false
                        }
                    }
                }
//                else if indexPath.section == 2 && indexPath.row == 0 {
//                    let indexPath = tableView.indexPath(for: cellAffected!)
//                    var switchStatus = 0
//                    if cellAffected?.cellSwitch.isOn == true {
//                        switchStatus = 1
//                    }
//                    let dashboardStoryBoard = UIStoryboard(name: "Dashboard", bundle: nil)
//                    let vc = dashboardStoryBoard.instantiateViewController(withIdentifier: "SyncPopUpViewController") as? SyncPopUpViewController ?? SyncPopUpViewController()
//                    vc.settingScreenStr = "1"
//                    vc.modalPresentationStyle = .overFullScreen
//                    self.present(vc, animated: true)
//                    vc.callback = { message in
//                        print(message)
//                        if message == "YES"{
//                            print(message)
//                            self.updatePreference(indexPath, value: switchStatus)
//                        } else {
//                            print("NOTHING")
//                            print(switchStatus)
//                            if switchStatus == 1{
//                                cellAffected?.cellSwitch.isOn = false
//                            }else{
//                                cellAffected?.cellSwitch.isOn = true
//                            }
//                        }
//                    }
//                } else if indexPath.section == 2 && indexPath.row == 1 {
//                    if self.package_id == "2" || self.package_id == "3" {
//                        let indexPath = tableView.indexPath(for: cellAffected!)
//                        print(String(format: "Section %ld Row : %ld", Int(indexPath?.section ?? 0), Int(indexPath?.row ?? 0)))
//                        var switchStatus = 0
//                        if cellAffected?.cellSwitch.isOn == true {
//                            switchStatus = 1
//                        }
//                        let dashboardStoryBoard = UIStoryboard(name: "Dashboard", bundle: nil)
//                        let vc = dashboardStoryBoard.instantiateViewController(withIdentifier: "SyncPopUpViewController") as? SyncPopUpViewController ?? SyncPopUpViewController()
//                        vc.settingScreenStr = "1"
//                        vc.modalPresentationStyle = .overFullScreen
//                        self.present(vc, animated: true)
//                        vc.callback = { message in
//                            print(message)
//                            if message == "YES"{
//                                print(message)
//                                self.updatePreference(indexPath, value: switchStatus)
//                            } else {
//                                print("NOTHING")
//                                print(switchStatus)
//                                if switchStatus == 1{
//                                    cellAffected?.cellSwitch.isOn = false
//                                }else{
//                                    cellAffected?.cellSwitch.isOn = true
//                                }
//                            }
//                        }
//                    } else {
//                        if !self.doublePushFlag {
//                            self.doublePushFlag = true
//                            self.showPremiumAlert()
//                            cellAffected?.cellSwitch.isOn = false
//                        }
//                    }
//                } else if indexPath.section == 2 && indexPath.row == 2 {
//                    if self.package_id == "2" || self.package_id == "3" {
//                        let indexPath = tableView.indexPath(for: cellAffected!)
//                        var switchStatus = 0
//                        if cellAffected?.cellSwitch.isOn == true {
//                            switchStatus = 1
//                        }
//                        let dashboardStoryBoard = UIStoryboard(name: "Dashboard", bundle: nil)
//                        let vc = dashboardStoryBoard.instantiateViewController(withIdentifier: "SyncPopUpViewController") as? SyncPopUpViewController ?? SyncPopUpViewController()
//                        vc.settingScreenStr = "1"
//                        vc.modalPresentationStyle = .overFullScreen
//                        self.present(vc, animated: true)
//                        vc.callback = { message in
//                            print(message)
//                            if message == "YES"{
//                                print(message)
//                                self.updatePreference(indexPath, value: switchStatus)
//                            } else {
//                                print("NOTHING")
//                                print(switchStatus)
//                                if switchStatus == 1{
//                                    cellAffected?.cellSwitch.isOn = false
//                                }else{
//                                    cellAffected?.cellSwitch.isOn = true
//                                }
//                            }
//                        }
//                    } else {
//                        if !self.doublePushFlag {
//                            self.doublePushFlag = true
//                            self.showPremiumAlert()
//                            cellAffected?.cellSwitch.isOn = false
//                        }
//                    }
//                }
                //MARK: Make the this section 3 when you uncommet the above code for section 2.
                else if indexPath.section == 2 && indexPath.row == 2 {
                    let packageID = self.package_id
                    if packageID == "2" || packageID == "3" {
                        let indexPath = tableView.indexPath(for: cellAffected!)
                        var switchStatus = 0
                        if cellAffected?.cellSwitch.isOn == true {
                            switchStatus = 1
                        }
                        let dashboardStoryBoard = UIStoryboard(name: "Dashboard", bundle: nil)
                        let vc = dashboardStoryBoard.instantiateViewController(withIdentifier: "SyncPopUpViewController") as? SyncPopUpViewController ?? SyncPopUpViewController()
                        vc.settingScreenStr = "1"
                        vc.modalPresentationStyle = .overFullScreen
                        self.present(vc, animated: true)
                        vc.callback = { message in
                            print(message)
                            if message == "YES"{
                                print(message)
                                self.updatePreference(indexPath, value: switchStatus)
                            } else {
                                print("NOTHING")
                                print(switchStatus)
                                if switchStatus == 1{
                                    cellAffected?.cellSwitch.isOn = false
                                }else{
                                    cellAffected?.cellSwitch.isOn = true
                                }
                            }
                        }
                    } else {
                        if !self.doublePushFlag {
                            self.doublePushFlag = true
                            self.showPremiumAlert()
                            cellAffected?.cellSwitch.isOn = false
                        }
                    }
                }
            } // Cell Affected End Here
        } else {
            cell?.cellSwitch.isHidden = true
        }
        cell?.cellLabel.text = label.myModification()
        if indexPath.section == 0 {
            cell?.cellSwitch.onTintColor = CommonModel.color(fromHexString: "orange")
        } else if indexPath.section == 2 {
            cell?.cellSwitch.onTintColor = CommonModel.color(fromHexString: "purple")
        } else if indexPath.section == 3 {
            cell?.cellSwitch.onTintColor = CommonModel.color(fromHexString: "red")
        }
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let packageId = self.package_id
        let key = allKeys[indexPath.section]
        let items = dataSource.value(forKey: key) as? [AnyHashable]
        var label = ""
        if let item = items?[indexPath.row] as? NSDictionary {
            label = item["label"] as! String
        }
        if (label == "settings_card_2_android_5") && indexPath.section == 1 {
            
            if packageId == "2" || packageId == "3" {
                navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                let stb = UIStoryboard(name: "Dashboard", bundle: nil)
                let vc = stb.instantiateViewController(withIdentifier: "InternetFilterVC") as? InternetFilterVC
                if let vc = vc {
                    navigationController?.pushViewController(vc, animated: true)
                }
            } else {
                SwiftFTUtils.showSwiftPremiumPopup(on: self)
            }
        } else if (label == "settings_card_2_android_4") && indexPath.section == 1 {
            //if packageId == "2" || packageId == "3" {
                let stb = UIStoryboard(name: "Dashboard", bundle: nil)
                let vc = stb.instantiateViewController(withIdentifier: "InternetScheduleVC") as? InternetScheduleVC
                navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                if let vc = vc {
                    navigationController?.pushViewController(vc, animated: true)
                }
//            } else {
//                SwiftFTUtils.showSwiftPremiumPopup(on: self)
//            }
        } else if (label == "settings_card_2_android_6") && indexPath.section == 1 {
            if packageId == "2" || packageId == "3" {
                navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                navigationController?.pushViewController(placesCont, animated: true)
            } else {
                SwiftFTUtils.showSwiftPremiumPopup(on: self)
            }
        } else if (label == "settings_card_2_android_2") && indexPath.section == 1 {
            if packageId == "2" || packageId == "3" {
                navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                let stb = UIStoryboard(name: "Dashboard", bundle: nil)
                let vc = stb.instantiateViewController(withIdentifier: "AppBlockerAndroidVC") as? AppBlockerAndroidVC
                if let vc = vc {
                    navigationController?.pushViewController(vc, animated: true)
                }
            } else {
                SwiftFTUtils.showSwiftPremiumPopup(on: self)
            }
        } else if (label == "settings_card_2_android_7") && indexPath.section == 1 {
            if packageId == "2" || packageId == "3" {
                let storyboardName = "MyStoryboard"
                let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
                let vc = storyboard.instantiateViewController(withIdentifier: "ClockViewController") as? ClockViewController
                if let vc = vc {
                    navigationController?.pushViewController(vc, animated: true)
                }
            } else {
                SwiftFTUtils.showSwiftPremiumPopup(on: self)
            }
        } else if (label == "settings_card_2_android_3") && indexPath.section == 1 {
           // if packageId == "2" || packageId == "3" {
                let stb = UIStoryboard(name: "Dashboard", bundle: nil)
                let vc = stb.instantiateViewController(withIdentifier: "ScheduleScreenTimeVC") as? ScheduleScreenTimeVC
                navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                if let vc = vc {
                    navigationController?.pushViewController(vc, animated: true)
                }
//            } else {
//                SwiftFTUtils.showSwiftPremiumPopup(on: self)
//            }
        } else if (label == "settings_card_2_android_1") && indexPath.section == 1 {
            let packageFeature = SwiftCommonUtility.shared.getPackageFeature(withName: "daily_limit")
            //delegate?.selectedDashboardChild.getPackageFeature(withName: "daily_limit")
            if packageFeature == nil {
                let vc = AndroidDailyLimitVC()
                navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                navigationController?.pushViewController(vc, animated: true)
            } else if packageFeature?.package_id == 1 {
                showPremiumAlert()
            } else {
                //---NEW SWIFT CONVERTED CLASS---//
                let vc = AndroidDailyLimitVC()
                navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                navigationController?.pushViewController(vc, animated: true)
            }
        } else if label == "settings_card_5_1" {
            self.synSettings()
        } else if (label == "settings_card_2_android_8") && indexPath.section == 1 {
            if packageId == "2" || packageId == "3" {
                navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                navigationController?.pushViewController(contactWListCont, animated: true)
            } else {
                SwiftFTUtils.showSwiftPremiumPopup(on: self)
            }
            //MARK: Make the following section 3 when you uncomment the code for section 2.
        } else if (label == "settings_android_content_3_sub_content_2") && indexPath.section == 2 {
            if self.package_id == "1" {
                self.showPremiumAlert()
            } else {
                let dashboardStoryboard = UIStoryboard(name: "Dashboard", bundle: nil)
                let vc = dashboardStoryboard.instantiateViewController(withIdentifier: "PasscodePopUpViewController") as? PasscodePopUpViewController ?? PasscodePopUpViewController()
                vc.color = "red"
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true, completion: nil)
            }
        } else if label == "settings_content_3_sub_content_1" {
            SwiftFTUtils.pushDeviceController(on: self)
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYOffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYOffset
        if distanceFromBottom < height {
            tableView.reloadData()
        }
    }
}
