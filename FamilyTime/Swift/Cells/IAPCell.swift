//
//  IAPCell.swift
//  FamilyTime
//
//  Created by Sana Ullah on 29/01/2019.
//  Copyright © 2019 YumyApps. All rights reserved.
//

import UIKit

class IAPCell: UITableViewCell {

    
    @IBOutlet weak var imageVu_leadConst: NSLayoutConstraint!
    @IBOutlet weak var imgVu_heightConst: NSLayoutConstraint!
    @IBOutlet weak var imgVu_widthConst: NSLayoutConstraint!
    
    @IBOutlet weak var stackVu_leadConst: NSLayoutConstraint!
    @IBOutlet weak var nextArrow_trailConst: NSLayoutConstraint!
    
    
    @IBOutlet weak var nextArrow_heightConst: NSLayoutConstraint!
    @IBOutlet weak var nextArrow_widthConst: NSLayoutConstraint!
    
    @IBOutlet weak var mainVu_bottomConst: NSLayoutConstraint!
    
    @IBOutlet weak var imgVu: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var stackVu: UIStackView!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        if !SwiftFTUtils.isDeviceiPhoneFamily(){
//
//            imageVu_leadConst.constant      = 30
//            imgVu_heightConst.constant      = 72
//            imgVu_widthConst.constant       = 72
//
//            nextArrow_trailConst.constant   = 30
//            nextArrow_widthConst.constant   = 30
//            nextArrow_heightConst.constant  = 30
//
//            mainVu_bottomConst.constant     = 13
//            stackVu.spacing                 = 14
//
//            nameLbl.font                    = UIFont(name: "OpenSans-Semibold", size: 25)
//            descriptionLbl.font             = UIFont(name: "OpenSans-Regular", size: 40)
//
//        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
//    func populateCell(group:IAP_Groups){
//        imgVu.image         = getImageForGroup(group: group)
//        nameLbl.text        = group.group_name
//        descriptionLbl.text = group.group_description
//    }
//    
//    func getImageForGroup(group:IAP_Groups) -> UIImage{
//        if group.group_color == Colors.kTheme_red{
//            return #imageLiteral(resourceName: "ic_red")
//        }
//        else if group.group_color == Colors.kTheme_green{
//            return #imageLiteral(resourceName: "ic_green")
//        }
//        else if group.group_color == Colors.kTheme_orange{
//            return #imageLiteral(resourceName: "ic_orange")
//        }
//
//        return #imageLiteral(resourceName: "ic_red")
//    }
//
}
