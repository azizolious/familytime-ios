//
//  DashboardVC.swift
//  FamilyTime
//
//  Created by Sana Ullah on 23/11/2018.
//  Copyright © 2018 YumyApps. All rights reserved.
//

import UIKit
import PopMenu
import Toast_Swift
import MBProgressHUD
//import ZendeskSDK
//import ZendeskProviderSDK
import IQKeyboardManager
import FirebaseAnalytics
import UserNotifications
import SwiftUI
import Combine

//MARK: - Global Variables
var notificationDataGlobal = NotificationFeeds(feed_id: nil, action_text: nil, billing_status: nil, card_color: nil, customer_criteria: nil, end_date: nil, feed_data: nil, feed_snippet: nil, feed_snippet_color: nil, image_url: nil, is_active: nil, lang: nil, limit: nil, notification_type: nil, platform_id: nil, read_more_color: nil, sort_order: nil, start_date: nil, time_color: nil, title: nil, title_color: nil, trigger_point: nil,google_in_app_sub_id: nil,apple_in_app_sub_id: nil,fs_sub_url: nil,paddle_sub_url: nil,dashboard_sub_url: nil, web_cta: nil)

//MARK: - Classes
class DashboardVC: BaseViewController, SwiftDashboardActiveCellDelegate {
    //MARK: - IBOutlets
    @IBOutlet weak var tableVu          : UITableView!
    //MARK: - Varibales
    private var locationManager         : CLLocationManager?
    private var delegate                = UIApplication.shared.delegate as? AppDelegate
    private var configurationArray      : [Configuration]?
    private var childrenArray           = [Child]()
    private var transLayer              : UIView?
    private var settingsCont            : SettingViewController?
    private var settingsContiOS         : SettingIOSViewController?
    private var parentLatitude          = "0.0"
    private var parentLongitude         = "0.0"
    private var address                 = ""
    private var activationFunnel          : Bool = false
    private var isScanning              : Bool = false
    private var package_id              : String = ""
    private var package_name            : String?
    private var devicePackage           : String = ""
    private var viewDetailsTitle        : String?
    var familymapEnable                 = false
    private var locationFound           = false
    private var productArr              = [String]()
    private var profileObject           :  Profile?
    private var subscriptionData        : [SubscriptionsData]?
    private var notificationTimer       : Timer?
    private var notificationCount       : Int = 86400
    private var timer                   : Timer?
    private var count                   = 60
    private var dailyLimitsData : LimitsData? = nil
    var searchButton: UIBarButtonItem?
    var isFeatureAvailable = true
    var isSection4Expanded = false
    var combinedData = [FeedItem]()
    let apiCalledBefore = UserDefaults.standard.bool(forKey: "apiCalled")
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.gray
        return refreshControl
    }()
    private var notifObj = NotificationFeeds(feed_id: nil, action_text: nil, billing_status: nil, card_color: nil, customer_criteria: nil, end_date: nil, feed_data: nil, feed_snippet: nil, feed_snippet_color: nil, image_url: nil, is_active: nil, lang: nil, limit: nil, notification_type: nil, platform_id: nil, read_more_color: nil, sort_order: nil, start_date: nil, time_color: nil, title: nil, title_color: nil, trigger_point: nil,google_in_app_sub_id: nil,apple_in_app_sub_id: nil,fs_sub_url: nil,paddle_sub_url: nil,dashboard_sub_url: nil, web_cta: nil)
    
    private var floatingChatButton: UIButton?

    private var unreadBadgeLabel: UILabel?

    private var unreadChatCount: Int = 0
    
    private var messages: [ChatMessage] = []

    private var messageText = ""

