//
//  FIRConstants.h
//  FamilyTime
//
//  Created by iOS Dev on 22/11/2018.
//  Copyright © 2018 YumyApps. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//---REGISTRATION---//

#define kFIR_AppLaunches    @"App Launches"
#define kFIR_Login          @"Login"
#define kFIR_Signup         @"Signup"
#define kFIR_Inactive       @"Inactive"
#define kFIR_Active         @"Active"
#define kFIR_Email          @"Email"
#define kFIR_Facebook       @"Facebook"
#define kFIR_Google         @"Google"
#define kFIR_Account        @"Account"

//---DASHBOARD---//
#define kFIR_MyFamily       @"MyFamily"
#define kFIR_Reports        @"Reports"
#define kFIR_Settings       @"Settings"
#define kFIR_LockDevice     @"LockDevice"
#define kFIR_UnLockDevice   @"Unlock Device"
#define kFIR_DeleteDevice   @"Delete Device"
#define kFIR_AddDevice      @"Add Device"
#define kFIR_FamilyMap      @"Family Map"
#define kFIR_HowToActivate  @"How to Activate"

//---NAVIGATION MENU---//

#define kFIR_MainNav                @"Main Nav"
#define kFIR_Help                   @"Help"
#define kFIR_Logout                 @"Logout"
#define kFIR_ChangePassword         @"Change Passowrd"

#define kFIR_ReportNav              @"Report Nav"
#define kFIR_LocationHistory        @"Location History"
#define kFIR_Contacts               @"Contacts"

#define kFIR_WebHistory             @"Web History"
#define kFIR_Bookmarks              @"Bookmarks"
#define kFIR_CallHistory            @"Call History"
#define kFIR_PlaceVisits            @"Place Visits"
#define kFIR_InstalledApps          @"Installed Apps"
#define kFIR_AppUsage               @"App Usage"
#define kFIR_DeviceInfo             @"Device Info"
#define kFIR_TextMessages           @"Text Messages"



//---GENERAL KEYS---//

#define kFIR_Empty          @""






#define kFIR_SUCCESS        @"Success"
#define kFIR_Failed         @"Failed"



#define kAppVersion         [NSString stringWithFormat:@"AppVersion (%@)", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]

//#define kAppVersion         [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]


@interface FIRConstants : NSObject

@end

NS_ASSUME_NONNULL_END
