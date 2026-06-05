//
//  NotificationsViewController.swift
//  FamilyTime
//
//  Created by Rao Mudassar Khalil on 21/09/2021.
//  Copyright © 2021 YumyApps. All rights reserved.
//

import UIKit
import SDWebImage

class NotificationViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    // @IBOutlet weak var menu_btn: UIBarButton!
    @IBOutlet weak var noNotificationView: UIView!
    @IBOutlet weak var oopsLabel: UILabel!
    @IBOutlet weak var noDataFoundLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var btn_bar: UIBarButtonItem!
    
    //MARK: - Variables
    var delegate: AppDelegate?
    var feedsArray=[NotificationFeeds]()
    var notifIndex:Int = -1
    private var notifObj = NotificationFeeds(feed_id: nil, action_text: nil, billing_status: nil, card_color: nil, customer_criteria: nil, end_date: nil, feed_data: nil, feed_snippet: nil, feed_snippet_color: nil, image_url: nil, is_active: nil, lang: nil, limit: nil, notification_type: nil, platform_id: nil, read_more_color: nil, sort_order: nil, start_date: nil, time_color: nil, title: nil, title_color: nil, trigger_point: nil,google_in_app_sub_id: nil,apple_in_app_sub_id: nil,fs_sub_url: nil,paddle_sub_url: nil,dashboard_sub_url: nil, web_cta: nil)
    
    //MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadNotificationsFeedOnDashboard()
        tableView.alpha = 0
        noNotificationView.alpha = 0
        refreshButton.setTitle("", for: .normal)
        oopsLabel.text = "notification_content_1".localized
        noDataFoundLabel.text = "notification_content_2".localized
        navigationItem.title = "notification_title".localized
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        LiveVisitorManager.shared.updateScreen(
            "Notifications"
        )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    //MARK: - IBActions
    @IBAction func actionRefreshButton(_ sender: UIButton) {
        self.loadNotificationsFeedOnDashboard()
    }
    
    @IBAction func menu(_ sender: Any) {
        //        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        //        let vc = storyBoard.instantiateViewController(withIdentifier: "ParentSideViewController") as! ParentSideViewController
        //        if  UIView.appearance().semanticContentAttribute == .forceRightToLeft {
        //            sideMenuController?.rightViewController = vc
        //            sideMenuController?.showRightView(animated: true, completionHandler: nil)
        //         }else{
        //            sideMenuController?.leftViewController = vc
        //            sideMenuController?.showLeftView(animated: true, completionHandler: nil)
        //         }
    }
    
    //MARK: - Helper Functions
    func loadNotificationsFeedOnDashboard() {
//        SwiftFTUtils.showHUDAdded(to: view, withText: "Loading...", animated: true)
//        HLApiManager.loadNotificationsApi() { [self] (response, status, message) in
//            SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
//            if let response = response {
//                if(status == 200 || status == 201 || status == 202 || status == 204 || status == 206){
//                    print(response)
//                    if let feed_data = response[StringConstants.ResponseKeys.FEED_DATA] as? [[String:Any]] {
//                        var eurl = ""
//                        if let url = response[StringConstants.ResponseKeys.ENCODED_URL] as? String{
//                            eurl = url
//                        }
//                        print(feed_data)
//                        for dict in feed_data {
//                            //                        let id1 = info["id"] as? Int
//                            //                        let newFeedId = info["news_feeds_id"] as? Int
//                            //                        let name1 = info["name"] as? String
//                            let info = dict
//                            let freuency = info[StringConstants.ResponseKeys.FREQUENCY] as? Int
//                            UserDefaults.standard.set(freuency, forKey: "FREQUENCY_DATA")
//                            var feed_id,web_cta,dashboard_sub_url,paddle_sub_url,fs_sub_url,apple_in_app_sub_id,google_in_app_sub_id,trigger_point,title_color,title,time_color,start_date,sort_order,read_more_color,platform_id,notification_type,limit,lang,is_active,image_url,feed_snippet_color,feed_snippet,feed_data,end_date,customer_criteria,card_color,billing_status,action_text : String?
//                            let uid =  info[StringConstants.ResponseKeys.ID] as? Int64 ?? 0
//                            let actionText =  info[StringConstants.ResponseKeys.ACTION_TEXT] as? String ?? ""
//                            let billingStatus =  info[StringConstants.ResponseKeys.BILLING_STATUS] as? String ?? ""
//                            let cardColor =  info[StringConstants.ResponseKeys.CARD_COLOR] as? String ?? ""
//                            let customerCriteria = info[StringConstants.ResponseKeys.CUSTOMER_CRITERIA] as? Int64 ?? 0
//                            let endDate = info[StringConstants.ResponseKeys.END_DATE] as? String ?? ""
//                            let feedData =  info[StringConstants.ResponseKeys.FEED_DATA] as? String ?? ""
//                            let sortOrder =  info[StringConstants.ResponseKeys.SORT_ORDER] as? Int64 ?? 0
//                            let feedSnippet =  info[StringConstants.ResponseKeys.FEED_SNIPPET] as? String ?? ""
//                            let feedSnippetColor = info[StringConstants.ResponseKeys.FEED_SNIPPET_COLOR] as? String ?? ""
//                            let imageURL =  info[StringConstants.ResponseKeys.IMAGE_URL] as? String
//                            let isActive =  info[StringConstants.ResponseKeys.IS_ACTIVE] as? Int64 ?? 0
//                            let language =  info[StringConstants.ResponseKeys.LANG] as? String ?? ""
//                            let daysLimit =  info[StringConstants.ResponseKeys.LIMIT] as? Int64 ?? 0
//                            let notificationType =  info[StringConstants.ResponseKeys.NOTIFICATION_TYPE] as? String ?? ""
//                            let platformID =  info[StringConstants.ResponseKeys.PLATFORM_ID] as? String ?? ""
//                            let readMoreColor =  info[StringConstants.ResponseKeys.READ_MORE_COLOR] as? String ?? ""
//                            let startDate =  info[StringConstants.ResponseKeys.START_DATE] as? String ?? ""
//                            let timeColor =  info[StringConstants.ResponseKeys.TIME_COLOR] as? String ?? ""
//                            let titleFor =  info[StringConstants.ResponseKeys.TITLE] as? String ?? ""
//                            let titleColor =  info[StringConstants.ResponseKeys.TITLE_COLOR] as? String ?? ""
//                            let googleInAppSubId =  info[StringConstants.ResponseKeys.GOOGLE_IN_APP_SUB_ID] as? String ?? ""
//                            let appleInAppSubId =  info[StringConstants.ResponseKeys.APPLE_IN_APP_SUB_ID] as? String ?? ""
//                            let fsSubURL =  info[StringConstants.ResponseKeys.FS_SUB_URL] as? String ?? ""
//                            let paddleSubURL =  info[StringConstants.ResponseKeys.PADDLE_SUB_URL] as? String ?? ""
//                            let subURL =  info[StringConstants.ResponseKeys.DASHBOARD_SUB_URL] as? String ?? ""
//                            let webCTA =  info[StringConstants.ResponseKeys.WEB_CTA] as? String ?? ""
//                            //                        let packageName =  info["packageName"] as? String ?? ""
//                            //                        let coupon_code =  info["couponCode"] as? String ?? ""
//                            feed_id = String(uid)
//                            action_text = actionText
//                            billing_status = billingStatus
//                            card_color = cardColor
//                            customer_criteria = String(customerCriteria)
//                            end_date = endDate
//                            feed_data = feedData
//                            sort_order = String(sortOrder)
//                            feed_snippet = feedSnippet
//                            feed_snippet_color = feedSnippetColor
//                            image_url = imageURL
//                            is_active = String(isActive)
//                            lang = language
//                            limit = String(daysLimit)
//                            notification_type = notificationType
//                            platform_id = platformID
//                            read_more_color = readMoreColor
//                            start_date = startDate
//                            time_color = timeColor
//                            title = titleFor
//                            title_color = titleColor
//                            google_in_app_sub_id = googleInAppSubId
//                            apple_in_app_sub_id = appleInAppSubId
//                            fs_sub_url = fsSubURL
//                            paddle_sub_url = paddleSubURL
//                            dashboard_sub_url = subURL
//                            web_cta = webCTA
//                            let obj = NotificationFeeds(feed_id:feed_id,action_text:action_text,billing_status:billing_status,card_color:card_color,customer_criteria:customer_criteria,end_date:end_date,feed_data:feed_data,feed_snippet:feed_snippet,feed_snippet_color:feed_snippet_color,image_url:image_url,is_active:is_active,lang:lang,limit:limit,notification_type:notification_type,platform_id:platform_id,read_more_color:read_more_color,sort_order:sort_order,start_date:start_date,time_color:time_color,title:title,title_color:title_color,trigger_point:trigger_point,google_in_app_sub_id: google_in_app_sub_id,apple_in_app_sub_id: apple_in_app_sub_id,fs_sub_url: fs_sub_url,paddle_sub_url: paddle_sub_url,dashboard_sub_url: dashboard_sub_url, web_cta: web_cta)
//                            feedsArray.append(obj)
//                            if feedsArray.count > 0 {
//                                self.notifObj = feedsArray[0]
//                                UserDefaults.standard.setValue(notifObj.web_cta, forKey: "web_cta")
//                                UserDefaults.standard.setValue(notifObj.dashboard_sub_url, forKey: "dashboard_sub_url")
//                                UserDefaults.standard.setValue(notifObj.paddle_sub_url, forKey: "paddle_sub_url")
//                                UserDefaults.standard.setValue(notifObj.fs_sub_url, forKey: "fs_sub_url")
//                                UserDefaults.standard.synchronize()
//                            }
//                            self.tableView.reloadData()
//                        }
//                    }
//                } else {
//                    self.tableView.reloadData()
//                }
//            } else {
//                print(StringConstants.Errors.SOMETHING_WENT_WRONG)
//                SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
//            }
//        }
    }
}

//MARK: - TableView Delegates and Datasources
extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.feedsArray.count == 0 {
            tableView.alpha = 0
            noNotificationView.alpha = 1
        } else {
            tableView.alpha = 1
            noNotificationView.alpha = 0
        }
        return self.feedsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let obj = self.feedsArray[indexPath.row]
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell01", for: indexPath) as! FeedDetailCell
        cell.feed_title.text = obj.title
        cell.feed_img.sd_setImage(with: URL(string: obj.image_url!), placeholderImage: UIImage(named: ""))
        cell.feed_detail.text = obj.feed_snippet
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Dashboard", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "goToNotificationDetail") as! UINavigationController
        notificationDataGlobal = self.feedsArray[indexPath.row]
        newViewController.modalPresentationStyle = .overFullScreen
        present(newViewController, animated: true, completion: nil)
        //        let storyBoard: UIStoryboard = UIStoryboard(name: "Dashboard", bundle: nil)
        //        let newViewController = storyBoard.instantiateViewController(withIdentifier: "NotificationDetailViewController") as! NotificationDetailViewController
        //        newViewController.notifDetail = self.feedsArray[indexPath.row]
        //        newViewController.modalPresentationStyle = .overFullScreen
        //        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
