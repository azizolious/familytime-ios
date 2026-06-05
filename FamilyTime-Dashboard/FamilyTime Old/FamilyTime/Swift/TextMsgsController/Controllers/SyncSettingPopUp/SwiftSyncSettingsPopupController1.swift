//
//  SwiftSyncSettingsPopupController1.swift
//  FamilyTime
//
//  Created by YumyApps on 08/11/2021.
//  Copyright © 2021 YumyApps. All rights reserved.
//

import UIKit
import MBProgressHUD

class SwiftSyncSettingsPopupController1: UIViewController, UIAlertViewDelegate {
    
    var alertTitle = ""
    var firstParagraph = ""
    var imagename = ""
    var color = ""
    
    var imageView = UIImageView()
    var messageLabel = UILabel()
    var cancelButton = UIButton()
    var syncButton = UIButton()
    let child_Id = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
    
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
        } else if IS_IPHONE_8s() {
            view.frame = CGRect(x: 0.0, y: 0.0, width: 350.0, height: 500.0)
        } else {
            view.frame = CGRect(x: 0.0, y: 0.0, width: 370.0, height: 500.0)
        }
        
        view.backgroundColor = UIColor.white
        setupUI()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        imageView = setupImageView() ?? UIImageView()
        view.addSubview(imageView)
        cancelButton = setupLaterButton() ?? UIButton()
        cancelButton.addTarget(self, action: #selector(handleLater(_:)), for: .touchUpInside)
        view.addSubview(cancelButton)
        messageLabel = setupMessageLabel() ?? UILabel()
        view.addSubview(messageLabel)
    }
    
    @objc func handleLater(_ sender: Any?) {
        NotificationCenter.default.post(
            name: NSNotification.Name("GoBackNowStep2"),
            object: self)
        
        dismiss(animated: true)
        
        UserDefaults.standard.set("YES", forKey: "gobacknow")
        UserDefaults.standard.synchronize()
        navigationController?.popViewController(animated: true)
    }
    
    func handleCancel(_ sender: Any?) {
        dismiss(animated: true)
    }
    
    func handleSync(_ sender: Any?) {
        synSettings()
    }
    
    func synSettings() {
//        SwiftFTUtils.showHUDAdded(to: view, withText: "Loading...".myModification(), animated: true)
//        CoreManager.syncSettings(params: ["feature": "all"]) {
//            SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
//        }
        
        
//        
        SwiftFTUtils.showHUDAdded(to: view, withText: "Loading...".myModification(), animated: true)
        let delegate = AppDelegate()
        let url = String(format: "\(kSyncSettings)/\(Int(child_Id ?? "") ?? 0)")
        
        //--Api Calling--//
        ApiManager.shared().mesh_postApi(withParamString: "", withApi: url) { json, errorCode, message in
            DispatchQueue.main.async {
                print("syncSettingsPopup api response = \(json)")
                var updateSettings: UpdateSyncSettings? = nil
                do {
                    updateSettings = try UpdateSyncSettings(dictionary: json)
                } catch {
                    print("Error Parsing Json!")
                }
                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                if updateSettings?.status_code != 200 {
                    let alert = UIAlertView(title: "Error!".myModification(), message: (updateSettings?.response)!, delegate: self, cancelButtonTitle: "OK".myModification())
                    alert.show()
                } else {
                    let alert = UIAlertView(title: "Sync Settings".myModification() ?? "", message: (updateSettings?.response)!, delegate: self, cancelButtonTitle: "OK".myModification())
                    alert.show()
                    UserDefaults.standard.set("YES", forKey: "gobacknow")
                    UserDefaults.standard.synchronize()
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    func alertView(_ alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        dismiss(animated: true)
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
        } else if IS_IPHONE_8s() {
            imageView = UIImageView(frame: CGRect(x: view.bounds.midX - 96.0 / 2.0, y: 31.0, width: 96.0, height: 96.0))
        } else {
            imageView = UIImageView(frame: CGRect(x: view.bounds.midX - 116.0 / 2.0, y: 47.0, width: 116.0, height: 116.0))
        }
        imageView?.image = UIImage(named: imagename)
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
        } else if IS_IPHONE_8s() {
            button.frame = CGRect(x: 0.0, y: view.bounds.maxY - 52.0, width: view.bounds.width / 2.0, height: 52.0)
            button.titleLabel?.font = UIFont(name: "OpenSans", size: 15)
        } else {
            button.frame = CGRect(x: 0.0, y: view.bounds.maxY - 78.0, width: view.bounds.width / 2.0, height: 78.0)
            button.titleLabel?.font = UIFont(name: "OpenSans", size: 20)
        }
        
        button.setTitleColor(UIColor.darkText, for: .normal)
        button.backgroundColor = CommonModel.color(fromHexString: color)
        
        button.setTitle("Cancel", for: .normal)
        
        button.selectiveBorderFlag = UInt(AUISelectiveBordersFlagRight)
        button.selectiveBordersColor = UIColor.white
        button.selectiveBordersWidth = 1.0
        
        return button
    }
    
    func setupLaterButton() -> UIButton? {
        
        let button = UIButton(type: .custom)
        if IS_IPHONE_4() {
            button.frame = CGRect(x: 0.0, y: view.bounds.maxY - 40.0, width: view.bounds.width, height: 40.0)
            button.titleLabel?.font = UIFont(name: "OpenSans", size: 13)
        } else if IS_IPHONE_5() {
            button.frame = CGRect(x: 0.0, y: view.bounds.maxY - 40.0, width: view.bounds.width, height: 40.0)
            button.titleLabel?.font = UIFont(name: "OpenSans", size: 13)
        } else if IS_IPHONE_6() {
            button.frame = CGRect(x: 0.0, y: view.bounds.maxY - 46.0, width: view.bounds.width, height: 46.0)
            button.titleLabel?.font = UIFont(name: "OpenSans", size: 14)
        } else if IS_IPHONE_6_PLUS() {
            button.frame = CGRect(x: 0.0, y: view.bounds.maxY - 52.0, width: view.bounds.width, height: 52.0)
            button.titleLabel?.font = UIFont(name: "OpenSans", size: 15)
        } else if IS_IPHONE_X() {
            button.frame = CGRect(x: 0.0, y: view.bounds.maxY - 52.0, width: view.bounds.width, height: 52.0)
            button.titleLabel?.font = UIFont(name: "OpenSans", size: 15)
        } else if IS_IPHONE_8s() {
            button.frame = CGRect(x: 0.0, y: view.bounds.maxY - 52.0, width: view.bounds.width, height: 52.0)
            button.titleLabel?.font = UIFont(name: "OpenSans", size: 15)
        } else {
            button.frame = CGRect(x: 0.0, y: view.bounds.maxY - 78.0, width: view.bounds.width, height: 78.0)
            button.titleLabel?.font = UIFont(name: "OpenSans", size: 20)
        }
        button.setTitleColor(UIColor.darkText, for: .normal)
        button.backgroundColor = UIColor.groupTableViewBackground
        button.setTitle("OK".myModification(), for: .normal)
        
        return button
    }
    
    func setupSyncButton() -> UIButton? {
        
        let button = UIButton(type: .custom)
        if IS_IPHONE_4() {
            button.frame = CGRect(x: view.bounds.width / 2.0, y: view.bounds.maxY - 40.0, width: view.bounds.width / 2.0, height: 40.0)
            button.titleLabel?.font = UIFont(name: "OpenSans", size: 13)
        } else if IS_IPHONE_5() {
            button.frame = CGRect(x: view.bounds.width / 2.0, y: view.bounds.maxY - 40.0, width: view.bounds.width / 2.0, height: 40.0)
            button.titleLabel?.font = UIFont(name: "OpenSans", size: 13)
        } else if IS_IPHONE_6() {
            button.frame = CGRect(x: view.bounds.width / 2.0, y: view.bounds.maxY - 46.0, width: view.bounds.width / 2.0, height: 46.0)
            button.titleLabel?.font = UIFont(name: "OpenSans", size: 14)
        } else if IS_IPHONE_6_PLUS() {
            button.frame = CGRect(x: view.bounds.width / 2.0, y: view.bounds.maxY - 52.0, width: view.bounds.width / 2.0, height: 52.0)
            button.titleLabel?.font = UIFont(name: "OpenSans", size: 15)
        } else if IS_IPHONE_X() {
            button.frame = CGRect(x: view.bounds.width / 2.0, y: view.bounds.maxY - 52.0, width: view.bounds.width / 2.0, height: 52.0)
            button.titleLabel?.font = UIFont(name: "OpenSans", size: 15)
        } else if IS_IPHONE_8s() {
            button.frame = CGRect(x: view.bounds.width / 2.0, y: view.bounds.maxY - 52.0, width: view.bounds.width / 2.0, height: 52.0)
            button.titleLabel?.font = UIFont(name: "OpenSans", size: 15)
        } else {
            button.frame = CGRect(x: view.bounds.width / 2.0, y: view.bounds.maxY - 78.0, width: view.bounds.width / 2.0, height: 78.0)
            button.titleLabel?.font = UIFont(name: "OpenSans", size: 20)
        }
        
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = CommonModel.color(fromHexString: color)
        button.setTitle("Sync".myModification(), for: .normal)
        return button
    }
    
    func setupMessageLabel() -> UILabel? {
        
        var label: UILabel? = nil
        let finalMessage = NSMutableAttributedString()
        
        let titleMessage = NSMutableAttributedString(string: alertTitle)
        titleMessage.addAttribute(.foregroundColor, value: RGBCOLOR(96, 96, 96, 1), range: NSRange(location: 0, length: titleMessage.length))
        
        let paragraphStyleTitle = NSMutableParagraphStyle()
        paragraphStyleTitle.alignment = .center
        titleMessage.addAttribute(.paragraphStyle, value: paragraphStyleTitle, range: NSRange(location: 0, length: titleMessage.length))
        
        let firstParagraph = NSMutableAttributedString(string: self.firstParagraph)
        firstParagraph.addAttribute(.foregroundColor, value: RGBCOLOR(96, 96, 96, 1), range: NSRange(location: 0, length: firstParagraph.length))
        let paragraphStyleFirstParagraph = NSMutableParagraphStyle()
        paragraphStyleFirstParagraph.alignment = .left
        firstParagraph.addAttribute(.paragraphStyle, value: paragraphStyleFirstParagraph, range: NSRange(location: 0, length: firstParagraph.length))
        
        if IS_IPHONE_4() {
            label = UILabel(frame: CGRect(x: 18.0, y: (imageView.frame.maxY) + 15.0, width: view.bounds.width - 36.0, height: cancelButton.frame.minY - (imageView.frame.maxY) - 15.0))
            titleMessage.addAttribute(.font, value: UIFont(name: "OpenSans-Semibold", size: 20), range: NSRange(location: 0, length: titleMessage.length))
            firstParagraph.addAttribute(.font, value: UIFont(name: "OpenSans-Light", size: 12), range: NSRange(location: 0, length: firstParagraph.length))
            
        } else if IS_IPHONE_5() {
            label = UILabel(frame: CGRect(x: 18.0, y: (imageView.frame.maxY) + 15.0, width: view.bounds.width - 36.0, height: cancelButton.frame.minY - (imageView.frame.maxY) - 15.0))
            titleMessage.addAttribute(.font, value: UIFont(name: "OpenSans-Semibold", size: 20), range: NSRange(location: 0, length: titleMessage.length))
            firstParagraph.addAttribute(.font, value: UIFont(name: "OpenSans-Light", size: 12), range: NSRange(location: 0, length: firstParagraph.length))
            
        } else if IS_IPHONE_6() {
            label = UILabel(frame: CGRect(x: 25.0, y: (imageView.frame.maxY) + 15.0, width: view.bounds.width - 42.0, height: cancelButton.frame.minY - (imageView.frame.maxY) - 15.0))
            titleMessage.addAttribute(.font, value: UIFont(name: "OpenSans-Semibold", size: 22), range: NSRange(location: 0, length: titleMessage.length))
            firstParagraph.addAttribute(.font, value: UIFont(name: "OpenSans-Light", size: 13), range: NSRange(location: 0, length: firstParagraph.length))
            
        } else if IS_IPHONE_6_PLUS() {
            label = UILabel(frame: CGRect(x: 31.0, y: (imageView.frame.maxY) + 15.0, width: view.bounds.width - 62.0, height: cancelButton.frame.minY - (imageView.frame.maxY) - 15.0))
            titleMessage.addAttribute(.font, value: UIFont(name: "OpenSans-Semibold", size: 24), range: NSRange(location: 0, length: titleMessage.length))
            firstParagraph.addAttribute(.font, value: UIFont(name: "OpenSans-Light", size: 14), range: NSRange(location: 0, length: firstParagraph.length))
            
        } else if IS_IPHONE_X() {
            label = UILabel(frame: CGRect(x: 31.0, y: (imageView.frame.maxY) + 15.0, width: view.bounds.width - 62.0, height: cancelButton.frame.minY - (imageView.frame.maxY) - 15.0))
            titleMessage.addAttribute(.font, value: UIFont(name: "OpenSans-Semibold", size: 24), range: NSRange(location: 0, length: titleMessage.length))
            firstParagraph.addAttribute(.font, value: UIFont(name: "OpenSans-Light", size: 14), range: NSRange(location: 0, length: firstParagraph.length))
            
        } else if IS_IPHONE_8s() {
            label = UILabel(frame: CGRect(x: 31.0, y: (imageView.frame.maxY) + 15.0, width: view.bounds.width - 62.0, height: cancelButton.frame.minY - (imageView.frame.maxY) - 15.0))
            titleMessage.addAttribute(.font, value: UIFont(name: "OpenSans-Semibold", size: 24), range: NSRange(location: 0, length: titleMessage.length))
            firstParagraph.addAttribute(.font, value: UIFont(name: "OpenSans-Light", size: 14), range: NSRange(location: 0, length: firstParagraph.length))
            
        } else {
            label = UILabel(frame: CGRect(x: 47.0, y: (imageView.frame.maxY) + 34.0, width: view.bounds.width - 94.0, height: cancelButton.frame.minY - (imageView.frame.maxY) - 34.0))
            titleMessage.addAttribute(.font, value: UIFont(name: "OpenSans-Semibold", size: 36), range: NSRange(location: 0, length: titleMessage.length))
            firstParagraph.addAttribute(.font, value: UIFont(name: "OpenSans-Light", size: 19), range: NSRange(location: 0, length: firstParagraph.length))
            
        }
        
        finalMessage.append(titleMessage)
        finalMessage.append(firstParagraph)
        label?.numberOfLines = 0
        
        let rect = finalMessage.boundingRect(with: CGSize(width: label?.bounds.width ?? 0, height: 10000), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        label?.frame = CGRect(x: label?.frame.minX ?? 0, y: label?.frame.minY ?? 0, width: label?.frame.width ?? 0, height: rect.height)
        label?.attributedText = finalMessage
        //label.backgroundColor = [UIColor redColor];
        label?.textColor = RGBCOLOR(96, 96, 96, 1)
        
        return label
    }
}
