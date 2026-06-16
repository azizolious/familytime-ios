//
//  ForgetPasswordVC.swift
//  FamilyTime - Dashboard
//
//  Created by Muhammad Ajmal on 08/05/2017.
//  Copyright © 2017 SoraCode. All rights reserved.
//

import UIKit
import MBProgressHUD

class ForgetPasswordVC: UIViewController {

    //MARK: - OUTLETS
    @IBOutlet weak var emailField: SkyFloatingLabelTextField!
    @IBOutlet weak var sendEmailButton: UIButton!
    @IBOutlet weak var lblForgotPassword: UILabel!
    @IBOutlet weak var descForgotPassword: UILabel!
    @IBOutlet weak var forgetPasswordButtonOutlet: UIButton!
    
    var logoImageView: UIImageView!
    
    //MARK: VIEW CONTROLLER LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lblForgotPassword.font = UIFont.BoldFont()
        self.title = "forgot_password_title".localized
        self.sendEmailButton.setTitle("forgot_password_button".localized, for: .normal)
        self.lblForgotPassword.text = "forgot_password_title".localized
        self.descForgotPassword.text = "forgot_pasword_content".localized
        self.emailField.placeholder = "login_email_input_email".localized
//        ZendeskChatManager.trackEvent("Forget Passward")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if SwiftFTUtils.isDeviceiPhoneFamily()
        {
            let width = self.convertPercentToValueWidth(percent: 0.25)
            let topMargin = self.convertPercentToValueHeight(percent: 0.112)
            self.logoImageView.frame = CGRect(x: self.view.bounds.size.width/2.0 - width/2.0, y: topMargin, width: width, height: width)
        }
        else
        {
            let width = self.convertPercentToValueWidth(percent: 0.18)
            let topMargin = self.convertPercentToValueHeight(percent: 0.112)
            self.logoImageView.frame = CGRect(x: self.view.bounds.size.width/2.0 - width/2.0, y: topMargin, width: width, height: width)
        }
    }
    
    func setupAppearance() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.logoImageView = UIImageView(image: UIImage(named: "logo_auth"))
        self.view.addSubview(self.logoImageView)
        
        emailField.placeholder = "forgot_password_input_email".localized
        sendEmailButton.setTitle("forgot_password_send_email_button".localized, for: UIControl.State.normal)
        
        let currentLanguage = Locale.preferredLanguages[0]
        if currentLanguage == "ar" || currentLanguage == "he" {
            forgetPasswordButtonOutlet.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        }
    }
    
    func convertPercentToValueWidth(percent: Double) -> CGFloat {
        return UIScreen.main.bounds.size.width * CGFloat(percent)
    }
    
    func convertPercentToValueHeight(percent: Double) -> CGFloat {
        return UIScreen.main.bounds.size.height * CGFloat(percent)
    }
    
    
    //MARK: - BUTTON ACTIONS
    @IBAction func backBtnTpd() {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func handleSendEmail(_ sender: Any) {
        self.view.endEditing(true)
        guard let email = self.emailField.text, !email.isEmpty else {
            CommonModel.showAlert("alert_title".localized, msg:"forgot_password_validation_empty_email".localized)
            return
        }
        guard CommonModel.isValidEmail(email) else {
            CommonModel.showAlert("alert_title".localized, msg:"forgot_password_validation_email".localized)
            return
        }
        
        //---NATIVE API CALLING---//
        HLApiManager.forgetPasswordNetworkCallCore2(email: email.trimmingCharacters(in: .whitespaces)) { isEmailSent, error in
            if let isEmailSent = isEmailSent {
                if isEmailSent {
                    DispatchQueue.main.async {
                        loaderVisibility(view: self.view, show: false)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                        CommonModel.showAlert("alert_title".localized, msg:"forgot_password_success_response".localized)
                    }
                    AppDelegateShared().userDefault.set(email, forKey: kForgotUserEmail)
                    AppDelegateShared().userDefault.synchronize()
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            } else {
                CommonModel.showAlert("alert_title".localized, msg: error ?? "Nil")
            }
        }
    }
}



