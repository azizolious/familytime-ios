//
//  SwiftFTUtils.m
//  FamilyTime - Dashboard
//
//  Created by Muhammad Ajmal on 10/12/2015.
//  Copyright © 2015 SoraCode. All rights reserved.
//

#import "FTUtils.h"
#import "MBProgressHUD.h"
#import "GMDCircleLoader.h"
#import <CCMPopup/CCMPopupTransitioning.h>
#import "PremiumAlertController.h"
#import "CheckInOutAlertControllerViewController.h"
#import "PasscodeViewController.h"
#import "SpeedAlertsViewController.h"
#import "SyncSettingsPopupController.h"
#import "SyncSettingsPopupController1.h"

#import "NSString+LockMustafa.h"
//#import "SyncSettingsPopupController11.h"

//---REMOVE FACEBOOK DUE TO MDM---//
//#import <FBSDKCoreKit/FBSDKCoreKit.h>

#import "FamilyTime-Swift.h"


#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

@implementation FTUtils
+ (UIImage *)imageWithTint:(UIColor *)tintColor image:(UIImage *)image
{
    CGRect aRect = CGRectMake(0.f, 0.f, image.size.width, image.size.height);
    CGImageRef alphaMask;
    {
        UIGraphicsBeginImageContext(aRect.size);
        CGContextRef c = UIGraphicsGetCurrentContext();
        
        CGContextTranslateCTM(c, 0, aRect.size.height);
        CGContextScaleCTM(c, 1.0, -1.0);
        [image drawInRect: aRect];
        alphaMask = CGBitmapContextCreateImage(c);
        UIGraphicsEndImageContext();
    }
    UIGraphicsBeginImageContext(aRect.size);
    CGContextRef c = UIGraphicsGetCurrentContext();
    [image drawInRect:aRect];
    
    CGContextClipToMask(c, aRect, alphaMask);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextSetFillColorSpace(c, colorSpace);
    
    CGContextSetFillColorWithColor(c, tintColor.CGColor);
    UIRectFillUsingBlendMode(aRect, kCGBlendModeNormal);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(alphaMask);
    
    return img;
}

+ (CGFloat)widthOfString:(NSString *)string withFont:(UIFont *)font
{
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    return [[[NSAttributedString alloc] initWithString:string attributes:attributes] size].width;
}

+ (BOOL)isDeviceiPhoneFamily
{
    return ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone);
}

+ (void)showHUDAddedTo:(UIView *)view withText:(NSString *)text animated:(BOOL)animated
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:HUD];
    
    
    UIView *tView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    tView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
    
    GMDCircleLoader *loader1 = [[GMDCircleLoader alloc] initWithFrame:CGRectInset(tView.bounds, 10, 10)];
    [tView addSubview:loader1];
    loader1.duration = 1.0f;
    loader1.lineTintColor = UIColorFromRGB(0x3498db);
    loader1.lineWidth = 1.5f;
    [loader1 setup];
    [loader1 start];
    
    GMDCircleLoader *loader2 = [[GMDCircleLoader alloc] initWithFrame:CGRectInset(loader1.frame, 6, 6)];
    [tView addSubview:loader2];
    loader2.duration = 1.5f;
    loader2.lineTintColor = UIColorFromRGB(0xe74c3c);
    loader2.lineWidth = 1.5f;
    [loader2 setup];
    [loader2 start];
    
    GMDCircleLoader *loader3 = [[GMDCircleLoader alloc] initWithFrame:CGRectInset(loader2.frame, 6, 6)];
    [tView addSubview:loader3];
    loader3.duration = 0.75f;
    loader3.lineTintColor = UIColorFromRGB(0xf9c922);
    loader3.lineWidth = 1.5f;
    [loader3 setup];
    [loader3 start];
    
    HUD.color = [UIColor whiteColor];
    HUD.margin = 10.0f;
    HUD.customView = tView;
    HUD.mode = MBProgressHUDModeCustomView;
    
    //HUD.delegate = self;
    
    [HUD show:YES];
}

+ (void)hideHUDAddedTo:(UIView *)view animated:(BOOL)animated{
    [MBProgressHUD hideAllHUDsForView:view animated:animated];
}

