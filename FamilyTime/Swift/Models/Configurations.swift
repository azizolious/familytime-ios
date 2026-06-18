//
//  Configurations.swift
//  FamilyTime
//
//  Created by Usama-Apps on 08/09/2022.
//  Copyright © 2022 YumyApps. All rights reserved.
//

import Foundation

// MARK: - Configurations
class Configurations: NSObject,Codable {
    var configurations: [Configuration]?
    
    init(configurations: [Configuration]?) {
        self.configurations = configurations
    }
}
// MARK: - Configuration
class Configuration: NSObject,Codable {
    var id: Int?
    var configName: String?
    var keyValue: String?
    var plateformID: Int?
    var plateform: String?
    var active: Int?
    var createdAt, updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case configName = "config_key"
        case keyValue = "config_value"
        case plateformID = "plateform_id"
        case plateform, active
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    init(id: Int?, configName: String?, keyValue: String?, plateformID: Int?, plateform: String?, active: Int?, createdAt: String?, updatedAt: String?) {
        self.id = id
        self.configName = configName
        self.keyValue = keyValue
        self.plateformID = plateformID
        self.plateform = plateform
        self.active = active
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
