//
//  AppUsageCell.swift
//  FamilyTime
//
//  Created by Sana Ullah on 19/09/2019.
//  Copyright © 2019 YumyApps. All rights reserved.
//

import UIKit

class AppUsageCell: UITableViewCell {

    @IBOutlet weak var appNameLbl: UILabel!
    
    
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var progressVuWidth: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
