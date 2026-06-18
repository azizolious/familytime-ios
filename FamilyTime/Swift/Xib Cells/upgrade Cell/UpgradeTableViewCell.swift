//
//  UpgradeTableViewCell.swift
//  FamilyTime
//
//  Created by Usama-Apps on 19/09/2022.
//  Copyright © 2022 YumyApps. All rights reserved.
//

import UIKit

protocol UpgradeCellDelegates {
    func upgradenow()
}

class UpgradeTableViewCell: UITableViewCell {
    
    //MARK: - IBActions
    @IBOutlet weak var upgradeView: UIView!{
        didSet {
            upgradeView.layer.cornerRadius = 5
            upgradeView.layer.masksToBounds = true
        }
    }
    
    

    @IBOutlet weak var subscriptionView: UIView! {
        didSet {
            subscriptionView.layer.cornerRadius = subscriptionView.frame.size.width/2
            subscriptionView.clipsToBounds = true
            subscriptionView.layer.borderColor = UIColor(red: 255, green: 255, blue: 255, a: 0.1).cgColor
            subscriptionView.layer.borderWidth = 1.0
        }
    }
    @IBOutlet weak var upgradeNowButtonOutlet: UIButton! {
        didSet {
            upgradeNowButtonOutlet.layer.cornerRadius = 5
            upgradeNowButtonOutlet.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var proActivity: UIActivityIndicatorView!
    @IBOutlet weak var promotionView: UIView!
    @IBOutlet weak var promotionalNotificationImgView: UIImageView!
    @IBOutlet weak var subcriptionImageView : UIImageView!
    @IBOutlet weak var limitedTimeLabel: UILabel!
    @IBOutlet weak var flatDiscountLabel: UILabel!
    @IBOutlet weak var onFamilyTimeLabel: UILabel!
    
    
    //MARK: - Variables
    var delegate : UpgradeCellDelegates?
    
    //MARK: - View LifeCycles
    override func awakeFromNib() {
        super.awakeFromNib()
        proActivity.isHidden = true
    }
    
    //MARK: - IBActions
    
    @IBAction func upgradeButtonPressed(_ sender: Any) {
        delegate?.upgradenow()
    }
    
    //MARK: - Helper Functions
    func setImageNotification(data:String?) {
        proActivity.isHidden = false
        proActivity.startAnimating()
        if data != nil {
            promotionalNotificationImgView.isHidden = false
            if data != ""{
                proActivity.stopAnimating()
                proActivity.isHidden = true
            }
            promotionalNotificationImgView.sd_setImage(with: URL(string: data ?? ""), placeholderImage: UIImage(named: ""))
            subscriptionView.isHidden = true
            subcriptionImageView.isHidden = true
            limitedTimeLabel.isHidden = true
            flatDiscountLabel.isHidden = true
            onFamilyTimeLabel.isHidden = true
            upgradeView.isHidden = true
            upgradeNowButtonOutlet.isHidden = true
        }
    }
}
