//
//  DataUseVC.swift
//  FamilyTimeChild
//
//  Created by Sana-Ullah on 15/01/2020.
//  Copyright © 2020 YumyApps. All rights reserved.
//

import UIKit
import FirebaseAnalytics

class DataUseVC: UIViewController {

    
    //MARK: - IBOutlets
    @IBOutlet weak var unicodeLbl1: UILabel!
    @IBOutlet weak var unicodeLbl2: UILabel!
    @IBOutlet weak var unicodeLbl3: UILabel!
    @IBOutlet weak var unicodeLbl4: UILabel!
    @IBOutlet weak var agreeButtonHeightAnchor: NSLayoutConstraint!
    @IBOutlet weak var disclaimerLabel: UILabel!
    @IBOutlet weak var cancelButtonOutlet: UIButton!
    @IBOutlet weak var agreeButtonOutlet: UIButton! {
        didSet {
            agreeButtonOutlet.layer.cornerRadius = 9.0
            agreeButtonOutlet.layer.masksToBounds = true
        }
    }
    
    //MARK: - Variables
    var isAgreeHidden : Bool = false
    var isInAppOn : Bool = false
    var subId : String?
    var isComingFromDrawer: Bool = false
    
    //MARK: - View LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        title = "Data Collection and Use"
        // Do any additional setup after loading the view.
        setText()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isAgreeHidden {
            print(StringConstants.Errors.DO_NOTHING)
        } else {
            self.navigationController?.isNavigationBarHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if isAgreeHidden {
            print(StringConstants.Errors.DO_NOTHING)
        } else {
            self.navigationController?.isNavigationBarHidden = false
        }
    }
    
    //MARK: - IBActions
    
    @IBAction func agreeButtonPressed(_ sender: Any) {
        if subId != nil {
            if let subId = subId {
                Analytics.logEvent("app_store_subscription_renew", parameters: [
                    "upgrade_status": "in_app_upgrade_compeleted_internal",
                    "screen_name": "in_app_upgrade_screen"
                        ])
                IAPUtility.shared.autoRenewablePurchase(prodId: subId, vc: self)
            }
        } else {
            print("Sub id is nil...")
//            if UserDefaultsManager.AddChildWithQRScan == true {
//                //Jump to QRCode Screen
//                let storyboard = UIStoryboard(name: StoryboardConstants.Storyboards.AUTH, bundle: Bundle.main)
//                let vc = storyboard.instantiateViewController(withIdentifier: StoryboardConstants.Identifiers.QR_CODE_VC_IDENTIFIER) as! QRCodeScreenController
//                vc.navigationController?.isNavigationBarHidden = true
//                self.navigationController?.pushViewController(vc, animated: true)
//
//            } else {
//                // Jump to Detailed Instructions Screen
//                let storyboard = UIStoryboard(name: StoryboardConstants.Storyboards.AUTH, bundle: Bundle.main)
//                let vc = storyboard.instantiateViewController(withIdentifier: StoryboardConstants.Identifiers.DETAILED_INSTRUCTIONS_VC_IDENTIFIER) as! DetailedInstructionsScreenController
//                vc.navigationController?.isNavigationBarHidden = true
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        if isComingFromDrawer {
            UserDefaults.standard.set(false, forKey: UserDefaultsConstants.FROM_DATA_USE_SCREEN)
            UserDefaults.standard.synchronize()
        } else {
            UserDefaults.standard.set(true, forKey: UserDefaultsConstants.FROM_DATA_USE_SCREEN)
            UserDefaults.standard.synchronize()
        }
        if #available(iOS 13.0, *) {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func setText(){
        unicodeLbl1.text = "\u{2022}"
        unicodeLbl2.text = "\u{2022}"
        unicodeLbl3.text = "\u{2022}"
        unicodeLbl4.text = "\u{2022}"
        
        let requiredText = StringConstants.Constants.DISCLAIMER_DISCRIPTION
        let changedAttributedText = requiredText.attributedString([StringConstants.Constants.DISCLAIMER], color: UIColor.black, font: UIFont.appFont(type: UIFont.FontType.SemiBold, size: 14.0))
        self.disclaimerLabel.attributedText = changedAttributedText
        
        if isAgreeHidden {
            self.agreeButtonOutlet.isHidden = true
            self.cancelButtonOutlet.isHidden = true
            self.agreeButtonHeightAnchor.constant = 0
        } else {
            self.agreeButtonOutlet.isHidden = false
            self.cancelButtonOutlet.isHidden = false
            self.agreeButtonHeightAnchor.constant = 50
        }
    }
}
