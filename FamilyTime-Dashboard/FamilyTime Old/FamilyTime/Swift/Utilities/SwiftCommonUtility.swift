//
//  SwiftCommonUtility.swift
//  FamilyTime
//
//  Created by Sana Ullah on 28/11/2018.
//  Copyright © 2018 YumyApps. All rights reserved.
//

import Foundation
import PopMenu
import SystemConfiguration.CaptiveNetwork
import UserNotifications

@objc(SwiftCommonUtility)
class SwiftCommonUtility:NSObject{
    
    static let shared = SwiftCommonUtility()
    
  func getPopupMenuManager() -> PopMenuManager{
        let manager = PopMenuManager() //PopMenuManager.default
        
        manager.popMenuAppearance.popMenuColor.backgroundColor = .solid(fill: .white)
        manager.popMenuAppearance.popMenuColor.actionColor     = PopMenuActionColor.tint(UIColor.darkGray)
        manager.popMenuAppearance.popMenuFont                  =  UIFont.systemFont(ofSize: 15.0) //UIFont(name: "OpenSans-Regular", size: 15) ?? UIFont()
        manager.popMenuAppearance.popMenuCornerRadius          = 5
        
        return manager
    }
    
    static func getWindow() -> UIWindow? {
        return UIApplication.shared.keyWindow
    }

    static func resetViewController() {
        
        let appDe = UIApplication.shared.delegate as? AppDelegate
        
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "DashboardRootNavig") as? UINavigationController
        appDe?.window?.rootViewController = vc
        appDe?.window?.makeKeyAndVisible()
        DispatchQueue.main.async {
            Global.setlanguage()
        }
        appDe?.setNavigationbarAppearence(false)
        appDe?.setupDrawer(0)
        
    }
    
    func isIosChild(info:String) -> Bool{
        if info == "7"  || info == "10" {
            return true
        }
        return false
    }
    
    func getGeorgianStartDate() -> Date{
        var startDate = Date()
        let gregorian = Calendar(identifier: .gregorian)
        var components: DateComponents? = gregorian.dateComponents(Set<Calendar.Component>(), from: startDate)
        components?.hour   = 12
        components?.minute = 0
        components?.second = 0
        startDate = gregorian.date(from: components ?? DateComponents()) ?? Date()
        
        return startDate
    }
    
