//
//  PasscodePopUpViewController.swift
//  FamilyTime
//
//  Created by YumyApps on 02/12/2021.
//  Copyright © 2021 YumyApps. All rights reserved.
//

import UIKit

class PasscodePopUpViewController: UIViewController, UITextFieldDelegate {
    
    
    //MARK: - IBOUTLETS
    @IBOutlet weak var passcodeOuterView: UIView!
    @IBOutlet weak var passcodeImage: UIImageView!
    @IBOutlet weak var passcodeTitle: UILabel!
    @IBOutlet weak var passcodeTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var setButton: UIButton!
    @IBOutlet weak var tipLabel: UILabel!
    
    let delegate = UIApplication.shared.delegate as? AppDelegate
    var color = ""
    var control = Control()
    var callback: ()->() = {}
    //MARK: - VIEWs LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        control = DBManager.shared.fetchAppBlockControl(identifier: "family_pause")
        passcodeOuterView.backgroundColor = UIColor.white
        passcodeOuterView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
        NotificationCenter.default.addObserver(self, selector: #selector(passcodeSetAlert), name: NSNotification.Name("PasscodeUpdateForChildAlert"), object: nil)
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func passcodeSetAlert(){
        
        DispatchQueue.main.async {
            let refreshAlert = UIAlertController(title: "", message: "child_profile_alert_content".localized, preferredStyle: UIAlertController.Style.alert)
            refreshAlert.addAction(UIAlertAction(title: "ok_button".localized, style: .default, handler: { (action: UIAlertAction!) in
                self.callback()
                self.dismiss(animated: true, completion: nil)
              }))
            self.present(refreshAlert, animated: true, completion: nil)
        }
    }
    
    @objc func handleTap(_ gesture: UIGestureRecognizer?) {
        
        if gesture?.state == .ended {
            passcodeTextField.resignFirstResponder()
        }
    }
    
    //MARK: - CUSTOM FUNCTION
    func setupUI() {
        passcodeImage?.image = SwiftFTUtils.isDeviceiPhoneFamily() ? UIImage(named: "popup_passcode") : UIImage(named: "popup_ipad_passcode")
        self.setupCancelButton()
        self.setupSetButton()
        self.setupPasscodeField()
        self.setupTitleLabel()
    }
    
    func setupCancelButton() {
        if IS_IPHONE_4() {
            cancelButton.titleLabel?.font = UIFont(name: "OpenSans", size: 13)
        } else if IS_IPHONE_5() {
            cancelButton.titleLabel?.font = UIFont(name: "OpenSans", size: 13)
        } else if IS_IPHONE_6() {
            cancelButton.titleLabel?.font = UIFont(name: "OpenSans", size: 14)
        } else if IS_IPHONE_6_PLUS() {
            cancelButton.titleLabel?.font = UIFont(name: "OpenSans", size: 15)
        } else if IS_IPHONE_X() {
            cancelButton.titleLabel?.font = UIFont(name: "OpenSans", size: 15)
        } else {
            cancelButton.titleLabel?.font = UIFont(name: "OpenSans", size: 20)
        }
        
        cancelButton.setTitle("cancel_button".localized, for: .normal)
        cancelButton.selectiveBorderFlag = UInt(AUISelectiveBordersFlagRight)
        cancelButton.selectiveBordersColor = UIColor.white
        cancelButton.selectiveBordersWidth = 0.5
    }
    
    func setupTitleLabel() {
                
        if IS_IPHONE_4() {
            passcodeTitle?.font = UIFont(name: "OpenSans", size: 15)
        } else if IS_IPHONE_5() {
            passcodeTitle?.font = UIFont(name: "OpenSans", size: 15)
        } else if IS_IPHONE_6() {
            passcodeTitle?.font = UIFont(name: "OpenSans", size: 17)
        } else if IS_IPHONE_6_PLUS() {
            passcodeTitle?.font = UIFont(name: "OpenSans", size: 18)
        } else if IS_IPHONE_X() {
            passcodeTitle?.font = UIFont(name: "OpenSans", size: 18)
        } else {
            passcodeTitle?.font = UIFont(name: "OpenSans", size: 25)
        }
//        passcodeTitle?.textAlignment = .center
//        passcodeTitle?.textColor = UIColor.lightGray
        //passcodeTitle?.text = "device_passcode_popup_content_1".localized
        passcodeTitle?.text = "emergency_unlock_title".localized
        tipLabel.text = "emergency_unlock_desc".localized
        //tipLabel.text = "device_passcode_popup_content_2".localized
    }
    
    func setupPasscodeField() {
    
        if IS_IPHONE_4() {
            passcodeTextField.font = UIFont.systemFont(ofSize: 15)
        } else if IS_IPHONE_5() {
            passcodeTextField.font = UIFont.systemFont(ofSize: 15)
        } else if IS_IPHONE_6() {
            passcodeTextField.font = UIFont.systemFont(ofSize: 16)
        } else if IS_IPHONE_6_PLUS() {
            passcodeTextField.font = UIFont.systemFont(ofSize: 17)
        } else if IS_IPHONE_X() {
            passcodeTextField.font = UIFont.systemFont(ofSize: 17)
        } else {
            passcodeTextField.font = UIFont.systemFont(ofSize: 19)
        }
        
        passcodeTextField.backgroundColor = UIColor.clear
        passcodeTextField.textColor = UIColor.darkGray
        passcodeTextField.textAlignment = .center
        passcodeTextField.placeholder = "dashboard_drawer_title_3".localized
        passcodeTextField.tintColor = UIColor.darkGray
        passcodeTextField.delegate = self
        passcodeTextField.keyboardType = .numberPad
        passcodeTextField.layer.borderColor = UIColor.lightGray.cgColor
        passcodeTextField.layer.borderWidth = 0.5
        passcodeTextField.isSecureTextEntry = true
        let preference = SwiftCommonUtility.shared.getPreferencesWithName("phonelock_pin")
        if let preference = preference {
            passcodeTextField.text = String(describing: preference.value)
        }
    }
    
    func setupSetButton() {
        
        if IS_IPHONE_4() {
            setButton.titleLabel?.font = UIFont(name: "OpenSans", size: 13)
        } else if IS_IPHONE_5() {
            setButton.titleLabel?.font = UIFont(name: "OpenSans", size: 13)
        } else if IS_IPHONE_6() {
            setButton.titleLabel?.font = UIFont(name: "OpenSans", size: 14)
        } else if IS_IPHONE_6_PLUS() {
            setButton.titleLabel?.font = UIFont(name: "OpenSans", size: 15)
        } else if IS_IPHONE_X() {
            setButton.titleLabel?.font = UIFont(name: "OpenSans", size: 15)
        } else {
            setButton.titleLabel?.font = UIFont(name: "OpenSans", size: 20)
        }
        setButton.setTitle("device_passcode_popup_button".localized, for: .normal)
    }
    
    //MARK: - BUTTON's ACTION
    @IBAction func actionCancelButton(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func actionSetButton(_ sender: UIButton) {
        
        var currentPasscode = ""
        let preference = SwiftCommonUtility.shared.getPreferencesWithName("phonelock_pin")
        if let preference = preference {
            currentPasscode = String(describing: preference.value)
        }
        if (passcodeTextField.text?.count ?? 0) < 4 || (passcodeTextField.text?.count ?? 0) > 16 {
            CommonModel.showAlert("", msg: "device_passcode_popup_content_4".localized)
        }else if passcodeTextField.text == currentPasscode{
            CommonModel.showAlert("", msg: "device_passcode_popup_content_3".localized)
        } else {
            let dict = [
                "name": "phonelock_pin",
                "status": Int(1),
                "value": passcodeTextField.text ?? ""
            ] as [String : Any]
            
            print("dict for phonlock = \(dict)")
            if control.identifier == nil {
                return
            }
            SwiftFTUtils.showHUDAdded(to: self.view, withText: "", animated: true)
            var value = ["pass_code":passcodeTextField.text ?? ""]
            let jsonData = (try? JSONSerialization.data(withJSONObject: value)) ?? Data()
            let jsonString = String(data: jsonData, encoding: .utf8)
            var params = ["child_id":control.childID ?? 0,
                          "feature_id":control.featureID ?? 0,
                          "identifier":control.identifier ?? "family_pause",
                          "value":jsonString] as [String : Any]
            let url = HLConstants.BASE_URL_CORE_2 + "controls"
            CoreManager.networkRequest(url: url, method: .put, params: params) { (response: EmptyResponseModel?, statusCode, message) in
                SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
                if message != nil {
                    CommonModel.showAlert("alert_error".localized, msg: message ?? "Nothing")
                    return
                }
                DBManager.shared.fetchControlAndUpdate(identifier: self.control.identifier ?? "", state: self.control.state ?? 0, value: self.passcodeTextField.text ?? "")
                self.passcodeSetAlert()
            }
//            HLApiManager.putControlApi(childId: control.childID ?? 0, featureId: control.featureID ?? 0, state: control.state ?? 0, identifier: "family_pause", value: passcodeTextField.text ?? "",isValue: true) { err in
//                print("Done")
//                SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
//                if err != nil {
//                    CommonModel.showAlert("alert_error".localized, msg: err ?? "Nothing")
//                    return
//                }
//                DBManager.shared.fetchControlAndUpdate(identifier: self.control.identifier ?? "", state: self.control.state ?? 0, value: self.passcodeTextField.text ?? "")
//                self.passcodeSetAlert()
//            }
            //CommonModel.updatePreference(dict, view: self, isNotification: false)
            
        }
    }
}
