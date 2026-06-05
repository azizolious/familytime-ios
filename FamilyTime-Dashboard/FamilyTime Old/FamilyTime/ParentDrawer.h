//
//  ParentDrawer.h
//  FamilyTime
//
//  Created by Sora Code on 3/2/15.
//  Copyright (c) 2015 SoraCode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocHistoryViewController.h"
#import "ContactViewController.h"
#import "BrowserLogsViewController.h"
#import "BookmarksViewController.h"
#import "CallLogsViewController.h"
//#import "ChangePassViewController1.h"
#import "PlacesViewController.h"
#import "LeftSidePanel.h"
#import "LeftSidePaneliOS.h"
//#import "UserProfileViewController.h"
#import "BaseViewController.h"
#import "AllInstalledAppsViewController.h"
#import "PlacesReportViewController.h"
#import "HelpViewController.h"
#import "FamilyMapViewController.h"
//#import "AppUsageViewController.h"

#import "ParentProfileViewController.h"
#import "ParentsViewControllerAll.h"



@interface ParentDrawer : BaseViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) LocHistoryViewController * locCont;
@property (nonatomic,strong) LeftSidePanel * settingsCont;
@property (nonatomic,strong) LeftSidePaneliOS * settingsContiOS;
@property (nonatomic,strong) PlacesViewController *placesCont;
@property (nonatomic,strong) CallLogsViewController * callLogsCont;
@property (nonatomic,strong) BookmarksViewController * bookmarksCont;
@property (nonatomic,strong) BrowserLogsViewController * browserCont;
@property (nonatomic,strong) AllInstalledAppsViewController * installAppsCont;
@property (nonatomic,strong) ContactViewController * contactsCont;
@property (nonatomic, strong) PlacesReportViewController *placesReportViewController;
@property (nonatomic, strong) HelpViewController *helpViewController;
@property (nonatomic, strong) FamilyMapViewController *familyMapViewController;
//@property (nonatomic, strong) AppUsageViewController *appUsage;

@property (nonatomic, strong) ParentProfileViewController *parentProfile;
@property (nonatomic, strong) ParentsViewControllerAll *parentVCAll;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray  *dataSource;
@property (strong, nonatomic) NSArray  *dataSourceNew;

@property (nonatomic,strong) NSString *contName;
@property (weak, nonatomic) IBOutlet UIImageView *parentImage;
@property (weak, nonatomic) IBOutlet UILabel *parentName;



@property (strong, nonatomic) IBOutlet UIView *alertSubView;
@property (weak, nonatomic) IBOutlet UIButton *btnNo;
@property (weak, nonatomic) IBOutlet UIButton *btnYes;

- (IBAction)btnPressedYes:(id)sender;

- (IBAction)btnPressedNo:(id)sender;



-(void) reloadView;



@end
