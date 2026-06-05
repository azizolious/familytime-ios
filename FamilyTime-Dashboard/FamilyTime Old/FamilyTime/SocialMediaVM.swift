//
//  SocialMediaVM.swift
//  FamilyTime
//
//  Created by Sufyan on 31/10/2023.
//  Copyright © 2023 YumyApps. All rights reserved.
//

import Foundation
class SocialMediaVM {
    var apps = [SocialMonitoringApps(name: "all_apps".localized, isSelected: false, isMonitor: false,hideImg: true, imgName: "", pkgName: ""),
                SocialMonitoringApps(name: "WhatsApp", isSelected: false, isMonitor: false, imgName: "whats", pkgName: "com.whatsapp"),
                SocialMonitoringApps(name: "Instagram", isSelected: false, isMonitor: false, imgName: "Instag", pkgName: "com.instagram.android"),
                SocialMonitoringApps(name: "Whatsapp Business", isSelected: false, isMonitor: false, imgName: "gbwhats", pkgName: "com.whatsapp.w4b"),
                SocialMonitoringApps(name: "TikTok", isSelected: false, isMonitor: false, imgName: "TikTok", pkgName: "com.zhiliaoapp.musically"),
                SocialMonitoringApps(name: "Imo", isSelected: false, isMonitor: false, imgName: "imoo", pkgName: "com.imo.android.imoim"),
                SocialMonitoringApps(name: "BiP", isSelected: false, isMonitor: false, imgName: "bip", pkgName: "com.turkcell.bip"),
                SocialMonitoringApps(name: "Signal", isSelected: false, isMonitor: false, imgName: "signal", pkgName: "org.thoughtcrime.securesms"),
                SocialMonitoringApps(name: "Twitch", isSelected: false, isMonitor: false, imgName: "twitch", pkgName: "tv.twitch.android.app")]
    let allApps = DBManager.shared.fetchDataAndConvertToModels()
    var control = Control()
    var state = false
    var tblReloader: ()->() = {}
    
    func getReady() {
        for (ind,obj) in apps.enumerated() {
            if let appp = allApps.first(where: {$0.appPackageName == obj.pkgName}) {
                print("monitor", appp.isMonitor as Any)
                let check = appp.isMonitor?.boolValue
                print("monitor", check as Any)
                apps[ind].isMonitor = check ?? false
                apps[ind].isSelected = true
            } else {
                apps[ind].isSelected = false
            }
        }
        var appss = apps
        appss.remove(at: 0)
        if appss.allSatisfy({$0.isMonitor == true}) {
            apps[0].isMonitor = true
        }
        tblReloader()
    }
    
    func sendSocialMonitorRequest(vu:UIView, navigation: UINavigationController?) {
        if control.identifier == nil {
            HLApiManager.getControlApi()
            return
        }
        if state == true && apps.allSatisfy({$0.isMonitor == false}) {
            CommonModel.showAlert("alert_title".localized, msg: "select_one_device_title".localized)
            return
        }
        
        SwiftFTUtils.showHUDAdded(to: vu, withText: "", animated: true)
        let params = getParams()
        CoreManager.postSocialMediaMonitor(params: params) { [weak self] err in
            if err != nil {
                SwiftFTUtils.hideHUDAdded(to: vu, animated: true)
                CommonModel.showAlert("alert_error".localized, msg: err ?? "Nothing")
                return
            }
            self?.putControlApi(vu: vu, navigation: navigation)
        }
    }
    
    private func getParams() -> [String:Any] {
        var apps = apps
        apps.remove(at: 0)
        var list = [[String:Any]]()
        for obj in apps {
            let obj = ["app_name": obj.name,
                       "isInstalled": obj.isSelected,
                       "is_monitor": obj.isMonitor ,
                       "package_name": obj.pkgName] as [String : Any]
            list.append(obj)
            
        }
        
        let params:[String:Any] = ["apps": list,
                                   "child_id": control.childID ?? 0,
                                   "is_enabled": state.boolToInt()]
        return params
    }
    
    private func putControlApi(vu:UIView, navigation: UINavigationController?) {
        
        if let childId = control.childID,
           let featureId = control.featureID,
           let identifier = control.identifier {
            
            HLApiManager.putControlApi(childId: childId,
                                       featureId: featureId,
                                       state: state.boolToInt(),
                                       identifier: identifier ?? "social_monitoring") { err in
                if err != nil {
                    SwiftFTUtils.hideHUDAdded(to: vu, animated: true)
                    CommonModel.showAlert("alert_error".localized, msg: err ?? "Nothing")
                    return
                }
                SwiftFTUtils.hideHUDAdded(to: vu, animated: true)
                DBManager.shared.fetchControlAndUpdate(identifier: "social_monitoring",
                                                       state: self.state.boolToInt())
                self.fetchAndUpdateDB()
                navigation?.popViewController(animated: true)
            }
        } else {
            CommonModel.showAlert("alert_error".localized, msg: "alert_something_wrong_again")
            print("❌ Missing required params (childId / featureId / identifier)")
        }
    }
    private func fetchAndUpdateDB() {
        let ap = apps
        for obj in ap {
            DBManager.shared.fetchAppAndUpdateMonitor(obj: obj)
        }
    }
}

struct SocialMonitoringApps {
    var name : String
    var isSelected : Bool
    var isMonitor : Bool
    var hideImg = false
    var imgName: String
    var pkgName: String
}
