//
//  SwiftConstants.swift
//  FamilyTime
//
//  Created by iOS Dev on 26/11/2018.
//  Copyright © 2018 YumyApps. All rights reserved.
//

import Foundation

struct SwiftConstants {
    static let KPhoneLockStatus = "KPhoneLockStatus"
    static let kNotif_update_child_in_db = "kNotif_update_child_in_db"
    static let kRefreshRules = "kRefreshRules"
    static let RELOAD_HOME = "ReloadHome"
    static let SIGNOUT_OBSERVER = "SIGNOUT_OBSERVER"
    static let RELOAD_DASHBOARD = "RELOAD_DASHBOARD"
    static let PICKUP_SOS_INACTIVE_PUSH = "PICK_ME_UP_INACTIVE"
    static let APPROVED_APP_INACTIVE_BACKGROUND = "APPROVED_APP_INACTIVE_BACKGROUND"
    static let kPleaseLogin_String = "\nPlease login to your Web Dashboard and upgrade the subscription and enjoy the premium feature.\n"
    static let kHowToInstallUrl = "https://familytime.io/how-to-install/familytime-child-app.html?utm_source=dashboard&utm_medium=ios&utm_campaign=ActivateChild"
    static let SwiftStoryBoard  = UIStoryboard.init(name: "Dashboard", bundle: nil)
    static let Receipt_not_found = "Receipt Not Found"
    static let SUBSCRIPTION_OBSERVER = "subscription_created_observer"
    
    //---APPLE PRODUCT ITUNES IDS---//
    static let MyFamilyYearly   = "myfamily_yearly"
    static let MyFamily3Yearly  = "myfamily3_yearly"
    static let MyFamily5Yearly  = "myfamily5_yearly"
    static let kGeneralErrorMsg = "alert_check_internet".localized
    static let kReload_Dashboard = "RELOAD_DASHBOARD"
}

struct SwiftTableVuConstants{
    static let kIAP_Detail_Cell_Height = 80
    static let kIAP_Cell_Height = 90
    static let kIAP_Cell_Height_ipad = 112
}

struct SwiftAPIConstants {
    //MARK: BASE URL
    //LIVE
//    static let KBaseURL_Core2 = "https://core2.familytime.io/"
    static let kProfileURL = HLConstants.BASE_URL_CORE_2 + "profile"
    static let kBaseUrl_Mesh2 = HLConstants.BASE_URL_CORE_2
    static let kChildDeleteUrlNew       = kBaseUrl_Mesh2 + "dashboard/device/delete/"
//    static let kLockAndroidDeviceUrl    = HLConstants.BASE_URL_CORE_2 + "dashboard/notifications/pause"
//    static let kLockIOSDeviceUrl        = HLConstants.BASE_URL_CORE_2 + "dashboard/phonelock/"
    static let kLockAndroidDeviceUrl    = kBaseUrl_Mesh2 + "dashboard/notifications/pause"
    static let kLockIOSDeviceUrl        = kBaseUrl_Mesh2 + "dashboard/phonelock/"
    static let kChildRegUrl             = kBaseUrl_Mesh2 + "dashboard/device/add"
    static let KChildEditProfile_mesh2  = kBaseUrl_Mesh2 + "dashboard/device/update/"
    static let KChildEditProfileiOS_mesh2  = kBaseUrl_Mesh2 + "/device/ios/profile"
    static let KChildEditProfileAndroid_mesh2  = kBaseUrl_Mesh2 + "/device/android/profile"
    static let kSaveAndroidDailyLimitSettings_mesh2  = kBaseUrl_Mesh2 + "dashboard/settings/android/lst/dailylimit/"
    static let kUploadDailyLimitUsage_mesh2  = kBaseUrl_Mesh2 + "dashboard/notifications/push/"
    static let kUpdateParentInfo_mesh2       = kBaseUrl_Mesh2 + "dashboard/parentdevice"
    static let kSignup_mesh2                 = kBaseUrl_Mesh2 + "dashboard/signup"
    static let kForgot_password_mesh2        = kBaseUrl_Mesh2 + "dashboard/forgotpassword"
    static let kLogoutUrl_mesh2              = kBaseUrl_Mesh2 + "dashboard/logout"
    static let kValidateReceipt_mesh2        = kBaseUrl_Mesh2 + "dashboard/ios/inapp/validatepurchase"
    static let kAppBlocker_Android_mesh2     = kBaseUrl_Mesh2 + "dashboard/settings/android/lst/appblock/v1/"
    static let kInternetFilters_mesh2        = kBaseUrl_Mesh2 + "dashboard/internetfilters/"
    static let kTerms_mesh2                  = kBaseUrl_Mesh2 + "dashboard/legal/toc"
    static let kPrivacy_mesh2 = kBaseUrl_Mesh2 + "dashboard/legal/privacy"
    static let kUpdateInternetFiltersV1_mesh2 = kBaseUrl_Mesh2 + "dashboard/internetfilters"
    static let kSosPickUpBack           = HLConstants.BASE_URL_CORE_2 + "devices/"
    static let kGetRules_mesh2          = kBaseUrl_Mesh2 + "dashboard/settings/android/lst/screenlock/rules/"
    static let kGetPost_InternetSchedules_mesh2          = kBaseUrl_Mesh2 + "dashboard/settings/android/internet/schedule/"
    static let KPFunTimeUrl_mesh2       = kBaseUrl_Mesh2 + "dashboard/settings/android/funtime/"
    static let KAppUsage_mesh2          = kBaseUrl_Mesh2 + "dashboard/appusage/"
}