//    private var conversation: Conversation?

    private var oldestMessageId: Int?

    private var isLoadingMore = false

    private var hasMoreMessages = true

    private var isChatScreenOpen = false

    private var liveChatHostingController: UIHostingController<LiveChatView>?
    
    private let liveChatService = LiveChatService.shared

    private var liveChatMessageListenerId: UUID?

    private var liveChatTypingTask: Task<Void, Never>?

    private var isLiveChatTyping = false

    private var isFlushingOfflineMessages = false
    
    private var conversationResolvedObserver: AnyCancellable?

    deinit {
        liveChatTypingTask?.cancel()

        LiveChatSocketManager.shared.removeMessageListener(
            liveChatMessageListenerId
        )
        
        NotificationCenter.default.removeObserver(
            self,
            name: NSNotification.Name(
                "LIVE_CHAT_PUSH_CLICKED"
            ),
            object: nil
        )
    }
    
    //MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(
                handleLiveChatPushNotification
            ),
            name: NSNotification.Name(
                "LIVE_CHAT_PUSH_CLICKED"
            ),
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(
                openCancellationChatNotification
            ),
            name: Notification.Name(
                "OPEN_LIVE_CHAT"
            ),
            object: nil
        )
        
        let searchImage = UIImage(named: "ic_family_pin")!
        searchButton = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(self.familyMap))
        searchButton?.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        LiveVisitorManager.shared.updateScreen(
            "Home Screen"
        )
        
        DispatchQueue.main.asyncAfter(
            deadline: .now() + 2
        ) {

            Task {
                
                try await LiveVisitorManager.shared
                    .joinApiCall()
                
                print("""
                    
                    ====================
                    JOIN COMPLETED
                    ====================
                    
                    """)
                
                await self.setupLiveChat()
                
            }
        }
        
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
                
                self.refreshLiveChatUI()
            }
        
        if !apiCalledBefore {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                loaderVisibility(view: self.view,show: true)
                ReportsApiManager.Shared.callAllReports(loaderView: self.view)
                self.handleSMSApi(isFirstTime: true, startDate: nil, loaderView: self.view)
                //                ReportsApiManager.Shared.callDrawerReports()
                self.loadDailyLimit()
                HLApiManager.getContentFiltersApi()
                HLApiManager.getControlApi()
                CoreManager.getControlApps()
                CoreManager.getWebBlocker()
                self.callSchedule()
                self.generateNewCore2Token()
                self.reloadDashboardData()
                self.loadPlaces()
                CoreManager.getCoParents()
                self.appConfigurations()
                self.initialization()
                UserDefaults.standard.set(true, forKey: "apiCalled")
                UserDefaults.standard.synchronize()
            }
        }
        didSetTableViewNibCells()
        setUpViewDidLoad()
        triggerNotificationObserver()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        handlePendingLiveChatPush()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        initialization()
        setUpViewWillAppear()
        let combinedData = self.fetchFilteredAndCombinedData()
        self.combinedData = combinedData
        self.tableVu.reloadData()
        let settingIosValue = UserDefaults.standard.bool(forKey: "SETTING_IOS")
        //        let DAILY_LIMIT = UserDefaults.standard.integer(forKey: "DAILY_LIMIT")
        //        let DAILY_LIMIT_SWITCH = UserDefaults.standard.bool(forKey: "DAILY_LIMIT_SWITCH")
        //        if DAILY_LIMIT > 0 && DAILY_LIMIT_SWITCH == true{
        //            let value : Double = Double(DAILY_LIMIT)
        //            DispatchQueue.main.asyncAfter(deadline: .now() + value, execute: {
        //                UserDefaults.standard.set(0, forKey: "DAILY_LIMIT")
        //                UserDefaults.standard.set(false, forKey: "DAILY_LIMIT")
        //                UserDefaults.standard.synchronize()
        //
        //                // MARK: - RESET DAILY LIMIT PROGRESS
        //                var installedAppsList = [AppLimits]()
        //                let child_Id = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        //                let url = SwiftAPIConstants.kSaveAndroidDailyLimitSettings_mesh2 + "\(child_Id ?? "0")"
        //                SwiftFTUtils.showHUDAdded(to: self.view, withText: "Loading", animated: true)
        //
        //                let dailyLimitObject = LimitsData(duration: "00", radian: 0.0, remaining: 0, autoAdd: 0, isActive: 0, apps: installedAppsList)
        //
        //                let params = SwiftParamUtility.shared.androidDailyLimitSaveSettingsParams(dailyLimit: dailyLimitObject, installedApps: installedAppsList, duration: "00:00", radian: "0")
        //                ApiManager.shared().putApi(url, params: params, controller: self, isContPresented: false) { (message, statusCode) in
        //                    DispatchQueue.main.async {
        //                        UserDefaults.standard.set(true, forKey: UserDefaultsConstants.DAILY_LIMIT_RELOAD_HOME)
        //                        UserDefaults.standard.synchronize()
        //                        SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
        //                        self.viewDidDisappear(true)
        //                        //SwiftFTUtils.showSyncSettingsPopup(with: self)
        //                        CommonModel.showAlert("settings_card_5_1".localized, msg: "daily_app_limit_alert_content_2".localized)
        //                    }
        //                }
        //
        //                CoreDataUtility.updateAllHomeData()
        //                self.reloadDashboardData()
        //                let token = UserDefaultsManager.bearerTokenCore2 ?? ""
        //                self.accountApiData(token: token)
        //            })
        //        }
        
        if settingIosValue{
            UserDefaults.standard.set(false, forKey: "SETTING_IOS")
            //            CoreDataUtility.updateAllHomeData(isRequire: false)
            self.reloadDashboardData()
            let token = UserDefaultsManager.bearerTokenCore2 ?? ""
            self.accountApiData(token: token)
        }
        //        loaderVisibility(view: self.view,show: true)
    }
    
    @objc
    private func handleLiveChatPushNotification() {
        
        handlePendingLiveChatPush()
    }
    
    private func handlePendingLiveChatPush() {
        
        guard let userInfo =
                UserDefaults.standard.dictionary(
                    forKey: "LIVE_CHAT_PUSH_DATA"
                ) else {
            return
        }
                
        UserDefaults.standard.removeObject(
            forKey: "LIVE_CHAT_PUSH_DATA"
        )
        
        let conversationId = Int(
            "\(userInfo["conversation_id"] ?? "")"
        )
        
        let visitorId = Int(
            "\(userInfo["visitor_id"] ?? "")"
        )
        
        openLiveChat(
            conversationId: conversationId,
            visitorId: visitorId
        )
        
        Task {
            await loadMessages()
        }
    }
    
    private func setupLiveChat() async {

        do {

            let conversationId: Int

            if let existingConversationId =
                LiveVisitorManager.shared
                .visitor?
                .conversationId {

                conversationId = existingConversationId

            } else {

                let newConversation =
                try await liveChatService
                    .createConversation()

                conversationId =
                newConversation.id ?? 0
            }

            guard conversationId > 0 else {
                print("No conversation found")
                return
            }

            LiveVisitorManager.shared.currentConversation = Conversation(
                id: conversationId,
                status: nil,
                createdAt: nil
            )

            await loadMessages()

            flushOfflineMessages()

            observeRealtimeMessages()

        } catch {

            print(
                "LIVE CHAT SETUP ERROR:",
                error.localizedDescription
            )

            return
        }
    }
    
    private func observeRealtimeMessages() {
        
        guard liveChatMessageListenerId == nil else {
            return
        }

        print("OBSERVER REGISTERED")

        liveChatMessageListenerId =
        LiveChatSocketManager.shared
            .addMessageListener { [weak self] message in
                
                print("""
                            
                            =========================
                            DASHBOARD CALLBACK HIT
                            =========================
                            MESSAGE:
                            \(message.message ?? "")
                            =========================
                            
                            """
                    )


                guard let self else {
                    return
                }
                
                DispatchQueue.main.async {

                    if let messageConversationId =
                        message.conversationId {

                        if LiveVisitorManager.shared.currentConversation?.id == nil {

                            LiveVisitorManager.shared.currentConversation = Conversation(
                                id: messageConversationId,
                                status: nil,
                                createdAt: nil
                            )
                        }

                        guard LiveVisitorManager.shared.currentConversation?.id ==
                                messageConversationId else {
                            return
                        }
                    }

                    let alreadyExists =
                    self.messages.contains {

                        if let lhsId = $0.id,
                           let rhsId = message.id {
                            return lhsId == rhsId
                        }

                        return $0.localId ==
                        message.localId
                    }

                    guard !alreadyExists else {
                        return
                    }
                    
                    self.messages.append(message)
                    
                    if !self.isChatScreenOpen {
                        
                        self.unreadChatCount += 1
                        
                        self.showFloatingChatButton()

                    } else {

                        self.markCurrentConversationRead()
                    }
                    
                    self.refreshLiveChatUI()
                }
            }
    }
    
    @objc
    private func openCancellationChatNotification() {
        
        openLiveChat(isFromCancelSubscription: true)
    }
    
    private func sendPendingCancellationMessage() {
        
        guard let message =
                UserDefaults.standard.string(
                    forKey:
                        "LIVE_CHAT_PENDING_MESSAGE"
                ) else {
            return
        }
        
        self.messageText = message
        
        UserDefaults.standard.removeObject(
            forKey:
                "LIVE_CHAT_PENDING_MESSAGE"
        )
        
        self.sendMessage()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        removeNotificationObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        //Title Colour
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        UserDefaults.standard.removeObject(forKey: UserDefaultsConstants.ZENDESK_CHAT_SCREEN)
        UserDefaults.standard.synchronize()
        refreshControl.removeFromSuperview()
    }
    
    //MARK: - IBActions
    @IBAction func claimDiscoutButtonPressed(_ sender: Any) {
    }
    
    @IBAction func linkChlidDeviceButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: StoryboardConstants.Storyboards.AUTH, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: StoryboardConstants.Identifiers.SELECT_CHILD_DEVICE_VC_IDENTIFIER) as! SelectChildDeviceScreenController
        vc.setScreenType(isComingFrom: "Dashboard")
        vc.navigationController?.isNavigationBarHidden = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func liveChatButtonPressed(_ sender: Any) {
        openLiveChat()
    }
    //    let tiktok = CoreDataUtility.fetchTiktokData()
    //                let web = CoreDataUtility.fetchHistoryData()
    //                let youtube = CoreDataUtility.fetchYoutubeData()
    //                let familyFeed = DBManager.shared.getLatestFamilyFeed()
    //                let calls = DBManager.shared.fetchAllCalls()
    //                let contacts = DBManager.shared.fetchAllContacts()
    //                let sms = DBManager.shared.fetchTextMsgs()
    //                SwiftFTUtils.hideHUDAdded(to: loaderView, animated: true)
    func handleSMSApi(isFirstTime: Bool, startDate: String?, loaderView: UIView) {
        var params: [String: Any] = [:]
        if let startDate = startDate {
            params["start_date"] = startDate
        }
        CoreManager.getTextMsgs(params: params, isFirstTime: isFirstTime, loaderView: loaderView) { hasMoreData in
            if hasMoreData {
                if let latestMsgTime = DBManager.shared.getLatestTextMsgs().first?.sms_time {
                    let nextTime = self.addOneMinuteToDateString(latestMsgTime)
                    self.handleSMSApi(isFirstTime: false, startDate: nextTime, loaderView: loaderView)
                }
            }else{
                loaderVisibility(view: loaderView,show: false)
                //                let familyFeed = DBManager.shared.getLatestFamilyFeed()
                //                let smsData = DBManager.shared.fetchTextMsgs()
                //                let allApps = DBManager.shared.fetchDataAndConvertToModels()
                //                DBManager.shared.fetchAllContacts()
                let contacts = DBManager.shared.fetchAllContacts()
                let combinedData = self.fetchFilteredAndCombinedData()
                self.combinedData = combinedData
                self.tableVu.reloadData()
            }
        }
    }
    //    func fetchFilteredAndCombinedData() -> [FeedItem] {
    //        let tiktokData = CoreDataUtility.fetchTiktokData().map { FeedItem.fromTikTokData($0) }
    //        let youtubeData = CoreDataUtility.fetchYoutubeData().map { FeedItem.fromYouTubeData($0) }
    //        let webHistoryData = CoreDataUtility.fetchHistoryData().map { FeedItem.fromWebHistoryData($0) }
    //        let callData = DBManager.shared.fetchAllCalls().map { FeedItem.fromCallData($0) }
    //        let smsData = DBManager.shared.getLatestTextMsgs().map { FeedItem.fromSmsData($0) }
    //        let contactData = DBManager.shared.fetchAllContacts().map { FeedItem.fromContactData($0) }
    //        let familyFeedData = DBManager.shared.getLatestFamilyFeed().compactMap { FeedItem.fromFamilyTimeDatum($0) }
    //
    //        let combinedData = (tiktokData + youtubeData + webHistoryData + callData + smsData + contactData + familyFeedData).filter { data in
    //            guard let createdAt = DateFormatter.customDateFormatter.date(from: data.createdAt ?? "") else {
    //                return false
    //            }
    //            return Calendar.current.isDateInToday(createdAt) || Calendar.current.isDateInYesterday(createdAt)
    //        }.sorted {
    //            let date1 = getDate(from: $0)
    //            let date2 = getDate(from: $1)
    //            return date1 > date2
    //        }
    //
    //        return combinedData
    //    }
    //
    //    func getDate(from item: FeedItem) -> Date {
    //        if let createdAt = item.createdAt {
    //            return DateFormatter.customDateFormatter.date(from: createdAt) ?? Date.distantPast
    //        }
    //        return Date.distantPast
    //    }
    func fetchFilteredAndCombinedData() -> [FeedItem] {
        let tiktokData = CoreDataUtility.fetchTiktokData().map { FeedItem.fromTikTokData($0) }
        let youtubeData = CoreDataUtility.fetchYoutubeData().map { FeedItem.fromYouTubeData($0) }
        let webHistoryData = CoreDataUtility.fetchHistoryData().map { FeedItem.fromWebHistoryData($0) }
        let callData = DBManager.shared.fetchAllCalls().map { FeedItem.fromCallData($0) }
        let smsData = DBManager.shared.getLatestTextMsgs().map { FeedItem.fromSmsData($0) }
        let allContactData = DBManager.shared.fetchAllContacts()
        let latestContact = allContactData.max {
            guard let date1 = DateFormatter.customDateFormatter.date(from: $0.contactTime ?? ""),
                  let date2 = DateFormatter.customDateFormatter.date(from: $1.contactTime ?? "") else {
                return false
            }
            return date1 < date2
        }
        
        let contactData = latestContact.map { FeedItem.fromContactData($0) }
        let familyFeedData = DBManager.shared.getLatestFamilyFeed().compactMap { datum in
            let feedItem = FeedItem.fromFamilyTimeDatum(datum)
            print("Processing datum: \(datum.createdAt), result: \(feedItem)")
            return feedItem
        }
        
        
        let combinedData = (tiktokData + youtubeData + webHistoryData + callData + smsData + (contactData != nil ? [contactData!] : []) + familyFeedData).filter { data in
            guard let createdAt = DateFormatter.customDateFormatter.date(from: data.createdAt ?? "") else {
                return false
            }
            return Date().timeIntervalSince(createdAt) <= 86400 // 86400 seconds in 24 hours
        }.sorted {
            let date1 = getDate(from: $0)
            let date2 = getDate(from: $1)
            return date1 > date2
        }
        
        return combinedData
    }
    
    func getDate(from item: FeedItem) -> Date {
        if let createdAt = item.createdAt {
            return DateFormatter.customDateFormatter.date(from: createdAt) ?? Date.distantPast
        }
        return Date.distantPast
    }
    
    func addOneMinuteToDateString(_ dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        if let date = dateFormatter.date(from: dateString) {
            let modifiedDate = date.addingTimeInterval(3)
            let modifiedDateString = dateFormatter.string(from: modifiedDate)
            return modifiedDateString
        } else {
            print("Invalid date string format")
            return nil
        }
    }
    //MARK: - OBJECTIVE Functions
    @objc func updateFamilyPause() {
        let lockStatus = UserDefaults.standard.string(forKey: UserDefaultsConstants.PHONE_LOCKED)
        if lockStatus == StringConstants.Constants.PAUSED {
            UserDefaults.standard.set(StringConstants.Constants.UNLOCKED, forKey: UserDefaultsConstants.PHONE_LOCKED)
            UserDefaults.standard.synchronize()
            self.tableVu.reloadData()
        } else if lockStatus == StringConstants.Constants.UNLOCKED {
            UserDefaults.standard.set(StringConstants.Constants.PAUSED, forKey: UserDefaultsConstants.PHONE_LOCKED)
            UserDefaults.standard.synchronize()
            self.tableVu.reloadData()
        }
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.refreshApiCall()
    }
    
    @objc func dataResave(notification: Notification) {
        DispatchQueue.main.async {
            SwiftFTUtils.showHUDAdded(to: self.view, withText: "Logging out", animated: true)
        }
        let staus = UserDefaults.standard.bool(forKey: "LOGOUT_STATUS")
        if staus {
            SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
            UserDefaults.standard.set(false, forKey: "LOGOUT_STATUS")
        }
    }
    
    @objc func subscriptionReload(notification: Notification) {
        debugPrint("Push notification received and update dashboard")
        self.reloadDashboardData()
    }
    
    @objc func subscriptionUpdate(notification: Notification) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            self.reloadDashboardData()
        })
    }
    
    @objc private func imgTapGesture(){
        let storyBoard: UIStoryboard = UIStoryboard(name: StoryboardConstants.Storyboards.DASHBOARD, bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: StoryboardConstants.Identifiers.NOTIFICATIONS_VC_IDENTIFIER) as! NotificationDetailViewController
        newViewController.notifDetail = self.notifObj
        newViewController.comeFromDashboard = true
        newViewController.modalPresentationStyle = .overFullScreen
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    @objc func reloadControl() {
        HLApiManager.getControlApi()
        CoreManager.getControlApps()
    }
    @objc func reloadDashboardData() {
        
        getAccountAPI()

        HLApiManager.getHomeApi { response, error in
            SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
            if let response = response {
                //MARK: CHANGES BY RIZWAN
                //CoreDataUtility.updateAllHomeData(isRequire: true)
                
                if let plans = response.plans {
                    DBManager.shared.savePlans(plans: plans)
                    // Assuming plans and children are parsed from your API response
                    for plan in plans {
                        if plan.identifier == "family_locator" {
                            // Check if any child has family locator released for either iOS or Android
                            if let children = response.children {
                                for child in children {
                                    if child.planID == plan.planID {
                                        if plan.androidReleased == 1 {
                                            self.isFeatureAvailable = false
                                            if #available(iOS 16.0, *) {
                                                self.searchButton?.isHidden = false
                                            } else {
                                                // Fallback on earlier versions
                                            }
                                            break
                                        }
                                        if plan.iosReleased == 1 {
                                            self.isFeatureAvailable = false
                                            if #available(iOS 16.0, *) {
                                                self.searchButton?.isHidden = false
                                            } else {
                                                // Fallback on earlier versions
                                            }
                                            break
                                        }
                                    }
                                }
                            }
                            
                        }
                    }
                }
                
                if let children = response.children {
                    children.forEach { child in
                        let subscription_package = child.package
                        if subscription_package != nil {
                            UserDefaults.standard.setValue(subscription_package, forKey: UserDefaultsConstants.BILLING_STATUS)
                        } else {
                            UserDefaults.standard.setValue(nil, forKey: UserDefaultsConstants.BILLING_STATUS)
                        }
                        UserDefaults.standard.synchronize()
                        
                        DBManager.shared.saveChildren(children: children)
                        let childID = Int32(child.childID ?? 0)
                        let packageID = Int32(child.planID ?? 0)
                        let device = child.device ?? ""
                        let package = child.package ?? ""
                        
                        self.savePackageIdInDatabase(childId: childID, packageId: packageID, device: device, package: package)
                        self.package_id = CoreDataUtility.fetchPackageIdFor(child_id: childID)
                        self.package_name = CoreDataUtility.fetchPackageNameFor(child_id: childID)
                        self.devicePackage = CoreDataUtility.fetchPackageDeviceFor(child_id: childID)
                    }
                }
                //                SwiftFTUtils.hideHUDAdded(to: self.view, animated: false)
                if let children = response.children {
                    let count = children.count
                    UserDefaults.standard.set(count, forKey: UserDefaultsConstants.CHILD_COUNT)
                    UserDefaults.standard.synchronize()
                    self.childrenArray = children
                }
                self.tableVu.reloadData()
                self.tableVu.isHidden = false
                self.setUpViewWillAppear()
                self.loadNotificationsFeedOnDashboard()
                
            } else {
                DispatchQueue.main.async {
                    //                    SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
                    if let error = error {
                        let errorMessage = error.localizedDescription
                        CommonModel.showAlert("Error!".myModification(), msg: errorMessage)
                    } else {
                        CommonModel.showAlert("Error!".myModification(), msg: "Unknown error occurred")
                    }
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.setFamilyMapEnable()
        }
    }
    
    func loadPlaces() {
        SwiftFTUtils.showHUDAdded(to: view, withText: "Loading...", animated: true)
        let urrl = HLConstants.BASE_URL_CORE_2 + "controls/places"
        CoreManager.networkRequest(url: urrl, method: .get) { (response: PlacesCodableModel?, statusCode, message) in
            DispatchQueue.main.async {
                //MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                if (200...206).contains(statusCode ?? 0) {
                    DBManager.shared.deleteData(entityName: "PlacesDB")
                    DBManager.shared.savePlaces(myModelArray: response?.data ?? [])
                } else {
                    //CommonModel.showAlert("alert_error".localized, msg: message)
                }
            }
        }
    }
    func loadDailyLimit() {
        SwiftFTUtils.showHUDAdded(to: view, withText: "Loading...", animated: true)
        let urrl = HLConstants.BASE_URL_CORE_2 + "controls/daily-limit"
        CoreManager.networkRequest(url: urrl, method: .get) { (response: DailyLimitCodableModel?, statusCode, message) in
            DispatchQueue.main.async {
                //MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                if (200...206).contains(statusCode ?? 0) {
                    DBManager.shared.deleteData(entityName: "DailyLimitTable")
                    DBManager.shared.saveDailyLimit(myModelArray: response?.dailyLimits ?? [])
                    self.tableVu.reloadData()
                } else {
                    //CommonModel.showAlert("alert_error".localized, msg: message)
                }
            }
        }
    }
    @objc private func familyMap(){
        let billingStatus = UserDefaults.standard.string(forKey: UserDefaultsConstants.BILLING_STATUS)
        if billingStatus == StringConstants.Subscriptions.FREE_CAPITAL  || billingStatus == StringConstants.Subscriptions.FREE_SMALL {
            let vc = HLStoryboard.loadPremiumPopupVC()
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            if familymapEnable {
                let vc = SwiftFamilyMapViewController(nibName: StoryboardConstants.Identifiers.FAMILY_MAP_VC_IDENTIFIER, bundle: nil)
                //navigationController?.pushViewController(vc, animated: true)
                vc.modalPresentationStyle = .fullScreen
                present(vc, animated: false)
            } else {
                let storyboard = UIStoryboard(name: StoryboardConstants.Storyboards.DASHBOARD, bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: StoryboardConstants.Identifiers.ACTIVATE_FAMILY_TIME_ALER_IDENTIFIER) as! ActivateFamilyTimeAlert
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    @objc func addUser() {
        goToAddChildScreen()
    }
    
    @objc func addPreSubscription() {
        goToPreSubscription()
    }
    
    func apiCallWith(message:String?, url:String) {
        self.view.makeToast("sending_toast".localized)
        var param : [String: Any]?
        if message == "not_coming" || message == "coming" {
            param = [ "push_type" : message ?? ""]
        } else {
            param = nil
        }
        print("update parent info Params: \(String(describing: param)) and url = \(url)")
        SwiftFTUtils.showHUDAdded(to: self.view, withText: "", animated: true)
        ApiManager.shared().putApiSOS(url, params: param ?? [String : Any](), controller: self, isContPresented: false) { (message, status) in
            DispatchQueue.main.async{
                SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
                if (status == 200 || status == 201 || status == 202 || status == 204 || status == 206){
                    DispatchQueue.main.async {
                        self.view.makeToast("message_sent_toast".localized)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        UserDefaults.standard.set(false, forKey: "checkin-checkout")
                        UserDefaults.standard.set(false, forKey: "sos_pickup")
                        UserDefaults.standard.removeObject(forKey: "genderStr")
                        UserDefaults.standard.removeObject(forKey: "push_time")
                        UserDefaults.standard.removeObject(forKey: "push_content")
                        UserDefaults.standard.removeObject(forKey: "user_name_str")
                        UserDefaults.standard.removeObject(forKey: "address_str")
                        UserDefaults.standard.set("", forKey: "lat_str")
                        UserDefaults.standard.set("", forKey: "long_str")
                        UserDefaults.standard.set("", forKey: "panicSOS_string")
                        UserDefaults.standard.synchronize()
                        self.dismiss(animated: true, completion: nil)
                    }
                } else {
                    print("push back api failed with message = \(message) and code = \(status)")
                    let alert = UIAlertController(title: "FamilyTime Dashboard".localized, message: message, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "alert_try_again".localized, style: UIAlertAction.Style.cancel, handler:nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    @objc func refreshApiCall(){
        if refreshControl.isRefreshing {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                
                ReportsApiManager.Shared.callAllReports(loaderView: self.view)
                self.handleSMSApi(isFirstTime: true, startDate: nil, loaderView: self.view)
                //                ReportsApiManager.Shared.callDrawerReports()
                self.loadDailyLimit()
                HLApiManager.getContentFiltersApi()
                HLApiManager.getControlApi()
                CoreManager.getControlApps()
                CoreManager.getWebBlocker()
                self.callSchedule()
                self.generateNewCore2Token()
                self.reloadDashboardData()
                self.loadPlaces()
                
                CoreManager.getCoParents()
                self.didSetTableViewNibCells()
                self.appConfigurations()
                self.setUpViewDidLoad()
                self.triggerNotificationObserver()
                self.initialization()
                let token = UserDefaultsManager.bearerTokenCore2 ?? ""
                self.accountApiData(token: token)
            }
        }
    }
    
    @objc func updateLocalNotificationTimer() {
        if (notificationCount > 0){
            notificationCount = notificationCount - 1
            
        } else {
            UserDefaults.standard.set(true, forKey: UserDefaultsConstants.SUBSCRIPTION_CHECK_KEY)
            UserDefaults.standard.synchronize()
            notificationTimer?.invalidate()
            notificationCount = 86400
        }
    }
    
    @objc func updateTimer() {
        if(count > 0){
            count = count - 1
        } else {
            UserDefaults.standard.set(true, forKey: UserDefaultsConstants.HIT_EMAIL_VERIFICATOIN_API)
            UserDefaults.standard.synchronize()
            timer?.invalidate()
            count = 60
        }
    }
    
    @objc func getAccountAPI(){
        UserDefaults.standard.removeObject(forKey: UserDefaultsConstants.EMAIL_VERIFIED_PUSH)
        UserDefaults.standard.synchronize()
        let token = UserDefaultsManager.bearerTokenCore2 ?? ""
        accountApiData(token: token)
    }
    
    @objc func pickUpSOSCall(){
        let storyboard = UIStoryboard(name: StoryboardConstants.Storyboards.DASHBOARD, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: StoryboardConstants.Identifiers.COMMON_POP_VC_IDENTIFIER) as! CommonPopupVC
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true)
    }
    
    @objc func approvedAppPopupCall() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsConstants.APPROVE_APP_NOTIFICAION)
        UserDefaults.standard.synchronize()
        let approvedAppTitle = UserDefaults.standard.string(forKey: UserDefaultsConstants.APPROVED_APP_TITLE)
        let approvedAppBody = UserDefaults.standard.string(forKey: UserDefaultsConstants.APPROVED_APP_BODY)
        let appName = UserDefaults.standard.string(forKey: UserDefaultsConstants.APPROVE_APP_NAME)
        let appPackageName = UserDefaults.standard.string(forKey: UserDefaultsConstants.APPROVE_APP_PACKAGE_NAME)
        let storyboard = UIStoryboard(name: StoryboardConstants.Storyboards.DASHBOARD, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: StoryboardConstants.Identifiers.APPROVED_APP_POP_UP_VC) as! ApprovedAppPopupVc
        vc.titleText = approvedAppTitle
        vc.body = approvedAppBody
        vc.appName = appName
        vc.appPackage = appPackageName
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
    }
    
    @objc func geoFencePopupCall(){
        UserDefaults.standard.removeObject(forKey: UserDefaultsConstants.GEO_FENCE_NOTIFICATION)
        UserDefaults.standard.synchronize()
        let storyboard = UIStoryboard(name: StoryboardConstants.Storyboards.DASHBOARD, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: StoryboardConstants.Identifiers.GEO_FENCE_POPUP_IDENTIFIER) as! GeoFencePopupVC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    @objc func blockAppPopupCall(){
        let childName = UserDefaults.standard.string(forKey: UserDefaultsConstants.APP_BLOCK_CHILD_NAME)
        UserDefaults.standard.removeObject(forKey: UserDefaultsConstants.APP_BLOCK_STATUS)
        UserDefaults.standard.synchronize()
        let sb = UIStoryboard(name: StoryboardConstants.Storyboards.DASHBOARD, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: StoryboardConstants.Storyboards.Identifiers.BLOCK_APP_STATUS_IDENTIFIER) as! BlockAppStatusVcPopUp
        vc.childName = childName
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func contactWatchListPopupCall(){
        let titleMessage = UserDefaults.standard.string(forKey: UserDefaultsConstants.APP_BLOCK_CONTACT_LIST_MSG)
        UserDefaults.standard.removeObject(forKey: UserDefaultsConstants.CONTACT_WATCHLIST_PUSH)
        UserDefaults.standard.synchronize()
        let sb = UIStoryboard(name: StoryboardConstants.Storyboards.DASHBOARD, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: StoryboardConstants.Storyboards.Identifiers.CONTACT_WATCH_LIST_POPUP) as! ContactWatchListPopup
        vc.titleNames = titleMessage
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    //MARK: - CUSTOM METHODS
    private func setUpViewDidLoad() {
        /// CHECKING IF NOTIFICARION ARRIVE
        let aprovAppNotiStatus = UserDefaults.standard.bool(forKey: UserDefaultsConstants.APPROVE_APP_NOTIFICAION)
        //let pickupNotiStatus = UserDefaults.standard.bool(forKey: UserDefaultsConstants.PICK_UP_PANIC_NOTIFICATON)
        //let checkinStatus = UserDefaults.standard.bool(forKey: "checkin-checkout")
        let sos_pickPush = UserDefaults.standard.bool(forKey: "sos_pickup")
        let updateHome = UserDefaults.standard.bool(forKey: "Update_Home")
        
        let geo_fencNotiStatus = UserDefaults.standard.bool(forKey: UserDefaultsConstants.GEO_FENCE_NOTIFICATION)
        let app_block_status = UserDefaults.standard.bool(forKey: UserDefaultsConstants.APP_BLOCK_STATUS)
        let email_verified_status = UserDefaults.standard.bool(forKey: UserDefaultsConstants.EMAIL_VERIFIED_PUSH)
        let subscriptionStatus = UserDefaults.standard.bool(forKey: UserDefaultsConstants.SUBSCRIPTION_CREATED_PUSH)
        let contactWatchlistStatus = UserDefaults.standard.bool(forKey: UserDefaultsConstants.CONTACT_WATCHLIST_PUSH)
        let upgradeSuccessFull = UserDefaults.standard.bool(forKey: UserDefaultsConstants.UPDATE_HOME_DATA_WHILE_UPGRADE)
        //let childCreated = UserDefaults.standard.bool(forKey: UserDefaultsConstants.CHILD_CREATED_PUSH)
        let childLocked = UserDefaults.standard.bool(forKey: UserDefaultsConstants.PHONE_LOCKED_PUSH)
        let loadFirstTimeData = UserDefaults.standard.bool(forKey: UserDefaultsConstants.RELOAD_HOME_PUSH)
        if aprovAppNotiStatus {
            approvedAppPopupCall()
        }
        
        if sos_pickPush {
            UserDefaults.standard.set(false, forKey: "sos_pickup")
            UserDefaults.standard.synchronize()
            pickUpSOSCall()
        }
        
        if geo_fencNotiStatus {
            // geoFencePopupCall()
        }
        if app_block_status {
            blockAppPopupCall()
        }
        if email_verified_status {
            getAccountAPI()
        }
        if subscriptionStatus {
            UserDefaults.standard.removeObject(forKey: UserDefaultsConstants.SUBSCRIPTION_CREATED_PUSH)
            UserDefaults.standard.synchronize()
            reloadDashboardData()
            getAccountAPI()
        }
        if contactWatchlistStatus{
            contactWatchListPopupCall()
        }
        if updateHome {
            UserDefaults.standard.removeObject(forKey: "Update_Home")
            UserDefaults.standard.set(false, forKey: "Update_Home")
            UserDefaults.standard.synchronize()
            reloadControl()
            reloadDashboardData()
            
        }
        if childLocked {
            UserDefaults.standard.removeObject(forKey: UserDefaultsConstants.PHONE_LOCKED_PUSH)
            UserDefaults.standard.synchronize()
            updateFamilyPause()
        }
        if upgradeSuccessFull {
            UserDefaults.standard.removeObject(forKey: UserDefaultsConstants.UPDATE_HOME_DATA_WHILE_UPGRADE)
            UserDefaults.standard.synchronize()
            reloadDashboardData()
        }
        if loadFirstTimeData {
            UserDefaults.standard.removeObject(forKey: UserDefaultsConstants.RELOAD_HOME_PUSH)
            UserDefaults.standard.synchronize()
            reloadDashboardData()
        }
        let check = UserDefaults.standard.bool(forKey: UserDefaultsConstants.DISMISS_TRIAL_SCREEN)
        if check {
            
            let billingStatus = UserDefaults.standard.string(forKey: UserDefaultsConstants.BILLING_STATUS)
            
            if (billingStatus == StringConstants.Subscriptions.TRIAL_CAPITAL || billingStatus == StringConstants.Subscriptions.TRIAL_SMALL) {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    let sb = UIStoryboard(name: StoryboardConstants.Storyboards.MY_STORYBOARD, bundle: nil)
                    let vc = sb.instantiateViewController(withIdentifier: StoryboardConstants.Identifiers.TRAIL_VC_IDENTIFIER) as! ThreeDayTrailVc
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
//            if let idArr = UserDefaults.standard.array(forKey: UserDefaultsConstants.PRODUCT_ACCOUNT_ARRAY) as? [String] {
//                print(idArr)
//                precondition(!idArr.isEmpty)
//                let repeated = repeatElement(idArr[0], count: idArr.count)
//                let hasAllElementsEqual = idArr.elementsEqual(repeated)
//                print(hasAllElementsEqual)
//                if hasAllElementsEqual {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
//                        let sb = UIStoryboard(name: StoryboardConstants.Storyboards.MY_STORYBOARD, bundle: nil)
//                        let vc = sb.instantiateViewController(withIdentifier: StoryboardConstants.Identifiers.TRAIL_VC_IDENTIFIER) as! ThreeDayTrailVc
//                        self.navigationController?.pushViewController(vc, animated: true)
//                    }
//                }
//            }
        }
        //        tableVu.allowsSelection = false
    }
    
    /// NOTIFICATIONS OBSERVER CALL
    private func triggerNotificationObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.dataResave(notification:)), name: Notification.Name(SwiftConstants.SIGNOUT_OBSERVER), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.subscriptionReload(notification:)), name: Notification.Name("subscription_created_observer"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.subscriptionUpdate(notification:)), name: Notification.Name("pre_paid_subscription_observer"), object: nil)
    }
    
    /// REMOVING NOTIFICATION OBSERVER
    private func removeNotificationObserver() {
        NotificationCenter.default.removeObserver(SwiftConstants.SIGNOUT_OBSERVER)
        UserDefaults.standard.removeObject(forKey: UserDefaultsConstants.PICK_UP_PANIC_NOTIFICATON)
        //NotificationCenter.default.removeObserver(SwiftConstants.KPhoneLockStatus)
        UserDefaults.standard.set("", forKey: "panic_string")
        UserDefaults.standard.set("", forKey: "pickup_string")
        UserDefaults.standard.synchronize()
    }
    
    private func setUpViewWillAppear(){
        Analytics.logEvent("app_store_subscription_renew", parameters: [
            "upgrade_status": "in_app_upgrade_compeleted",
            "screen_name": "in_app_upgrade_screen"
        ])
        if((UserDefaults.standard.string(forKey: UserDefaultsConstants.USER_LANGUAGE)) == nil){
            UserDefaults.standard.set(NSLocale.current.languageCode, forKey: UserDefaultsConstants.USER_LANGUAGE)
        }
        ZendeskChatManager.trackEvent("Mykids Dashboard")
        var editImage = UIImage()
        if #available(iOS 13.0, *) {
            editImage = UIImage(systemName: "plus")!
        } else {
            
        }
        var prepaidSubscriptionImage = UIImage()
        if #available(iOS 13.0, *) {
            prepaidSubscriptionImage = UIImage(named: "prepaidSubscriptionIcon") ?? UIImage()
        } else {
            
        }
        let searchImage  = UIImage(named: "ic_family_pin")!
        let preSubscription = UIBarButtonItem(image: prepaidSubscriptionImage, style: .plain, target: self, action: #selector(addPreSubscription))
        let editButton  = UIBarButtonItem(image: editImage,  style: .plain, target: self, action: #selector(self.addUser))
        let searchButton = UIBarButtonItem(image: searchImage,  style: .plain, target: self, action: #selector(self.familyMap))
        //        if #available(iOS 16.0, *) {
        //            searchButton.isHidden = self.isFeatureAvailable
        //        } else {
        //            // Fallback on earlier versions
        //        }
        editButton.imageInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: -20.0)
        searchButton.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0.0)
        
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: nil, action: nil)
        let package = UserDefaults.standard.string(forKey: UserDefaultsConstants.BILLING_STATUS)
        space.width = 0.0
        let childCount = UserDefaults.standard.integer(forKey: UserDefaultsConstants.CHILD_COUNT)
        if childCount == 0 {
            preSubscription.imageInsets = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 0.0)
            // MARK: check user package
            if package == StringConstants.Subscriptions.PREMIUM_CAPITAL || package == StringConstants.Subscriptions.PREMIUM_SMALL {
                navigationItem.rightBarButtonItems = [searchButton]
            } else {
                navigationItem.rightBarButtonItems = [searchButton, preSubscription]
            }
        } else {
            preSubscription.imageInsets = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: -25.0)
            // MARK: check user package
            if package == StringConstants.Subscriptions.PREMIUM_CAPITAL || package == StringConstants.Subscriptions.PREMIUM_SMALL {
                navigationItem.rightBarButtonItems = [searchButton, editButton]
            } else {
                navigationItem.rightBarButtonItems = [searchButton, editButton, preSubscription]
            }
        }
        UserDefaults.standard.removeObject(forKey: UserDefaultsConstants.RELOAD_FROM_DETAILS_VC)
        UserDefaults.standard.removeObject(forKey: UserDefaultsConstants.REFRESH_RELOADER)
        UserDefaults.standard.synchronize()
    }
    func callSchedule() {
        let url = HLConstants.BASE_URL_CORE_2 + "controls/schedules"
        CoreManager.networkRequest(url: url, method: .get) { (response: ScheduleRuleCodableModel?, statusCode, errorMessage) in
            //            SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
            if errorMessage == nil {
                if let schedules = response?.schedules {
                    DBManager.shared.deleteData(entityName: "Schedules")
                    DBManager.shared.saveSchedule(myModelArray: schedules)
                }
            } else {
                CommonModel.showAlert("alert_error".localized, msg: errorMessage)
            }
        }
    }
    
    func getControlCall() {
        let url = HLConstants.BASE_URL_CORE_2 + "controls"
        CoreManager.networkRequest(url: url, method: .get) { (response: ControlCodableModel?, statusCode, errorMessage)  in
            if errorMessage == nil {
                if response?.controls != nil {
                    DBManager.shared.saveControlsModel(myModelArray: response?.controls ?? [])
                    self.tableVu.reloadData()
                }
            } else {
                print(errorMessage as Any)
                //CommonModel.showAlert("alert_error".localized, msg: errorMessage)
            }
        }
    }
    
    private func initialization(){
        /// Reloading HomeAPI  on the base of value from the QRCode & DetailedInstructions Screen
        let sub_done_status = UserDefaults.standard.bool(forKey:UserDefaultsConstants.SUBSCRIPTION_DONE_KEY)
        let updateDailyLimit = UserDefaults.standard.bool(forKey: UserDefaultsConstants.DAILY_LIMIT_RELOAD_HOME)
        let instruction = UserDefaults.standard.string(forKey: UserDefaultsConstants.RELOAD_DASHBOARD_VIA_INSTRUCTION) ?? ""
        if instruction == StringConstants.Constants.YES_I_HAVE_DONE_IT {
            loadDataFromDataBase()
            UserDefaults.standard.removeObject(forKey: UserDefaultsConstants.RELOAD_DASHBOARD_VIA_INSTRUCTION)
            UserDefaults.standard.synchronize()
        } else if updateDailyLimit {
            reloadDashboardData()
            UserDefaults.standard.removeObject(forKey: UserDefaultsConstants.DAILY_LIMIT_RELOAD_HOME)
            UserDefaults.standard.synchronize()
        } else {
            loadDataFromDataBase()
        }
        if UserDefaults.standard.bool(forKey: UserDefaultsConstants.FAMILY_MAP_ENABLE){
            familymapEnable = true
        } else {
            familymapEnable = false
            UserDefaults.standard.set(false, forKey: UserDefaultsConstants.FAMILY_MAP_ENABLE)
            UserDefaults.standard.synchronize()
        }
        
        if sub_done_status {
            UserDefaults.standard.removeObject(forKey: UserDefaultsConstants.SUBSCRIPTION_DONE_KEY)
            UserDefaults.standard.synchronize()
            let token = UserDefaultsManager.bearerTokenCore2 ?? ""
            self.accountApiData(token: token)
        }
        self.tableVu.estimatedRowHeight = 0
        delegate = AppDelegate.getSharedAppDelegateForSwift()
        delegate?.setNavigationbarAppearence(false)
        navigationItem.title = "dashboard_title".localized
        locationSetup()
        tableVu.addSubview(refreshControl)
        let triggerSubscriptionNotification = UserDefaults.standard.bool(forKey: UserDefaultsConstants.SUBSCRIPTION_CHECK_KEY)
        if triggerSubscriptionNotification {
            notificationTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateLocalNotificationTimer), userInfo: nil, repeats: true)
            UserDefaults.standard.set(false, forKey: UserDefaultsConstants.SUBSCRIPTION_CHECK_KEY)
            UserDefaults.standard.synchronize()
            let billingStatus = UserDefaults.standard.string(forKey: UserDefaultsConstants.BILLING_STATUS)
            if (billingStatus != StringConstants.Subscriptions.PREMIUM_CAPITAL || billingStatus != StringConstants.Subscriptions.PREMIUM_SMALL) {
                self.sendLocalNotification(title: StringConstants.Constants.SUBSCRIPTION, body: StringConstants.Constants.SUBSCRIPTION_CANCELLED)
            }
        }
    }
    
    private func goToAddChildScreen() {
        let storyboard = UIStoryboard(name: StoryboardConstants.Storyboards.DASHBOARD, bundle : nil)
        let vc = storyboard.instantiateViewController(withIdentifier: StoryboardConstants.Identifiers.INSTRUCTIONS_VC_IDENTIFIER) as! InstructionsVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func goToPreSubscription() {
        let vc = QRCodeScannerViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showPremiumAlert() {
        let alert = UIAlertController(title: "already_active_subscription".localized,
                                      message: "add_additional_subscription".localized,
                                      preferredStyle: .alert)
        
        // Cancel Action
        let cancelAction = UIAlertAction(title: "cancel_button".localized, style: .cancel) { _ in
            // Handle cancel action if needed
        }
        alert.addAction(cancelAction)
        
        // Continue Action
        let continueAction = UIAlertAction(title: "continue_button".localized, style: .default) { _ in
            self.navigateToCameraView()
        }
        alert.addAction(continueAction)
        
        // Present the alert
        present(alert, animated: true, completion: nil)
    }
    
    private func navigateToCameraView() {
        let cameraVC = QRCodeScannerViewController()
        self.navigationController?.pushViewController(cameraVC, animated: true)
    }
    
    private func loadDataFromDataBase() {
        let chilArrData = DBManager.shared.fetchAllChildren()
        let settingIosValue = UserDefaults.standard.bool(forKey: "SETTING_IOS")
        
        if let children = chilArrData, children.count > 0, settingIosValue == false {
            self.childrenArray = children
            self.tableVu.reloadData()
            self.tableVu.isHidden = false
            setUpViewWillAppear()
            self.loadNotificationsFeedOnDashboard()
        } else {
            UserDefaults.standard.set(false, forKey: "SETTING_IOS")
            UserDefaults.standard.synchronize()
            SwiftFTUtils.showHUDAdded(to: view, withText: "Loading...", animated: true)
            
            HLApiManager.getHomeApi { response, error in
                if let response = response {
                    
                    SwiftFTUtils.hideHUDAdded(to: self.view, animated: false)
                    
                    if let children = response.children {
                        for child in children {
                            
                            let subscription_package = child.package
                            if subscription_package != nil {
                                UserDefaults.standard.setValue(subscription_package, forKey: UserDefaultsConstants.BILLING_STATUS)
                                UserDefaults.standard.synchronize()
                            } else {
                                UserDefaults.standard.setValue(nil, forKey: UserDefaultsConstants.BILLING_STATUS)
                                UserDefaults.standard.synchronize()
                            }
                            DBManager.shared.saveChildren(children: children)
                            let lockStatus = UserDefaults.standard.string(forKey: UserDefaultsConstants.PHONE_LOCKED)
                            let childID = Int32(child.childID ?? 0)
                            let packageID = Int32(child.planID ?? 0)
                            let device = child.device ?? ""
                            let package = child.package ?? ""
                            self.savePackageIdInDatabase(childId: childID, packageId: packageID, device: device, package: package)
                            self.package_id = CoreDataUtility.fetchPackageIdFor(child_id: Int32(child.childID ?? 0))
                            self.package_name = CoreDataUtility.fetchPackageNameFor(child_id: Int32(child.childID ?? 0))
                            self.devicePackage = CoreDataUtility.fetchPackageDeviceFor(child_id: Int32(child.childID ?? 0))
                            if lockStatus == StringConstants.Constants.PAUSED {
                                UserDefaults.standard.set(StringConstants.Constants.UNLOCKED, forKey: UserDefaultsConstants.PHONE_LOCKED)
                                UserDefaults.standard.synchronize()
                                self.tableVu.reloadData()
                            } else if lockStatus == StringConstants.Constants.UNLOCKED {
                                UserDefaults.standard.set(StringConstants.Constants.PAUSED, forKey: UserDefaultsConstants.PHONE_LOCKED)
                                UserDefaults.standard.synchronize()
                                self.tableVu.reloadData()
                            }
                            
                        }
                        
                        let count = children.count
                        UserDefaults.standard.set(count, forKey: UserDefaultsConstants.CHILD_COUNT)
                        UserDefaults.standard.synchronize()
                        
                        self.childrenArray = children
                        self.tableVu.isHidden = false
                        self.tableVu.reloadData()
                        self.setUpViewWillAppear()
                        self.loadNotificationsFeedOnDashboard()
                    }
                } else {
                    //                    SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
                    if let error = error {
                        let errorMessage = error.localizedDescription
                        CommonModel.showAlert("Error!".myModification(), msg: errorMessage)
                    } else {
                        CommonModel.showAlert("Error!".myModification(), msg: "Unknown error occurred")
                    }
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.setFamilyMapEnable()
        }
    }
    
    private func didSetTableViewNibCells(){
        tableVu.register(UINib(nibName: "FamilyFeedTableViewCell", bundle: nil), forCellReuseIdentifier: "FamilyFeedTableViewCell")
        tableVu.register(UINib(nibName: NibConstants.Names.UPGRADE_CELL, bundle: nil), forCellReuseIdentifier: NibConstants.Identifiers.UPGRADE_CELL)
        tableVu.register(UINib(nibName: NibConstants.Names.QR_CODE_CELL, bundle: nil), forCellReuseIdentifier: NibConstants.Identifiers.QR_CODE_CELL)
        tableVu.register(UINib(nibName: NibConstants.Names.INSTRUCTIONS_CELL, bundle: nil), forCellReuseIdentifier: NibConstants.Identifiers.INSTRUCTIONS_CELL)
        tableVu.register(UINib(nibName: NibConstants.Names.EMAIL_VERIFIED_CELL, bundle: nil), forCellReuseIdentifier: NibConstants.Identifiers.EMAIL_VERIFIED_CELL)
        viewDetailsTitle = StringConstants.Constants.VIEW_DETAILED_GUIDE
        UserDefaults.standard.set(StringConstants.Constants.VIEW_DETAILED_GUIDE, forKey: UserDefaultsConstants.I_HAVE_DONE_INSTRUCTIONS)
        UserDefaults.standard.synchronize()
    }
    
    func addShadow(_ view : UIView){
        view.layer.shadowOffset = CGSize(width:0, height:0)
        view.layer.shadowRadius = 3
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOpacity = 0.3
    }
    
    ///Generate New Core2 Token
    private func generateNewCore2Token(){
        if UserDefaultsManager.bearerTokenCore2 == nil {
            HLApiManager.tokenGeneraterNetworkCallCore2 { response, error in
                if response != nil {
                    if let token = response {
                        UserDefaultsManager.bearerTokenCore2 = token
                    }
                } else {
                    print(StringConstants.Errors.CORE2_TOKEN_NOT_FOUND, error ?? StringConstants.Constants.NIL_VALUE)
                }
            }
        } else {
            print(StringConstants.Constants.TOKEN_ALREADY_EXIST)
        }
    }
    ///ACOUNT API CALL
    private func accountApiData(token: String){
        SwiftFTUtils.showHUDAdded(to: view, withText: "Reloading...".localized, animated: true)
        HLApiManager.accountApiFunc(token: token) { response, error in
            SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
            if response != nil {
                UserDefaults.standard.removeObject(forKey: UserDefaultsConstants.PRODUCT_ACCOUNT_ARRAY)
                UserDefaults.standard.synchronize()
                self.productArr.removeAll()
                self.profileObject = response?.profile
                let accountDeleted = response?.profile?.deleted
                UserDefaults.standard.setValue(accountDeleted, forKey: "isAccDeleted")
                self.subscriptionData = response?.billing?.subscriptions
                if let emailVerifiedAt = response?.profile?.emailVerifiedAt {
                    UserDefaults.standard.setValue(emailVerifiedAt, forKey: UserDefaultsConstants.EMAIL_VERIFIED_AT_ACCOUNT)
                    UserDefaults.standard.synchronize()
                } else {
                    UserDefaults.standard.setValue(nil, forKey: UserDefaultsConstants.EMAIL_VERIFIED_AT_ACCOUNT)
                    UserDefaults.standard.synchronize()
                }
                
                if let emailBounce = response?.profile?.emailBounce {
                    UserDefaults.standard.set(emailBounce, forKey: UserDefaultsConstants.EMAIL_BOUNCE_ACCOUNT)
                    UserDefaults.standard.synchronize()
                } else {
                    UserDefaults.standard.setValue(nil, forKey: UserDefaultsConstants.EMAIL_BOUNCE_ACCOUNT)
                    UserDefaults.standard.synchronize()
                }
                
                if let emailComplaint = response?.profile?.emailComplaint {
                    UserDefaults.standard.setValue(emailComplaint, forKey: UserDefaultsConstants.EMAIL_COMPLAINT_ACCOUNT)
                    UserDefaults.standard.synchronize()
                } else {
                    UserDefaults.standard.setValue(nil, forKey: UserDefaultsConstants.EMAIL_COMPLAINT_ACCOUNT)
                    UserDefaults.standard.synchronize()
                }
                
                let userLanguage = response?.profile?.language
                if(userLanguage != nil){
                    UserDefaults.standard.set(userLanguage, forKey: UserDefaultsConstants.USER_LANGUAGE)
                } else {
                    UserDefaults.standard.set(NSLocale.current.languageCode, forKey: UserDefaultsConstants.USER_LANGUAGE)
                }
                let id = response?.profile?.id
                if (id != nil){
                    AppDelegateShared().userDefault.set(id, forKey: UserDefaultsConstants.USER_ID)
                    AppDelegateShared().userDefault.synchronize()
                } else {
                    AppDelegateShared().userDefault.set(StringConstants.Constants.EMPTY_STRING, forKey: UserDefaultsConstants.USER_ID)
                    AppDelegateShared().userDefault.synchronize()
                }
                
                let name = response?.profile?.name
                if (name != nil){
                    UserDefaults.standard.set(name, forKey: UserDefaultsConstants.USER_NAME)
                } else {
                    UserDefaults.standard.set(StringConstants.Constants.EMPTY_STRING, forKey: UserDefaultsConstants.USER_NAME)
                }
                
                let email = response?.profile?.email
                if (email != nil){
                    UserDefaults.standard.set(email, forKey: UserDefaultsConstants.USER_EMAIL)
                    AppDelegateShared().userDefault.set(email, forKey: UserDefaultsConstants.USER_EMAIL)
                    AppDelegateShared().userDefault.synchronize()
                } else {
                    UserDefaults.standard.set(StringConstants.Constants.EMPTY_STRING, forKey: UserDefaultsConstants.USER_EMAIL)
                    AppDelegateShared().userDefault.set(StringConstants.Constants.EMPTY_STRING, forKey: UserDefaultsConstants.USER_EMAIL)
                    AppDelegateShared().userDefault.synchronize()
                }
                
                let phone = response?.profile?.phone
                if (phone != nil){
                    UserDefaults.standard.set(phone, forKey: UserDefaultsConstants.USER_PHONE)
                } else {
                    UserDefaults.standard.set(StringConstants.Constants.EMPTY_STRING, forKey: UserDefaultsConstants.USER_PHONE)
                }
                
                let package = response?.profile?.package
                if package != nil {
                    UserDefaults.standard.set(package, forKey: UserDefaultsConstants.BILLING_STATUS)
                } else {
                    UserDefaults.standard.set(StringConstants.Constants.EMPTY_STRING, forKey: UserDefaultsConstants.BILLING_STATUS)
                }
                
                let gender = response?.profile?.gender
                if (gender != nil) {
                    UserDefaults.standard.set(gender, forKey: UserDefaultsConstants.USER_GENDER)
                    if gender == StringConstants.Constants.MALE {
                        UserDefaults.standard.set(StringConstants.Constants.FATHER, forKey: UserDefaultsConstants.USER_RELATION)
                    } else {
                        UserDefaults.standard.set(StringConstants.Constants.MOTHER, forKey: UserDefaultsConstants.USER_RELATION)
                    }
                } else {
                    UserDefaults.standard.set(StringConstants.Constants.FATHER, forKey: UserDefaultsConstants.USER_RELATION)
                    UserDefaults.standard.set(StringConstants.Constants.EMPTY_STRING, forKey: UserDefaultsConstants.USER_GENDER)
                }
                
                let type = response?.profile?.type
                if (type != nil){
                    UserDefaults.standard.set(type, forKey: UserDefaultsConstants.USER_TYPE)
                } else {
                    UserDefaults.standard.set(StringConstants.Constants.EMPTY_STRING, forKey: UserDefaultsConstants.USER_TYPE)
                }
                if let subs = response?.billing?.subscriptions {
                    for value in subs {
                        let product = value.psp ?? StringConstants.Constants.EMPTY_STRING
                        self.productArr.append(product)
                        UserDefaults.standard.set(self.productArr, forKey: UserDefaultsConstants.PRODUCT_ACCOUNT_ARRAY)
                        UserDefaults.standard.set(value.endDate, forKey: UserDefaultsConstants.SUBSCRIPTION_RENEWAL_DATE)
                        UserDefaults.standard.synchronize()
                        //                        CoreDataUtility.saveSubscriptionData(subs: value)
                    }
                }
                //                SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
                self.refreshControl.endRefreshing()
                self.tableVu.reloadData()
            } else {
                self.refreshControl.endRefreshing()
                if error == "Unauthenticated." {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        CommonModel.clearDataAndLogout(on: self, isPresentedVC: false)
                    }
                }
                print(StringConstants.Errors.APP_CONFIG_NOT_FOUND,error ?? StringConstants.Constants.NIL_VALUE)
            }
        }
    }
    
    private func appConfigurations(){
        HLApiManager.appConfigurationsNetworkCallCore2 { response, error in
            if response != nil {
                self.configurationArray = response?.configurations ?? [Configuration]()
                if let configurations = self.configurationArray {
                    for config in configurations {
                        ///Saving configurations record in Database
                        CoreDataUtility.savePremiumPackageDetails(data: config)
                        let config_name = config.configName
                        let config_value = config.keyValue
                        let keyValue = Int(config_value ?? "")
                        if config_name != nil && config_name == StringConstants.Constants.SHOPPING_FUNNEL {
                            UserDefaults.standard.setValue(keyValue?.boolValue, forKey: UserDefaultsConstants.SHOPPING_FUNNEL_VALUE)
                            UserDefaults.standard.setValue(config_name, forKey: UserDefaultsConstants.SHOPPING_FUNNEL_NAME)
                            UserDefaults.standard.synchronize()
                        } else if config_name != nil && config_name == StringConstants.Constants.ACTIVATION_FUNNEL {
                            if config_value != "0" {
                                self.activationFunnel = true
                                self.isScanning = true
                            } else {
                                self.activationFunnel = false
                                self.isScanning = false
                            }
                            UserDefaults.standard.setValue(config_value, forKey: UserDefaultsConstants.ACTIVATION_FUNNEL)
                            UserDefaultsManager.AddChildWithQRScan = keyValue?.boolValue ?? false
                            UserDefaults.standard.synchronize()
                        } else if config_name != nil && config_name == StringConstants.Constants.UPDRADE_SUB_EXTERNAL {
                            UserDefaults.standard.set(config_name, forKey: UserDefaultsConstants.UPDRADE_SUB_EXTERNAL)
                            UserDefaults.standard.synchronize()
                        } else if config_name != nil && config_name == StringConstants.Constants.UPGRADE_SUB_INTERNAL {
                            UserDefaults.standard.set(config_name, forKey: UserDefaultsConstants.UPGRADE_SUB_INTERNAL)
                            UserDefaults.standard.synchronize()
                        } else if config_name != nil && config_name == StringConstants.Constants.APPLE_TRIAL_INT {
                            UserDefaults.standard.set(config_name, forKey: UserDefaultsConstants.APPLE_TRIAL_INT)
                            UserDefaults.standard.synchronize()
                        } else if config_name != nil && config_name == StringConstants.Constants.FAST_SPRING_TRIAL_EXT {
                            UserDefaults.standard.set(config_name, forKey: UserDefaultsConstants.FAST_SPRING_TRIAL_EXT)
                            UserDefaults.standard.synchronize()
                        } else {
                            print(StringConstants.Errors.DO_NOTHING)
                        }
                    }
                }
            } else {
                if error == "Unauthenticated." {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        CommonModel.clearDataAndLogout(on: self, isPresentedVC: false)
                    }
                }
                //print(StringConstants.Errors.APP_CONFIG_NOT_FOUND,error ?? StringConstants.Constants.NIL_VALUE)
            }
        }
    }
    
    private func movetoSecondScreen() {
        let storyboard = UIStoryboard(name: StoryboardConstants.Storyboards.AUTH, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: StoryboardConstants.Identifiers.DETAILED_INSTRUCTIONS_VC_IDENTIFIER) as! DetailedInstructionsScreenController
        self.navigationController?.pushViewController(vc, animated: true)
        UserDefaultsManager.ChildAdded = false
    }
    
    private func locationSetup(){
        parentLatitude  = ""
        parentLongitude = ""
        if locationManager == nil {
            locationManager = CLLocationManager()
        }
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.startUpdatingLocation()
    }
    
    private func loadNotificationsFeedOnDashboard(){
        _ = [NotificationFeeds]()
        print("currentThreead:",Thread.current)
        DispatchQueue.global(qos: .background).async {
            print("currentThreead:",Thread.current)
            //            HLApiManager.loadNotificationsApi() { [weak self] (response, status, message) in
            //                if response == nil {return}
            //                if let response = response {
            //                    if(status == 200 || status == 201 || status == 202 || status == 204 || status == 206){
            //                        print(response)
            //                        if let feed_data = response[StringConstants.ResponseKeys.FEED_DATA] as? [[String:Any]] {
            //                            var eurl = ""
            //                            if let url = response[StringConstants.ResponseKeys.ENCODED_URL] as? String {
            //                                eurl = url
            //                            }
            //                            print(feed_data)
            //                            print(eurl)
            //                            for dict in feed_data {
            //                                //                        let id1 = info["id"] as? Int
            //                                //                        let newFeedId = info["news_feeds_id"] as? Int
            //                                //                        let name1 = info["name"] as? String
            //                                let info = dict
            //                                let freuency = info[StringConstants.ResponseKeys.FREQUENCY] as? Int
            //                                UserDefaults.standard.set(freuency, forKey: "FREQUENCY_DATA")
            //                                var feed_id,web_cta,dashboard_sub_url,paddle_sub_url,fs_sub_url,apple_in_app_sub_id,google_in_app_sub_id,trigger_point,title_color,title,time_color,start_date,sort_order,read_more_color,platform_id,notification_type,limit,lang,is_active,image_url,feed_snippet_color,feed_snippet,feed_data,end_date,customer_criteria,card_color,billing_status,action_text : String?
            //                                let uid =  info[StringConstants.ResponseKeys.ID] as? Int64 ?? 0
            //                                let actionText =  info[StringConstants.ResponseKeys.ACTION_TEXT] as? String ?? ""
            //                                let billingStatus =  info[StringConstants.ResponseKeys.BILLING_STATUS] as? String ?? ""
            //                                let cardColor =  info[StringConstants.ResponseKeys.CARD_COLOR] as? String ?? ""
            //                                let customerCriteria = info[StringConstants.ResponseKeys.CUSTOMER_CRITERIA] as? Int64 ?? 0
            //                                let endDate = info[StringConstants.ResponseKeys.END_DATE] as? String ?? ""
            //                                let feedData =  info[StringConstants.ResponseKeys.FEED_DATA] as? String ?? ""
            //                                let sortOrder =  info[StringConstants.ResponseKeys.SORT_ORDER] as? Int64 ?? 0
            //                                let feedSnippet =  info[StringConstants.ResponseKeys.FEED_SNIPPET] as? String ?? ""
            //                                let feedSnippetColor = info[StringConstants.ResponseKeys.FEED_SNIPPET_COLOR] as? String ?? ""
            //                                let imageURL =  info[StringConstants.ResponseKeys.IMAGE_URL] as? String
            //                                let isActive =  info[StringConstants.ResponseKeys.IS_ACTIVE] as? Int64 ?? 0
            //                                let language =  info[StringConstants.ResponseKeys.LANG] as? String ?? ""
            //                                let daysLimit =  info[StringConstants.ResponseKeys.LIMIT] as? Int64 ?? 0
            //                                let notificationType =  info[StringConstants.ResponseKeys.NOTIFICATION_TYPE] as? String ?? ""
            //                                let platformID =  info[StringConstants.ResponseKeys.PLATFORM_ID] as? String ?? ""
            //                                let readMoreColor =  info[StringConstants.ResponseKeys.READ_MORE_COLOR] as? String ?? ""
            //                                let startDate =  info[StringConstants.ResponseKeys.START_DATE] as? String ?? ""
            //                                let timeColor =  info[StringConstants.ResponseKeys.TIME_COLOR] as? String ?? ""
            //                                let titleFor =  info[StringConstants.ResponseKeys.TITLE] as? String ?? ""
            //                                let titleColor =  info[StringConstants.ResponseKeys.TITLE_COLOR] as? String ?? ""
            //                                let googleInAppSubId =  info[StringConstants.ResponseKeys.GOOGLE_IN_APP_SUB_ID] as? String ?? ""
            //                                let appleInAppSubId =  info[StringConstants.ResponseKeys.APPLE_IN_APP_SUB_ID] as? String ?? ""
            //                                let fsSubURL =  info[StringConstants.ResponseKeys.FS_SUB_URL] as? String ?? ""
            //                                let paddleSubURL =  info[StringConstants.ResponseKeys.PADDLE_SUB_URL] as? String ?? ""
            //                                let subURL =  info[StringConstants.ResponseKeys.DASHBOARD_SUB_URL] as? String ?? ""
            //                                let webCTA =  info[StringConstants.ResponseKeys.WEB_CTA] as? String ?? ""
            //                                //                        let packageName =  info["packageName"] as? String ?? ""
            //                                //                        let coupon_code =  info["couponCode"] as? String ?? ""
            //                                feed_id = String(uid)
            //                                action_text = actionText
            //                                billing_status = billingStatus
            //                                card_color = cardColor
            //                                customer_criteria = String(customerCriteria)
            //                                end_date = endDate
            //                                feed_data = feedData
            //                                sort_order = String(sortOrder)
            //                                feed_snippet = feedSnippet
            //                                feed_snippet_color = feedSnippetColor
            //                                image_url = imageURL
            //                                is_active = String(isActive)
            //                                lang = language
            //                                limit = String(daysLimit)
            //                                notification_type = notificationType
            //                                platform_id = platformID
            //                                read_more_color = readMoreColor
            //                                start_date = startDate
            //                                time_color = timeColor
            //                                title = titleFor
            //                                title_color = titleColor
            //                                google_in_app_sub_id = googleInAppSubId
            //                                apple_in_app_sub_id = appleInAppSubId
            //                                fs_sub_url = fsSubURL
            //                                paddle_sub_url = paddleSubURL
            //                                dashboard_sub_url = subURL
            //                                web_cta = webCTA
            //                                let obj = NotificationFeeds(feed_id:feed_id,action_text:action_text,billing_status:billing_status,card_color:card_color,customer_criteria:customer_criteria,end_date:end_date,feed_data:feed_data,feed_snippet:feed_snippet,feed_snippet_color:feed_snippet_color,image_url:image_url,is_active:is_active,lang:lang,limit:limit,notification_type:notification_type,platform_id:platform_id,read_more_color:read_more_color,sort_order:sort_order,start_date:start_date,time_color:time_color,title:title,title_color:title_color,trigger_point:trigger_point,google_in_app_sub_id: google_in_app_sub_id,apple_in_app_sub_id: apple_in_app_sub_id,fs_sub_url: fs_sub_url,paddle_sub_url: paddle_sub_url,dashboard_sub_url: dashboard_sub_url, web_cta: web_cta)
            //                                if imageURL != nil || imageURL != "" {
            //                                    DispatchQueue.main.async { [weak self] in
            //                                        self?.tableVu.reloadData()
            //                                    }
            //
            //                                }
            //                                feedsArray.append(obj)
            //                                if feedsArray.count > 0 {
            //                                    self?.notifObj = feedsArray[0]
            //                                    UserDefaults.standard.setValue(self?.notifObj.web_cta, forKey: "web_cta")
            //                                    UserDefaults.standard.setValue(self?.notifObj.dashboard_sub_url, forKey: "dashboard_sub_url")
            //                                    UserDefaults.standard.setValue(self?.notifObj.paddle_sub_url, forKey: "paddle_sub_url")
            //                                    UserDefaults.standard.setValue(self?.notifObj.fs_sub_url, forKey: "fs_sub_url")
            //                                    if UserDefaults.standard.bool(forKey: "HasLaunchedOnce") == false {
            //                                        UserDefaults.standard.setValue(true, forKey: "HasLaunchedOnce")
            //                                        DispatchQueue.main.async { [weak self] in
            //                                            self?.goToNotificationDetail()                                    }
            //                                    }
            //                                }
            //                            }
            //                        }
            //                    } else {
            //                        DispatchQueue.main.async { [weak self] in
            //                            self?.tableVu.reloadData()
            //                        }
            //                    }
            //                } else {
            //                    if message == "Unauthenticated." {
            //                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            //                            CommonModel.clearDataAndLogout(on: self, isPresentedVC: false)
            //                        }
            //                    }
            //                    print(StringConstants.Errors.SOMETHING_WENT_WRONG)
            //                }
            //            }
        }
    }
    
    private func goToNotificationDetail() {
        let storyBoard: UIStoryboard = UIStoryboard(name: StoryboardConstants.Storyboards.DASHBOARD, bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "goToNotificationDetail") as! UINavigationController
        notificationDataGlobal = self.notifObj
        newViewController.modalPresentationStyle = .overFullScreen
        present(newViewController, animated: true, completion: nil)
    }
    
    private func savePackageIdInDatabase(childId:Int32, packageId:Int32, device:String, package:String) {
        CoreDataUtility.savePackageIdInDatabase(childId: childId, packageId: packageId, device: device, package: package)
    }
    
    private func setFamilyMapEnable() {
        if childrenArray.count > 0 {
            for child in childrenArray {
                if child.active == 0 {
                    UserDefaults.standard.set(false, forKey: UserDefaultsConstants.FAMILY_MAP_ENABLE)
                    self.familymapEnable = false
                } else {
                    UserDefaults.standard.set(true, forKey: UserDefaultsConstants.FAMILY_MAP_ENABLE)
                    self.familymapEnable = true
                    break
                }
            }
        }
        UserDefaults.standard.synchronize()
    }
    
    private func handleHowToInstall() {
        ///Userlanguage
        let prefs = UserDefaults.standard
        // getting an NSString
        let userlanguage = prefs.string(forKey: "userlanguage") ?? ""
        var myString: String? = nil
        if userlanguage == "en" || userlanguage == "he" || userlanguage == "tr" {
            myString = "https://familytime.io/how-to-install/familytime-child-app.html?utm_source=dashboard&amp;utm_medium=ios&amp;utm_campaign=ActivateChild"
        } else {
            myString = "https://familytime.io/\(userlanguage)/how-to-install/familytime-child-app.html?utm_source=dashboard&amp;utm_medium=ios&amp;utm_campaign=ActivateChild"
        }
        open(scheme: myString ?? "")
    }
    
    private func open(scheme: String) {
        if let url = URL(string: scheme){
            if #available(iOS 10, *){
                UIApplication.shared.open(url, options: [:], completionHandler: {
                    (success) in
                })
            } else {
                let success = UIApplication.shared.openURL(url)
                print(success)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                self.viewDetailsTitle = StringConstants.Constants.YES_I_HAVE_DONE_IT
                UserDefaults.standard.set(StringConstants.Constants.YES_I_HAVE_DONE_IT, forKey: UserDefaultsConstants.I_HAVE_DONE_INSTRUCTIONS)
                UserDefaults.standard.synchronize()
                self.tableVu.reloadData()
            }
        }
    }
    
    private func getEmailVerification(){
        let hitAPI = UserDefaults.standard.bool(forKey: UserDefaultsConstants.HIT_EMAIL_VERIFICATOIN_API)
        if hitAPI {
            HLApiManager.networkCallEmailVerification { response, error in
                if response != nil {
                    self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
                    let alert = UIAlertController(title: StringConstants.Constants.VERIFY_YOUR_EMAIL, message: StringConstants.Constants.VERIFICATION_EMAIL_IS_SENT, preferredStyle: .alert)
                    let action = UIAlertAction(title: "ok", style: .default) {_ in
                        UserDefaults.standard.set(false, forKey: UserDefaultsConstants.HIT_EMAIL_VERIFICATOIN_API)
                        UserDefaults.standard.synchronize()
                    }
                    alert.addAction(action)
                    self.present(alert, animated: true)
                } else {
                    print("Error!", error ?? "nil")
                }
            }
        } else {
            let alert = UIAlertController(title: StringConstants.Constants.VERIFY_YOUR_EMAIL, message: StringConstants.Constants.VERIFICATION_EMAIL_IS_SENT, preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default){ action in
            }
            alert.addAction(action)
            self.present(alert, animated: true)
        }
    }
    
    private func getEmailBounce(){
        HLApiManager.networkCallEmailBounce { response, error in
            if response != nil {
                let alert = UIAlertController(title: "Alert", message: StringConstants.Constants.CHANGES_ARE_SENT, preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default)
                alert.addAction(action)
                self.present(alert, animated: true)
            } else {
                let alert = UIAlertController(title: "Error!", message: error ?? "Nil", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default)
                alert.addAction(action)
                self.present(alert, animated: true)
            }
        }
    }
    
    private func getEmailComplaint(){
        HLApiManager.networkCallEmailComplaint { response, error in
            if response != nil {
                let alert = UIAlertController(title: "Alert", message: StringConstants.Constants.CHANGES_ARE_SENT, preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default)
                alert.addAction(action)
                self.present(alert, animated: true)
            } else {
                let alert = UIAlertController(title: "Error!", message: error ?? "Nil", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default)
                alert.addAction(action)
                self.present(alert, animated: true)
            }
        }
    }
    
    private func goToParentProfileScreen(){
        let storyboardName = StoryboardConstants.Storyboards.MY_STORYBOARD
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: StoryboardConstants.Identifiers.PARENT_PROFILE_VC_IDENTIFIER)
        delegate?.centerNavController = UINavigationController(rootViewController: vc)
        delegate?.jasidePanel.centerPanel = delegate?.centerNavController
    }
    
    func shareAppLink() {
        // Replace 'yourAppLink' with the actual App Store link to your app.
        let appLink = "https://store.familytime.io/"
        let items: [Any] = [appLink]
        let activityViewController = UIActivityViewController(
            activityItems: items,
            applicationActivities: nil
        )
        // Exclude specific sharing options if needed
        activityViewController.excludedActivityTypes = [
            .addToReadingList,
            .assignToContact,
            .postToVimeo,
            .openInIBooks
        ]
        // If you're on an iPad, you'll also need to specify the source view and arrow direction for the popover.
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = self.view
        }
        present(activityViewController, animated: true, completion: nil)
    }
}

