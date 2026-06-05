//
//  ScheduleScreenCell.swift
//  FamilyTime
//
//  Created by Sana Ullah on 22/04/2019.
//  Copyright © 2019 YumyApps. All rights reserved.
//

import UIKit

protocol ScheduleScreenProtocol{
    func menuButtonPressed(at indexpath:IndexPath, menuBtn:UIButton)
}

class ScheduleScreenCell: UITableViewCell {
    
    @IBOutlet weak var imageVu: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var startTimeLbl: UILabel!
    @IBOutlet weak var startPmLbl: UILabel!
    @IBOutlet weak var endTimeLbl: UILabel!
    @IBOutlet weak var endPmLbl: UILabel!
    @IBOutlet weak var daysLbl: UILabel!
    
    @IBOutlet weak var switchVu: AppBlockerSwitch!
    @IBOutlet weak var menuBtn: UIButton!
    
    var delegate:ScheduleScreenProtocol!
        
    var cellIndexPath = IndexPath()
    
    var rule = Schedule()
    
    //---INTERNET SHCEDULE---//
    var internetSchedule = InternetScheduleInnerModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func UTCToLocalConverter(timeToConvert : String) -> String{
        let dateFormatter = DateFormatter()
        let locale = Locale.current.identifier
        dateFormatter.calendar = Calendar.current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "HH:mm:ss"
        dateFormatter.locale = Locale(identifier: locale)
        let date24 = dateFormatter.date(from: timeToConvert)
        dateFormatter.dateFormat = "h:mm a"
        let date12 = dateFormatter.string(from: date24 ?? Date())
        return date12
    }
    
