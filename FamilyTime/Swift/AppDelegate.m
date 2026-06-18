//
//  AppDelegate.m
//  FamilyTime
//
//  Created by Sora Code on 11/11/14.
//  Copyright (c) 2014 SoraCode. All rights reserved.
//

#import "AppDelegate.h"
#import "SplashView.h"
#import "NSString+AESCrypt.h"
#import "Constant.h"
#import <GoogleMaps/GoogleMaps.h>
//#import "ParentPickupViewController.h"
//#import "ParentSOSViewController.h"
//#import "WizardScreen4ViewController.h"
//#import <ZendeskCoreSDK/ZendeskCoreSDK.h>
#import "FTUtils.h"
#import <CoreLocation/CoreLocation.h>
#import <AddressBookUI/AddressBookUI.h>
#import <UserNotifications/UserNotifications.h>
#import "IQKeyboardManager.h"
#import "SingleLineTextField.h"
//---REMOVE FACEBOOK DUE TO MDM---//
//#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "LimitScreentimeActivatedPushViewController.h"
#import "PermissionScreenViewControllerPush.h"
#import "FTUtils.h"
//#import "JSONHTTPClient.h"
#import "MBProgressHUD.h"
#import <CoreLocation/CoreLocation.h>
#import <sys/utsname.h>
#import "ChatStyling.h"
// TODO: GoogleSignIn disabled temporarily — replace with GoogleSignIn 7.x via SPM when legacy Auth VCs are removed
//#import <GoogleSignIn/GoogleSignIn.h>
#import "FamilyTime-Swift.h"
//#import <ChatSDK/ChatSDK.h>
//#import <ChatProvidersSDK/ChatProvidersSDK.h>
//@import GoogleSignIn;

@class IAPUtility;

//static NSString* const installedAppListPath = @"/private/var/mobile/Library/Caches/com.apple.mobile.installation.plist";
//NSString* deviceName() {
//    struct utsname systemInfo;
//    uname(&systemInfo);
//    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
//}

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define kOpenLiveChatPush @"kOpenLiveChatPush"

@interface AppDelegate ()
//@property (nonatomic, strong) CLLocationManager *locationManager;
//@property (nonatomic,strong) DashboardVC *swiftDashboardVc;
@end

AppDelegate *delegate;
@implementation AppDelegate

-(void)setUpLocaitonUpdates:(NSDictionary *)launchOptions {
    NSLog(@"Something To Print");
}

-(void)registerRegionWithCircularOverlay:(CLCircularRegion *)region {
}

//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
//    return [[GIDSignIn sharedInstance] handleURL:url sourceApplication:sourceApplication annotation:annotation];
//}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    YourAppCheckProviderFactory *providerFactory =
            [[YourAppCheckProviderFactory alloc] init];
    [FIRAppCheck setAppCheckProviderFactory:providerFactory];
    [FIRApp configure];
    [FIRAnalytics setAnalyticsCollectionEnabled:YES];
    [FIRAnalytics setConsent:@{
    FIRConsentTypeAnalyticsStorage : FIRConsentStatusGranted,
    FIRConsentTypeAdStorage : FIRConsentStatusGranted,
    FIRConsentTypeAdUserData : FIRConsentStatusGranted,
    FIRConsentTypeAdPersonalization : FIRConsentStatusGranted,
    }];
    
    [self styleApp];
    //Set Arabic and English language
    [Global setlanguage];
    // apply appearance styling first if you want to customise the look of the chat
    [ChatStyling applyStyling];
    
//    [ZDKChat initializeWithAccountKey:@"3SFP4o0ZGIlzTBHUuO2gfu8Sy4YiwlPp" appId:@"754abc37f24b4e7447f58b3d3269f5c15a2c0c2dac8b4327" queue:dispatch_get_main_queue()];
    
    // configure account key and pre-chat form
    // remember to switch off debug logging before app store submission!
//    ZDKChatLogger.isEnabled = YES;
//    ZDKChatLogger.defaultLevel = ZDKChatLogLevelVerbose;
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    // TODO: GoogleSignIn disabled temporarily — replace with GoogleSignIn 7.x via SPM when legacy Auth VCs are removed
    //[GIDSignIn sharedInstance].clientID = @"181235234645-bfr0co1kg4bn179g0rgec24tk1374v1t.apps.googleusercontent.com";
    //[GIDSignIn sharedInstance].delegate = self;
    
