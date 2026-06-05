//
//  ConfigurationKeyValue.swift
//  FamilyTime
//
//  Created by Usama-Apps on 09/09/2022.
//  Copyright © 2022 YumyApps. All rights reserved.
//

import Foundation

// MARK: - ConfigurationKeyValue
class ConfigurationKeys: NSObject, Codable {
    var name: String?
    var price: Double?
    var discount, colour: String?
    var points: [String]?
    var cta: String?
    var subURL: String?
    var subID : String?

    enum CodingKeys: String, CodingKey {
        case name, price, discount, colour, points, cta
        case subURL = "sub_url"
        case subID = "sub_id"
    }

    init(name: String?, price: Double?, discount: String?, colour: String?, points: [String]?, cta: String?, subURL: String?, subID:String?) {
        self.name = name
        self.price = price
        self.discount = discount
        self.colour = colour
        self.points = points
        self.cta = cta
        self.subURL = subURL
        self.subID = subID
    }
}

typealias ConfigurationKey = [ConfigurationKeys]
