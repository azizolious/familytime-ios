//
//  LeftSidePanel.m
//  FamilyTime
//
//  Created by Sora Code on 11/19/14.
//  Copyright (c) 2014 SoraCode. All rights reserved.
//

#import "LeftSidePaneliOS.h"
#import "LeftSidesTableViewCell.h"
#import "AppDelegate.h"
//#import "JSONHTTPClient.h"
#import "MBProgressHUD.h"
#import "CustomIOS7AlertView.h"
#import "FTD.h"
//#import <Google/Analytics.h>
#import "FTUtils.h"
#import "ContentFilterViewController.h"
#import "SpeedLimitViewController.h"
#import "LimitScreenViewController.h"
#import "Dashboard.h"
#import "NSString+LockMustafa.h"
#import "FamilyTime-Swift.h"
//#import "DeviceVC.h"

@class CoreDataUtility;

NSString *leftSide_package_id = @"";
NSString *leftSide_package_name = @"";
NSString *leftSide_device = @"";



AppDelegate *delegate;
@interface LeftSidePaneliOS (){
    BOOL speedLimitDoublePushFlag; //---PUSH PREMIUM SCREEN 2 TIMES, TO AVOID THIS---//
}

@end

@implementation LeftSidePaneliOS
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
//    [ZendeskChatManager trackEvent:@"Settings ios device"];

    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"settingsiOS" ofType:@"plist"];
    self.dataSource = [NSDictionary dictionaryWithContentsOfFile:filePath];
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    [self.tableView reloadData];
    
    speedLimitDoublePushFlag = false;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    
    [self.navigationItem setTitle:[@"Settings" myModification]];
    delegate                = [AppDelegate appDelegate];
    self.placesCont         = [[PlacesViewController alloc] initWithNibName:@"PlacesViewController" bundle:nil];
    self.contactWListCont   = [[ContactsWatchListViewController alloc] initWithNibName:@"ContactsWatchListViewController" bundle:nil];
    [self.tableView registerNib:[UINib nibWithNibName:@"LeftSidesTableViewCell" bundle:nil] forCellReuseIdentifier:@"LeftSidesCell"];
    self.tableView.rowHeight = 75;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.allKeys = [NSArray arrayWithObjects:@"FamilyWatch",@"FamilyCare",@"Notifications",@"Device",@"Sync", nil];
    
    [self multilingual];
    
    NSInteger child_id = delegate.selectedDashboardChild.child_id;
    int convertedChild_id = (int) child_id;
    
    leftSide_package_id =  [CoreDataUtility fetchPackageIdForChild_id:(convertedChild_id)];
    leftSide_package_name = [CoreDataUtility fetchPackageNameForChild_id:(convertedChild_id)];
    leftSide_device =  [CoreDataUtility fetchPackageDeviceForChild_id:(convertedChild_id)];
}

