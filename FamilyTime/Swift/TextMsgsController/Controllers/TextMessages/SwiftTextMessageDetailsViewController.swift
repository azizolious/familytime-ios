//
//  SwiftTextMessageDetailsViewController.swift
//  FamilyTime
//
//  Created by YumyApps on 28/10/2021.
//  Copyright © 2021 YumyApps. All rights reserved.
//

import UIKit
import MBProgressHUD

class SwiftTextMessageDetailsViewController: UIViewController, STBubbleTableViewCellDataSource, STBubbleTableViewCellDelegate {
    
    //MARK: - VARIABLES
    var tableView = UITableView()
    let delegate = UIApplication.shared.delegate as? AppDelegate
    var refreshControl = UIRefreshControl()
    var thread_id = ""
    var parsedMessages = [AnyHashable : Any]()
    var dates = [AnyHashable]()
    var messages = [AnyHashable]()
    var dataSource = [AnyHashable]()
    let child_Id = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
    
    //MARK: - VIEWS LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        if SwiftFTUtils.isDeviceiPhoneFamily() {
            self.tableView = UITableView(frame: view.bounds.insetBy(dx: 20, dy: 10), style: .grouped)
        } else {
            self.tableView = UITableView(frame: view.bounds.insetBy(dx: 35, dy: 20), style: .grouped)
        }
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.view.addSubview(tableView)
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: view.frame.size.width, height: 10.0))
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = UIColor.white
        self.tableView.showsVerticalScrollIndicator = false
        tableView.contentInset.bottom = 40
        self.addPullRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.loadMessagesDetails()
    }
    
    func addPullRefresh() {
        refreshControl = UIRefreshControl()
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(loadMessagesDetails), for: .valueChanged)
    }
    
    @objc func loadMessagesDetails() {
        SwiftFTUtils.showHUDAdded(to: view, withText: "Loading...", animated: true)
        let url = String(format: "\(kBasUrlNew_mesh2)/dashboard/messages/\(Int(child_Id ?? "") ?? -1)/\(thread_id)")
        print(url)
        ApiManager.shared().mesh_getApi(withApi: url) { json, errorCode, message in
            
            DispatchQueue.main.async {
                print("Old Mesh api Text MEssages Detail json = \(json)")
                if (json["status"] as? NSNumber)?.intValue ?? 0 == 200 {
                    self.dataSource.removeAll()
                    self.dates.removeAll()
                    self.parsedMessages.removeAll()
                    self.messages.removeAll()
                    var thread: MessagesModel? = nil
                    do {
                        thread = try MessagesModel(dictionary: json)
                    } catch {
                    }
                    if let thread = thread {
                        print("Message Thread = \(thread)")
                    }
                    if let msg = thread?.messages {
                        self.messages = msg as! [AnyHashable]
                        print(self.messages)
                    }
                    self.dataSource = self.messages
                    print(self.dataSource.count)
                    for index in 0..<(self.dataSource.count) {
                        let msg = self.dataSource[index] as? MessageModel
                        let message = Message()
                        if let is_sent = msg?.is_sent {
                            print("isSend = \(is_sent)")
                        }
                        if Int(msg?.is_sent ?? "-1") != 0 {
                            message.sender = MessageSender.myself
                            message.status = MessageStatus.sent
                            
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            let date = dateFormatter.date(from: msg?.message_date ?? "")
                            message.date = date
                        }
                        if Int(msg?.is_received ?? "-1") != 0 {
                            message.sender = MessageSender.someone
                            message.status = MessageStatus.received
                            
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            let date = dateFormatter.date(from: msg?.message_date ?? "")
                            message.date = date
                        }
                        message.identifier = msg?.sms_id
                        message.chat_id = msg?.thread_id
                        message.text = msg?.body
                        self.messages.append(message)
                        //add message to parsed data
                        if self.isdateAlreadyExists(message) {
                            self.addMessage(toExistingDate: message)
                        } else {
                            self.addNewDate(with: message)
                        }
                    }
                } else {
                    CommonModel.showAlert("Error!", msg: json["message"] as? String)
                }
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            }
        }
    }
    
    func isdateAlreadyExists(_ message: Message?) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var strDate: String? = nil
        if let date1 = message?.date {
            strDate = dateFormatter.string(from: date1)
        }
        for date in dates {
            if date == strDate as AnyHashable {
                return true
            }
        }
        return false
    }
    
    func addNewDate(with message: Message?) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var strDate: String = ""
        if let date = message?.date {
            strDate = dateFormatter.string(from: date)
        }
        if strDate == "" {
            strDate = ""
        }
        dates.append(strDate)
        var newArray: [AnyHashable] = []
        newArray.append(message)
        print(strDate)
        parsedMessages[strDate] = newArray
        
    }
    
    func addMessage(toExistingDate message: Message?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var strDate: String? = nil
        if let date = message?.date {
            strDate = dateFormatter.string(from: date)
        }
        var existingArray = parsedMessages[strDate] as? [AnyHashable]
        if let message = message {
            existingArray?.append(message)
        }
        parsedMessages[strDate ?? ""] = existingArray
    }
}

