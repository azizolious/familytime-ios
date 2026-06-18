//
//  ActivateFamilyTimeAlert.swift
//  FamilyTime
//
//  Created by Mian Usama on 13/04/2022.
//  Copyright © 2022 YumyApps. All rights reserved.
//

import UIKit

class ActivateFamilyTimeAlert: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var okayButtonOutlet: UIButton! {
        didSet {
            okayButtonOutlet.backgroundColor = UIColor.groupTableViewBackground
        }
    }
    
    //MARK: - View LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - IBActions
    
    @IBAction func okayButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