// MARK: -  TableView Delegate Data Source
extension DashboardVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return section == 4 ? 60 : 0 // 60 for section 4, 15 for others
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let childCount = UserDefaults.standard.integer(forKey: UserDefaultsConstants.CHILD_COUNT)
        
        if section == 4 && childCount != 0 {
            let conView = UIView(frame: CGRect.init(x: 0, y: 0, width: Device.width, height: 60))
            conView.backgroundColor = UIColor.groupTableViewBackground
            let label = UILabel(frame: CGRect.init(x: 15, y: 0, width: conView.frame.width - 25, height: 60))
            label.backgroundColor = UIColor.groupTableViewBackground
            label.textColor = Colors.RGB(138, 138, 138, alpha: 1)
            label.font = UIFont(name: "OpenSans", size: 16.0)
            label.text = "Family Feeds"
            //            label.text = "content_filters_content_1".localized
            conView.addSubview(label)
            return conView
        } else {
            // Return a clear view for other sections
            let tview = UIView(frame: CGRect(x: 0, y: 0, width: Device.width, height: 0))
            tview.backgroundColor = .clear
            return tview
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 230
        } else if indexPath.section == 2 {
            if activationFunnel && isScanning {
                return 970
            } else {
                return 780
            }
        } else if indexPath.section == 4{
            if  combinedData.isEmpty {
                return 170 // Adjust height as needed
            }else{
                return 70
            }
            //            if !isSection4Expanded && indexPath.row == 4{
            //                return 75
            //            }else{
            //            }
        }
        else{
            if UI_USER_INTERFACE_IDIOM() == .pad {
                return 365 //325
            }
            return 270
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if let imageURL = self.notifObj.image_url {
                let package = UserDefaults.standard.string(forKey: UserDefaultsConstants.BILLING_STATUS) ?? ""
                if package != StringConstants.Subscriptions.PREMIUM_CAPITAL || package != StringConstants.Subscriptions.PREMIUM_SMALL || imageURL != "" {
                    return 1
                } else {
                    return 0
                }
            } else {
                let package = UserDefaults.standard.string(forKey: UserDefaultsConstants.BILLING_STATUS)
                if package == StringConstants.Subscriptions.PREMIUM_CAPITAL || package == StringConstants.Subscriptions.PREMIUM_SMALL {
                    return 0
                } else {
                    return 1
                }
            }
        } else if section == 1 {
            let emailVerifiedAt = UserDefaults.standard.string(forKey: UserDefaultsConstants.EMAIL_VERIFIED_AT_ACCOUNT)
            let emailComplaint = UserDefaults.standard.integer(forKey: UserDefaultsConstants.EMAIL_COMPLAINT_ACCOUNT)
            let emailBounce = UserDefaults.standard.integer(forKey: UserDefaultsConstants.EMAIL_BOUNCE_ACCOUNT)
            if emailVerifiedAt == nil || emailBounce == 1 || emailComplaint == 1 {
                return 1
            } else {
                return 0
            }
        } else if section == 2 {
            if childrenArray.count == 0 {
                return 1
            } else {
                return 0
            }
        } else if section == 3 {
            return childrenArray.count
        }else{
            let childCount = UserDefaults.standard.integer(forKey: UserDefaultsConstants.CHILD_COUNT)

            return childCount == 0 ? 0 : combinedData.isEmpty ? 1 : (isSection4Expanded ? combinedData.count : min(combinedData.count, 5))
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let upgradeCell = tableView.dequeueReusableCell(withIdentifier: NibConstants.Identifiers.UPGRADE_CELL) as! UpgradeTableViewCell
            upgradeCell.selectionStyle = .none
            upgradeCell.promotionView.layer.cornerRadius = 10.0
            upgradeCell.promotionView.clipsToBounds = true
            let promoImgTab = UITapGestureRecognizer(target: self, action: #selector(imgTapGesture))
            upgradeCell.promotionView.addGestureRecognizer(promoImgTab)
            let imageURL = notifObj.image_url
            upgradeCell.setImageNotification(data: imageURL)
            upgradeCell.delegate = self
            return upgradeCell
        } else if indexPath.section == 1 {
            let emailVerifiedCell = tableView.dequeueReusableCell(withIdentifier: NibConstants.Identifiers.EMAIL_VERIFIED_CELL) as! EmailVerficationCell
            emailVerifiedCell.delegate = self
            return emailVerifiedCell
        } else if indexPath.section == 2 {
            if activationFunnel && isScanning {
                let cell = tableView.dequeueReusableCell(withIdentifier: NibConstants.Identifiers.QR_CODE_CELL) as! QRCodeCell
                let title = UserDefaults.standard.string(forKey: UserDefaultsConstants.I_HAVE_DONE_INSTRUCTIONS)
                cell.buttonTitle = title ?? ""
                cell.setUpUI(title: title ?? "")
                cell.qrCellDelegate = self
                cell.shareTapp = {
                    self.shareAppLink()
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: NibConstants.Identifiers.INSTRUCTIONS_CELL) as! InstructionsCell
                let title = UserDefaults.standard.string(forKey: UserDefaultsConstants.I_HAVE_DONE_INSTRUCTIONS)
                cell.buttonTitle = title ?? ""
                cell.setUpUI(title: title ?? "")
                cell.instructionDelegate = self
                cell.shareTapp = {
                    self.shareAppLink()
                }
                return cell
            }
        } else if indexPath.section == 3{
            let activeCell = tableView.dequeueReusableCell(withIdentifier: NibConstants.Identifiers.DASH_BOARD_ACTIVE_CELL) as? SwiftDashboardActiveCell ?? SwiftDashboardActiveCell()
            activeCell.cellDelegate  = self
            let newChild = childrenArray[indexPath.row]
            print(newChild)
            activeCell.setChild(newChild)
            activeCell.newChildData = newChild
            activeCell.cellIndexPath = indexPath
            return activeCell
        }else {
            let childCount = UserDefaults.standard.integer(forKey: UserDefaultsConstants.CHILD_COUNT)

            if indexPath.section == 4 && childCount != 0 {
                if combinedData.isEmpty {
                    // Dequeue the cell to display the image view
                    let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyStateCell") ?? UITableViewCell(style: .default, reuseIdentifier: "EmptyStateCell")
                    cell.isUserInteractionEnabled = false
                    cell.selectionStyle = .none
                    // Remove any existing subviews
                    cell.contentView.subviews.forEach { $0.removeFromSuperview() }
                    
                    // Create and configure the image view
                    let imageView = UIImageView()
                    imageView.translatesAutoresizingMaskIntoConstraints = false
                    imageView.contentMode = .scaleAspectFit
                    imageView.image = UIImage(named: "emptyFeed") // Set your image here
                    cell.contentView.addSubview(imageView)
                    
                    // Create and configure the labels
                    let firstLabel = UILabel()
                    firstLabel.translatesAutoresizingMaskIntoConstraints = false
                    firstLabel.text = "No Feeds Yet!"
                    firstLabel.textAlignment = .center
                    firstLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
                    cell.contentView.addSubview(firstLabel)
                    
                    let secondLabel = UILabel()
                    secondLabel.translatesAutoresizingMaskIntoConstraints = false
                    secondLabel.text = "Check out your Family Feed here!"
                    secondLabel.textAlignment = .center
                    secondLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
                    secondLabel.textColor = UIColor.systemGray
                    cell.contentView.addSubview(secondLabel)
                    
                    // Center the image view
                    NSLayoutConstraint.activate([
                        imageView.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
                        imageView.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor, constant: -30),
                        imageView.widthAnchor.constraint(equalToConstant: 90),
                        imageView.heightAnchor.constraint(equalToConstant: 70)
                    ])
                    
                    // Position the labels below the image view
                    NSLayoutConstraint.activate([
                        firstLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 15),
                        firstLabel.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
                        
                        secondLabel.topAnchor.constraint(equalTo: firstLabel.bottomAnchor, constant: 10),
                        secondLabel.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor)
                    ])
                    cell.contentView.layoutIfNeeded()
                    return cell
                } else if !isSection4Expanded && indexPath.row == 4 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ShowMoreButtonCell") ?? UITableViewCell(style: .default, reuseIdentifier: "ShowMoreButtonCell")
                    
                    cell.selectionStyle = .none
                    
                    // Create and configure the button
                    let showMoreButton = UIButton(type: .system)
                    showMoreButton.setTitle("Show More", for: .normal)
                    showMoreButton.tintColor = .darkGray
                    showMoreButton.setTitleColor(.darkGray, for: .normal)
                    showMoreButton.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
                    showMoreButton.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1) // Lighter background color
                    showMoreButton.layer.cornerRadius = 15 // Capsule shape
                    
                    // Set custom image and position it on the right side
                    showMoreButton.setImage(UIImage(named: "down"), for: .normal)
                    showMoreButton.semanticContentAttribute = .forceRightToLeft
                    
                    // Add padding between the text and the image
                    showMoreButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -10)
                    
                    showMoreButton.addTarget(self, action: #selector(showMoreTapped), for: .touchUpInside)
                    showMoreButton.translatesAutoresizingMaskIntoConstraints = false
                    cell.contentView.addSubview(showMoreButton)
                    
                    // Create and add a transparent overlay view
                    //                    let transparentOverlay = UIView()
                    //                    transparentOverlay.backgroundColor = .clear
                    //                    transparentOverlay.isUserInteractionEnabled = false
                    //                    transparentOverlay.translatesAutoresizingMaskIntoConstraints = false
                    //                    cell.contentView.addSubview(transparentOverlay)
                    //
                    //                    // Constraints for overlay view
                    //                    NSLayoutConstraint.activate([
                    //                        transparentOverlay.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
                    //                        transparentOverlay.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
                    //                        transparentOverlay.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                    //                        transparentOverlay.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor)
                    //                    ])
                    
                    // Center the button
                    NSLayoutConstraint.activate([
                        showMoreButton.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
                        showMoreButton.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                        showMoreButton.heightAnchor.constraint(equalToConstant: 30),
                        showMoreButton.widthAnchor.constraint(equalToConstant: 120)
                    ])
                    
                    return cell
                } else {
                    let feedCell = tableView.dequeueReusableCell(withIdentifier: "FamilyFeedTableViewCell") as? FamilyFeedTableViewCell ?? FamilyFeedTableViewCell()
                    let item = combinedData[indexPath.row]
                    let (title, subtitle, miniSubtitle, hideMiniImageView, hideSubtitleLabel, miniImage) = titleAndSubtitle(for: item)
                    feedCell.titleLabel.text = title
                    feedCell.subtitleLabel.text = subtitle
                    feedCell.miniSubtitle.text = miniSubtitle
                    feedCell.subtitleLabel.isHidden = hideSubtitleLabel
                    feedCell.miniImageView.isHidden = hideMiniImageView
                    feedCell.miniImageView.image = miniImage
                    feedCell.timeLabel.text = relativeTime(for: item.createdAt)
                    feedCell.iconImageView.image = imageForFeedItemType(item.type, subtype: item.subType)
                    return feedCell
                }
            }else {
                let feedCell = tableView.dequeueReusableCell(withIdentifier: "FamilyFeedTableViewCell") as? FamilyFeedTableViewCell ?? FamilyFeedTableViewCell()
                let item = combinedData[indexPath.row]
                let (title, subtitle, miniSubtitle, hideMiniImageView, hideSubtitleLabel, miniImage) = titleAndSubtitle(for: item)
                feedCell.titleLabel.text = title
                feedCell.subtitleLabel.text = subtitle
                feedCell.miniSubtitle.text = miniSubtitle
                feedCell.subtitleLabel.isHidden = hideSubtitleLabel
                feedCell.miniImageView.isHidden = hideMiniImageView
                feedCell.miniImageView.image = miniImage
                feedCell.timeLabel.text = relativeTime(for: item.createdAt)
                feedCell.iconImageView.image = imageForFeedItemType(item.type, subtype: item.subType)
                return feedCell
            }
        }
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        var child_ID : String = ""
//        let item = combinedData[indexPath.row]
//        if let childID = item.childID {
//            let childIDString = String(childID)
//            child_ID = childIDString
//            UserDefaults.standard.setValue(childIDString, forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
//            UserDefaults.standard.synchronize()
//        }
//        
//        if indexPath.section == 2 {
//            switch item.type {
//            case .webHistory:
//                openWebVC(childID: child_ID)
//            case .call:
//                openCallsVC(childID: child_ID)
//            case .sms:
//                openSmsVC(childID: child_ID)
//            case .contact:
//                openContactsVC(childID: child_ID)
//            case .youtube:
//                if let urlString = item.url {
//                    openYouTube(urlString, childID: child_ID)
//                }
//            case .tiktok:
//                openTikTok(item, childID: child_ID)
//            default:
//                break
//            }
//        }
//    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if indexPath.section == 3 {
            return .delete
        } else {
            return .none
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deletUser(indexPath.row)
        }
    }
    
    func openCallsVC (childID: String){
        guard let plan = getPlan(withIdentifier: "call_logs", childID: childID) else {
            return
        }
        if plan.status == 0 {
            SwiftFTUtils.showSwiftPremiumPopup(on: self)
        } else {
            let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "CallHistoryViewController") as? CallHistoryViewController ?? CallHistoryViewController()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
    }
    
    func openSmsVC (childID: String){
        guard let plan = getPlan(withIdentifier: "sms", childID: childID) else {
            return
        }
        if plan.status == 0 {
            SwiftFTUtils.showSwiftPremiumPopup(on: self)
        } else {
            let vc = TextMessagesMainViewController()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: false, completion: nil)
        }
    }
    
    func openWebVC (childID: String){
        guard let plan = getPlan(withIdentifier: "browsing_history", childID: childID) else {
            return
        }
        if plan.status == 0 {
            SwiftFTUtils.showSwiftPremiumPopup(on: self)
        } else {
            let vc = YoutubeHistroyVC()
            vc.vm.isFrom = .web
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: false, completion: nil)
        }
    }
    
    func openContactsVC (childID: String){
        guard let plan = getPlan(withIdentifier: "contacts", childID: childID) else {
            return
        }
        if plan.status == 0 {
            SwiftFTUtils.showSwiftPremiumPopup(on: self)
        } else {
            let vc = ContactsViewController(nibName: "ContactViewController", bundle: nil)
            vc.ishiddenBar = true
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: false)
        }
    }
    
    func openYouTube(_ urlString: String, childID: String) {
        guard let plan = getPlan(withIdentifier: "youtube_history", childID: childID) else {
            return
        }
        if plan.status == 0 {
            SwiftFTUtils.showSwiftPremiumPopup(on: self)
        } else {
            if let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                let appURLString = "youtube://\(encodedString)"
                if let appURL = URL(string: appURLString), UIApplication.shared.canOpenURL(appURL) {
                    UIApplication.shared.open(appURL)
                } else if let webURL = URL(string: "https://www.youtube.com/results?search_query=\(encodedString)") {
                    UIApplication.shared.open(webURL)
                }
            }
        }
    }
    
    func openTikTok(_ item: FeedItem, childID: String) {
        guard let plan = getPlan(withIdentifier: "tiktok_history", childID: childID) else {
            return
        }
        if plan.status == 0 {
            SwiftFTUtils.showSwiftPremiumPopup(on: self)
        } else {
            guard let urlString = item.url, let url = URL(string: urlString) else {
                print("Invalid URL.")
                return
            }
            if urlString.contains("tiktok.com") {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    print("Failed to open TikTok URL.")
                }
            } else {
                let searchQuery = item.title?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                let searchURLString = "https://www.tiktok.com/search?q=\(searchQuery)"
                if let searchURL = URL(string: searchURLString) {
                    if UIApplication.shared.canOpenURL(searchURL) {
                        UIApplication.shared.open(searchURL, options: [:], completionHandler: nil)
                    } else {
                        print("Failed to open TikTok search URL.")
                    }
                } else {
                    print("Failed to create TikTok search URL.")
                }
            }
        }
    }
    
    func getPlan(withIdentifier identifier: String,childID: String?) -> PlanEntity? {
        if let childIdString = childID, let childId = Int(childIdString) {
            let result = DBManager.shared.fetchChildAndPlans(byChildID: childId)
            if let plan = result.plans.first(where: { $0.identifier == identifier }) {
                return plan
            } else {
                print("Plan not found for identifier: \(identifier)")
            }
        } else {
            print("Invalid child ID")
        }
        return nil
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tableVu.refreshControl = refreshControl
    }
    
    @objc func showMoreTapped() {
        isSection4Expanded = true
        tableVu.reloadSections(IndexSet(integer: 4), with: .automatic)
    }
    
    func titleAndSubtitle(for item: FeedItem) -> (title: String, subtitle: String, miniSubtitle: String, hideMiniImageView: Bool, hideSubtitleLabel: Bool, miniImage: UIImage?) {
        switch item.type {
        case .tiktok:
            return (title: "TikTok", subtitle: "Video Watched", miniSubtitle: item.miniSubtitle ?? "", hideMiniImageView: false, hideSubtitleLabel: false, UIImage(named: "dot"))
        case .youtube:
            return (title: "YouTube", subtitle: "Video Watched", miniSubtitle: item.miniSubtitle ?? "", hideMiniImageView: false, hideSubtitleLabel: false, miniImage: UIImage(named: "dot"))
        case .webHistory:
            return (title: "Web History", subtitle: item.subTitle ?? "Visited", miniSubtitle: item.miniSubtitle ?? "", hideMiniImageView: false, hideSubtitleLabel: false, miniImage: UIImage(named: "dot"))
        case .call:
            let miniImage: UIImage?
            switch item.subType {
            case "Dialed":
                miniImage = UIImage(named: "outgoingCall")
            case "Missed":
                miniImage = UIImage(named: "missedCall")
            case "Rejected":
                miniImage = UIImage(named: "declinedCall")
            case "Received":
                miniImage = UIImage(named: "incomingCall")
            default:
                miniImage = UIImage(named: "dot")
            }
            return (title: item.title ?? "Unknown", subtitle: item.subTitle ?? "Unknown", miniSubtitle: item.miniSubtitle ?? "", hideMiniImageView: false, hideSubtitleLabel: false, miniImage: miniImage)
        case .sms:
            return (title: "Message \(item.title ?? "")", subtitle: item.subTitle ?? "Unknown", miniSubtitle: item.miniSubtitle ?? "", hideMiniImageView: false, hideSubtitleLabel: false, miniImage: UIImage(named: "sms_subicon"))
        case .contact:
            return (title: item.title ?? "", subtitle: item.subTitle ?? "Unknown", miniSubtitle: item.miniSubtitle ?? "", hideMiniImageView: true, hideSubtitleLabel: true, miniImage: nil)
        case .sos:
            return (title: item.title ?? "SOS", subtitle: item.subTitle ?? "Unknown", miniSubtitle: item.miniSubtitle ?? "", hideMiniImageView: true, hideSubtitleLabel: true, miniImage: nil)
        case .pickMeUp:
            return (title: item.title ?? "Pick Me Up", subtitle: item.subTitle ?? "Unknown", miniSubtitle: item.miniSubtitle ?? "", hideMiniImageView: true, hideSubtitleLabel: true, miniImage: nil)
        case .lowBattery:
            return (title: item.title ?? "Low Battery", subtitle: "battery at \(item.subTitle ?? "")", miniSubtitle: item.miniSubtitle ?? "", hideMiniImageView: false, hideSubtitleLabel: false, miniImage: UIImage(named: "dot"))
        case .acknowledgeBattery:
            return (title: "Acknowledged", subtitle: item.subTitle ?? "Unknown", miniSubtitle: item.miniSubtitle ?? "", hideMiniImageView: true, hideSubtitleLabel: true, miniImage: nil)
        case .powerConnected:
            return (title: item.title ?? "Power Connected", subtitle: "battery at \(item.subTitle ?? "")", miniSubtitle: item.miniSubtitle ?? "", hideMiniImageView: false, hideSubtitleLabel: false, miniImage: UIImage(named: "dot"))
//        case .place:
//            return (title: item.title ?? "Unknown", subtitle: item.subTitle ?? "Unknown", miniSubtitle: item.miniSubtitle ?? "", hideMiniImageView: true, hideSubtitleLabel: true, miniImage: nil)
        case .appApprove:
            return (title: item.title ?? "Approve New App", subtitle: item.subTitle ?? "", miniSubtitle: item.miniSubtitle ?? "", hideMiniImageView: false, hideSubtitleLabel: false, miniImage: UIImage(named: "dot"))
        case .previousAppApprove:
            return (title: item.title ?? "App Access Request", subtitle: item.subTitle ?? "", miniSubtitle: item.miniSubtitle ?? "", hideMiniImageView: false, hideSubtitleLabel: false, miniImage: UIImage(named: "dot"))
        case .sstRunning:
            return (title: item.title ?? "ScreenTime Schedule", subtitle: item.subTitle ?? "", miniSubtitle: item.miniSubtitle ?? "", hideMiniImageView: false, hideSubtitleLabel: false, miniImage: UIImage(named: "dot"))
        case .sstStopped:
            return (title: item.title ?? "ScreenTime Schedule", subtitle: item.subTitle ?? "", miniSubtitle: item.miniSubtitle ?? "", hideMiniImageView: false, hideSubtitleLabel: false, miniImage: UIImage(named: "dot"))
        case .internetScheduleRunning:
            return (title: item.title ?? "Schedule Internet", subtitle: item.subTitle ?? "", miniSubtitle: item.miniSubtitle ?? "", hideMiniImageView: true, hideSubtitleLabel: false, miniImage: UIImage(named: "dot"))
        case .internetScheduleStopped:
            return (title: item.title ?? "Schedule Internet", subtitle: item.subTitle ?? "", miniSubtitle: item.miniSubtitle ?? "", hideMiniImageView: true, hideSubtitleLabel: false, miniImage: UIImage(named: "dot"))
        case .unblockApp:
            return (title: item.title ?? "Approve Previous App", subtitle: item.subTitle ?? "", miniSubtitle: item.miniSubtitle ?? "", hideMiniImageView: false, hideSubtitleLabel: false, miniImage: UIImage(named: "dot"))
        case .uninstallApp:
            return (title: item.title ?? "App Uninstalled", subtitle: item.subTitle ?? "", miniSubtitle: item.miniSubtitle ?? "", hideMiniImageView: false, hideSubtitleLabel: false, miniImage: UIImage(named: "dot"))
        case .checkin:
            return (title: item.title ?? "Unknown", subtitle: item.subTitle ?? "Unknown", miniSubtitle: item.miniSubtitle ?? "", hideMiniImageView: false, hideSubtitleLabel: false, miniImage: UIImage(named: "dot"))
        case .checkout:
            return (title: item.title ?? "Unknown", subtitle: item.subTitle ?? "Unknown", miniSubtitle: item.miniSubtitle ?? "", hideMiniImageView: false, hideSubtitleLabel: false, miniImage: UIImage(named: "dot"))
        }
    }
    
    func imageForFeedItemType(_ type: FeedItemType,subtype: String? = nil) -> UIImage? {
        switch type {
        case .tiktok:
            return UIImage(named: "tiktok")
        case .youtube:
            return UIImage(named: "youtube")
        case .webHistory:
            return UIImage(named: "web_history")
        case .call:
            return UIImage(named: "call")
        case .sms:
            return UIImage(named: "sms")
        case .contact:
            return UIImage(named: "contacts")
        case .sos:
            return UIImage(named: "sos")
        case .pickMeUp:
            return UIImage(named: "pickmeup")
        case .lowBattery:
            return UIImage(named: "batteryLowff")
        case .acknowledgeBattery:
            return UIImage(named: "battery_acknowledged")
        case .powerConnected:
            return UIImage(named: "powerConnected")
//        case .place:
//            if let subtype = subtype {
//                switch subtype {
//                case "checkin":
//                    return UIImage(named: "checkIn")
//                case "checkout":
//                    return UIImage(named: "checkOut")
//                default:
//                    return UIImage(named: "place_default")
//                }
//            }
//            return UIImage(named: "place_default")
        case .appApprove:
            return UIImage(named: "newApp")
        case .previousAppApprove:
            return UIImage(named: "previousApp")
        case .sstRunning:
            return UIImage(named: "sst")
        case .sstStopped:
            return UIImage(named: "sst")
        case .internetScheduleRunning:
            return UIImage(named: "internetSchedule")
        case .internetScheduleStopped:
            return UIImage(named: "internetSchedule")
        case .unblockApp:
            return UIImage(named: "previousApp")
        case .uninstallApp:
            return UIImage(named: "appUninstall")
        case .checkin:
            return UIImage(named: "checkIn")
        case .checkout:
            return UIImage(named: "checkOut")
        }
    }
    func relativeTime(for dateString: String?) -> String {
        guard let dateString = dateString,
              let date = DateFormatter.customDateFormatter.date(from: dateString) else {
            return "Unknown"
        }
        
        let now = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.second, .minute, .hour, .day], from: date, to: now)
        
        if let day = components.day, day > 0 {
            return "\(day) day\(day > 1 ? "s" : "") ago"
        }
        
        if let hour = components.hour, hour > 0 {
            return "\(hour)h \(components.minute ?? 0)m ago"
        }
        
        if let minute = components.minute, minute > 0 {
            return "\(minute)m ago"
        }
        
        if let second = components.second, second > 0 {
            return "\(second)s ago"
        }
        
        return "Just now"
    }
    //    func relativeTime(for dateString: String?) -> String {
    //        guard let dateString = dateString,
    //              let date = DateFormatter.customDateFormatter.date(from: dateString) else {
    //            return "Unknown"
    //        }
    //
    //        let now = Date()
    //        let calendar = Calendar.current
    //
    //        let components = calendar.dateComponents([.second, .minute, .hour, .day], from: date, to: now)
    //
    //        if let day = components.day, day >= 1 {
    //            if let hour = components.hour, let minute = components.minute {
    //                let totalHours = (day * 24) + hour
    //                return "\(totalHours)h \(minute)m ago"
    //            }
    //            return "\(day) day\(day > 1 ? "s" : "") ago"
    //        }
    //
    //        if let hour = components.hour, hour > 0 {
    //            return "\(hour)h \(components.minute ?? 0)m ago"
    //        }
    //
    //        if let minute = components.minute, minute > 0 {
    //            return "\(minute)m ago"
    //        }
    //
    //        if let second = components.second, second > 0 {
    //            return "\(second)s ago"
    //        }
    //
    //        return "Just now"
    //    }
    
}

