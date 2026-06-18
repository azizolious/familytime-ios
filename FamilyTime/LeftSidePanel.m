//
//  LeftSidePanel.m
//  FamilyTime
//
//  Created by Sora Code on 11/19/14.
//  Copyright (c) 2014 SoraCode. All rights reserved.
//

#import "LeftSidePanel.h"
#import "LeftSidesTableViewCell.h"
#import "AppDelegate.h"
//#import "JSONHTTPClient.h"
#import "MBProgressHUD.h"
#import "CustomIOS7AlertView.h"
#import "FTD.h"
//#import <Google/Analytics.h>
#import "FTUtils.h"
#import "Dashboard.h"
#import "NSString+LockMustafa.h"
#import "FamilyTime-Swift.h"

@class CoreDataUtility;

NSString *left_package_id = @"";
NSString *left_package_name = @"";
NSString *left_device = @"";

AppDelegate *delegate;
@interface LeftSidePanel (){
//    BOOL speedLimitDoublePushFlag; //---PUSH PREMIUM SCREEN 2 TIMES, TO AVOID THIS---//
//    BOOL textMsgsDoublePushFlag; //---PUSH PREMIUM SCREEN 2 TIMES, TO AVOID THIS---//
    
    BOOL doublePushFlag; //---PUSH PREMIUM SCREEN 2 TIMES, TO AVOID THIS---//
}

@end

@implementation LeftSidePanel
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
//    [ZendeskChatManager trackEvent:@"Settings android device"];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"settings" ofType:@"plist"];
    self.dataSource = [NSDictionary dictionaryWithContentsOfFile:filePath];
    [self.tableView reloadData];
//    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    [self.tableView reloadData];
    
//    speedLimitDoublePushFlag = false;
//    textMsgsDoublePushFlag   = false;
    
    doublePushFlag = false;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setTitle:[@"Settings" myModification]];
    delegate = [AppDelegate appDelegate];
    
    NSLog(@"child = %@ and features = %@", delegate.selectedDashboardChild, delegate.selectedDashboardChild.package_features);
    
    self.placesCont         = [[PlacesViewController alloc] initWithNibName:@"PlacesViewController" bundle:nil];
