//
//  TextMessagesTableViewCell.swift
//  FamilyTime
//
//  Created by Rao Mudassar Khalil on 14/10/2021.
//  Copyright © 2021 YumyApps. All rights reserved.
//

import UIKit

class TextMessagesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var snippetLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var borderView = UIView()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        borderView = UIView(frame: CGRect.zero)
        borderView.backgroundColor = UIColor.lightGray
        contentView.addSubview(borderView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        borderView.frame = CGRect(x: 0, y: contentView.frame.maxY - 1, width: contentView.frame.maxX, height: 0.5)
    }
}
