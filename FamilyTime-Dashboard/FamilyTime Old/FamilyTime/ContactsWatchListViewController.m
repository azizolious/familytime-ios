//
//  ContactsWatchListViewController.m
//  FamilyTime
//
//  Created by Sora Code on 12/30/14.
//  Copyright (c) 2014 SoraCode. All rights reserved.
//

#import "ContactsWatchListViewController.h"
#import "MBProgressHUD.h"
//#import "JSONHTTPClient.h"
#import "AppDelegate.h"
#import "ContactsCell.h"
#import "NEIServiceManager.h"
#import "FTD.h"
//#import <Google/Analytics.h>
#import "FTUtils.h"
#import "Dashboard.h"
#import "NSString+LockMustafa.h"
#import "ContactWatchedListTableViewCell.h"
#import "FamilyTime-Swift.h"

AppDelegate *delegate;
UIRefreshControl *refreshCont;
@interface ContactsWatchListViewController ()
@property (nonatomic, assign) BOOL isCountBased;
@property (nonatomic, assign) NSInteger countLimit;
@property (nonatomic, assign) NSInteger watchedCount;
@end

@implementation ContactsWatchListViewController
- (void) refreshView
{
    DashboardChildPreference *contactsWatchlistPreference = [delegate.selectedDashboardChild getPreferencesWithName:@"contact_watchlist"];
    if(contactsWatchlistPreference.status == 0)
    {
        [self.tableView setUserInteractionEnabled:NO];
        [self.contPrefer setOn:false];
        self.enableLabel.text = NSLocalizedString(@"Enable Watchlist",nil);
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    else
    {
        [self.tableView setUserInteractionEnabled:YES];
        [self.contPrefer setOn:YES];
        self.enableLabel.text = NSLocalizedString(@"Disable Watchlist",nil);
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    //[self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [ZendeskChatManager trackEvent:@"Enable/Disable Watchlist"];
    
    
    DashboardChildPackageFeature *contactsWatchlistPackageFeature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"contactwatchlist"];
    self.isCountBased = contactsWatchlistPackageFeature.is_count_based;
    self.countLimit = [contactsWatchlistPackageFeature.count_limit integerValue];
    //    NSLog(@"self.isCountBased=%i",self.isCountBased);
    //    NSLog(@"self.countLimit=%li",(long)self.countLimit);
    
    [self refreshView];
    [self loadContactWatchList];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //IDsAllArray
    _IDsAllArray=[NSMutableArray new];
    
    _StatusAllArray=[NSMutableArray new];
    delegate = [AppDelegate appDelegate];
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        [self.tableView registerNib:[UINib nibWithNibName:@"ContactWatchedListTableViewCell" bundle:nil] forCellReuseIdentifier:@"contactCell22"];
    }
    else
    {
        [self.tableView registerNib:[UINib nibWithNibName:@"ContactWatchedListTableViewCell" bundle:nil] forCellReuseIdentifier:@"contactCell22"];
    }
    
    self.tableView.rowHeight = 90;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    [self.navigationItem setTitle:NSLocalizedString(@"Contact Watchlist",nil)];
    UIBarButtonItem * add = [[UIBarButtonItem alloc]initWithTitle:[@"Save" myModification] style:UIBarButtonItemStylePlain target:self action:@selector(addAppToBlackList)];
    [self.navigationItem setRightBarButtonItems:@[add]];
    
   // [self addPullDownRefresh];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) { // if iOS 7
        self.edgesForExtendedLayout = UIRectEdgeNone; //layout adjustements
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark pulldown Refresh


//-(void) refreshTable
//{
//    [refreshCont endRefreshing];
//    [self.tableView reloadData];
//}

-(void) addAppToBlackList
{
    
    //    [self saveButton:nil];
    
    
    //    if (self.isCountBased && self.watchedCount >= self.countLimit)
    //    {
    
    
    if(self.isCountBased==0)
    {
        [self saveButton:nil];
        
    }
    else if (_IDsAllArray.count > self.countLimit)
    {
        //_IDsAllArray
        //        NSString *popupTitle = [NSString stringWithFormat:@"%@\n",[@"Limit Exceeded!" myModification]];
        //        NSString *firstParagraph = [NSString stringWithFormat:@"\n%@\n",[@"The watchlist contacts limit is exceeded; you can Watchlist only 1 contact with free subscription." myModification]];
        //        NSString *firstTitle = @"";
        //        NSString *firstDetails = [NSString stringWithFormat:@"\n%@",[@"Upgrade each child device to premium for a small monthly fee and get ultimate parenting satisfaction." myModification]];
        //        NSString *secondTitle = @"\n";
        //        NSString *secondDetails = [NSString stringWithFormat:@"\n%@",[@"Please login to your web Dashbord to upgrade the subscription and unrestricted access." myModification]];
        //        [SwiftFTUtils showPremiumPopupWith:self title:popupTitle firstParagraph:firstParagraph firstTitle:firstTitle firstDetails:firstDetails secondTitle:secondTitle secondDetails:secondDetails imageName:@"ic_premium" color:@"orange"];
        
        [SwiftFTUtils showSwiftPremiumPopupOn:self];
        return;
    }
    //    else if (self.isCountBased && self.watchedCount < self.countLimit)
    //    {
    //    [self saveButton:nil];
    //
    ////        self.contactCont = [[NoneWatchedContactViewController alloc] initWithNibName:@"NoneWatchedContactViewController" bundle:nil];
    ////        self.contactCont.checkCount = YES;
    ////        self.contactCont.remainingCount = self.countLimit - self.watchedCount;
    ////        [self.navigationController pushViewController:self.contactCont animated:YES];
    //    }
    else
    {
        [self saveButton:nil];
        
        //        self.contactCont = [[NoneWatchedContactViewController alloc] initWithNibName:@"NoneWatchedContactViewController" bundle:nil];
        //        self.contactCont.checkCount = NO;
        //        [self.navigationController pushViewController:self.contactCont animated:YES];
    }
    
    //*/
}

#pragma mark Location dates from server
-(void) loadContactWatchList
{
    [_StatusAllArray removeAllObjects];
    [_IDsAllArray removeAllObjects];
    
    [SwiftFTUtils showHUDAddedTo:self.view withText:[@"Loading..." myModification] animated:YES];
    
    
    NSString *url = [NSString stringWithFormat:@"%@%ld", kContactWatchlist_mesh2, (long)delegate.selectedDashboardChild.child_id];
    
    [[ApiManager shared] mesh2_commonGetApiWithVC:self andUrl:url withResponse:^(id  _Nonnull json) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            NSLog(@"mesh2 contacts watchlist api response = %@",json);
            
            if([[json valueForKey:@"status"] intValue] == 200)
            {
                //                                           AllContactsModel *model = [[AllContactsModel alloc] initWithDictionary:json error:&error];
                self.dataSource = [NSMutableArray arrayWithArray:[[json valueForKey:@"data"]objectForKey:@"contacts"]];
                
                self.watchedCount = 0;
                for (NSDictionary *temp in self.dataSource) {
                    if ([[temp objectForKey:@"is_watched"] intValue] == 1)
                        self.watchedCount++;
                }
                NSLog(@"self.watchedCount=%ld",(long)self.watchedCount);
                
                for(int i=0;i<self.dataSource.count;i++)
                {
                    NSDictionary *dic=[self.dataSource objectAtIndex:i];
                    [_StatusAllArray addObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"is_watched"]]];
                    if([[NSString stringWithFormat:@"%@",[dic objectForKey:@"is_watched"]] isEqualToString:@"1"])
                    {
                        [_IDsAllArray addObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]]];
                    }
                }
                
                NSLog(@"statusallarray count = %lu and idsallarray count = %lu", (unsigned long)self.StatusAllArray.count, (unsigned long)self.IDsAllArray.count);
            }
            else
                [CommonModel showAlert:@"Error!" msg:[json valueForKey:@"message"]];
            
           // [self refreshTable];
            [self.tableView reloadData];
        });
        
    }];
    
    //---DEPRICATED---//
