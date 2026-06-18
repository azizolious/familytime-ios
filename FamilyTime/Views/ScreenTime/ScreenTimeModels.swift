//
//  ScreenTimeModels.swift
//  FamilyTime
//
//  Phase 2 — Screen Time models (Foundation/Combine only, no UIKit).
//
//  Naming note: a Codable `DailyLimit` and `ChildData` already live in
//  Swift/Models/HomeResponse.swift. To avoid collisions these models are named
//  `ScreenTimeRule` and `ScreenTimeDailyLimit` — `DailyLimit` is NOT redeclared.
//

import Foundation

// MARK: - ScreenTimeRule

/// A single screen-time rule (a named window with a per-weekday schedule).
struct ScreenTimeRule: Codable, Identifiable, Equatable {
    /// Server rule id. `nil` for a rule that has not yet been created.
    let id: Int?
    var ruleName: String
    /// Start time in "HH:mm" 24-hour format.
    var timeStart: String
    /// End time in "HH:mm" 24-hour format.
    var timeEnd: String
    var isMon: Bool
    var isTue: Bool
    var isWed: Bool
    var isThu: Bool
    var isFri: Bool
    var isSat: Bool
    var isSun: Bool
    var isActive: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case ruleName = "rule_name"
        case timeStart = "time_start"
        case timeEnd = "time_end"
        case isMon = "is_mon"
        case isTue = "is_tue"
        case isWed = "is_wed"
        case isThu = "is_thu"
        case isFri = "is_fri"
        case isSat = "is_sat"
        case isSun = "is_sun"
        case isActive = "is_active"
    }

    init(
        id: Int? = nil,
        ruleName: String,
        timeStart: String,
        timeEnd: String,
        isMon: Bool = false,
        isTue: Bool = false,
        isWed: Bool = false,
        isThu: Bool = false,
        isFri: Bool = false,
        isSat: Bool = false,
        isSun: Bool = false,
        isActive: Bool = true
    ) {
        self.id = id
        self.ruleName = ruleName
        self.timeStart = timeStart
        self.timeEnd = timeEnd
        self.isMon = isMon
        self.isTue = isTue
        self.isWed = isWed
        self.isThu = isThu
        self.isFri = isFri
        self.isSat = isSat
        self.isSun = isSun
        self.isActive = isActive
    }

    // The backend (a legacy PHP API — see HomeResponse where bools arrive as Int)
    // may send booleans as Bool, Int (0/1), or String ("0"/"1"). Decode tolerantly.
    // TODO confirm server JSON shape with backend.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        ruleName = try container.decodeIfPresent(String.self, forKey: .ruleName) ?? ""
        timeStart = try container.decodeIfPresent(String.self, forKey: .timeStart) ?? ""
        timeEnd = try container.decodeIfPresent(String.self, forKey: .timeEnd) ?? ""
        isMon = try container.decodeFlexibleBool(forKey: .isMon)
        isTue = try container.decodeFlexibleBool(forKey: .isTue)
        isWed = try container.decodeFlexibleBool(forKey: .isWed)
        isThu = try container.decodeFlexibleBool(forKey: .isThu)
        isFri = try container.decodeFlexibleBool(forKey: .isFri)
        isSat = try container.decodeFlexibleBool(forKey: .isSat)
        isSun = try container.decodeFlexibleBool(forKey: .isSun)
        isActive = try container.decodeFlexibleBool(forKey: .isActive)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encode(ruleName, forKey: .ruleName)
        try container.encode(timeStart, forKey: .timeStart)
        try container.encode(timeEnd, forKey: .timeEnd)
        try container.encode(isMon, forKey: .isMon)
        try container.encode(isTue, forKey: .isTue)
        try container.encode(isWed, forKey: .isWed)
        try container.encode(isThu, forKey: .isThu)
        try container.encode(isFri, forKey: .isFri)
        try container.encode(isSat, forKey: .isSat)
        try container.encode(isSun, forKey: .isSun)
        try container.encode(isActive, forKey: .isActive)
    }
}

