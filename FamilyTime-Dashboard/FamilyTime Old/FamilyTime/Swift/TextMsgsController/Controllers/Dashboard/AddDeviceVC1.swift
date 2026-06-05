//
//  AddDeviceVC1.swift
//  FamilyTime
//
//  Created by Sana Ullah on 05/12/2018.
//  Copyright © 2018 YumyApps. All rights reserved.
//

import UIKit

class AddDeviceVC1: UIViewController {
    //MARK: - VARIABLES
    var containerView: UIView?
    var titleLabel: UILabel?
    var logoImageView: UIImageView?
    var firstLabel: UILabel?
    var secondLabel: UILabel?
    var nameField: UITextField?
    var relationTableView: UITableView?
    var childField: UIButton?
    var addDeviceButton: UIButton?
   
    var relationship = ""
    var selectedTimeZoneIndex: Int = 0
    var selectedTimeZone = ""
    var timezones: [Any] = []
    var gmtTimezones: [AnyHashable] = []
    
    var name = ""
    var isChild = false
    var timezone = ""
    var fromDashboard = false
    var addingNewUserFromDashboard = false
    var cancelButton = false
    var stateMaintain = ""
    var newUser = false
    
    //MARK: - IBOUTLETS
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblSubtitle: UILabel!
    
    @IBOutlet var textFieldTextPicker: IQDropDownTextField!
    @IBOutlet var textFieldName: SkyFloatingLabelTextField!
    @IBOutlet var btnNext: UIButton!
    @IBOutlet var btnCancel: UIButton!
    
    @IBOutlet weak var subtitleLblTopConst: NSLayoutConstraint!
    @IBOutlet weak var topLblTopConst: NSLayoutConstraint!
    //**************************************************************************************//
    
        //---CANCEL_BTN WIDTH = NEXT_BTN WIDTH---AND NEXT BTN WIDTH = TEXT_FIELD_VIEW WIDTH---//
        //---SO CHANGING VIEW WIDTH WILL CHANGE NEXT AND CANCEL BTN WIDTH TOO---//
        //---//SAME FOR NAME TEXT FIELD HEIGHT----//
    
    @IBOutlet weak var textFieldVuWidthConst: NSLayoutConstraint!
    @IBOutlet weak var nameTfHeightConst: NSLayoutConstraint!
    //**************************************************************************************//

    //MARK: - VIEW LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        initialization()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        
        textFieldName.lineHeight = 2.0
        if cancelButton == true {
            btnCancel.isHidden = false
        } else {
            btnCancel.isHidden = true
        }
        
        if (stateMaintain == "YES") {
            textFieldName.text               = UserDefaults.standard.object(forKey: "LatestChildName") as? String
            textFieldTextPicker.selectedItem = UserDefaults.standard.string(forKey: "LatestChildRelationship")
            textFieldTextPicker.selectedItem = textFieldTextPicker.selectedItem?.myModification()
            movetoSecondScreen()
        }
                
