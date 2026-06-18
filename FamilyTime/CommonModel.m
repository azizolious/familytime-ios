//
//  CommonModel.m
//  FamilyTime
//
//  Created by Sora Code on 11/14/14.
//  Copyright (c) 2014 SoraCode. All rights reserved.
//

#import "CommonModel.h"
#import "DataModel.h"
#import "AppDelegate.h"
//#import "JSONHTTPClient.h"
#import "NetworkModel.h"
#import "MBProgressHUD.h"
#import "CustomIOS7AlertView.h"
#import "FTUtils.h"
#import "Dashboard.h"
#import "FIRConstants.h"
#import "FamilyTime-Swift.h"

//---REMOVE FACEBOOK DUE TO MDM---//
//#import <FBSDKCoreKit/FBSDKCoreKit.h>

#import "NSString+LockMustafa.h"

#import "FamilyTime-Swift.h"

#define RGBCOLOR(R,G,B, A) [UIColor colorWithRed:R/255.2f green:G/255.2f blue:B/255.2f alpha:A]


@implementation CommonModel

+(void)showAlert:(NSString *)title msg:(NSString *)msg
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:[@"OK" myModification] otherButtonTitles:nil, nil];
        
        [alert show];
    });
}

+(void)showAlert2:(NSString *)title msg:(NSString *)msg
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:[@"TRY AGAIN" myModification] otherButtonTitles:[@"SIGN UP" myModification], nil];
        alert.delegate=self;
        alert.tag=101;
        [alert show];
    });
}


+(BOOL) isValidEmail:(NSString *)email
{
    NSString *emailReg = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailReg];
    
    if (([emailTest evaluateWithObject:email] != YES))
        return false;
    else
        return true;
}

#pragma mark keyboard observers
+(void)removeKeyBoardObserver:(UIViewController *)cont
{
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:cont
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:cont
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
}

