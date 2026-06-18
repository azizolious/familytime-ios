//
//  AppDelegate.h
//  FamilyTime
//
//  P3 (June 2026): minimal SwiftUI-era adapter. The app entry point is SwiftUI
//  (FamilyTimeApp); this delegate exists only for Firebase, push notifications,
//  the GoogleMaps key, and the LiveChat bootstrap.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
@import Firebase;

@interface AppDelegate : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate>
@property (strong, nonatomic) UIWindow *window;
@end
