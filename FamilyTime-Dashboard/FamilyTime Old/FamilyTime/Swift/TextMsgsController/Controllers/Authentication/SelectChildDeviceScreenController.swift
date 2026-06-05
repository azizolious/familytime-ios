//
//  SelectChildDeviceScreenController.swift
//  FamilyTime
//
//  Created by YumyApps on 25/03/2022.
//  Copyright © 2022 YumyApps. All rights reserved.
//

import UIKit
import IQKeyboardManager
import Toast_Swift

protocol SelectedChildScreenDelegate {
    func setchildType(chlid:String)
    func SetScreenType(isComingFrom: String)
}

protocol WelcomeScreenDelegates {
    func setScreenType(isComingFrom:String)
}

class SelectChildDeviceScreenController: UIViewController, IQDropDownTextFieldDelegate {
    
    //MARK: - IBOutlets
    @IBOutlet weak var selectChildLabel: UILabel!
    @IBOutlet weak var deviceKindLabel: UILabel!
    @IBOutlet weak var nextButtonOutlet: UIButton! {
        didSet {
            nextButtonOutlet.layer.cornerRadius = 9.0
            nextButtonOutlet.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var dropdownImage: UIImageView! {
        didSet {
            let tappGesture = UITapGestureRecognizer(target: self, action: #selector(dropdownClicked))
            dropdownImage.addGestureRecognizer(tappGesture)
            dropdownImage.isUserInteractionEnabled = true
        }
    }
    @IBOutlet weak var dropMenuTextField: UITextField! {
        didSet {
            
            let tappGesture = UITapGestureRecognizer(target: self, action: #selector(dropdownClicked))
            dropMenuTextField.addGestureRecognizer(tappGesture)
            dropMenuTextField.isUserInteractionEnabled = true
            dropMenuTextField.placeholder = "select_device_title".localized
        }
    }
    
    //MARK: - Variables
    private var screenType:String?
    
    //MARK: - View LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       // navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    //MARK: - IBActions
    @IBAction func nextButtonPressed(_ sender: Any) {
        var style = ToastStyle()
        style.messageColor = .white
        ToastManager.shared.style = style
        if dropMenuTextField.text?.isEmpty == true {
            self.view.makeToast("select_one_device_title".localized, duration: 3.0, position: .bottom, title: nil, image: nil, style: style, completion: nil)
        } else {
            self.goToTheNextScreen()
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.popBackController()
    }
    
    //MARK: - Helper Functions
    @objc private func dropdownClicked() {
        setUpDropDownMenu()
    }
    private func setUpDropDownMenu() {
        //// changing the Drop down text alignment while having left language notations i-e Arabic language.
        if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
            self.dropMenuTextField.textAlignment = .right
        }
        let actionSheet = UIAlertController(title: "select_device_title".localized, message: nil, preferredStyle: .actionSheet)
        let actionAndroid = UIAlertAction(title: "step_1_option_1".localized, style: .default) { action in
            self.dropMenuTextField.text = "step_1_option_1".localized
        }
        
        let actionIOS = UIAlertAction(title: "step_1_option_2".localized, style: .default) { action in
            self.dropMenuTextField.text = "step_1_option_2".localized
        }
        actionSheet.addAction(actionAndroid)
        actionSheet.addAction(actionIOS)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    private func goToTheNextScreen() {
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
    
    func popBackController() {
         if #available(iOS 13.0, *) {
             self.navigationController?.popViewController(animated: true)
         }else{
            self.navigationController?.popViewController(animated: true)
         }
     }
    
    private func setUpView() {
       self.selectChildLabel.text = "select_child_label_title".localized
       self.deviceKindLabel.text = "device_kind_label_title".localized
       self.nextButtonOutlet.setTitle("next_label_title".localized, for: .normal)
    }
}

//MARK: - Welcome Screen Delegates 
extension SelectChildDeviceScreenController : WelcomeScreenDelegates {
    func setScreenType(isComingFrom: String) {
        self.screenType = isComingFrom
    }
}