let kOFFSET_FOR_KEYBOARD = 80.0
let kOFFSET_FOR_KEYBOARDiPhone6 = 120.0
let child_Id = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)

// MARK: - NEW MESH URLS
//live
let kBasUrlNew_mesh2 = HLConstants.BASE_URL_CORE_2

let KPSignUpUrlNew = "\(kBasUrlNew_mesh2)/dashboard/signup"
let kLoginWithFBNew = "\(kBasUrlNew_mesh2)/dashboard/fbsignin"
let kSignUpWithFBNew = "\(kBasUrlNew_mesh2)/dashboard/fbsignup"
let kLoginWithGoogleNew = "\(kBasUrlNew_mesh2)/dashboard/googlesignin"
let kSignUpWithGoogleNew = "\(kBasUrlNew_mesh2)/dashboard/googlesignup"
let KDashboard_home_mesh2 = "\(kBasUrlNew_mesh2)/dashboard/home/"
let KRefreshDashboard_mesh2 = "\(kBasUrlNew_mesh2)/dashboard/home/refresh/"
let KForgotPswUrlNew = "\(kBasUrlNew_mesh2)/dashboard/forgotpassword"
let KPLoginUrl = "\(kBasUrlNew_mesh2)/dashboard/signin"
let KDailyLimit_mesh2 = "\(kBasUrlNew_mesh2)/dashboard/settings/android/lst/dailylimit/"
let kVerifyEmail_mesh2 = "\(kBasUrlNew_mesh2)/dashboard/verifyemail"
let kIAP_Products_Mesh2 = "\(kBasUrlNew_mesh2)/dashboard/ios/in-app/products/"

func KChildDeleteUrl_NEW(_ child_id: Any) -> String {
    "\(kBasUrlNew_mesh2)/child/delete/\(child_id)"
}

let KChildUpdatePref_Android_Mesh2 = "\(kBasUrlNew_mesh2)/dashboard/settings/android/feature/"
let KChildUpdatePref_IOS_Mesh2 = "\(kBasUrlNew_mesh2)/dashboard/settings/ios/feature/"
let kChildSettings_Notif_Android_Mesh2 = "\(kBasUrlNew_mesh2)/dashboard/settings/android/notifications/"
let kChildSettings_Notif_IOS_Mesh2 = "\(kBasUrlNew_mesh2)/dashboard/settings/ios/notifications/"
let kFamilyMap_Mesh2 = "\(kBasUrlNew_mesh2)/dashboard/notifications/familytimemap/1"
let kChangePassword_mesh2 = "\(kBasUrlNew_mesh2)/dashboard/changepassword"
let KChildEditProfile_mesh2 = "\(kBasUrlNew_mesh2)/dashboard/device/update/"
let kIOSAppBlocker_mesh2 = "\(kBasUrlNew_mesh2)/dashboard/settings/ios/lst/appblock/"
let kPlaces_mesh2 = "\(kBasUrlNew_mesh2)dashboard/settings/places/"
let kPlaces_Delete_ios_mesh2 = "\(kBasUrlNew_mesh2)dashboard/settings/places/ios/"
let kPlaces_Delete_android_mesh2 = "\(kBasUrlNew_mesh2)dashboard/settings/places/android/"
let kGet_Contacts_mesh2 = "\(kBasUrlNew_mesh2)/dashboard/contacts/v2/"
let kAndroid_Sync_settings_mesh2 = "\(kBasUrlNew_mesh2)/dashboard/settings/android/sync/"
let kIOS_Sync_settings_mesh2 = "\(kBasUrlNew_mesh2)devices/\(Int(child_Id ?? "") ?? -1)/sync-settings"
let kContactWatchlist_mesh2 = "\(kBasUrlNew_mesh2)/dashboard/settings/android/contactwatchlist/"
let kCoparents_mesh2 = "\(kBasUrlNew_mesh2)/dashboard/coparents"
let kInvite_Coparent_mesh2 = "\(kBasUrlNew_mesh2)/dashboard/coparent/invite"
let kDelete_Coparent_mesh2 = "\(kBasUrlNew_mesh2)/dashboard/coparent"

