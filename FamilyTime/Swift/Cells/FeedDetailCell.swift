//
//  FeedDetailCell.swift
//  FamilyTime
//
//  Created by Rao Mudassar Khalil on 21/09/2021.
//  Copyright © 2021 YumyApps. All rights reserved.
//

import UIKit

class FeedDetailCell: UITableViewCell {
    
    @IBOutlet weak var feed_title: UILabel!

    @IBOutlet weak var feed_detail: UILabel!
    
    @IBOutlet weak var feed_img: UIImageView!
    
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowOffset = .zero
        containerView.layer.shadowRadius = 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

