//
//  ViewController.swift
//  HGCircularSlider
//
//  Created by Hamza Ghazouani on 10/19/2016.
//  Copyright (c) 2016 Hamza Ghazouani. All rights reserved.
//

import UIKit
import HGCircularSlider
import MBProgressHUD

class ClockViewController: UIViewController {
    
    @IBOutlet weak var btnSavetopp: UIBarButtonItem!
    @IBOutlet weak var lblEnableFunTime11: UILabel!
    @IBOutlet weak var lblEnableFunTime: UILabel!
    @IBOutlet weak var lblSelectDay: UILabel!
    @IBOutlet weak var lblStartTime1: UILabel!
    @IBOutlet weak var lblEndTime1: UILabel!
    @IBOutlet weak var viewTop11: UIView!
    @IBOutlet weak var viewTop1: UIView!
    @IBOutlet weak var viewTop2: UIView!
    @IBOutlet weak var viewAwakeSleep: UIView!
    @IBOutlet weak var viewButtons: UIView!
    @IBOutlet weak var MoButton: UIButton!
    @IBOutlet weak var TuButton: UIButton!
    @IBOutlet weak var WeButton: UIButton!
    @IBOutlet weak var ThButton: UIButton!
    @IBOutlet weak var FrButton: UIButton!
    @IBOutlet weak var saButton: UIButton!
    @IBOutlet weak var sunButton: UIButton!
    @IBOutlet weak var swEnable: UISwitch!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var bedtimeLabel: UILabel!
    @IBOutlet weak var wakeLabel: UILabel!
    @IBOutlet weak var rangeCircularSlider: RangeCircularSlider!
    @IBOutlet weak var rangeCircularSliderImgView: UIImageView!
    @IBOutlet weak var clockFormatSegmentedControl: UISegmentedControl!
    
    var selectedDay: String = ""
    var SelectionIsCorrect: Double = 1.0
    var control = Control()
    var schedule = Schedule()
    let child_Id = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
    
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "h:mm"
        return dateFormatter
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if(UIDevice.current.userInterfaceIdiom == .pad) {
            rangeCircularSliderImgView.frame =  CGRect(x:rangeCircularSliderImgView.frame.origin.x-2,y:rangeCircularSliderImgView.frame.origin.y-2,width:rangeCircularSliderImgView.frame.size.width+4,height:rangeCircularSliderImgView.frame.size.height+4)
            
            let xConstraint = NSLayoutConstraint(item: rangeCircularSliderImgView!, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.swEnable.backgroundColor = UIColor.lightGray
        self.swEnable.layer.cornerRadius = 16.0
        btnSavetopp.title = "save_button".localized
        lblEnableFunTime.text = "fun_time_content_1".localized
        lblEnableFunTime11.text = "fun_time_switch_1".localized
//        ZendeskChatManager.trackEvent("Fun Time Screen")
        //        lblStartTime1.adjustsFontSizeToFitWidth=true
        //        lblEndTime1.adjustsFontSizeToFitWidth=true
        lblStartTime1.text = "fun_time_content_2".localized
        lblEndTime1.text = "fun_time_content_3".localized
        //bedtimeLabel.text = bedtimeLabel.text?.localized
        //wakeLabel.text = wakeLabel.text?.localized
        lblSelectDay.text = "fun_time_content_6".localized
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LiveVisitorManager.shared.updateScreen(
            "Fun Time"
        )
        
        swEnable.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        control = DBManager.shared.fetchAppBlockControl(identifier: "fun_time")
        rangeCircularSlider.isEnabled=false
        setUpButtonUI()
        swEnable.isOn = control.state?.boolValue ?? false
        let childID = Int(child_Id ?? "0")
        let sched = DBManager.shared.getSchedules(identifier: "fun_time", childID: childID ?? 0)
        if sched.count == 0 {
            viewData();
        }else {
            self.schedule = sched.first ?? Schedule()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.updateUI(funModel: sched.first ?? Schedule())
            }
        }
        
        self.title="settings_card_2_android_7".localized
        self.navigationController?.isNavigationBarHidden=false
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(
            title: "",
            style: .plain,
            target: nil,
            action: nil)
        let tempImage:UIImage = self.textToImage(drawText: " ".localized as NSString, inImage: UIImage(named: "ic_dialer")!, atPoint: CGPoint(x: 5,y :9))
        let tempImage2:UIImage = self.textToImage(drawText: " ".localized as NSString, inImage: UIImage(named: "ic_dialer")!, atPoint: CGPoint(x: 6,y :9))
        rangeCircularSlider.startThumbTintColor=UIColor(red: 251.0/255, green: 192.0/255, blue: 45.0/255, alpha: 1)
        rangeCircularSlider.endThumbTintColor=UIColor(red: 251.0/255, green: 192.0/255, blue: 45.0/255, alpha: 1)
        rangeCircularSlider.startThumbStrokeColor=UIColor(red: 251.0/255, green: 192.0/255, blue: 45.0/255, alpha: 1)
        rangeCircularSlider.endThumbStrokeColor=UIColor(red: 251.0/255, green: 192.0/255, blue: 45.0/255, alpha: 1)
        rangeCircularSlider.startThumbStrokeHighlightedColor=UIColor(red: 251.0/255, green: 192.0/255, blue: 45.0/255, alpha: 1)
        rangeCircularSlider.endThumbStrokeHighlightedColor=UIColor(red: 251.0/255, green: 192.0/255, blue: 45.0/255, alpha: 1)
        rangeCircularSlider.startThumbImage = tempImage
        rangeCircularSlider.endThumbImage = tempImage2
        let dayInSeconds = 24 * 60 * 60
        rangeCircularSlider.maximumValue = CGFloat(dayInSeconds)
        rangeCircularSlider.startPointValue = 14 * 60 * 60
        rangeCircularSlider.endPointValue = 16 * 60 * 60
        updateTexts(rangeCircularSlider)
    }
    
