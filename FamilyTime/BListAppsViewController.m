////
////  BlacklistAppsViewController.m
////  FamilyTime
////
////  Created by Sora Code on 12/29/14.
////  Copyright (c) 2014 SoraCode. All rights reserved.
////
//
//#import "BListAppsViewController.h"
//#import "MBProgressHUD.h"
//#import "JSONHTTPClient.h"
//#import "AppDelegate.h"
//#import "PlacesCell.h"
//#import "FTD.h"
//#import "FTUtils.h"
////#import <Google/Analytics.h>
//#import "Dashboard.h"
//#import "NSString+LockMustafa.h"
//
//
//AppDelegate *delegate;
//UIRefreshControl *refreshCont;
//@interface BListAppsViewController ()
//@property (nonatomic, assign) BOOL isCountBased;
//@property (nonatomic, assign) NSInteger countLimit;
//@end
//
//@implementation BListAppsViewController
//
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:YES];
//
//    DashboardChildPackageFeature *appBlockingPackageFeature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"appblocking"];
//    self.isCountBased = appBlockingPackageFeature.is_count_based;
//    self.countLimit = [appBlockingPackageFeature.count_limit integerValue];
//
//    [self loadAppList];
//}
//
//-(void) refreshView
//{
//    DashboardChildPreference *preference = [delegate.selectedDashboardChild getPreferencesWithName:@"app_blocking"];
//    if(preference.status == 0)
//    {
//        [self.tableView setUserInteractionEnabled:NO];
//        [self.appState setOn:false];
//        self.enableLabel.text = [@"Enable Blacklist" myModification];
//        self.navigationItem.rightBarButtonItem.enabled = NO;
//    }
//    else{
//        [self.tableView setUserInteractionEnabled:YES];
//        [self.appState setOn:YES];
//        self.enableLabel.text = [@"Disable Blacklist" myModification];
//        self.navigationItem.rightBarButtonItem.enabled = YES;
//    }
//    [self.tableView reloadData];
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    delegate = [AppDelegate appDelegate];
//    self.appsCont = [[InstalledAppsViewController alloc] initWithNibName:@"InstalledAppsViewController" bundle:nil];
//    [self.tableView registerNib:[UINib nibWithNibName:@"PlacesCell" bundle:nil] forCellReuseIdentifier:@"PlacesCell"];
//    if([SwiftFTUtils isDeviceiPhoneFamily])
//        self.tableView.rowHeight = 60;
//    else
//        self.tableView.rowHeight = 100;
//    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//    [self.navigationItem setTitle:[@"App Blocker" myModification]];
//        UIBarButtonItem * add = [[UIBarButtonItem alloc]initWithTitle:[@"Add" myModification] style:UIBarButtonItemStylePlain target:self action:@selector(addAppToBlackListSett)];
//    [self.navigationItem setRightBarButtonItems:@[add]];
//    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) { // if iOS 7
//        self.edgesForExtendedLayout = UIRectEdgeNone; //layout adjustements
//    }
//}
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//#pragma mark pulldown Refresh
//-(void) addPullDownRefresh{
//    refreshCont = [[UIRefreshControl alloc] init];
//    [self.tableView addSubview:refreshCont];
//    [refreshCont addTarget:self action:@selector(loadAppList) forControlEvents:UIControlEventValueChanged];
//}
//-(void) refreshTable
//{
//    [refreshCont endRefreshing];
//    [self.tableView reloadData];
//}
//-(void) addAppToBlackListSett
//{
//    if (self.isCountBased && self.dataSource.count >= self.countLimit)
//    {
////        NSString *popupTitle =[NSString stringWithFormat:@"%@\n",[@"Limit Exceeded!" myModification]];
////        NSString *firstParagraph = [NSString stringWithFormat:@"\n%@\n",NSLocalizedString(@"The Blacklist App limit is exceeded; You can add only 1 App with free subscription.", nil)];
////        NSString *firstTitle = @"";
////        NSString *firstDetails = [NSString stringWithFormat:@"\n%@",NSLocalizedString(@"Upgrade each child device to premium for a small monthly fee and get ultimate parenting satisfaction.", nil)];
////        NSString *secondTitle = @"\n";
////        NSString *secondDetails = [NSString stringWithFormat:@"\n%@",NSLocalizedString(@"Please login to your web Dashbord to upgrade the subscription and unrestricted access.", nil)];
////        [SwiftFTUtils showPremiumPopupWith:self title:popupTitle firstParagraph:firstParagraph firstTitle:firstTitle firstDetails:firstDetails secondTitle:secondTitle secondDetails:secondDetails imageName:@"ic_premium" color:@"orange"];
//
//        [SwiftFTUtils showSwiftPremiumPopupOn:self];
//        return;
//    }
//    else if (self.isCountBased && self.dataSource.count < self.countLimit)
//    {
//        self.appsCont.remainingCount = self.countLimit - self.dataSource.count;
//        self.appsCont.checkCount = YES;
//        [self.navigationController pushViewController:self.appsCont animated:YES];
//    }
//    else
//    {
//        self.appsCont.checkCount = NO;
//        [self.navigationController pushViewController:self.appsCont animated:YES];
//    }
//
//}
//
//#pragma mark Location dates from server
//- (void) loadAppList
//{
//    [SwiftFTUtils showHUDAddedTo:self.view withText:[@"Loading..." myModification] animated:YES];
//    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:delegate.selectedDashboardChild.child_id],@"child_id", nil];
//    [JSONHTTPClient postJSONFromURLWithString:@"" //KBlackListedApps
//                                       params:params
//                                   completion:^(id json, JSONModelError *err) {
//                                       NSError *error;
//                                       NSString *msg = [json valueForKey:@"message"] == nil ? [kErrorGeneral myModification] : [json valueForKey:@"message"];
//                                       // read response code
//                                       if([[json valueForKey:@"response"] intValue] == 200)
//                                       {
//                                           AllBlistAppsModel *model = [[AllBlistAppsModel alloc] initWithDictionary:json error:&error];
//                                          self.dataSource = [NSMutableArray arrayWithArray:model.data];
//                                       }
//                                       else
//                                       [CommonModel showAlert:[@"Error!" myModification] msg:msg];
//                                       dispatch_async(dispatch_get_main_queue(), ^{
//                                           //any UI refresh
//                                           [self refreshTable];
//                                           [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                                       });
//                                   }];
//}
//
//#pragma mark - Table view data source
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return self.dataSource.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    PlacesCell *cell = (PlacesCell *)[tableView dequeueReusableCellWithIdentifier:@"PlacesCell"];
//
//    if (cell == nil)
//    {
//        cell = (PlacesCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PlacesCell"];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    }
//
//    BlistAppModel *model = [self.dataSource objectAtIndex:indexPath.row];
//    cell.place.text =  model.app_name;
//    float fileSize = (model.size /1024) /1000;
//    if(fileSize == 0.0)
//        cell.address.text = [NSString stringWithFormat:@"%.2f KB",(fileSize / 1024) / 100];
//    else
//        cell.address.text = [NSString stringWithFormat:@"%.f MB",fileSize];
//    cell.editPlace.tag = indexPath.row;
//
//    if(self.tableView.userInteractionEnabled)
//    {
//        NSString *imgName =[NSString stringWithFormat:@"iapp_%i.png",(int)indexPath.row%4 + 1 ];
//        [cell.placeImg setImage:[UIImage imageNamed:imgName]];
//        [cell.editPlace setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
//        [cell.editPlace addTarget:self action:@selector(deleteApp:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    else
//    {
//        NSString *imgName =[NSString stringWithFormat:@"iapp_%i_0.png",(int)indexPath.row%4 + 1 ];
//        [cell.placeImg setImage:[UIImage imageNamed:imgName]];
//        [cell.editPlace setImage:[UIImage imageNamed:@"delete_0"] forState:UIControlStateNormal];
//    }
//    return cell;
//}
//
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//}
//-(void)deleteApp:(UIButton *)sender
//{
//    BlistAppModel *model = [self.dataSource objectAtIndex:sender.tag];
//    [SwiftFTUtils showHUDAddedTo:self.view withText:[@"Deleting..." myModification] animated:YES];
//    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:delegate.selectedDashboardChild.child_id],@"child_id",model.installedapp_id,@"id", nil];
//    [JSONHTTPClient postJSONFromURLWithString:@"" //KRemoveBlackListedApp
//                                       params:params
//                                   completion:^(id json, JSONModelError *err) {
//                                       if([[json valueForKey:@"response"] intValue] == 200){
//                                           [self.dataSource removeObject:model];
//                                           [self.tableView reloadData];
//                                       }
//                                       else
//                                           [CommonModel showAlert:[@"Error!" myModification] msg:[json valueForKey:@"message"]];
//
//                                       [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                                   }];
//}
//
//- (IBAction)updateBLAppState:(UISwitch *)sender
//{
//    self.navigationItem.rightBarButtonItem.enabled = sender.isOn;
//    NSDictionary *params = @{@"name":@"app_blocking",
//                             @"status":[NSNumber numberWithInteger:sender.isOn],
//                             @"value":[NSString stringWithFormat:@"%i",sender.isOn]};
//
//    [CommonModel updatePreference:params view:self isNotification:NO];
//}
//@end
