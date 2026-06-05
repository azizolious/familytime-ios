//
//  CommonUtility.swift
//  FamilyTime
//
//  Created by Sana Ullah on 20/11/2018.
//  Copyright © 2018 YumyApps. All rights reserved.
//

import Foundation
import ActiveLabel
import UIKit
import Firebase


class CommonUtility{
    
    static let shared = CommonUtility()
    
    
    func showTermsPolicy(label : ActiveLabel, vc:UIViewController){
        
        let termsStr        = "Terms of service".localized
        let policyStr       = "privacy policy".localized
        let dataCollection  = "Data Collection".localized
        
        let termsType           = ActiveType.custom(pattern: "\\s\(termsStr)\\b") //Regex that looks for "with"
        let privacyType2        = ActiveType.custom(pattern: "\\s\(policyStr)\\b") //Regex that looks for "with"
        let dataCollectionType  = ActiveType.custom(pattern: "\\s\(dataCollection)\\b") //Regex that looks for "with"
        label.enabledTypes      = [.url, termsType, privacyType2, dataCollectionType]
        
        label.text              = "in_app_purchase_content_7".localized
        
        
        label.customColor[termsType]          = UIColor.init(red: 11, green: 117, blue: 169, a: 1.0)
        label.customColor[privacyType2]       = UIColor.init(red: 11, green: 117, blue: 169, a: 1.0)
        label.customColor[dataCollectionType] = UIColor.init(red: 11, green: 117, blue: 169, a: 1.0)
        
        
        label.handleCustomTap(for: termsType) { element in
            let termsVc = SwiftConstants.SwiftStoryBoard.instantiateViewController(withIdentifier: "TermsVC") as! TermsVC
            termsVc.isPrivacyPolicy = false
            vc.navigationController?.pushViewController(termsVc, animated: true)
        }
        
        label.handleCustomTap(for: privacyType2) { (element) in
            let termsVc = SwiftConstants.SwiftStoryBoard.instantiateViewController(withIdentifier: "TermsVC") as! TermsVC
            termsVc.isPrivacyPolicy = true
            vc.navigationController?.pushViewController(termsVc, animated: true)
        }
        
        label.handleCustomTap(for: dataCollectionType) { (element) in
            let dataUse = SwiftConstants.SwiftStoryBoard.instantiateViewController(withIdentifier: "DataUseVC") as! DataUseVC
//            termsVc.isPrivacyPolicy = true
            vc.navigationController?.pushViewController(dataUse, animated: true)
        }
    }
    
    func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }
    
    func showToast(message : String, font: UIFont, view: UIView) {
        
        let toastLabel = UILabel(frame: CGRect(x: view.frame.size.width/2 - 170, y: view.frame.size.height/1.55 + 100, width: view.frame.size.width * 0.9, height: 40))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func setFirebaseEvents(eventName:String,screenTitle:String,itemName:String) {
//        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
//          AnalyticsParameterItemID: "id-\(title)",
//          AnalyticsParameterItemName: title,
//          AnalyticsParameterContentType: "cont",
//        ])
        
        FirebaseAnalytics.Analytics.logEvent(eventName, parameters: [
            AnalyticsParameterItemName : itemName,
            AnalyticsParameterScreenName : screenTitle
        ])
    }
}


