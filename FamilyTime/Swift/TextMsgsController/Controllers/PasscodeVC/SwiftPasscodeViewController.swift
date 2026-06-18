//
//  SwiftPasscodeViewController.swift
//  FamilyTime
//
//  Created by YumyApps on 08/11/2021.
//  Copyright © 2021 YumyApps. All rights reserved.
//

import UIKit

class SwiftPasscodeViewController: UIViewController,UITextFieldDelegate {
    
    //MARK: - VARIABLES
    var color = ""
    var imageView = UIImageView()
    var titleLabel = UILabel()
    var cancelButton = UIButton()
    var setButton = UIButton()
    var passcodeField = UITextField()
    
    let delegate = UIApplication.shared.delegate as? AppDelegate

    //MARK: - VIEW LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if IS_IPHONE_4() {
            view.frame = CGRect(x: 0.0, y: 0.0, width: 270.0, height: 420.0)
        } else if IS_IPHONE_5() {
            view.frame = CGRect(x: 0.0, y: 0.0, width: 270.0, height: 420.0)
        } else if IS_IPHONE_6() {
            view.frame = CGRect(x: 0.0, y: 0.0, width: 317.0, height: 450.0)
        } else if IS_IPHONE_6_PLUS() {
            view.frame = CGRect(x: 0.0, y: 0.0, width: 350.0, height: 500.0)
        } else if IS_IPHONE_X() {
            view.frame = CGRect(x: 0.0, y: 0.0, width: 350.0, height: 500.0)
        } else {
            view.frame = CGRect(x: 0.0, y: 0.0, width: 525.0, height: 715.0)
        }
        
        view.backgroundColor = UIColor.white
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        passcodeField.becomeFirstResponder()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleTap(_ gesture: UIGestureRecognizer?) {
        
        if gesture?.state == .ended {
            passcodeField.resignFirstResponder()
        }
    }
    
    func setupUI() {
        
        imageView = setupImageView() ?? UIImageView()
        view.addSubview(imageView)

        cancelButton = setupCancelButton() ?? UIButton()
        cancelButton.addTarget(self, action: #selector(handleCancel(_:)), for: .touchUpInside)
        view.addSubview(cancelButton)

        setButton = setupSetButton() ?? UIButton()
        setButton.addTarget(self, action: #selector(handleSet(_:)), for: .touchUpInside)
        view.addSubview(setButton)

        titleLabel = setupTitleLabel() ?? UILabel()
        view.addSubview(titleLabel)
    
        passcodeField = setupPasscodeField() ?? UITextField()
        view.addSubview(passcodeField)
    }
    
    @objc func handleCancel(_ sender: Any?) {
        dismiss(animated: true)
    }
    
    @objc func handleSet(_ sender: Any?) {
        
        if (passcodeField.text?.count ?? 0) < 4 || (passcodeField.text?.count ?? 0) > 6 {
            CommonModel.showAlert("", msg: "Please enter 4-6 digit Pin.".myModification())
        } else {
            let dict = [
                "name": "phonelock_pin",
                "status": NSNumber(value: 1),
                "value": passcodeField.text ?? ""
            ] as [String : Any]

            print("dict for phonlock = \(dict)")
            CommonModel.updatePreference(dict, view: self, isNotification: false)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func setupImageView() -> UIImageView? {
        
        var imageView: UIImageView?
        if IS_IPHONE_4() {
            imageView = UIImageView(frame: CGRect(x: view.bounds.midX - 72.0 / 2.0, y: 24.0, width: 72.0, height: 72.0))
        } else if IS_IPHONE_5() {
            imageView = UIImageView(frame: CGRect(x: view.bounds.midX - 72.0 / 2.0, y: 24.0, width: 72.0, height: 72.0))
        } else if IS_IPHONE_6() {
            imageView = UIImageView(frame: CGRect(x: view.bounds.midX - 96.0 / 2.0, y: 29.0, width: 96.0, height: 96.0))
        } else if IS_IPHONE_6_PLUS() {
            imageView = UIImageView(frame: CGRect(x: view.bounds.midX - 96.0 / 2.0, y: 31.0, width: 96.0, height: 96.0))
        } else if IS_IPHONE_X() {
            imageView = UIImageView(frame: CGRect(x: view.bounds.midX - 96.0 / 2.0, y: 31.0, width: 96.0, height: 96.0))
        } else {
            imageView = UIImageView(frame: CGRect(x: view.bounds.midX - 116.0 / 2.0, y: 47.0, width: 116.0, height: 116.0))
        }
        
        imageView?.image = SwiftFTUtils.isDeviceiPhoneFamily() ? UIImage(named: "popup_passcode") : UIImage(named: "popup_ipad_passcode")
        return imageView
    }
    
    func setupCancelButton() -> UIButton? {
        
        let button = UIButton(type: .custom)
        if IS_IPHONE_4() {
            button.frame = CGRect(x: 0.0, y: view.bounds.maxY - 40.0, width: view.bounds.width / 2.0, height: 40.0)
            button.titleLabel?.font = UIFont(name: "OpenSans", size: 13)
        } else if IS_IPHONE_5() {
            button.frame = CGRect(x: 0.0, y: view.bounds.maxY - 40.0, width: view.bounds.width / 2.0, height: 40.0)
            button.titleLabel?.font = UIFont(name: "OpenSans", size: 13)
        } else if IS_IPHONE_6() {
            button.frame = CGRect(x: 0.0, y: view.bounds.maxY - 46.0, width: view.bounds.width / 2.0, height: 46.0)
            button.titleLabel?.font = UIFont(name: "OpenSans", size: 14)
        } else if IS_IPHONE_6_PLUS() {
            button.frame = CGRect(x: 0.0, y: view.bounds.maxY - 52.0, width: view.bounds.width / 2.0, height: 52.0)
            button.titleLabel?.font = UIFont(name: "OpenSans", size: 15)
        } else if IS_IPHONE_X() {
            button.frame = CGRect(x: 0.0, y: view.bounds.maxY - 52.0, width: view.bounds.width / 2.0, height: 52.0)
            button.titleLabel?.font = UIFont(name: "OpenSans", size: 15)
        } else {
            button.frame = CGRect(x: 0.0, y: view.bounds.maxY - 78.0, width: view.bounds.width / 2.0, height: 78.0)
            button.titleLabel?.font = UIFont(name: "OpenSans", size: 20)
        }
        
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = CommonModel.color(fromHexString: color)
        button.setTitle("CANCEL".myModification(), for: .normal)

        button.selectiveBorderFlag = UInt(AUISelectiveBordersFlagRight)
        button.selectiveBordersColor = UIColor.white
        button.selectiveBordersWidth = 0.5
        return button
    }
    
    func setupSetButton() -> UIButton? {
        
        let button = UIButton(type: .custom)
        
        if IS_IPHONE_4() {
            button.frame = CGRect(x: view.bounds.midX, y: view.bounds.maxY - 40.0, width: view.bounds.width / 2.0, height: 40.0)
            button.titleLabel?.font = UIFont(name: "OpenSans", size: 13)
        } else if IS_IPHONE_5() {
            button.frame = CGRect(x: view.bounds.midX, y: view.bounds.maxY - 40.0, width: view.bounds.width / 2.0, height: 40.0)
            button.titleLabel?.font = UIFont(name: "OpenSans", size: 13)
        } else if IS_IPHONE_6() {
            button.frame = CGRect(x: view.bounds.midX, y: view.bounds.maxY - 46.0, width: view.bounds.width / 2.0, height: 46.0)
            button.titleLabel?.font = UIFont(name: "OpenSans", size: 14)
        } else if IS_IPHONE_6_PLUS() {
            button.frame = CGRect(x: view.bounds.midX, y: view.bounds.maxY - 52.0, width: view.bounds.width / 2.0, height: 52.0)
            button.titleLabel?.font = UIFont(name: "OpenSans", size: 15)
        } else if IS_IPHONE_X() {
            button.frame = CGRect(x: view.bounds.midX, y: view.bounds.maxY - 52.0, width: view.bounds.width / 2.0, height: 52.0)
            button.titleLabel?.font = UIFont(name: "OpenSans", size: 15)
        } else {
            button.frame = CGRect(x: view.bounds.midX, y: view.bounds.maxY - 78.0, width: view.bounds.width / 2.0, height: 78.0)
            button.titleLabel?.font = UIFont(name: "OpenSans", size: 20)
        }
        
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = CommonModel.color(fromHexString: color)
        button.setTitle("SET".myModification(), for: .normal)
        return button
    }
    
    func setupTitleLabel() -> UILabel? {
        var label: UILabel?
        if IS_IPHONE_4() {
            label = UILabel(frame: CGRect(x: 15.0, y: (imageView.frame.maxY) + 10, width: view.bounds.width - 30.0, height: 20.0))
            label?.font = UIFont(name: "OpenSans", size: 15)
        } else if IS_IPHONE_5() {
            label = UILabel(frame: CGRect(x: 15.0, y: (imageView.frame.maxY) + 10, width: view.bounds.width - 30.0, height: 20.0))
            label?.font = UIFont(name: "OpenSans", size: 15)
        } else if IS_IPHONE_6() {
            label = UILabel(frame: CGRect(x: 15.0, y: (imageView.frame.maxY) + 15, width: view.bounds.width - 30.0, height: 20.0))
            label?.font = UIFont(name: "OpenSans", size: 17)
        } else if IS_IPHONE_6_PLUS() {
            label = UILabel(frame: CGRect(x: 15.0, y: (imageView.frame.maxY) + 15, width: view.bounds.width - 30.0, height: 20.0))
            label?.font = UIFont(name: "OpenSans", size: 18)
        } else if IS_IPHONE_X() {
            label = UILabel(frame: CGRect(x: 15.0, y: (imageView.frame.maxY) + 15, width: view.bounds.width - 30.0, height: 20.0))
            label?.font = UIFont(name: "OpenSans", size: 18)
        } else {
            label = UILabel(frame: CGRect(x: 20.0, y: (imageView.frame.maxY) + 15, width: view.bounds.width - 40.0, height: 30.0))
            label?.font = UIFont(name: "OpenSans", size: 25)
        }
        label?.textAlignment = .center
        label?.textColor = UIColor.lightGray
        label?.text = "Set Device Passcode".localized
        label?.text = label?.text?.localized
        return label
    }
    
    func setupPasscodeField() -> UITextField? {
        
        var field = UITextField()
        if IS_IPHONE_4() {
            field = UITextField(frame: CGRect(x: 15.0, y: (titleLabel.frame.maxY) + 20.0, width: view.bounds.width - 30, height: 37))
            field.font = UIFont.systemFont(ofSize: 15)
        } else if IS_IPHONE_5() {
            field = UITextField(frame: CGRect(x: 15.0, y: (titleLabel.frame.maxY) + 25.0, width: view.bounds.width - 30, height: 37))
            field.font = UIFont.systemFont(ofSize: 15)
        } else if IS_IPHONE_6() {
            field = UITextField(frame: CGRect(x: 15.0, y: (titleLabel.frame.maxY) + 30.0, width: view.bounds.width - 30, height: 43))
            field.font = UIFont.systemFont(ofSize: 16)
        } else if IS_IPHONE_6_PLUS() {
            field = UITextField(frame: CGRect(x: 15.0, y: (titleLabel.frame.maxY) + 35.0, width: view.bounds.width - 30, height: 47))
            field.font = UIFont.systemFont(ofSize: 17)
        } else if IS_IPHONE_X() {
            field = UITextField(frame: CGRect(x: 15.0, y: (titleLabel.frame.maxY) + 35.0, width: view.bounds.width - 30, height: 47))
            field.font = UIFont.systemFont(ofSize: 17)
        } else {
            field = UITextField(frame: CGRect(x: 20.0, y: (titleLabel.frame.maxY) + 55.0, width: view.bounds.width - 40, height: 68))
            field.font = UIFont.systemFont(ofSize: 19)
        }
        
        field.backgroundColor = UIColor.clear
        field.textColor = UIColor.darkGray
        field.textAlignment = .center
        field.placeholder = "\("Device".localized) "
        field.tintColor = UIColor.darkGray
        field.delegate = self
        field.keyboardType = .numberPad
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.layer.borderWidth = 0.5
        field.isSecureTextEntry = true
        let preference = SwiftCommonUtility.shared.getPreferencesWithName("phonelock_pin")
        //delegate?.selectedDashboardChild.getPreferencesWithName("phonelock_pin")
        if let preference = preference {
            field.text = "\(String(describing: preference.value))"
        }
        return field
    }    
}
