//
//  ApprovedAppPopupVc.swift
//  FamilyTime
//
//  Created by Rizwan-Apps on 12/01/2023.
//  Copyright © 2023 YumyApps. All rights reserved.
//

import UIKit

class ApprovedAppPopupVc: UIViewController {
    
    //MARK: - OUTLETS
    @IBOutlet weak var mainImgView: UIImageView!
    @IBOutlet weak var approveBtn: UIButton!
    @IBOutlet weak var rejectBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var intsructionLbl: UILabel!
    
    //MARK: - Variables
    @objc var appName:String?
    @objc var appPackage:String?
    @objc var titleText:String?
    @objc var body:String?
    
    //MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        let name = UserDefaults.standard.string(forKey: "app_name") ?? ""
        let desc = UserDefaults.standard.string(forKey: "app_body") ?? ""
        titleLbl.text = name
        intsructionLbl.text = desc
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        approveBtn.layer.cornerRadius = 10.0
        approveBtn.layer.borderWidth = 0.5
        rejectBtn.layer.cornerRadius = 10.0
        rejectBtn.layer.borderColor = UIColor.systemPink.cgColor
        rejectBtn.layer.borderWidth = 0.5
    }
    
    //MARK: - BUTTON ACTIONS
    @IBAction func approveBtn(_ sender: Any) {
        loadData(approvaStatus: true)
    }
    @IBAction func rejectBtn(_ sender: Any) {
        loadData(approvaStatus: false)
    }
    
    //MARK: - LOAD NOTIFICATION DATA
    func loadData(approvaStatus: Bool){
        SwiftFTUtils.showHUDAdded(to: view, withText: "Loading...", animated: true)
        let child_Id = UserDefaults.standard.string(forKey: "approve_app_id") ?? ""
        let pkg = UserDefaults.standard.string(forKey: "app_package") ?? ""
        let name = UserDefaults.standard.string(forKey: "app_name") ?? ""
        let endURlStr =  "\(child_Id)/approve-app"
        HLApiManager.networkAppStatus(urlEnd: endURlStr, approve: approvaStatus, appName: name , appPkg: pkg) { response, error in
            if error == "" {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                    SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
                    UserDefaults.standard.removeObject(forKey: UserDefaultsConstants.APPROVED_APP_TITLE)
                    UserDefaults.standard.removeObject(forKey: UserDefaultsConstants.APPROVED_APP_BODY)
                    UserDefaults.standard.removeObject(forKey: UserDefaultsConstants.APPROVE_APP_NAME)
                    UserDefaults.standard.removeObject(forKey: UserDefaultsConstants.APPROVE_APP_PACKAGE_NAME)
                    UserDefaults.standard.set(false, forKey: UserDefaultsConstants.APPROVE_APP_NOTIFICAION)
                    UserDefaults.standard.synchronize()
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
                UserDefaults.standard.removeObject(forKey: UserDefaultsConstants.APPROVED_APP_TITLE)
                UserDefaults.standard.removeObject(forKey: UserDefaultsConstants.APPROVED_APP_BODY)
                UserDefaults.standard.removeObject(forKey: UserDefaultsConstants.APPROVE_APP_NAME)
                UserDefaults.standard.removeObject(forKey: UserDefaultsConstants.APPROVE_APP_PACKAGE_NAME)
                UserDefaults.standard.set(false, forKey: UserDefaultsConstants.APPROVE_APP_NOTIFICAION)
                UserDefaults.standard.synchronize()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
