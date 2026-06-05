//
//  TextMessagesMainViewController.swift
//  FamilyTime
//
//  Created by Rao Mudassar Khalil on 14/10/2021.
//  Copyright © 2021 YumyApps. All rights reserved.
//

import UIKit
import MBProgressHUD

class TextMessagesMainViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    var imgView = UIImageView()
    var contentLbl=UILabel()
    var oopsLbl=UILabel()
    
    var delegate: AppDelegate?
    var refreshControl = UIRefreshControl()
    
    var tableView = UITableView()
    var dataSource = [MessageThreadData]()
    var contactColors = [UIColor?]()
    
    var colorArray = [UIColor(red: 255, green: 132, blue: 0), UIColor(red: 114, green: 102, blue: 186), UIColor(red: 240, green: 80, blue: 80), UIColor(red: 162, green: 201, blue: 34)]
    
    var package_id : String = ""
    var package_name : String = ""
    var device : String = ""
    var isFromSideMenu: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        self.title = "text_messages_title".localized
        ZendeskChatManager.trackEvent("text Messages")
        
        view.backgroundColor = UIColor.white
        delegate = AppDelegate.getSharedAppDelegateForSwift()
        
        
        tableView = UITableView(frame: CGRect(x: 0.0, y: 100.0, width: view.bounds.width, height: view.bounds.height - 64.0), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "MessageThreadCell", bundle: nil), forCellReuseIdentifier: "messages_cell")
        
        tableView.rowHeight = 80
        contactColors = KCallColor
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        let screenSize: CGRect = UIScreen.main.bounds
        let myView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width - 0, height: 100))
        if #available(iOS 15.0, *) {
//            myView.layer.backgroundColor = UIColor.systemCyan.cgColor
        } else {
            // Fallback on earlier versions
        }
        
        let myFirstButton = UIButton()
        myFirstButton.setImage(UIImage(named: "backBtnWhite"), for: .normal)
        myFirstButton.setTitleColor(UIColor.blue, for: .normal)
        myFirstButton.frame = CGRectMake(15, -50, 30, 240)
        myFirstButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        myView.addSubview(myFirstButton)
        let titleLbl = UILabel()
        titleLbl.text = "settings_card_1_android_2".localized
        titleLbl.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        titleLbl.textAlignment = .center
        titleLbl.textColor = .black
        titleLbl.frame = CGRectMake(UIScreen.main.bounds.width/2 - 100, -50, 200, 240)
        myView.addSubview(titleLbl)
        view.addSubview(myView)
        
        let child_Id = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID) ?? ""
        package_id = CoreDataUtility.fetchPackageIdFor(child_id: Int32(child_Id) ?? 0)
        package_name = CoreDataUtility.fetchPackageNameFor(child_id: Int32(child_Id) ?? 0)
        device = CoreDataUtility.fetchPackageDeviceFor(child_id: Int32(child_Id) ?? 0)
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            
            imgView = UIImageView(frame: CGRect(x: 236, y: 229, width: 296, height: 212))
            imgView.contentMode = .scaleAspectFill
            imgView.image = UIImage(named: "ipad_empty")
            imgView.isHidden = true
            view.addSubview(imgView)
            view.bringSubviewToFront(imgView)
            
            oopsLbl = UILabel(frame: CGRect(x: view.bounds.size.width / 2 - 40, y: imgView.frame.maxY + 10, width: 80, height: 30))
            oopsLbl.text = "oops_title".myModification()
            oopsLbl.font = UIFont.boldSystemFont(ofSize: 20)
            oopsLbl.isHidden = true
            view.addSubview(oopsLbl)
            view.bringSubviewToFront(oopsLbl)
            
            contentLbl = UILabel(frame: CGRect(x: 203, y: oopsLbl.frame.maxY + 10, width: 362, height: 41))
            contentLbl.textColor = UIColor.lightGray
            contentLbl.text = "text_messages_content_1".myModification()
            contentLbl.font = UIFont.systemFont(ofSize: 16)
            contentLbl.lineBreakMode = .byWordWrapping
            contentLbl.numberOfLines = 2
            contentLbl.textAlignment = .center
            contentLbl.isHidden = true
            view.addSubview(contentLbl)
            view.bringSubviewToFront(contentLbl)
            
        } else if UIDevice.current.userInterfaceIdiom == .phone {
            
            imgView = UIImageView(frame: CGRect(x: 115, y: 152, width: 145, height: 104))
            imgView.contentMode = .scaleAspectFill
            imgView.image = UIImage(named: "ic_empty")
            imgView.isHidden = true
            view.addSubview(imgView)
            view.bringSubviewToFront(imgView)
            oopsLbl = UILabel(frame: CGRect(x: view.bounds.size.width / 2 - 20, y: imgView.frame.maxY + 5, width: 70, height: 30))
            oopsLbl.text = "oops_title".myModification()
            oopsLbl.font = UIFont.boldSystemFont(ofSize: 18)
            oopsLbl.isHidden = true
            view.addSubview(oopsLbl)
            view.bringSubviewToFront(oopsLbl)
            contentLbl = UILabel(frame: CGRect(x: 6, y: oopsLbl.frame.maxY + 5, width: 362, height: 45))
            contentLbl.textColor = UIColor.lightGray
            contentLbl.text = "text_messages_content_1".myModification()
            contentLbl.font = UIFont.systemFont(ofSize: 16)
            contentLbl.lineBreakMode = .byWordWrapping
            contentLbl.numberOfLines = 2
            contentLbl.textAlignment = .center
            contentLbl.isHidden = true
            view.addSubview(contentLbl)
            view.bringSubviewToFront(contentLbl)
        }
