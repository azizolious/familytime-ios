//
//  AppDelegate.m
//  FamilyTime
//
//  P3 (June 2026): minimal SwiftUI-era adapter. Firebase + push + GoogleMaps key
//  + LiveChat bootstrap only. All legacy bodies removed (Core Data stack, drawer/
//  storyboard setup, splash, styling, location, getAllInfo, UserDefaultsManager guard).
//

#import "AppDelegate.h"
#import <GoogleMaps/GoogleMaps.h>
#import <UserNotifications/UserNotifications.h>
#import "FamilyTime-Swift.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [FIRApp configure];
    [FIRAnalytics setAnalyticsCollectionEnabled:YES];

    // GoogleMaps key from Info.plist (-> Config.xcconfig); no key in source.
    NSString *googleMapsKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"GOOGLE_MAPS_API_KEY"] ?: @"";
    [GMSServices provideAPIKey:googleMapsKey];

    [self registerForRemoteNotifications:application];

    // LiveChat (protected) visitor session. LiveChatService reads the session token
    // from SessionManager (Keychain), so no legacy-token guard is needed.
    [[LiveVisitorManager shared] startVisitorSession];

    // Cold launch from a push.
    if (launchOptions) {
        NSDictionary *userInfo = [launchOptions valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (userInfo) {
            [self handlePush:userInfo];
        }
    }
    return YES;
}

#pragma mark - Push notifications

- (void)registerForRemoteNotifications:(UIApplication *)application {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge)
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            });
        }
    }];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *newToken = [self stringFromDeviceToken:deviceToken];
    // Stored under "deviceToken"; the SwiftUI LoginViewModel reads it for `push_token`.
    [[NSUserDefaults standardUserDefaults] setValue:(newToken ?: @"") forKey:@"deviceToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)stringFromDeviceToken:(NSData *)deviceToken {
    NSUInteger length = deviceToken.length;
    if (length == 0) { return nil; }
    const unsigned char *buffer = deviceToken.bytes;
    NSMutableString *hexString = [NSMutableString stringWithCapacity:(length * 2)];
    for (int i = 0; i < length; ++i) {
        [hexString appendFormat:@"%02x", buffer[i]];
    }
    return [hexString copy];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Failed to register for remote notifications: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [self handlePush:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
             fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [self handlePush:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    [self handlePush:notification.request.content.userInfo];
    completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionBadge);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void (^)(void))completionHandler {
    [self handlePush:response.notification.request.content.userInfo];
    completionHandler();
}

// Forward the raw APNs payload to the SwiftUI layer. PushAlertCenter observes
// `ft.pushReceived`, parses it into a typed PushAlert, and routes every push type.
- (void)handlePush:(NSDictionary *)userInfo {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ft.pushReceived" object:nil userInfo:userInfo];
}

@end
