//
//  NotSureTableViewCell.swift
//  FamilyTime
//
//  Created by Rao Mudassar Khalil on 12/11/2021.
//  Copyright © 2021 YumyApps. All rights reserved.
//

import UIKit

class NotSureTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iosLabel: UILabel!
    @IBOutlet weak var androidLabel: UILabel!
    @IBOutlet weak var makeSureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