//MARK: - TableView Data Sourse and TableView Delegate

extension SwiftTextMessageDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dates.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let key = dates[section] as? String
        let messages = parsedMessages[key ?? ""] as? [AnyHashable]
        print(messages)
        return (messages?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let key = dates[section] as? String
        let messages = parsedMessages[key ?? ""] as? [AnyHashable]
        let message = messages?[0] as? Message
        let days = daysBetweenDate(message?.date, andDate: Date())
        if days == 0 {
            return "Today".myModification()
        } else if days == 1 {
            return "Yesterday".myModification()
        } else {
            let df = DateFormatter()
            df.dateFormat = "EEEE, MMM dd"
            return df.string(from: (message?.date)!)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40)
        let view = UIView(frame: frame)
        view.backgroundColor = UIColor.clear
        view.autoresizingMask = .flexibleWidth
        let label = UILabel()
        label.text = self.tableView(tableView, titleForHeaderInSection: section)
        label.textAlignment = .center
        label.font = UIFont(name: "Helvetica", size: 20.0)
        label.sizeToFit()
        label.center = view.center
        label.font = UIFont(name: "Helvetica", size: 13.0)
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.lightGray
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.autoresizingMask = []
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let CellIdentifier = "Bubble Cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as? STBubbleTableViewCell
        if cell == nil {
            cell = STBubbleTableViewCell(style: .default, reuseIdentifier: CellIdentifier)
            cell?.backgroundColor = tableView.backgroundColor
            cell?.selectionStyle = .none
            cell?.dataSource = self
            cell?.delegate = self
        }
        let key = dates[indexPath.section] as? String
        let messages = parsedMessages[key ?? ""] as? [AnyHashable]
        let message = messages?[indexPath.row] as? Message
        let attributedString = NSMutableAttributedString()
        
        var messageStr: NSMutableAttributedString? = nil
        if let text = message?.text {
            messageStr = NSMutableAttributedString(string: "\(text)\n")
        }
        if message?.sender == MessageSender.myself {
            messageStr?.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: messageStr!.length))
        } else {
            messageStr?.addAttribute(.foregroundColor, value: UIColorFromRGB(0x252525), range: NSRange(location: 0, length: messageStr?.length ?? -1))
        }
        
        messageStr?.addAttribute(.font, value: UIFont(name: "Helvetica", size: 15.0) ?? UIFont(), range: NSRange(location: 0, length: messageStr?.length ?? -1))
        attributedString.append(messageStr!)
        
        //Set Text to Label
        let df = DateFormatter()
        df.timeStyle = .short
        df.dateStyle = .none
        df.doesRelativeDateFormatting = true
        let time = df.string(from: (message?.date)!)
        let dateStr = NSMutableAttributedString(string: "\(time)")
        dateStr.addAttribute(.font, value: UIFont(name: "Helvetica", size: 10.0) ?? UIFont(), range: NSRange(location: 0, length: dateStr.length))
        if message?.sender == MessageSender.myself {
            dateStr.addAttribute(.foregroundColor, value: UIColorFromRGB(0xcbe9fe), range: NSRange(location: 0, length: dateStr.length))
        } else {
            dateStr.addAttribute(.foregroundColor, value: UIColorFromRGB(0x656462), range: NSRange(location: 0, length: dateStr.length))
        }
        attributedString.append(dateStr)
        if message?.sender == MessageSender.myself {
            cell?.authorType = AuthorType.STBubbleTableViewCellAuthorTypeSelf
            cell?.bubbleView.tintColor = UIColorFromRGB(0x3daefe)
        } else {
            cell?.authorType = AuthorType.STBubbleTableViewCellAuthorTypeOther
            cell?.bubbleView.tintColor = UIColorFromRGB(0xe6e5eb)
        }
        cell?.textLabel?.attributedText = attributedString
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let key = dates[indexPath.section] as? String
        let messages = parsedMessages[key ?? ""] as? [AnyHashable]
        let message = messages?[indexPath.row] as? Message
        var str: String? = nil
        if let text = message?.text {
            str = "\(text)\n\(Date().description)"
        }
        var size: CGSize = CGSize(width: 0, height: 0)
        
        if false { // if message has avartar
            if let font = UIFont(name: "Helvetica", size: 15) {
                size = (message?.text.boundingRect(
                    with: CGSize(width: tableView.frame.size.width - minInset(for: nil, at: indexPath) - CGFloat(STBubbleImageSize) - 8.0 - CGFloat(STBubbleWidthOffset), height: CGFloat.greatestFiniteMagnitude),
                    options: .usesLineFragmentOrigin,
                    attributes: [
                        NSAttributedString.Key.font: font
                    ],
                    context: nil).size)!
            }
        } else {
            if let font = UIFont(name: "Helvetica", size: 15) {
                size = (str?.boundingRect(
                    with: CGSize(width: tableView.frame.size.width - minInset(for: nil, at: indexPath) - CGFloat(STBubbleWidthOffset), height: CGFloat.greatestFiniteMagnitude),
                    options: .usesLineFragmentOrigin,
                    attributes: [
                        NSAttributedString.Key.font: font
                    ],
                    context: nil).size)!
            }
        }
        if size.height + 15.0 < Double(STBubbleImageSize) + 4.0 && false {
            return Double(STBubbleImageSize) + 4.0
        }
        return size.height + 15.0
    }
    
    //MARK: - STBubbleTableViewCellDataSource methods
    func minInset(for cell: STBubbleTableViewCell?, at indexPath: IndexPath?) -> CGFloat {
        if SwiftFTUtils.isDeviceiPhoneFamily() {
            return 50.0
        } else {
            return 300
        }
    }
    func loadFakeMessages() {
        messages = [AnyHashable]()
        for index in 0..<20 {
            let message = Message()
            let randNum = Int(arc4random() % (10 - 0) + 0)
            if randNum % 2 == 0 {
                message.sender = MessageSender.myself
                message.status = MessageStatus.sent
            } else {
                message.sender = MessageSender.someone
                message.status = MessageStatus.received
            }
            message.identifier = String(format: "A%ld", Int(index))
            message.chat_id = String(format: "AA%ld", Int(index))
            message.text = String(format: "This is a simple message for testing number %ld", Int(index))
            message.date = Date()
            messages.append(message)
        }
    }
    
    func daysBetweenDate(_ fromDateTime: Date?, andDate toDateTime: Date?) -> Int {
        let calendar = NSCalendar.current
        let fromDate = calendar.startOfDay(for: fromDateTime!) // <1>
        let toDate = calendar.startOfDay(for: toDateTime!) // <2>
        let numberOfDays = calendar.dateComponents([.day], from: fromDate, to: toDate) // <3>
        return numberOfDays.day!
    }
}