+(void) addKeyBoardObserver:(UIViewController *)cont
{
    [[NSNotificationCenter defaultCenter] addObserver:cont selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:cont selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

#pragma mark Date
+(NSString *)currentDate
{
    //    2014-12-02 12:12:02"
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    return [df stringFromDate:[NSDate date]];
    
}
-(void)keyboardWillShow
{
    
}

-(void)keyboardWillHide
{
    
}

+(NSString *)date:(NSString *)date oldFormat:(NSString *)oldforamt format:(NSString *)format
{
    //    2014-12-02 12:12:02"
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
//    [df setLocale:[NSLocale systemLocale]];
    NSLog(@"Great==%@",[NSLocale systemLocale]);
    
     NSLog(@"Date==%@",date);
    
    
    
    [df setDateFormat:oldforamt];
    if([date isEqualToString:@""])
        date = [df stringFromDate:[NSDate date]];
    
    NSDate *dateStr = [df dateFromString:date];
    
    [df setDateFormat:format];//@"YYYY-MM-dd HH:mm:ss"];
    
    return [df stringFromDate:dateStr];
    
}

+(NSDate *)date2:(NSString *)date oldFormat:(NSString *)oldforamt format:(NSString *)format
{
    //    2014-12-02 12:12:02"
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:oldforamt];
    if([date isEqualToString:@""])
        date = [df stringFromDate:[NSDate date]];
    NSDate *dateStr = [df dateFromString:date];
    [df setDateFormat:format];//@"YYYY-MM-dd HH:mm:ss"];
    
    return dateStr;//[df dateFromString:[df stringFromDate:dateStr]];
    
}
+(NSDate *)dateWithTimestamp:(NSString *)date
{
    //    2014-12-02 12:12:02"
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
//    [df setLocale:[NSLocale systemLocale]];
    [df setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    return [df dateFromString:date];
    
}

+ (int)daysBetween:(NSString *)dt1 and:(NSString *)dt2 {
    @try {
        
        NSDate *startDate = [self dateWithTimestamp:dt1];
        NSDate *endDate = [self dateWithTimestamp:dt2];
        
        NSUInteger unitFlags = NSCalendarUnitMinute;//NSDayCalendarUnit;
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [calendar components:unitFlags fromDate:startDate toDate:endDate options:0];
        return (int)[components minute];
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    return 0;
}

+(NSString*)remaningTime:(NSDate*)startDate endDate:(NSDate*)endDate {
    
    NSDateComponents *components;
    NSInteger days;
    NSInteger hour;
    NSInteger minutes;
    NSString *durationString;
    
    components = [[NSCalendar currentCalendar] components: NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute
                                                 fromDate: startDate toDate: endDate options: 0];
    days = [components day];
    hour = [components hour];
    minutes = [components minute];
    
    if (days > 0) {
        
        if (days > 1) {
            durationString = [NSString stringWithFormat:@"(%ld days)", (long)days];
        }
        else {
            durationString = [NSString stringWithFormat:@"(%ld day)", (long)days];
        }
        return durationString;
    }
    
    if (hour > 0) {
        
        if (hour > 1) {
            durationString = [NSString stringWithFormat:@"(%ld hr)", (long)hour];
        }
        else {
            durationString = [NSString stringWithFormat:@"(%ld hr)", (long)hour];
        }
        return durationString;
    }
    
    if (minutes > 0) {
        
        if (minutes > 1) {
            durationString = [NSString stringWithFormat:@"(%ld min)", (long)minutes];
        }
        else {
            durationString = [NSString stringWithFormat:@"(%ld min)", (long)minutes];
        }
        return durationString;
    }
    
    return @"";
}

+(NSString*)remaningTimeInDays:(NSDate*)startDate endDate:(NSDate*)endDate {
    
    NSDateComponents *components;
    NSInteger days;
    NSString *durationString;
    
    components = [[NSCalendar currentCalendar] components: NSCalendarUnitDay
                                                 fromDate: startDate toDate: endDate options: 0];
    days = [components day];
    
    if (days > 0) {
        
        if (days > 1) {
            durationString = [NSString stringWithFormat:@"%ld days", (long)days];
        }
        else {
            durationString = [NSString stringWithFormat:@"%ld day", (long)days];
        }
        return durationString;
    }
    return @"Last day";
}

+(NSString *)pushTime:(NSString *)sentTime //and:(NSString *)dt2
{
    NSString *time = @"";//2014-12-02 12:12:02
    @try {
        
        NSDate *startDate = [self dateWithTimestamp:sentTime];
        NSDate *endDate = [NSDate date];//[self dateWithTimestamp:dt2];
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [calendar components:NSMinuteCalendarUnit fromDate:startDate toDate:endDate options:0];
        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *dayscomponent = [calendar components:NSDayCalendarUnit fromDate:startDate toDate:endDate options:0];
        if([components minute] == 0)
            time = [@"Just Now" myModification];
        else if([components minute]< 60)
            time = [NSString stringWithFormat:@"%i Minutes Ago",(int)[components minute]] ;
        else if([components minute]> 60 && [components minute]  < 60* 24 ){
            time = [NSString stringWithFormat:@"%i Hours Ago",(int)[components minute]/60] ;
        }
        else if([components minute]  > 60 * 24 && [dayscomponent day] < 7){
            time = [NSString stringWithFormat:@"%i Day(s) Ago",(int)[dayscomponent day]] ;
        }  else
            time = [self date:@"" oldFormat:@"YYYY-MM-dd HH:mm:ss" format:@"EEEE dd MMM"];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    return time;
}

#pragma mark edit plist
+(void) resetPreference:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",fileName]];
    NSFileManager *fm = [NSFileManager defaultManager];
    
    if([fm fileExistsAtPath:filePath])
        [fm removeItemAtPath:filePath error:nil];
    
    //    NSString * filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    //
    //    NSMutableArray *contactsArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    //    [contactsArray removeAllObjects];
    //    [contactsArray writeToFile:filePath atomically:false];
    
}
+(void) setPreference:(NSString *)key value:(NSDictionary *)contact
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *destPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",key]];
    //    NSLog(@"Loction plist path == %@",destPath);
    
    NSString * filePath = [[NSBundle mainBundle] pathForResource:key ofType:@"plist"];
    
    // copy file to document folder
    NSFileManager *fm = [NSFileManager defaultManager];
    if(![fm fileExistsAtPath:destPath])
        [fm copyItemAtPath:filePath toPath:destPath error:nil];
    
    NSMutableArray *contactsArray = [NSMutableArray arrayWithContentsOfFile:destPath];
    [contactsArray addObject:contact];
    [contactsArray writeToFile:destPath atomically:false];
    
}
+(NSString *) getPreference:(NSString *)key
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",key]];
    // NSString * filePath = [[NSBundle mainBundle] pathForResource:key ofType:@"plist"];
    NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:filePath];
    
    if(array == nil)
        return @"";
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:array options:0 error:nil];
    NSString* jsonString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
    //    NSLog(@"Dict:%@", jsonString);
    return jsonString;
    //    if(settingDic != nil && [settingDic valueForKey:key])
    //        return [settingDic objectForKey:key];
    //    else
    //        return nil;
    
}

