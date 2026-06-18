//
//  PremiumPackageCell.swift
//  FamilyTime
//
//  Created by Usama-Apps on 07/09/2022.
//  Copyright © 2022 YumyApps. All rights reserved.
//

import UIKit

protocol PremiumPackageCellDelegates {
    func upgradePackage(at indexPath : IndexPath)
}

class PremiumPackageCell: UITableViewCell {
    
    @IBOutlet weak var lastImgTop: NSLayoutConstraint!
    /* MARK: - IBOutlets */
    @IBOutlet weak var homeView: UIView!
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var ftLogoImageView: UIImageView!
    @IBOutlet weak var wheelImageView: UIImageView!
    @IBOutlet weak var discountImageView: UIImageView!
    @IBOutlet weak var startOneImageView: UIImageView!
    @IBOutlet weak var startTwoImageView: UIImageView!
    @IBOutlet weak var startThreeeImageView: UIImageView!
    @IBOutlet weak var startFourImageView: UIImageView!
    @IBOutlet weak var startFiveImageView: UIImageView!
    @IBOutlet weak var startSixImageView: UIImageView!
    @IBOutlet weak var startSevenImageView: UIImageView!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var myFamilyLabel: UILabel!
    @IBOutlet weak var priceLable: UILabel!
    @IBOutlet weak var discountLableHeightAnchor: NSLayoutConstraint!
    @IBOutlet weak var childDevicePriceLabel: UILabel!
    
