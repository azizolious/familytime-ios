//
//  NotificationDetail.swift
//  FamilyTime
//
//  Created by Rao Mudassar Khalil on 21/09/2021.
//  Copyright © 2021 YumyApps. All rights reserved.
//

import UIKit
import SDWebImage

class NotificationDetailViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var couponLAbel: UILabel!
    @IBOutlet weak var downLabel: UILabel!
    @IBOutlet weak var downButton: UIButton!
    
    //MARK: - Variables
    private var feedDataModelArr = [Feed_Data_Model]()
    var comeFromDashboard = false
    var strURL : String?
    var notifDetail = NotificationFeeds(feed_id: nil, action_text: nil, billing_status: nil, card_color: nil, customer_criteria: nil, end_date: nil, feed_data: nil, feed_snippet: nil, feed_snippet_color: nil, image_url: nil, is_active: nil, lang: nil, limit: nil, notification_type: nil, platform_id: nil, read_more_color: nil, sort_order: nil, start_date: nil, time_color: nil, title: nil, title_color: nil, trigger_point: nil,google_in_app_sub_id: nil,apple_in_app_sub_id: nil,fs_sub_url: nil,paddle_sub_url: nil,dashboard_sub_url: nil, web_cta: nil)
    
    //MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.notifDetail = notificationDataGlobal
        self.loadContent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.backgroundColor = .clear
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        /// Restore the navigation bar to default
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToWebView") {
            let vc = segue.destination as! BrowserViewController
            vc.strUrl = self.strURL
        }
    }
    
    //MARK: - IBActions
    @IBAction func backAction(_ sender: Any) {
        if comeFromDashboard {
            navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func downButtonAction(_ sender: Any) {
        let shoppingFunnel = UserDefaults.standard.bool(forKey: UserDefaultsConstants.SHOPPING_FUNNEL_VALUE)
        if shoppingFunnel {
            let billingStatus = UserDefaults.standard.string(forKey: UserDefaultsConstants.BILLING_STATUS)
            if (billingStatus  == StringConstants.Subscriptions.FREE_CAPITAL || billingStatus  == StringConstants.Subscriptions.FREE_SMALL || billingStatus == StringConstants.Subscriptions.TRIAL_CAPITAL || billingStatus == StringConstants.Subscriptions.TRIAL_SMALL) {
                guard let subidd = self.notifDetail.apple_in_app_sub_id else {
                    return
                }
                if subidd != "" {
                    IAPUtility.shared.autoRenewablePurchase(prodId: subidd, vc: self)
                }
            }
        } else {
            var urlString = ""
            switch self.notifDetail.web_cta{
            case StringConstants.Constants.DASHBOARD:
                urlString = self.notifDetail.dashboard_sub_url ?? ""
            case StringConstants.Constants.PADDLE:
                urlString = self.notifDetail.paddle_sub_url ?? ""
            case StringConstants.Constants.FAST_SPRING:
                urlString = self.notifDetail.fs_sub_url ?? ""
            default:
                urlString = self.notifDetail.fs_sub_url ?? ""
            }
            self.strURL = urlString
            if self.strURL != nil {
                let storyboard = UIStoryboard(name: StoryboardConstants.Storyboards.DASHBOARD, bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: StoryboardConstants.Identifiers.BROWSER_VC_IDENTIFIER) as! BrowserViewController
                vc.strUrl = self.strURL ?? ""
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    //MARK: - Helper Functions
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func loadContent(){
        //        HLApiManager.loadNotificationsApiNew(view: self.view) { response, error in
        //            print(response)
        //            for i in response!{
        //                print(i.feedData)
        //                self.couponLAbel.textColor = self.hexStringToUIColor(hex: i.readMoreColor )
        //                self.decodeFeedData(data: i.feedData)
        //            }
        //        }
        if let pagetext = notifDetail.feed_data{
            let str = pagetext.replacingOccurrences(of: "\\", with: "")
            if let dict = self.convertToDictionary(text: str) as? [AnyObject]{
                print(dict)
                if dict.count > 0 {
                    let backgroundObj = dict[0]
                    self.outerView.backgroundColor = hexStringToUIColor(hex: backgroundObj["bgColor"] as? String ?? "#000000")
                    print(backgroundObj["textColor"] as? String ?? "#012000")
                    let obj = dict[1]
                    if let text = obj["data"] as? String {
                        let decodingStr = self.replaceOccuranceOfNumeralsWith(value: text)
                        print("\u{ff1a}")
                        self.titleLabel.text = decodingStr
                        self.titleLabel.textColor = hexStringToUIColor(hex: obj["textColor"] as? String ?? "#000000")
                        print(obj["textColor"] as? String ?? "#012000")
                    }
                    let detail = dict[2]
                    if let text = detail["data"] as? String{
                        let decodingStr = self.replaceOccuranceOfNumeralsWith(value: text)
                        self.detailLabel.text = decodingStr
                        self.detailLabel.textColor = hexStringToUIColor(hex: detail["textColor"] as? String ?? "#000000")
                        print(detail["textColor"] as? String ?? "#012000")
                    }
                    let img = dict[3]
                    if UIDevice.current.userInterfaceIdiom == .pad {
                        print("iPad")
                        if let image = img["tabletUrl"] as? String{
                            self.imageView.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: ""))
                        }
                    } else {
                        print("not iPad")
                        if let image = img["phoneUrl"] as? String{
                            self.imageView.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: ""))
                        }
                    }
                    let coupon = dict[4]
                    if let text = coupon["data"] as? String{
                        self.couponLAbel.text =  text
                        self.couponLAbel.textColor = hexStringToUIColor(hex: coupon["textColor"] as? String ?? "#012000")
                        print(coupon["textColor"] as? String ?? "#012000")
                    }
                    let downLabel = dict[5]
                    if let text = downLabel["data"] as? String{
                        let decodingStr = self.replaceOccuranceOfNumeralsWith(value: text)
                        self.downLabel.text =  decodingStr
                        self.downLabel.textColor = hexStringToUIColor(hex: downLabel["textColor"] as? String ?? "#012000")
                        print(downLabel["textColor"] as? String ?? "#012000")
                    }
                    let button = dict[6]
                    if let text = button["data"] as? String{
                        let decodingStr = self.replaceOccuranceOfNumeralsWith(value: text)
                        self.downButton.setTitle( decodingStr, for: .normal)
                        self.downButton.backgroundColor = hexStringToUIColor(hex: button["bgColor"] as? String ?? "#012000")
                        self.downButton.setTitleColor(hexStringToUIColor(hex: button["textColor"] as? String ?? "#ffffff"), for: .normal)
                        print(button["textColor"] as? String ?? "#012000")
                    }
                }
            }
        }
    }
    
//    func decodeFeedData(data:String) {
//        let data = data.data(using: .utf8)!
//        do {
//            let decodeFeedData = try JSONDecoder().decode([Feed_Data_Model].self, from: data)
//            self.feedDataModelArr = decodeFeedData
//            print(decodeFeedData)
//
//            titleLabel.text = decodeFeedData[1].data
//            detailLabel.text = decodeFeedData[2].data
//            downLabel.text = decodeFeedData[5].data
//            couponLAbel.text = decodeFeedData[4].data
//            downButton.setTitle( decodeFeedData[6].data, for: .normal)
//            imageView.sd_setImage(with: URL(string: decodeFeedData[3].tabletURL!), placeholderImage: UIImage(named: ""))
//        } catch let error as NSError {
//            print(error)
//        }
//    }
    
    func replaceOccuranceOfNumeralsWith(value:String)->String{
        var str = ""
        //        let currentLang = UserDefaults.standard.value(forKey: "userlanguage") as? String ?? "en"
        //        if currentLang == "ar"||currentLang == "ja"||currentLang == "zh"||currentLang == "he"{
        ////            str = str.replacingOccurrences(of: "uf", with: #"\uf"#)
        //            str = str.replacingOccurrences(of: "uf", with: " uf")
        //            str = str.replacingOccurrences(of: "uf", with: #"\uf"#)
        //        }
        str = str.replacingOccurrences(of: "uf", with: #"\uf"#)
        str = value.replacingOccurrences(of: "u0", with: #"\u0"#)
        str = str.replacingOccurrences(of: "u1", with: #"\u1"#)
        str = str.replacingOccurrences(of: "u2", with: #"\u2"#)
        str = str.replacingOccurrences(of: "u3", with: #"\u3"#)
        str = str.replacingOccurrences(of: "u4", with: #"\u4"#)
        str = str.replacingOccurrences(of: "u5", with: #"\u5"#)
        str = str.replacingOccurrences(of: "u6", with: #"\u6"#)
        str = str.replacingOccurrences(of: "u7", with: #"\u7"#)
        str = str.replacingOccurrences(of: "u8", with: #"\u8"#)
        str = str.replacingOccurrences(of: "u9", with: #"\u9"#)
        str = str.decodingUnicodeCharacters
        str = str.replacingOccurrences(of: "uff05", with: "%")
        str = str.replacingOccurrences(of: "uff01", with: "!")
        str = str.replacingOccurrences(of: "uff0c", with: ",")
        str = str.replacingOccurrences(of: "uff1a", with: ":")
        return str
    }
    
    func convertToDictionary(text: String) -> Any? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options:.allowFragments) as? [Dictionary<String,Any>]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func removeSpecialCharsFromString(text: String) -> String {
        let okayChars : Set<Character> =
        Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890+-*=(),.:!_")
        return String(text.filter {okayChars.contains($0) })
    }
}