//    ZDKChatLogger.isEnabled = YES;
//    ZDKChatLogger.defaultLevel = ZDKChatLogLevelVerbose;
    
//    [IQKeyboardManager sharedManager].enable = YES;
    // Override point for customization after application launch.
    self.userDefault = [NSUserDefaults standardUserDefaults];
    self.parent = [[UserModel alloc]initWithDictionary:[self.userDefault objectForKey:@"user"] error:nil];
    // set S3 bucket keys
    NSString *string = [self.userDefault objectForKey:@"userRelation"];
    if(string == nil){
        [self.userDefault setObject:self.parent.relationship forKey:@"userRelation"];
        [self.userDefault synchronize];
    }
    [self registerForRemoteNotifications:application];
    self.shareModel = [LocationShareModel sharedModel];
    //set Google map key (read from Info.plist -> Config.xcconfig; no key in source)
    NSString *googleMapsKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"GOOGLE_MAPS_API_KEY"] ?: @"";
    [GMSServices provideAPIKey:googleMapsKey];
    // [P2] Legacy nav-bar / drawer launch setup removed — SwiftUI owns the window & navigation.
    [[NSUserDefaults standardUserDefaults] setObject: kYES forKey:kUpdateParentDataOnce];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HIT_EMAIL_VERIFICAION_API"];
    [[NSUserDefaults standardUserDefaults] setValue:@"Settings" forKey:@"DRAWER_TYPE"];
    [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"HasLaunchedOnce"];
    [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"dismiss_trail_screen"];
    [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"apiCalled"];
    
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kGeofenceLatitude"];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kGeofenceLongitude"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        [appearance configureWithOpaqueBackground];
        appearance.backgroundColor = UIColor.whiteColor;
        [appearance setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
        [appearance setLargeTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
        UINavigationBar.appearance.scrollEdgeAppearance = appearance;
        UINavigationBar.appearance.standardAppearance = appearance;
    }
    
    //Supreman down
    //    NSArray *appFolderContents = [[NSFileManager defaultManager] directoryContentsAtPath:@"/Applications"];
    //    NSLog(@"cool:%@",appFolderContents);
    ///Here Superman
    //    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    //    NSString *applicationSupportDirectory = [paths firstObject];
    //    NSLog(@"applicationSupportDirectory: '%@'", applicationSupportDirectory);
    //
    //    NSString *filePath = @"/Applications/Cydia.app";
    //    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    //    {
    //            // do something useful
    //    }
    //    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:filePath error:NULL];
    //    for (int count = 0; count < (int)[directoryContent count]; count++)
    //    {
    //        NSLog(@"File %d: %@", (count + 1), [directoryContent objectAtIndex:count]);
    //    }
    //    NSLog(@"Yo:%@",directoryContent);
    //
    //    NSLog(@"Yo:%@",[self installedApp]);
    //
    //   NSLog(@"Yo:%@",[self desktopAppsFromDictionary]);
    
    
    //  [self installedApp];
    //        config.accountKey = @"3SFP4o0ZGIlzTBHUuO2gfu8Sy4YiwlPp";
    //    }];
    // Uncomment to disable visitor data persistence between application runs
    
    // Uncomment if you don't want open chat sessions to be automatically resumed on application launch
    //    [[IQKeyboardManager sharedManager]setEnableAutoToolbar:NO];
    
    //    if (self.locationManager == nil)
    //        self.locationManager = [[CLLocationManager alloc] init];
    //    [self.locationManager requestWhenInUseAuthorization];
    //    self.locationManager.delegate = self;
    //    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //    [self.locationManager startUpdatingLocation];
    //    [FIRApp configure];
    //    [GIDSignIn sharedInstance].clientID = @"181235234645-bfr0co1kg4bn179g0rgec24tk1374v1t.apps.googleusercontent.com";
    //    [GIDSignIn sharedInstance].clientID = [FIRApp defaultApp].options.clientID;
    //    [GIDSignIn sharedInstance].delegate = self;
    //    [self getAllInfo];
    //    [[NSUserDefaults standardUserDefaults] setObject:@[@"en",@"ru"] forKey:@"AppleLanguages"];
    //   NSLog(@"All languages=%@",[NSLocale preferredLanguages]);
    //    NSString *language = [[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0];
    //    NSLog(@"language=%@",language);
    //---REMOVE FACEBOOK DUE TO MDM---//
    //    [[FBSDKApplicationDelegate sharedInstance] application:application
    //                             didFinishLaunchingWithOptions:launchOptions];
    
    // Configure tracker from GoogleService-Info.plist.
    //    NSError *configureError;
    //    [[EAGLContext sharedInstance] configureWithError:&configureError];
    //    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    //GAI *gai = [GAI sharedInstance];
    //gai.trackUncaughtExceptions = YES;  // report uncaught exceptions
    //gai.logger.logLevel = kGAILogLevelVerbose;  // remove before app release
    // [defaults setBool:NO forKey:@"test"];
    //    self.dboardCont  = [[DashboardTableViewController alloc] initWithNibName:@"DashboardTableViewController" bundle:nil];
    //self.jasidePanel = [[JASidePanelController alloc]init];
    //    [self.centerNavController setNavigationBarHidden:NO];
    //    self.jasidePanel.centerPanel =  self.centerNavController;
    //    [self.window setRootViewController:self.jasidePanel];
    //    [self.window makeKeyAndVisible];
    //    [IAPUtility.shared setupIAP];
    //    [self showSplash];
    //[SwiftFTUtils showOverSpeedAlert:self.window.rootViewController childID:9371 childName:@"MDM" isSon:NO startLatitude:31.523001 startLongitude:74.347892 endLatitude:31.506885 endLongitude:74.336884 speedLimit:30 currentSpeed:45 address:nil accuracy:@"20 m" isOverSpeed:YES alertTime:[self getUTCFormateDate:[NSDate date]]];
    //    PermissionScreenViewControllerPush *pickupCont = [[PermissionScreenViewControllerPush alloc] initWithNibName:@"PermissionScreenViewControllerPush" bundle:nil];
    //    pickupCont.rowDic=userInfo;
    //    UIViewController *activeCont = [self.centerNavController.viewControllers lastObject];
    //    [self presentViewController:pickupCont animated:YES completion:nil];
    //    LimitScreentimeActivatedPushViewController *pickupCont = [[LimitScreentimeActivatedPushViewController alloc] initWithNibName:@"LimitScreentimeActivatedPushViewController~iphone" bundle:nil];
    //    pickupCont.strDeviceName=@"LG Yo";
    //    UIViewController *activeCont = [self.centerNavController.viewControllers lastObject];
    //    [activeCont presentViewController:pickupCont animated:YES completion:nil];
    /*
     NSDictionary *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
     if (notification)
     {
     NSLog(@"app recieved notification from remote%@",notification);
     [self application:application didReceiveRemoteNotification:notification];
     }
     else
     {
     NSLog(@"app did not recieve notification");
     }
     */
    //    if (@available(iOS 13.0, *)) {
    //        [self initializingAuthenticationService];
    //    }
    //UINavigationBar.appearance().isTranslucent = false
    //UINavigationBar.appearance().barTintColor = .red
    //    if (@available(iOS 13.0, *)) {
    //        UINavigationBarAppearance *apper = [[UINavigationBarAppearance alloc] init];
    //        [apper configureWithDefaultBackground];
    //        UINavigationBar.appearance.scrollEdgeAppearance = apper;
    //    } else {
    //        // Fallback on earlier versions
    //    }
    //Language Orientatation changing...
    //    if ([[NSUserDefaults.standardUserDefaults stringForKey:@"userlanguage"] isEqual:@"ar"] || [[NSUserDefaults.standardUserDefaults stringForKey:@"userlanguage"] isEqual:@"he"]) {
    //
    //        [UIView appearance].semanticContentAttribute == UISemanticContentAttributeForceRightToLeft;
    //
    //    } else {
    //        [UIView appearance].semanticContentAttribute == UISemanticContentAttributeForceLeftToRight;
    //    }
    
    if ([UserDefaultsManager bearerTokenCore2].length > 0) {
        
        [[LiveVisitorManager shared]
         startVisitorSession];
    }
    
//MARK:  Register Push Notification
    if (launchOptions) {
        NSDictionary *userInfo = [launchOptions valueForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
        if (userInfo) {
            [self handlePush:userInfo];
        }
    }
    return YES;
}

- (NSString *)getUTCFormateDate:(NSDate *)localDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:localDate];
    NSLog(@"%@",dateString);
    return dateString;
}
#pragma mark settup dashboard drawer
-(void) setupDrawer:(int) flag {
    // [P2] Legacy drawer / JASidePanel / storyboard / window-root setup removed.
    // SwiftUI (AppNavigationView) owns navigation and the window. Retained as a
    // no-op because legacy VCs still call it; they are deleted in P3.
}

