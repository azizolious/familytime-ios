//
//  NotSureViewController.swift
//  FamilyTime
//
//  Created by Rao Mudassar Khalil on 12/11/2021.
//  Copyright © 2021 YumyApps. All rights reserved.
//

import UIKit

class NotSureViewController: UIViewController {
    
    @IBOutlet weak var notSureTableView: UITableView!
    @IBOutlet weak var notSureLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var noProblemLabel: UILabel!
    @IBOutlet weak var backArrowButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.notSureLabel.text = "step_1_option_3".localized
        self.noProblemLabel.text = "step_2_not_sure_content".localized
        self.backButton.setTitle("back_button".localized, for: .normal)
        //For Arabic
        if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
            self.backArrowButton.transform = self.backArrowButton.transform.rotated(by: CGFloat(Double.pi / 1))
        }
        self.notSureTableView.rowHeight = UITableView.automaticDimension
        self.notSureTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension NotSureViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! NotSureTableViewCell
        cell.selectionStyle = .none
        cell.androidLabel.text = "step_2_not_sure_android_content_1".localized
        cell.iosLabel.text = "step_2_not_sure_ios_content".localized
        cell.makeSureLabel.text = "step_2_not_sure_android_content_2".localized
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
