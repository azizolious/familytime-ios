//
//  SwiftLimitScreentimeActivatedPushViewController.swift
//  FamilyTime
//
//  Created by YumyApps on 03/11/2021.
//  Copyright © 2021 YumyApps. All rights reserved.
//

import UIKit

class SwiftLimitScreentimeActivatedPushViewController: UIViewController {
    
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var submitbutton: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    @objc var mainTitle = ""
    @objc var subTitle = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        submitbutton.layer.cornerRadius = submitbutton.frame.size.height / 2.0
        submitbutton.layer.masksToBounds = true

        lblTitle.text = mainTitle
        lblSubTitle.text = subTitle

    }
    
    @IBAction func okButton(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
