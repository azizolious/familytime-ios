//
//  swiftCommonModel.swift
//  FamilyTime
//
//  Created by YumyApps on 07/10/2021.
//  Copyright © 2021 YumyApps. All rights reserved.
//

import UIKit
import MBProgressHUD



class CommonModel {
    
    let delegate = UIApplication.shared.delegate as? AppDelegate
    let child_Id = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
    
    class func showAlert(_ title: String, msg: String?) {
        DispatchQueue.main.async(execute: {
            let alert = UIAlertView(title: title, message: msg, delegate: nil, cancelButtonTitle: "ok_button".localized)
            alert.show()
        })
    }
    
    class func showAlert2(_ title: String, msg: String) {
        
        DispatchQueue.main.async(execute: {
            let alert = UIAlertView(title: title, message: msg, delegate: nil, cancelButtonTitle: "TRY AGAIN".myModification(), otherButtonTitles: "SIGN UP".myModification())
            alert.delegate = self
            alert.tag = 101
            alert.show()
        })
    }
    
    class func isValidEmail(_ email: String) -> Bool {
        //        let emailReg = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        //        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailReg)
        //
        //        if emailTest.evaluate(with: email) != true {
        //            return false
        //        } else {
        //            return true
        //        }
        
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
        
    }
    
    //    func isValidEmail(_ email: String) -> Bool {
    //        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    //
    //        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    //        return emailPred.evaluate(with: email)
    //    }
    
    //    func isValidEmail() -> Bool {
    //            // here, `try!` will always succeed because the pattern is valid
    //            let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
    //            return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    //        }
    
    // MARK:- Keyboard Observer
    
    class func removeKeyBoardObserver(_ cont: UIViewController?) {
        if let cont = cont {
            NotificationCenter.default.removeObserver(
                cont,
                name: UIResponder.keyboardWillShowNotification,
                object: nil)
        }
        
        if let cont = cont {
            NotificationCenter.default.removeObserver(
                cont,
                name: UIResponder.keyboardWillHideNotification,
                object: nil)
        }
    }
    
    class func addKeyBoardObserver(_ cont: UIViewController?) {
        if let cont = cont {
            NotificationCenter.default.addObserver(
                cont, selector: #selector(keyboardWillShow),
                name: UIResponder.keyboardWillShowNotification,
                object: nil)
        }
        if let cont = cont {
            NotificationCenter.default.addObserver(
                cont,
                selector: #selector(keyboardWillHide),
                name: UIResponder.keyboardWillHideNotification,
                object: nil)
        }
    }
    
    @objc func keyboardWillShow() {
    }
    
    @objc func keyboardWillHide() {
    }
    
    //MARK:- Date
    class func currentDate() -> String? {
        //    2014-12-02 12:12:02"
        let df = DateFormatter()
        df.dateFormat = "YYYY-MM-dd HH:mm:ss"
        return df.string(from: Date())
        
    }
    
    class func date(_ date: String, oldFormat oldforamt: String, format: String) -> String {
        //    2014-12-02 12:12:02"
        let df = DateFormatter()
        df.locale = Locale(identifier: "en_US_POSIX")
        //    [df setLocale:[NSLocale systemLocale]];
        print("Great==\(NSLocale.system)")
        print("Date==\(date)")
        df.dateFormat = oldforamt
        
        var nDate = date
        
        if date == "" {
            nDate = df.string(from: Date())
        }
        
        let dateStr = df.date(from: nDate)
        df.dateFormat = format //@"YYYY-MM-dd HH:mm:ss"];
        print(df.string(from: dateStr ?? Date()))
        return df.string(from: dateStr ?? Date())
    }
    
    class func dateForLocationHistory(_ date: String) -> String {
        
        let fullName    = date
        let fullNameArr = fullName.components(separatedBy: " ")
        let name    = fullNameArr[0]
        
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: name)
        
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        let resultString = dateFormatter.string(from: date ?? Date())
        
