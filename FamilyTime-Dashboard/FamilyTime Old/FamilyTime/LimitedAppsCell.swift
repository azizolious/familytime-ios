//
//  LimitedAppsCell.swift
//  FamilyTime
//
//  Created by Sufyan on 20/10/2023.
//  Copyright © 2023 YumyApps. All rights reserved.
//

import UIKit

class LimitedAppsCell: UITableViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var limitTime: UILabel!
    @IBOutlet weak var selectionImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
