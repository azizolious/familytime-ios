//
//  HLConstants.swift
//  FamilyTime
//
//  Created by Sana-Ullah-IOS on 11/03/2020.
//  Copyright © 2020 YumyApps. All rights reserved.
//
//  MARK:- By Hammad Lodhi

import Foundation
import SwiftUI

class HLConstants {
    /// NEW Base URL for STAGIng
//    static let BASE_URL_CORE_2 = "https://stgcore.familytime.io/"
    
    // for live
    static let BASE_URL_CORE_2 = "https://core.familytime.io/" // Core Live
    
    struct URLs {
        struct AUTH {
            public static let SignUp_SignIn = BASE_URL_CORE_2 + "api/old/login"
            public static let auth = BASE_URL_CORE_2 + "api/old/auth"
            public static let Forgot_Password = BASE_URL_CORE_2 + "dashboard/forgotpassword"
            public static let notification_feeds = BASE_URL_CORE_2 + "dashboard/notifications/feeds/atlaunch"
            public static let verifyUserURL = BASE_URL_CORE_2 + "api/old/check-verified-user"
            
            //New SignIn URL For Core2
            public static let signInCore2 = BASE_URL_CORE_2 + "login"
            public static let generateCoreOldToken = BASE_URL_CORE_2 + "api/v1/signin"
            public static let generateCore2Token = BASE_URL_CORE_2 + "generate-bearer-token"
            public static let appCongigurations = BASE_URL_CORE_2 + "v1/app-configurations/ios"
            public static let generateQRCode = BASE_URL_CORE_2 + "generate-qr-code"
            public static let logoutCore2 = BASE_URL_CORE_2 + "logout"
            public static let forgetPasswordCore2 = BASE_URL_CORE_2 + "forget-password"
            public static let accountCore = BASE_URL_CORE_2 + "account"
        }
        struct FUNNEL {
            public static let activation = BASE_URL_CORE_2 + "device/ios/activationfunnel"
        }
        struct Child {
            public static let deleteChildCore2 = BASE_URL_CORE_2 + "children/"
            struct Settings {
                struct ContentFilters {
                    public static let Root = BASE_URL_CORE_2 + "dashboard/settings/ios/contentfilters/"
//                    public static let dashboardApi2 = "https://core.familytime.io/api/old/home"
                    public static let Apps = Root + "apps/{child_id}"
                    public static let Movies = Root + "movies/{child_id}"
                    public static let TVShows = Root + "tvshows/{child_id}"
                    public static let ExplicitContents = Root + "explicitcontent/{child_id}"
                    public static let BookStoreErotica = Root + "bookstoreerotica/{child_id}"
                }
            }
            
            struct Summary {
                
                public static let Api = BASE_URL_CORE_2 + "dashboard/report/stats"
                
            }
            
            struct Dashboard {
                public static let homeApiCore2 = BASE_URL_CORE_2 + "home"
                public static let emailVerification = BASE_URL_CORE_2 + "user/verify-email"
                public static let emailComplaint = BASE_URL_CORE_2 + "user/email-complaints/fix"
                public static let emailBounce = BASE_URL_CORE_2 + "user/email-bounce/fix"
                public static let updateProfile = BASE_URL_CORE_2 + "profile"
                public static let subscriptionCancelled = BASE_URL_CORE_2 + "pending-purchase"
            }
        }
        struct AppHistory {
            public static let Web_History = BASE_URL_CORE_2 + "reports/web-history"
            public static let Youtube_History = BASE_URL_CORE_2 + "reports/youtube-history"
            public static let TikToke_History = BASE_URL_CORE_2 + "reports/tiktok-history"
            public static let social_History = BASE_URL_CORE_2 + "reports/social-monitoring"
        }
        
        struct AproveApp {
            public static let update_ApproveApp = BASE_URL_CORE_2 + "devices/"
        }
    }
}
struct Theme {
    
    static let PrimaryBlueColor = UIColor(hexString: "#1D8DF9")
    static let NavBarItemColor = UIColor(hexString: "#00a6d2")
    static let GreenColor = UIColor(hexString: "#1D8600")
    
}

struct NotificationKeys {
    let GmailAuthentication = NSNotification.Name(rawValue: "ToggleAuthUINotification")
}