//    func getColorFrom(r:int, g:int, b:int, a:int) -> UIColor{
//        return UIColor.colorwith
//    }
    
    func getCurrentLanguageFull() -> String{
        let langCode = Locale.preferredLanguages[0]
        
        if langCode == "en-US" || langCode == "en"{
            return "English"
        }
        else if langCode == "es"{
            return "Spanish"
        }
        else if langCode == "fi"{
            return "Finnish"
        }
        else if langCode == "ja"{
            return "Japanese"
        }
        else if langCode == "pt"{
            return "Portugues"
        }
        else if langCode == "de"{
            return "Deutsch"
        }
        else if langCode == "fr"{
            return "French"
        }
        
        return "English"
    }
    
    func getCurrentLanguageCode() -> String{
        let langCode = Locale.preferredLanguages[0]
        
        if langCode == "en-US" || langCode == "en"{
            return "en"
        }
        else if langCode == "es"{
            return "es"
        }
        else if langCode == "fi"{
            return "fi"
        }
        else if langCode == "ja"{
            return "ja"
        }
        else if langCode == "pt"{
            return "pt"
        }
        else if langCode == "de"{
            return "de"
        }
        else if langCode == "fr"{
            return "fr"
        }else if langCode == "zh"{
            return "zh"
        }else if langCode == "ar"{
            return "ar"
        }else if langCode == "it"{
            return "it"
        }else if langCode == "he"{
            return "he"
        }else if langCode == "tur"{
            return "tur"
        }
        
        return "en"
    }
    
    func getAdressName(coords: CLLocation, completion : @escaping ((String) -> ())) {
        var adressString : String = ""
        CLGeocoder().reverseGeocodeLocation(coords) { (placemark, error) in
            if error != nil {
                print("Hay un error")
            } else {
                
                print("location = \(coords)")
                
                let place = placemark! as [CLPlacemark]
                if place.count > 0 {
                    let place = placemark![0]
                    
                    if place.thoroughfare != nil {
                        adressString = adressString + (place.thoroughfare ?? "") + ", "
                    }
                    if place.subThoroughfare != nil {
                        adressString = adressString + (place.subThoroughfare ?? "")
                    }
                    if place.locality != nil {
                        adressString = adressString + (place.locality ?? "") + " - "
                    }
                    if place.postalCode != nil {
                        adressString = adressString + (place.postalCode ?? "")
                    }
                    if place.subAdministrativeArea != nil {
                        adressString = adressString + (place.subAdministrativeArea ?? "") + " - "
                    }
                    if place.country != nil {
                        adressString = adressString + (place.country ?? "")
                    }
                    
                    completion(adressString)
                }
            }
        }
    }
    
    
    func getWiFiSsid() -> String? {
        var ssid: String?
        if let interfaces = CNCopySupportedInterfaces() as NSArray? {
            for interface in interfaces {
                if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                    ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
                    break
                }
            }
        }
        return ssid
    }
    
    
    func getMD5UniqueStringWithUserId(userId:String) -> String{
        let uniqueStr = userId + UIDevice.current.name + UIDevice.modelName
        return uniqueStr.MD5
    }
    
    //---DASHBOARD VC METHODS---//
    
    func getTransLayerFrame(view:UIView) -> CGRect{
        //setup transparent layer
        var frame: CGRect = view.frame
        frame.origin.y = 0
        frame.size.height += 100
        if UI_USER_INTERFACE_IDIOM() == .pad {
            frame.size.width  = 786
            frame.size.height = 1024
        }
        
        
        if (UIDevice.current.userInterfaceIdiom == .phone && max(UIScreen.main.bounds.size.height, UIScreen.main.bounds.size.width) == 667) {
            frame.size.width = 375
        } else if (UIDevice.current.userInterfaceIdiom == .phone && max(UIScreen.main.bounds.size.height, UIScreen.main.bounds.size.width) == 736) {
            frame.size.width = 414
        }
        return frame
    }
    
    func getTopBarBtnWithIcon(iconName:String) -> UIButton{
        let image2 = UIImage(named: iconName)
        let myCustomButton = UIButton(type: .custom)
        myCustomButton.bounds = CGRect(x: 0, y: 0, width: image2?.size.width ?? 0.0, height: image2?.size.height ?? 0.0)
        myCustomButton.setImage(image2, for: .normal)
        
        return myCustomButton
    }
    
    func getParsedTimeInSeconds(time:String) -> CGFloat{
        
        let fullArray = time.components(separatedBy: ":")
        print("hour = \(fullArray[0]) minutes = = \(fullArray[1]) seconds = = \(fullArray[2])")
        
        guard let hours = Int(fullArray[0]) else { return  0.0}
        guard let mins = Int(fullArray[1]) else { return  0.0}
        guard let seconds = Int(fullArray[2]) else { return  0.0}
        
        let totalSeconds = (hours * 3600) + (mins * 60) + seconds
        print("total seconds = \(totalSeconds)")
        
        return CGFloat(totalSeconds)
    }
    
    func getFormatedTimeForRuleWith(time:String, amPm:String) -> String{
        var dateAsString = time + " " + amPm
        let locale = NSLocale.current
          let formatter : String = DateFormatter.dateFormat(fromTemplate: "j", options:0, locale:locale) ?? ""
          if formatter.contains("a") {
            dateAsString = time + " " + amPm
          } else {
            dateAsString = time
          }
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let date = dateFormatter.date(from: dateAsString)
        
        dateFormatter.dateFormat = "HH:mm:ss"
        let startEndTime = dateFormatter.string(from: date ?? Date())
//        rule.time_start = Startdate24
        return startEndTime
    }
    
    //---FOR INTERNET SCHEDULE TIME---//
    func getFormatedTimeForInternetScheduleWith(time:String) -> String{
        let dateAsString = time
        let dateFormatter = DateFormatter()
        let locale = Locale.current.identifier
        dateFormatter.calendar = Calendar.current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.locale = Locale(identifier: locale)
        let date24 = dateFormatter.date(from: dateAsString)
        dateFormatter.dateFormat = "HH:mm:ss"
        let date12 = dateFormatter.string(from: date24 ?? Date())
        return date12
    }
    
    //---FOR INTERNET SCHEDULE TIME---//
    func getParsedTimeInMinutes(time:String) -> Int{
        
        let fullArray = time.components(separatedBy: ":")
        print("hour = \(fullArray[0]) minutes = = \(fullArray[1]) seconds = = \(fullArray[2])")
        
        guard let hours   = Int(fullArray[0]) else { return  0}
        guard let mins    = Int(fullArray[1]) else { return  0}
//        guard let seconds = Int(fullArray[2]) else { return  0.0}
        
//        let totalSeconds  = (hours * 3600) + (mins * 60) + seconds
        
        let totalMinutes  = (hours * 60) + mins //+ seconds
        
        print("total minutes = \(totalMinutes)")
        
        return Int(totalMinutes)
    }
    
    func getInitializedNewRule() -> RuleModel{
        let rule = RuleModel()
        
        rule.rule_type      = "timebased"
        rule.rule_function  = "phonelock"
        rule.time_start     = "23:59:00"
        rule.time_end       = "02:00:00"
        rule.on_sunday      = "1"
        rule.on_monday      = "1"
        rule.on_tuesday     = "1"
        rule.on_wednesday   = "1"
        rule.on_thursday    = "1"
        rule.on_friday      = "1"
        rule.on_saturday    = "1"
        rule.is_active      = "1"
        
        return rule
    }
    
    func getInitializedNewInternetSchedule() -> InternetScheduleInnerModel{
        let rule = InternetScheduleInnerModel()
        
//        rule.rule_type      = "timebased"
//        rule.rule_function  = "phonelock"
        rule.time_start     = "23:59:00"
        rule.time_end       = "02:00:00"
        rule.is_sunday      = "0"
        rule.is_monday      = "0"
        rule.is_tuesday     = "0"
        rule.is_wednesday   = "0"
        rule.is_thursday    = "0"
        rule.is_friday      = "0"
        rule.is_saturday    = "0"
        rule.is_active      = "1"
        
        return rule
    }
    func getPreferenceWithName(child:Child, name:String) -> PreferenceData? {
//        if let preferences = child.preferences {
//            for preference in preferences {
//                if name == preference.name {
//                    return preference
//                }
//            }
//        }
        return nil
    }
    
    func getPreferencesWithName(_ name: String?) -> PreferenceData? {
        let preferences = [PreferenceData]()
        for preference in preferences {
            if preference.name == name {
                return preference
            }
        }
        return nil
    }
    
    
    func getPreferencesForLockView(_ prefference: [PreferenceData],_ name: String?) -> PreferenceData? {
        for pref in prefference {
            if pref.name == name {
                return pref
            }
        }
        return nil
    }
    
    func getPackageFeature(withName name: String?) -> Package_features_Model? {
        let package_feature = [Package_features_Model]()
        for feature in package_feature {
            print(String(format: "child package feature name = %@ and isapplied = %ld", feature.feature_name, Int(feature.package_id)))
            if feature.feature_name == name {
                return feature
            }
        }
        return nil
    }
}
