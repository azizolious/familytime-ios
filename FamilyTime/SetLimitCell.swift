//
//  SetLimitCell.swift
//  FamilyTime
//
//  Created by Sufyan on 17/10/2023.
//  Copyright © 2023 YumyApps. All rights reserved.
//

import UIKit

class SetLimitCell: UITableViewCell{
    
    @IBOutlet weak var pickerVu: UIPickerView!
    
    let minutessArray = (0...60).map { String(format: "%02d", $0) }
    let hourArray = (0...23).map { String(format: "%02d", $0) }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