//+ (void)showPremiumPopupWith:(UIViewController *)controller title:(NSString *)title firstParagraph:(NSString *)firstParagraph firstTitle:(NSString *)firstTitle firstDetails:(NSString *)firstDetails secondTitle:(NSString *)secondTitle secondDetails:(NSString *)secondDetails imageName:(NSString *)imageName  color:(NSString *)color
//{
//    PremiumAlertController *popup   = [[PremiumAlertController alloc] init];
//    popup.alertTitle                = title;
//    popup.firstParagraph            = firstParagraph;
//    popup.firstTitle                = firstTitle;
//    popup.firstDetails              = firstDetails;
//    popup.secondTitle               = secondTitle;
//    popup.secondDetails             = secondDetails;
//    popup.imagename                 = imageName;
//    popup.color                     = color;
//    CGSize contentSize;
//
//    /*
//    if ([SwiftFTUtils isDeviceiPhoneFamily]){
//        if(IS_IPHONE_4)
//        {
//            contentSize = CGSizeMake(270.0f, 420.0f);
//        }
//        else if(IS_IPHONE_5)
//        {
//            contentSize = CGSizeMake(270.0f, 420.0f);
//        }
//        else if(IS_IPHONE_6)
//        {
//            contentSize = CGSizeMake(317.0f, 450.0f);
//        }
//        else if(IS_IPHONE_6_PLUS)
//        {
//            contentSize = CGSizeMake(350.0f, 500.0f);
//        }
//        else //if(IS_IPHONE_X)
//        {
//            contentSize = CGSizeMake(350.0f, 500.0f);
//        }
//    }
//    else{
//        contentSize = CGSizeMake(525.0f, 715.0f);
//    }
//
//     */
//
//    if(IS_IPHONE_4)
//    {
//        contentSize = CGSizeMake(270.0f, 420.0f);
//    }
//    else if(IS_IPHONE_5)
//    {
//        contentSize = CGSizeMake(270.0f, 420.0f);
//    }
//    else if(IS_IPHONE_6)
//    {
//        contentSize = CGSizeMake(317.0f, 450.0f);
//    }
//    else if(IS_IPHONE_6_PLUS)
//    {
//        contentSize = CGSizeMake(350.0f, 500.0f);
//    }
//    else if(IS_IPHONE_X)  // || IS_IPHONE_XS_MAX || IS_IPHONE_XR)
//    {
//        contentSize = CGSizeMake(350.0f, 500.0f);
//    }
//    else
//    {
//        contentSize = CGSizeMake(525.0f, 715.0f);
//    }
//
//    /*
//    CCMPopupTransitioning *popup1 = [CCMPopupTransitioning sharedInstance];
//    popup1.destinationBounds = CGRectMake(0, 0, contentSize.width, contentSize.height);
////    popup1.presentedViewController = popup;
//    popup1.presentingController = controller;
//    popup1.backgroundBlurRadius = 0.0f;
//    popup1.backgroundViewColor = [UIColor blackColor];
//    popup1.backgroundViewAlpha = 0.5f;
//    [controller presentViewController:popup animated:YES completion:nil];
//    */
//
//    CCMPopupTransitioning *popup1   = [CCMPopupTransitioning sharedInstance];
//    popup1.destinationBounds        = CGRectMake(0, 0, contentSize.width, contentSize.height);
//    popup1.presentedController      = popup;
//    popup1.presentingController     = controller;
//    popup1.backgroundBlurRadius     = 0.0f;
//    popup1.backgroundViewColor      = [UIColor blackColor];
//    popup1.backgroundViewAlpha      = 0.5f;
//    [controller presentViewController:popup animated:YES completion:nil];
//}

//---SANA CHANGE---//

+ (void)showSwiftPremiumPopupOn:(UIViewController *)controller
{
    UIStoryboard *stb      = [UIStoryboard storyboardWithName:@"Dashboard" bundle:nil];
    PremiumPopupVC *popup  = [stb instantiateViewControllerWithIdentifier:@"PremiumPopupVC"];
    
    [controller.navigationController pushViewController:popup animated:YES];
    
//    let vc = SwiftConstants.SwiftStoryBoard.instantiateViewController(withIdentifier: "PremiumPopupVC") as! PremiumPopupVC
//    self.navigationController?.pushViewController(vc, animated: true)
    
//    CGSize contentSize;
//
//    if (!SwiftFTUtils.isDeviceiPhoneFamily){
//        contentSize = CGSizeMake(525.0f, 715.0f);
//    }
//    else
//    {
//        if(IS_IPHONE_4 || IS_IPHONE_5)
//        {
//            contentSize = CGSizeMake(270.0f, 420.0f);
//        }
//        else if(IS_IPHONE_6)
//        {
//            contentSize = CGSizeMake(317.0f, 450.0f);
//        }
//        else //if(IS_IPHONE_X)  // || IS_IPHONE_XS_MAX || IS_IPHONE_XR)
//        {
//            contentSize = CGSizeMake(350.0f, 500.0f);
//        }
//    }
//
//
//    CCMPopupTransitioning *popup1   = [CCMPopupTransitioning sharedInstance];
//    popup1.destinationBounds        = CGRectMake(0, 0, contentSize.width, contentSize.height);
//    popup1.presentedController      = popup;
//    popup1.presentingController     = controller;
//    popup1.backgroundBlurRadius     = 0.0f;
//    popup1.backgroundViewColor      = [UIColor blackColor];
//    popup1.backgroundViewAlpha      = 0.5f;
//    [controller presentViewController:popup animated:YES completion:nil];
        
}

