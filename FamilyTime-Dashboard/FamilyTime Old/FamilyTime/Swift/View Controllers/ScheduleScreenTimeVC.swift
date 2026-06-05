//
//  ScheduleScreenTimeVC.swift
//  FamilyTime
//
//  Created by Sana Ullah on 19/04/2019.
//  Copyright © 2019 YumyApps. All rights reserved.
//

import UIKit
import PopMenu

class ScheduleScreenTimeVC: UIViewController {
    
    @IBOutlet weak var tableVu: UITableView!
    
    var isCountBased = false
    var countLimit   = 0
    let child_Id = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
    var rulesArray = [Schedule]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LiveVisitorManager.shared.updateScreen(
            "Screen Time Schedule"
        )
        initialization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ZendeskChatManager.trackEvent("Anroid App Blocker Screen")
        
        let packageFeature = SwiftCommonUtility.shared.getPackageFeature(withName: "access_control")
        isCountBased = packageFeature?.is_count_based == 0 ? false : true
        countLimit   = Int(packageFeature?.count_limit ?? "0") ?? 0
        let childID = Int(child_Id ?? "0")
        let sched = DBManager.shared.getSchedules(identifier: "schedule_screen_time", childID: childID ?? 0)
        if sched.count == 0 {
            loadRules()
        }else {
            self.rulesArray = sched
            self.tableVu.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    //MARK: - CLASS METHODS
    func initialization() {
        self.navigationItem.title = "settings_card_2_android_3".localized
        navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "add_button".localized, style: .plain, target: self, action: #selector(addRule))]
        NotificationCenter.default.addObserver(self, selector: #selector(loadRules), name: NSNotification.Name(rawValue: kRefreshRules), object: nil)
    }
    
    //MARK: - API CALLS
    @objc func loadRules() {
        SwiftFTUtils.showHUDAdded(to: self.view, withText: "", animated: true)
        let url = HLConstants.BASE_URL_CORE_2 + "controls/schedules"
        CoreManager.networkRequest(url: url, method: .get) { (response: ScheduleRuleCodableModel?, statusCode, errorMessage) in
            SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
            if errorMessage == nil {
                if let schedules = response?.schedules {
                    DBManager.shared.deleteData(entityName: "Schedules")
                    DBManager.shared.saveSchedule(myModelArray: schedules)
                }
                let scheduleArr = response?.schedules?.filter({($0.childID == Int(self.child_Id ?? "0") && ($0.function == "schedule_screen_time"))})
                self.rulesArray = scheduleArr ?? []
                self.tableVu.reloadData()
            } else {
                CommonModel.showAlert("alert_error".localized, msg: errorMessage)
            }
        }
    }
    
    func deleteRuleApiCall(index:Int){
        SwiftFTUtils.showHUDAdded(to: view, withText: "", animated: true)
        let param = ["data": [["child_id": "\(rulesArray[index].childID ?? 0)",
                              "id": "\(rulesArray[index].id ?? 0)"]]]
        
        guard let childId = rulesArray[index].childID, childId != 0, rulesArray[index].id != 0 else {
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
            DBManager.shared.deleteSchedule(schedule: self.rulesArray[index])
            self.rulesArray.remove(at: index)
            self.tableVu.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
    }
    
    @objc func addRule() {
        if isCountBased && countLimit >= rulesArray.count{
            SwiftFTUtils.showSwiftPremiumPopup(on: self)
            return
        }
        pushAddRuleScreen(index: 0)
    }
    
    func updateRuleApiCall(isSwitchOn:Bool, index:Int){
        SwiftFTUtils.showHUDAdded(to: self.view, withText: "", animated: true)
        let param = ["data": [["child_id": "\(rulesArray[index].childID ?? 0)",
                               "id": "\(rulesArray[index].id ?? 0)",
                               "status": isSwitchOn.boolToInt()]]]
//                let URL = SwiftAPIConstants.kGetRules_mesh2 + "\(String(describing: child_Id ?? "0"))"
        //        print("url = \(URL)")
        let url = HLConstants.BASE_URL_CORE_2 + "controls/schedules"
        CoreManager.networkRequest(url: url, method: .patch, params: param) { (response: EmptyResponseModel?, statusCode, errorMessage) in
            SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
            if statusCode == 204{
                print("rule updated")
                self.rulesArray[index].status = isSwitchOn ? 1 : 0
                DBManager.shared.getScheduleAndUpdate(childID: self.rulesArray[index].childID ?? 0, identifier: self.rulesArray[index].function ?? "", id: self.rulesArray[index].id ?? 0, obj: self.rulesArray[index])
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
        
        let vc = SwiftAddLimitScreenRuleAndroid()
        if !isNew{
            
            let obj = rulesArray[index]
            let rule = RuleModel()
            rule.on_friday = obj.onFriday?.intToStr()
            rule.on_monday = obj.onMonday?.intToStr()
            rule.on_saturday = obj.onSaturday?.intToStr()
            rule.on_sunday = obj.onSunday?.intToStr()
            rule.on_tuesday = obj.onTuesday?.intToStr()
            rule.on_wednesday = obj.onWednesday?.intToStr()
            rule.on_thursday = obj.onThursday?.intToStr()
            rule.child_id = obj.childID?.intToStr()
            rule.is_active = obj.status?.intToStr()
            rule.is_predefined = obj.isPredefined?.intToStr()
            rule.rule_function = obj.function
            rule.rule_id = obj.id?.intToStr()
            rule.rule_name = obj.name
            rule.rule_type = obj.type
            rule.time_end = obj.endTime
            rule.time_start = obj.startTime
            vc.rule = rule
        }else{
            vc.rule = RuleModel()
        }
        vc.isNew = isNew
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func deleteRule(index : Int){
        
        let alert = UIAlertController.init(title: "schedule_screen_time_delete_alert_title".localized, message: "schedule_screen_time_delete_alert_content_1".localized, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "cancel_button".localized, style: .default, handler: nil))
        
        alert.addAction(UIAlertAction.init(title: "ok_button".localized, style: .default) { (alertAction) in
            print("ok delete the rule")
            self.deleteRuleApiCall(index: index)
        })
        self.present(alert, animated: true)
    }
}

extension ScheduleScreenTimeVC : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rulesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ScheduleScreenCell
        cell.selectionStyle = .none
        cell.setRule(cellRule: rulesArray[indexPath.row])
        cell.switchVu.index = indexPath.row
        cell.switchVu.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        cell.delegate = self
        cell.cellIndexPath = indexPath
        cell.switchVu.addTarget(self, action: #selector(didSettingsChangedFor(switchVu:)), for: .valueChanged)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        pushAddRuleScreen(index: indexPath.row, isNew: false)
    }
    
    @objc func didSettingsChangedFor(switchVu:AppBlockerSwitch){
        
        if switchVu.isOn {
//            let child_Data_Obj = CoreDataUtility.fetchHomeApiResponseFromDatabase(childId: child_Id ?? "")
//            print(child_Data_Obj)
            let pref2 = CoreDataUtility.fetchPreferenceFromDatabase(child_id: child_Id ?? "")
            print(pref2)
            for v in pref2{
                if v.name == "phonelock_pin"{
                    if v.value == nil || v.status == 0{
                        CommonModel.lockPhonePopup(self)
                        let indexPath = IndexPath(row: switchVu.index, section: 0)
                        let cell = tableVu.cellForRow(at: indexPath) as! ScheduleScreenCell
                        cell.switchVu.setOn(false, animated: true)
                        return
                    }
                }
            }
        }
        rulesArray[switchVu.index].status = switchVu.isOn ? 1 : 0
        var rule = rulesArray[switchVu.index]
        rule.status = switchVu.isOn ? 1 : 0
        updateRuleApiCall(isSwitchOn: switchVu.isOn, index: switchVu.index)
    }
}

extension ScheduleScreenTimeVC : ScheduleScreenProtocol{
    func menuButtonPressed(at indexpath: IndexPath, menuBtn:UIButton) {
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "edit_button".localized, style: .default, handler: { action in
            print("Edit action")
            self.pushAddRuleScreen(index: indexpath.row, isNew: false)
        }))
        
        let rule = rulesArray[indexpath.row]
        if rule.isPredefined != 1 {
            alert.addAction(UIAlertAction(title: "alert_delete".localized, style: .default, handler: { action in
                print("Delete action")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                    self.deleteRule(index: indexpath.row)
                })
            }))
        }
        
        alert.addAction(UIAlertAction(title: "cancel_button".localized, style: .default, handler: { action in
            print("Cancel action")
        }))
        
        if let presenter = alert.popoverPresentationController {
            presenter.sourceView = menuBtn
            presenter.sourceRect = menuBtn.bounds
            presenter.permittedArrowDirections = .up
        }
        self.present(alert, animated: true, completion: nil)
    }
}

