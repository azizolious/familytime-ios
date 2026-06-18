//
//  LoginViewController.swift
//  FamilyTime - Dashboard
//
//  Created by Muhammad Ajmal on 02/05/2017.
//  Copyright © 2017 SoraCode. All rights reserved.
//  Updated by Usama-Apps on 10/03/2022.
//

import UIKit
import ActiveLabel
import MBProgressHUD

@objc
class LoginViewController: UIViewController  {
    
    //MARK: - IBOutlets
    @IBOutlet var vAuthenticationMethods: UIStackView!
    @IBOutlet var btnWithGoogle: UIButton!
    @IBOutlet var btnWithEmail: UIButton!
    @IBOutlet var btnWithApple: UIButton!
    @IBOutlet var vBtnWithApple: UIView!
    @IBOutlet var vInputFields: UIView!
    @IBOutlet var txtFldEmail: SkyFloatingLabelTextField!
    @IBOutlet var txtFldPassword: SkyFloatingLabelTextField!
    @IBOutlet var btnForgotPassword: UIButton!
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var lblHeading: UILabel!
    @IBOutlet var vHeadings: UIStackView!
    @IBOutlet var heightVAuthentication: NSLayoutConstraint!
    @IBOutlet weak var registerOrLoginLabel: UILabel!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var disclaimerLabel: UILabel!
    @IBOutlet weak var privacyAndPolicyLabel: UILabel!
    @IBOutlet weak var showPasswordBtn: UIButton!
    
    //MARK: - Variables
    var logoImageView: UIImageView!
    var animationDone = false
    var removeObserver = false
    private var childArray : [[String:Any]] = []
    private var userLanguage : String?
    private var package : String?
    private var userID : Int?
    private var userName:String?
    private var userEmail : String?
    private var userPhoneNumber : String?
    private var userGender : String?
    private var userType : String?
    var productArr = [String]()
    var profileObject :  Profile?
    var subscriptionData : [SubscriptionsData]?
    var paswrdBtnState: Bool = false
    
    //MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: GoogleSignIn disabled temporarily — replace with GoogleSignIn 7.x via SPM when legacy Auth VCs are removed
        //GIDSignIn.sharedInstance().uiDelegate = self
        NotificationCenter.default.addObserver(self,selector: #selector(LoginViewController.receiveToggleAuthUINotification(_:)), name: NotificationKeys().GmailAuthentication,object: nil)
        
        if #available(iOS 13.0, *) {
            HLAuthenticationAppleUser.shared.addActionToAppleButton(btnWithApple)
            HLAuthenticationAppleUser.shared.dataRecievedSuccessfully = { (name, email, appleIdentifier,token) in
                guard let userToken = token , token != nil else {
                    print("Token is not available!!")
                    return
                }
                self.loginWithNewApiCore2(email: "", password: "", signInType: NetworkCallConstants.Parameters.APPLE, accessToken: userToken, providerName: NetworkCallConstants.Parameters.APPLE)
            }
        } else {
            let vAppleBtn = vAuthenticationMethods.arrangedSubviews[1]
            vAppleBtn.isHidden = true
            DispatchQueue.main.async {
                self.heightVAuthentication.constant = Device.pad ? 135 : 90
            }
        }
        
