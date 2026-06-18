//
//  AddDomainCell.swift
//  FamilyTime
//
//  Created by Sufyan on 15/01/2024.
//  Copyright © 2024 YumyApps. All rights reserved.
//

import UIKit

class AddDomainCell: UITableViewCell {
    @IBOutlet weak var domainView: UIView!
    @IBOutlet weak var addUrlTF: UITextField!
    @IBOutlet weak var urlView: UIView!
    @IBOutlet weak var domainBtn: UIButton!
    @IBOutlet weak var urlBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addUrlTF.placeholder = "add_URL".localized
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    @IBAction func addBtnTapped(_ sender: Any) {
    }
    
    @IBAction func DomainTapped(_ sender: UIButton) {
    }
    
}