+ (void)updatePreference:(NSDictionary *)params view:(UIViewController *)cont isNotification:(BOOL)isNotif
{
    NSString *name  = [params valueForKey:@"name"];
    NSString *value = [params valueForKey:@"value"];
    
    NSLog(@"dict in update pref = %@", params);
    
    AppDelegate *delegate = [AppDelegate appDelegate];
    [SwiftFTUtils showHUDAddedTo:cont.view withText:@"Updating Preference..." animated:YES];
    
    NSString *url = @"";
    if (delegate.selectedDashboardChild.plateform_id == 1)
    {
        if (isNotif)
            url = [NSString stringWithFormat:@"%@%ld", kChildSettings_Notif_Android_Mesh2, (long)delegate.selectedDashboardChild.child_id];
        else
            url = [NSString stringWithFormat:@"%@%ld", KChildUpdatePref_Android_Mesh2, (long)delegate.selectedDashboardChild.child_id];
    }
    else
    {
        if (isNotif)
            url = [NSString stringWithFormat:@"%@%ld", kChildSettings_Notif_IOS_Mesh2, (long)delegate.selectedDashboardChild.child_id];
        else
            url = [NSString stringWithFormat:@"%@%ld", KChildUpdatePref_IOS_Mesh2, (long)delegate.selectedDashboardChild.child_id];
    }
    
    NSLog(@"Put Url = %@ and params = %@", url, params);
    
     [[ApiManager shared] putApi:url params:params controller:cont isContPresented:NO withResponse:^(NSString * _Nonnull error, NSInteger errorCode) {
        NSLog(@"api manager put api errorcode in common model = %ld", (long)errorCode);
        
        if(errorCode == 200)
        {
            DashboardChildPreference   *preference   = nil;
            DashboardChildNotification *notification = nil;
            if([name isEqualToString:@"location_tracking"])
            {
                preference        = [delegate.selectedDashboardChild getPreferencesWithName:@"location_tracking"];
                preference.status = [value integerValue];
            }
            else if([name isEqualToString:@"monitor_places"])
            {
                preference        = [delegate.selectedDashboardChild getPreferencesWithName:@"monitor_places"];
                preference.status = [value integerValue];
            }
            else if([name isEqualToString:@"app_blocking"])
            {
                preference        = [delegate.selectedDashboardChild getPreferencesWithName:@"app_blocking"];
                preference.status = [value integerValue];
            }
            else if([name isEqualToString:@"call_logs"])
            {
                preference        = [delegate.selectedDashboardChild getPreferencesWithName:@"call_logs"];
                preference.status = [value integerValue];
            }
            else if([name isEqualToString:@"contact_logs"])
            {
                preference        = [delegate.selectedDashboardChild getPreferencesWithName:@"contact_logs"];
                preference.status = [value integerValue];
            }
            else if([name isEqualToString:@"bookmark_history"])
            {
                preference = [delegate.selectedDashboardChild getPreferencesWithName:@"bookmark_history"];
                preference.status = [value integerValue];
            }
            else if([name isEqualToString:@"browsing_history"])
            {
                preference = [delegate.selectedDashboardChild getPreferencesWithName:@"browsing_history"];
                preference.status = [value integerValue];
            }
            else if([name isEqualToString:@"contact_watchlist"])
            {
                preference = [delegate.selectedDashboardChild getPreferencesWithName:@"contact_watchlist"];
                preference.status = [value integerValue];
            }
            else if([name isEqualToString:@"word_watchlist"])
            {
                preference = [delegate.selectedDashboardChild getPreferencesWithName:@"word_watchlist"];
                preference.status = [value integerValue];
            }
            else if([name isEqualToString:@"phonelock_pin"])
            {
                preference = [delegate.selectedDashboardChild getPreferencesWithName:@"phonelock_pin"];
                preference.status = [value integerValue];
                preference.value  = value;
            }
            else if([name isEqualToString:@"monitor_places_alert"])
            {
                notification = [delegate.selectedDashboardChild getNotificationsWithName:@"monitor_places_alert"];
                notification.status = [value integerValue];
            }
            else if([name isEqualToString:@"sos_alert"])
            {
                notification = [delegate.selectedDashboardChild getNotificationsWithName:@"sos_alert"];
                notification.status = [value integerValue];
            }
            else if([name isEqualToString:@"pickup_alert"])
            {
                notification = [delegate.selectedDashboardChild getNotificationsWithName:@"pickup_alert"];
                notification.status = [value integerValue];
            }
            else if([name isEqualToString:@"contact_watchlist_alert"])
            {
                notification = [delegate.selectedDashboardChild getNotificationsWithName:@"contact_watchlist_alert"];
                notification.status = [value integerValue];
            }
            else if([name isEqualToString:@"app_blocking_alert"])
            {
                notification = [delegate.selectedDashboardChild getNotificationsWithName:@"app_blocking_alert"];
                notification.status = [value integerValue];
            }
            else if([name isEqualToString:@"speed_limit_alert"])
            {
                notification = [delegate.selectedDashboardChild getNotificationsWithName:@"speed_limit_alert"];
                notification.status = [value integerValue];
                notification.value  = value;
            }
            else if([name isEqualToString:@"installed_app_logs"])
            {
                preference = [delegate.selectedDashboardChild getPreferencesWithName:@"installed_app_logs"];
                preference.status = [value integerValue];
            }
            else if([name isEqualToString:@"sms_logs"])
            {
                preference = [delegate.selectedDashboardChild getPreferencesWithName:@"sms_logs"];
                preference.status = [value integerValue];
            }
            
            //---HIDE NOTIFICATION AREA TOGGLE ADDED FOR ANDROID UNDER DEVICE SECTION---//
            else if([name isEqualToString:@"top_stack"])
            {
                preference = [delegate.selectedDashboardChild getPreferencesWithName:@"top_stack"];
                preference.status = [value integerValue];
            }
            
            if(preference != nil)
                [delegate.selectedDashboardChild updatePreferenceWitPreference:preference];
            else if (notification != nil)
                [delegate.selectedDashboardChild updateNotificationWitNotification:notification];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kNotif_update_child_in_db" object:nil];
        }
        
         dispatch_async(dispatch_get_main_queue(), ^{
             [MBProgressHUD hideAllHUDsForView:cont.view animated:YES];
             //        if([cont respondsToSelector:@selector(refreshView)])
             //            [(BListAppsViewController *)cont refreshView];
             if([cont respondsToSelector:@selector(refreshView)])
                 [(ContactsWatchListViewController *)cont refreshView];
//             else if([cont respondsToSelector:@selector(lockChildPhone)] && value.length > 0)
//                 [(DashboardVC *)cont handleLockWith:delegate.selectedDashboardChild];
         });
         
//            [(DashboardTableViewController *)cont lockChildPhone];
    }];
    
    //---OLD API---//
    /*
    [JSONHTTPClient postJSONFromURLWithString:KChildUpdatePref
                                       params:params
                                   completion:^(id json, JSONModelError *err) {
                                       
//                                       //---SEND_HEADERS----//
//                                       [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:kSendHeaders];
//                                       [[NSUserDefaults standardUserDefaults] synchronize];
                                       
                                       NSLog(@"update preference json received = %@", json);
                                       
                                       if([[json valueForKey:@"response"] intValue]== 200)
                                       {
                                           DashboardChildPreference   *preference   = nil;
                                           DashboardChildNotification *notification = nil;
                                           if([name isEqualToString:@"location_tracking"])
                                           {
                                               preference        = [delegate.selectedDashboardChild getPreferencesWithName:@"location_tracking"];
                                               preference.status = [value integerValue];
                                           }
                                           else if([name isEqualToString:@"monitor_places"])
                                           {
                                               preference        = [delegate.selectedDashboardChild getPreferencesWithName:@"monitor_places"];
                                               preference.status = [value integerValue];
                                           }
                                           else if([name isEqualToString:@"app_blocking"])
                                           {
                                               preference        = [delegate.selectedDashboardChild getPreferencesWithName:@"app_blocking"];
                                               preference.status = [value integerValue];
                                           }
                                           else if([name isEqualToString:@"call_logs"])
                                           {
                                               preference        = [delegate.selectedDashboardChild getPreferencesWithName:@"call_logs"];
                                               preference.status = [value integerValue];
                                           }
                                           else if([name isEqualToString:@"contact_logs"])
                                           {
                                               preference        = [delegate.selectedDashboardChild getPreferencesWithName:@"contact_logs"];
                                               preference.status = [value integerValue];
                                           }
                                           else if([name isEqualToString:@"bookmark_history"])
                                           {
                                               preference = [delegate.selectedDashboardChild getPreferencesWithName:@"bookmark_history"];
                                               preference.status = [value integerValue];
                                           }
                                           else if([name isEqualToString:@"browsing_history"])
                                           {
                                               preference = [delegate.selectedDashboardChild getPreferencesWithName:@"browsing_history"];
                                               preference.status = [value integerValue];
                                           }
                                           else if([name isEqualToString:@"contact_watchlist"])
                                           {
                                               preference = [delegate.selectedDashboardChild getPreferencesWithName:@"contact_watchlist"];
                                               preference.status = [value integerValue];
                                           }
                                           else if([name isEqualToString:@"word_watchlist"])
                                           {
                                               preference = [delegate.selectedDashboardChild getPreferencesWithName:@"word_watchlist"];
                                               preference.status = [value integerValue];
                                           }
                                           else if([name isEqualToString:@"phonelock_pin"])
                                           {
                                               preference = [delegate.selectedDashboardChild getPreferencesWithName:@"phonelock_pin"];
                                               preference.status = [value integerValue];
                                               preference.value  = value;
                                           }
                                           else if([name isEqualToString:@"monitor_places_alert"])
                                           {
                                               notification = [delegate.selectedDashboardChild getNotificationsWithName:@"monitor_places_alert"];
                                               notification.status = [value integerValue];
                                           }
                                           else if([name isEqualToString:@"sos_alert"])
                                           {
                                               notification = [delegate.selectedDashboardChild getNotificationsWithName:@"sos_alert"];
                                               notification.status = [value integerValue];
                                           }
                                           else if([name isEqualToString:@"pickup_alert"])
                                           {
                                               notification = [delegate.selectedDashboardChild getNotificationsWithName:@"pickup_alert"];
                                               notification.status = [value integerValue];
                                           }
                                           else if([name isEqualToString:@"contact_watchlist_alert"])
                                           {
                                               notification = [delegate.selectedDashboardChild getNotificationsWithName:@"contact_watchlist_alert"];
                                               notification.status = [value integerValue];
                                           }
                                           else if([name isEqualToString:@"app_blocking_alert"])
                                           {
                                               notification = [delegate.selectedDashboardChild getNotificationsWithName:@"app_blocking_alert"];
                                               notification.status = [value integerValue];
                                           }
                                           else if([name isEqualToString:@"speed_limit_alert"])
                                           {
                                               notification = [delegate.selectedDashboardChild getNotificationsWithName:@"speed_limit_alert"];
                                               notification.status = [value integerValue];
                                           }
                                           else if([name isEqualToString:@"installed_app_logs"])
                                           {
                                               preference = [delegate.selectedDashboardChild getPreferencesWithName:@"installed_app_logs"];
                                               preference.status = [value integerValue];
                                           }
                                           else if([name isEqualToString:@"sms_logs"])
                                           {
                                               preference = [delegate.selectedDashboardChild getPreferencesWithName:@"sms_logs"];
                                               preference.status = [value integerValue];
                                           }
                                           if(preference != nil)
                                               [delegate.selectedDashboardChild updatePreferenceWitPreference:preference];
                                           else if (notification != nil)
                                               [delegate.selectedDashboardChild updateNotificationWitNotification:notification];
                                       }
                                       [MBProgressHUD hideAllHUDsForView:cont.view animated:YES];
                                       if([cont respondsToSelector:@selector(refreshView)])
                                           [(BListAppsViewController *)cont refreshView];
                                       else if([cont respondsToSelector:@selector(refreshView)])
                                           [(ContactsWatchListViewController *)cont refreshView];
                                       else if([cont respondsToSelector:@selector(lockChildPhone)] && value.length > 0)
                                           [(DashboardTableViewController *)cont lockChildPhone];
                                   }];
     
     */ //---END OLD API---//
}


