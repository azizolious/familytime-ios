//
//  QRScanViewController.swift
//  FamilyTime
//
//  Created by Rao Mudassar Khalil on 22/09/2021.
//  Copyright © 2021 YumyApps. All rights reserved.
//

import UIKit

class QRScanViewController: UIViewController {
    
    @IBOutlet weak var qrImage: UIImageView!
        
    @IBOutlet weak var viewGuideButton: UIButton!
    
    var isBackButton = false

    var urlStr:String = "iOS"
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var subtitleLabel: UILabel!
    
    @IBOutlet weak var step1Label: UILabel!
    
    
    @IBOutlet weak var step1ContentLabel: UILabel!
    
    @IBOutlet weak var step2Label: UILabel!
    
    @IBOutlet weak var step2ContentLabel: UILabel!
    
    @IBOutlet weak var step3Label: UILabel!
    
    
    @IBOutlet weak var step3ContentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "qrscreen_title_content".localized
        subtitleLabel.text = "qrscreen_subtitle_content".localized
        
        step1Label.text = "qrscreen_step1_title".localized
        step1ContentLabel.text = "qrscreen_step1_subcontent".localized
        
        step2Label.text = "qrscreen_step2_title".localized
        step2ContentLabel.text = "qrscreen_step2_subcontent".localized
        
        step3Label.text = "qrscreen_step3_title".localized
        step3ContentLabel.text = "qrscreen_step3_subcontent".localized
        viewGuideButton.tag = 0
        viewGuideButton.setTitle("qrscreen_button".localized, for: .normal)
        
        let user_id = UserDefaults.standard.value(forKey: "userID")
        let email = UserDefaults.standard.value(forKey: "userEmail")
        let qrString = "user-\(user_id ?? "")-\(email ?? "")"
        let base = qrString.data(using: .utf8)?.base64EncodedString()
        let images = generateQRCode(from: base!)
        self.qrImage.image = images
        
        if isBackButton {
            self.backButton.isHidden = false
        } else {
            self.backButton.isHidden = true
        }
    }
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.utf8)
        print(data)
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.isNavigationBarHidden = true
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
            self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func viewGuideButtonAction(_ sender: Any) {

        if viewGuideButton.tag == 0 {
            viewGuideButton.setTitle("step_2_done_button".localized, for: .normal)
            viewGuideButton.tag = 1
            self.handleHowToInstall()
        } else {
            if !(UIApplication.shared.keyWindow?.rootViewController is JASidePanelController) {
                delegate?.setupDrawer(0)
            } else {
                dissmisshere()
            }
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
    
    func handleHowToInstall() {
        
        //userlanguage
        let prefs = UserDefaults.standard
        // getting an NSString
        let userlanguage = prefs.string(forKey: "userlanguage") ?? ""
        var myString: String? = nil
        
        if urlStr == "iOS" {
            if userlanguage == "en" {
                myString = "https://familytime.io/how-to-install/child-app-on-ios.html?utm_source=dashboard&amp;utm_medium=android&amp;utm_campaign=ActivateChild"
            } else {
                myString = "https://familytime.io/\(userlanguage)/how-to-install/child-app-on-ios.html?utm_source=dashboard&amp;utm_medium=android&amp;utm_campaign=ActivateChild"
            }
            
            self.open(scheme: myString ?? "")
            
        } else if urlStr == "Android" {
            
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
    
}

