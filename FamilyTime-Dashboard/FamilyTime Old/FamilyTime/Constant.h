//
//  Constant.h
//  FamilyTime
//
//  Created by Sora Code on 11/19/14.
//  Copyright (c) 2014 SoraCode. All rights reserved.
//

//#define kRADIUS 500
#import <Foundation/Foundation.h>

#define kOFFSET_FOR_KEYBOARD 80.0
#define kOFFSET_FOR_KEYBOARDiPhone6 120.0

//--------------------------------------NEW MESH2 URLS-------------------//

#pragma mark NEW MESH URLS

#define     kBasUrlNew_mesh2                 @"https://core.familytime.io"//LIVE
//#define     kBasUrlNew_mesh2                 @"https://stgcore.familytime.io"//STAGGING


#define     KPSignUpUrlNew              [NSString stringWithFormat:@"%@/dashboard/signup",kBasUrlNew_mesh2]
#define     kLoginWithFBNew             [NSString stringWithFormat:@"%@/dashboard/fbsignin",kBasUrlNew_mesh2]
#define     kSignUpWithFBNew            [NSString stringWithFormat:@"%@/dashboard/fbsignup",kBasUrlNew_mesh2]
#define     kLoginWithGoogleNew         [NSString stringWithFormat:@"%@/dashboard/googlesignin",kBasUrlNew_mesh2]
#define     kSignUpWithGoogleNew        [NSString stringWithFormat:@"%@/dashboard/googlesignup",kBasUrlNew_mesh2]
#define     KDashboard_home_mesh2       [NSString stringWithFormat:@"%@/dashboard/home/",kBasUrlNew_mesh2]
#define     KRefreshDashboard_mesh2     [NSString stringWithFormat:@"%@/dashboard/home/refresh/",kBasUrlNew_mesh2]
#define     KForgotPswUrlNew            [NSString stringWithFormat:@"%@/dashboard/forgotpassword",kBasUrlNew_mesh2]
#define     KPLoginUrl                  [NSString stringWithFormat:@"%@/dashboard/signin",kBasUrlNew_mesh2]
#define     KDailyLimit_mesh2           [NSString stringWithFormat:@"%@/dashboard/settings/android/lst/dailylimit/",kBasUrlNew_mesh2]

#define     kVerifyEmail_mesh2          [NSString stringWithFormat:@"%@/dashboard/verifyemail",kBasUrlNew_mesh2]
#define     kLogoutUrl_mesh2            [NSString stringWithFormat:@"%@/v1/logout", kBasUrlNew_mesh2]
#define     kIAP_Products_Mesh2         [NSString stringWithFormat:@"%@/dashboard/ios/in-app/products/",kBasUrlNew_mesh2]


#define     KChildDeleteUrl_NEW(child_id)         [NSString stringWithFormat:@"%@/child/delete/%@", kBasUrlNew_mesh2, child_id]

#define     KChildUpdatePref_Android_Mesh2        [NSString stringWithFormat:@"%@/dashboard/settings/android/feature/",kBasUrlNew_mesh2]
#define     KChildUpdatePref_IOS_Mesh2            [NSString stringWithFormat:@"%@/dashboard/settings/ios/feature/",kBasUrlNew_mesh2]

#define     kChildSettings_Notif_Android_Mesh2    [NSString stringWithFormat:@"%@/dashboard/settings/android/notifications/",kBasUrlNew_mesh2]
#define     kChildSettings_Notif_IOS_Mesh2        [NSString stringWithFormat:@"%@/dashboard/settings/ios/notifications/",kBasUrlNew_mesh2]
#define     kFamilyMap_Mesh2                      [NSString stringWithFormat:@"%@/dashboard/notifications/familytimemap/1",kBasUrlNew_mesh2]



#define     kChangePassword_mesh2         [NSString stringWithFormat:@"%@/dashboard/changepassword",kBasUrlNew_mesh2]
#define     KChildEditProfile_mesh2       [NSString stringWithFormat:@"%@/dashboard/device/update/",kBasUrlNew_mesh2]
#define     kIOSAppBlocker_mesh2          [NSString stringWithFormat:@"%@/dashboard/settings/ios/lst/appblock/",kBasUrlNew_mesh2]