#pragma mark view circular animation
+ (void) runSpinAnimationOnView:(UIView*)view duration:(CGFloat)duration rotations:(CGFloat)rotations repeat:(float)repeat
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/ * rotations * duration ];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = repeat;
    
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}
#pragma store location in plist
+(void) storeLocationInPlist:(CLLocationCoordinate2D )theLocation
{
    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[NSNumber numberWithFloat:theLocation.latitude] forKey:@"latitude"];
    [dict setObject:[NSNumber numberWithFloat:theLocation.longitude] forKey:@"longitude"];
    [dict setObject:[CommonModel currentDate] forKey:@"time_in"];
    [dict setObject:[CommonModel currentDate] forKey:@"time_out"];
    [dict setObject:[CommonModel currentDate] forKey:@"time_sent"];
    
    __block NSString *address;
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:theLocation.latitude longitude:theLocation.longitude];
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark * placemark =[placemarks objectAtIndex:0];
        
        
        if([placemark addressDictionary] != NULL){
            address = [NSString stringWithFormat:@"%@ %@ %@",[[placemark addressDictionary] valueForKey:@"Street"],[[placemark addressDictionary] valueForKey:@"State"],[[placemark addressDictionary] valueForKey:@"Country"]];
        }
        else
            address = @"Unknown";
        
        [dict setObject:address forKey:@"location"];
        
        //Add the vallid location with good accuracy into an array
        //Every 1 minute, I will select the best location based on accuracy and send to server
        [self setPreference:@"locations" value:dict];
    }];
}


