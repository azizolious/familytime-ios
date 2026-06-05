//
//  NewUserAddChildVC.swift
//  FamilyTime
//
//  Created by Hammad Lodhi iOS on 19/03/2020.
//  Copyright © 2020 YumyApps. All rights reserved.
//

import UIKit

class NewUserAddChildVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func adddeviceBtnTpd() {
        let controller = HLStoryboard.loadAddDeviceVC()
        controller.cancelButton  = false
        controller.stateMaintain = "NO"
        controller.newUser = true
        self.navigationController?.pushViewController(controller, animated: true)
        
    }

}