struct ScheduleRuleCodableModel: Codable {
    var schedules: [Schedule]?
}
struct ScheduleRuleSingleModel: Codable {
    var schedule: Schedule?
}

// MARK: - Schedule
struct Schedule: Codable {
    var id: Int?
    var childID: Int?
    var name: String?
    var function: String?
    var type: String?
    var startTime: String?
    var endTime: String?
    var onMonday: Int?
    var onTuesday: Int?
    var onWednesday: Int?
    var onThursday: Int?
    var onFriday: Int?
    var onSaturday: Int?
    var onSunday: Int?
    var status: Int?
    var isPredefined: Int?
    var mdmPayload: String?
    var deleted: Int?
    var created_at: String?
    var updated_at: String?
    var super_user_id: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case childID = "child_id"
        case name, function, type
        case startTime = "start_time"
        case endTime = "end_time"
        case onMonday = "on_monday"
        case onTuesday = "on_tuesday"
        case onWednesday = "on_wednesday"
        case onThursday = "on_thursday"
        case onFriday = "on_friday"
        case onSaturday = "on_saturday"
        case onSunday = "on_sunday"
        case status
        case isPredefined = "is_predefined"
        case mdmPayload = "mdm_payload"
        case deleted, super_user_id
        case created_at, updated_at
    }
    
    init() {
        // Initialize properties here if needed
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        childID = try container.decodeIfPresent(Int.self, forKey: .childID)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        function = try container.decodeIfPresent(String.self, forKey: .function)
        type = try container.decodeIfPresent(String.self, forKey: .type)
        startTime = try container.decodeIfPresent(String.self, forKey: .startTime)
        endTime = try container.decodeIfPresent(String.self, forKey: .endTime)
        onMonday = try decodeIntOrString(forKey: .onMonday, from: decoder)
        onTuesday = try decodeIntOrString(forKey: .onTuesday, from: decoder)
        onWednesday = try decodeIntOrString(forKey: .onWednesday, from: decoder)
        onThursday = try decodeIntOrString(forKey: .onThursday, from: decoder)
        onFriday = try decodeIntOrString(forKey: .onFriday, from: decoder)
        onSaturday = try decodeIntOrString(forKey: .onSaturday, from: decoder)
        onSunday = try decodeIntOrString(forKey: .onSunday, from: decoder)
        status = try decodeIntOrString(forKey: .status, from: decoder)
        isPredefined = try decodeIntOrString(forKey: .isPredefined, from: decoder)
        mdmPayload = try container.decodeIfPresent(String.self, forKey: .mdmPayload)
        deleted = try decodeIntOrString(forKey: .deleted, from: decoder)
        created_at = try container.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try container.decodeIfPresent(String.self, forKey: .updated_at)
        super_user_id = try container.decodeIfPresent(Int.self, forKey: .super_user_id)
    }
    
    private func decodeIntOrString(forKey key: CodingKeys, from decoder: Decoder) throws -> Int? {
        if let intValue = try? decoder.container(keyedBy: CodingKeys.self).decodeIfPresent(Int.self, forKey: key) {
            return intValue
        } else if let stringValue = try? decoder.container(keyedBy: CodingKeys.self).decodeIfPresent(String.self, forKey: key),
                  let intValue = Int(stringValue) {
            return intValue
        } else {
            return nil
        }
    }

}

