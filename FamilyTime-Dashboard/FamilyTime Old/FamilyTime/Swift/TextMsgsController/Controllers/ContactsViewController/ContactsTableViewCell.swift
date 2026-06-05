//
//  ContactsTableViewCell.swift
//  FamilyTime
//
//  Created by Rao Mudassar Khalil on 13/10/2021.
//  Copyright © 2021 YumyApps. All rights reserved.
//

import UIKit

class ContactsTableViewCell: UITableViewCell {

    @IBOutlet weak var contactImage: UIButton?
    @IBOutlet weak var name: UILabel?
    @IBOutlet weak var mobile: UILabel?
    @IBOutlet weak var email: UILabel?
    @IBOutlet weak var add: UIButton?
    
    override func awakeFromNib() {
        super.awakeFromNib()
 
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
