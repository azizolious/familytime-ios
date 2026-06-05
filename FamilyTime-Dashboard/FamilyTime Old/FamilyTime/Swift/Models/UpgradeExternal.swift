//
//  UpgradeExternal.swift
//  FamilyTime
//
//  Created by Usama-Apps on 07/11/2022.
//  Copyright © 2022 YumyApps. All rights reserved.
//

import Foundation

class UpgradeExternal : Codable {
    var  upgradeExternal : [UpgradeExternalData]?
    
    init(upgradeExternal : [UpgradeExternalData]?) {
        self.upgradeExternal = upgradeExternal
    }
}

// MARK: - UpgradeExternalData
class UpgradeExternalData: Codable {
    var languages: [UserLanguageExt]?
    var colour, colorCode, accentColor, discount: String?
    var price: String?
    var subURL: String?

    enum CodingKeys: String, CodingKey {
        case languages, colour
        case colorCode = "color_code"
        case accentColor = "accent_color"
        case discount, price
        case subURL = "sub_url"
    }

    init(languages: [UserLanguageExt]?, colour: String?, colorCode: String?, accentColor: String?, discount: String?, price: String?, subURL: String?) {
        self.languages = languages
        self.colour = colour
        self.colorCode = colorCode
        self.accentColor = accentColor
        self.discount = discount
        self.price = price
        self.subURL = subURL
    }
}

// MARK: - Language
class UserLanguageExt: Codable {
    var language, title, packageDescription: String?
    var name: String?
    var plan: String?
    var points: [String]?
    var cta : String?

    enum CodingKeys: String, CodingKey {
        case language, title
        case packageDescription = "description"
        case name, plan, points, cta
    }

    init(language: String?, title: String?, packageDescription: String?, name: String?, plan: String?, points: [String]?, cta: String?) {
        self.language = language
        self.title = title
        self.packageDescription = packageDescription
        self.name = name
        self.plan = plan
        self.points = points
        self.cta = cta
    }
}
