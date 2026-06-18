//
//  LocationModels.swift
//  FamilyTime
//
//  Phase 2 — Location & Maps models (Foundation only, no UIKit / MapKit / GoogleMaps).
//
//  Naming note: legacy Objective-C `LocationModel` / `PlaceModel` already exist in
//  DataModel.{h,m}. To avoid collisions these Swift models use NEW names:
//  `FTChildLocation`, `Geofence`, and `LocationRecord`.
//
//  Legacy backend (a PHP API) sends latitude/longitude/radius as STRINGS and
//  booleans as "1"/"0". All numeric/bool fields are decoded tolerantly.
//  TODO confirm server JSON shape with backend.
//

import Foundation

// MARK: - FTChildLocation

/// A child's current/last-known location, used directly as Map annotation items.
struct FTChildLocation: Codable, Identifiable, Equatable {
    /// `Identifiable` id used for SwiftUI Map `annotationItems`.
    var id: String { childID }

    let childID: String
    let latitude: Double
    let longitude: Double
    let name: String?
    let color: String?
    let gender: String?
    let locationDate: String?
    let address: String?

    enum CodingKeys: String, CodingKey {
        case childID = "child_id"
        case latitude
        case longitude
        case name
        case color
        case gender
        case locationDate = "location_date"
        case address
    }

    init(
        childID: String,
        latitude: Double,
        longitude: Double,
        name: String? = nil,
        color: String? = nil,
        gender: String? = nil,
        locationDate: String? = nil,
        address: String? = nil
    ) {
        self.childID = childID
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
        self.color = color
        self.gender = gender
        self.locationDate = locationDate
        self.address = address
    }

    // latitude/longitude may arrive as String or numeric in the legacy JSON.
    // TODO confirm server JSON shape with backend.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        childID = try container.decodeFlexibleString(forKey: .childID) ?? ""
        latitude = try container.decodeFlexibleDouble(forKey: .latitude)
        longitude = try container.decodeFlexibleDouble(forKey: .longitude)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        color = try container.decodeIfPresent(String.self, forKey: .color)
        gender = try container.decodeIfPresent(String.self, forKey: .gender)
        locationDate = try container.decodeIfPresent(String.self, forKey: .locationDate)
        address = try container.decodeIfPresent(String.self, forKey: .address)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(childID, forKey: .childID)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(color, forKey: .color)
        try container.encodeIfPresent(gender, forKey: .gender)
        try container.encodeIfPresent(locationDate, forKey: .locationDate)
        try container.encodeIfPresent(address, forKey: .address)
    }
}

// MARK: - Geofence

/// A saved place / geofence with an optional check-in alert.
struct Geofence: Codable, Identifiable, Equatable {
    /// `Identifiable` id used for SwiftUI lists / Map annotation items.
    var id: String { placeId }

    let placeId: String
    let location: String
    let latitude: Double
    let longitude: Double
    let radius: Double
    let checkinAlert: Bool
    let address: String?
    let predefined: Bool

    enum CodingKeys: String, CodingKey {
        case placeId = "place_id"
        case location
        case latitude
        case longitude
        case radius
        case checkinAlert = "checkin_alert"
        case address
        case predefined
    }

    init(
        placeId: String,
        location: String,
        latitude: Double,
        longitude: Double,
        radius: Double,
        checkinAlert: Bool,
        address: String? = nil,
        predefined: Bool = false
    ) {
        self.placeId = placeId
        self.location = location
        self.latitude = latitude
        self.longitude = longitude
        self.radius = radius
        self.checkinAlert = checkinAlert
        self.address = address
        self.predefined = predefined
    }

    // The legacy API sends latitude/longitude/radius as String and bools as "1"/"0".
    // TODO confirm server JSON shape with backend.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        placeId = try container.decodeFlexibleString(forKey: .placeId) ?? ""
        location = try container.decodeIfPresent(String.self, forKey: .location) ?? ""
        latitude = try container.decodeFlexibleDouble(forKey: .latitude)
        longitude = try container.decodeFlexibleDouble(forKey: .longitude)
        radius = try container.decodeFlexibleDouble(forKey: .radius)
        checkinAlert = try container.decodeFlexibleBool(forKey: .checkinAlert)
        address = try container.decodeIfPresent(String.self, forKey: .address)
        predefined = try container.decodeFlexibleBool(forKey: .predefined)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(placeId, forKey: .placeId)
        try container.encode(location, forKey: .location)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
        try container.encode(radius, forKey: .radius)
        try container.encode(checkinAlert, forKey: .checkinAlert)
        try container.encodeIfPresent(address, forKey: .address)
        try container.encode(predefined, forKey: .predefined)
    }

    /// Maps this model back to the endpoints' `PlaceBody` (numeric fields stringified).
    /// `PlaceBody` is owned by Core/Networking/FamilyTimeEndpoints.swift.
    func toBody() -> PlaceBody {
        PlaceBody(
            location: location,
            latitude: String(latitude),
            longitude: String(longitude),
            radius: String(radius),
            checkinAlert: checkinAlert ? "1" : "0"
        )
    }
}

// MARK: - LocationRecord

/// A single historical location ping (one row of a child's location history).
struct LocationRecord: Codable, Identifiable, Equatable {
    /// Client-side identity; not part of the server payload.
    var id = UUID()
    let latitude: Double
    let longitude: Double
    let timeSent: String?
    let address: String?

    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
        case timeSent = "time_sent"
        case address
    }

    init(
        latitude: Double,
        longitude: Double,
        timeSent: String? = nil,
        address: String? = nil
    ) {
        self.latitude = latitude
        self.longitude = longitude
        self.timeSent = timeSent
        self.address = address
    }

    // latitude/longitude may arrive as String or numeric in the legacy JSON.
    // TODO confirm server JSON shape with backend.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        latitude = try container.decodeFlexibleDouble(forKey: .latitude)
        longitude = try container.decodeFlexibleDouble(forKey: .longitude)
        timeSent = try container.decodeIfPresent(String.self, forKey: .timeSent)
        address = try container.decodeIfPresent(String.self, forKey: .address)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
        try container.encodeIfPresent(timeSent, forKey: .timeSent)
        try container.encodeIfPresent(address, forKey: .address)
    }
}

// MARK: - Response wrappers

/// Generic envelope mirroring the `HomeResponse` style (`status`/`message`/`data`).
/// Used when the location endpoints nest their payload under `data`.
/// TODO confirm server JSON shape with backend.
struct LocationResponse<Payload: Decodable>: Decodable {
    let status: Bool?
    let message: String?
    let data: Payload?
}

// MARK: - Flexible decoding helpers

private extension KeyedDecodingContainer {
    /// Decodes a Double that may arrive as a Double, Int, or String. Missing or
    /// unparsable values default to `0`.
    func decodeFlexibleDouble(forKey key: Key) throws -> Double {
        if let doubleValue = try? decodeIfPresent(Double.self, forKey: key) {
            return doubleValue
        }
        if let intValue = try? decodeIfPresent(Int.self, forKey: key) {
            return Double(intValue)
        }
        if let stringValue = try? decodeIfPresent(String.self, forKey: key) {
            return Double(stringValue) ?? 0
        }
        return 0
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

    /// Decodes a String that may arrive as a String or numeric (e.g. an Int id).
    func decodeFlexibleString(forKey key: Key) throws -> String? {
        if let stringValue = try? decodeIfPresent(String.self, forKey: key) {
            return stringValue
        }
        if let intValue = try? decodeIfPresent(Int.self, forKey: key) {
            return String(intValue)
        }
        return nil
    }
}
