//
//  WebBlockerViewModel.swift
//  FamilyTime
//
//  Created by Sufyan on 15/01/2024.
//  Copyright © 2024 YumyApps. All rights reserved.
//

import Foundation
class WebBlockerViewModel {
    var webBlockerArr = [WebBlockerObj]()
    var control = Control()
    var selectedAll = false
    var reload: () -> () = {}
    
    func initMethod() {
        fetchControl()
        let objArr = DBManager.shared.getWebBlocker()
        webBlockerArr = objArr
        selectAllTogle()
        reload()
    }
    func selectAllTogle() {
        if webBlockerArr.allSatisfy({$0.isBlocked == 1}) {
            selectedAll = true
        } else {
            selectedAll = false
        }
    }
    
    func fetchControl()  {
        let control = DBManager.shared.fetchAppBlockControl(identifier: "web_blocker")
        self.control = control
    }
    
    func changeControl(state: Int, callBack:@escaping()->()) {
        
        let id = UserDefaults.standard.integer(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        
        if let featureId = control.featureID,
           let identifier = control.identifier {
            
            HLApiManager.putControlApi(childId: id, featureId: featureId, state: state, identifier: identifier) { err in
                callBack()
                if err == nil {
                    DBManager.shared.fetchControlAndUpdate(identifier: "web_blocker", state: state)
                    self.fetchControl()
                    self.reload()
                }
            }
        } else {
            CommonModel.showAlert("alert_error".localized, msg: "alert_something_wrong_again")
            print("❌ Missing required params (childId / featureId / identifier)")
        }
    }
    func patchData(callback: @escaping()->()) {
        CoreManager.patchWebBlocker(param: getParams()) { res, code, message in
            if (200...210).contains(code ?? 0) {
                DBManager.shared.deleteData(entityName: "WebBlocker")
                DBManager.shared.saveWebBlocker(myModelArray: self.webBlockerArr)
            }
            callback()
        }
    }
    private func getParams() -> [String:Any] {
        var apps = webBlockerArr
       
        var list = [[String:Any]]()
        for obj in apps {
            let obj = ["child_id": obj.childID ?? 0,
                       "is_blocked": obj.isBlocked ?? 0,
                       "type": obj.type ?? 0,
                       "id":obj.id ?? 0,
                       "super_user_id": obj.superUserID ?? 0,
                       "url": obj.url ?? ""] as [String : Any]
            list.append(obj)
            
        }
        
        let params:[String:Any] = ["data": list]
        return params
    }
    func selection() {
        if selectedAll == true {
            webBlockerArr = webBlockerArr.map({ value in
                var obj = value
                obj.isBlocked = 1
                return obj
            })
        } else {
            webBlockerArr = webBlockerArr.map({ value in
                var obj = value
                obj.isBlocked = 0
                return obj
            })
        }
        //reload()
    }
}
