//
//  SocialMediaCell.swift
//  FamilyTime
//
//  Created by Sufyan on 31/10/2023.
//  Copyright © 2023 YumyApps. All rights reserved.
//

import UIKit

class SocialMediaCell: UITableViewCell {

    @IBOutlet weak var socialSwitch: UISwitch!
    @IBOutlet weak var socialImg: UIImageView!
    @IBOutlet weak var socialTitle: UILabel!
    @IBOutlet weak var uninstalledView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
