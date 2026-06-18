//
//  ControlViewController.swift
//  FamilyTime
//
//  Created by Sufyan on 13/10/2023.
//  Copyright © 2023 YumyApps. All rights reserved.
//

import UIKit

class ControlViewController: UIViewController {
    
    @IBOutlet weak var tblVu: UITableView!
    let child_Id = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
    let vm = ControlVM()
    var sectionName = ["settings_card_2_title".localized,"family_watch".localized, "device".localized, ""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblVu.delegate = self
        tblVu.dataSource = self
        tblVu.register(UINib(nibName: "ControlTableCell", bundle: nil), forCellReuseIdentifier: "ControlTableCell")
        tblVu.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        LiveVisitorManager.shared.updateScreen(
            "Settings"
        )
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.setPassCode()
        }
        filterFamilyArr()
        vm.tableReloader = {self.tblVu.reloadData()}
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tblVu.reloadData()
    }
    func filterFamilyArr() {
        guard let childIdString = child_Id, let childId = Int(childIdString) else {
            print("Invalid child ID")
            return
        }
        
        let result = DBManager.shared.fetchChildAndPlans(byChildID: childId)
        guard let _ = result.child else {
            print("Child not found")
            return
        }
        
        // Filter for family watch
        let filteredWatchPlans = result.plans.filter { plan in
            guard let identifier = plan.identifier else {
                return false
            }
            return ["social_monitoring", "call_logs", "sms","contacts","location_history","apps_list","youtube_history","browsing_history","low_battery"].contains(identifier) && plan.androidReleased != 0
        }
        
        // Assign status to vm.familyWatchArrIOS
        for (index, control) in vm.familyWatchArr.enumerated() {
            if let matchedPlan = filteredWatchPlans.first(where: { $0.identifier == control.identifier }) {
                vm.familyWatchArr[index].status = Int(matchedPlan.status)
            }
        }
        
        vm.familyWatchArr = vm.familyWatchArr.filter { control in
            return filteredWatchPlans.contains { $0.identifier == control.identifier }
        }
        
        // Filter for family care
        let filteredCarePlans = result.plans.filter { plan in
            guard let identifier = plan.identifier else {
                return false
            }
            return  ["app_limit", "daily_app_limit", "app_blocker", "schedule_screen_time", "internet_filters","internet_schedule","web_blocker","geofence","fun_time","contacts_watch"].contains(identifier) && plan.androidReleased != 0
        }
        
        // Assign status to vm.familyCareIOS
        for (index, control) in vm.familyCareArr.enumerated() {
            if let matchedPlan = filteredCarePlans.first(where: { $0.identifier == control.identifier }) {
                vm.familyCareArr[index].status = Int(matchedPlan.status)
            }
        }
        
        vm.familyCareArr = vm.familyCareArr.filter { control in
            return filteredCarePlans.contains { $0.identifier == control.identifier }
        }
        
        let filteredDevicePlans = result.plans.filter { plan in
            if let identifier = plan.identifier, ["pin_code", "protect_uninstall"].contains(identifier) {
                return plan.androidReleased != 0
            }
            return true
        }
        
        // Update the status of vm.deviceArr based on the filtered plans
        for (index, control) in vm.deviceArr.enumerated() {
            if let matchedPlan = filteredDevicePlans.first(where: { $0.identifier == control.identifier }) {
                vm.deviceArr[index].status = Int(matchedPlan.status)
            }
        }
        
        // Filter vm.deviceArr to exclude "pin_code" and "protect_uninstall" if their androidReleased is 0
        vm.deviceArr = vm.deviceArr.filter { control in
            if ["pin_code", "protect_uninstall"].contains(control.identifier) {
                return filteredDevicePlans.contains { $0.identifier == control.identifier }
            }
            return true
        }
        
        
    }
    //    func filterFamilyArr() {
    //        guard let childIdString = child_Id, let childId = Int(childIdString) else {
    //            print("Invalid child ID")
    //            return
    //        }
    //
    //        let result = DBManager.shared.fetchChildAndPlans(byChildID: childId)
    //        guard let _ = result.child else {
    //            print("Child not found")
    //            return
    //        }
    //
    //        // Filter for family watch
    //        let filteredWatchPlans = result.plans.filter { plan in
    //            guard let identifier = plan.identifier else {
    //                return false
    //            }
    //            return ["social_monitoring", "call_logs", "sms","contacts","location_history","apps_list","youtube_history","browsing_history","low_battery"].contains(identifier) && plan.androidReleased != 0
    //        }
    //
    //        vm.familyWatchArr = vm.familyWatchArr.filter { control in
    //            return filteredWatchPlans.contains { $0.identifier == control.identifier }
    //        }
    //
    //        let filteredCarePlans = result.plans.filter { plan in
    //            guard let identifier = plan.identifier else {
    //                return false
    //            }
    //            return ["app_limit", "daily_app_limit", "app_blocker", "schedule_screen_time", "internet_filters","internet_schedule","web_blocker","geofence","fun_time","contacts_watch"].contains(identifier) && plan.androidReleased != 0
    //        }
    //
    //        vm.familyCareArr = vm.familyCareArr.filter { control in
    //            return filteredCarePlans.contains { $0.identifier == control.identifier }
    //        }
    //    }
    
    func setPassCode() {
        let getControl = DBManager.shared.fetchAppBlockControl(identifier: "family_pause")
        if getControl.value == "" || getControl.value == nil{
            let dashboardStoryboard = UIStoryboard(name: "Dashboard", bundle: nil)
            let vc = dashboardStoryboard.instantiateViewController(withIdentifier: "PasscodePopUpViewController") as? PasscodePopUpViewController ?? PasscodePopUpViewController()
            vc.color = "red"
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true, completion: nil)
        }
    }
}

