//
//  AddRuleVC.swift
//  FamilyTime
//
//  Created by Sana Ullah on 22/04/2019.
//  Copyright © 2019 YumyApps. All rights reserved.
//

import UIKit

class AddRuleVC: UIViewController {

    @IBOutlet weak var enableLbl: UILabel!
    @IBOutlet weak var enableSwitch: AppBlockerSwitch!
    
    @IBOutlet weak var nameTf: SkyFloatingLabelTextField!
    
    @IBOutlet weak var nameFieldVuHeightConst: NSLayoutConstraint!
    @IBOutlet weak var startTimeTitleLbl:   UILabel!
    @IBOutlet weak var startTimeLbl:        UILabel!
    @IBOutlet weak var startPmLbl:          UILabel!
    @IBOutlet weak var endTimeTitleLbl:     UILabel!
    @IBOutlet weak var endTimeLbl:          UILabel!
    @IBOutlet weak var endPmLbl:            UILabel!
    
    @IBOutlet weak var rangeCircularSlider: RangeCircularSlider!
    @IBOutlet weak var weekDayLbl: UILabel!
    
    @IBOutlet weak var sundayLbl:    UILabel!
    @IBOutlet weak var mondayLbl:    UILabel!
    @IBOutlet weak var tuesdayLbl:   UILabel!
    @IBOutlet weak var wednesdayLbl: UILabel!
    @IBOutlet weak var thursdayLbl:  UILabel!
    @IBOutlet weak var fridayLbl:    UILabel!
    @IBOutlet weak var saturdayLbl:  UILabel!
    
    @IBOutlet weak var sundayVu:    UIView!
    @IBOutlet weak var mondayVu:    UIView!
    @IBOutlet weak var tuesdayVu:   UIView!
    @IBOutlet weak var wednesdayVu: UIView!
    @IBOutlet weak var thursdayVu:  UIView!
    @IBOutlet weak var fridayVu:    UIView!
    @IBOutlet weak var saturdayVu:  UIView!
    
    @IBOutlet weak var sundayBtn:    UIButton!
    @IBOutlet weak var mondayBtn:    UIButton!
    @IBOutlet weak var tuesdayBtn:   UIButton!
    @IBOutlet weak var wednesdayBtn: UIButton!
    @IBOutlet weak var thursdayBtn:  UIButton!
    @IBOutlet weak var fridayBtn:    UIButton!
    @IBOutlet weak var saturdayBtn:  UIButton!
    
    @IBOutlet weak var durationHourLbl:     UILabel!
    @IBOutlet weak var durationMinLabel:    UILabel!
    
    @objc var rule = RuleModel()
    var isNew = false
    var delegate : AppDelegate?
    
    var dayButtonsArray = [UIButton]()

//    var SelectionIsCorrect: Double = 1.0
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
        