- (BOOL) taketoEmailVerificationScreen {
    if (!self.emailVerified) {
        NSString *email = [self.userDefault stringForKey:kUserEmail];
        if (email != NULL || email.length > 0) {
            return YES;
        }
    }
    return NO;
}

- (BOOL) isUserExists {
    NSString *token = [self.userDefault objectForKey:@"LoginAuthToken"];
    if (token != NULL || token.length > 0) {
        return YES;
    }
    return NO;
}

- (BOOL) emailVerified {
    return [self.userDefault boolForKey: kEmailVerified];
}


- (void) addStatusBarImageNamed:(NSString*)image removeOnExit: (BOOL) remove {
}


#pragma mark - Push Notifications
-(void) registerForRemoteNotifications:(UIApplication *)application {
    if (@available(iOS 10.0, *)) {
        //Mustafa
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            if(!error){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[UIApplication sharedApplication] registerForRemoteNotifications];
                });
            }
        }];
    } else {
        if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)]){
            ////  iOS 8 Notifications
            [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
            [application registerForRemoteNotifications];
        } else {
            ////  iOS < 8 Notifications
            [application registerForRemoteNotificationTypes:
             (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
        }
    }
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken {
    NSLog(@"DEVICE TOKEN = %@", deviceToken);
    NSString *newToken = [self stringFromDeviceToken:deviceToken];
    NSLog(@"new token for ios 13 = %@", newToken);
    if (newToken != nil) {
        [self.userDefault setValue:newToken forKey:kDeviceToken];
    } else {
        [self.userDefault setValue:@"" forKey:kDeviceToken];
    }
    [self.userDefault synchronize];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC),dispatch_get_main_queue(),^{
        if (self.tokenCallback) {
            _tokenCallback(newToken);
        }
    });
}

