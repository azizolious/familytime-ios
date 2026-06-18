//
//  SwiftLimitScreenCell.swift
//  FamilyTime
//
//  Created by YumyApps on 10/11/2021.
//  Copyright © 2021 YumyApps. All rights reserved.
//

import UIKit

protocol SwiftLimitScreenCellDelegate {
    
    func didRuleStatusChanged(_ isActive: Bool, indexPath: IndexPath?)
    func didOptionButtonTapped(_ indexPath: IndexPath?)
    
}

class SwiftLimitScreenCell: UITableViewCell {
    
    var rule = AccessControlRuleModel()
    var indexPath = IndexPath()
    var switchView = UISwitch()
    var delegate: SwiftLimitScreenCellDelegate?
    
    var title = UILabel()
    var timeLabel = UILabel()
    var weekdaysLabel = UILabel()
    var borderView = UIView()
    var containerView = UIView()
    var titleImage = UIImageView()
    var timeLabel1 = UILabel()
    var startPm = UILabel()
    var endPm = UILabel()
    var optionButton = UIButton()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = UIColor.clear
        tintColor = UIColor.red
        title = UILabel(frame: CGRect.zero)
        title.backgroundColor = UIColor.clear
        title.textColor = UIColor.lightGray
        title.textAlignment = .left

        title.text = title.text?.localized

        contentView.addSubview(title)

        timeLabel = UILabel(frame: CGRect.zero)
        timeLabel.backgroundColor = UIColor.clear
        timeLabel.textColor = UIColor.lightGray
        timeLabel.textAlignment = .left
        contentView.addSubview(timeLabel)

        timeLabel1 = UILabel(frame: CGRect.zero)
        timeLabel1.backgroundColor = UIColor.clear
        timeLabel1.textColor = UIColor.lightGray
        timeLabel1.textAlignment = .left
        contentView.addSubview(timeLabel1)
        
        startPm = UILabel(frame: CGRect.zero)
        startPm.backgroundColor = UIColor.clear
        startPm.textColor = UIColor.lightGray
        startPm.textAlignment = .left
        contentView.addSubview(startPm)
        endPm = UILabel(frame: CGRect.zero)
        endPm.backgroundColor = UIColor.clear
        endPm.textColor = UIColor.lightGray
        endPm.textAlignment = .left
        contentView.addSubview(endPm)
        
        weekdaysLabel = UILabel(frame: CGRect.zero)
        weekdaysLabel.backgroundColor = UIColor.clear
        weekdaysLabel.textColor = UIColor.lightGray
        weekdaysLabel.textAlignment = .left
        contentView.addSubview(weekdaysLabel)

        titleImage = UIImageView(frame: CGRect.zero)
        titleImage.image = UIImage(named: "st_book_blue")
        contentView.addSubview(titleImage)
        
