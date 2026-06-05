//
//  UserDefaultsManager.swift
//  FamilyTime
//
//  Created by Sana-Ullah-IOS on 12/03/2020.
//  Copyright © 2020 YumyApps. All rights reserved.
//

import Foundation

@objc
class UserDefaultsManager: UserDefaults {
    
    struct Keys {
        static let DeviceToken = "deviceToken"
        static let userEmail = "userEmail"
        static let userPassword = "userPassword"
        static let EmailVerified = "EmailVerified"
        static let LaunchAppHash = "LaunchApp_Hash"
        static let LoginToken = "kHeaderToken"
        static let ShowInApps = "ShowInApps"
        static let ChildAdded = "ChildAdded"
        static let ShoppingFunnel = "shopping_funnel"
        static let ActivationFunnel = "activation_funnel"
        static let AppleAuthServiceIdentified = "AppleAuthServiceIdentified"
        static let NewLoginToken = "newHeaderToken"
    }
    
    
    @objc public static var bearerTokenCore2 : String? {
        set {
            standard.set(newValue, forKey: Keys.NewLoginToken)
            standard.synchronize()
        }
        
        get {
            return standard.string(forKey: Keys.NewLoginToken)
        }
    }
    
    public static var deviceToken : String? {
        set {
            standard.set(newValue, forKey: Keys.DeviceToken)
            standard.synchronize()
        }
        get {
            return standard.string(forKey: Keys.DeviceToken)
        }
    }
    
    
    public static var LaunchAppHash : String? {
        set {
            standard.set(newValue, forKey: Keys.LaunchAppHash)
            standard.synchronize()
        }
        get {
            return standard.string(forKey: Keys.LaunchAppHash)
        }
    }
    
    
    public static var LoginApiToken : String? {
        set {
            standard.set(newValue, forKey: Keys.LoginToken)
            standard.synchronize()
        }
        get {
            return standard.string(forKey: Keys.LoginToken)
        }
    }
    
    
    public static var userEmail : String? {
        set {
            standard.set(newValue, forKey: Keys.userEmail)
            standard.synchronize()
        }
        get {
            return standard.string(forKey: Keys.userEmail)
        }
    }
    
    public static var userPassword : String? {
        set {
            standard.set(newValue, forKey: Keys.userPassword)
            standard.synchronize()
        }
        get {
            return standard.string(forKey: Keys.userPassword)
        }
    }
    
    
    public static var emailVerified : Bool {
        set {
            standard.set(newValue, forKey: Keys.EmailVerified)
            standard.synchronize()
        }
        get {
            return standard.bool(forKey: Keys.EmailVerified)
        }
    }
    
    
//    public static var ShowInAppsPage : Bool {
//        set {
//            standard.set(newValue, forKey: Keys.ShoppingFunnel)
//            standard.synchronize()
//        }
//        get {
//            return standard.bool(forKey: Keys.ShoppingFunnel)
//        }
//    }
    
    
    public static var AppleAuthIdentifier : String? {
        set {
            standard.set(newValue, forKey: Keys.AppleAuthServiceIdentified)
            standard.synchronize()
        }
        get {
            return standard.string(forKey: Keys.AppleAuthServiceIdentified)
        }
    }
    
    
    public static var ChildAdded : Bool {
        set {
            standard.set(newValue, forKey: Keys.ChildAdded)
            standard.synchronize()
        }
        get {
            return standard.bool(forKey: Keys.ChildAdded)
        }
    }
    //MARK: RIZWAMN+N
    
//    public static var AddChildWithQRScan : Bool {
//        set {
//            standard.set(newValue, forKey: Keys.ActivationFunnel)
//            standard.synchronize()
//        }
//        get {
//            return standard.bool(forKey: Keys.ActivationFunnel)
//        }
//    }
    public static var AddChildWithQRScan : Bool {
        set {
            standard.set(newValue, forKey: Keys.ActivationFunnel)
            standard.synchronize()
        }
        get {
            return standard.bool(forKey: Keys.ActivationFunnel)
            //bool(forKey: Keys.ActivationFunnel)
        }
    }
    
    
}