#define     kPlaces_mesh2                 [NSString stringWithFormat:@"%@/dashboard/settings/places/",kBasUrlNew_mesh2]
#define     kPlaces_Delete_ios_mesh2      [NSString stringWithFormat:@"%@/dashboard/settings/places/ios/",kBasUrlNew_mesh2]
#define     kPlaces_Delete_android_mesh2  [NSString stringWithFormat:@"%@/dashboard/settings/places/android/",kBasUrlNew_mesh2]

#define     kGet_Contacts_mesh2           [NSString stringWithFormat:@"%@/dashboard/contacts/v2/",kBasUrlNew_mesh2]

#define     kAndroid_Sync_settings_mesh2  [NSString stringWithFormat:@"%@/dashboard/settings/android/sync/",kBasUrlNew_mesh2]
#define     kIOS_Sync_settings_mesh2      [NSString stringWithFormat:@"%@/dashboard/settings/ios/sync/",kBasUrlNew_mesh2]

#define     kContactWatchlist_mesh2       [NSString stringWithFormat:@"%@/dashboard/settings/android/contactwatchlist/",kBasUrlNew_mesh2]
#define     kCoparents_mesh2              [NSString stringWithFormat:@"%@/dashboard/coparents",kBasUrlNew_mesh2]
#define     kInvite_Coparent_mesh2        [NSString stringWithFormat:@"%@/dashboard/coparent/invite",kBasUrlNew_mesh2]
#define     kDelete_Coparent_mesh2        [NSString stringWithFormat:@"%@/dashboard/coparent",kBasUrlNew_mesh2]




//#define     kPlaceEdit_Add_mesh2          [NSString stringWithFormat:@"%@/dashboard/settings/places/",kBasUrlNew_mesh2]


//--------------------------------------NEW MESH2 URLS-------------------//



#pragma mark - CHILD NEW APIS



//http://mesh.familytime.io/contact?child_id=1
//#define     kBasUrlNew_mesh2                @"https://mesh2.familytime.io"//LIVE
//#define     kBasUrlNew_mesh2                @"https://meshstg.familytime.io/"//LIVE
//#define     UpdateWebFilter           @"/dashboard/internetfilters"

//#define     kBasUrl                   @"https://mesh.familytime.io"//LIVE
//#define     kBasUrl                 @"https://meshstg.familytime.io"//STAGGING



#define     KPFunTimeUrl              [NSString stringWithFormat:@"%@/v2/ftd/settings/android/funtime/",kBasUrlNew_mesh2]
//dashboard/signin
///dashboard/signup






//---SANA CHANGE---//---COMMENT OUT UNUSED APIS---//


//#define     KVerifyActivation       [NSString stringWithFormat:@"%@/user/verifyemail",kBasUrl]
//#define     KForgotPswUrl           [NSString stringWithFormat:@"%@/user/forgotpassword",kBasUrl]
//#define     KParentProfile          [NSString stringWithFormat:@"%@/user/profile",kBasUrl]
//#define     KChildPreference        [NSString stringWithFormat:@"%@/child/preference",kBasUrl]
//#define     KChildActUrl            [NSString stringWithFormat:@"%@/child/activate",kBasUrl]
//#define     KChildUpdatePref        [NSString stringWithFormat:@"%@/child/updatepref",kBasUrl]
//#define     KPush                   [NSString stringWithFormat:@"%@/pushnotification",kBasUrl]
//#define     KPushBack               [NSString stringWithFormat:@"%@/pushnotification/pushback",kBasUrl]
//#define     KChildUpdatePhoto       [NSString stringWithFormat:@"%@/child/updatephoto",kBasUrl]
//#define     KChildUpdatePushToken   [NSString stringWithFormat:@"%@/child/updatetoken",kBasUrl]
//#define     KChildPhonelock         [NSString stringWithFormat:@"%@/pushnotification/phonelock",kBasUrl]
//#define     KChildPhonelockACK      [NSString stringWithFormat:@"%@/pushnotification/phonelockback",kBasUrl]
//#define     KAppusageDates          [NSString stringWithFormat:@"%@/appusage/checkindates",kBasUrl]
//#define     KDashboard              [NSString stringWithFormat:@"%@/child/mychildren?id=",kBasUrl]
//#define     KAddContacts            [NSString stringWithFormat:@"%@/contact/add",kBasUrl]
//#define     KEditContacts           [NSString stringWithFormat:@"%@/contact/edit",kBasUrl]
//#define     KAddBrowserLogs         [NSString stringWithFormat:@"%@/browsinghistory/add",kBasUrl]
//#define     Api_FamilyMap           @"/v2/push/familytimemap/"
//#define     KUserAddUrl             [NSString stringWithFormat:@"%@/user/addios",kBasUrl]
//#define     KChildRegUrl            [NSString stringWithFormat:@"%@/child/add",kBasUrl]
//#define     KUpdatePushToken        [NSString stringWithFormat:@"%@/user/updatetoken",kBasUrl]
//#define     kRules                  [NSString stringWithFormat:@"%@/rule",kBasUrl]
//#define     kRuleEdit               [NSString stringWithFormat:@"%@/rule/edit",kBasUrl]
//#define     kRuleAdd                [NSString stringWithFormat:@"%@/rule/add",kBasUrl]
//#define     kRuleDelete             [NSString stringWithFormat:@"%@/rule/delete",kBasUrl]
//#define     KDashboardNew           [NSString stringWithFormat:@"%@/v2/ftd/dashboard/",kBasUrl]
//#define     KContactNoneWatchList   [NSString stringWithFormat:@"%@/contact/nonwatchlist",kBasUrl]
//#define     KAddBookmarksLogs       [NSString stringWithFormat:@"%@/bookmark/add",kBasUrl]
//#define     KAddCallLogs            [NSString stringWithFormat:@"%@/call/add",kBasUrl]
//#define     KBlackListedApps        [NSString stringWithFormat:@"%@/installedapp/blacklist",kBasUrl]