//        let packageId = self.package_id
//        if (packageId == "3") && (packageId != ""){
            loadMessages()
//        } else {
//            showPremiumAlert()
//        }
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        if ((self.navigationController?.viewControllers.contains(self)) != nil) {
            self.navigationController?.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    @objc func backBtnAction() {
        dismiss(animated: true)
    }
    
    func addPullRefresh() {
        refreshControl = UIRefreshControl()
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(loadMessages), for: .valueChanged)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showPremiumAlert() {
        SwiftFTUtils.showSwiftPremiumPopup(on: self)
    }
    
    @objc func loadMessages(urlString: String = "", emptyPreviosData: Bool = true) {
        //SwiftFTUtils.showHUDAdded(to: view, withText: "Loading...".myModification(), animated: true)
  //      let child_Id = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID) ?? ""
//        var url = String(format: "%@/dashboard/messages/v1/%ld", kBasUrlNew_mesh2, Int(child_Id) ?? 0)
//        if urlString != "" {
//            url = urlString
//        }
//        print(url)
        // ApiManager.shared().mesh_getApi(withApi: url, withResponse: { [self] json, errorCode, message in
        //DispatchQueue.main.async(execute: { [self] in
        //let msg = (json["message"] == nil ? kErrorGeneral.myModification() : json["message"]) as? String
        // read response code
        //                if (json["status"] as? NSNumber)?.intValue ?? 0 == 200 {
        //                    if emptyPreviosData {
        //                        self.dataSource.removeAll()
        //                    }
        
        //                    var threads: TextMessagesResponse? = nil
        //                    do {
        //                        threads = try JSONDecoder().decode(TextMessagesResponse.self,from:json)
        //
        //                    } catch {
        //                        print("Total Job")
        //                    }
        //                    if let threads = json["messages"] as? [String:Any]{
        //                        if let datad = threads["data"] as? [[String:Any]]{
        //                            for dat in datad{
        //                                let obj = MessageThreadData(id: dat["id"] as? Int, child_id: dat["child_id"] as? Int, thread_id: dat["thread_id"] as? Int, contact_name: dat["contact_name"] as? String, snippet: dat["snippet"] as? String, thread_date: dat["thread_date"] as? String)
        //                                dataSource.append(obj)
        //                            }
        //                            //                            do {
        //                            //                                let messages = try decoder.decode([MessageThreadData].self, from: datadat)
        //                            //                                print(messages)
        //                            //                                dataSource = messages
        //                            //                            } catch {
        //                            //                                print(String(describing: error))
        //                            //                            }
        //                        }
        //                    }
        //                    dataSource = Array(dataSource.reversed())
        let inbox = DBManager.shared.getInboxSms()
        
        dataSource = inbox.sorted(by: {$0.sms_time?.getDateFromStr() ?? Date() >= $1.sms_time?.getDateFromStr() ?? Date()})
        if dataSource.count > 0 {
            tableView.isHidden = false
            imgView.isHidden = true
            contentLbl.isHidden = true
            oopsLbl.isHidden = true
            view.backgroundColor = UIColorFromRGB(0xefeff4)
        } else {
            tableView.isHidden = true
            imgView.isHidden = false
            contentLbl.isHidden = false
            oopsLbl.isHidden = false
            view.backgroundColor = UIColor.white
        }
        //                } else {
        //                    CommonModel.showAlert("alert_error".myModification(), msg: msg)
        //                    tableView.isHidden = true
        //                    imgView.isHidden = false
        //                    contentLbl.isHidden = false
        //                    oopsLbl.isHidden = false
        //                }
        //self.refreshControl.endRefreshing()
        self.tableView.reloadData()
        //                MBProgressHUD.hideAllHUDs(for: view, animated: true)
        //                if let threads = json["messages"] as? [String:Any] {
        //                    if let next_page_url = threads["next_page_url"] as? String {
        //                        print(next_page_url)
        //                        self.loadMessages(urlString: next_page_url, emptyPreviosData: false)
        //                    }
        //                }
        //})
        // })
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messages_cell", for: indexPath) as! TextMessagesTableViewCell
        let thread = dataSource[indexPath.row]
        cell.snippetLabel.text = thread.body
        cell.nameLabel.text = thread.contact_name
        let contactImgName = String(format: "call_circ_%i.png", Int(indexPath.row) % 4 + 1)
        let avatarImgName = String(format: "avater%i.png", Int(indexPath.row) % 4 + 1)
        if thread.contact_name?.count ?? 0 > 0 {
            if let firstChar = ((thread.contact_name ?? "") as String).first{
                cell.imageButton.setTitle(String(firstChar), for: .normal)
                cell.imageButton.setBackgroundImage(UIImage(named: contactImgName), for: .normal)
            }
        } else {
            cell.imageButton.setTitle("", for: .normal)
            cell.imageButton.setBackgroundImage(UIImage(named: avatarImgName), for: .normal)
        }
        cell.imageButton.setTitleColor(colorArray[indexPath.row % 4], for: .normal)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: thread.sms_time ?? "")
        let days = daysBetweenDate(date, andDate: Date())
        if days == 0 {
            cell.dateLabel.text = "date_drop_down_1".myModification()
        } else if days == 1 {
            cell.dateLabel.text = "date_drop_down_2".myModification()
        } else {
            let df = DateFormatter()
                df.locale = Locale(identifier: "en_US_POSIX")
            df.dateFormat = "EEE, MMM dd"
            cell.dateLabel.text = df.string(from: date ?? Date())
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //        let vc = TextMessageDetailsViewController()
        //        let thread = dataSource[indexPath.row]
        //        vc.thread_id = "\(thread.thread_id ?? 0)"
        let msgs = DBManager.shared.getMsgsAgainstThread(threadID: dataSource[indexPath.row].thread_id ?? 0)
        let vc = TextMsgsViewController()
        vc.navigationController?.isNavigationBarHidden = true
        //        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(
        //            title: "back_button".localized,
        //            style: .plain,
        //            target: nil,
        //            action: nil)
        //vc.title = thread.contact_name
        vc.msgs = msgs
        vc.modalPresentationStyle = .fullScreen
        vc.titleStr = dataSource[indexPath.row].contact_name ?? ""
        //if isFromSideMenu{
        self.present(vc, animated: true)
        //        } else {
        //            navigationController?.pushViewController(vc, animated: true)
        //        }
    }
    
    func daysBetweenDate(_ fromDateTime: Date?, andDate toDateTime: Date?) -> Int? {
        let calendar = Calendar.current
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: fromDateTime ?? Date())
        let date2 = calendar.startOfDay(for: toDateTime ?? Date())
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        return components.day
    }
}
