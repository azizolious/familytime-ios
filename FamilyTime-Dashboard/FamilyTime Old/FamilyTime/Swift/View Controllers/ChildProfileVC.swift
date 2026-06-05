//
//  ChildProfileVC.swift
//  FamilyTime
//
//  Created by Sana Ullah on 22/08/2019.
//  Copyright © 2019 YumyApps. All rights reserved.
//

import UIKit

class ChildProfileVC: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var lblUpdateProfile: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var childImageVu: UIImageView!
    @IBOutlet weak var backImageVu:  UIImageView!
    @IBOutlet weak var nameLbl:         UILabel!
    @IBOutlet weak var basicInfoLbl:    UILabel!
    @IBOutlet weak var contactInfoLbl:  UILabel!
    @IBOutlet weak var nameTf:  UITextField!
    @IBOutlet weak var dobTf:   UITextField!
    @IBOutlet weak var emailTf: UITextField!
    @IBOutlet weak var phoneTf: UITextField!
    @IBOutlet weak var editBtn:     UIButton!
    @IBOutlet weak var timezoneBtn: UIButton!
    @IBOutlet weak var genderBtn:   UIButton!
    @IBOutlet weak var basicInfoHeightVuConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameVuHeightConstraint: NSLayoutConstraint!
    
    //MARK: Variables
    let datePicker = UIDatePicker()
    var delegate = AppDelegate.getSharedAppDelegateForSwift()
    var timezones  = [String]()
    var gmtTimezones  = [GMTTimezone]()
    var selectedTimeZoneIndex = 0
    private var package_id : String = ""
    private var package_name : String = ""
    private var device : String = ""
    
    //MARK: View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        let child_Id = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID) ?? ""
        package_id = CoreDataUtility.fetchPackageIdFor(child_id: Int32(child_Id) ?? 0)
        package_name = CoreDataUtility.fetchPackageNameFor(child_id: Int32(child_Id) ?? 0)
        device = CoreDataUtility.fetchPackageDeviceFor(child_id: Int32(child_Id) ?? 0)
        loadUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let child_Id = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID) ?? ""
        guard let childIDInt = Int(child_Id ) else {
        // Handle the error: childID is not a valid integer
        print("Error: childID is not a valid integer")
        return
    }

    let user_info = DBManager.shared.fetchChild(byID: childIDInt)
        
        
