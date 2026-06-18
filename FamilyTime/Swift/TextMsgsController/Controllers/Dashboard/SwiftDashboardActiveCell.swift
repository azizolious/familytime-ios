//
//  SwiftDashboardActiveCell.swift
//  FamilyTime
//
//  Created by YumyApps on 05/11/2021.
//  Copyright © 2021 YumyApps. All rights reserved.
//

import UIKit
import MBProgressHUD
import MBCircularProgressBar

//MARK: - Protocols
protocol SwiftDashboardActiveCellDelegate {
    func handleReports(with child: Child)
    func handleSettings(with child: Child)
    func handleUpgrade(with child: Child, indexPath : IndexPath)
    func handleLock(with child: Child)
    func handleExpired()
    func handleActiveMenu(with child: Child, with btn: UIButton?, with indexPath: IndexPath?)
    func handleActivePair(with child: Child, with btn: UIButton?, with indexPath: IndexPath?)
    func handleZeroProgress(with child: Child,status: Int) //---TAKE USER TO DAILY LIMIT SCREEN IF 00 DAILY LIMIT---//
    func handleProgress(with child: Child) //---GET LATEST APP USAGE IF DAILY LIMIT IS NOT 00---//
    func handleProfileAction(with child: Child)
    
}

//MARK: - Classes
class SwiftDashboardActiveCell: UITableViewCell {
    //MARK: - IBOutlets
    @IBOutlet weak var cellContainerView: UIView!
    @IBOutlet weak var leftContainer: UIView!
    @IBOutlet weak var centerContainer: UIView!
    @IBOutlet weak var rightContainer: UIView!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var centerImageView: UIImageView!
    @IBOutlet weak var rightImageView: UIImageView!
    
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var centerLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var expiredVu: UIView!
    @IBOutlet weak var subscriptoinExpiredLbl: UILabel!
    @IBOutlet weak var progressVu: MBCircularProgressBarView!
    @IBOutlet weak var hourMintLbl: UILabel!
    @IBOutlet weak var timeLeftLbl: UILabel!
    @IBOutlet weak var pairBtn: UIButton!
    
    @IBOutlet weak var menuBtnTrailingConst: NSLayoutConstraint!
    @IBOutlet weak var menuBtnTopConst: NSLayoutConstraint!
//    @IBOutlet weak var pairBtnBottomConst: NSLayoutConstraint!
    @IBOutlet weak var pairBtnLeadingConst: NSLayoutConstraint!
    @IBOutlet weak var expiredVuCenterVerticallyConst: NSLayoutConstraint!
    @IBOutlet weak var progressVuCenterVerticallyConst: NSLayoutConstraint!
    @IBOutlet weak var avatarTopSpace: NSLayoutConstraint!
    @IBOutlet weak var nameLeadingConst: NSLayoutConstraint!
    @IBOutlet weak var menuBtnWidthConst: NSLayoutConstraint!
    @IBOutlet weak var menuBtnHeightConst: NSLayoutConstraint!
    @IBOutlet weak var pairBtnWidthConst: NSLayoutConstraint!
    @IBOutlet weak var pairBtnHeightConst: NSLayoutConstraint!
    @IBOutlet weak var expiredIconCenterConst: NSLayoutConstraint!
    @IBOutlet weak var expiredVuWidthConst: NSLayoutConstraint!
    @IBOutlet weak var expiredVuHeightConst: NSLayoutConstraint!
    @IBOutlet weak var avatarWidth: NSLayoutConstraint!
    @IBOutlet weak var avatarHeight: NSLayoutConstraint!
//    @IBOutlet weak var rightImageLeading: NSLayoutConstraint!
    @IBOutlet weak var rightContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var rightImageHeight: NSLayoutConstraint!
    @IBOutlet weak var rightImageWidth: NSLayoutConstraint!
//    @IBOutlet weak var centerLabelLeading: NSLayoutConstraint!
//    @IBOutlet weak var centerImageLeading: NSLayoutConstraint!
    @IBOutlet weak var centerContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var centerImageHeight: NSLayoutConstraint!
    @IBOutlet weak var centerImageWidth: NSLayoutConstraint!
//    @IBOutlet weak var leftLabelLeading: NSLayoutConstraint!
//    @IBOutlet weak var leftImageLeftMargin: NSLayoutConstraint!
    @IBOutlet weak var leftContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var leftImageHeight: NSLayoutConstraint!
    @IBOutlet weak var leftImageWidth: NSLayoutConstraint!
    @IBOutlet weak var progressVuHeightConst: NSLayoutConstraint!
    @IBOutlet weak var progressVuWidthConst: NSLayoutConstraint!
    