    @IBOutlet weak var bestValueLabel: UILabel! {
        didSet {
            bestValueLabel.layer.cornerRadius = 15.0
            bestValueLabel.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var upgradeButtonOutlet: UIButton! {
        didSet {
            upgradeButtonOutlet.layer.cornerRadius = 10.0
            upgradeButtonOutlet.layer.masksToBounds = true
        }
    }
    
    
    @IBOutlet weak var unlimitedDevicesLabel: UILabel! {
        didSet {
            unlimitedDevicesLabel.text = "unlimitedParentDevices".localized
        }
    }
    @IBOutlet weak var childDeviceLabel: UILabel!
    @IBOutlet weak var premiumFeaturesLabel: UILabel! {
        didSet {
            premiumFeaturesLabel.text = "allPremiumFeaturesIncluded".localized
        }
    }
    @IBOutlet weak var emailSupportLabel: UILabel! {
        didSet {
            emailSupportLabel.text = "priorityEmailSupport".localized
        }
    }
    @IBOutlet weak var unlimittedDeviceLbl: UILabel! {
        didSet {
            emailSupportLabel.text = "priorityEmailSupport".localized
        }
    }
    @IBOutlet weak var premierFeatureIncludeLbl: UILabel!
    @IBOutlet weak var preiorityCustomerServiceLable: UILabel!
    
    //MARK: - Variables
    var indexPath : IndexPath?
    var premiumDelegate : PremiumPackageCellDelegates?
    
    /* MARK: - View Life Cycles */
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    /* MARK: - IBActions */
    @IBAction func upgradeButtonPressed(_ sender: Any) {
        self.premiumDelegate?.upgradePackage(at: indexPath ?? IndexPath())
    }
    
    /* MARK: - UI & Helper Functions */
    func setUpCellForExternal(data: UpgradeExternalData) {
        let userCurrentLanguage = SwiftCommonUtility.shared.getCurrentLanguageCode()
        let languages = data.languages ?? [UserLanguageExt]()
        for lang in languages {
            if userCurrentLanguage == lang.language {
                let discount = data.discount ?? ""
                let points = lang.points ?? [String]()
                if discount.contains("50%") {
                    bestValueLabel.backgroundColor = UIColor.init(hexString: data.colorCode ?? "")
                    bestValueLabel.text = "bestValue".localized
                    bestValueLabel.isHidden = false
                    discountLableHeightAnchor.constant = 33
                } else {
                    bestValueLabel.isHidden = true
                    discountLableHeightAnchor.constant = 0
                }
                myFamilyLabel.text = lang.name ?? "FamilyTimePremium"
                upgradeButtonOutlet.setTitle(lang.cta ?? "", for: .normal)
                unlimitedDevicesLabel.text = points[0]
                childDeviceLabel.text = points[1]
                premiumFeaturesLabel.text = points[2]
                emailSupportLabel.text = points[3]
                unlimittedDeviceLbl.text = points[4]
                premierFeatureIncludeLbl.text = points[5]
                if points.count < 7{
                    lastImgTop.constant = 0
                    preiorityCustomerServiceLable.isHidden = true
                    startSevenImageView.isHidden = true
                }else{
                    preiorityCustomerServiceLable.text = points[6]
                }
                priceLable.text = "$\(data.price ?? "")\(lang.plan ?? "")"
                upgradeButtonOutlet.backgroundColor = UIColor.init(hexString: data.colorCode ?? "")
                discountLabel.text = "\("save_button".localized) \(data.discount ?? "")"
                priceLable.textColor = UIColor.init(hexString: data.accentColor ?? "")
                discountImageView.image = discountImageView.image?.withRenderingMode(.alwaysTemplate)
                discountImageView.tintColor = UIColor.init(hexString: data.colorCode ?? "")
                ftLogoImageView.image = ftLogoImageView.image?.withRenderingMode(.alwaysTemplate)
                ftLogoImageView.tintColor = UIColor.init(hexString: data.colorCode ?? "")
                startOneImageView.image = startOneImageView.image?.withRenderingMode(.alwaysTemplate)
                startOneImageView.tintColor = UIColor.init(hexString: data.accentColor ?? "")
                startTwoImageView.image = startTwoImageView.image?.withRenderingMode(.alwaysTemplate)
                startTwoImageView.tintColor = UIColor.init(hexString: data.accentColor ?? "")
                startThreeeImageView.image = startThreeeImageView.image?.withRenderingMode(.alwaysTemplate)
                startThreeeImageView.tintColor = UIColor.init(hexString: data.accentColor ?? "")
                startFourImageView.image = startFourImageView.image?.withRenderingMode(.alwaysTemplate)
                startFourImageView.tintColor = UIColor.init(hexString: data.accentColor ?? "")
                startFiveImageView.image = startFiveImageView.image?.withRenderingMode(.alwaysTemplate)
                startFiveImageView.tintColor = UIColor.init(hexString: data.accentColor ?? "")
                startSixImageView.image = startSixImageView.image?.withRenderingMode(.alwaysTemplate)
                startSixImageView.tintColor = UIColor.init(hexString: data.accentColor ?? "")
                startSevenImageView.image = startSevenImageView.image?.withRenderingMode(.alwaysTemplate)
                startSevenImageView.tintColor = UIColor.init(hexString: data.accentColor ?? "")
                
            } else {
                if lang.language == "en" {
                    let name = lang.name ?? "FamilyTimePremium"
                    let points = lang.points ?? [String]()
                    if name.contains("Yearly") || name.contains("yearly") {
                        bestValueLabel.backgroundColor = UIColor.init(hexString: data.colorCode ?? "")
                        bestValueLabel.text = "bestValue".localized
                        
                        bestValueLabel.isHidden = false
                        discountLableHeightAnchor.constant = 33
                    } else if name.contains("Monthly") || name.contains("monthly") {
                        bestValueLabel.isHidden = true
                        discountLableHeightAnchor.constant = 0
                    } else {
                        bestValueLabel.isHidden = true
                        discountLableHeightAnchor.constant = 0
                    }
                    myFamilyLabel.text = lang.name ?? "FamilyTimePremium"
                    upgradeButtonOutlet.setTitle(lang.cta ?? "", for: .normal)
                    unlimitedDevicesLabel.text = points[0]
                    childDeviceLabel.text = points[1]
                    premiumFeaturesLabel.text = points[2]
                    emailSupportLabel.text = points[3]
                    unlimittedDeviceLbl.text = points[4]
                    premierFeatureIncludeLbl.text = points[5]
                    if points.count < 7{
                        lastImgTop.constant = 0
                        preiorityCustomerServiceLable.isHidden = true
                        startSevenImageView.isHidden = true
                    }else{
                        preiorityCustomerServiceLable.text = points[6]
                    }
                    priceLable.text = "$\(data.price ?? "")\(lang.plan ?? "")"
                    upgradeButtonOutlet.backgroundColor = UIColor.init(hexString: data.colorCode ?? "")
                    discountLabel.text = "\("save_button".localized) \(data.discount ?? "")"
                    priceLable.textColor = UIColor.init(hexString: data.accentColor ?? "")
                    discountImageView.image = discountImageView.image?.withRenderingMode(.alwaysTemplate)
                    discountImageView.tintColor = UIColor.init(hexString: data.colorCode ?? "")
                    ftLogoImageView.image = ftLogoImageView.image?.withRenderingMode(.alwaysTemplate)
                    ftLogoImageView.tintColor = UIColor.init(hexString: data.colorCode ?? "")
                    startOneImageView.image = startOneImageView.image?.withRenderingMode(.alwaysTemplate)
                    startOneImageView.tintColor = UIColor.init(hexString: data.accentColor ?? "")
                    startTwoImageView.image = startTwoImageView.image?.withRenderingMode(.alwaysTemplate)
                    startTwoImageView.tintColor = UIColor.init(hexString: data.accentColor ?? "")
                    startThreeeImageView.image = startThreeeImageView.image?.withRenderingMode(.alwaysTemplate)
                    startThreeeImageView.tintColor = UIColor.init(hexString: data.accentColor ?? "")
                    startFourImageView.image = startFourImageView.image?.withRenderingMode(.alwaysTemplate)
                    startFourImageView.tintColor = UIColor.init(hexString: data.accentColor ?? "")
                    startFiveImageView.image = startFiveImageView.image?.withRenderingMode(.alwaysTemplate)
                    startFiveImageView.tintColor = UIColor.init(hexString: data.accentColor ?? "")
                    startSixImageView.image = startSixImageView.image?.withRenderingMode(.alwaysTemplate)
                    startSixImageView.tintColor = UIColor.init(hexString: data.accentColor ?? "")
                    startSevenImageView.image = startSevenImageView.image?.withRenderingMode(.alwaysTemplate)
                    startSevenImageView.tintColor = UIColor.init(hexString: data.accentColor ?? "")
                }
            }
        }
    }
    
    func setUpCellForInternal(data: UpgradeInternalData) {
        let userCurrentLanguage = SwiftCommonUtility.shared.getCurrentLanguageCode()
        let languages = data.languages ?? [UserLanguageInt]()
        for lang in languages {
            if userCurrentLanguage == lang.language {
                let discount = data.discount ?? ""
                let points = lang.points ?? [String]()
                if discount.contains("50%") {
                    bestValueLabel.backgroundColor = UIColor.init(hexString: data.colorCode ?? "")
                    bestValueLabel.text = "bestValue".localized
                    bestValueLabel.isHidden = false
                    discountLableHeightAnchor.constant = 33
                } else {
                    bestValueLabel.isHidden = true
                    discountLableHeightAnchor.constant = 0
                }
                myFamilyLabel.text = lang.name ?? "FamilyTimePremium"
                upgradeButtonOutlet.setTitle(lang.cta ?? "", for: .normal)
                unlimitedDevicesLabel.text = points[0]
                childDeviceLabel.text = points[1]
                premiumFeaturesLabel.text = points[2]
                emailSupportLabel.text = points[3]
                unlimittedDeviceLbl.text = points[4]
                premierFeatureIncludeLbl.text = points[5]
                if points.count < 7{
                    lastImgTop.constant = 0
                    preiorityCustomerServiceLable.isHidden = true
                    startSevenImageView.isHidden = true
                }else{
                    preiorityCustomerServiceLable.text = points[6]
                }
                priceLable.text = "$\(data.price ?? "")\(lang.plan ?? "")"
                upgradeButtonOutlet.backgroundColor = UIColor.init(hexString: data.colorCode ?? "")
                discountLabel.text = "\("save_button".localized) \(data.discount ?? "")"
                priceLable.textColor = UIColor.init(hexString: data.accentColor ?? "")
                discountImageView.image = discountImageView.image?.withRenderingMode(.alwaysTemplate)
                discountImageView.tintColor = UIColor.init(hexString: data.colorCode ?? "")
                ftLogoImageView.image = ftLogoImageView.image?.withRenderingMode(.alwaysTemplate)
                ftLogoImageView.tintColor = UIColor.init(hexString: data.colorCode ?? "")
                startOneImageView.image = startOneImageView.image?.withRenderingMode(.alwaysTemplate)
                startOneImageView.tintColor = UIColor.init(hexString: data.accentColor ?? "")
                startTwoImageView.image = startTwoImageView.image?.withRenderingMode(.alwaysTemplate)
                startTwoImageView.tintColor = UIColor.init(hexString: data.accentColor ?? "")
                startThreeeImageView.image = startThreeeImageView.image?.withRenderingMode(.alwaysTemplate)
                startThreeeImageView.tintColor = UIColor.init(hexString: data.accentColor ?? "")
                startFourImageView.image = startFourImageView.image?.withRenderingMode(.alwaysTemplate)
                startFourImageView.tintColor = UIColor.init(hexString: data.accentColor ?? "")
                startFiveImageView.image = startFiveImageView.image?.withRenderingMode(.alwaysTemplate)
                startFiveImageView.tintColor = UIColor.init(hexString: data.accentColor ?? "")
                startSixImageView.image = startSixImageView.image?.withRenderingMode(.alwaysTemplate)
                startSixImageView.tintColor = UIColor.init(hexString: data.accentColor ?? "")
                startSevenImageView.image = startSevenImageView.image?.withRenderingMode(.alwaysTemplate)
                startSevenImageView.tintColor = UIColor.init(hexString: data.accentColor ?? "")
            } else {
                if lang.language == "en" {
                    let name = lang.name ?? ""
                    let points = lang.points ?? [String]()
                    if name.contains("Yearly") || name.contains("yearly") {
                        bestValueLabel.backgroundColor = UIColor.init(hexString: data.colorCode ?? "")
                        bestValueLabel.text = "bestValue".localized
                        
                        bestValueLabel.isHidden = false
                        discountLableHeightAnchor.constant = 33
                    } else if name.contains("Monthly") || name.contains("monthly") {
                        bestValueLabel.isHidden = true
                        discountLableHeightAnchor.constant = 0
                    } else {
                        bestValueLabel.isHidden = true
                        discountLableHeightAnchor.constant = 0
                    }
                    myFamilyLabel.text = lang.name ?? "FamilyTimePremium"
                    upgradeButtonOutlet.setTitle(lang.cta ?? "", for: .normal)
                    unlimitedDevicesLabel.text = points[0]
                    childDeviceLabel.text = points[1]
                    premiumFeaturesLabel.text = points[2]
                    emailSupportLabel.text = points[3]
                    unlimittedDeviceLbl.text = points[4]
                    premierFeatureIncludeLbl.text = points[5]
                    if points.count < 7{
                        lastImgTop.constant = 0
                        preiorityCustomerServiceLable.isHidden = true
                        startSevenImageView.isHidden = true
                    }else{
                        preiorityCustomerServiceLable.text = points[6]
                    }
                    priceLable.text = "$\(data.price ?? "")\(lang.plan ?? "")"
                    upgradeButtonOutlet.backgroundColor = UIColor.init(hexString: data.colorCode ?? "")
                    discountLabel.text = "\("save_button".localized) \(data.discount ?? "")"
                    priceLable.textColor = UIColor.init(hexString: data.accentColor ?? "")
                    discountImageView.image = discountImageView.image?.withRenderingMode(.alwaysTemplate)
                    discountImageView.tintColor = UIColor.init(hexString: data.colorCode ?? "")
                    ftLogoImageView.image = ftLogoImageView.image?.withRenderingMode(.alwaysTemplate)
                    ftLogoImageView.tintColor = UIColor.init(hexString: data.colorCode ?? "")
                    startOneImageView.image = startOneImageView.image?.withRenderingMode(.alwaysTemplate)
                    startOneImageView.tintColor = UIColor.init(hexString: data.accentColor ?? "")
                    startTwoImageView.image = startTwoImageView.image?.withRenderingMode(.alwaysTemplate)
                    startTwoImageView.tintColor = UIColor.init(hexString: data.accentColor ?? "")
                    startThreeeImageView.image = startThreeeImageView.image?.withRenderingMode(.alwaysTemplate)
                    startThreeeImageView.tintColor = UIColor.init(hexString: data.accentColor ?? "")
                    startFourImageView.image = startFourImageView.image?.withRenderingMode(.alwaysTemplate)
                    startFourImageView.tintColor = UIColor.init(hexString: data.accentColor ?? "")
                    startFiveImageView.image = startFiveImageView.image?.withRenderingMode(.alwaysTemplate)
                    startFiveImageView.tintColor = UIColor.init(hexString: data.accentColor ?? "")
                    startSixImageView.image = startSixImageView.image?.withRenderingMode(.alwaysTemplate)
                    startSixImageView.tintColor = UIColor.init(hexString: data.accentColor ?? "")
                    startSevenImageView.image = startSevenImageView.image?.withRenderingMode(.alwaysTemplate)
                    startSevenImageView.tintColor = UIColor.init(hexString: data.accentColor ?? "")
                }
            }
        }
    }
    
    func setUpCellForAppleTrialInternal(data: AppleInternalTrialData) {
        let userCurrentLanguage = SwiftCommonUtility.shared.getCurrentLanguageCode()
        let languages = data.languages ?? [AppleInternalLanguage]()
        for lang in languages {
            if userCurrentLanguage == lang.language {
                let discount = data.discount ?? ""
                let points = lang.points ?? [String]()
                if discount.contains("50%") || discount.contains("60%") {
                    bestValueLabel.backgroundColor = UIColor.init(hexString: data.colorCode ?? "")
                    bestValueLabel.text = "bestValue".localized
                    bestValueLabel.isHidden = false
                    discountLableHeightAnchor.constant = 33
                } else {
                    bestValueLabel.isHidden = true
                    discountLableHeightAnchor.constant = 0
                }
                myFamilyLabel.text = lang.name ?? "FamilyTimePremium"
                upgradeButtonOutlet.setTitle(lang.cta ?? "", for: .normal)
                unlimitedDevicesLabel.text = points[0]
                childDeviceLabel.text = points[1]
                premiumFeaturesLabel.text = points[2]
                emailSupportLabel.text = points[3]
                unlimittedDeviceLbl.text = points[4]
                premierFeatureIncludeLbl.text = points[5]
                if points.count < 7{
                    lastImgTop.constant = 0
                    preiorityCustomerServiceLable.isHidden = true
                    startSevenImageView.isHidden = true
                }else{
                    preiorityCustomerServiceLable.text = points[6]
                }
                priceLable.text = "$\(data.price ?? "")\(lang.plan ?? "")"
                upgradeButtonOutlet.backgroundColor = UIColor.init(hexString: data.colorCode ?? "")
                discountLabel.text = "\("save_button".localized) \(data.discount ?? "")"
                priceLable.textColor = UIColor.init(hexString: data.accentColor ?? "")
                discountImageView.image = discountImageView.image?.withRenderingMode(.alwaysTemplate)
                discountImageView.tintColor = UIColor.init(hexString: data.colorCode ?? "")
                ftLogoImageView.image = ftLogoImageView.image?.withRenderingMode(.alwaysTemplate)
                ftLogoImageView.tintColor = UIColor.init(hexString: data.colorCode ?? "")
                startOneImageView.image = startOneImageView.image?.withRenderingMode(.alwaysTemplate)
                startOneImageView.tintColor = UIColor.init(hexString: data.accentColor ?? "")
                startTwoImageView.image = startTwoImageView.image?.withRenderingMode(.alwaysTemplate)
                startTwoImageView.tintColor = UIColor.init(hexString: data.accentColor ?? "")
                startThreeeImageView.image = startThreeeImageView.image?.withRenderingMode(.alwaysTemplate)
                startThreeeImageView.tintColor = UIColor.init(hexString: data.accentColor ?? "")
                startFourImageView.image = startFourImageView.image?.withRenderingMode(.alwaysTemplate)
                startFourImageView.tintColor = UIColor.init(hexString: data.accentColor ?? "")
                startFiveImageView.image = startFiveImageView.image?.withRenderingMode(.alwaysTemplate)
                startFiveImageView.tintColor = UIColor.init(hexString: data.accentColor ?? "")
                startSixImageView.image = startSixImageView.image?.withRenderingMode(.alwaysTemplate)
                startSixImageView.tintColor = UIColor.init(hexString: data.accentColor ?? "")
                startSevenImageView.image = startSevenImageView.image?.withRenderingMode(.alwaysTemplate)
                startSevenImageView.tintColor = UIColor.init(hexString: data.accentColor ?? "")
            } else {
                if lang.language == "en" {
                    let name = lang.name ?? ""
                    let points = lang.points ?? [String]()
                    if name.contains("Yearly") || name.contains("yearly") {
                        bestValueLabel.backgroundColor = UIColor.init(hexString: data.colorCode ?? "")
                        bestValueLabel.text = "bestValue".localized
                        
                        bestValueLabel.isHidden = false
                        discountLableHeightAnchor.constant = 33
                    } else if name.contains("Monthly") || name.contains("monthly") {
                        bestValueLabel.isHidden = true
                        discountLableHeightAnchor.constant = 0
                    } else {
                        bestValueLabel.isHidden = true
                        discountLableHeightAnchor.constant = 0
                    }
                    myFamilyLabel.text = lang.name ?? "FamilyTimePremium"
                    upgradeButtonOutlet.setTitle(lang.cta ?? "", for: .normal)
                    unlimitedDevicesLabel.text = points[0]
                    childDeviceLabel.text = points[1]
                    premiumFeaturesLabel.text = points[2]
                    emailSupportLabel.text = points[3]
                    unlimittedDeviceLbl.text = points[4]
                    premierFeatureIncludeLbl.text = points[5]
                    if points.count < 7{
                        lastImgTop.constant = 0
                        preiorityCustomerServiceLable.isHidden = true
                        startSevenImageView.isHidden = true
                    }else{
                        preiorityCustomerServiceLable.text = points[6]
                    }
                    priceLable.text = "$\(data.price ?? "")\(lang.plan ?? "")"
                    upgradeButtonOutlet.backgroundColor = UIColor.init(hexString: data.colorCode ?? "")
                    discountLabel.text = "\("save_button".localized) \(data.discount ?? "")"
                    priceLable.textColor = UIColor.init(hexString: data.accentColor ?? "")
                    discountImageView.image = discountImageView.image?.withRenderingMode(.alwaysTemplate)
                    discountImageView.tintColor = UIColor.init(hexString: data.colorCode ?? "")
                    ftLogoImageView.image = ftLogoImageView.image?.withRenderingMode(.alwaysTemplate)
                    ftLogoImageView.tintColor = UIColor.init(hexString: data.colorCode ?? "")
                    startOneImageView.image = startOneImageView.image?.withRenderingMode(.alwaysTemplate)
                    startOneImageView.tintColor = UIColor.init(hexString: data.accentColor ?? "")
                    startTwoImageView.image = startTwoImageView.image?.withRenderingMode(.alwaysTemplate)
                    startTwoImageView.tintColor = UIColor.init(hexString: data.accentColor ?? "")
                    startThreeeImageView.image = startThreeeImageView.image?.withRenderingMode(.alwaysTemplate)
                    startThreeeImageView.tintColor = UIColor.init(hexString: data.accentColor ?? "")
                    startFourImageView.image = startFourImageView.image?.withRenderingMode(.alwaysTemplate)
                    startFourImageView.tintColor = UIColor.init(hexString: data.accentColor ?? "")
                    startFiveImageView.image = startFiveImageView.image?.withRenderingMode(.alwaysTemplate)
                    startFiveImageView.tintColor = UIColor.init(hexString: data.accentColor ?? "")
                    startSixImageView.image = startSixImageView.image?.withRenderingMode(.alwaysTemplate)
                    startSixImageView.tintColor = UIColor.init(hexString: data.accentColor ?? "")
                    startSevenImageView.image = startSevenImageView.image?.withRenderingMode(.alwaysTemplate)
                    startSevenImageView.tintColor = UIColor.init(hexString: data.accentColor ?? "")
                }
            }
        }
    }
    
    func setUpCellForFastSpringExternal(data: FastSpringExternalTrialData) {
        let userCurrentLanguage = SwiftCommonUtility.shared.getCurrentLanguageCode()
        let languages = data.languages ?? [FastSpringExternalLanguage]()
        for lang in languages {
            if userCurrentLanguage == lang.language {
                let discount = data.discount ?? ""
                let points = lang.points ?? [String]()
                if discount.contains("50%") || discount.contains("60%") {
                    bestValueLabel.backgroundColor = UIColor.init(hexString: data.colorCode ?? "")
                    bestValueLabel.text = "bestValue".localized
                    bestValueLabel.isHidden = false
                    discountLableHeightAnchor.constant = 33
                } else {
                    bestValueLabel.isHidden = true
                    discountLableHeightAnchor.constant = 0
                }
                myFamilyLabel.text = lang.name ?? "FamilyTimePremium"
                upgradeButtonOutlet.setTitle(lang.cta ?? "", for: .normal)
                unlimitedDevicesLabel.text = points[0]
                childDeviceLabel.text = points[1]
                premiumFeaturesLabel.text = points[2]
                emailSupportLabel.text = points[3]
                unlimittedDeviceLbl.text = points[4]
                premierFeatureIncludeLbl.text = points[5]
                if points.count < 7{
                    lastImgTop.constant = 0
                    preiorityCustomerServiceLable.isHidden = true
                    startSevenImageView.isHidden = true
                }else{
                    preiorityCustomerServiceLable.text = points[6]
                }
                priceLable.text = "$\(data.price ?? "")\(lang.plan ?? "")"
                upgradeButtonOutlet.backgroundColor = UIColor.init(hexString: data.colorCode ?? "")
                discountLabel.text = "\("save_button".localized) \(data.discount ?? "")"
                priceLable.textColor = UIColor.init(hexString: data.accentColor ?? "")
                discountImageView.image = discountImageView.image?.withRenderingMode(.alwaysTemplate)
                discountImageView.tintColor = UIColor.init(hexString: data.colorCode ?? "")
                ftLogoImageView.image = ftLogoImageView.image?.withRenderingMode(.alwaysTemplate)
                ftLogoImageView.tintColor = UIColor.init(hexString: data.colorCode ?? "")
                startOneImageView.image = startOneImageView.image?.withRenderingMode(.alwaysTemplate)
                startOneImageView.tintColor = UIColor.init(hexString: data.accentColor ?? "")
                startTwoImageView.image = startTwoImageView.image?.withRenderingMode(.alwaysTemplate)
                startTwoImageView.tintColor = UIColor.init(hexString: data.accentColor ?? "")
                startThreeeImageView.image = startThreeeImageView.image?.withRenderingMode(.alwaysTemplate)
                startThreeeImageView.tintColor = UIColor.init(hexString: data.accentColor ?? "")
                startFourImageView.image = startFourImageView.image?.withRenderingMode(.alwaysTemplate)
                startFourImageView.tintColor = UIColor.init(hexString: data.accentColor ?? "")
                startFiveImageView.image = startFiveImageView.image?.withRenderingMode(.alwaysTemplate)
                startFiveImageView.tintColor = UIColor.init(hexString: data.accentColor ?? "")
                startSixImageView.image = startSixImageView.image?.withRenderingMode(.alwaysTemplate)
                startSixImageView.tintColor = UIColor.init(hexString: data.accentColor ?? "")
                startSevenImageView.image = startSevenImageView.image?.withRenderingMode(.alwaysTemplate)
                startSevenImageView.tintColor = UIColor.init(hexString: data.accentColor ?? "")
                
            } else {
                if lang.language == "en" {
                    let name = lang.name ?? "FamilyTimePremium"
                    let points = lang.points ?? [String]()
                    if name.contains("Yearly") || name.contains("yearly") {
                        bestValueLabel.backgroundColor = UIColor.init(hexString: data.colorCode ?? "")
                        bestValueLabel.text = "bestValue".localized
                        
                        bestValueLabel.isHidden = false
                        discountLableHeightAnchor.constant = 33
                    } else if name.contains("Monthly") || name.contains("monthly") {
                        bestValueLabel.isHidden = true
                        discountLableHeightAnchor.constant = 0
                    } else {
                        bestValueLabel.isHidden = true
                        discountLableHeightAnchor.constant = 0
                    }
                    myFamilyLabel.text = lang.name ?? "FamilyTimePremium"
                    upgradeButtonOutlet.setTitle(lang.cta ?? "", for: .normal)
                    unlimitedDevicesLabel.text = points[0]
                    childDeviceLabel.text = points[1]
                    premiumFeaturesLabel.text = points[2]
                    emailSupportLabel.text = points[3]
                    unlimittedDeviceLbl.text = points[4]
                    premierFeatureIncludeLbl.text = points[5]
                    if points.count < 7{
                        lastImgTop.constant = 0
                        preiorityCustomerServiceLable.isHidden = true
                        startSevenImageView.isHidden = true
                    }else{
                        preiorityCustomerServiceLable.text = points[6]
                    }
                    priceLable.text = "$\(data.price ?? "")\(lang.plan ?? "")"
                    upgradeButtonOutlet.backgroundColor = UIColor.init(hexString: data.colorCode ?? "")
                    discountLabel.text = "\("save_button".localized) \(data.discount ?? "")"
                    priceLable.textColor = UIColor.init(hexString: data.accentColor ?? "")
                    discountImageView.image = discountImageView.image?.withRenderingMode(.alwaysTemplate)
                    discountImageView.tintColor = UIColor.init(hexString: data.colorCode ?? "")
                    ftLogoImageView.image = ftLogoImageView.image?.withRenderingMode(.alwaysTemplate)
                    ftLogoImageView.tintColor = UIColor.init(hexString: data.colorCode ?? "")
                    startOneImageView.image = startOneImageView.image?.withRenderingMode(.alwaysTemplate)
                    startOneImageView.tintColor = UIColor.init(hexString: data.accentColor ?? "")
                    startTwoImageView.image = startTwoImageView.image?.withRenderingMode(.alwaysTemplate)
                    startTwoImageView.tintColor = UIColor.init(hexString: data.accentColor ?? "")
                    startThreeeImageView.image = startThreeeImageView.image?.withRenderingMode(.alwaysTemplate)
                    startThreeeImageView.tintColor = UIColor.init(hexString: data.accentColor ?? "")
                    startFourImageView.image = startFourImageView.image?.withRenderingMode(.alwaysTemplate)
                    startFourImageView.tintColor = UIColor.init(hexString: data.accentColor ?? "")
                    startFiveImageView.image = startFiveImageView.image?.withRenderingMode(.alwaysTemplate)
                    startFiveImageView.tintColor = UIColor.init(hexString: data.accentColor ?? "")
                    startSixImageView.image = startSixImageView.image?.withRenderingMode(.alwaysTemplate)
                    startSixImageView.tintColor = UIColor.init(hexString: data.accentColor ?? "")
                    startSevenImageView.image = startSevenImageView.image?.withRenderingMode(.alwaysTemplate)
                    startSevenImageView.tintColor = UIColor.init(hexString: data.accentColor ?? "")
                }
            }
        }
    }
    
    func addShadow(_ view : UIView){
        view.layer.shadowOffset = CGSize(width:0, height:0)
        view.layer.shadowRadius = 10
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, a: 0.2).cgColor
        view.layer.shadowOpacity = 0.3
    }
}
