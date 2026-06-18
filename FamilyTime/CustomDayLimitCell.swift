//
//  CustomDayLimitCell.swift
//  FamilyTime
//
//  Created by Sufyan on 17/10/2023.
//  Copyright © 2023 YumyApps. All rights reserved.
//

import UIKit

class CustomDayLimitCell: UITableViewCell {

    
    @IBOutlet weak var dayNameLbl: UILabel!
    
    @IBOutlet weak var switchChanged: UISwitch!
    
    @IBOutlet weak var timeBtn: UIButton!
    
    var callback: ()->() = {}
    var switchChanges: ()->() = {}
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func switchChange(_ sender: UISwitch) {
        switchChanges()
    }
    @IBAction func timeBtnTap(_ sender: Any) {
        callback()
    }
}
