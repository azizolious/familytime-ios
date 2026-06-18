//
//  SyncPopUpViewController.swift
//  FamilyTime
//
//  Created by YumyApps on 19/11/2021.
//  Modified by Usama-Apps on 04/01/2023.
//  Copyright © 2021 YumyApps. All rights reserved.
//

import UIKit
import MBProgressHUD

@objc class SyncPopUpViewController: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var popUpImage: UIImageView!
    @IBOutlet weak var popUpTitleLabel: UILabel?
    @IBOutlet weak var popUpDescriptionLabel: UILabel?
    @IBOutlet weak var popUpLaterButton: UIButton?
    @IBOutlet weak var popUpSyncButton: UIButton?
    
    //MARK: - Variables
    var settingScreenStr = ""
    var callback : ((String) -> Void)?
    var alertTitle = "settings_card_5_1".localized
    var firstParagraph = "schedule_screen_time_sync_popup_content_1".localized
    let delegate = UIApplication.shared.delegate as? AppDelegate
    let child_Id = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
    
    //MARK: - View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupSyncButton()
        self.setupLaterButton()
        self.setupLabel()
        if UIView.appearance().semanticContentAttribute == .forceRightToLeft{
            self.popUpDescriptionLabel?.textAlignment = .right
        } else {
            self.popUpDescriptionLabel?.textAlignment = .left
        }
    }
    
    //MARK: - IBActions
    @IBAction func actionLaterButton(_ sender: UIButton) {
        callback?("NO")
        dismiss(animated: true)
        UserDefaults.standard.set("YES", forKey: "gobacknow")
        UserDefaults.standard.synchronize()
    }
    
    @IBAction func actionSyncButton(_ sender: UIButton) {
        if settingScreenStr == "1" {
            callback?("YES")
            dismiss(animated: true)
        } else {
            synSettings()
        }
    }
    
    //MARK: - Helper Functions
    func setupSyncButton() {
        if IS_IPHONE_4() {
            popUpSyncButton?.titleLabel?.font = UIFont(name: "OpenSans", size: 13)
        } else if IS_IPHONE_5() {
            popUpSyncButton?.titleLabel?.font = UIFont(name: "OpenSans", size: 13)
        } else if IS_IPHONE_6() {
            popUpSyncButton?.titleLabel?.font = UIFont(name: "OpenSans", size: 14)
        } else if IS_IPHONE_6_PLUS() {
            popUpSyncButton?.titleLabel?.font = UIFont(name: "OpenSans", size: 15)
        } else if IS_IPHONE_X() {
            popUpSyncButton?.titleLabel?.font = UIFont(name: "OpenSans", size: 15)
        } else if IS_IPHONE_8s() {
            popUpSyncButton?.titleLabel?.font = UIFont(name: "OpenSans", size: 15)
        } else {
            popUpSyncButton?.titleLabel?.font = UIFont(name: "OpenSans", size: 20)
        }
        popUpSyncButton?.setTitleColor(UIColor.white, for: .normal)
        popUpSyncButton?.backgroundColor = CommonModel.color(fromHexString: "blue")
        popUpSyncButton?.setTitle("schedule_screen_time_sync_popup_button_2".localized, for: .normal)
    }
    
    func setupLaterButton() {
        popUpLaterButton?.setTitleColor(UIColor.white, for: .normal)
        popUpLaterButton?.backgroundColor = CommonModel.color(fromHexString: "blue")
        popUpLaterButton?.setTitle("schedule_screen_time_sync_popup_button_1".localized, for: .normal)
        //        popUpLaterButton?.selectiveBorderFlag = UInt(AUISelectiveBordersFlagRight)
        //        popUpLaterButton?.selectiveBordersColor = UIColor.white
        //        popUpLaterButton?.selectiveBordersWidth = 1.0
        if IS_IPHONE_4() {
            popUpLaterButton?.titleLabel?.font = UIFont(name: "OpenSans", size: 13)
        } else if IS_IPHONE_5() {
            popUpLaterButton?.titleLabel?.font = UIFont(name: "OpenSans", size: 13)
        } else if IS_IPHONE_6() {
            popUpLaterButton?.titleLabel?.font = UIFont(name: "OpenSans", size: 14)
        } else if IS_IPHONE_6_PLUS() {
            popUpLaterButton?.titleLabel?.font = UIFont(name: "OpenSans", size: 15)
        } else if IS_IPHONE_X() {
            popUpLaterButton?.titleLabel?.font = UIFont(name: "OpenSans", size: 15)
        } else if IS_IPHONE_8s() {
            popUpLaterButton?.titleLabel?.font = UIFont(name: "OpenSans", size: 15)
        } else {
            popUpLaterButton?.titleLabel?.font = UIFont(name: "OpenSans", size: 20)
        }
    }
    
    func setupLabel() {
        let titleMessage = NSMutableAttributedString(string: alertTitle)
        titleMessage.addAttribute(.foregroundColor, value: RGBCOLOR(96, 96, 96, 1), range: NSRange(location: 0, length: titleMessage.length))
        let paragraphStyleTitle = NSMutableParagraphStyle()
        paragraphStyleTitle.alignment = .center
        titleMessage.addAttribute(.paragraphStyle, value: paragraphStyleTitle, range: NSRange(location: 0, length: titleMessage.length))
        let firstParagraph = NSMutableAttributedString(string: self.firstParagraph)
        firstParagraph.addAttribute(.foregroundColor, value: RGBCOLOR(118, 118, 118, 1), range: NSRange(location: 0, length: firstParagraph.length))
        let paragraphStyleFirstParagraph = NSMutableParagraphStyle()
        paragraphStyleFirstParagraph.alignment = .left
        firstParagraph.addAttribute(.paragraphStyle, value: paragraphStyleFirstParagraph, range: NSRange(location: 0, length: firstParagraph.length))
        if IS_IPHONE_4() {
            titleMessage.addAttribute(.font, value: UIFont(name: "OpenSans-Semibold", size: 20) ?? UIFont(), range: NSRange(location: 0, length: titleMessage.length))
            firstParagraph.addAttribute(.font, value: UIFont(name: "OpenSans-Light", size: 12) ?? UIFont(), range: NSRange(location: 0, length: firstParagraph.length))
        } else if IS_IPHONE_5() {
            titleMessage.addAttribute(.font, value: UIFont(name: "OpenSans-Semibold", size: 20) ?? UIFont(), range: NSRange(location: 0, length: titleMessage.length))
            firstParagraph.addAttribute(.font, value: UIFont(name: "OpenSans-Light", size: 12) ?? UIFont(), range: NSRange(location: 0, length: firstParagraph.length))
        } else if IS_IPHONE_6() {
            titleMessage.addAttribute(.font, value: UIFont(name: "OpenSans-Semibold", size: 22) ?? UIFont(), range: NSRange(location: 0, length: titleMessage.length))
            firstParagraph.addAttribute(.font, value: UIFont(name: "OpenSans-Light", size: 13) ?? UIFont(), range: NSRange(location: 0, length: firstParagraph.length))
        } else if IS_IPHONE_6_PLUS() {
            titleMessage.addAttribute(.font, value: UIFont(name: "OpenSans-Semibold", size: 24) ?? UIFont(), range: NSRange(location: 0, length: titleMessage.length))
            firstParagraph.addAttribute(.font, value: UIFont(name: "OpenSans-Light", size: 14) ?? UIFont(), range: NSRange(location: 0, length: firstParagraph.length))
        } else if IS_IPHONE_X() {
            titleMessage.addAttribute(.font, value: UIFont(name: "OpenSans-Semibold", size: 24) ?? UIFont(), range: NSRange(location: 0, length: titleMessage.length))
            firstParagraph.addAttribute(.font, value: UIFont(name: "OpenSans-Light", size: 14) ?? UIFont(), range: NSRange(location: 0, length: firstParagraph.length))
        } else if IS_IPHONE_8s() {
            titleMessage.addAttribute(.font, value: UIFont(name: "OpenSans-Semibold", size: 24) ?? UIFont(), range: NSRange(location: 0, length: titleMessage.length))
            firstParagraph.addAttribute(.font, value: UIFont(name: "OpenSans-Light", size: 14) ?? UIFont(), range: NSRange(location: 0, length: firstParagraph.length))
        } else {
            titleMessage.addAttribute(.font, value: UIFont(name: "OpenSans-Semibold", size: 36) ?? UIFont(), range: NSRange(location: 0, length: titleMessage.length))
            firstParagraph.addAttribute(.font, value: UIFont(name: "OpenSans-Light", size: 19) ?? UIFont(), range: NSRange(location: 0, length: firstParagraph.length))
        }
        popUpTitleLabel?.attributedText = titleMessage
        popUpDescriptionLabel?.attributedText = firstParagraph
    }
    
    func synSettings() {
        SwiftFTUtils.showHUDAdded(to: view, withText: "Loading...".myModification(), animated: true)
        CoreManager.syncSstSettings(params: ["feature": "all"]) { message, success in
            SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
            if success {
                self.dismiss(animated: true) {
                    NotificationCenter.default.post(name: NSNotification.Name("syncComplete"), object: nil)
                }
            } else {
                let alert = UIAlertController(title: "alert_error".localized, message: message , preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok_button".localized, style: .default, handler: { action in
                    self.dismiss(animated: true) {
                        NotificationCenter.default.post(name: NSNotification.Name("syncComplete"), object: nil)
                    }
                }))
                self.present(alert, animated: true, completion: nil)
                UserDefaults.standard.set("YES", forKey: "gobacknow")
                UserDefaults.standard.synchronize()
            }
        }
    }
    
