//
//  AddURLViewModel.swift
//  FamilyTime
//
//  Created by Sufyan on 16/01/2024.
//  Copyright © 2024 YumyApps. All rights reserved.
//

import Foundation
class AddURLViewModel {
    var newURLArr = [WebBlockerObj]()
    
    private func getParams() -> [String:Any] {
        var apps = newURLArr
       
        var list = [[String:Any]]()
        for obj in apps {
            let obj = ["child_id": obj.childID ?? 0,
                       "is_blocked": obj.isBlocked ?? 0,
                       "type": obj.type ?? 0,
                       "url": obj.url ?? ""] as [String : Any]
            list.append(obj)
            
        }
        
        let params:[String:Any] = ["data": list]
        return params
    }
    func postData(callback: @escaping(String?)->()) {
        CoreManager.postWebBlocker(param: getParams()) { res, code, message in
            if (200...210).contains(code ?? 0) {
                DBManager.shared.saveWebBlocker(myModelArray: self.newURLArr)
                callback(nil)
            }else {
                callback(message)
            }
        }
    }
}
 