+ (void)pushDeviceControllerOn:(UIViewController *)controller
{
    UIStoryboard *stb      = [UIStoryboard storyboardWithName:@"Dashboard" bundle:nil];
    DeviceVC *vc = [stb instantiateViewControllerWithIdentifier:@"DeviceVC"];
//    controller.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:NULL action:NULL];
    [controller.navigationController pushViewController:vc animated:YES];
}

+ (void)showSyncSettingsPopupWith:(UIViewController *)controller
{
    SyncSettingsPopupController *popup = [[SyncSettingsPopupController alloc] init];
    popup.alertTitle     = [NSString stringWithFormat:@"%@\n\n\n",[@"Sync Settings" myModification]];
    popup.firstParagraph = [@"Changes you have made wont take effect until you sync them. If you are done with changes" myModification];
    popup.imagename      = @"ic_sync-setting";
    popup.color          = @"blue";
    
    CGSize contentSize;
    if(IS_IPHONE_4)
    {
        contentSize = CGSizeMake(270.0f, 420.0f);
    }
    else if(IS_IPHONE_5)
    {
        contentSize = CGSizeMake(270.0f, 420.0f);
    }
    else if(IS_IPHONE_6)
    {
        contentSize = CGSizeMake(317.0f, 450.0f);
    }
    else if(IS_IPHONE_6_PLUS)
    {
        contentSize = CGSizeMake(350.0f, 500.0f);
    }
    else if(IS_IPHONE_X)
    {
        contentSize = CGSizeMake(350.0f, 500.0f);
    }
    else
    {
        popup.imagename = @"ipad_sync-setting";
        contentSize = CGSizeMake(525.0f, 715.0f);
    }
    
    CCMPopupTransitioning *popup1 = [CCMPopupTransitioning sharedInstance];
    popup1.destinationBounds    = CGRectMake(0, 0, contentSize.width, contentSize.height);
    popup1.presentedController  = popup;
    popup1.presentingController = controller;
    popup1.backgroundBlurRadius = 0.0f;
    popup1.backgroundViewColor  = [UIColor blackColor];
    popup1.backgroundViewAlpha  = 0.5f;
    [controller presentViewController:popup animated:YES completion:nil];
    
}

//---FOR MESH2 APIS SETTINGS POPUP---//
+ (void)showSyncSettingsPopupWith:(UIViewController *)controller andMessage:(NSString *)message
{
    SyncSettingsPopupController *popup = [[SyncSettingsPopupController alloc] init];
    popup.alertTitle     = [NSString stringWithFormat:@"%@\n\n\n",[@"Sync Settings" myModification]];
    popup.firstParagraph = message;
    popup.imagename      = @"ic_sync-setting";
    popup.color          = @"blue";
    
    CGSize contentSize;
    
    if(FTUtils.isDeviceiPhoneFamily){
        if(IS_IPHONE_4 || IS_IPHONE_5)
            contentSize = CGSizeMake(270.0f, 420.0f);
        else if(IS_IPHONE_6)
            contentSize = CGSizeMake(317.0f, 450.0f);
        else
            contentSize = CGSizeMake(350.0f, 500.0f);
    }
    else{
        popup.imagename = @"ipad_sync-setting";
        contentSize = CGSizeMake(525.0f, 715.0f);
    }
    
    
    CCMPopupTransitioning *popup1 = [CCMPopupTransitioning sharedInstance];
    popup1.destinationBounds    = CGRectMake(0, 0, contentSize.width, contentSize.height);
    popup1.presentedController  = popup;
    popup1.presentingController = controller;
    popup1.backgroundBlurRadius = 0.0f;
    popup1.backgroundViewColor  = [UIColor blackColor];
    popup1.backgroundViewAlpha  = 0.5f;
    [controller presentViewController:popup animated:YES completion:nil];
    
}