    //MARK: - Variables
        var nameLabelTopSpace = NSLayoutConstraint()
        var packageLabelTopSpace = NSLayoutConstraint()
        var rightLabelLeading = NSLayoutConstraint()
        var cellIndexPath: IndexPath?
        var rightTapGesture = UITapGestureRecognizer()
        var expiredGesture = UITapGestureRecognizer()
        var zeroProgressGesture = UITapGestureRecognizer()
    //    var child: DashboardChild?
        var newChildData: Child?
        var delegate = UIApplication.shared.delegate as? AppDelegate
        var cellDelegate: SwiftDashboardActiveCellDelegate?
        
        //MARK: - View Life Cycles
        override func awakeFromNib() {
            super.awakeFromNib()
            setUpUI()
        }
        
        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
        }
        
        //MARK: - Helper Functions
        func setChild(_ child: Child) {
            leftLabel.text = NSLocalizedString("dashboard_child_card_horizontal_tab_1", comment: "")
            centerLabel.text = NSLocalizedString("dashboard_child_card_horizontal_tab_2", comment: "")
            subscriptoinExpiredLbl.text = NSLocalizedString("dashboard_child_card_child_free_content", comment: "")
            //        self.child = child
            self.newChildData = child
            avatarImageView.image = UIImage(named: (child.gender?.lowercased() == "male") ? "avatar_boy1" : "avatar_girl1")
            nameLabel.text = child.name
            self.handleActiveInactive(child)
            //---ADD LOCK GESTURE---WILL BE OVERIDE IF ITS UPDATE----//
            rightTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleLock(_:)))
            rightContainer.addGestureRecognizer(rightTapGesture)
            //---SHOW/HIDE SUBSCRIPTION VIEW AND COLOR---//
            // MARK: comment this check for temporary
