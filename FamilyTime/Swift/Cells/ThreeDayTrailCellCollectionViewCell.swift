//
//  ThreeDayTrailCellCollectionViewCell.swift
//  FamilyTime
//
//  Created by Rizwan-Apps on 25/11/2022.
//  Copyright © 2022 YumyApps. All rights reserved.
//

import UIKit

class ThreeDayTrailCellCollectionViewCell: UICollectionViewCell {
    

    /* MARK: - Outlets and Properties */
    @IBOutlet weak var lblTitle     : UILabel!
    @IBOutlet weak var imageContent : UIImageView!
    //@IBOutlet weak var bgView       : UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
}

/* MARK: - Extension */
extension ThreeDayTrailCellCollectionViewCell{
    func setupCell(){
//        self.contentView.layer.cornerRadius = 15.0
//        bgView.layer.cornerRadius = 15.0
        //addBorder(bgView)
        
    }
     func addBorder(_ view : UIView){
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(rgb: 0xF2F2F2).cgColor
    }
}
