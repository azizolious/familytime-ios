//
//  SwiftLimitScreenViewController.swift
//  FamilyTime
//
//  Created by YumyApps on 03/11/2021.
//  Copyright © 2021 YumyApps. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire

class SwiftLimitScreenViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, SwiftLimitScreenCellDelegate {
    
    let delegate = UIApplication.shared.delegate as? AppDelegate
    var dataSource = [AnyHashable]()
    var refreshControl = UIRefreshControl()
    var addButton = UIBarButtonItem()
    var ruleId = ""
    let child_Id = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
    var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "settings_card_2_android_3".localized
        view.backgroundColor = UIColor.white
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - 64), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.register(SwiftLimitScreenCell.self, forCellReuseIdentifier: "LIMIT_SCREEN_CELL")
        tableView.backgroundColor = RGBCOLOR(243, 243, 243, 1)
        
        if SwiftFTUtils.isDeviceiPhoneFamily() {
            tableView.rowHeight = 170
        } else {
            tableView.rowHeight = 170
        }
        
        tableView.separatorStyle = .none
        addButton = UIBarButtonItem(title: "add_button".localized, style: .plain, target: self, action: #selector(addRule(_:)))
        navigationItem.rightBarButtonItems = [addButton]
        
        self.addPullRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.loadRules()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        refreshControl.endRefreshing()
    }
    
    func editPlace() {
        tableView.isEditing = !tableView.isEditing
    }
    // Update the API handling logic to map the new response and convert it to the format expected by AllAccessControlRulesModel
    
    @objc func loadRules() {
        SwiftFTUtils.showHUDAdded(to: self.view, withText: "", animated: true)
        
        let url = HLConstants.BASE_URL_CORE_2 + "controls/schedules"
        CoreManager.networkRequest(url: url, method: .get) { (response: ScheduleRuleCodableModel?, statusCode, errorMessage) in
            SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
            if let errorMessage = errorMessage {
                CommonModel.showAlert("alert_error".localized, msg: errorMessage)
                return
            }
            
            guard let schedules = response?.schedules else {
                return
            }
            self.viewDidDisappear(true)
            DBManager.shared.deleteData(entityName: "Schedules")
            DBManager.shared.saveSchedule(myModelArray: schedules)
            
            let filteredSchedules = schedules.filter { $0.childID == Int(self.child_Id ?? "0") && $0.function == "schedule_screen_time" }
            self.convertCodableToClassModel(schedule: filteredSchedules)
        }
    }
    
    func convertCodableToClassModel(schedule: [Schedule]) {
        self.dataSource.removeAll()
        
        for obj in schedule {
            let rule = AccessControlRuleModel()
            rule.is_friday = obj.onFriday?.intToStr() ?? ""
            rule.is_monday = obj.onMonday?.intToStr() ?? ""
            rule.is_saturday = obj.onSaturday?.intToStr() ?? ""
            rule.is_sunday = obj.onSunday?.intToStr() ?? ""
            rule.is_tuesday = obj.onTuesday?.intToStr() ?? ""
            rule.is_wednesday = obj.onWednesday?.intToStr() ?? ""
            rule.is_thursday = obj.onThursday?.intToStr() ?? ""
            rule.child_id = obj.childID?.intToStr() ?? ""
            rule.is_active = obj.status?.intToStr() ?? ""
            rule.is_predefined = obj.isPredefined?.intToStr() ?? ""
            rule.rule_function = obj.function ?? ""
            rule.id = obj.id?.description ?? ""
            rule.rule_name = obj.name ?? ""
            rule.rule_type = obj.type ?? ""
            rule.time_end = obj.endTime ?? ""
            rule.time_start = obj.startTime ?? ""
            
            // Parse mdmPayload JSON string
            if let mdmPayloadString = obj.mdmPayload {
                // Parse the string into data
                if let data = mdmPayloadString.data(using: .utf8) {
                    do {
                        // Parse the data into a JSON object
                        if let mdmPayloadDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            rule.mdm_payload = mdmPayloadDict
                        } else {
                            print("Failed to parse mdmPayload JSON.")
                        }
                    } catch {
                        print("Error parsing mdmPayload JSON: \(error)")
                    }
                } else {
                    print("Failed to convert mdmPayload string to data.")
                }
            } else {
                print("mdmPayload is nil.")
            }

            self.dataSource.append(rule)
            print(rule)
        }
        
        self.refreshTable()
    }
    
    //    @objc func loadRules() {
    //        SwiftFTUtils.showHUDAdded(to: self.view, withText: "", animated: true)
    //        let url = HLConstants.BASE_URL_CORE_2 + "controls/schedules"
    //        CoreManager.networkRequest(url: url, method: .get) { (response: ScheduleRuleCodableModel?, statusCode, errorMessage) in
    //            SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
    //
    //            if errorMessage == nil {
    //                if let schedules = response?.schedules {
    //                    DBManager.shared.deleteData(entityName: "Schedules")
    //                    DBManager.shared.saveSchedule(myModelArray: schedules)
    //                }
    //                self.viewDidDisappear(true)
    //                let scheduleArr = response?.schedules?.filter({($0.childID == Int(self.child_Id ?? "0") && ($0.function == "schedule_screen_time"))})
    //                self.dataSource = scheduleArr ?? []
    //                print(self.dataSource)
    //                self.tableView.reloadData()
    //            } else {
    //                CommonModel.showAlert("alert_error".localized, msg: errorMessage)
    //            }
    //        }
    //    }
    
    //    @objc func loadRules() {
    //
    //        SwiftFTUtils.showHUDAdded(to: view, withText: "Loading...".myModification(), animated: true)
    //        let url = String(format: "\(kBasUrlNew_mesh2)/dashboard/settings/ios/lst/applock/rules/\(Int(Int(child_Id ?? "") ?? -1))")
    //
    //        //---NATIVE API CALLING---//
    //        ApiManager.shared().mesh_getApi(withApi: url) { json, errorCode, message in
    //
    //            DispatchQueue.main.async {
    //                print("Old Mesh api Limit Screen Time IOS json = \(json)")
    //                if (json["status"] as? NSNumber)?.intValue ?? 0 == 200 {
    //                    var rules: AllAccessControlRulesModel? = nil
    //                    do {
    //                        rules = try AllAccessControlRulesModel(dictionary: json)
    //                    } catch {
    //                    }
    //                    if let rules = rules {
    //                        print("\(rules)")
    //                    }
    //                    if let data = rules?.data as? [AnyHashable] {
    //                        self.dataSource = data
    //                    }
    //                    print(String(format: "count %lu", self.dataSource.count))
    //                    self.viewDidDisappear(true)
    //
    //                } else {
    //                    CommonModel.showAlert("alert_error".localized, msg: "alert_something_wrong".localized)//json["message"] as? String
    //                }
    //                self.refreshTable()
    //                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
    //            }
    //        }
    //    }
    
    func refreshTable() {
        refreshControl.endRefreshing()
        tableView.reloadData()
    }
    
    func addPullRefresh() {
        refreshControl = UIRefreshControl()
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(loadRules), for: .valueChanged)
    }
    
    @objc func addRule(_ sender: Any) {
        
        let controller = SwiftAddLimitScrenRule()
        controller.isNew = true
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    func didRuleStatusChanged(_ isActive: Bool, indexPath: IndexPath?) {
        guard let indexPath = indexPath,
              indexPath.row < dataSource.count,
              let rule = dataSource[indexPath.row] as? AccessControlRuleModel else {
            // Handle invalid indexPath or missing rule
            return
        }
        
        SwiftFTUtils.showHUDAdded(to: self.view, withText: "", animated: true)
        let status: String = isActive ? "1" : "0"
        let params: [String: Any] = ["data": [["child_id": rule.child_id ?? "",
                                               "id": rule.id ?? "",
                                               "status": status]]]
        
        let url = HLConstants.BASE_URL_CORE_2 + "controls/schedules"
        
        CoreManager.networkRequest(url: url, method: .patch, params: params) { [weak self] (response: EmptyResponseModel?, statusCode, errorMessage) in
            guard let self = self else { return }
            
            SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
            
            if statusCode == 204 {
                // Update the switch state in the data source
                rule.is_active = isActive ? "1" : "0"
                
                // Reload the corresponding row in the table view to update the switch UI
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
                let dashboardStoryBoard = UIStoryboard(name: "Dashboard", bundle: nil)
                let vc = dashboardStoryBoard.instantiateViewController(withIdentifier: "SyncPopUpViewController") as? SyncPopUpViewController ?? SyncPopUpViewController()
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true)
            } else {
                CommonModel.showAlert("alert_error".localized, msg: errorMessage)
            }
        }
    }

    
