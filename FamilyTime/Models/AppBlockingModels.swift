//
//  AppBlockingModels.swift
//  FamilyTime
//
//  App-Blocking & Content-Filtering (parity sprint). MVVM, async/await, no UIKit.
//  New SwiftUI model names — intentionally distinct from the legacy
//  `InstalledApp` / `BlistAppModel` to avoid type collisions.
//
//  TODO confirm server JSON shape with backend (derived from a code audit).
//

import Foundation

// MARK: - Blockable App

/// A single installed app that can be allowed or blocked for the selected child.
/// Maps the legacy installed-apps payload synced from CoreData / core2.
struct BlockableApp: Codable, Identifiable, Equatable {

    /// Stable identifier — the legacy `installedapp_id`.
    let id: String
    let appName: String?
    let appPackageName: String?
    /// "system" | "important" | "app" (server-defined; not exhaustive).
    let appCategory: String?
    /// Whether the app is currently blocked (legacy `is_blacklisted` 0/1).
    let isBlacklisted: Bool

    enum CodingKeys: String, CodingKey {
        case id = "installedapp_id"
        case appName = "app_name"
        case appPackageName = "app_package_name"
        case appCategory = "app_category"
        case isBlacklisted = "is_blacklisted"
    }

    init(
        id: String,
        appName: String?,
        appPackageName: String?,
        appCategory: String?,
        isBlacklisted: Bool
    ) {
        self.id = id
        self.appName = appName
        self.appPackageName = appPackageName
        self.appCategory = appCategory
        self.isBlacklisted = isBlacklisted
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // `installedapp_id` may arrive as Int or String depending on the writer.
        if let intID = try? container.decode(Int.self, forKey: .id) {
            id = String(intID)
        } else {
            id = try container.decode(String.self, forKey: .id)
        }

        appName = try container.decodeIfPresent(String.self, forKey: .appName)
        appPackageName = try container.decodeIfPresent(String.self, forKey: .appPackageName)
        appCategory = try container.decodeIfPresent(String.self, forKey: .appCategory)

        // `is_blacklisted` is tolerant: accept Bool, Int (0/1) or String ("0"/"1"/"true").
        if let boolValue = try? container.decode(Bool.self, forKey: .isBlacklisted) {
            isBlacklisted = boolValue
        } else if let intValue = try? container.decode(Int.self, forKey: .isBlacklisted) {
            isBlacklisted = intValue != 0
        } else if let stringValue = try? container.decode(String.self, forKey: .isBlacklisted) {
            isBlacklisted = stringValue == "1" || stringValue.lowercased() == "true"
        } else {
            isBlacklisted = false
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(appName, forKey: .appName)
        try container.encodeIfPresent(appPackageName, forKey: .appPackageName)
        try container.encodeIfPresent(appCategory, forKey: .appCategory)
        try container.encode(isBlacklisted ? 1 : 0, forKey: .isBlacklisted)
    }

    /// A copy with `isBlacklisted` toggled to `blocked` — used for optimistic UI.
    func setting(blocked: Bool) -> BlockableApp {
        BlockableApp(
            id: id,
            appName: appName,
            appPackageName: appPackageName,
            appCategory: appCategory,
            isBlacklisted: blocked
        )
    }
}

// MARK: - Content Filter Setting

/// A single iOS content-filter toggle (e.g. Apps / Movies / TV Shows).
struct ContentFilterSetting: Identifiable, Equatable {
    /// Stable identifier — the filter category key.
    let id: String
    let title: String
    var isOn: Bool
}

/// The fixed set of iOS content-filter categories surfaced in the UI.
/// Order is the display order.
enum ContentFilterCategory: String, CaseIterable {
    case apps = "Apps"
    case movies = "Movies"
    case tvShows = "TVShows"
    case explicitContent = "ExplicitContent"
    case bookStoreErotica = "BookStoreErotica"

    /// Localized, user-facing title for the category.
    var localizedTitle: String {
        switch self {
        case .apps:
            return String(localized: "appblocking.filter.apps")
        case .movies:
            return String(localized: "appblocking.filter.movies")
        case .tvShows:
            return String(localized: "appblocking.filter.tvshows")
        case .explicitContent:
            return String(localized: "appblocking.filter.explicit")
        case .bookStoreErotica:
            return String(localized: "appblocking.filter.bookstore")
        }
    }
}

// MARK: - Response envelopes

/// Generic envelope mirroring the screen-time `status`/`message`/`data` style.
/// Used when the app-blocking endpoints nest their payload under `data`.
/// TODO confirm server JSON shape with backend.
struct AppBlockingResponse<Payload: Decodable>: Decodable {
    let status: Bool?
    let message: String?
    let data: Payload?
}

/// Content-filter row as returned by the content-filters endpoint.
/// `mdmPayload` holds the encoded MDM blob; `id` is the filter record id.
/// TODO confirm server JSON shape with backend.
struct ContentFilterPayload: Decodable {
    let id: Int?
    let mdmPayload: String?
    /// Map of category key -> enabled flag, when the server returns granular state.
    let categories: [String: Bool]?

    enum CodingKeys: String, CodingKey {
        case id
        case mdmPayload = "mdm_payload"
        case categories
    }
}