//    self.changPswCont       = [[ChangePassViewController1 alloc] initWithNibName:@"ChangePassViewController" bundle:nil];
//    self.blackListCont      = [[BListAppsViewController alloc] initWithNibName:@"BListAppsViewController" bundle:nil];
    self.contactWListCont   = [[ContactsWatchListViewController alloc] initWithNibName:@"ContactsWatchListViewController" bundle:nil];
    [self.tableView registerNib:[UINib nibWithNibName:@"LeftSidesTableViewCell" bundle:nil] forCellReuseIdentifier:@"LeftSidesCell"];
    self.tableView.rowHeight = 75;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.allKeys = [NSArray arrayWithObjects:@"FamilyWatch",@"FamilyCare",@"Notifications",@"Device",@"Sync", nil];
    
    NSInteger child_id = delegate.selectedDashboardChild.child_id;
    int convertedChild_id = (int) child_id;
    
    left_package_id =  [CoreDataUtility fetchPackageIdForChild_id:(convertedChild_id)];
    left_package_name = [CoreDataUtility fetchPackageNameForChild_id:(convertedChild_id)];
    left_device =  [CoreDataUtility fetchPackageDeviceForChild_id:(convertedChild_id)];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
 
    headertitle.text=[headertitle.text myModification];
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
    NSString *key       = [self.allKeys objectAtIndex:indexPath.section];
    NSArray  *items     = [self.dataSource valueForKey:key];
    NSString *label     = [[items objectAtIndex:indexPath.row] valueForKey:@"label"];
    NSString * lImgName = [[items objectAtIndex:indexPath.row] valueForKey:@"lefticon"];
    NSString * rImgName = [[items objectAtIndex:indexPath.row] valueForKey:@"righticon"];
    
    cell.cellImage.image = [UIImage imageNamed:lImgName];
    
    if (rImgName.length >0) {
        
        [cell.cellSwitch setHidden:NO];
        [cell.arrow setHidden:YES];
        if(indexPath.section == 2 && [delegate.parent.type isEqualToString:@"Super"])
            [cell.cellSwitch setEnabled:true];
        else  if(indexPath.section == 2 && ![delegate.parent.type isEqualToString:@"Super"])//---TION---//
            [cell.cellSwitch setEnabled:false];
        
        
        [self setSwitchState:indexPath cell:cell];
        cell.onSwitchChange = ^(LeftSidesTableViewCell *cellAffected)
        {
            if(indexPath.section == 0 && indexPath.row == 0)//Calls
            {
                //DashboardChildPackageFeature *callsPackageFeature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"call"];
                
//                if (callsPackageFeature.package_id == 1 || callsPackageFeature.package_id == 2 || callsPackageFeature.package_id == 5)
//                {
                    NSIndexPath *indexPath = [self.tableView indexPathForCell:cellAffected];
                    NSLog(@"Section %ld Row : %ld",(long)indexPath.section,(long)indexPath.row);
                    [self updatePreference:indexPath value:cellAffected.cellSwitch.isOn];
               // }
                //else
//                {
//                    if (!doublePushFlag){
//                        doublePushFlag = true;
//                        [self showPremiumAlert];
//                        [cellAffected.cellSwitch setOn:false];
//                    }
//
//                }
            }
            if(indexPath.section == 0 && indexPath.row == 1)//SMS
            {
               // DashboardChildPackageFeature *smsPackageFeature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"sms"];
                if ([left_package_id isEqualToString:@"3"])
                {
                    NSIndexPath *indexPath = [self.tableView indexPathForCell:cellAffected];
                    NSLog(@"Section %ld Row : %ld",(long)indexPath.section,(long)indexPath.row);
                    [self updatePreference:indexPath value:cellAffected.cellSwitch.isOn];
                }
                else
                {
                    if (!doublePushFlag){
                        doublePushFlag = true;
                        [self showPremiumAlert];
                        [cellAffected.cellSwitch setOn:false];
                    }
                    
                }
            }
            else if(indexPath.section == 0 && indexPath.row == 2)//Contacts
             {
                 //DashboardChildPackageFeature *contactsPackageFeature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"contact"];
                 if ([left_package_id isEqualToString:@"2"]|| [left_package_id isEqualToString:@"3"])
                 {
                     NSIndexPath *indexPath = [self.tableView indexPathForCell:cellAffected];
                     NSLog(@"Section %ld Row : %ld",(long)indexPath.section,(long)indexPath.row);
                     [self updatePreference:indexPath value:cellAffected.cellSwitch.isOn];
                 }
                 else
                 {
                     if (!doublePushFlag){
                         doublePushFlag = true;
                         [self showPremiumAlert];
                         [cellAffected.cellSwitch setOn:false];
                     }
                     
                 }
             }
            else if(indexPath.section == 0 && indexPath.row == 3)//Locations
            {
               // DashboardChildPackageFeature *geolocationsPackageFeature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"geolocation"];
                if ([left_package_id isEqualToString:@"2"] || [left_package_id isEqualToString:@"3"])
                {
                    NSIndexPath *indexPath = [self.tableView indexPathForCell:cellAffected];
                    NSLog(@"Section %ld Row : %ld",(long)indexPath.section,(long)indexPath.row);
                    [self updatePreference:indexPath value:cellAffected.cellSwitch.isOn];
                }
                else
                {
                    if(!doublePushFlag){
                        doublePushFlag = true;
                        [self showPremiumAlert];
                        [cellAffected.cellSwitch setOn:false];
                    }
                    
                }
            }
            else if(indexPath.section == 0 && indexPath.row == 4)//Apps
            {
               // DashboardChildPackageFeature *installedAppsPackageFeature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"installedapp"];
//                if (installedAppsPackageFeature.package_id == 1 || installedAppsPackageFeature.package_id == 2 || installedAppsPackageFeature.package_id == 5)
//                {
                    NSIndexPath *indexPath = [self.tableView indexPathForCell:cellAffected];
                    NSLog(@"Section %ld Row : %ld",(long)indexPath.section,(long)indexPath.row);
                    [self updatePreference:indexPath value:cellAffected.cellSwitch.isOn];
                //}
//                else
//                {
//                    if (!doublePushFlag){
//                        doublePushFlag = true;
//                        [self showPremiumAlert];
//                        [cellAffected.cellSwitch setOn:false];
//                    }
//
//                }
            }
            else if(indexPath.section == 2 && indexPath.row == 0)//Place Alerts
            {
                //DashboardChildPackageFeature *placesPackageFeature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"place"];
                if ([left_package_id isEqualToString:@"2"] || [left_package_id isEqualToString:@"3"])
                {
                    NSIndexPath *indexPath = [self.tableView indexPathForCell:cellAffected];
                    NSLog(@"Section %ld Row : %ld",(long)indexPath.section,(long)indexPath.row);
                    [self updatePreference:indexPath value:cellAffected.cellSwitch.isOn];
                }
                else
                {
                    if (!doublePushFlag){
                        doublePushFlag = true;
                        [self showPremiumAlert];
                        [cellAffected.cellSwitch setOn:false];
                    }
                }
            }
            else if(indexPath.section == 2 && indexPath.row == 1)//App Blocker Alerts
            {
               // DashboardChildPackageFeature *appBlockerPackageFeature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"appblocking"];
                if ([left_package_id isEqualToString:@"3"]|| [left_package_id isEqualToString:@"3"])
                {
                    NSIndexPath *indexPath = [self.tableView indexPathForCell:cellAffected];
                    NSLog(@"Section %ld Row : %ld",(long)indexPath.section,(long)indexPath.row);
                    [self updatePreference:indexPath value:cellAffected.cellSwitch.isOn];
                }
                else
                {
                    if(!doublePushFlag){
                        doublePushFlag = true;
                        [self showPremiumAlert];
                        [cellAffected.cellSwitch setOn:false];
                    }
                    
//                    [self showPremiumAlert];
//                    [cellAffected.cellSwitch setOn:false];
                }
            }
            else if(indexPath.section == 2 && indexPath.row == 2)//contacts watchlist
            {
                //DashboardChildPackageFeature *contactsWatchlistPackageFeature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"contactwatchlist"];
                if ([left_package_id isEqualToString:@"2"] || [left_package_id isEqualToString:@"3"])
                {
                    NSIndexPath *indexPath = [self.tableView indexPathForCell:cellAffected];
                    NSLog(@"Section %ld Row : %ld",(long)indexPath.section,(long)indexPath.row);
                    [self updatePreference:indexPath value:cellAffected.cellSwitch.isOn];
                }
                else
                {
                    if(!doublePushFlag){
                        doublePushFlag = true;
                        [self showPremiumAlert];
                        [cellAffected.cellSwitch setOn:false];
                    }
                }
            }
            
            else if(indexPath.section == 3 && indexPath.row == 2)//HIDE NOTIFICATION BAR
            {
                if ([left_package_id isEqualToString:@"2"] || [left_package_id isEqualToString:@"3"])
                {
                NSLog(@"hide notification area toggle");
                NSIndexPath *indexPath = [self.tableView indexPathForCell:cellAffected];
                NSLog(@"Section %ld Row : %ld",(long)indexPath.section,(long)indexPath.row);
                [self updatePreference:indexPath value:cellAffected.cellSwitch.isOn];
                
                NSLog(@"hide notification area toggle");
                }else{
                    
                    if(!doublePushFlag){
                        doublePushFlag = true;
                        [self showPremiumAlert];
                        [cellAffected.cellSwitch setOn:false];
                    }
                }
            }
        };
    }
    else
    {
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
    else if (indexPath.section == 3)
    {
        cell.cellSwitch.onTintColor = [CommonModel colorFromHexString:@"red"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *key   = [self.allKeys objectAtIndex:indexPath.section];
    NSArray *items  = [self.dataSource valueForKey:key];
    NSString *label = [[items objectAtIndex:indexPath.row] valueForKey:@"label"];
    
    //---lefticon = "ic_internet_filter"---label = "Internet Filters"---//---//---ADDED AGAIN---//---//---ADD THESE TO SETTINGS.PLIST IF WANT TO SHOW AGAIN---//
    
    if([label isEqualToString:@"Internet Filters"] && indexPath.section == 1)
    {
       // DashboardChildPackageFeature *appBlockingPackageFeature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"appblocking"];
        if ([left_package_id isEqualToString:@"2"] || [left_package_id isEqualToString:@"3"])
        {
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:NULL action:NULL];
            UIStoryboard *stb = [UIStoryboard storyboardWithName:@"Dashboard" bundle:nil];
            InternetFilterVC *vc = [stb instantiateViewControllerWithIdentifier:@"InternetFilterVC"];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
            [SwiftFTUtils showSwiftPremiumPopupOn:self];
 
//        DashboardChildPackageFeature *placesPackageFeature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"place"];
//        if(placesPackageFeature.package_id == 1)
//        {
//            [self Yoooo];
////            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:NULL action:NULL];
////            [self.navigationController pushViewController:self.placesCont animated:YES];
//        }
//        else
//            [SwiftFTUtils showPremiumPopupDefaultWith:self color:@"orange"];
    }
    
    
    else if([label isEqualToString:@"Internet Schedules"] && indexPath.section == 1)
    {
        //DashboardChildPackageFeature *limitScreenPackageFeature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"internet_schedule"];
        if ([left_package_id isEqualToString:@"2"] || [left_package_id isEqualToString:@"3"])
        {
            UIStoryboard *stb = [UIStoryboard storyboardWithName:@"Dashboard" bundle:nil];
            InternetScheduleVC *vc = [stb instantiateViewControllerWithIdentifier:@"InternetScheduleVC"];
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:NULL action:NULL];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
            [SwiftFTUtils showSwiftPremiumPopupOn:self];
    }
    else if([label isEqualToString:@"Places (Geo-fence)"] && indexPath.section == 1)
    {
        //DashboardChildPackageFeature *placesPackageFeature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"place"];
        if([left_package_id isEqualToString:@"2"] || [left_package_id isEqualToString:@"3"])
        {
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:NULL action:NULL];
            [self.navigationController pushViewController:self.placesCont animated:YES];
        }
        else
            [SwiftFTUtils showSwiftPremiumPopupOn:self];
//            [SwiftFTUtils showPremiumPopupDefaultWith:self color:@"orange"];
    }
    else  if([label isEqualToString:@"App Blocker"] && indexPath.section == 1)
    {
        //DashboardChildPackageFeature *appBlockingPackageFeature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"appblocking"];
     //   NSLog(@"dict after parsing = %@ and error = %@", jsonDict, parsingError);
        if ([left_package_id isEqualToString:@"2"] || [left_package_id isEqualToString:@"3"])
        {
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:NULL action:NULL];
            UIStoryboard *stb = [UIStoryboard storyboardWithName:@"Dashboard" bundle:nil];
            AppBlockerAndroidVC *vc = [stb instantiateViewControllerWithIdentifier:@"AppBlockerAndroidVC"];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        else
            [SwiftFTUtils showSwiftPremiumPopupOn:self];
//            [SwiftFTUtils showPremiumPopupDefaultWith:self color:@"orange"];
    }
    else if([label isEqualToString:@"FunTime"] && indexPath.section == 1)
    {
        //DashboardChildPackageFeature *limitScreenPackageFeature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"access_control"];
        if ([left_package_id isEqualToString:@"2"] || [left_package_id isEqualToString:@"3"])
        {   
            NSString * storyboardName = @"MyStoryboard";
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: [NSBundle mainBundle]];
            
            ClockViewController *vc  = [storyboard instantiateViewControllerWithIdentifier:@"ClockViewController"];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
            [SwiftFTUtils showSwiftPremiumPopupOn:self];
    }
    else  if([label isEqualToString:@"Schedule Screen Time"] && indexPath.section == 1)
    {
       // DashboardChildPackageFeature *limitScreenPackageFeature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"access_control"];
        if ([left_package_id isEqualToString:@"2"] || [left_package_id isEqualToString:@"3"])
        {
            UIStoryboard *stb = [UIStoryboard storyboardWithName:@"Dashboard" bundle:nil];
            ScheduleScreenTimeVC *vc = [stb instantiateViewControllerWithIdentifier:@"ScheduleScreenTimeVC"];
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:NULL action:NULL];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
            [SwiftFTUtils showSwiftPremiumPopupOn:self];
    }
    else  if([label isEqualToString:@"Daily App Limit"] && indexPath.section == 1)
    {
        DashboardChildPackageFeature *packageFeature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"daily_limit"];
        
        if (packageFeature == nil){
            
            AndroidDailyLimitVC *vc = [[AndroidDailyLimitVC alloc] init];
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:NULL action:NULL];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        
        else if (packageFeature.package_id == 1)
        {
                [self showPremiumAlert];
        }
            else
            {
                //---NEW SWIFT CONVERTED CLASS---//
                AndroidDailyLimitVC *vc = [[AndroidDailyLimitVC alloc] init];
                self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:NULL action:NULL];
                [self.navigationController pushViewController:vc animated:YES];
            }
        
    }
    else  if([label isEqualToString:@"Sync Settings"])
    {
        [self synSettings];
    }
    else  if([label isEqualToString:@"Contact Watchlist"] && indexPath.section == 1)
    {
       // DashboardChildPackageFeature *contacstWatchlistPackageFeature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"contactwatchlist"];
        if ([left_package_id isEqualToString:@"2"] || [left_package_id isEqualToString:@"3"])
        {
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:NULL action:NULL];
            [self.navigationController pushViewController:self.contactWListCont animated:YES];
        }
        else
            [SwiftFTUtils showSwiftPremiumPopupOn:self];
    }
    else  if([label isEqualToString:@"Device Passcode"] && indexPath.section == 3)
    {
        //DashboardChildPackageFeature *phonelockPackageFeature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"phonelock"];
        if ([left_package_id isEqualToString:@"1"])
        {
            [self showPremiumAlert];
        }
        else
        {
            [CommonModel lockPhonePopup:self];
        }
    }
    else  if([label isEqualToString:@"Device"])
    {
        [SwiftFTUtils pushDeviceControllerOn:self];
    }
}