//#define     KRemoveBlackListedApp   [NSString stringWithFormat:@"%@/installedapp/removeblack",kBasUrl]
//#define     KAddAppToBlackList      [NSString stringWithFormat:@"%@/installedapp/addblack",kBasUrl]
//#define     KSendActivationCoparent [NSString stringWithFormat:@"%@/v2/ftd/user/invite",kBasUrl]
//#define     Api_VersionCheck        @"/v2/ftd/parent/latestiphoneappversion"

//#define     kChangePassword         [NSString stringWithFormat:@"%@/user/reset",kBasUrl]

#define     KChildEditProfile       [NSString stringWithFormat:@"%@/child/edit",kBasUrlNew_mesh2]

//#define kSyncSettingsUpdateForApp   [NSString stringWithFormat:@"%@/v2/ftd/settings/ios/appblocker",kBasUrl]

//Sync Settings
//#define kSyncSettingsAll            [NSString stringWithFormat:@"%@/v2/ftd/settings/ios/appblocker",kBasUrl]
//#define KPlaces                     [NSString stringWithFormat:@"%@/place",kBasUrl]

//#define KPlaceEditUrl               [NSString stringWithFormat:@"%@/place/edit",kBasUrl]
//#define KPlaceAddUrl                [NSString stringWithFormat:@"%@/place/add",kBasUrl]
//#define KPlacedeleteUrl             [NSString stringWithFormat:@"%@/place/delete",kBasUrl]

//#define KContacts               [NSString stringWithFormat:@"%@/contact",kBasUrl]
//#define KDeleteContacts         [NSString stringWithFormat:@"%@/contact/delete",kBasUrl]
#define kSyncSettings             [NSString stringWithFormat:@"%@/dashboard/settings/ios/sync",kBasUrlNew_mesh2]
//#define KContactWatchList           [NSString stringWithFormat:@"%@/v2/ftd/settings/android/contactwatchlist/",kBasUrl]
//#define Api_Invite_coparent                @"/v2/ftd/user/invite"
//#define KLocationAddUrl         [NSString stringWithFormat:@"%@/geolocation/add",kBasUrl]

//#define KAddContactToWatchList      [NSString stringWithFormat:@"%@/contact/addwatchios",kBasUrl]


//---SANA CHANGE---//---COMMENT OUT UNUSED APIS---//


#pragma mark OLD URLS

#define     KUserUpdatePhoto        [NSString stringWithFormat:@"%@/user/updatephoto",kBasUrlNew_mesh2]
#define     KParentEditProfile      [NSString stringWithFormat:@"%@/user/edit",kBasUrlNew_mesh2]

#define     kLoginWithFB            [NSString stringWithFormat:@"%@/v2/ftd/parent/fb_signup",kBasUrlNew_mesh2]
#define     kLoginWithGoogle        [NSString stringWithFormat:@"%@/v2/ftd/parent/google_signup",kBasUrlNew_mesh2]

