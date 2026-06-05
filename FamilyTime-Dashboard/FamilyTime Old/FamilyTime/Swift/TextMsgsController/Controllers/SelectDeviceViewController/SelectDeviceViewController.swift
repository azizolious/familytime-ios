//
//  SelectDeviceViewController.swift
//  FamilyTime
//
//  Created by Rao Mudassar Khalil on 15/10/2021.
//  Copyright © 2021 YumyApps. All rights reserved.
//

import UIKit
import IQKeyboardManager

class SelectDeviceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    
    //MARK: - IBOUTLETS
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var chooseDeviceLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var havingDiffButtonLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    //MARK: - VARIABLES
    let cellIds = ["cell1", "cell2", "cell3"]
    var selectedCell = 0
    var orangeColor = UIColor()
    let dispatchGroup = DispatchGroup()
    var isBackButton = false
    var feedsArray = [NotificationFeeds]()
    var notifObj = NotificationFeeds(feed_id: "", action_text: "", billing_status: "", card_color: "", customer_criteria: "", end_date: "", feed_data: "", feed_snippet: "", feed_snippet_color: "", image_url: "", is_active: "", lang: "", limit: "", notification_type: "", platform_id: "", read_more_color: "", sort_order: "", start_date: "", time_color: "", title: "", title_color: "", trigger_point: "",google_in_app_sub_id: "",apple_in_app_sub_id: "",fs_sub_url: "",paddle_sub_url: "",dashboard_sub_url: "", web_cta: "")
    
    //MARK: - VIEWS LIFECYLE
    override func viewDidLoad() {
        super.viewDidLoad()
        orangeColor=UIColorFromRGB(0xff8400)
        if (UI_USER_INTERFACE_IDIOM() == .pad){
          self.nextButton.layer.cornerRadius = 30
        } else {
          self.nextButton.layer.cornerRadius = 21
        }
        let tapGesture = UITapGestureRecognizer()
            tapGesture.addTarget(self, action: #selector(talkToParentButtonAction))
            tapGesture.delegate = self
            self.havingDiffButtonLabel.addGestureRecognizer(tapGesture)
        
        if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
            self.backButton.transform = self.backButton.transform.rotated(by: CGFloat(Double.pi / 1))
        }
        
        if isBackButton {
            self.backButton.isHidden = false
        } else {
            self.backButton.isHidden = true
        }
        
//        self.getDashboard2ApiCall()
      }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.navigationBar.isHidden = true
        self.titleLabel.text = "step_1_title".localized
        self.chooseDeviceLabel.text = "step_1_content_1".localized
        self.nextButton.setTitle("next_button".localized, for: .normal)
        self.havingDiffButtonLabel.text = "step_1_link_text".localized
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    //MARK: - BUTTON ACTIONS
    @IBAction func nextButtonAction(_ sender: Any) {
        if selectedCell == 0 || selectedCell == 1 {
            self.moveToNextScreen()
        } else {
            let storyboard = UIStoryboard(name: "KidDevice", bundle: Bundle.main)
            let controller = storyboard.instantiateViewController(withIdentifier: "NotSureViewController") as? NotSureViewController
            self.navigationController?.pushViewController(controller!, animated: true)
        }
    }
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
   @objc func talkToParentButtonAction(_ sender: Any) {
       IQKeyboardManager.shared().isEnabled = false
       ZendeskChatManager.trackEvent("Help Chat Started")
       
       ZendeskChatManager.startChat(on: navigationController, event: "Help Chat Started")
    }
    