extension ScreenTimeRule {
    /// Maps this model to the request body used for create/update calls.
    var ruleBody: ScreenTimeRuleBody {
        ScreenTimeRuleBody(
            ruleName: ruleName,
            timeStart: timeStart,
            timeEnd: timeEnd,
            isMon: isMon,
            isTue: isTue,
            isWed: isWed,
            isThu: isThu,
            isFri: isFri,
            isSat: isSat,
            isSun: isSun,
            isActive: isActive
        )
    }
}

// MARK: - ScreenTimeDailyLimit

/// The daily screen-time allowance for the selected child.
struct ScreenTimeDailyLimit: Codable, Equatable {
    var duration: Int
    var remaining: Int
    var remainingLimit: Int
    var autoAdd: Bool
    var isActive: Bool

    enum CodingKeys: String, CodingKey {
        case duration
        case remaining
        case remainingLimit = "remaining_limit"
        case autoAdd = "auto_add"
        case isActive = "is_active"
    }

    init(
        duration: Int,
        remaining: Int,
        remainingLimit: Int,
        autoAdd: Bool,
        isActive: Bool
    ) {
        self.duration = duration
        self.remaining = remaining
        self.remainingLimit = remainingLimit
        self.autoAdd = autoAdd
        self.isActive = isActive
    }

    // The legacy API exposes auto_add / is_active as Int (see HomeResponse.DailyLimit).
    // Decode tolerantly to accept Bool, Int, or String forms.
    // TODO confirm server JSON shape with backend.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        duration = try container.decodeIfPresent(Int.self, forKey: .duration) ?? 0
        remaining = try container.decodeIfPresent(Int.self, forKey: .remaining) ?? 0
        remainingLimit = try container.decodeIfPresent(Int.self, forKey: .remainingLimit) ?? 0
        autoAdd = try container.decodeFlexibleBool(forKey: .autoAdd)
        isActive = try container.decodeFlexibleBool(forKey: .isActive)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(duration, forKey: .duration)
        try container.encode(remaining, forKey: .remaining)
        try container.encode(remainingLimit, forKey: .remainingLimit)
        try container.encode(autoAdd, forKey: .autoAdd)
        try container.encode(isActive, forKey: .isActive)
    }
}

extension ScreenTimeDailyLimit {
    /// Maps this model to the request body used to update the daily limit.
    /// `DailyLimitUpdate` is owned by Core/Networking/FamilyTimeEndpoints.swift.
    var updateBody: DailyLimitUpdate {
        DailyLimitUpdate(
            duration: duration,
            autoAdd: autoAdd,
            isActive: isActive,
            remaining: remaining,
            remainingLimit: remainingLimit
        )
    }
}

// MARK: - Response wrappers

/// Generic envelope mirroring the `HomeResponse` style (`status`/`message`/`data`).
/// Used when the screen-time endpoints nest their payload under `data`.
/// TODO confirm server JSON shape with backend.
struct ScreenTimeResponse<Payload: Decodable>: Decodable {
    let status: Bool?
    let message: String?
    let data: Payload?
}

/// Throwaway response used for write calls whose body shape is not yet known.
/// TODO confirm server JSON shape with backend.
struct EmptyDecodableResponse: Decodable {}

// NOTE: The request body structs `ScreenTimeRuleBody` and `DailyLimitUpdate`
// are declared in Core/Networking/FamilyTimeEndpoints.swift (owned by the
// networking layer) and are NOT redeclared here to avoid collisions. The
// mapping helpers above build those types from these models.

// MARK: - Flexible bool decoding

private extension KeyedDecodingContainer {
    /// Decodes a boolean that may arrive as Bool, Int (0/1), or String ("0"/"1",
    /// "true"/"false"). Missing keys default to `false`.
    func decodeFlexibleBool(forKey key: Key) throws -> Bool {
        if let boolValue = try? decodeIfPresent(Bool.self, forKey: key) {
            return boolValue
        }
        if let intValue = try? decodeIfPresent(Int.self, forKey: key) {
            return intValue != 0
        }
        if let stringValue = try? decodeIfPresent(String.self, forKey: key) {
            switch stringValue.lowercased() {
            case "1", "true", "yes":
                return true
            default:
                return false
            }
        }
        return false
    }
}