        let requiredText = "disclaimer_text".localized
        //Privacy and Policy
        let text = StringConstants.Translation.BY_CONTINUING_YOU_ARE_AGREE + " " + StringConstants.Translation.TERMS_AND_CONDITIONS + " " + StringConstants.Translation.AND + " " + StringConstants.Translation.PRIVACY_POLICY
        privacyAndPolicyLabel.text = text
        self.privacyAndPolicyLabel.textColor = ColorConstants.PRIVACY_POLICY_TEXT_COLOR
        let underlineAttriString = NSMutableAttributedString(string: text)
        let termsRange = (text as NSString).range(of: StringConstants.Translation.TERMS_AND_CONDITIONS)
        underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: termsRange)
        underlineAttriString.addAttribute(NSAttributedString.Key.font, value: UIFont.init(name: FontConstants.ROBOTO, size: 14.0)!, range: termsRange)
        underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: ColorConstants.PRIVACY_POLICY_TEXT_COLOR, range: termsRange)
        let privacyRange = (text as NSString).range(of: StringConstants.Translation.PRIVACY_POLICY)
        underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: privacyRange)
        underlineAttriString.addAttribute(NSAttributedString.Key.font, value: UIFont.init(name: FontConstants.ROBOTO, size: 14.0)!, range: privacyRange)
        underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: ColorConstants.PRIVACY_POLICY_TEXT_COLOR, range: privacyRange)
        privacyAndPolicyLabel.attributedText = underlineAttriString
        privacyAndPolicyLabel.isUserInteractionEnabled = true
        privacyAndPolicyLabel.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapLabel(gesture:))))
        
        let currentLanguage = Locale.preferredLanguages[0]
        if currentLanguage == "ar" || currentLanguage == "he" {
            btnBack.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //set email to nil in userdefaults
        UserDefaults.standard.set(nil, forKey: kUserEmail)
        UserDefaults.standard.set(true, forKey: UserDefaultsConstants.DISMISS_TRIAL_SCREEN)
        UserDefaults.standard.set(true, forKey: UserDefaultsConstants.GENERATE_QR_CODE)
        UserDefaults.standard.synchronize()
        removeObserver = true
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        showAuthenticationOptions()
        if !animationDone {
            setupAppearance()
            hidesAllControls()
        }
        
//        ZendeskChatManager.trackEvent("Login Screen")
        txtFldEmail.placeholder = "login_email_input_email".localized
        txtFldPassword.placeholder = "login_email_input_password".localized
        btnBack.isHidden = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logoAnimation()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    //MARK: - IBActions
    @IBAction func showPasswordBtn(_ sender: UIButton) {
           paswrdBtnState.toggle()
           if paswrdBtnState{
               if #available(iOS 13.0, *) {
                   showPasswordBtn.setImage(UIImage(systemName: "eye"), for: .normal)
                   txtFldPassword.isSecureTextEntry = false
               } else {
                   // Fallback on earlier versions
               }
           }else{
               if #available(iOS 13.0, *) {
                   showPasswordBtn.setImage(UIImage(systemName: "eye.slash"), for: .normal)
                   txtFldPassword.isSecureTextEntry = true
               } else {
                   // Fallback on earlier versions
               }
           }
       }
    
    @IBAction func withEmailTbnTpd() {
        UserDefaults.standard.set(true, forKey: "ZendeskChatScreen")
        UserDefaults.standard.synchronize()
        //Firebase Log Event
        CommonUtility.shared.setFirebaseEvents(eventName: "Login", screenTitle: "Login Screen", itemName: "Login with Email")
        UIView.animate(withDuration: 0.35, animations: {
            self.vAuthenticationMethods.superview!.alpha = 0
        }, completion: { (completed) in
            self.vInputFields.alpha = 1
            self.btnBack.isHidden = false
            self.lblHeading.text = StringConstants.Translation.LOGIN_TO_YOUR_EXISTING_ACCOUNT
        })
    }
    
    @IBAction func backBtnTpd(_ sender: UIButton) {
        self.view.endEditing(true)
        self.showAuthenticationOptions()
    }
    
    @IBAction func loginBtnTpd(_ sender: UIButton) {
        self.view.endEditing(true)
        signInWithNewAPI()
    }
    
    @IBAction func tapLabel(gesture: UITapGestureRecognizer) {
        let text = StringConstants.Translation.BY_CONTINUING_YOU_ARE_AGREE +  " " + StringConstants.Translation.TERMS_AND_CONDITIONS + " " +  StringConstants.Translation.AND + " " + StringConstants.Translation.PRIVACY_POLICY
        let termsRange = (text as NSString).range(of: StringConstants.Translation.TERMS_AND_CONDITIONS)
        let privacyRange = (text as NSString).range(of: StringConstants.Translation.PRIVACY_POLICY)
        
        if gesture.didTapAttributedTextInLabel(label: self.privacyAndPolicyLabel, inRange: termsRange) {
            print("Tapped Terms")
            self.open(scheme: "https://familytime.io/legal/terms-conditions.html")
        } else if gesture.didTapAttributedTextInLabel(label: self.privacyAndPolicyLabel, inRange: privacyRange) {
            print("Tapped privacy")
            self.open(scheme: "https://familytime.io/legal/app-privacy-policy.html")
        } else {
            print("Tapped none")
            self.open(scheme: "https://familytime.io/legal/app-privacy-policy.html")
        }
    }
    
    //MARK: - Objective Functions
    @objc func receiveToggleAuthUINotification(_ notification: NSNotification){
        if notification.name.rawValue == "ToggleAuthUINotification" {
            if notification.userInfo != nil {
                guard let userInfo = notification.userInfo as? [String:String] else { return }
                print(userInfo)
                guard let id_token = userInfo["id_token"] else {
                    print("Token is not available!!")
                    return
                }
                self.loginWithNewApiCore2(email: "", password: "", signInType: "google", accessToken: id_token, providerName: "google")
            }
        }
    }
    
    //MARK: - Helper Functions
    func showAuthenticationOptions() {
        UIView.animate(withDuration: 0.35, animations: {
            self.vInputFields.alpha = 0
        }, completion: { (completed) in
            self.vAuthenticationMethods.superview!.alpha = 1
            self.btnBack.isHidden = true
            if #available(iOS 13.0, *) {
                self.lblHeading.text = StringConstants.Translation.LOGIN_TO_YOUR_EXISTING_ACCOUNT
            }
            else {
                self.lblHeading.text = StringConstants.Translation.LOGIN_TO_YOUR_EXISTING_ACCOUNT
            }
        })
    }
    
    func setupAppearance() {
        txtFldEmail.text = ""
        self.logoImageView = UIImageView(image: UIImage(named: "logo"))
        self.view.addSubview(self.logoImageView)
        self.logoImageView.alpha = 1.0
        if SwiftFTUtils.isDeviceiPhoneFamily() {
            let width = convertPercentToValueWidth(percent: 0.30)
            self.logoImageView.frame = CGRect(x: self.view.bounds.size.width/2.0 - width/2.0, y: self.view.bounds.size.height/2.0 - width/2.0, width: width, height: width)
        } else {
            let width = convertPercentToValueWidth(percent: 0.25)
            self.logoImageView.frame = CGRect(x: self.view.bounds.size.width/2.0 - width/2.0, y: self.view.bounds.size.height/2.0 - width/2.0, width: width, height: width)
        }
        
        txtFldEmail.placeholder = "login_email_input_email".localized
        self.registerOrLoginLabel.text = "welcome_label_title".localized
        self.btnWithGoogle.setTitle("login_google_button".localized, for: .normal)
        self.btnWithApple.setTitle("login_apple_button".localized, for: .normal)
        self.btnWithEmail.setTitle("login_email_button".localized, for: .normal)
        self.btnContinue.setTitle("continue_button".localized, for: .normal)
        self.disclaimerLabel.text = "DISCLAIMER_TEXT".localized
    }
    
    private func open(scheme: String) {
        if let url = URL(string: scheme) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:],
                                          completionHandler: {
                    (success) in
                    print("Open \(scheme): \(success)")
                })
            } else {
                let success = UIApplication.shared.openURL(url)
                print("Open \(scheme): \(success)")
            }
        }
    }
    
    func signInWithNewAPI() {
        // Username Validation
        guard let email = self.txtFldEmail.text, !email.isEmpty else {
            print("username is missing!")
            CommonModel.showAlert("alert_title".localized, msg: "login_email_validation_empty_email".localized)
            return
        }
        guard CommonModel.isValidEmail(email) else {
            CommonModel.showAlert("alert_title".localized, msg:"login_email_validation_email".localized)
            return print("in valid email address.")
        }
        // Password Check
        guard let password = self.txtFldPassword.text, !password.isEmpty else {
            CommonModel.showAlert("alert_title".localized, msg:"login_email_validation_empty_password".localized)
            return
        }
        guard self.txtFldPassword.text!.count >= 4 else {
            CommonModel.showAlert("alert_title".localized, msg:"login_email_validation_password".localized)
            return
        }
        // Show Loader
        SwiftFTUtils.showHUDAdded(to: view, withText: "Loading...", animated: true)
        self.loginWithNewApiCore2(email: email, password: password,signInType: "email",accessToken: "",providerName: "")
    }
    
    //MARK: Login API
    func loginWithNewApiCore2(email: String, password:String, signInType:String, accessToken:String,providerName:String) {
        SwiftFTUtils.showHUDAdded(to: self.view, withText: "Loading...", animated: true)
        HLApiManager.loginNetworkCallCore2(email: email, password: password,siginInType: signInType,accessToken: accessToken,providerName: providerName) { response,error  in
            if error != nil {
                SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
                CommonModel.showAlert("alert_title".localized, msg: error)
            }
            if let data = response {
                if let token = data[StringConstants.ResponseKeys.TOKEN] as? String {
                    UserDefaultsManager.bearerTokenCore2 = token
                    UserDefaultsManager.userEmail = email
                    UserDefaultsManager.emailVerified = true
                    AppDelegateShared().userDefault.setValue(token, forKey: "LoginAuthToken")
                    self.accountApiData(token: token)
                    // Hide loader
                    SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
                }
            } else {
                print("Login Api response is nil because of ",error ?? "nil")
            }
        }
    }
    
    func moveToTheDashboard(){
        AppDelegateShared().setupDrawer(0)
    }
    
    //MARK: ACOUNT API CALL
    func accountApiData(token: String){
        HLApiManager.accountApiFunc(token: token) { response, error in
            if response != nil{
                UserDefaults.standard.removeObject(forKey: UserDefaultsConstants.PRODUCT_ACCOUNT_ARRAY)
                UserDefaults.standard.synchronize()
                self.productArr.removeAll()
                self.profileObject = response?.profile
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
                
                self.userLanguage = response?.profile?.language
                if(self.userLanguage != nil){
                    UserDefaults.standard.set(self.userLanguage, forKey: UserDefaultsConstants.USER_LANGUAGE)
                } else {
                    UserDefaults.standard.set(NSLocale.current.languageCode, forKey: UserDefaultsConstants.USER_LANGUAGE)
                }
                if let id = response?.profile?.id {
                    self.userID = id
                    if (self.userID != nil){
                        AppDelegateShared().userDefault.set(self.userID, forKey: UserDefaultsConstants.USER_ID)
                        AppDelegateShared().userDefault.synchronize()
                    } else {
                        AppDelegateShared().userDefault.set(StringConstants.Constants.EMPTY_STRING, forKey: UserDefaultsConstants.USER_ID)
                        AppDelegateShared().userDefault.synchronize()
                    }
                }
                
                if let name = response?.profile?.name {
                    self.userName = name
                    if (self.userName != nil){
                        UserDefaults.standard.set(self.userName, forKey: UserDefaultsConstants.USER_NAME)
                    } else {
                        UserDefaults.standard.set(StringConstants.Constants.EMPTY_STRING, forKey: UserDefaultsConstants.USER_NAME)
                    }
                }
                
                if let email = response?.profile?.email {
                    self.userEmail = email
                    if (self.userEmail != nil){
                        UserDefaults.standard.set(self.userEmail, forKey: UserDefaultsConstants.USER_EMAIL)
                        AppDelegateShared().userDefault.set(self.userEmail, forKey: UserDefaultsConstants.USER_EMAIL)
                        AppDelegateShared().userDefault.synchronize()
                    } else {
                        UserDefaults.standard.set(StringConstants.Constants.EMPTY_STRING, forKey: UserDefaultsConstants.USER_EMAIL)
                        AppDelegateShared().userDefault.set(StringConstants.Constants.EMPTY_STRING, forKey: UserDefaultsConstants.USER_EMAIL)
                        AppDelegateShared().userDefault.synchronize()
                    }
                }
                
                if let phone = response?.profile?.phone {
                    self.userPhoneNumber = phone
                    
                    if (self.userPhoneNumber != nil){
                        UserDefaults.standard.set(self.userPhoneNumber, forKey: UserDefaultsConstants.USER_PHONE)
                    } else {
                        UserDefaults.standard.set(StringConstants.Constants.EMPTY_STRING, forKey: UserDefaultsConstants.USER_PHONE)
                    }
                }
                
                if let gender = response?.profile?.gender {
                    self.userGender = gender
                    if (self.userGender != nil) {
                        UserDefaults.standard.set(self.userGender, forKey: UserDefaultsConstants.USER_GENDER)
                        if self.userGender == StringConstants.Constants.MALE {
                            UserDefaults.standard.set(StringConstants.Constants.FATHER, forKey: UserDefaultsConstants.USER_RELATION)
                        } else {
                            UserDefaults.standard.set(StringConstants.Constants.MOTHER, forKey: UserDefaultsConstants.USER_RELATION)
                        }
                    } else {
                        UserDefaults.standard.set(StringConstants.Constants.FATHER, forKey: UserDefaultsConstants.USER_RELATION)
                        UserDefaults.standard.set(StringConstants.Constants.EMPTY_STRING, forKey: UserDefaultsConstants.USER_GENDER)
                    }
                }
                
                if let type = response?.profile?.type {
                    self.userType = type
                    if (self.userType != nil) {
                        UserDefaults.standard.set(self.userType, forKey: UserDefaultsConstants.USER_TYPE)
                    } else {
                        UserDefaults.standard.set(StringConstants.Constants.EMPTY_STRING, forKey: UserDefaultsConstants.USER_TYPE)
                    }
                }
                let package = response?.profile?.package
                if package != nil {
                    UserDefaults.standard.set(package, forKey: UserDefaultsConstants.BILLING_STATUS)
                    UserDefaults.standard.synchronize()
                } else {
                    UserDefaults.standard.set(nil, forKey: UserDefaultsConstants.BILLING_STATUS)
                    UserDefaults.standard.synchronize()
                }
                if let subs = response?.billing?.subscriptions {
                    for value in subs{
                        if let package = value.status {
                            self.package = "\(package)"
                            let product = value.psp ?? StringConstants.Constants.EMPTY_STRING
                            self.productArr.append(product)
                            UserDefaults.standard.set(self.productArr, forKey: UserDefaultsConstants.PRODUCT_ACCOUNT_ARRAY)
                            UserDefaults.standard.synchronize()
                        }
                    }
                }
                DispatchQueue.main.async {
                    if self.childArray.count > 0 {
                        UserDefaultsManager.ChildAdded = true
                        AppDelegateShared().setupDrawer(0)
                    }
                    else {
                        self.moveToTheDashboard()
                    }
                }
            } else {
                print(StringConstants.Errors.APP_CONFIG_NOT_FOUND,error ?? StringConstants.Constants.NIL_VALUE)
            }
        }
    }
    
    /*
     // MARK: - FB SIGNIN
     //---REMOVE FACEBOOK DUE TO MDM---//
     //    @IBAction func handleFBLogin(_ sender: Any) {
     //        AuthenticationService.shared().loginWithFB(with: self, success: { [weak self] (name, email, fbId, fbToken) in
     //            DispatchQueue.main.async { [weak self] in
     //                if(email=="")||(email==nil)
     //                {
     //                    let loginManager = FBSDKLoginManager()
     //                    loginManager.logOut()
     //                    FBSDKAccessToken.setCurrent(nil)
     //                    SwiftFTUtils.showFaceBookIssue(self)
     //                }
     //                else
     //                {
     //                    SwiftFTUtils.showHUDAdded(to: self?.view, withText: "Authenticating...".localized, animated: true)
     //                    self?.doFBLogin(name: name!, email: email!, fbId: fbId!, fbToken: fbToken!)
     //                }
     //            }
     //        }, failure: { [weak self] (error) in
     //            DispatchQueue.main.async
     //            {
     //                let alert = UIAlertController(title: "FamilyTime Dashboard".localized, message: error, preferredStyle: UIAlertController.Style.alert)
     //                alert.addAction(UIAlertAction(title: "TRY AGAIN".localized, style: UIAlertAction.Style.cancel, handler: nil))
     //                self?.present(alert, animated: true, completion: nil)
     //            }
     //        })
     //    }
     
     //---REMOVE FACEBOOK DUE TO MDM---//
     //    func doFBLogin(name: String, email: String, fbId: String, fbToken: String)
     //    {
     //        //---NATIVE API CALLING---//---RESPONSE IS SAME AND PARSING IS SAME SO FOR BOTH FB AND GOOGLE ONE METHOD IS BEING USED---//
     //
     //        AuthenticationService.shared()?.nativePost_fBlogin(withUserName: name, email: email, fbId: fbId, fbToken: fbToken, isFbLogin: false, success: { (userModel) in
     //
     //            DispatchQueue.main.async {
     //                MBProgressHUD.hideAllHUDs(for: (self.view)!, animated: true)
     //
     //                let user = userModel! as UserModel
     //                AppDelegateShared().parent = user
     //                AppDelegateShared().userDefault.set(user.toDictionary(), forKey: "user")
     //                AppDelegateShared().userDefault.set(user.email, forKey: "userEmail")
     //                AppDelegateShared().setNavigationbarAppearence(false, cont: self)
     //                AppDelegateShared().userDefault.synchronize()
     //                AppDelegateShared().setupDrawer(0)
     //            }
     //
     //        }, failure: { (error,responseCode) in
     //            DispatchQueue.main.async {
     //                if responseCode != 200 || responseCode == 100 || responseCode == 300
     //                {
     //                    MBProgressHUD.hideAllHUDs(for: (self.view)!, animated: true)
     //                    let alert = UIAlertController(title: "FamilyTime Dashboard".localized, message: error, preferredStyle: UIAlertController.Style.alert)
     //                    alert.addAction(UIAlertAction(title: "TRY AGAIN".localized, style: UIAlertAction.Style.cancel, handler: nil))
     //                    self.present(alert, animated: true, completion: nil)
     //                }
     //            }
     //        })
     //    }
     */
    // MARK: - Google Signin
    @IBAction func withgoogleBtnTpd(_ sender: UIButton){
        //Firebase Log Event
        CommonUtility.shared.setFirebaseEvents(eventName: "Login", screenTitle: "Login Screen", itemName: "Login with Google")
        removeObserver = false
        // TODO: GoogleSignIn disabled temporarily — replace with GoogleSignIn 7.x via SPM when legacy Auth VCs are removed
        //GIDSignIn.sharedInstance().signIn()
    }

    // TODO: GoogleSignIn disabled temporarily — replace with GoogleSignIn 7.x via SPM when legacy Auth VCs are removed
    //func signIn(signIn: GIDSignIn!, dismissViewController viewController: UIViewController!){
    //    print("GoogleSignInDismiss")
    //}
}


