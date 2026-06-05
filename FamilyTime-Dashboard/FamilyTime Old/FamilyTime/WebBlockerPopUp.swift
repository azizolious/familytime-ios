//
//  WebBlockerPopUp.swift
//  FamilyTime
//
//  Created by Sufyan on 17/01/2024.
//  Copyright © 2024 YumyApps. All rights reserved.
//

import UIKit

class WebBlockerPopUp: UIViewController {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var bottomConstant: NSLayoutConstraint!

    var responseBack: ()->() = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func deleteTapped(_ sender: Any) {
        responseBack()
        self.dismiss(animated: true)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
