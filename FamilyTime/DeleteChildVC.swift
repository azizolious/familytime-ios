//
//  DeleteChildVC.swift
//  FamilyTime
//
//  Created by Sufyan on 16/10/2023.
//  Copyright © 2023 YumyApps. All rights reserved.
//

import UIKit

class DeleteChildVC: UIViewController {
    
    @IBOutlet weak var mainVu: UIView!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var deleteChildLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var bottomConstant: NSLayoutConstraint!
    @IBOutlet weak var cancelBtn: UIButton!
    
    var deleteLimit = false
    var deleteLimitCallback: ()->() = {}
    var childDeleted: ()->() = {}
    var limitApps = [InstalledApp]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cancelBtn.setTitle("cancel_button".localized, for: .normal)
        deleteBtn.setTitle("delete".localized, for: .normal)
        if deleteLimit {
            self.deleteChildLbl.isHidden = true
            self.deleteBtn.setTitle("remove_button".localized, for: .normal)
            descLbl.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            descLbl.font = UIFont(name: "SFProDisplay-Regular", size: 16)
            if limitApps.count > 1 {
                descLbl.text = "delete_limit_app_des".localized + " " + "selected_apps".localized + "?"
            } else {
                let delete = "delete_limit_app_des".localized
                descLbl.text = delete + " ''" + "\(limitApps[0].appName ?? "")" + "''" + "?"
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.bottomConstant.constant = 30
            self.view.layoutIfNeeded()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.bottomConstant.constant = -500
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func dismissBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func deleteBtn(_ sender: Any) {
        if !deleteLimit {
            deleteChildApiCall()
        } else {
            SwiftFTUtils.showHUDAdded(to: self.view, withText: "", animated: true)
            deleteLimit(array: limitApps) {
                for obj in self.limitApps {
                    var updates = obj
                    updates.appLimit = "0"
                    updates.saturday = 0
                    updates.sunday = 0
                    updates.monday = 0
                    updates.tuesday = 0
                    updates.wednesday = 0
                    updates.thursday = 0
                    updates.friday = 0
                    DBManager.shared.fetchModelAndUpdate(obj: updates)
                }
                DispatchQueue.main.async {
                    UserDefaults.standard.set(true, forKey: "reloadDB")
                    self.dismiss(animated: true) {
                        self.deleteLimitCallback()
                    }
                }
            }
        }
    }
    
    func deleteLimit(array: [InstalledApp], callback:@escaping ()->()) {
        let params = deleteLimitParams(array: array)
        print("ajhsg", array[0].childID as Any)
        let childID = UserDefaults.standard.integer(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        CoreManager.putLimitToApp(params: params, childID: childID, callBack: {
            print("Done Limit")
            callback()
        })
    }
    
    func deleteLimitParams(array: [InstalledApp]) -> [String: Any] {
        var json = [[String: Any]]()
        for obj in array{
            let params: [String:Any] = [
                "installed_app_id": obj.installedappID ?? 0,
                "app_limit": 0]
            json.append(params)
        }
        let param = ["apps": json]
        return param
    }
    
    func deleteChildApiCall(){
        let childId = UserDefaults.standard.integer(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        let core2URL = HLConstants.URLs.Child.deleteChildCore2 + "\(childId)"
        print(core2URL)
        SwiftFTUtils.showHUDAdded(to: view, withText: "Deleting Child...".localized, animated: true)
        HLApiManager.deleteChildNetworkCallCore2(withURL: core2URL) { isDeleted, error in
            DispatchQueue.main.async {
                SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
                if let isDeleted = isDeleted {
                    if isDeleted {
                        
                        CoreDataUtility.delete_ChildDataFromDB(entity: "ChildrenEntity")
                        CoreDataUtility.delete_ChildDataFromDB(entity: "Children_Info")
                        CoreDataUtility.delete_ChildDataFromDB(entity: "Child_Info_Dashboard")
                        CoreDataUtility.delete_ChildDataFromDB(entity: "FamilyFeed")
                        
                        UserDefaultsManager.ChildAdded = false
                        self.dismiss(animated: true) {
                            self.childDeleted()
                        }
                    } else {
                        CommonModel.showAlert("alert_error".localized, msg: error ?? StringConstants.Constants.NIL_VALUE)
                    }
                    
                } else {
                    print("Child is not deleted!")
                    
                }
            }
        }
    }
}
