//
//  AddInternetScheduleVC.swift
//  FamilyTime
//
//  Created by Sana-Ullah-IOS on 30/01/2020.
//  Copyright © 2020 YumyApps. All rights reserved.
//

import UIKit
import RangeSeekSlider

class AddInternetScheduleVC: UIViewController {

    @IBOutlet weak var enableLbl: UILabel!
    @IBOutlet weak var enableSwitch: AppBlockerSwitch!
    
    @IBOutlet weak var nameTf: SkyFloatingLabelTextField!
    
    @IBOutlet weak var nameFieldVuHeightConst: NSLayoutConstraint!
    @IBOutlet weak var startTimeTitleLbl:   UILabel!
    @IBOutlet weak var startTimeLbl:        UILabel!
    @IBOutlet weak var endTimeTitleLbl:     UILabel!
    @IBOutlet weak var endTimeLbl:          UILabel!
    
    
    
    @IBOutlet weak var rangeSlider: RangeSeekSlider!
    
    //@IBOutlet weak var rangeCircularSlider: RangeCircularSlider!
    
    @IBOutlet weak var weekDayLbl: UILabel!
    
//    @IBOutlet weak var sundayLbl:    UILabel!
//    @IBOutlet weak var mondayLbl:    UILabel!
//    @IBOutlet weak var tuesdayLbl:   UILabel!
//    @IBOutlet weak var wednesdayLbl: UILabel!
//    @IBOutlet weak var thursdayLbl:  UILabel!
//    @IBOutlet weak var fridayLbl:    UILabel!
//    @IBOutlet weak var saturdayLbl:  UILabel!
    
//    @IBOutlet weak var sundayVu:    UIView!
//    @IBOutlet weak var mondayVu:    UIView!
//    @IBOutlet weak var tuesdayVu:   UIView!
//    @IBOutlet weak var wednesdayVu: UIView!
//    @IBOutlet weak var thursdayVu:  UIView!
//    @IBOutlet weak var fridayVu:    UIView!
//    @IBOutlet weak var saturdayVu:  UIView!
    
    @IBOutlet weak var sundayBtn:    UIButton!
    @IBOutlet weak var mondayBtn:    UIButton!
    @IBOutlet weak var tuesdayBtn:   UIButton!
    @IBOutlet weak var wednesdayBtn: UIButton!
    @IBOutlet weak var thursdayBtn:  UIButton!
    @IBOutlet weak var fridayBtn:    UIButton!
    @IBOutlet weak var saturdayBtn:  UIButton!
        
//    @IBOutlet weak var durationHourLbl:     UILabel!
//    @IBOutlet weak var durationMinLabel:    UILabel!
    
    var rule = InternetScheduleInnerModel()
    var isNew = false
    var delegate : AppDelegate?
    let child_Id = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
    
    var dayButtonsArray = [UIButton]()

    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ZendeskChatManager.trackEvent("Add Internet Schedule")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func initialization(){
        
        dayButtonsArray = [sundayBtn, mondayBtn, tuesdayBtn, wednesdayBtn, thursdayBtn, fridayBtn, saturdayBtn]
//        UserDefaults.standard.set("NO", forKey: "gobacknow")
//        UserDefaults.standard.synchronize()
        
        self.enableLbl.text = "schedule_screen_time_rules_switch_1_content_2".localized
        self.startTimeTitleLbl.text = "schedule_screen_time_rules_content_1".localized
        self.endTimeTitleLbl.text = "schedule_screen_time_rules_content_2".localized
        self.weekDayLbl.text = "internet_schedules_content_2".localized
        delegate = AppDelegate.getSharedAppDelegateForSwift()
        
        if isNew{
            rule = SwiftCommonUtility.shared.getInitializedNewInternetSchedule()
        }
        
        setSlider()
        setRule()
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .save, target: self, action: #selector(handleSave))
        
        title = isNew ? "settings_card_2_android_4".localized : rule.rule_name
        enableSwitch.setOn(rule.is_active == "1" ? true : false, animated: true)
        enableSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        updateViewsStatusEnableOrDisable(isEnable: rule.is_active == "1" ? true : false)
        nameTf.placeholder  = "internet_schedules_content_1".localized
        if isNew || rule.is_predefined == "0"{
            nameTf.placeholder  = "internet_schedules_content_1".localized
            nameTf.leftViewMode = .always
            
//            nameTf.isHidden     = false
//            nameFieldVuHeightConst.constant = 60
        }
        else{
            nameTf.isUserInteractionEnabled = false
        }
        
        nameTf.text = rule.rule_name
        
        if !SwiftFTUtils.isDeviceiPhoneFamily(){
            _ = dayButtonsArray.map{
                $0.layer.cornerRadius = dayButtonsArray[0].frame.width/2
                $0.layer.masksToBounds = true
            }
        }
    
//        MultilingualUtility.shared.lingualForAddRule(vc: self)
    }