- (void) setSwitchState:(NSIndexPath *) indexPath cell:(LeftSidesTableViewCell *)cell
{
    [cell.cellSwitch setOn:false];
    if(indexPath.section == 0 && indexPath.row == 0)//Calls
    {
        //DashboardChildPackageFeature *callsPackageFeature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"call"];
        if ([left_package_id isEqualToString:@"2"] || [left_package_id isEqualToString:@"3"] || [left_package_id isEqualToString:@"1"])
        {
            DashboardChildPreference *callsPreference = [delegate.selectedDashboardChild getPreferencesWithName:@"call_logs"];
            [cell.cellSwitch setOn:callsPreference.status];
            
        }
        else
        {
            [cell.cellSwitch setOn:false];
        }
    }
    else if(indexPath.section == 0 && indexPath.row == 1)//SMS
    {
        //DashboardChildPackageFeature *smsPackageFeature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"sms"];
        if ([left_package_id isEqualToString:@"1"] || [left_package_id isEqualToString:@"2"])
        {
            [cell.cellSwitch setOn:false];
        }
        else
        {
            DashboardChildPreference *smsPreference = [delegate.selectedDashboardChild getPreferencesWithName:@"sms_logs"];
            [cell.cellSwitch setOn:smsPreference.status];
        }
    }
    else if(indexPath.section == 0 && indexPath.row == 2)//contacts
    {
        //DashboardChildPackageFeature *contactsPackageFeature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"contact"];
        if ([left_package_id isEqualToString:@"2"] || [left_package_id isEqualToString:@"3"])
        {
            DashboardChildPreference *contactsPreference = [delegate.selectedDashboardChild getPreferencesWithName:@"contact_logs"];
            [cell.cellSwitch setOn:contactsPreference.status];
            
        }
        else
        {
            [cell.cellSwitch setOn:false];
        }
    }
    else if(indexPath.section == 0 && indexPath.row == 3)//locations
    {
        //DashboardChildPackageFeature *geolocationsPackageFeature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"geolocation"];
        if ([left_package_id isEqualToString:@"1"])
        {
            [cell.cellSwitch setOn:false];
        }
        else
        {
            DashboardChildPreference *locationssPreference = [delegate.selectedDashboardChild getPreferencesWithName:@"location_tracking"];
            [cell.cellSwitch setOn:locationssPreference.status];
        }
    }
    
    //----------------------------------------------------------------------------------------------------//
    
    //---BOOKMARKS AND INTERNET REMOVED IN SPRINT 4 ACCORDING TO ANDROID SETTINGS---//
    
    //----------------------------------------------------------------------------------------------------//
    
    /*
    else if(indexPath.section == 0 && indexPath.row == 4)//bookmarks
    {
        DashboardChildPackageFeature *bookmarksPackageFeature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"bookmark"];
        if (bookmarksPackageFeature.package_id == 0)
        {
            [cell.cellSwitch setOn:false];
        }
        else
        {
            DashboardChildPreference *bookmarksPreference = [delegate.selectedDashboardChild getPreferencesWithName:@"bookmark_history"];
            [cell.cellSwitch setOn:bookmarksPreference.status];
        }
    }
    else if(indexPath.section == 0 && indexPath.row == 5)//internet
    {
        DashboardChildPackageFeature *internetPackageFeature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"browsinghistory"];
        if (internetPackageFeature.package_id == 0)
        {
            [cell.cellSwitch setOn:false];
        }
        else
        {
            DashboardChildPreference *internetPreference = [delegate.selectedDashboardChild getPreferencesWithName:@"browsing_history"];
            [cell.cellSwitch setOn:internetPreference.status];
        }
    }
     */
    else if(indexPath.section == 0 && indexPath.row == 4)//Apps
    {
//        DashboardChildPackageFeature *installedAppsPackageFeature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"installedapp"];
//        if (installedAppsPackageFeature.package_id == 5 || installedAppsPackageFeature.package_id == 2 || installedAppsPackageFeature.package_id == 1)
        //{
            DashboardChildPreference *appsPreference = [delegate.selectedDashboardChild getPreferencesWithName:@"installed_app_logs"];
            [cell.cellSwitch setOn:TRUE];
            
        //}
       // else
       // {
           // [cell.cellSwitch setOn:false];
       // }
    }
    else if(indexPath.section == 2 && indexPath.row == 0 )//places alerts
    {
        //DashboardChildPackageFeature *placesPackageFeature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"place"];
        if ([left_package_id isEqualToString:@"1"])
        {
            [cell.cellSwitch setOn:false];
        }
        else
        {
            DashboardChildNotification *placesNotification = [delegate.selectedDashboardChild getNotificationsWithName:@"monitor_places_alert"];
            [cell.cellSwitch setOn:placesNotification.status];
        }
        
    }
    else if(indexPath.section == 2 && indexPath.row == 1)//app blocker alerts
    {
        //DashboardChildPackageFeature *appBlockerPackageFeature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"appblocking"];
        if ([left_package_id isEqualToString:@"1"])
        {
            [cell.cellSwitch setOn:false];
        }
        else
        {
            DashboardChildNotification *appblockingNotification = [delegate.selectedDashboardChild getNotificationsWithName:@"app_blocking"];
            [cell.cellSwitch setOn:appblockingNotification.status];
        }
    }
//    else if(indexPath.section == 2 && indexPath.row == 2)//pickme up alerts
//    {
//        DashboardChildPackageFeature *pickmeupPackageFeature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"pick_me_up"];
//        if (pickmeupPackageFeature.package_id == 0)
//        {
//            [cell.cellSwitch setOn:false];
//        }
//        else
//        {
//            DashboardChildNotification *pickmeupNotification = [delegate.selectedDashboardChild getNotificationsWithName:@"pickup_alert"];
//            [cell.cellSwitch setOn:pickmeupNotification.status];
//        }
//    }
    else if(indexPath.section == 2 && indexPath.row == 2)//contacts watchlist alerts
    {
        //DashboardChildPackageFeature *contactsWatchlistPackageFeature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"contactwatchlist"];
        if ([left_package_id isEqualToString:@"1"])
        {
            [cell.cellSwitch setOn:false];
        }
        else
        {
            DashboardChildNotification *conatcsWatchlistNotification = [delegate.selectedDashboardChild getNotificationsWithName:@"contact_watchlist_alert"];
            [cell.cellSwitch setOn:conatcsWatchlistNotification.status];
        }
    }else if(indexPath.section == 3 && indexPath.row == 2)//---HIDE NOTIFICATION AREA---TOP_STACK---//
    {
       // DashboardChildPackageFeature *topStack = [delegate.selectedDashboardChild getPackageFeatureWithName:@"top_stack"];
        if ([left_package_id isEqualToString:@"1"])
        {
            [cell.cellSwitch setOn:false];
        }
        else
        {
            DashboardChildPreference *topStack = [delegate.selectedDashboardChild getPreferencesWithName:@"top_stack"];
            [cell.cellSwitch setOn:topStack.status];
        }
    }
    
    //---NEW TOGGLE ADDED UNDER DEVICE ONLY FOR ANDROID---//
    
    
    /* //---REMOVED IN SPRINT 4 TO MAKE ACCORDING TO ANDROID---//
    else if(indexPath.section == 2 && indexPath.row == 3)//sos alerts
    {
        DashboardChildPackageFeature *sosPackageFeature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"sos"];
        if (sosPackageFeature.package_id == 0)
        {
            [cell.cellSwitch setOn:false];
        }
        else
        {
            DashboardChildNotification *sosNotification = [delegate.selectedDashboardChild getNotificationsWithName:@"sos_alert"];
            [cell.cellSwitch setOn:sosNotification.status];
        }
    }
     */
    
    else
    {
        [cell.cellSwitch setOn:false];
    }
    
}
-(void) updatePreference:(NSIndexPath *) indexPath value:(int)value
{
    NSString *name;
    BOOL includeUserId = YES;
    BOOL isNotification = NO; //---FLAG TO HIT NOTIF API FOR SETTINGS---//

    if(indexPath.section == 0 && indexPath.row == 0)
    {
        name = @"call_logs";
        includeUserId = NO;
    }
    else if(indexPath.section == 0 && indexPath.row == 1)
    {
        name = @"sms_logs";
        includeUserId = NO;
    }
    else if(indexPath.section == 0 && indexPath.row == 2)
    {
        name = @"contact_logs";
        includeUserId = NO;
    }
    else if(indexPath.section == 0 && indexPath.row == 3)
    {
        name = @"location_tracking";
        includeUserId = NO;
    }
    //---REMOVED IN SPRINT 4---//
    
//    else if(indexPath.section == 0 && indexPath.row == 4)
//    {
//        name = @"bookmark_history";
//        includeUserId = NO;
//    }
//    else if(indexPath.section == 0 && indexPath.row == 5)
//    {
//        name = @"browsing_history";
//        includeUserId = NO;
//    }
    else if(indexPath.section == 0 && indexPath.row == 4)
    {
        name = @"installed_app_logs";
        includeUserId = NO;
    }
    else if(indexPath.section == 2 && indexPath.row == 0)
    {
        name = @"monitor_places_alert";
        includeUserId  = YES;
        isNotification = YES;
    }
    else if(indexPath.section == 2 && indexPath.row == 1)
    {
        name = @"app_blocking";
        includeUserId  = YES;
        isNotification = YES;
    }
//    else if(indexPath.section == 2 && indexPath.row == 2)
//    {
//        name = @"pickup_alert";
//        includeUserId = YES;
//        isNotification = YES;
//    }
    else if(indexPath.section == 2 && indexPath.row == 2)
    {
        name = @"contact_watchlist_alert";
        includeUserId  = YES;
        isNotification = YES;
    }
    
    //---NEW TOGGLE FOR ANDROID ADDED UNDER DEVICE---//
    else if(indexPath.section == 3 && indexPath.row == 2)
    {
        name = @"top_stack";
        includeUserId  = NO;
        isNotification = NO;
    }
    //---REMOVED IN SPRINT 4---//
    
//    else if(indexPath.section == 2 && indexPath.row == 3)
//    {
//        name = @"sos_alert";
//        includeUserId = YES;
//    }
    
    NSDictionary *params;
    if (includeUserId)
        params = @{//@"id":[NSNumber numberWithInteger:delegate.selectedDashboardChild.child_id],
                   @"name":name,
                   @"status":[NSNumber numberWithInteger:value],
                   @"value":[NSString stringWithFormat:@"%i",value],
                   @"user_id":delegate.parent.user_id};
    else
        params = @{//@"id":[NSNumber numberWithInteger:delegate.selectedDashboardChild.child_id],
                   @"name":name,
                   @"status":[NSNumber numberWithInteger:value],
                   @"value":[NSString stringWithFormat:@"%i",value]};
    
    NSLog(@"params = %@", params);
    [CommonModel updatePreference:params view:self isNotification:isNotification];
}

- (void)showPremiumAlert
{
    [SwiftFTUtils showSwiftPremiumPopupOn:self];
}


- (void)synSettings
{
    [SwiftFTUtils showHUDAddedTo:self.view withText:[@"Loading..." myModification] animated:YES];
    
    
    NSString *url = [NSString stringWithFormat:@"%@%ld", kAndroid_Sync_settings_mesh2, (long)delegate.selectedDashboardChild.child_id];
    NSDictionary *params = @{@"setting" : @"all"};
    
    NSLog(@"url to sync settings = %@ and params = %@", url, params);
    
    [[ApiManager shared] postApiWithVC:self isPresentedCont:NO andParams:@{@"setting" : @"all"} withApi:url withResponse:^(NSString * _Nonnull message, NSInteger statusCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [SwiftFTUtils hideHUDAddedTo:self.view animated:YES];
            
            NSLog(@"sync settings status code = %ld and message = %@", (long)statusCode, message);
            [CommonModel showAlert:[@"Sync Settings" myModification] msg:message];
        });
    }];
}


@end