//---FOR IOS 13 TOKEN STRING CHANGED---//
- (NSString *)stringFromDeviceToken:(NSData *)deviceToken {
    NSUInteger length = deviceToken.length;
    if (length == 0) {
        return nil;
    }
    const unsigned char *buffer = deviceToken.bytes;
    NSMutableString *hexString  = [NSMutableString stringWithCapacity:(length * 2)];
    for (int i = 0; i < length; ++i) {
        [hexString appendFormat:@"%02x", buffer[i]];
    }
    NSLog(@"hex string for token = %@", hexString);
    return [hexString copy];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error{
    NSLog(@"Failed to get token, error: %@", error);
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"Received Remote Notification: %@", userInfo);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC),dispatch_get_main_queue(),^{
        [self handlePush:userInfo];
    });
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    //MARK: Called when a notification is delivered to a foreground app.
    NSLog(@"Userinfo %@",notification.request.content.userInfo);
    [self handlePush:notification.request.content.userInfo];
    completionHandler(UNNotificationPresentationOptionAlert);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler; {
    //MARK: Called to let your app know which action was selected by the user for a given notification.
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    NSLog(@"Received Notification Payload: %@", userInfo);
//    NSLog(@"Userinfo %@",response.notification.request.content.userInfo.description);
    [self handlePush:response.notification.request.content.userInfo];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult)) completionHandler {
    //MARK: Called when a notification is delivered to a Background app.
    NSLog(@"Userinfo %@",userInfo);
    [self handlePush:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    return;
}

- (void)handlePush:(NSDictionary *)userInfo {
    NSLog(@"push info %@", userInfo);
    // Modernization bridge: forward the raw APNs payload to the SwiftUI layer.
    // PushAlertCenter observes `ft.pushReceived`, parses it into a typed PushAlert,
    // and routes every push type. [P2] The legacy push -> UIKit-VC routing that used
    // to follow has been removed; this post is now the sole handler.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ft.pushReceived" object:nil userInfo:userInfo];
}

- (void)openLiveChatFromPush:(NSDictionary *)userInfo {

    dispatch_async(dispatch_get_main_queue(), ^{

        [[NSNotificationCenter defaultCenter]
         postNotificationName:kOpenLiveChatPush
         object:nil
         userInfo:userInfo];
    });
}

- (BOOL)getChildGender:(NSInteger)childId {
    for (ChildModel *childModel in self.family.children) {
        if ([childModel.child_id integerValue] == childId) {
            if ([childModel.gender isEqualToString:@"male"])
                return YES;
            return NO;
        }
    }
    return NO;
}

#pragma mark - Navigation bar appearence
//-(void) setNavigationbarAppearenceMustafa:(BOOL)isWhite cont:(UIViewController *)cont {
//    //    [cont.navigationController.navigationBar setBarTintColor:[]];
//    [cont.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
//
//}
-(void) setNavigationbarAppearence:(BOOL)isWhite {
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTintColor:kPrimaryColor()];
    //UIFont *font = [UIFont fontWithName:@"OpenSans-Light" size:20.0];
    //    if(isWhite){
    //        [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName:font}];
    //    } else {
    //        [[UINavigationBar appearance] setBarTintColor:kPrimaryColor()];
    //        //UINavigationItem *navItem = [UINavigationItem alloc];
    //        navItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top_bg.png"]];
    //[[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    //        [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName :kTextColor(), NSFontAttributeName:font}];
    //}
}