    func setSlider(){
        
        rangeSlider.delegate = self //as? RangeSeekSliderDelegate
        
//        let dayInSeconds = 24 * 60 * 60
        
//        rangeSlider.maxValue    = CGFloat(dayInSeconds)
        
        rangeSlider.minValue = 0
        rangeSlider.maxValue = 48
        rangeSlider.step     = 1
        rangeSlider.enableStep = true
        rangeSlider.minDistance = 1
        
//        rangeSlider.distan
        
        let startMinutes = SwiftCommonUtility.shared.getParsedTimeInMinutes(time: rule.time_start ?? "")
        let endMinutes   = SwiftCommonUtility.shared.getParsedTimeInMinutes(time: rule.time_end ?? "")
        
        rangeSlider.selectedMinValue = CGFloat(startMinutes / 30)
        rangeSlider.selectedMaxValue = CGFloat(endMinutes / 30)
        
        startTimeLbl.text = calculateTime(minutes: startMinutes)
        endTimeLbl.text   = calculateTime(minutes: endMinutes)
        
    }
    
//    @IBAction func updateTexts(_ sender: RangeSeekSlider) {
//
//        print("min val = \(sender.minValue) maxValue = \(sender.maxValue) distance = \(sender.maxDistance)")
//    }
    
//    @IBAction func updateTexts(_ sender: AnyObject)
//    {
        /*
//        adjustValue(value: &rangeCircularSlider.startPointValue)
//        adjustValue(value: &rangeCircularSlider.endPointValue)
//
//        print("Valuee==")
//        print(rangeCircularSlider.startPointValue)
//        print(rangeCircularSlider.endPointValue)
                
        let bedtime = TimeInterval(rangeCircularSlider.startPointValue)
        let bedtimeDate = Date(timeIntervalSinceReferenceDate: bedtime)
        
        var dateString = dateFormatter.string(from: bedtimeDate)
        var dateArr = dateString.split(separator: " ")
        
        startTimeLbl.text = String(dateArr.first ?? "")
        startPmLbl.text   = String(dateArr.last  ?? "")
        
        let wake = TimeInterval(rangeCircularSlider.endPointValue)
        let wakeDate = Date(timeIntervalSinceReferenceDate: wake)
        
        dateString = dateFormatter.string(from: wakeDate)
        dateArr = dateString.split(separator: " ")
        
        endTimeLbl.text = String(dateArr.first ?? "")
        endPmLbl.text   = String(dateArr.last  ?? "")        
        
        let duration = wake - bedtime
        let durationDate = Date(timeIntervalSinceReferenceDate: duration)
        dateFormatter.dateFormat = "HH:mm"
        
        dateString = dateFormatter.string(from: durationDate)
        dateArr = dateString.split(separator: ":")
        durationHourLbl.text  = String(dateArr.first ?? "")
        durationMinLabel.text = String(dateArr.last ?? "")
        
        dateFormatter.dateFormat = "hh:mm a"
        
        print(duration)
 
 */
        
//    }
    
    @objc func handleSave(){
        
        nameTf.resignFirstResponder()
        
        updateRuleTime()
        
        //---AT LEAST ONE DAY MUST BE SELECTED---//
            if  nameTf.text == ""{
                CommonModel.showAlert("internet_schedules_alert_1_content_1".localized, msg: "schedule_screen_time_rules_alert_content_1".localized)
            }
        else if rule.is_sunday! == "0" && rule.is_monday! == "0" && rule.is_tuesday! == "0" && rule.is_wednesday! == "0" && rule.is_thursday! == "0" && rule.is_friday! == "0" && rule.is_saturday! == "0"{
            CommonModel.showAlert("alert_error".localized, msg: "schedule_screen_time_rules_alert_content_3".localized)
        }
        else{
            updateRuleApiCall()
        }
    }
    
