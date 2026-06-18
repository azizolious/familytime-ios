//
//  SwiftAddLimitScreenRuleAndroid.swift
//  FamilyTime
//
//  Created by YumyApps on 09/11/2021.
//  Copyright © 2021 YumyApps. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire

//MARK: - SwiftLimitScreenRuleStatusView1

class SwiftLimitScreenRuleStatusView1: UIView {
    
    //MARK: - VARIABLES
    var imageView = UIImageView()
    var statusLabel = UILabel()
    var statusSwitch = UISwitch()
    
    //MARK: - VIEWS LIFECYLE
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
        statusSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        var labelFont: CGFloat = 0.0
        if IS_IPHONE_4() {
            labelFont = 14.0
        } else if IS_IPHONE_5() {
            labelFont = 14.0
        } else if IS_IPHONE_6() {
            labelFont = 15.0
        } else if IS_IPHONE_6_PLUS() {
            labelFont = 15.0
        } else if IS_IPHONE_X() {
            labelFont = 15.0
        } else {
            labelFont = 20.0
        }

        statusLabel.font = UIFont(name: "OpenSans", size: labelFont)
        
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

//MARK: -SwiftLimitScreenPickerHeaderView1

class SwiftLimitScreenPickerHeaderView1: UIView {
    
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
        addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var labelFont: CGFloat = 0.0
        
