//
//  EmailConfirmationVC.swift
//  FamilyTime
//
//  Created by Sana-Ullah-IOS on 12/03/2020.
//  Copyright © 2020 YumyApps. All rights reserved.
//

import UIKit

class EmailConfirmationVC: UIViewController {
        
    //MARK: - OUTLETS
    @IBOutlet var btnEditEmail: UIButton!
    @IBOutlet var txtFldEmail: UITextField!
    @IBOutlet var btnBack: UIButton!
    @IBOutlet weak var lblConfirmEmail: UILabel!
    @IBOutlet weak var lblEmailSent: UILabel!
    @IBOutlet weak var lblEmailNotReceive: UILabel!
    @IBOutlet weak var btnResendEmail: UIButton!
    @IBOutlet weak var btnContinue: UIButton!
    
    //MARK: - VARIABLEs
    var email = ""
    var password = ""
    public var showBackBtn = false
    
    //MARK: - VIEW LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        email = UserDefaultsManager.userEmail ?? ""
        password = UserDefaultsManager.userPassword ?? ""
        self.setappearance()
    }
    
    func setappearance() {
        self.lblConfirmEmail.text = "verify_account_title".localized
        self.lblEmailSent.text = "verify_account_content_1".localized
        self.lblEmailNotReceive.text = "verify_account_content_2".localized
        self.btnResendEmail.setTitle("verify_account_content_3".localized, for: .normal)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        txtFldEmail.placeholder = "login_email_input_email".localized
        txtFldEmail.text = email
        txtFldEmail.delegate = self
        txtFldEmail.keyboardType = .emailAddress
        btnBack.isHidden = false
        btnContinue.layer.cornerRadius = 6
        btnContinue.setTitle("continue_button".localized, for: .normal)
        
    }
    
    //MARK: - BUTTON ACTIONS
    @IBAction func backBtnTpd() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editBtnTpd(_ sender: UIButton) {
        if sender.tag == 0 {
            sender.tag = 1
            txtFldEmail.isUserInteractionEnabled = true
            sender.setImage(UIImage(named: "ic_check_green"), for: .normal)
            sender.borderColor = UIColor.clear
            sender.tintColor = UIColor.systemBlue
            txtFldEmail.becomeFirstResponder()
        }
        else {
            sender.tag = 0
            view.endEditing(true)
            txtFldEmail.isUserInteractionEnabled = false
            sender.setImage(UIImage(named: "edit_1"), for: .normal)
            sender.tintColor = Theme.PrimaryBlueColor
            sender.borderColor = .clear
            resendVerificationEmail(tag: sender.tag)
        }
    }
    @IBAction func resendEmailBtnTpd(_ sender: UIButton) {
        resendVerificationEmail(tag: sender.tag)
    }
    @IBAction func continueBtnTpd(_ sender: UIButton) {
        verifyUserEmail(tag: sender.tag)
    }
    //MARK: - OBJECRIE FUNCTIONS
    @objc func verifyUserEmail(tag:Int) {
        //  Email Validation
        guard CommonModel.isValidEmail(self.email) else {
            CommonModel.showAlert("alert_error".localized, msg:"login_email_validation_email".localized)
            return
        }
        HLApiManager.verifyUser(email: self.email, view: self.view) { (response, childCount, status, message) in
            print(status)
            if  status == 200 {
                print(message)
                //TODO: Auth API Call
                self.callSignupAuthAPI()
            } else {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "alert_title".localized, message: "verify_account_alert_1".localized, preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title: "ok_button".localized, style: .default, handler: { (action: UIAlertAction!) in
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    @objc func resendVerificationEmail(tag:Int) {
        //  Email Validation
        guard CommonModel.isValidEmail(self.email) else {
            CommonModel.showAlert("alert_error".localized, msg:"login_email_validation_email".localized)
            return
        }
        //  Password Check
        guard !self.password.isEmpty else {
            print("password is empty!")
            return
        }
        
         HLApiManager.loginUser(email: email, password: password, view: self.view) { (response, childCount, status, message) in
                   
            guard status == 200 else {
               print(message)
               return
            }
            
            UserDefaultsManager.userEmail = self.email
            
            guard let userProfile = response?.myJSON.dictionaryObject else {
                UserDefaultsManager.userPassword = self.password
                
                var message = ""
                
                if tag == 0 {
                    message = "verify_account_alert_2".localized
                } else {
                    message = "verify_account_alert_1".localized
                }
                
                DispatchQueue.main.async {
                    
                    let alert = UIAlertController(title: "alert_title".localized, message: message, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "ok_button".localized, style: .default, handler: { (action: UIAlertAction!) in
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                }
                return
            }
               
            UserDefaultsManager.emailVerified = true

            do {
               let user = try UserModel(dictionary: userProfile)
               AppDelegateShared().parent = user
               AppDelegateShared().userDefault.set(user.toDictionary(), forKey: "user")
               AppDelegateShared().userDefault.synchronize()
            }
            catch(let error) {
               print(error.localizedDescription)
            }

            DispatchQueue.main.async {
               if childCount > 0 {
                   UserDefaultsManager.ChildAdded = true
                   AppDelegateShared().setupDrawer(0)
               } else {
                self.movetoSecondScreen()
               }
            }
        }
    }
    
    @objc func callSignupAuthAPI() {
        guard let userEmail = UserDefaultsManager.userEmail else {
            CommonModel.showAlert("Email required!".localized, msg: "")
            return
        }
        //  Email Validation
        guard CommonModel.isValidEmail(userEmail) else {
            CommonModel.showAlert("Email ID invalid!".localized, msg:"Please enter a valid email ID and try again.".localized)
            return
        }
        //  Password Check
        let userPassword = UserDefaultsManager.userPassword ?? ""
        
        HLApiManager.loginWithVerifiedEmail(name: "", email: userEmail, password: userPassword, signInType: "email", view: self.view) { (profile, childCount, status, message) in
            
            guard let userProfile = profile?.myJSON.dictionaryObject else {
                DispatchQueue.main.async {
                    CommonModel.showAlert(message, msg: "")
                }
                return
            }
            
            UserDefaultsManager.emailVerified = true
            do {
                let user = try UserModel(dictionary: userProfile)
                AppDelegateShared().parent = user
                AppDelegateShared().userDefault.set(user.toDictionary(), forKey: "user")
                AppDelegateShared().userDefault.synchronize()
            }
            catch(let error) {
                print(error.localizedDescription)
            }
            
            DispatchQueue.main.async {
                if childCount > 0 {
                    UserDefaultsManager.ChildAdded = true
                    AppDelegateShared().setupDrawer(0)
                }
                else {
                    self.movetoSecondScreen()
                    AppDelegateShared().setupDrawer(0)
                }
            }
        }
    }
    
    func movetoSecondScreen() {
        //MARK: Rizwan
        if UserDefaultsManager.AddChildWithQRScan == true{
           let storyboard = UIStoryboard(name: "Steps", bundle: Bundle.main)
           let controller = storyboard.instantiateViewController(withIdentifier: "QRScanViewController") as? QRScanViewController
            navigationController?.pushViewController(controller ?? UIViewController(), animated: true)
        } else {
            let storyboard = UIStoryboard(name: "KidDevice", bundle: Bundle.main)
            let controller = storyboard.instantiateViewController(withIdentifier: "SelectDeviceViewController") as? SelectDeviceViewController
            navigationController?.pushViewController(controller ?? UIViewController(), animated: true)
            UserDefaultsManager.ChildAdded = false
        }
    }
}
//MARK: - DELEGATEs
extension EmailConfirmationVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let txt = textField.text, !txt.isEmpty {
            self.email = txt
        }
    }
}