//child

#define     KChildDeleteUrl         [NSString stringWithFormat:@"%@/child/delete",kBasUrlNew_mesh2]
#define     KChildProfile           [NSString stringWithFormat:@"%@/child/profile",kBasUrlNew_mesh2]





//place

//#define KPlacesReportDatesUrl   [NSString stringWithFormat:@"%@/dashboard/reports/ios/placevisit",kBasUrlNew_mesh2]
//#define KPlaceHistoryUrl        [NSString stringWithFormat:@"%@/placevisit",kBasUrl]
#define KPlaceHistoryUrlAndroid           [NSString stringWithFormat:@"%@/dashboard/reports/android/placevisit/",kBasUrlNew_mesh2]
#define KPlaceHistoryUrliOS           [NSString stringWithFormat:@"%@/dashboard/reports/ios/placevisit/",kBasUrlNew_mesh2]
#define KPlacesReportDatesUrliOS          [NSString stringWithFormat:@"%@/dashboard/reports/ios/placevisit/checkindates/",kBasUrlNew_mesh2]
#define KPlacesReportDatesUrlAndroid          [NSString stringWithFormat:@"%@/dashboard/reports/android/placevisit/checkindates/",kBasUrlNew_mesh2]
//GeoLocation

#define KLocationUrlAndroid           [NSString stringWithFormat:@"%@/dashboard/reports/android/locations/",kBasUrlNew_mesh2]
#define KLocationUrliOS           [NSString stringWithFormat:@"%@/dashboard/reports/ios/locations/",kBasUrlNew_mesh2]
#define KLocationDatesiOS          [NSString stringWithFormat:@"%@/dashboard/reports/ios/locations/checkindates/",kBasUrlNew_mesh2]
#define KLocationDatesAndroid          [NSString stringWithFormat:@"%@/dashboard/reports/android/locations/checkindates/",kBasUrlNew_mesh2]


#define KRemoveContactFromWatchList [NSString stringWithFormat:@"%@/contact/removewatch",kBasUrlNew_mesh2]


//Installed Applicaton
#define KInstalledApps          [NSString stringWithFormat:@"%@/dashboard/apps/",kBasUrlNew_mesh2]
#define KNoneBlackListedApps    [NSString stringWithFormat:@"%@/installedapp/nonblacklist",kBasUrlNew_mesh2]

//BrowserLogs
#define KBrowserLogs            [NSString stringWithFormat:@"%@/browsinghistory",kBasUrlNew_mesh2]

//BookmarksLogs
#define KBookmarksLogs          [NSString stringWithFormat:@"%@/bookmark",kBasUrlNew_mesh2]

//BookmarksLogs
#define KCallLogs               [NSString stringWithFormat:@"%@/dashboard/calls/",kBasUrlNew_mesh2]


#define     kViewParentAll                 @"/dashboard/coparents"//LIVE
#define     kViewParentProfile             @"/v2/ftd/user/profile/"//LIVE


#pragma mark CONSTANTS

//--------------------------------------CONSTANTS-------------------//

#define kHeaderToken                @"kHeaderToken"
#define kForgotUserEmail            @"forgotUserEmail"
#define kIsNewUser                  @"kIsNewUser"
#define kIsGoogleNewUser            @"kIsGoogleNewUser"

#define kUpdateParentDataOnce       @"kUpdateParentDataOnce"
#define kRefreshRules               @"kRefreshRules"


#define kGetMethod                  @"GET"
#define kPostMethod                 @"POST"
#define kDeleteMethod               @"DELETE"
#define kPutMethod                  @"PUT"
#define kPatchMethod                @"PATCH"



#define kHowToInstallUrl            @"https://familytime.io/how-to-install/familytime-child-app.html?utm_source=dashboard&utm_medium=ios&utm_campaign=ActivateChild"


//--------------------------------------CONSTANTS-------------------//


//text Color
#define kTextColor()  [UIColor blackColor]//[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1]
#define kBarTextColor() [UIColor colorWithRed:22/255.0 green:151/255.0 blue:191/255.0 alpha:1]
//#define kBarTextColor() [UIColor colorWithRed:102/255.0 green:204/255.0 blue:102/255.0 alpha:1]
#define kBarTintColor() [UIColor colorWithRed:191/255.0 green:208/255.0 blue:249/255.0 alpha:1]
#define kNavBarTintColor() [UIColor colorWithRed:243/255.0 green:242/255.0 blue:242/255.0 alpha:1]
#define KSetBG(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
//[UIColor colorWithRed:65/255.0 green:103/255.0 blue:54/255.0 alpha:1]