        if IS_IPHONE_4() {
            labelFont = 14.0
        } else if IS_IPHONE_5() {
            labelFont = 14.0
        } else if IS_IPHONE_6() {
            labelFont = 15.0
        } else if IS_IPHONE_6_PLUS() {
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

//MARK: - SwiftLimitScreenWeekDaysView1
class SwiftLimitScreenWeekDaysView1: UIView {
    
    var mondayButton = UIButton()
    var tuesdayButton = UIButton()
    var wednesdayButton = UIButton()
    var thursdayButton = UIButton()
    var fridayButton = UIButton()
    var saturdayButton = UIButton()
    var sundayButton = UIButton()
    var rule = RuleModel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        let height = frame.height
        var leftMargin: CGFloat = 0
        
        if IS_IPHONE_4() {
            //height = 30.0f;
            leftMargin = 15.0
        } else if IS_IPHONE_5() {
            //height = 30.0f;
            leftMargin = 15.0
        } else if IS_IPHONE_6() {
            //height = 35.0f;
            leftMargin = 15.0
        } else if IS_IPHONE_6_PLUS() {
            //height = 40.0f;
            leftMargin = 17.0
        } else {
            //height = 50.0f;
            leftMargin = 17.0
        }
        
        let spacesBetweenButtons = ((bounds.width - leftMargin) - (height * 7)) / 7.0
        sundayButton = newButton(withTitle: "S", frame: CGRect(x: leftMargin, y: 0.0, width: height, height: height), enable: true) ?? UIButton()
        sundayButton.tag = 101
        sundayButton.addTarget(self, action: #selector(handleWeekDayButton(_:)), for: .touchUpInside)
        addSubview(sundayButton)
        
        mondayButton = newButton(withTitle: "M", frame: CGRect(x: sundayButton.frame.maxX + spacesBetweenButtons, y: 0.0, width: height, height: height), enable: true) ?? UIButton()
        mondayButton.tag = 102
        mondayButton.addTarget(self, action: #selector(handleWeekDayButton(_:)), for: .touchUpInside)
        addSubview(mondayButton)
        
        tuesdayButton = newButton(withTitle: "T", frame: CGRect(x: mondayButton.frame.maxX + spacesBetweenButtons, y: 0.0, width: height, height: height), enable: true) ?? UIButton()
        tuesdayButton.tag = 103
        tuesdayButton.addTarget(self, action: #selector(handleWeekDayButton(_:)), for: .touchUpInside)
        addSubview(tuesdayButton)
        
        wednesdayButton = newButton(withTitle: "W", frame: CGRect(x: tuesdayButton.frame.maxX + spacesBetweenButtons, y: 0.0, width: height, height: height), enable: true) ?? UIButton()
        wednesdayButton.tag = 104
        wednesdayButton.addTarget(self, action: #selector(handleWeekDayButton(_:)), for: .touchUpInside)
        addSubview(wednesdayButton)
        
        thursdayButton = newButton(withTitle: "T", frame: CGRect(x: wednesdayButton.frame.maxX + spacesBetweenButtons, y: 0.0, width: height, height: height), enable: true) ?? UIButton()
        thursdayButton.tag = 105
        thursdayButton.addTarget(self, action: #selector(handleWeekDayButton(_:)), for: .touchUpInside)
        addSubview(thursdayButton)
        
        fridayButton = newButton(withTitle: "F", frame: CGRect(x: thursdayButton.frame.maxX + spacesBetweenButtons, y: 0.0, width: height, height: height), enable: true) ?? UIButton()
        fridayButton.tag = 106
        fridayButton.addTarget(self, action: #selector(handleWeekDayButton(_:)), for: .touchUpInside)
        addSubview(fridayButton)
        
        saturdayButton = newButton(withTitle: "S", frame: CGRect(x: fridayButton.frame.maxX + spacesBetweenButtons, y: 0.0, width: height, height: height), enable: true) ?? UIButton()
        saturdayButton.tag = 107
        saturdayButton.addTarget(self, action: #selector(handleWeekDayButton(_:)), for: .touchUpInside)
        addSubview(saturdayButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func newButton(withTitle title: String?, frame: CGRect, enable: Bool) -> UIButton? {
        var fontSize: CGFloat = 0.0
        if IS_IPHONE_4() {
            fontSize = 22
        } else if IS_IPHONE_5() {
            fontSize = 22.0
        } else if IS_IPHONE_6() {
            fontSize = 23.0
        } else if IS_IPHONE_6_PLUS() {
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
    
    func setRule(_ rule: RuleModel?) {

        self.rule = rule!
        applyRule(on: sundayButton, isOn: (rule?.on_sunday == "1"))
        applyRule(on: mondayButton, isOn: (rule?.on_monday == "1"))
        applyRule(on: tuesdayButton, isOn: (rule?.on_tuesday == "1"))
        applyRule(on: wednesdayButton, isOn: (rule?.on_wednesday == "1"))
        applyRule(on: thursdayButton, isOn: (rule?.on_thursday == "1"))
        applyRule(on: fridayButton, isOn: (rule?.on_friday == "1"))
        applyRule(on: saturdayButton, isOn: (rule?.on_saturday == "1"))
        
        self.rule.on_sunday = rule?.on_sunday
        self.rule.on_monday = rule?.on_monday
        self.rule.on_tuesday = rule?.on_tuesday
        self.rule.on_wednesday = rule?.on_wednesday
        self.rule.on_thursday = rule?.on_thursday
        self.rule.on_friday = rule?.on_friday
        self.rule.on_saturday = rule?.on_saturday
    }
    
    func applyRule(on button: UIButton?, isOn: Bool) {
        
        button?.setTitleColor(isOn ? UIColor.white : UIColor.lightGray, for: .normal)
        button?.layer.borderColor = isOn ? RGBCOLOR(16, 132, 180, 1).cgColor : UIColor.lightGray.cgColor
        button?.layer.backgroundColor = isOn ? RGBCOLOR(16, 132, 180, 1).cgColor : UIColor.clear.cgColor
        button?.setNeedsDisplay()
    }
    
    @objc func handleWeekDayButton(_ button: UIButton?) {

        print("\(rule)")
        let data = UserDefaults.standard
        
        if button?.tag == 101 {//sunday
            print("\(rule.on_sunday ?? "")")

            if rule.on_sunday == "1" {
                rule.on_sunday = "0"
                button?.setTitleColor(UIColor.lightGray, for: .normal)
                button?.layer.borderColor = UIColor.lightGray.cgColor
                button?.layer.backgroundColor = UIColor.clear.cgColor
                
            } else {
                rule.on_sunday = "1"
                button?.setTitleColor(UIColor.white, for: .normal)
                button?.layer.borderColor = RGBCOLOR(16, 132, 180, 1).cgColor
                button?.layer.backgroundColor = RGBCOLOR(16, 132, 180, 1).cgColor
            }
            
        } else if button?.tag == 102 {//Monday
            
            if rule.on_monday == "1" {
                rule.on_monday = "0"
                data.setValue("0", forKey: "monday_day")
                rule.on_monday = "0"
                button?.setTitleColor(UIColor.lightGray, for: .normal)
                button?.layer.borderColor = UIColor.lightGray.cgColor
                button?.layer.backgroundColor = UIColor.clear.cgColor
                
            } else {
                rule.on_monday = "1"
                data.setValue("1", forKey: "monday_day")
                rule.on_monday = "1"
                button?.setTitleColor(UIColor.white, for: .normal)
                button?.layer.borderColor = RGBCOLOR(16, 132, 180, 1).cgColor
                button?.layer.backgroundColor = RGBCOLOR(16, 132, 180, 1).cgColor
            }
            
        } else if button?.tag == 103 {//tuesday
            
            if rule.on_tuesday == "1" {
                rule.on_tuesday = "0"
                data.setValue("0", forKey: "tuesday_day")
                rule.on_tuesday = "0"

                button?.setTitleColor(UIColor.lightGray, for: .normal)
                button?.layer.borderColor = UIColor.lightGray.cgColor
                button?.layer.backgroundColor = UIColor.clear.cgColor
            } else {
                rule.on_tuesday = "1"
                rule.on_tuesday = "1"
                data.setValue("1", forKey: "tuesday_day")
                button?.setTitleColor(UIColor.white, for: .normal)
                button?.layer.borderColor = RGBCOLOR(16, 132, 180, 1).cgColor
                button?.layer.backgroundColor = RGBCOLOR(16, 132, 180, 1).cgColor
            }
            
        } else if button?.tag == 104 {//wednesday
            
            if rule.on_wednesday == "1" {
                rule.on_wednesday = "0"
                rule.on_wednesday = "0"
                data.setValue("0", forKey: "wednesday_day")
                button?.setTitleColor(UIColor.lightGray, for: .normal)
                button?.layer.borderColor = UIColor.lightGray.cgColor
                button?.layer.backgroundColor = UIColor.clear.cgColor
            } else {
                rule.on_wednesday = "1"
                rule.on_wednesday = "1"
                data.setValue("1", forKey: "wednesday_day")
                button?.setTitleColor(UIColor.white, for: .normal)
                button?.layer.borderColor = RGBCOLOR(16, 132, 180, 1).cgColor
                button?.layer.backgroundColor = RGBCOLOR(16, 132, 180, 1).cgColor
            }
            
        } else if button?.tag == 105 {//thursday
            
            if rule.on_thursday == "1" {
                rule.on_thursday = "0"
                rule.on_thursday = "0"
                data.setValue("0", forKey: "thursday_day")
                button?.setTitleColor(UIColor.lightGray, for: .normal)
                button?.layer.borderColor = UIColor.lightGray.cgColor
                button?.layer.backgroundColor = UIColor.clear.cgColor
            } else {
                self.rule.on_thursday = "1"
                rule.on_thursday = "1"
                data.setValue("1", forKey: "thursday_day")
                button?.setTitleColor(UIColor.white, for: .normal)
                button?.layer.borderColor = RGBCOLOR(16, 132, 180, 1).cgColor
                button?.layer.backgroundColor = RGBCOLOR(16, 132, 180, 1).cgColor
            }
            
        } else if button?.tag == 106 {//friday
            
            if rule.on_friday == "1" {
                rule.on_friday = "0"
                rule.on_friday = "0"
                data.setValue("0", forKey: "friday_day")
                button?.setTitleColor(UIColor.lightGray, for: .normal)
                button?.layer.borderColor = UIColor.lightGray.cgColor
                button?.layer.backgroundColor = UIColor.clear.cgColor
            } else {
                rule.on_friday = "1"
                rule.on_friday = "1"
                data.setValue("1", forKey: "friday_day")
                button?.setTitleColor(UIColor.white, for: .normal)
                button?.layer.borderColor = RGBCOLOR(16, 132, 180, 1).cgColor
                button?.layer.backgroundColor = RGBCOLOR(16, 132, 180, 1).cgColor
            }
            
        } else if button?.tag == 107 {//saturday
            
            if rule.on_saturday == "1" {
                rule.on_saturday = "0"
                rule.on_saturday = "0"
                data.setValue("0", forKey: "saturday_day")
                button?.setTitleColor(UIColor.lightGray, for: .normal)
                button?.layer.borderColor = UIColor.lightGray.cgColor
                button?.layer.backgroundColor = UIColor.clear.cgColor
                
            } else {
                rule.on_saturday = "1"
                rule.on_saturday = "1"
                data.setValue("1", forKey: "saturday_day")
                button?.setTitleColor(UIColor.white, for: .normal)
                button?.layer.borderColor = RGBCOLOR(16, 132, 180, 1).cgColor
                button?.layer.backgroundColor = RGBCOLOR(16, 132, 180, 1).cgColor
            }
        }
        
        data.synchronize()
    }
}

//MARK: - SwiftAddLimitScreenRuleAndroid

class SwiftAddLimitScreenRuleAndroid: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIAlertViewDelegate {
    
    let delegate = UIApplication.shared.delegate as? AppDelegate
    
    var scrollView = UIScrollView()
    var statusView = SwiftLimitScreenRuleStatusView1()
    var nameField = UITextField()
    var firstHeaderView = SwiftLimitScreenPickerHeaderView1()
    var secondHeaderView = SwiftLimitScreenPickerHeaderView1()
    var repeatHeaderView = SwiftLimitScreenPickerHeaderView1()
    var weekDaysView = SwiftLimitScreenWeekDaysView1()
    var startTimePicker = UIDatePicker()
    var endTimePicker = UIDatePicker()
    var hours = [String]()
    var minutes = [String]()
    
    var isNew = false
    var isCustom = false
    var rule = RuleModel()
    var sunday_Day: String = ""
    var monday_Day: String = ""
    var tuesday_Day: String = ""
    var wednesday_Day: String = ""
    var thursday_Day: String = ""
    var friday_Day: String = ""
    var saturday_Day: String = ""
    let child_Id = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.set("NO", forKey: "gobacknow")
        UserDefaults.standard.synchronize()
        view.backgroundColor = UIColor.white
        
        hours = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
        for index in 0..<60 {
            minutes.append(String(format: "%02ld", index))
        }
        
        if isNew {
            rule.child_id = NSNumber(value: Int(child_Id ?? "") ?? -1).stringValue
            rule.rule_name = ""
            rule.time_start = ""
            rule.time_end = ""
            rule.on_sunday = "0"
            rule.on_monday = "0"
            rule.on_tuesday = "0"
            rule.on_wednesday = "0"
            rule.on_thursday = "0"
            rule.on_friday = "0"
            rule.on_saturday = "0"
            rule.rule_type = "timebased"
            rule.rule_function = "phonelock"
            let data = UserDefaults.standard
            data.setValue("0", forKey: "monday_day")
            data.setValue("0", forKey: "tuesday_day")
            data.setValue("0", forKey: "wednesday_day")
            data.setValue("0", forKey: "thursday_day")
            data.setValue("0", forKey: "friday_day")
            data.setValue("0", forKey: "saturday_day")
            data.setValue("0", forKey: "sunday_day")
            rule.is_active = "1"
        }
        
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(handleSave(_:)))

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
    
    @objc func handleStatusSwitch(_ switchView: UISwitch?) {
        
        if switchView?.isOn ?? false {
            rule.is_active = "1"
            statusView.statusLabel.text = "schedule_screen_time_rules_switch_1_content_1".localized
        } else {
            rule.is_active = "0"
            statusView.statusLabel.text = "schedule_screen_time_rules_switch_1_content_2".localized
        }
    }
    
    func setupUI() {
        
        var verticalMargin: CGFloat = 0
        var weekdaysViewHeight: CGFloat = 0
        var headerViewHeight: CGFloat = 0
        var timePickerHeight: CGFloat
        var nameFieldHeight: CGFloat = 0
        var statusViewHeight: CGFloat = 0
        var switchViewSclaeFactor: CGFloat = 0.75
        
        if IS_IPHONE_4() {
            
            verticalMargin = 10.0
            weekdaysViewHeight = 35
            headerViewHeight = 20.0
            timePickerHeight = 100.0
            nameFieldHeight = 25.0
            statusViewHeight = 40.0
            switchViewSclaeFactor = 1.0
            
        } else if IS_IPHONE_5() {
            
            verticalMargin = 15.0
            weekdaysViewHeight = 35
            headerViewHeight = 25.0
            timePickerHeight = 120.0
            nameFieldHeight = 30.0
            statusViewHeight = 40.0
            switchViewSclaeFactor = 1.0
            
        } else if IS_IPHONE_6() {
            
            verticalMargin = 25.0
            weekdaysViewHeight = 40
            headerViewHeight = 35.0
            timePickerHeight = 130.0
            nameFieldHeight = 35.0
            statusViewHeight = 40.0
            switchViewSclaeFactor = 1.0
            
        } else if IS_IPHONE_6_PLUS() {
            
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
        
        title = isNew ? "schedule_screen_add_rules_title".localized : rule.rule_name
        title = title?.localized
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        scrollView.backgroundColor = UIColor.clear
        view.addSubview(scrollView)
        
        statusView = SwiftLimitScreenRuleStatusView1(frame: CGRect(x: 0.0, y: 0.0, width: view.bounds.width, height: statusViewHeight))
        scrollView.addSubview(statusView)
        statusView.statusSwitch.transform = CGAffineTransform(scaleX: switchViewSclaeFactor, y: switchViewSclaeFactor)
        statusView.statusLabel.text = (Int(rule.is_active) == 1) ? "schedule_screen_time_rules_switch_1_content_1".localized : "schedule_screen_time_rules_switch_1_content_2".localized
        
        statusView.imageView.image = CommonModel.image(forHeaderSST: rule.rule_name) // [self imageForHeader:self.rule];
        statusView.statusSwitch.isOn = (Int(rule.is_active ?? "0") == 1) ? true : false
        statusView.statusSwitch.addTarget(self, action: #selector(handleStatusSwitch(_:)), for: .valueChanged)
        
        if isNew || Int(rule.is_predefined ?? "0") == 0 {
            
            nameField = UITextField(frame: CGRect(x: 20.0, y: statusView.frame.maxY + verticalMargin, width: view.bounds.width - 40.0, height: nameFieldHeight))
            nameField.placeholder = " \("schedule_screen_time_add_rules_text_content_1".localized)"
            nameField.font = UIFont(name: "OpenSans", size: 13.0)
            nameField.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
            nameField.layer.borderWidth = 1.0
            nameField.layer.cornerRadius = 3.0
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 20))
            nameField.leftView = paddingView
            nameField.leftViewMode = .always
            nameField.delegate = self
            nameField.returnKeyType = .done
            nameField.text = rule.rule_name
            scrollView.addSubview(nameField)
        }
        
        if isNew || Int(rule.is_predefined ?? "0") == 0 {
            
            firstHeaderView = SwiftLimitScreenPickerHeaderView1(frame: CGRect(x: 0.0, y: nameField.frame.maxY + verticalMargin, width: view.bounds.width, height: headerViewHeight))
            scrollView.addSubview(firstHeaderView)
            
        } else {
            firstHeaderView = SwiftLimitScreenPickerHeaderView1(frame: CGRect(x: 0.0, y: statusView.frame.maxY + verticalMargin, width: view.bounds.width, height: headerViewHeight))
            scrollView.addSubview(firstHeaderView)
        }
        
        firstHeaderView.imageView.image = UIImage(named: "ic_clock")
        firstHeaderView.label.text = "schedule_screen_time_rules_content_1".localized

        if #available(iOS 14.0, *) {
            
            if IS_IPHONE_5() {
                startTimePicker = UIDatePicker(frame: CGRect(x: view.center.x - 155, y: firstHeaderView.frame.maxY, width: view.bounds.width, height: timePickerHeight))
            } else if IS_IPHONE_6() {
                startTimePicker = UIDatePicker(frame: CGRect(x: view.center.x - 160, y: firstHeaderView.frame.maxY, width: view.bounds.width, height: timePickerHeight))
            } else if IS_IPHONE_6_PLUS() {
                startTimePicker = UIDatePicker(frame: CGRect(x: view.center.x - 165, y: firstHeaderView.frame.maxY, width: view.bounds.width, height: timePickerHeight))
            } else if IS_IPHONE_X() {
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
            let start_date = UTCToLocalConverter(timeToConvert: rule.time_start ?? "")
            startTimePicker.date = start_date
        }
        
        secondHeaderView = SwiftLimitScreenPickerHeaderView1(frame: CGRect(x: 0.0, y: startTimePicker.frame.maxY + verticalMargin, width: view.bounds.width, height: headerViewHeight))
        scrollView.addSubview(secondHeaderView)
        secondHeaderView.imageView.image = UIImage(named: "ic_clock")
        secondHeaderView.label.text = "schedule_screen_time_rules_content_2".localized
        endTimePicker.tintColor = RGBCOLOR(16, 132, 180, 1)
        endTimePicker.tag = 102
        
        if #available(iOS 14.0, *) {
            
            if IS_IPHONE_5() {
                endTimePicker = UIDatePicker(frame: CGRect(x: view.center.x - 155, y: secondHeaderView.frame.maxY, width: view.bounds.width, height: timePickerHeight))
            } else if IS_IPHONE_6() {
                endTimePicker = UIDatePicker(frame: CGRect(x: view.center.x - 160, y: secondHeaderView.frame.maxY, width: view.bounds.width, height: timePickerHeight))
            } else if IS_IPHONE_6_PLUS() {
                endTimePicker = UIDatePicker(frame: CGRect(x: view.center.x - 165, y: secondHeaderView.frame.maxY, width: view.bounds.width, height: timePickerHeight))
            } else if IS_IPHONE_X() {
                endTimePicker = UIDatePicker(frame: CGRect(x: view.center.x - 162, y: secondHeaderView.frame.maxY, width: view.bounds.width, height: timePickerHeight))
            } else {
                endTimePicker = UIDatePicker(frame: CGRect(x: view.center.x - 170, y: secondHeaderView.frame.maxY, width: view.bounds.width, height: timePickerHeight))
            }
            
            endTimePicker.preferredDatePickerStyle = .wheels
            
        } else {
            // Fallback on earlier versions
            endTimePicker = UIDatePicker(frame: CGRect(x: 0.0, y: secondHeaderView.frame.maxY, width: view.bounds.width, height: timePickerHeight))
        }
        
        self.endTimePicker.datePickerMode = .time
        endTimePicker.setValue(RGBCOLOR(16, 132, 180, 1), forKey: "textColor")
        scrollView.addSubview(endTimePicker)
        
        if !isNew {
            let end_date = UTCToLocalConverter(timeToConvert: rule.time_end ?? "")
            endTimePicker.date = end_date
        }
        
        repeatHeaderView = SwiftLimitScreenPickerHeaderView1(frame: CGRect(x: 0.0, y: endTimePicker.frame.maxY + verticalMargin, width: view.bounds.width, height: headerViewHeight))
        scrollView.addSubview(repeatHeaderView)
        repeatHeaderView.imageView.image = UIImage(named: "blue_refresh")
        repeatHeaderView.label.text = "schedule_screen_time_rules_content_3".localized
        
        weekDaysView = SwiftLimitScreenWeekDaysView1(frame: CGRect(x: 0.0, y: repeatHeaderView.frame.maxY, width: view.bounds.width, height: weekdaysViewHeight))
        scrollView.addSubview(weekDaysView)
        weekDaysView.setRule(rule)
        weekDaysView.rule = rule
        
        if Int(rule.is_predefined ?? "0") == 0 && !isNew {
            
            let deleteButton = UIButton(type: .custom)
            deleteButton.setImage(UIImage(named: "delete"), for: .normal)
            deleteButton.frame = CGRect(x: 15.0, y: weekDaysView.frame.maxY + 10, width: 30, height: 30)
            deleteButton.addTarget(self, action: #selector(handleDelete(_:)), for: .touchUpInside)
            deleteButton.tag = Int(rule.rule_id) ?? 0
            scrollView.addSubview(deleteButton)

            scrollView.contentSize = CGSize(width: view.bounds.width, height: deleteButton.frame.maxY + 10 + 70)
        } else {
            scrollView.contentSize = CGSize(width: view.bounds.width, height: weekDaysView.frame.maxY + 10 + 70)
        }
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
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        if component == 0 {
            let rowTitle = NSMutableAttributedString(string: hours[row])
            rowTitle.addAttribute(.foregroundColor, value: RGBCOLOR(16, 132, 180, 1), range: NSRange(location: 0, length: rowTitle.length))
            return rowTitle
            
        } else if component == 1 {
            let rowTitle = NSMutableAttributedString(string: minutes[row])
            rowTitle.addAttribute(.foregroundColor, value: RGBCOLOR(16, 132, 180, 1), range: NSRange(location: 0, length: rowTitle.length))
            return rowTitle
            
        } else {
            
            if row == 0 {
                let rowTitle = NSMutableAttributedString(string: "AM")
                rowTitle.addAttribute(.foregroundColor, value: RGBCOLOR(16, 132, 180, 1), range: NSRange(location: 0, length: rowTitle.length))
                return rowTitle
                
            } else {
                let rowTitle = NSMutableAttributedString(string: "PM")
                rowTitle.addAttribute(.foregroundColor, value: RGBCOLOR(16, 132, 180, 1), range: NSRange(location: 0, length: rowTitle.length))
                return rowTitle
            }
        }
    }
    
//MARK: - End PickerView
    
    func convert24hrTo12hr(timeToConvert : String) -> String{
        let dateFormatter = DateFormatter()
        let locale = Locale.current.identifier
        dateFormatter.calendar = Calendar.current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "hh:mm:ss a"
        dateFormatter.locale = Locale(identifier: locale) // fixes nil if device time in 24 hour format
        let date24 = dateFormatter.date(from: timeToConvert)
        dateFormatter.dateFormat = "HH:mm:ss"
        let date12 = dateFormatter.string(from: date24 ?? Date())
        return date12
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
            
            var ruleNew = ""

            if !isNew {
                ruleNew = rule.rule_id
            }
            
            var params: [String : Any] = [:]
            if rule.is_predefined != "1" {
                rule.rule_name = nameField.text ?? "New"
            }
            params["child_id"] = rule.child_id.integer
            params["name"] = rule.rule_name
            params["start_time"] = rule.time_start
            params["end_time"] = rule.time_end
            params["on_monday"] = rule.on_monday.integer
            params["on_tuesday"] = rule.on_tuesday.integer
            params["on_wednesday"] = rule.on_wednesday.integer
            params["on_thursday"] = rule.on_thursday.integer
            params["on_friday"] = rule.on_friday.integer
            params["on_saturday"] = rule.on_saturday.integer
            params["on_sunday"] = rule.on_sunday.integer
            params["status"] = rule.is_active.integer
            params["type"] = rule.rule_type ?? "timebased"
            if !isNew {
                params["id"] = ruleNew.integer
                params["function"] = rule.rule_function
            } else {
                params["function"] = "schedule_screen_time"
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
//            if let value = params["on_monday"], let value1 = params["on_tuesday"], let value2 = params["on_wednesday"], let value3 = params["on_thursday"], let value4 = params["on_friday"], let value5 = params["on_saturday"], let value6 = params["on_sunday"] {
//                
//                if ("\(value)" == "1") || ("\(value1)" == "1") || ("\(value2)" == "1") || ("\(value3)" == "1") || ("\(value4)" == "1") || ("\(value5)" == "1") || ("\(value6)" == "1") {
//                    
//                    let url = String(format: "\(kBasUrlNew_mesh2)/dashboard/settings/android/lst/screenlock/rules/\(Int(child_Id ?? "") ?? -1))")
//                    var jsonData: Data? = nil
//                    do {
//                        jsonData = try JSONSerialization.data(withJSONObject: params, options: [])
//                    } catch {
//                    }
//                    var myString: String? = nil
//                    if let jsonData = jsonData {
//                        myString = String(data: jsonData, encoding: .utf8)
//                    }
//                    print("Put api URL = \(url) and params = \(myString ?? "")")
//                    UIApplication.shared.beginIgnoringInteractionEvents()
//                    //Native Api Calling
//                    
//                    ApiManager.shared().putApi(url, params: params, controller: self, isContPresented: false) { msg, code in
//                        DispatchQueue.main.async {
//                            UIApplication.shared.endIgnoringInteractionEvents()
//                            SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
//                            self.viewDidDisappear(true)
//                            
//                            if code == 200 {
//                                NotificationCenter.default.post(name: NSNotification.Name("kRefreshRules"), object: nil)
//                                self.navigationController?.popViewController(animated: true)
//                                CommonModel.showAlert("settings_card_5_1".localized, msg: "schedule_screen_time_rules_alert_content_2".localized)
//                            } else {
//                                CommonModel.showAlert("alert_error".localized, msg: msg)
//                                self.navigationController?.popViewController(animated: true)
//                            }
//                        }
//                    }
//                    
//                } else {
//                    CommonModel.showAlert("alert_error".localized, msg: "schedule_screen_time_rules_alert_content_3".localized)
//                }
//            }
        }
    }
    
    @objc func handleDelete(_ sender: UIButton?) {
        
        let alertview = UIAlertView(title: "schedule_screen_time_delete_alert_title".localized, message: "schedule_screen_time_delete_alert_content_1".localized, delegate: self, cancelButtonTitle: "cancel_button".localized, otherButtonTitles: "ok_button".localized)
        alertview.tag = sender?.tag ?? 0
        alertview.show()
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
//        let url = String(format: "\(kBasUrlNew_mesh2)/dashboard/settings/android/lst/screenlock/rules/\(Int(child_Id ?? "") ?? -1)/\(rule.rule_id ?? "")")
//        print("\(url)")
        
        //Native Api Calling
//        ApiManager.shared().deleteApi(withParams: [:], andUrl: url, andController: self) { message, code in
//            
//            DispatchQueue.main.async {
//                print("delete ios child rule native api response = \(message)")
//                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
//                if code == 200 {
//                    self.navigationController?.popViewController(animated: true)
//                } else {
//                    CommonModel.showAlert("alert_error".localized, msg: "alert_something_wrong".localized)
//                    self.navigationController?.popViewController(animated: true)
//                }
//            }
//        }
    }
    
//MARK: - TextField
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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
}



