//
//  HomeDatabaseResponse.swift
//  FamilyTime
//
//  Created by Usama-Apps on 08/12/2022.
//  Copyright © 2022 YumyApps. All rights reserved.
//

import Foundation

class HomeDatabaseResponse : NSObject {
    var coParent: [CoParent]?
    var childInfo: ChildInfo?
    var preferences: [PreferenceData]?
    var dailyLimit: DailyLimit?
    
    init(coParent:[CoParent]?, childInfo:ChildInfo?, preferences:[PreferenceData]?, dailyLimit:DailyLimit?) {
        self.coParent = coParent
        self.dailyLimit = dailyLimit
        self.preferences = preferences
        self.childInfo = childInfo
    }
}
