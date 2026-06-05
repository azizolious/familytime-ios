//
//  Colors.swift
//  FamilyTime - Dashboard
//
//  Created by Muhammad Ajmal on 04/05/2017.
//  Copyright © 2017 SoraCode. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    static var FTWhite: UIColor {
        return UIColor(red:1, green:1, blue:1, alpha:1.0)
    }
    
    static var FTClear: UIColor {
        return UIColor(red:1, green:1, blue:1, alpha:0.0)
    }
    
    static var FTBlack: UIColor {
        return UIColor(red:0, green:0, blue:0, alpha:1.0)
    }
    
    static var FTBlue: UIColor {
        return UIColor(red:3.0/255, green:169.0/255, blue:244.0/255, alpha:1.0)
    }
    
    static var FTRed: UIColor {
        return UIColor(red:255.0/255, green:68.0/255, blue:68.0/255, alpha:1.0)
    }
    
    static var FTPurple: UIColor {
        return UIColor(red:114.0/255, green:102.0/255, blue:186.0/255, alpha:1.0)
    }
    
    static var FTOrange: UIColor {
        return UIColor(red:255.0/255, green:132.0/255, blue:0.0, alpha:1.0)
    }
    
    static var FTGreen: UIColor {
        return UIColor(red:162.0/255, green:201.0/255, blue:34.0/255, alpha:1.0)
    }
    
    static var FTAmber: UIColor {
        return UIColor(red:255.0/255, green:184.0/255, blue:29.0/255, alpha:1.0)
    }
    
    static var FTLightPink: UIColor {
        return UIColor(red:255.0/255, green:64.0/255, blue:129.0/255, alpha:1.0)
    }
    
    static var FTDarkPink: UIColor {
        return UIColor(red:246.0/255, green:8.0/255, blue:93.0/255, alpha:1.0)
    }
    
    static var FTLightGray: UIColor {
        return UIColor(red:150.0/255, green:150.0/255, blue:150.0/255, alpha:1.0)
    }
    
    static var FTDarkGray: UIColor {
        return UIColor(red:96.0/255, green:96.0/255, blue:96.0/255, alpha:1.0)
    }
    
    convenience init(colorWithHexValue value: Int, alpha:CGFloat = 1.0){
        self.init(
            red   : CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green : CGFloat((value & 0x00FF00) >> 8) / 255.0,
            blue  : CGFloat(value & 0x0000FF) / 255.0,
            alpha : alpha
        )
    }
    
    convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: a
        )
    }

}