#pragma mark send location to server
//+(void) sendLocationToServer//:(NSArray * )myLocations
//{
//    NSLog(@"sending locatin to  server *****");
//    AppDelegate *delegate = [AppDelegate appDelegate];
//    NSString *jsonString = [CommonModel getPreference:@"locations"];
//
//    if(jsonString.length > 4){
//        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:delegate.selectedDashboardChild.child_id],@"child_id",jsonString,@"locations", nil];
//        //        NSLog(@"location params %@",params);
//        [JSONHTTPClient postJSONFromURLWithString:@"" //KLocationAddUrl  //---IN PARENT WE ARE NOT SENDING LOCATION TO SERVER, FAHAD BHAI CONFIRMED IT, SO COMMENTING NOW---SANA---//FRI 11 OCT 2019---//
//                                           params:params
//                                       completion:^(id json, JSONModelError *err) {
//                                           // read response code
//                                           if([[json valueForKey:@"response"] intValue] == 200){
//                                               NSLog(@"location sent to server ******");
//                                               // delete all contacts stored from plist
//                                               [self resetPreference:@"locations"];
//                                           }
//                                           else
//                                               NSLog(@"****** Unable to send location to server %@ and json %@",err,json);
//
//                                       }];
//    }
//
//
//}

#pragma mark update PUSH Token
+ (void) updateDeviceToken {
    
    //---NOT BEING CALLED---COZ UPDATE PARENT DEVICE API IS BEING CALLED ON DASHBOARD---//
    
    NSString *deviceToken = [[AppDelegate appDelegate].userDefault valueForKey:@"deviceToken"];
    
    if(deviceToken.length <=0)
        [CommonModel showAlert:@"" msg:@"Network error please try later"];
    
    else{
        AppDelegate *delegate = [AppDelegate appDelegate];
        NSString *user_id = delegate.parent == nil ? [NSString stringWithFormat:@"%ld",delegate.selectedDashboardChild.child_id] :delegate.parent.user_id;
        //NSLog(@"%@",delegate.parent.user_id);
        //NSLog(@"%ld",delegate.selectedDashboardChild.child_id);
        
        //---DEPRICATED---//
//        [JSONHTTPClient postJSONFromURLWithString:@"" //KUpdatePushToken
//                                           params:@{@"id":user_id,@"device":@"iphone",@"token":deviceToken}
//                                       completion:^(id json, JSONModelError *err) {
//                                           NSLog(@"JSON for pdate device token =  %@", json);
//                                           // read response code
//                                           if([[json valueForKey:@"response"] intValue] != 200 )
//                                               [CommonModel showAlert:@"Error!" msg:[json valueForKey:@"message"]];
//                                           else{
//                                               NSLog(@"JSON: %@", json);   //check err, process json ...
//                                           }
//                                           //<a5820743 7434a0e9 49d55e5d e50616a6 2ba95413 0c7e7010 fd49e79c a3f7cfbc>
//                                           //                                           [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                                       }];
    }
    
}
#pragma mark Check in/out
//+(void) sendACK:(NSDictionary *)params add:(NSString *)url
//{
//    //    push_type (panic/checkin/checkout)
//    //    address (for checkin/checkout)
//    //    push_type (phonelock | phoneunlock)
//    [JSONHTTPClient postJSONFromURLWithString:url
//                                       params:params
//                                   completion:^(id json, JSONModelError *err) {
//                                //       NSError *error;
//                                       NSString *msg = [json valueForKey:@"message"] == nil ? [kErrorGeneral myModification] : [json valueForKey:@"message"];
//
//                                       // read response code
//                                       if([[json valueForKey:@"response"] intValue] == 200){
//                                           // set activated user key
//                                           [CommonModel showAlert:@"" msg:msg];
//                                       }
//                                       else
//                                           [CommonModel showAlert:@"Error!" msg:msg];
//                                   }];
//
//
//    //---NATIVE API CALLING---//
//
//    [[ApiManager shared] mesh_postApiWithParamString:@"" withApi:url withResponse:^(NSDictionary * _Nonnull json, NSInteger errorCode, NSString * _Nonnull message) {
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//            NSString *msg = [json valueForKey:@"message"] == nil ? [kErrorGeneral myModification] : [json valueForKey:@"message"];
//
//            // read response code
//            if([[json valueForKey:@"response"] intValue] == 200){
//                // set activated user key
//                [CommonModel showAlert:@"" msg:msg];
//            }
//            else
//                [CommonModel showAlert:@"Error!" msg:msg];
//
//        });
//
//    }];

