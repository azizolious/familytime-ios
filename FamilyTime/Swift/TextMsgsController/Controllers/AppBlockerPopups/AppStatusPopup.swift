//
//  AppStatusPopup.swift
//  FamilyTime
//
//  Created by Rizwan-Apps on 12/01/2023.
//  Copyright © 2023 YumyApps. All rights reserved.
//

import UIKit

class AppStatusPopup: UIViewController {

    //MARK: - OUTLETS
    @IBOutlet weak var mainImgView: UIImageView!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var instructionLbl: UILabel!
    
    //MARK: - VARRIABLES
    let child_Id = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
    var app_name: String?
    var app_package: String?
    var status = false
    
    //MARK: - VIEW LYFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        closeBtn.layer.cornerRadius = 10.0
    }

    //MARK: - ACTIONS
    @IBAction func closeBtn(_ sender: Any) {
        presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
    }
    //MARK: - API CALL
    func loadData(){
        SwiftFTUtils.showHUDAdded(to: view, withText: "Loading...", animated: true)
        let endURlStr =  "\(child_Id ?? "")/approve-app"
        if status == true{
            HLApiManager.networkAppStatus(urlEnd: endURlStr, approve: true, appName: app_name ?? "", appPkg: app_package ?? "") { response, error in
                print(error ?? "", response ?? 0)
                if error == ""{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                        SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
                    }
                    let attributedWithTextColor: NSAttributedString = "Congratulations! The \(self.app_name ?? "") App has been approved by your Parents or Guardian.".attributedStringWithColor(["Congratulations!"], color: UIColor.black)
                    self.mainImgView.image = UIImage(named: "Approved")
                    self.titleLbl.text = "App Approved!"
                    self.instructionLbl.attributedText = attributedWithTextColor
                    self.closeBtn.layer.backgroundColor = UIColor.systemGreen.cgColor
                }else{
                    SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
                    CommonModel.showAlert("alert_title".localized, msg: "alert_something_wrong")
                }
            }
        }else{
            HLApiManager.networkAppStatus(urlEnd: endURlStr, approve: false, appName: "", appPkg: "") { response, error in
                print(response, error)
                if error == ""{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                        SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
                    }
                    let attributedWithTextColor: NSAttributedString = "Sorry! Your Parents or Guardian has not approved the \(self.app_name ?? "")” App.".attributedStringWithColor(["Sorry!"], color: UIColor.systemPink)
                    self.mainImgView.image = UIImage(named: "Not Approved")
                    self.titleLbl.text = "App not Approved!"
                    self.instructionLbl.attributedText = attributedWithTextColor
                    self.closeBtn.layer.backgroundColor = UIColor.systemPink.cgColor
                }else{
                    SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
                    CommonModel.showAlert("alert_title".localized, msg: "alert_something_wrong")
                }
            }
        }
    }
}
