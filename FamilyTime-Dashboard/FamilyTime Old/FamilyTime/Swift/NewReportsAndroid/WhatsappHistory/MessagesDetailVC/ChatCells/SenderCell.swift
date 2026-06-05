//
//  SenderCell.swift
//  FamilyTime
//
//  Created by Sufyan on 21/12/2023.
//  Copyright © 2023 YumyApps. All rights reserved.
//

import UIKit

class SenderCell: UITableViewCell {

    @IBOutlet weak var msgView: UIView!
    @IBOutlet weak var bodyLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        msgView.layer.cornerRadius = 10
        msgView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner]
        //.layerMaxXMaxYCorner,
        //msgView.roundCorners([.topLeft, .topRight, .bottomLeft], radius: 10)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