//}

#pragma mark color
+(NSString *) randomColor:(int) r
{
    if(r== 1)
        return @"orange";//kOrangeColor;
    else  if(r== 2)
        return @"green";//kGreenColor;
    else  if(r== 3)
        return @"purple";//kPurpleColor;
    else
        return @"red";//kredColor;
}
// Assumes input like "#00FF00" (#RRGGBB).
+ (UIColor *)colorFromHexString:(NSString *)hexString {
    if([hexString isEqualToString:@"orange"])
        hexString = kOrangeColor;
    else if([hexString isEqualToString:@"green"])
        hexString = kGreenColor;
    else if([hexString isEqualToString:@"purple"])
        hexString = kPurpleColor;
    else if([hexString isEqualToString:@"gray"])
        return RGBCOLOR(187, 187, 187, 1);
    else if([hexString isEqualToString:kDarkGray])
        return RGBCOLOR(76, 76, 76, 1);
    else if([hexString isEqualToString:@"blue"])
         hexString  = kBlueColor;
    else if([hexString isEqualToString:@"yellow"])
        hexString  = k_IAP_YellowColor;
    else
        hexString = kredColor;
    
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

+(NSString *)getHoursMinutesFromSeconds:(NSInteger)seconds{
    
    int minutes = (seconds / 60) % 60;
    NSInteger hours = seconds / 3600;
    
    return [NSString stringWithFormat:@"%02ldHr : %02dMins",(long)hours, minutes];
}


#pragma mark Lock phone
+(void) lockPhonePopup:(UIViewController *)view
{
    [SwiftFTUtils showPopupPasscodeWith:view color:@"red"];
}

#pragma mark SANA NEW METHODS


//---LOGOUT METHODS---//
+(void)showAlertAndLogoutOnVC:(UIViewController *)vc isPresentedVC:(BOOL)isPresent{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:NSLocalizedString(@"Error!", @"")
                                     message:NSLocalizedString(@"logout_message", @"")
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:NSLocalizedString(@"OK", @"")
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        //Handle your yes please button action here
                                        [CommonModel clearDataAndLogoutOnController:vc isPresentedVC:isPresent];
                                    }];
        
        [alert addAction:yesButton];
        [vc presentViewController:alert animated:YES completion:nil];
    });
}

