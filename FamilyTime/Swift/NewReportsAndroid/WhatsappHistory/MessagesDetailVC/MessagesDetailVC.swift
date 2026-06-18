//
//  MessagesDetailVC.swift
//  FamilyTime
//
//  Created by Sufyan on 21/12/2023.
//  Copyright © 2023 YumyApps. All rights reserved.
//

import UIKit

class MessagesDetailVC: UIViewController {
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var tblVu: UITableView!
    
    var sortedMessages: [Date: [SocialApp]] = [:]
    var sectionDates: [Date] = []
    var apps = [SocialApp]()
    var titleStr = ""
    var relaod: ()->() = {}
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        sortedMessages = groupMessagesByDate(apps)
        sectionDates = Array(sortedMessages.keys.sorted(by: { $0 > $1 }))
        //sortedMessages = sortedMessages.mapValues { $0.reversed() }
        titleLbl.text = titleStr
        for obj in apps {
            DBManager.shared.fetchAndUpdateSocialHistory(socialApps: obj)
        }
    }
    private func initTableView() {
        tblVu.delegate = self
        tblVu.dataSource = self
        tblVu.register(UINib(nibName: "SenderCell", bundle: nil), forCellReuseIdentifier: "SenderCell")
        tblVu.register(UINib(nibName: "ReceiverCell", bundle: nil), forCellReuseIdentifier: "ReceiverCell")
        tblVu.register(UINib(nibName: "DateHeaderVu", bundle: nil), forHeaderFooterViewReuseIdentifier: "DateHeaderVu")

    }
    func groupMessagesByDate(_ messages: [SocialApp]) -> [Date: [SocialApp]] {
        var groupedMessages: [Date: [SocialApp]] = [:]
        
        for message in messages {
            let date = Calendar.current.startOfDay(for: message.date?.getDateFromStr() ?? Date())
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
        dateFormatter.dateFormat = "EEEE, d MMM yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let date = dateFormatter.string(from: dateString)
        return date
    }
    @IBAction func backTapped(_ sender: Any) {
        relaod()
        self.dismiss(animated: true)
    }
    func convertToShortTimeString(_ dateString: String, dateFormat: String, timeFormat: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        if let date = dateFormatter.date(from: dateString) {
            let timeFormatter = DateFormatter()
            timeFormatter.locale = Locale(identifier: "en_US_POSIX")
            timeFormatter.dateFormat = timeFormat
            let shortTimeString = timeFormatter.string(from: date)
            return shortTimeString
        } else {
            print("Invalid date format or string.")
            return nil
        }
    }
}
extension MessagesDetailVC:UITableViewDelegate, UITableViewDataSource {
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
        let shortTimeString = convertToShortTimeString(message?.date ?? "2023-12-05 12:28:15", dateFormat: "yyyy-MM-dd HH:mm:ss", timeFormat: "h:mm a")
        if message?.fromMe == "1" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SenderCell", for: indexPath) as! SenderCell
            cell.timeLbl.text = shortTimeString
            cell.bodyLbl.text = message?.body ?? ""
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverCell", for: indexPath) as! ReceiverCell
            cell.timeLbl.text = shortTimeString
            cell.bodyLbl.text = message?.body ?? ""
            cell.selectionStyle = .none
            return cell
        }
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        UITableView.automaticDimension
//    }
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