////list colors
#define KListHeadingBGColor() [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1]
//#define KListHeadingColor() [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1]
//#define KListTextColor() [UIColor colorWithRed:96/255.0 green:96/255.0 blue:96/255.0 alpha:1]
#define KListDetailColor() [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]

//-------------------------SANA COLORS--------------------//

#define KDashboardRedColor()        [UIColor colorWithRed:183/255.0 green:26/255.0 blue:26/255.0 alpha:1]
#define KDashboardGreyBtnColor()    [UIColor colorWithRed:126/255.0 green:120/255.0 blue:120/255.0 alpha:1]
#define KDashboardBlueBtnColor()    [UIColor colorWithRed:19/255.0 green:150/255.0 blue:239/255.0 alpha:1]

#define kPrimaryColor()    [UIColor colorWithRed:0/255.0 green:166/255.0 blue:210/255.0 alpha:1]

//-------------------------SANA COLORS--------------------//

//user bg color
#define kOrangeColor @"#ff8400"
#define kGreenColor  @"#a2c922"
#define kPurpleColor @"#7266ba"
#define kredColor    @"#f05050"
#define kBlueColor   @"#1da6d0"

#define k_IAP_YellowColor @"#FFB81D"


#define KCallColor [[NSArray alloc] initWithObjects:[CommonModel colorFromHexString:@"orange"],[CommonModel colorFromHexString:@"purple"], [CommonModel colorFromHexString:@"red"], [CommonModel colorFromHexString:@"green"],nil]
#define KCallDisabledColor [[NSArray alloc] initWithObjects:KSetBG(168, 168, 168, 1),KSetBG(208, 207, 207, 1),KSetBG(112, 112, 112, 1),KSetBG(80, 80, 80, 1), nil]

//location
#define     kGoogleMapKey                   @"AIzaSyB2MKLJ9-RwtH4yDmO-RZJOLN0YGUVKZLQ"
#define     LOGUPLOAD_SERVER_INTERVAL       20*60  //20 MINUTES;
#define     DISTANCE_FILTER                 33.0f // 100 feet kCLDistanceFilterNone//
#define     LOC_MANAGER_INTERVAL            5*60 //5 MINUTES



//texfield styles
#define kTFColor(x) [[NSAttributedString alloc] initWithString:x attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}]

#define KPhoneLockStatus @"KPhoneLockStatus"

/**Encryption key for getting AWS Credentionals*/
#define kEncryptionKey @"SneakProAWSCredt"
#define kEncryptionString @"AWSACTUALCREDENTIALS"
/**Encryption key used for encrypting user data*/
#define kJSONACTIVEDATA @"JSONACTIVEDATA"

/**Encryption key used for encrypting file names*/
#define kFileNames @"kJFilesNames"

//// Constants for the Bucket
#define S3TRANSFERMANAGER_BUCKET   @"familytime"
/**Bucket constant messages*/
#define CREDENTIALS_ERROR_TITLE    @"Missing Credentials"
#define CREDENTIALS_ERROR_MESSAGE  @"AWS Credentials not configured correctly.  Please review the README file."



//----------------------------COLORS-------------------//

#define kDarkGray      @"kDarkGray"

#define kSendHeaders   @"kSendHeaders"
#define kNO            @"kNO"
#define kYES           @"kYES"
#define kDeviceToken   @"deviceToken"

#define kUnauthenticated   @"Unauthenticated"
#define kLogoutStatus      @"eX00401"




@interface Constant : NSObject

/**
 * Creating bucket
 */
+ (NSString *)transferManagerBucket;

@end



#pragma mark KEYS

#define kLaunchAppHash                      @"LaunchApp_Hash"
#define kUserEmail                          @"userEmail"
#define kUserPassword                       @"userPassword"
#define kEmailVerified                      @"EmailVerified"
#define kChildAdded                         @"ChildAdded"
#define kActivationFunnel                   @"ActivationFunnel"
#define kShoppingFunnel                     @"ShoppingFunnel"
