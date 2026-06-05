//
//  Alerts.swift
//  FamilyTime - Dashboard
//
//  Created by Muhammad Ajmal on 14/05/2017.
//  Copyright © 2017 SoraCode. All rights reserved.
//

import Foundation
import UIKit




func AppDelegateShared() -> AppDelegate {
    var realDelegate: AppDelegate?
    if Thread.isMainThread{
        return UIApplication.shared.delegate as! AppDelegate
    }
    let dg = DispatchGroup()
    dg.enter()
    DispatchQueue.main.async{
        realDelegate = UIApplication.shared.delegate as? AppDelegate
        dg.leave()
    }
    dg.wait()
    return realDelegate ?? UIApplication.shared.delegate as! AppDelegate
}
