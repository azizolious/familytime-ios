//
//  AppDelegate.h
//  FamilyTime
//
//  Created by Sora Code on 11/11/14.
//  Copyright (c) 2014 SoraCode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h> 
//#import "ParentLoginViewController.h"
#import "DataModel.h"
//#import "DashboardTableViewController.h"
#import "LocationShareModel.h"
#import "LocationTracker.h"
#import "ActivityAlertView.h"
#import "JASidePanelController.h"
#import "ParentDrawer.h"
#import "Constant.h"
#import "Dashboard.h"
//#import "DashboardVC.h"
#import <UserNotifications/UserNotifications.h>
//@import GoogleSignIn;
#import <GoogleSignIn/GoogleSignIn.h>

@import Firebase;
@class SwiftParentDrawer;

#define RGBCOLOR(R,G,B, A) [UIColor colorWithRed:R/255.2f green:G/255.2f blue:B/255.2f alpha:A]

typedef void(^deviceTokenReceived)(NSString *token);

@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate, UNUserNotificationCenterDelegate, GIDSignInDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong) NSPersistentContainer *persistentContainer;
@property (nonatomic,strong) UINavigationController * centerNavController;
@property(nonatomic,strong) JASidePanelController *jasidePanel;

@property(nonatomic,strong) SwiftParentDrawer *drawerCont;

@property (nonatomic, copy) deviceTokenReceived tokenCallback;

//@property (nonatomic,strong) DashboardTableViewController *dboardCont;
//@property (nonatomic,strong) DashboardTableViewController *dashboardCont;


@property (nonatomic,strong) ChildModel *selectedChild;
@property (nonatomic,strong) PushModel *childPush;
@property (nonatomic,strong) UserModel *parent;
@property (nonatomic,strong) UserDeviceModel *userDevice;
@property (nonatomic,strong) NSUserDefaults *userDefault;
@property (nonatomic,strong) ActivityAlertView *activityAlert;
@property (nonatomic,strong) Preferences *preferences;
@property (nonatomic,strong) FamilyModel *family;

//@property (nonatomic,strong) LoginViewController *loginViewController;


//New Model
@property (nonatomic, strong) Dashboard         *dashboard;
@property (nonatomic, strong) DashboardCoParent *selectedDashboardParent;
@property (nonatomic, strong) DashboardChild    *selectedDashboardChild;
//@property (nonatomic, strong) Children_Model    *m;
@property (nonatomic, assign) NSInteger         isChildSelected;


@property (strong,nonatomic) LocationShareModel * shareModel;
@property LocationTracker * locationTracker;
@property (nonatomic) NSTimer* locationUpdateTimer;

@property (nonatomic) CLLocationCoordinate2D myLocation;
@property (nonatomic) CLLocationAccuracy myLocationAccuracy;
-(void) setUpLocaitonUpdates:(NSDictionary *)launchOptions;
- (void)registerRegionWithCircularOverlay:(CLCircularRegion *)region;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

+(AppDelegate *) appDelegate;
+(AppDelegate *) getSharedAppDelegateForSwift;
    
-(void) setupDrawer:(int) flag;

-(void) setNavigationbarAppearence:(BOOL)isWhite;
-(void) setNavigationbarAppearence:(BOOL)isWhite cont:(UIViewController *)cont;
-(void) registerForRemoteNotifications:(UIApplication *)application;


//-(void) setNavigationbarAppearenceMustafa:(BOOL)isWhite cont:(UIViewController *)cont;
- (BOOL) taketoEmailVerificationScreen;
- (BOOL) isUserExists;
- (BOOL) emailVerified;


@end