//    func didRuleStatusChanged(_ isActive: Bool, indexPath: IndexPath?) {
//        
//        let rule = dataSource[indexPath!.row] as? AccessControlRuleModel
//        SwiftFTUtils.showHUDAdded(to: view, withText: "Updating...".myModification(), animated: true)
//        
//        let dict = dataSource[indexPath!.row] as? AccessControlRuleModel
//        dict?.is_active = isActive ? "1" : "0"
//        if let dict = dict {
//            dataSource[indexPath!.row] = dict
//            
//        }
//        let url = String(format: "\(kBasUrlNew_mesh2)/dashboard/settings/ios/lst/applock/rule/\(Int(Int(child_Id ?? "") ?? -1))/\(rule?.id ?? "")")
//        var params: [AnyHashable : Any] = [:]
//        params["is_active"] = isActive ? "1" : "0"
//        params["type"] = "changeStatus"
//        
//        var jsonData: Data? = nil
//        do {
//            jsonData = try JSONSerialization.data(withJSONObject: params, options: [])
//        } catch {
//        }
//        var myString: String? = nil
//        if let jsonData = jsonData {
//            myString = String(data: jsonData, encoding: .utf8)
//        }
//        
//        //---NATIVE API CALLING---//
//        ApiManager.shared().mesh_patch_withJson_Api(withParamString: myString!, withApi: url) { json, errorCode, message in
//            DispatchQueue.main.async {
//                print("Patch native api with json call response = \(json)")
//                if (json["status"] as? NSNumber)?.intValue ?? 0 == 200 {
//                    print("\(json)")
//                    let dashboardStoryBoard = UIStoryboard(name: "Dashboard", bundle: nil)
//                    let vc = dashboardStoryBoard.instantiateViewController(withIdentifier: "SyncPopUpViewController") as? SyncPopUpViewController ?? SyncPopUpViewController()
//                    vc.modalPresentationStyle = .overFullScreen
//                    self.present(vc, animated: true)
//                    self.tableView.reloadData()
//                } else {
//                    CommonModel.showAlert("alert_error".myModification(), msg: "alert_something_wrong".localized)//json["message"] as? String
//                }
//                
//                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
//            }
//        }
//    }
    
    func didOptionButtonTapped(_ indexPath: IndexPath?) {
        let actionSheet = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "edit_button".localized, style: .default, handler: { [self] action in
            
            let controller = SwiftAddLimitScrenRule()
            controller.isNew = false
            let rule = dataSource[indexPath?.row ?? 0] as? AccessControlRuleModel
            controller.rule = rule ?? AccessControlRuleModel()
            print(rule?.is_saturday ?? "")
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            self.navigationController?.pushViewController(controller, animated: true)
        }))
        
        let rule = dataSource[indexPath?.row ?? 0] as? AccessControlRuleModel
        if rule?.is_predefined != "1" {
            
            actionSheet.addAction(UIAlertAction(title: "alert_delete".localized, style: .default, handler: { [self] action in
                
                self.ruleId = rule?.id ?? ""
                
                let alert = UIAlertController(title: "schedule_screen_time_delete_alert_title".localized, message: "schedule_screen_time_delete_alert_content_1".localized, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "cancel_button".localized, style: .default, handler: { action in
                    
                }))
                
                alert.addAction(UIAlertAction(title: "alert_delete".localized, style: .default, handler: { [self] action in
                    deleteApi()
                }))
                
                var source = UIView()
                if let cell = tableView.cellForRow(at: indexPath ?? IndexPath()) as? SwiftLimitScreenCell{
                    source = cell.optionButton
                }else{
                    source = self.view
                }
                if let presenter = alert.popoverPresentationController {
                    presenter.sourceView = source
                    presenter.sourceRect = source.bounds
                    presenter.permittedArrowDirections = .up
                }
                
                // Present action sheet.
                present(alert, animated: true)
            }))
        }
        
        actionSheet.addAction(UIAlertAction(title: "cancel_button".localized, style: .default, handler: { [self] action in
            // Cancel button tappped.
            dismiss(animated: true) {
            }
        }))
        
        var source = UIView()
        if let cell = tableView.cellForRow(at: indexPath ?? IndexPath()) as? SwiftLimitScreenCell{
            source = cell.optionButton
        }else{
            source = self.view
        }
        if let presenter = actionSheet.popoverPresentationController {
            presenter.sourceView = source
            presenter.sourceRect = source.bounds
            presenter.permittedArrowDirections = .up
        }
        // Present action sheet.
        self.present(actionSheet, animated: true)
    }
    
    func deleteApi() {
        //    if(buttonIndex == 0)
        //        return;
        SwiftFTUtils.showHUDAdded(to: view, withText: "", animated: true)
        let param = ["data": [["child_id": "\(child_Id ?? "")",
                               "id": "\(ruleId)"]]]
        
        guard let childId = child_Id, childId != "", ruleId != "" else {
            SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
            return
        }
        
        let url = HLConstants.BASE_URL_CORE_2 + "controls/schedules"
        CoreManager.networkRequest(url: url, method: .delete, params: param) { (response: Empty?, statusCode, errorMessage) in
            SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
            if statusCode != 204{
                CommonModel.showAlert("alert_error".localized, msg: errorMessage)
                //                self.navigationController?.popViewController(animated: true)
            }else if statusCode == 204{
                CommonModel.showAlert("".localized, msg: "internet_schedules_alert_4_content_1".localized)
                //                self.navigationController?.popViewController(animated: true)
            }else{
                CommonModel.showAlert("alert_error".localized, msg: "alert_something_wrong".localized)
                //                self.navigationController?.popViewController(animated: true)
            }
            self.loadRules()
        }
        //        SwiftFTUtils.showHUDAdded(to: view, withText: "Deleting...", animated: true)
        //        let url = String(format: "\(kBasUrlNew_mesh2)/dashboard/settings/ios/lst/applock/rule/\(Int(Int(child_Id ?? "") ?? -1))/\(ruleId)")
        //        print("\(url)")
        //        ApiManager.shared().deleteApi(withParams: [:], andUrl: url, andController: self) { message, code in
        //
        //            DispatchQueue.main.async {
        //                print("delete ios child rule native api response = \(message)")
        //                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
        //
        //                if code == 200 {
        //                    print(String(format: "\(Int(code))"))
        //                    CommonModel.showAlert("".localized, msg: "internet_schedules_alert_4_content_1".localized)
        //                   self.loadRules()
        //                } else {
        //                    CommonModel.showAlert("alert_error".localized, msg: "alert_something_wrong".localized)
        //                }
        //            }
        //        }
    }
    
    //MARK: -TableView Data Source and Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "LIMIT_SCREEN_CELL") as? SwiftLimitScreenCell
        if cell == nil {
            cell = SwiftLimitScreenCell(style: .default, reuseIdentifier: "ACCESS_CELL")
            cell?.accessoryType = .disclosureIndicator
        }
        
        if let cell = cell {
            cell.selectionStyle = .none
            guard let rule = dataSource[indexPath.row] as? AccessControlRuleModel else {
                return UITableViewCell()
            }
            cell.rule = rule
            cell.setRule(rule)
            cell.delegate = self
            cell.indexPath = indexPath
            viewDidDisappear(true)
        }
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let controller = SwiftAddLimitScrenRule()
        controller.isNew = false
        guard let rule = dataSource[indexPath.row] as? AccessControlRuleModel else {
            return
        }
        print(rule)
        controller.rule = rule
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
