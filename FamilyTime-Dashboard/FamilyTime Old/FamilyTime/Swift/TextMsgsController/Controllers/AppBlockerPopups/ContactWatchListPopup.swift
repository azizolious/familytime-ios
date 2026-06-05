//
//  ContactWatchListPopup.swift
//  FamilyTime
//
//  Created by Usama-Apps on 03/02/2023.
//  Copyright © 2023 YumyApps. All rights reserved.
//

import UIKit

class ContactWatchListPopup: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var instructionLbl: UILabel!
    @IBOutlet weak var okBtn: UIButton!

    //MARK: - Variables
    @objc var titleNames:String?
    
    //MARK: - View Life Cycles
    override func viewDidLoad(){
        super.viewDidLoad()
        let text = UserDefaults.standard.string(forKey: "app_block_contact_watchlist_message")
        instructionLbl.text = text ?? ""
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        okBtn.layer.cornerRadius = 10.0
        okBtn.clipsToBounds = true
    }
    
    //MARK: - IBActions
    @IBAction func okBtn(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: UserDefaultsConstants.CONTACT_WATCHLIST_PUSH)
        UserDefaults.standard.removeObject(forKey: UserDefaultsConstants.APP_BLOCK_CONTACT_LIST_MSG)
        UserDefaults.standard.synchronize()
        dismiss(animated: true, completion: nil)
    }
}
