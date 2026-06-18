//
//  ReportModels.swift
//  FamilyTime
//
//  Reports & History models (Foundation only, no UIKit).
//
//  Naming note: the task brief calls the row model `ReportItem`, but a top-level
//  `struct ReportItem` ALREADY exists in main
//  (Swift/TextMsgsController/.../ParentDrawer/SwiftParentDrawer.swift) as a drawer
//  menu item. Swift top-level types are module-global, so to avoid a redeclaration
//  collision this model is named `ReportEntry` instead. `SocialMessage` and
//  `ReportResponse` have no collisions.
//
//  Legacy backend (a PHP API) is inconsistent: numeric fields can arrive as String
//  or number, and booleans as Bool / Int (0/1) / String ("1"/"0"). All such fields
//  are decoded tolerantly. Identifiers are synthesized when absent (NO force-unwrap).
//  TODO confirm server JSON shape with backend.
//

import Foundation

// MARK: - ReportEntry

/// A single web / search / YouTube / TikTok history row.
///
/// Maps the legacy `AppHistoryModel` JSON keys: `title`, `domain`, `url`,
/// `created_at` / `time_visit`, `number_visits`.
struct ReportEntry: Codable, Identifiable, Equatable {
    /// Stable identity, synthesized from `url` + `timestamp` when present,
    /// otherwise a generated UUID string. Never force-unwrapped.
    let id: String
    let title: String
    /// Legacy `domain`.
    let subtitle: String?
    let url: String?
    /// Legacy `created_at`, falling back to `time_visit`.
    let timestamp: String?
    /// Legacy `number_visits`.
    let visitCount: Int?

    enum CodingKeys: String, CodingKey {
        case title
        case domain
        case url
        case createdAt = "created_at"
        case timeVisit = "time_visit"
        case numberVisits = "number_visits"
    }

    init(
        id: String = UUID().uuidString,
        title: String,
        subtitle: String? = nil,
        url: String? = nil,
        timestamp: String? = nil,
        visitCount: Int? = nil
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.url = url
        self.timestamp = timestamp
        self.visitCount = visitCount
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decodeFlexibleString(forKey: .title) ?? ""
        subtitle = try container.decodeFlexibleString(forKey: .domain)
        url = try container.decodeFlexibleString(forKey: .url)
        // `created_at` preferred; fall back to `time_visit`.
        timestamp = try container.decodeFlexibleString(forKey: .createdAt)
            ?? container.decodeFlexibleString(forKey: .timeVisit)
        visitCount = try container.decodeFlexibleInt(forKey: .numberVisits)

        // Synthesize a stable id from url + timestamp, else a UUID. No force-unwrap.
        let composed = [url, timestamp].compactMap { $0 }.joined(separator: "|")
        id = composed.isEmpty ? UUID().uuidString : composed
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encodeIfPresent(subtitle, forKey: .domain)
        try container.encodeIfPresent(url, forKey: .url)
        try container.encodeIfPresent(timestamp, forKey: .createdAt)
        try container.encodeIfPresent(visitCount, forKey: .numberVisits)
    }
}

// MARK: - SocialMessage

/// A single social-monitoring message row.
///
/// Maps legacy social keys: `app_package`, `contact_name`, `body`, `date`,
/// `from_me`.
struct SocialMessage: Codable, Identifiable, Equatable {
    /// Stable identity, synthesized from package + contact + date + body when
    /// present, otherwise a generated UUID string. Never force-unwrapped.
    let id: String
    /// Legacy `app_package`.
    let appPackage: String?
    /// Legacy `contact_name`.
    let contactName: String?
    let body: String?
    let date: String?
    /// Legacy `from_me` (tolerant: Bool / Int / String "1"/"0").
    let fromMe: Bool

    enum CodingKeys: String, CodingKey {
        case appPackage = "app_package"
        case contactName = "contact_name"
        case body
        case date
        case fromMe = "from_me"
    }

    init(
        id: String = UUID().uuidString,
        appPackage: String? = nil,
        contactName: String? = nil,
        body: String? = nil,
        date: String? = nil,
        fromMe: Bool = false
    ) {
        self.id = id
        self.appPackage = appPackage
        self.contactName = contactName
        self.body = body
        self.date = date
        self.fromMe = fromMe
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        appPackage = try container.decodeFlexibleString(forKey: .appPackage)
        contactName = try container.decodeFlexibleString(forKey: .contactName)
        body = try container.decodeFlexibleString(forKey: .body)
        date = try container.decodeFlexibleString(forKey: .date)
        fromMe = try container.decodeFlexibleBool(forKey: .fromMe)

        // Synthesize a stable id, else a UUID. No force-unwrap.
        let composed = [appPackage, contactName, date, body]
            .compactMap { $0 }
            .joined(separator: "|")
        id = composed.isEmpty ? UUID().uuidString : composed
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(appPackage, forKey: .appPackage)
        try container.encodeIfPresent(contactName, forKey: .contactName)
        try container.encodeIfPresent(body, forKey: .body)
        try container.encodeIfPresent(date, forKey: .date)
        try container.encode(fromMe, forKey: .fromMe)
    }
}

// MARK: - Response wrapper

/// Generic envelope mirroring the `LocationResponse` / `ScreenTimeResponse` style
/// (`status` / `message` / `data`). Used when report endpoints nest their payload
/// under `data` (e.g. `data: [ReportEntry]` or `data: [SocialMessage]`).
/// A distinct name avoids duplicating the existing generic envelopes.
/// TODO confirm server JSON shape with backend.
struct ReportResponse<Payload: Decodable>: Decodable {
    let status: Bool?
    let message: String?
    let data: Payload?
}

// MARK: - Flexible decoding helpers

// Declared `private` to this file, matching the established per-file pattern in
// LocationModels.swift and ScreenTimeModels.swift (avoids redeclaration collisions).
private extension KeyedDecodingContainer {
    /// Decodes a String that may arrive as a String or numeric (e.g. an Int id).
    func decodeFlexibleString(forKey key: Key) throws -> String? {
        if let stringValue = try? decodeIfPresent(String.self, forKey: key) {
            return stringValue
        }
        if let intValue = try? decodeIfPresent(Int.self, forKey: key) {
            return String(intValue)
        }
        if let doubleValue = try? decodeIfPresent(Double.self, forKey: key) {
            return String(doubleValue)
        }
        return nil
    }

    /// Decodes an Int that may arrive as Int, Double, or String. Missing or
    /// unparsable values return `nil`.
    func decodeFlexibleInt(forKey key: Key) throws -> Int? {
        if let intValue = try? decodeIfPresent(Int.self, forKey: key) {
            return intValue
        }
        if let doubleValue = try? decodeIfPresent(Double.self, forKey: key) {
            return Int(doubleValue)
        }
        if let stringValue = try? decodeIfPresent(String.self, forKey: key) {
            return Int(stringValue)
        }
        return nil
    }

    /// Decodes a Bool that may arrive as Bool, Int (0/1), or String ("0"/"1",
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