//  MARK: - Animation Methods
extension LoginViewController {
    func hidesAllControls() {
        //self.vAuthenticationMethods.superview!.alpha    = 0
        //        self.vHeadings.alpha                    = 0
        //        self.vInputFields.alpha                 = 0
        //        self.btnForgotPassword.alpha            = 0
    }
    
    func showAllControls(){
        UIView.animate(withDuration: 0.35, animations: {
            let forgetPasswordText = StringConstants.Translation.HAVING_TROUBLE_IN_SIGN_IN + " " + StringConstants.Translation.RESET_PASSWORD
            let changedAttributedText = forgetPasswordText.attributedString([StringConstants.Translation.RESET_PASSWORD], color: ColorConstants.RESET_PASSWORD_TEXT_COLOR_HIGHLIGHT, font: UIFont.init(name: FontConstants.ARIAL, size: 15.0)!)
            self.vAuthenticationMethods.superview!.superview!.alpha = 1.0
            self.vAuthenticationMethods.superview!.alpha = 1.0
            self.vHeadings.alpha = 1.0
            self.vInputFields.alpha = 0.0
            self.btnForgotPassword.alpha = 1.0
            self.btnForgotPassword.setAttributedTitle(changedAttributedText, for: .normal)
        }, completion: { (completed) in
            self.animationDone = true
        })
    }
    
