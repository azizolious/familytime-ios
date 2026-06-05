//
//  AppLimitTableCell.swift
//  FamilyTime
//
//  Created by Sufyan on 17/10/2023.
//  Copyright © 2023 YumyApps. All rights reserved.
//

import UIKit

class AppLimitTableCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var iconImg: UIImageView!
    
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
