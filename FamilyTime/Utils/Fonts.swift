//
//  Fonts.swift
//  FamilyTime - Dashboard
//
//  Created by Muhammad Ajmal on 04/05/2017.
//  Copyright © 2017 SoraCode. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

enum FTFontSize : CGFloat {
    case size9 = 9.0

    case size12 = 12.0
    case size14 = 14.0
    case size16 = 16.0
    case size17 = 17.0
    case size18 = 18.0
    case size20 = 20.0
    case size21 = 21.0
    case size22 = 22.0
    case size23 = 23.0
//    case size40 = 40.0

    var relative: CGFloat {
        let isLandscape = UIApplication.shared.statusBarOrientation != .portrait
        let result = UIScreen.main.bounds.size
        
        if result.height == 480 || (isLandscape && result.width == 480) { //iPhone 4, 4S
            switch self {
            case .size9:
                return 9.0
            case .size12:
                return 10.0
            case .size14:
                return 12.5
            case .size16:
                return 14.0
            case .size17:
                return 14.5
            case .size18:
                return 15.0
            case .size20:
                return 17.0
            case .size21:
                return 18.0
            case .size22:
                return 19.0
            case .size23:
                return 20.5
//            case .size9:
                return 9.0

            }
        }
        else if result.height == 568 || (isLandscape && result.width == 568) { // iPhone 5
            switch self {
            case .size9:
                return 9.0

            case .size12:
                return 10.0
            case .size14:
                return 12.5
            case .size16:
                return 14.0
            case .size17:
                return 14.5
            case .size18:
                return 15.0
            case .size20:
                return 17.0
            case .size21:
                return 18.0
            case .size22:
                return 19.0
            case .size23:
                return 20.5
            }
        }
        else if(result.height == 667 || (isLandscape && result.width == 667)) { // iPhone 6
            return self.rawValue
        }
        else if(result.height == 736 || (isLandscape && result.width == 736)) { // iPhone 6Plus
            switch self {
            case .size9:
                return 9.0

            case .size12:
                return 13.0
            case .size14:
                return 15.5
            case .size16:
                return 18.0
            case .size17:
                return 19.0
            case .size18:
                return 20.0
            case .size20:
                return 22.0
            case .size21:
                return 23.0
            case .size22:
                return 24.0
            case .size23:
                return 25.5
            }
        }
        else if(result.height == 1024 || (isLandscape && result.width == 1024)) { // iPad
            switch self {
            case .size9:
                return 9.0

            case .size12:
                return 25.0
            case .size14:
                return 29.0
            case .size16:
                return 33.0
            case .size17:
                return 35.0
            case .size18:
                return 37.0
            case .size20:
                return 41.0
            case .size21:
                return 43.0
            case .size22:
                return 45.0
            case .size23:
                return 47.0
            }
        }
        return 16.0
    }
}

extension UIScreen {
    static func isIphoneX() -> Bool {
        //1334×750 pixels
        let isLandscape = UIApplication.shared.statusBarOrientation != .portrait
        let result = UIScreen.main.bounds.size
        if(result.height == 812 || (isLandscape && result.width == 812)) { // iPhone 6
            return true
        }
        return false
    }

    static func isIphone6() -> Bool {
        let isLandscape = UIApplication.shared.statusBarOrientation != .portrait
        let result = UIScreen.main.bounds.size
        if(result.height == 667 || (isLandscape && result.width == 667)) { // iPhone 6
            return true
        }
        return false
    }
    
    static func isIphone6Plus() -> Bool {
        let isLandscape = UIApplication.shared.statusBarOrientation != .portrait
        let result = UIScreen.main.bounds.size
        if(result.height == 736 || (isLandscape && result.width == 736)) { // iPhone 6Plus
            return true
        }
        return false
    }
    
    static func isIphone5() -> Bool {
        let isLandscape = UIApplication.shared.statusBarOrientation != .portrait
        let result = UIScreen.main.bounds.size
        if result.height == 568 || (isLandscape && result.width == 568) { // iPhone 5
            return true
        }
        return false
    }
    
    static func isIphone4() -> Bool {
        let isLandscape = UIApplication.shared.statusBarOrientation != .portrait
        let result = UIScreen.main.bounds.size
        if result.height == 480 || (isLandscape && result.width == 480) { //iPhone 4, 4S
            return true
        }
        return false
    }
    
    static func isIpad() -> Bool {
        let isLandscape = UIApplication.shared.statusBarOrientation != .portrait
        let result = UIScreen.main.bounds.size
        if(result.height == 1024 || (isLandscape && result.width == 1024)) {  // iPad
            return true
        }
        return false
    }
}

extension UIFont {
    
    static func RegularFont(size: FTFontSize = .size16) -> UIFont {
        return UIFont(name: "OpenSans", size: size.relative)!
    }
    
    static func LightFont(size: FTFontSize = .size16) -> UIFont {
        return UIFont(name: "OpenSans-Light", size: size.relative)!
    }
    
    static func SemiboldFont(size: FTFontSize = .size16) -> UIFont {
        return UIFont(name: "OpenSans-Semibold", size: size.relative)!
    }
    
    static func BoldFont(size: FTFontSize = .size16) -> UIFont {
        return UIFont(name: "OpenSans-Bold", size: size.relative)!
    }
}

@available(iOS 13.0, *)
extension Font {
    
    static func RegularFont(size: CGFloat) -> Font {
        .custom("OpenSans", size: size) // Replace with your font's name
    }
    
    static func LightFont(size: CGFloat) -> Font {
        .custom("OpenSans-Light", size: size) // Replace with your font's name
    }
    
    static func SemiboldFont(size: CGFloat) -> Font {
        .custom("OpenSans-Semibold", size: size) // Replace with your font's name
    }
    
    static func BoldFont(size: CGFloat) -> Font {
        .custom("OpenSans-Bold", size: size) // Replace with your font's name
    }
}
