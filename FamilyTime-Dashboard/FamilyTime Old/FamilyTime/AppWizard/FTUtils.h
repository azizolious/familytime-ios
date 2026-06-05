//
//  SwiftFTUtils.h
//  FamilyTime - Dashboard
//
//  Created by Muhammad Ajmal on 10/12/2015.
//  Copyright © 2015 SoraCode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TimeZonesViewController.h"


#define IS_IPHONE_4 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)480) < DBL_EPSILON)
#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)568) < DBL_EPSILON)
#define IS_IPHONE_6 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)667) < DBL_EPSILON)
#define IS_IPHONE_6_PLUS (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)736) < DBL_EPSILON)
#define IS_IPHONE_X (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)812) < DBL_EPSILON)

//---THESE TWO MANUALLY DEFINED---//---AS RESOLUTION IS 896---//
//#define IS_IPHONE_XS_MAX (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)896) < DBL_EPSILON)
//#define IS_IPHONE_XR     (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)896) < DBL_EPSILON)

#define RGBCOLOR(R,G,B, A) [UIColor colorWithRed:R/255.2f green:G/255.2f blue:B/255.2f alpha:A]
#define APP_DELEGATE (AppDelegate*)[UIApplication sharedApplication].delegate;
#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

@interface FTUtils : NSObject
+ (BOOL)isDeviceiPhoneFamily;
+ (UIImage *)imageWithTint:(UIColor *)tintColor image:(UIImage *)image;
+ (CGFloat)widthOfString:(NSString *)string withFont:(UIFont *)font;

+ (void)showHUDAddedTo:(UIView *)view withText:(NSString *)text animated:(BOOL)animated;
+ (void)hideHUDAddedTo:(UIView *)view animated:(BOOL)animated;

//+ (void)showPremiumPopupWith:(UIViewController *)controller title:(NSString *)title firstParagraph:(NSString *)firstParagraph firstTitle:(NSString *)firstTitle firstDetails:(NSString *)firstDetails secondTitle:(NSString *)secondTitle secondDetails:(NSString *)secondDetails imageName:(NSString *)imageName color:(NSString *)color;

//+ (void)showPremiumPopupDefaultWith:(UIViewController *)controller color:(NSString *)color;

//+ (void)showPremiumFeaturePopupDefaultWith:(UIViewController *)controller color:(NSString *)color;

//+ (void)showPopupFeatureNotIniOSWith:(UIViewController *)controller color:(NSString *)color;

+ (void)selectTimeZoneWithController:(UIViewController *)vc withIndex:(NSInteger)index andTimeZones:(NSArray *)gmtTimeZones;


+ (void)showPopupForCheckedInOutWith:(UIViewController *)controller checkedIn:(BOOL)checkedin image:(UIImage *)image name:(NSString *)name time:(NSString *)time accuracy:(NSString *)accuracy lat:(NSString *)lat lon:(NSString *)lon placeName:placeName color:(NSString *)color;
+ (void)showPopupPasscodeWith:(UIViewController *)controller color:(NSString *)color;
//+ (void)showPopupLockDeviceAlertWith:(UIViewController *)controller status:(NSString *)status color:(NSString *)color;
+ (void)showOverSpeedAlert:(UIViewController *)controller childID:(NSInteger)childId childName:(NSString *)childName isSon:(BOOL)isSon startLatitude:(double)startLatitude startLongitude:(double)startLongitude endLatitude:(double)endLatitude endLongitude:(double)endLongitude speedLimit:(NSInteger)speedlimit currentSpeed:(NSInteger)currentSpeed address:(NSString *)address accuracy:(NSString *)accuracy isOverSpeed:(BOOL)isOverSpeed alertTime:(NSString *)alertTime;
+ (void)showSyncSettingsPopupWith:(UIViewController *)controller;
+ (void)showActivateForfamilyMap:(UIViewController *)controller;
+ (void)showSyncSettingsPopupWith:(UIViewController *)controller andMessage:(NSString *)message;

//+ (void)showPopupLockDeviceAlertWith:(UIViewController *)controller status:(NSString *)status color:(UIColor *)color and:(NSString *)deviceName;
//+ (void)showActivateForUpdate:(UIViewController *)controller;
+ (void)showActivateForDeviceNotEnrolled:(UIViewController *)controller;
//+ (void)showActivateOneChild11:(UIViewController *)controller;


//---REMOVE FACEBOOK DUE TO MDM---//
//+ (void)showFaceBookIssue:(UIViewController *)controller;


//---SANA CHANGE---//
+ (void)showSwiftPremiumPopupOn:(UIViewController *)controller;
+ (void)pushDeviceControllerOn:(UIViewController *)controller;
@end