//+ (void)showPremiumPopupDefaultWith:(UIViewController *)controller color:(NSString *)color
//{
////    NSString *popupTitle = @"FamilyTime Premium\n";
//    NSString *popupTitle        = [NSString stringWithFormat:@"%@\n",[@"FamilyTime Premium" myModification]];
//
//    NSString *firstParagraph    = [NSString stringWithFormat:@"%@",[@"\nPlease login to your Web Dashboard and upgrade the subscription and enjoy the premium feature.\n" myModification]];
//    
//    NSString *firstTitle        = @"";
//    NSString *firstDetails      = @"";
//    NSString *secondTitle       = @"";
//    NSString *secondDetails     = @"";
//    
//    [SwiftFTUtils showPremiumPopupWith:controller title:popupTitle firstParagraph:firstParagraph firstTitle:firstTitle firstDetails:firstDetails secondTitle:secondTitle secondDetails:secondDetails imageName:@"ic_premium" color:color];
//}

//+ (void)showPremiumFeaturePopupDefaultWith:(UIViewController *)controller color:(NSString *)color
//{
//    NSString *popupTitle = [NSString stringWithFormat:@"%@\n",[@"Premium Feature" myModification]];
//    NSString *firstParagraph = [@"\nThis is premium feature and not available with the free subscription.\n" myModification];
//    NSString *firstTitle = @"";
//    NSString *firstDetails = [@"\nUpgrade each child device to premium for a small monthly fee and get ultimate parenting satisfaction.\nPlease login to your web Dashbord to upgrade the subscription and get superpowers for superior parental controls." myModification];
//    NSString *secondTitle = @"";
//    NSString *secondDetails = @"";
//    [SwiftFTUtils showPremiumPopupWith:controller title:popupTitle firstParagraph:firstParagraph firstTitle:firstTitle firstDetails:firstDetails secondTitle:secondTitle secondDetails:secondDetails imageName:@"ic_premium" color:color];
//}

//+ (void)showPopupFeatureNotIniOSWith:(UIViewController *)controller color:(NSString *)color
//{
//    NSString *alertTitle = [NSString stringWithFormat:@"%@\n",[@"Feature Not Available!" myModification]];
//    NSString *firstParagraph = [@"\nThis feature is not currently available on iOS based devices." myModification];
//    NSString *firstTitle = @"";
//    NSString *firstDetails = @"";
//    NSString *secondTitle = @"\n";
//    NSString *secondDetails = [NSString stringWithFormat:@"\n%@",NSLocalizedString(@"We are working hard to get this feature on iOS based devices. Please check back later or subscribe to our product blog for updates.", nil)];
//    [SwiftFTUtils showPremiumPopupWith:controller title:alertTitle firstParagraph:firstParagraph firstTitle:firstTitle firstDetails:firstDetails secondTitle:secondTitle secondDetails:secondDetails imageName:@"ic_premium" color:color];
//}

//+ (void)showPopupLockDeviceAlertWith:(UIViewController *)controller status:(NSString *)status color:(UIColor *)color and:(NSString *)deviceName
//{
//    //mustafa
//    BOOL islocked = ([status isEqualToString:@"phonelock"]) ? YES : NO;
//    NSString *alertTitle;
//     NSString *imagename;
//    if(islocked)
//    {
//        //paue
//        alertTitle = [NSString stringWithFormat:@"FamilyPause\n"];
////        imagename = ([SwiftFTUtils isDeviceiPhoneFamily]) ?  @"ic_pause_pop" : @"ic_pause_pop";
//        imagename = ([SwiftFTUtils isDeviceiPhoneFamily]) ?  @"ic_unpause_pop" : @"ic_unpause_pop";
//    }
//    else
//    {//Resume
//        alertTitle = [NSString stringWithFormat:@"FamilyPause\n"];
////        imagename = ([SwiftFTUtils isDeviceiPhoneFamily]) ?  @"ic_unpause_pop" : @"ic_unpause_pop";
//          imagename = ([SwiftFTUtils isDeviceiPhoneFamily]) ?  @"ic_pause_pop" : @"ic_pause_pop";
//    }
//    NSString *firstParagraph;
//    if(islocked)
//    {
//        firstParagraph = [NSString stringWithFormat:[@"\nThe FamilyPause command has been sent to %@. It might take few moments for FamilyPause to get activated on your child’s device." myModification],deviceName];
//    }else
//    {
//        firstParagraph = [NSString stringWithFormat:[@"\nThe FamilyPause command has been sent to %@. It might take few moments for FamilyPause to get deactivated on your child’s device." myModification],deviceName];
//    }
//    NSString *firstTitle = @"";
//    NSString *firstDetails = @"";
//    NSString *secondTitle = @"\n\n";
//    NSString *secondDetails = [@"Please also note that FamilyPause requires both parents and child's device to be connected with internet." myModification];
//
////popup_unlock
//    [SwiftFTUtils showPremiumPopupWith:controller title:alertTitle firstParagraph:firstParagraph firstTitle:firstTitle firstDetails:firstDetails secondTitle:secondTitle secondDetails:secondDetails imageName:imagename color:@"green"];
//}

