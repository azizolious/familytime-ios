//
//  SelectDeviceTableViewCell.swift
//  FamilyTime
//
//  Created by Rao Mudassar Khalil on 15/10/2021.
//  Copyright © 2021 YumyApps. All rights reserved.
//

import UIKit

class SelectDeviceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var separator: UIView!
    
    @IBOutlet weak var check: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