//MARK: -  DEVICE RELATED METHODS & PROPERTIES
struct ScreenSize
{
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct Version{
    static let SYS_VERSION_FLOAT = (UIDevice.current.systemVersion as NSString).floatValue
    static let iOS9 = (Version.SYS_VERSION_FLOAT >= 9.0 && Version.SYS_VERSION_FLOAT < 10.0)
    static let iOS10 = (Version.SYS_VERSION_FLOAT >= 10.0 && Version.SYS_VERSION_FLOAT < 11.0)
    static let iOS11 = (Version.SYS_VERSION_FLOAT >= 11.0 && Version.SYS_VERSION_FLOAT < 12.0)
    static let iOS12 = (Version.SYS_VERSION_FLOAT >= 12.0)
}

struct VersionAndNewer {
    static let iOS9 = (Version.SYS_VERSION_FLOAT >= 9.0)
    static let iOS10 = (Version.SYS_VERSION_FLOAT >= 10.0)
    static let iOS11 = (Version.SYS_VERSION_FLOAT >= 11.0)
    static let iOS12 = (Version.SYS_VERSION_FLOAT >= 12.0)
    
}

public enum UIUserInterfaceIdiom : Int {

    case unspecified

    case phone // iPhone and iPod touch style UI

    case pad // iPad style UI

    @available(iOS 9.0, *)
    case tv // Apple TV style UI

    @available(iOS 9.0, *)
    case carPlay // CarPlay style UI
}


public enum DeviceType {
    case unknown
    case iphone4
    case iphone5
    case iphone6
    case iphone6plus
    static let iphone7 = iphone6
    static let iphone7plus = iphone6plus
    case iphoneX
    case iphoneXMax
    case iphoneXR
    case iphone12Pro
    case iphone12ProMax
    case iphone14
    case iphone14ProMax
}

@objc
public class Device: NSObject {
    
    static var width:CGFloat     { return UIScreen.main.bounds.size.width }
    static var height:CGFloat    { return UIScreen.main.bounds.size.height }
    static var maxLength:CGFloat { return max(width, height) }
    static var minLength:CGFloat { return min(width, height) }
    static var zoomed:Bool       { return UIScreen.main.nativeScale >= UIScreen.main.scale }
    static var retina:Bool       { return UIScreen.main.scale >= 2.0 }
    static var phone:Bool        { return UIDevice.current.userInterfaceIdiom == .phone }
    static var pad:Bool          { return UIDevice.current.userInterfaceIdiom == .pad }
    static var carplay:Bool      { return UIDevice.current.userInterfaceIdiom == .carPlay }
    static var tv:Bool           { return UIDevice.current.userInterfaceIdiom == .tv }
    
    static var typeIsLike:DeviceType {
        if phone && maxLength < 568 {
            return .iphone4
        }
        else if phone && maxLength == 568 {
            return .iphone5
        }
        else if phone && maxLength == 667 {
            return .iphone6
        }
        else if phone && maxLength == 736 {
            return .iphone6plus
        }
        else if phone && maxLength == 812 {
            return .iphoneX
            
        }else if phone && maxLength == 844 {
            return .iphone14
            
        }else if phone && maxLength == 896 {
            return .iphoneXMax
            
        }else if phone && maxLength == 932 {
            return .iphone14ProMax
            
        }
        return .unknown
    }
}

@objc
class Colors: NSObject {
    static let kTheme_red       = "red"
    static let kTheme_orange    = "orange"
    static let kTheme_yellow    = "yellow"
    static let kTheme_green     = "green"
    static let kTheme_purple    = "purple"
    static let kTheme_blue      = "blue"
    static let kTheme_grey      = "gray"
    static func RGB(_ red: Int, _ green: Int, _ blue: Int, alpha: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, a: alpha)
    }
    
}

extension Color {
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let length = hexSanitized.count
        let r, g, b, a: Double
        
        switch length {
        case 3: // RGB (12-bit, e.g. FFF)
            r = Double((rgb >> 8) & 0xF) / 15.0
            g = Double((rgb >> 4) & 0xF) / 15.0
            b = Double(rgb & 0xF) / 15.0
            a = 1.0
        case 6: // RRGGBB (24-bit, e.g. FF0000)
            r = Double((rgb >> 16) & 0xFF) / 255.0
            g = Double((rgb >> 8) & 0xFF) / 255.0
            b = Double(rgb & 0xFF) / 255.0
            a = 1.0
        case 8: // RRGGBBAA (32-bit, e.g. FF000080)
            r = Double((rgb >> 24) & 0xFF) / 255.0
            g = Double((rgb >> 16) & 0xFF) / 255.0
            b = Double((rgb >> 8) & 0xFF) / 255.0
            a = Double(rgb & 0xFF) / 255.0
        default:
            r = 1.0; g = 1.0; b = 1.0; a = 1.0 // fallback = white
        }
        
        self.init(.sRGB, red: r, green: g, blue: b, opacity: a)
    }
}
