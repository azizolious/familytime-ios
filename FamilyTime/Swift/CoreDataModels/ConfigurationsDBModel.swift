//
//  ConfigurationsDBModel.swift
//  FamilyTime
//
//  Created by Usama-Apps on 12/09/2022.
//  Copyright © 2022 YumyApps. All rights reserved.
//

import Foundation

class ConfigurationsDBModel : NSObject {
    
    var id: String?
    var configName: String?
    var configValue: String?
    var keyValue: String?
    var plateformID: String?
    var plateform: String?
    var active: String?
    var createdAt, updatedAt: String?
    
    init(id: String?, configName: String?, configValue: String?, keyValue: String?, plateformID: String?, plateform: String?, active: String?, createdAt: String?, updatedAt: String?) {
        self.id = id
        self.configName = configName
        self.configValue = configValue
        self.keyValue = keyValue
        self.plateformID = plateformID
        self.plateform = plateform
        self.active = active
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
