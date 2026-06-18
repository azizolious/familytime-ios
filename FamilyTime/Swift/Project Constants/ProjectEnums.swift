//
//  ProjectEnums.swift
//  FamilyTime
//
//  Created by Usama-Apps on 13/09/2022.
//  Copyright © 2022 YumyApps. All rights reserved.
//

import Foundation


//MARK: - PremiumPackageVC Enums
enum PremiumPackageKeys : String {
    case SHOPING_FUNNEL             = "shopping_funnel"
    case ACTIVATION_FUNNEL          = "activation_funnel"
    case APPLE_TRIAL_SUB            = "trial_sub_int"
    case UPGRADE_SUB_EXT            = "upgrade_sub_ext"
    case UPGRADE_SUB_INT            = "upgrade_sub_int"
    case FAST_SPRING_TRIAL_EXT      = "trial_sub_ext"
}
enum PackagesColors: String {
    case red
    case blue
    case green
    case orange
    case purple
    
    var create: UIColor {
        switch self {
        case .red:
            return UIColor.red
        case .blue:
            return UIColor(red: 0, green: 153, blue: 255, a: 1)
        case .green:
            return UIColor(red: 159, green: 200, blue: 27, a: 1)
        case.orange:
            return UIColor(red: 255, green: 187, blue: 0, a: 1)
        case.purple:
            return UIColor(red: 114, green: 102, blue: 186, a: 1)
        default:
            return UIColor(red: 114, green: 102, blue: 186, a: 1)
        }
    }
}

enum UserLanguages : String {
    case en
    case ja
    case es
    case fi
    case pt
    case de
    case fr
    case it
    case zh
    case tr
    case iw
    case ar
    
    var language : String {
        switch self {
        case .en:
            return "en"
        case .ja:
            return "ja"
        case .es:
            return "es"
        case .fi:
            return "fi"
        case .pt:
            return "pt"
        case .de:
            return "de"
        case .fr:
            return "fr"
        case .it:
            return "it"
        case .zh:
            return "zh"
        case .tr:
            return "tr"
        case .iw:
            return "iw"
        case .ar:
            return "ar"
        }
    }
}
