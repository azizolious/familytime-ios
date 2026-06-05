//
//  TextMsgsViewController.swift
//  FamilyTime
//
//  Created by Sufyan on 27/12/2023.
//  Copyright © 2023 YumyApps. All rights reserved.
//

import UIKit

class TextMsgsViewController: UIViewController {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var tblVu: UITableView!
    
    var sortedMessages: [Date: [MessageThreadData]] = [:]
    var sectionDates: [Date] = []
    var msgs = [MessageThreadData]()
    var titleStr = ""
    var relaod: ()->() = {}
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        sortedMessages = groupMessagesByDate(msgs)
        sectionDates = Array(sortedMessages.keys.sorted(by: { $0 > $1 }))
        //sortedMessages = sortedMessages.mapValues { $0.reversed() }
        titleLbl.text = titleStr
//        for obj in msgs {
//            DBManager.shared.fetchAndUpdateSocialHistory(socialApps: obj)
//        }
    }
    private func initTableView() {
        tblVu.delegate = self
        tblVu.dataSource = self
        tblVu.register(UINib(nibName: "SenderCell", bundle: nil), forCellReuseIdentifier: "SenderCell")
        tblVu.register(UINib(nibName: "ReceiverCell", bundle: nil), forCellReuseIdentifier: "ReceiverCell")
        tblVu.register(UINib(nibName: "DateHeaderVu", bundle: nil), forHeaderFooterViewReuseIdentifier: "DateHeaderVu")

    }
    func groupMessagesByDate(_ messages: [MessageThreadData]) -> [Date: [MessageThreadData]] {
        var groupedMessages: [Date: [MessageThreadData]] = [:]
        
        for message in messages {
            let date = Calendar.current.startOfDay(for: message.sms_time?.getDateFromStr() ?? Date())
            if var messagesForDate = groupedMessages[date] {
                messagesForDate.append(message)
                groupedMessages[date] = messagesForDate
            } else {
                groupedMessages[date] = [message]
            }
        }
        
        return groupedMessages
    }
    func getStringFromDate(_ dateString: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "EEEE, d MMM yyyy"
        let date = dateFormatter.string(from: dateString)
        return date
    }
    @IBAction func backTapped(_ sender: Any) {
        //relaod()
        self.dismiss(animated: true)
    }
    func convertToShortTimeString(_ dateString: String, dateFormat: String, timeFormat: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        if let date = dateFormatter.date(from: dateString) {
            let timeFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            timeFormatter.dateFormat = timeFormat
            let shortTimeString = timeFormatter.string(from: date)
            return shortTimeString
        } else {
            print("Invalid date format or string.")
            return nil
        }
    }
}
extension TextMsgsViewController:UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionDates.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let obj = sectionDates[section]
        return sortedMessages[obj]?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let obj = sectionDates[indexPath.section]
        let message = sortedMessages[obj]?[indexPath.row]
        let shortTimeString = convertToShortTimeString(message?.sms_time ?? "2023-12-05 12:28:15", dateFormat: "yyyy-MM-dd HH:mm:ss", timeFormat: "h:mm a")
        if message?.type == "received" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverCell", for: indexPath) as! ReceiverCell
            cell.msgVu.backgroundColor = UIColor(hexString: "#F8F8F8")
            cell.timeLbl.text = shortTimeString
            cell.bodyLbl.text = message?.body ?? ""
            cell.selectionStyle = .none
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SenderCell", for: indexPath) as! SenderCell
            cell.msgView.backgroundColor = UIColor(hexString: "#156CF7")
            cell.timeLbl.text = shortTimeString
            cell.bodyLbl.text = message?.body ?? ""
            cell.selectionStyle = .none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let obj = sectionDates[section]
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "DateHeaderVu") as! DateHeaderView
        headerView.timeLBl.text = getStringFromDate(obj)
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
}