+ (void)showPopupForCheckedInOutWith:(UIViewController *)controller checkedIn:(BOOL)checkedin image:(UIImage *)image name:(NSString *)name time:(NSString *)time accuracy:(NSString *)accuracy lat:(NSString *)lat lon:(NSString *)lon placeName:placeName color:(NSString *)color
{
    CheckInOutAlertControllerViewController *popup = [[CheckInOutAlertControllerViewController alloc] init];
    popup.image = image;
    popup.name = name;
    popup.time = time;
    popup.checkedin = checkedin;
    //popup.address = address;
    popup.accuracy = accuracy;
    popup.latitude = lat;
    popup.longitude = lon;
    popup.placeName = placeName;
    popup.color = color;
    CGSize contentSize;
    if(IS_IPHONE_4)
    {
        contentSize = CGSizeMake(270.0f, 420.0f);
    }
    else if(IS_IPHONE_5)
    {
        contentSize = CGSizeMake(270.0f, 420.0f);
    }
    else if(IS_IPHONE_6)
    {
        contentSize = CGSizeMake(317.0f, 450.0f);
    }
    else if(IS_IPHONE_6_PLUS)
    {
        contentSize = CGSizeMake(350.0f, 500.0f);
    }
    else if(IS_IPHONE_X)
        {
        contentSize = CGSizeMake(350.0f, 500.0f);
        }
    else
    {
        contentSize = CGSizeMake(525.0f, 715.0f);
    }
    
    CCMPopupTransitioning *popup1 = [CCMPopupTransitioning sharedInstance];
    popup1.destinationBounds = CGRectMake(0, 0, contentSize.width, contentSize.height);
    popup1.presentedController = popup;
    popup1.presentingController = controller;
    popup1.backgroundBlurRadius = 0.0f;
    popup1.backgroundViewColor = [UIColor blackColor];
    popup1.backgroundViewAlpha = 0.5f;
    [controller presentViewController:popup animated:YES completion:nil];
}

+ (void)showPopupPasscodeWith:(UIViewController *)controller color:(NSString *)color
{
    PasscodeViewController *popup = [[PasscodeViewController alloc] init];
    popup.color = color;
    CGSize contentSize;
    if(IS_IPHONE_4)
    {
        contentSize = CGSizeMake(270.0f, 420.0f);
    }
    else if(IS_IPHONE_5)
    {
        contentSize = CGSizeMake(270.0f, 420.0f);
    }
    else if(IS_IPHONE_6)
    {
        contentSize = CGSizeMake(317.0f, 450.0f);
    }
    else if(IS_IPHONE_6_PLUS)
    {
        contentSize = CGSizeMake(350.0f, 500.0f);
    }
    else if(IS_IPHONE_X)
        {
        contentSize = CGSizeMake(350.0f, 500.0f);
        }
    else
    {
        contentSize = CGSizeMake(525.0f, 715.0f);
    }
    CCMPopupTransitioning *popup1 = [CCMPopupTransitioning sharedInstance];
    popup1.destinationBounds = CGRectMake(0, 0, contentSize.width, contentSize.height);
    popup1.presentedController = popup;
    popup1.backgroundBlurRadius = 0.0f;
    popup1.backgroundViewColor = [UIColor blackColor];
    popup1.backgroundViewAlpha = 0.5f;
    popup1.presentingController = controller;
    [controller presentViewController:popup animated:YES completion:nil];
}

