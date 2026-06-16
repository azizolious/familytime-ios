//
//  AppBlockerAndroidVC.swift
//  FamilyTime
//
//  Created by Sana Ullah on 11/04/2019.
//  Copyright © 2019 YumyApps. All rights reserved.
//

import UIKit

class AppBlockerAndroidVC: UIViewController {

    @IBOutlet weak var enableLbl: UILabel!
    @IBOutlet weak var enableSwitch: UISwitch!
    @IBOutlet weak var autoLbl: UILabel!
    @IBOutlet weak var autoSwitch: UISwitch!
    @IBOutlet weak var appsLbl: UILabel!
    @IBOutlet weak var stackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var approveAppSwitch: UISwitch!
    @IBOutlet weak var approveAppLbl: UILabel!
        
    @IBOutlet weak var tableVu: UITableView!
    
    let child_Id = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
    var appBlockerStatus = 0
    var autoPlugStatus   = 0
    var approvePlusStatus   = 0
    var refreshControl: UIRefreshControl?
    var control = Control()
    var apps = [InstalledApp]()
    var changedAps = [InstalledApp]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LiveVisitorManager.shared.updateScreen(
            "App Blocker"
        )
        
        enableSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        autoSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        approveAppSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        initialization()
        let objects = DBManager.shared.fetchDataAndConvertToModels()
        let objs = objects.sorted(by: {$0.appsTime?.getDateFromStr() ?? Date() > $1.appsTime?.getDateFromStr() ?? Date.tomorrow})
        apps = objs
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        ZendeskChatManager.trackEvent("Anroid App Blocker Screen")
        control = DBManager.shared.fetchAppBlockControl(identifier: "app_blocker")
        setToggles()
        edgesForExtendedLayout = []
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        refreshControl?.endRefreshing()
    }
    
    //MARK: - CLASS METHODS
    func setToggles() {
        let status = control.getAppBlockerValue()
        autoSwitch.isOn = status.0.boolValue
        autoPlugStatus = status.0
        approveAppSwitch.setOn(status.1.boolValue, animated: true)
        approvePlusStatus = status.1
        enableSwitch.setOn(control.state?.boolValue ?? false, animated: true)
        autoSwitch.isEnabled = control.state?.boolValue ?? false
        approveAppSwitch.isEnabled = control.state?.boolValue ?? false
    }
    func initialization(){
        multiLingual()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(handleSave))
    }

    
    func multiLingual(){
        self.navigationItem.title = "settings_card_2_android_2".localized
        enableLbl.text = "app_blocker_switch_1".localized
        autoLbl.text   = "app_blocker_switch_2".localized
        approveAppLbl.text = "app_blocker_switch_3".localized
        appsLbl.text   = "settings_card_1_android_5".localized.uppercased()
    }
    
    @objc func handleSave() {
        if control.identifier == nil {
            HLApiManager.getControlApi()
            return
        }
        SwiftFTUtils.showHUDAdded(to: self.view, withText: "", animated: true)
        HLApiManager.putControlAppBlocker(childId: control.childID ?? 0, featureId: control.featureID ?? 0, state: enableSwitch.isOn.boolToInt(), identifier: control.identifier ?? "", blockSt: autoSwitch.isOn.boolToInt(), appSt: approveAppSwitch.isOn.boolToInt()) {  succ, err in
            //
            if err != nil {
                SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
                CommonModel.showAlert("alert_error".localized, msg: err ?? "Nothing")
                return
            }
            
            let dataValue = [
                ["identifier": "block_new_apps", "status": self.autoSwitch.isOn.boolToInt()],
                ["identifier": "approve_new_app", "status": self.approveAppSwitch.isOn.boolToInt()]
            ]
            if let jsonData = try? JSONSerialization.data(withJSONObject: dataValue, options: []),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                print(jsonString)
                DBManager.shared.fetchControlAndUpdate(identifier: "app_blocker", state: self.enableSwitch.isOn.boolToInt(), value: jsonString)
            } else {
                print("Failed to create JSON string.")
            }
            print("hitted")
            if self.changedAps.count != 0{
                var ids = [[String:Any]]()
                for obj in self.changedAps {
                    let param = ["app_package_name": obj.appPackageName ?? "",
                                 "blocked":obj.isBlacklisted ?? 0,
                                 "child_id":obj.childID ?? 0]
                    ids.append(param as [String : Any])
                }
                let params = ["apps": ids]
                let url = HLConstants.BASE_URL_CORE_2 + "controls/app-blocker"
                CoreManager.networkRequest(url: url, method: .post, params: params) { (response: EmptyResponseModel?, statusCode, msg) in
                    SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
                    if statusCode == 204{
                        self.changedAps.forEach { app in
                            DBManager.shared.fetchModelAndUpdate(obj: app)
                        }
                        self.navigationController?.popViewController(animated: true)
//                        CommonModel.showAlert("alert_title".localized, msg: "app_blocker_alert_content_1".localized)
                    } else {
                        CommonModel.showAlert("alert_error".localized, msg: msg)
                    }
                }
            }else {
                SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    func refreshTable(){
        refreshControl?.endRefreshing()
        tableVu.reloadData()
    }
  
    func DeviceNotEnrolledPopUp(){
        SwiftFTUtils.showActivate(forDeviceNotEnrolled: self)
    }
    
    
    //MARK: - UI ACTIONS
    
    @IBAction func enableSwitchAction(_ sender: UISwitch) {
        appBlockerStatus = sender.isOn ? 1 : 0
        autoSwitch.isEnabled = sender.isOn
        approveAppSwitch.isEnabled = sender.isOn
        tableVu.reloadData()
    }
    
    @IBAction func autoSwitchAction(_ sender: UISwitch) {
        autoPlugStatus = sender.isOn ? 1 : 0
        if approvePlusStatus == 1{
            approveAppSwitch.isOn = false
            approvePlusStatus = 0
        }else{
            if autoPlugStatus == 0{
                autoSwitch.isOn = false
                print(approvePlusStatus, autoPlugStatus)
                if approvePlusStatus == 0{
                    approvePlusStatus = 0
                }else{
                    approvePlusStatus = 1
                }
                
            }else{
                autoSwitch.isOn = true
                approvePlusStatus = 0
            }
        }
    }
    
    @IBAction func approveAppSwitch(_ sender: UISwitch) {
        approvePlusStatus = sender.isOn ? 1 : 0
        if autoPlugStatus == 1{
            autoSwitch.isOn = false
            autoPlugStatus = 0
        }else{
            if approvePlusStatus == 0{
                approveAppSwitch.isOn = false
                if autoPlugStatus == 0{
                    autoPlugStatus = 0
                }else{
                    autoPlugStatus = 1
                }
                
            }else{
                approveAppSwitch.isOn = true
                autoPlugStatus = 0
            }
        }
    }
}

extension AppBlockerAndroidVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        let nameLbl  = cell?.contentView.viewWithTag(1) as! UILabel
        let switchVu = cell?.contentView.viewWithTag(2) as! AppBlockerSwitch

        let app = self.apps[indexPath.row]
        nameLbl.text = app.appName
        switchVu.setOn(app.isBlacklisted == 0 ? false : true, animated: true)
        switchVu.index = indexPath.row
        switchVu.isEnabled = enableSwitch.isOn
        switchVu.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        switchVu.addTarget(self, action: #selector(didSettingsChangedFor(switchVu:)), for: .valueChanged)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func didSettingsChangedFor(switchVu:AppBlockerSwitch){
        var app = apps[switchVu.index]
        app.isBlacklisted = switchVu.isOn.boolToInt()
        if let ind = changedAps.firstIndex(where: {$0.installedappID == app.installedappID}) {
            changedAps[ind].isBlacklisted = switchVu.isOn.boolToInt()
        } else {
            changedAps.append(app)
        }

        // Update the apps array to reflect the change
        apps[switchVu.index] = app
    }
}

class AppBlockerSwitch : UISwitch {
    
    var index : Int = 0
    
    convenience init(index: Int) {
        self.init()
        self.index = index
    }
}
