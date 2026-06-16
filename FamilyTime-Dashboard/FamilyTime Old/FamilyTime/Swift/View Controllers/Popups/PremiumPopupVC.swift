//
//  PremiumPopupVC.swift
//  FamilyTime
//
//  Created by Sana Ullah on 19/02/2019.
//  Copyright © 2019 YumyApps. All rights reserved.
//

import UIKit
//import ZendeskSDK
import IQKeyboardManager

@objcMembers class PremiumPopupVC: UIViewController {

    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    
    @IBOutlet weak var upgradeBtn: UIButton!
    @IBOutlet weak var closeBtn: UIButton!
    
    @IBOutlet weak var closeImageVu: UIImageView!
    
    var strURL = ""
    let appDelegate = UIApplication.shared.delegate as? AppDelegate ?? AppDelegate()
    let child_Id = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
    
    var titleString = ""
    var shouldHideTitle = false
    private var package_id : String = ""
    private var package_name : String = ""
    private var device : String = ""
    
    var notifDetail = NotificationFeeds(feed_id: "", action_text: "", billing_status: "", card_color: "", customer_criteria: "", end_date: "", feed_data: "", feed_snippet: "", feed_snippet_color: "", image_url: "", is_active: "", lang: "", limit: "", notification_type: "", platform_id: "", read_more_color: "", sort_order: "", start_date: "", time_color: "", title: "", title_color: "", trigger_point: "",google_in_app_sub_id: "",apple_in_app_sub_id: "",fs_sub_url: "",paddle_sub_url: "",dashboard_sub_url: "", web_cta: "")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        package_id = CoreDataUtility.fetchPackageIdFor(child_id: Int32(child_Id ?? "") ?? 0)
        package_name = CoreDataUtility.fetchPackageNameFor(child_id: Int32(child_Id ?? "") ?? 0)
        device = CoreDataUtility.fetchPackageDeviceFor(child_id: Int32(child_Id ?? "") ?? 0)
        
