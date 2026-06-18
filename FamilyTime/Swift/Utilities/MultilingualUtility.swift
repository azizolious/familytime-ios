//
//  MultilingualUtility.swift
//  FamilyTime
//
//  Created by Sana Ullah on 30/01/2019.
//  Copyright © 2019 YumyApps. All rights reserved.
//

import Foundation

class MultilingualUtility {
    
    static let shared = MultilingualUtility()
    
    func lingualForIAPDetail(vc:SubscriptionVC){
        vc.navigationItem.title   = "in_app_purchase_title".myModification()
        vc.groupNameLbl.text      = "FamilyTime Premium".myModification()
        vc.groupDescLbl.text      = "in_app_purchase_content_5".myModification()
        vc.chooseLbl.text         = "in_app_purchase_content_1".myModification()
        vc.renewLbl.text          = "in_app_purchase_content_6".myModification()
        vc.upgradeBtn.setTitle("dashboard_child_card_horizontal_tab_3_content_3".myModification(), for: .normal)
    }
    
    func lingualForAddRule(vc:AddRuleVC){
        vc.startTimeTitleLbl.text = "Start Time".myModification()
        vc.endTimeTitleLbl.text   = "End Time".myModification()
        vc.enableLbl.text         = "Enable Rule".myModification()
        vc.weekDayLbl.text        = "Week Days".myModification()
    }
    
    func lingualForDevice(vc:DeviceVC){
        vc.deviceInfoLbl.text   = "Device Information".myModification()
        vc.manufacturerNameLabel.text   = "Device Name".myModification()
        vc.manufacturerNameLabel.text  = "Manufacturer".myModification()
        vc.languageNameLabel.text        = "Model".myModification()
        vc.timeZoneNameLabel.text     = "Device OS".myModification()
        vc.batteryNameLabel.text     = "Language".myModification()
        vc.wifiNameLabel.text     = "Timezone".myModification()
        vc.appInfoLbl.text      = "App Information".myModification()
        vc.appVersionLbl.text   = "App Version".myModification()
        vc.buildLbl.text        = "Build".myModification()
        vc.helpDeskLbl.text     = "Help Desk".myModification()
    }
}
