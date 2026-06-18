//
//  CommonPopupVC.swift
//  FamilyTime
//
//  Created by Sana Ullah on 25/03/2019.
//  Copyright © 2019 YumyApps. All rights reserved.
//

import UIKit

class CommonPopupVC: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var topImageVu:      UIImageView!
    @IBOutlet weak var avatarImageVu:   UIImageView!
    @IBOutlet weak var titleLbl:        UILabel!
    @IBOutlet weak var descriptionLbl:  UILabel!
    @IBOutlet weak var nameLbl:         UILabel!
    @IBOutlet weak var timeLbl:         UILabel!
    @IBOutlet weak var addressLbl:      UILabel!
    @IBOutlet weak var accuracyLbl:     UILabel!
    @IBOutlet weak var gotItBtn:        UIButton!
    @IBOutlet weak var directionBtn:    UIButton!
    @IBOutlet weak var comingBtn:       UIButton!
    @IBOutlet weak var icontBtn:        UIButton!
    @IBOutlet weak var pickupButtonsVu: UIView!
    
    //MARK: - Variables
    var delegate : AppDelegate?
    //MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = AppDelegate.getSharedAppDelegateForSwift()
        self.initialization()
    }
    
    //MARK: - IBActions
    @IBAction func closeAction(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "checkin-checkout")
        UserDefaults.standard.set(false, forKey: "sos_pickup")
        UserDefaults.standard.removeObject(forKey: "genderStr")
        UserDefaults.standard.removeObject(forKey: "push_time")
        UserDefaults.standard.removeObject(forKey: "senderid")
        UserDefaults.standard.removeObject(forKey: "push_content")
        UserDefaults.standard.removeObject(forKey: "user_name_str")
        UserDefaults.standard.removeObject(forKey: "address_str")
        UserDefaults.standard.removeObject(forKey: "pushAccuracy")
        UserDefaults.standard.set("", forKey: "lat_str")
        UserDefaults.standard.set("", forKey: "long_str")
        UserDefaults.standard.set("", forKey: "panicSOS_string")
        UserDefaults.standard.synchronize()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func yesAction(_ sender: Any) {
        //let childId = UserDefaults.standard.string(forKey: "push_child_id") ?? ""
        let childId = UserDefaults.standard.string(forKey: "senderid") ?? ""
        apiCallWith(message: "".localized, url: SwiftAPIConstants.kSosPickUpBack + "\(childId)/sos")
    }
    
    @IBAction func comingAction(_ sender: Any) {
        //let childId = UserDefaults.standard.string(forKey: "push_child_id") ?? ""
        let childId = UserDefaults.standard.string(forKey: "senderid") ?? ""
        apiCallWith(message: "coming", url: SwiftAPIConstants.kSosPickUpBack + "\(childId)/pick-me-up")
    }
    
    @IBAction func cantAction(_ sender: Any) {
        //let childId = UserDefaults.standard.string(forKey: "push_child_id") ?? ""
        let childId = UserDefaults.standard.string(forKey: "senderid") ?? ""
        apiCallWith(message: "not_coming", url: SwiftAPIConstants.kSosPickUpBack + "\(childId)/pick-me-up")
    }
    
    @IBAction func directionAction(_ sender: Any) {
        let latStr = UserDefaults.standard.string(forKey: "lat_str")
        let longStr = UserDefaults.standard.string(forKey: "long_str")
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            if let url = URL(string: "comgooglemaps-x-callback://?saddr=&daddr=\(latStr ?? "3.00485"),\(longStr ?? "74.102369")&directionsmode=driving") {
                UIApplication.shared.open(url, options: [:])
            }
        } else {
            if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(latStr ?? "30.00485"),\(longStr ?? "74.102369")&directionsmode=driving") {
                UIApplication.shared.open(urlDestination)
            }
        }
    }
    
    //MARK: - Helper Functions
    func initialization(){
        UserDefaults.standard.removeObject(forKey: "sos_pickup")
        UserDefaults.standard.synchronize()
        let pushtYpeStr = UserDefaults.standard.string(forKey: "panicSOS_string")
        if pushtYpeStr == "panic"{
            setUp()
        } else if pushtYpeStr == "pick_me_up" {
            setUp()
        } else {
            setUp()
        }
    }
    
    func setUp() {
        let genderStr = UserDefaults.standard.string(forKey: "genderStr")
        let pushtimeStr = UserDefaults.standard.string(forKey: "push_time")
        let pushContentStr = UserDefaults.standard.string(forKey: "push_content")
        let sendernameStr = UserDefaults.standard.string(forKey: "user_name_str")
        let addressStr = UserDefaults.standard.string(forKey: "address_str")
        let pushtYpeStr = UserDefaults.standard.string(forKey: "panicSOS_string")
        let accuracy =  UserDefaults.standard.string(forKey: "pushAccuracy") ?? ""
        accuracyLbl.text = "alert_check_in_content_2".localized + ": " + accuracy + "m"
        let df = DateFormatter()
        df.locale = Locale(identifier: "en_US_POSIX")
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let pushDate_d = df.date(from: pushtimeStr ?? "") {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "hh:mm a"
            formatter.amSymbol = "AM"
            formatter.pmSymbol = "PM"
            let pushTime = formatter.string(from: pushDate_d)
            //timeLbl.text = pushTime
        }
        avatarImageVu.image = genderStr == "female" ? #imageLiteral(resourceName: "popup_avatar_girl") : #imageLiteral(resourceName: "popup_avatar_boy")
        descriptionLbl.text = pushContentStr ?? ""
        nameLbl.text        = sendernameStr ?? "MY KID"
        addressLbl.text     = addressStr ?? "pakistan"
        //accuracyLbl.isHidden = true
        
        if delegate?.childPush.pushType == "panic" || pushtYpeStr == "panic" || delegate?.childPush.typeCore == "sos" {
            panicNav()
        } else if delegate?.childPush.pushType == "pickup" || pushtYpeStr == "pick_me_up" || delegate?.childPush.typeCore == "pickup" {
            pickupNav()
        } else if delegate?.childPush.pushType == "checkin" {
            checkInNavigate()
        } else if delegate?.childPush.pushType == "checkout" {
            checkOutNavigate()
        }
    }
    func panicNav(){
        let pushtimeStr = UserDefaults.standard.string(forKey: "push_time")
        topImageVu.image    = #imageLiteral(resourceName: "so_image")
        titleLbl.text       = "alert_sos".localized
        let sendernameStr = UserDefaults.standard.string(forKey: "user_name_str")
        let alertText = "There is an urgent need to getting touch with \(sendernameStr ?? "") as they are currently going through a state of panic. Please reach out to them as soon as possible"
        descriptionLbl.text = alertText
        gotItBtn.setTitle("alert_sos_button".myModification(), for: .normal)
        gotItBtn.isHidden = false
        pickupButtonsVu.isHidden = true
        let seconds  = NSDate.secondsDifferenceFromCurrent(toDateString: pushtimeStr)
        var string = "\(seconds) ago"
        
        // MARK: - USING SWITCH CASES
        
//        switch seconds{
//        case 86400:
//            timeLbl.text = "day_ago".localized
//        case 3600:
//            timeLbl.text = "time_hour_ago".localized
//        case 60:
//            timeLbl.text = "time_minute_ago".localized
//        case 1:
//            timeLbl.text = "time_hour_ago".localized
//        case 86400...:
//            timeLbl.text = "time_hour_ago".localized
//        case 3600...:
//            timeLbl.text = "time_hour_ago".localized
//        case 60...:
//            timeLbl.text = "time_hour_ago".localized
//        default:
//            string = "time_seconds_ago".localized
//            let replaced2 = string.replacingOccurrences(of: "5", with: "\(seconds)")
//            timeLbl.text = replaced2
//        }
        if seconds < 0 {
            let shortTimeString = convertToShortTimeString(pushtimeStr ?? "2023-12-05 12:28:15", dateFormat: "yyyy-MM-dd HH:mm:ss", timeFormat: "h:mm a")
            timeLbl.text = shortTimeString
        }else if seconds < 60 {
             let str =  String("time_seconds_ago".localized.dropFirst())
            timeLbl.text = "\(seconds)" + str
        }else if seconds >= 60 && seconds < 3600 {
            let minute = seconds/60
            let str =  String("time_minute_ago".localized.dropFirst())
            timeLbl.text = "\(minute)" + str
        } else if seconds >= 3600 && seconds < 86400 {
            let hour = seconds/3600
            let str =  String("time_hour_ago".localized.dropFirst())
            timeLbl.text = "\(hour)" + str
        } else if seconds >= 86400 {
            let days = seconds/86400
            let str =  String("days_ago".localized.dropFirst())
            timeLbl.text = "\(days)"+str
        }
        
//        if seconds == 86400 {
//            timeLbl.text = "day_ago".localized
//        } else if seconds == 3600 {
//            timeLbl.text = "time_hour_ago".localized
//        } else if seconds == 60 {
//            timeLbl.text = "time_minute_ago".localized
//        } else if seconds == 1 {
//            timeLbl.text = "time_second_ago".localized
//        } else if seconds > 86400 {
//            timeLbl.text = "days_ago".localized
//            let replaced2 = string.replacingOccurrences(of: "5", with: "\(seconds/86400)")
//            timeLbl.text = replaced2
//        }else if seconds > 3600{
//            string = "time_hours_ago".localized
//            let replaced2 = string.replacingOccurrences(of: "5", with: "\(seconds/3600)")
//            timeLbl.text = replaced2
//        } else if seconds > 60 {
//            string = "time_minutes_ago".localized
//            let replaced2 = string.replacingOccurrences(of: "5", with: "\(seconds/60)")
//            timeLbl.text = replaced2
//        } else {
//            string = "time_seconds_ago".localized
//            let replaced2 = string.replacingOccurrences(of: "5", with: "\(seconds)")
//            timeLbl.text = replaced2
//        }
    }
    func convertToShortTimeString(_ dateString: String, dateFormat: String, timeFormat: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        if let date = dateFormatter.date(from: dateString) {
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = timeFormat
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            let shortTimeString = timeFormatter.string(from: date)
            return shortTimeString
        } else {
            print("Invalid date format or string.")
            return nil
        }
    }
    func pickupNav(){
        let pushtimeStr = UserDefaults.standard.string(forKey: "push_time")
        let sendernameStr = UserDefaults.standard.string(forKey: "user_name_str")
        let alertText = "You received a reminder from \(sendernameStr ?? "") to pick them up. Kindly inform them if you plan to do so or not."
        topImageVu.image    = #imageLiteral(resourceName: "popup_pickup")
        titleLbl.text       = "alert_pick_me_up".localized
        let str = "alert_pick_me_up_content_1".localized
        let replaced = str.replacingOccurrences(of: "Jack", with:  sendernameStr ?? "child")
        descriptionLbl.text = alertText
        comingBtn.setTitle("alert_pick_me_up_button_1".localized, for: .normal)
        icontBtn.setTitle("alert_pick_me_up_button_2".localized, for: .normal)
        gotItBtn.isHidden = true
        pickupButtonsVu.isHidden = false
        let seconds  = NSDate.secondsDifferenceFromCurrent(toDateString: pushtimeStr ?? "")
        if seconds < 0 {
            let shortTimeString = convertToShortTimeString(pushtimeStr ?? "2023-12-05 12:28:15", dateFormat: "yyyy-MM-dd HH:mm:ss", timeFormat: "h:mm a")
            timeLbl.text = shortTimeString
        }else if seconds < 60 {
            let str =  String("time_seconds_ago".localized.dropFirst())
           timeLbl.text = "\(seconds)" + str
       }else if seconds >= 60 && seconds < 3600 {
           let minute = seconds/60
           let str =  String("time_minute_ago".localized.dropFirst())
           timeLbl.text = "\(minute)" + str
       } else if seconds >= 3600 && seconds < 86400 {
           let hour = seconds/3600
           let str =  String("time_hour_ago".localized.dropFirst())
           timeLbl.text = "\(hour)" + str
       } else if seconds >= 86400 {
           let days = seconds/86400
           let str =  String("days_ago".localized.dropFirst())
           timeLbl.text = "\(days)"+str
       }
//        var string = "\(seconds) ago"
//        if seconds == 86400 {
//            timeLbl.text = "day_ago".localized
//        } else if seconds == 3600 {
//            timeLbl.text = "time_hour_ago".localized
//        } else if seconds == 60 {
//            timeLbl.text = "time_minute_ago".localized
//        } else if seconds == 1 {
//            timeLbl.text = "time_second_ago".localized
//        } else if seconds > 86400 {
//            timeLbl.text = "days_ago".localized
//            let replaced2 = string.replacingOccurrences(of: "5", with: "\(seconds/86400)")
//            timeLbl.text = replaced2
//        } else if seconds > 3600 {
//            string = "time_hours_ago".localized
//            let replaced2 = string.replacingOccurrences(of: "5", with: "\(seconds/3600)")
//            timeLbl.text = replaced2
//        } else if seconds > 60 {
//            string = "time_minutes_ago".localized
//            let replaced2 = string.replacingOccurrences(of: "5", with: "\(seconds/60)")
//            timeLbl.text = replaced2
//        }
    }
    func checkInNavigate(){
        gotItBtn.isHidden = true
        pickupButtonsVu.isHidden = true
        let str = "alert_check_in_content_1".localized
        let replaced = str.replacingOccurrences(of: "home", with:  delegate?.childPush.placeName ?? "home")
        descriptionLbl.text = replaced
    }
    func checkOutNavigate(){
        gotItBtn.isHidden = true
        pickupButtonsVu.isHidden = true
        let str = "alert_check_out_content_1".localized
        let replaced = str.replacingOccurrences(of: "home", with:  delegate?.childPush.placeName ?? "home")
        descriptionLbl.text = replaced
    }
    
    func apiCallWith(message:String?, url:String) {
        self.view.makeToast("sending_toast".localized)
        var param : [String: Any]?
        if message == "not_coming" || message == "coming" {
            param = [ "push_type" : message ?? ""]
        } else {
            param = nil
        }
        print("update parent info Params: \(String(describing: param)) and url = \(url)")
        SwiftFTUtils.showHUDAdded(to: self.view, withText: "", animated: true)
        ApiManager.shared().putApiSOS(url, params: param ?? [String : Any](), controller: self, isContPresented: false) { (message, status) in
            DispatchQueue.main.async{
                SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
                if (status == 200 || status == 201 || status == 202 || status == 204 || status == 206){
                        DispatchQueue.main.async {
                            self.view.makeToast("message_sent_toast".localized)
                        }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.navigateRootViewController()
                    }
                } else {
                    print("push back api failed with message = \(message) and code = \(status)")
                    let alert = UIAlertController(title: "FamilyTime Dashboard".localized, message: message, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "alert_try_again".localized, style: UIAlertAction.Style.cancel, handler:nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    func navigateRootViewController(){
        UserDefaults.standard.set(false, forKey: "checkin-checkout")
        UserDefaults.standard.set(false, forKey: "sos_pickup")
        UserDefaults.standard.removeObject(forKey: "genderStr")
        UserDefaults.standard.removeObject(forKey: "push_time")
        UserDefaults.standard.removeObject(forKey: "senderid")
        UserDefaults.standard.removeObject(forKey: "push_content")
        UserDefaults.standard.removeObject(forKey: "user_name_str")
        UserDefaults.standard.removeObject(forKey: "address_str")
        UserDefaults.standard.set("", forKey: "lat_str")
        UserDefaults.standard.set("", forKey: "long_str")
        UserDefaults.standard.set("", forKey: "panicSOS_string")
        UserDefaults.standard.synchronize()
        dismiss(animated: true, completion: nil)
    }
}