    func adjustValue(value: inout CGFloat) {
        let minutes = value / 60
        let adjustedMinutes =  ceil(minutes / 5.0) * 5
        value = adjustedMinutes * 60
    }
    
    func applyRuleOnLabel(btn:UIButton, isOn:Bool){
//        lbl.textColor = isOn ? UIColor.FTOrange : UIColor.lightGray
        btn.setTitleColor(isOn ? UIColor.white : UIColor.lightGray, for: .normal)
        btn.backgroundColor = isOn ? UIColor.FTOrange : UIColor.white
        btn.layer.borderColor = isOn ? UIColor.FTOrange.cgColor : UIColor.lightGray.cgColor
//        bottomVu.backgroundColor = isOn ? UIColor.FTOrange : UIColor.lightGray
    }
    
    func setRule(){
        applyRuleOnLabel(btn: sundayBtn,    isOn: (rule.is_sunday    ?? "") == "1")
        applyRuleOnLabel(btn: mondayBtn,    isOn: (rule.is_monday    ?? "") == "1")
        applyRuleOnLabel(btn: tuesdayBtn,   isOn: (rule.is_tuesday   ?? "") == "1")
        applyRuleOnLabel(btn: wednesdayBtn, isOn: (rule.is_wednesday ?? "") == "1")
        applyRuleOnLabel(btn: thursdayBtn,  isOn: (rule.is_thursday  ?? "") == "1")
        applyRuleOnLabel(btn: fridayBtn,    isOn: (rule.is_friday    ?? "") == "1")
        applyRuleOnLabel(btn: saturdayBtn,  isOn: (rule.is_saturday  ?? "") == "1")
    }
    
    func updateRuleTime()
    {
        rule.time_start = SwiftCommonUtility.shared.getFormatedTimeForInternetScheduleWith(time: startTimeLbl.text ?? "")
        rule.time_end   = SwiftCommonUtility.shared.getFormatedTimeForInternetScheduleWith(time: endTimeLbl.text ?? "")
        
        print(rule.time_start ?? "")
        print(rule.time_end ?? "")
    }
    
    
    func updateRuleApiCall(){
//        var params = SwiftParamUtility.shared.changeInternetScheduleParams(isActive: enableSwitch.isOn, isNewRule: isNew, rule: rule) //getParamsForRule(rule:rule, isNew:isNew)
//        print("add or update rule parms = \(params)")
//        
//        var URL = ""
//        
//        if isNew{
//            URL = SwiftAPIConstants.kGetPost_InternetSchedules_mesh2 + "\(String(describing: child_Id ?? "0"))"
//        }
//        else{
//            URL = SwiftAPIConstants.kGetPost_InternetSchedules_mesh2 + "\(String(describing: child_Id ?? "0"))/\(rule.id)"
//            params["_method"] = "PATCH"
//            params["type"] = "updateInternetSchedule"
//        }
        
        var params: [String : Any] = [:]
//        if rule.is_predefined != "1" {
//            rule.rule_name = nameField.text ?? "New"
//        }
        let childID = UserDefaults.standard.integer(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        params["child_id"] = childID
        params["name"] = rule.rule_name
        params["start_time"] = rule.time_start
        params["end_time"] = rule.time_end
        params["on_monday"] = rule.is_monday.integer
        params["on_tuesday"] = rule.is_tuesday.integer
        params["on_wednesday"] = rule.is_wednesday.integer
        params["on_thursday"] = rule.is_thursday.integer
        params["on_friday"] = rule.is_friday.integer
        params["on_saturday"] = rule.is_saturday.integer
        params["on_sunday"] = rule.is_sunday.integer
        params["status"] = rule.is_active.integer
        params["type"] = rule.rule_type ?? "timebased"
        if !isNew {
            params["id"] = rule.id
            params["function"] = rule.function
        } else {
            params["function"] = "internet_schedule"
        }
        //print("Add Update Internet Schedule Rule URL = \(URL) and params = \(params)")
        
        SwiftFTUtils.showHUDAdded(to: view, withText: "", animated: true)
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
        
//        ApiManager.shared().postApi(withVC: self, isPresentedCont: false, andParams: params, withApi: URL) { (message, statusCode) in
//            DispatchQueue.main.async{
//                SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
//                
//                print("add update api response msg = \(message) and code = \(statusCode)")
//                
//                if statusCode == 200{
//                    //---SANA---REFRESH SCREEN---CRASH FIX---//
//                    //                    NotificationCenter.default.post(name: Notification.Name(SwiftConstants.kRefreshRules), object: nil)
//                    CommonModel.showAlert("settings_card_5_1".localized, msg: "internet_schedules_alert_1_content_2".localized)
//                    self.navigationController?.popViewController(animated: true)
//                }
//                else{
//                    CommonModel.showAlert("alert_error".localized, msg: "alert_something_wrong".localized)
//                }
//            }
//        }//---END API CALLING---//
        
    }
    
    func updateViewsStatusEnableOrDisable(isEnable:Bool){
        nameTf.isEnabled = isEnable
        rangeSlider.isEnabled = isEnable
        _ = dayButtonsArray.map{$0.isEnabled = isEnable}
    }
    
}


extension AddInternetScheduleVC{
    //MARK: - UI ACTIONS
    
