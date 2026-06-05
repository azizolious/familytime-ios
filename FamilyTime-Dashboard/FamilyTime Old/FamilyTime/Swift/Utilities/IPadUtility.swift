//
//  IPadUtility.swift
//  FamilyTime
//
//  Created by Sana Ullah on 29/01/2019.
//  Copyright © 2019 YumyApps. All rights reserved.
//

import Foundation

class IPadUtility{
    
    
    static let shared = IPadUtility()
    
    func updateConstraintsForIAP(vc : SubscriptionVC){
        vc.chooseLbl_topConst.constant  = 30
        vc.chooseLbl_leadConst.constant = 30
        vc.chooseLbl_bottomConst.constant = 30
        
        vc.chooseLbl.font = UIFont(name: "OpenSans-Semibold", size: 21)
    }
    
}