-(void) setNavigationbarAppearence:(BOOL)isWhite cont:(UIViewController *)cont {
    //    [self setNavigationbarAppearence:isWhite];
    //    UIFont *font = [UIFont fontWithName:@"OpenSans-Light" size:20.0];
    //    if(isWhite){
    //        [cont.navigationController.navigationBar setBarTintColor:kBarTintColor()];
    //        [cont.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    //        [cont.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName:font}];
    //    } else {
    //        [cont.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    //        [cont.navigationController.navigationBar setTintColor:kBarTextColor()];
    //        [cont.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : kTextColor(), NSFontAttributeName:font}];
    //    }
}

+(AppDelegate *) appDelegate {
    if (delegate == nil){
        delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    }
    return delegate;
}

+(AppDelegate *) getSharedAppDelegateForSwift {
    if (delegate == nil){
        delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    }
    return delegate;
}

- (void) showSplash {
    SplashView * splash = [[SplashView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    splash.animation = SplashViewAnimationFade;
    [splash setDelay:1];
    [splash setTouchAllowed:NO];
    [splash startSplash];
}

//- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
//{
//    return [[FBSDKApplicationDelegate sharedInstance] application:app
//                                                          openURL:url
//                                                sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
//                                                       annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
//
//
//
//}

//- (BOOL)application: (UIApplication *)application openURL: (NSURL *)url sourceApplication: (NSString *)sourceApplication annotation: (id)annotation
//{
//
////    if ([GPPURLHandler handleURL:url sourceApplication:sourceApplication annotation:annotation]) {
////        return YES;
////    }else if([FBAppCall handleOpenURL:url sourceApplication:sourceApplication]){
////        return YES;
////    }
//
//    return YES;
//}


//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
//{
//    return YES;
//}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

    __block UIBackgroundTaskIdentifier liveChatDisconnectTask =
    [application beginBackgroundTaskWithName:@"LiveChatDisconnect"
                           expirationHandler:^{
        [application endBackgroundTask:liveChatDisconnectTask];
        liveChatDisconnectTask = UIBackgroundTaskInvalid;
    }];

    [[LiveVisitorManager shared] disconnectVisitorSession];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                 (int64_t)(5 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
        if (liveChatDisconnectTask != UIBackgroundTaskInvalid) {
            [application endBackgroundTask:liveChatDisconnectTask];
            liveChatDisconnectTask = UIBackgroundTaskInvalid;
        }
    });
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    if ([UserDefaultsManager bearerTokenCore2].length > 0) {
        
        [[LiveVisitorManager shared]
         startVisitorSession];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self saveContext];
}

-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    completionHandler(UIBackgroundFetchResultNewData);
}

// Below are 3 functions that add location and Application status to PList
// The purpose is to collect location information locally
#pragma mark - Core Data stack
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize persistentContainer = _persistentContainer;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.soracode.FamilyTime" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"FamilyTime" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    // Create the coordinator and store
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"FamilyTime.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:@{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES} error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"FamilyTime"]; //e.g. CoreDataModel.xcdatamodeld
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


