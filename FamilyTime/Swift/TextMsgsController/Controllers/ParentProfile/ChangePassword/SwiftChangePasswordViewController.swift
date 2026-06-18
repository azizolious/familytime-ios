//
//  SwiftChangePasswordViewController.swift
//  FamilyTime
//
//  Created by YumyApps on 22/10/2021.
//  Copyright © 2021 YumyApps. All rights reserved.
//

import UIKit
import MBProgressHUD

class SwiftChangePasswordViewController: UIViewController, UITextFieldDelegate, UIAlertViewDelegate {
    
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var confirmPasswordTextField: SkyFloatingLabelTextField?
    @IBOutlet weak var currentPasswordTextField: SkyFloatingLabelTextField?
    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var newPasswordTextField: SkyFloatingLabelTextField?
    
    let delegate = UIApplication.shared.delegate as? AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentPasswordTextField?.placeholder = "change_password_input_1".localized
        newPasswordTextField?.placeholder = "change_password_input_2".localized
        confirmPasswordTextField?.placeholder = "change_password_input_3".localized
        
        if (UI_USER_INTERFACE_IDIOM() == .pad){
            
            self.changePasswordButton.layer.cornerRadius = 30
        }
        else{
            
            self.changePasswordButton.layer.cornerRadius = 25
            
        }
        
        changePasswordButton.titleLabel?.text = changePasswordButton.titleLabel?.text?.myModification()
        
        self.navigationController?.navigationBar.topItem?.title = ""
        
        title = "change_password_title".localized
        
        currentPasswordTextField?.delegate = self
        newPasswordTextField?.delegate = self
        confirmPasswordTextField?.delegate = self
        
        let currentPasswordPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        currentPasswordTextField?.leftView = currentPasswordPaddingView
        currentPasswordTextField?.leftViewMode = .always
        
        let newPasswordPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        newPasswordTextField?.leftView = newPasswordPaddingView
        newPasswordTextField?.leftViewMode = .always
        
        let confirmPasswordPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        confirmPasswordTextField?.leftView = confirmPasswordPaddingView
        confirmPasswordTextField?.leftViewMode = .always
        
        if UIScreen.isIphone4() {
            
            nameLabel?.font = UIFont(name: "OpenSans", size: 20)
            currentPasswordTextField?.font = UIFont(name: "OpenSans-Light", size: 10)
            newPasswordTextField?.font = UIFont(name: "OpenSans-Light", size: 10)
            confirmPasswordTextField?.font = UIFont(name: "OpenSans-Light", size: 10)
            changePasswordButton.titleLabel?.font = UIFont(name: "OpenSans", size: 12)
            
        } else if UIScreen.isIphone5() {
            
            nameLabel?.font = UIFont(name: "OpenSans", size: 21)
            currentPasswordTextField?.font = UIFont(name: "OpenSans-Light", size: 11)
            newPasswordTextField?.font = UIFont(name: "OpenSans-Light", size: 11)
            confirmPasswordTextField?.font = UIFont(name: "OpenSans-Light", size: 11)
            changePasswordButton.titleLabel?.font = UIFont(name: "OpenSans", size: 13)
            
        } else if UIScreen.isIphone6() {
            
            nameLabel?.font = UIFont(name: "OpenSans", size: 25)
            currentPasswordTextField?.font = UIFont(name: "OpenSans-Light", size: 13)
            newPasswordTextField?.font = UIFont(name: "OpenSans-Light", size: 13)
            confirmPasswordTextField?.font = UIFont(name: "OpenSans-Light", size: 13)
            changePasswordButton.titleLabel?.font = UIFont(name: "OpenSans", size: 16)
            
        } else if UIScreen.isIphone6Plus() {
            
            nameLabel?.font = UIFont(name: "OpenSans", size: 28)
            currentPasswordTextField?.font = UIFont(name: "OpenSans-Light", size: 14)
            newPasswordTextField?.font = UIFont(name: "OpenSans-Light", size: 14)
            confirmPasswordTextField?.font = UIFont(name: "OpenSans-Light", size: 14)
            changePasswordButton.titleLabel?.font = UIFont(name: "OpenSans", size: 17)
            
        } else if UIScreen.isIphoneX() {
            
            nameLabel?.font = UIFont(name: "OpenSans", size: 28)
            currentPasswordTextField?.font = UIFont(name: "OpenSans-Light", size: 14)
            newPasswordTextField?.font = UIFont(name: "OpenSans-Light", size: 14)
            confirmPasswordTextField?.font = UIFont(name: "OpenSans-Light", size: 14)
            changePasswordButton.titleLabel?.font = UIFont(name: "OpenSans", size: 17)
            
        } else {
            
            nameLabel?.font = UIFont(name: "OpenSans", size: 30)
            currentPasswordTextField?.font = UIFont(name: "OpenSans-Light", size: 25)
            newPasswordTextField?.font = UIFont(name: "OpenSans-Light", size: 25)
            confirmPasswordTextField?.font = UIFont(name: "OpenSans-Light", size: 25)
            changePasswordButton.titleLabel?.font = UIFont(name: "OpenSans", size: 25)
            
        }
        