        multiLingual()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.upgradeBtn.layer.cornerRadius = 8
        self.upgradeBtn.layer.masksToBounds = true
        self.upgradeBtn.backgroundColor = .FTBlue
        if shouldHideTitle
        {
            self.title = titleString
            closeBtn.isHidden = true
            closeImageVu.isHidden = true
        }
        else{
          navigationController?.setNavigationBarHidden(true, animated: true)
        }
//        navigationController?.setNavigationBarHidden(true, animated: true)
       // upgradeBtn.isHidden = !UserDefaultsManager.ShowInAppsPage
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: .plain, target: nil, action: nil)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func multiLingual(){
        let billingStatus = UserDefaults.standard.string(forKey: "billing_status")
        let childPackage = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_PACKAGE) ?? ""
        if billingStatus == "PREMIUM" || billingStatus == "premium" {
            if childPackage == "FREE" || childPackage == "free" || childPackage == "TRIAL" || childPackage == "trial" {
                descLbl.text = "premium_features_content_4".localized
                upgradeBtn.setTitle("premium_features_button_3".localized, for: .normal)
            } else {
                descLbl.text = "premium_features_content_4".localized
                upgradeBtn.setTitle("premium_features_button_3".localized, for: .normal)
            }
        }
        
        if billingStatus == "FREE" || billingStatus == "free" {
            descLbl.text = "upgrade_status".localized
            upgradeBtn.setTitle("premium_features_button_2".localized, for: .normal)
        } else {
            if (self.package_name == "free" && (UserDefaults.standard.string(forKey: "billing_status") == "FREE" || UserDefaults.standard.string(forKey: "billing_status") == "free")){
                descLbl.text = "upgrade_status".localized
                upgradeBtn.setTitle("premium_features_button_2".localized, for: .normal)
            } else if (UserDefaults.standard.string(forKey: "billing_status") == "TRIAL" || UserDefaults.standard.string(forKey: "billing_status") == "trial"){
                let childCount = UserDefaults.standard.integer(forKey: UserDefaultsConstants.CHILD_COUNT)
                if childCount > 15 {
                    descLbl.text = "upgrade_status".localized
                    upgradeBtn.setTitle("premium_features_button_2".localized, for: .normal)
                } else {
                    upgradeBtn.setTitle("premium_features_button_2".localized, for: .normal)
                    descLbl.text = "premium_features_content_3".localized
                }
            }
        }
    }
    //MARK :- UI ACTIONS
    @IBAction func closeAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func upgradeAction(_ sender: Any) {
        
        //        let vc = SwiftConstants.SwiftStoryBoard.instantiateViewController(withIdentifier: "SubscriptionVC") as! SubscriptionVC
        //        self.navigationController?.pushViewController(vc, animated: true)
        
        if upgradeBtn.titleLabel?.text == "premium_features_button_3".localized {
            //            let vc = SwiftConstants.SwiftStoryBoard.instantiateViewController(withIdentifier: "HelpViewController") as! HelpViewController
            //            self.navigationController?.pushViewController(vc, animated: true)
            
            //            let helpCenterContentModel = ZDKHelpCenterOverviewContentModel.defaultContent()
            //            // Show Help Center
            //            ZDKHelpCenter.pushOverview(navigationController, with: helpCenterContentModel)
            
            IQKeyboardManager.shared().isEnabled = false
//            ZendeskChatManager.trackEvent("Help Chat Started")
//            ZendeskChatManager.startChat(on: navigationController, event: "Help Chat Started")
        } else {
            let shoppingFunnel = UserDefaults.standard.bool(forKey: "shopping_funnel")
            if shoppingFunnel {
                if (UserDefaults.standard.string(forKey: "billing_status")  == "FREE" || UserDefaults.standard.string(forKey: "billing_status")  == "free") || (UserDefaults.standard.string(forKey: "billing_status") == "TRIAL" || UserDefaults.standard.string(forKey: "billing_status") == "trial") {
                    let storyboard = UIStoryboard(name: StoryboardConstants.Storyboards.DASHBOARD, bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: StoryboardConstants.Identifiers.DATA_USE_VC_IDENTIFIER) as! DataUseVC
                    vc.isInAppOn = true
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    let childPackage = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_PACKAGE) ?? ""
                    if childPackage == "FREE" || childPackage == "free" || childPackage == "TRIAL" || childPackage == "trial" {
                        IQKeyboardManager.shared().isEnabled = false
//                        ZendeskChatManager.trackEvent("Help Chat Started")
//                        ZendeskChatManager.startChat(on: navigationController, event: "Help Chat Started")
                    } else {
                        IQKeyboardManager.shared().isEnabled = false
//                        ZendeskChatManager.trackEvent("Help Chat Started")
//                        ZendeskChatManager.startChat(on: navigationController, event: "Help Chat Started")
                    }
                }
            }
            else {
                print("The value of Shopping Funnel is ",UserDefaults.standard.bool(forKey: "shopping_funnel"))
                var urlString = ""
                switch UserDefaults.standard.string(forKey: "web_cta") ?? ""{
                    
                case "dashboard":
                    print("dashboard")
                    urlString = UserDefaults.standard.string(forKey: "dashboard_sub_url") ?? ""
                case "paddle":
                    print("paddle")
                    urlString = UserDefaults.standard.string(forKey: "paddle_sub_url") ?? ""
                case "fs":
                    print("fs")
                    urlString = UserDefaults.standard.string(forKey: "fs_sub_url") ?? ""
                default:
                    urlString = UserDefaults.standard.string(forKey: "fs_sub_url") ?? ""
                }
                self.strURL = urlString
                self.performSegue(withIdentifier:"premiumToWebView", sender: self)
//                if let url = URL(string: urlString) {
//                    UIApplication.shared.open(url)
//                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "premiumToWebView") {
            let vc = segue.destination as! BrowserViewController
            vc.strUrl = self.strURL
        }
    }
}
