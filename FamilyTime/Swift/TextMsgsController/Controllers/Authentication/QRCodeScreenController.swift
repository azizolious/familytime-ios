//
//  QRCodeScreenController.swift
//  FamilyTime
//
//  Created by YumyApps on 25/03/2022.
//  Copyright © 2022 YumyApps. All rights reserved.
//

import UIKit

class QRCodeScreenController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var qrCodeBackgroundImageView: UIImageView!
    @IBOutlet weak var qrCodeImageView: UIImageView!
    
    @IBOutlet weak var connectChildLabel: UILabel!
    @IBOutlet weak var scanQRCodeLabel: UILabel!
    
    @IBOutlet weak var step1_Label: UILabel!
    @IBOutlet weak var openLabel: UILabel!
    
    @IBOutlet weak var step2_label: UILabel!
    @IBOutlet weak var familyTimeJrLabel: UILabel!
    
    @IBOutlet weak var step3_label: UILabel!
    @IBOutlet weak var instructionsLabel: UILabel!
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var viewDetailsButtonOutlet: UIButton! {
        didSet {
            viewDetailsButtonOutlet.layer.cornerRadius = 9.0
            viewDetailsButtonOutlet.layer.masksToBounds = true
        }
    }
    
    //MARK: - Variables
    private var chlidType : String?
    private var screenType : String?
    
    //MARK: - View LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        getQRCodeString()
        UserDefaults.standard.setValue(self.viewDetailsButtonOutlet.titleLabel?.text, forKey: "refresh_loader")
        UserDefaults.standard.synchronize()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
        self.popBackController()
    }
    
    //MARK: - Helper Functions
    private func setUpView() {
        self.viewDetailsButtonOutlet.setTitle("view_detailed_guide_title".localized, for: .normal)
        self.connectChildLabel.text = "connect_chlid_title".localized
        self.scanQRCodeLabel.text = "scan_QR_title".localized
        self.step1_Label.text = "step1_title".localized
        self.openLabel.text = "open_title".localized
        
        self.step2_label.text = "step2_title".localized
        self.familyTimeJrLabel.text = "familyTimeJr_step2".localized
        self.step3_label.text = "qrscreen_step3_title".localized
        self.instructionsLabel.text = "instructions_title".localized
        
        let requiredText = "familyTime_step1_title".localized
        let changedAttributedText = requiredText.attributedString(["get.familytime.io"], color: UIColor.init(hexString: "#20A0E9"), font: UIFont.appFont(type: UIFont.FontType.SemiBold, size: 14.0))
        self.openLabel.attributedText = changedAttributedText
    }
    
    private func popBackController() {
        if #available(iOS 13.0, *) {
            self.navigationController?.popViewController(animated: true)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func getQRCodeString() {
        self.activityIndicatorView.isHidden = false
        self.activityIndicatorView.startAnimating()
        HLApiManager.generateQRCodeNetworkCallCore2 { response, error in
            if response != nil {
                // Getting the QR Code here...
                let images = self.generateQRCode(from: response ?? "")
                self.qrCodeImageView.image = images
                self.activityIndicatorView.stopAnimating()
                self.activityIndicatorView.isHidden = true
            } else {
                print("QR Code String is not found because of error ", error ?? "")
            }
        }
    }
    
    private func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.utf8)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
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
    
    private func goToTheDashboardScreen() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
