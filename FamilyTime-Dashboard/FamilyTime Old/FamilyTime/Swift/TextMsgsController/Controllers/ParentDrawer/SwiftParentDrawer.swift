//
//  SwiftParentDrawer.swift
//  FamilyTime
//
//  Created by YumyApps on 12/10/2021.
//  Copyright © 2021 YumyApps. All rights reserved.
//

import UIKit
import SwiftUI
import IQKeyboardManager
import Combine

class SwiftParentDrawer: BaseViewController, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, GIDSignInUIDelegate {
    
    //MARK: - IBOutlets
    @IBOutlet weak var parentImage: UIImageView?
    @IBOutlet weak var parentName: UILabel?
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var btnNo: UIButton?
    @IBOutlet weak var btnYes: UIButton?
    @IBOutlet var alertSubView: UIView?
    @IBOutlet weak var drawerTopHeaderView: UIView?
    
    //MARK: - Variables
    var delegate = UIApplication.shared.delegate as? AppDelegate
    var contName: String = ""
    var myKidsArray : [String] = []
    var settingArray : [String] = []
    var reportsArray : [ReportItem] = []
    var deviceArray : [String] = []
    var myKidsArrayImage : [String] = []
    var settingArrayImage : [String] = []
    var reportsArrayImage : [String] = []
    var deviceArrayImage : [String] = []
    private var package_id : String = ""
    private var package_name : String = ""
    private var device : String = ""
    
    // MARK: - Live Chat
    private var messages: [ChatMessage] = []
    
    private var messageText: String = ""
    
//    private var conversation: Conversation?
    
    private var isLoadingMore = false
    
    private var hasMoreMessages = true
    
    private var oldestMessageId: Int?
    
    private let liveChatService =
    LiveChatService.shared

    private var conversationResolvedObserver: AnyCancellable?

    private var liveChatMessageListenerId: UUID?

    deinit {
        LiveChatSocketManager.shared.removeMessageListener(
            liveChatMessageListenerId
        )
    }
    
    //MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        observeRealtimeMessages()
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.rowHeight = 55
        tableView?.tableFooterView = UIView(frame: CGRect.zero)
        tableView?.tableHeaderView = UIView(frame: CGRect.zero)
        tableView?.separatorColor = KSetBG(187, 186, 186, 1)
        parentImage?.layer.cornerRadius = (parentImage?.frame.size.width)! / 2
        ReportsApiManager.Shared.callDrawerReports()
        
