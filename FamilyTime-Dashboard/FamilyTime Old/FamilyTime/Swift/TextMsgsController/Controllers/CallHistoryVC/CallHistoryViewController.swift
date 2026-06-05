//
//  CallHistoryViewController.swift
//  FamilyTime
//
//  Created by YumyApps on 02/12/2021.
//  Copyright © 2021 YumyApps. All rights reserved.
//

import UIKit
import MBProgressHUD
import DropDown

class CallHistoryViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var lastDayLabel: UILabel!
    @IBOutlet weak var dateRangeLabel: UILabel!
    @IBOutlet weak var daysBtn: UIButton!
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var itsSeemLikeLabel: UILabel!
    @IBOutlet weak var noDataImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var oopsLabel: UILabel!
    @IBOutlet weak var callLogLabel: UILabel!
    
    let delegate = UIApplication.shared.delegate as? AppDelegate
    let child_Id = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
    
    var refreshControl = UIRefreshControl()
    var dataSource = [AnyHashable]()
    var contactColors = [UIColor?]()
    
    var dropDown = DropDown()
    var day_count = 0
    
    var serverdate = ""
    var serverdate11 = ""
    
    var colorArray = [UIColor(red: 255, green: 132, blue: 0), UIColor(red: 114, green: 102, blue: 186), UIColor(red: 240, green: 80, blue: 80), UIColor(red: 162, green: 201, blue: 34)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        navigationItem.title = "call_history_title".localized
        self.tableView.register(UINib(nibName: "CallCell", bundle: nil), forCellReuseIdentifier: "callCell")
        self.contactColors = KCallColor
        self.addPullRefresh()
        self.oopsLabel.text = "oops_title".localized
        self.callLogLabel.text = "call_history_content_1".localized
        navigationController?.navigationBar.barStyle = .default
        
        
        itsSeemLikeLabel.text = "call_history_content_2".localized
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            
            noDataImage.image = UIImage(named: "ipad_empty")
            itsSeemLikeLabel.textColor = UIColor.lightGray
            itsSeemLikeLabel.text = "call_history_content_2".localized
            itsSeemLikeLabel.font = UIFont.systemFont(ofSize: 16)
            itsSeemLikeLabel.lineBreakMode = .byWordWrapping
            itsSeemLikeLabel.numberOfLines = 2
            itsSeemLikeLabel.textAlignment = .center
            
        }else if UIDevice.current.userInterfaceIdiom == .phone {
            
            noDataImage.image = UIImage(named: "ic_empty")
            itsSeemLikeLabel.textColor = UIColor.lightGray
            itsSeemLikeLabel.text = "call_history_content_2".localized
            itsSeemLikeLabel.font = UIFont.systemFont(ofSize: 17)
            itsSeemLikeLabel.lineBreakMode = .byWordWrapping
            itsSeemLikeLabel.numberOfLines = 2
            itsSeemLikeLabel.textAlignment = .center
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        ZendeskChatManager.trackEvent("Call History")
        if day_count == 1 {
            self.lastDayLabel.text = "date_drop_down_2".localized
            self.updateDateLabel(isToday: false)
        } else if day_count == 7 {
            self.lastDayLabel.text = "date_drop_down_3".localized
            self.updateDateLabelForMoreDays(index: 2)
        } else if day_count == 14 {
            self.lastDayLabel.text = "date_drop_down_4".localized
            self.updateDateLabelForMoreDays(index: 3)
        } else if day_count == 30 {
            self.lastDayLabel.text = "date_drop_down_5".localized
            self.updateDateLabelForMoreDays(index: 4)
        } else {
            self.lastDayLabel.text = "date_drop_down_1".localized
            self.updateDateLabel(isToday: true)
        }
        self.dropDownSetup()
        self.loadCallLogs()
    }
    
    @IBAction func actionSelectDays(_ sender: UIButton) {
        dropDown.show()
    }
    
    
    @IBAction func bacjkBtn(_ sender: Any) {
        
        if ((self.navigationController?.viewControllers.contains(self)) != nil) {
            self.navigationController?.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
        
    }
    
    func addPullRefresh() {
        refreshControl = UIRefreshControl()
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshControlAction), for: .valueChanged)
    }
    
    @objc func refreshControlAction() {
        self.loadCallLogs()
    }
    
    func refreshTable() {
        
        refreshControl.endRefreshing()
        tableView.reloadData()
        
    }
    
    func daysBetweenDate(_ fromDateTime: Date?, andDate toDateTime: Date?) -> Int {
        
        let calendar = NSCalendar.current
        
        let fromDate = calendar.startOfDay(for: fromDateTime!) // <1>
        let toDate = calendar.startOfDay(for: toDateTime!) // <2>
        let numberOfDays = calendar.dateComponents([.day], from: fromDate, to: toDate) // <3>
        
        return numberOfDays.day ?? 0
        
    }
    @objc func loadCallLogs() {
        // Get the current calendar and the user's current time zone
        let calendar = Calendar.current
        let timeZone = TimeZone.current
        
        // Calculate the start date and end date based on the selected time range
        var endDate = Date()
        var startDate = Date()
        
        switch day_count {
        case 0 :
            startDate = calendar.startOfDay(for: Date())
        case 1:
            startDate = calendar.date(byAdding: .day, value: -1, to: calendar.startOfDay(for: Date()))!
        case 7:
            startDate = calendar.date(byAdding: .day, value: -7, to: endDate)!
        case 14:
            startDate = calendar.date(byAdding: .day, value: -14, to: endDate)!
        case 30:
            startDate = calendar.date(byAdding: .day, value: -30, to: endDate)!
        default:
            break
        }
        
        let calls = DBManager.shared.fetchCalls(forChildId: Int(child_Id ?? "") ?? 0, fromDate: startDate, toDate: endDate)
        var convertedCallLogs = [CallLogsModel]()
        var totalDurationSeconds = 0
        for call in calls {
            let convertedCall = CallLogsModel()
            convertedCall.call_id = call.callID.map { String($0) }
            convertedCall.name = call.name
            convertedCall.number = call.number
            convertedCall.type = call.type
            convertedCall.call_time = call.callTime
            convertedCall.duration = call.duration
            
            if let durationInSecondsString = call.durationInSeconds {
                totalDurationSeconds += Int(durationInSecondsString) ?? 0
            }
            
            convertedCallLogs.append(convertedCall)
        }
        
        // Calculate total duration in hours, minutes, and seconds
        let (totalHours, totalMinutes, totalSeconds) = secondsToHoursMinutesSeconds(seconds: totalDurationSeconds)
        
        // Format the total duration string
        let totalDurationString: String
        if totalHours > 0 {
            totalDurationString = String(format: "%dh %02dm", totalHours, totalMinutes)
        } else {
            totalDurationString = String(format: "%dm %02ds", totalMinutes, totalSeconds)
        }
        self.totalTimeLabel.text = totalDurationString
        self.dataSource = convertedCallLogs
        refreshTable()
    }
    
    func totalTimeFromArrayOfTimes(array: [String]) {
        
        var minutes:Int = 0
        var seconds:Int = 0
        for timeString in array {
            let components = timeString.components(separatedBy: ":")
            let minComp = Int(components.first ?? "0") ?? 0
            let secComp = Int(components.last ?? "0") ?? 0
            minutes += minComp
            seconds += secComp
        }
        minutes += seconds/60
        seconds = seconds%60
        let minsString = minutes.description
        let secsString = seconds.description
        var totalTime = "0s"
        if minutes != 0 {
            totalTime = minsString+"m, "+secsString+"s"
        } else {
            totalTime = secsString+"s"
        }
        self.totalTimeLabel.text = totalTime
    }
    
    @objc func buttonClicked(_ sender: UIButton?) {
        if sender?.isSelected ?? false {
            sender?.setImage(
                UIImage(named: "blacklist_unselect.png"),
                for: .normal)
            sender?.isSelected = false
        } else {
            sender?.setImage(
                UIImage(named: "blacklist_select.png"),
                for: .selected)
            sender?.isSelected = true
            //[self addContactToWatchList:sender];
        }
    }
    
    func addContact(toWatchList sender: UIButton?) {
        guard let tag = sender?.tag else {
            return
        }
        _ = dataSource[tag] as? CallLogsModel
        SwiftFTUtils.showHUDAdded(to: view, withText: "Adding...".myModification(), animated: true)
    }
    
    func dropDownSetup(){
        
        if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
            dropDown.anchorView = totalTimeLabel // UIView or UIBarButtonItem
        } else {
            dropDown.anchorView = daysBtn // UIView or UIBarButtonItem
        }
        dropDown.dataSource = ["date_drop_down_1".localized, "date_drop_down_2".localized, "date_drop_down_3".localized, "date_drop_down_4".localized, "date_drop_down_5".localized]
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.lastDayLabel.text = item
            
            switch index {
            case 1:
                self.day_count = 1
                self.updateDateLabel(isToday: false)
            case 2:
                self.day_count = 7
            case 3:
                self.day_count = 14
            case 4:
                self.day_count = 30
            default:
                self.day_count = 0
                self.updateDateLabel()
            }
            
            if index == 2 || index == 3 || index == 4{
                self.updateDateLabelForMoreDays(index: index)
            }
            
            self.loadCallLogs()
        }
    }
    
    //MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.dataSource.count == 0 {
            
            self.noDataView.isHidden = false
            return 0
            
        } else {
            
            self.noDataView.isHidden = true
            return self.dataSource.count
            
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var firstChar: String? = nil
        var cell = tableView.dequeueReusableCell(withIdentifier: "callCell") as? CallCell
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "callCell") as? CallCell
        }
        
        let model = dataSource[indexPath.row] as? CallLogsModel
        
        if model?.name == nil || (model?.name == "") {
            cell?.name.text = model?.number
            
            let now = Date()
            serverdate = CommonModel.date((model?.call_time)!, oldFormat: "YYYY-MM-dd HH:mm:ss", format: "yyyy-MM-dd HH:mm")
            let dateFormat7 = DateFormatter()
            dateFormat7.dateFormat = "yyyy-MM-dd HH:mm"
            let date7 = dateFormat7.date(from: serverdate)
            
            let timeDateDiff = daysBetweenDate(date7, andDate: now)
            
            let DaywithTimeDiff = Int(timeDateDiff)
            
            if DaywithTimeDiff == 0 {
                
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                
                var todayDate = ""
                
                if let date = date7 {
                    
                    todayDate = formatter.string(from: date)
                    print("\(todayDate)")
                    
                }
                cell?.lblDate.text = todayDate
                
            } else if Int(DaywithTimeDiff) == 1 {
                
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                
                var yesterdayDate = ""
                
                if let date = date7 {
                    
                    yesterdayDate = formatter.string(from: date)
                    print("\(yesterdayDate)")
                    
                }
                
                let myString = "Yesterday, "
                let test = myString + yesterdayDate
                print("\(test)")
                cell?.lblDate.text = test
                
            } else if Int(DaywithTimeDiff) > 1 {
                
                let formatter = DateFormatter()
                formatter.dateFormat = "MMM dd, HH:mm"
                
                var oldDate = ""
                
                if let date = date7 {
                    
                    oldDate = formatter.string(from: date)
                    print("\(oldDate)")
                    
                }
                
                cell?.lblDate.text = oldDate
                
            } else {
                
                if let callTime = model?.call_time {
                    
                    cell?.lblDate.text = CommonModel.date(callTime, oldFormat: "YYYY-MM-dd HH:mm:ss", format: "MMM dd HH:mm")
                    
                }
                
            }
            
            firstChar = "U"
            
        } else {
            
            let now = Date()
            
            if let callTime = model?.call_time {
                
                serverdate = CommonModel.date(callTime, oldFormat: "YYYY-MM-dd HH:mm:ss", format: "yyyy-MM-dd HH:mm")
                
            }
            
            let dateFormat7 = DateFormatter()
            
            dateFormat7.dateFormat = "yyyy-MM-dd HH:mm"
            let date7 = dateFormat7.date(from: serverdate)
            
            let timeDateDiff = daysBetweenDate(date7, andDate: now)
            
            let DaywithTimeDiff = Int(timeDateDiff)
            
            if Int(DaywithTimeDiff) == 0 {
                
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                
                var todayDate = ""
                
                if let date = date7 {
                    
                    todayDate = formatter.string(from: date)
                    print("\(todayDate)")
                    
                }
                
                cell?.lblDate.text = todayDate
                
            } else if Int(DaywithTimeDiff) == 1 {
                
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                
                var yesterdayDate = ""
                
                if let date = date7 {
                    
                    yesterdayDate = formatter.string(from: date)
                    print("\(yesterdayDate)")
                    
                }
                
                let myString = "Yesterday,"
                let test = myString + yesterdayDate
                print("\(test)")
                cell?.lblDate.text = test //[NSString stringWithFormat:@"%@, %@",model.number,test];
                cell?.lblDate.text = cell?.lblDate.text?.myModification()
                
            } else if Int(DaywithTimeDiff) > 1 {
                
                let formatter = DateFormatter()
                formatter.dateFormat = "MMM dd, HH:mm"
                
                var oldDate = ""
                
                if let date = date7 {
                    
                    oldDate = formatter.string(from: date)
                    print("\(oldDate)")
                    
                }
                
                cell?.lblDate.text = oldDate
            }
        }
        
        //        cell?.separator.isHidden = false
        let contactImgName = String(format: "call_circ_\(Int(indexPath.row) % 4 + 1).png")
        
        let avatarImgName = String(format: "avater\(Int(indexPath.row) % 4 + 1).png")
        
        let imgName = (model?.type == "Received") ? "received_call.png" : (model?.type == "Dialed") ? "dialed_call.png" : "missed_call.png"
        
        if model?.name == "Unknown" {
            
            cell?.name.text = model?.number
            cell?.lblCallNumber.text = "Unsaved"
            
            cell?.callType.setBackgroundImage(UIImage(named: imgName), for: .normal)
            
            cell?.contactImage.setBackgroundImage(UIImage(named: avatarImgName), for: .normal)
            
            let secondData = model?.duration.secondFromString ?? 0
            var (h,m,s) = secondsToHoursMinutesSeconds(seconds: secondData)
            
            if h > 0 {
                
                cell?.lblCallDuration.text = "\(h)h \(m)m"
                
            } else if m > 0 {
                
                cell?.lblCallDuration.text = "\(m)m \(s)s"
                
            } else {
                
                cell?.lblCallDuration.text = "\(s)s"
                
            }
            
            cell?.contactImage.setTitleColor(contactColors[indexPath.row % 4], for: .normal)
            cell?.btnBlackList.isHidden = true
            
        } else {
            
            cell?.name.text = model?.name
            cell?.lblCallNumber.text = model?.number
            
            cell?.callType.setBackgroundImage(UIImage(named: imgName), for: .normal)
            
            cell?.contactImage.setBackgroundImage(UIImage(named: contactImgName), for: .normal)
            
            let secondData = model?.duration.secondFromString ?? 0
            var (h,m,s) = secondsToHoursMinutesSeconds(seconds: secondData)
            
            if h > 0 {
                
                cell?.lblCallDuration.text = "\(h)h \(m)m"
                
            } else if m > 0 {
                
                cell?.lblCallDuration.text = "\(m)m \(s)s"
                
            } else {
                
                cell?.lblCallDuration.text = "\(s)s"
                
            }
            
            let phoneName = "\(model?.name ?? "")".uppercased()
            
            firstChar = "\(phoneName[phoneName.index(phoneName.startIndex, offsetBy: 0)])"
            let ahm = indexPath.row % 4
            let col = contactColors[ahm]
            
            cell?.contactImage.setTitleColor(col, for: .normal)
            cell?.btnBlackList.isHidden = false
            
        }
        
        let notDigits = CharacterSet.decimalDigits.inverted
        
        if (firstChar == "(") {
            
            cell?.name.text = "Unknown"
            let avatarImgName2 = String(format: "avater\(Int(indexPath.row) % 4 + 1).png")
            
            cell?.contactImage.setBackgroundImage(UIImage(named: avatarImgName2), for: .normal)
            cell?.contactImage.setTitle("", for: .normal)
            
        } else if firstChar?.rangeOfCharacter(from: notDigits) == nil {
            
            let avatarImgName2 = String(format: "avater\(Int(indexPath.row) % 4 + 1).png")
            
            cell?.contactImage.setBackgroundImage(UIImage(named: avatarImgName2), for: .normal)
            cell?.contactImage.setTitle("", for: .normal)
            
            // newString consists only of the digits 0 through 9
            
        } else {
            
            cell?.contactImage.setTitle(firstChar, for: .normal)
            
        }
        
        cell?.btnBlackList.addTarget(
            self,
            action: #selector(buttonClicked(_:)),
            for: .touchUpInside)
        
        cell?.btnBlackList.tag = indexPath.row
        
        //we are hiding this button for now unleass we resolve the API issue of adding it into watchlist and remove from watchlist, because contact_id is coming null form server in all cases.
        cell?.btnBlackList.isHidden = true
        return cell ?? UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
        
    }
    
    //MARK: - DATE LABEL METHODS
    
    func updateDateLabel(isToday:Bool = true){
        let date = isToday ? Date() : Date().dayBefore
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM"
        
        let dateStr = formatter.string(from: date)
        print("date = \(dateStr)")
        
        dateRangeLabel.text = dateStr
    }
    
    func updateDateLabelForMoreDays(index:Int){
        
        var date = Date()
        if index == 2{
            date = date.weekBefore
        }
        else if index == 3{
            date = date.fortNightBefore
        }
        else{
            date = date.monthBefore
        }
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        
        let dateStr = formatter.string(from: date)
        print("date = \(dateStr)")
        
        dateRangeLabel.text = "\(dateStr) - \(formatter.string(from: Date.yesterday))"
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
}

