//
//  DeviceVC.swift
//  FamilyTime
//
//  Created by Sana Ullah on 31/05/2019.
//  Copyright © 2019 YumyApps. All rights reserved.
//

import UIKit

class DeviceVC: UIViewController {

    
    
    @IBOutlet weak var backImageVu: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var childImageVu: UIImageView!
    
    @IBOutlet weak var deviceInfoLbl: UILabel!
    
    @IBOutlet weak var manufacturerNameLabel: UILabel!
    @IBOutlet weak var manufacturerValueLabel: UILabel!
    @IBOutlet weak var deviceOSNameLabel: UILabel!
    @IBOutlet weak var deviceOSValueLabel: UILabel!
    @IBOutlet weak var deviceOsImage: UIImageView!
    
    @IBOutlet weak var appVersionImage: UIImageView!
    
    @IBOutlet weak var languageNameLabel: UILabel!
    @IBOutlet weak var languageValueLabel: UILabel!
    @IBOutlet weak var timeZoneNameLabel: UILabel!
    @IBOutlet weak var timeZoneValueLabel: UILabel!
    @IBOutlet weak var batteryNameLabel: UILabel!
    @IBOutlet weak var batteryValueLabel: UILabel!
    @IBOutlet weak var wifiNameLabel: UILabel!
    @IBOutlet weak var wifiValueLabel: UILabel!
    
    @IBOutlet weak var appInfoLbl: UILabel!
    @IBOutlet weak var appVersionLbl: UILabel!
    @IBOutlet weak var appVersionValueLbl: UILabel!
    @IBOutlet weak var buildLbl: UILabel!
    @IBOutlet weak var buildValueLbl: UILabel!
    @IBOutlet weak var helpDeskLbl: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var topView: UIView!
    
    
    private var package_id : String = ""
    private var package_name : String = ""
    private var device : String = ""
    let child_Id = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
    
    @objc var flagToHideNavBar:Bool = true
    
    var delegate : AppDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //initialization()
        
        let selectedChildID = UserDefaults.standard.integer(forKey: "selectedChildId")
        package_id = CoreDataUtility.fetchPackageIdFor(child_id: Int32(selectedChildID))
        package_name = CoreDataUtility.fetchPackageNameFor(child_id:  Int32(selectedChildID))
        device = CoreDataUtility.fetchPackageDeviceFor(child_id:  Int32(selectedChildID))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        LiveVisitorManager.shared.updateScreen(
            "Device Information"
        )
//        if flagToHideNavBar{
//            //navigationController?.setNavigationBarHidden(true, animated: true)
//            //navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: .plain, target: nil, action: nil)
//        }else{ //---IF USER COMES FROM DRAWER MENU THEN SHOW TOP NAV BAR---//
            self.title = "settings_content_3_sub_content_1".localized
            navigationController?.setNavigationBarHidden(false, animated: true)
        
//            navigationController?.navigationBar.barTintColor = .white
           backBtn.isHidden = true
           backImageVu.isHidden = true
//            navigationController?.setNavigationBarHidden(false, animated: true)
//            navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: .plain, target: nil, action: nil)
       // }
        
        //This line is use beacause UI going under navigationbar
        edgesForExtendedLayout = []
        
        initialization()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        if flagToHideNavBar{
//            navigationController?.setNavigationBarHidden(false, animated: true)
//            navigationController?.navigationBar.barTintColor = UIColor.white
//        }
         
    }
    
    func initialization(){
        //navigationController?.navigationBar.barTintColor = UIColor.FTOrange

       // backImageVu.image     = backImageVu.image?.withRenderingMode(.alwaysTemplate)
        //backImageVu.tintColor = UIColor.white
//
//        navigationController?.setNavigationBarHidden(true, animated: true)
//        MultilingualUtility.shared.lingualForDevice(vc: self)
        
        delegate = AppDelegate.getSharedAppDelegateForSwift()
        loadUI()
        
        let nameGesture = UITapGestureRecognizer.init(target: self, action: #selector(profileAction))
        nameLbl.addGestureRecognizer(nameGesture)
        
        let imageGesture = UITapGestureRecognizer.init(target: self, action: #selector(profileAction))
        childImageVu.addGestureRecognizer(imageGesture)
    }
    
    func loadUI(){
        print(child_Id)
        let childID = Int(child_Id ?? "")
        let child_Data = DBManager.shared.fetchChild(byID: childID ?? 0)
        if let child_Data = child_Data{
            print(child_Data.relationship, child_Data.deviceOS)
            nameLbl.text                = child_Data.name ?? ""
            
            manufacturerValueLabel.text = child_Data.deviceManufacturer ?? ""
            deviceOSValueLabel.text = child_Data.deviceOS ?? ""
            languageValueLabel.text          = child_Data.deviceLanguage ?? ""
            timeZoneValueLabel.text       = child_Data.timeZone ?? ""
            batteryValueLabel.text       = child_Data.batteryRemaining ?? ""
            wifiValueLabel.text       = child_Data.wifiName ?? ""
            appVersionValueLbl.text     = child_Data.appVersion ?? ""
            buildValueLbl.text          = child_Data.appBuild ?? ""
            childImageVu.image = (child_Data.gender?.lowercased() == "male") ? #imageLiteral(resourceName: "avatar_boy1") : #imageLiteral(resourceName: "popup_avatar_girl")
            topView.backgroundColor = CommonModel.color(fromHexString: child_Data.color)
        }
        
        
        
        self.manufacturerNameLabel.text = "device_info_content_1_sub_content_2".localized
        self.deviceInfoLbl.text = "device_info_content_1".localized
        self.deviceOSNameLabel.text = "device_info_content_1_sub_content_4".localized//"WiFi".localized
        self.languageNameLabel.text = "device_info_content_1_sub_content_5".localized//"device_info_content_1_sub_content_3".localized
        self.timeZoneNameLabel.text = "device_info_content_1_sub_content_6".localized//"device_info_content_1_sub_content_4".localized
        self.batteryNameLabel.text = "device_info_content_1_sub_content_7".localized
        self.wifiNameLabel.text = "WiFi".localized
        self.appInfoLbl.text = "device_info_content_2".localized
        self.appVersionLbl.text = "device_info_content_2_sub_content_1".localized
        self.buildLbl.text = "device_info_content_2_sub_content_2".localized
        self.helpDeskLbl.text = "device_info_content_2_sub_content_3".localized
        let deviceInfo = self.device
                
        if self.device == "iphone" {
            
            deviceOsImage.image = UIImage(named: "purple_apple")
            appVersionImage.image = UIImage(named: "yellow_apple")
            
        } else {
            
            deviceOsImage.image = UIImage(named: "ic_os")
            appVersionImage.image = UIImage(named: "yellow_android")
            
        }
    }
    
    
    @objc func profileAction(){
        
        delegate?.isChildSelected        = 1
        
        //--DEPRICATED---//---CONVERTED TO SWIFT---//
        let vc = SwiftConstants.SwiftStoryBoard.instantiateViewController(withIdentifier: "ChildProfileVC") as! ChildProfileVC
        navigationController?.pushViewController(vc, animated: true)
    }

    //MARK: - UI ACTIONS
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func helpAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "MyStoryboard", bundle: Bundle.main)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "SwiftHelpViewController") as? SwiftHelpViewController else { return }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
}
