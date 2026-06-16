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
#import <GoogleSignIn/GoogleSignIn.h>
#import "SwiftyStoreKit-Swift.h"
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
    NSURL *documentsDirectory = [self applicationDocumentsDirectory];
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
    [GIDSignIn sharedInstance].clientID = @"181235234645-bfr0co1kg4bn179g0rgec24tk1374v1t.apps.googleusercontent.com";
    [GIDSignIn sharedInstance].delegate = self;
    
//    ZDKChatLogger.isEnabled = YES;
//    ZDKChatLogger.defaultLevel = ZDKChatLogLevelVerbose;
    
//    [IQKeyboardManager sharedManager].enable = YES;
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
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
    //set Google map key
    [GMSServices provideAPIKey:kGoogleMapKey];
    if(self.isUserExists){
        [self setNavigationbarAppearence:NO];
        [self setupDrawer:0];
    } else {
        [self setNavigationbarAppearence:YES];
        [self setupDrawer:1];
    }
    [IAPUtility.new setupIAP];
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
    dispatch_async(dispatch_get_main_queue(), ^{
        if(flag == 0) {
            UIStoryboard *stb = [UIStoryboard storyboardWithName:@"Dashboard" bundle:nil];
            UINavigationController *dashboardRoot = [stb instantiateViewControllerWithIdentifier:@"DashboardRootNavig"];
            [self setNavigationbarAppearence:false];
            self.centerNavController = dashboardRoot;
            if(self.drawerCont == nil)
                self.drawerCont = [[SwiftParentDrawer alloc] initWithNibName:@"ParentDrawer" bundle:nil];
            [self.drawerCont reloadView];
            self.jasidePanel = [[JASidePanelController alloc]init];
            [self.centerNavController setNavigationBarHidden:NO];
            if([UIView appearance].semanticContentAttribute == UISemanticContentAttributeForceRightToLeft){
                self.jasidePanel.rightPanel      = self.drawerCont;
                self.jasidePanel.rightFixedWidth = 180;//257;
                self.jasidePanel.centerPanel    = self.centerNavController;
            } else {
                self.jasidePanel.leftPanel      = self.drawerCont;
                self.jasidePanel.leftFixedWidth = 220;//257;
                self.jasidePanel.centerPanel    = self.centerNavController;
            }
            //        self.jasidePanel.recognizesPanGesture = NO;
            self.jasidePanel.allowRightOverpan = NO;
            NSLog(@"%i", self.jasidePanel.state);
            [self.window setRootViewController:self.jasidePanel];
            [self.window makeKeyAndVisible];
        } else {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Auth" bundle: [NSBundle mainBundle]];
            UINavigationController *initialNavigVC = [storyboard instantiateViewControllerWithIdentifier:@"LoginNavigVC"];
            if (!self.isUserExists) {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Auth" bundle: [NSBundle mainBundle]];
                UINavigationController *initialNavigVC = [storyboard instantiateViewControllerWithIdentifier:@"LoginNavigVC"];
                [self.window setRootViewController: initialNavigVC];
                [self.window makeKeyAndVisible];
                return;
            }
            [self.window setRootViewController: initialNavigVC];
            [self.window makeKeyAndVisible];
        }
    });
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
    NSString *chatType = userInfo[@"type"];
    NSDictionary *device = [[userInfo valueForKey:@"aps"] valueForKey:@"device"];
    NSString *pushtype = [[userInfo valueForKey:@"aps"] valueForKey:@"pushtype"];
    NSString *newPushdata = [userInfo  valueForKey:@"data"];
    NSString *newPushtype = [newPushdata valueForKey:@"subtype"];
    NSString *type = [[userInfo valueForKey:@"aps"] valueForKey:@"type"];
    NSString *body = [[userInfo valueForKey:@"aps"] valueForKey:@"body"];
    NSString *title = [[userInfo valueForKey:@"aps"] valueForKey:@"title"];
    //NSString *message = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
    NSString *appName = [[userInfo valueForKey:@"aps"] valueForKey:@"app_name"];
    NSString *appPackage = [[userInfo valueForKey:@"aps"] valueForKey:@"app_package"];
    NSString *name = [device valueForKey:@"name"];
    NSString *senderName = [[userInfo valueForKey:@"aps"] valueForKey:@"sendername"];
    if(!self.isUserExists)
        return;
    
    //    NSString *push_time = [[userInfo valueForKey:@"aps"] valueForKey:@"push_time"];
    //    NSString *accuracy = [[userInfo valueForKey:@"aps"] valueForKey:@"accuracy"];
    //    NSString *address = [[userInfo valueForKey:@"aps"] valueForKey:@"address"];
    //    NSString *latitude = [[userInfo valueForKey:@"aps"] valueForKey:@"latitude"];
    //    NSString *longitude = [[userInfo valueForKey:@"aps"] valueForKey:@"longitude"];
    //    NSString *gender = [device valueForKey:@"gender"];
    //NSString *title = [[userInfo valueForKey:@"aps"] valueForKey:@"title"];
    //NSString *alert = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
    //    if (type) {
    //        self.childPush.gender = gender;
    //        self.childPush.childName = name;
    //        self.childPush.child_id = childID;
    //        self.childPush.push_content = body;
    //        self.childPush.time = push_time;
    //        self.childPush.lat = latitude;
    //        self.childPush.longi = longitude;
    //        self.childPush.address = address;
    //        self.childPush.accuracy = accuracy;
    //    } else {
    //        self.childPush.gender    = [[userInfo valueForKey:@"aps"] valueForKey:@"gender"];
    //        self.childPush.child_id  = [[userInfo valueForKey:@"aps"] valueForKey:@"senderid"];
    //        self.childPush.childName = [[userInfo valueForKey:@"aps"] valueForKey:@"sendername"];
    //        self.childPush.push_content = [[userInfo valueForKey:@"aps"] valueForKey:@"push_content"];
    //        self.childPush.time  = [[userInfo valueForKey:@"aps"] valueForKey:@"pushtime"];
    //        self.childPush.accuracy  = [[userInfo valueForKey:@"aps"] valueForKey:@"accuracy"];
    //        self.childPush.address        = [[userInfo valueForKey:@"aps"] valueForKey:@"address"];
    //        self.childPush.lat       = [[userInfo valueForKey:@"aps"] valueForKey:@"lat"];
    //        self.childPush.longi     = [[userInfo valueForKey:@"aps"] valueForKey:@"long"];
    //    }
    
    //    if (type) {
    //        if ([[type lowercaseString]  isEqualToString: @"panic"] || [type isEqualToString:@"panic"]) {
    //            UIStoryboard *stb = [UIStoryboard storyboardWithName:@"Dashboard" bundle:nil];
    //            CommonPopupVC *vc = [stb instantiateViewControllerWithIdentifier:@"CommonPopupVC"];
    //            UIViewController *activeCont = [self.centerNavController.viewControllers lastObject];
    //            [vc setModalPresentationStyle: UIModalPresentationFullScreen];
    //            [activeCont presentViewController:vc animated:YES completion:nil];
    //        }
    //    } else {
    //        if([pushtype isEqualToString:@"pickup"] || [pushtype isEqualToString:@"panic"])
    //        {
    //            UIStoryboard *stb = [UIStoryboard storyboardWithName:@"Dashboard" bundle:nil];
    //            CommonPopupVC *vc = [stb instantiateViewControllerWithIdentifier:@"CommonPopupVC"];
    //            UIViewController *activeCont = [self.centerNavController.viewControllers lastObject];
    //            [vc setModalPresentationStyle: UIModalPresentationFullScreen];
    //            [activeCont presentViewController:vc animated:YES completion:nil];
    //        }
    //    }
    
    if ([chatType isEqualToString:@"agent_message"]) {
        
        [[NSUserDefaults standardUserDefaults]
         setObject:userInfo
         forKey:@"LIVE_CHAT_PUSH_DATA"];
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"LIVE_CHAT_PUSH_CLICKED"
         object:nil];
    }
    
    self.childPush           = [[PushModel alloc] init];
    self.childPush.pushType  = pushtype;
    self.childPush.typeCore = type;
    self.childPush.imgsrc    = [[userInfo valueForKey:@"aps"] valueForKey:@"imgsrc"];
    self.childPush.placeName = [[userInfo valueForKey:@"aps"] valueForKey:@"place_name"];
    self.childPush.gender    = [[userInfo valueForKey:@"aps"] valueForKey:@"gender"];
    //self.childPush.child_id  = [[userInfo valueForKey:@"aps"] valueForKey:@"senderid"];
    self.childPush.child_id  = [[userInfo valueForKey:@"data"] valueForKey:@"device_id"];
    self.childPush.childName = [[userInfo valueForKey:@"aps"] valueForKey:@"sendername"];
    self.childPush.push_content = [[userInfo valueForKey:@"aps"] valueForKey:@"push_content"];
    self.childPush.time  = [[userInfo valueForKey:@"aps"] valueForKey:@"pushtime"];
    self.childPush.address        = [[userInfo valueForKey:@"aps"] valueForKey:@"address"];
    self.childPush.lat       = [[userInfo valueForKey:@"aps"] valueForKey:@"lat"];
    self.childPush.longi     = [[userInfo valueForKey:@"aps"] valueForKey:@"long"];
    //self.childPush.descriptionn   = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
    NSString *alertType         = [[userInfo valueForKey:@"aps"] valueForKey:@"alertType"];
    NSString *deviceName        = [[userInfo valueForKey:@"aps"] valueForKey:@"deviceName"];
    self.childPush.speedLimit   = [[userInfo valueForKey:@"aps"] valueForKey:@"speedLimit"];
    self.childPush.currentSpeed = [[userInfo valueForKey:@"aps"] valueForKey:@"currentSpeed"];
    self.childPush.startLatitude  = [[userInfo valueForKey:@"aps"] valueForKey:@"startLatitude"];
    self.childPush.startLongitude = [[userInfo valueForKey:@"aps"] valueForKey:@"startLongitude"];
    self.childPush.endLatitude    = [[userInfo valueForKey:@"aps"] valueForKey:@"endLatitude"];
    self.childPush.endLongitude   = [[userInfo valueForKey:@"aps"] valueForKey:@"endLongitude"];
    NSLog(@"device name = %@ and userInfo dict = %@", deviceName, userInfo);
    NSString *pushTime = [[userInfo valueForKey:@"aps"] valueForKey:@"pushtime"];
    NSString *pushGender = [[userInfo valueForKey:@"aps"] valueForKey:@"gender"];
    NSString *pushadd = [[userInfo valueForKey:@"aps"] valueForKey:@"address"];
    NSString *placeName = [[userInfo valueForKey:@"aps"] valueForKey:@"place_name"];
    [[NSUserDefaults standardUserDefaults] setValue: placeName forKey:@"push_child_place"];
    [[NSUserDefaults standardUserDefaults] setValue: pushadd forKey:@"push_child_address"];
    [[NSUserDefaults standardUserDefaults] setValue: pushGender forKey:@"push_child_gender"];
    [[NSUserDefaults standardUserDefaults] setValue: pushtype forKey:@"push_child_type"];
    [[NSUserDefaults standardUserDefaults] setValue: pushTime forKey:@"push_child_Time"];
    [[NSUserDefaults standardUserDefaults] setValue:self.childPush.child_id forKey:@"push_child_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [UIApplication sharedApplication].applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber+1;
    dispatch_async(dispatch_get_main_queue(), ^{
        UIApplicationState state = [[UIApplication sharedApplication] applicationState];
        if (state == UIApplicationStateInactive){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PICK_ME_UP_INACTIVE" object:nil userInfo:userInfo];
        }
        if (state == UIApplicationStateBackground || state == UIApplicationStateInactive) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"APPROVED_APP_INACTIVE_BACKGROUND" object:nil userInfo:userInfo];
            [[NSUserDefaults standardUserDefaults] setValue: title forKey:@"APPROVED_APP_TITLE"];
            [[NSUserDefaults standardUserDefaults] setValue: body forKey:@"APPROVED_APP_BODY"];
        }
        if (!(state == UIApplicationStateBackground || state == UIApplicationStateInactive || state == UIApplicationStateActive))
            [self setupDrawer:0];
    });
    
    //MARK: Handling Notifications W.r.t Push Type
    if ([[pushtype lowercaseString]  isEqualToString: @"signup_auth_ios"]) {
        NSLog(@"Silent push notification received pushtype: %@", pushtype);
        if (![self.userDefault boolForKey:kEmailVerified]) {
            [self.userDefault setBool:YES forKey: kEmailVerified];
            id topVC = [[[UIApplication sharedApplication] keyWindow] rootViewController];
            if ([topVC isKindOfClass: UINavigationController.class]) {
                UINavigationController *topNav = (UINavigationController *)topVC;
                if ([[topNav viewControllers] count] > 0) {
                    if ([[[topNav viewControllers] lastObject] isKindOfClass:EmailConfirmationVC.class]) {
                        EmailConfirmationVC *vc = [[topNav viewControllers] lastObject];
                        [vc callSignupAuthAPI];
                    }
                }
            }
            return;
        }
        
    } else if ([[type lowercaseString]  isEqualToString: @"subscription_create"] || [[type lowercaseString]  isEqualToString: @"subscription_renew"] || [[type lowercaseString]  isEqualToString: @"subscription_refund"] || [[type lowercaseString]  isEqualToString: @"subscription_cancel"]) {
        [self setupDrawer:0];
        NSLog(@"Silent push notification received type: %@", type);
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey: @"subscription_created_push"];
        id topVC = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        if ([topVC isKindOfClass: UINavigationController.class]) {
            UINavigationController *topNav = (UINavigationController *)topVC;
            if ([[topNav viewControllers] count] > 0) {
                if ([[[topNav viewControllers] lastObject] isKindOfClass:DashboardVC.class]) {
                    DashboardVC *vc = [[topNav viewControllers] lastObject];
                    [vc reloadDashboardData];
                } else {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"subscription_created_observer" object:nil userInfo:userInfo];
                }
            }
        }
        return;
        
    } else if ([[pushtype lowercaseString]  isEqualToString: @"subscription_created"] || [[pushtype lowercaseString]  isEqualToString: @"subscription_updated"]) {
        [self setupDrawer:0];
        NSLog(@"Silent push notification received push type: %@", pushtype);
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey: @"subscription_created_push"];
        id topVC = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        if ([topVC isKindOfClass: UINavigationController.class]) {
            UINavigationController *topNav = (UINavigationController *)topVC;
            if ([[topNav viewControllers] count] > 0) {
                if ([[[topNav viewControllers] lastObject] isKindOfClass:DashboardVC.class]) {
                    DashboardVC *vc = [[topNav viewControllers] lastObject];
                    [vc reloadDashboardData];
                } else {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"subscription_created_observer" object:nil userInfo:userInfo];
                }
            }
        }
        return;
        
    } else if ([[type lowercaseString]  isEqualToString: @"email_verified"] || [[type lowercaseString]  isEqualToString: @"email_bounce_fixed"] || [[type lowercaseString]  isEqualToString: @"email_complaint_fixed"] || [[type lowercaseString]  isEqualToString: @"email_bounced"] || [[type lowercaseString]  isEqualToString: @"email_complaint"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"EMAIL_VERIFIED_PUSH"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self setupDrawer:0];
        id topVC = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        if ([topVC isKindOfClass: UINavigationController.class]) {
            UINavigationController *topNav = (UINavigationController *)topVC;
            if ([[topNav viewControllers] count] > 0) {
                if ([[[topNav viewControllers] lastObject] isKindOfClass:DashboardVC.class]) {
                    DashboardVC *vc = [[topNav viewControllers] lastObject];
                    [vc getAccountAPI];
                }
            }
        }
        return;
        
    }else if ([type isEqualToString:@"app_approved"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey: @"approve_app_TEST"];
        NSString *chilId = [[userInfo valueForKey:@"data"] valueForKey:@"device_id"];
        [[NSUserDefaults standardUserDefaults] setValue:chilId forKey:@"approve_app_id"];
        UIStoryboard *stb = [UIStoryboard storyboardWithName:@"Dashboard" bundle:nil];
        ApprovedAppPopupVc *vc = [stb instantiateViewControllerWithIdentifier:@"ApprovedAppPopupVc"];
        UIViewController *activeCont = [self.centerNavController.viewControllers lastObject];
        NSString *appPackage = [[userInfo valueForKey:@"data"] valueForKey:@"app_package"];
        NSString *appName = [[userInfo valueForKey:@"data"] valueForKey:@"app_name"];
        NSString *appDesc = [[userInfo valueForKey:@"data"] valueForKey:@"body"];
        //MARK: SET USER DEFAULTS
        [[NSUserDefaults standardUserDefaults] setValue:title forKey:@"app_title"];
        [[NSUserDefaults standardUserDefaults] setValue:appDesc forKey:@"app_body"];
        [[NSUserDefaults standardUserDefaults] setValue:appName forKey:@"app_name"];
        [[NSUserDefaults standardUserDefaults] setValue:appPackage forKey:@"app_package"];
        [[NSUserDefaults standardUserDefaults] setValue:name forKey:@"approve_app_CHILD_NAME"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        vc.titleText = appName;
        vc.body = appDesc;
        vc.appName = appName;
        vc.appPackage = appPackage;
        [vc setModalPresentationStyle: UIModalPresentationFullScreen];
        [activeCont presentViewController:vc animated:YES completion:nil];
        
    }
//    else if ([type isEqualToString:@"approve_app"]) {
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey: @"approve_app_TEST"];
//        NSString *chilId = [[userInfo valueForKey:@"data"] valueForKey:@"device_id"];
//        [[NSUserDefaults standardUserDefaults] setValue:chilId forKey:@"approve_app_id"];
//        UIStoryboard *stb = [UIStoryboard storyboardWithName:@"Dashboard" bundle:nil];
//        ApprovedAppPopupVc *vc = [stb instantiateViewControllerWithIdentifier:@"ApprovedAppPopupVc"];
//        UIViewController *activeCont = [self.centerNavController.viewControllers lastObject];
//        //MARK: SET USER DEFAULTS
//        [[NSUserDefaults standardUserDefaults] setValue:title forKey:@"approve_app_TITLE"];
//        [[NSUserDefaults standardUserDefaults] setValue:body forKey:@"approve_app_BODY"];
//        [[NSUserDefaults standardUserDefaults] setValue:appName forKey:@"approve_app_NAME"];
//        [[NSUserDefaults standardUserDefaults] setValue:appPackage forKey:@"approve_app_PACKAGE"];
//        [[NSUserDefaults standardUserDefaults] setValue:name forKey:@"approve_app_CHILD_NAME"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        vc.titleText = title;
//        vc.body = body;
//        vc.appName = appName;
//        vc.appPackage = appPackage;
//        [vc setModalPresentationStyle: UIModalPresentationFullScreen];
//        [activeCont presentViewController:vc animated:YES completion:nil];
//
//    }
    else if ([[pushtype lowercaseString]  isEqualToString: @"new_child"] || [[pushtype lowercaseString]  isEqualToString: @"login"] || [[pushtype lowercaseString]  isEqualToString: @"profile_updated"] || [[pushtype lowercaseString]  isEqualToString: @"new_child_second_type"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CHILD_CREATED_PUSH" object:nil userInfo:userInfo];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey: @"Update_Home"];
        [self setupDrawer:0];
        id topVC = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        if ([topVC isKindOfClass: UINavigationController.class]) {
            UINavigationController *topNav = (UINavigationController *)topVC;
            if ([[topNav viewControllers] count] > 0) {
                if ([[[topNav viewControllers] lastObject] isKindOfClass:DashboardVC.class]) {
                    DashboardVC *vc = [[topNav viewControllers] lastObject];
                    [vc reloadDashboardData];
                    [vc reloadControl];
                }
            }
        }
        return;
        
    } else if ([pushtype isEqualToString:@"childPermission"]) {
        SwiftPermissionScreenViewControllerPush *pickupCont = [[SwiftPermissionScreenViewControllerPush alloc] initWithNibName:@"PermissionScreenViewControllerPush" bundle:nil];
        pickupCont.rowDic=userInfo;
        pickupCont.strDeviceName=deviceName;
        UIViewController *activeCont = [self.centerNavController.viewControllers lastObject];
        [pickupCont setModalPresentationStyle: UIModalPresentationFullScreen];
        [activeCont presentViewController:pickupCont animated:YES completion:nil];
        
    } else if ([pushtype isEqualToString:@"ruleActivated"] || [pushtype isEqualToString:@"ruleDeactivated"]) {
        SwiftLimitScreentimeActivatedPushViewController *pickupCont = nil;
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            pickupCont = [[SwiftLimitScreentimeActivatedPushViewController alloc] initWithNibName:@"LimitScreentimeActivatedPushViewControllerIPAD" bundle:nil];
        else
            pickupCont = [[SwiftLimitScreentimeActivatedPushViewController alloc] initWithNibName:@"LimitScreentimeActivatedPushViewController~iphone" bundle:nil];
        NSLog(@"user info = %@ and device name = %@", userInfo, deviceName);
        pickupCont.mainTitle    = [[userInfo valueForKey:@"aps"] valueForKey:@"title"];
        pickupCont.subTitle = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
        UIViewController *activeCont = [self.centerNavController.viewControllers lastObject];
        [pickupCont setModalPresentationStyle: UIModalPresentationFullScreen];
        [activeCont presentViewController:pickupCont animated:YES completion:nil];
        
    } else if ([pushtype isEqualToString:@"FirstTimeData"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RemoveSteps" object:self];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadHome" object:nil userInfo:userInfo];
        
    } else if ([type isEqualToString:@"pick_me_up"]) {
        
        //MARK: - NEW ANS STRUCTURE
        NSString *subType = [[userInfo valueForKey:@"data"] valueForKey:@"subtype"];
        NSString *subtype2 = [[userInfo valueForKey:@"aps"] valueForKey:@"subtype"];
        if ([subType isEqualToString:@"coming"] || [subType isEqualToString:@"not_coming"] || [subtype2 isEqualToString:@"coming"] || [subtype2 isEqualToString:@"not_coming"]) {
            UIViewController *activeCont = [self.centerNavController.viewControllers lastObject];
            [activeCont dismissViewControllerAnimated:YES completion:nil];
            return;
        }
        NSString *newGender = [[userInfo valueForKey:@"data"] valueForKey:@"gender"];
        NSString *newPushTime = [[userInfo valueForKey:@"data"] valueForKey:@"push_time"];
        NSString *newSendername = [[userInfo valueForKey:@"data"] valueForKey:@"sendername"];
        NSString *newAddress = [[userInfo valueForKey:@"data"] valueForKey:@"address"];
        NSString *newPushtpype = [[userInfo valueForKey:@"aps"] valueForKey:@"type"];
        NSString *newMessage = [[userInfo valueForKey:@"data"] valueForKey:@"message"];
        NSString *newPushContent = [[userInfo valueForKey:@"data"] valueForKey:@"push_content"];
        NSString *accuracy = [[userInfo valueForKey:@"data"] valueForKey:@"accuracy"];
//        NSDictionary *alertObj = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
//        NSString *newAlert = [alertObj valueForKey:@"alert"];
        
        
        NSString *chilName = [[userInfo valueForKey:@"data"] valueForKey:@"device_name"];
        NSString *chilId = [[userInfo valueForKey:@"data"] valueForKey:@"device_id"];
        [[NSUserDefaults standardUserDefaults] setValue:pushtype forKey:@"pickup_string"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey: @"sos_pickup"];
        [[NSUserDefaults standardUserDefaults] setValue:newPushtpype forKey:@"panicSOS_string"];
        [[NSUserDefaults standardUserDefaults] setValue:accuracy forKey:@"pushAccuracy"];
        [[NSUserDefaults standardUserDefaults] setValue:chilName forKey:@"user_name_str"];
        [[NSUserDefaults standardUserDefaults] setValue:chilId forKey:@"senderid"];
        if (newGender){
            [[NSUserDefaults standardUserDefaults] setValue:newGender forKey:@"genderStr"];
        }
        if (newPushTime){
            [[NSUserDefaults standardUserDefaults] setValue:newPushTime forKey:@"push_time"];
        }else{
            NSString *timeStr = [[userInfo valueForKey:@"data"] valueForKey:@"pushtime"];
            [[NSUserDefaults standardUserDefaults] setValue:timeStr forKey:@"push_time"];
        }
        
        if (newPushContent){
            [[NSUserDefaults standardUserDefaults] setValue:newPushContent forKey:@"push_content"];
        }else{
            NSString *pushContent = [[userInfo valueForKey:@"data"] valueForKey:@"push_content"];
            [[NSUserDefaults standardUserDefaults] setValue:pushContent forKey:@"push_content"];
        }
        NSString *latitudeStr      = [[userInfo valueForKey:@"data"] valueForKey:@"latitude"];
        NSString *longitudeStr     = [[userInfo valueForKey:@"data"] valueForKey:@"longitude"];
        if (latitudeStr){
            [[NSUserDefaults standardUserDefaults] setValue:latitudeStr forKey:@"lat_str"];
        }
        if (longitudeStr){
            [[NSUserDefaults standardUserDefaults] setValue:longitudeStr forKey:@"long_str"];
        }
        [[NSUserDefaults standardUserDefaults] setValue:newSendername forKey:@"child_name"];
        [[NSUserDefaults standardUserDefaults] setValue:newAddress forKey:@"address_str"];
        [[NSUserDefaults standardUserDefaults] setValue:newPushtpype forKey:@"pushType"];
        //[[NSUserDefaults standardUserDefaults] setValue:newAlert forKey:@"newAlert"];
        [[NSUserDefaults standardUserDefaults] setValue:newMessage forKey:@"newMessage"];
        
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        UIStoryboard *stb = [UIStoryboard storyboardWithName:@"Dashboard" bundle:nil];
        CommonPopupVC *vc = [stb instantiateViewControllerWithIdentifier:@"CommonPopupVC"];
        UIViewController *activeCont = [self.centerNavController.viewControllers lastObject];
        [vc setModalPresentationStyle: UIModalPresentationFullScreen];
        [activeCont presentViewController:vc animated:YES completion:nil];
        
    } else if ([type isEqualToString:@"sos"]){
        //MARK: - NEW ANS STRUCTURE
        NSString *subType = [[userInfo valueForKey:@"data"] valueForKey:@"subtype"];
        NSString *subtype2 = [[userInfo valueForKey:@"aps"] valueForKey:@"subtype"];
        if ([subType isEqualToString:@"got_you"] || [subtype2 isEqualToString:@"got_you"]) {
            UIViewController *activeCont = [self.centerNavController.viewControllers lastObject];
            [activeCont dismissViewControllerAnimated:YES completion:nil];
            return;
        }
        NSString *newGender = [[userInfo valueForKey:@"data"] valueForKey:@"gender"];
        NSString *newPushTime = [[userInfo valueForKey:@"data"] valueForKey:@"pushtime"];
        NSString *newSendername = [[userInfo valueForKey:@"data"] valueForKey:@"sendername"];
        NSString *newAddress = [[userInfo valueForKey:@"data"] valueForKey:@"address"];
        NSString *newPushtpype = [[userInfo valueForKey:@"aps"] valueForKey:@"type"];
        NSString *newMessage = [[userInfo valueForKey:@"data"] valueForKey:@"message"];
        NSString *newPushContent = [[userInfo valueForKey:@"data"] valueForKey:@"push_content"];
        NSString *accuracy = [[userInfo valueForKey:@"data"] valueForKey:@"accuracy"];
//        NSDictionary *alertObj = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
//        NSString *newAlert = [alertObj valueForKey:@"alert"];
        
        
        //SETTING VALUES FOR PICKUP AND PANIC
        NSString *chilName = [[userInfo valueForKey:@"data"] valueForKey:@"device_name"];
        NSString *chilId = [[userInfo valueForKey:@"data"] valueForKey:@"device_id"];
        [[NSUserDefaults standardUserDefaults] setValue:accuracy forKey:@"pushAccuracy"];
        [[NSUserDefaults standardUserDefaults] setValue:newPushtpype forKey:@"panicSOS_string"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey: @"sos_pickup"];
        [[NSUserDefaults standardUserDefaults] setValue:chilName forKey:@"user_name_str"];
        [[NSUserDefaults standardUserDefaults] setValue:chilId forKey:@"senderid"];
        if (newGender){
            [[NSUserDefaults standardUserDefaults] setValue:newGender forKey:@"genderStr"];
        }
        if (newPushTime){
            [[NSUserDefaults standardUserDefaults] setValue:newPushTime forKey:@"push_time"];
        }else{
            NSString *timeStr = [[userInfo valueForKey:@"data"] valueForKey:@"push_time"];
            [[NSUserDefaults standardUserDefaults] setValue:timeStr forKey:@"push_time"];
        }
        
        if (newPushContent){
            [[NSUserDefaults standardUserDefaults] setValue:newPushContent forKey:@"push_content"];
        }else{
            NSString *pushContent = [[userInfo valueForKey:@"data"] valueForKey:@"push_content"];
            [[NSUserDefaults standardUserDefaults] setValue:pushContent forKey:@"push_content"];
        }
        
        NSString *latitudeStr       = [[userInfo valueForKey:@"data"] valueForKey:@"latitude"];
        NSString *longitudeStr     = [[userInfo valueForKey:@"data"] valueForKey:@"longitude"];
        if (latitudeStr){
            [[NSUserDefaults standardUserDefaults] setValue:latitudeStr forKey:@"lat_str"];
        }
        if (longitudeStr){
            [[NSUserDefaults standardUserDefaults] setValue:longitudeStr forKey:@"long_str"];
        }
        [[NSUserDefaults standardUserDefaults] setValue:newSendername forKey:@"child_name"];
        [[NSUserDefaults standardUserDefaults] setValue:newAddress forKey:@"address_str"];
        [[NSUserDefaults standardUserDefaults] setValue:newPushtpype forKey:@"pushType"];
        //[[NSUserDefaults standardUserDefaults] setValue:newAlert forKey:@"newAlert"];
        [[NSUserDefaults standardUserDefaults] setValue:newMessage forKey:@"newMessage"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        UIStoryboard *stb = [UIStoryboard storyboardWithName:@"Dashboard" bundle:nil];
        CommonPopupVC *vc = [stb instantiateViewControllerWithIdentifier:@"CommonPopupVC"];
        UIViewController *activeCont = [self.centerNavController.viewControllers lastObject];
        [vc setModalPresentationStyle: UIModalPresentationFullScreen];
        [activeCont presentViewController:vc animated:YES completion:nil];
        
        
    }
    //else if ([pushtype isEqualToString:@"panic"] || [pushtype isEqualToString:@"pickup"]){
        //MARK: - APNS FOR PANIC AND PICKUP
//        NSString *newGender = [[userInfo valueForKey:@"aps"] valueForKey:@"gender"];
//        NSString *newPushTime = [[userInfo valueForKey:@"aps"] valueForKey:@"pushtime"];
//        NSString *newSendername = [[userInfo valueForKey:@"aps"] valueForKey:@"sendername"];
//        NSString *newAddress = [[userInfo valueForKey:@"aps"] valueForKey:@"address"];
//        NSString *newPushtpype = [[userInfo valueForKey:@"aps"] valueForKey:@"pushtype"];
//        NSString *newMessage = [[userInfo valueForKey:@"aps"] valueForKey:@"message"];
//        NSString *newPushContent = [[userInfo valueForKey:@"aps"] valueForKey:@"push_content"];
//        NSString *senderId = [[userInfo valueForKey:@"aps"] valueForKey:@"senderid"];
////        NSDictionary *alertObj = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
////        NSString *newAlert = [alertObj valueForKey:@"alert"];
//
//
//        //SETTING VALUES FOR PICKUP AND PANIC
//        NSString *chilName = [[userInfo valueForKey:@"aps"] valueForKey:@"device_name"];
//        [[NSUserDefaults standardUserDefaults] setValue:newPushtpype forKey:@"panicSOS_string"];
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey: @"sos_pickup"];
//        [[NSUserDefaults standardUserDefaults] setValue:newSendername forKey:@"user_name_str"];
//
//        if (newGender){
//            [[NSUserDefaults standardUserDefaults] setValue:newGender forKey:@"genderStr"];
//        }
//        if (newPushTime){
//            [[NSUserDefaults standardUserDefaults] setValue:newPushTime forKey:@"push_time"];
//        }else{
//            NSString *timeStr = [[userInfo valueForKey:@"aps"] valueForKey:@"pushtime"];
//            [[NSUserDefaults standardUserDefaults] setValue:timeStr forKey:@"push_time"];
//        }
//
//        if (newPushContent){
//            [[NSUserDefaults standardUserDefaults] setValue:newPushContent forKey:@"push_content"];
//        }else{
//            NSString *pushContent = [[userInfo valueForKey:@"aps"] valueForKey:@"push_content"];
//            [[NSUserDefaults standardUserDefaults] setValue:pushContent forKey:@"push_content"];
//        }
//
//        NSString *latitudeStr       = [[userInfo valueForKey:@"aps"] valueForKey:@"lat"];
//        NSString *longitudeStr     = [[userInfo valueForKey:@"aps"] valueForKey:@"long"];
//        if (latitudeStr){
//            [[NSUserDefaults standardUserDefaults] setValue:latitudeStr forKey:@"lat_str"];
//        }
//        if (longitudeStr){
//            [[NSUserDefaults standardUserDefaults] setValue:longitudeStr forKey:@"long_str"];
//        }
//        [[NSUserDefaults standardUserDefaults] setValue:newSendername forKey:@"child_name"];
//        [[NSUserDefaults standardUserDefaults] setValue:newAddress forKey:@"address_str"];
//        [[NSUserDefaults standardUserDefaults] setValue:newPushtpype forKey:@"pushType"];
//        [[NSUserDefaults standardUserDefaults] setValue:senderId forKey:@"senderid"];
//       // [[NSUserDefaults standardUserDefaults] setValue:newAlert forKey:@"newAlert"];
//        [[NSUserDefaults standardUserDefaults] setValue:newMessage forKey:@"newMessage"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//
//        UIStoryboard *stb = [UIStoryboard storyboardWithName:@"Dashboard" bundle:nil];
//        CommonPopupVC *vc = [stb instantiateViewControllerWithIdentifier:@"CommonPopupVC"];
//        UIViewController *activeCont = [self.centerNavController.viewControllers lastObject];
//        [vc setModalPresentationStyle: UIModalPresentationFullScreen];
//        [activeCont presentViewController:vc animated:YES completion:nil];
//
 //   }
    else if([pushtype isEqualToString:@"contact_watchlist"]) {
        NSString *message = [[userInfo valueForKey:@"aps"] valueForKey:@"message"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey: @"Contact_Watchlist_Push"];
        [[NSUserDefaults standardUserDefaults] setValue:message forKey:@"app_block_contact_watchlist_message"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        UIStoryboard *stb = [UIStoryboard storyboardWithName:@"Dashboard" bundle:nil];
        ContactWatchListPopup *vc = [stb instantiateViewControllerWithIdentifier:@"ContactWatchListPopup"];
        UIViewController *activeCont = [self.centerNavController.viewControllers lastObject];
        vc.titleNames = message;
        [vc setModalPresentationStyle: UIModalPresentationFullScreen];
        [activeCont presentViewController:vc animated:YES completion:nil];
        
    } else if([type isEqualToString:@"low_battery"]) {
        NSString *title = [[userInfo valueForKey:@"data"] valueForKey:@"title"];
        NSString *body = [[userInfo valueForKey:@"data"] valueForKey:@"body"];
        NSString *subtype = [[userInfo valueForKey:@"data"] valueForKey:@"subtype"];
        NSString *subtype2 = [[userInfo valueForKey:@"aps"] valueForKey:@"subtype"];
        if ([subtype  isEqualToString: @"charge"] || [subtype2 isEqualToString:@"charge"]) {
            UIViewController *activeCont = [self.centerNavController.viewControllers lastObject];
            [activeCont dismissViewControllerAnimated:YES completion:nil];
            return;
        }
        NSString *deviceID = [[userInfo valueForKey:@"data"] valueForKey:@"device_id"];
        NSString *requestTime = [[userInfo valueForKey:@"data"] valueForKey:@"requested_time"];
        [[NSUserDefaults standardUserDefaults] setValue:title forKey:@"lowBatterytitle"];
        [[NSUserDefaults standardUserDefaults] setValue:body forKey:@"lowBatterybody"];
        [[NSUserDefaults standardUserDefaults] setValue:subtype forKey:@"lowBatterysubtype"];
        [[NSUserDefaults standardUserDefaults] setValue:deviceID forKey:@"lowBatterydeviceId"];
        [[NSUserDefaults standardUserDefaults] setValue:requestTime forKey:@"lowBatteryRequestTime"];
        BatteryLowPopUp *vc = [[BatteryLowPopUp alloc] initWithNibName:@"BatteryLowPopUp" bundle:nil];
        UIViewController *activeCont = [self.centerNavController.viewControllers lastObject];
        [activeCont dismissViewControllerAnimated:YES completion:nil];
        [vc setModalPresentationStyle: UIModalPresentationFullScreen];
        [activeCont presentViewController:vc animated:YES completion:nil];
        
    } else if ([pushtype isEqualToString:@"app_blocking"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey: @"app_blocking_status"];
        [[NSUserDefaults standardUserDefaults] setValue:title forKey:@"app_block_child_name"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        UIStoryboard *stb = [UIStoryboard storyboardWithName:@"Dashboard" bundle:nil];
        BlockAppStatusVcPopUp *vc = [stb instantiateViewControllerWithIdentifier:@"BlockAppStatusVcPopUp"];
        UIViewController *activeCont = [self.centerNavController.viewControllers lastObject];
        vc.childName = title;
        [vc setModalPresentationStyle: UIModalPresentationFullScreen];
        [activeCont presentViewController:vc animated:YES completion:nil];
        
    } else if ([pushtype isEqualToString:@"phonelocked"] || [pushtype isEqualToString:@"phoneunlocked"]) {
        //[[NSNotificationCenter defaultCenter] postNotificationName:KPhoneLockStatus object:nil];
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey: @"Update_Home"];
//        [self setupDrawer:0];
//        id topVC = [[[UIApplication sharedApplication] keyWindow] rootViewController];
//        if ([topVC isKindOfClass: UINavigationController.class]) {
//            UINavigationController *topNav = (UINavigationController *)topVC;
//            if ([[topNav viewControllers] count] > 0) {
//                if ([[[topNav viewControllers] lastObject] isKindOfClass:DashboardVC.class]) {
//                    DashboardVC *vc = [[topNav viewControllers] lastObject];
//                    [vc reloadDashboardData];
//                }
//            }
//        }
        return;
    } else if([pushtype isEqualToString:@"panic_back"]) {
        
    } else if([newPushtype isEqualToString:@"checkin"] || [newPushtype isEqualToString:@"checkout"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey: @"geo_fence_status"];
        NSString *lat = [newPushdata valueForKey:@"latitude"];
        NSString *lng = [newPushdata valueForKey:@"longitude"];
        [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%@", lat] forKey:@"kGeofenceLatitude"];
        [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%@", lng] forKey:@"kGeofenceLongitude"];
        NSString *childName = [newPushdata valueForKey:@"device_name"];
        NSString *pushTime = [newPushdata valueForKey:@"push_time"];
        NSString *placeName = [newPushdata valueForKey:@"place_name"];
        NSString *childAdd = [newPushdata valueForKey:@"address"];
        NSString *accuracy = [newPushdata valueForKey:@"accuracy"];
        [[NSUserDefaults standardUserDefaults] setValue: placeName forKey:@"push_child_place"];
        [[NSUserDefaults standardUserDefaults] setValue: childAdd forKey:@"push_child_address"];
        [[NSUserDefaults standardUserDefaults] setValue: pushTime forKey:@"push_child_Time"];
        [[NSUserDefaults standardUserDefaults] setValue: newPushtype forKey:@"push_child_type"];
        //NSString *placeName = [newPushdata valueForKey:@"place_name"];
        [[NSUserDefaults standardUserDefaults] setValue:childName forKey:@"checkInChildName"];
        [[NSUserDefaults standardUserDefaults] setValue:accuracy forKey:@"push_child_accuracy"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        UIStoryboard *stb = [UIStoryboard storyboardWithName:@"Dashboard" bundle:nil];
        GeoFencePopupVC *vc = [stb instantiateViewControllerWithIdentifier:@"GeoFencePopupVC"];
        UIViewController *activeCont = [self.centerNavController.viewControllers lastObject];
        [vc setModalPresentationStyle: UIModalPresentationFullScreen];
        [activeCont presentViewController:vc animated:YES completion:nil];
        
    } else if ([alertType isEqualToString:@"normalSpeed"] || [alertType isEqualToString:@"overSpeed"]) {
        UIStoryboard *stb = [UIStoryboard storyboardWithName:@"Dashboard" bundle:nil];
        SpeedPopupVC *vc = [stb instantiateViewControllerWithIdentifier:@"SpeedPopupVC"];
        UIViewController *activeCont = [self.centerNavController.viewControllers lastObject];
        [vc setModalPresentationStyle: UIModalPresentationFullScreen];
        [activeCont presentViewController:vc animated:YES completion:nil];
        
    } else if ([alertType isEqualToString:@"All Set"]) {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"RemoveSteps"
         object:self];
        
    } else if([alertType isEqualToString:@"All Set!"]) {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"RemoveSteps"
         object:self];
        
    } else {
        NSString *title = [[userInfo valueForKey:@"aps"] valueForKey:@"title"];
        if([title isEqualToString:@"All Set!"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RemoveSteps" object:self];
            //            [FIRAnalytics logEventWithName:@"child_added" parameters:@{@"activation_status":@"Child Activated"}];
        } else  if ([title isEqualToString:@"All Set"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RemoveSteps" object:self];
            //            [FIRAnalytics logEventWithName:@"child_added"  parameters:@{ @"activation_status":@"Child Activated"}];
        }
    }
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

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    // Perform any operations on signed in user here.
    NSString *userId = user.userID;                  // For client-side use only!
    NSString *idToken = user.authentication.idToken; // Safe to send to the server
    NSString *fullName = user.profile.name;
    NSString *email = user.profile.email;
    // [START_EXCLUDE]
    NSLog(@"%@", fullName);
    if(idToken != nil) {
        NSDictionary *statusText = @{@"statusText": [NSString stringWithFormat:@"Signed in user: %@",fullName],
                                     @"user_id": userId,
                                     @"id_token": idToken,
                                     @"email": email,
                                     @"name": fullName};
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ToggleAuthUINotification" object:nil userInfo:statusText];
    }
    // [END_EXCLUDE]
}

// [END signin_handler]
// This callback is triggered after the disconnect call that revokes data
// access to the user's resources has completed.
// [START disconnect_handler]
- (void)signIn:(GIDSignIn *)signIn didDisconnectWithUser:(GIDGoogleUser *)user withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    // [START_EXCLUDE]
    NSDictionary *statusText = @{@"statusText": @"Disconnected user" };
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"ToggleAuthUINotification"
     object:nil
     userInfo:statusText];
    // [END_EXCLUDE]
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSLog(@"%@",url.absoluteString);
    NSLog(@"%@",sourceApplication);
    //---REMOVE FACEBOOK DUE TO MDM---//
    //    BOOL FacebookCheck = [[FBSDKApplicationDelegate sharedInstance]application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    
    BOOL GoogleCheck = [[GIDSignIn sharedInstance] handleURL:url sourceApplication:sourceApplication annotation:annotation];
    return GoogleCheck;
    //---REMOVE FACEBOOK DUE TO MDM---//
    //    return  FacebookCheck||GoogleCheck;
}
@end