-(void)multilingual
{
    [self.featureUpdateLbl  setText:[@"Feature Update" myModification]];
    [self.notAvailableLbl   setText:[@"This feature is not available due to Apple restriction." myModification]];
    [self.closeBtn          setTitle:[@"close" myModification] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect frame = [[UIScreen mainScreen]bounds];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 10, frame.size.width, 30)];
    [view setBackgroundColor:[UIColor whiteColor]];
    UILabel *headertitle = [[UILabel alloc] initWithFrame:view.frame];
    if(section == 0)
        [headertitle setTextColor:[CommonModel colorFromHexString:@"orange"]];
    else if(section == 1)
        [headertitle setTextColor:[CommonModel colorFromHexString:@"green"]];
    else if(section == 2)
        [headertitle setTextColor:[CommonModel colorFromHexString:@"purple"]];
    else if(section == 3)
        [headertitle setTextColor:[CommonModel colorFromHexString:@"red"]];
    else
        [headertitle setTextColor:[CommonModel colorFromHexString:@"orange"]];
    
    [headertitle setText:[self.allKeys objectAtIndex:section]];
    [headertitle setFont:[UIFont fontWithName:@"OpenSans" size:20.0]];
    headertitle.text = [headertitle.text myModification];

    [view addSubview:headertitle];
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.dataSource valueForKey:[self.allKeys objectAtIndex:section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LeftSidesTableViewCell *cell = (LeftSidesTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"LeftSidesCell"];
    
    if (cell == nil) {
        cell = (LeftSidesTableViewCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LeftSidesCell"];
    }
    
    NSString * key       = [self.allKeys objectAtIndex:indexPath.section];
    NSArray  * items     = [self.dataSource valueForKey:key];
    NSString * label     = [[items objectAtIndex:indexPath.row] valueForKey:@"label"];
    NSString * lImgName  = [[items objectAtIndex:indexPath.row] valueForKey:@"lefticon"];
    NSString * rImgName  = [[items objectAtIndex:indexPath.row] valueForKey:@"righticon"];
    
    cell.cellImage.image = [UIImage imageNamed:lImgName];
    cell.separatorInset = UIEdgeInsetsMake(0, 100, 0, 0);
//    [field setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 0.0f)];
    
    if (rImgName.length > 0 ) {
        
        [cell.cellSwitch setHidden:NO];
        [cell.arrow setHidden:YES];
        
        if(indexPath.section == 2 && [delegate.parent.type isEqualToString:@"Super"])
            [cell.cellSwitch setEnabled:true];
         else  if(indexPath.section == 2 && ![delegate.parent.type isEqualToString:@"Super"])
            [cell.cellSwitch setEnabled:false];
        [self setSwitchState:indexPath cell:cell];
        
        cell.onSwitchChange = ^(LeftSidesTableViewCell *cellAffected)
        {
            if(indexPath.section == 0 && indexPath.row == 0)//Contacts - Preferences
            {
                //DashboardChildPackageFeature *contactsPackageFeature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"contact"];
                if ([leftSide_package_id isEqualToString:@"2"] || [leftSide_package_id isEqualToString:@"3"])
                {
                    NSIndexPath *indexPath = [self.tableView indexPathForCell:cellAffected];
                    [self updatePreference:indexPath value:cellAffected.cellSwitch.isOn];
                }
                else
                {
                    [self showPremiumAlert];
                    [cellAffected.cellSwitch setOn:false];
                }
            }
            else if(indexPath.section == 0 && indexPath.row == 1)//Locations - Preferences
            {
               // DashboardChildPackageFeature *geolocationsPackageFeature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"geolocation"];
                 if ([leftSide_package_id isEqualToString:@"2"] || [leftSide_package_id isEqualToString:@"3"])
                 {
                     NSIndexPath *indexPath = [self.tableView indexPathForCell:cellAffected];
                     NSLog(@"Section %ld Row : %ld",(long)indexPath.section,(long)indexPath.row);
                     [self updatePreference:indexPath value:cellAffected.cellSwitch.isOn];
                 }
                 else
                 {
                     [self showPremiumAlert];
                     [cellAffected.cellSwitch setOn:false];
                 }
            }
            else if(indexPath.section == 0 && indexPath.row == 2)//Installed Apps - Preferences
            {
               // DashboardChildPackageFeature *installedAppsPackageFeature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"installedapp"];
                if ([leftSide_package_id isEqualToString:@"2"] || [leftSide_package_id isEqualToString:@"3"])
                {
                    NSIndexPath *indexPath = [self.tableView indexPathForCell:cellAffected];
                    NSLog(@"Section %ld Row : %ld",(long)indexPath.section,(long)indexPath.row);
                    [self updatePreference:indexPath value:cellAffected.cellSwitch.isOn];
                }
                else
                {
                    [self showPremiumAlert];
                    [cellAffected.cellSwitch setOn:false];
                }
            }
            else if(indexPath.section == 2 && indexPath.row == 0)//Places - From Notifications
            {
                //DashboardChildPackageFeature *placesPackageFeature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"place"];
                if ([leftSide_package_id isEqualToString:@"2"] || [leftSide_package_id isEqualToString:@"3"])
                {
                    NSIndexPath *indexPath = [self.tableView indexPathForCell:cellAffected];
                    NSLog(@"Section %ld Row : %ld",(long)indexPath.section,(long)indexPath.row);
                    [self updatePreference:indexPath value:cellAffected.cellSwitch.isOn];
                }
                else
                {
                    [self showPremiumAlert];
                    [cellAffected.cellSwitch setOn:false];
                }
            }
            else if(indexPath.section == 2 && indexPath.row == 1)//Speed Alerts - From Notifications
            {
               // DashboardChildPackageFeature *speedAlertsPackageFeature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"speed_limit"];
                if ([leftSide_package_id isEqualToString:@"2"] || [leftSide_package_id isEqualToString:@"3"])
                {
                    NSIndexPath *indexPath = [self.tableView indexPathForCell:cellAffected];
                    NSLog(@"Section %ld Row : %ld",(long)indexPath.section,(long)indexPath.row);
                    [self updatePreference:indexPath value:cellAffected.cellSwitch.isOn];
                }
                else
                {
                    if (speedLimitDoublePushFlag){
                    }
                    else{
                        speedLimitDoublePushFlag = true;
                        [self showPremiumAlert];
                        [cellAffected.cellSwitch setOn:false];
                    }
                }
            }
        };
        
    }
    else{
        [cell.cellSwitch setHidden:YES];
        [cell.arrow setHidden:NO];
    }
    cell.cellLabel.text = [label myModification];
    
    if(indexPath.section == 0)
    {
        cell.cellSwitch.onTintColor = [CommonModel colorFromHexString:@"orange"];
    }
    else if (indexPath.section == 2)
    {
        cell.cellSwitch.onTintColor = [CommonModel colorFromHexString:@"purple"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *key = [self.allKeys objectAtIndex:indexPath.section];
    NSArray *items = [self.dataSource valueForKey:key];
    NSString *label = [[items objectAtIndex:indexPath.row] valueForKey:@"label"];
    
    if([label isEqualToString:@"Internet Filters"] && indexPath.section == 1)
    {
       // DashboardChildPackageFeature *appBlockingPackageFeature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"appblocking"];
        if ([leftSide_package_id isEqualToString:@"2"] || [leftSide_package_id isEqualToString:@"3"])
        {
        }
        else
            [SwiftFTUtils showSwiftPremiumPopupOn:self];
    }
    
    else if([label isEqualToString:@"Places (Geo-fence)"] && indexPath.section == 1)
    {
        //DashboardChildPackageFeature *placesPackageFeature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"place"];
        if([leftSide_package_id isEqualToString:@"2"] || [leftSide_package_id isEqualToString:@"3"])
        {
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:NULL action:NULL];
            [self.navigationController pushViewController:self.placesCont animated:YES];
        }
        else
            [SwiftFTUtils showSwiftPremiumPopupOn:self];
    }
    else if([label isEqualToString:@"Schedule Screen Time"] && indexPath.section == 1)//---REMOVED FOR IOS CHILD---//---IN 221 BUILD---//---MDM---//
    {
        //DashboardChildPackageFeature *limitScreenPackageFeature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"app_control"];
        if([leftSide_package_id isEqualToString:@"2"] || [leftSide_package_id isEqualToString:@"3"])
        {
            LimitScreenViewController *controller = [[LimitScreenViewController alloc] init];
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:NULL action:NULL];
            [self.navigationController pushViewController:controller animated:YES];
        }
        else
            [SwiftFTUtils showSwiftPremiumPopupOn:self];
        
        
        //---REMOVED FOR IOS CHILD---//---IN 221 BUILD---//---MDM---//
//        [self showHidePopup:NO];
    }
    else  if([label isEqualToString:@"App Blocker"] && indexPath.section == 1)//---REMOVED FOR IOS CHILD---//---IN 221 BUILD---//---MDM---//
    {
        //DashboardChildPackageFeature *appBlockingPackageFeature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"appblocking"];
        if ([leftSide_package_id isEqualToString:@"2"] || [leftSide_package_id isEqualToString:@"3"])
        {
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:NULL action:NULL];
        }
        else
            [SwiftFTUtils showSwiftPremiumPopupOn:self];
        
        
        //---REMOVED FOR IOS CHILD---//---IN 221 BUILD---//---MDM---//
//        [self showHidePopup:NO];
        
    }
    else  if([label isEqualToString:@"Internet Filters"] && indexPath.section == 1)
    {
        [[[UIAlertView alloc] initWithTitle:@"" message:@"Feature coming soon!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }
    else  if([label isEqualToString:@"Content Filters"] && indexPath.section == 1)//---REMOVED FOR IOS CHILD---//---IN 221 BUILD---//---MDM---//
    {
       // DashboardChildPackageFeature *contentFilterPackageFeature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"content_filters"];
        if ([leftSide_package_id isEqualToString:@"2"] || [leftSide_package_id isEqualToString:@"3"])
        {
            if([delegate selectedDashboardChild].child_enrolled == 0) {
                [CommonModel showAlert:@"Child is not enrolled yet!" msg:@""];
            } else {
                ContentFiltersVC *controller = [HLStoryboard loadContentFiltersVC];
                //ContentFilterVC *controller = [[ContentFilterVC alloc] initWithStyle:UITableViewStylePlain];
                self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:NULL action:NULL];
                [self.navigationController pushViewController:controller animated:YES];
            }
        }
        else
            [SwiftFTUtils showSwiftPremiumPopupOn:self];
        
        //---REMOVED FOR IOS CHILD---//---IN 221 BUILD---//---MDM---//
//        [self showHidePopup:NO];
    }
    else  if([label isEqualToString:@"Speed Limit"] && indexPath.section == 1)
    {
       // DashboardChildPackageFeature *speedLimitPackageFeature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"speed_limit"];
        if([leftSide_package_id isEqualToString:@"2"] || [leftSide_package_id isEqualToString:@"3"])
        {
            SpeedLimitViewController *controller = [[SpeedLimitViewController alloc] initWithNibName:NSStringFromClass([SpeedLimitViewController class]) bundle:nil];
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:NULL action:NULL];
            [self.navigationController pushViewController:controller animated:YES];
        }
        else
            [SwiftFTUtils showSwiftPremiumPopupOn:self];
    }
    else  if([label isEqualToString:@"Sync Settings"])
    {
        [self synSettings];
    }
    else  if([label isEqualToString:@"Device Info"])
    {
        [SwiftFTUtils pushDeviceControllerOn:self];
    }
}

- (void) setSwitchState:(NSIndexPath *) indexPath cell:(LeftSidesTableViewCell *)cell
{
    [cell.cellSwitch setOn:false];
    if(indexPath.section == 0 && indexPath.row == 0)//Contacts - Preferences
    {
        //DashboardChildPackageFeature *contactsPackageFeature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"contact"];
        if ([leftSide_package_id isEqualToString:@"1"])
        {
            [cell.cellSwitch setOn:false];
        }
        else
        {
            DashboardChildPreference *contactsPreference = [delegate.selectedDashboardChild getPreferencesWithName:@"contact_logs"];
            [cell.cellSwitch setOn:contactsPreference.status];
        }
    }
    else if(indexPath.section == 0 && indexPath.row == 1)//Locations - Preferences
    {
        DashboardChildPackageFeature *geolocationsPackageFeature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"geolocation"];
        if ([leftSide_package_id isEqualToString:@"1"])
        {
            [cell.cellSwitch setOn:false];
        }
        else
        {
            DashboardChildPreference *geoLocationsPreference = [delegate.selectedDashboardChild getPreferencesWithName:@"location_tracking"];
            [cell.cellSwitch setOn:geoLocationsPreference.status];
        }
    }
    else if(indexPath.section == 0 && indexPath.row == 2)//Installed Apps - Preferences
    {
        //DashboardChildPackageFeature *installedAppsPackageFeature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"installedapp"];
       //if (installedAppsPackageFeature.package_id == )
        //{
            //[cell.cellSwitch setOn:false];
        //}
        //else
        //{
            DashboardChildPreference *installedAppsPreference = [delegate.selectedDashboardChild getPreferencesWithName:@"installed_app_logs"];
            [cell.cellSwitch setOn:installedAppsPreference.status];
        //}
    }
    else if(indexPath.section == 2 && indexPath.row == 0 )//Places - From Notifications
    {
        DashboardChildPackageFeature *placesPackageFeature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"place"];
        if ([leftSide_package_id isEqualToString:@"1"])
        {
            [cell.cellSwitch setOn:false];
        }
        else
        {
            DashboardChildNotification *placesNotification = [delegate.selectedDashboardChild getNotificationsWithName:@"monitor_places_alert"];
            [cell.cellSwitch setOn:placesNotification.status];
        }
    }
    
    
    else if(indexPath.section == 2 && indexPath.row == 1)//Speed Alerts - From Notifications
    {
       // DashboardChildPackageFeature *speedAlertsPackageFeature = [delegate.selectedDashboardChild package_id];
        if ([leftSide_package_id isEqualToString:@"1"])
        {
            [cell.cellSwitch setOn:false];
        }
        else
        {
            //DashboardChildNotification *speedLimitNotification = [delegate.selectedDashboardChild getNotificationsWithName:@"speed_limit_alert"];
            [cell.cellSwitch setOn:TRUE];
        }
    }
    else
    {
        [cell.cellSwitch setOn:false];
    }
}

