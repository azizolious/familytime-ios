//
//  ControlVM.swift
//  FamilyTime
//
//  Created by Sufyan on 10/10/2023.
//  Copyright © 2023 YumyApps. All rights reserved.
//

import Foundation
class ControlVM {
    
    var familyCareArr = HandleControlVCData.familyCareArr
    var familyCareIOS = HandleControlVCData.familyCareIOS
     var familyWatchArr: [ControlModel] = [ControlModel]()
    var familyWatchArrIOS: [ControlModel] = []
    var deviceArr = HandleControlVCData.deviceArr
    var deviceArrIOS = HandleControlVCData.deviceArrIOS
    var controlApiData = ControlCodableModel()
     var stt = ""
    var tableReloader: ()->() = {}
    
    init() {
        familyWatchArr = [
            //            ControlModel(title: "apps".localized, description: "apps_des".localized, isOn: false, isPremium: false, imgName: "apps", identifier: "apps_list", isSwitch: true),
            ControlModel(title: "social_media_monitoring_setting".localized, description: "social_monitoring_des".localized, isOn: false, isPremium: false, status: 1, imgName: "smmonitor", identifier: "social_monitoring"),
            ControlModel(title: "calls".localized, description: "calss_desc".localized, isOn: false, isPremium: false, status: 1, imgName: "callsG", identifier: "call_logs", isSwitch: true),
            ControlModel(title: "text_messages".localized, description: "text_message_desc".localized, isOn: false, isPremium: false, status: 1, imgName: "textMsg", identifier: "sms", isSwitch: true),
            ControlModel(title: "settings_card_1_android_3".localized, description: "contact_des".localized, isOn: false, isPremium: false, status: 1, imgName: "con", identifier: "contacts", isSwitch: true),
            ControlModel(title: "locations".localized, description: "locations_des".localized, isOn: false, isPremium: false, status: 1, imgName: "loc", identifier: "location_history", isSwitch: true),
            ControlModel(title: "apps".localized, description: "apps_desc".localized, isOn: false, isPremium: false, status: 1, imgName: "apps", identifier: "apps_list", isSwitch: true),
            //                          ControlModel(title: "youtube_controls".localized, description: "youtube_controls_des".localized, isOn: false, isPremium: false, imgName: "utubeGreen", identifier: "youtube_history", isSwitch: true),
            ControlModel(title: "youtube_history".localized, description: "youtube_desc".localized, isOn: false, isPremium: false, status: 1, imgName: "utubeGreen", identifier: "youtube_history", isSwitch: true),
            ControlModel(title: "web".localized, description: "web_des".localized, isOn: false, isPremium: false, status: 1, imgName: "webG", identifier: "browsing_history", isSwitch: true),
            ControlModel(title: "low_battery".localized, description: "low_battery_desc".localized, isOn: false, isPremium: false, status: 1, imgName: "lowBattery", identifier: "low_battery", isSwitch: true)
        ]
        
        familyWatchArrIOS = [
            ControlModel(title: "settings_card_1_android_3".localized, description: "contacts_des".localized, isOn: false, isPremium: false, status: 1, imgName: "con", identifier: "contacts", isSwitch: true),
            ControlModel(title: "Locations", description: "Enable and disable locations", isOn: false, isPremium: false, status: 1, imgName: "loc", identifier: "location_history", isSwitch: true),
            ControlModel(title: "Apps", description: "Enable and disable apps", isOn: false, isPremium: false, status: 1, imgName: "apps", identifier: "apps_list", isSwitch: true)
                ]
        
        getControlFromDb()
    }
    func getControlFromDb() {
           let childID = UserDefaults.standard.integer(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
           DBManager.shared.getModelDataFromDB(entityName: .control) { (mode: ControlCodableModel?, err) in
               if mode == nil {
                   HLApiManager.getControlApi()
               } else {
                   self.controlApiData = mode ?? ControlCodableModel()
                   for (ind, obj) in self.familyWatchArr.enumerated() {
                       if obj.isSwitch {
                           guard let apiControl = self.controlApiData.controls else { return }
                           for obj2 in apiControl {
                               if self.deviceArr[2].identifier == obj2.identifier && childID == obj2.childID {
                                   self.deviceArr[2].isOn = obj2.state?.boolValue ?? false
                               }
                               if obj.identifier == obj2.identifier && childID == obj2.childID {
                                   self.familyWatchArr[ind].isOn = obj2.state?.boolValue ?? false
                               }
                           }
                       }
                   }
                   
                   for (ind, obj) in self.familyWatchArrIOS.enumerated() {
                       if obj.isSwitch {
                           guard let apiControl = self.controlApiData.controls else { return }
                           for obj2 in apiControl {
                               if self.deviceArr[2].identifier == obj2.identifier && childID == obj2.childID {
                                   self.deviceArr[2].isOn = obj2.state?.boolValue ?? false
                               }
                               if obj.identifier == obj2.identifier && childID == obj2.childID {
                                   self.familyWatchArrIOS[ind].isOn = obj2.state?.boolValue ?? false
                               }
                           }
                       }
                   }
                   
                   self.tableReloader()
               }
           }
       }
//    func getControlFromDb() {
//        let childID = UserDefaults.standard.integer(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
//        DBManager.shared.getModelDataFromDB(entityName: .control) { (mode: ControlCodableModel?, err) in
//            if mode == nil {
//                HLApiManager.getControlApi()
//            } else {
//                self.controlApiData = mode ?? ControlCodableModel()
//                for (ind,obj) in self.familyWatchArr.enumerated() {
//                    if obj.isSwitch {
//                        guard let apiContro = self.controlApiData.controls else {return}
//                        for obj2 in apiContro{
//                            if self.deviceArr[2].identifier == obj2.identifier && childID == obj2.childID {
//                                self.deviceArr[2].isOn = obj2.state?.boolValue ?? false
//                            }
//                            if obj.identifier == obj2.identifier && childID == obj2.childID {
//                                self.familyWatchArr[ind].isOn = obj2.state?.boolValue ?? false
//                            }
//                        }
//                    }
//                }
//                
//                self.tableReloader()
//            }
//        }
//    }
    func getState(iden: String) -> Bool {
        let cont = controlApiData.controls
        let childID = UserDefaults.standard.integer(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        print("selectedChild", childID)

        if let obj = cont?.first(where: {$0.childID == childID && $0.identifier == iden}) {
            return ((obj.state?.boolValue) != nil)
        }else {
            return false
        }
    }
    func getIdentifier(iden: String, state: Int = 0, vu: UIView) {
        var con = controlApiData.controls
        let childID = UserDefaults.standard.integer(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        print("selectedChild", childID)
        SwiftFTUtils.showHUDAdded(to: vu, withText: "", animated: true)

        if let obj = con?.firstIndex(where: {$0.childID == childID && $0.identifier == iden}) {
            print(obj)
            
            if let childId = con?[obj].childID,
               let featureId = con?[obj].featureID {
                
                HLApiManager.putControlApi(childId: childId,
                                           featureId: featureId,
                                           state: state, identifier: iden) { err in
                    if err != nil {
                        SwiftFTUtils.hideHUDAdded(to: vu, animated: true)
                        CommonModel.showAlert("alert_error".localized, msg: err ?? "Nothing")
                        return
                    }
                    SwiftFTUtils.hideHUDAdded(to: vu, animated: true)
                    con?[obj].state = state
                    self.controlApiData.controls = con
                    let jsonEncoder = JSONEncoder()
                    do {
                        let jsonData = try jsonEncoder.encode(self.controlApiData)
                        DBManager.shared.saveDataToDB(entityName: .control, ModelData: jsonData) {
                            self.getControlFromDb()
                            
                        }
                        
                    } catch {
                        print(error)
                    }
                }
            } else {
                CommonModel.showAlert("alert_error".localized, msg: "alert_something_wrong_again")
                print("❌ Missing required params (childId / featureId / identifier)")
            }
        }
    }
}



struct ControlModel: Codable {
    var title: String
    var description: String
    var isOn: Bool
    var isPremium: Bool
    var status : Int
    var imgName: String
    var identifier: String
    var isSwitch = false
    var isCheveron = false
    
    func isPremiumPkg()->Bool {
        let childID = UserDefaults.standard.integer(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        let package_id = CoreDataUtility.fetchPackageIdFor(child_id: Int32(childID))
        if package_id == "2" || package_id == "3" {
            return true
        } else {
            return false
        }
    }
    func isPremiumOnly()->Bool {
        let childID = UserDefaults.standard.integer(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        let package_id = CoreDataUtility.fetchPackageIdFor(child_id: Int32(childID))
        if package_id == "3" {
            return true
        } else {
            return false
        }
    }
}

class HandleControlVCData {
    static var familyCareArr = [
        ControlModel(title: "individual_app_limit".localized, description: "set_limit_apps_game".localized, isOn: false, isPremium: false, status: 1, imgName: "indAppLimit", identifier: "app_limit"),
        ControlModel(title: "settings_card_2_android_1".localized, description: "daily_usageDes".localized, isOn: false, isPremium: false, status: 1, imgName: "dailyAppLimit", identifier: "daily_app_limit", isCheveron: true),
        
        ControlModel(title: "settings_card_2_android_2".localized, description: "app_block_desc".localized, isOn: false, isPremium: false, status: 1, imgName: "appBlocker", identifier: "app_blocker"),
        ControlModel(title: "schedule_screen_time".localized, description: "sst_des".localized, isOn: false, isPremium: false, status: 1, imgName: "SST", identifier: "schedule_screen_time"),
        ControlModel(title: "internet_filters".localized, description: "inter_filter_des".localized, isOn: false, isPremium: false, status: 1, imgName: "interFilter", identifier: "internet_filters"),
        ControlModel(title: "internet_schedules".localized, description: "inter_schedule_des".localized, isOn: false, isPremium: false, status: 1, imgName: "inteSchedule", identifier: "internet_schedule"),
        ControlModel(title: "web_blocker".localized, description: "web_blocker_des".localized, isOn: false, isPremium: false, status: 1, imgName: "webRed", identifier: "web_blocker"),
        ControlModel(title: "places_geo_fence".localized, description: "geofence_desc".localized, isOn: false, isPremium: false, status: 1, imgName: "geoF", identifier: "geofence"),
        ControlModel(title: "fun_time".localized, description: "funtime_desc".localized, isOn: false, isPremium: false, status: 1, imgName: "funT", identifier: "fun_time"),
        ControlModel(title: "contact_watchlist".localized, description: "contact_watchlist_desc".localized, isOn: false, isPremium: false, status: 1, imgName: "contectWatchList", identifier: "contacts_watch")]
    
    
    //                                ,
    //                               ControlModel(title: "speed_limit".localized, description: "speed_limit_des".localized, isOn: false, isPremium: false, imgName: "speedLimit", identifier: ""),
    //                                ControlModel(title: "content_filters".localized, description: "content_filters_des".localized, isOn: false, isPremium: false, imgName: "contentFil", identifier: "")]
   static var familyCareIOS = [
        
    ControlModel(title: "settings_card_2_android_2".localized, description: "app_block_desc".localized, isOn: false, isPremium: false, status: 1, imgName: "appBlocker", identifier: "app_blocker"),
    ControlModel(title: "schedule_screen_time".localized, description: "sst_des".localized, isOn: false, isPremium: false, status: 1, imgName: "SST", identifier: "schedule_screen_time"),
    ControlModel(title: "places_geo_fence".localized, description: "geofence_desc".localized, isOn: false, isPremium: false, status: 1, imgName: "geoF", identifier: "geofence"),
    ControlModel(title: "speed_limit".localized, description: "speed_limit_des".localized, isOn: false, isPremium: false, status: 1, imgName: "speedLimit", identifier: "speed_limit"),
    ControlModel(title: "content_filters".localized, description: "content_filters_des".localized, isOn: false, isPremium: false, status: 1, imgName: "contentFil", identifier: "content_filters"),
    ControlModel(title: "web_blocker".localized, description: "web_blocker_des".localized, isOn: false, isPremium: false, status: 1, imgName: "webRed", identifier: "web_blocker")]
    
    
    
    static var familyWatchArr = [ControlModel(title: "Apps", description: "Enable and disable apps", isOn: false, isPremium: false, status: 1, imgName: "apps", identifier: "apps_list", isSwitch: true),
                                 ControlModel(title: "social_media_monitoring_setting".localized, description: "Enable and disable social monitoring", isOn: false, isPremium: false, status: 1, imgName: "smmonitor", identifier: ""),
                                 ControlModel(title: "Calls", description: "Enable and disable calls", isOn: false, isPremium: false, status: 1, imgName: "callsG", identifier: "call_logs", isSwitch: true),
                                 ControlModel(title: "Text Messages", description: "Enable and disable text messages", isOn: false, isPremium: false, status: 1, imgName: "textMsg", identifier: "sms", isSwitch: true),
                                 ControlModel(title: "settings_card_1_android_3".localized, description: "contacts_des".localized, isOn: false, isPremium: false, status: 1, imgName: "con", identifier: "contacts", isSwitch: true),
                                 ControlModel(title: "Locations", description: "Enable and disable locations", isOn: false, isPremium: false, status: 1, imgName: "loc", identifier: "location_history", isSwitch: true),
                                 ControlModel(title: "Safe Internet", description: "Enable and safe internet", isOn: false, isPremium: false, status: 1, imgName: "safeInt", identifier: "internet_filters", isSwitch: true),
                                 ControlModel(title: "Web", description: "Enable and disable web", isOn: false, isPremium: false, status: 1, imgName: "webG", identifier: "web_blocker", isSwitch: true),
                                 ControlModel(title: "Low Battery", description: "Enable and disable low battery", isOn: false, isPremium: false, status: 1, imgName: "lowBattery", identifier: "low_battery", isSwitch: true)
    ]
   
    
    
    
    static var deviceArr = [ControlModel(title: "device_info".localized, description: "device_info_desc".localized, isOn: false, isPremium: false, status: 1, imgName: "deviceInfo", identifier: "device_info", isCheveron: true),
                            ControlModel(title: "change_passcode".localized, description: "change_pass_desc".localized, isOn: false, isPremium: false, status: 1, imgName: "chPass", identifier: "pin_code"),
                            ControlModel(title: "secure_familytime_jr_app".localized, description: "secure_desc".localized, isOn: false, isPremium: false, status: 1, imgName: "protectIns", identifier: "protect_uninstall", isSwitch: true),
                            ControlModel(title: "sync_settings".localized, description: "sync_setting_desc".localized, isOn: false, isPremium: false, status: 1, imgName: "syncSett", identifier: "sync")
    ]
    static var deviceArrIOS = [ControlModel(title: "device_info".localized, description: "device_info_desc".localized, isOn: false, isPremium: false, status: 1, imgName: "deviceInfo", identifier: "", isCheveron: true),
                               ControlModel(title: "sync_settings".localized, description: "sync_setting_desc".localized, isOn: false, isPremium: false, status: 1, imgName: "syncSett", identifier: "")
    ]
  
    
}