-(void)getAllInfo {
    NSLog(@"OS=%f",[[UIDevice currentDevice].systemVersion floatValue]);
    //    NSLog(@"%@",[NSString deviceName]);
    struct utsname systemInfo;
    uname(&systemInfo);
    //    NSLog(@"Model info=%@",[NSString stringWithCString:systemInfo.machine
    //                                   encoding:NSUTF8StringEncoding]);
    //
    //    NSLog(@"Model info=%@",[NSString stringWithCString:systemInfo.version
    //                                              encoding:NSUTF8StringEncoding]);
    //    NSLog(@"Model info=%@",[NSString stringWithCString:systemInfo.release
    //                                              encoding:NSUTF8StringEncoding]);
    NSLog(@"Model info=%@",[NSString stringWithCString:systemInfo.nodename encoding:NSUTF8StringEncoding]);
    //    NSLog(@"%@", [[UIDevice currentDevice] platformType]) ;
    //     // ex: @"iPhone 4G"
    //    [[UIDevice currentDevice] platformString]
}


- (void) styleApp {
    // status bar
    //   [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    // nav bar
    //    NSDictionary *navbarAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
    //                                      [UIColor whiteColor] ,UITextAttributeTextColor, nil];
    //    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    //    [[UINavigationBar appearance] setTitleTextAttributes:navbarAttributes];
    //    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.91f green:0.16f blue:0.16f alpha:1.0f]];
    if ([self isVersionOrNewer:@"8.0"]) {
        // For translucent nav bars set YES
        [[UINavigationBar appearance] setTranslucent:NO];
    }
    // For a completely transparent nav bar uncomment this and set 'translucent' above to YES
    // (you may also want to change the title text and tint colors above since they are white by default)
    [[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];
    //[[UINavigationBar appearance] setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //[[UINavigationBar appearance] setShadowImage:[UIImage new]];
    //[[UINavigationBar appearance] setBackgroundColor:[UIColor clearColor]];
}


void uncaughtExceptionHandler(NSException *exception){
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
}

- (BOOL) isVersionOrNewer:(NSString*)majorVersionNumber{
    return [[[UIDevice currentDevice] systemVersion] compare:majorVersionNumber options:NSNumericSearch] != NSOrderedAscending;
}

#pragma mark - Google Signin
// [END openurl]
// [START signin_handler]

// TODO: GoogleSignIn disabled temporarily — replace with GoogleSignIn 7.x via SPM when legacy Auth VCs are removed
//- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
//    // Perform any operations on signed in user here.
//    NSString *userId = user.userID;                  // For client-side use only!
//    NSString *idToken = user.authentication.idToken; // Safe to send to the server
//    NSString *fullName = user.profile.name;
//    NSString *email = user.profile.email;
//    // [START_EXCLUDE]
//    NSLog(@"%@", fullName);
//    if(idToken != nil) {
//        NSDictionary *statusText = @{@"statusText": [NSString stringWithFormat:@"Signed in user: %@",fullName],
//                                     @"user_id": userId,
//                                     @"id_token": idToken,
//                                     @"email": email,
//                                     @"name": fullName};
//
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"ToggleAuthUINotification" object:nil userInfo:statusText];
//    }
//    // [END_EXCLUDE]
//}

// [END signin_handler]
// This callback is triggered after the disconnect call that revokes data
// access to the user's resources has completed.
// [START disconnect_handler]
// TODO: GoogleSignIn disabled temporarily — replace with GoogleSignIn 7.x via SPM when legacy Auth VCs are removed
//- (void)signIn:(GIDSignIn *)signIn didDisconnectWithUser:(GIDGoogleUser *)user withError:(NSError *)error {
//    // Perform any operations when the user disconnects from app here.
//    // [START_EXCLUDE]
//    NSDictionary *statusText = @{@"statusText": @"Disconnected user" };
//    [[NSNotificationCenter defaultCenter]
//     postNotificationName:@"ToggleAuthUINotification"
//     object:nil
//     userInfo:statusText];
//    // [END_EXCLUDE]
//}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSLog(@"%@",url.absoluteString);
    NSLog(@"%@",sourceApplication);
    //---REMOVE FACEBOOK DUE TO MDM---//
    //    BOOL FacebookCheck = [[FBSDKApplicationDelegate sharedInstance]application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    
    // TODO: GoogleSignIn disabled temporarily — replace with GoogleSignIn 7.x via SPM when legacy Auth VCs are removed
    //BOOL GoogleCheck = [[GIDSignIn sharedInstance] handleURL:url sourceApplication:sourceApplication annotation:annotation];
    BOOL GoogleCheck = NO;
    return GoogleCheck;
    //---REMOVE FACEBOOK DUE TO MDM---//
    //    return  FacebookCheck||GoogleCheck;
}
@end
