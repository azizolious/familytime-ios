//
//  CommonModel.h
//  FamilyTime
//
//  Created by Sora Code on 11/14/14.
//  Copyright (c) 2014 SoraCode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "NSString+LockMustafa.h"
#import "ApiManager.h"

#define kErrorGeneral @"Something went wrong please check your internet connection."
@interface CommonModel : NSObject 


+(void)showAlert:(NSString *)title msg:(NSString *)msg;
+(void)showAlert2:(NSString *)title msg:(NSString *)msg;

+(BOOL) isValidEmail:(NSString *)email;

+(void)addKeyBoardObserver:(UIViewController *)cont;
+(void)removeKeyBoardObserver:(UIViewController *)cont;
//+(void) addGeoLocation:(NSDictionary *)params;
+(NSString *)currentDate;
+(NSString *)date:(NSString *)date oldFormat:(NSString *)oldforamt format:(NSString *)format;
+(NSDate *)date2:(NSString *)date oldFormat:(NSString *)oldforamt format:(NSString *)format;
+(NSDate *)dateWithTimestamp:(NSString *)date;
+(int)daysBetween:(NSString *)dt1 and:(NSString *)dt2;
+(NSString *)pushTime:(NSString *)sentTime ;
+(NSString*)remaningTime:(NSDate*)startDate endDate:(NSDate*)endDate;
+(NSString*)remaningTimeInDays:(NSDate*)startDate endDate:(NSDate*)endDate;

//Edit settings plist
+(void) storeLocationInPlist:(CLLocationCoordinate2D )theLocation;
+(void) resetPreference:(NSString *)fileName;
+(void) setPreference:(NSString *)key value:(NSDictionary *)contact;
+(NSString *) getPreference:(NSString *)key;

//+(void) updatePreference:(NSDictionary *)params view:(UIViewController *)cont;
+ (void)updatePreference:(NSDictionary *)params view:(UIViewController *)cont isNotification:(BOOL)isNotif;

+ (void) runSpinAnimationOnView:(UIView*)view duration:(CGFloat)duration rotations:(CGFloat)rotations repeat:(float)repeat;
//+ (void) sendLocationToServer;
+ (void) updateDeviceToken; //---NOT BEING CALLED---COZ UPDATE PARENT DEVICE API IS BEING CALLED ON DASHBOARD---//
//+ (void) sendACK:(NSDictionary *)params add:(NSString *)url;//+(void) checkinOut:(NSString *)type add:(NSString *)address;

+(NSString *) randomColor:(int) r;
+ (UIColor *)colorFromHexString:(NSString *)hexString;
+(void) lockPhonePopup:(UIViewController *)view;

//-----SANA NEW METHODS---//

+(NSString *)getHoursMinutesFromSeconds:(NSInteger)seconds;

+(void)showAlertAndLogoutOnVC:(UIViewController *)vc isPresentedVC:(BOOL)isPresent;
+(void)clearDataAndLogoutOnController:(UIViewController *)vc isPresentedVC:(BOOL)isPresentCont;
+ (UIImage *)imageForHeaderSST:(NSString *)ruleName;
+ (UIImage *)newImageForHeaderSST:(NSString *)ruleName isRuleActive:(BOOL)isActive;
+ (UIImage *)newImageForInternetSchedule:(NSString *)ruleName isRuleActive:(BOOL)isActive;

@end
