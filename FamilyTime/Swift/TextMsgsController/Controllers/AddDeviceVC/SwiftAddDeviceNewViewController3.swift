//
//  SwiftAddDeviceNewViewController3.swift
//  FamilyTime
//
//  Created by YumyApps on 26/10/2021.
//  Copyright © 2021 YumyApps. All rights reserved.
//

import UIKit

class SwiftAddDeviceNewViewController3: UIViewController {
        
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnHwtoAct: UIButton!
    @IBOutlet weak var btnYesIdo: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var step1Label: UILabel!
    
    @IBOutlet weak var step2Label: UILabel!
    
    @IBOutlet weak var step3Label: UILabel!
    
    @IBOutlet weak var step4Label: UILabel!
    
    @IBOutlet weak var step5Label: UILabel!
        
    var checkPopup = -1
    var urlString = ""
    var strName = ""
    var newUser = false
        
    let delegate = UIApplication.shared.delegate as? AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (UI_USER_INTERFACE_IDIOM() == .pad){
          self.btnHwtoAct.layer.cornerRadius = 30
            self.btnYesIdo.layer.cornerRadius = 30
        }
        else{
          self.btnHwtoAct.layer.cornerRadius = 21
            self.btnYesIdo.layer.cornerRadius = 21
        }
        
        lblTitle.text = "step_2_title".localized

        btnHwtoAct.setTitle("step_2_details_button".localized, for: .normal)
        btnYesIdo.setTitle("step_2_done_button".localized, for: .normal)
        
        lblTitle.text = lblTitle.text?.localized
        
        if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
            
            self.backButton.transform = self.backButton.transform.rotated(by: CGFloat(Double.pi / 1))
            
        }

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(goBack(_:)),
            name: NSNotification.Name("GoBackNowStep2"),
            object: nil)
        
        let strRealID: String? = nil
        //    NSString *str= [[NSUserDefaults standardUserDefaults]objectForKey:@"CurrentUserID"];
        print("Oee")
        //    NSLog(@"%@",str);
        print("Oee")
        
        // Do any additional setup after loading the view.
        btnHwtoAct.isHidden = false
        checkPopup = 1
        //    self.navigationController.navigationBarHidden=NO;
        print("\("real time data")")

        addAttributedTextToTextView()
        
        btnYesIdo.isHidden = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if checkPopup == 2 {
            navigationController?.popViewController(animated: true)
        }
    }
    
    func addAttributedTextToTextView() {


        var normalTextSize: CGFloat = 15.0
        var boldTextSize: CGFloat = 15.0
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            normalTextSize = 22.0
            boldTextSize = 22.0
        }
        var point1 = "step_2_ios_bullet_1".localized
        
        if urlString == "iOS"{
            
            point1 = "step_2_ios_bullet_1".localized
            
        }else{
            
            point1 = "step_2_android_bullet_1".localized
        }
        let point2 = "step_2_bullet_2".localized
        let point3 = "step_2_bullet_3".localized
        let point4 = "step_2_bullet_4".localized
        let point5 = "step_2_bullet_5".localized
        
        let p_1_2 = point1.attributedString(["get.familytime.io"], color: UIColor.FTOrange, font: UIFont.appFont(type: UIFont.FontType.SemiBold, size: boldTextSize))
        step1Label.attributedText = p_1_2

        let p_2_2 = point2.attributedString(["FamilyTime Jr."], color: UIColor.black, font: UIFont.appFont(type: UIFont.FontType.SemiBold, size: boldTextSize))
        step2Label.attributedText = p_2_2
        
        step3Label.text = point3
        step4Label.text = point4
        step5Label.text = point5
        
    }
    
    @IBAction func yesIdoneIt(_ sender: Any) {
        
        if !(UIApplication.shared.keyWindow?.rootViewController is JASidePanelController) {

            delegate?.setupDrawer(0)
        } else {

            dissmisshere()
        }
        
    }
    
    func dissmisshere() {
        NotificationCenter.default.post(
            name: NSNotification.Name("RemoveStepsPrevious"),
            object: self)
        NotificationCenter.default.post(name: NSNotification.Name("RELOAD_DASHBOARD"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name("fromChildStepsScreen"), object: nil)
        
        if presentingViewController != nil {
            dismiss(animated: true)
            
        } else {
            navigationController?.popToRootViewController(animated: true)
        }
        
    }
    
    @IBAction func howtoActivate(_ sender: Any) {

        btnHwtoAct.isHidden = true
        btnYesIdo.isHidden = false
        
        self.handleHowToInstall()
    }
    
    func handleHowToInstall() {

        //userlanguage
        let prefs = UserDefaults.standard
        // getting an NSString
        let userlanguage = prefs.string(forKey: "userlanguage") ?? ""

        var myString: String? = nil
        
        if urlString == "iOS" {
            if userlanguage == "en" {

                myString = "https://familytime.io/how-to-install/child-app-on-ios.html?utm_source=dashboard&amp;utm_medium=android&amp;utm_campaign=ActivateChild"
                
            } else {
                
                myString = "https://familytime.io/\(userlanguage)/how-to-install/child-app-on-ios.html?utm_source=dashboard&amp;utm_medium=android&amp;utm_campaign=ActivateChild"
                
            }
            
            self.open(scheme: myString ?? "")
            
        } else if urlString == "Android" {
            
            if userlanguage == "en" {

                myString = "https://familytime.io/how-to-install/child-app-on-android.html?utm_source=dashboard&amp;utm_medium=android&amp;utm_campaign=ActivateChild"
                
            } else {
                
                myString = "https://familytime.io/\(userlanguage)/how-to-install/child-app-on-android.html?utm_source=dashboard&amp;utm_medium=android&amp;utm_campaign=ActivateChild"
                
            }
            
            self.open(scheme: myString ?? "")
            
        } else {
            
            if userlanguage == "en" {

                myString = "https://familytime.io/how-to-install/child-app-on-ios.html?utm_source=dashboard&amp;utm_medium=android&amp;utm_campaign=ActivateChild"
            } else {

                myString = "https://familytime.io/\(userlanguage)/how-to-install/child-app-on-ios.html?utm_source=dashboard&amp;utm_medium=android&amp;utm_campaign=ActivateChild"
            }
            
            self.open(scheme: myString ?? "")
            
        }
        
    }
    
    func open(scheme: String) {
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
    
    @IBAction func btnBack(_ sender: Any) {


        navigationController?.popViewController(animated: true)

    }
    
    @objc func goBack(_ notification: Notification?) {

        navigationController?.popViewController(animated: true)

        //    [self dismissViewControllerAnimated:YES completion:^{
        //        [[NSNotificationCenter defaultCenter] postNotificationName:@"RELOAD_DASHBOARD" object:nil];
        //    }];


    }

}