//MARK: - Upgrade Cell Delegates
extension DashboardVC : UpgradeCellDelegates {
    func upgradenow(){
        let storyboard = UIStoryboard(name: StoryboardConstants.Storyboards.DASHBOARD, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: StoryboardConstants.Identifiers.PREMIUM_PACKAGE_VC_IDENTIFIER) as! PremiumPackageVC
        vc.isCommingFromOtherScreens = true
        let transition = CATransition()
        transition.duration = 0.6
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromTop
        self.navigationController?.view.layer.add(transition, forKey: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - QRCode Cell Delegates
extension DashboardVC : QRCodeCellDelegates {
    func viewDetailsInstructions(){
        if viewDetailsTitle == StringConstants.Constants.VIEW_DETAILED_GUIDE {
            handleHowToInstall()
        } else {
            self.viewDetailsTitle = StringConstants.Constants.VIEW_DETAILED_GUIDE
            UserDefaults.standard.set(StringConstants.Constants.VIEW_DETAILED_GUIDE, forKey: UserDefaultsConstants.I_HAVE_DONE_INSTRUCTIONS)
            loadDataFromDataBase()
        }
    }
    
    func cantScan(){
        activationFunnel = false
        isScanning = false
        tableVu.reloadData()
    }
}

//MARK: - Instructions Cell Delegates
extension DashboardVC: InstructionCellDelegates {
    
    func detailedButtonPressed(){
        
        if viewDetailsTitle == StringConstants.Constants.VIEW_DETAILED_GUIDE {
            handleHowToInstall()
        } else {
            viewDetailsTitle = StringConstants.Constants.VIEW_DETAILED_GUIDE
            UserDefaults.standard.set(StringConstants.Constants.VIEW_DETAILED_GUIDE, forKey: UserDefaultsConstants.I_HAVE_DONE_INSTRUCTIONS)
            loadDataFromDataBase()
        }
    }
    
    func cantLoginButtonPressed(){
        activationFunnel = true
        isScanning = true
        tableVu.reloadData()
    }
}

//MARK: - EmailVerificationCell Delegates
extension DashboardVC : EmailVerificationCellDelegates {
    func changeEmailButtonPressed(){
        goToParentProfileScreen()
    }
    
    func verifyEmailButtonPressed(){
        let emailBounce = UserDefaults.standard.integer(forKey: UserDefaultsConstants.EMAIL_BOUNCE_ACCOUNT)
        let emailComplaint = UserDefaults.standard.integer(forKey: UserDefaultsConstants.EMAIL_COMPLAINT_ACCOUNT)
        let emailVerified = UserDefaults.standard.string(forKey: UserDefaultsConstants.EMAIL_VERIFIED_AT_ACCOUNT)
        let userEmail = UserDefaults.standard.string(forKey: UserDefaultsConstants.USER_EMAIL)
        if userEmail == nil || userEmail == "" {
            goToParentProfileScreen()
        } else if emailVerified == nil || emailVerified == "" {
            getEmailVerification()
        } else if emailBounce == 1 {
            getEmailBounce()
        } else if emailComplaint == 1 {
            getEmailComplaint()
        }
    }
}

// MARK: -  DashboardActiveCellDelegate
extension DashboardVC {
    func handleReports(with child: Child){
        let childID = child.childID ?? 0
        let agentStatus = child.agent ?? ""
        print(childID)
        UserDefaults.standard.setValue(childID, forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        UserDefaults.standard.synchronize()
        
        FTD.sharedInstance().isSettingsView = false
        FTD.sharedInstance().isPhoneLock    = false
        delegate?.drawerCont.contName       = "Reports"
        UserDefaults.standard.set("Reports", forKey: UserDefaultsConstants.DRAWER_TYPE)
        delegate?.drawerCont.reloadView()
        if agentStatus == "android" {
            let sb = UIStoryboard(name: StoryboardConstants.Storyboards.DASHBOARD, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: StoryboardConstants.Identifiers.SUMMERY_SCREEN_IDENTIFIER) as? SummaryViewController
            vc?.isIOS = false
            delegate?.centerNavController = UINavigationController(rootViewController: vc ?? SummaryViewController())
            delegate?.jasidePanel.centerPanel = delegate?.centerNavController
            
        } else {
            if child.package == "free"{
                SwiftFTUtils.showSwiftPremiumPopup(on: self)
            } else {
                let sb = UIStoryboard(name: StoryboardConstants.Storyboards.DASHBOARD, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: StoryboardConstants.Identifiers.SUMMERY_SCREEN_IDENTIFIER) as? SummaryViewController
                vc?.isIOS = true
                delegate?.centerNavController = UINavigationController(rootViewController: vc ?? SummaryViewController())
                delegate?.jasidePanel.centerPanel = delegate?.centerNavController
            }
        }
    }
    
    func handleSettings(with child: Child){
        //        let vc = WebBlockerVC()
        //        self.navigationController?.pushViewController(vc, animated: true)
        
        let childID = child.childID
        print(childID ?? 0)
        UserDefaults.standard.setValue(childID, forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        UserDefaults.standard.setValue(child.versionNumber, forKey: UserDefaultsConstants.SELECTED_CHILD_VERSION_NUMBER)
        UserDefaults.standard.synchronize()
        FTD.sharedInstance().isSettingsView = true
        UserDefaults.standard.set("Settings", forKey: UserDefaultsConstants.DRAWER_TYPE)
        let agentStatus = child.agent ?? ""
        
        if agentStatus == "android"{
            //            settingsCont = SettingViewController(nibName: "LeftSidePanel", bundle: nil)
            //            navigationController?.pushViewController(settingsCont ?? SettingViewController(), animated: true)
            let nibVc = ControlViewController(nibName: "ControlViewController", bundle: nil)
            nibVc.title = child.name
            navigationController?.pushViewController(nibVc, animated: true)
        } else {
            //            var sett = ControlVC()
            //            let vc = UIHostingController(rootView: sett)
            //            vc.rootView.isDiss = {
            //                vc.navigationController?.popViewController(animated: true)
            //            }
            //            vc.navigationController?.navigationItem.backBarButtonItem?.tintColor = .black
            //            settingsCont = SettingViewController(nibName: "LeftSidePanel", bundle: nil)
            //            navigationController?.pushViewController(settingsCont ?? SettingViewController(), animated: true)
            settingsContiOS = SettingIOSViewController(nibName: "LeftSidePaneliOS", bundle: nil)
            settingsContiOS?.title = child.name
            navigationController?.pushViewController(settingsContiOS ?? SettingIOSViewController(), animated: true)
        }
    }
    
    func handleUpgrade(with child: Child, indexPath: IndexPath){
        let childPackageName = self.childrenArray[indexPath.row].package
        UserDefaults.standard.set(childPackageName ?? "" , forKey: UserDefaultsConstants.SELECTED_CHILD_PACKAGE)
        UserDefaults.standard.synchronize()
        
        let storyboard = UIStoryboard(name: StoryboardConstants.Storyboards.DASHBOARD, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: StoryboardConstants.Identifiers.PREMIUM_PACKAGE_VC_IDENTIFIER) as! PremiumPackageVC
        vc.isCommingFromOtherScreens = true
        let transition = CATransition()
        transition.duration = 0.6
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromTop
        self.navigationController?.view.layer.add(transition, forKey: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func handleLock(with child: Child){
        FTD.sharedInstance().isPhoneLock    = true
        FTD.sharedInstance().isSettingsView = false
        let packageID = String(describing: child.packageID ?? 0)
        let planID = String(describing: child.planID ?? 0)
        if (planID == "1"){
            SwiftFTUtils.showSwiftPremiumPopup(on: self)
        } else {
            let isIosChild = SwiftCommonUtility.shared.isIosChild(info: packageID)
            if isIosChild {
                let childData = child
                hitLockApi(isIosChild: true, child: childData)
                
            } else {
                let childData = child
                let preference = SwiftCommonUtility.shared.getPreferenceWithName(child: childData, name: "phonelock_pin")
                let value = preference?.value ?? "0"
                print("phone lock pref = \(String(describing: value))")
                hitLockApi(isIosChild: false, child: childData)
                
            }
        }
    }
    
    func handleActiveMenu(with child: Child, with btn: UIButton?, with indexPath: IndexPath?){
        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "dashboard_child_card_drop_down_option_1".localized, style: .default, handler: { action in
            print("Profile action")
            self.handleChildProfile(with: child)
        }))
        alert.addAction(UIAlertAction(title: "dashboard_child_card_drop_down_option_2".localized, style: .default, handler: { action in
            print("Settings action")
            self.handleSettings(with: child)
        }))
        alert.addAction(UIAlertAction(title: "dashboard_child_card_drop_down_option_3".localized, style: .default, handler: { action in
            print("Delete action")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                self.deletUser(indexPath!.row)
            })
        }))
        alert.addAction(UIAlertAction(title: "cancel_button".localized, style: .default, handler: { action in
        }))
        if let presenter = alert.popoverPresentationController {
            presenter.sourceView = btn
            presenter.sourceRect = btn?.bounds ?? self.view.bounds
            presenter.permittedArrowDirections = .up
        }
        present(alert, animated: true, completion: nil)
    }
    
    func handleActivePair(with child: Child, with btn: UIButton?, with indexPath: IndexPath?){
        checkForActivation(child: child)
    }
    
    func handleChildProfile(with child: Child) {
        let vc = SwiftConstants.SwiftStoryBoard.instantiateViewController(withIdentifier: StoryboardConstants.Identifiers.CHILD_PROFILE_VC_IDENTIFIER) as? ChildProfileVC ?? ChildProfileVC()
        let childID = child.childID ?? 0
        UserDefaults.standard.set(childID, forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        UserDefaults.standard.synchronize()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func handleZeroProgress(with child: Child,status: Int) {
        if status == 0 {
            SwiftFTUtils.showSwiftPremiumPopup(on: self)
        }else{
            let vc = AndroidDailyLimitVC()
            let childID = child.childID ?? 0
            print(childID)
            UserDefaults.standard.setValue(childID, forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
            UserDefaults.standard.synchronize()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func handleProgress(with child: Child) {
        let paramUrlTuple = SwiftParamUtility.shared.getUploadDailyLimitUsageParams(child_id: child.childID ?? 0)
        ApiManager.shared().putApi(paramUrlTuple.1, params: paramUrlTuple.0, controller: self, isContPresented: false) { (message, statusCode) in
            DispatchQueue.main.async{
                if statusCode == 200{
                    //                    self.view.makeToast("dashboard_child_daily_limit_response_content".localized)
                }
                print("message = \(message) and status Code = \(statusCode)")
            }
        }
    }
    
    func handleProfileAction(with child: Child) {
        if child.active == 1 {
            self.handleChildProfile(with: child)
        }
    }
    
    func checkForActivation(child:Child){
        let agentStatus = child.agent ?? ""
        if agentStatus == "android"{
            (child.active == 1) ? self.view.makeToast("dashboard_child_card_android_pair_toast_1".localized) : self.view.makeToast("dashboard_child_card_android_pair_toast_2".localized)
        } else {
            //iOS case
            (child.childEnrolled == 1) ? self.view.makeToast("dashboard_child_card_ios_pair_toast_2".localized) : self.view.makeToast("dashboard_child_card_ios_pair_toast_1".localized)
        }
    }
    
    func handleExpired() {
    }
}

// MARK: -  User
extension DashboardVC {
    func deletUser(_ index: Int) {
        let alert = UIAlertController(title: "alert_delete_child_title".localized, message: "alert_delete_child_content".localized, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "alert_delete".localized, style: .default, handler: { action in
            self.deleteChildApiCall(index: index)
        }))
        alert.addAction(UIAlertAction(title: "cancel_button".localized, style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
    
    func transparentLayer(_ shown: Bool) {
        if !shown {
            view.addSubview(transLayer!)
        } else {
            transLayer?.removeFromSuperview()
        }
    }
    
    func setFamilyPause() {
        SwiftFTUtils.showHUDAdded(to: self.view, withText: "Requesting...".localized, animated: true)
        let control = DBManager.shared.fetchAppBlockControl(identifier: "family_pause")
        let state = control.state ?? 0
        
        if let childId = control.childID,
           let featureId = control.featureID {
            
            HLApiManager.putControlApi(childId: childId,
                                       featureId: featureId,
                                       state: state == 0 ? 1 : 0, identifier: "family_pause",
                                       value: control.value ?? "", isValue: false) { err in
                SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
                if err == nil {
                    DBManager.shared.fetchControlAndUpdate(identifier: control.identifier ?? "family_pause", state: state == 0 ? 1 : 0, value: control.value ?? "")
                    DispatchQueue.main.async {
                        self.tableVu.reloadData()
                        let alert = UIAlertController(title: "", message: "dashboard_family_pause_alert_content".localized, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "ok_button".localized, style: .default, handler: { (action: UIAlertAction!) in
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                } else {
                    CommonModel.showAlert("alert_error".localized, msg: err)
                }
            }
        } else {
            SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
            CommonModel.showAlert("alert_error".localized, msg: "alert_something_wrong_again")
            print("❌ Missing required params (childId / featureId / identifier)")
        }
    }
    
    //MARK: - API CALLS
    func hitLockApi(isIosChild:Bool, child: Child){
        UserDefaults.standard.setValue(child.childID ?? 0, forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        let getControl = DBManager.shared.fetchAppBlockControl(identifier: "family_pause")
        if (getControl.value == "" || getControl.value == nil) && !isIosChild {
            let dashboardStoryboard = UIStoryboard(name: "Dashboard", bundle: nil)
            let vc = dashboardStoryboard.instantiateViewController(withIdentifier: "PasscodePopUpViewController") as? PasscodePopUpViewController ?? PasscodePopUpViewController()
            vc.color = "red"
            vc.callback = {
                self.setFamilyPause()
            }
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true, completion: nil)
        } else {
            self.setFamilyPause()
        }
    }
    
    //MARK: Delete child
    func deleteChildApiCall(index:Int){
        let child  = childrenArray[index]
        let childId = child.childID ?? 0
        let core2URL = HLConstants.URLs.Child.deleteChildCore2 + "\(childId)"
        print(core2URL)
        SwiftFTUtils.showHUDAdded(to: view, withText: "Deleting Child...".localized, animated: true)
        HLApiManager.deleteChildNetworkCallCore2(withURL: core2URL) { isDeleted, error in
            DispatchQueue.main.async {
                SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
                if let isDeleted = isDeleted {
                    if isDeleted {
                        CoreDataUtility.delete_ChildDataFromDB(entity: "ChildrenEntity")
                        CoreDataUtility.delete_ChildDataFromDB(entity: "Children_Info")
                        CoreDataUtility.delete_ChildDataFromDB(entity: "Child_Info_Dashboard")
                        CoreDataUtility.delete_ChildDataFromDB(entity: "FamilyFeed")
                        DBManager.shared.deleteData(entityName: "FamilyFeed")
                        self.childrenArray.remove(at: index)
                        UserDefaultsManager.ChildAdded = false
                        //                        CoreManager.getFamilyFeed(isFirstTime: true)
                        self.reloadDashboardData()
                        self.tableVu.reloadData()
                    } else {
                        CommonModel.showAlert("alert_error".localized, msg: error ?? StringConstants.Constants.NIL_VALUE)
                    }
                } else {
                    print("Child is not deleted!")
                    self.reloadDashboardData()
                }
            }
        }
    }
}

// MARK: -  LocationDelegate
extension DashboardVC : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        if location != nil, !locationFound {
            SwiftCommonUtility.shared.getAdressName(coords: location ?? CLLocation()) { (add) in
                self.address = add
            }
            parentLatitude  = "\(location?.coordinate.latitude ?? 0)"
            parentLongitude = "\(location?.coordinate.longitude ?? 0)"
            print("lat = \(parentLatitude) long = \(parentLongitude) and address = \(address)")
            locationFound = true
        }
        locationManager?.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("location manager failed with error \(error.localizedDescription)")
    }
}

//MARK: - UILocal Notification Delegates
extension DashboardVC : UNUserNotificationCenterDelegate {
    private func sendLocalNotification(title:String, body:String){
        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        center.requestAuthorization(options: options) { (granted, error) in
            if !granted {
                print("error permission notification")
            }
        }
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        let request = UNNotificationRequest(identifier: "LocalNotification", content: content, trigger: trigger)
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    internal func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
}

extension DateFormatter {
    static let customDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
}

extension DashboardVC {
    
    private func setupLiveChatObserver() {
        observeRealtimeMessages()
    }
    
    private func showFloatingChatButton() {
        
        // Already exists
        
        if floatingChatButton != nil {

            floatingChatButton?.isHidden = false

            updateFloatingBadge()

            return
        }
        
        let button = UIButton(type: .custom)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.backgroundColor =
        UIColor.systemGreen
        
        button.layer.cornerRadius = 30
        
        button.clipsToBounds = false
        
        button.setImage(
            UIImage(systemName: "message"),
            for: .normal
        )
        
        button.tintColor = .white
        
        button.addTarget(
            self,
            action: #selector(floatingChatTapped),
            for: .touchUpInside
        )
        
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            
            button.widthAnchor.constraint(
                equalToConstant: 60
            ),
            
            button.heightAnchor.constraint(
                equalToConstant: 60
            ),
            
            button.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 20
            ),
            
            button.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -20
            )
        ])
        
        self.floatingChatButton = button
        
        // BADGE
        
        let badge = UILabel()
        
        badge.translatesAutoresizingMaskIntoConstraints = false
        
        badge.backgroundColor = .systemRed
        
        badge.textColor = .white
        
        badge.font = .boldSystemFont(
            ofSize: 12
        )
        
        badge.textAlignment = .center
        
        badge.layer.cornerRadius = 11
        
        badge.clipsToBounds = true
        
        button.addSubview(badge)
        
        NSLayoutConstraint.activate([
            
            badge.topAnchor.constraint(
                equalTo: button.topAnchor,
                constant: -2
            ),
            
            badge.trailingAnchor.constraint(
                equalTo: button.trailingAnchor,
                constant: 2
            ),
            
            badge.widthAnchor.constraint(
                greaterThanOrEqualToConstant: 22
            ),
            
            badge.heightAnchor.constraint(
                equalToConstant: 22
            )
        ])
        
        unreadBadgeLabel = badge
        
        updateFloatingBadge()
        
        // Floating effect
        
        view.bringSubviewToFront(button)
    }
    
    @objc
    private func floatingChatTapped() {
        openLiveChat()
    }
    
    private func updateFloatingBadge() {
        
        guard let badge = unreadBadgeLabel else {
            return
        }
        
        badge.text = unreadChatCount > 99
        ? "99+"
        : "\(unreadChatCount)"
        
        let width = max(
            24,
            badge.intrinsicContentSize.width + 12
        )
        
        badge.widthAnchor.constraint(
            equalToConstant: width
        ).isActive = true
        
        badge.isHidden =
        unreadChatCount == 0
    }
    
    func hideFloatingChatButton() {
        
        unreadChatCount = 0
        
        floatingChatButton?.isHidden = true
        
        updateFloatingBadge()
    }
    
    private func openLiveChat(
        conversationId: Int? = nil,
        visitorId: Int? = nil,
        isFromCancelSubscription: Bool = false
    ) {

        IQKeyboardManager.shared().isEnabled = false
        
        LiveVisitorManager.shared.updateScreen(
            "Support Chat"
        )

        if let conversationId,
           LiveVisitorManager.shared.currentConversation?.id != conversationId {

            LiveVisitorManager.shared.currentConversation = Conversation(
                id: conversationId,
                status: nil,
                createdAt: nil
            )

            messages = []

            oldestMessageId = nil

            hasMoreMessages = true

        } else if LiveVisitorManager.shared.currentConversation == nil,
                  let existingConversationId =
                    LiveVisitorManager.shared
                    .visitor?
                    .conversationId {

            LiveVisitorManager.shared.currentConversation = Conversation(
                id: existingConversationId,
                status: nil,
                createdAt: nil
            )
        }
        
        isChatScreenOpen = true

        unreadChatCount = 0

        hideFloatingChatButton()

        let hosting = UIHostingController(
            rootView: buildChatView()
        )
        
        liveChatHostingController = hosting
        
        let nav = UINavigationController(
            rootViewController: hosting
        )
        
        nav.setNavigationBarHidden(
            true,
            animated: false
        )
        
        nav.modalPresentationStyle = .fullScreen
        
        present(
            nav,
            animated: true
        )

        Task {

            if LiveVisitorManager.shared.currentConversation == nil {

                await self.setupLiveChat()

            } else if self.messages.isEmpty {

                await self.loadMessages()
            }
            
            DispatchQueue.main.asyncAfter(
                deadline: .now() + 1.0
            ) {
                if isFromCancelSubscription {
                    self.sendPendingCancellationMessage()
                }
            }

            self.markCurrentConversationRead()

            self.flushOfflineMessages()
        }
    }
    
    private func buildChatView()
    -> LiveChatView {
        
        print("""
            
            =========================
            BUILD CHAT VIEW
            =========================
            RESOLVED:
            \(LiveVisitorManager.shared.isConversationResolved)
            =========================
            
            """)
        
        return LiveChatView(
            
            messages: messages,
            
            messageText:
                messageText,
            
            isLoadingMore: isLoadingMore,
            
            hasMoreMessages: hasMoreMessages,
            
            isConversationResolved: LiveVisitorManager.shared.isConversationResolved,
            
            onTextChange: { [weak self] text in
                
                self?.messageText = text

                self?.handleLiveChatTyping(text)
            },
            
            onSend: { [weak self] in
                
                self?.sendMessage()
            },
            
            onBack: { [weak self] in
                
                self?.isChatScreenOpen =
                false
                
                self?.liveChatHostingController?
                    .dismiss(
                        animated: true
                    )
            },
            
            onLoadMore: { [weak self] in
                
                self?.loadMoreMessages()
            },
            
            retryMessage: { [weak self] msg in
                
                self?.retryMessage(msg)
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
                
                refreshLiveChatUI()
                
                LiveVisitorManager.shared.isConversationResolved = false
            }
        )
    }
    
    private func refreshLiveChatUI() {

        guard let hosting =
                liveChatHostingController else {
            return
        }

        hosting.rootView =
        buildChatView()
    }
}

extension DashboardVC {
    
    private func loadMessages() async {

        guard let conversationId =
                LiveVisitorManager.shared.currentConversation?.id else {
            return
        }

        do {

            let fetched =
            try await liveChatService.fetchMessages(
                conversationId: conversationId
            )

            let sorted =
            fetched.sorted {

                ($0.id ?? 0)
                <
                ($1.id ?? 0)
            }

            await MainActor.run {

                self.messages = sorted

                self.oldestMessageId =
                sorted.first?.id

                self.hasMoreMessages =
                sorted.count >=
                LiveChatConstants.initialMessageLimit

                self.refreshLiveChatUI()
            }

        } catch {

            print(
                "LOAD MESSAGES ERROR:",
                error
            )
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

        guard let before =
                oldestMessageId else {
            return
        }

        isLoadingMore = true

        Task {

            do {

                let older =
                try await liveChatService
                    .fetchMessages(
                        conversationId:
                        conversationId,
                        before: before
                    )

                let sorted =
                older.sorted {

                    ($0.id ?? 0)
                    <
                    ($1.id ?? 0)
                }

                await MainActor.run {

                    if sorted.isEmpty {

                        self.hasMoreMessages =
                        false

                    } else {

                        self.oldestMessageId =
                        sorted.first?.id

                        self.messages.insert(
                            contentsOf: sorted,
                            at: 0
                        )

                        self.hasMoreMessages =
                        sorted.count >=
                        LiveChatConstants.paginationMessageLimit
                    }

                    self.isLoadingMore =
                    false

                    self.refreshLiveChatUI()
                }

            } catch {

                await MainActor.run {

                    self.isLoadingMore =
                    false
                }
            }
        }
    }

    private func markCurrentConversationRead() {

        guard let conversationId =
                LiveVisitorManager.shared.currentConversation?.id else {
            return
        }

        Task {

            do {

                try await liveChatService
                    .markConversationRead(
                        conversationId: conversationId
                    )

                await MainActor.run {

                    self.unreadChatCount = 0

                    self.updateFloatingBadge()

                    LiveVisitorManager
                        .shared
                        .unreadCount = 0
                }

            } catch {

                print(
                    "MARK READ ERROR:",
                    error.localizedDescription
                )
            }
        }
    }
    
    private func sendMessage() {

        let text =
        messageText.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !text.isEmpty else {
            return
        }

        guard let conversationId =
                LiveVisitorManager.shared.currentConversation?.id else {
            return
        }

        let tempMessage =
        ChatMessage(
            id: nil,
            conversationId: conversationId,
            senderType: "visitor",
            senderName: "You",
            message: text,
            isRead: true,
            createdAt: nil,
            localId: UUID(),
            status: .sending
        )

        messages.append(
            tempMessage
        )

        messageText = ""

        stopLiveChatTyping()

        refreshLiveChatUI()

        Task {

            do {

                let sentMessage =
                try await liveChatService
                    .sendMessage(
                        conversationId:
                        conversationId,
                        message:
                        text
                    )

                await MainActor.run {

                    if let index =
                        self.messages.firstIndex(
                            where: {

                                $0.localId ==
                                tempMessage.localId
                            }
                        ) {

                        self.messages[index] =
                        sentMessage
                    }

                    LiveChatOfflineMessageQueue
                        .shared
                        .remove(
                            localId: tempMessage.localId
                        )

                    self.refreshLiveChatUI()
                }

            } catch {

                await MainActor.run {

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

                    LiveChatOfflineMessageQueue
                        .shared
                        .enqueue(
                            localId: tempMessage.localId,
                            conversationId: conversationId,
                            message: text
                        )

                    self.refreshLiveChatUI()
                }
            }
        }
    }
    
    private func retryMessage(
        _ failedMessage: ChatMessage
    ) {

        guard let index =
                messages.firstIndex(
                    of: failedMessage
                ) else {
            return
        }

        messages[index].status =
        .sending

        refreshLiveChatUI()

        guard let text =
                failedMessage.message else {
            return
        }

        guard let conversationId =
                LiveVisitorManager.shared.currentConversation?.id else {
            return
        }

        Task {

            do {

                let sent =
                try await liveChatService
                    .sendMessage(
                        conversationId:
                        conversationId,
                        message:
                        text
                    )

                await MainActor.run {

                    self.messages[index] =
                    sent

                    LiveChatOfflineMessageQueue
                        .shared
                        .remove(
                            localId: failedMessage.localId
                        )

                    self.refreshLiveChatUI()
                }

            } catch {

                await MainActor.run {

                    self.messages[index]
                        .status = .failed

                    LiveChatOfflineMessageQueue
                        .shared
                        .enqueue(
                            localId: failedMessage.localId,
                            conversationId: conversationId,
                            message: text
                        )

                    self.refreshLiveChatUI()
                }
            }
        }
    }

    private func handleLiveChatTyping(
        _ text: String
    ) {

        guard let conversationId =
                LiveVisitorManager.shared.currentConversation?.id else {
            return
        }

        let trimmed = text.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        if trimmed.isEmpty {
            stopLiveChatTyping()
            return
        }

        if !isLiveChatTyping {

            isLiveChatTyping = true

            Task {
                try? await liveChatService.sendTyping(
                    conversationId: conversationId,
                    isTyping: true
                )
            }
        }

        // Debounce the "typing stopped" event so agents do not receive a
        // network request on every keystroke.
        liveChatTypingTask?.cancel()

        liveChatTypingTask = Task {

            try? await Task.sleep(
                for: .seconds(2)
            )

            await MainActor.run {
                self.stopLiveChatTyping()
            }
        }
    }

    private func stopLiveChatTyping() {

        guard let conversationId =
                LiveVisitorManager.shared.currentConversation?.id else {
            return
        }

        guard isLiveChatTyping else {
            return
        }

        isLiveChatTyping = false

        liveChatTypingTask?.cancel()

        liveChatTypingTask = nil

        Task {
            try? await liveChatService.sendTyping(
                conversationId: conversationId,
                isTyping: false
            )
        }
    }

    private func flushOfflineMessages() {

        guard !isFlushingOfflineMessages else {
            return
        }

        guard let conversationId =
                LiveVisitorManager.shared.currentConversation?.id else {
            return
        }

        let queuedMessages =
        LiveChatOfflineMessageQueue
            .shared
            .queuedMessages(
                for: conversationId
            )

        guard !queuedMessages.isEmpty else {
            return
        }

        isFlushingOfflineMessages = true

        Task {

            defer {
                Task {
                    await MainActor.run {
                        self.isFlushingOfflineMessages = false
                    }
                }
            }

            for queued in queuedMessages {

                await MainActor.run {

                    if !self.messages.contains(
                        where: { $0.localId == queued.id }
                    ) {

                        self.messages.append(
                            ChatMessage(
                                id: nil,
                                conversationId: queued.conversationId,
                                senderType: "visitor",
                                senderName: "You",
                                message: queued.message,
                                isRead: true,
                                createdAt: nil,
                                localId: queued.id,
                                status: .sending
                            )
                        )

                        self.refreshLiveChatUI()
                    }
                }

                do {

                    let sent =
                    try await liveChatService
                        .sendMessage(
                            conversationId:
                                queued.conversationId,
                            message:
                                queued.message
                        )

                    await MainActor.run {

                        if let index =
                            self.messages.firstIndex(
                                where: {
                                    $0.localId == queued.id
                                }
                            ) {

                            self.messages[index] = sent
                        }

                        LiveChatOfflineMessageQueue
                            .shared
                            .remove(
                                localId: queued.id
                            )

                        self.refreshLiveChatUI()
                    }

                } catch {

                    await MainActor.run {

                        if let index =
                            self.messages.firstIndex(
                                where: {
                                    $0.localId == queued.id
                                }
                            ) {

                            self.messages[index]
                                .status = .failed
                        }

                        self.refreshLiveChatUI()
                    }

                    break
                }
            }
        }
    }
}
