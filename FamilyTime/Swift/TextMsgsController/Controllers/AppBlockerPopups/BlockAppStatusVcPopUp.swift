//
//  BlockAppStatusVcPopUp.swift
//  FamilyTime
//
//  Created by Usama-Apps on 20/01/2023.
//  Copyright © 2023 YumyApps. All rights reserved.
//

import UIKit

class BlockAppStatusVcPopUp: UIViewController {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var instructionLbl: UILabel!
    @IBOutlet weak var closeBtn: UIButton!
    
    //MARK: - Variables
    @objc var childName:String?
    @objc var body:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        instructionLbl.text = childName ?? ""
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        closeBtn.layer.cornerRadius = 5.0
    }

    //MARK: ACTION
    @IBAction func closeBtn(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: UserDefaultsConstants.APP_BLOCK_CHILD_NAME)
        UserDefaults.standard.removeObject(forKey: UserDefaultsConstants.APP_BLOCK_STATUS)
        UserDefaults.standard.synchronize()
        dismiss(animated: true, completion: nil)
    }
}