        return resultString
    }
    
    class func convertedDateForSummeryScreen(_ date: String) -> String {
        
        let currentDate  = date
        let dateFormatter = DateFormatter()
        
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        let date = dateFormatter.date(from: currentDate)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let resultString = dateFormatter.string(from: date ?? Date())
        
        return resultString
    }
    
    class func currentDateForSummeryScreen(_ date:Date, formate:String) -> String {
        
        let currentDate = date
        
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = formate
        
        let date = dateFormatter.string(from: currentDate)
        return date
    }
    
    class func dateInDaysForSummeryScreen(_ date:String) -> String {
        
        let currentDate = date
        let dateFormatter = DateFormatter()
        
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        let date = dateFormatter.date(from: currentDate) ?? Date()
        dateFormatter.dateFormat = "d MMM"
        
        let result = dateFormatter.string(from: date)
        return result
    }
    
    class func dateInMonthsForSummeryScreen(_ date:String) -> String {
        
        let currentDate = date
        let dateFormatter = DateFormatter()
        
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        let date = dateFormatter.date(from: currentDate) ?? Date()
        dateFormatter.dateFormat = "d MMM"
        
        let result = dateFormatter.string(from: date)
        return result
    }
    
    class func dateForLocator(_ date: String) -> String {
        
        let fullName    = date
        let fullNameArr = fullName.components(separatedBy: " ")
        let name    = fullNameArr[0]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: name)
        dateFormatter.dateFormat = "MMM d, y"
        let resultString = dateFormatter.string(from: date ?? Date())
        
        return resultString
    }
    
    class func date2(_ date: String?, oldFormat oldforamt: String?, format: String?) -> Date? {
        var date = date
        //    2014-12-02 12:12:02"
        let df = DateFormatter()
        df.dateFormat = oldforamt
        if date == "" {
            date = df.string(from: Date())
        }
        let dateStr = df.date(from: date ?? "")
        df.dateFormat = format //@"YYYY-MM-dd HH:mm:ss"];
        
        return dateStr //[df dateFromString:[df stringFromDate:dateStr]];
        
    }
    
    class func date(withTimestamp date: String?) -> Date? {
        //    2014-12-02 12:12:02"
        let df = DateFormatter()
        df.locale = Locale(identifier: "en_US_POSIX")
        //    [df setLocale:[NSLocale systemLocale]];
        df.dateFormat = "YYYY-MM-dd HH:mm:ss"
        return df.date(from: date ?? "")
        
    }
    
    class func daysBetween(_ dt1: String?, and dt2: String?) -> Int {
        // TODO: import SwiftTryCatch from https://github.com/ypopovych/SwiftTryCatch
        
        let startDate = self.date(withTimestamp: dt1)
        let endDate = self.date(withTimestamp: dt2)
        
        let unitFlags = Set<Calendar.Component>([.minute]) //NSDayCalendarUnit;
        let calendar = Calendar(identifier: .gregorian)
        var components: DateComponents? = nil
        if let startDate = startDate, let endDate = endDate {
            components = calendar.dateComponents(unitFlags, from: startDate, to: endDate)
        }
        return Int(components?.minute ?? 0)
    }
    
    class func remaningTime(_ startDate: Date, end endDate: Date) -> String? {
        
        var components: DateComponents? = nil
        let days: Int
        let hour: Int
        let minutes: Int
        var durationString: String? = nil
        
        components = Calendar.current.dateComponents(
            [.day, .hour, .minute],
            from: startDate,
            to: endDate)
        days = (components?.day) ?? 0
        hour = (components?.hour) ?? 0
        minutes = (components?.minute) ?? 0
        
        if days > 0 {
            
            if days > 1 {
                durationString = String(format: "(%ld days)", Int(days))
            } else {
                durationString = String(format: "(%ld day)", Int(days))
            }
            return durationString
        }
        
        if hour > 0 {
            
            if hour > 1 {
                durationString = String(format: "(%ld hr)", Int(hour))
            } else {
                durationString = String(format: "(%ld hr)", Int(hour))
            }
            return durationString
        }
        
        if minutes > 0 {
            
            if minutes > 1 {
                durationString = String(format: "(%ld min)", Int(minutes))
            } else {
                durationString = String(format: "(%ld min)", Int(minutes))
            }
            return durationString
        }
        
        return ""
        
    }
    
    class func remaningTime(inDays startDate: Date, end endDate: Date) -> String? {
        
        var components: DateComponents? = nil
        var days: Int
        var durationString: String? = nil
        
        components = Calendar.current.dateComponents(
            [.day],
            from: startDate,
            to: endDate)
        days = (components?.day) ?? 0
        
        if days > 0 {
            
            if days > 1 {
                durationString = String(format: "%ld days", Int(days))
            } else {
                durationString = String(format: "%ld day", Int(days))
            }
            return durationString
        }
        return "Last day"
    }
    
    class func pushTime(_ sentTime: String) -> String? {
        
        var time = "" //2014-12-02 12:12:02
        
        let startDate = date(withTimestamp: sentTime)
        let endDate = Date() //[self dateWithTimestamp:dt2];
        
        var calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        
        let components = calendar.dateComponents([.minute], from: startDate!, to: endDate)
        calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let dayscomponent = calendar.dateComponents([.day], from: startDate!, to: endDate)
        
        if components.minute == 0 {
            time = "Just Now".myModification()
        } else if components.minute! < 60 {
            time = String(format: "\(String(describing: components.minute)) Minutes Ago")
        } else if components.minute! > 60 && components.minute! < 60 * 24 {
            time = String(format: "\(String(describing: (components.minute! / 60))) Hours Ago")
        } else if components.minute! > 60 * 24 && dayscomponent.day! < 7 {
            time = String(format: "\(dayscomponent.day!) Day(s) Ago")
        } else {
            time = date("", oldFormat: "YYYY-MM-dd HH:mm:ss", format: "EEEE dd MMM")
        }
        
        return time
        
    }
    
    //MARK:- Edit Plist
    
    class func resetPreference(_ fileName: String?) {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).map(\.path)
        let documentsDirectory = paths[0]
        let filePath = URL(fileURLWithPath: documentsDirectory).appendingPathComponent("\(fileName ?? "").plist").path
        let fm = FileManager.default
        
        if fm.fileExists(atPath: filePath) {
            do {
                try fm.removeItem(atPath: filePath)
            } catch {
            }
        }
    }
    
    class func setPreference(_ key: String?, value contact: [AnyHashable: Any]?) {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).map(\.path)
        let documentsDirectory = paths[0]
        let destPath = URL(fileURLWithPath: documentsDirectory).appendingPathComponent("\(key ?? "").plist").path
        
        let filePath = Bundle.main.path(forResource: key, ofType: "plist")
        
        // copy file to document folder
        let fm = FileManager.default
        if !fm.fileExists(atPath: destPath) {
            do {
                try fm.copyItem(atPath: filePath ?? "", toPath: destPath)
            } catch {
            }
        }
        
        var contactsArray = NSArray(contentsOfFile: destPath) as? [[AnyHashable: Any]]
        
        contactsArray?.append(contact!)
        (contactsArray as NSArray?)?.write(toFile: destPath, atomically: false)
        
    }
    
    class func getPreference(_ key: String?) -> String? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).map(\.path)
        let documentsDirectory = paths[0]
        let filePath = URL(fileURLWithPath: documentsDirectory).appendingPathComponent("\(key ?? "").plist").path
        // NSString * filePath = [[NSBundle mainBundle] pathForResource:key ofType:@"plist"];
        let array = NSArray(contentsOfFile: filePath) as? [AnyHashable]
        
        if array == nil {
            return ""
        }
        var jsonData: Data? = nil
        do {
            jsonData = try JSONSerialization.data(withJSONObject: array as Any, options: [])
        } catch {
        }
        var jsonString: String?
        
        if let bytes = jsonData {
            jsonString = String(bytes: bytes, encoding: .utf8)
        }
        //    NSLog(@"Dict:%@", jsonString);
        return jsonString
    }
    
    class func updatePreference(_ params: [String : Any]?, view cont: UIViewController?, isNotification isNotif: Bool) {
//        
//        let name = params?["name"] as? String
//        let value = params?["value"] as? String
//        let child_Id = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID) ?? ""
//        let preferences = CoreDataUtility.fetchPreferenceFromDatabase(child_id: child_Id)
//        print("dict in update pref = \(params ?? [:])")
//        SwiftFTUtils.showHUDAdded(to: cont!.view, withText: "Updating Preference...", animated: true)
//        var url = ""
//        let child_Info = CoreDataUtility.fetchChildInfoFromDatabase(child_id: child_Id)
//        if child_Info.plateformID == 1{
//            if isNotif {
//                url = String(format: "\(kChildSettings_Notif_Android_Mesh2)\(Int(child_Id) ?? 0)")
//            } else {
//                
//                //{{PARENT-URL}}/devices/{{CHILD-ID}}/set-passcode
//               // url = String(format: "https://core2.familytime.io/devices/\(Int(child_Id) ?? 0)/set-passcode")
//                url = String(format: "\(KChildUpdatePref_Android_Mesh2)\(Int(child_Id) ?? 0)")
//            }
//        } else {
//            if isNotif {
//                url = String(format: "\(kChildSettings_Notif_IOS_Mesh2)\(Int(child_Id) ?? 0)")
//            } else {
//                url = String(format: "\(KChildUpdatePref_IOS_Mesh2)\(Int(child_Id) ?? 0)")
//            }
//        }
//        print("Put Url = \(url) and params = \(String(describing: params))")
//        ApiManager.shared().putApi(url, params: params!, controller: cont!, isContPresented: false) { error, errorCode in
//            print(String(format: "api manager put api errorcode in common model = %ld", Int(errorCode)))
//            if errorCode == 200 {
//                //var preference: DashboardChildPreference? = nil
//                var preferenceData: PreferenceData? = nil
//                var notification: PreferenceData? = nil
//                print("NAME:- \(name ?? "")")
//                if name == "location_tracking" {
//                    preferenceData = SwiftCommonUtility.shared.getPreferencesForLockView(preferences, "location_tracking")
//                    preferenceData?.status = Int(value ?? "") ?? 0
//                } else if name == "monitor_places" {
//                    preferenceData = SwiftCommonUtility.shared.getPreferencesForLockView(preferences, "monitor_places")
//                    preferenceData?.status = Int(value ?? "") ?? 0
//                } else if name == "app_blocking" {
//                    preferenceData = SwiftCommonUtility.shared.getPreferencesForLockView(preferences, "app_blocking")
//                    preferenceData?.status = Int(value ?? "") ?? 0
//                } else if name == "call_logs" {
//                    preferenceData = SwiftCommonUtility.shared.getPreferencesForLockView(preferences, "call_logs")
//                    preferenceData?.status = Int(value ?? "") ?? 0
//                } else if name == "contact_logs" {
//                    preferenceData = SwiftCommonUtility.shared.getPreferencesForLockView(preferences, "contact_logs")
//                    preferenceData?.status = Int(value ?? "") ?? 0
//                } else if name == "bookmark_history" {
//                    preferenceData = SwiftCommonUtility.shared.getPreferencesForLockView(preferences, "bookmark_history")
//                    preferenceData?.status = Int(value ?? "") ?? 0
//                } else if name == "browsing_history" {
//                    preferenceData = SwiftCommonUtility.shared.getPreferencesForLockView(preferences, "browsing_history")
//                    preferenceData?.status = Int(value ?? "") ?? 0
//                }
//                //                else if name == "contact_watchlist" {
//                //                    preferenceData = SwiftCommonUtility.shared.getPreferencesForLockView(preferences, "contact_watchlist")
//                //                    preferenceData?.status = Int(value ?? "") ?? 0
//                //                }
//                else if name == "word_watchlist" {
//                    preferenceData = SwiftCommonUtility.shared.getPreferencesForLockView(preferences, "word_watchlist")
//                    preferenceData?.status = Int(value ?? "") ?? 0
//                } else if name == "phonelock_pin" {
//                    preferenceData = SwiftCommonUtility.shared.getPreferencesForLockView(preferences, "phonelock_pin")
//                    preferenceData?.status = Int(value ?? "") ?? 0
//                    preferenceData?.value = value ?? ""
//                    NotificationCenter.default.post(name: NSNotification.Name("PasscodeUpdateForChildAlert"), object: nil)
//                } else if name == "monitor_places_alert" {
//                    notification = SwiftCommonUtility.shared.getPreferencesForLockView(preferences, "monitor_places_alert")
//                    //appDeleg.selectedDashboardChild.getNotificationsWithName("monitor_places_alert")
//                    notification?.status = Int(value ?? "") ?? 0
//                } else if name == "sos_alert" {
//                    notification = SwiftCommonUtility.shared.getPreferencesForLockView(preferences, "sos_alert")
//                    //notification = appDeleg.selectedDashboardChild.getNotificationsWithName("sos_alert")
//                    notification?.status = Int(value ?? "") ?? 0
//                } else if name == "pickup_alert" {
//                    notification = SwiftCommonUtility.shared.getPreferencesForLockView(preferences, "pickup_alert")
//                    //notification = appDeleg.selectedDashboardChild.getNotificationsWithName("pickup_alert")
//                    notification?.status = Int(value ?? "") ?? 0
//                } else if name == "contact_watchlist_alert" {
//                    notification = SwiftCommonUtility.shared.getPreferencesForLockView(preferences, "contact_watchlist_alert")
//                    //notification = appDeleg.selectedDashboardChild.getNotificationsWithName("contact_watchlist_alert")
//                    notification?.status = Int(value ?? "") ?? 0
//                } else if name == "app_blocking_alert" {
//                    notification = SwiftCommonUtility.shared.getPreferencesForLockView(preferences, "app_blocking_alert")
//                    //notification = appDeleg.selectedDashboardChild.getNotificationsWithName("app_blocking_alert")
//                    notification?.status = Int(value ?? "") ?? 0
//                } else if name == "speed_limit_alert" {
//                    notification = SwiftCommonUtility.shared.getPreferencesForLockView(preferences, "speed_limit_alert")
//                    //notification = appDeleg.selectedDashboardChild.getNotificationsWithName("speed_limit_alert")
//                    notification?.status = Int(value ?? "") ?? 0
//                    notification?.value = value ?? ""
//                } else if name == "installed_app_logs" {
//                    preferenceData = SwiftCommonUtility.shared.getPreferencesForLockView(preferences, "installed_app_logs")
//                    //appDeleg.selectedDashboardChild.getPreferencesWithName("installed_app_logs")
//                    preferenceData?.status = Int(value ?? "") ?? 0
//                }
//                //                else if name == "web_history" {
//                //                    preferenceData = SwiftCommonUtility.shared.getPreferencesForLockView(preferences, "web_history")
//                //                    //preferenceData = appDeleg.selectedDashboardChild.getPreferencesWithName("safe_internet")
//                //                    preferenceData?.status = Int(value ?? "") ?? 0
//                //                }else if name == "yotutube_history" {
//                //                    preferenceData = SwiftCommonUtility.shared.getPreferencesForLockView(preferences, "yotutube_history")
//                //                    //preferenceData = appDeleg.selectedDashboardChild.getPreferencesWithName("safe_internet")
//                //                    preferenceData?.status = Int(value ?? "") ?? 0
//                //                }else if name == "tiktok_history" {
//                //                    preferenceData = SwiftCommonUtility.shared.getPreferencesForLockView(preferences, "tiktok_history")
//                //                    //preferenceData = appDeleg.selectedDashboardChild.getPreferencesWithName("safe_internet")
//                //                    preferenceData?.status = Int(value ?? "") ?? 0
//                //                }
//                else if name == "safe_internet" {
//                    preferenceData = SwiftCommonUtility.shared.getPreferencesForLockView(preferences, "safe_internet")
//                    //preferenceData = appDeleg.selectedDashboardChild.getPreferencesWithName("safe_internet")
//                    preferenceData?.status = Int(value ?? "") ?? 0
//                } else if name == "sms_logs" {
//                    preferenceData = SwiftCommonUtility.shared.getPreferencesForLockView(preferences, "sms_logs")
//                    //preferenceData = appDeleg.selectedDashboardChild.getPreferencesWithName("sms_logs")
//                    preferenceData?.status = Int(value ?? "") ?? 0
//                } else if name == "top_stack" {
//                    preferenceData = SwiftCommonUtility.shared.getPreferencesForLockView(preferences, "top_stack")
//                    //preferenceData = appDeleg.selectedDashboardChild.getPreferencesWithName("top_stack")
//                    preferenceData?.status = Int(value ?? "") ?? 0
//                }
//                CoreDataUtility.updateAllHomeData()
//                NotificationCenter.default.post(name: NSNotification.Name("kNotif_update_child_in_db"), object: nil)
//            }
//            
//            DispatchQueue.main.async(execute: {
//                MBProgressHUD.hideAllHUDs(for: cont!.view, animated: true)
//                if name == "contact_watchlist" {
//                    (cont as? SwiftContactsWatchListViewController)?.refreshView()
//                } else if cont!.responds(to: Selector(("lockChildPhone"))) && value!.count > 0 {
//                    let child_Info = CoreDataUtility.fetchChildInfoFromDatabase(child_id: child_Id)
//                    let obj = CoreDataUtility.fetchDashboardFromDatabaseNEW(childssID: child_Id)
//                    var data : ChildData!
//                    for i in obj{
//                        data = i
//                    }
////                    (cont as? DashboardVC)?.handleLock(with: child_Info, childData: data)
//                }
//            })
//         }
    }
    
    //MARK: - View Circular Animation
    class func runSpinAnimation(on view: UIView?, duration: CGFloat, rotations: CGFloat, `repeat`: Float) {
        var rotationAnimation: CABasicAnimation?
        rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation?.toValue = NSNumber(value: Float(.pi * 2.0 /* full rotation*/ * rotations * duration))
        rotationAnimation?.duration = CFTimeInterval(duration)
        rotationAnimation?.isCumulative = true
        rotationAnimation?.repeatCount = `repeat`
        
        if let rotationAnimation = rotationAnimation {
            view?.layer.add(rotationAnimation, forKey: "rotationAnimation")
        }
    }
    
    //#pragma store location in plist
    
    class func storeLocation(inPlist theLocation: CLLocationCoordinate2D) {
        
        var dict: [AnyHashable : Any] = [:]
        dict["latitude"] = NSNumber(value: Float(theLocation.latitude))
        dict["longitude"] = NSNumber(value: Float(theLocation.longitude))
        dict["time_in"] = CommonModel.currentDate()
        
        dict["time_out"] = CommonModel.currentDate
        dict["time_sent"] = CommonModel.currentDate
        
        var address: String? = nil
        let geoCoder = CLGeocoder()
        
        let newLocation = CLLocation(latitude: theLocation.latitude, longitude: theLocation.longitude)
        
        geoCoder.reverseGeocodeLocation(newLocation) { placemarksArray, error in
            
            let placemark = placemarksArray![0]
            if placemarksArray?.count != 0 {
                if let value = placemark.thoroughfare, let value1 = placemark.administrativeArea, let value2 = placemark.country {
                    address = "\(value) \(value1) \(value2)"
                }
                
            } else {
                address = ""
            }
            
            dict["location"] = address
            //Add the vallid location with good accuracy into an array
            //Every 1 minute, I will select the best location based on accuracy and send to server
            setPreference("locations", value: dict)
        }
        
    }
    
    //MARK:- Update Push Token
    
    class func updateDeviceToken() {
        
        //---NOT BEING CALLED---COZ UPDATE PARENT DEVICE API IS BEING CALLED ON DASHBOARD---//
        let deviceToken = AppDelegate().userDefault.value(forKey: "deviceToken") as? String
        
        if (deviceToken?.count ?? 0) <= 0 {
            CommonModel.showAlert("", msg: "Network error please try later")
        } else {
            let delegate = AppDelegate()
            let user_id = delegate.parent == nil ? String(format: "\(CommonModel().child_Id ?? "0")") : delegate.parent.user_id
            print(user_id ?? "")
        }
    }
    
    //MARK:- Color
    class func randomColor(_ r: Int) -> String? {
        
        if r == 1 {
            return "orange" //kOrangeColor;
        } else if r == 2 {
            return "green" //kGreenColor;
        } else if r == 3 {
            return "purple" //kPurpleColor;
        } else {
            return "red" //kredColor;
        }
    }
    
    // Assumes input like "#00FF00" (#RRGGBB).
    class func color(fromHexString hexString: String?) -> UIColor {
        
        if hexString == "orange" {
            return UIColor(red: 255, green: 132, blue: 0)
        } else if hexString == "green" {
            return UIColor(red: 162, green: 201, blue: 34)
        } else if hexString == "purple" {
            return UIColor(red: 114, green: 102, blue: 186)
        } else if hexString == "gray" {
            return RGBCOLOR(187, 187, 187, 1)
        } else if hexString == kDarkGray {
            return RGBCOLOR(76, 76, 76, 1)
        } else if hexString == "blue" {
            return UIColor(red: 29, green: 166, blue: 208)
        } else if hexString == "yellow" {
            return UIColor(red: 255, green: 184, blue: 29)
        } else {
            return UIColor(red: 240, green: 80, blue: 80)
        }
        
        var rgbValue: UInt = 0
        let scanner = Scanner(string: hexString!)
        scanner.scanLocation = 1 // bypass '#' character
        
        scanner.scanHexInt32(UnsafeMutablePointer<UInt32>(bitPattern: rgbValue))
        
        return UIColor(red: CGFloat(Double(((rgbValue & 0xff0000) >> 16)) / 255.0), green: CGFloat(Double(((rgbValue & 0xff00) >> 8))) / 255.0, blue: CGFloat(Double((rgbValue & 0xff)) / 255.0), alpha: 1.0)
        
    }
    
    class func getHoursMinutes(fromSeconds seconds: Int) -> String? {
        
        let minutes = (seconds / 60) % 60
        let hours = seconds / 3600
        return String(format: "%02ld"+"time_hours".localized+" : %02d"+"time_mintues".localized, Int(hours), minutes)
    }
    
    //MARK:- Lock Phone
    class func lockPhonePopup(_ view: UIViewController?) {
        SwiftFTUtils.showPopupPasscode(with: view, color: "red")
    }
    
    class func showAlertAndLogout(onVC vc: UIViewController?, isPresentedVC isPresent: Bool) {
        
        let alert = UIAlertController(
            title: NSLocalizedString("alert_error".localized, comment: ""),
            message: NSLocalizedString("logout_alert_content_2".localized, comment: ""),
            preferredStyle: .alert)
        
        let yesButton = UIAlertAction(
            title: NSLocalizedString("ok_button".localized, comment: ""),
            style: .default,
            handler: { action in
                //Handle your yes please button action here
                CommonModel.clearDataAndLogout(on: vc, isPresentedVC: isPresent)
            })
        
        alert.addAction(yesButton)
        vc!.present(alert, animated: true)
        
    }
    
    class func clearDataAndLogout(on vc: UIViewController?, isPresentedVC isPresentCont: Bool) {
        
        UserDefaults.standard.set(nil, forKey: kUserEmail)
        UserDefaults.standard.set(nil, forKey: kUserPassword)
        UserDefaults.standard.set(nil, forKey: kHeaderToken)
        UserDefaults.standard.set(nil, forKey: kLaunchAppHash)
        UserDefaults.standard.set(false, forKey: kEmailVerified)
        UserDefaults.standard.set(false, forKey: kChildAdded)
        UserDefaults.standard.set(false, forKey: "HasLaunchedOnce")
        UserDefaults.standard.set(false, forKey: "apiCalled")
        UserDefaults.standard.removeObject(forKey: "userRelation")
        UserDefaults.standard.removeObject(forKey: "userName")
        UserDefaults.standard.removeObject(forKey: UserDefaultsConstants.LAST_TIME_CLICKED_UPGRADE)
        UserDefaults.standard.removeObject(forKey: UserDefaultsConstants.LAST_TIME_CLICKED_TRIAL)
        UserDefaults.standard.removeObject(forKey: UserDefaultsConstants.BILLING_STATUS)
        UserDefaults.standard.removeObject(forKey: UserDefaultsConstants.CHILD_COUNT)
        UserDefaults.standard.removeObject(forKey: "CHILD_COUNTs")
        UserDefaults.standard.removeObject(forKey: UserDefaultsConstants.QR_CODE_STRING_VALUE)
        UserDefaults.standard.removeObject(forKey: UserDefaultsConstants.PRODUCT_ACCOUNT_ARRAY)
        UserDefaults.standard.removeObject(forKey: UserDefaultsConstants.SUBSCRIPTION_CHECK_KEY)
        UserDefaults.standard.removeObject(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        UserDefaults.standard.removeObject(forKey: UserDefaultsConstants.SHOW_SUB_INT_NOTIFICATION)
        UserDefaults.standard.removeObject(forKey: UserDefaultsConstants.SHOW_SUB_EXT_NOTIFICATION)
        UserDefaults.standard.removeObject(forKey: UserDefaultsConstants.PICK_UP_PANIC_NOTIFICATON)
        UserDefaults.standard.removeObject(forKey: "checkin-checkout")
        UserDefaults.standard.removeObject(forKey: "panic_string")
        UserDefaults.standard.removeObject(forKey: "pickup_panic")
        UserDefaults.standard.synchronize()
        UserDefaultsManager.bearerTokenCore2 = nil
        //        UserDefaults.standard.set(true, forKey: kDeviceToken)
        //        UserDefaults.standard.removeObject(forKey: kUserEmail)
        //        UserDefaults.standard.removeObject(forKey: kUserPassword)
        //        UserDefaults.standard.removeObject(forKey: kHeaderToken)
        //        UserDefaults.standard.removeObject(forKey: kLaunchAppHash)
        //        UserDefaults.standard.removeObject(forKey: kEmailVerified)
        //        UserDefaults.standard.removeObject(forKey: kChildAdded)
        //        UserDefaults.standard.removeObject(forKey: "HasLaunchedOnce")
        //        UserDefaults.standard.removeObject(forKey: kDeviceToken)
        
        //MARK: CLEARING DATABASE
        CoreDataUtility.deleteHomeData()
        let appDel = UIApplication.shared.delegate as? AppDelegate
        appDel?.userDefault.set(nil, forKey: "userID")
        appDel?.userDefault.setValue(nil, forKey: "LoginAuthToken")
        
        //        UserDefaults.standard.removeObject(forKey: "user")
        appDel?.userDefault.setValue(nil, forKey: "user")
        appDel?.userDefault.synchronize()
        //---FLAG TO UPDATE PARENT DEVICE DATA TO SERVER ONLY ONCE---//
        UserDefaults.standard.set(kYES, forKey: kUpdateParentDataOnce)
        UserDefaults.standard.synchronize()
        
        appDel?.dashboard = nil
        //        self.clearRealmDb()
        print(UserDefaults.standard.string(forKey: kDeviceToken))
        print("The value of Login AuthToken is ",appDel?.userDefault.string(forKey: "LoginAuthToken") ?? "nil")
        
        
        GIDSignIn.sharedInstance().signOut()
        
        if isPresentCont {
            vc!.dismiss(animated: true)
        }
        
        appDel?.setNavigationbarAppearence(true, cont: vc)
        appDel?.setupDrawer(2)
        
    }
    
    class func image(forHeaderSST ruleName: String?) -> UIImage? {
        
        if ruleName == "Bedtime" {
            return UIImage(named: "ic_moon")
        } else if ruleName == "Dinner Time" {
            return UIImage(named: "ic_dinner")
        } else if ruleName == "Homework Time" {
            return UIImage(named: "ic_homework")
        } else {
            return UIImage(named: "ic_white_clock")
        }
        
    }
    
    class func newImage(forHeaderSST ruleName: String?, isRuleActive isActive: Bool) -> UIImage? {
        
        if ruleName == "Bedtime" {
            return isActive ? UIImage(named: "st_moon_blue") : UIImage(named: "st_moon_gray")
        } else if ruleName == "Dinner Time" {
            return isActive ? UIImage(named: "st_dinner_blue") : UIImage(named: "st_dinner_gray")
        } else if ruleName == "Homework Time" {
            return isActive ? UIImage(named: "st_book_blue") : UIImage(named: "st_book_gray")
        } else {
            return isActive ? UIImage(named: "st_clock_blue") : UIImage(named: "st_clock_gray")
        }
        
    }
    
    class func newImage(forInternetSchedule ruleName: String?, isRuleActive isActive: Bool) -> UIImage? {
        if ruleName == "Weekends" {
            return isActive ? UIImage(named: "ic_weekeds") : UIImage(named: "ic_weekeds_gray")
        } else if ruleName == "Weekdays" {
            return isActive ? UIImage(named: "ic_weekdays") : UIImage(named: "ic_weekdays_gray")
        } else {
            return isActive ? UIImage(named: "ic_internet") : UIImage(named: "ic_internet_gray")
        }
    }
}