- (void) updatePreference:(NSIndexPath *) indexPath value:(int)value
{
    NSString *name;
    BOOL includeUserId = YES;
    BOOL isNotification = NO; //---FLAG TO HIT NOTIF API FOR SETTINGS---//

    if(indexPath.section == 0 && indexPath.row == 0)
    {
        name = @"contact_logs";
        includeUserId = NO;
    }
    else if(indexPath.section == 0 && indexPath.row == 1)
    {
        name = @"location_tracking";
        includeUserId = NO;
    }
    else if(indexPath.section == 0 && indexPath.row == 2)
    {
        name = @"installed_app_logs";
        includeUserId = NO;
    }
    else if(indexPath.section == 2 && indexPath.row == 0)
    {
        name = @"monitor_places_alert";
        includeUserId = YES;
        isNotification = YES;
    }
    
    else if(indexPath.section == 2 && indexPath.row == 1)
    {
        name = @"speed_limit_alert";
        includeUserId = YES;
        isNotification = YES;
    }
    
    NSDictionary *params;
    if (includeUserId)
        params = @{//@"id":[NSNumber numberWithInteger:delegate.selectedDashboardChild.child_id],
                   @"name":name,
                   @"value":[NSString stringWithFormat:@"%i",value],
                   @"status":[NSNumber numberWithInteger:value],
                   @"user_id":delegate.parent.user_id};
    else
        params = @{//@"id":[NSNumber numberWithInteger:delegate.selectedDashboardChild.child_id],
                   @"name":name,
                   @"status":[NSNumber numberWithInteger:value],
                   @"value":[NSString stringWithFormat:@"%i",value]};
    
    [CommonModel updatePreference:params view:self isNotification:isNotification];
}