    func startAnimation(){
        UIView.animate(withDuration: 0.35, animations: {
            self.logoImageView.alpha = 1.0
        }, completion: { (completed) in
            self.moveLogoWithAnimation()
        })
    }
    
    func moveLogoWithAnimation(){
        UIView.animate(withDuration: 1.0, animations: {
            self.changeLogoFrameForAnimation()
        }, completion: { (completed) in
            self.showAllControls()
        })
    }
    
    func changeLogoFrameForAnimation(){
        if SwiftFTUtils.isDeviceiPhoneFamily(){
            let width = self.convertPercentToValueWidth(percent: 0.23)
            let topMargin = self.convertPercentToValueHeight(percent: 0.12)
            self.logoImageView.frame = CGRect(x: self.view.bounds.size.width/2.0 - width/2.0, y: topMargin, width: width, height: width)
        }
        else {
            let width = self.convertPercentToValueWidth(percent: 0.17)
            let topMargin = self.convertPercentToValueHeight(percent: 0.15)
            self.logoImageView.frame = CGRect(x: self.view.bounds.size.width/2.0 - width/2.0, y: topMargin, width: width, height: width)
        }
    }
    
    func logoAnimation(){
        if !animationDone {
            if SwiftFTUtils.isDeviceiPhoneFamily(){
                let width = convertPercentToValueWidth(percent: 0.30)
                self.logoImageView.frame = CGRect(x: self.view.bounds.size.width/2.0 - width/2.0, y: self.view.bounds.size.height/2.0 - width/2.0, width: width, height: width)
            } else {
                let width = convertPercentToValueWidth(percent: 0.25)
                self.logoImageView.frame = CGRect(x: self.view.bounds.size.width/2.0 - width/2.0, y: self.view.bounds.size.height/2.0 - width/2.0, width: width, height: width)
            }
            startAnimation()
        }
    }
    
    func convertPercentToValueWidth(percent: Double) -> CGFloat {
        return CGFloat(UIScreen.main.bounds.size.width * CGFloat(percent))
    }
    
    func convertPercentToValueHeight(percent: Double) -> CGFloat {
        return CGFloat(UIScreen.main.bounds.size.height * CGFloat(percent))
    }
}

//MARK: - Google SignIn Delegates
// TODO: GoogleSignIn disabled temporarily — replace with GoogleSignIn 7.x via SPM when legacy Auth VCs are removed
//extension LoginViewController: GIDSignInUIDelegate {
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?){
//
//    }
//
//    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!){
//
//    }
//}