    @IBAction func updateTexts(_ sender: AnyObject) {
        
        adjustValue(value: &rangeCircularSlider.startPointValue)
        adjustValue(value: &rangeCircularSlider.endPointValue)
        print(rangeCircularSlider.startPointValue)
        print(rangeCircularSlider.endPointValue)
        let bedtime = TimeInterval(rangeCircularSlider.startPointValue)
        let bedtimeDate = Date(timeIntervalSinceReferenceDate: bedtime)
        //        dateFormatter.amSymbol = "AM"
        //        dateFormatter.pmSymbol = "PM"
        bedtimeLabel.text = dateFormatter.string(from: bedtimeDate)
        
        let wake = TimeInterval(rangeCircularSlider.endPointValue)
        let wakeDate = Date(timeIntervalSinceReferenceDate: wake)
        //        dateFormatter.amSymbol = "AM"
        //        dateFormatter.pmSymbol = "PM"
        wakeLabel.text = dateFormatter.string(from: wakeDate)
        let duration = wake - bedtime
        let durationDate = Date(timeIntervalSinceReferenceDate: duration)
        dateFormatter.dateFormat = "HH:mm"
        //        dateFormatter.amSymbol = "AM"
        //        dateFormatter.pmSymbol = "PM"
        durationLabel.text = dateFormatter.string(from: durationDate)
        dateFormatter.dateFormat = "HH:mm"
        //        dateFormatter.amSymbol = "AM"
        //        dateFormatter.pmSymbol = "PM"
        let TotalSecondsin24Hours:Double=24*60*60
        let TempConstant:Double = TotalSecondsin24Hours-bedtime
        if(duration>0.0) {
            print("Right Selection")
            SelectionIsCorrect=1.0
        } else if(duration<0.0) {
            print("Wrong Selection")
            SelectionIsCorrect=2.0
        } else {
            print("Right Selection")
            SelectionIsCorrect=1.0
        }
    }
    
    func adjustValue(value: inout CGFloat) {
        let minutes = value / 60
        let adjustedMinutes =  ceil(minutes / 5.0) * 5
        value = adjustedMinutes * 60
    }
    