- (void)showPremiumAlert
{
    [SwiftFTUtils showSwiftPremiumPopupOn:self];
}

- (void)synSettings
{
    [SwiftFTUtils showHUDAddedTo:self.view withText:[@"Loading..." myModification] animated:YES];
    
    NSString *url = [NSString stringWithFormat:@"%@%ld", kIOS_Sync_settings_mesh2, (long)delegate.selectedDashboardChild.child_id];
    NSDictionary *params = @{@"settings" : @"all"};
    
    NSLog(@"url to sync settings = %@ and params = %@", url, params);
    
    [[ApiManager shared] postApiWithVC:self isPresentedCont:NO andParams:@{@"setting" : @"all"} withApi:url withResponse:^(NSString * _Nonnull message, NSInteger statusCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [SwiftFTUtils hideHUDAddedTo:self.view animated:YES];
            
            NSLog(@"sync settings status code = %ld and message = %@", (long)statusCode, message);
            [CommonModel showAlert:[@"Sync Settings" myModification] msg:message];
        });
    }];
}

-(void)showHidePopup:(BOOL)isHidden
{
    [UIView transitionWithView:self.popupVu
                      duration:0.9
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [self.popupVu setHidden:isHidden];
                    }
                    completion:NULL];
    
//    CATransition *animation = [CATransition animation];
//    animation.type = kCATransitionReveal;
//    animation.duration = 0.5;
//    [self.popupVu.layer addAnimation:animation forKey:nil];
//
//    self.popupVu.hidden = isHidden;
}

#pragma mark UI ACTIONS

- (IBAction)closeAction:(id)sender {
    
//    [self showHidePopup:YES];
}



@end