+ (void)showOverSpeedAlert:(UIViewController *)controller childID:(NSInteger)childId childName:(NSString *)childName isSon:(BOOL)isSon startLatitude:(double)startLatitude startLongitude:(double)startLongitude endLatitude:(double)endLatitude endLongitude:(double)endLongitude speedLimit:(NSInteger)speedlimit currentSpeed:(NSInteger)currentSpeed address:(NSString *)address accuracy:(NSString *)accuracy isOverSpeed:(BOOL)isOverSpeed alertTime:(NSString *)alertTime;
{
    SpeedAlertsViewController *popup = [[SpeedAlertsViewController alloc] init];
    CGSize contentSize;
    if(IS_IPHONE_4)
    {
        contentSize = CGSizeMake(270.0f, 430.0f);
    }
    else if(IS_IPHONE_5)
    {
        contentSize = CGSizeMake(270.0f, 450.0f);
    }
    else if(IS_IPHONE_6)
    {
        contentSize = CGSizeMake(317.0f, 500.0f);
    }
    else if(IS_IPHONE_6_PLUS)
    {
        contentSize = CGSizeMake(350.0f, 550.0f);
    }
    else if(IS_IPHONE_X)
        {
        contentSize = CGSizeMake(350.0f, 550.0f);
        }
    else
    {
        contentSize = CGSizeMake(600.0f, 815.0f);
    }
    
    CCMPopupTransitioning *popup1 = [CCMPopupTransitioning sharedInstance];
    popup1.destinationBounds = CGRectMake(0, 0, contentSize.width, contentSize.height);
    popup1.presentedController = popup;
    popup1.presentingController = controller;
    popup1.backgroundBlurRadius = 0.0f;
    popup1.backgroundViewColor = [UIColor blackColor];
    popup1.backgroundViewAlpha = 0.5f;
    [controller presentViewController:popup animated:YES completion:nil];
    
    [popup setupData:childId childName:childName isSon:isSon startLatitude:startLatitude startLongitude:startLongitude endLatitude:endLatitude endLongitude:endLongitude speedLimit:speedlimit currentSpeed:currentSpeed address:address accuracy:accuracy isOverSpeed:isOverSpeed alertTime:alertTime];
}


+ (void)showActivateForfamilyMap:(UIViewController *)controller
{
    SyncSettingsPopupController1 *popup = [[SyncSettingsPopupController1 alloc] init];
    popup.alertTitle = [NSString stringWithFormat:@"%@\n\n\n",[@"FamilyTime Dashboard" myModification]];
    popup.firstParagraph = [@"Please activate atleast one child to see locations on Family Map.After activating please refresh dashboard and try again." myModification];
    popup.imagename = @"logooooo.png";
    popup.color = @"blue";
    CGSize contentSize;
    if(IS_IPHONE_4)
    {
        contentSize = CGSizeMake(270.0f, 420.0f);
    }
    else if(IS_IPHONE_5)
    {
        contentSize = CGSizeMake(270.0f, 420.0f);
    }
    else if(IS_IPHONE_6)
    {
        contentSize = CGSizeMake(317.0f, 450.0f);
    }
    else if(IS_IPHONE_6_PLUS)
    {
        contentSize = CGSizeMake(350.0f, 500.0f);
    }
    else if(IS_IPHONE_X)
        {
        contentSize = CGSizeMake(350.0f, 500.0f);
        }
    else
    {
        popup.imagename = @"logooooo.png";
        contentSize = CGSizeMake(525.0f, 715.0f);
    }
    
    CCMPopupTransitioning *popup1 = [CCMPopupTransitioning sharedInstance];
    popup1.destinationBounds = CGRectMake(0, 0, contentSize.width, contentSize.height);
    popup1.presentedController = popup;
    popup1.presentingController = controller;
    popup1.backgroundBlurRadius = 0.0f;
    popup1.backgroundViewColor = [UIColor blackColor];
    popup1.backgroundViewAlpha = 0.5f;
    [controller presentViewController:popup animated:YES completion:nil];
    
}


