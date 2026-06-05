//
//  ReceiverCell.swift
//  FamilyTime
//
//  Created by Sufyan on 21/12/2023.
//  Copyright © 2023 YumyApps. All rights reserved.
//

import UIKit

class ReceiverCell: UITableViewCell {
    @IBOutlet weak var msgVu: UIView!
    @IBOutlet weak var bodyLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        msgVu.cornerRadius = 10
        msgVu.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMaxXMinYCorner,.layerMinXMinYCorner]
        // Initialization code
       // msgVu.roundCorners([.topLeft, .topRight, .bottomRight], radius: 10)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