//    func synSettings() {
//
//        //        SwiftFTUtils.showHUDAdded(to: view, withText: "Loading...".myModification(), animated: true)
//        //        CoreManager.syncSettings(params: ["feature": "all"]) {
//        //            SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
//        //        }
//
//        SwiftFTUtils.showHUDAdded(to: view, withText: "Loading...".myModification(), animated: true)
//        let url = String(format: "\(kSyncSettings)/\(Int(child_Id ?? "") ?? 0)")
//        ApiManager.shared().mesh_postApi(withOutParam: url) { json, errorCode, message in
//            DispatchQueue.main.async {
//                print("syncSettingsPopup api response = \(json)")
//                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
//                print("after parsing model = \(json)")
//                let status = (json["status"] as? NSNumber)?.intValue ?? 0
//                if status != 200 {
//                    let message = json["message"] as? String
//                    let alert = UIAlertController(title: "alert_error".localized, message: message ?? "", preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "ok_button".localized, style: .default, handler: { action in
//                        self.dismiss(animated: true) {
//                            NotificationCenter.default.post(name: NSNotification.Name("syncComplete"), object: nil)
//                        }
//                    }))
//                    self.present(alert, animated: true, completion: nil)
//                } else {
//                    let message = json["message"] as? String
//                    let alert = UIAlertController(title: "settings_card_5_1".localized, message: "sync_alert_content_1".localized, preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "ok_button".localized, style: .default, handler: { action in
//                        self.dismiss(animated: true) {
//                            NotificationCenter.default.post(name: NSNotification.Name("syncComplete"), object: nil)
//                        }
//                    }))
//                    self.present(alert, animated: true, completion: nil)
//                    UserDefaults.standard.set("YES", forKey: "gobacknow")
//                    UserDefaults.standard.synchronize()
//                }
//            }
//        }
//    }
}