//    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:delegate.selectedDashboardChild.child_id],@"child_id", nil];
//
//    //    NSLog(@"%@",[NSString stringWithFormat:@"%@%@", KContactWatchList,[NSString stringWithFormat:@"%li",(long)delegate.selectedDashboardChild.child_id]]);
//
//
//    [JSONHTTPClient getJSONFromURLWithString:[NSString stringWithFormat:@"%@%@", KContactWatchList,[NSString stringWithFormat:@"%li",(long)delegate.selectedDashboardChild.child_id]]
//                                      params:params
//                                  completion:^(id json, JSONModelError *err) {
//                                      NSError *error;
//                                      // read response code
//
//                                      NSLog(@"%@",json);
//                                      if([[json valueForKey:@"status_code"] intValue] == 200)
//                                      {
//                                          //                                           AllContactsModel *model = [[AllContactsModel alloc] initWithDictionary:json error:&error];
//                                          self.dataSource = [NSMutableArray arrayWithArray:[[json valueForKey:@"response"]objectForKey:@"contacts"]];
//
//                                          self.watchedCount = 0;
//                                          for (NSDictionary *temp in self.dataSource) {
//                                              if ([[temp objectForKey:@"is_watched"] intValue] == 1)
//                                                  self.watchedCount++;
//                                          }
//                                          NSLog(@"self.watchedCount=%ld",(long)self.watchedCount);
//
//                                          for(int i=0;i<self.dataSource.count;i++)
//                                          {
//                                              NSDictionary *dic=[self.dataSource objectAtIndex:i];
//                                              [_StatusAllArray addObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"is_watched"]]];
//                                              if([[NSString stringWithFormat:@"%@",[dic objectForKey:@"is_watched"]] isEqualToString:@"1"])
//                                              {
//                                                  [_IDsAllArray addObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"contact_id"]]];
//                                              }
//                                          }
//                                      }
//                                      else
//                                          [CommonModel showAlert:@"Error!" msg:[json valueForKey:@"message"]];
//
//                                      [self refreshTable];
//                                      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                                  }];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactWatchedListTableViewCell *cell = (ContactWatchedListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"contactCell22"];
    
    NSString *firstChar;
    if (cell == nil) {
        cell = (ContactWatchedListTableViewCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"contactCell22"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSDictionary *model =  [self.dataSource objectAtIndex:indexPath.row] ;
    //    if(model.name == nil || [model.name isEqualToString:@""])
    //    {
    cell.name.text = [model objectForKey:@"name"];
    
    if( [cell.name.text isEqualToString:@""])
    {
        cell.name.text =@"Unknown";
    }
    else if( [cell.name.text isEqualToString:@"."])
    {
        cell.name.text =@"Unknown";
    }
  
    if(( [model objectForKey:@"phone_mobile"] ==[NSNull null])||( [model objectForKey:@"phone_mobile"] ==nil)||( [model objectForKey:@"phone_mobile"] ==NULL))
    {
        cell.mobile.text = @"Mobile: Unknown";
        
        
        if(( [model objectForKey:@"phone_home"] ==[NSNull null])||( [model objectForKey:@"phone_home"] ==nil)||( [model objectForKey:@"phone_home"] ==NULL))
        {
            cell.mobile.text = @"Home: Unknown";
            if(( [model objectForKey:@"phone_work"] ==[NSNull null])||( [model objectForKey:@"phone_work"] ==nil)||( [model objectForKey:@"phone_work"] ==NULL))
            {
                cell.mobile.text = @"Work: Unknown";
            }
            else
            {
                cell.mobile.text = [NSString stringWithFormat:@"Work:%@",[model objectForKey:@"phone_work"]];
            }
        }
        else
        {
            cell.mobile.text = [NSString stringWithFormat:@"Home:%@",[model objectForKey:@"phone_home"]];
        }
        
    }
    else
    {
        cell.mobile.text = [NSString stringWithFormat:@"Mobile:%@",[model objectForKey:@"phone_mobile"]];
        
    }
    
    if(( [model objectForKey:@"email"] ==[NSNull null])||( [model objectForKey:@"email"] ==nil)||( [model objectForKey:@"email"] ==NULL))
    {
        cell.email.text = @"Email: Unknown";
        
    }
    else
    {
        cell.email.text =  [NSString stringWithFormat:@"Email: %@",[model objectForKey:@"email"]];
        
    }
    //        cell.email.text = [model objectForKey:@"email"];
    //    NSLog(@"%@",[model objectForKey:@"name"]);
    
    firstChar = [NSString stringWithFormat:@"%c",[[model objectForKey:@"name"] characterAtIndex:0]];
    
    //   firstChar = @"U";
    //    }
    //    else
    //    {
    //        cell.name.text = model.name;
    //        cell.mobile.text =model.phone_mobile;
    //        firstChar = [NSString stringWithFormat:@"%c",[model.name characterAtIndex:0]];
    //        cell.email.text = model.email;
    //        firstChar = [NSString stringWithFormat:@"%c",[model.name characterAtIndex:0]];
    //    }
    //   [cell.separator setHidden:NO];
    
    if([firstChar isEqualToString:@""])
    {    [cell.contactImage setTitle:@"U" forState:UIControlStateNormal];
    }
    else if([firstChar isEqualToString:@"."])
    {    [cell.contactImage setTitle:@"U" forState:UIControlStateNormal];
    }
    else
    {
        [cell.contactImage setTitle:[firstChar uppercaseString] forState:UIControlStateNormal];
    }
    
    if(self.tableView.userInteractionEnabled){
        NSString *contactImgName =[NSString stringWithFormat:@"call_circ_%i.png",(int)indexPath.row%4 + 1 ];
        
        [cell.contactImage setBackgroundImage:[UIImage imageNamed:contactImgName] forState:UIControlStateNormal];
        [cell.contactImage setTitleColor:[KCallColor objectAtIndex:indexPath.row %4] forState:UIControlStateNormal];
        cell.add.tag = indexPath.row;
        [cell.add setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        [cell.add addTarget:self action:@selector(deleteContact:) forControlEvents:UIControlEventTouchUpInside];
    }
    else{
        NSString *contactImgName =[NSString stringWithFormat:@"dis_call_circ_%i.png",(int)indexPath.row%4 + 1 ];
        
        [cell.contactImage setBackgroundImage:[UIImage imageNamed:contactImgName] forState:UIControlStateNormal];
        [cell.contactImage setTitleColor:[KCallDisabledColor objectAtIndex:indexPath.row %4] forState:UIControlStateNormal];
        [cell.add setImage:[UIImage imageNamed:@"delete_0"] forState:UIControlStateNormal];
        
    }
    //    cell.contactImage.translatesAutoresizingMaskIntoConstraints=NO;
    //    [cell.contactImage setFrame:CGRectMake(cell.contactImage.frame.origin.x, cell.contactImage.frame.origin.y, 60.0,60.0 )];
    
    
    cell.sw11.on=[[_StatusAllArray objectAtIndex:indexPath.row] boolValue];
    [cell.sw11 addTarget:self action:@selector(Switch1:) forControlEvents:UIControlEventValueChanged];
    
    // */
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)deleteContact:(UIButton *)sender
{
    //---DEPRICATED---//
    NSLog(@"delete contact");
    
    NSLog(@"delete contact");
    
    //    ContactsModel *model = [self.dataSource objectAtIndex:sender.tag];
    //    [SwiftFTUtils showHUDAddedTo:self.view withText:[@"Deleting..." myModification] animated:YES];
    //    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:delegate.selectedDashboardChild.child_id],@"child_id",model.contact_id,@"id", nil];
    //    NSLog(@"%@",params);
    //    [JSONHTTPClient postJSONFromURLWithString:KRemoveContactFromWatchList
    //                                       params:params
    //                                   completion:^(id json, JSONModelError *err){
    //                                       if([[json valueForKey:@"response"] intValue] == 200)
    //                                       {
    //                                           [self.dataSource removeObject:model];
    //                                           [self loadContactWatchList];
    //                                           [self.tableView reloadData];
    //                                       }
    //                                       else
    //                                           [CommonModel showAlert:@"Error!" msg:[json valueForKey:@"message"]];
    //
    //                                       [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    //                                   }];
}



- (IBAction)updateContPrefer:(UISwitch *)sender {
    self.navigationItem.rightBarButtonItem.enabled = sender.isOn;
    NSDictionary *params = @{//@"id":[NSNumber numberWithInteger:delegate.selectedDashboardChild.child_id],
                             @"name":@"contact_watchlist",
                             @"status":[NSNumber numberWithInteger:sender.isOn],
                             @"value":[NSString stringWithFormat:@"%i",sender.isOn]};
    
    [CommonModel updatePreference:params view:self isNotification:NO];
}

#pragma mark Switches Buttons

//Switch1
- (IBAction)Switch1:(id)sender
{
    UISwitch *button = (UISwitch *)sender;
    int k=button.on;
    NSString *SwitchState=[NSString stringWithFormat:@"%i",k];
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    if (indexPath)
    {
        NSLog(@"Row=%li  Section=%li",(long)indexPath.row,(long)indexPath.section);
        
        //        NSString *strUser_Id= @"";
        //https://mesh.familytime.io/v2/ftd/user/management/2922
        
        NSDictionary *dicc=[self.dataSource objectAtIndex:indexPath.row];
        if(k==1)
        {
            [_IDsAllArray addObject: [dicc objectForKey:@"id"]];
            //[_StatusAllArray addObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"is_watched"]]];
            //[_StatusAllArray replaceObjectAtIndex:indexPath.row  withObject:@"1"];
        }
        if(k==0)
        {
            for (int i = 0; i < _IDsAllArray.count; i++)
            {
                if([_IDsAllArray[i] integerValue ] == [[dicc objectForKey:@"id"] integerValue]){
                
                [_IDsAllArray removeObjectAtIndex:i];
                }
            //[_StatusAllArray replaceObjectAtIndex:indexPath.row  withObject:@"0"];
            }
        }
        
        [_StatusAllArray replaceObjectAtIndex:indexPath.row withObject:SwitchState];
        
        
    }
    NSLog(@"StatusAllArray===%@",_StatusAllArray);
    NSLog(@"IDDSSSAllArray===%@",_IDsAllArray);
}

-(IBAction)saveButton:(id)sender
{
    [self apiCall];
    
    
    //---DEPRICATED---//
    
//    [SwiftFTUtils showHUDAddedTo:self.view withText:[@"loading..." myModification] animated:YES];
//    //        NSString *url = [NSString stringWithFormat:@"https://mesh.familytime.io/v2/ftd/user/invite"];
//    NSString *url = [NSString stringWithFormat:@"%@/v2/ftd/settings/android/contactwatchlist/%li",kBasUrl,(long)delegate.selectedDashboardChild.child_id];
//
//    //{"type":"update","user_id":4446,"settings":[{"type": "push_notification", "status": 0},{"type":"add_device", "status": 0},{"type":"email_notification","status":0},{"type":"product_updates","status":0}]}
//
//    //        NSArray *arr=[[NSArray alloc]initWithObjects:@{@"type":@"push_notification",@"status":@"0"},@{@"type":@"add_device",@"status":@"0"},@{@"type":@"email_notification",@"status":@"0"},@{@"type":@"product_updates",@"status":@"0"}, nil];
//    NSArray *arr=[[NSArray alloc]initWithObjects:@{@"type":@"add_device",@"status":@""}, nil];
//
//    NSDictionary *params = @{@"is_active":@"1",@"ids":_IDsAllArray};
//    //    NSArray *params=[[NSArray alloc]initWithObjects:strUser_Id, nil];
//
//    NSString *jsonString;
//    {
//
//        NSError *error;
//        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params
//                                                           options:NSJSONWritingPrettyPrinted // Pass 0 if you don't  care about the readability of the generated string
//                                                             error:&error];
//
//        if (! jsonData) {
//            NSLog(@"Got an error: %@", error);
//        } else {
//            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//            NSLog(@"%@", jsonString);
//        }
//    }
//
//    [JSONHTTPClient postJSONFromURLWithString11:url bodyString:jsonString completion:^(id json, JSONModelError *err) {
//
//        //NSError *error;
//
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//
//        //        NSLog(@"hehe==%@",json);
//        if([[json valueForKey:@"status_code"] intValue] == 200)
//        {
//            [SwiftFTUtils showSyncSettingsPopupWith:self];
//
//            //      [CommonModel showAlert:@"" msg:[json valueForKey:@"response"]];
//            //   [self refreshScreen];
//        }
//        else
//        {
//            [CommonModel showAlert:@"" msg:[json valueForKey:@"response"]];
//        }
//    }];
}

-(void)apiCall
{
    [SwiftFTUtils showHUDAddedTo:self.view withText:[@"loading..." myModification] animated:YES];
    NSString *url = [NSString stringWithFormat:@"%@%ld", kContactWatchlist_mesh2, (long)delegate.selectedDashboardChild.child_id];
    NSDictionary *params = @{@"is_active":_contPrefer.isOn ? @"1" : @"0",
                             @"ids":_IDsAllArray};
    
    NSLog(@"url = %@ and params = %@", url, params);
    
    [[ApiManager shared] putApi:url params:params controller:self isContPresented:NO withResponse:^(NSString * _Nonnull message, NSInteger code) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            if(code == 200)
                [CommonModel showAlert:@"Contact Watchlist" msg:message];
            else
                [CommonModel showAlert:@"Error!" msg:kErrorGeneral];
        });
    }];
}



@end