        optionButton = UIButton(frame: CGRect.zero)
        optionButton.setImage(UIImage(named: "menu_grey"), for: .normal)
        optionButton.addTarget(self, action: #selector(handleMenuList(_:)), for: .touchUpInside)
        contentView.addSubview(optionButton)

//        selectiveBorderFlag = UInt(AUISelectiveBordersFlagRight)
//        selectiveBordersColor = UIColor.lightGray
//        selectiveBordersWidth = 1.0

        borderView = UIView(frame: CGRect.zero)
        borderView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        addSubview(borderView)

        switchView = UISwitch(frame: CGRect.zero)
        switchView.onTintColor = RGBCOLOR(24, 167, 225, 1)
        
        switchView.backgroundColor = UIColor.clear
        switchView.addTarget(self, action: #selector(handleStatusChange(_:)), for: .valueChanged)
        optionButton.addTarget(self, action: #selector(handleMenuList(_:)), for: .touchUpInside)
        addSubview(switchView)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if SwiftFTUtils.isDeviceiPhoneFamily() {
            
            contentView.backgroundColor = UIColor.white
            contentView.frame = CGRect(x: 10.0, y: 10.0, width: bounds.width - 20.0, height: bounds.height - 10.0)
            contentView.layer.cornerRadius = 10
            title.font = UIFont(name: "OpenSans", size: 17)
            timeLabel.font = UIFont(name: "OpenSans", size: 25)
            weekdaysLabel.font = UIFont(name: "OpenSans", size: 14)

            timeLabel1.font = UIFont(name: "OpenSans", size: 25)
            startPm.font = UIFont(name: "OpenSans", size: 13)
            endPm.font = UIFont(name: "OpenSans", size: 13)
            
            titleImage.frame = CGRect(x: 15.0, y: 15.0, width: 35.0, height: 35.0)

            title.frame = CGRect(x: 60.0, y: 20.5, width: contentView.bounds.width - 20.0, height: 25.0)
            optionButton.frame = CGRect(x: contentView.frame.maxX - 40.0, y: 20.5, width: 25.0, height: 27.0)
            borderView.frame = CGRect(x: 10.0, y: 70.0, width: contentView.bounds.width, height: 1.0)
            
            switchView.frame = CGRect(x: borderView.frame.maxX - 65.0, y: borderView.frame.maxY + 20.0, width: 51, height: 46)
            timeLabel.frame = CGRect(x: 15.0, y: borderView.frame.maxY + 10.0, width: 64.0, height: 30.0)
            weekdaysLabel.frame = CGRect(x: 15.0, y: timeLabel.frame.maxY + 10.0, width: 200, height: 15.0)
            startPm.frame = CGRect(x: 80.0, y: borderView.frame.maxY + 8.0, width: 22.0, height: 20.0)
            timeLabel1.frame = CGRect(x: 113.0, y: borderView.frame.maxY + 10.0, width: 96.0, height: 30.0)
            endPm.frame = CGRect(x: 205.0, y: borderView.frame.maxY + 8.0, width: 26.0, height: 15.0)
            
        } else {
            
            contentView.backgroundColor = UIColor.white
            contentView.frame = CGRect(x: 10.0, y: 10.0, width: bounds.width - 20.0, height: bounds.height - 10.0)
            contentView.layer.cornerRadius = 10
            title.font = UIFont(name: "OpenSans", size: 17)
            timeLabel.font = UIFont(name: "OpenSans", size: 25)
            weekdaysLabel.font = UIFont(name: "OpenSans", size: 14)

            timeLabel1.font = UIFont(name: "OpenSans", size: 25)
            startPm.font = UIFont(name: "OpenSans", size: 13)
            endPm.font = UIFont(name: "OpenSans", size: 13)
            
            titleImage.frame = CGRect(x: 15.0, y: 15.0, width: 35.0, height: 35.0)

            title.frame = CGRect(x: 60.0, y: 20.5, width: contentView.bounds.width - 20.0, height: 25.0)
            optionButton.frame = CGRect(x: contentView.frame.maxX - 40.0, y: 20.5, width: 25.0, height: 27.0)
            borderView.frame = CGRect(x: 10.0, y: 70.0, width: contentView.bounds.width, height: 1.0)
            
            switchView.frame = CGRect(x: borderView.frame.maxX - 65.0, y: borderView.frame.maxY + 20.0, width: 51, height: 46)
            timeLabel.frame = CGRect(x: 15.0, y: borderView.frame.maxY + 10.0, width: 64.0, height: 30.0)
            weekdaysLabel.frame = CGRect(x: 15.0, y: timeLabel.frame.maxY + 10.0, width: 200, height: 15.0)
            startPm.frame = CGRect(x: 80.0, y: borderView.frame.maxY + 8.0, width: 22.0, height: 20.0)
            timeLabel1.frame = CGRect(x: 113.0, y: borderView.frame.maxY + 10.0, width: 96.0, height: 30.0)
            endPm.frame = CGRect(x: 205.0, y: borderView.frame.maxY + 8.0, width: 26.0, height: 15.0)
            
        }
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
    
    func setRule(_ rule: AccessControlRuleModel?) {
        
        guard let rule = rule else {
            return
        }
        self.rule = rule
        title.text = self.rule.rule_name

        let start_date = rule.time_start
        let end_date = rule.time_end
        let startTime = UTCToLocalConverter(timeToConvert: start_date ?? "")
        let endTimeTime = UTCToLocalConverter(timeToConvert: end_date ?? "")
        let startArr = startTime.split(separator: " ")
        let endArr   = endTimeTime.split(separator: " ")
        
        timeLabel.text = String(startArr.first ?? "")
        
        let combined = "\(" -  ")\(String(endArr.first ?? ""))"
        timeLabel1.text = combined
        startPm.text = String(startArr.last ?? "")
        endPm.text = String(endArr.last ?? "")
        
        if startTime == "" {
            timeLabel.text = ""
        }
        let finalStr = NSMutableAttributedString()
        //sunday
        let sunday = NSMutableAttributedString(string: "SU  ")
        
        if let object = rule.is_sunday {
            print("\(object)")
        }
        if let isSundayString = rule.is_sunday, let isSundayInt = Int(isSundayString), isSundayInt == 1,
            let isActiveString = rule.is_active, let isActiveInt = Int(isActiveString), isActiveInt == 1 {
            sunday.addAttribute(.foregroundColor, value: RGBCOLOR(3, 169, 244, 1), range: NSRange(location: 0, length: sunday.length))
        } else {
            sunday.addAttribute(.foregroundColor, value: UIColor.lightGray, range: NSRange(location: 0, length: sunday.length))
        }

        
        sunday.addAttribute(.font, value: weekdaysLabel.font ?? UILabel(), range: NSRange(location: 0, length: sunday.length))
        finalStr.append(sunday)
        //monday
        let monday = NSMutableAttributedString(string: "MO  ")
        if let isMondayString = rule.is_monday, let isMondayInt = Int(isMondayString), isMondayInt == 1,
            let isActiveString = rule.is_active, let isActiveInt = Int(isActiveString), isActiveInt == 1 {
            monday.addAttribute(.foregroundColor, value: RGBCOLOR(3, 169, 244, 1), range: NSRange(location: 0, length: monday.length))
        } else {
            monday.addAttribute(.foregroundColor, value: UIColor.lightGray, range: NSRange(location: 0, length: monday.length))
        }

        
        monday.addAttribute(.font, value: weekdaysLabel.font ?? UILabel(), range: NSRange(location: 0, length: monday.length))
        finalStr.append(monday)
        
        let tuesday = NSMutableAttributedString(string: "TU  ")
        if let isTuesdayString = rule.is_tuesday, let isTuesdayInt = Int(isTuesdayString), isTuesdayInt == 1,
            let isActiveString = rule.is_active, let isActiveInt = Int(isActiveString), isActiveInt == 1 {
            tuesday.addAttribute(.foregroundColor, value: RGBCOLOR(3, 169, 244, 1), range: NSRange(location: 0, length: tuesday.length))
        } else {
            tuesday.addAttribute(.foregroundColor, value: UIColor.lightGray, range: NSRange(location: 0, length: tuesday.length))
        }

        
        tuesday.addAttribute(.font, value: weekdaysLabel.font ?? UILabel(), range: NSRange(location: 0, length: tuesday.length))
        finalStr.append(tuesday)

        //wednesday
        let wednesday = NSMutableAttributedString(string: "WE  ")
        if let isWednesdayString = rule.is_wednesday, let isWednesdayInt = Int(isWednesdayString), isWednesdayInt == 1,
            let isActiveString = rule.is_active, let isActiveInt = Int(isActiveString), isActiveInt == 1 {
            wednesday.addAttribute(.foregroundColor, value: RGBCOLOR(3, 169, 244, 1), range: NSRange(location: 0, length: wednesday.length))
        } else {
            wednesday.addAttribute(.foregroundColor, value: UIColor.lightGray, range: NSRange(location: 0, length: wednesday.length))
        }

        wednesday.addAttribute(.font, value: weekdaysLabel.font ?? UILabel(), range: NSRange(location: 0, length: wednesday.length))
        finalStr.append(wednesday)
        
        //thursday
        let thursday = NSMutableAttributedString(string: "TH  ")
        if let isThursdayString = rule.is_thursday, let isThursdayInt = Int(isThursdayString), isThursdayInt == 1,
            let isActiveString = rule.is_active, let isActiveInt = Int(isActiveString), isActiveInt == 1 {
            thursday.addAttribute(.foregroundColor, value: RGBCOLOR(3, 169, 244, 1), range: NSRange(location: 0, length: thursday.length))
        } else {
            thursday.addAttribute(.foregroundColor, value: UIColor.lightGray, range: NSRange(location: 0, length: thursday.length))
        }

        
        thursday.addAttribute(.font, value: weekdaysLabel.font ?? UILabel(), range: NSRange(location: 0, length: thursday.length))
        finalStr.append(thursday)

        //friday
        let friday = NSMutableAttributedString(string: "FR  ")
        if let isFridayString = rule.is_friday, let isFridayInt = Int(isFridayString), isFridayInt == 1,
            let isActiveString = rule.is_active, let isActiveInt = Int(isActiveString), isActiveInt == 1 {
            friday.addAttribute(.foregroundColor, value: RGBCOLOR(3, 169, 244, 1), range: NSRange(location: 0, length: friday.length))
        } else {
            friday.addAttribute(.foregroundColor, value: UIColor.lightGray, range: NSRange(location: 0, length: friday.length))
        }

        friday.addAttribute(.font, value: weekdaysLabel.font ?? UILabel(), range: NSRange(location: 0, length: friday.length))
        finalStr.append(friday)
        //saturday
        let saturday = NSMutableAttributedString(string: "SA")
        if let isSaturdayString = rule.is_saturday, let isSaturdayInt = Int(isSaturdayString), isSaturdayInt == 1,
            let isActiveString = rule.is_active, let isActiveInt = Int(isActiveString), isActiveInt == 1 {
            saturday.addAttribute(.foregroundColor, value: RGBCOLOR(3, 169, 244, 1), range: NSRange(location: 0, length: saturday.length))
        } else {
            saturday.addAttribute(.foregroundColor, value: UIColor.lightGray, range: NSRange(location: 0, length: saturday.length))
        }

        saturday.addAttribute(.font, value: weekdaysLabel.font ?? UILabel(), range: NSRange(location: 0, length: saturday.length))
        finalStr.append(saturday)
        weekdaysLabel.attributedText = finalStr
        
        if Int(rule.is_active ?? "0") == 1 {
            
            switchView.isOn = true
            title.textColor = RGBCOLOR(3, 169, 244, 1)
            timeLabel1.textColor = RGBCOLOR(96, 96, 96, 1)
            timeLabel.textColor = RGBCOLOR(96, 96, 96, 1)
            startPm.textColor = RGBCOLOR(96, 96, 96, 1)
            endPm.textColor = RGBCOLOR(96, 96, 96, 1)
        } else {
            switchView.isOn = false
            title.textColor = UIColor.lightGray
            timeLabel1.textColor = UIColor.lightGray
            timeLabel.textColor = UIColor.lightGray
            startPm.textColor = UIColor.lightGray
            endPm.textColor = UIColor.lightGray
        }
        
        titleImage.image = CommonModel.newImage(forHeaderSST: rule.rule_name, isRuleActive: switchView.isOn)
    }
    
    @objc func handleStatusChange(_ switchView: UISwitch?) {
        delegate?.didRuleStatusChanged(switchView!.isOn, indexPath: indexPath)
    }
    
    @objc func handleMenuList(_ sender: UIButton?) {
        print("Menu button was tapped")
        delegate?.didOptionButtonTapped(indexPath)
    }
}
 
