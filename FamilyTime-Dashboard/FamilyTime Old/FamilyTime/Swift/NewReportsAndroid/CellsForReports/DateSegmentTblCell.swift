//
//  DateSegmentTblCell.swift
//  FamilyTime
//
//  Created by Sufyan on 27/11/2023.
//  Copyright © 2023 YumyApps. All rights reserved.
//

import UIKit

class DateSegmentTblCell: UITableViewCell {

    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var segmentControl: OYSegmentControl!
    
    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var rightDateBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        segmentControl.setTitle("day".localized, forSegmentAt: 0)
        segmentControl.setTitle("week".localized, forSegmentAt: 1)
        segmentControl.setTitle("month".localized, forSegmentAt: 2)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func segmentChanged(_ sender: OYSegmentControl) {
    }
    
    
    
    
}
