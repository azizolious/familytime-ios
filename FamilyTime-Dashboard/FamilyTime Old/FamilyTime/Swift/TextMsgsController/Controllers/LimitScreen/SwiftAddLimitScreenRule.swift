//
//  SwiftLimitScreenRule.swift
//  FamilyTime
//
//  Created by YumyApps on 04/11/2021.
//  Copyright © 2021 YumyApps. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire

class SwiftLimitScreenRuleStatusView: UIView {
    
    var imageView = UIImageView()
    var statusLabel = UILabel()
    var statusSwitch = UISwitch()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        backgroundColor = RGBCOLOR(16, 132, 180, 1)
        imageView = UIImageView(frame: CGRect.zero)
        imageView.image = UIImage(named: "ic_white_clock")
        addSubview(imageView)
        
        statusLabel = UILabel(frame: CGRect.zero)
        statusLabel.textColor = UIColor.white
        statusLabel.textAlignment = .left
        statusLabel.text = "Enabled"
        addSubview(statusLabel)
        
        statusSwitch = UISwitch(frame: CGRect.zero)
        statusSwitch.onTintColor = RGBCOLOR(24, 167, 225, 1)
        statusSwitch.isOn = true
        addSubview(statusSwitch)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var labelFont: CGFloat = 0.0
        
        if iPhone4 {
            
            labelFont = 14.0
            
        } else if iPhone5 {
            
            labelFont = 14.0
            
        } else if iPhone6 {
            
            labelFont = 15.0
            
        } else if iPhone6Plus {
            
            labelFont = 15.0
            
        } else if iPhoneX {
            
            labelFont = 15.0
            
        } else {
            
            labelFont = 20.0
            
        }
        self.statusLabel.font = UIFont(name: "OpenSans", size: labelFont)
        
        if UIView.appearance().semanticContentAttribute == .forceLeftToRight{
            
            imageView.frame = CGRect(x: 10.0, y: bounds.midY - 14.5, width: 29, height: 29)
            statusLabel.frame = CGRect(x: (imageView.frame.maxX) + 10.0, y: 0.0, width: 150.0, height: bounds.height)
            statusSwitch.frame = CGRect(x: bounds.maxX - 61.0, y: bounds.midY - 15.5, width: 51, height: 31)
            statusLabel.textAlignment = .left
            
        }else{
            
            imageView.frame = CGRect(x: bounds.maxX - 10 - 29 , y: bounds.midY - 14.5, width: 29, height: 29)
            statusLabel.frame = CGRect(x: (imageView.frame.minX) - 10 - 150.0, y: 0.0, width: 150.0, height: bounds.height)
            statusSwitch.frame = CGRect(x: 10.0, y: bounds.midY - 15.5, width: 51, height: 31)
            statusLabel.textAlignment = .right
        }
        
    }
    
}

class SwiftLimitScreenPickerHeaderView: UIView {
    
    var imageView = UIImageView()
    var label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        imageView = UIImageView(frame: CGRect.zero)
        addSubview(imageView)
        
        label = UILabel(frame: CGRect.zero)
        label.textColor = UIColor.darkGray
        label.textAlignment = .left
        label.text = "Enabled"
        self.addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var labelFont: CGFloat = 0.0
        
        if iPhone4 {
            
            labelFont = 14.0
            
        } else if iPhone5 {
            
            labelFont = 14.0
            
        } else if iPhone6 {
            
            labelFont = 15.0
            
        } else if iPhone6Plus {
            
            labelFont = 15.0
            
        } else {
            
            labelFont = 20.0
            
        }
        
        label.font = UIFont(name: "OpenSans", size: labelFont)
        
        if UIView.appearance().semanticContentAttribute == .forceLeftToRight{
            
            imageView.frame = CGRect(x: 10.0, y: bounds.midY - 12.0, width: 24, height: 24)
            label.frame = CGRect(x: (imageView.frame.maxX) + 10.0, y: 0.0, width: 200.0, height: bounds.height)
            label.textAlignment = .left
        }else{
            
            imageView.frame = CGRect(x: bounds.maxX - 10 - 24 , y:bounds.midY - 12.0, width: 24, height: 24)
            label.frame = CGRect(x: imageView.frame.minX  - 10 - 200.0, y: 0.0, width: 200.0, height: bounds.height)
            label.textAlignment = .right
        }
        
    }
    
}

class SwiftLimitScreenWeekDaysView: UIView {
    
    var mondayButton = UIButton()
    var tuesdayButton = UIButton()
    var wednesdayButton = UIButton()
    var thursdayButton = UIButton()
    var fridayButton = UIButton()
    var saturdayButton = UIButton()
    var sundayButton = UIButton()
    @objc var rule = AccessControlRuleModel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        let height = frame.height
        var leftMargin: CGFloat = 0
        
        if iPhone4 {
            //height = 30.0f;
            leftMargin = 15.0
            
        } else if iPhone5 {
            //height = 30.0f;
            leftMargin = 15.0
            
        } else if iPhone6 {
            //height = 35.0f;
            leftMargin = 15.0
            
        } else if iPhone6Plus {
            
            //height = 40.0f;
            leftMargin = 17.0
            
        } else {
            
            leftMargin = 17.0
            
        }
        
