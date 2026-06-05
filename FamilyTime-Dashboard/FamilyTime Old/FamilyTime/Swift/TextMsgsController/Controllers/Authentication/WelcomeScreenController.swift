//
//  WelcomeScreenController.swift
//  FamilyTime
//
//  Created by YumyApps on 25/03/2022.
//  Copyright © 2022 YumyApps. All rights reserved.
//

import UIKit

protocol LoginScreenDelegates {
    func setScreenType(isComingFrom:String)
}

class WelcomeScreenController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var supportLabel: UILabel!
    
    
    @IBOutlet weak var linkDeviceButtonOutlet: UIButton! {
        didSet {
            linkDeviceButtonOutlet.layer.cornerRadius = 9.0
            linkDeviceButtonOutlet.layer.masksToBounds = true 
        }
    }
    
    
    //MARK: - Variables
    private var screenType : String?
    
    //MARK: - View LifeCyles
    override func viewDidLoad() {
        super.viewDidLoad()
          
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    //MARK: - IBActions
    @IBAction func linkDeviceButtonPressed(_ sender: Any) {
        self.goToAddChildScreen()
    }
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.popBackController()
    }
    
    //MARK: -  Helper Functions
    private func goToAddChildScreen() {
        if UserDefaultsManager.AddChildWithQRScan == true {
            //Jump to QRCode Screen
            let storyboard = UIStoryboard(name: StoryboardConstants.Storyboards.AUTH, bundle: Bundle.main)
            let vc = storyboard.instantiateViewController(withIdentifier: StoryboardConstants.Identifiers.QR_CODE_VC_IDENTIFIER) as! QRCodeScreenController
            vc.navigationController?.isNavigationBarHidden = true
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else {
            // Jump to Detailed Instructions Screen
            let storyboard = UIStoryboard(name: StoryboardConstants.Storyboards.AUTH, bundle: Bundle.main)
            let vc = storyboard.instantiateViewController(withIdentifier: StoryboardConstants.Identifiers.DETAILED_INSTRUCTIONS_VC_IDENTIFIER) as! DetailedInstructionsScreenController
            vc.navigationController?.isNavigationBarHidden = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func popBackController() {
        if #available(iOS 13.0, *) {
            self.navigationController?.popViewController(animated: true)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    private func setUpView() {
        self.welcomeLabel.text = "welcome_label_title".localized
        self.supportLabel.text = "we_support_label_title".localized
        self.linkDeviceButtonOutlet.setTitle("link_child_label_title".localized, for: .normal)
    }
}

//MARK: - LoginScreen Delegates
extension WelcomeScreenController : LoginScreenDelegates {
    func setScreenType(isComingFrom: String) {
        self.screenType = isComingFrom
    }
}