//MARK: - Child New Api
let KPFunTimeUrl = "\(kBasUrlNew_mesh2)/v2/ftd/settings/android/funtime/"
let KChildEditProfile = "\(kBasUrlNew_mesh2)/child/edit"
let kSyncSettings = "\(kBasUrlNew_mesh2)devices/\(Int(child_Id ?? "") ?? -1)/sync-settings"

//MARK: - Old URls

let KUserUpdatePhoto = "\(kBasUrlNew_mesh2)/user/updatephoto"
let KParentEditProfile = "\(kBasUrlNew_mesh2)/user/edit"
let kLoginWithFB = "\(kBasUrlNew_mesh2)/v2/ftd/parent/fb_signup"
let kLoginWithGoogle = "\(kBasUrlNew_mesh2)/v2/ftd/parent/google_signup"

//child
let KChildDeleteUrl = "\(kBasUrlNew_mesh2)/child/delete"
let KChildProfile = "\(kBasUrlNew_mesh2)/child/profile"

//Place
let KPlaceHistoryUrlAndroid = "\(kBasUrlNew_mesh2)/dashboard/reports/android/placevisit/"
let KPlaceHistoryUrliOS = "\(kBasUrlNew_mesh2)/dashboard/reports/ios/placevisit/"
let KPlacesReportDatesUrliOS = "\(kBasUrlNew_mesh2)/dashboard/reports/ios/placevisit/checkindates/"
let KPlacesReportDatesUrlAndroid = "\(kBasUrlNew_mesh2)/dashboard/reports/android/placevisit/checkindates/"

//GeoLocation
let KLocationUrlAndroid = "\(kBasUrlNew_mesh2)/dashboard/reports/android/locations/"
let KLocationUrliOS = "\(kBasUrlNew_mesh2)/dashboard/reports/ios/locations/"
let KLocationDatesiOS = "\(kBasUrlNew_mesh2)/dashboard/reports/ios/locations/checkindates/"
let KLocationDatesAndroid = "\(kBasUrlNew_mesh2)/dashboard/reports/android/locations/checkindates/"
let KRemoveContactFromWatchList = "\(kBasUrlNew_mesh2)/contact/removewatch"

//Installed Applicaton
let KInstalledApps = "\(kBasUrlNew_mesh2)/dashboard/apps/"
let KNoneBlackListedApps = "\(kBasUrlNew_mesh2)/installedapp/nonblacklist"

//BrowserLogs
let KBrowserLogs = "\(kBasUrlNew_mesh2)/browsinghistory"

//BookmarksLogs
let KBookmarksLogs = "\(kBasUrlNew_mesh2)/bookmark"

//BookmarksLogs
let KCallLogs = "\(kBasUrlNew_mesh2)/dashboard/calls/"

let kViewParentAll = "/dashboard/coparents" //LIVE
let kViewParentProfile = "/v2/ftd/user/profile/" //LIVE

//MARK: - Constants

let kHeaderToken = "kHeaderToken"
let kForgotUserEmail = "forgotUserEmail"
let kIsNewUser = "kIsNewUser"
let kIsGoogleNewUser = "kIsGoogleNewUser"
let kUpdateParentDataOnce = "kUpdateParentDataOnce"
let kRefreshRules = "kRefreshRules"
let kGetMethod = "GET"
let kPostMethod = "POST"
let kDeleteMethod = "DELETE"
let kPutMethod = "PUT"
let kPatchMethod = "PATCH"

let kHowToInstallUrl = "https://familytime.io/how-to-install/familytime-child-app.html?utm_source=dashboard&utm_medium=ios&utm_campaign=ActivateChild"

//Constants

func kTextColor() -> UIColor {
    UIColor.black //[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1]
}
func kBarTextColor() -> UIColor {
    UIColor(red: 22 / 255.0, green: 151 / 255.0, blue: 191 / 255.0, alpha: 1)
}