        let spacesBetweenButtons = ((bounds.width - leftMargin) - (height * 7)) / 7.0
        sundayButton = newButton(withTitle: "S", frame: CGRect(x: leftMargin, y: 0.0, width: height, height: height), enable: true)!
        sundayButton.tag = 101
        sundayButton.addTarget(self, action: #selector(handleWeekDayButton(_:)), for: .touchUpInside)
        addSubview(sundayButton)
        
        mondayButton = newButton(withTitle: "M", frame: CGRect(x: sundayButton.frame.maxX + spacesBetweenButtons, y: 0.0, width: height, height: height), enable: true)!
        mondayButton.tag = 102
        mondayButton.addTarget(self, action: #selector(handleWeekDayButton(_:)), for: .touchUpInside)
        addSubview(mondayButton)
        
        tuesdayButton = newButton(withTitle: "T", frame: CGRect(x: mondayButton.frame.maxX + spacesBetweenButtons, y: 0.0, width: height, height: height), enable: true)!
        tuesdayButton.tag = 103
        tuesdayButton.addTarget(self, action: #selector(handleWeekDayButton(_:)), for: .touchUpInside)
        addSubview(tuesdayButton)
        
        wednesdayButton = newButton(withTitle: "W", frame: CGRect(x: tuesdayButton.frame.maxX + spacesBetweenButtons, y: 0.0, width: height, height: height), enable: true)!
        wednesdayButton.tag = 104
        wednesdayButton.addTarget(self, action: #selector(handleWeekDayButton(_:)), for: .touchUpInside)
        addSubview(wednesdayButton)
        
        thursdayButton = newButton(withTitle: "T", frame: CGRect(x: wednesdayButton.frame.maxX + spacesBetweenButtons, y: 0.0, width: height, height: height), enable: true)!
        thursdayButton.tag = 105
        thursdayButton.addTarget(self, action: #selector(handleWeekDayButton(_:)), for: .touchUpInside)
        addSubview(thursdayButton)
        
        fridayButton = newButton(withTitle: "F", frame: CGRect(x: thursdayButton.frame.maxX + spacesBetweenButtons, y: 0.0, width: height, height: height), enable: true)!
        fridayButton.tag = 106
        fridayButton.addTarget(self, action: #selector(handleWeekDayButton(_:)), for: .touchUpInside)
        addSubview(fridayButton)
        
        saturdayButton = newButton(withTitle: "S", frame: CGRect(x: fridayButton.frame.maxX + spacesBetweenButtons, y: 0.0, width: height, height: height), enable: true)!
        saturdayButton.tag = 107
        saturdayButton.addTarget(self, action: #selector(handleWeekDayButton(_:)), for: .touchUpInside)
        addSubview(saturdayButton)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func newButton(withTitle title: String?, frame: CGRect, enable: Bool) -> UIButton? {
        
        var fontSize: CGFloat = 0.0
        
        if iPhone4 {
            
            fontSize = 22
            
        } else if iPhone5 {
            
            fontSize = 22.0
            
        } else if iPhone6 {
            
            fontSize = 23.0
            
        } else if iPhone6Plus {
            
            fontSize = 24.0
            
        } else {
            
            fontSize = 30.0
            
        }
        
        let button = UIButton(type: .custom)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont(name: "OpenSans", size: fontSize)
        button.setTitleColor(enable ? RGBCOLOR(16, 132, 180, 1) : UIColor.lightGray, for: .normal)
        button.frame = frame
        button.layer.cornerRadius = frame.width / 2.0
        button.layer.borderColor = enable ? RGBCOLOR(16, 132, 180, 1).cgColor : UIColor.lightGray.cgColor
        button.layer.borderWidth = 1.0
        button.layer.masksToBounds = true
        return button
        
    }
    
    //    func setRule(_ rule: AccessControlRuleModel?) {
    //
    //        self.rule = rule!
    //        applyRule(on: sundayButton, isOn: ((rule?.is_sunday as? NSNumber)?.intValue ?? 0 == 1))
    //        applyRule(on: mondayButton, isOn: ((rule?.is_monday as? NSNumber)?.intValue ?? 0 == 1))
    //        applyRule(on: tuesdayButton, isOn: ((rule?.is_tuesday as? NSNumber)?.intValue ?? 0 == 1))
    //        applyRule(on: wednesdayButton, isOn: ((rule?.is_wednesday as? NSNumber)?.intValue ?? 0 == 1))
    //        applyRule(on: thursdayButton, isOn: ((rule?.is_thursday as? NSNumber)?.intValue ?? 0 == 1))
    //        applyRule(on: fridayButton, isOn: ((rule?.is_friday as? NSNumber)?.intValue ?? 0 == 1))
    //        applyRule(on: saturdayButton, isOn: ((rule?.is_saturday as? NSNumber)?.intValue ?? 0 == 1))
    //
    //        let sunday = rule?.is_sunday as? Int ?? 0
    //        let monday = rule?.is_monday as? Int ?? 0
    //        let tuesday = rule?.is_tuesday as? Int ?? 0
    //        let wednesday = rule?.is_thursday as? Int ?? 0
    //        let thursday = rule?.is_friday as? Int ?? 0
    //        let friday = rule?.is_saturday as? Int ?? 0
    //        let saturday = rule?.is_sunday as? Int ?? 0
    //
    //        self.rule.is_sunday = String(sunday)
    //        self.rule.is_monday = String(monday)
    //        self.rule.is_tuesday = String(tuesday)
    //        self.rule.is_wednesday = String(wednesday)
    //        self.rule.is_thursday = String(thursday)
    //        self.rule.is_friday = String(friday)
    //        self.rule.is_saturday = String(saturday)
    //
    //    }
    func setRule(_ rule: AccessControlRuleModel?) {
        guard let rule = rule else {
            return
        }
        
        self.rule = rule // Optionally update the rule object if necessary
        
        applyRule(on: sundayButton, isOn: (rule.is_sunday as NSString?)?.boolValue ?? false)
        applyRule(on: mondayButton, isOn: (rule.is_monday as NSString?)?.boolValue ?? false)
        applyRule(on: tuesdayButton, isOn: (rule.is_tuesday as NSString?)?.boolValue ?? false)
        applyRule(on: wednesdayButton, isOn: (rule.is_wednesday as NSString?)?.boolValue ?? false)
        applyRule(on: thursdayButton, isOn: (rule.is_thursday as NSString?)?.boolValue ?? false)
        applyRule(on: fridayButton, isOn: (rule.is_friday as NSString?)?.boolValue ?? false)
        applyRule(on: saturdayButton, isOn: (rule.is_saturday as NSString?)?.boolValue ?? false)
    }
    
    
    func applyRule(on button: UIButton?, isOn: Bool) {
        
        button?.setTitleColor(isOn ? UIColor.white : UIColor.lightGray, for: .normal)
        button?.layer.borderColor = isOn ? RGBCOLOR(16, 132, 180, 1).cgColor : UIColor.lightGray.cgColor
        button?.layer.backgroundColor = isOn ? RGBCOLOR(16, 132, 180, 1).cgColor : UIColor.clear.cgColor
        button?.setNeedsDisplay()
        
        
    }
    
    @objc func handleWeekDayButton(_ button: UIButton?) {
        
        let data = UserDefaults.standard
        
        print(rule)
        
        if button?.tag == 101 {//Sunday
            
            print("\(rule.is_sunday ?? "")")
            
            if Int(rule.is_sunday) == 1 {
                
                rule.is_sunday = "0"
                data.setValue("0", forKey: "sunday_day")
                rule.is_sunday = "0"
                button?.setTitleColor(UIColor.lightGray, for: .normal)
                button?.layer.borderColor = UIColor.lightGray.cgColor
                button?.layer.backgroundColor = UIColor.clear.cgColor
                
            } else {
                
                rule.is_sunday = "1"
                data.setValue("1", forKey: "sunday_day")
                rule.is_sunday = "1"
                button?.setTitleColor(UIColor.white, for: .normal)
                button?.layer.borderColor = RGBCOLOR(16, 132, 180, 1).cgColor
                button?.layer.backgroundColor = RGBCOLOR(16, 132, 180, 1).cgColor
                
            }
            
        } else if button?.tag == 102 {//monday
            
            if Int(rule.is_monday) == 1 {
                
                rule.is_monday = "0"
                data.setValue("0", forKey: "monday_day")
                rule.is_monday = "0"
                button?.setTitleColor(UIColor.lightGray, for: .normal)
                button?.layer.borderColor = UIColor.lightGray.cgColor
                button?.layer.backgroundColor = UIColor.clear.cgColor
                
            } else {
                
                rule.is_monday = "1"
                data.setValue("1", forKey: "monday_day")
                rule.is_monday = "1"
                button?.setTitleColor(UIColor.white, for: .normal)
                button?.layer.borderColor = RGBCOLOR(16, 132, 180, 1).cgColor
                button?.layer.backgroundColor = RGBCOLOR(16, 132, 180, 1).cgColor
                
            }
            
        } else if button?.tag == 103 {//tuesday
            
            if Int(rule.is_tuesday) == 1 {
                
                rule.is_tuesday = "0"
                data.setValue("0", forKey: "tuesday_day")
                rule.is_tuesday = "0"
                
                button?.setTitleColor(UIColor.lightGray, for: .normal)
                button?.layer.borderColor = UIColor.lightGray.cgColor
                button?.layer.backgroundColor = UIColor.clear.cgColor
                
            } else {
                
                rule.is_tuesday = "1"
                rule.is_tuesday = "1"
                data.setValue("1", forKey: "tuesday_day")
                button?.setTitleColor(UIColor.white, for: .normal)
                button?.layer.borderColor = RGBCOLOR(16, 132, 180, 1).cgColor
                button?.layer.backgroundColor = RGBCOLOR(16, 132, 180, 1).cgColor
                
            }
            
        } else if button?.tag == 104 {// wednesday
            
            if Int(rule.is_wednesday) == 1 {
                
                rule.is_wednesday = "0"
                rule.is_wednesday = "0"
                data.setValue("0", forKey: "wednesday_day")
                button?.setTitleColor(UIColor.lightGray, for: .normal)
                button?.layer.borderColor = UIColor.lightGray.cgColor
                button?.layer.backgroundColor = UIColor.clear.cgColor
                
            } else {
                
                rule.is_wednesday = "1"
                rule.is_wednesday = "1"
                data.setValue("1", forKey: "wednesday_day")
                button?.setTitleColor(UIColor.white, for: .normal)
                button?.layer.borderColor = RGBCOLOR(16, 132, 180, 1).cgColor
                button?.layer.backgroundColor = RGBCOLOR(16, 132, 180, 1).cgColor
                
            }
            
        } else if button?.tag == 105 {//thursday
            
            if Int(rule.is_thursday) == 1 {
                
                rule.is_thursday = "0"
                rule.is_thursday = "0"
                data.setValue("0", forKey: "thursday_day")
                button?.setTitleColor(UIColor.lightGray, for: .normal)
                button?.layer.borderColor = UIColor.lightGray.cgColor
                button?.layer.backgroundColor = UIColor.clear.cgColor
                
            } else {
                
                rule.is_thursday = "1"
                rule.is_thursday = "1"
                data.setValue("1", forKey: "thursday_day")
                button?.setTitleColor(UIColor.white, for: .normal)
                button?.layer.borderColor = RGBCOLOR(16, 132, 180, 1).cgColor
                button?.layer.backgroundColor = RGBCOLOR(16, 132, 180, 1).cgColor
                
            }
            
        } else if button?.tag == 106 {//friday
            
            if Int(rule.is_friday) == 1 {
                rule.is_friday = "0"
                rule.is_friday = "0"
                data.setValue("0", forKey: "friday_day")
                button?.setTitleColor(UIColor.lightGray, for: .normal)
                button?.layer.borderColor = UIColor.lightGray.cgColor
                button?.layer.backgroundColor = UIColor.clear.cgColor
            } else {
                rule.is_friday = "1"
                rule.is_friday = "1"
                data.setValue("1", forKey: "friday_day")
                button?.setTitleColor(UIColor.white, for: .normal)
                button?.layer.borderColor = RGBCOLOR(16, 132, 180, 1).cgColor
                button?.layer.backgroundColor = RGBCOLOR(16, 132, 180, 1).cgColor
            }
            
        } else if button?.tag == 107 {//saturday
            
            if Int(rule.is_saturday) == 1 {
                rule.is_saturday = "0"
                rule.is_saturday = "0"
                data.setValue("0", forKey: "saturday_day")
                button?.setTitleColor(UIColor.lightGray, for: .normal)
                button?.layer.borderColor = UIColor.lightGray.cgColor
                button?.layer.backgroundColor = UIColor.clear.cgColor
            } else {
                rule.is_saturday = "1"
                rule.is_saturday = "1"
                data.setValue("1", forKey: "saturday_day")
                button?.setTitleColor(UIColor.white, for: .normal)
                button?.layer.borderColor = RGBCOLOR(16, 132, 180, 1).cgColor
                button?.layer.backgroundColor = RGBCOLOR(16, 132, 180, 1).cgColor
            }
        }
        
        data.synchronize()
    }
}

class SwiftAddLimitScrenRule:UIViewController, UITextFieldDelegate, UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate,UIPickerViewDataSource, UIPickerViewDelegate {
    
    var is_Safari = false
    var is_Camera = false
    var is_Siri = false
    var is_iTunes = false
    var is_installinApps = false
    var is_inappPurchases = false
    var is_otherApps = false
    
    var isNew = false
    var isCustom = false
    var rule = AccessControlRuleModel()
    var sunday_Day = ""
    var monday_Day = ""
    var tuesday_Day = ""
    var wednesday_Day = ""
    var thursday_Day = ""
    var friday_Day = ""
    var saturday_Day = ""
    let delegate = UIApplication.shared.delegate as? AppDelegate
    
    var scrollView = UIScrollView()
    var statusView = SwiftLimitScreenRuleStatusView()
    var nameField = UITextField()
    var firstHeaderView = SwiftLimitScreenPickerHeaderView()
    var secondHeaderView = SwiftLimitScreenPickerHeaderView()
    var repeatHeaderView = SwiftLimitScreenPickerHeaderView()
    var weekDaysView = SwiftLimitScreenWeekDaysView()
    var startTimePicker = UIDatePicker()
    var endTimePicker = UIDatePicker()
    var tableView = UITableView()
    
    var hours = [String]()
    var minutes = [Any]()
    var appsTitles0 = [String]()
    var appsImages0 = [String]()
    var appsTitles1 = [String]()
    var appsImages1 = [String]()
    var appsTitles2 = [String]()
    var appsImages2 = [String]()
    let child_Id = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
    var previousSwitchColors = [UISwitch: (onTintColor: UIColor?, thumbTintColor: UIColor?, tintColor: UIColor?)]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.set("NO", forKey: "gobacknow")
        UserDefaults.standard.synchronize()
        
        view.backgroundColor = UIColor.white
        hours = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
        
        appsTitles0 = ["Safari", "Camera", "Siri & Dictation"]
        appsImages0 = ["safari", "camera", "siri"]
        
        appsTitles1 = ["iTunes Store", "Installing Apps", "In App Purchases"]
        appsImages1 = ["itunesStore", "installingApps", "inappPurchases"]
        
        appsTitles2 = ["Other Apps"]
        appsImages2 = ["inappPurchases"]
        
        for index in 0..<60 {
            minutes.append(String(format: "%02ld", index))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isNew {
            rule.child_id = NSNumber(value: Int(child_Id ?? "") ?? -1).stringValue
            rule.rule_name = ""
            rule.time_start = ""
            rule.time_end = ""
            rule.is_sunday = "0"
            rule.is_monday = "0"
            rule.is_tuesday = "0"
            rule.is_wednesday = "0"
            rule.is_thursday = "0"
            rule.is_friday = "0"
            rule.is_saturday = "0"
            
            var rule_config_dict: [String: Any] = [:]
            
            rule_config_dict["time_start"] = ""
            rule_config_dict["time_end"] = ""
            rule_config_dict["is_sunday"] = "0"
            rule_config_dict["is_monday"] = "0"
            rule_config_dict["is_tuesday"] = "0"
            rule_config_dict["is_wednesday"] = "0"
            rule_config_dict["is_thursday"] = "0"
            rule_config_dict["is_friday"] = "0"
            rule_config_dict["is_saturday"] = "0"
            
            rule.rule_config = NSMutableDictionary(dictionary: rule_config_dict)
            
            let data = UserDefaults.standard
            data.setValue("0", forKey: "monday_day")
            data.setValue("0", forKey: "tuesday_day")
            data.setValue("0", forKey: "wednesday_day")
            data.setValue("0", forKey: "thursday_day")
            data.setValue("0", forKey: "friday_day")
            data.setValue("0", forKey: "saturday_day")
            data.setValue("0", forKey: "sunday_day")
            
            rule.is_active = "1"
            
            var restriction_dict: [String: Any] = [:]
            
            restriction_dict["safari"] = is_Safari ? "1" : "0"
            restriction_dict["camera"] = is_Camera ? "1" : "0"
            restriction_dict["siri"] = is_Siri ? "1" : "0"
            restriction_dict["itunesStore"] = is_iTunes ? "1" : "0"
            restriction_dict["inappPurchases"] = is_installinApps ? "1" : "0"
            restriction_dict["externalApps"] = is_otherApps ? "1" : "0"
            
            rule.restriction = NSMutableDictionary(dictionary: restriction_dict)
        }
        print(rule.rule_config)
        
        self.setupUI()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(handleSave(_:)))
        tableView.frame = CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.size.width, height: tableView.frame.size.height - tableView.rowHeight + 200)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(showMainMenu(_:)),
            name: NSNotification.Name("syncComplete"),
            object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserDefaults.standard.object(forKey: "gobacknow") != nil {
            if UserDefaults.standard.object(forKey: "gobacknow") as! String == "YES" {
                UserDefaults.standard.set("NO", forKey: "gobacknow")
                UserDefaults.standard.synchronize()
                navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @objc func showMainMenu(_ note: Notification?) {
        navigationController?.popViewController(animated: true)
    }
    
    func setupUI() {
        
        var verticalMargin: CGFloat = 0
        var weekdaysViewHeight: CGFloat = 0
        var headerViewHeight: CGFloat = 0
        let timePickerHeight: CGFloat
        var nameFieldHeight: CGFloat = 0
        var statusViewHeight: CGFloat = 0
        var switchViewSclaeFactor: CGFloat = 1.0
        
        if iPhone4 {
            verticalMargin = 10.0
            weekdaysViewHeight = 35
            headerViewHeight = 20.0
            timePickerHeight = 100.0
            nameFieldHeight = 25.0
            statusViewHeight = 40.0
            switchViewSclaeFactor = 1.0
            
        } else if iPhone5 {
            verticalMargin = 15.0
            weekdaysViewHeight = 35
            headerViewHeight = 25.0
            timePickerHeight = 120.0
            nameFieldHeight = 30.0
            statusViewHeight = 40.0
            switchViewSclaeFactor = 1.0
            
        } else if iPhone6 {
            verticalMargin = 25.0
            weekdaysViewHeight = 40
            headerViewHeight = 35.0
            timePickerHeight = 130.0
            nameFieldHeight = 35.0
            statusViewHeight = 40.0
            switchViewSclaeFactor = 1.0
            
        } else if iPhone6Plus {
            verticalMargin = 25.0
            weekdaysViewHeight = 45
            headerViewHeight = 45.0
            timePickerHeight = 130.0
            nameFieldHeight = 40.0
            statusViewHeight = 50.0
            switchViewSclaeFactor = 1.0
        } else {
            verticalMargin = 30.0
            weekdaysViewHeight = 45
            headerViewHeight = 50.0
            timePickerHeight = 230.0
            nameFieldHeight = 40.0
            statusViewHeight = 60.0
            switchViewSclaeFactor = 1.0
        }
        
        title = isNew ? "schedule_screen_add_rules_title".myModification() : rule.rule_name
        title = title?.myModification()
        
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        scrollView.backgroundColor = UIColor.clear
        view.addSubview(scrollView)
        
        statusView = SwiftLimitScreenRuleStatusView(frame: CGRect(x: 0.0, y: 0.0, width: view.bounds.width, height: statusViewHeight))
        scrollView.addSubview(statusView)
        statusView.statusSwitch.transform = CGAffineTransform(scaleX: switchViewSclaeFactor, y: switchViewSclaeFactor)
        statusView.statusLabel.text = (Int(rule.is_active) == 1) ? "schedule_screen_time_rules_switch_1_content_1".myModification() : "schedule_screen_time_rules_switch_1_content_2".myModification()
        statusView.imageView.image = CommonModel.image(forHeaderSST: rule.rule_name) // [self imageForHeader:self.rule];
        //        statusView.statusSwitch.isOn = (Int(rule.is_active) == 1) ? true : false
        //        statusView.statusSwitch.addTarget(self, action: #selector(handleStatusSwitch(_:)), for: .valueChanged)
        
        if isNew || Int(rule.is_predefined ?? "0") == 0 {
            nameField = UITextField(frame: CGRect(x: 20.0, y: statusView.frame.maxY + verticalMargin, width: view.bounds.width - 40.0, height: nameFieldHeight))
            nameField.placeholder = " \("schedule_screen_time_add_rules_text_content_1".myModification() ?? "")"
            nameField.font = UIFont(name: "OpenSans", size: 13.0)
            nameField.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
            nameField.layer.borderWidth = 1.0
            nameField.layer.cornerRadius = 3.0
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 20))
            nameField.leftView = paddingView
            nameField.leftViewMode = .always
            nameField.delegate = self
            nameField.returnKeyType = .done
            self.nameField.text = rule.rule_name
            self.scrollView.addSubview(self.nameField)
        }
        
        if isNew || Int(rule.is_predefined ?? "0") == 0 {
            firstHeaderView = SwiftLimitScreenPickerHeaderView(frame: CGRect(x: 0.0, y: nameField.frame.maxY + verticalMargin, width: view.bounds.width, height: headerViewHeight))
            scrollView.addSubview(firstHeaderView)
        } else {
            firstHeaderView = SwiftLimitScreenPickerHeaderView(frame: CGRect(x: 0.0, y: statusView.frame.maxY + verticalMargin, width: view.bounds.width, height: headerViewHeight))
            scrollView.addSubview(firstHeaderView)
        }
        
        firstHeaderView.imageView.image = UIImage(named: "ic_clock")
        firstHeaderView.label.text = "schedule_screen_time_rules_content_1".myModification()
        
        if #available(iOS 14.0, *) {
            
            if iPhone5 {
                startTimePicker = UIDatePicker(frame: CGRect(x: view.center.x - 155, y: firstHeaderView.frame.maxY, width: view.bounds.width, height: timePickerHeight))
            } else if iPhone6 {
                startTimePicker = UIDatePicker(frame: CGRect(x: view.center.x - 160, y: firstHeaderView.frame.maxY, width: view.bounds.width, height: timePickerHeight))
            } else if iPhone6Plus {
                startTimePicker = UIDatePicker(frame: CGRect(x: view.center.x - 165, y: firstHeaderView.frame.maxY, width: view.bounds.width, height: timePickerHeight))
            } else if iPhoneX {
                startTimePicker = UIDatePicker(frame: CGRect(x: view.center.x - 162, y: firstHeaderView.frame.maxY, width: view.bounds.width, height: timePickerHeight))
            } else {
                startTimePicker = UIDatePicker(frame: CGRect(x: view.center.x - 170, y: firstHeaderView.frame.maxY, width: view.bounds.width, height: timePickerHeight))
            }
            startTimePicker.preferredDatePickerStyle = .wheels
        } else {
            startTimePicker = UIDatePicker(frame: CGRect(x: 0.0, y: firstHeaderView.frame.maxY, width: view.bounds.width, height: timePickerHeight))
        }
        
        startTimePicker.tag = 101
        startTimePicker.datePickerMode = .time
        startTimePicker.setValue(RGBCOLOR(16, 132, 180, 1), forKey: "textColor")
        scrollView.addSubview(startTimePicker)
        
        if !isNew {
            let start_date = UTCToLocalConverter(timeToConvert: rule.time_start as? String ?? "")
            startTimePicker.date = start_date
        }
        
        secondHeaderView = SwiftLimitScreenPickerHeaderView(frame: CGRect(x: 0.0, y: startTimePicker.frame.maxY + verticalMargin, width: view.bounds.width, height: headerViewHeight))
        scrollView.addSubview(secondHeaderView)
        secondHeaderView.imageView.image = UIImage(named: "ic_clock")
        secondHeaderView.label.text = "schedule_screen_time_rules_content_2".myModification()
        endTimePicker.tintColor = RGBCOLOR(16, 132, 180, 1)
        endTimePicker.tag = 102
        
        if #available(iOS 14.0, *) {
            
            if iPhone5 {
                endTimePicker = UIDatePicker(frame: CGRect(x: view.center.x - 155, y: secondHeaderView.frame.maxY, width: view.bounds.width, height: timePickerHeight))
            } else if iPhone6 {
                endTimePicker = UIDatePicker(frame: CGRect(x: view.center.x - 160, y: secondHeaderView.frame.maxY, width: view.bounds.width, height: timePickerHeight))
            } else if iPhone6Plus {
                endTimePicker = UIDatePicker(frame: CGRect(x: view.center.x - 165, y: secondHeaderView.frame.maxY, width: view.bounds.width, height: timePickerHeight))
                
            } else if iPhoneX {
                endTimePicker = UIDatePicker(frame: CGRect(x: view.center.x - 162, y: secondHeaderView.frame.maxY, width: view.bounds.width, height: timePickerHeight))
            } else {
                endTimePicker = UIDatePicker(frame: CGRect(x: view.center.x - 170, y: secondHeaderView.frame.maxY, width: view.bounds.width, height: timePickerHeight))
            }
            endTimePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
            endTimePicker = UIDatePicker(frame: CGRect(x: 0.0, y: secondHeaderView.frame.maxY, width: view.bounds.width, height: timePickerHeight))
        }
        
        endTimePicker.datePickerMode = .time
        endTimePicker.setValue(RGBCOLOR(16, 132, 180, 1), forKey: "textColor")
        scrollView.addSubview(endTimePicker)
        if !isNew {
            let end_date = UTCToLocalConverter(timeToConvert: rule.time_end as? String ?? "")
            endTimePicker.date = end_date
        }
        repeatHeaderView = SwiftLimitScreenPickerHeaderView(frame: CGRect(x: 0.0, y: endTimePicker.frame.maxY + verticalMargin, width: view.bounds.width, height: headerViewHeight))
        scrollView.addSubview(repeatHeaderView)
        repeatHeaderView.imageView.image = UIImage(named: "blue_refresh")
        repeatHeaderView.label.text = "schedule_screen_time_rules_content_3".myModification()
        weekDaysView = SwiftLimitScreenWeekDaysView(frame: CGRect(x: 0.0, y: repeatHeaderView.frame.maxY, width: view.bounds.width, height: weekdaysViewHeight))
        scrollView.addSubview(weekDaysView)
        weekDaysView.setRule(rule)
        weekDaysView.rule = rule
        
        tableView = UITableView(frame: CGRect(x: 0.0, y: weekDaysView.frame.maxY + 20, width: view.bounds.width, height: 75.0 * 8.0), style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        tableView.rowHeight = 75
        tableView.register(UINib(nibName: "LeftSidesTableViewCell", bundle: nil), forCellReuseIdentifier: "LeftSidesCell")
        scrollView.addSubview(tableView)
        
        if Int(rule.is_predefined ?? "0") == 0 && !isNew {
            let deleteButton = UIButton(type: .custom)
            deleteButton.setImage(UIImage(named: "delete"), for: .normal)
            deleteButton.frame = CGRect(x: 15.0, y: `self`.tableView.frame.maxY + 80, width: 30, height: 30)
            deleteButton.addTarget(self, action: #selector(handleDelete(_:)), for: .touchUpInside)
            deleteButton.tag = Int(rule.id) ?? 0
            scrollView.addSubview(deleteButton)
            
            scrollView.contentSize = CGSize(width: view.bounds.width, height: deleteButton.frame.maxY + 10 + 20)
        } else {
            scrollView.contentSize = CGSize(width: view.bounds.width, height: tableView.frame.maxY + 10 + 70)
        }
        //        if Int(rule.is_predefined ?? "0") != 0 && !isNew {
        if !isNew {
            // Assuming this code block is inside a method where you update UI based on rules
            // Assuming this code block is inside a method where you update UI based on rules
            //            if let mdmPayload = rule.mdm_payload {
            //                if let safari = mdmPayload["safari"] as? String {
            //                    is_Safari = (safari != "0")
            //                } else {
            //                    is_Safari = false
            //                }
            //
            //                if let camera = mdmPayload["camera"] as? String {
            //                    is_Camera = (camera != "0")
            //                } else {
            //                    is_Camera = false
            //                }
            //
            //                if let siri = mdmPayload["siri"] as? String {
            //                    is_Siri = (siri != "0")
            //                } else {
            //                    is_Siri = false
            //                }
            //
            //                if let itunesStore = mdmPayload["itunesStore"] as? String {
            //                    is_iTunes = (itunesStore != "0")
            //                } else {
            //                    is_iTunes = false
            //                }
            //
            //                if let installingApps = mdmPayload["installingApps"] as? String {
            //                    is_installinApps = (installingApps != "0")
            //                } else {
            //                    is_installinApps = false
            //                }
            //
            //                if let inappPurchases = mdmPayload["inappPurchases"] as? String {
            //                    is_inappPurchases = (inappPurchases != "0")
            //                } else {
            //                    is_inappPurchases = false
            //                }
            //
            //                if let externalApps = mdmPayload["externalApps"] as? String {
            //                    is_otherApps = (externalApps != "0")
            //                } else {
            //                    is_otherApps = false
            //                }
            //            }
            if let mdmPayload = rule.mdm_payload as? [String: Any] {
                is_Safari = !(mdmPayload["safari"] as? Bool ?? true)
                is_Camera = !(mdmPayload["camera"] as? Bool ?? true)
                is_Siri = !(mdmPayload["siri"] as? Bool ?? true)
                is_iTunes = !(mdmPayload["itunesStore"] as? Bool ?? true)
                is_installinApps = !(mdmPayload["installingApps"] as? Bool ?? true)
                is_inappPurchases = !(mdmPayload["inappPurchases"] as? Bool ?? true)
                is_otherApps = !(mdmPayload["externalApps"] as? Bool ?? true)
            }
            
            print("here\(String(describing: rule.restriction))")
        } else if Int(rule.is_predefined ?? "0") == 0 && !isNew {
            
            
            if let mdmPayload = rule.mdm_payload {
                if let safari = mdmPayload["safari"] as? String {
                    is_Safari = (safari != "0")
                } else {
                    is_Safari = false
                }
                
                if let camera = mdmPayload["camera"] as? String {
                    is_Camera = (camera != "0")
                } else {
                    is_Camera = false
                }
                
                if let siri = mdmPayload["siri"] as? String {
                    is_Siri = (siri != "0")
                } else {
                    is_Siri = false
                }
                
                if let itunesStore = mdmPayload["itunesStore"] as? String {
                    is_iTunes = (itunesStore != "0")
                } else {
                    is_iTunes = false
                }
                
                if let installingApps = mdmPayload["installingApps"] as? String {
                    is_installinApps = (installingApps != "0")
                } else {
                    is_installinApps = false
                }
                
                if let inappPurchases = mdmPayload["inappPurchases"] as? String {
                    is_inappPurchases = (inappPurchases != "0")
                } else {
                    is_inappPurchases = false
                }
                
                if let externalApps = mdmPayload["externalApps"] as? String {
                    is_otherApps = (externalApps != "0")
                } else {
                    is_otherApps = false
                }
            }
            
            //            let data = (rule.rule_config["restriction"] as AnyObject).data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue).rawValue)
            //            var json: Any? = nil
            //            do {
            //                if let data = data {
            //                    json = try JSONSerialization.jsonObject(with: data, options: [])
            //                }
            //            } catch {
            //            }
            //
            //            if (json as? [AnyHashable : Any])?["safari"] != nil {
            //                is_Safari = ((((json as? [AnyHashable : Any])?["safari"] as? NSNumber)?.intValue ?? 0) != 0)
            //            } else {
            //                is_Safari = false
            //            }
            //
            //            if (json as? [AnyHashable : Any])?["camera"] != nil {
            //                is_Camera = ((((json as? [AnyHashable : Any])?["camera"] as? NSNumber)?.intValue ?? 0) != 0)
            //            } else {
            //                is_Camera = false
            //            }
            //
            //            if (json as? [AnyHashable : Any])?["siri"] != nil {
            //                is_Siri = ((((json as? [AnyHashable : Any])?["siri"] as? NSNumber)?.intValue ?? 0) != 0)
            //            } else {
            //                is_Siri = false
            //            }
            //
            //            if (json as? [AnyHashable : Any])?["itunesStore"] != nil {
            //                is_iTunes = ((((json as? [AnyHashable : Any])?["itunesStore"] as? NSNumber)?.intValue ?? 0) != 0)
            //            } else {
            //                is_iTunes = false
            //            }
            //
            //            if (json as? [AnyHashable : Any])?["installingApps"] != nil {
            //                is_installinApps = ((((json as? [AnyHashable : Any])?["installingApps"] as? NSNumber)?.intValue ?? 0) != 0)
            //            } else {
            //                is_installinApps = false
            //            }
            //
            //            if (json as? [AnyHashable : Any])?["inappPurchases"] != nil {
            //                is_inappPurchases = ((((json as? [AnyHashable : Any])?["inappPurchases"] as? NSNumber)?.intValue ?? 0) != 0)
            //            } else {
            //                is_inappPurchases = false
            //            }
            //
            //            if (json as? [AnyHashable : Any])?["externalApps"] != nil {
            //                is_otherApps = ((((json as? [AnyHashable : Any])?["externalApps"] as? NSNumber)?.intValue ?? 0) != 0)
            //            } else {
            //                is_otherApps = false
            //            }
            //            print("here\(String(describing: rule.restriction))")
        }
        statusView.statusSwitch.isOn = (Int(rule.is_active) == 1) ? true : false
        statusView.statusSwitch.addTarget(self, action: #selector(handleStatusSwitch(_:)), for: .valueChanged)
        if statusView.statusSwitch.isOn == false {
            
            DispatchQueue.main.async{
                self.disableOtherSwitches()
            }
        }
    }
    @objc func handleStatusSwitch(_ switchView: UISwitch?) {
        
        if switchView?.isOn ?? false {
            rule.is_active = "1"
            statusView.statusLabel.text = "schedule_screen_time_rules_switch_1_content_1".localized
            enableOtherSwitches()
        } else {
            rule.is_active = "0"
            statusView.statusLabel.text = "schedule_screen_time_rules_switch_1_content_2".localized
            disableOtherSwitches()
        }
    }
    private func enableOtherSwitches() {
        for cell in tableView.visibleCells {
            if let settingCell = cell as? SettingTableViewCell {
                settingCell.cellSwitch.isEnabled = true
                
                if let previousColors = previousSwitchColors[settingCell.cellSwitch] {
                    settingCell.cellSwitch.onTintColor = previousColors.onTintColor
                    settingCell.cellSwitch.thumbTintColor = previousColors.thumbTintColor
                    settingCell.cellSwitch.tintColor = previousColors.tintColor
                }
            }
        }
    }
    private func disableOtherSwitches() {
        for cell in tableView.visibleCells {
            if let settingCell = cell as? SettingTableViewCell {
                let previousColors = (
                    onTintColor: settingCell.cellSwitch.onTintColor,
                    thumbTintColor: settingCell.cellSwitch.thumbTintColor,
                    tintColor: settingCell.cellSwitch.tintColor
                )
                previousSwitchColors[settingCell.cellSwitch] = previousColors
                settingCell.cellSwitch.isEnabled = false
                let dullAlpha: CGFloat = 0.5
                settingCell.cellSwitch.onTintColor = settingCell.cellSwitch.onTintColor?.withAlphaComponent(dullAlpha)
                settingCell.cellSwitch.thumbTintColor = settingCell.cellSwitch.thumbTintColor?.withAlphaComponent(dullAlpha)
                settingCell.cellSwitch.tintColor = settingCell.cellSwitch.tintColor?.withAlphaComponent(dullAlpha)
            }
        }
    }
    @objc func handleSave(_ sender: Any?) {
        if nameField.text?.count == 0 && Int(rule.is_predefined ?? "0") == 0 {
            let alert = UIAlertView(title: "schedule_screen_time_add_rules_text_content_1".localized, message: "schedule_screen_time_rules_alert_content_1".localized, delegate: nil, cancelButtonTitle: "Ok")
            alert.show()
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm:ss"
            //Start Time
            let startTime = formatter.string(from: startTimePicker.date)
            if startTime.contains("AM") || startTime.contains("PM") || startTime.contains("am") || startTime.contains("pm") {
                let newStartTime = convert24hrTo12hr(timeToConvert: startTime)
                rule.time_start = newStartTime
            } else {
                rule.time_start = startTime
            }
            //End Time
            let endTime = formatter.string(from: endTimePicker.date)
            if endTime.contains("AM") || endTime.contains("PM") || endTime.contains("am") || endTime.contains("pm")  {
                let newEndTime = convert24hrTo12hr(timeToConvert: endTime)
                rule.time_end = newEndTime
            } else {
                rule.time_end = endTime
            }
            //            var ruleNew = ""
            //
            //            if !isNew {
            //                ruleNew = rule.rule_id
            //            }
            
            var params: [String : Any] = [:]
            if rule.is_predefined != "1" {
                rule.rule_name = nameField.text ?? "New"
            }
            
            params["child_id"] = rule.child_id.integer
            params["name"] = rule.rule_name
            params["start_time"] = rule.time_start
            params["end_time"] = rule.time_end
            params["on_monday"] = rule.is_monday
            params["on_tuesday"] = rule.is_tuesday
            params["on_wednesday"] = rule.is_wednesday
            params["on_thursday"] = rule.is_thursday
            params["on_friday"] = rule.is_friday
            params["on_saturday"] = rule.is_saturday
            params["on_sunday"] = rule.is_sunday
            params["status"] = rule.is_active.integer
            params["type"] = "timebased"
            //            params["id"] = rule.id
            //            params["function"] = "schedule_screen_time"
            if !isNew {
                params["id"] = rule.id
                params["function"] = rule.rule_function
            } else {
                params["function"] = "schedule_screen_time"
            }
            var dict: [String: Any] = [:]
            dict["safari"] = is_Safari ? false : true
            dict["camera"] = is_Camera ? false : true
            dict["siri"] = is_Siri ? false : true
            dict["itunesStore"] = is_iTunes ? false : true
            dict["installingApps"] = is_installinApps ? false : true
            dict["inappPurchases"] = is_inappPurchases ? false : true
            dict["externalApps"] = is_otherApps ? false : true
            
            params["mdm_payload"] = dict
            // Convert the dictionary to JSON data
            if let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: []) {
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    params["mdm_payload"] = jsonString
                } else {
                    print("Error converting JSON data to string")
                }
            } else {
                print("Error converting dictionary to JSON data")
            }
            
            //params["id"] = ruleNew
            SwiftFTUtils.showHUDAdded(to: self.view, withText: "", animated: true)
            let url = HLConstants.BASE_URL_CORE_2 + "controls/schedules"
            CoreManager.networkRequest(url: url, method: isNew ? .post : .put, params: params) { (response: ScheduleRuleSingleModel?, statusCode, errorMessage) in
                SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
                if statusCode == 200 {
                    //NotificationCenter.default.post(name: NSNotification.Name("kRefreshRules"), object: nil)
                    if let res = response?.schedule {
                        if self.isNew {
                            DBManager.shared.saveSchedule(myModelArray: [res])
                        } else {
                            DBManager.shared.getScheduleAndUpdate(childID: res.childID ?? 0, identifier: res.function ?? "", id: res.id ?? 0, obj: res)
                        }
                    }
                    self.navigationController?.popViewController(animated: true)
                    CommonModel.showAlert("settings_card_5_1".localized, msg: "schedule_screen_time_rules_alert_content_2".localized)
                } else {
                    CommonModel.showAlert("alert_error".localized, msg: errorMessage)
                    self.navigationController?.popViewController(animated: true)
                }
            }
            
        }
        //        if !isNew {
        //            if nameField.text?.count == 0 && Int(rule.is_predefined ?? "0") == 0 {
        //                let alert = UIAlertView(title: "schedule_screen_time_add_rules_text_content_1".myModification(), message: "schedule_screen_time_rules_alert_content_1".myModification(), delegate: nil, cancelButtonTitle: "ok_button".localized)
        //                alert.show()
        //            } else {
        //
        //                let formatter = DateFormatter()
        //                formatter.dateFormat = "HH:mm:ss"
        //                // Start Time
        //                let startTime = formatter.string(from: startTimePicker.date)
        //                if startTime.contains("AM") || startTime.contains("PM") || startTime.contains("am") || startTime.contains("pm") {
        //                    let newStartTime = convert24hrTo12hr(timeToConvert: startTime)
        //                    rule.time_start = newStartTime
        //                } else {
        //                    rule.time_start = startTime
        //                }
        //                // End Time
        //                let endTime = formatter.string(from: endTimePicker.date)
        //                if endTime.contains("AM") || endTime.contains("PM") || endTime.contains("am") || endTime.contains("pm")  {
        //                    let newEndTime = convert24hrTo12hr(timeToConvert: endTime)
        //                    rule.time_end = newEndTime
        //                } else {
        //                    rule.time_end = endTime
        //                }
        ////                var ruleNew = ""
        ////
        ////                if !isNew {
        ////                    ruleNew = rule2.rule_id
        ////                }
        //                var params: [String : Any] = [:]
        //                if rule.is_predefined != "1" {
        //                    rule.rule_name = nameField.text ?? "New"
        //                }
        //                params["child_id"] = rule.child_id.integer
        //                params["name"] = rule.rule_name
        //                params["start_time"] = rule.time_start
        //                params["end_time"] = rule.time_end
        //                params["on_monday"] = rule.is_monday
        //                params["on_tuesday"] = rule.is_tuesday
        //                params["on_wednesday"] = rule.is_wednesday
        //                params["on_thursday"] = rule.is_thursday
        //                params["on_friday"] = rule.is_friday
        //                params["on_saturday"] = rule.is_saturday
        //                params["on_sunday"] = rule.is_sunday
        //                params["status"] = rule.is_active.integer
        //                params["type"] = "timebased"
        //                params["id"] = rule.id
        //                params["function"] = "schedule_screen_time"
        //
        //                var dict: [String: Any] = [:]
        //                dict["safari"] = is_Safari ? "1" : "0"
        //                dict["camera"] = is_Camera ? "1" : "0"
        //                dict["siri"] = is_Siri ? "1" : "0"
        //                dict["itunesStore"] = is_iTunes ? "1" : "0"
        //                dict["installingApps"] = is_installinApps ? "1" : "0"
        //                dict["inappPurchases"] = is_inappPurchases ? "1" : "0"
        //                dict["externalApps"] = is_otherApps ? "1" : "0"
        //
        //                //                params["mdm_payload"] = dict
        //                // Convert the dictionary to JSON data
        //                if let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: []) {
        //                    // Convert JSON data to a string
        //                    if let jsonString = String(data: jsonData, encoding: .utf8) {
        //                        // Assign the JSON string to the mdm_payload parameter
        //                        params["mdm_payload"] = jsonString
        //                    } else {
        //                        print("Error converting JSON data to string")
        //                        // Handle error if unable to convert JSON data to string
        //                    }
        //                } else {
        //                    print("Error converting dictionary to JSON data")
        //                    // Handle error if unable to convert dictionary to JSON data
        //                }
        //
        //                SwiftFTUtils.showHUDAdded(to: self.view, withText: "", animated: true)
        //                let url = HLConstants.BASE_URL_CORE_2 + "controls/schedules"
        //
        //                CoreManager.networkRequest(url: url, method: .put, params: params) { (response: ScheduleRuleSingleModel?, statusCode, errorMessage) in
        //                    SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
        //                    if statusCode == 200 {
        //                        // NotificationCenter.default.post(name: NSNotification.Name("kRefreshRules"), object: nil)
        //                        if let res = response?.schedule {
        //                            DBManager.shared.getScheduleAndUpdate(childID: res.childID ?? 0, identifier: res.function ?? "", id: res.id ?? 0, obj: res)
        //                        }
        //                        self.navigationController?.popViewController(animated: true)
        //                        CommonModel.showAlert("settings_card_5_1".localized, msg: "schedule_screen_time_rules_alert_content_2".localized)
        //                    } else {
        //                        CommonModel.showAlert("alert_error".localized, msg: errorMessage)
        //                        self.navigationController?.popViewController(animated: true)
        //                    }
        //                }
        //
        //                //                //start time
        //                //                let formatter = DateFormatter()
        //                //                formatter.dateFormat = "HH:mm:ss"
        //                //                //[formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        //                //                let startTime = formatter.string(from: startTimePicker.date)
        //                //                //self.rule.time_start = startTime;
        //                //                rule.rule_config["time_start"] = startTime
        //                //                //end time
        //                //                let endTime = formatter.string(from: endTimePicker.date)
        //                //                rule.rule_config["time_end"] = endTime
        //                //
        //                //                if rule.is_predefined != "1" {
        //                //                    rule.rule_name = nameField.text ?? "New"
        //                //                }
        //                //
        //                //                var params: [AnyHashable : Any] = [:]
        //                //                params["rule_name"] = rule.rule_name
        //                //                params["time_start"] = rule.rule_config["time_start"]
        //                //                params["time_end"] = rule.rule_config["time_end"]
        //                //                params["is_monday"] = rule.is_monday
        //                //                params["is_tuesday"] = rule.is_tuesday
        //                //                params["is_wednesday"] = rule.is_wednesday
        //                //                params["is_thursday"] = rule.is_thursday
        //                //                params["is_friday"] = rule.is_friday
        //                //                params["is_saturday"] = rule.is_saturday
        //                //                params["is_sunday"] = rule.is_sunday
        //                //                params["is_active"] = rule.is_active
        //                //                params["type"] = "updateAppRule"
        //                //
        //                //                var dict: [String: Any] = [:]
        //                //
        //                //                dict["safari"] = is_Safari ? "1" : "0"
        //                //                dict["camera"] = is_Camera ? "1" : "0"
        //                //                dict["siri"] = is_Siri ? "1" : "0"
        //                //                dict["itunesStore"] = is_iTunes ? "1" : "0"
        //                //                dict["installingApps"] = is_installinApps ? "1" : "0"
        //                //                dict["inappPurchases"] = is_inappPurchases ? "1" : "0"
        //                //                dict["externalApps"] = is_otherApps ? "1" : "0"
        //                //                params["rules"] = dict
        //                //                print(params)
        //                //
        //                //                if params["is_monday"] as? String == "1" || params["is_tuesday"] as? String == "1" || params["is_wednesday"] as? String == "1" || params["is_thursday"] as? String == "1" || params["is_friday"] as? String == "1" || params["is_saturday"] as? String == "1" || params["is_sunday"] as? String == "1" {
        //                //
        //                //                    SwiftFTUtils.showHUDAdded(to: view, withText: "Updating...", animated: true)
        //                //                    let url = String(format: "\(kBasUrlNew_mesh2)/dashboard/settings/ios/lst/applock/rule/\(Int(Int(child_Id ?? "") ?? -1))/\(rule.id ?? "")")
        //                //
        //                //                    var jsonData: Data? = nil
        //                //                    do {
        //                //                        jsonData = try JSONSerialization.data(withJSONObject: params, options: [])
        //                //                    } catch {
        //                //                    }
        //                //                    var myString: String? = nil
        //                //                    if let jsonData = jsonData {
        //                //                        myString = String(data: jsonData, encoding: .utf8)
        //                //                    }
        //                //                    print(myString)
        //                //                    UIApplication.shared.beginIgnoringInteractionEvents()
        //                //
        //                //                    //---NATIVE API CALLING---//
        //                //                    ApiManager.shared().mesh_patch_withJson_Api(withParamString: myString!, withApi: url) { json, errorCode, message in
        //                //
        //                //                        DispatchQueue.main.async {
        //                //                            print("Patch native api call response = \(json)")
        //                //                            UIApplication.shared.endIgnoringInteractionEvents()
        //                //
        //                //                            if (json["status"] as? NSNumber)?.intValue ?? 0 == 200 {
        //                //                                print("\(json)")
        //                //                                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
        //                //                                //                                SwiftFTUtils.showSyncSettingsPopup(with: self)
        //                //
        //                //                                let dashboardStoryBoard = UIStoryboard(name: "Dashboard", bundle: nil)
        //                //                                let vc = dashboardStoryBoard.instantiateViewController(withIdentifier: "SyncPopUpViewController") as? SyncPopUpViewController ?? SyncPopUpViewController()
        //                //                                vc.modalPresentationStyle = .overFullScreen
        //                //                                self.present(vc, animated: true)
        //                //                            } else {
        //                //                                CommonModel.showAlert("alert_error".myModification(), msg: "alert_something_wrong".localized)//json["message"] as? String
        //                //                            }
        //                //
        //                //                            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
        //                //                            self.navigationController?.popViewController(animated: true)
        //                //                        }
        //                //                    }
        //                //                } else {
        //                //                    CommonModel.showAlert("alert_error".localized, msg: "schedule_screen_time_rules_alert_content_3".localized)
        //                //                }
        //            }
        //        } else {
        //
        //            let prefs = UserDefaults.standard
        //            sunday_Day = prefs.string(forKey: "sunday_day") ?? ""
        //            monday_Day = prefs.string(forKey: "monday_day") ?? ""
        //            tuesday_Day = prefs.string(forKey: "tuesday_day") ?? ""
        //            wednesday_Day = prefs.string(forKey: "wednesday_day") ?? ""
        //            thursday_Day = prefs.string(forKey: "thursday_day") ?? ""
        //            friday_Day = prefs.string(forKey: "friday_day") ?? ""
        //            saturday_Day = prefs.string(forKey: "saturday_day") ?? ""
        //            print("\(monday_Day)")
        //
        //            var startTime = ""
        //            var endTime = ""
        //            //start time
        //
        //            let formatter = DateFormatter()
        //            formatter.dateFormat = "HH:mm"
        //            startTime = formatter.string(from: startTimePicker.date)
        //            rule.rule_config["time_start"] = startTime
        //
        //            endTime = formatter.string(from: endTimePicker.date)
        //            rule.rule_config["time_end"] = endTime
        //            rule.rule_name = nameField.text
        //
        //            if nameField.text?.count == 0 {
        //                let alert = UIAlertView(title: "schedule_screen_time_add_rules_text_content_1".localized, message: "schedule_screen_time_rules_alert_content_1".localized, delegate: nil, cancelButtonTitle: "ok_button".localized)
        //                alert.show()
        //
        //            } else {
        //
        //
        //                let formatter = DateFormatter()
        //                formatter.dateFormat = "HH:mm:ss"
        //                // Start Time
        //                let startTime = formatter.string(from: startTimePicker.date)
        //                if startTime.contains("AM") || startTime.contains("PM") || startTime.contains("am") || startTime.contains("pm") {
        //                    let newStartTime = convert24hrTo12hr(timeToConvert: startTime)
        //                    rule.time_start = newStartTime
        //                } else {
        //                    rule.time_start = startTime
        //                }
        //
        //                // End Time
        //                let endTime = formatter.string(from: endTimePicker.date)
        //                if endTime.contains("AM") || endTime.contains("PM") || endTime.contains("am") || endTime.contains("pm")  {
        //                    let newEndTime = convert24hrTo12hr(timeToConvert: endTime)
        //                    rule.time_end = newEndTime
        //                } else {
        //                    rule.time_end = endTime
        //                }
        //
        //
        //                var params: [String : Any] = [:]
        //                if rule.is_predefined != "1" {
        //                    rule.rule_name = nameField.text ?? "New"
        //                }
        //                params["child_id"] = rule.child_id.integer
        //                params["name"] = rule.rule_name
        //                params["start_time"] = rule.time_start
        //                params["end_time"] = rule.time_end
        //                params["on_monday"] = monday_Day
        //                params["on_tuesday"] = tuesday_Day
        //                params["on_wednesday"] = wednesday_Day
        //                params["on_thursday"] = thursday_Day
        //                params["on_friday"] = friday_Day
        //                params["on_saturday"] = saturday_Day
        //                params["on_sunday"] = sunday_Day
        //                params["status"] = rule.is_active.integer
        //                params["type"] = "timebased"
        //                params["id"] = rule.id
        //                params["function"] = "schedule_screen_time"
        //
        //                var dict: [String: Any] = [:]
        //                dict["safari"] = is_Safari ? "1" : "0"
        //                dict["camera"] = is_Camera ? "1" : "0"
        //                dict["siri"] = is_Siri ? "1" : "0"
        //                dict["itunesStore"] = is_iTunes ? "1" : "0"
        //                dict["installingApps"] = is_installinApps ? "1" : "0"
        //                dict["inappPurchases"] = is_inappPurchases ? "1" : "0"
        //                dict["externalApps"] = is_otherApps ? "1" : "0"
        //
        //                //                params["mdm_payload"] = dict
        //                // Convert the dictionary to JSON data
        //                if let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: []) {
        //                    // Convert JSON data to a string
        //                    if let jsonString = String(data: jsonData, encoding: .utf8) {
        //                        // Assign the JSON string to the mdm_payload parameter
        //                        params["mdm_payload"] = jsonString
        //                    } else {
        //                        print("Error converting JSON data to string")
        //                        // Handle error if unable to convert JSON data to string
        //                    }
        //                } else {
        //                    print("Error converting dictionary to JSON data")
        //                    // Handle error if unable to convert dictionary to JSON data
        //                }
        //
        //                SwiftFTUtils.showHUDAdded(to: self.view, withText: "", animated: true)
        //                let url = HLConstants.BASE_URL_CORE_2 + "controls/schedules"
        //
        //                // Only POST method is used here
        //                CoreManager.networkRequest(url: url, method: .post, params: params) { (response: ScheduleRuleSingleModel?, statusCode, errorMessage) in
        //                    SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
        //                    if statusCode == 200 {
        //                        // NotificationCenter.default.post(name: NSNotification.Name("kRefreshRules"), object: nil)
        //                        if let res = response?.schedule {
        //
        //                            DBManager.shared.saveSchedule(myModelArray: [res])
        //
        //                        }
        //                        self.navigationController?.popViewController(animated: true)
        //                        CommonModel.showAlert("settings_card_5_1".localized, msg: "schedule_screen_time_rules_alert_content_2".localized)
        //                    } else {
        //                        CommonModel.showAlert("alert_error".localized, msg: errorMessage)
        //                        self.navigationController?.popViewController(animated: true)
        //                    }
        //                }
        //
        //
        //                //                if (monday_Day == "1") || (tuesday_Day == "1") || (wednesday_Day == "1") || (thursday_Day == "1") || (friday_Day == "1") || (saturday_Day == "1") || (sunday_Day == "1") {
        //                //
        //                //                    var params: [AnyHashable : Any] = [:]
        //                //                    params["rule_name"] = rule.rule_name
        //                //                    params["time_start"] = startTime
        //                //                    params["time_end"] = endTime
        //                //                    params["is_monday"] = monday_Day
        //                //                    params["is_tuesday"] = tuesday_Day
        //                //                    params["is_wednesday"] = wednesday_Day
        //                //                    params["is_thursday"] = thursday_Day
        //                //                    params["is_friday"] = friday_Day
        //                //                    params["is_saturday"] = saturday_Day
        //                //                    params["is_sunday"] = sunday_Day
        //                //                    params["is_active"] = rule.is_active
        //                //
        //                //                    var dict: [String: Any] = [:]
        //                //
        //                //                    dict["safari"] = is_Safari ? "1" : "0"
        //                //                    dict["camera"] = is_Camera ? "1" : "0"
        //                //                    dict["siri"] = is_Siri ? "1" : "0"
        //                //                    dict["itunesStore"] = is_iTunes ? "1" : "0"
        //                //                    dict["installingApps"] = is_installinApps ? "1" : "0"
        //                //                    dict["inappPurchases"] = is_inappPurchases ? "1" : "0"
        //                //                    dict["externalApps"] = is_otherApps ? "1" : "0"
        //                //
        //                //                    params["rules"] = dict
        //                //                    let url = String(format: "\(kBasUrlNew_mesh2)/dashboard/settings/ios/lst/applock/rule/\(Int(Int(child_Id ?? "") ?? -1))")
        //                //                    var jsonData: Data? = nil
        //                //                    do {
        //                //                        jsonData = try JSONSerialization.data(withJSONObject: params, options: [])
        //                //                    } catch {
        //                //                    }
        //                //                    var myString: String? = nil
        //                //                    if let jsonData = jsonData {
        //                //                        myString = String(data: jsonData, encoding: .utf8)
        //                //                    }
        //                //
        //                //                    UIApplication.shared.beginIgnoringInteractionEvents()
        //                //                    ApiManager.shared().mesh_postApi(withParamString: myString!, withApi: url) { json, errorCode, message in
        //                //                        DispatchQueue.main.async {
        //                //
        //                //                            UIApplication.shared.endIgnoringInteractionEvents()
        //                //                            print("mesh api ios new rule add response = \(json)")
        //                //
        //                //                            if (json["status"] as? NSNumber)?.intValue ?? 0 == 200 {
        //                //                                print("\(json)")
        //                ////                                SwiftFTUtils.showSyncSettingsPopup(with: self)
        //                //                                let dashboardStoryBoard = UIStoryboard(name: "Dashboard", bundle: nil)
        //                //                                let vc = dashboardStoryBoard.instantiateViewController(withIdentifier: "SyncPopUpViewController") as? SyncPopUpViewController ?? SyncPopUpViewController()
        //                //                                vc.modalPresentationStyle = .overFullScreen
        //                //                                self.present(vc, animated: true)
        //                //                                self.navigationController?.popViewController(animated: true)
        //                //                            } else {
        //                //                                CommonModel.showAlert("alert_error".localized, msg: "alert_something_wrong".localized)//json["message"] as? String
        //                //                            }
        //                //
        //                //                            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
        //                //                            self.navigationController?.popViewController(animated: true)
        //                //                        }
        //                //                    }
        //                //                } else {
        //                //                    CommonModel.showAlert("alert_error".localized, msg: "schedule_screen_time_rules_alert_content_3".localized)
        //                //                }
        //            }
        //        }
    }
    
    @objc func handleDelete(_ sender: UIButton?) {
        
        let alertview = UIAlertView(title: "schedule_screen_time_delete_alert_title".localized, message: "schedule_screen_time_delete_alert_content_1".localized, delegate: self, cancelButtonTitle: "cancel_button".localized, otherButtonTitles: "ok_button".localized)
        alertview.tag = sender?.tag ?? 0
        alertview.show()
    }
    
    func UTCToLocalConverter(timeToConvert : String) -> Date {
        let dateFormatter = DateFormatter()
        let locale = Locale.current.identifier
        dateFormatter.calendar = Calendar.current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "HH:mm:ss"
        dateFormatter.locale = Locale(identifier: locale)
        let date12 = dateFormatter.date(from: timeToConvert)
        return date12 ?? Date()
    }
    
    func alertView(_ alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        
        if buttonIndex == 0 {
            return
        }
        
        SwiftFTUtils.showHUDAdded(to: view, withText: "", animated: true)
        let param = ["data": [["child_id": "\(rule.child_id ?? "")",
                               "id": "\(rule.rule_id ?? "")"]]]
        
        guard let childId = rule.child_id, childId != "", rule.rule_id != "" else {
            SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
            return
        }
        
        let url = HLConstants.BASE_URL_CORE_2 + "controls/schedules"
        CoreManager.networkRequest(url: url, method: .delete, params: param) { (response: Empty?, statusCode, errorMessage) in
            SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
            if statusCode != 204{
                CommonModel.showAlert("alert_error".localized, msg: errorMessage)
                self.navigationController?.popViewController(animated: true)
            }else if statusCode == 204{
                CommonModel.showAlert("".localized, msg: "internet_schedules_alert_4_content_1".localized)
                self.navigationController?.popViewController(animated: true)
            }else{
                CommonModel.showAlert("alert_error".localized, msg: "alert_something_wrong".localized)
                self.navigationController?.popViewController(animated: true)
            }
            
        }
        
        //        SwiftFTUtils.showHUDAdded(to: view, withText: "Deleting...", animated: true)
        //        let url = String(format: "\(kBasUrlNew_mesh2)/dashboard/settings/ios/lst/applock/rule/\(Int(Int(child_Id ?? "") ?? -1))/\(rule.id ?? "")")
        //        ApiManager.shared().mesh_deleteApi(withApi: url) { json, errorCode, message in
        //            DispatchQueue.main.async {
        //                print("delete ios child rule native api response = \(json)")
        //                if (json["status"] as? NSNumber)?.intValue ?? 0 != 200 {
        //                    CommonModel.showAlert("alert_error".localized, msg: "alert_something_wrong".localized)//json["message"] as? String
        //                }
        //
        //                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
        //                self.navigationController?.popViewController(animated: true)
        //
        //            }
        //        }
    }
    
    //MARK: - TextField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //  rule.rule_name = textField.text
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        rule.rule_name = textField.text
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        rule.rule_name = textField.text
    }
    
    //MARK: - tableView Data Sourse
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return appsTitles0.count
        } else if section == 1 {
            return appsTitles1.count
        } else {
            return appsTitles2.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return 60
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            let frame = UIScreen.main.bounds
            let view = UIView(frame: CGRect(x: 15, y: 0, width: frame.size.width, height: 60))
            view.backgroundColor = UIColor.groupTableViewBackground
            let label = UILabel(frame: CGRect(x: 15, y: 0, width:frame.size.width - 25, height: 60))
            label.backgroundColor = UIColor.groupTableViewBackground
            label.textColor = RGBCOLOR(138, 138, 138, 1)
            label.font = UIFont(name: "OpenSans", size: 16)
            label.text = "\("schedule_screen_time_rules_content_4".localized)"
            view.addSubview(label)
            return view
        } else if section == 1 || section == 2 {
            let label = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 10))
            label.backgroundColor = UIColor.groupTableViewBackground
            return label
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "LeftSidesCell") as? SettingTableViewCell
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "LeftSidesCell") as? SettingTableViewCell
        }
        if indexPath.section == 0 {
            cell?.cellLabel.text = appsTitles0[indexPath.row]
            cell?.cellImage.image = UIImage(named: appsImages0[indexPath.row])
        } else if indexPath.section == 1 {
            cell?.cellLabel.text = appsTitles1[indexPath.row]
            cell?.cellImage.image = UIImage(named: appsImages1[indexPath.row])
        } else if indexPath.section == 2 {
            cell?.cellLabel.text = appsTitles2[indexPath.row]
            cell?.cellImage.image = UIImage(named: appsImages2[indexPath.row])
        }
        
        cell?.cellSwitch.isHidden = false
        cell?.selectionStyle = .none
        
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                cell?.cellSwitch.isOn = is_Safari
            } else if indexPath.row == 1 {
                cell?.cellSwitch.isOn = is_Camera
            }
            if indexPath.row == 2 {
                cell?.cellSwitch.isOn = is_Siri
            }
            
        } else if indexPath.section == 1 {
            
            if indexPath.row == 0 {
                cell?.cellSwitch.isOn = is_iTunes
            } else if indexPath.row == 1 {
                cell?.cellSwitch.isOn = is_installinApps
            }
            if indexPath.row == 2 {
                cell?.cellSwitch.isOn = is_inappPurchases
            }
            
        } else if indexPath.section == 2 {
            cell?.cellSwitch.isOn = is_otherApps
        }
        
        cell?.onSwitchChange = { cellAffected in
            
            if indexPath.section == 0 && indexPath.row == 0 {
                self.is_Safari = cellAffected?.cellSwitch.isOn ?? false
            } else if indexPath.section == 0 && indexPath.row == 1 {
                self.is_Camera = cellAffected?.cellSwitch.isOn ?? false
            } else if indexPath.section == 0 && indexPath.row == 2 {
                self.is_Siri = cellAffected?.cellSwitch.isOn ?? false
            } else if indexPath.section == 1 && indexPath.row == 0 {
                self.is_iTunes = cellAffected?.cellSwitch.isOn ?? false
            } else if indexPath.section == 1 && indexPath.row == 1 {
                self.is_installinApps = cellAffected?.cellSwitch.isOn ?? false
            } else if indexPath.section == 1 && indexPath.row == 2 {
                self.is_inappPurchases = cellAffected?.cellSwitch.isOn ?? false
            } else if indexPath.section == 2 && indexPath.row == 0 {
                self.is_otherApps = cellAffected?.cellSwitch.isOn ?? false
            }
        }
        return cell ?? UITableViewCell()
        
    }
    
    //MARK: - PickerView
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return hours.count
        } else if component == 1 {
            return minutes.count
        }
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return startTimePicker.frame.width / 3.0
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return startTimePicker.frame.height / 4.0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0 {
            let rowTitle = NSMutableAttributedString(string: hours[row])
            rowTitle.addAttribute(.foregroundColor, value: RGBCOLOR(16, 132, 180, 1), range: NSRange(location: 0, length: rowTitle.length))
            return rowTitle.string
            
        } else if component == 1 {
            let rowTitle = NSMutableAttributedString(string: minutes[row] as? String ?? "")
            rowTitle.addAttribute(.foregroundColor, value: RGBCOLOR(16, 132, 180, 1), range: NSRange(location: 0, length: rowTitle.length))
            return rowTitle.string
            
        } else {
            if row == 0 {
                let rowTitle = NSMutableAttributedString(string: "AM")
                rowTitle.addAttribute(.foregroundColor, value: RGBCOLOR(16, 132, 180, 1), range: NSRange(location: 0, length: rowTitle.length))
                return rowTitle.string
            } else {
                let rowTitle = NSMutableAttributedString(string: "PM")
                rowTitle.addAttribute(.foregroundColor, value: RGBCOLOR(16, 132, 180, 1), range: NSRange(location: 0, length: rowTitle.length))
                return rowTitle.string
            }
        }
    }
    func convert24hrTo12hr(timeToConvert : String) -> String{
        let dateFormatter = DateFormatter()
        let locale = Locale.current.identifier
        dateFormatter.calendar = Calendar.current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.locale = Locale(identifier: locale) // fixes nil if device time in 24 hour format
        let date24 = dateFormatter.date(from: timeToConvert)
        dateFormatter.dateFormat = "HH:mm:ss"
        let date12 = dateFormatter.string(from: date24 ?? Date())
        return date12
    }
}

struct SwitchColors {
    let onTintColor: UIColor?
    let thumbTintColor: UIColor?
    let tintColor: UIColor?
}