        lblTitle.text       = lblTitle.text?.myModification()
        lblSubtitle.text    = lblSubtitle.text?.myModification()
    }//---END WILL APPEAR---//
    
    
    //MARK: - CUSTOM METHODS
    func initialization(){
        uiSetup()
        
        lblTitle.text    = lblTitle.text?.myModification()
        lblSubtitle.text = lblSubtitle.text?.myModification()
        
        btnCancel.setTitle("Cancel".myModification(), for: .normal)
        btnNext.setTitle("NEXT".myModification(), for: .normal)
        
        lblTitle.text    = "Let's Get Started!".myModification()
        lblSubtitle.text = "Please enter the device name in the given field. You can change the name afterwards from the Profile Screen.".myModification()
        // Do any additional setup after loading the view.
        
        textFieldTextPicker.dropDownMode        = .textPicker
        textFieldTextPicker.isOptionalDropDown  = false
        textFieldTextPicker.itemList            = ["Please select relationship", "Son", "Daughter"]
        
        let toolbar         = UIToolbar()
        toolbar.barStyle    = .default
        toolbar.sizeToFit()
        let buttonflexible  = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let buttonDone      = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.doneClicked(_:)))
        toolbar.items       = [buttonflexible, buttonDone]
        textFieldTextPicker.selectedItem = textFieldTextPicker.selectedItem?.myModification()
    }
    
    func uiSetup(){
        if SwiftFTUtils.isDeviceiPhoneFamily(){
            self.textFieldVuWidthConst.constant = 280
        }
        else{
            textFieldVuWidthConst.constant = 420
            nameTfHeightConst.constant     = 60
            topLblTopConst.constant        = 15
            subtitleLblTopConst.constant   = 20
            
            lblTitle.font    = UIFont(name: "OpenSans-Semibold", size: 33)
            lblSubtitle.font = UIFont(name: "OpenSans-Semibold", size: 25)
            
            btnNext.titleLabel?.font   = UIFont(name: "OpenSans-Semibold", size: 22)
            btnCancel.titleLabel?.font = UIFont(name: "OpenSans-Semibold", size: 22)
            
            textFieldTextPicker.font = UIFont(name: "OpenSans", size: 22)
            textFieldName.font       = UIFont(name: "OpenSans", size: 22)
        }
        
        btnNext.layer.cornerRadius    = self.nameTfHeightConst.constant / 2.0
        btnCancel.layer.cornerRadius  = self.nameTfHeightConst.constant / 2.0
        btnNext.layer.masksToBounds   = true
        btnCancel.layer.masksToBounds = true
    }
    
    func validateData() -> Bool{
        
        if (!(textFieldName.text == "")) && (!(textFieldTextPicker.selectedItem == "Please select relationship")) {
            return true
        } else {
            if (textFieldName.text == "") {
                CommonModel.showAlert("Enter Child's Name".myModification(), msg: "")
            }
            else if (textFieldTextPicker.selectedItem == "Please select relationship")
            {
                CommonModel.showAlert("Select Relationship".myModification(), msg: "")
            }
            
            return false
        }
    }
    
    func movetoSecondScreen() {
        var storyboardName = "Steps"
        if UI_USER_INTERFACE_IDIOM() == .pad {
            storyboardName = "Steps_Ipad"
        }
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(withIdentifier: "SwiftAddDeviceNewViewController3") as? SwiftAddDeviceNewViewController3
        controller?.strName = textFieldName.text!;
        controller?.newUser = newUser;
        
        navigationController?.pushViewController(controller ?? UIViewController(), animated: true)
        UserDefaultsManager.ChildAdded = true
    }
    
    func dissmisshere() {
        //---IOS 13 MODEL SCREEN ISSUE---//
        dismiss(animated: true) {}
        
        navigationController?.popViewController(animated: true)
        //---IOS 13 MODEL SCREEN ISSUE---//
    }
    
    @objc func doneClicked(_ button: UIBarButtonItem?) {
        view.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        view.endEditing(true)
        moveFrame(toVerticalPosition: 0.0, forDuration: 0.3)
    }
    func moveFrame(toVerticalPosition position: Float, forDuration duration: Float) {
        var frame: CGRect = view.frame
        frame.origin.y = CGFloat(position)
        
        UIView.animate(withDuration: TimeInterval(duration), animations: {
            self.view.frame = frame
        })
    }
    
    //MARK: - UI ACTIONS
    @IBAction func handleAddDevice(_ sender: Any) {
        var params: [AnyHashable : Any] = [:]
        var urlStr = "" //= KChildRegUrl;
        let type = "Child"
        let delegate = AppDelegate.getSharedAppDelegateForSwift()
        
        if validateData(){
            let timeZoneLocal = NSTimeZone.local as NSTimeZone
            selectedTimeZone  = timeZoneLocal.name
            if type == "Child"
            {
                let r = (Int(arc4random()) % 4) + 1
                let randColor = CommonModel.randomColor(Int(Int32(r)))
                
                var strGender = ""
                if (textFieldTextPicker.selectedItem == "Son") {
                    strGender = "male"
                } else if (textFieldTextPicker.selectedItem == "Daughter") {
                    strGender = "female"
                }
                
                if let anItem = textFieldTextPicker.selectedItem {
                    params = ["name"         : textFieldName.text ?? "",
                              "birthday"     : "0000-00-00",
                              "gender"       : strGender,
                              "relationship" : anItem,
                              //"package"      : "Standard",
                              //"duration"     : "1",
                              "color"        : randColor ?? "",
                              "time_zone"    : selectedTimeZone,
                              "phone"        : "",
                              "email"        : ""]
                }
                urlStr = SwiftAPIConstants.kChildRegUrl
            }
            
            //---SANA CHANGE---//---ONLY CHILD CAN BE ADDED---//
            
            //            else
            //            {
            //                let email       = "jkhjhk@khjkjh.hkjhj".trimmingCharacters(in: CharacterSet.whitespaces)
            //                let genderp     = "male"
            //                let r           = (Int(arc4random()) % 4) + 1
            //                let randColor   = CommonModel.randomColor(Int32(r))
            //
            //                params = ["name": "", "email": email, "color": randColor ?? "", "gender": genderp, "relationship": ""]
            //                urlStr = SwiftAPIConstants.kUserAddUrl
            //            }
            
            SwiftFTUtils.showHUDAdded(to: view, withText: "Adding Profile...".myModification(), animated: true)
            ApiManager.shared().postApi(withVC: self, isPresentedCont: true, andParams: params, withApi: urlStr) { (message, statusCode) in
                
                DispatchQueue.main.async{
                    SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
                    if statusCode == 200{
                        UserDefaults.standard.set(self.textFieldName.text, forKey: "LatestChildName")
                        UserDefaults.standard.set(self.textFieldTextPicker.selectedItem, forKey: "LatestChildRelationship")
                        UserDefaults.standard.synchronize()
                        self.movetoSecondScreen()
                    }
                    else{
                        CommonModel.showAlert("Error!", msg: message)
                    }
                }
            }
        }
    }
    
    @IBAction func nextAction(_ sender: Any) {
        //---testing---//
        handleAddDevice("abc")
        //        movetoSecondScreen()
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dissmisshere()
    }
    
}