    func textToImage(drawText text: NSString, inImage image: UIImage, atPoint point: CGPoint) -> UIImage {
        let textColor = UIColor.darkGray
        let textFont = UIFont(name: "Helvetica", size: 9.0)!
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
        let textFontAttributes = [
            NSAttributedString.Key.font.rawValue: textFont,
            NSAttributedString.Key.foregroundColor: textColor,
        ] as! [NSAttributedString.Key : Any]
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        
        let rect = CGRect(origin: point, size: image.size)
        text.draw(in: rect, withAttributes: textFontAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    func convertTimeFormat(inputTime: String) -> String? {
        let inputFormat = DateFormatter()
        inputFormat.dateFormat = "HH:mm"
        
        let outputFormat = DateFormatter()
        outputFormat.dateFormat = "HH:mm:ss"
        
        if let date = inputFormat.date(from: inputTime) {
            return outputFormat.string(from: date)
        } else {
            return nil
        }
    }
    
    func updateUI(funModel : Schedule){
        updateSlider(time: funModel.startTime ?? "")
        updateSlider(time: funModel.endTime ?? "", isStart: false)
        
        updateTime(time: funModel.startTime ?? "")
        updateTime(time: funModel.endTime ?? "", isStart: false)
        if funModel.onMonday == 1 {
            self.selectedDay = "Monday"
        } else if funModel.onTuesday == 1 {
            self.selectedDay = "Tuesday"
        }else if funModel.onWednesday == 1 {
            self.selectedDay = "Wednesday"
        }else if funModel.onThursday == 1 {
            self.selectedDay = "Thursday"
        }else if funModel.onFriday == 1 {
            self.selectedDay = "Friday"
        }else if funModel.onSaturday == 1 {
            self.selectedDay = "Saturday"
        }else if funModel.onSunday == 1 {
            self.selectedDay = "Sunday"
        }
        self.selectedDay = self.selectedDay.capitalized
        self.PopulateButton()
        enableSwitchPressed(mySwitch: swEnable)
    }
    
    func UTCToLocalConverter(timeToConvert : String) -> String{
        let dateFormatter = DateFormatter()
        let locale = Locale.current.identifier
        dateFormatter.calendar = Calendar.current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "HH:mm:ss"
        dateFormatter.locale = Locale(identifier: locale)
        let date24 = dateFormatter.date(from: timeToConvert)
        dateFormatter.dateFormat = "HH:mm"
        let date12 = dateFormatter.string(from: date24 ?? Date())
        return date12
    }
    
    func updateTime(time:String, isStart:Bool = true){
        let date = self.UTCToLocalConverter(timeToConvert: time)
        if isStart{
            self.bedtimeLabel.text = date
        }
        else{
            self.wakeLabel.text = date
        }
    }
    
    func updateSlider(time:String, isStart:Bool = true){
        let fullNameArr = time.components(separatedBy: ":")
        
        let Starthour1: String  = fullNameArr[0]
        let StartMin1:  String  = fullNameArr[1]
        let StartSec1:  String  = fullNameArr[2]
        
        print(Starthour1)
        let totalSecondsStart = (Int(Starthour1)!*60*60)+(Int(StartMin1)!*60)+Int(StartSec1)!
       if isStart {
            self.rangeCircularSlider.startPointValue = CGFloat(totalSecondsStart)
        } else {
            self.rangeCircularSlider.endPointValue = CGFloat(totalSecondsStart)
        }
    }
    
    func viewData() {
        SwiftFTUtils.showHUDAdded(to: self.view, withText: "", animated: true)
        
        let url = HLConstants.BASE_URL_CORE_2 + "controls/schedules"
        CoreManager.networkRequest(url: url, method: .get) { (response: ScheduleRuleCodableModel?, statusCode, errorMessage) in
            SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
            if errorMessage == nil {
                if let funtimeObj = response?.schedules?.first(where: {($0.childID == Int(self.child_Id ?? "0") && ($0.function == "fun_time"))}) {
                    self.schedule = funtimeObj
                    self.updateUI(funModel: funtimeObj)
                }
            } else {
                CommonModel.showAlert("alert_error".localized, msg: errorMessage)
            }
        }
    }

    @IBAction func dayPressed(_ sender: Any) {
        if((sender as AnyObject).tag==1) {
            MoButton.tintColor = UIColor.FTDarkPink
            print("Monday")
            selectedDay="Monday"
            TuButton.tintColor = UIColor.lightGray
            WeButton.tintColor = UIColor.lightGray
            ThButton.tintColor = UIColor.lightGray
            FrButton.tintColor = UIColor.lightGray
            saButton.tintColor = UIColor.lightGray
            sunButton.tintColor = UIColor.lightGray
        } else if((sender as AnyObject).tag==2) {
            TuButton.tintColor = UIColor.FTDarkPink
            selectedDay="Tuesday"
            MoButton.tintColor = UIColor.lightGray
            WeButton.tintColor = UIColor.lightGray
            ThButton.tintColor = UIColor.lightGray
            FrButton.tintColor = UIColor.lightGray
            saButton.tintColor = UIColor.lightGray
            sunButton.tintColor = UIColor.lightGray
        } else if((sender as AnyObject).tag==3) {
            WeButton.tintColor = UIColor.FTDarkPink
            selectedDay="Wednesday"
            MoButton.tintColor = UIColor.lightGray
            TuButton.tintColor = UIColor.lightGray
            ThButton.tintColor = UIColor.lightGray
            FrButton.tintColor = UIColor.lightGray
            saButton.tintColor = UIColor.lightGray
            sunButton.tintColor = UIColor.lightGray
        } else if((sender as AnyObject).tag==4) {
            ThButton.tintColor = UIColor.FTDarkPink
            selectedDay="Thursday"
            MoButton.tintColor = UIColor.lightGray
            WeButton.tintColor = UIColor.lightGray
            TuButton.tintColor = UIColor.lightGray
            FrButton.tintColor = UIColor.lightGray
            saButton.tintColor = UIColor.lightGray
            sunButton.tintColor = UIColor.lightGray
        } else if((sender as AnyObject).tag==5) {
            FrButton.tintColor = UIColor.FTDarkPink
            selectedDay="Friday"
            MoButton.tintColor = UIColor.lightGray
            TuButton.tintColor = UIColor.lightGray
            WeButton.tintColor = UIColor.lightGray
            ThButton.tintColor = UIColor.lightGray
            saButton.tintColor = UIColor.lightGray
            sunButton.tintColor = UIColor.lightGray
        } else if((sender as AnyObject).tag==6) {
            saButton.tintColor = UIColor.FTDarkPink
            selectedDay="Saturday"
            MoButton.tintColor = UIColor.lightGray
            TuButton.tintColor = UIColor.lightGray
            WeButton.tintColor = UIColor.lightGray
            ThButton.tintColor = UIColor.lightGray
            FrButton.tintColor = UIColor.lightGray
            sunButton.tintColor = UIColor.lightGray
        } else if((sender as AnyObject).tag==7) {
            sunButton.tintColor = UIColor.FTDarkPink
            selectedDay="Sunday"
            MoButton.tintColor = UIColor.lightGray
            TuButton.tintColor = UIColor.lightGray
            WeButton.tintColor = UIColor.lightGray
            ThButton.tintColor = UIColor.lightGray
            FrButton.tintColor = UIColor.lightGray
            saButton.tintColor = UIColor.lightGray
        }
        self.selectedDay = self.selectedDay.capitalized
    }
    
    @IBAction func savebuttonPressed(_ sender: Any) {
        if(self.SelectionIsCorrect != 1.0) {
            let alert = UIAlertController(title: "", message: "fun_time_alert_content_1".localized , preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "ok_button".localized, style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return }
        if control.identifier == nil {
            HLApiManager.getControlApi()
            return
        }
        SwiftFTUtils.showHUDAdded(to: self.view, withText: "", animated: true)
        
        if let childId = control.childID,
           let featureId = control.featureID,
           let identifier = control.identifier {
            
            HLApiManager.putControlApi(childId: childId, featureId: featureId, state:swEnable.isOn.boolToInt(), identifier: identifier) {err in
                if err != nil {
                    SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
                    CommonModel.showAlert("alert_error".localized, msg: err ?? "Nothing")
                    return
                }
                DBManager.shared.fetchControlAndUpdate(identifier: self.control.identifier ?? "", state: self.swEnable.isOn.boolToInt())
                if(self.SelectionIsCorrect==1.0) {
                    self.updateDataNow()
                } else {
                    let alert = UIAlertController(title: "", message: "fun_time_alert_content_1".localized , preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "ok_button".localized, style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        } else {
            SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
            CommonModel.showAlert("alert_error".localized, msg: "alert_something_wrong_again")
            print("❌ Missing required params (childId / featureId / identifier)")
        }
    }
    
    func setUpButtonUI() {
        let image = UIImage(named: "ic_mo")?.withRenderingMode(.alwaysTemplate)
        MoButton.setImage(image, for: .normal)
        MoButton.tintColor = UIColor(red: 96.0/255, green: 96.0/255, blue: 96.0/255, alpha: 1)
        
        let image2 = UIImage(named: "ic_tu")?.withRenderingMode(.alwaysTemplate)
        TuButton.setImage(image2, for: .normal)
        TuButton.tintColor = UIColor(red: 96.0/255, green: 96.0/255, blue: 96.0/255, alpha: 1)
        
        let image3 = UIImage(named: "ic_we")?.withRenderingMode(.alwaysTemplate)
        WeButton.setImage(image3, for: .normal)
        WeButton.tintColor = UIColor(red: 96.0/255, green: 96.0/255, blue: 96.0/255, alpha: 1)
        
        let image4 = UIImage(named: "ic_th")?.withRenderingMode(.alwaysTemplate)
        ThButton.setImage(image4, for: .normal)
        ThButton.tintColor = UIColor(red: 96.0/255, green: 96.0/255, blue: 96.0/255, alpha: 1)
        
        let image5 = UIImage(named: "ic_fr")?.withRenderingMode(.alwaysTemplate)
        FrButton.setImage(image5, for: .normal)
        FrButton.tintColor = UIColor(red: 96.0/255, green: 96.0/255, blue: 96.0/255, alpha: 1)
        
        let image6 = UIImage(named: "ic_sa")?.withRenderingMode(.alwaysTemplate)
        saButton.setImage(image6, for: .normal)
        saButton.tintColor = UIColor(red: 96.0/255, green: 96.0/255, blue: 96.0/255, alpha: 1)
        
        let image7 = UIImage(named: "ic_su")?.withRenderingMode(.alwaysTemplate)
        sunButton.setImage(image7, for: .normal)
        sunButton.tintColor = UIColor(red: 96.0/255, green: 96.0/255, blue: 96.0/255, alpha: 1)
        
        MoButton.tintColor = UIColor.lightGray
        TuButton.tintColor = UIColor.lightGray
        WeButton.tintColor = UIColor.lightGray
        ThButton.tintColor = UIColor.lightGray
        FrButton.tintColor = UIColor.lightGray
        saButton.tintColor = UIColor.lightGray
        sunButton.tintColor = UIColor.lightGray
    }
    
    
    @IBAction func enableSwitchPressed(mySwitch: UISwitch) {
        if mySwitch.isOn {
            rangeCircularSlider.isEnabled=true
        } else {
            rangeCircularSlider.isEnabled=false
        }
    }
    
    func updateDataNow() {
        
        let startTime = convertTimeFormat(inputTime: bedtimeLabel.text ?? "00:00")
        let endTime = convertTimeFormat(inputTime: wakeLabel.text ?? "00:00")
        var params: [String : Any] = [:]
        params["child_id"] = self.child_Id
        params["name"] = "Fun Time"
        params["start_time"] = startTime ?? "00:00:00"
        params["end_time"] = endTime ?? "00:00:00"
        params["on_monday"] = selectedDay == "Monday" ? 1 : 0
        params["on_tuesday"] = selectedDay == "Tuesday" ? 1 : 0
        params["on_wednesday"] = selectedDay == "Wednesday" ? 1 : 0
        params["on_thursday"] = selectedDay == "Thursday" ? 1 : 0
        params["on_friday"] = selectedDay == "Friday" ? 1 : 0
        params["on_saturday"] = selectedDay == "Saturday" ? 1 : 0
        params["on_sunday"] = selectedDay == "Sunday" ? 1 : 0
        params["status"] = swEnable.isOn.boolToInt()
        params["type"] = "timebased"
        if let scID = schedule.id {
            params["id"] = scID
        }
        params["function"] = "fun_time"
        SwiftFTUtils.showHUDAdded(to: self.view, withText: "", animated: true)
        let url = HLConstants.BASE_URL_CORE_2 + "controls/schedules"
        CoreManager.networkRequest(url: url, method: .put, params: params) { (response: ScheduleRuleSingleModel?, statusCode, errorMessage) in
            SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
            if statusCode == 200{
                if let response = response?.schedule {
                    DBManager.shared.getScheduleAndUpdate(childID: response.childID ?? 0, identifier: "fun_time", id: response.id ?? 0, obj: response)
                }
                CommonModel.showAlert("settings_card_5_1".localized, msg:"fun_time_alert_content_2".localized)
            }
            else{
                CommonModel.showAlert("alert_error".localized, msg:errorMessage)
            }
        }
    }
    
    func PopulateButton() {
        let Btnn: UIButton=UIButton()
        if(self.selectedDay=="Monday") {
            Btnn.tag=1
            self.dayPressed(Btnn)
        } else if(self.selectedDay=="Tuesday") {
            Btnn.tag=2
            self.dayPressed(Btnn)
        } else if(self.selectedDay=="Wednesday") {
            Btnn.tag=3
            self.dayPressed(Btnn)
        } else if(self.selectedDay=="Thursday") {
            Btnn.tag=4
            self.dayPressed(Btnn)
        } else if(self.selectedDay=="Friday") {
            Btnn.tag=5
            self.dayPressed(Btnn)
        } else if(self.selectedDay=="Saturday") {
            Btnn.tag=6
            self.dayPressed(Btnn)
        } else if(self.selectedDay=="Sunday") {
            Btnn.tag=7
            self.dayPressed(Btnn)
        }
    }
}


