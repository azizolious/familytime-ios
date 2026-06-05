//
//  RemoveURLVM.swift
//  FamilyTime
//
//  Created by Sufyan on 17/01/2024.
//  Copyright © 2024 YumyApps. All rights reserved.
//

import Foundation
class RemoveURLVM {
    var webBlockerArr = [WebBlockerObj]()
    var selectAll = false
    var isSearching = false
    var searchArr = [WebBlockerObj]()
    
    func selection() {
        if selectAll == true {
           webBlockerArr = webBlockerArr.map { obj in
                var ob2 = obj
                ob2.isSelectd = true
                return ob2
            }
        } else {
            webBlockerArr = webBlockerArr.map { obj in
                 var ob2 = obj
                 ob2.isSelectd = false
                 return ob2
             }
        }
    }
    
    func deleteData(callback: @escaping()->()) {
        CoreManager.deleteWebBlocker(param: getParams()) { res, code, message in
            if (200...210).contains(code ?? 0) {
                let filterArr = self.webBlockerArr.filter({$0.isSelectd == true})
                for obj in filterArr {
                    DBManager.shared.deletObjWebBlocker(webObj: obj)
                }
            }
            callback()
        }
    }
    private func getParams() -> [String:Any] {
        let apps = isSearching ? searchArr.filter({$0.isSelectd == true}) : webBlockerArr.filter({$0.isSelectd == true})
       
        var list = [[String:Any]]()
        for obj in apps {
            let obj = ["child_id": obj.childID ?? 0,
                       "is_blocked": obj.isBlocked ?? 0,
                       "type": obj.type ?? 0,
                       "id":obj.id ?? 0,
                       "is_selected": 1,
                       "super_user_id": obj.superUserID ?? 0,
                       "url": obj.url ?? ""] as [String : Any]
            list.append(obj)
            
        }
        
        let params:[String:Any] = ["data": list]
        return params
    }
}
