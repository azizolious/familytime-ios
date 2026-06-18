//
//  WebBlockerCell.swift
//  FamilyTime
//
//  Created by Sufyan on 12/01/2024.
//  Copyright © 2024 YumyApps. All rights reserved.
//

import UIKit

class WebBlockerCell: UITableViewCell {

    @IBOutlet weak var swicth: UISwitch!
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var checkImg: UIImageView!
    
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