        conversationResolvedObserver = LiveVisitorManager.shared
            .$isConversationResolved
            .receive(on: DispatchQueue.main)
            .sink { [weak self] resolved in
                
                guard let self else {
                    return
                }
                
                print("""
                    
                    =========================
                    CONVERSATION STATE CHANGED
                    =========================
                    RESOLVED:
                    \(resolved)
                    =========================
                    
                    """)
                
                self.updateLiveChatScreen()
            }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let child_Id = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID) ?? ""
        package_id = CoreDataUtility.fetchPackageIdFor(child_id: Int32(child_Id) ?? 0)
        package_name = CoreDataUtility.fetchPackageNameFor(child_id: Int32(child_Id) ?? 0)
        device = CoreDataUtility.fetchPackageDeviceFor(child_id: Int32(child_Id) ?? 0)
        self.tableView?.register(SwiftParentDrawerTableViewCell.self, forCellReuseIdentifier: "Cell")
        print("Side menu here =")
        super.viewWillAppear(animated)
        self.reloadView()
        NotificationCenter.default.addObserver(self, selector: #selector(showMainMenu(_:)), name: NSNotification.Name("updateDrawer"), object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Objective Functions
    @objc func showMainMenu(_ note: Notification?) {
        //NSLog(@"Received Notification - Someone seems to have logged in");
        self.reloadView()
    }
    @objc func reloadView() {
        reportsArray.removeAll()
        reportsArrayImage.removeAll()
        myKidsArray.removeAll()
        deviceArray.removeAll()
        myKidsArrayImage.removeAll()
        deviceArrayImage.removeAll()
        
        let identifiers = [
            "phone_usage","call_logs", "sms", "contacts", "location_history","apps_list", "browsing_history", "youtube_history", "tiktok_history",   "social_monitoring"
        ]
        let child_Id = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID) ?? ""
        let childID = Int(child_Id)
        let childData = DBManager.shared.fetchChildAndPlans(byChildID: childID ?? 0)
        let child_Info = childData.child
        let filteredPlans = childData.plans.filter { plan in
            guard let identifier = plan.identifier else {
                return false
            }
            return identifiers.contains(identifier)
        }
        
        parentName?.text = UserDefaults.standard.string(forKey: "userName")
        drawerTopHeaderView?.backgroundColor = RGBCOLOR(4.0, 155.0, 236, 1.0) //CommonModel.color(fromHexString: "blue")
        
        if contName == "Reports" {
            
            if let child_Info = child_Info {
                let status = child_Info.agent
                if status == "android" {
                    reportsArray.append(ReportItem(title: NSLocalizedString("summary_title", comment: ""), imageName: "ic_summary", status: 1))
                    //                    reportsArray.append(NSLocalizedString("summary_title", comment: ""))
                    //                    reportsArrayImage.append("ic_summary")
                    for plan in filteredPlans {
                        switch plan.identifier {
                        case "phone_usage":
                            if plan.androidReleased != 0 {
                                reportsArray.append(ReportItem(title: NSLocalizedString("app_usage_title", comment: ""), imageName: "ic_app_usage_1", status: Int(plan.status)))
                                //                                reportsArray.append(NSLocalizedString("app_usage_title", comment: ""))
                                //                                reportsArrayImage.append("ic_app_usage_1")
                            }
                        case "call_logs":
                            if plan.androidReleased != 0 {
                                reportsArray.append(ReportItem(title: NSLocalizedString("Calls", comment: ""), imageName: "call_history_drawer", status: Int(plan.status)))
                                //                                reportsArray.append(NSLocalizedString("Calls", comment: ""))
                                //                                reportsArrayImage.append("call_history_drawer")
                            }
                        case "sms":
                            if plan.androidReleased != 0 {
                                reportsArray.append(ReportItem(title: NSLocalizedString("text_messages_title", comment: ""), imageName: "ic_text_message_drawer", status: Int(plan.status)))
                                //                                reportsArray.append(NSLocalizedString("text_messages_title", comment: ""))
                                //                                reportsArrayImage.append("ic_text_message_drawer")
                            }
                        case "contacts":
                            if plan.androidReleased != 0 {
                                reportsArray.append(ReportItem(title: NSLocalizedString("contacts_title", comment: ""), imageName: "contact_drawer", status: Int(plan.status)))
                                //                                reportsArray.append(NSLocalizedString("contacts_title", comment: ""))
                                //                                reportsArrayImage.append("contact_drawer")
                            }
                        case "location_history":
                            if plan.androidReleased != 0 {
                                reportsArray.append(ReportItem(title: NSLocalizedString("location_history_title", comment: ""), imageName: "ic_location_1", status: Int(plan.status)))
                                //                                reportsArray.append(NSLocalizedString("location_history_title", comment: ""))
                                //                                reportsArrayImage.append("ic_location_1")
                            }
                        case "apps_list":
                            if plan.androidReleased != 0 {
                                reportsArray.append(ReportItem(title: NSLocalizedString("installed_apps_title", comment: ""), imageName: "installed_drawer", status: Int(plan.status)))
                                //                                reportsArray.append(NSLocalizedString("installed_apps_title", comment: ""))
                                //                                reportsArrayImage.append("installed_drawer")
                            }
                        case "browsing_history":
                            if plan.androidReleased != 0 {
                                reportsArray.append(ReportItem(title: NSLocalizedString("settings_card_1_android_7", comment: ""), imageName: "ic_web", status: Int(plan.status)))
                                //                                reportsArray.append(NSLocalizedString("settings_card_1_android_7", comment: ""))
                                //                                reportsArrayImage.append("ic_web")
                            }
                        case "youtube_history":
                            if plan.androidReleased != 0 {
                                reportsArray.append(ReportItem(title: NSLocalizedString("YouTube", comment: ""), imageName: "ic_youtube", status: Int(plan.status)))
                                //                                reportsArray.append(NSLocalizedString("YouTube", comment: ""))
                                //                                reportsArrayImage.append("ic_youtube")
                            }
                        case "tiktok_history":
                            if plan.androidReleased != 0 {
                                reportsArray.append(ReportItem(title: NSLocalizedString("TikTok", comment: ""), imageName: "ic_tiktok", status: Int(plan.status)))
                                //                                reportsArray.append(NSLocalizedString("TikTok", comment: ""))
                                //                                reportsArrayImage.append("ic_tiktok")
                            }
                        case "social_monitoring":
                            if plan.androidReleased != 0 {
                                reportsArray.append(ReportItem(title: NSLocalizedString("Whatsapp", comment: ""), imageName: "whatsB", status: Int(plan.status)))
                                reportsArray.append(ReportItem(title: NSLocalizedString("Instagram", comment: ""), imageName: "instagramB", status: Int(plan.status)))
                                reportsArray.append(ReportItem(title: NSLocalizedString("Whatsapp Business", comment: ""), imageName: "bwhatsB", status: Int(plan.status)))
                                reportsArray.append(ReportItem(title: NSLocalizedString("Bip", comment: ""), imageName: "bipBlack", status: Int(plan.status)))
                                reportsArray.append(ReportItem(title: NSLocalizedString("Tiktok Chat", comment: ""), imageName: "ic_tiktok", status: Int(plan.status)))
                                reportsArray.append(ReportItem(title: NSLocalizedString("Signal", comment: ""), imageName: "signalB", status: Int(plan.status)))
                                reportsArray.append(ReportItem(title: NSLocalizedString("Imo", comment: ""), imageName: "imoBlack", status: Int(plan.status)))
                                reportsArray.append(ReportItem(title: NSLocalizedString("Twitch", comment: ""), imageName: "twitchB", status: Int(plan.status)))
                                //                                reportsArray.append(NSLocalizedString("Whatsapp", comment: ""))
                                //                                reportsArrayImage.append("whatsB")
                                //                                reportsArray.append(NSLocalizedString("Instagram", comment: ""))
                                //                                reportsArrayImage.append("instagramB")
                                //                                reportsArray.append(NSLocalizedString("Whatsapp Business", comment: ""))
                                //                                reportsArrayImage.append("bwhatsB")
                                //                                reportsArray.append(NSLocalizedString("Bip", comment: ""))
                                //                                reportsArrayImage.append("bipBlack")
                                //                                reportsArray.append(NSLocalizedString("Tiktok Chat", comment: ""))
                                //                                reportsArrayImage.append("ic_tiktok")
                                //                                reportsArray.append(NSLocalizedString("Signal", comment: ""))
                                //                                reportsArrayImage.append("signalB")
                                //                                reportsArray.append(NSLocalizedString("Imo", comment: ""))
                                //                                reportsArrayImage.append("imoBlack")
                                //                                reportsArray.append(NSLocalizedString("Twitch", comment: ""))
                                //                                reportsArrayImage.append("twitchB")
                            }
                            
                        default:
                            break
                        }
                        if plan.identifier == "family_locator" && (plan.iosReleased == 1 || plan.androidReleased == 1){
                            myKidsArray = [NSLocalizedString("dashboard_drawer_option_1", comment: ""), NSLocalizedString("family_locator_title", comment: "")]
                            myKidsArrayImage = ["ic_dashboard_drawer", "ic_family_map"]
                        }else{
                            myKidsArray = [NSLocalizedString("dashboard_drawer_option_1", comment: "")]
                            myKidsArrayImage = ["ic_dashboard_drawer"]
                        }
                        //                        myKidsArray = [NSLocalizedString("dashboard_drawer_option_1", comment: ""), NSLocalizedString("family_locator_title", comment: "")]
                        deviceArray = [NSLocalizedString("settings_title", comment: ""), NSLocalizedString("device_info_title", comment: ""), NSLocalizedString("dashboard_drawer_option_6", comment: "")]
                        //                        myKidsArrayImage = ["ic_dashboard_drawer", "ic_family_map"]
                        //"ic_app_usage_1",
                        deviceArrayImage = ["settings_drawer", "profile_drawer", "ic_logout"]
                    }
                    
                } else {
                    for plan in filteredPlans {
                        switch plan.identifier {
                        case "contacts":
                            if plan.iosReleased != 0 {
                                reportsArray.append(ReportItem(title: NSLocalizedString("contacts_title", comment: ""), imageName: "contact_drawer", status: Int(plan.status)))
                                //                                reportsArray.append(NSLocalizedString("contacts_title", comment: ""))
                                //                                reportsArrayImage.append("contact_drawer")
                            }
                        case "location_history":
                            if plan.iosReleased != 0 {
                                reportsArray.append(ReportItem(title: NSLocalizedString("location_history_title", comment: ""), imageName: "ic_location_1", status: Int(plan.status)))
                                //                                reportsArray.append(NSLocalizedString("location_history_title", comment: ""))
                                //                                reportsArrayImage.append("ic_location_1")
                            }
                        case "apps_list":
                            if plan.iosReleased != 0 {
                                reportsArray.append(ReportItem(title: NSLocalizedString("installed_apps_title", comment: ""), imageName: "installed_drawer", status: Int(plan.status)))
                                //                                reportsArray.append(NSLocalizedString("installed_apps_title", comment: ""))
                                //                                reportsArrayImage.append("installed_drawer")
                            }
                        case "family_locator":
                            if plan.iosReleased == 1 || plan.androidReleased == 1{
                                myKidsArray.append(NSLocalizedString("dashboard_drawer_option_1", comment: ""))
                                myKidsArray.append(NSLocalizedString("family_locator_title", comment: ""))
                                myKidsArrayImage.append("ic_dashboard_drawer")
                                myKidsArrayImage.append("ic_family_map")
                            }else if plan.iosReleased == 0 && plan.androidReleased == 0{
                                myKidsArray.append(NSLocalizedString("dashboard_drawer_option_1", comment: ""))
                                myKidsArrayImage.append("ic_dashboard_drawer")
                            }
                            
                        default:
                            break
                        }
                        if plan.identifier == "family_locator" && (plan.iosReleased == 1 || plan.androidReleased == 1){
                            myKidsArray = [NSLocalizedString("dashboard_drawer_option_1", comment: ""), NSLocalizedString("family_locator_title", comment: "")]
                            myKidsArrayImage = ["ic_dashboard_drawer", "ic_family_map"]
                        }else{
                            myKidsArray = [NSLocalizedString("dashboard_drawer_option_1", comment: "")]
                            myKidsArrayImage = ["ic_dashboard_drawer"]
                        }
                        
                        deviceArray = [NSLocalizedString("settings_title", comment: ""), NSLocalizedString("device_info_title", comment: ""), NSLocalizedString("dashboard_drawer_option_6", comment: "")]
                        
                        deviceArrayImage = ["settings_drawer", "profile_drawer", "ic_logout"]
                    }
                    
                }
                
                
                
                parentName?.text = child_Info.name
                drawerTopHeaderView?.backgroundColor = CommonModel.color(fromHexString: child_Info.color)
                if child_Info.gender?.lowercased() == "male" {
                    parentImage?.image = UIImage(named: "avatar_boy1")
                } else {
                    parentImage?.image = UIImage(named: "avatar_girl1")
                }
            } else {
                print("Child not found")
            }
        } else {
            var gender: String?
            var userGender = UserDefaults.standard.string(forKey: "userGender")
            if UserDefaults.standard.object(forKey: "userRelation") == nil {
                gender = userGender
            } else {
                gender = UserDefaults.standard.object(forKey: "userRelation") as? String
            }
            print("Relation==\(gender ?? "")")
            if gender == NSLocalizedString("Mother", comment: "") || gender == NSLocalizedString("mother", comment: "") {
                parentImage?.image = UIImage(named: "parent_profile_f")
            } else {
                //       self.parentImage.image = [UIImage imageNamed:@"in_parent_m"];
                parentImage?.image = UIImage(named: "parent_profile_m")
            }
            let type = UserDefaults.standard.string(forKey: "userType")
            myKidsArray = [NSLocalizedString("dashboard_drawer_option_1", comment: ""), NSLocalizedString("dashboard_drawer_option_2", comment: "")]
            if type == "Sub" {
                settingArray = [NSLocalizedString("dashboard_drawer_option_4", comment: ""), NSLocalizedString("dashboard_drawer_option_5", comment: "")]
                settingArrayImage = ["settings_drawer", "chatIcon"]
            } else {
                settingArray = [NSLocalizedString("dashboard_drawer_option_3", comment: ""), NSLocalizedString("dashboard_drawer_option_4", comment: ""), NSLocalizedString("dashboard_drawer_option_5", comment: ""),NSLocalizedString("data_collection_and_use", comment: "")]
                settingArrayImage = ["parents_settings", "settings_drawer", "chatIcon", "ic_data_collection"]
            }
            
            deviceArray = [NSLocalizedString("dashboard_drawer_option_6", comment: "")]
            myKidsArrayImage = ["ic_dashboard_drawer", "v2_ic_notifications"]
            deviceArrayImage = ["ic_logout"]
        }
        
        self.tableView?.reloadData()
    }
    
    
    //        @objc func reloadView() {
    //            let identifiers = [
    //                 "call_logs","sms","contacts","location_history","browsing_history","youtube_history","tiktok_history","apps_list","phone_usage","social_monitoring",
    //             ]
    //            let child_Id = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID) ?? ""
    //            let childID = Int(child_Id)
    //            let childData = DBManager.shared.fetchChildAndPlans(byChildID: childID ?? 0)
    //            let child_Info = childData.child
    //            let filteredPlans = childData.plans.filter { plan in
    //                guard let identifier = plan.identifier else {
    //                    return false
    //                }
    //                return identifiers.contains(identifier)
    //            }
    //
    //
    //
    //            //       parentName?.text = delegate?.parent.name ?? ""
    //            parentName?.text = UserDefaults.standard.string(forKey: "userName")
    //            drawerTopHeaderView?.backgroundColor = RGBCOLOR(4.0, 155.0, 236, 1.0) //CommonModel.color(fromHexString: "blue")
    //            print(contName)
    //            if contName == "Reports" {
    //                let status = child_Info?.agent
    //                if status == "android" {
    //                    myKidsArray = [NSLocalizedString("dashboard_drawer_option_1", comment: ""), NSLocalizedString("family_locator_title", comment: "")]
    //                    //NSLocalizedString("Summary", comment: ""),
    //                    reportsArray = [NSLocalizedString("summary_title", comment: ""),
    //                                    NSLocalizedString("app_usage_title", comment: ""),
    //                                    NSLocalizedString("Calls", comment: ""),
    //                                    NSLocalizedString("text_messages_title", comment: ""),
    //                                    NSLocalizedString("contacts_title", comment: ""),
    //                                    NSLocalizedString("location_history_title", comment: ""),
    //                                    NSLocalizedString("installed_apps_title", comment: ""),
    //                                    NSLocalizedString("settings_card_1_android_7".localized,comment: ""),
    //                                    NSLocalizedString("YouTube", comment: ""),
    //                                    NSLocalizedString("TikTok", comment: ""),
    //                                    NSLocalizedString("Whatsapp", comment: ""),
    //                                    NSLocalizedString("Instagram", comment: ""),
    //                                    NSLocalizedString("Whatsapp Business", comment: ""),
    //                                    NSLocalizedString("Bip", comment: ""),
    //                                    NSLocalizedString("Tiktok Chat", comment: ""),
    //                                    NSLocalizedString("Signal", comment: ""),
    //                                    NSLocalizedString("Imo", comment: ""),
    //                                    NSLocalizedString("Twitch", comment: "")]
    //
    //                    deviceArray = [NSLocalizedString("settings_title", comment: ""), NSLocalizedString("device_info_title", comment: ""), NSLocalizedString("dashboard_drawer_option_6", comment: "")]
    //                    myKidsArrayImage = ["ic_dashboard_drawer", "ic_family_map"]
    //                    //"ic_app_usage_1",
    //                    reportsArrayImage = ["ic_summary", "ic_app_usage_1", "call_history_drawer", "ic_text_message_drawer", "contact_drawer", "ic_location_1", "ic_places_settings", "installed_drawer", "ic_web", "ic_youtube", "ic_tiktok", "whatsB", "instagramB" , "bwhatsB", "bipBlack","ic_tiktok", "signalB", "imoBlack", "twitchB"]
    //                    deviceArrayImage = ["settings_drawer", "profile_drawer", "ic_logout"]
    //                } else {
    //                    myKidsArray = [NSLocalizedString("dashboard_drawer_option_1", comment: ""), NSLocalizedString("family_locator_title", comment: "")]
    //                    reportsArray = [NSLocalizedString("location_history_title", comment: ""), NSLocalizedString("contacts_title", comment: ""), NSLocalizedString("installed_apps_title", comment: "")]
    //                    deviceArray = [NSLocalizedString("settings_title", comment: ""), NSLocalizedString("device_info_title", comment: ""), NSLocalizedString("dashboard_drawer_option_6", comment: "")]
    //                    myKidsArrayImage = ["ic_dashboard_drawer", "ic_family_map"]
    //                    reportsArrayImage = ["ic_location_1", "ic_places_settings", "contact_drawer", "installed_drawer"]
    //                    deviceArrayImage = ["settings_drawer", "profile_drawer", "ic_logout"]
    //                }
    //                parentName?.text = child_Info?.name
    //                drawerTopHeaderView?.backgroundColor = CommonModel.color(fromHexString: child_Info?.color)
    //                if child_Info?.gender?.lowercased() == "male" {
    //                    parentImage?.image = UIImage(named: "avatar_boy1")
    //                } else {
    //                    parentImage?.image = UIImage(named: "avatar_girl1")
    //                }
    //            } else {
    //                var gender: String?
    //                var userGender = UserDefaults.standard.string(forKey: "userGender")
    //                if UserDefaults.standard.object(forKey: "userRelation") == nil {
    //                    gender = userGender
    //                } else {
    //                    gender = UserDefaults.standard.object(forKey: "userRelation") as? String
    //                }
    //                print("Relation==\(gender ?? "")")
    //                if gender == NSLocalizedString("Mother", comment: "") || gender == NSLocalizedString("mother", comment: "") {
    //                    parentImage?.image = UIImage(named: "parent_profile_f")
    //                } else {
    //                    //       self.parentImage.image = [UIImage imageNamed:@"in_parent_m"];
    //                    parentImage?.image = UIImage(named: "parent_profile_m")
    //                }
    //                let type = UserDefaults.standard.string(forKey: "userType")
    //                myKidsArray = [NSLocalizedString("dashboard_drawer_option_1", comment: ""), NSLocalizedString("dashboard_drawer_option_2", comment: "")]
    //                if type == "Sub" {
    //                    settingArray = [NSLocalizedString("dashboard_drawer_option_4", comment: ""), NSLocalizedString("dashboard_drawer_option_5", comment: "")]
    //                    settingArrayImage = ["settings_drawer", "ic_help_dashboard"]
    //                } else {
    //                    settingArray = [NSLocalizedString("dashboard_drawer_option_3", comment: ""), NSLocalizedString("dashboard_drawer_option_4", comment: ""), NSLocalizedString("dashboard_drawer_option_5", comment: ""),NSLocalizedString("data_collection_and_use", comment: "")]
    //                    settingArrayImage = ["parents_settings", "settings_drawer", "ic_help_dashboard", "ic_data_collection"]
    //                }
    //
    //                deviceArray = [NSLocalizedString("dashboard_drawer_option_6", comment: "")]
    //                myKidsArrayImage = ["ic_dashboard_drawer", "v2_ic_notifications"]
    //                deviceArrayImage = ["ic_logout"]
    //            }
    //            self.tableView?.reloadData()
    //        }
    
    //MARK: - IBActions
    @IBAction func btnPressedNo(_ sender: UIButton) {
        btnNo?.setTitleColor(UIColor(red: 29 / 255.0, green: 146 / 255.0, blue: 208 / 255.0, alpha: 1.0), for: .selected)
        alertSubView?.isHidden = true
    }
    
    @IBAction func btnPressedYes(_ sender: UIButton) {
        delegate?.userDefault.set(nil, forKey: "user")
        AppDelegate().setNavigationbarAppearence(true, cont: self)
        delegate?.setupDrawer(2)
        sender.removeFromSuperview()
        self.alertSubView?.removeFromSuperview()
        btnYes?.setTitleColor(UIColor(red: 29 / 255.0, green: 146 / 255.0, blue: 208 / 255.0, alpha: 1.0), for: .selected)
    }
    
    //MARK: - TableView Data Source tableView Delegate
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 70))
            let lineView = UIView()
            lineView.frame = CGRect.init(x: 0, y: 0, width: headerView.frame.width, height: 1)
            lineView.backgroundColor = .lightGray
            headerView.addSubview(lineView)
            let label = UILabel()
            label.frame = CGRect.init(x: 10, y: 15, width: headerView.frame.width-20, height: headerView.frame.height-20)
            if contName == "Settings" {
                label.text = "dashboard_drawer_title_1".localized
                label.font = UIFont(name: "SFProDisplay-Regular", size: 16)!
            } else if contName == "Reports"{
                label.text = "dashboard_drawer_title_2".localized
                label.font = UIFont(name: "SFProDisplay-Regular", size: 16)!
            } else {
                label.text = "dashboard_drawer_title_1".localized
                label.font = UIFont(name: "SFProDisplay-Regular", size: 16)!
            }
            label.textColor = .gray
            headerView.addSubview(label)
            return headerView
        } else if section == 2 {
            if delegate?.isChildSelected == 0 {
                let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 20))
                let lineView = UIView()
                lineView.frame = CGRect.init(x: 0, y: 5, width: headerView.frame.width, height: 1)
                lineView.backgroundColor = .gray
                headerView.addSubview(lineView)
                return headerView
            } else {
                let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 70))
                let lineView = UIView()
                lineView.frame = CGRect.init(x: 0, y: 0, width: headerView.frame.width, height: 1)
                lineView.backgroundColor = .lightGray
                headerView.addSubview(lineView)
                let label = UILabel()
                label.frame = CGRect.init(x: 10, y: 15, width: headerView.frame.width-20, height: headerView.frame.height-20)
                label.text = "dashboard_drawer_title_3".localized
                label.font = UIFont(name: "SFProDisplay-Regular", size: 16)!
                label.textColor = .gray
                headerView.addSubview(label)
                return headerView
            }
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 70
        } else if section == 2 {
            if delegate?.isChildSelected == 0 {
                return 20
            } else {
                return 70
            }
        }
        return 0.0001
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return myKidsArray.count
        } else if section == 1 {
            if contName != "Reports" {
                return settingArray.count
            } else {
                return reportsArray.count
            }
        } else {
            return deviceArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwiftParentDrawerTableViewCell
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        cell.drawerLabel.textColor = RGBCOLOR(33, 33, 33, 1)
        if indexPath.section == 0 {
            cell.drawerLabel.font = UIFont(name: "SFProDisplay-Regular", size: 16)!
            cell.drawerLabel.text = self.myKidsArray[indexPath.row]
            cell.drawerImage.image = UIImage(named: myKidsArrayImage[indexPath.row])
            if delegate?.isChildSelected == 1 {
                cell.drawerLabel.font = UIFont(name: "SFProDisplay-Regular", size: 16)!
            }
            cell.labelImageView.isHidden = true
        } else if indexPath.section == 1 {
            if contName != "Reports" {//Parent Dashboard
                cell.drawerLabel.font = UIFont(name: "SFProDisplay-Regular", size: 16)!
                cell.drawerLabel.text = self.settingArray[indexPath.row]
                cell.drawerImage.image = UIImage(named: settingArrayImage[indexPath.row])
                cell.labelImageView.isHidden = true
            } else {//Child Dashboard
                
                cell.drawerLabel.font = UIFont(name: "SFProDisplay-Regular", size: 16)!
                let reportItem = reportsArray[indexPath.row]
                cell.drawerLabel.text = reportItem.title
                //                if indexPath.row < reportsArrayImage.count {
                let imageName = reportItem.imageName
                let image = UIImage(named: imageName)
                cell.drawerImage.image = image
                cell.labelImageView.image = UIImage(named: "top")
                cell.labelImageView.isHidden = reportItem.status != 0
                //                } else {
                //                    print("Index out of range in reportsArrayImage: \(indexPath.row)")
                //                }
                //                let labelImageView = AddImage.addImageView(to: cell.drawerLabel, imageName: "top")
                print(cell.labelImageView.image ?? "")
                //                labelImageView.isHidden = false
                
                print("reportItem.status: \(reportItem.status), labelImageView.isHidden: \(cell.labelImageView.isHidden)")
                
            }
        } else if indexPath.section == 2 {
            cell.drawerLabel.font = UIFont(name: "SFProDisplay-Regular", size: 16)!
            cell.drawerLabel.text = self.deviceArray[indexPath.row]
            cell.drawerImage.image = UIImage(named: deviceArrayImage[indexPath.row])
            if delegate?.isChildSelected == 1 {
                cell.drawerLabel.font = UIFont(name: "SFProDisplay-Regular", size: 16)!
            }
            cell.labelImageView.isHidden = true
        }
        cell.drawerLabel.adjustsFontSizeToFitWidth = false
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let child_iid = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        let childID = Int(child_iid ?? "")
        let child_Info = DBManager.shared.fetchChild(byID: childID ?? 0)
        let packageId = self.package_id
        if indexPath.section == 0 {
            let label = self.myKidsArray[indexPath.row]
            print(label)
            if label == NSLocalizedString("dashboard_drawer_option_1", comment: "") {
                contName = "Drawer"
                delegate?.isChildSelected = 0
                reloadView()
                delegate?.setupDrawer(0)
                UserDefaults.standard.removeObject(forKey: UserDefaultsConstants.DRAWER_TYPE)
                UserDefaults.standard.synchronize()
                if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
                    delegate?.jasidePanel.toggleRightPanel(nil)
                } else {
                    delegate?.jasidePanel.toggleLeftPanel(nil)
                }
            } else if label == NSLocalizedString("dashboard_drawer_option_2", comment: "") {
                //MARK: RIZWAN CHANGE NEW SCREEN
                let sb = UIStoryboard(name: "Dashboard", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "NotificationViewController") as? NotificationViewController
                if let vc = vc {
                    self.delegate?.centerNavController = UINavigationController(rootViewController: vc)
                }
                self.delegate?.jasidePanel.centerPanel = self.delegate?.centerNavController
            } else if label == NSLocalizedString("family_locator_title", comment: "") {
                let billingStatus = UserDefaults.standard.string(forKey: UserDefaultsConstants.BILLING_STATUS)
                print(billingStatus)
                if billingStatus == "FREE" || billingStatus == "free" && UserDefaults.standard.bool(forKey: "familymapEnable") == true{
                    
                    let sb = UIStoryboard(name: "Dashboard", bundle: nil)
                    let vc = sb.instantiateViewController(withIdentifier: StoryboardConstants.Identifiers.PREMIUM_PACKAGE_VC_IDENTIFIER) as? PremiumPackageVC
                    vc?.isCommingFromDrwa = true
                    let transition = CATransition()
                    transition.duration = 0.6
                    transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                    transition.type = CATransitionType.moveIn
                    transition.subtype = CATransitionSubtype.fromTop
                    self.navigationController?.view.layer.add(transition, forKey: nil)
                    self.navigationController?.popViewController(animated: true)
                    if let vc = vc {
                        delegate?.centerNavController = UINavigationController(rootViewController: vc)
                    }
                    
                }else if billingStatus != "FREE" || billingStatus != "FREE" && UserDefaults.standard.bool(forKey: "familymapEnable") == true {
                    let childId = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID) ?? ""
                    let childID = Int(childId)
                    let child_Info = DBManager.shared.fetchChild(byID: childID ?? 0)
                    let vc = SwiftFamilyMapViewController(nibName: "FamilyMapViewController", bundle: nil)
                    let drawerType = UserDefaults.standard.string(forKey: UserDefaultsConstants.DRAWER_TYPE)
                    if drawerType == "Reports"{
                        vc.isComingFromSideMenu = true
                    }
                    let sb = UIStoryboard(name: "Dashboard", bundle: nil)
                    let status = child_Info?.agent
                    if status == "android" {
                        if UI_USER_INTERFACE_IDIOM() == .pad {
                            let vc = LocationHistoryViewController(nibName: "LocHistoryViewController", bundle: nil)
                            vc.ishiddenBar = true
                            delegate?.centerNavController = UINavigationController(rootViewController: vc)
                            
                        } else {
                            let vc = LocationHistoryViewController(nibName: "LocHistoryViewController~ipad", bundle: nil)
                            vc.ishiddenBar = true
                            delegate?.centerNavController = UINavigationController(rootViewController: vc)
                        }
                        
                    }else {
                        let vcs = sb.instantiateViewController(withIdentifier: "SummaryViewController") as! SummaryViewController
                        delegate?.centerNavController = UINavigationController(rootViewController: vcs)
                    }
                    vc.modalPresentationStyle = .fullScreen
                    present(vc, animated: false)
                    delegate?.jasidePanel.centerPanel = delegate?.centerNavController
                    if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
                        delegate?.jasidePanel.toggleRightPanel(nil)
                    } else {
                        delegate?.jasidePanel.toggleLeftPanel(nil)
                    }
                } else {
                    SwiftFTUtils.showActivateForfamilyMap(self)
                }
            }
        } else if indexPath.section == 1 {
            let drawerType = UserDefaults.standard.string(forKey: UserDefaultsConstants.DRAWER_TYPE) ?? "Settings"
            if drawerType == "Settings"{
                let label = settingArray[indexPath.row]
                if label == NSLocalizedString("dashboard_drawer_option_3", comment: "") {
                    let storyboardName = "MyStoryboard"
                    let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
                    let vc = storyboard.instantiateViewController(withIdentifier: "SwiftParentsAllViewController")
                    delegate?.centerNavController = UINavigationController(rootViewController: vc)
                    delegate?.jasidePanel.centerPanel = delegate?.centerNavController
                } else if label == NSLocalizedString("dashboard_drawer_option_4", comment: "") {
                    let storyboardName = "MyStoryboard"
                    let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
                    let vc = storyboard.instantiateViewController(withIdentifier: "SwiftParentProfileViewController")
                    delegate?.centerNavController = UINavigationController(rootViewController: vc)
                    delegate?.jasidePanel.centerPanel = delegate?.centerNavController
                } else if label == NSLocalizedString("dashboard_drawer_option_5", comment: "") {
                    openLiveChat()
                    LiveVisitorManager.shared.updateScreen(
                        "Support Chat"
                    )
                } else if label == NSLocalizedString("data_collection_and_use", comment: "") {
                    let storyboardName = "Dashboard"
                    let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
                    let vc = storyboard.instantiateViewController(withIdentifier: "DataUseVC") as! DataUseVC
                    vc.isAgreeHidden = true
                    delegate?.centerNavController = UINavigationController(rootViewController: vc)
                    delegate?.jasidePanel.centerPanel = delegate?.centerNavController
                }
            } else {
                let reportItem = reportsArray[indexPath.row]
                let status = reportItem.status
                let title = reportItem.title
                
                if status == 0 {
                    // Show premium popup here
                    let premiumVC = UIStoryboard(name: "Dashboard", bundle: nil).instantiateViewController(withIdentifier: StoryboardConstants.Identifiers.PREMIUM_PACKAGE_VC_IDENTIFIER) as? PremiumPackageVC
                    premiumVC?.isCommingFromDrwa = true
                    let transition = CATransition()
                    transition.duration = 0.6
                    transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                    transition.type = CATransitionType.moveIn
                    transition.subtype = CATransitionSubtype.fromTop
                    self.navigationController?.view.layer.add(transition, forKey: nil)
                    self.navigationController?.popViewController(animated: true)
                    if let vc = premiumVC {
                        delegate?.centerNavController = UINavigationController(rootViewController: vc)
                    }
                } else {
                    // Navigate based on the title
                    let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
                    let vcs = storyboard.instantiateViewController(withIdentifier: "SummaryViewController") as! SummaryViewController
                    self.delegate?.centerNavController = UINavigationController(rootViewController: vcs)
                    
                    switch title {
                    case NSLocalizedString("summary_title", comment: ""):
                        let vc = storyboard.instantiateViewController(withIdentifier: "SummaryViewController") as? SummaryViewController
                        if let vc = vc {
                            delegate?.centerNavController = UINavigationController(rootViewController: vc)
                        }
                    case NSLocalizedString("app_usage_title", comment: ""):
                        let vc = storyboard.instantiateViewController(withIdentifier: "AppUsageVC") as? AppUsageVC
                        if let vc = vc {
                            vc.modalPresentationStyle = .fullScreen
                            present(vc, animated: false)
                        }
                    case NSLocalizedString("Calls", comment: ""):
                        let vc = storyboard.instantiateViewController(withIdentifier: "CallHistoryViewController") as? CallHistoryViewController ?? CallHistoryViewController()
                        vc.modalPresentationStyle = .fullScreen
                        present(vc, animated: true)
                    case NSLocalizedString("text_messages_title", comment: ""):
                        if packageId == "3" {
                            let vc = TextMessagesMainViewController()
                            vc.isFromSideMenu = true
                            vc.modalPresentationStyle = .fullScreen
                            present(vc, animated: false)
                        } else {
                            let vc = storyboard.instantiateViewController(withIdentifier: StoryboardConstants.Identifiers.PREMIUM_PACKAGE_VC_IDENTIFIER) as? PremiumPackageVC
                            vc?.isCommingFromDrwa = true
                            if let vc = vc {
                                delegate?.centerNavController = UINavigationController(rootViewController: vc)
                            }
                        }
                    case NSLocalizedString("contacts_title", comment: ""):
                        if packageId == "1" {
                            let vc = storyboard.instantiateViewController(withIdentifier: StoryboardConstants.Identifiers.PREMIUM_PACKAGE_VC_IDENTIFIER) as? PremiumPackageVC
                            vc?.isCommingFromDrwa = true
                            let transition = CATransition()
                            transition.duration = 0.6
                            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                            transition.type = CATransitionType.moveIn
                            transition.subtype = CATransitionSubtype.fromTop
                            self.navigationController?.view.layer.add(transition, forKey: nil)
                            self.navigationController?.popViewController(animated: true)
                            if let vc = vc {
                                delegate?.centerNavController = UINavigationController(rootViewController: vc)
                            }
                        } else {
                            let vc = ContactsViewController(nibName: "ContactViewController", bundle: nil)
                            vc.ishiddenBar = true
                            vc.modalPresentationStyle = .fullScreen
                            present(vc, animated: false)
                        }
                    case NSLocalizedString("location_history_title", comment: ""):
                        if packageId == "1" {
                            let vc = storyboard.instantiateViewController(withIdentifier: StoryboardConstants.Identifiers.PREMIUM_PACKAGE_VC_IDENTIFIER) as? PremiumPackageVC
                            vc?.isCommingFromDrwa = true
                            let transition = CATransition()
                            transition.duration = 0.6
                            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                            transition.type = CATransitionType.moveIn
                            transition.subtype = CATransitionSubtype.fromTop
                            self.navigationController?.view.layer.add(transition, forKey: nil)
                            self.navigationController?.popViewController(animated: true)
                            if let vc = vc {
                                delegate?.centerNavController = UINavigationController(rootViewController: vc)
                            }
                        } else {
                            if UI_USER_INTERFACE_IDIOM() == .pad {
                                let vc = LocationHistoryViewController(nibName: "LocHistoryViewController~ipad", bundle: nil)
                                vc.ishiddenBar = true
                                delegate?.centerNavController = UINavigationController(rootViewController: vc)
                            } else {
                                let vc = LocationHistoryViewController(nibName: "LocHistoryViewController", bundle: nil)
                                vc.ishiddenBar = true
                                delegate?.centerNavController = UINavigationController(rootViewController: vc)
                            }
                        }
                    case NSLocalizedString("places_history_title", comment: ""):
                        if packageId == "1" {
                            let vc = storyboard.instantiateViewController(withIdentifier: StoryboardConstants.Identifiers.PREMIUM_PACKAGE_VC_IDENTIFIER) as? PremiumPackageVC
                            vc?.isCommingFromDrwa = true
                            let transition = CATransition()
                            transition.duration = 0.6
                            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                            transition.type = CATransitionType.moveIn
                            transition.subtype = CATransitionSubtype.fromTop
                            self.navigationController?.view.layer.add(transition, forKey: nil)
                            self.navigationController?.popViewController(animated: true)
                            if let vc = vc {
                                delegate?.centerNavController = UINavigationController(rootViewController: vc)
                            }
                        } else {
                            if UI_USER_INTERFACE_IDIOM() == .pad {
                                let vc = PlacesHistoryViewController(nibName: "PlacesReportViewController~ipad", bundle: nil)
                                vc.modalPresentationStyle = .fullScreen
                                present(vc, animated: false)
                            } else {
                                let vc = PlacesHistoryViewController(nibName: "PlacesReportViewController", bundle: nil)
                                vc.modalPresentationStyle = .fullScreen
                                present(vc, animated: false)
                            }
                        }
                    case NSLocalizedString("installed_apps_title", comment: ""):
                        let vc = SwiftInstalledAppsViewController(nibName: "AllInstalledAppsViewController", bundle: nil)
                        vc.modalPresentationStyle = .fullScreen
                        present(vc, animated: false)
                    case NSLocalizedString("settings_card_1_android_7", comment: ""):
                        let vc = YoutubeHistroyVC()
                        vc.vm.isFrom = .web
                        vc.modalPresentationStyle = .fullScreen
                        present(vc, animated: false, completion: nil)
                    case NSLocalizedString("YouTube", comment: ""):
                        let vc = YoutubeHistroyVC()
                        vc.vm.isFrom = .youtube
                        vc.modalPresentationStyle = .fullScreen
                        present(vc, animated: false, completion: nil)
                    case NSLocalizedString("TikTok", comment: ""):
                        let vc = YoutubeHistroyVC()
                        vc.vm.isFrom = .tiktok
                        vc.modalPresentationStyle = .fullScreen
                        present(vc, animated: false, completion: nil)
                    case NSLocalizedString("Whatsapp", comment: ""):
                        let vc = WhatsappHistoryVC()
                        vc.vm.isFrom = .whatsapp
                        vc.modalPresentationStyle = .fullScreen
                        present(vc, animated: false, completion: nil)
                    case NSLocalizedString("Whatsapp Business", comment: ""):
                        let vc = WhatsappHistoryVC()
                        vc.vm.isFrom = .bwhatsapp
                        vc.modalPresentationStyle = .fullScreen
                        present(vc, animated: false, completion: nil)
                    case NSLocalizedString("Bip", comment: ""):
                        let vc = WhatsappHistoryVC()
                        vc.vm.isFrom = .bip
                        vc.modalPresentationStyle = .fullScreen
                        present(vc, animated: false, completion: nil)
                    case NSLocalizedString("Instagram", comment: ""):
                        let vc = WhatsappHistoryVC()
                        vc.vm.isFrom = .instagram
                        vc.modalPresentationStyle = .fullScreen
                        present(vc, animated: false, completion: nil)
                    case NSLocalizedString("Twitch", comment: ""):
                        let vc = WhatsappHistoryVC()
                        vc.vm.isFrom = .twitch
                        vc.modalPresentationStyle = .fullScreen
                        present(vc, animated: false, completion: nil)
                    case NSLocalizedString("Imo", comment: ""):
                        let vc = WhatsappHistoryVC()
                        vc.vm.isFrom = .imo
                        vc.modalPresentationStyle = .fullScreen
                        present(vc, animated: false, completion: nil)
                    case NSLocalizedString("Signal", comment: ""):
                        let vc = WhatsappHistoryVC()
                        vc.vm.isFrom = .signal
                        vc.modalPresentationStyle = .fullScreen
                        present(vc, animated: false, completion: nil)
                    case NSLocalizedString("Tiktok Chat", comment: ""):
                        let vc = WhatsappHistoryVC()
                        vc.vm.isFrom = .tiktok
                        vc.modalPresentationStyle = .fullScreen
                        present(vc, animated: false, completion: nil)
                    default:
                        break
                    }
                }
                
            }
        } else if indexPath.section == 2 {
            let label = deviceArray[indexPath.row]
            if label == NSLocalizedString("settings_title", comment: "") {
                let status = child_Info?.agent
                if status == "android" {
                    let nibVc = ControlViewController(nibName: "ControlViewController", bundle: nil)
                    nibVc.title = child_Info?.name
                    delegate?.centerNavController = UINavigationController(rootViewController: nibVc)
                } else {
                    let vc = SettingIOSViewController(nibName: "LeftSidePaneliOS", bundle: nil)
                    delegate?.centerNavController = UINavigationController(rootViewController: vc)
                }
                
            } else if label == NSLocalizedString("device_info_title", comment: "") {
                let sb = UIStoryboard(name: "Dashboard", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "DeviceVC") as? DeviceVC
                vc?.flagToHideNavBar = false
                if let vc = vc {
                    delegate?.centerNavController = UINavigationController(rootViewController: vc)
                }
            } else if label == NSLocalizedString("dashboard_drawer_option_6", comment: "") {
                let alert = UIAlertController(title: "logout_alert_content_1".localized, message: "logout_alert_content_2".localized, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "alert_no".localized, style: .default, handler: { action in
                    print("No button is tapped")
                }))
                alert.addAction(UIAlertAction(title: "logout_alert_content_1".localized, style: .default, handler: { action in
                    //Logout Here
                    NotificationCenter.default.post(name: Notification.Name("SIGNOUT_OBSERVER"), object: nil)
                    self.logoutApi()
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        delegate?.jasidePanel.centerPanel = delegate?.centerNavController
        if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
            delegate?.jasidePanel.toggleRightPanel(nil)
        } else {
            delegate?.jasidePanel.toggleLeftPanel(nil)
        }
    }
    
    func logoutApi() {
        DispatchQueue.main.async {
            SwiftFTUtils.showHUDAdded(to: self.view, withText: "Logging out", animated: true)
        }
        HLApiManager.LogoutNetworkCallCore2 { isLogout, error in
            SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
            CommonModel.clearDataAndLogout(on: self, isPresentedVC: false)
        }
    }
}

extension SwiftParentDrawer {
    
    private func observeRealtimeMessages() {

        guard liveChatMessageListenerId == nil else {
            return
        }

        liveChatMessageListenerId =
        LiveChatSocketManager.shared
            .addMessageListener {
                [weak self] message in
                
                DispatchQueue.main.async {
                    
                    guard let self else {
                        return
                    }
                    
                    let exists =
                    self.messages.contains {
                        
                        $0.stableId ==
                        message.stableId
                    }
                    
                    guard !exists else {
                        return
                    }
                    
                    self.messages.append(message)
                    
                    self.updateLiveChatScreen()
                    
                    print("""
                
                =========================
                REALTIME MESSAGE
                =========================
                \(message.message ?? "")
                =========================
                
                """)
                }
            }
    }
    
    private func openLiveChat() {
        
        IQKeyboardManager.shared().isEnabled = false
        
        let chatView = LiveChatView(
            
            messages: self.messages,
            
            messageText: self.messageText,
            
            isLoadingMore: self.isLoadingMore,
            
            hasMoreMessages: self.hasMoreMessages,
            
            isConversationResolved: LiveVisitorManager.shared.isConversationResolved,
            
            onTextChange: { [weak self] text in
                
                self?.messageText = text
            },
            
            onSend: { [weak self] in
                
                self?.handleSendMessage()
            },
            
            onBack: { [weak self] in
                self?.messages = []
                self?.closeLiveChat()
            },
            
            onLoadMore: { [weak self] in
                
                self?.loadMoreMessages()
            },
            
            retryMessage: { [weak self] message in
                
                self?.retryMessage(message)
            },
            
            startConversation: { [weak self] in
                
                guard let self else {
                    return
                }
                
                self.messages.removeAll()
                
                self.oldestMessageId = nil
                
                self.hasMoreMessages = true
                
                if let existingConversationId =
                    LiveVisitorManager.shared
                    .visitor?
                    .conversationId {
                    
                    LiveVisitorManager.shared.currentConversation = Conversation(
                        id: existingConversationId,
                        status: nil,
                        createdAt: nil
                    )
                    
                }
                
                updateLiveChatScreen()
                
                LiveVisitorManager.shared.isConversationResolved = false
            }
        )
        
        let hosting = UIHostingController(
            rootView: chatView
        )
        
        let nav = UINavigationController(
            rootViewController: hosting
        )
        
        nav.setNavigationBarHidden(
            true,
            animated: false
        )
        
        self.delegate?.centerNavController = nav
        
        self.delegate?.jasidePanel.centerPanel =
        self.delegate?.centerNavController
        
        // LOAD DATA AFTER UI OPENS
        
        Task {
            
            await self.setupLiveChat()
        }
    }
    
    private func setupLiveChat() async {
        
        do {
            
            if let existingConversationId =
                LiveVisitorManager.shared
                .visitor?
                .conversationId {
                
                LiveVisitorManager.shared.currentConversation = Conversation(
                    id: existingConversationId,
                    status: nil,
                    createdAt: nil
                )
                
            } else {
                
                let newConversation =
                try await liveChatService
                    .createConversation()
                
                LiveVisitorManager.shared.currentConversation =
                newConversation
            }
            
            await loadMessages()
            
        } catch {
            
            print(error.localizedDescription)
        }
    }
    
    private func loadMessages() async {
        
        guard let conversationId =
                LiveVisitorManager.shared.currentConversation?.id else {
            return
        }
        
        do {
            
            let fetchedMessages =
            try await liveChatService
                .fetchMessages(
                    conversationId: conversationId
                )
            
            let sorted =
            fetchedMessages.sorted {
                
                ($0.id ?? 0) <
                    ($1.id ?? 0)
            }
            
            DispatchQueue.main.async {
                
                self.messages = sorted
                
                self.oldestMessageId =
                sorted.first?.id

                self.hasMoreMessages =
                sorted.count >=
                LiveChatConstants.initialMessageLimit
                
                self.updateLiveChatScreen()
            }
            
        } catch {
            
            print(error.localizedDescription)
        }
    }
    
    private func loadMoreMessages() {
        
        guard !isLoadingMore else {
            return
        }
        
        guard hasMoreMessages else {
            return
        }
        
        guard let conversationId =
                LiveVisitorManager.shared.currentConversation?.id else {
            return
        }
        
        guard let beforeId =
                oldestMessageId else {
            return
        }
        
        isLoadingMore = true
        
        updateLiveChatScreen()
        
        Task {
            
            do {
                
                let older =
                try await liveChatService
                    .fetchMessages(
                        conversationId: conversationId,
                        before: beforeId
                    )
                
                let sorted =
                older.sorted {
                    
                    ($0.id ?? 0) <
                        ($1.id ?? 0)
                }
                
                DispatchQueue.main.async {
                    
                    if sorted.isEmpty {
                        
                        self.hasMoreMessages = false
                        
                    } else {
                        
                        self.messages.insert(
                            contentsOf: sorted,
                            at: 0
                        )
                        
                        self.oldestMessageId =
                        sorted.first?.id

                        self.hasMoreMessages =
                        sorted.count >=
                        LiveChatConstants.paginationMessageLimit
                    }
                    
                    self.isLoadingMore = false
                    
                    self.updateLiveChatScreen()
                }
                
            } catch {
                
                DispatchQueue.main.async {
                    
                    self.isLoadingMore = false
                    
                    self.updateLiveChatScreen()
                }
                
                print(error.localizedDescription)
            }
        }
    }
    
    private func handleSendMessage() {
        
        let text = messageText
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )
        
        guard !text.isEmpty else {
            return
        }
        
        messageText = ""
        
        sendMessage(text)
    }
    
    private func sendMessage(
        _ text: String
    ) {
        
        guard let conversationId =
                LiveVisitorManager.shared.currentConversation?.id else {
            return
        }
        
        var tempMessage = ChatMessage(
            id: nil,
            conversationId: conversationId,
            senderType: "visitor",
            senderName: "You",
            message: text,
            isRead: true,
            createdAt: nil
        )
        
        tempMessage.status = .sending
        
        messages.append(tempMessage)
        
        updateLiveChatScreen()
        
        Task {
            
            do {
                
                var apiMessage =
                try await liveChatService
                    .sendMessage(
                        conversationId: conversationId,
                        message: text
                    )
                
                apiMessage.localId =
                tempMessage.localId
                
                apiMessage.status = .sent
                
                DispatchQueue.main.async {
                    
                    if let index =
                        self.messages.firstIndex(
                            where: {
                                $0.localId ==
                                tempMessage.localId
                            }
                        ) {
                        
                        self.messages[index] =
                        apiMessage
                    }
                    
                    self.updateLiveChatScreen()
                }
                
            } catch {
                
                DispatchQueue.main.async {
                    
                    if let index =
                        self.messages.firstIndex(
                            where: {
                                $0.localId ==
                                tempMessage.localId
                            }
                        ) {
                        
                        self.messages[index]
                            .status = .failed
                    }
                    
                    self.updateLiveChatScreen()
                }
                
                print(error.localizedDescription)
            }
        }
    }
    
    private func retryMessage(
        _ message: ChatMessage
    ) {
        
        guard let text =
                message.message else {
            return
        }
        
        messages.removeAll {
            
            $0.localId ==
            message.localId
        }
        
        updateLiveChatScreen()
        
        sendMessage(text)
    }
    
    private func updateLiveChatScreen() {
        
        guard let nav =
                delegate?.centerNavController,
              
                let hosting =
                nav.viewControllers.first
                as? UIHostingController<
                LiveChatView
        > else {
            return
        }
        
        hosting.rootView = LiveChatView(
            
            messages: messages,
            
            messageText: messageText,
            
            isLoadingMore: isLoadingMore,
            
            hasMoreMessages: hasMoreMessages,
            
            isConversationResolved: LiveVisitorManager.shared.isConversationResolved,

            onTextChange: { [weak self] text in
                
                self?.messageText = text
            },
            
            onSend: { [weak self] in
                
                self?.handleSendMessage()
            },
            
            onBack: { [weak self] in
                self?.messages = []
                self?.closeLiveChat()
            },
            
            onLoadMore: { [weak self] in
                
                self?.loadMoreMessages()
            },
            
            retryMessage: { [weak self] message in
                
                self?.retryMessage(message)
            },
            
            startConversation: { [weak self] in
                
                guard let self else {
                    return
                }
                
                self.messages.removeAll()
                
                self.oldestMessageId = nil
                
                self.hasMoreMessages = true
                                
                if let existingConversationId =
                    LiveVisitorManager.shared
                    .visitor?
                    .conversationId {
                    
                    LiveVisitorManager.shared.currentConversation = Conversation(
                        id: existingConversationId,
                        status: nil,
                        createdAt: nil
                    )
                    
                }
                
                updateLiveChatScreen()
                
                LiveVisitorManager.shared.isConversationResolved = false
            }
        )
    }
    
    private func closeLiveChat() {
        
        let storyboard =
        UIStoryboard(name: StoryboardConstants.Storyboards.DASHBOARD, bundle: nil)
        
        let vc =
        storyboard.instantiateViewController(withIdentifier: StoryboardConstants.Identifiers.DASH_BOARD_VC_IDENTIFIER) as? DashboardVC
        
        delegate?.centerNavController =
        UINavigationController(rootViewController: vc ?? DashboardVC())
        
        delegate?.jasidePanel.centerPanel =
        delegate?.centerNavController
    }
    
    private func createNewConversation() async {
        
        do {
            
            let newConversation =
            try await liveChatService
                .createConversation()
            
            LiveVisitorManager.shared.currentConversation =
            newConversation
            
            self.messages.removeAll()
            
            self.oldestMessageId = nil
            
            self.hasMoreMessages = true
            
//            LiveVisitorManager.shared.isConversationResolved = false
            
            await loadMessages()
            
            updateLiveChatScreen()
            
            try await LiveVisitorManager.shared.joinApiCall()
            
        } catch {
            
            print(
                "CREATE CONVERSATION ERROR:",
                error.localizedDescription
            )
        }
    }
}

struct ReportItem {
    let title: String
    let imageName: String
    let status: Int
}