//    func getDashboard2ApiCall() {
//        HLApiManager.hitDashboardApi2(view: self.view) { response, status, message in
//            guard let response = response else {
//                return
//            }
//            
//            if let data = response["data"] as? [String:Any] {
//                if let app_config = data["app_config"] as? [String: Any] {
//                    let shopping_funnel = app_config["shopping_funnel"] as? Bool ?? false
//                    UserDefaults.standard.setValue(shopping_funnel, forKey: "shopping_funnel")
//                    print(UserDefaults.standard.bool(forKey: "shopping_funnel"))
//                }
//                
//                if let subscription = data["subscription"] as? [String: Any] {
//                    let subscription_package = subscription["package"] as? String ?? ""
//                    UserDefaults.standard.setValue(subscription_package, forKey: "billing_status")
//                    print(UserDefaults.standard.string(forKey: "billing_status") ?? "")
//                }
//            }
//            
////            HLApiManager.loadNotificationsApi() { [self] (response, status, message) in
////                print(message)
////                guard response != nil else {
////                    return
////                }
////                
////                if(status == 200){
////                    print(response!)
////                    if let feed_data = response!["feed_data"] as? [[String:Any]]{
////                        var eurl = ""
////                        if let url = response!["encoded_url"] as? String{
////                            eurl = url
////                            print(eurl)
////                        }
////                        print(feed_data)
////                        
////                        for dict in feed_data{
////                            
////                            if let info = dict as?  NSDictionary{
////                                //  SwiftCommonUtility.shared.saveFeedsData(UserDBObj: info, url:eurl)
////                                var feed_id:String? =  "14"
////                                var action_text:String? =  "Read More"
////                                var billing_status:String? = "FREE,SIGNUP,TRIAL"
////                                var card_color:String? =  "#ffffff"
////                                var customer_criteria:String? = "1"
////                                var end_date:String? = "2019-04-30"
////                                var feed_data:String? =  "{\r\n\t\t\"type\": \"body\",\r\n\t\t\"bgColor\": \"#feffff\"\r\n\t},\r\n\t{\r\n\t\t\"type\":}"
////                                var feed_snippet:String? =  "1"
////                                var feed_snippet_color:String? =  "Easter is right round the corner and we are celebrating with all our FamilyTime parents this year."
////                                var image_url:String? = "https://familytime.io/img/app-offers/en/v2_happy_easter_sale_2019_01.png"
////                                var is_active:String? =  "1"
////                                var lang:String? = "en"
////                                var limit:String? = "null"
////                                var notification_type:String? =  "2"
////                                var platform_id:String? =  "1,2"
////                                var read_more_color:String? = "#9c71d3"
////                                var sort_order:String? = "1"
////                                var start_date:String? = "2019-04-18"
////                                var time_color:String? =  "#5e5e5e"
////                                var title:String? =  "The Easter Sale is ON"
////                                var title_color:String? =  "#1a1a1a"
////                                var trigger_point:String? = "null"
////                                var google_in_app_sub_id:String? = "google_in_app_sub_id"
////                                var apple_in_app_sub_id:String? = "apple_in_app_sub_id"
////                                var fs_sub_url:String? = "fs_sub_url"
////                                var paddle_sub_url:String? = "paddle_sub_url"
////                                var dashboard_sub_url:String? = "dashboard_sub_url"
////                                var web_cta:String? = "web_cta"
////                                var packageName:String? = "packageName"
////                                var couponCode:String? = "couponCode"
////                                
////                                if let uid =  info["id"] as? Int64{
////                                    feed_id = String(uid)
////                                }
////                                
////                                if let uname =  info["action_text"] as? String{
////                                    action_text = uname
////                                }
////                                
////                                if let ubirthday =  info["billing_status"] as? String{
////                                    billing_status = ubirthday
////                                }
////                                
////                                if let ugender =  info["card_color"] as? String{
////                                    card_color = ugender
////                                }
////                                
////                                if let urelationship =  info["customer_criteria"] as? Int64{
////                                    customer_criteria = String(urelationship)
////                                }
////                                if let uemail = info["end_date"] as? String{
////                                    end_date = uemail
////                                }
////                                if let uphone =  info["feed_data"] as? String{
////                                    feed_data = uphone
////                                }
////                                
////                                if let uplateform_id =  info["sort_order"] as? Int64{
////                                    sort_order = String(uplateform_id)
////                                }
////                                
////                                if let udevice =  info["feed_snippet"] as? String{
////                                    feed_snippet = udevice
////                                }
////                                
////                                if let upackage_id = info["feed_snippet_color"] as? String{
////                                    feed_snippet_color = upackage_id
////                                }
////                                if let upackage_name =  info["image_url"] as? String{
////                                    image_url = upackage_name
////                                }
////                                
////                                if let uduration =  info["is_active"] as? Int64{
////                                    is_active = String(uduration)
////                                }
////                                
////                                if let uexpiry_date =  info["lang"] as? String{
////                                    lang = uexpiry_date
////                                }
////                                
////                                if let uremaining_days =  info["limit"] as? Int64{
////                                    limit = String(uremaining_days)
////                                }
////                                if let ucover_img_src =  info["notification_type"] as? String{
////                                    notification_type = ucover_img_src
////                                }
////                                
////                                if let uprofile_img_src =  info["platform_id"] as? String{
////                                    platform_id = uprofile_img_src
////                                }
////                                if let ucolor =  info["read_more_color"] as? String{
////                                    read_more_color = ucolor
////                                }
////                                
////                                if let uactivation_code =  info["start_date"] as? String{
////                                    start_date = uactivation_code
////                                }
////                                if let uchild_mdm_hash =  info["time_color"] as? String{
////                                    time_color = uchild_mdm_hash
////                                }
////                                
////                                if let upush_token =  info["title"] as? String{
////                                    title = upush_token
////                                }
////                                
////                                if let uis_production_build =  info["title_color"] as? String{
////                                    title_color = uis_production_build
////                                }
////                                
////                                if let utime_zone =  info["google_in_app_sub_id"] as? String{
////                                    google_in_app_sub_id = utime_zone
////                                }
////                                
////                                if let utime_zone =  info["apple_in_app_sub_id"] as? String{
////                                    apple_in_app_sub_id = utime_zone
////                                }
////                                
////                                if let utime_zone =  info["fs_sub_url"] as? String{
////                                    fs_sub_url = utime_zone
////                                }
////                                
////                                if let utime_zone =  info["paddle_sub_url"] as? String{
////                                    paddle_sub_url = utime_zone
////                                }
////                                
////                                if let utime_zone =  info["dashboard_sub_url"] as? String{
////                                    dashboard_sub_url = utime_zone
////                                }
////                                
////                                if let utime_zone =  info["web_cta"] as? String{
////                                    web_cta = utime_zone
////                                }
////                                
////                                if let utime_zone =  info["packageName"] as? String{
////                                    packageName = utime_zone
////                                }
////                                
////                                if let utime_zone =  info["couponCode"] as? String{
////                                    couponCode = utime_zone
////                                }
////                                
////                                let obj = NotificationFeeds(feed_id:feed_id,action_text:action_text,billing_status:billing_status,card_color:card_color,customer_criteria:customer_criteria,end_date:end_date,feed_data:feed_data,feed_snippet:feed_snippet,feed_snippet_color:feed_snippet_color,image_url:image_url,is_active:is_active,lang:lang,limit:limit,notification_type:notification_type,platform_id:platform_id,read_more_color:read_more_color,sort_order:sort_order,start_date:start_date,time_color:time_color,title:title,title_color:title_color,trigger_point:trigger_point,google_in_app_sub_id: google_in_app_sub_id,apple_in_app_sub_id: apple_in_app_sub_id,fs_sub_url: fs_sub_url,paddle_sub_url: paddle_sub_url,dashboard_sub_url: dashboard_sub_url, web_cta: web_cta)
////                                
////                                feedsArray.append(obj)
////                            }
////                        }
////                    }
////                    if self.feedsArray.count > 0{
////                        self.notifObj = self.feedsArray[0]
////                        
////                        UserDefaults.standard.setValue(self.notifObj.web_cta, forKey: "web_cta")
////                        UserDefaults.standard.setValue(self.notifObj.dashboard_sub_url, forKey: "dashboard_sub_url")
////                        UserDefaults.standard.setValue(self.notifObj.paddle_sub_url, forKey: "paddle_sub_url")
////                        UserDefaults.standard.setValue(self.notifObj.fs_sub_url, forKey: "fs_sub_url")
////                        
////                        if UserDefaults.standard.bool(forKey: "HasLaunchedOnce") == false {
////                            UserDefaults.standard.setValue(true, forKey: "HasLaunchedOnce")
////                            self.dispatchGroup.notify(queue: .main) { [self] in
////                                let storyBoard: UIStoryboard = UIStoryboard(name: "Dashboard", bundle: nil)
////                                let newViewController = storyBoard.instantiateViewController(withIdentifier: "goToNotificationDetail") as! UINavigationController
////                                notificationDataGlobal = self.notifObj
////                                newViewController.modalPresentationStyle = .overFullScreen
////                                present(newViewController, animated: true, completion: nil)
////                            }
////                        }
////                    }
////                } else {
////                    
////                    // LoginViewController.displayToast(message,onView: self.view)
////                }
////            }
//        }
//    }
    
    func moveToNextScreen() {
        var storyboardName = "Steps"
        
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(withIdentifier: "SwiftAddDeviceNewViewController3") as? SwiftAddDeviceNewViewController3
        
        if selectedCell == 0 {
            controller?.urlString = "Android"
        } else if selectedCell == 1 {
            controller?.urlString = "iOS"
        }
        
        self.navigationController?.pushViewController(controller!, animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIds[indexPath.row], for: indexPath) as! SelectDeviceTableViewCell
        cell.selectionStyle = .none
        if selectedCell == indexPath.row{
            
            cell.separator.backgroundColor = orangeColor
            cell.check.isHidden = false
        }else{
            cell.separator.backgroundColor = .darkGray
            cell.check.isHidden = true
        }
        
        if indexPath.row == 2{
            cell.titleLabel.text = "step_1_option_3".localized
            }else{
              cell.titleLabel.text = cell.titleLabel.text
            }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        selectedCell = indexPath.row
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (UI_USER_INTERFACE_IDIOM() == .pad){
            return 80.0
        }else{
            return 60.0
        }
    }
}
