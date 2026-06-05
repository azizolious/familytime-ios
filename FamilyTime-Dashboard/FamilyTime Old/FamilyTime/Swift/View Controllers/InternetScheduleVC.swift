//
//  InternetScheduleVC.swift
//  FamilyTime
//
//  Created by Sana-Ullah-IOS on 29/01/2020.
//  Copyright © 2020 YumyApps. All rights reserved.
//

import UIKit
import PopMenu

class InternetScheduleVC: UIViewController {

    @IBOutlet weak var tableVu: UITableView!
    
    var rulesArray = [InternetScheduleInnerModel]()
    let child_Id = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
    var scheduleArr = [Schedule]()
    override func viewDidLoad() {
        super.viewDidLoad()
        initialization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LiveVisitorManager.shared.updateScreen(
            "Internet Schedule"
        )
        ZendeskChatManager.trackEvent("Anroid Internet Schedule Screen")
        let childID = Int(child_Id ?? "0")
        let sched = DBManager.shared.getSchedules(identifier: "internet_schedule", childID: childID ?? 0)
        if sched.count == 0 {
        loadInternetSchedules()
        } else {
            self.convertCodableToClassModel(schedule: sched)
        }
    }
    
    
    //MARK: - CLASS METHODS
    
    func initialization()
    {
        self.navigationItem.title = "settings_card_2_android_4".localized
        navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "add_button".localized, style: .plain, target: self, action: #selector(addRule))]
        NotificationCenter.default.addObserver(self, selector: #selector(loadInternetSchedules), name: NSNotification.Name(rawValue: kRefreshRules), object: nil)
    }
    
    
    //MARK: - API CALLS
    
    @objc func loadInternetSchedules(){
        SwiftFTUtils.showHUDAdded(to: self.view, withText: "", animated: true)
        
        let url = HLConstants.BASE_URL_CORE_2 + "controls/schedules"
        CoreManager.networkRequest(url: url, method: .get) { (response: ScheduleRuleCodableModel?, statusCode, errorMessage) in
            SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
            if errorMessage == nil {
                if let schedules = response?.schedules {
                    DBManager.shared.deleteData(entityName: "Schedules")
                    DBManager.shared.saveSchedule(myModelArray: schedules)
                }
                let scheduleArr = response?.schedules?.filter({($0.childID == Int(self.child_Id ?? "0") && ($0.function == "internet_schedule"))})
                self.convertCodableToClassModel(schedule: scheduleArr ?? [])

            } else {
                CommonModel.showAlert("alert_error".localized, msg: errorMessage)
            }
        }
    }
    func convertCodableToClassModel(schedule:[Schedule]) {
        
        self.rulesArray.removeAll()
        let scheduleArr = schedule.filter({($0.childID == Int(self.child_Id ?? "0") && ($0.function == "internet_schedule"))})
        self.scheduleArr = scheduleArr
        scheduleArr.forEach({ obj in
            let rule = InternetScheduleInnerModel()
            rule.is_friday = obj.onFriday?.intToStr()
            rule.is_monday = obj.onMonday?.intToStr()
            rule.is_saturday = obj.onSaturday?.intToStr()
            rule.is_sunday = obj.onSunday?.intToStr()
            rule.is_tuesday = obj.onTuesday?.intToStr()
            rule.is_wednesday = obj.onWednesday?.intToStr()
            rule.is_thursday = obj.onThursday?.intToStr()
            rule.child_id = obj.childID?.intToStr()
            rule.is_active = obj.status?.intToStr()
            rule.is_predefined = obj.isPredefined?.intToStr()
            rule.function = obj.function
            rule.id = Int32(obj.id ?? 0)
            rule.rule_name = obj.name
            rule.rule_type = obj.type
            rule.time_end = obj.endTime
            rule.time_start = obj.startTime
            self.rulesArray.append(rule)
        })
        self.tableVu.reloadData()
    }
    func deleteRuleApiCall(index:Int){
        SwiftFTUtils.showHUDAdded(to: view, withText: "", animated: true)
        let param = ["data": [["child_id": "\(rulesArray[index].child_id ?? "")",
                               "id": "\(rulesArray[index].id)"]]]
        
        guard let childId = rulesArray[index].child_id, childId != "", rulesArray[index].id != 0 else {
            SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
            return
        }
        
        let url = HLConstants.BASE_URL_CORE_2 + "controls/schedules"
        CoreManager.networkRequest(url: url, method: .delete, params: param) { (response: EmptyResponseModel?, statusCode, errorMessage) in
            SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
            if statusCode != 204{
                CommonModel.showAlert("alert_error".localized, msg: errorMessage)
            }else if statusCode == 204{
                CommonModel.showAlert("".localized, msg: "internet_schedules_alert_4_content_1".localized)
            }else{
                CommonModel.showAlert("alert_error".localized, msg: "alert_something_wrong".localized)
            }
            DBManager.shared.deleteSchedule(schedule: self.scheduleArr[index])
            self.scheduleArr.remove(at: index)
            self.rulesArray.remove(at: index)
            self.tableVu.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
    }
    
    @objc func addRule()
    {
        pushAddRuleScreen(index: 0)
    }
    
    func updateRuleApiCall(isSwitchOn:Bool, index:Int, params:[String:Any]){
        SwiftFTUtils.showHUDAdded(to: self.view, withText: "", animated: true)
        let param = ["data": [["child_id": "\(rulesArray[index].child_id ?? "")",
                              "id": "\(rulesArray[index].id)",
                               "status": isSwitchOn.boolToInt()]]]
        let url = HLConstants.BASE_URL_CORE_2 + "controls/schedules"
        CoreManager.networkRequest(url: url, method: .patch, params: param) { (response: EmptyResponseModel?, statusCode, errorMessage) in
            SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
            if statusCode == 204{
                print("rule updated")
                self.rulesArray[index].is_active = isSwitchOn ? "1" : "0"
                self.scheduleArr[index].status = isSwitchOn ? 1 : 0
                DBManager.shared.getScheduleAndUpdate(childID: self.scheduleArr[index].childID ?? 0, identifier: self.scheduleArr[index].function ?? "", id: self.scheduleArr[index].id ?? 0, obj: self.scheduleArr[index])
                CommonModel.showAlert("settings_card_5_1".localized, msg: "schedule_screen_time_rules_alert_content_2".localized)
            }
            else{
                CommonModel.showAlert("alert_error".localized, msg: errorMessage)
            }
            self.tableVu.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }
        }
    
    func pushAddRuleScreen(index:Int, isNew:Bool = true){
        navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: .plain, target: nil, action: nil)
        
        let vc = SwiftConstants.SwiftStoryBoard.instantiateViewController(withIdentifier: "AddInternetScheduleVC") as! AddInternetScheduleVC
        if !isNew{
            vc.rule = rulesArray[index]
        }
        vc.isNew = isNew
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func deleteRule(index : Int){
        
        let alert = UIAlertController.init(title: "alert_delete".localized, message: "internet_schedules_alert_2_content_1".localized, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "cancel_button".localized, style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction.init(title: "ok_button".localized, style: .default) { (alertAction) in
            print("ok delete the rule")
            self.deleteRuleApiCall(index: index)
        })
        
        self.present(alert, animated: true)
    }
    
}



extension InternetScheduleVC : UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rulesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ScheduleScreenCell
        cell.selectionStyle = .none
        cell.setInternetSchedule(cellRule: rulesArray[indexPath.row])
        cell.switchVu.index = indexPath.row
        cell.switchVu.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        cell.delegate = self
        cell.cellIndexPath = indexPath
        cell.switchVu.addTarget(self, action: #selector(didSettingsChangedFor(switchVu:)), for: .valueChanged)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        pushAddRuleScreen(index: indexPath.row, isNew: false)
    }
    
    
    @objc func didSettingsChangedFor(switchVu:AppBlockerSwitch){
        
        rulesArray[switchVu.index].is_active = switchVu.isOn ? "1" : "0"
        
        
        let rule = rulesArray[switchVu.index]
        rule.is_active = switchVu.isOn ? "1" : "0"
        
        
        let params = SwiftParamUtility.shared.changeInternetScheduleParams(isActive: switchVu.isOn, isNewRule: false, rule: rule)
        print("params = \(params)")
        updateRuleApiCall(isSwitchOn: switchVu.isOn, index: switchVu.index, params: params)
    }
}

extension InternetScheduleVC : ScheduleScreenProtocol{
    func menuButtonPressed(at indexpath: IndexPath, menuBtn:UIButton) {
        print("name = \(String(describing: rulesArray[indexpath.row].rule_name))")
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "edit_button".localized, style: .default, handler: { action in
            
            print("Edit action")
            self.pushAddRuleScreen(index: indexpath.row, isNew: false)
            
        }))
        
        let rule = rulesArray[indexpath.row]
        if rule.rule_name != "Weekdays", rule.rule_name != "Weekends"{
            
            alert.addAction(UIAlertAction(title: "alert_delete".localized, style: .default, handler: { action in
                
                print("Delete action")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                    self.deleteRule(index: indexpath.row)
                })
                
            }))
            
        }
        
        alert.addAction(UIAlertAction(title: "cancel_button".localized, style: .default, handler: { action in
            
            
        }))
        
        if let presenter = alert.popoverPresentationController {
            presenter.sourceView = menuBtn
            presenter.sourceRect = menuBtn.bounds
            presenter.permittedArrowDirections = .up
        }
        
        present(alert, animated: true, completion: nil)
    }    
}
