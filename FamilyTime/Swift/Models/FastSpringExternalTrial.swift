//
//  FastSpringExternalTrial.swift
//  FamilyTime
//
//  Created by Usama-Apps on 29/11/2022.
//  Copyright © 2022 YumyApps. All rights reserved.
//

import Foundation

//MARK: - FastSpringExternalTrial
class FastSpringExternalTrial : Codable {
    var fastSpringExternalTrail : [FastSpringExternalTrialData]?
    
    init(fastSpringExternalTrial : [FastSpringExternalTrialData]?) {
        self.fastSpringExternalTrail = fastSpringExternalTrial
    }
}

// MARK: - FastSpringExternalTrialData
class FastSpringExternalTrialData: Codable {
    var languages: [FastSpringExternalLanguage]?
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

    init(languages: [FastSpringExternalLanguage]?, colour: String?, colorCode: String?, accentColor: String?, discount: String?, price: String?, subURL: String?) {
        self.languages = languages
        self.colour = colour
        self.colorCode = colorCode
        self.accentColor = accentColor
        self.discount = discount
        self.price = price
        self.subURL = subURL
    }
}

// MARK: - FastSpringExternalLanguage
class FastSpringExternalLanguage: Codable {
    var language, title, languageDescription, name: String?
    var plan: String?
    var points: [String]?
    var cta: String?

    enum CodingKeys: String, CodingKey {
        case language, title
        case languageDescription = "description"
        case name, plan, points, cta
    }

    init(language: String?, title: String?, languageDescription: String?, name: String?, plan: String?, points: [String]?, cta: String?) {
        self.language = language
        self.title = title
        self.languageDescription = languageDescription
        self.name = name
        self.plan = plan
        self.points = points
        self.cta = cta
    }
}