//struct ScheduleRuleCodableModel: Codable {
//    var schedules: [Schedule]?
//}
//struct ScheduleRuleSingleModel: Codable {
//    var schedule: Schedule?
//}
//
//// MARK: - Schedule
//struct Schedule: Codable {
//    var id, childID: Int?
//    var name: String?
//    var function: String?
//    var type: String?
//    var startTime, endTime: String?
//    var onMonday, onTuesday, onWednesday, onThursday: Int?
//    var onFriday, onSaturday, onSunday, status: Int?
//    var isPredefined: Int?
//    var deleted: Int?
//    var created_at: String?
//    var updated_at: String?
//    var super_user_id: Int?
//    enum CodingKeys: String, CodingKey {
//        case id
//        case childID = "child_id"
//        case name, function, type
//        case startTime = "start_time"
//        case endTime = "end_time"
//        case onMonday = "on_monday"
//        case onTuesday = "on_tuesday"
//        case onWednesday = "on_wednesday"
//        case onThursday = "on_thursday"
//        case onFriday = "on_friday"
//        case onSaturday = "on_saturday"
//        case onSunday = "on_sunday"
//        case status
//        case isPredefined = "is_predefined"
//        case deleted, super_user_id
//        case created_at, updated_at
//    }
//}

extension Int {
    func intToStr()->String {
        return "\(self)"
    }
}