//MARK: Handle TableView
extension ControlViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sectionName.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return vm.familyCareArr.count
        case 1:
            return vm.familyWatchArr.count
        case 2:
            return vm.deviceArr.count
        case 3:
            return 1
        default:
            return 0
            
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ControlTableCell") as! ControlTableCell
        switch indexPath.section {
        case 0:
            cell.setfamilyCareUI(control: vm.familyCareArr[indexPath.row])
        case 1:
            cell.setCellUI(control: vm.familyWatchArr[indexPath.row])
            cell.controlSwitch.onTintColor = UIColor.init(hexString: "#12C5A4")
            cell.controlSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
            cell.callback = { control, state in
                if control.status == 0 {
                    SwiftFTUtils.showSwiftPremiumPopup(on: self)
                } else {
                    self.vm.getIdentifier(iden: control.identifier, state: state.boolToInt(), vu: self.view)
                }
            }
        case 2:
            
            cell.deviceSetUi(control: vm.deviceArr[indexPath.row])
            cell.arrowImg.isHidden = indexPath.row == 0 ? false : true
            cell.controlSwitch.onTintColor = UIColor.init(hexString: "#7333E3")
            cell.controlSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
            cell.callback = { control, state in
                let getControl = DBManager.shared.fetchAppBlockControl(identifier: "family_pause")
                if getControl.value == "" || getControl.value == nil{
                    let dashboardStoryboard = UIStoryboard(name: "Dashboard", bundle: nil)
                    let vc = dashboardStoryboard.instantiateViewController(withIdentifier: "PasscodePopUpViewController") as? PasscodePopUpViewController ?? PasscodePopUpViewController()
                    vc.color = "red"
                    cell.controlSwitch.isOn = false
                    vc.callback = {
                        self.vm.getIdentifier(iden: control.identifier,state: state.boolToInt(), vu: self.view)
                        cell.controlSwitch.isOn = true
                    }
                    vc.modalPresentationStyle = .overCurrentContext
                    self.present(vc, animated: true, completion: nil)
                } else {
                    self.vm.getIdentifier(iden: control.identifier,state: state.boolToInt(), vu: self.view)
                }
            }
        case 3:
            cell.deleteSection()
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: section == 3 ? 0 : 30))
        let lbl = UILabel(frame: CGRect(x: 0, y: -10, width: 300, height: section == 3 ? 0 : 30))
        lbl.font = UIFont(name: "SFProDisplay-Semibold", size: 18)
        lbl.text = sectionName[section]
        view.backgroundColor = .clear
        lbl.backgroundColor = .clear
        view.addSubview(lbl)
        return view
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 3 {
            return 2
        } else  {
            return 30
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("section is: ",indexPath.section,"index is:", indexPath.row)
        let obj = vm.deviceArr[0]
        
        switch indexPath.section {
        case 0:
            handleFamilyCareSelection(index: indexPath.row)
            break
        case 1:
            let selectedControl = vm.familyWatchArr[indexPath.row]
            if indexPath.row == 0 {
                // Check status of the selected control's plan
                if selectedControl.status == 0 {
                    SwiftFTUtils.showSwiftPremiumPopup(on: self)
                    
                }else{
                    gotoSocialMediaVC()
                }
            }
//            if obj.isPremiumPkg() {
//                if indexPath.row == 0 {
//                    if obj.isPremiumOnly() {
//                        gotoSocialMediaVC()
//                    } else {
//                        SwiftFTUtils.showSwiftPremiumPopup(on: self)
//                    }
//                }
//                if !obj.isPremiumOnly() && indexPath.row == 2 {
//                    SwiftFTUtils.showSwiftPremiumPopup(on: self)
//                }
//            }else {
//                if indexPath.row == 5 || indexPath.row == 8 {
//                    print("Free Available")
//                } else {
//                    
//                    SwiftFTUtils.showSwiftPremiumPopup(on: self)
//                }
//            }
            break
        case 2:
            handleDeviceSection(index: indexPath.row)
            break
        case 3:
            UserDefaults.standard.set(true, forKey: "SETTING_IOS")
            let vc = DeleteChildVC(nibName: "DeleteChildVC", bundle: nil)
            vc.childDeleted = {
                self.navigationController?.popViewController(animated: true)
            }
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.navigationController?.present(vc, animated: true, completion: nil)
            break
        default:
            break
        }
    }
    
    func handleFamilyCareSelection(index: Int) {
        guard index >= 0 && index < vm.familyCareArr.count else {
            print("Index out of range")
            return
        }
        
        let selectedControl = vm.familyCareArr[index]
        
        // Check status of the selected control's plan
        if selectedControl.status == 0 {
            SwiftFTUtils.showSwiftPremiumPopup(on: self)
            return
        }
        switch selectedControl.identifier {
        case "app_limit":
            let vc = IndividualAppLimit(nibName: "IndividualAppLimit", bundle: nil)
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            navigationController?.pushViewController(vc, animated: true)
        case "daily_app_limit":
            gotoDailyLimitVC()
        case "app_blocker":
            gotoAppBlockerVC()
        case "schedule_screen_time":
            SSTVC()
        case "internet_filters":
            let stb = UIStoryboard(name: "Dashboard", bundle: nil)
            let vc = stb.instantiateViewController(withIdentifier: "InternetFilterVC") as? InternetFilterVC
            if let vc = vc {
                navigationController?.pushViewController(vc, animated: true)
            }
        case "internet_schedule":
            let stb = UIStoryboard(name: "Dashboard", bundle: nil)
            let vc = stb.instantiateViewController(withIdentifier: "InternetScheduleVC") as? InternetScheduleVC
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            if let vc = vc {
                navigationController?.pushViewController(vc, animated: true)
            }
        case "web_blocker":
            // [WebBlocker Tier 2] UIKit WebBlockerVC removed; web blocker is now SwiftUI
            // (Views/AppBlocking/WebBlockerView). This legacy entry is dead at runtime.
            break
        case "geofence":
            let placesCont = SwiftPlacesViewController(nibName: "PlacesViewController", bundle: nil)
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            navigationController?.pushViewController(placesCont, animated: true)
        case "fun_time":
            let storyboardName = "MyStoryboard"
            let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
            let vc = storyboard.instantiateViewController(withIdentifier: "ClockViewController") as? ClockViewController
            if let vc = vc {
                navigationController?.pushViewController(vc, animated: true)
            }
        case "contacts_watch":
            let contactWListCont = SwiftContactsWatchListViewController(nibName: "ContactsWatchListViewController", bundle: nil)
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            navigationController?.pushViewController(contactWListCont, animated: true)
        default:
            break
        }
    }
    //    func handleFamilyCareSelection(index: Int) {
    //        switch index {
    //        case 0:
    //            let vc = IndividualAppLimit(nibName: "IndividualAppLimit", bundle: nil)
    //            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    //            navigationController?.pushViewController(vc, animated: true)
    //            break
    //        case 1:
    //            gotoDailyLimitVC()
    //        case 2:
    //            gotoAppBlockerVC()
    //        case 3:
    //            SSTVC()
    //        case 5:
    //            let stb = UIStoryboard(name: "Dashboard", bundle: nil)
    //            let vc = stb.instantiateViewController(withIdentifier: "InternetScheduleVC") as? InternetScheduleVC
    //            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    //            if let vc = vc {
    //                navigationController?.pushViewController(vc, animated: true)
    //            }
    //        case 4:
    //            let stb = UIStoryboard(name: "Dashboard", bundle: nil)
    //            let vc = stb.instantiateViewController(withIdentifier: "InternetFilterVC") as? InternetFilterVC
    //            if let vc = vc {
    //                navigationController?.pushViewController(vc, animated: true)
    //            }
    //        case 6 :
    //            let webCon = WebBlockerVC()
    //            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    //            navigationController?.pushViewController(webCon, animated: true)
    //        case 7:
    //            let placesCont = SwiftPlacesViewController(nibName: "PlacesViewController", bundle: nil)
    //            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    //            navigationController?.pushViewController(placesCont, animated: true)
    //        case 8:
    //            let storyboardName = "MyStoryboard"
    //            let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
    //            let vc = storyboard.instantiateViewController(withIdentifier: "ClockViewController") as? ClockViewController
    //            if let vc = vc {
    //                navigationController?.pushViewController(vc, animated: true)
    //            }
    //        case 9:
    //            let contactWListCont = SwiftContactsWatchListViewController(nibName: "ContactsWatchListViewController", bundle: nil)
    //            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    //            navigationController?.pushViewController(contactWListCont, animated: true)
    //        default:
    //            break
    //        }
    //    }
    func gotoDailyLimitVC() {
        let vc = AndroidDailyLimitVC()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    func gotoSocialMediaVC() {
        let vc = SocialMediaMonitoringVC()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    func SSTVC() {
        let stb = UIStoryboard(name: "Dashboard", bundle: nil)
        let vc = stb.instantiateViewController(withIdentifier: "ScheduleScreenTimeVC") as? ScheduleScreenTimeVC
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        if let vc = vc {
            let getControl = DBManager.shared.fetchAppBlockControl(identifier: "family_pause")
            if getControl.value == "" || getControl.value == nil{
                let dashboardStoryboard = UIStoryboard(name: "Dashboard", bundle: nil)
                let vc = dashboardStoryboard.instantiateViewController(withIdentifier: "PasscodePopUpViewController") as? PasscodePopUpViewController ?? PasscodePopUpViewController()
                vc.color = "red"
                vc.callback = {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                vc.modalPresentationStyle = .overCurrentContext
                self.present(vc, animated: true, completion: nil)
            } else {
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    func gotoAppBlockerVC() {
        let stb = UIStoryboard(name: "Dashboard", bundle: nil)
        let vc = stb.instantiateViewController(withIdentifier: "AppBlockerAndroidVC") as? AppBlockerAndroidVC
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        if let vc = vc {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func handleDeviceSection(index: Int) {
        switch index {
        case 0:
            let stb = UIStoryboard(name: "Dashboard", bundle: nil)
            let vc = stb.instantiateViewController(withIdentifier: "DeviceVC") as? DeviceVC
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            if let vc = vc {
                navigationController?.pushViewController(vc, animated: true)
            }
            break
        case 1:
            let dashboardStoryboard = UIStoryboard(name: "Dashboard", bundle: nil)
            let vc = dashboardStoryboard.instantiateViewController(withIdentifier: "PasscodePopUpViewController") as? PasscodePopUpViewController ?? PasscodePopUpViewController()
            vc.color = "red"
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true, completion: nil)
            break
        case 2:
            
            break
        case 3:
            synSettings()
            break
        default:
            break
        }
    }
    func synSettings() {
        SwiftFTUtils.showHUDAdded(to: view, withText: "Loading...".myModification(), animated: true)
        CoreManager.syncSettings(params: ["feature": "all"]) { status, message in
            SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
            if status == 200 && message == nil {
                CommonModel.showAlert("successfull".localized, msg: "sync_alert_content_1".localized)

            } else {
                CommonModel.showAlert("alert_title".localized, msg: message)
            }
        }
        //        let child_Id = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        //        SwiftFTUtils.showHUDAdded(to: view, withText: "Loading...".myModification(), animated: true)
        //        let url = String(format: "\(kAndroid_Sync_settings_mesh2)\(Int(child_Id ?? "") ?? -1)")
        //        let params = [
        //            "setting": "all"
        //        ]
        //        print("url to sync settings = \(url) and params = \(params)")
        //        ApiManager.shared().postApi(withVC: self, isPresentedCont: false, andParams: params, withApi: url) { message, statusCode in
        //            DispatchQueue.main.async {
        //                SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
        //                CommonModel.showAlert("settings_card_5_1".localized, msg: "sync_alert_content_1".localized)
        //            }
        //        }
    }
}

extension Bool {
    func boolToInt()->Int {
        self ? 1 : 0
    }
}
