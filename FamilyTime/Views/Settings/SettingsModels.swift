//
//  SettingsModels.swift
//  FamilyTime
//
//  Models for the Settings & Account feature (co-parents, etc.).
//  Account/profile reuses the existing `Profile` type in
//  Swift/Models/AccountModel.swift — it is intentionally NOT redefined here.
//
//  TODO confirm payloads with backend (derived from a code audit, not backend docs).
//

import Foundation

/// A co-parent associated with the account.
///
/// `id` maps to the backend `co_parent_user_id` and is decoded tolerantly
/// (the backend may send it as a String or an Int). No force-unwraps.
struct FTCoParent: Codable, Identifiable, Equatable {
    let id: String
    let name: String?
    let email: String?
    /// e.g. "pending" / "active".
    let status: String?

    enum CodingKeys: String, CodingKey {
        case id = "co_parent_user_id"
        case name
        case email
        case status
    }

    init(id: String, name: String?, email: String?, status: String?) {
        self.id = id
        self.name = name
        self.email = email
        self.status = status
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // Tolerant id decode (String or Int); fall back to "" rather than failing
        // or force-unwrapping if the field is absent/unexpected.
        id = try container.decodeFlexibleString(forKey: .id) ?? ""
        name = try container.decodeFlexibleString(forKey: .name)
        email = try container.decodeFlexibleString(forKey: .email)
        status = try container.decodeFlexibleString(forKey: .status)
    }
}

/// Envelope for the co-parent list endpoint.
///
/// Defined locally (rather than reusing `ReportResponse`/`LocationResponse`,
/// which are file-private to their respective repositories per codebase convention).
struct CoParentResponse: Decodable {
    let status: String?
    let message: String?
    let data: [FTCoParent]?
}

// MARK: - Flexible decoding helpers

// Declared `private` to this file, matching the established per-file pattern in
// ReportModels.swift / LocationModels.swift / ScreenTimeModels.swift
// (avoids redeclaration collisions).
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
}
