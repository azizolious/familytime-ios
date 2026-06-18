//
//  YTHistoryCell.swift
//  FamilyTime
//
//  Created by Sufyan on 04/12/2023.
//  Copyright © 2023 YumyApps. All rights reserved.
//

import UIKit

class YTHistoryCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var playBtn: UIButton!
    
    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