    func UTCToLocalConverterWithOutAmPM(timeToConvert : String) -> String{
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
    
    func setTimeLabel(){
        let startTime = UTCToLocalConverter(timeToConvert: rule.startTime ?? "")
        let endTime = UTCToLocalConverter(timeToConvert: rule.endTime ?? "")
        
        print("start time = \(startTime) and end time = \(endTime)")
        
        //        startTime.split(separator: " ")
        
        let startArr = startTime.split(separator: " ")// startTime.split(separator: " ")
        let endArr   = endTime.split(separator: " ") //endTime.split(separator: " ")
        
        startTimeLbl.text = String(startArr.first ?? "")
        startPmLbl.text   = String(startArr.last ?? "") //== "AM" ? "AM" : "PM"
        
        endTimeLbl.text = String(endArr.first ?? "")
        endPmLbl.text   = String(endArr.last ?? "") //== "AM" ? "AM" : "PM"
        
        //        return startTime + " - " + endTime
    }
        
    func setInternetScheduleTimeLabel(){
        
        print(internetSchedule.time_start ?? "")
        print(internetSchedule.time_end ?? "")
        
        let startTime = UTCToLocalConverterWithOutAmPM(timeToConvert: internetSchedule.time_start)
        let endTime = UTCToLocalConverterWithOutAmPM(timeToConvert: internetSchedule.time_end)
        
        print("start time = \(startTime) and end time = \(endTime)")
        
        let startArr = startTime.split(separator: " ")// startTime.split(separator: " ")
        let endArr   = endTime.split(separator: " ") //endTime.split(separator: " ")
        
        startTimeLbl.text = String(startArr.first ?? "")
        //        startPmLbl.text   = String(startArr.last ?? "") //== "AM" ? "AM" : "PM"
        
        endTimeLbl.text = String(endArr.first ?? "")
        //        endPmLbl.text   = String(endArr.last ?? "") //== "AM" ? "AM" : "PM"
    }
    
    func getDaysString() -> NSMutableAttributedString {
        
        
        let finalStr = NSMutableAttributedString()
        //sunday
        let sunday = NSMutableAttributedString(string: "SU  ")
        if rule.onSunday ?? 0 == 1{
            sunday.addAttribute(.foregroundColor, value: UIColor.FTBlue, range: NSRange(location: 0, length: sunday.length))
        }
        else{
            sunday.addAttribute(.foregroundColor, value: UIColor.init(red: 153, green: 153, blue: 153, a: 1), range: NSRange(location: 0, length: sunday.length))
        }
        
        sunday.addAttribute(.font, value: daysLbl.font ?? UIFont.systemFontSize, range: NSRange(location: 0, length: sunday.length))
        finalStr.append(sunday)

        
        //monday
        let monday = NSMutableAttributedString(string: "MO  ")
        if rule.onMonday ?? 0 == 1 {
            monday.addAttribute(.foregroundColor, value: UIColor.FTBlue, range: NSRange(location: 0, length: monday.length))
        } else {
            monday.addAttribute(.foregroundColor, value: UIColor.init(red: 153, green: 153, blue: 153, a: 1), range: NSRange(location: 0, length: monday.length))
        }
        monday.addAttribute(.font, value: daysLbl.font ?? UIFont.systemFontSize, range: NSRange(location: 0, length: monday.length))
        finalStr.append(monday)

        
        //tuesdays
        let tuesday = NSMutableAttributedString(string: "TU  ")
        if rule.onTuesday ?? 0 == 1 {
            tuesday.addAttribute(.foregroundColor, value: UIColor.FTBlue, range: NSRange(location: 0, length: tuesday.length))
        } else {
            tuesday.addAttribute(.foregroundColor, value: UIColor.init(red: 153, green: 153, blue: 153, a: 1), range: NSRange(location: 0, length: tuesday.length))
        }
        tuesday.addAttribute(.font, value: daysLbl.font ?? UIFont.systemFontSize, range: NSRange(location: 0, length: tuesday.length))
        finalStr.append(tuesday)

        
        //wednesday
        let wednesday = NSMutableAttributedString(string: "WE  ")
        if rule.onWednesday ?? 0 == 1 {
            wednesday.addAttribute(.foregroundColor, value: UIColor.FTBlue, range: NSRange(location: 0, length: wednesday.length))
        } else {
            wednesday.addAttribute(.foregroundColor, value: UIColor.init(red: 153, green: 153, blue: 153, a: 1), range: NSRange(location: 0, length: wednesday.length))
        }
        wednesday.addAttribute(.font, value: daysLbl.font ?? UIFont.systemFontSize, range: NSRange(location: 0, length: wednesday.length))
        finalStr.append(wednesday)

        
        
        //thursday
        let thursday = NSMutableAttributedString(string: "TH  ")
        if rule.onThursday ?? 0 == 1 {
            thursday.addAttribute(.foregroundColor, value: UIColor.FTBlue, range: NSRange(location: 0, length: thursday.length))
        } else {
            thursday.addAttribute(.foregroundColor, value: UIColor.init(red: 153, green: 153, blue: 153, a: 1), range: NSRange(location: 0, length: thursday.length))
        }
        thursday.addAttribute(.font, value: daysLbl.font ?? UIFont.systemFontSize, range: NSRange(location: 0, length: thursday.length))
        finalStr.append(thursday)

        
        
        //friday
        let friday = NSMutableAttributedString(string: "FR  ")
        if rule.onFriday ?? 0 == 1 {
            friday.addAttribute(.foregroundColor, value: UIColor.FTBlue, range: NSRange(location: 0, length: friday.length))
        } else {
            friday.addAttribute(.foregroundColor, value: UIColor.init(red: 153, green: 153, blue: 153, a: 1), range: NSRange(location: 0, length: friday.length))
        }
        friday.addAttribute(.font, value: daysLbl.font ?? UIFont.systemFontSize, range: NSRange(location: 0, length: friday.length))
        finalStr.append(friday)

        
        //saturday
        let saturday = NSMutableAttributedString(string: "SA")
        if rule.onSaturday ?? 0 == 1 {
            saturday.addAttribute(.foregroundColor, value: UIColor.FTBlue, range: NSRange(location: 0, length: saturday.length))
        } else {
            saturday.addAttribute(.foregroundColor, value: UIColor.init(red: 153, green: 153, blue: 153, a: 1), range: NSRange(location: 0, length: saturday.length))
        }
        saturday.addAttribute(.font, value: daysLbl.font ?? UIFont.systemFontSize, range: NSRange(location: 0, length: saturday.length))
        finalStr.append(saturday)
        
        
        
        print("final str = \(finalStr)")
        return finalStr
    }
    
    //---INTERNET SCHEDULE---//
    
    func getInternetScheduleDaysString() -> NSMutableAttributedString{
        
        
        let finalStr = NSMutableAttributedString()
        //sunday
        let sunday = NSMutableAttributedString(string: "SU  ")
        if internetSchedule.is_sunday == "1"{
            sunday.addAttribute(.foregroundColor, value: UIColor.FTOrange, range: NSRange(location: 0, length: sunday.length))
        }
        else{
            sunday.addAttribute(.foregroundColor, value: UIColor.init(red: 153, green: 153, blue: 153, a: 1), range: NSRange(location: 0, length: sunday.length))
        }
        
        sunday.addAttribute(.font, value: daysLbl.font ?? UIFont.systemFontSize, range: NSRange(location: 0, length: sunday.length))
        finalStr.append(sunday)

        
        //monday
        let monday = NSMutableAttributedString(string: "MO  ")
        if internetSchedule.is_monday == "1" {
            monday.addAttribute(.foregroundColor, value: UIColor.FTOrange, range: NSRange(location: 0, length: monday.length))
        } else {
            monday.addAttribute(.foregroundColor, value: UIColor.init(red: 153, green: 153, blue: 153, a: 1), range: NSRange(location: 0, length: monday.length))
        }
        monday.addAttribute(.font, value: daysLbl.font ?? UIFont.systemFontSize, range: NSRange(location: 0, length: monday.length))
        finalStr.append(monday)

        
        //tuesdays
        let tuesday = NSMutableAttributedString(string: "TU  ")
        if internetSchedule.is_tuesday == "1" {
            tuesday.addAttribute(.foregroundColor, value: UIColor.FTOrange, range: NSRange(location: 0, length: tuesday.length))
        } else {
            tuesday.addAttribute(.foregroundColor, value: UIColor.init(red: 153, green: 153, blue: 153, a: 1), range: NSRange(location: 0, length: tuesday.length))
        }
        tuesday.addAttribute(.font, value: daysLbl.font ?? UIFont.systemFontSize, range: NSRange(location: 0, length: tuesday.length))
        finalStr.append(tuesday)

        
        //wednesday
        let wednesday = NSMutableAttributedString(string: "WE  ")
        if internetSchedule.is_wednesday == "1" {
            wednesday.addAttribute(.foregroundColor, value: UIColor.FTOrange, range: NSRange(location: 0, length: wednesday.length))
        } else {
            wednesday.addAttribute(.foregroundColor, value: UIColor.init(red: 153, green: 153, blue: 153, a: 1), range: NSRange(location: 0, length: wednesday.length))
        }
        wednesday.addAttribute(.font, value: daysLbl.font ?? UIFont.systemFontSize, range: NSRange(location: 0, length: wednesday.length))
        finalStr.append(wednesday)

        
        
        //thursday
        let thursday = NSMutableAttributedString(string: "TH  ")
        if internetSchedule.is_thursday == "1" {
            thursday.addAttribute(.foregroundColor, value: UIColor.FTOrange, range: NSRange(location: 0, length: thursday.length))
        } else {
            thursday.addAttribute(.foregroundColor, value: UIColor.init(red: 153, green: 153, blue: 153, a: 1), range: NSRange(location: 0, length: thursday.length))
        }
        thursday.addAttribute(.font, value: daysLbl.font ?? UIFont.systemFontSize, range: NSRange(location: 0, length: thursday.length))
        finalStr.append(thursday)

        
        
        //friday
        let friday = NSMutableAttributedString(string: "FR  ")
        if internetSchedule.is_friday == "1" {
            friday.addAttribute(.foregroundColor, value: UIColor.FTOrange, range: NSRange(location: 0, length: friday.length))
        } else {
            friday.addAttribute(.foregroundColor, value: UIColor.init(red: 153, green: 153, blue: 153, a: 1), range: NSRange(location: 0, length: friday.length))
        }
        friday.addAttribute(.font, value: daysLbl.font ?? UIFont.systemFontSize, range: NSRange(location: 0, length: friday.length))
        finalStr.append(friday)
        
        //saturday
        let saturday = NSMutableAttributedString(string: "SA")
        if internetSchedule.is_saturday == "1" {
            saturday.addAttribute(.foregroundColor, value: UIColor.FTOrange, range: NSRange(location: 0, length: saturday.length))
        } else {
            saturday.addAttribute(.foregroundColor, value: UIColor.init(red: 153, green: 153, blue: 153, a: 1), range: NSRange(location: 0, length: saturday.length))
        }
        saturday.addAttribute(.font, value: daysLbl.font ?? UIFont.systemFontSize, range: NSRange(location: 0, length: saturday.length))
        finalStr.append(saturday)
        
        print("final str = \(finalStr)")
        return finalStr
    }
    
    func setRule(cellRule:Schedule){
        rule = cellRule
        
        titleLbl.text = rule.name ?? ""
        setTimeLabel()
        daysLbl.attributedText = getDaysString()
        
        
        if rule.status ?? 0 == 1{
            titleLbl.textColor = .FTBlue
        }
        else{
            daysLbl.textColor  = .FTLightGray
            titleLbl.textColor = .FTLightGray
        }
        
        print("is active = \(String(describing: rule.status ?? 0))")
        
        switchVu.setOn(rule.status ?? 0 == 1 ? true : false, animated: true)
        imageVu.image = CommonModel.newImage(forHeaderSST: rule.name ?? "", isRuleActive: switchVu.isOn)
    }
    
    func setInternetSchedule(cellRule:InternetScheduleInnerModel){
        internetSchedule = cellRule
        
        titleLbl.text = internetSchedule.rule_name
        setInternetScheduleTimeLabel()
        daysLbl.attributedText = getInternetScheduleDaysString()
        
        if internetSchedule.is_active == "1"{
            titleLbl.textColor = .FTOrange
        }
        else{
            daysLbl.textColor  = .FTLightGray
            titleLbl.textColor = .FTLightGray
        }
        
        print("is active = \(String(describing: rule.status ?? 0))")
        
        switchVu.setOn(internetSchedule.is_active == "1" ? true : false, animated: true)
        
        imageVu.image = CommonModel.newImage(forInternetSchedule: internetSchedule.rule_name, isRuleActive: internetSchedule.is_active == "1" ? true : false)
    }
        
    //MARK: - UI ACTIONS
    
    @IBAction func menuAction(_ sender: UIButton) {
        delegate.menuButtonPressed(at: cellIndexPath, menuBtn:sender)
    }
    
}
