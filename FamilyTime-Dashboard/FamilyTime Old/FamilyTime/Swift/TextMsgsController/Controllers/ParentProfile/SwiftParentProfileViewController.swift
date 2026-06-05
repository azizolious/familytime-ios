//
//  SwiftParentProfileViewController.swift
//  FamilyTime
//
//  Created by YumyApps on 21/10/2021.
//  Modified by Usama-Apps 02/01/2023.
//  Copyright © 2021 YumyApps. All rights reserved.
//

import UIKit
import IQKeyboardManager
import MBProgressHUD
import AVFoundation
import SwiftUI

class SwiftParentProfileViewController: BaseViewController, UITextFieldDelegate {
    
    
    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Variables
    var txtPhone = UITextField()
    var txtRelation = IQDropDownTextField()
    var txtLang = IQDropDownTextField()
    var txtName = UITextField()
    var txtEmail = UITextField()
    let topView = UIView()
    let lblTotalMinutes = UILabel()
    let lblDaySelected = UILabel()
    let view1 = UIView()
    let view2 = UIView()
    let refreshControl = UIRefreshControl()
    let delegate = UIApplication.shared.delegate as? AppDelegate
    var rowklanguages = [AnyHashable]()
    var rightButton = UIBarButtonItem()
    var strLanguage = ""
    var strRelationShip = ""
    var nRelationStr = ""
    var strName = ""
    var strPhone = ""
    var strEmail = ""
    var checklanguageChange = -1
    var rowDic = [AnyHashable : Any]()
    var rowkSettings = [AnyHashable]()
    var arrOfBasicInfoImages = [AnyHashable]()
    var arrOfBasicInfoData = [AnyHashable]()
    var rowArr = [AnyHashable]()
    var IndexOfDate = -1
    var imgView = UIImageView()
    var contentLbl = UILabel()
    var profileObject :  Profile?
    var subscriptionData : [SubscriptionsData]?
    var productArr = [String]()
    
    private var selectedReasonIndex: Int?
    private var hostingController:UIHostingController<CancelSubscriptionView>?
    
