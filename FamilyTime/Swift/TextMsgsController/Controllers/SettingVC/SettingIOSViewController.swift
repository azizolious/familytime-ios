//
//  SettingIOSViewController.swift
//  FamilyTime
//
//  Created by YumyApps on 01/11/2021.
//  Copyright © 2021 YumyApps. All rights reserved.
//

import UIKit

class SettingIOSViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    
    let child_Id = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
    let vm = ControlVM()
    var sectionName = ["settings_card_2_title".localized,"family_watch".localized, "device".localized, ""]
    var syncSettingsCont = SyncSettingsViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ControlTableCell", bundle: nil), forCellReuseIdentifier: "ControlTableCell")
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        filterFamilyArrIOS()
        vm.tableReloader = {self.tableView.reloadData()}
       
    }
    func filterFamilyArrIOS() {
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
            return ["contacts", "location_history", "apps_list"].contains(identifier) && plan.iosReleased != 0
        }
        
        // Assign status to vm.familyWatchArrIOS
        for (index, control) in vm.familyWatchArrIOS.enumerated() {
            if let matchedPlan = filteredWatchPlans.first(where: { $0.identifier == control.identifier }) {
                vm.familyWatchArrIOS[index].status = Int(matchedPlan.status)
            }
        }
        
        vm.familyWatchArrIOS = vm.familyWatchArrIOS.filter { control in
            return filteredWatchPlans.contains { $0.identifier == control.identifier }
        }
        
        // Filter for family care
        let filteredCarePlans = result.plans.filter { plan in
            guard let identifier = plan.identifier else {
                return false
            }
            print("Identifier: \(identifier), iOS Released: \(plan.iosReleased), status: \(plan.status)")
            return ["app_blocker", "schedule_screen_time", "geofence", "speed_limit", "content_filters"].contains(identifier) && plan.iosReleased != 0
        }
        
        // Assign status to vm.familyCareIOS
        for (index, control) in vm.familyCareIOS.enumerated() {
            if let matchedPlan = filteredCarePlans.first(where: { $0.identifier == control.identifier }) {
                vm.familyCareIOS[index].status = Int(matchedPlan.status)
            }
        }
        
        vm.familyCareIOS = vm.familyCareIOS.filter { control in
            return filteredCarePlans.contains { $0.identifier == control.identifier }
        }
    }



}

//MARK: Handle TableView
extension SettingIOSViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sectionName.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return vm.familyCareIOS.count
        case 1:
            return vm.familyWatchArrIOS.count
        case 2:
            return vm.deviceArrIOS.count
        case 3:
            return 1
        default:
            return 0
            
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ControlTableCell") as? ControlTableCell else {
                    return UITableViewCell()
                }
        switch indexPath.section {
        case 0:
            cell.setfamilyCareUI(control: vm.familyCareIOS[indexPath.row])
        case 1:
            cell.setCellUI(control: vm.familyWatchArrIOS[indexPath.row])
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
            cell.deviceSetUi(control: vm.deviceArrIOS[indexPath.row])
            cell.arrowImg.isHidden = indexPath.row == 0 ? false : true
            cell.controlSwitch.onTintColor = UIColor.init(hexString: "#7333E3")
            cell.controlSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
            cell.callback = { control, state in
                let getControl = DBManager.shared.fetchAppBlockControl(identifier: "family_pause")
                self.vm.getIdentifier(iden: control.identifier,state: state.boolToInt(), vu: self.view)
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
        let obj = vm.deviceArrIOS[0]
        
        switch indexPath.section {
        case 0:
            handleFamilyCareSelection(index: indexPath.row)
            break
        case 1:
            print("no need to navigate")
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
        guard index >= 0 && index < vm.familyCareIOS.count else {
            print("Index out of range")
            return
        }

        let selectedControl = vm.familyCareIOS[index]

        // Check status of the selected control's plan
        if selectedControl.status == 0 {
            SwiftFTUtils.showSwiftPremiumPopup(on: self)
            return
        }

        // Navigate based on selected control
        switch selectedControl.identifier {
        case "app_blocker":
//            let mdmHash = childInfo.childMdmHash ?? ""
//            UserDefaults.standard.set(mdmHash, forKey: UserDefaultsConstants.CHILD_MDM_HASH)
//            UserDefaults.standard.synchronize()
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            navigationController?.pushViewController(syncSettingsCont, animated: true)
        case "schedule_screen_time":
            SSTVC()
        case "geofence":
            let placesCont = SwiftPlacesViewController(nibName: "PlacesViewController", bundle: nil)
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            navigationController?.pushViewController(placesCont, animated: true)
        case "speed_limit":
            let controller = SwiftSpeedLimitViewController(nibName: "SpeedLimitViewController", bundle: nil)
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            navigationController?.pushViewController(controller, animated: true)
        case "content_filters":
            let controller = HLStoryboard.loadContentFiltersVC()
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            navigationController?.pushViewController(controller, animated: true)
        case "web_blocker":
            // [WebBlocker Tier 2] UIKit WebBlockerVC removed; web blocker is now SwiftUI
            // (Views/AppBlocking/WebBlockerView). This legacy entry is dead at runtime.
            break
        default:
            break
        }
    }



//    func handleFamilyCareSelection(index: Int) {
//        switch index {
//        case 0:
//            gotoAppBlockerVC()
//            break
//        case 1:
//            SSTVC()
//        case 2:
//            let placesCont = SwiftPlacesViewController(nibName: "PlacesViewController", bundle: nil)
//            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
//            navigationController?.pushViewController(placesCont, animated: true)
//        case 3:
//            let controller = SwiftSpeedLimitViewController(nibName: "SpeedLimitViewController", bundle: nil)
//            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
//            navigationController?.pushViewController(controller, animated: true)
//            
////            let speedLimitCont = SwiftSpeedLimitViewController(nibName: "SwiftSpeedLimitViewController", bundle: nil)
////            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
////            navigationController?.pushViewController(speedLimitCont, animated: true)
//        case 4:
//            let controller = HLStoryboard.loadContentFiltersVC()
//            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
//            navigationController?.pushViewController(controller, animated: true)
//            
//       
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
        
        let controller = SwiftLimitScreenViewController()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(controller, animated: true)
//        let stb = UIStoryboard(name: "Dashboard", bundle: nil)
//        let vc = stb.instantiateViewController(withIdentifier: "ScheduleScreenTimeVC") as? ScheduleScreenTimeVC
//        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
//        if let vc = vc {
//            navigationController?.pushViewController(vc, animated: true)
//        }
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
            synSettings()
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
    }
    
}