    @IBAction func switchAction(_ sender: AppBlockerSwitch) {
        if sender.isOn{
            rule.is_active = "1"
            updateViewsStatusEnableOrDisable(isEnable: true)
        }
        else{
            rule.is_active = "0"
            updateViewsStatusEnableOrDisable(isEnable: false)
        }
    }
    
    
    @IBAction func sundayAction(_ sender: UIButton) {
        rule.is_sunday = rule.is_sunday == "1" ? "0" : "1"
        applyRuleOnLabel(btn: sundayBtn, isOn: rule.is_sunday == "1")
    }
    
    @IBAction func mondayAction(_ sender: UIButton) {
        rule.is_monday = rule.is_monday == "1" ? "0" : "1"
        applyRuleOnLabel(btn: mondayBtn, isOn: rule.is_monday == "1")
    }
    
    @IBAction func tuesdayAction(_ sender: UIButton) {
        rule.is_tuesday = rule.is_tuesday == "1" ? "0" : "1"
        applyRuleOnLabel(btn: tuesdayBtn, isOn: rule.is_tuesday == "1")
    }
    
    @IBAction func wednesdayAction(_ sender: UIButton) {
        rule.is_wednesday = rule.is_wednesday == "1" ? "0" : "1"
        applyRuleOnLabel(btn: wednesdayBtn, isOn: rule.is_wednesday == "1")
    }
    
    @IBAction func thursdayAction(_ sender: UIButton) {
        rule.is_thursday = rule.is_thursday == "1" ? "0" : "1"
        applyRuleOnLabel(btn: thursdayBtn, isOn: rule.is_thursday == "1")
    }
    
    @IBAction func fridayAction(_ sender: UIButton) {
        rule.is_friday = rule.is_friday == "1" ? "0" : "1"
        applyRuleOnLabel(btn: fridayBtn, isOn: rule.is_friday == "1")
    }
    
    @IBAction func saturdayAction(_ sender: UIButton) {
        rule.is_saturday = rule.is_saturday == "1" ? "0" : "1"
        applyRuleOnLabel(btn: saturdayBtn, isOn: rule.is_saturday == "1")
    }
}


extension AddInternetScheduleVC : UITextFieldDelegate{
    
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


extension AddInternetScheduleVC : RangeSeekSliderDelegate{
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat){
        print("slider did change with min = \(minValue) and max = \(maxValue)")
        
        startTimeLbl.text = calculateTime(minutes: Int(minValue) * 30) //---AS EACH STEP IS OF 30 MINUTES---//
        endTimeLbl.text   = calculateTime(minutes: Int(maxValue) * 30) //---AS EACH STEP IS OF 30 MINUTES---//
    }
    
    func calculateTime(minutes : Int) -> String{
        
        let h = minutes / 60
        let m = minutes % 60
        
        print("hours = \(h) and minutes = \(m)")
        
        var hours = "\(h)"
        var mints = "\(m)"
        
        if h < 10{
            hours = "0\(h)"
        }
        if m < 10{
            mints = "0\(m)"
        }
        
        if h == 24{
            hours = "23"
            mints = "59"
        }
        
        return "\(hours):\(mints)"
    }

}
