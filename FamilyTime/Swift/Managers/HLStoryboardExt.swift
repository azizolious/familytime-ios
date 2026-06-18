//
//  HLStoryboardExt.swift
//  FamilyTime
//
//  Created by Sana-Ullah-IOS on 09/03/2020.
//  Copyright © 2020 YumyApps. All rights reserved.
//

import Foundation

@objc
class HLStoryboard: NSObject {
    //  Storyboards Names
    enum Names: String {
        case Auth
        case Dashboard
        case Settings
    }
    
    //  Storyboard Instance
    static func instance(_ storyboard: Names) -> UIStoryboard {
        return UIStoryboard(name: storyboard.rawValue, bundle: Bundle.main)
    }
    
    
    //  MARK:- Refrences & Instances
    static let Auth = instance(Names.Auth)
    static let Dashboard = instance(Names.Dashboard)
    static let Settings = instance(Names.Settings)
    
    static func loginNavigationVC() -> UINavigationController {
        return Auth.instantiateViewController(withIdentifier: "LoginNavigVC") as! UINavigationController
    }
    
    static func loadLoginVC() -> LoginViewController {
        return Auth.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
    }
    
    static func loadForgotPasswordVC() -> ForgetPasswordVC {
        return Auth.instantiateViewController(withIdentifier: "ForgetPasswordVC") as! ForgetPasswordVC
    }
    
    static func loadEmailConfirmationVC() -> EmailConfirmationVC {
        return Auth.instantiateViewController(withIdentifier: "EmailConfirmationVC") as! EmailConfirmationVC
    }
    
    static func loadNewUserAddChildVC() -> NewUserAddChildVC {
        return Auth.instantiateViewController(withIdentifier: "NewUserAddChildVC") as! NewUserAddChildVC
    }
    
    //  MARK: - - Dashboard Screens Reference
    static func loadDashboardVC() -> DashboardVC {
        return Dashboard.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
    }

    //  MARK: Add Child
    static func loadAddDeviceVC() -> AddDeviceVC1 {
        return Dashboard.instantiateViewController(withIdentifier: "AddDeviceVC1") as! AddDeviceVC1
    }
    
    
    //  MARK: Premium Alert
    static func loadPremiumPopupVC() -> PremiumPackageVC {
        let vc = Dashboard.instantiateViewController(withIdentifier: StoryboardConstants.Identifiers.PREMIUM_PACKAGE_VC_IDENTIFIER) as! PremiumPackageVC
        vc.isCommingFromOtherScreens = true
        return vc
    }
    
    //  MARK: In-App/Subscribe
    static func loadSubscriptionVC() -> SubscriptionVC {
        return Dashboard.instantiateViewController(withIdentifier: "SubscriptionVC") as! SubscriptionVC
    }
    
    //  MARK: - - Child
    //  MARK: - Settings
    //  MARK: Content Filters
    @objc static func loadContentFiltersVC() -> ContentFiltersVC {
        return Settings.instantiateViewController(withIdentifier: "ContentFiltersVC") as! ContentFiltersVC
    }
    
    @objc static func loadContentFiltersDetailsVC() -> ContentFilterDetailsVC {
        return Settings.instantiateViewController(withIdentifier: "ContentFilterDetailsVC") as! ContentFilterDetailsVC
    }
    
}