+ (void)selectTimeZoneWithController:(UIViewController *)vc withIndex:(NSInteger)index andTimeZones:(NSArray *)gmtTimeZones
{
    TimeZonesViewController *popup = [[TimeZonesViewController alloc] init];
    popup.selectedIndex = index; //self.selectedTimeZoneIndex;
    popup.timezones = gmtTimeZones; //self.gmtTimezones;
    popup.isFromPopup = YES;
    popup.controllerDelegate = vc; //self;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:popup];
    CGSize contentSize;
    
    if (FTUtils.isDeviceiPhoneFamily){
        if(IS_IPHONE_4 || IS_IPHONE_5)
            contentSize = CGSizeMake(270.0f, 420.0f);
        
        else if(IS_IPHONE_6)
            contentSize = CGSizeMake(317.0f, 450.0f);
        else //if(IS_IPHONE_6_PLUS || IS_IPHONE_X)
            contentSize = CGSizeMake(350.0f, 500.0f);
    }
    else
        contentSize = CGSizeMake(525.0f, 715.0f);
    
    CCMPopupTransitioning *popup1 = [CCMPopupTransitioning sharedInstance];
    popup1.destinationBounds = CGRectMake(0, 0, contentSize.width, contentSize.height);
    popup1.presentedController = navController;
    popup1.presentingController = vc;
    popup1.backgroundBlurRadius = 0.0f;
    popup1.backgroundViewColor = [UIColor blackColor];
    popup1.backgroundViewAlpha = 0.5f;
    [vc presentViewController:navController animated:YES completion:nil];
}


//---REMOVE FACEBOOK DUE TO MDM---//

//+ (void)showFaceBookIssue:(UIViewController *)controller
//{
//    [FBSDKAccessToken setCurrentAccessToken:nil];
//    [FBSDKProfile setCurrentProfile:nil];
//
//
//    SyncSettingsPopupController1 *popup = [[SyncSettingsPopupController1 alloc] init];
//    popup.alertTitle = [NSString stringWithFormat:@"%@\n\n",[@"FamilyTime Dashboard" myModification]];
//    popup.firstParagraph = [@"Either you haven't given Email Permission or your ID is not recognized by Facebook. Please make sure to get your ID confirmed from Facebook first and try again." myModification];
//    popup.imagename = @"logooooo.png";
//    popup.color = @"blue";
//    CGSize contentSize;
//    if(IS_IPHONE_4)
//    {
//        contentSize = CGSizeMake(270.0f, 420.0f);
//    }
//    else if(IS_IPHONE_5)
//    {
//        contentSize = CGSizeMake(270.0f, 420.0f);
//    }
//    else if(IS_IPHONE_6)
//    {
//        contentSize = CGSizeMake(317.0f, 450.0f);
//    }
//    else if(IS_IPHONE_6_PLUS)
//    {
//        contentSize = CGSizeMake(350.0f, 500.0f);
//    }
//    else if(IS_IPHONE_X)
//    {
//        contentSize = CGSizeMake(350.0f, 500.0f);
//    }
//    else
//    {
//        popup.imagename = @"logooooo.png";
//        contentSize = CGSizeMake(525.0f, 715.0f);
//    }
//
//    CCMPopupTransitioning *popup1 = [CCMPopupTransitioning sharedInstance];
//    popup1.destinationBounds = CGRectMake(0, 0, contentSize.width, contentSize.height);
//    popup1.presentedController = popup;
//    popup1.presentingController = controller;
//    popup1.backgroundBlurRadius = 0.0f;
//    popup1.backgroundViewColor = [UIColor blackColor];
//    popup1.backgroundViewAlpha = 0.5f;
//    [controller presentViewController:popup animated:YES completion:nil];
//
//}


//+ (void)showActivateOneChild11:(UIViewController *)controller
//{
//    SyncSettingsPopupController1 *popup = [[SyncSettingsPopupController1 alloc] init];
//    popup.alertTitle = [NSString stringWithFormat:@"%@\n\n",[@"FamilyTime Dashboard" myModification]];
//    popup.firstParagraph = [@"It looks like you haven't activated your child yet. Please make sure you have followed all steps or contact FamilyTime customer support." myModification];
//    popup.imagename = @"logooooo.png";
//    popup.color = @"blue";
//    CGSize contentSize;
//    if(IS_IPHONE_4)
//    {
//        contentSize = CGSizeMake(270.0f, 420.0f);
//    }
//    else if(IS_IPHONE_5)
//    {
//        contentSize = CGSizeMake(270.0f, 420.0f);
//    }
//    else if(IS_IPHONE_6)
//    {
//        contentSize = CGSizeMake(317.0f, 450.0f);
//    }
//    else if(IS_IPHONE_6_PLUS)
//    {
//        contentSize = CGSizeMake(350.0f, 500.0f);
//    }
//    else if(IS_IPHONE_X)
//    {
//        contentSize = CGSizeMake(350.0f, 500.0f);
//    }
//    else
//    {
//        popup.imagename = @"logooooo.png";
//        contentSize = CGSizeMake(525.0f, 715.0f);
//    }
//
//    CCMPopupTransitioning *popup1 = [CCMPopupTransitioning sharedInstance];
//    popup1.destinationBounds = CGRectMake(0, 0, contentSize.width, contentSize.height);
//    popup1.presentedController = popup;
//    popup1.presentingController = controller;
//    popup1.backgroundBlurRadius = 0.0f;
//    popup1.backgroundViewColor = [UIColor blackColor];
//    popup1.backgroundViewAlpha = 0.5f;
//    [controller presentViewController:popup animated:YES completion:nil];
//
//}


