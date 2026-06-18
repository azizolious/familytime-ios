//
//  Global.swift
//  FamilyTime
//
//  Created by YumyApps on 11/01/2022.
//  Copyright © 2022 YumyApps. All rights reserved.
//

import UIKit


@objc class Global: NSObject {
    
    @objc class func setlanguage() {
        
        if UserDefaults.standard.string(forKey: "userlanguage") == "ar" || UserDefaults.standard.string(forKey: "userlanguage") == "he" {
            
            print("Right Language")
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            UITextField.appearance().semanticContentAttribute = .forceRightToLeft
            UILabel.appearance().semanticContentAttribute = .forceRightToLeft
            UIImageView.appearance().semanticContentAttribute = .forceRightToLeft
            UITableViewCell.appearance().semanticContentAttribute = .forceRightToLeft
            
        } else {
            
            print("English")
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            UITextField.appearance().semanticContentAttribute = .forceLeftToRight
            UILabel.appearance().semanticContentAttribute = .forceLeftToRight
            UIImageView.appearance().semanticContentAttribute = .forceLeftToRight
            UITableViewCell.appearance().semanticContentAttribute = .forceLeftToRight
        }
        
    }
    
}