    //MARK: - View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshTableView()
        print(strLanguage)
        txtName.isUserInteractionEnabled = true
        txtEmail.isUserInteractionEnabled = true
        txtPhone.isUserInteractionEnabled = true
        txtLang.isUserInteractionEnabled = true
        txtRelation.isUserInteractionEnabled = true
        txtName.delegate = self
        txtEmail.delegate = self
        txtPhone.delegate = self
        rightButton = UIBarButtonItem(title: "save_button".localized, style: .plain, target: self, action: #selector(actionEditButton))
        navigationItem.rightBarButtonItems = [rightButton]
        checklanguageChange = 0
        strRelationShip = "Father"
        strLanguage = ""
        strName = ""
        strPhone = ""
        strEmail = ""
        self.tableView.isHidden = false
        arrOfBasicInfoImages.append("p_name")
        arrOfBasicInfoImages.append("p_phone")
        arrOfBasicInfoImages.append("p_email")
        arrOfBasicInfoImages.append("p_relation")
        arrOfBasicInfoData.append("Loading...".myModification())
        arrOfBasicInfoData.append("Loading...".myModification())
        arrOfBasicInfoData.append("Loading...".myModification())
        arrOfBasicInfoData.append("Loading...".myModification())
        topView.layer.borderColor = UIColor.lightGray.cgColor
        topView.layer.borderWidth = 1.0
        lblTotalMinutes.adjustsFontSizeToFitWidth = true
        self.IndexOfDate = 0
        title = "account_title".localized
        if UI_USER_INTERFACE_IDIOM() == .pad {
            imgView = UIImageView(frame: CGRect(x: 236, y: 229, width: 296, height: 212))
            imgView.contentMode = .scaleAspectFill
            imgView.image = UIImage(named: "ipad_empty")
            imgView.isHidden = true
            view.addSubview(imgView)
            view.bringSubviewToFront(imgView)
            contentLbl = UILabel(frame: CGRect(x: 203, y: 489, width: 362, height: 45))
            contentLbl.textColor = UIColor.lightGray
            contentLbl.text = "It seems like there is no record to\n display.".myModification()
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
            contentLbl = UILabel(frame: CGRect(x: 30, y: 279, width: 315, height: 41))
            contentLbl.textColor = UIColor.lightGray
            contentLbl.text = "It seems like there is no record to\n display.".myModification()
            contentLbl.font = UIFont.systemFont(ofSize: 17)
            contentLbl.lineBreakMode = .byWordWrapping
            contentLbl.numberOfLines = 2
            contentLbl.textAlignment = .center
            self.contentLbl.isHidden = true
            view.addSubview(contentLbl)
            view.bringSubviewToFront(contentLbl)
        }
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LiveVisitorManager.shared.updateScreen(
            "Profile"
        )
        ZendeskChatManager.trackEvent("Account Screen")
        self.txtName.placeholder = "account_input_content_1".localized
        self.txtPhone.placeholder = "account_input_content_2".localized
        //[_txtPhone setKeyboardType:UIKeyboardTypeNumberPad];
        txtPhone.keyboardType = .numberPad
        txtEmail.keyboardType = .emailAddress
        txtName.keyboardType = .default
        txtRelation.resignFirstResponder()
        txtLang.resignFirstResponder()
        let params = [
            "code": "en",
            "name": "English"
        ]
        let params1 = [
            "code": "ar",
            "name": "العربية"
        ]
        let params2 = [
            "code": "es",
            "name": "Español"
        ]
        let params3 = [
            "code": "fi",
            "name": "suomi"
        ]
        let params4 = [
            "code": "ja",
            "name": "日本語"
        ]
        let params5 = [
            "code": "pt",
            "name": "Português"
        ]
        let params6 = [
            "code": "de",
            "name": "Deutsch"
        ]
        
        let params7 = [
            "code": "fr",
            "name": "Français"
        ]
        let chineseLang = [
            "code": "zh",
            "name": "中文"
        ] //---Chinese---//
        let italianLang = [
            "code": "it",
            "name": "italiano"
        ]
        let turkishLang = [
            "code": "tr",
            "name": "Türkçe"
        ] //---Chinese---//
        let hebrewLang = [
            "code": "he",
            "name": "עִברִית"
        ]
        let arr = [params, params2, params3, params4, params5, params6, params7, italianLang, chineseLang, turkishLang,hebrewLang,params1]
        self.rowklanguages = arr
    }
    
    
    //MARK: - IBActions
    @IBAction func btnChangePassword(_ sender: UIButton) {
        let vc = SwiftChangePasswordViewController(nibName: "ChangePasswordViewController", bundle: Bundle.main)
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnRemoveAccount(_ sender: UIButton) {
        let isDeled = UserDefaults.standard.integer(forKey: "isAccDeleted").boolValue
        if !isDeled {
            let alert = UIAlertController(title: "Alert!".localized, message: "Do you want to delete your account?".localized, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel".localized, style: .default, handler: { action in
                print("No button is tapped")
            }))
            alert.addAction(UIAlertAction(title: "Remove".localized, style: .default, handler: { action in
                //Logout Here
                NotificationCenter.default.post(name: Notification.Name("SIGNOUT_OBSERVER"), object: nil)
                self.deleteAccount()
            }))
            
            self.present(alert, animated: true, completion: nil)
        } else {
            self.deleteAccount()
        }
    }
    
    @IBAction func btnCancelSubscription(_ sender: UIButton) {
        print("cancle subscription")
        
        navigationController?.isNavigationBarHidden = true
        
        let hosting = UIHostingController(rootView: buildCancelSubscriptionView())
        
        self.hostingController = hosting
        
        navigationController?.pushViewController(hosting, animated: true)
    }
    
    private func openCancellationChat(reason: String) {
        
        let userName =
        UserDefaults.standard.string(
            forKey: UserDefaultsConstants.USER_NAME
        ) ?? "N/A"

        let userEmail =
        UserDefaults.standard.string(
            forKey: UserDefaultsConstants.USER_EMAIL
        ) ?? "N/A"

        let subscriptionPlan =
        UserDefaults.standard.string(
            forKey: UserDefaultsConstants.BILLING_STATUS
        ) ?? "N/A"
        
        let accountId =
        UserDefaults.standard.string(
            forKey: UserDefaultsConstants.USER_ID
        ) ?? "N/A"
        
        let rawRenewalDate =
        UserDefaults.standard.string(
            forKey: UserDefaultsConstants.SUBSCRIPTION_RENEWAL_DATE
        ) ?? "N/A"

        let renewalDate =
        formattedRenewalDate(
            from: rawRenewalDate
        )
                
        let message = """
        
        Hi, I'd like to cancel my subscription.
        
        User Details:
        • Name: \(userName)
        • Email: \(userEmail)
        • Subscription Plan: \(subscriptionPlan)
        • Renewal Date: \(renewalDate)
        • Account ID: \(accountId)
        
        Reason:
        \(reason)
        
        Please help me with the cancellation process.
        
        """
        
        UserDefaults.standard.set(
            message,
            forKey: "LIVE_CHAT_PENDING_MESSAGE"
        )
        
        navigationController?
            .popToViewController(
                self,
                animated: false
            )
        
        navigationController?
            .popViewController(
                animated: true
            )
        
        closeCancelSubscriptionView()
    }
    
    private func formattedRenewalDate(
        from dateString: String
    ) -> String {

        let inputFormatter = DateFormatter()

        inputFormatter.dateFormat =
        "yyyy-MM-dd HH:mm:ss"

        guard let date =
                inputFormatter.date(
                    from: dateString
                ) else {

            return dateString
        }

        let renewalDate =
        Calendar.current.date(
            byAdding: .day,
            value: 1,
            to: date
        ) ?? date

        let outputFormatter =
        DateFormatter()

        outputFormatter.dateFormat =
        "dd-MM-yyyy"

        return outputFormatter.string(
            from: renewalDate
        )
    }
    
    private func buildCancelSubscriptionView() -> CancelSubscriptionView {
        
        CancelSubscriptionView(
            
            selectedIndex:
                selectedReasonIndex,
            
            onBack: { [weak self] in
                
                self?.navigationController?
                    .isNavigationBarHidden = false
                
                self?.selectedReasonIndex = nil
                
                self?.navigationController?
                    .popViewController(
                        animated: true
                    )
            },
            
            onSelectReason: { [weak self] index in
                
                guard let self else {
                    return
                }
                
                self.selectedReasonIndex = index
                
                self.hostingController?
                    .rootView =
                self.buildCancelSubscriptionView()
            },
            
            onContinue: { [weak self] reason in
                
                self?.navigationController?
                    .isNavigationBarHidden = false
                
                self?.openCancellationChat(
                    reason: reason.title
                )
            }
        )
    }
    
    private func closeCancelSubscriptionView() {
        
        let storyboard =
        UIStoryboard(name: StoryboardConstants.Storyboards.DASHBOARD, bundle: nil)
        
        let vc =
        storyboard.instantiateViewController(withIdentifier: StoryboardConstants.Identifiers.DASH_BOARD_VC_IDENTIFIER) as? DashboardVC
        
        delegate?.centerNavController =
        UINavigationController(rootViewController: vc ?? DashboardVC())
        
        delegate?.jasidePanel.centerPanel =
        delegate?.centerNavController
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            NotificationCenter.default.post(
                name: Notification.Name(
                    "OPEN_LIVE_CHAT"
                ),
                object: nil
            )
        }
    }
    
    func deleteAccount() {
        let isDeled = UserDefaults.standard.integer(forKey: "isAccDeleted").boolValue
        SwiftFTUtils.showHUDAdded(to: self.view, withText: "", animated: true)
        var endpoint = ""
        if isDeled {
            endpoint = "restore-account"
        } else {
            endpoint = "remove-account"
        }
        let url = HLConstants.BASE_URL_CORE_2 + endpoint
        CoreManager.networkRequest(url: url, method: .post) { (resp: EmptyResponseModel?, statusCode, mesg) in
            //
            SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
            if (200...206).contains(statusCode ?? 0) {
                if !isDeled {
                    let alert = UIAlertController(title: "Successful!", message: "Your account and all data associated with the account will be permanently deleted within 7 days.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "ok_button".localized, style: .default, handler: { action in
                        //CommonModel.clearDataAndLogout(on: self, isPresentedVC: false)
                    }))
                    self.present(alert, animated: true)
                }
                UserDefaults.standard.setValue(isDeled ? 0 : 1, forKey: "isAccDeleted")
                self.tableView.reloadSections(IndexSet(integer: 5), with: .automatic)
                
            }
        }
    }
    
    //MARK: - Objective Functions
    @objc func actionEditButton() {
        if rightButton.title == "save_button".localized {
            print(txtPhone.text!.count)
            if txtPhone.text!.count > 0 && txtPhone.text!.count < 6 {
                let alert = UIAlertController(title: "alert_title".localized, message: "account_validation_content_2".localized, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok_button".localized, style: .default, handler: { action in
                    
                }))
                self.present(alert, animated: true)
            } else if txtName.text == "" {
                let alert = UIAlertController(title: "alert_title".localized, message: "account_validation_content_1".localized, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok_button".localized, style: .default, handler: { action in
                }))
                self.present(alert, animated: true)
            } else if txtEmail.text == "" {
                let alert = UIAlertController(title: "alert_title".localized, message: "enter_email".localized, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok_button".localized, style: .default, handler: { action in
                }))
                self.present(alert, animated: true)
            } else {
                self.updateProfile()
                rightButton.title = "save_button".localized
                txtName.isUserInteractionEnabled = true
                txtEmail.isUserInteractionEnabled = true
                txtPhone.isUserInteractionEnabled = true
                txtLang.isUserInteractionEnabled = true
                txtRelation.isUserInteractionEnabled = true
            }
        } else {
            txtName.isUserInteractionEnabled = true
            txtEmail.isUserInteractionEnabled = true
            txtPhone.isUserInteractionEnabled = true
            txtLang.isUserInteractionEnabled = true
            txtRelation.isUserInteractionEnabled = true
            txtName.becomeFirstResponder()
            rightButton.title = "save_button".localized
        }
    }
    
    //MARK: ViewParentProfileData
    @objc func viewParentProfiledata() {
        //MARK: ACCOUNT API
        var language: String = ""
        let token = UserDefaultsManager.bearerTokenCore2 ?? ""
        if NSLocale.preferredLanguages.count > 1 {
            language = NSLocale.preferredLanguages[0]
        }
        SwiftFTUtils.showHUDAdded(to: view, withText: "loading...".localized, animated: true)
        HLApiManager.accountApiFunc(token: token) { response, error in
            if response != nil{
                UserDefaults.standard.removeObject(forKey: UserDefaultsConstants.PRODUCT_ACCOUNT_ARRAY)
                UserDefaults.standard.synchronize()
                self.productArr.removeAll()
                let emailVerifiedAt = response?.profile?.emailVerifiedAt
                let userLanguage = response?.profile?.language
                let phone = response?.profile?.phone
                let package = response?.profile?.package
                let gender = response?.profile?.gender
                let type = response?.profile?.type
                let id = response?.profile?.id
                let name = response?.profile?.name
                let email = response?.profile?.email
                let emailBounce = response?.profile?.emailBounce
                let emailComplaint = response?.profile?.emailComplaint
                self.arrOfBasicInfoData.removeAll()
                DispatchQueue.main.async {
                    MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                    
                    if self.rightButton.title == "save_button".localized{
                        self.txtName.isUserInteractionEnabled = true
                        self.txtEmail.isUserInteractionEnabled = true
                        self.txtPhone.isUserInteractionEnabled = true
                        self.txtLang.isUserInteractionEnabled = true
                        self.txtRelation.isUserInteractionEnabled = true
                    } else {
                        self.txtName.isUserInteractionEnabled = true
                        self.txtEmail.isUserInteractionEnabled = true
                        self.txtPhone.isUserInteractionEnabled = true
                        self.txtLang.isUserInteractionEnabled = true
                        self.txtRelation.isUserInteractionEnabled = true
                    }
                    self.refreshControl.endRefreshing()
                }
                
                if emailVerifiedAt != nil {
                    UserDefaults.standard.setValue(emailVerifiedAt, forKey: UserDefaultsConstants.EMAIL_VERIFIED_AT_ACCOUNT)
                    UserDefaults.standard.synchronize()
                } else {
                    UserDefaults.standard.setValue(nil, forKey: UserDefaultsConstants.EMAIL_VERIFIED_AT_ACCOUNT)
                    UserDefaults.standard.synchronize()
                }
                
                if emailBounce != nil {
                    UserDefaults.standard.set(emailBounce, forKey: UserDefaultsConstants.EMAIL_BOUNCE_ACCOUNT)
                    UserDefaults.standard.synchronize()
                } else {
                    UserDefaults.standard.setValue(nil, forKey: UserDefaultsConstants.EMAIL_BOUNCE_ACCOUNT)
                    UserDefaults.standard.synchronize()
                }
                
                if emailComplaint != nil {
                    UserDefaults.standard.setValue(emailComplaint, forKey: UserDefaultsConstants.EMAIL_COMPLAINT_ACCOUNT)
                    UserDefaults.standard.synchronize()
                } else {
                    UserDefaults.standard.setValue(nil, forKey: UserDefaultsConstants.EMAIL_COMPLAINT_ACCOUNT)
                    UserDefaults.standard.synchronize()
                }
                if (userLanguage != nil){
                    UserDefaults.standard.set(userLanguage, forKey: UserDefaultsConstants.USER_LANGUAGE)
                } else {
                    UserDefaults.standard.set(NSLocale.current.languageCode, forKey: UserDefaultsConstants.USER_LANGUAGE)
                }
                if (id != nil){
                    AppDelegateShared().userDefault.set(id, forKey: UserDefaultsConstants.USER_ID)
                    AppDelegateShared().userDefault.synchronize()
                } else {
                    AppDelegateShared().userDefault.set(StringConstants.Constants.EMPTY_STRING, forKey: UserDefaultsConstants.USER_ID)
                    AppDelegateShared().userDefault.synchronize()
                }
                if (name != nil){
                    self.arrOfBasicInfoData.append(name)
                    UserDefaults.standard.set(name, forKey: UserDefaultsConstants.USER_NAME)
                } else {
                    self.arrOfBasicInfoData.append("")
                    UserDefaults.standard.set(StringConstants.Constants.EMPTY_STRING, forKey: UserDefaultsConstants.USER_NAME)
                }
                if (email != nil){
                    self.arrOfBasicInfoData.append(email)
                    UserDefaults.standard.set(email, forKey: UserDefaultsConstants.USER_EMAIL)
                    AppDelegateShared().userDefault.set(email, forKey: UserDefaultsConstants.USER_EMAIL)
                    AppDelegateShared().userDefault.synchronize()
                } else {
                    self.arrOfBasicInfoData.append("")
                    UserDefaults.standard.set(StringConstants.Constants.EMPTY_STRING, forKey: UserDefaultsConstants.USER_EMAIL)
                    AppDelegateShared().userDefault.set(StringConstants.Constants.EMPTY_STRING, forKey: UserDefaultsConstants.USER_EMAIL)
                    AppDelegateShared().userDefault.synchronize()
                }
                if (phone != nil){
                    self.arrOfBasicInfoData.append(phone)
                    UserDefaults.standard.set(phone, forKey: UserDefaultsConstants.USER_PHONE)
                } else {
                    self.arrOfBasicInfoData.append("")
                    UserDefaults.standard.set(StringConstants.Constants.EMPTY_STRING, forKey: UserDefaultsConstants.USER_PHONE)
                }
                if package != nil {
                    UserDefaults.standard.set(package, forKey: UserDefaultsConstants.BILLING_STATUS)
                } else {
                    UserDefaults.standard.set(StringConstants.Constants.EMPTY_STRING, forKey: UserDefaultsConstants.BILLING_STATUS)
                }
                if (gender != nil) {
                    if gender == "male" || gender == "Male" {
                        self.strRelationShip = "Father"
                    } else {
                        self.strRelationShip = "Mother"
                    }
                    self.arrOfBasicInfoData.append(self.strRelationShip)
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
                if (type != nil) {
                    UserDefaults.standard.set(type, forKey: UserDefaultsConstants.USER_TYPE)
                } else {
                    UserDefaults.standard.set(StringConstants.Constants.EMPTY_STRING, forKey: UserDefaultsConstants.USER_TYPE)
                }
                if let subs = response?.billing?.subscriptions {
                    for value in subs {
                        let product = value.psp ?? StringConstants.Constants.EMPTY_STRING
                        self.productArr.append(product)
                        UserDefaults.standard.set(self.productArr, forKey: UserDefaultsConstants.PRODUCT_ACCOUNT_ARRAY)
                        UserDefaults.standard.synchronize()
//                        CoreDataUtility.saveSubscriptionData(subs: value)
                    }
                }
                self.strName = name ?? ""
                self.strEmail = email ?? ""
                self.strPhone = phone ?? ""
                self.strLanguage = userLanguage ?? ""
                self.txtLang.resignFirstResponder()
                self.txtRelation.resignFirstResponder()
                self.txtRelation.selectedItem = self.strRelationShip
                UserDefaults.standard.set(self.strRelationShip, forKey: "ParentRelationship")
                UserDefaults.standard.synchronize()
                var Language_id = ""
                for i in 0..<self.rowklanguages.count {
                    let strTemp = (self.rowklanguages[i] as? [AnyHashable : Any])?["code"] as? String
                    if strTemp == self.strLanguage {
                        Language_id = (self.rowklanguages[i] as? [AnyHashable : Any])?["name"] as! String
                        break
                    }
                }
                self.strLanguage = Language_id
                let drawerVC = (self.parent?.parent as? JASidePanelController)?.leftPanel as? SwiftParentDrawer
                if let drawerVC = drawerVC {
                    drawerVC.reloadView()
                }
                
            } else {
                CommonModel.showAlert("alert_something_wrong".localized, msg: error ?? "Nil")
            }
        }
    }
    
    //MARK: - Helper Functions
    func updateProfile() {
        var gender:String?
        txtName.resignFirstResponder()
        txtPhone.resignFirstResponder()
        print("\(strLanguage)")
        print("\(strRelationShip)")
        if strRelationShip == "Father" {
            gender = "male"
        } else {
            gender = "female"
        }
        SwiftFTUtils.showHUDAdded(to: view, withText: "loading...".localized, animated: true)
        var Language_id = ""
        for i in 0..<rowklanguages.count {
            let strTemp = (rowklanguages[i] as? [AnyHashable : Any])?["name"] as? String
            if strTemp == strLanguage {
                Language_id = (rowklanguages[i] as? [AnyHashable : Any])?["code"] as? String ?? ""
                break
            }
        }
        strName = txtName.text ?? ""
        strPhone = txtPhone.text ?? ""
        strEmail = txtEmail.text ?? ""
        var params: [String : Any] = [:]
        params["name"] = strName
        params["email"] = strEmail
        params["gender"] = gender ?? "male"
        params["phone"] = strPhone
        params["language"] = Language_id
        print(params)
        HLApiManager.networkCallUpdateProfile(params: params) { response, error in
            if response != nil {
                DispatchQueue.main.async {
                    print(self.strRelationShip)
                    MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                    UserDefaults.standard.set(self.strName, forKey: "userName")
                    UserDefaults.standard.set(self.strPhone, forKey: "userPhone")
                    UserDefaults.standard.set(self.strRelationShip, forKey: "userRelation")
                    UserDefaults.standard.set(self.strEmail, forKey: "userEmail")
                    UserDefaults.standard.set(Language_id, forKey: "userlanguage")
                    UserDefaults.standard.synchronize()
                    if Language_id == "" {
                    } else {
                        if self.checklanguageChange == 1 {
                            UserDefaults.standard.set([Language_id, "ru"], forKey: "AppleLanguages")
                            let alertController = UIAlertController(
                                title: "alert_title".localized,
                                message: "account_alert_content_2".localized,
                                preferredStyle: .alert)
                            let cancelAction = UIAlertAction(
                                title: NSLocalizedString("ok_button".localized, comment: "Ok action"),
                                style: .default,
                                handler: { action in
                                    print(Language_id)
                                    //                                    Bundle.setLanguage(Language_id)
                                    //                                    SwiftCommonUtility.resetViewController()
                                })
                            alertController.addAction(cancelAction)
                            //                [alertController addAction:okAction];
                            self.present(alertController, animated: true)
                        } else {
                            // self.tableView.reloadData()
                            let alertController = UIAlertController(
                                title: "".myModification(),
                                message: "account_alert_content_1".localized,
                                preferredStyle: .alert)
                            let cancelAction = UIAlertAction(
                                title: NSLocalizedString("ok_button".localized, comment: "Cancel action"),
                                style: .cancel,
                                handler: { action in
                                    print("Cancel action")
                                })
                            alertController.addAction(cancelAction)
                            self.present(alertController, animated: true)
                        }
                    }
                }
                self.viewParentProfiledata()
            } else {
                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                CommonModel.showAlert("Alert!", msg: error ?? "Nil")
            }
        }
    }
    
    func validate(_ string: String?, withPattern pattern: String?) -> Bool {
        var regex: NSRegularExpression? = nil
        do {
            regex = try NSRegularExpression(pattern: pattern ?? "", options: .caseInsensitive)
        } catch {
            
        }
        assert((regex != nil), "Unable to create regular expression")
        let textRange = NSRange(location: 0, length: string!.count)
        let matchRange = regex?.rangeOfFirstMatch(in: string!, options: .reportProgress, range: textRange)
        var didValidate = false
        // Did we find a matching range
        if matchRange?.location != NSNotFound {
            didValidate = true
        }
        return didValidate
    }
    
    func refreshTableView() {
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(viewParentProfiledata), for: .valueChanged)
    }
    
    func refreshTable() {
        refreshControl.endRefreshing()
        tableView.reloadData()
    }
    
    func dataShowAll() {
        imgView.isHidden = true
        contentLbl.isHidden = true
        view1.isHidden = false
        view2.isHidden = false
        tableView.isHidden = false
    }
    
    func nodataShowNew() {
        imgView.isHidden = false
        view1.isHidden = false
        view2.isHidden = true
        view.backgroundColor = UIColor.white
        tableView.isHidden = true
        
    }
    
    func doneClicked(_ button: UIBarButtonItem?) {
        view.endEditing(true)
    }
    
    //MARK: - Textfield Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        rightButton.title = "save_button".localized
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtRelation {
            checklanguageChange = 0
            if txtRelation.selectedRow == 0 {
                strRelationShip = "Father"
                nRelationStr = "Father"
                UserDefaults.standard.set("Father", forKey: "userRelation")
                tableView.reloadData()
                print(textField)
            } else {
                strRelationShip = "Mother"
                nRelationStr = "Mother"
                UserDefaults.standard.set("Mother", forKey: "userRelation")
                tableView.reloadData()
            }
            //        [self UpdateProfile];
        } else if textField == txtLang {
            checklanguageChange = 1
            
            strLanguage = textField.text ?? ""
            //        [self UpdateProfile];
        }
        
    }
}