        changePasswordButton.setTitle("change_password_button_content".localized, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let name = UserDefaults.standard.string(forKey: "userName")
        nameLabel?.text = name
        
        var strRelationShip = UserDefaults.standard.string(forKey: "userRelation") ?? "Father"
        //        strRelationShip = "\(strRelationShip.substring(to: 1).uppercased())\(strRelationShip.substring(from: 1))"
        strRelationShip = strRelationShip.capitalized
        if strRelationShip == NSLocalizedString("Mother", comment: "") {
            logoView.image = UIImage(named: "in_parent_f")
        } else {
            logoView.image = UIImage(named: "in_parent_m")
        }
    }
    
    @IBAction func handleChangePassword(_ sender: Any) {
        
        if !validate() {
            return
        }
        
        // Show loading indicator
        SwiftFTUtils.showHUDAdded(to: self.view, withText: "Changing Password...", animated: true)
        
        // New API payload
        let params: [String: Any] = [
            "current_password": currentPasswordTextField?.text ?? "",
            "password": newPasswordTextField?.text ?? "",
            "password_confirmation": newPasswordTextField?.text ?? ""  // Assuming confirmation is the same as the new password
        ]
        
        let url = HLConstants.BASE_URL_CORE_2 + "change-password"
        
        CoreManager.networkRequest(url: url, method: .put, params: params) { (response: EmptyResponseModel?, statusCode, errorMessage) in
            SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
            
            if statusCode == 204 {
                UIAlertView(title: "logout_alert_content_1".localized, message: "change_password_alert_validation_3".localized, delegate: self, cancelButtonTitle: "ok_button".localized).show()
                
            }else if statusCode == 100 {
                CommonModel.showAlert("alert_error".localized, msg: "change_password_alert_validation_2".localized)
            } else {
                CommonModel.showAlert("alert_error".localized, msg: "alert_something_wrong".localized)
            }
        }
        
        
        //        if !validate() {
        //            return
        //        }
        //
        //        //---MESH2 API IMPLEMENTATION---//
        //        SwiftFTUtils.showHUDAdded(to: view, withText: "Changing Password...", animated: true)
        //        let params: [AnyHashable: Any] = [
        //            "current_password": currentPasswordTextField?.text ?? "",
        //            "new_password": newPasswordTextField?.text ?? ""
        //        ]
        //
        //        print("url for change password = \(kChangePassword_mesh2) and params = \(params))")
        //
        //        ApiManager.shared().postApi(withPwdVC: self, isPresentedCont: false, andParams: params, withApi: kChangePassword_mesh2) { message, statusCode in
        //
        //            DispatchQueue.main.async {
        //
        //                print(String(format: "change password code = %ld", Int(statusCode)))
        //                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
        //
        //                if statusCode == 200 {
        //                    UIAlertView(title: "logout_alert_content_1".localized, message: "change_password_alert_validation_3".localized, delegate: self, cancelButtonTitle: "ok_button".localized).show()
        //
        //                }else if statusCode == 100 {
        //                    CommonModel.showAlert("alert_error".localized, msg: "change_password_alert_validation_2".localized)
        //                  } else {
        //                    CommonModel.showAlert("alert_error".localized, msg: "alert_something_wrong".localized)
        //                }
        //
        //            }
        //
        //        }
        
    }
    
    func validate() -> Bool {
        
        if currentPasswordTextField?.text == nil || currentPasswordTextField?.text?.count == 0 {
            CommonModel.showAlert("change_password_title".localized, msg: "change_password_alert_validation_4".localized)
            return false
        }
        if newPasswordTextField?.text == nil || newPasswordTextField?.text?.count == 0 {
            CommonModel.showAlert("change_password_title".localized, msg: "change_password_input_validation_1".localized)
            return false
        }
        if confirmPasswordTextField?.text == nil || confirmPasswordTextField?.text?.count == 0 {
            CommonModel.showAlert("change_password_title".localized, msg: "change_password_input_validation_1".localized)
            return false
        }
        if confirmPasswordTextField?.text != newPasswordTextField?.text {
            CommonModel.showAlert("change_password_title".localized, msg: "change_password_alert_validation_5".localized)
            return false
        }
        if newPasswordTextField!.text!.count < 4 {
            let changeString = "change_password_input_validation_2".localized
            let replaced = changeString.replacingOccurrences(of: "6", with: "4")
            CommonModel.showAlert("change_password_title".localized, msg: replaced)
            return false
        }
        return true
    }
    
    func alertView(_ alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        
        delegate?.userDefault.set(nil, forKey: "user")
        delegate?.setNavigationbarAppearence(true, cont: self)
        delegate?.setupDrawer(2)
        
    }
    
}

//MARK: - UITEXTFIELD Delegate

extension SwiftChangePasswordViewController {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        view.endEditing(true)
        return true
    }
    
    @objc func keyboardDidShow(_ notification: Notification?) {
        
    }
    
    @objc func keyboardDidHide(_ notification: Notification?) {
        
    }
    
}
