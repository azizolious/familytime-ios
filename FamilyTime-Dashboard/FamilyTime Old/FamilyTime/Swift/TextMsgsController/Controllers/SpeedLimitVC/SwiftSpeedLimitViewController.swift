//
//  SwiftSpeedLimitViewController.swift
//  FamilyTime
//
//  Created by YumyApps on 03/11/2021.
//  Modified by Usama-Apps on 06/01/2023.
//  Copyright © 2021 YumyApps. All rights reserved.
//

import UIKit
import MBProgressHUD

class SwiftSpeedLimitViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: - IBOutlets
    @IBOutlet weak var enableSpeedLimit: UILabel!
    @IBOutlet weak var switchView: UISwitch!
    @IBOutlet weak var overspeedLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var speedTextField: UITextField!
    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var kphCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var KPH: UILabel!
    
    //MARK: - Variables
    var rightButton = UIBarButtonItem()
    let delegate = UIApplication.shared.delegate as? AppDelegate
    let child_Id = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
    var speedometerTopMargin = NSLayoutConstraint()
    var saveButtonBottomMargin = NSLayoutConstraint()
    var speedometerImageHeight = NSLayoutConstraint()
    var speedometerImageWidth = NSLayoutConstraint()
    var textfieldWidth = NSLayoutConstraint()
    var textfieldHeightConstraint = NSLayoutConstraint()
    var speedTitleTopMargin = NSLayoutConstraint()
    var tapGesture = UITapGestureRecognizer()
    var control = Control()
    //MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        speedLabel.adjustsFontSizeToFitWidth = true
        speedTextField.isUserInteractionEnabled = false
        enableSpeedLimit.text = "speed_limit_switch_1".localized
        rightButton = UIBarButtonItem(title: "save_button".localized, style: .plain, target: self, action: #selector(handleSaveButton(_:)))
        navigationItem.rightBarButtonItems = [rightButton]
        title = "ssettings_card_2_ios_5".localized
        speedTextField.text = ""
        speedTextField.tintColor = UIColor.red
        speedTextField.delegate = self
        if iPhone4 {
            speedometerTopMargin.constant = 10
            speedTextField.font = UIFont(name: "Open24DisplaySt", size: 100)
            textfieldHeightConstraint.constant = 90
            speedTitleTopMargin.constant = 30
            speedLabel.font = UIFont(name: "OpenSans", size: 25)
            overspeedLabel.font = UIFont(name: "OpenSans-Light", size: 13)
            saveButtonBottomMargin.constant = 15
        } else if iPhone5 {
            speedometerTopMargin.constant = 40
            speedTextField.font = UIFont(name: "Open24DisplaySt", size: 100)
            textfieldHeightConstraint.constant = 90
            speedTitleTopMargin.constant = 60
            speedLabel.font = UIFont(name: "OpenSans", size: 25)
            overspeedLabel.font = UIFont(name: "OpenSans-Light", size: 13)
        } else if iPhone6 {
            speedTextField.font = UIFont(name: "Open24DisplaySt", size: 100)
            textfieldHeightConstraint.constant = 90
            speedTitleTopMargin.constant = 100
            speedLabel.font = UIFont(name: "OpenSans", size: 35)
            overspeedLabel.font = UIFont(name: "OpenSans-Light", size: 15)
        } else if iPhone6Plus {
            speedTextField.font = UIFont(name: "Open24DisplaySt", size: 100)
            textfieldHeightConstraint.constant = 90
            speedTitleTopMargin.constant = 100
            speedLabel.font = UIFont(name: "OpenSans", size: 30)
            overspeedLabel.font = UIFont(name: "OpenSans-Light", size: 15)
        } else if iPhoneX {
            speedTextField.font = UIFont(name: "Open24DisplaySt", size: 100)
            textfieldHeightConstraint.constant = 90
            speedTitleTopMargin.constant = 100
            speedLabel.font = UIFont(name: "OpenSans", size: 35)
            overspeedLabel.font = UIFont(name: "OpenSans-Light", size: 15)
        } else {
            speedometerImageWidth.constant = 568
            speedometerImageHeight.constant = 280
            textfieldWidth.constant = 120
            speedTextField.font = UIFont(name: "Open24DisplaySt", size: 100)
            textfieldHeightConstraint.constant = 140
            speedTitleTopMargin.constant = 150
            speedLabel.font = UIFont(name: "OpenSans", size: 55)
            overspeedLabel.font = UIFont(name: "OpenSans-Light", size: 20)
            saveButtonBottomMargin.constant = 75
        }
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
        speedLabel.text = "speed_limit_content_1".localized
        overspeedLabel.text = "speed_limit_content_2".localized
        if UIView.appearance().semanticContentAttribute == .forceRightToLeft{
            self.carImage.image = self.carImage.image?.withHorizontallyFlippedOrientation()
            self.speedTextField.semanticContentAttribute = .forceRightToLeft
            self.kphCenterConstraint.constant = -60.0
        } else {
            self.kphCenterConstraint.constant = 60.0
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        edgesForExtendedLayout = []
        self.loadSpeed()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - IBActions
    @IBAction func switchValueChanged(_ sender: Any) {
        let mySwitch = sender as? UISwitch
        if mySwitch?.isOn ?? false {
            speedTextField.isUserInteractionEnabled = true
        } else {
            speedTextField.isUserInteractionEnabled = false
        }
    }
    
    //MARK: - Objective Functions
    @objc func handleTap(_ gesture: UIGestureRecognizer?) {
        if gesture?.state == .ended {
            speedTextField.resignFirstResponder()
        }
    }
    
    @objc func handleSaveButton(_ sender: Any) {
        updateActivation()
    }
    
    //MARK: - Helper Functions
    func loadSpeed() {
        let childID = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        let preferences = CoreDataUtility.fetchPreferenceFromDatabase(child_id: childID ?? "")
        let speedlimitPreference = SwiftCommonUtility.shared.getPreferencesForLockView(preferences, "speed_limit")
        var controlFromDB = DBManager.shared.fetchAppBlockControl(identifier: "speed_limit")
        self.control = controlFromDB
        switchView.isOn = false
        if control.state == 1 {
            switchView.isOn = true
        }
        
        var speedLimitValue: Int = 45 // Default value
        
        if let value = control.value {
            if let data = value.data(using: .utf8) {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let speedLimit = json["speed_limit"] as? Int {
                        speedLimitValue = speedLimit
                    }
                } catch {
                    print("Failed to parse JSON: \(error.localizedDescription)")
                }
            }
        }
        
        speedTextField.text = "\(speedLimitValue)"
        
        if switchView.isOn {
            speedTextField.isUserInteractionEnabled = true
        } else {
            speedTextField.isUserInteractionEnabled = false
        }
        
//        switchView.isOn = false
//        if speedlimitPreference?.status == 1 {
//            switchView.isOn = true
//        }
//        if let value = speedlimitPreference?.value {
//            speedTextField.text = "\(value)"
//        }
//        if switchView.isOn {
//            speedTextField.isUserInteractionEnabled = true
//        } else {
//            speedTextField.isUserInteractionEnabled = false
//        }
    }
    
//    func updateSpeed() {
//        var speedInInt = 0
//        if let unwrappedString = speedTextField.text {
//            if let unwrappedIntegerInit = Int(unwrappedString) {
//                speedInInt = unwrappedIntegerInit
//            }
//        }
//        
//        if speedInInt <= 25 {
//            CommonModel.showAlert("ssettings_card_2_ios_5".localized, msg: "speed_limit_alert_2".localized)
//            return
//        }
//        
//        SwiftFTUtils.showHUDAdded(to: view, withText: "Updating...".localized, animated: true)
//        let url = String(format: "\(kBasUrlNew_mesh2)/dashboard/settings/ios/speedlimit/\(String(describing: child_Id))")
//        let paramStr = "speed_limit=\(speedTextField.text ?? "")"
//        ApiManager.shared().mesh_postApi(withParamString: paramStr, withApi: url) { json, errorCode, message in
//            DispatchQueue.main.async {
//                print("Old Mesh update speed limit api json response = \(json)")
//                if json["status"] as? Int == 200 {
//                    let childID = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
//                    let preferences = CoreDataUtility.fetchPreferenceFromDatabase(child_id: childID ?? "")
//                    let speedlimitPreference = SwiftCommonUtility.shared.getPreferencesForLockView(preferences, "speed_limit")
//                    let currentSpeed = self.speedTextField.text
//                    speedlimitPreference?.value = currentSpeed ?? ""
//                    DispatchQueue.main.async {
//                        CoreDataUtility.updateAllHomeData()
//                    }
//                } else {
//                    CommonModel.showAlert("alert_error".localized, msg: json["message"] as? String)
//                }
//                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
//            }
//        }
//    }
    
    func updateActivation() {
        var speedInInt = 0
        if let unwrappedString = speedTextField.text {
            if let unwrappedIntegerInit = Int(unwrappedString) {
                speedInInt = unwrappedIntegerInit
            }
        }
        if speedInInt <= 25 {
            CommonModel.showAlert("ssettings_card_2_ios_5".localized, msg: "speed_limit_alert_2".localized)
            return
        }
        
        SwiftFTUtils.showHUDAdded(to: view, withText: "Updating...".myModification(), animated: true)
        //        let url = String(format: "\(kBasUrlNew_mesh2)/dashboard/settings/ios/speedlimit/\(Int(child_Id ?? "-1") ?? -1)")
        //        var param: [String : Any] = [:]
        //        param["status"] = switchView.isOn ? "1" : "0"
        //        param["speed_limit"] = speedTextField.text
        //        var jsonString: String?
        //        do {
        //            var jsonData: Data? = nil
        //            do {
        //                jsonData = try JSONSerialization.data(
        //                    withJSONObject: param/* Pass 0 if you don't  care about the readability of the generated string */)
        //            } catch {
        //            }
        //
        //            if (jsonData == nil) {
        //
        //                print("Got an error")
        //
        //                } else {
        //
        //                    jsonString = String(data: jsonData!, encoding: .utf8)
        //                    print("\(jsonString ?? "")")
        //
        //                }
        //
        //        }
        
        
        let speedLimitValue = speedTextField.text ?? "0"
        let speedLimitPayload = "{\"speed_limit\":\(speedLimitValue)}"
        
        if let childId = control.childID,
           let featureId = control.featureID,
           let identifier = control.identifier {
            
            HLApiManager.putControlApi(
                childId: childId,
                featureId: featureId,
                state: switchView.isOn.boolToInt(),
                identifier: identifier,
                value: speedLimitPayload,
                isValue: true
            ) { err in
                DispatchQueue.main.async { [self] in
                    SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
                    
                    if let err = err {
                        print("Error updating control api: \(err)")
                        CommonModel.showAlert("alert_error".localized, msg: err)
                        return
                    }
                    
                    DBManager.shared.fetchControlAndUpdate(
                        identifier: identifier,
                        state: switchView.isOn.boolToInt(),
                        value: speedLimitPayload
                    )
                    
                    var controlFromDB = DBManager.shared.fetchAppBlockControl(identifier: "speed_limit")
                    let childID = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
                    let preferences = CoreDataUtility.fetchPreferenceFromDatabase(child_id: childID ?? "")
                    let speedlimitPreference = SwiftCommonUtility.shared.getPreferencesForLockView(preferences, "speed_limit")
                    let currentSpeed = speedTextField.text
                    speedlimitPreference?.status = switchView.isOn ? 1 : 0
                    speedlimitPreference?.value = currentSpeed ?? ""
                    CoreDataUtility.updateAllHomeData()
                    CommonModel.showAlert("", msg: "speed_limit_alert_1".localized)
                }
            }
        } else {
            SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
            CommonModel.showAlert("alert_error".localized, msg: "alert_something_wrong_again")
            print("❌ Missing required params (childId / featureId / identifier)")
        }
        
        
        //        HLApiManager.mesh_putApi(withParamString: param, withApi: url) { json, errorCode, message in
        //            DispatchQueue.main.async { [self] in
        //                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
        //                print("Old Mesh update speed limit api json response = \(String(describing: json))")
        //                if json?["status"] as? Int == 200 {
        //                    let childID = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        //                    let preferences = CoreDataUtility.fetchPreferenceFromDatabase(child_id: childID ?? "")
        //                    let speedlimitPreference = SwiftCommonUtility.shared.getPreferencesForLockView(preferences, "speed_limit")
        //                    let currentSpeed = speedTextField.text
        //                    speedlimitPreference?.status = switchView.isOn ? 1 : 0
        //                    speedlimitPreference?.value = currentSpeed ?? ""
        //                    CoreDataUtility.updateAllHomeData()
        //                    CommonModel.showAlert("", msg: "speed_limit_alert_1".localized)//json?["message"] as? String
        //                } else {
        //                    CommonModel.showAlert("alert_error".localized, msg: json?["message"] as? String)
        //                }
        //                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
        //            }
        //        }
        
        // }
    }
    
    //MARK: - UitextField Delegate and Datasourse
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        /*updateSpeed*/()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // allow adding of chars
        if (textField.text?.count ?? 0) < 2 && Int(string) ?? 0 >= 0 && Int(string) ?? 0 <= 9 {
            return true
        }
        // allow deleting
        if (textField.text?.count ?? 0) == 2 && string.count == 0 && Int(string) ?? 0 >= 0 && Int(string) ?? 0 <= 9 {
            return true
        }
        return false
    }
}
