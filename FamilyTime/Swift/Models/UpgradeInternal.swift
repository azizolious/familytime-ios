//
//  UpgradeInternal.swift
//  FamilyTime
//
//  Created by Usama-Apps on 07/11/2022.
//  Copyright © 2022 YumyApps. All rights reserved.
//

import Foundation

//MARK: - UpgradeInternal

class UpgradeInternal : Codable {
    var upgradeInternal : [UpgradeInternalData]?
    
    init(upgradeInternal : [UpgradeInternalData]?) {
        self.upgradeInternal = upgradeInternal
    }
}

//MARK: - UpgradeInternalData
class UpgradeInternalData: Codable {
    var languages: [UserLanguageInt]?
    var colour, colorCode, accentColor, discount: String?
    var price, subID: String?

    enum CodingKeys: String, CodingKey {
        case languages, colour
        case colorCode = "color_code"
        case accentColor = "accent_color"
        case discount, price
        case subID = "sub_id"
    }

    init(languages: [UserLanguageInt]?, colour: String?, colorCode: String?, accentColor: String?, discount: String?, price: String?, subID: String?) {
        self.languages = languages
        self.colour = colour
        self.colorCode = colorCode
        self.accentColor = accentColor
        self.discount = discount
        self.price = price
        self.subID = subID
    }
}

//MARK: - UserLanguageInt
class UserLanguageInt: Codable {
    var language, title, packageDescription, name: String?
    var plan: String?
    var points: [String]?
    var cta: String?

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

