//
//  BatteryLowPopUp.swift
//  FamilyTime
//
//  Created by Sufyan on 30/10/2023.
//  Copyright © 2023 YumyApps. All rights reserved.
//

import UIKit

class BatteryLowPopUp: UIViewController {

    @IBOutlet weak var batteryLowImg: UIImageView!
    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var childNameLbl: UILabel!
    @IBOutlet weak var cautionImg: UIImageView!
    @IBOutlet weak var bodyLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var okBtn: UIButton!
    
    @IBOutlet weak var stackToHide: UIStackView!
    
    var titleStr = ""
    var body = ""
    var subType = ""
    var childID = ""
    var time = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleStr = UserDefaults.standard.string(forKey: "lowBatterytitle") ?? ""
        body = UserDefaults.standard.string(forKey: "lowBatterybody") ?? ""
        subType = UserDefaults.standard.string(forKey: "lowBatterysubtype") ?? ""
        childID = UserDefaults.standard.string(forKey: "lowBatterydeviceId") ?? ""
        time = UserDefaults.standard.string(forKey: "lowBatteryRequestTime") ?? ""
        initUi()
        timeConvertAndShow()
    }

    func initUi () {
        switch subType {
        case "charging":
            okBtn.isHidden = false
            stackToHide.isHidden = true
            okBtn.setTitle("close_button".localized, for: .normal)
            okBtn.backgroundColor = UIColor(hexString: "#156CF7")
            cautionImg.image = UIImage(named: "cautionB")
            batteryLowImg.image = UIImage(named: "batteryCharging")
            break
        case "discharging":
            okBtn.isHidden = true
            stackToHide.isHidden = false
            cautionImg.image = UIImage(named: "caution")
            break
        case "acknowledged":
            batteryLowImg.image = UIImage(named: "batteryLow")
            okBtn.isHidden = false
            stackToHide.isHidden = true
            cautionImg.image = UIImage(named: "charging")
            break
        default:
            break
            
        }
        self.titleLbl.text = titleStr
        self.bodyLbl.text = body
        guard let childIDInt = Int(childID) else {
        // Handle the error: childID is not a valid integer
        print("Error: childID is not a valid integer")
        return
    }

    let childInfoObj = DBManager.shared.fetchChild(byID: childIDInt)
        
//        let childInfoObj = CoreDataUtility.fetchChildInfoFromDatabase(child_id: childID)
        childNameLbl.text = childInfoObj?.name
        if childInfoObj?.gender == "male" {
            avatarImg.image = UIImage(named: "avatar_boy1")
        } else {
            avatarImg.image = UIImage(named: "avatar_girl3")
        }
    }
    func convertToShortTimeString(_ dateString: String, dateFormat: String, timeFormat: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        
        if let date = dateFormatter.date(from: dateString) {
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = timeFormat
            let shortTimeString = timeFormatter.string(from: date)
            return shortTimeString
        } else {
            print("Invalid date format or string.")
            return nil
        }
    }
    func timeConvertAndShow() {
        let seconds  = NSDate.secondsDifferenceFromCurrent(toDateString: time)
        if seconds < 0 {
            let shortTimeString = convertToShortTimeString(time, dateFormat: "yyyy-MM-dd HH:mm:ss", timeFormat: "h:mm a")
            timeLbl.text = shortTimeString
            return
        }
        var string = "\(seconds) ago"
        if seconds < 60 {
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
//            let time = seconds/86400
//            //let replaced2 = string.replacingOccurrences(of: "5", with: "\(time)")
//            timeLbl.text = "\(time)" + " day ago"
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
    @IBAction func closeBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func sendAdvicePress(_ sender: Any) {
        SwiftFTUtils.showHUDAdded(to: self.view, withText: "", animated: true)
        HLApiManager.chargeDeviceRequest(childId: childID) {
            SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func okBtnPress(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    
}