+(void)clearDataAndLogoutOnController:(UIViewController *)vc isPresentedVC:(BOOL)isPresentCont{
    
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:kUserEmail];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:kUserPassword];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:kHeaderToken];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:kLaunchAppHash];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:kEmailVerified];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:kChildAdded];
    
    [[AppDelegate appDelegate].userDefault setObject:nil forKey:@"user"];
    
    
    
    //---FLAG TO UPDATE PARENT DEVICE DATA TO SERVER ONLY ONCE---//
    [[NSUserDefaults standardUserDefaults] setObject: kYES forKey:kUpdateParentDataOnce];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[AppDelegate appDelegate] setDashboard:nil];
    
    // TODO: GoogleSignIn disabled temporarily — replace with GoogleSignIn 7.x via SPM when legacy Auth VCs are removed
    //[[GIDSignIn sharedInstance] signOut];
    
    
    if (isPresentCont)
        [vc dismissViewControllerAnimated:true completion:nil];
    
    
    
    [[AppDelegate appDelegate] setNavigationbarAppearence:YES cont:vc];
    [[AppDelegate appDelegate] setupDrawer:2];
    
}


+ (UIImage *)imageForHeaderSST:(NSString *)ruleName
{
    if([ruleName isEqualToString:@"Bedtime"])
        return [UIImage imageNamed:@"ic_moon"];
    else if([ruleName isEqualToString:@"Dinner Time"])
        return [UIImage imageNamed:@"ic_dinner"];
    else if([ruleName isEqualToString:@"Homework Time"])
        return [UIImage imageNamed:@"ic_homework"];
    else
        return [UIImage imageNamed:@"ic_white_clock"];
}


