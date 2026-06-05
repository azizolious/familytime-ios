//
//  DetailedInstructionsScreenController.swift
//  FamilyTime
//
//  Created by YumyApps on 29/03/2022.
//  Copyright © 2022 YumyApps. All rights reserved.
//

import UIKit

class DetailedInstructionsScreenController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var kidDeviceLabel: UILabel!
    @IBOutlet weak var openLabel: UILabel!
    @IBOutlet weak var downlaodLabel: UILabel!
    @IBOutlet weak var step3_label: UILabel!
    @IBOutlet weak var step4_label: UILabel!
    @IBOutlet weak var step5_label: UILabel!
    @IBOutlet weak var backButtonOutlet: UIButton!
    
    @IBOutlet weak var viewDetailsButtonOutlet: UIButton! {
        didSet {
            viewDetailsButtonOutlet.layer.cornerRadius = 9.0
            viewDetailsButtonOutlet.layer.masksToBounds = true
        }
    }
    
    
    //MARK: - Variables
    private var screenType:String?
    private var childType:String?
    
    //MARK: - View LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        UserDefaults.standard.setValue(self.viewDetailsButtonOutlet.titleLabel?.text, forKey: "refresh_loader")
        UserDefaults.standard.synchronize()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       // navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    //MARK: - IBActions
    @IBAction func viewDetailsButtonPressed(_ sender: Any) {
        if viewDetailsButtonOutlet.titleLabel?.text == "step_2_done_button".localized {
            goToTheDashboardScreen()
        } else {
            handleHowToInstall()
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: "LOAD_DASHBOARD_FROM_DETAILED_SCREEN")
        UserDefaults.standard.synchronize()
        self.popBackController()
    }
    
    //MARK: - Helper Functions
    private func setUpView() {
        self.viewDetailsButtonOutlet.setTitle("step_2_details_button".localized, for: .normal)
        self.kidDeviceLabel.text = "step_2_title".localized
        self.step3_label.text = "step_2_bullet_3".localized
        self.step4_label.text = "step_2_bullet_4".localized
        self.step5_label.text = "step_2_bullet_5".localized
        
        let point1 = "step_2_ios_bullet_1".localized
        let point2 = "step_2_bullet_2".localized
        
        let p_1_2 = point1.attributedString(["get.familytime.io"], color: UIColor.init(hexString: "#20A0E9"), font: UIFont.appFont(type: UIFont.FontType.SemiBold, size: 14.0))
        self.openLabel.attributedText = p_1_2
        print(p_1_2)
        
        let p_2_2 = point2.attributedString(["FamilyTime Jr."], color: UIColor.black, font: UIFont.appFont(type: UIFont.FontType.SemiBold, size: 14.0))
        self.downlaodLabel.attributedText = p_2_2
        
        let currentLanguage = Locale.preferredLanguages[0]
        if currentLanguage == "ar" || currentLanguage == "he" {
            backButtonOutlet.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        }
    }
    
    private func popBackController() {
        if #available(iOS 13.0, *) {
            self.navigationController?.popViewController(animated: true)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func goToTheDashboardScreen() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    private func handleHowToInstall() {
        //userlanguage
        let prefs = UserDefaults.standard
        // getting an NSString
        let userlanguage = prefs.string(forKey: "userlanguage") ?? ""
        var myString: String? = nil
        if userlanguage == "en" || userlanguage == "he" || userlanguage == "tr" {
            myString = "https://familytime.io/how-to-install/familytime-child-app.html?utm_source=dashboard&amp;utm_medium=ios&amp;utm_campaign=ActivateChild"
            
        } else {
            myString = "https://familytime.io/\(userlanguage)/how-to-install/familytime-child-app.html?utm_source=dashboard&amp;utm_medium=ios&amp;utm_campaign=ActivateChild"
        }
        
        self.open(scheme: myString ?? "")
        self.viewDetailsButtonOutlet.setTitle("step_2_done_button".localized, for: .normal)
        UserDefaults.standard.setValue("step_2_done_button".localized, forKey: "refresh_loader")
        UserDefaults.standard.synchronize()
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
}
