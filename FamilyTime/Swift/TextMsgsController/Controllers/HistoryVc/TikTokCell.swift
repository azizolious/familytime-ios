//
//  TikTokCell.swift
//  FamilyTime
//
//  Created by Rizwan-Apps on 05/12/2022.
//  Copyright © 2022 YumyApps. All rights reserved.
//

import UIKit

class TikTokCell: UITableViewCell {

    //MARK: OUTLETS
    @IBOutlet weak var videoNameLbl: UILabel!
    @IBOutlet weak var videoDetailLbl: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