+ (void)showActivateForDeviceNotEnrolled:(UIViewController *)controller
{
    SyncSettingsPopupController1 *popup = [[SyncSettingsPopupController1 alloc] init];
    popup.alertTitle = [NSString stringWithFormat:@"%@\n\n\n",[@"FamilyTime Dashboard" myModification]];
    popup.firstParagraph = [@"Device is not enrolled." myModification];
    popup.imagename = @"logooooo.png";
    popup.color = @"blue";
    CGSize contentSize;
    if(IS_IPHONE_4)
    {
        contentSize = CGSizeMake(270.0f, 420.0f);
    }
    else if(IS_IPHONE_5)
    {
        contentSize = CGSizeMake(270.0f, 420.0f);
    }
    else if(IS_IPHONE_6)
    {
        contentSize = CGSizeMake(317.0f, 450.0f);
    }
    else if(IS_IPHONE_6_PLUS)
    {
        contentSize = CGSizeMake(350.0f, 500.0f);
    }
    else if(IS_IPHONE_X)
        {
        contentSize = CGSizeMake(350.0f, 500.0f);
        }
    else
    {
        popup.imagename = @"logooooo.png";
        contentSize = CGSizeMake(525.0f, 715.0f);
    }
    
    CCMPopupTransitioning *popup1 = [CCMPopupTransitioning sharedInstance];
    popup1.destinationBounds = CGRectMake(0, 0, contentSize.width, contentSize.height);
    popup1.presentedController = popup;
    popup1.presentingController = controller;
    popup1.backgroundBlurRadius = 0.0f;
    popup1.backgroundViewColor = [UIColor blackColor];
    popup1.backgroundViewAlpha = 0.5f;
    [controller presentViewController:popup animated:YES completion:nil];
    
}


//+ (void)showActivateForUpdate:(UIViewController *)controller
//{
//    SyncSettingsPopupController11 *popup = [[SyncSettingsPopupController11 alloc] init];
//    popup.alertTitle = [NSString stringWithFormat:@"%@ %@\n\n\n",[@"FamilyTime" myModification],@"Update"];
//    popup.firstParagraph = [@"Good News! A new version of familyTime Dashboard is available" myModification];
//    popup.imagename = @"logooooo.png";
//    popup.color = @"blue";
//    CGSize contentSize;
//    if(IS_IPHONE_4)
//    {
//        contentSize = CGSizeMake(270.0f, 420.0f);
//    }
//    else if(IS_IPHONE_5)
//    {
//        contentSize = CGSizeMake(270.0f, 420.0f);
//    }
//    else if(IS_IPHONE_6)
//    {
//        contentSize = CGSizeMake(317.0f, 450.0f);
//    }
//    else if(IS_IPHONE_6_PLUS)
//    {
//        contentSize = CGSizeMake(350.0f, 500.0f);
//    }
//    else if(IS_IPHONE_X)
//        {
//        contentSize = CGSizeMake(350.0f, 500.0f);
//        }
//    else
//    {
//        popup.imagename = @"logooooo.png";
//        contentSize = CGSizeMake(525.0f, 715.0f);
//    }
//
//    CCMPopupTransitioning *popup1 = [CCMPopupTransitioning sharedInstance];
//    popup1.destinationBounds = CGRectMake(0, 0, contentSize.width, contentSize.height);
//    popup1.presentedController = popup;
//    popup1.presentingController = controller;
//    popup1.backgroundBlurRadius = 0.0f;
//    popup1.backgroundViewColor = [UIColor blackColor];
//    popup1.backgroundViewAlpha = 0.5f;
//    [controller presentViewController:popup animated:YES completion:nil];
//
//}
@end
