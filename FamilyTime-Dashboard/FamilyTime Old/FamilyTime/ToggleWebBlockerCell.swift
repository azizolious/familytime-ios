//
//  ToggleWebBlockerCell.swift
//  FamilyTime
//
//  Created by Sufyan on 12/01/2024.
//  Copyright © 2024 YumyApps. All rights reserved.
//

import UIKit

class ToggleWebBlockerCell: UITableViewCell {

    @IBOutlet weak var mainSwitch: UISwitch!
    @IBOutlet weak var descLbl: UILabel!
    
    @IBOutlet weak var titleLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
