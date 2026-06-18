//
//  SwiftPermissionScreenViewControllerPush.swift
//  FamilyTime
//
//  Created by YumyApps on 03/11/2021.
//  Copyright © 2021 YumyApps. All rights reserved.
//

import UIKit

class SwiftPermissionScreenViewControllerPush: UIViewController {
    
    @objc var rowDic: [AnyHashable: Any] = [:]
    @objc var strDeviceName = ""
    
    @IBOutlet weak var lblTitleName: UILabel!
    @IBOutlet weak var lblFirstLine: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var lbl3: UILabel!
    @IBOutlet weak var lbl4: UILabel!
    @IBOutlet weak var lbl5: UILabel!
    @IBOutlet weak var lbl6: UILabel!
    @IBOutlet weak var lblHead: UILabel!
    @IBOutlet weak var lblSubHead: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblTitleName.text = strDeviceName
        lblFirstLine.text = "\(String(describing: "Open FamilyTime on your".myModification())) \(strDeviceName) \(String(describing: "device".myModification()))"
        //"Take Me There"
        lbl2.text = "\(String(describing: "Permission pop-up will come up, tap on".myModification()))\"\(String(describing: "Take Me There".myModification()))\" "
        lbl3.text = lbl3.text?.myModification()
        lbl4.text = lbl4.text?.myModification()
        lbl5.text = lbl5.text?.myModification()
        lbl6.text = lbl6.text?.myModification()

        lblHead.text = lblHead.text?.myModification()
        lblSubHead.text = lblSubHead.text?.myModification()

    }
    
    @IBAction func okButton(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
