//
//  ControlModel.swift
//  FamilyTime
//
//  Created by Sufyan on 11/10/2023.
//  Copyright © 2023 YumyApps. All rights reserved.
//


struct ControlCodableModel: Codable {
    var controls: [Control]?
}

// MARK: - Control
struct Control: Codable {
    var childID, superUserID, featureID: Int?
    var identifier: String?
    var state: Int?
    var value: String?

    enum CodingKeys: String, CodingKey {
        case childID = "child_id"
        case superUserID = "super_user_id"
        case featureID = "feature_id"
        case identifier, state, value
    }
    func getAppBlockerValue() -> (Int, Int) {
        var newAppValue = 0
        var apprAppValue = 0
        if let data = value?.data(using: .utf8) {
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    for item in jsonArray {
                        if let identifier = item["identifier"] as? String,
                           let status = item["status"] as? Int {
                            if identifier == "block_new_apps" {
                                newAppValue = status
                            } else {
                                apprAppValue = status
                            }
                        }
                    }
                }
            } catch {
                print("Error parsing JSON: \(error)")
            }
        } else {
            print("Failed to convert JSON string to data.")
        }
        return (newAppValue, apprAppValue)
    }
    func getAutoLimitAppValue() -> Int {
        var newAppValue = 0
        do {
            // Convert JSON string to Data
            let jsonData = value?.data(using: .utf8)! ?? Data()
            
            // Decode JSON data into MyStruct
            let myStruct = try JSONDecoder().decode(MyStruct.self, from: jsonData)
            
            // Access the state value
            let stateValue = myStruct.status
            return stateValue
        } catch {
            print("Error decoding JSON: \(error)")
        }
        return newAppValue
//        var newAppValue = 0
//        var apprAppValue = 0
//        if let data = value?.data(using: .utf8) {
//            do {
//                if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
//                    for item in jsonArray {
//                        if let identifier = item["identifier"] as? String,
//                           let status = item["status"] as? Int {
//                            if identifier == "auto_limit_new_apps" {
//                                newAppValue = status
//                            }
//                        }
//                    }
//                }
//            } catch {
//                print("Error parsing JSON: \(error)")
//            }
//        } else {
//            print("Failed to convert JSON string to data.")
//        }
//        return newAppValue
    }
}

struct TimeBankCodableModel: Codable {
    var timeBank: [TimeBankObj]?

    enum CodingKeys: String, CodingKey {
        case timeBank = "time_bank"
    }
}

// MARK: - TimeBank
struct TimeBankObj: Codable {
    var childID, timeBank: Int?

    enum CodingKeys: String, CodingKey {
        case childID = "child_id"
        case timeBank = "time_bank"
    }
}

struct MyStruct: Codable {
    let identifier: String
    let status: Int
}

//let jsonString = "{\"identifier\":\"auto_limit_new_apps\",\"status\":0}"


