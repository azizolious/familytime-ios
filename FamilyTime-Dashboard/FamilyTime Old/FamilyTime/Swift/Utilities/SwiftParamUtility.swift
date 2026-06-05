//
//  SwiftParamUtility.swift
//  FamilyTime
//
//  Created by Sana Ullah on 05/12/2018.
//  Updated by Usama-Apps on 12/12/2022.
//  Copyright © 2018 YumyApps. All rights reserved.
//

import Foundation

typealias param_url_tuple = ([String :Any], String)

@objc(SwiftParamUtility)
class SwiftParamUtility:NSObject{
    
    //MARK: - Variables
    static let shared = SwiftParamUtility()
    let child_Id = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID) ?? ""
    
    //MARK: - Helper Functions
    func getUploadDailyLimitUsageParams(child_id:NSInteger) -> param_url_tuple{
        let params = ["push_type"  : "uploadDailyLimitUsage"]
        let urlString = SwiftAPIConstants.kUploadDailyLimitUsage_mesh2 + "\(child_id)"
        print("utility params = \(params) and url = \(urlString)")
        return (params,urlString)
    }
    
    func androidDailyLimitSaveSettingsParams(dailyLimit:LimitsData, installedApps:[AppLimits], duration:String,radian:String) -> [String:Any]{
        var ids: [AnyHashable] = []
        if installedApps.count > 0 {
            let apps = installedApps
            for app in apps {
                if app.inDailyLimit == 1 {
                    ids.append(["id" : app.installedappID ?? 0])
                }
            }
        }
        let params = [
            "is_active"  : dailyLimit.isActive ?? 0,
            "auto_add"   : dailyLimit.autoAdd ?? 0,
            "duration"   : duration,
            "radian"     : radian,
            "ids"        : ids
        ] as [String : Any]
        return params
    }
    
    func getParentDeviceParmas(address:String, lat:String, long:String, userId:String) -> [String:Any]{
        let language    = SwiftCommonUtility.shared.getCurrentLanguageFull()
        let timeZone    = NSTimeZone.local as NSTimeZone
        let tzName      = timeZone.name
        let appVersion  = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let build       = Bundle.main.infoDictionary!["CFBundleVersion"]!
        let deviceToken  = UserDefaults.standard.string(forKey: kDeviceToken)
        print("token = \(deviceToken ?? "")")
        var params = [String:Any]()
        params = ["accuracy"            : "",
                  "address"             : address ?? "",
                  "app_build"           : build,
                  "app_version"         : appVersion ?? "",
                  "battery_remaining"   : "",
                  "device_imei"         : "",
                  "device_language"     : language,
                  "device_manufacturer" : "Apple",
                  "device_model"        : UIDevice.modelName, //UIDevice.current.model,
                  "device_name"         : UIDevice.current.name,
                  "device_os"           : UIDevice.current.systemVersion,
                  "device_timezone"     : tzName,
                  "latitude"            : lat,
                  "longitude"           : long,
                  "signal_strength"     : "",
                  "wifi_name"           : SwiftCommonUtility.shared.getWiFiSsid() ?? "",
                  "push_token"          : deviceToken ?? "a21d93030b64215a1ee4e2e2d7715ba50875a747f854eddeb189681ddd1fdc6f",
                  
                  "device_unique_identity" : SwiftCommonUtility.shared.getMD5UniqueStringWithUserId(userId: userId)
        ]
        return params
    }
    
    
    func changeRuleParams(isActive:Bool, isNewRule:Bool, rule:RuleModel) -> [String:Any]{
        
        var params = ["rule_name"       : rule.rule_name ?? "",
                      "rule_type"       : rule.rule_type ?? "",
                      "rule_function"   : rule.rule_function ?? "",
                      "time_start"      : rule.time_start ?? "",
                      "time_end"        : rule.time_end ?? "",
                      "is_active"       : isActive,
                      "id"              : isNewRule ? "" : (rule.rule_id  ?? "")] as [String : Any] // [String:Any]
        
        params["on_monday"]     = rule.on_monday ?? ""
        params["on_tuesday"]    = rule.on_tuesday ?? ""
        params["on_wednesday"]  = rule.on_wednesday ?? ""
        params["on_thursday"]   = rule.on_thursday ?? ""
        params["on_friday"]     = rule.on_friday ?? ""
        params["on_saturday"]   = rule.on_saturday ?? ""
        params["on_sunday"]     = rule.on_sunday ?? ""
        
        print("params for schedule time = \(params)")
        return params
    }
    
    func changeInternetScheduleParams(isActive:Bool, isNewRule:Bool, rule:InternetScheduleInnerModel) -> [String:Any]{
        
        var params = ["rule_name"       : rule.rule_name ?? "",
                      "type"       : isNewRule ? "updateInternetSchedule" : "changeStatus", //rule.rule_type ?? "",
                      "time_start"      : rule.time_start ?? "",
                      "time_end"        : rule.time_end ?? "",
                      "is_active"       : isActive] as [String : Any] // [String:Any]
        
        params["is_monday"]     = rule.is_monday ?? ""
        params["is_tuesday"]    = rule.is_tuesday ?? ""
        params["is_wednesday"]  = rule.is_wednesday ?? ""
        params["is_thursday"]   = rule.is_thursday ?? ""
        params["is_friday"]     = rule.is_friday ?? ""
        params["is_saturday"]   = rule.is_saturday ?? ""
        params["is_sunday"]     = rule.is_sunday ?? ""
        
        print("params for Internet schedule = \(params)")
        return params
    }
    func childProfileUpdateParams(timezone: GMTTimezone, vc: ChildProfileVC) -> [String: Any] {
        guard let childIDInt = Int(child_Id) else {
            // Handle the error: childID is not a valid integer
            print("Error: childID is not a valid integer")
            return [:] // Return an empty dictionary or some default values
        }

        let child_info = DBManager.shared.fetchChild(byID: childIDInt)

//        let params: [String: Any] = [
//            "name": vc.nameTf.text ?? "",
//            "birthday": vc.dobTf.text ?? "",
//            "gender": child_info?.gender ?? "",
//            "relationship": (child_info?.gender == "Male") ? "Son" : "Daughter",
//            "color": child_info?.color ?? "",
//            "time_zone": timezone.name ?? "",
//            "phone": vc.phoneTf.text ?? "",
//            "email": vc.emailTf.text ?? ""
//        ]
        let params: [String: Any] = [
              "name": vc.nameTf.text ?? "",
              "dob": vc.dobTf.text ?? "",
              "child_id": childIDInt,
              "gender": child_info?.gender ?? "",
              "phone": vc.phoneTf.text ?? "",
              "email": vc.emailTf.text ?? "",
              "time_zone": timezone.name ?? "", // Assuming `timezone.name` returns a valid string
          ]
        
        print("params in param utility = \(params)")
        return params
    }

//    func childProfileUpdateParams(timezone:GMTTimezone, vc : ChildProfileVC) -> [String:Any]{
//        let child_info = CoreDataUtility.fetchChildInfoFromDatabase(child_id: child_Id)
//        let params = ["name"         : vc.nameTf.text ?? "",
//                      "birthday"     : vc.dobTf.text ?? "",
//                      "gender"       : child_info.gender ?? "",
//                      "relationship" : (child_info.gender == "Male") ? "Son" : "Daughter",
//                      "color"        : child_info.color ?? "",
//                      "time_zone"    : timezone.name ?? "",
//                      "phone"        : vc.phoneTf.text ?? "",
//                      "email"        : vc.emailTf.text ?? ""] as [String : Any]
//        
//        print("params in param utility = \(params)")
//        return params
//    }
}
