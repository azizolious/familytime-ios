//
//  HomePlansModel.swift
//  FamilyTime
//
//  Created by Sufyan on 31/05/2024.
//  Copyright © 2024 YumyApps. All rights reserved.
//

import Foundation

struct HomePlansModel: Codable {
    let children: [Child]?
    let plans: [Plan]?
}

struct Child: Codable {
    let childID: Int?
    let name: String?
    let birthday: NullableString?
    let gender, relationship: String?
    let email: NullableString?
    let phone: NullableString?
    let age, avatarID: Int?
    let device: String?
    let planID, packageID: Int?
    let package, color: String?
    let active, deleted: Int?
    let deletedAt: NullableString?
    let superUserID: Int?
    let lastActivity: String?
    let childEnrolled: Int?
    let versionNumber, versionCode, timeZone: String?
    let activationDate: NullableString?
    let createdAt, updatedAt, agent: String?
    let deviceID: Int?
    let batteryRemaining, wifiName, deviceManufacturer, deviceName: String?
    let deviceModel, deviceOS, deviceLanguage: String?
    let deviceTimezone, deviceImei: NullableString?
    let appVersion, appBuild: String?

    enum CodingKeys: String, CodingKey {
        case childID = "child_id"
        case name, birthday, gender, relationship, email, phone, age
        case avatarID = "avatar_id"
        case device
        case planID = "plan_id"
        case packageID = "package_id"
        case package, color, active, deleted
        case deletedAt = "deleted_at"
        case superUserID = "super_user_id"
        case lastActivity = "last_activity"
        case childEnrolled = "child_enrolled"
        case versionNumber = "version_number"
        case versionCode = "version_code"
        case timeZone = "time_zone"
        case activationDate = "activation_date"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case agent
        case deviceID = "device_id"
        case batteryRemaining = "battery_remaining"
        case wifiName = "wifi_name"
        case deviceManufacturer = "device_manufacturer"
        case deviceName = "device_name"
        case deviceModel = "device_model"
        case deviceOS = "device_os"
        case deviceLanguage = "device_language"
        case deviceTimezone = "device_timezone"
        case deviceImei = "device_imei"
        case appVersion = "app_version"
        case appBuild = "app_build"
    }
    func stringValue(forNullableString nullableString: NullableString) -> String? {
           switch nullableString {
           case .string(let value):
               return value
           case .null:
               return nil
           }
       }
}

// MARK: - Plan
struct Plan: Codable {
    let planID: Int?
    let identifier: String?
    let forAndroid, forIos, androidReleased, iosReleased: Int?
    let status: Int?
    let value: String?

    enum CodingKeys: String, CodingKey {
        case planID = "plan_id"
        case identifier
        case forAndroid = "for_android"
        case forIos = "for_ios"
        case androidReleased = "android_released"
        case iosReleased = "ios_released"
        case status, value
    }
    func stringValue(forNullableString nullableString: NullableString) -> String? {
            switch nullableString {
            case .string(let value):
                return value
            case .null:
                return nil
            }
        }
}

public struct JSONHelper {
    class JSONNull: Codable, Hashable {
        public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
            return true
        }

        public var hashValue: Int {
            return 0
        }

        public init() {}

        public required init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if !container.decodeNil() {
                throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encodeNil()
        }
    }
}
enum NullableString: Codable {
    case string(String)
    case null

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
        } else if container.decodeNil() {
            self = .null
        } else {
            throw DecodingError.typeMismatch(NullableString.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for NullableString"))
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let value):
            try container.encode(value)
        case .null:
            try container.encodeNil()
        }
    }
}