        ZendeskChatManager.trackEvent("Add Rule")
    }
    
    func initialization(){
        
        dayButtonsArray = [sundayBtn, mondayBtn, tuesdayBtn, wednesdayBtn, thursdayBtn, fridayBtn, saturdayBtn]
        UserDefaults.standard.set("NO", forKey: "gobacknow")
        UserDefaults.standard.synchronize()
        
        delegate = AppDelegate.getSharedAppDelegateForSwift()
        
        if isNew{
            rule = SwiftCommonUtility.shared.getInitializedNewRule()
        }
        
        
        setSlider()
        setRule()
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .save, target: self, action: #selector(handleSave))
        
        title = isNew ? "Custom Rule".myModification() : rule.rule_name
        enableSwitch.setOn(rule.is_active == "1" ? true : false, animated: true)
        updateViewsStatusEnableOrDisable(isEnable: rule.is_active == "1" ? true : false)
        
        if isNew || rule.is_predefined == "0"{
            nameTf.placeholder  = "Enter Rule Name".myModification()
            nameTf.leftViewMode = .always
            nameTf.text         = rule.rule_name
            nameTf.isHidden     = false
            nameFieldVuHeightConst.constant = 60
        }
        else{
            nameTf.isHidden = true
            nameFieldVuHeightConst.constant = 0
        }

        MultilingualUtility.shared.lingualForAddRule(vc: self)
    }
    

    func setSlider(){
        
        rangeCircularSlider.startThumbImage = UIImage(named: "start_rule")
        rangeCircularSlider.endThumbImage   = UIImage(named: "end_rule")
        
        // setup O'clock
        
        let dayInSeconds = 24 * 60 * 60
        
        rangeCircularSlider.maximumValue    = CGFloat(dayInSeconds)
        
        rangeCircularSlider.startPointValue = SwiftCommonUtility.shared.getParsedTimeInSeconds(time: rule.time_start ?? "")
        rangeCircularSlider.endPointValue   = SwiftCommonUtility.shared.getParsedTimeInSeconds(time: rule.time_end ?? "")
        updateTexts(rangeCircularSlider)
    }
    
    @IBAction func updateTexts(_ sender: AnyObject)
    {
        adjustValue(value: &rangeCircularSlider.startPointValue)
        adjustValue(value: &rangeCircularSlider.endPointValue)
        
        print("Valuee==")
        print(rangeCircularSlider.startPointValue)
        print(rangeCircularSlider.endPointValue)
        
        
        var bedtime = TimeInterval(rangeCircularSlider.startPointValue)
        
     
        let locale = NSLocale.current
          let formatter : String = DateFormatter.dateFormat(fromTemplate: "j", options:0, locale:locale)!
          if formatter.contains("a") {
            bedtime = TimeInterval(rangeCircularSlider.startPointValue)
          } else {
            bedtime = TimeInterval(rangeCircularSlider.startPointValue-1)
          }
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
        
        
//        let TotalSecondsin24Hours:Double=24*60*60
//        let TempConstant:Double = TotalSecondsin24Hours-bedtime
//
        print(duration)
//        print(TempConstant)
        
//        if(duration>0.0)
//        {
//            print("Right Selection")
//            SelectionIsCorrect=1.0
//        }
//        else if(duration<0.0)
//        {
//            print("Wrong Selection")
//            SelectionIsCorrect=2.0
//        }
//        else
//        {
//            print("Right Selection")
//            SelectionIsCorrect=1.0
//        }
        
    }
    
    @objc func handleSave(){
        
        nameTf.resignFirstResponder()
        
        updateRuleTime()
        
        //---AT LEAST ONE DAY MUST BE SELECTED---//
        if rule.on_sunday! == "0" && rule.on_monday! == "0" && rule.on_tuesday! == "0" && rule.on_wednesday! == "0" && rule.on_thursday! == "0" && rule.on_friday! == "0" && rule.on_saturday! == "0"{
            CommonModel.showAlert("Error!".myModification(), msg: "Please select atleast one day of a week".myModification())
        }
        else if isNew || rule.is_predefined == "0"{
            nameTf.text == "" ? CommonModel.showAlert("Rule Name".myModification(), msg: "Please provide rule name".myModification()) : updateRuleApiCall()
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
    
    func applyRuleOnLabel(lbl:UILabel, bottomVu:UIView, isOn:Bool){
        lbl.textColor = isOn ? UIColor.FTOrange : UIColor.lightGray
        bottomVu.backgroundColor = isOn ? UIColor.FTOrange : UIColor.lightGray
    }
    
    func setRule(){
        applyRuleOnLabel(lbl: sundayLbl,    bottomVu: sundayVu,    isOn: (rule.on_sunday    ?? "") == "1")
        applyRuleOnLabel(lbl: mondayLbl,    bottomVu: mondayVu,    isOn: (rule.on_monday    ?? "") == "1")
        applyRuleOnLabel(lbl: tuesdayLbl,   bottomVu: tuesdayVu,   isOn: (rule.on_tuesday   ?? "") == "1")
        applyRuleOnLabel(lbl: wednesdayLbl, bottomVu: wednesdayVu, isOn: (rule.on_wednesday ?? "") == "1")
        applyRuleOnLabel(lbl: thursdayLbl,  bottomVu: thursdayVu,  isOn: (rule.on_thursday  ?? "") == "1")
        applyRuleOnLabel(lbl: fridayLbl,    bottomVu: fridayVu,    isOn: (rule.on_friday    ?? "") == "1")
        applyRuleOnLabel(lbl: saturdayLbl,  bottomVu: saturdayVu,  isOn: (rule.on_saturday  ?? "") == "1")
    }
    
    func updateRuleTime()
    {
        rule.time_start = SwiftCommonUtility.shared.getFormatedTimeForRuleWith(time: startTimeLbl.text ?? "", amPm: startPmLbl.text!)
        rule.time_end   = SwiftCommonUtility.shared.getFormatedTimeForRuleWith(time: endTimeLbl.text ?? "", amPm: endPmLbl.text!)
    }
    
    
    @objc func updateRuleApiCall(){
        let params = SwiftParamUtility.shared.changeRuleParams(isActive: enableSwitch.isOn, isNewRule: isNew, rule: rule) //getParamsForRule(rule:rule, isNew:isNew)
        print("add or update rule parms = \(params)")
        
        let URL = SwiftAPIConstants.kGetRules_mesh2 + "\(String(describing: CommonModel().child_Id ?? "0"))"
        print("url = \(URL)")
        
        SwiftFTUtils.showHUDAdded(to: view, withText: "", animated: true)
        ApiManager.shared().putApi(URL, params: params, controller: self, isContPresented: false) { (msg, code) in
            DispatchQueue.main.async{
                SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
                
                print("add update api response msg = \(msg) and code = \(code)")
                
                if code == 200{
                    //---SANA---REFRESH SCREEN---CRASH FIX---//
                    NotificationCenter.default.post(name: Notification.Name(SwiftConstants.kRefreshRules), object: nil)
                    
                    //---MESH2 API DOES THIS AUTO SO NO NEED FOR THIS---//
                    //                SwiftFTUtils.showSyncSettingsPopup(with: self)
                    self.navigationController?.popViewController(animated: true)
                    CommonModel.showAlert("Sync Settings".localized, msg: msg)
                }
                else{
                    CommonModel.showAlert("Error!".myModification(), msg: msg)
                }
            }
        }
    }
    
    func updateViewsStatusEnableOrDisable(isEnable:Bool){
        nameTf.isEnabled = isEnable
        rangeCircularSlider.isEnabled = isEnable
        _ = dayButtonsArray.map{$0.isEnabled = isEnable}
    }
    
}


extension AddRuleVC{
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
        rule.on_sunday = rule.on_sunday == "1" ? "0" : "1"
        applyRuleOnLabel(lbl: sundayLbl, bottomVu: sundayVu, isOn: rule.on_sunday == "1")
    }
    
    @IBAction func mondayAction(_ sender: UIButton) {
        rule.on_monday = rule.on_monday == "1" ? "0" : "1"
        applyRuleOnLabel(lbl: mondayLbl, bottomVu: mondayVu, isOn: rule.on_monday == "1")
    }
    
    @IBAction func tuesdayAction(_ sender: UIButton) {
        rule.on_tuesday = rule.on_tuesday == "1" ? "0" : "1"
        applyRuleOnLabel(lbl: tuesdayLbl, bottomVu: tuesdayVu, isOn: rule.on_tuesday == "1")
    }
    
    @IBAction func wednesdayAction(_ sender: UIButton) {
        rule.on_wednesday = rule.on_wednesday == "1" ? "0" : "1"
        applyRuleOnLabel(lbl: wednesdayLbl, bottomVu: wednesdayVu, isOn: rule.on_wednesday == "1")
    }
    
    @IBAction func thursdayAction(_ sender: UIButton) {
        rule.on_thursday = rule.on_thursday == "1" ? "0" : "1"
        applyRuleOnLabel(lbl: thursdayLbl, bottomVu: thursdayVu, isOn: rule.on_thursday == "1")
    }
    
    @IBAction func fridayAction(_ sender: UIButton) {
        rule.on_friday = rule.on_friday == "1" ? "0" : "1"
        applyRuleOnLabel(lbl: fridayLbl, bottomVu: fridayVu, isOn: rule.on_friday == "1")
    }
    
    @IBAction func saturdayAction(_ sender: UIButton) {
        rule.on_saturday = rule.on_saturday == "1" ? "0" : "1"
        applyRuleOnLabel(lbl: saturdayLbl, bottomVu: saturdayVu, isOn: rule.on_saturday == "1")
    }
}


extension AddRuleVC : UITextFieldDelegate{
    
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
