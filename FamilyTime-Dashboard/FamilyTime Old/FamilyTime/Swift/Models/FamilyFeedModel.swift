//
//  FamilyFeedModel.swift
//  FamilyTime
//
//  Created by Sufyan on 22/07/2024.
//  Copyright © 2024 YumyApps. All rights reserved.
//

import Foundation

struct FamilyFeedModel: Codable {
    let data: [Datum]?
}

// MARK: - Datum
struct Datum: Codable {
    let id, childID: Int?
    let type, data, requestedTime, createdAt: String?
    enum CodingKeys: String, CodingKey {
        case id
        case childID = "child_id"
        case type, data
        case requestedTime = "requested_time"
        case createdAt = "created_at"
    }
}

struct SOSData: Decodable {
    struct DataContent: Decodable {
        let device_id: String?
        let device_name: String?
        let accuracy: String?
        let latitude: String?
        let longitude: String?
        let push_time: String?
        let address: String?
        let subtype: String?
    }
    
    let id: Int?
    let child_id: Int?
    let type: String?
    let requested_time: String?
    let created_at: String?
    let data: String?  // JSON string that needs to be decoded separately
}


struct BatteryData: Decodable {
    let subtype: String?
    let device_name: String?
    let device_id: String?
    let requested_time: String?
    let percent: String?
}


struct PlaceData: Decodable {
    let place_name: String?
    let device_id: String?
    let device_name: String?
    let accuracy: String?
    let latitude: String?
    let longitude: String?
    let push_time: String?
    let address: String?
    let subtype: String?
}


struct AppApprove: Decodable {
    let subtype: String?
    let device_name: String?
    let app_name: String?
}


struct PreviousAppApprove: Decodable {
    let subtype: String?
    let app_name: String?
    let app_package: String?
    let device_id: String?
    let device_name: String?
    let requested_time: String?
    let app_icon: String?
    let device_avatar: String?
}

struct ChargingStartedData: Decodable {
    struct DataContent: Decodable {
        let subtype: String?
        let device_name: String?
        let device_id: String?
        let requested_time: String?
        let percent: String?
    }
    
    let id: Int?
    let child_id: Int?
    let type: String?
    let requested_time: String?
    let data: DataContent?
}

struct UninstallAppData: Decodable {
    struct DataContent: Decodable {
        let device_name: String?
        let app_name: String?
    }
    
    let id: Int?
    let child_id: Int?
    let type: String?
    let requested_time: String?
    let data: DataContent?
}

struct UnblockAppRequestData: Decodable {
    struct DataContent: Decodable {
        let subtype: String?
        let app_name: String?
        let app_package: String?
        let device_id: String?
        let device_name: String?
        let requested_time: String?
        let app_icon: String?
        let device_avatar: String?
    }
    
    let id: Int?
    let child_id: Int?
    let type: String?
    let requested_time: String?
    let data: DataContent?
}

struct PreviousAppApproveData: Decodable {
    struct DataContent: Decodable {
        let subtype: String?
        let app_name: String?
        let app_package: String?
        let device_id: String?
        let device_name: String?
        let requested_time: String?
        let app_icon: String?
        let device_avatar: String?
    }
    
    let id: Int?
    let child_id: Int?
    let type: String?
    let requested_time: String?
    let data: DataContent?
}

struct NewAppApproveData: Decodable {
    struct DataContent: Decodable {
        let subtype: String?
        let device_name: String?
        let app_name: String?
    }
    
    let id: Int?
    let child_id: Int?
    let type: String?
    let requested_time: String?
    let data: DataContent?
}

struct ApproveAppData: Decodable {
    struct DataContent: Decodable {
        let subtype: String?
        let device_name: String?
        let app_name: String?
    }
    
    let id: Int?
    let child_id: Int?
    let type: String?
    let requested_time: String?
    let data: DataContent?
}

struct SSTRuleData: Decodable {
    struct DataContent: Decodable {
        let rule_name: String?
        let status: String?
        let device_name: String?
    }
    
    let id: Int?
    let child_id: Int?
    let type: String?
    let requested_time: String?
    let data: DataContent?
}
struct InternetScheduleRuleRunningData: Decodable {
    let id: Int?
    let child_id: Int?
    let type: String?
    let requested_time: String?
    let data: [String]?
}

//struct InternetScheduleRuleRunningData: Decodable {
//    struct DataContent: Decodable {
//           // Assuming it's an empty array as per the example
//       }
//       
//       let id: Int?
//       let child_id: Int?
//       let type: String?
//       let requested_time: String?
//       let data: DataContent?
//}
struct LowBatteryData: Decodable {
    struct DataContent: Decodable {
        let subtype: String?
        let device_name: String?
        let device_id: String?
        let requested_time: String?
        let percent: String?
    }
    
    let id: Int?
    let child_id: Int?
    let type: String?
    let requested_time: String?
    let data: DataContent?
}


struct CheckinOutData: Decodable {
    struct DataContent: Decodable {
        let place_name: String?
    }
    
    let id: Int?
    let child_id: Int?
    let type: String?
    let requested_time: String?
    let created_at: String?
    let data: DataContent?
}
