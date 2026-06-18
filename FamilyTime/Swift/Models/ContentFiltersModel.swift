//
//  ContentFiltersModel.swift
//  FamilyTime
//
//  Created by Sufyan on 21/05/2024.
//  Copyright © 2024 YumyApps. All rights reserved.
//

import Foundation

struct ContentFilterResponse: Codable {
    let contentFilters: [ContentFilter]
    
    enum CodingKeys: String, CodingKey {
        case contentFilters = "content_filter"
    }
}

struct ContentFilter: Codable {
    let id: Int
    let childId: Int
    let mdmPayload: MdmPayload
    
    enum CodingKeys: String, CodingKey {
        case id
        case childId = "child_id"
        case mdmPayload = "mdm_payload"
    }
    
    struct MdmPayload: Codable {
        let movies: ContentValue
        let tvShows: ContentValue
        let apps: ContentValue
        let bookstoreErotica: BoolOrString
        let explicitContent: BoolOrString
        
        enum CodingKeys: String, CodingKey {
            case movies
            case tvShows = "tvshows"
            case apps
            case bookstoreErotica = "bookstoreErotica"
            case explicitContent = "explicitContent"
        }
    }
    
    enum ContentValue: Codable {
        case bool(Bool)
        case string(String)
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let boolValue = try? container.decode(Bool.self) {
                self = .bool(boolValue)
                return
            }
            if let stringValue = try? container.decode(String.self) {
                self = .string(stringValue)
                return
            }
            throw DecodingError.typeMismatch(ContentValue.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Value could not be decoded"))
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .bool(let boolValue):
                try container.encode(boolValue)
            case .string(let stringValue):
                try container.encode(stringValue)
            }
        }
    }
    
    struct BoolOrString: Codable {
        var value: Bool
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let boolValue = try? container.decode(Bool.self) {
                self.value = boolValue
                return
            }
            if let stringValue = try? container.decode(String.self) {
                switch stringValue.lowercased() {
                case "true", "1":
                    self.value = true
                case "false", "0":
                    self.value = false
                default:
                    throw DecodingError.typeMismatch(BoolOrString.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "String value is not 'true', 'false', '1', or '0'"))
                }
                return
            }
            throw DecodingError.typeMismatch(BoolOrString.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Value could not be decoded as Bool or String"))
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(value)
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        childId = try container.decode(Int.self, forKey: .childId)
        
        let mdmPayloadString = try container.decode(String.self, forKey: .mdmPayload)
        let data = mdmPayloadString.data(using: .utf8)!
        mdmPayload = try JSONDecoder().decode(MdmPayload.self, from: data)
    }
}

extension ContentFilter.ContentValue {
    var stringValue: String {
        switch self {
        case .bool(let boolValue):
            return boolValue ? "true" : "false"
        case .string(let stringValue):
            return stringValue
        }
    }
}