//MARK: - TableView Data Source and Delegate
extension SwiftParentProfileViewController: UITableViewDataSource, UITableViewDelegate, IQDropDownTextFieldDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 2
        } else if section == 2 {
            return arrOfBasicInfoImages.count
        } else if section == 3 {
            return 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Active Parents"
        } else if section == 1 {
            return nil
        } else if section == 2 {
            return "account_content_1".localized
        } else if section == 3 {
            return ""
        } else {
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 18 + 5))
        let viewTop = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        let viewBottom = UIView(frame: CGRect(x: 0, y: 17, width: tableView.frame.size.width, height: 1))
        viewTop.backgroundColor = UIColor.lightGray
        viewBottom.backgroundColor = UIColor.lightGray
        // Create custom view to display section header...
        let label = UILabel()
        if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
            label.frame = CGRect(x: self.tableView.frame.size.width - 200 - 18, y: 10, width: 200, height: 23)
        } else {
            label.frame = CGRect(x: 18, y: 10, width: 200, height: 23)
        }
        label.font = UIFont.boldSystemFont(ofSize: 12)
        //    NSString *string =[list objectAtIndex:section];
        var string = ""
        view.backgroundColor = UIColor.white
        if section == 1 {
            string = "Subscription"
            //        return @"Basic information";
            //        return @"Languages";
        } else if section == 2 {
            string = "account_content_1".localized
        } else if section == 3 {
            //        string= @"Change Language";
            string = ""
            return nil
        } else if section == 4 {
            //        return nil;
            string = ""
            view.frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 13.0)
            view.backgroundColor = UIColor.groupTableViewBackground
            let viewTop = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 0.5))
            let viewBottom = UIView(frame: CGRect(x: 0, y: 12.5, width: tableView.frame.size.width, height: 0.5))
            viewTop.backgroundColor = UIColor(red: 200.0 / 255.0, green: 199.0 / 255, blue: 204.0 / 255, alpha: 1.0)
            viewBottom.backgroundColor = UIColor(red: 200.0 / 255.0, green: 199.0 / 255, blue: 204.0 / 255, alpha: 1.0)
            //        [viewBottom setBackgroundColor:[UIColor lightGrayColor]];
            view.addSubview(viewTop)
            view.addSubview(viewBottom)
        } else {
            string = ""
        }
        label.text = string
        view.addSubview(label)
        label.textColor = UIColor(red: 114.0 / 255.0, green: 102.0 / 255.0, blue: 186.0 / 255.0, alpha: 1.0)
        label.font = UIFont(name: "OpenSans-semibold", size: 17)
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let simpleTableIdentifier = "ProfilePic"
                cell = tableView.dequeueReusableCell(withIdentifier: simpleTableIdentifier)
                if cell == nil {
                    cell = UITableViewCell(style: .default, reuseIdentifier: simpleTableIdentifier)
                }
                let LabelTitle = cell?.viewWithTag(1) as? UILabel
                let LabelSubTitle = cell?.viewWithTag(2) as? UILabel
                let imgview = cell?.viewWithTag(3) as? UIImageView
                let name = UserDefaults.standard.string(forKey: "userName")
                let email = UserDefaults.standard.string(forKey: "userEmail")
                LabelTitle?.text = name
                LabelSubTitle?.text = email
                strRelationShip = UserDefaults.standard.string(forKey: "userRelation") ?? ""
                //                strRelationShip = delegate?.parent.relationship ?? ""
                strRelationShip = "\(strRelationShip.substring(to: 1).uppercased())\(strRelationShip.substring(from: 1))"
                print(strRelationShip)
                if strRelationShip == "Mother" || nRelationStr == "Mother" {
                    imgview?.image = UIImage(named: "in_parent_f")
                } else {
                    imgview?.image = UIImage(named: "in_parent_m")
                }
            }
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let simpleTableIdentifier = "Free"
                cell = tableView.dequeueReusableCell(withIdentifier: simpleTableIdentifier)
                if cell == nil {
                    cell = UITableViewCell(style: .default, reuseIdentifier: simpleTableIdentifier)
                }
            } else if indexPath.row == 1 {
                let simpleTableIdentifier = "GoPremium"
                cell = tableView.dequeueReusableCell(withIdentifier: simpleTableIdentifier)
                if cell == nil {
                    cell = UITableViewCell(style: .default, reuseIdentifier: simpleTableIdentifier)
                }
            }
        } else if indexPath.section == 2 {
            if indexPath.row == arrOfBasicInfoImages.count - 1 {
                let simpleTableIdentifier = "BasicInfoList"
                cell = tableView.dequeueReusableCell(withIdentifier: simpleTableIdentifier)
                if cell == nil {
                    cell = UITableViewCell(style: .default, reuseIdentifier: simpleTableIdentifier)
                }
                let imgView11 = cell?.viewWithTag(1) as? UIImageView
                let lblTitle = cell?.viewWithTag(2) as? UILabel
                imgView11?.image = UIImage(named: arrOfBasicInfoImages[indexPath.row] as? String ?? "")
                lblTitle?.text = arrOfBasicInfoData[indexPath.row] as? String
                lblTitle?.text = ""
                let textFieldTextPicker = cell?.viewWithTag(3) as? IQDropDownTextField
                textFieldTextPicker?.delegate = self
                textFieldTextPicker?.isOptionalDropDown = false
                textFieldTextPicker?.autocorrectionType = .no
                textFieldTextPicker?.itemList = [NSLocalizedString("account_gender_drop_down_1", comment: ""), NSLocalizedString("account_gender_drop_down_2", comment: "")]
                if UserDefaults.standard.string(forKey: "userRelation") == "Mother" {
                    textFieldTextPicker?.selectedItem = "account_gender_drop_down_2".localized
                } else {
                    textFieldTextPicker?.selectedItem = "account_gender_drop_down_1".localized
                }
                txtRelation = textFieldTextPicker!
            } else {
                let simpleTableIdentifier = "BasicInfo"
                cell = tableView.dequeueReusableCell(withIdentifier: simpleTableIdentifier)
                if cell == nil {
                    cell = UITableViewCell(style: .default, reuseIdentifier: simpleTableIdentifier)
                }
                let imgView11 = cell?.viewWithTag(1) as? UIImageView
                let lblTitle = cell?.viewWithTag(2) as? UILabel
                let txtFieldTitle = cell?.viewWithTag(3) as? UITextField
                imgView11?.image = UIImage(named: arrOfBasicInfoImages[indexPath.row] as? String ?? "")
                lblTitle?.text = arrOfBasicInfoData[indexPath.row] as? String
                lblTitle?.isHidden = true
                if indexPath.row == 0 {
                    txtFieldTitle?.text = UserDefaults.standard.string(forKey: "userName")
                    txtFieldTitle?.placeholder = "account_input_content_1".localized
                    txtFieldTitle?.keyboardType = .default
                    txtName = txtFieldTitle!
                } else if indexPath.row == 1 {
                    txtFieldTitle?.text = UserDefaults.standard.string(forKey: "userPhone")
                    txtFieldTitle?.placeholder = "account_input_content_2".localized
                    txtFieldTitle?.keyboardType = .numberPad
                    txtPhone = txtFieldTitle!
                } else if indexPath.row == 2 {
                    txtFieldTitle?.text = UserDefaults.standard.string(forKey: "userEmail")
                    txtFieldTitle?.placeholder = "invite_parent_input_content_2".localized
                    txtFieldTitle?.keyboardType = .emailAddress
                    txtEmail = txtFieldTitle!
                }
            }
        } else if indexPath.section == 3 {
            let simpleTableIdentifier = "BasicInfoListChangelanguage"
            cell = tableView.dequeueReusableCell(withIdentifier: simpleTableIdentifier)
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: simpleTableIdentifier)
            }
            let imgView11 = cell?.viewWithTag(1) as? UIImageView
            imgView11?.image = UIImage(named: "p_english")
            let lbllanguagessss = cell?.viewWithTag(55) as? UILabel
            //            print(lbllanguagessss?.text?.myModification())
            lbllanguagessss?.text = "account_content_2".localized
            let lblTitle = cell?.viewWithTag(2) as? UILabel
            let vwLine = cell?.viewWithTag(12)
            vwLine?.isHidden = true
            let textFieldTextPicker = cell?.viewWithTag(3) as? IQDropDownTextField
            textFieldTextPicker?.isOptionalDropDown = false
            var arrTest: [String] = []
            print("ALL=")
            print("\(rowklanguages)")
            if rowklanguages.count > 0 {
                for i in 0..<rowklanguages.count {
                    if let object = (rowklanguages[i] as? [AnyHashable : Any])?["name"] {
                        arrTest.append(object as? String ?? "")
                    }
                }
                textFieldTextPicker?.dropDownMode = .textPicker
                textFieldTextPicker?.isOptionalDropDown = false
                textFieldTextPicker?.itemList = arrTest
            } else {
                textFieldTextPicker?.itemList = ["English"]
            }
            textFieldTextPicker?.delegate = self
            var Language_id = ""
            for i in 0..<rowklanguages.count {
                let strTemp = (rowklanguages[i] as? [AnyHashable : Any])?["code"] as? String
                if strTemp == UserDefaults.standard.string(forKey: "userlanguage") {
                    Language_id = (rowklanguages[i] as? [AnyHashable : Any])?["name"] as? String ?? ""
                    break
                }
            }
            strLanguage = Language_id
            lblTitle?.text = ""
            textFieldTextPicker?.selectedItem = strLanguage
            txtLang = textFieldTextPicker!
            var language11 = Bundle.main.preferredLocalizations[0]
            let arrNew = language11.components(separatedBy: "-")
            language11 = arrNew[0]
            print("\(language11)")
            //language11=language11
            var LanguageHere = ""
            for i in 0..<rowklanguages.count {
                let strTemp = (rowklanguages[i] as? [AnyHashable : Any])?["code"] as? String
                if strTemp == language11 {
                    if let object = (rowklanguages[i] as? [AnyHashable : Any])?["name"] {
                        LanguageHere = object as! String
                    }
                    break
                }
            }
            if LanguageHere == "" {
                textFieldTextPicker?.selectedItem = "English"
            } else {
                textFieldTextPicker?.selectedItem = LanguageHere
            }
            
        } else if indexPath.section == 4 {
            let simpleTableIdentifier = "ChangePassword"
            cell = tableView.dequeueReusableCell(withIdentifier: simpleTableIdentifier)
            let btnMain = cell?.viewWithTag(33) as? UIButton
            print("change password translation = \(String(describing: "Change Password".myModification()))")
            btnMain?.setTitle(NSLocalizedString("account_button", comment: ""), for: .normal)
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: simpleTableIdentifier)
            }
        } else if indexPath.section == 5 {
            let simpleTableIdentifier = "CancelSubscription"
            cell = tableView.dequeueReusableCell(withIdentifier: simpleTableIdentifier)
            let btnMain = cell?.viewWithTag(33) as? UIButton
            print("Cancel Subscription translation = \(String(describing: "Cancel Subscription".myModification()))")
            btnMain?.setTitle(NSLocalizedString("cancel_subscription_button", comment: ""), for: .normal)
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: simpleTableIdentifier)
            }
        } else if indexPath.section == 6 {
            let simpleTableIdentifier = "DeleteAccountCell"
            cell = tableView.dequeueReusableCell(withIdentifier: simpleTableIdentifier)
            let btnMain = cell?.viewWithTag(233) as? UIButton
            let isDeled = UserDefaults.standard.integer(forKey: "isAccDeleted")
           // print("change password translation = \(String(describing: "Change Password".myModification()))")
            btnMain?.setTitle(NSLocalizedString(isDeled == 0 ? "Delete My Account" : "Restore My Account", comment: ""), for: .normal)
            //btnMain?.titleLabel?.textColor = isDeled == 1 ? .red : .green
            btnMain?.setTitleColor(isDeled == 0 ? .red : UIColor(hexString: "#31B237"), for: .normal)
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: simpleTableIdentifier)
            }
        } else {
            tableView.separatorStyle = .none
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else if section == 1 {
            return 0
        } else if section == 3 {
            return 0
        } else if section == 4 {
            return 13
        } else if section == 5 {
            return 2
        } else if section == 6 {
            return 2
        } else {
            return 29
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 219
        } else if indexPath.section == 1 {
            return 0
        } else if indexPath.section == 3 {
            return 107
        } else if indexPath.section == 5 {
            return 50
        } else {
            return 51
        }
    }
}
