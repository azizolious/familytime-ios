//
//  successPopViewController.swift
//  FamilyTime
//
//  Created by Sufyan on 28/06/2024.
//  Copyright © 2024 YumyApps. All rights reserved.
//

import UIKit

class SuccessPopViewController: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var subtitleLabel: UILabel!
    
    @IBOutlet weak var buttonOK: UIButton!
    
    var image: UIImage!
    var titleText : String = ""
    var subtitleText : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        imgView.image = image
        titleLabel.text = titleText
        subtitleLabel.text = subtitleText

    }
    
    @IBAction func buttonOK(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
