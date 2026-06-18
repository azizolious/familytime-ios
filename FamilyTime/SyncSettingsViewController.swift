//
//  SyncSettingsViewController.swift
//  FamilyTime
//
//  Created by Sufyan on 17/04/2024.
//  Copyright © 2024 YumyApps. All rights reserved.
//

import UIKit
import MBProgressHUD
import Motis

class SyncSettingsViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, SyncSettingsCellDelegate, UIAlertViewDelegate {
    var tableView: UITableView!
    //    var dataSource: [SyncSettingModel] = []
    var dataSource: [String: Bool] = [:]
    var dataSourceBlock1: [String: Bool] = [:]
    var dataSourceBlock2: [String: Bool] = [:]
    var dataSourceBlock3: [String: Bool] = [:]
    var settings: IOSAppBlockerModel?
    var headerLabel: UILabel!
    var headerSwitch: UISwitch!
    var refreshControl: UIRefreshControl!
    var control = Control()
    let child_Id = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
    var settingsChanged: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "settings_card_2_android_2".myModification()
        self.view.backgroundColor = UIColor.groupTableViewBackground
        delegate = AppDelegate()
        tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        tableView.register(SyncSettingsCell.self, forCellReuseIdentifier: "SETTINGS_CELL")
        
        if SwiftFTUtils.isDeviceiPhoneFamily() {
            tableView.rowHeight = 60
        } else {
            tableView.rowHeight = 75
        }
        tableView.separatorStyle = .none
        let headerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.view.bounds.width, height: 80.0))
        headerView.backgroundColor = RGBCOLOR(22, 151, 191, 1)
        let separatorView = UIView(frame: CGRect(x: 0.0, y: 60.0, width: headerView.bounds.width, height: 20.0))
        separatorView.backgroundColor = UIColor.groupTableViewBackground
        
        var leftMargin: CGFloat = 100
        if IS_IPHONE_4() || IS_IPHONE_5() || IS_IPHONE_6() || IS_IPHONE_6_PLUS() || IS_IPHONE_X() {
            leftMargin = 65
        }
         if UIApplication.shared.userInterfaceLayoutDirection == .leftToRight {
            headerLabel = UILabel(frame: CGRect(x: 15.0, y: 0.0, width: headerView.bounds.width - 100.0, height: headerView.bounds.height - 20.0))
            headerLabel.textAlignment = .left
            if UIScreen.main.nativeBounds.size.height == 2688 {
                headerSwitch = UISwitch(frame: CGRect(x: headerView.bounds.maxX - leftMargin + 30, y: headerView.bounds.midY - 25.5, width: 51, height: 31))
            } else if UIScreen.main.nativeBounds.size.height == 2436 {
                headerSwitch = UISwitch(frame: CGRect(x: headerView.bounds.maxX - leftMargin + 5, y: headerView.bounds.midY - 25.5, width: 51, height: 31))
            } else {
                headerSwitch = UISwitch(frame: CGRect(x: headerView.bounds.maxX - leftMargin, y: headerView.bounds.midY - 25.5, width: 51, height: 31))
            }
        } else {
            headerLabel = UILabel(frame: CGRect(x: 71.0, y: 0.0, width: headerView.bounds.width - 100.0, height: headerView.bounds.height - 20.0))
            headerLabel.textAlignment = .right
            headerSwitch = UISwitch(frame: CGRect(x: 15.0, y: headerView.bounds.midY - 25.5, width: 51, height: 31))
        }
        headerLabel.backgroundColor = UIColor.clear
        headerLabel.textColor = UIColor.white
        headerLabel.font = UIFont(name: "OpenSans", size: 17)
        headerLabel.text = "app_blocker_switch_1".myModification()
        headerView.addSubview(headerLabel)
        headerView.addSubview(separatorView)
        
        headerSwitch.addTarget(self, action: #selector(handleHeaderSwitch(_:)), for: .valueChanged)
        headerSwitch.onTintColor = RGBCOLOR(24, 167, 225, 1)
        headerView.addSubview(headerSwitch)
        tableView.tableHeaderView = headerView
        addPullRefresh()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        control = DBManager.shared.fetchAppBlockControl(identifier: "app_blocker")
        let childMdmHash = UserDefaults.standard.string(forKey: "CHILD_MDM_HASH")
//        if let childMdmHash = childMdmHash {
            loadSettings()
            
//        } else {
//            let alertView = UIAlertView(title: "", message: "alert_device_not_enrolled".myModification(), delegate: self, cancelButtonTitle: "ok_button".myModification(), otherButtonTitles: "")
//            alertView.show()
//        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(handleSave(_:)))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        refreshControl.endRefreshing()
    }
    
    func addPullRefresh() {
        refreshControl = UIRefreshControl()
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(loadSettings), for: .valueChanged)
    }
    
    func refreshTable() {
        refreshControl.endRefreshing()
        tableView.reloadData()
    }
    @objc func loadSettings() {
        SwiftFTUtils.showHUDAdded(to: self.view, withText: "Loading...", animated: true)
        
        guard let selectedChildId = UserDefaults.standard.string(forKey: "selectedChildId") else { return }
        let url = HLConstants.BASE_URL_CORE_2 + "controls/app-blocker"
        CoreManager.networkRequest(url: url, method: .get, params: nil) { [weak self] (response: AppBlockerResponse?, statusCode, message) in
            DispatchQueue.main.async {
                SwiftFTUtils.hideHUDAdded(to: self?.view, animated: true)
                self?.viewDidDisappear(true)
                
                if statusCode == 200 {
                    guard let model = response else {
                        CommonModel.showAlert("alert_error".myModification(), msg: "alert_something_wrong".myModification())
                        return
                    }
                    
                    if let appBlocker = model.appBlockers?.first(where: { $0.childID == Int(selectedChildId) }) {
                        if let mdmPayloadData = appBlocker.mdmPayload?.data(using: .utf8),
                           let mdmPayload = try? JSONSerialization.jsonObject(with: mdmPayloadData) as? [String: Bool] {
                            print(mdmPayload)
                            // Reversing the values in the mdmPayload dictionary
                            var reversedPayload: [String: Bool] = [:]
                            for (key, value) in mdmPayload {
                                reversedPayload[key] = !value
                            }

                            // Now, reversedPayload contains the reversed values
                            print(reversedPayload)

                            self?.populateTableView(with: reversedPayload)
                            //                            self.settings = mdmPayload
                            if let safariEnabled = mdmPayload["safari"] {
                                print("Safari is enabled: \(safariEnabled)")
                            }
                        }
                    } else {
                        print("Selected child ID not found in the response.")
                    }
//                    let status = self?.control.getAppBlockerValue()
                    self?.headerSwitch.setOn(self?.control.state?.boolValue ?? false, animated: true)
                    self?.control.state?.boolValue == true ? self?.enableChildSwitches() : self?.disableChildSwitches()
                    self?.refreshTable()
                } else {
                    CommonModel.showAlert("alert_error".myModification(), msg: "alert_something_wrong".myModification())
                }
            }
        }
    }
    
    @objc func handleSave(_ sender: Any?) {
        guard let selectedChildId = UserDefaults.standard.string(forKey: "selectedChildId") else { return }
        if headerSwitch.isOn != control.state?.boolValue {
            SwiftFTUtils.showHUDAdded(to: self.view, withText: "", animated: true)
            
            if let childId = control.childID,
               let featureId = control.featureID,
               let identifier = control.identifier {
                
                HLApiManager.putControlApi(childId: childId,
                                           featureId: featureId,
                                           state: headerSwitch.isOn ? 1 : 0, identifier: identifier) {err in
                    DBManager.shared.fetchControlAndUpdate(identifier: self.control.identifier ?? "", state: self.headerSwitch.isOn.boolToInt())
                    SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
                    if err != nil {
                        SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
                        CommonModel.showAlert("alert_error".localized, msg: err ?? "Nothing")
                        return
                    }
                    
                }
            } else {
                SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
                CommonModel.showAlert("alert_error".localized, msg: "alert_something_wrong_again")
                print("❌ Missing required params (childId / featureId / identifier)")
            }
        }
//        guard settingsHaveChanged() else {
//            navigationController?.popViewController(animated: true)
//            return
//        }
        let payload = buildPayload(forChildId: selectedChildId)
        guard let appEntry = payload["apps"] as? [[String: Any]], !appEntry.isEmpty else {
            return
        }
        SwiftFTUtils.showHUDAdded(to: self.view, withText: "", animated: true)
        let url = HLConstants.BASE_URL_CORE_2 + "controls/app-blocker"
        CoreManager.networkRequest(url: url, method: .post, params: payload) { [weak self] (response: EmptyResponseModel?, statusCode, msg) in
            DispatchQueue.main.async {
                SwiftFTUtils.hideHUDAdded(to: self?.view, animated: true)
                if statusCode == 204 {
//                    CommonModel.showAlert("alert_title".localized, msg: "app_blocker_alert_content_1".localized)
                    self?.settingsChanged = false
                    self?.navigationController?.popViewController(animated: true)
                } else {
                    CommonModel.showAlert("alert_error".localized, msg: msg)
                }
            }
        }
    }
    func settingsHaveChanged() -> Bool {
        return settingsChanged
    }
    
    func populateTableView(with mdmPayload: [String: Bool]?) {
        guard let mdmPayload = mdmPayload else {
            print("MDM payload is nil.")
            dataSourceBlock1.removeAll()
            dataSourceBlock2.removeAll()
            dataSourceBlock3.removeAll()
            tableView.reloadData()
            return
        }
        let desiredOrder = ["safari", "camera", "siri", "itunesStore", "installingApps", "inappPurchases", "externalApps"]
        for key in desiredOrder {
            switch key {
            case "safari", "camera", "siri":
                dataSourceBlock1[key] = mdmPayload[key]
            case "itunesStore", "installingApps", "inappPurchases":
                dataSourceBlock2[key] = mdmPayload[key]
            case "externalApps":
                dataSourceBlock3[key] = mdmPayload[key]
            default:
                break
            }
        }
        
        tableView.reloadData()
    }
    
    func buildPayload(forChildId childId: String) -> [String: Any] {
        var payload: [String: Any] = [:]
        var appsArray: [[String: Any]] = []
        
        // Convert the dictionary containing settings into a JSON string
        let settingsJSONString = "{\"safari\":\(!(dataSourceBlock1["safari"] ?? false)),\"camera\":\(!(dataSourceBlock1["camera"] ?? false)),\"siri\":\(!(dataSourceBlock1["siri"] ?? false)),\"itunesStore\":\(!(dataSourceBlock2["itunesStore"] ?? false)),\"installingApps\":\(!(dataSourceBlock2["installingApps"] ?? false)),\"inappPurchases\":\(!(dataSourceBlock2["inappPurchases"] ?? false)),\"externalApps\":\(!(dataSourceBlock3["externalApps"] ?? false))}"
        
        // Construct the app entry with the child ID and JSON string settings
        let appEntry: [String: Any] = ["child_id": childId, "mdm_payload": settingsJSONString]
        
        // Append the app entry to the apps array
        appsArray.append(appEntry)
        
        payload["apps"] = appsArray
        return payload
    }
    
    
    
    func didSettingsChanged(isActive: Bool, indexPath: IndexPath) {
        guard tableView.cellForRow(at: indexPath) is SyncSettingsCell else {
            return
        }
        let key: String
        switch indexPath.section {
        case 0:
            key = Array(dataSourceBlock1.keys)[indexPath.row]
            dataSourceBlock1[key] = isActive
        case 1:
            key = Array(dataSourceBlock2.keys)[indexPath.row]
            dataSourceBlock2[key] = isActive
        case 2:
            key = Array(dataSourceBlock3.keys)[indexPath.row]
            dataSourceBlock3[key] = isActive
        default:
            return
        }
        dataSource[key] = isActive
        settingsChanged = true
    }
    @objc func handleHeaderSwitch(_ sender: UISwitch) {
        print("Main switch toggled: \(sender.isOn)")
        //        updateAppBlockerStatus(on: sender.isOn)
        if sender.isOn {
            enableChildSwitches()
        } else {
            disableChildSwitches()
        }
    }
    
    func enableChildSwitches() {
        for indexPath in tableView.indexPathsForVisibleRows ?? [] {
            if let cell = tableView.cellForRow(at: indexPath) as? SyncSettingsCell {
                cell.switchView.isEnabled = true
            }
        }
    }
    
    func disableChildSwitches() {
        for indexPath in tableView.indexPathsForVisibleRows ?? [] {
            if let cell = tableView.cellForRow(at: indexPath) as? SyncSettingsCell {
                cell.switchView.isEnabled = false
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print("Number of sections called")
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the count of items in each block for respective sections
        switch section {
        case 0:
            return dataSourceBlock1.count
        case 1:
            return dataSourceBlock2.count
        case 2:
            return dataSourceBlock3.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SETTINGS_CELL", for: indexPath) as! SyncSettingsCell
        
        // Configure cell based on the section and indexPath
        switch indexPath.section {
        case 0:
            let key = Array(dataSourceBlock1.keys)[indexPath.row]
            let value = dataSourceBlock1[key] ?? false
            cell.setModel(appName: key, permission: value)
        case 1:
            let key = Array(dataSourceBlock2.keys)[indexPath.row]
            let value = dataSourceBlock2[key] ?? false
            cell.setModel(appName: key, permission: value)
        case 2:
            let key = Array(dataSourceBlock3.keys)[indexPath.row]
            let value = dataSourceBlock3[key] ?? false
            cell.setModel(appName: key, permission: value)
        default:
            break
        }
        
        cell.delegate = self
        cell.indexPath = indexPath
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SwiftFTUtils.isDeviceiPhoneFamily() ? 60.0 : 90.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    // MARK: - UIAlertViewDelegate
    func alertView(_ alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        self.navigationController?.popViewController(animated: true)
    }
}

struct AppBlockerResponse: Codable {
    let appBlockers: [AppBlocker]?
    
    enum CodingKeys: String, CodingKey {
        case appBlockers = "app_blockers"
    }
}

// MARK: - AppBlocker
struct AppBlocker: Codable {
    let childID: Int?
    let mdmPayload: String?
    
    enum CodingKeys: String, CodingKey {
        case childID = "child_id"
        case mdmPayload = "mdm_payload"
    }
}

//        @objc func loadSettings() {
//            SwiftFTUtils.showHUDAdded(to: self.view, withText: "Loading...", animated: true)
//
//            guard let selectedChildId = UserDefaults.standard.string(forKey: "selectedChildId") else { return }
//            let url = "\(kIOSAppBlocker_mesh2)\(selectedChildId)"
//            print("id", url)
//
//            ApiManager.shared().getIOSAppBlockerApi(withVC: self, andUrl: url) { [weak self] model, message, statusCode in
//                DispatchQueue.main.async {
//                    SwiftFTUtils.hideHUDAdded(to: self?.view, animated: true)
//                    self?.viewDidDisappear(true)
//                    if statusCode == 1 {
//                        CommonModel.showAlert("alert_error".myModification(), msg: "alert_something_wrong".myModification())
//                    } else if model.status == 200 {
//                        self?.settings = model
//                        print(self?.settings ?? "")
//                        self?.refreshTable()
//                        self?.headerSwitch.setOn(self?.settings?.data.feature_status == 1, animated: true)
//                        if let featureStatus = self?.settings?.data.feature_status {
//                            featureStatus == 1 ? self?.enableChildSwitches() : self?.disableChildSwitches()
//                        }
//                    } else {
//                        CommonModel.showAlert("alert_error".myModification(), msg: "alert_something_wrong".myModification())
//                    }
//                }
//            }
//        }


//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "SETTINGS_CELL", for: indexPath) as! SyncSettingsCell
//        if let model = model(for: indexPath) {
//            cell.setModel(model)
//            cell.delegate = self
//            cell.indexPath = indexPath
//            cell.setFeatureStatus((settings?.data.feature_status) != nil)
//        }
//        return cell
//    }
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 3
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        switch section {
//        case 0:
//            return settings?.data.apps.block1.count ?? 0
//        case 1:
//            return settings?.data.apps.block2.count ?? 0
//        case 2:
//            return settings?.data.apps.block3.count ?? 0
//        default:
//            return 0
//        }
//    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        guard let model = model(for: indexPath) else { return 0 }
//        return SwiftFTUtils.isDeviceiPhoneFamily() ? (model.app_status == 2 ? 0.0 : 60.0) : (model.app_status == 2 ? 0.0 : 90.0)
//    }
//@objc func handleSave(_ sender: Any?) {
//    if let settings = settings {
//        for appModel in settings.data.apps.block1 {
//            if let syncModel = appModel as? SyncSettingModel {
//                updateStatus(syncModel)
//            }
//        }
//        for appModel in settings.data.apps.block2 {
//            if let syncModel = appModel as? SyncSettingModel {
//                updateStatus(syncModel)
//            }
//        }
//        for appModel in settings.data.apps.block3 {
//            if let syncModel = appModel as? SyncSettingModel {
//                updateStatus(syncModel)
//            }
//        }
//    }
//
//    updateAppBlockerStatus(on: headerSwitch.isOn)
//
//}


//func updateStatus(_ model: SyncSettingModel) {
//    SwiftFTUtils.showHUDAdded(to: self.view, withText: "Loading...", animated: true)
//    let params: [String: Any] = ["app_name": model.app_name, "app_status": model.app_status]
//    print(params)
//    guard let childID = UserDefaults.standard.string(forKey: "selectedChildId") else { return }
//    let url = "\(kIOSAppBlocker_mesh2)\(childID)"
//    ApiManager.shared().putApi(url, params: params, controller: self, isContPresented: false) { [weak self] msg, code in
//        DispatchQueue.main.async {
//            SwiftFTUtils.hideHUDAdded(to: self?.view, animated: true)
//            if code == 200 {
//                let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
//                if let controller = storyboard.instantiateViewController(withIdentifier: "SyncPopUpViewController") as? SyncPopUpViewController {
//                    controller.modalPresentationStyle = .overFullScreen
//                    self?.present(controller, animated: true, completion: nil)
//                }
//            } else {
//                CommonModel.showAlert("alert_error".myModification(), msg: self?.settings?.message ?? "")
//            }
//        }
//    }
//}
//
//func updateAppBlockerStatus(on: Bool) {
//    settings?.data.feature_status = on ? 1 : 0
//    SwiftFTUtils.showHUDAdded(to: self.view, withText: "Loading...", animated: true)
//    let params: [String: Any] = ["feature_status": on ? 1 : 0]
//    guard let childID = UserDefaults.standard.string(forKey: "selectedChildId") else { return }
//    let url = "\(kIOSAppBlocker_mesh2)\(childID)"
//    ApiManager.shared().putApi(url, params: params, controller: self, isContPresented: false) { [weak self] msg, code in
//        DispatchQueue.main.async {
//            SwiftFTUtils.hideHUDAdded(to: self?.view, animated: true)
//            self?.viewDidDisappear(true)
//            if code == 200 {
//                let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
//                if let controller = storyboard.instantiateViewController(withIdentifier: "SyncPopUpViewController") as? SyncPopUpViewController {
//                    controller.modalPresentationStyle = .overFullScreen
//                    self?.present(controller, animated: true, completion: nil)
//                    self?.refreshTable()
//                    self?.navigationController?.popViewController(animated: true)
//                }
//            } else {
//                CommonModel.showAlert("alert_error".myModification(), msg: self?.settings?.message ?? "")
//            }
//            if !on {
//                for indexPath in self?.tableView.indexPathsForVisibleRows ?? [] {
//                    if let cell = self?.tableView.cellForRow(at: indexPath) as? SyncSettingsCell {
//                        cell.switchView.isEnabled = false
//                    }
//                }
//            }
//        }
//    }
//}

//    func didSettingsChanged(isActive: Bool, indexPath: IndexPath) {
//        guard let model = model(for: indexPath) else { return }
//        model.app_status = isActive ? 1 : 0
//        if indexPath.section == 0 {
//            settings?.data.apps.block1[indexPath.row] = model
//        } else if indexPath.section == 1 {
//            settings?.data.apps.block2[indexPath.row] = model
//        } else if indexPath.section == 2 {
//            settings?.data.apps.block3[indexPath.row] = model
//        }
//    }
//func model(for indexPath: IndexPath) -> SyncSettingModel? {
//    switch indexPath.section {
//    case 0:
//        return settings?.data.apps.block1[indexPath.row] as? SyncSettingModel
//    case 1:
//        return settings?.data.apps.block2[indexPath.row] as? SyncSettingModel
//    case 2:
//        return settings?.data.apps.block3[indexPath.row] as? SyncSettingModel
//    default:
//        return nil
//    }
//}
