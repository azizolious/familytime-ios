//
//  ApplimitSuccessPopup.swift
//  FamilyTime
//
//  Created by Sufyan on 20/10/2023.
//  Copyright © 2023 YumyApps. All rights reserved.
//

import UIKit

class ApplimitSuccessPopup: UIViewController {
    var tapped: ()->() = {}
    @IBOutlet weak var bottomConstant: NSLayoutConstraint!
    @IBOutlet weak var okTapped: UIStackView!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    
    var titleStr:String?
    var imgName: String?
    var desc:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        changeUI()
        // Do any additional setup after loading the view.
    }
    func changeUI() {
        if let imgStr = imgName {
            img.image = UIImage(named: imgStr)
        }
        if let des = desc {
            descLbl.text = des
        }
        if let titl = titleStr {
            titleLbl.text = titl
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.bottomConstant.constant = 30
            self.view.layoutIfNeeded()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.bottomConstant.constant = -500
            self.view.layoutIfNeeded()
        }
    }
   
    @IBAction func oktapped(_ sender: Any) {
        self.dismiss(animated: true) {
            self.tapped()
        }
    }
}
