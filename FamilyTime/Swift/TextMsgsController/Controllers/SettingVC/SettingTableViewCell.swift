//
//  SettingTableViewCell.swift
//  FamilyTime
//
//  Created by YumyApps on 01/11/2021.
//  Copyright © 2021 YumyApps. All rights reserved.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
    
    @objc var cellSwitch = UISwitch()
    var arrow = UIButton()
    
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    
    @objc var onSwitchChange: ((_ cell: SettingTableViewCell?) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellSwitch = UISwitch(frame: CGRect(x: 0, y: 0, width: 51, height: 31))
        cellSwitch.onTintColor = RGBCOLOR(24, 167, 225, 1)
        accessoryView = cellSwitch
        cellSwitch.addTarget(self, action: #selector(updatePrefence(_:)), for: .valueChanged)

        self.selectiveBorderFlag = UInt(AUISelectiveBordersFlagBottom)
        self.selectiveBordersColor = UIColor.lightGray.withAlphaComponent(0.5)
        self.selectiveBordersWidth = 0.5
        
        self.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func updatePrefence(_ sender: Any) {
        
        self.onSwitchChange!(self)
        
    }
    
    @objc func showAccessoryview() {
        
        accessoryView = nil
        accessoryType = .disclosureIndicator
        
    }
    

}