//            if child.packageID == 1 || child.packageID == 6 {
            if child.planID == 1 {
                cellContainerView.backgroundColor = CommonModel.color(fromHexString: kDarkGray)
                expiredVu.isHidden = false
                progressVu.isHidden = true
                rightImageView.image = UIImage(named: "ic_upgrade")
                rightLabel.text = NSLocalizedString("dashboard_child_card_horizontal_tab_3_content_3", comment: "")
                rightLabel.textColor = KDashboardRedColor()
                expiredGesture = UITapGestureRecognizer(target: self, action: #selector(handleUpgrade(_:)))
                rightTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleUpgrade(_:)))
                expiredVu.addGestureRecognizer(expiredGesture)
                rightContainer.addGestureRecognizer(rightTapGesture)
            } else {
                cellContainerView.backgroundColor = CommonModel.color(fromHexString: child.color)
                expiredVu.isHidden = true
                let agentStatus = child.agent ?? ""
                if agentStatus == "android"{
                    
                    let planID = child.planID ?? 0
                    let plans = DBManager.shared.fetchPlans(byPlanID: planID)
                    for plan in plans{
                        if plan.identifier == "family_pause"{
                            if plan.androidReleased == 0 {
                                rightContainer.isHidden = true
                            }else if plan.androidReleased == 1{
                                rightContainer.isHidden = false
                            }
                        }
                    }
                    handleAndroidCase(with: child)
                    if child.childEnrolled == 1 {
                        pairBtn.setImage(UIImage(named: "ic_pair"), for: .normal)
                    } else {
                        pairBtn.setImage(UIImage(named: "ic_not_pair"), for: .normal)
                    }
                } else {
                    //---IOS CASE---//
                    progressVu.isHidden = true
                    let planID = child.planID ?? 0
                    let plans = DBManager.shared.fetchPlans(byPlanID: planID)
                    for plan in plans{
                        if plan.identifier == "family_pause"{
                            if plan.iosReleased == 0 {
                                rightContainer.isHidden = true
                            }else if plan.iosReleased == 1{
                                rightContainer.isHidden = false
                            }
                        }
                    }
                    if child.childEnrolled == 1 {
                        pairBtn.setImage(UIImage(named: "ic_pair"), for: .normal)
                    } else {
                        pairBtn.setImage(UIImage(named: "ic_not_pair"), for: .normal)
                        
                    }
                }
                
//                ---ANDROID = 1 OR IOS = 2---//
//                if child.plateformID == 1 {
//                    handleAndroidCase(with: child)
//                    if child.active == 1 {
//                        pairBtn.setImage(UIImage(named: "ic_pair"), for: .normal)
//                    } else {
//                        pairBtn.setImage(UIImage(named: "ic_not_pair"), for: .normal)
//                    }
//                } else {
//                    //---IOS CASE---//
//                    progressVu.isHidden = true
//                    if child.childEnrolled == 1 {
//                        pairBtn.setImage(UIImage(named: "ic_pair"), for: .normal)
//                    } else {
//                        pairBtn.setImage(UIImage(named: "ic_not_pair"), for: .normal)
//                        
//                    }
//                }
            }
        }
        
        func setUpUI() {
            cellContainerView.layer.cornerRadius = 5.0
            cellContainerView.layer.masksToBounds = true
            selectionStyle = .none
            centerContainer.selectiveBorderFlag = UInt(AUISelectiveBordersFlagRight | AUISelectiveBordersFlagLeft)
            centerContainer.selectiveBordersColor = UIColor.lightGray.withAlphaComponent(0.5)
            centerContainer.selectiveBordersWidth = 0.0
            expiredVu.layer.borderColor = UIColor(red: 68 / 255.0, green: 68 / 255.0, blue: 68 / 255.0, alpha: 1.0).cgColor
            expiredVu.layer.borderWidth = 2.0
            if !SwiftFTUtils.isDeviceiPhoneFamily() {
                nameLabel.font = UIFont(name: "OpenSans-Light", size: 18)
                leftLabel.font = UIFont(name: "OpenSans-Light", size: 18)
                rightLabel.font = UIFont(name: "OpenSans-Light", size: 18)
                centerLabel.font = UIFont(name: "OpenSans-Light", size: 18)
                timeLeftLbl.font = UIFont(name: "Dosis-Regular", size: 16)
                hourMintLbl.font = UIFont(name: "Dosis-Regular", size: 16)
                subscriptoinExpiredLbl.font = UIFont(name: "Dosis-Regular", size: 16)
                avatarTopSpace.constant = 12
                avatarWidth.constant = 45
                avatarHeight.constant = 45
//                leftContainerHeight.constant = 75
//                rightContainerHeight.constant = 75
//                centerContainerHeight.constant = 75
//                leftImageWidth.constant = 48
//                leftImageHeight.constant = 48
//                centerImageWidth.constant = 48
//                centerImageHeight.constant = 48
//                rightImageWidth.constant = 48
//                rightImageHeight.constant = 48
//                leftImageLeftMargin.constant = 45
//                leftLabelLeading.constant = 10
//                centerImageLeading.constant = 45
//                centerLabelLeading.constant = 10
//                rightImageLeading.constant = 45
//                rightLabelLeading.constant = 10
//                expiredVuHeightConst.constant = 200
//                expiredVuWidthConst.constant = 200
//                expiredVu.layer.cornerRadius = 100
//                progressVuWidthConst.constant = 200
//                progressVuHeightConst.constant = 200
                self.progressVuCenterVerticallyConst.constant = -35;
                self.expiredVuCenterVerticallyConst.constant  = -35;
                self.pairBtnWidthConst.constant     = 30;
                self.pairBtnHeightConst.constant    = 30;
                if let menuBtnWidthConst = self.menuBtnWidthConst {
                    menuBtnWidthConst.constant = 30;
                }
                if let menuBtnHeightConst = self.menuBtnHeightConst {
                    menuBtnHeightConst.constant = 30;
                }
                self.pairBtnLeadingConst.constant   = 20;
//                self.pairBtnBottomConst.constant    = 20;
                if let menuBtnTopConst = self.menuBtnTopConst {
                    menuBtnTopConst.constant = 20;
                }
                if let menuBtnTrailingConst = self.menuBtnTrailingConst {
                    menuBtnTrailingConst.constant = 14
                }
                nameLeadingConst.constant = 20
            }
            let reportsTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleReports(_:)))
            leftContainer.addGestureRecognizer(reportsTapGesture)
            let settingsTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSettings(_:)))
            centerContainer.addGestureRecognizer(settingsTapGesture)
        }
        
        //MARK: - Custom Methods
        func handleActiveInactive(_ child: Child) {
//            if child.childInfo?.agent != StringConstants.Constants.IOS {
                let control = DBManager.shared.fetchControlWithChildID(childID: child.childID ?? 0, identifier: "family_pause")
                //if child.childInfo?.phonelockStatus == 0{
                let state = control.state ?? 0
                if state == 0 {
                    rightImageView.image = UIImage(named: "ic_unpause")
                    rightLabel.text = NSLocalizedString("dashboard_child_card_horizontal_tab_3_content_1", comment: "")
                    rightLabel.textColor = KDashboardGreyBtnColor()
                } else {
                    rightImageView.image = UIImage(named: "ic_pause")
                    rightLabel.text = NSLocalizedString("dashboard_child_card_horizontal_tab_3_content_2", comment: "")
                    rightLabel.textColor = KDashboardRedColor()
                }

        }
        
        func handleAndroidCase(with child: Child) {
            progressVu.isHidden = false
//            if let dailyLimit = child.dailyLimit {
//                print("dailyLimit = \(dailyLimit)")
//            }
            
            if child.active == 0 {
                timeLeftLbl.text = NSLocalizedString("dashboard_child_card_daily_limit_content_2".localized, comment: "")
                timeLeftLbl.textColor = timeLeftLbl.textColor.withAlphaComponent(0.7)
                showZeroProgress()
            } else {
                //MARK: CHECKING DAILY LIMITS
                if child.active != nil{
                    timeLeftLbl.text = NSLocalizedString("dashboard_child_card_daily_limit_content_1".localized, comment: "")
                    timeLeftLbl.textColor = timeLeftLbl.textColor.withAlphaComponent(1.0)
                    if child.childID != nil{
                        self.setProgressFor(child)
                    }
                } else {
                    progressVu.value = 0
                    progressVu.fontColor = progressVu.fontColor.withAlphaComponent(0.7)
                    hourMintLbl.text = "00" + "time_hours".localized + " : " + "00" + "time_mintues".localized
                    hourMintLbl.textColor = hourMintLbl.textColor.withAlphaComponent(0.7)
                    zeroProgressGesture = UITapGestureRecognizer(target: self, action: #selector(handleZeroProgress(_:)))
                    progressVu.addGestureRecognizer(zeroProgressGesture)
                }
                
            }
        }
        
//        func setProgressFor(_ child: ChildData) {
//            // MASLA
//            let result : Float = Float(((child.dailyLimit?.remainingLimit ?? 0) * 100) / (child.dailyLimit?.duration ?? 0))
//            if let remaining_limit = child.dailyLimit?.remainingLimit, let duration = child.dailyLimit?.duration {
//                print("remainingLimit = \(remaining_limit) duration = \(duration) and final result = \(result), \(child.childInfo?.name ?? "")")
//            }
//            //---LOWER BOUND CHECK---//---IF MINUS THEN SHOW 0---//
//            if result < 0 || result != result {
//                showZeroProgress()
//            } else {
//                showNonZeroProgress(withResult: result, andChild: child)
//            }
//        }
    func setProgressFor(_ child: Child) {
        let control = DBManager.shared.fetchControlWithChildID(childID: child.childID ?? 0, identifier: "daily_app_limit")
        let state = control.state
        let dailyLimit = DBManager.shared.getDailyLimit(childID: child.childID ?? 0)
        
        
//         Ensure `duration` is not zero to prevent division by zero
        let duration = dailyLimit.duration ?? 0
        guard duration != 0 else {
            showZeroProgress()
            return
        }

        // Calculate result safely
        let remainingLimit = dailyLimit.remainingLimit ?? 0
        let result: Float = Float((remainingLimit * 100) / duration)

        // Print debug information
        if let name = child.name {
            print("remainingLimit = \(remainingLimit) duration = \(duration) and final result = \(result), \(name)")
        }

        //---LOWER BOUND CHECK---//---IF MINUS THEN SHOW 0---//
        if state == 0 {
            showZeroProgress()
        } else {
            showNonZeroProgress(withResult: result, andChild: child, remainingLimit: remainingLimit)
        }
    }

        func showZeroProgress() {
            progressVu.value = 0
            progressVu.fontColor = progressVu.fontColor.withAlphaComponent(0.7)
            hourMintLbl.text = "00" + "time_hours".localized + " : " + "00" + "time_mintues".localized
            hourMintLbl.textColor = hourMintLbl.textColor.withAlphaComponent(0.7)
            zeroProgressGesture = UITapGestureRecognizer(target: self, action: #selector(handleZeroProgress(_:)))
            progressVu.addGestureRecognizer(zeroProgressGesture)
        }
        
    func showNonZeroProgress(withResult result: Float, andChild child: Child,remainingLimit : Int) {
            var result = result
            print("result = \(result)")
            if result > 100 {
                result = 100
            }
            progressVu.value = CGFloat(result)
            progressVu.fontColor = progressVu.fontColor.withAlphaComponent(1.0)
            hourMintLbl.text = CommonModel.getHoursMinutes(fromSeconds: Int(remainingLimit))
            hourMintLbl.textColor = hourMintLbl.textColor.withAlphaComponent(1.0)
            zeroProgressGesture = UITapGestureRecognizer(target: self, action: #selector(handleZeroProgress(_:)))
            progressVu.addGestureRecognizer(zeroProgressGesture)
        }
        
        //MARK: - Delegates Methods
        @objc func handleReports(_ sender: UIGestureRecognizer?) {
            if sender?.state == .ended {
                if let child = newChildData {
                    cellDelegate?.handleReports(with: child)
                }
            }
        }
        
        @objc func handleSettings(_ sender: UIGestureRecognizer?) {
            if sender?.state == .ended {
                if let child = newChildData {
                    cellDelegate?.handleSettings(with: child)
                }
            }
        }
        
        @objc func handleUpgrade(_ sender: UIGestureRecognizer?) {
            if sender?.state == .ended {
                if let child = newChildData {
                    cellDelegate?.handleUpgrade(with: child, indexPath: cellIndexPath ?? IndexPath())
                }
            }
        }
        
        // handleZeroProgress
        @objc func handleZeroProgress(_ sender: UIGestureRecognizer?) {
            if sender?.state == .ended {
                
                if let child = newChildData {
                    let planID = (child.planID) ?? 0
                    let plans = DBManager.shared.fetchPlans(byPlanID: planID)
                    for plan in plans{
                        if plan.identifier == "daily_app_limit"{
                            let status = plan.status
                            cellDelegate?.handleZeroProgress(with: child, status: Int(status))
                        }
                    }
                    
                }
            }
        }
        
        @objc func handleDailyLimitProgress(_ sender: UIGestureRecognizer?) {
            if let child = newChildData {
                cellDelegate?.handleProgress(with: child)
            }
        }
        
        @objc func handleLock(_ sender: UIGestureRecognizer?) {
            if sender?.state == .ended {
                if let childInfo = newChildData {
                    cellDelegate?.handleLock(with: childInfo)
                }
            }
        }
        
        func handleExpired(_ sender: UIGestureRecognizer?) {
            if sender?.state == .ended {
                cellDelegate?.handleExpired()
            }
        }
        
//        @IBAction func topMenuAction(_ sender: UIButton) {
//            if let child = newChildData {
//                cellDelegate?.handleActiveMenu(with: child, with: sender, with: cellIndexPath)
//            }
//        }
        
        @IBAction func pairActoin(_ sender: UIButton) {
            if let child = newChildData {
                cellDelegate?.handleActivePair(with: child, with: sender, with: cellIndexPath)
            }
        }
        
        @IBAction func invisibleProfileAction(_ sender: Any) {
            if let child = newChildData {
                cellDelegate?.handleProfileAction(with: child)
            }
        }
    }
