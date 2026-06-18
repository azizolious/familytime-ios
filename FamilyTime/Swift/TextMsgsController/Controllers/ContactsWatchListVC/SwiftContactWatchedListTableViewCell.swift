//
//  SwiftContactWatchedListTableViewCell.swift
//  FamilyTime
//
//  Created by YumyApps on 02/11/2021.
//  Copyright © 2021 YumyApps. All rights reserved.
//

import UIKit

class SwiftContactWatchedListTableViewCell: UITableViewCell {

    @IBOutlet weak var contactImage: UIButton!
    @IBOutlet weak var mobile: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var sw11: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