+ (UIImage *)newImageForHeaderSST:(NSString *)ruleName isRuleActive:(BOOL)isActive
{
    if([ruleName isEqualToString:@"Bedtime"])
        return isActive ? [UIImage imageNamed:@"st_moon_blue"] : [UIImage imageNamed:@"st_moon_gray"];
    else if([ruleName isEqualToString:@"Dinner Time"])
        return isActive ? [UIImage imageNamed:@"st_dinner_blue"] : [UIImage imageNamed:@"st_dinner_gray"];
    else if([ruleName isEqualToString:@"Homework Time"])
        return isActive ? [UIImage imageNamed:@"st_book_blue"] : [UIImage imageNamed:@"st_book_gray"];
    else
        return isActive ? [UIImage imageNamed:@"st_clock_blue"] : [UIImage imageNamed:@"st_clock_gray"];
}

+ (UIImage *)newImageForInternetSchedule:(NSString *)ruleName isRuleActive:(BOOL)isActive
{
    if([ruleName isEqualToString:@"Weekends"])
        return isActive ? [UIImage imageNamed:@"ic_weekeds"] : [UIImage imageNamed:@"ic_weekeds_gray"];
    else if([ruleName isEqualToString:@"Weekdays"])
        return isActive ? [UIImage imageNamed:@"ic_weekdays"] : [UIImage imageNamed:@"ic_weekdays_gray"];
    else
        return isActive ? [UIImage imageNamed:@"ic_internet"] : [UIImage imageNamed:@"ic_internet_gray"];
}

@end
