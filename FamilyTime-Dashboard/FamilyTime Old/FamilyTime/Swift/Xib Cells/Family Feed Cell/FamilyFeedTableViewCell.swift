//
//  FamilyFeedTableViewCell.swift
//  FamilyTime
//
//  Created by Sufyan on 24/07/2024.
//  Copyright © 2024 YumyApps. All rights reserved.
//

import UIKit

class FamilyFeedTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var miniSubtitle: UILabel!
    @IBOutlet weak var miniImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