//        let user_info = CoreDataUtility.fetchChildInfoFromDatabase(child_id: child_Id)
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationItem.backBarButtonItem?.image = UIImage(named: "prevLoc")
        let date = CommonModel.date2(user_info?.birthday, oldFormat: "YYYY-MM-dd", format: "dd-MMM-YYYY")
        if let datee = date {
            datePicker.setDate(datee, animated: true)
        }
        
        if UIView.appearance().semanticContentAttribute == .forceRightToLeft{
            backImageVu.image = backImageVu.image?.withHorizontallyFlippedOrientation()
        }
        self.lblUpdateProfile.text = "child_profile_title".localized
        self.basicInfoLbl.text = "child_profile_content_1".localized
        self.contactInfoLbl.text = "child_profile_content_2".localized
        self.nameTf.placeholder = "child_profile_input_field_1".localized
        self.dobTf.placeholder = "child_profile_input_field_2".localized
        self.emailTf.placeholder = "child_profile_input_field_3".localized
        self.phoneTf.placeholder = "child_profile_input_field_4".localized
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.barTintColor = UIColor.white
    }
    
    //MARK: - Objective Functions
    @objc func donedatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        dobTf.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    //MARK: - IBActions
    @IBAction func editAction(_ sender: Any) {
        if editBtn.imageView?.image == #imageLiteral(resourceName: "pro_check") {
            print("api call to save")
            updateProfileApiCall()
            nameTf.resignFirstResponder()
        } else {
            shouldEnableEditMode(editMode: true)
            editBtn.setImage(#imageLiteral(resourceName: "pro_check"), for: .normal)
            nameTf.becomeFirstResponder()
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func genderAction(_ sender: Any) {
        let alert = UIAlertController(title: "child_profile_gender_drop_down_title".localized, message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "child_profile_gender_drop_down_1".localized, style: .default , handler:{ (UIAlertAction)in
            print("User click Male button")
            self.genderBtn.setTitle("child_profile_gender_drop_down_1".localized, for: .normal)
            self.genderBtn.tag = 0
        }))
        alert.addAction(UIAlertAction(title: "child_profile_gender_drop_down_2".localized, style: .default , handler:{ (UIAlertAction)in
            print("User click Female button")
            self.genderBtn.setTitle("child_profile_gender_drop_down_2".localized, for: .normal)
            self.genderBtn.tag = 1
        }))
        alert.addAction(UIAlertAction(title: "cancel_button".localized, style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        if !SwiftFTUtils.isDeviceiPhoneFamily(){
            alert.modalPresentationStyle = .popover
        }
        alert.popoverPresentationController?.sourceView = sender as! UIButton // works for both iPhone & iPad
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    @IBAction func timezoneAction(_ sender: Any) {
        SwiftFTUtils.selectTimeZone(with: self, with: selectedTimeZoneIndex, andTimeZones: gmtTimezones)
    }
    
    //MARK: - Helper Functions
    func updateProfileApiCall() {
        // Retrieve and validate child ID
        let child_Id = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID) ?? ""
        guard let childIDInt = Int(child_Id) else {
            print("Error: childID is not a valid integer")
            return
        }
        // Fetch child info from the database
        guard let child_info = DBManager.shared.fetchChild(byID: childIDInt) else {
            print("Error: Failed to fetch child info from the database")
            return
        }
        // Validate input fields
        if nameTf.text?.isEmpty ?? true {
            self.view.makeToast("child_profile_validation_3".localized)
            return
        }
        if let phone = phoneTf.text, !phone.isEmpty, phone.count < 6 {
            self.view.makeToast("child_profile_validation_2".localized)
            return
        }
        if let email = emailTf.text, !email.isEmpty, !CommonUtility.shared.isValidEmail(emailStr: email) {
            self.view.makeToast("child_profile_validation_4".localized)
            return
        }
        // Set gender based on the selected button
        child_info.gender = (self.genderBtn.tag == 0) ? "male" : "female"
        // Prepare API URL and parameters
        let url = HLConstants.BASE_URL_CORE_2 + "devices/account"
        let tz = gmtTimezones[selectedTimeZoneIndex]
        let params = SwiftParamUtility.shared.childProfileUpdateParams(timezone: tz, vc: self)
        // Show loading indicator
        SwiftFTUtils.showHUDAdded(to: view, withText: "", animated: true)
        // Make the network request using the new API structure
        CoreManager.networkRequest(url: url, method: .put, params: params) { (response: EmptyResponseModel?, statusCode, errorMessage) in
            SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
            DispatchQueue.main.async {
                print("API response code = \(statusCode ?? 0)")
                
                if statusCode == 204 {
                    // Handle success
                    self.shouldEnableEditMode()
                    self.editBtn.setImage(#imageLiteral(resourceName: "pro_edit"), for: .normal)
                    self.view.makeToast("child_profile_alert_content".localized)
                    self.nameLbl.text = self.nameTf.text ?? ""
                    self.updateChildInfo()
                } else {
                    // Handle error
                    CommonModel.showAlert("alert_error".localized, msg: errorMessage ?? SwiftConstants.kGeneralErrorMsg)
                }
                
            }
        }
    }
    
//    func updateProfileApiCall(){
//        let child_Id = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID) ?? ""
//        
//        guard let childIDInt = Int(child_Id ) else {
//        // Handle the error: childID is not a valid integer
//        print("Error: childID is not a valid integer")
//        return
//    }
//
//    let child_info = DBManager.shared.fetchChild(byID: childIDInt)
//        
////        let child_info = CoreDataUtility.fetchChildInfoFromDatabase(child_id: child_Id)
//        if nameTf.text == ""{
//            self.view.makeToast("child_profile_validation_3".localized)
//            return
//        }
//        if phoneTf.text != ""{
//            guard let phone = phoneTf.text, (phone.count >= 6) else{
//                self.view.makeToast("child_profile_validation_2".localized)
//                return
//            }
//        }
//        if emailTf.text != ""{
//            guard let email = emailTf.text, (CommonUtility.shared.isValidEmail(emailStr: email)) else{
//                self.view.makeToast("child_profile_validation_4".localized)
//                return
//            }
//        }
//        if self.genderBtn.tag == 0 {
//            child_info?.gender = "Male"
//        } else {
//            child_info?.gender = "Female"
//        }
//        let url = SwiftAPIConstants.KChildEditProfile_mesh2 + child_Id
//        let tz = gmtTimezones[selectedTimeZoneIndex]
//        let params = SwiftParamUtility.shared.childProfileUpdateParams(timezone: tz, vc: self)
//        print("url = \(url) and params = \(params)")
//        SwiftFTUtils.showHUDAdded(to: view, withText: "", animated: true)
//        ApiManager.shared().putApi(url, params: params, controller: self, isContPresented: false) { (msg, code) in
//            DispatchQueue.main.async{
//                SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
//                print("api response msg = \(msg) and code = \(code)")
//                if code == 200 {
//                    CoreDataUtility.updateAllHomeData()
//                    print("updated successfully")
//                    self.shouldEnableEditMode()
//                    self.editBtn.setImage(#imageLiteral(resourceName: "pro_edit"), for: .normal)
//                    self.view.makeToast("child_profile_alert_content".localized)
//                    self.nameLbl.text = self.nameTf.text ?? ""
//                    self.updateChildInfo()
//                } else {
//                    CommonModel.showAlert("alert_error".localized, msg: SwiftConstants.kGeneralErrorMsg)
//                }
//            }
//        }
//    }
}

//MARK: SwiftTimeZonesViewController Delegates
extension ChildProfileVC : SwiftTimeZonesViewControllerDelegate{
    func didTimeZoneChanged(to selectedIndex: Int) {
        selectedTimeZoneIndex = selectedIndex
        print("selected timezone index = \(selectedIndex)")
        let tz = gmtTimezones[selectedIndex]
        timezoneBtn.setTitle(tz.strRep, for: .normal)
    }
}

//MARK: - UTILITY METHODS FOR THIS CLASS
extension ChildProfileVC {
    func loadTimezones(){
        if timezones.count == 0 {
            timezones = NSTimeZone.knownTimeZoneNames
            print(timezones)
            gmtTimezones = [GMTTimezone]()
            for name in timezones{
                gmtTimezones.append(getTimeZoneWithName(name: name))
            }
            print(gmtTimezones)
            let sortDescriptor = NSSortDescriptor.init(key: "gmtDiff", ascending: true)
            gmtTimezones = (gmtTimezones as NSArray).sortedArray(using: [sortDescriptor]) as! [GMTTimezone]
        }
        
        if UIView.appearance().semanticContentAttribute == .forceRightToLeft{
            timezoneBtn.contentHorizontalAlignment = .right
            genderBtn.contentHorizontalAlignment = .right
        } else {
            timezoneBtn.contentHorizontalAlignment = .left
            genderBtn.contentHorizontalAlignment = .left
        }
    }
    
    func shouldEnableEditMode(editMode:Bool = false){
        nameTf.isEnabled      = editMode
        timezoneBtn.isEnabled = editMode
        dobTf.isEnabled     = editMode
        genderBtn.isEnabled = editMode
        emailTf.isEnabled   = editMode
        phoneTf.isEnabled   = editMode
    }
    
    //MARK: - TIME ZONE METHODS
    func getTimeZoneWithName(name:String) -> GMTTimezone{
        let tz = GMTTimezone()
        let atimezone = NSTimeZone.init(name: name)
        let minutes   = ((atimezone?.secondsFromGMT ?? 0) / 60) % 60
        let hours     = (atimezone?.secondsFromGMT ?? 0) / 3600
        let aStrOffset = (hours > 0) ? String(format: "+%02ld:%02ld", Int(hours), Int(minutes)) : String(format: "%02ld:%02ld", Int(hours), Int(minutes))
        tz.strRep  = "(GMT \(aStrOffset)) \(name)"
        tz.gmtDiff = atimezone?.secondsFromGMT ?? 0
        tz.name    = name
        print("strrep = \(String(describing: tz.strRep))")
        return tz
    }
    
    
    func getIndexOfSelectedTimeZone(timezone:String) -> NSInteger{
        var timezoneindex = 0
        for (index, tz) in gmtTimezones.enumerated(){
            if tz.name == timezone{
                timezoneindex = index
                break
            }
        }
        print("selected index = \(timezoneindex)")
        return timezoneindex
    }
}

//MARK: - UI METHODS
extension ChildProfileVC {
    func loadUI(){
        let child_Id = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID) ?? ""
        let childID = Int(child_Id)
        let child = DBManager.shared.fetchChild(byID: childID ?? 0)
        let packageId = self.package_id
//        for child in children {
            
        
                if packageId == "1" {
                    backgroundView.backgroundColor = CommonModel.color(fromHexString: kDarkGray)
                } else {
                    backgroundView.backgroundColor = CommonModel.color(fromHexString: child?.color)
                }
                backImageVu.image     = backImageVu.image?.withRenderingMode(.alwaysTemplate)
                backImageVu.tintColor = UIColor.white
                nameLbl.text = child?.name
                childImageVu.image = (child?.gender?.lowercased() == "male") ? #imageLiteral(resourceName: "avatar_boy1") : #imageLiteral(resourceName: "avatar_girl1")
                nameTf.text     = child?.name
                dobTf.text      = child?.birthday
                emailTf.text    = child?.email
                phoneTf.text    = child?.phone
                if child?.gender?.capitalized == "Male" {
                    genderBtn.setTitle("child_profile_gender_drop_down_1".localized, for: .normal)
                    self.genderBtn.tag = 0
                } else {
                    genderBtn.setTitle("child_profile_gender_drop_down_2".localized, for: .normal)
                    self.genderBtn.tag = 1
                }
                let gmttimezone = getTimeZoneWithName(name: child?.timeZone ?? "")
                timezoneBtn.setTitle(gmttimezone.strRep, for: .normal)
                selectedTimeZoneIndex = getIndexOfSelectedTimeZone(timezone: child?.timeZone ?? "")
            
        
        loadTimezones()
        shouldEnableEditMode()
        showDatePicker()
        print("selected timezone index = \(selectedTimeZoneIndex)")
        if !SwiftFTUtils.isDeviceiPhoneFamily(){
            basicInfoHeightVuConstraint.constant = 340
            nameVuHeightConstraint.constant      = 280
            editBtn.layer.cornerRadius           = 36
            editBtn.layer.masksToBounds          = true
        }
    }
    
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        let currentDate = Date()
        var dateComponents = DateComponents()
        //---SET MAXIMUM DATE---//
        dateComponents.year = -3
        let threeYearsDate = NSCalendar.current.date(byAdding: dateComponents, to: currentDate)
        datePicker.maximumDate = threeYearsDate
        //---SET MINIMUM DATE---//
        dateComponents.year = -18
        let eighteenYearsDate = NSCalendar.current.date(byAdding: dateComponents, to: currentDate)
        datePicker.minimumDate = eighteenYearsDate
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "done_button".localized, style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "cancel_button".localized, style: .plain, target: self, action: #selector(cancelDatePicker));
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        dobTf.inputAccessoryView = toolbar
        dobTf.inputView = datePicker
    }
    
    func updateChildInfo(){
        let child_Id = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID) ?? ""
//        let children = CoreDataUtility.fetchDashboardFromDatabaseNEW(childssID: child_Id)
//        print(children)
//        for child in children {
//            let user_info = child.childInfo
//            let name = user_info?.name ?? ""
//            let birthday = user_info?.birthday ?? ""
//            let email = user_info?.email ?? ""
//            let phone = user_info?.phone ?? ""
//            let timeZone = user_info?.timeZone ?? ""
//            if self.genderBtn.tag == 0 {
//                user_info?.gender = "Male"
//            } else {
//                user_info?.gender = "Female"
//            }
//            self.nameTf.text = name
//            self.dobTf.text = birthday
//            self.emailTf.text = email
//            self.phoneTf.text = phone
//            self.timezoneBtn.setTitle(timeZone, for: .normal)
//        }
//        NotificationCenter.default.post(name: NSNotification.Name(SwiftConstants.kReload_Dashboard), object: nil)
    }
}