func kBarTintColor() -> UIColor {
    UIColor(red: 191 / 255.0, green: 208 / 255.0, blue: 249 / 255.0, alpha: 1)
}
func kNavBarTintColor() -> UIColor {
    UIColor(red: 243 / 255.0, green: 242 / 255.0, blue: 242 / 255.0, alpha: 1)
}
func KSetBG(_ R: CGFloat, _ G: CGFloat, _ B: CGFloat, _ A: CGFloat) -> UIColor {
    UIColor(red: R / 255.0, green: G / 255.0, blue: B / 255.0, alpha: A)
}
func KListHeadingBGColor() -> UIColor {
    UIColor(red: 247 / 255.0, green: 247 / 255.0, blue: 247 / 255.0, alpha: 1)
}
func KListDetailColor() -> UIColor {
    UIColor(red: 153 / 255.0, green: 153 / 255.0, blue: 153 / 255.0, alpha: 1)
}

//-------------------------SANA COLORS--------------------//

func KDashboardRedColor() -> UIColor {
    UIColor(red: 183 / 255.0, green: 26 / 255.0, blue: 26 / 255.0, alpha: 1)
}
func KDashboardGreyBtnColor() -> UIColor {
    UIColor(red: 126 / 255.0, green: 120 / 255.0, blue: 120 / 255.0, alpha: 1)
}
func KDashboardBlueBtnColor() -> UIColor {
    UIColor(red: 19 / 255.0, green: 150 / 255.0, blue: 239 / 255.0, alpha: 1)
}

func kPrimaryColor() -> UIColor {
    UIColor(red: 0 / 255.0, green: 166 / 255.0, blue: 210 / 255.0, alpha: 1)
}

//user bg color
let kOrangeColor = "#ff8400"
let kGreenColor = "#a2c922"
let kPurpleColor = "#7266ba"
let kredColor = "#f05050"
let kBlueColor = "#1da6d0"

let k_IAP_YellowColor = "#FFB81D"

let KCallColor = [CommonModel.color(fromHexString: "orange"), CommonModel.color(fromHexString: "purple"), CommonModel.color(fromHexString: "red"), CommonModel.color(fromHexString: "green")]
let KCallDisabledColor = [KSetBG(168, 168, 168, 1), KSetBG(208, 207, 207, 1), KSetBG(112, 112, 112, 1), KSetBG(80, 80, 80, 1)]

//location
let kGoogleMapKey = "" // TODO: inject via Config.xcconfig
let LOGUPLOAD_SERVER_INTERVAL = 20 * 60 //20 MINUTES;
let DISTANCE_FILTER = 33.0 // 100 feet kCLDistanceFilterNone//
let LOC_MANAGER_INTERVAL = 5 * 60 //5 MINUTES

//texfield styles
func kTFColor(_ x: String) -> NSAttributedString {
    NSAttributedString(string: x, attributes: [
        NSAttributedString.Key.foregroundColor: UIColor.white
    ])
}

let KPhoneLockStatus = "KPhoneLockStatus"

//MARK: Encryption key for getting AWS Credentionals
let kEncryptionKey = "SneakProAWSCredt"
let kEncryptionString = "AWSACTUALCREDENTIALS"

//MARK: Encryption key used for encrypting user data
let kJSONACTIVEDATA = "JSONACTIVEDATA"

//MARK: Encryption key used for encrypting file names
let kFileNames = "kJFilesNames"

//MARK:  Constants for the Bucket
let S3TRANSFERMANAGER_BUCKET = "familytime"

//MARK: Bucket constant messages
let CREDENTIALS_ERROR_TITLE = "Missing Credentials"
let CREDENTIALS_ERROR_MESSAGE = "AWS Credentials not configured correctly.  Please review the README file."

//MARK: Colors
let kDarkGray = "kDarkGray"
let kSendHeaders = "kSendHeaders"
let kNO = "kNO"
let kYES = "kYES"
let kDeviceToken = "deviceToken"
let kUnauthenticated = "Unauthenticated"
let kLogoutStatus = "eX00401"

func RGBCOLOR(_ R: CGFloat, _ G: CGFloat, _ B: CGFloat, _ A: CGFloat) -> UIColor {
    UIColor(red: R / 255.2, green: G / 255.2, blue: B / 255.2, alpha: A)
}

//MARK: - KEYS
let kLaunchAppHash = "LaunchApp_Hash"
let kUserEmail = "userEmail"
let kUserPassword = "userPassword"
let kEmailVerified = "EmailVerified"
let kChildAdded = "ChildAdded"
let kActivationFunnel = "ActivationFunnel"
let kShoppingFunnel = "ShoppingFunnel"