struct CallsModel: Codable {
    let calls: [Call]?
}

// MARK: - Call
struct Call: Codable {
    let callID: Int?
    let name, number, type, callTime: String?
    let duration, durationInSeconds: String?
    let contactID, childID, superUserID: Int?
    let dateCreated, dateModified: JSONNull?
    let deleted: Int?
    
    enum CodingKeys: String, CodingKey {
        case callID = "call_id"
        case name, number, type
        case callTime = "call_time"
        case duration
        case durationInSeconds = "duration_in_seconds"
        case contactID = "contact_id"
        case childID = "child_id"
        case superUserID = "super_user_id"
        case dateCreated = "date_created"
        case dateModified = "date_modified"
        case deleted
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {
    
    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }
    
    public var hashValue: Int {
        return 0
    }
    
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

extension Call {
    var dictionaryRepresentation: [String: AnyHashable] {
        return [
            "callID": self.callID ?? 0,
            "name": self.name ?? "",
            "number": self.number ?? "",
            "type": self.type ?? "",
            "callTime": self.callTime ?? "",
            "duration": self.duration ?? "",
            "durationInSeconds": self.durationInSeconds ?? "",
            "contactID": self.contactID ?? 0,
            "childID": self.childID ?? 0,
            "superUserID": self.superUserID ?? 0,
            "dateCreated": self.dateCreated ?? JSONNull(),
            "dateModified": self.dateModified ?? JSONNull(),
            "deleted": self.deleted ?? 0
        ]
    }
}
