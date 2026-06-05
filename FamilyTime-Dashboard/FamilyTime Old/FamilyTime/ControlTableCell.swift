//
//  ControlTableCell.swift
//  FamilyTime
//
//  Created by Sufyan on 13/10/2023.
//  Copyright © 2023 YumyApps. All rights reserved.
//

import UIKit

class ControlTableCell: UITableViewCell {
    
    @IBOutlet weak var controlImg: UIImageView!
    @IBOutlet weak var titleLBl: UILabel!
    @IBOutlet weak var descrLbl: UILabel!
    @IBOutlet weak var premiumImg: UIImageView!
    @IBOutlet weak var arrowImg: UIImageView!
    @IBOutlet weak var controlSwitch: UISwitch!
    
    let versionNumber = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_VERSION_NUMBER) ?? ""

    var con: ControlModel? = nil
    var callback: ((ControlModel, Bool)->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Setup switch action
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        // Reset the state of the cell
        controlSwitch.alpha = 1.0
        if versionNumber.contains(".ps") {
            
            if con?.identifier == "call_logs" {
                controlSwitch.isEnabled = false
                controlSwitch.isOn = false
            } else {
                controlSwitch.isEnabled = true
            }
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setfamilyCareUI(control: ControlModel) {
        self.con = control
        titleLBl.text = control.title
        descrLbl.text = control.description
        controlImg.image = UIImage(named: control.imgName)
        controlSwitch.isHidden = !control.isSwitch
        if control.isPremiumPkg() {
//            premiumImg.isHidden = true
            arrowImg.isHidden = false
        }else {
//            premiumImg.isHidden = false
            arrowImg.isHidden = true
        }
        setStatusImageIfNeeded(status: control.status)
    }
  
       
    func setCellUI(control: ControlModel) {
        self.con = control
//        controlSwitch.isEnabled = control.isPremiumPkg()
        titleLBl.text = control.title
        descrLbl.text = control.description
        controlImg.image = UIImage(named: control.imgName)
        if control.isPremiumPkg() {
            controlSwitch.isOn = control.isOn
            arrowImg.isHidden = control.isSwitch
        } else {
            controlSwitch.isOn = false
            arrowImg.isHidden = true
        }
        controlSwitch.isHidden = !control.isSwitch
            
        // Handle conditional switch disabling
        if versionNumber.contains(".ps") {
            
            guard self.con?.identifier == control.identifier else { return }
            self.controlSwitch.isEnabled = control.identifier != "call_logs" // Disable for `call_logs`
        }

        if control.identifier == "low_battery"  || control.identifier == "apps_list" {
//            premiumImg.isHidden = true
            controlSwitch.isEnabled = true
            controlSwitch.isOn = control.isOn
        } else {
//            premiumImg.isHidden = control.isPremiumPkg()
        }
//        if control.identifier == "sm" || control.identifier == "sms" || control.identifier == "social_monitoring" {
//            if !control.isPremiumOnly() {
//                premiumImg.isHidden = false
//                arrowImg.isHidden = true
//                controlSwitch.isEnabled = false
//                controlSwitch.isOn = false
//            }
            //               else {
            //               if control.isPremiumPkg() {
            //                   controlSwitch.isOn = control.isOn
            //                   arrowImg.isHidden = control.isSwitch
            //               } else {
            //                   premiumImg.isHidden = false
            //                   arrowImg.isHidden = false
            //                   controlSwitch.isOn = false
            //                   controlSwitch.isEnabled = false
            //               }
            //           }
//        }
        if control.status == 0 {
            controlSwitch.alpha = 0.5
            } else {
                controlSwitch.alpha = 1.0
            }
        setStatusImageIfNeeded(status: control.status)
    }
    func setStatusImageIfNeeded(status: Int) {
//        let statusImageView = AddImage.addImageView(to: titleLBl, imageName: "top")
           if status == 0 {
               premiumImg.isHidden = false
           } else {
               premiumImg.isHidden = true
           }
       }
    func deleteSection() {
        titleLBl.text = "dashboard_child_card_drop_down_option_3".localized
        descrLbl.text = "delete_desc".localized
        controlImg.image = UIImage(named: "delChild")
        arrowImg.isHidden = true
        controlSwitch.isHidden = true
        premiumImg.isHidden = true
    }
    func deviceSetUi(control: ControlModel) {
        self.con = control
        titleLBl.text = control.title
        descrLbl.text = control.description
        controlImg.image = UIImage(named: control.imgName)
        controlSwitch.isOn = control.isOn
        controlSwitch.isHidden = !control.isSwitch
        premiumImg.isHidden = true
        controlSwitch.isEnabled = true
        
    }
    
    @IBAction func controlSwitch(_ sender: UISwitch) {
        guard let control = con else { return }
        if versionNumber.contains(".ps") {
            if control.identifier == "call_logs" {
                sender.isOn = false // Reset switch to off
                return
            }
        }
        callback?(con!, sender.isOn)
    }
}
