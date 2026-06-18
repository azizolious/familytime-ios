//
//  InstalledAppsViewController.m
//  FamilyTime
//
//  Created by Sora Code on 12/29/14.
//  Copyright (c) 2014 SoraCode. All rights reserved.
//

#import "AllInstalledAppsViewController.h"
#import "MBProgressHUD.h"
//#import "JSONHTTPClient.h"
#import "AppDelegate.h"
#import "PlaceCell.h"
#import "PlacesCell.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FTD.h"
#import "NEIServiceManager.h"
#import "FTUtils.h"
#import "NSString+LockMustafa.h"
#import "FamilyTime-Swift.h"


AppDelegate *delegate;
UIRefreshControl *refreshCont;
@interface AllInstalledAppsViewController ()
@property(nonatomic, strong) NSMutableDictionary *dictionary;
@property (nonatomic, assign) NSInteger blockedCount;
@end

@implementation AllInstalledAppsViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dictionary = [NSMutableDictionary dictionary];
    delegate = [AppDelegate appDelegate];
    [self.tableView registerNib:[UINib nibWithNibName:@"PlacesCell" bundle:nil] forCellReuseIdentifier:@"PlacesCell"];
    if([SwiftFTUtils isDeviceiPhoneFamily])
        self.tableView.rowHeight = 70;
    else
        self.tableView.rowHeight = 100;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.navigationItem setTitle:[@"Installed Apps" myModification]];
  
    /*
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(236, 229,296,212)];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.image = [UIImage imageNamed:@"ipad_empty"];
        imgView.hidden=YES;
        [self.view addSubview:imgView];
        [self.view bringSubviewToFront:imgView];
        
        contentLbl=[[UILabel alloc]initWithFrame:CGRectMake(203, 489, 362, 41)];
        contentLbl.lineBreakMode=YES;
        contentLbl.textColor=[UIColor lightGrayColor];
        contentLbl.text=[@"It seems like there is no record to\n display." myModification];
        contentLbl.font=[UIFont systemFontOfSize:16];
        contentLbl.lineBreakMode = NSLineBreakByWordWrapping;
        contentLbl.numberOfLines = 2;
        contentLbl.textAlignment = NSTextAlignmentCenter;
        contentLbl.hidden=YES;
        [self.view addSubview:contentLbl];
        [self.view bringSubviewToFront:contentLbl];
    }
    else if(([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone))
    {
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(115, 152,145,104)];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.image = [UIImage imageNamed:@"ic_empty"];
        imgView.hidden=YES;
        [self.view addSubview:imgView];
        [self.view bringSubviewToFront:imgView];
        
        contentLbl=[[UILabel alloc]initWithFrame:CGRectMake(6, 279, 362, 45)];
        contentLbl.lineBreakMode=YES;
        contentLbl.textColor=[UIColor lightGrayColor];
        contentLbl.text=[@"It seems like there is no record to\n display." myModification];
        contentLbl.font=[UIFont systemFontOfSize:16];
        contentLbl.lineBreakMode = NSLineBreakByWordWrapping;
        contentLbl.numberOfLines = 2;
        contentLbl.textAlignment = NSTextAlignmentCenter;
        contentLbl.hidden=YES;
        [self.view addSubview:contentLbl];
        [self.view bringSubviewToFront:contentLbl];
    }
   */
    
    
    [self loadAppList];
    [self addPullDownRefresh];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    DashboardChildPackageFeature *packageFeature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"installedapp"];
//    if (packageFeature.package_id == 1)
//    {
////        if(packageFeature.is_time_based == 1 || packageFeature.is_count_based == 1)
////            [self showPremiumBanner:YES];
////        else
////            [self showPremiumBanner:NO];
//    }
//    else
//    {
//        [self showPremiumFeatureView:YES];
//    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)addtoWatchlist:(id)sender
{
    
}

#pragma  mark pull down refresh
-(void) addPullDownRefresh
{
    refreshCont = [[UIRefreshControl alloc] init];
    [self.tableView addSubview:refreshCont];
    [refreshCont addTarget:self action:@selector(loadAppList) forControlEvents:UIControlEventValueChanged];
}
-(void) refreshTable
{
    [refreshCont endRefreshing];
    [self.tableView reloadData];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

#pragma mark Location dates from server
- (void) loadAppList
{
    [self.contactImage removeFromSuperview];
    [contentLbl removeFromSuperview];
    [_lblText removeFromSuperview];

    [SwiftFTUtils showHUDAddedTo:self.view withText:[@"Loading..." myModification] animated:YES];
    
    
    
//    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:delegate.selectedDashboardChild.child_id],@"child_id", nil];
//
//    [JSONHTTPClient postJSONFromURLWithString:KInstalledApps
//                                       params:params
//                                   completion:^(id json, JSONModelError *err) {
//                                       NSError *error;
//                                       NSString *msg = [json valueForKey:@"message"] == nil ? [kErrorGeneral myModification] : [json valueForKey:@"message"];
//
//
////                                       [self.contactImage removeFromSuperview];
////                                       [contentLbl removeFromSuperview];
////                                       [_lblText removeFromSuperview];
//                                       // read response code
//                                       /*
//                                       /////////
//                                       if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//                                       {
//                                           imgView.hidden=NO;
//                                           contentLbl.hidden=NO;
//                                           self.view.backgroundColor = [UIColor whiteColor];
//
//                                           self.contactImage.hidden=YES;
//                                           self.lblText.hidden=YES;
//                                       }
//                                       if (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width) == 667))
//                                       {
//                                           imgView.hidden=NO;
//                                           contentLbl.hidden=NO;
//                                           self.view.backgroundColor = [UIColor whiteColor];
//
//                                           self.contactImage.hidden=YES;
//                                           self.lblText.hidden=YES;
//                                       }
//                                       else if (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width) == 736))
//                                       {
//                                           imgView.hidden=NO;
//                                           contentLbl.hidden=NO;
////                                           self.view.backgroundColor = UIColorFromRGB(0xEFEFF4);
//                                           self.view.backgroundColor = [UIColor whiteColor];
//
//                                           self.contactImage.hidden=YES;
//                                           self.lblText.hidden=YES;
//                                       }
////                                       [self refreshTable];
//
//         */
//
////                                       self.contactImage.hidden=YES;
////                                       self.lblText.hidden=YES;
//
//                                       ////////
//                                       if([[json valueForKey:@"response"] intValue] == 200)
//                                       {
//                                           AllBlistAppsModel *model = [[AllBlistAppsModel alloc] initWithDictionary:json error:&error];
//                                           self.dataSource = [NSMutableArray arrayWithArray:model.data];
//                                           [self sortWithCategories];
////                                           [self viewDidDisappear:YES];
//
//                                           if(self.dataSource.count==0)
//                                           {
//                                               self.view.backgroundColor = [UIColor whiteColor];
//
//                                               self.contactImage.hidden=NO;
//                                               self.lblText.hidden=NO;
//                                               _tableView.hidden=YES;
//
////                                               [self.view addSubview:self.contactImage];
////                                               [self.view addSubview:self.lblText];
//                                               [self onthebook];
//
//                                               [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//
////                                               [self refreshTable];
//
//                                           }
//                                           else
//                                           {
//                                               self.contactImage.hidden=YES;
//                                               self.lblText.hidden=YES;
//                                               _tableView.hidden=NO;
//                                               [self refreshTable];
//
//                                           }
////                                           [self refreshTable];
//
//
//                                       }
//                                       else
//                                       {
//                                           [CommonModel showAlert:[@"Error!" myModification] msg:msg];
//                                           self.view.backgroundColor = [UIColor whiteColor];
////                                           self.contactImage.hidden=NO;
////                                           self.lblText.hidden=NO;
//
//                                           [self.contactImage removeFromSuperview];
//                                           [self.lblText removeFromSuperview];
//                                           _tableView.hidden=YES;
//
////                                           [self.view addSubview:self.contactImage];
////                                           [self.view addSubview:self.lblText];
//                                           [self onthebook];
//
//                                       }
////                                       self.contactImage.hidden=NO;
////                                       self.lblText.hidden=NO;
////                                       [self refreshTable];
////                                       self.contactImage.hidden=YES;
////                                       self.lblText.hidden=YES;
//
//
//                                   }];
    
    
    
    //---NATIVE API CALLING---//
    NSString *paramStr = [NSString stringWithFormat:@"%ld", (long)delegate.selectedDashboardChild.child_id];
    NSString *url = [KInstalledApps stringByAppendingString:paramStr];
    
    [[ApiManager shared] mesh_getApiWithApi:url withResponse:^(NSDictionary * _Nonnull json, NSInteger errorCode, NSString * _Nonnull message) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            {
                NSError *error;
                NSString *msg = [json valueForKey:@"message"] == nil ? [kErrorGeneral myModification] : [json valueForKey:@"message"];
                
                ////////
                if([[json valueForKey:@"status"] intValue] == 200) {
                    AllBlistAppsModel *model = [[AllBlistAppsModel alloc] initWithDictionary:json error:&error];
                    self.dataSource = [NSMutableArray arrayWithArray:model.installedAppList];
                    for (BlistAppModel *items in self.dataSource){
                        if (![items.app_category.lowercaseString  isEqual: @"app"] && ![items.app_category.lowercaseString  isEqual: @"system"] && ![items.app_category.lowercaseString  isEqual: @"important"]){
                            NSLog(@"%@", items.app_category);
                            items.app_category = @"app";
                          //  [self.dataSource removeObject:items];
                        }
                    }
                    [self sortWithCategories];
                    
                    if(self.dataSource.count==0)
                    {
                        self.view.backgroundColor = [UIColor whiteColor];
                        
                        self.contactImage.hidden=NO;
                        self.lblText.hidden=NO;
                        _tableView.hidden=YES;
                        
                        [self onthebook];
                        
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    } else {
                        self.contactImage.hidden=YES;
                        self.lblText.hidden=YES;
                        _tableView.hidden=NO;
                        [self.tableView.delegate self];
                        [self.tableView.dataSource self];
                        [self refreshTable];
                    }
                }
                else
                {
                    [CommonModel showAlert:[@"Error!" myModification] msg:msg];
                    self.view.backgroundColor = [UIColor whiteColor];
                    
                    [self.contactImage removeFromSuperview];
                    [self.lblText removeFromSuperview];
                    _tableView.hidden=YES;
                    
                    [self onthebook];
                    
                }
            }
            
        });
        
    }];
    
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.contactImage setHidden:YES];
    [self.lblText setHidden:YES];
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        imgView.hidden=YES;
        contentLbl.hidden=YES;
        self.view.backgroundColor = UIColorFromRGB(0xEFEFF4);
    }
    if (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width) == 667))
    {
        imgView.hidden=YES;
        contentLbl.hidden=YES;
        self.view.backgroundColor = UIColorFromRGB(0xEFEFF4);
    }
    else if (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width) == 736))
    {
        imgView.hidden=YES;
        contentLbl.hidden=YES;
        self.view.backgroundColor = UIColorFromRGB(0xEFEFF4);
    }
}

- (void)sortWithCategories
{
    self.blockedCount = 0;
    self.dictionary = [NSMutableDictionary dictionary];
    for (BlistAppModel *model in self.dataSource)
    {
        NSMutableArray *array = [self.dictionary objectForKey:model.app_category.lowercaseString];
        if(array == nil)
        {
            array = [NSMutableArray array];
            [array addObject:model];
        }
        else
        {
            [array addObject:model];
        }
        [self.dictionary setObject:array forKey:model.app_category.lowercaseString];
        if (model.is_blacklisted == 1)
            self.blockedCount += 1;
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return [[self.dictionary objectForKey:@"system"] count];
    else if(section == 1)
        return [[self.dictionary objectForKey:@"important"] count];
    else if(section == 2)
        return [[self.dictionary objectForKey:@"app"] count];
   return [[self.dictionary objectForKey:@"app"] count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
         if([[self.dictionary objectForKey:@"system"] count] > 0 )
         {
             if([SwiftFTUtils isDeviceiPhoneFamily])
                 return 35.0f;
             else
                 return 80.0f;
         }
        else
        {
            return 0.0f;
        }
    }
    else if(section == 1)
    {
         if([[self.dictionary objectForKey:@"important"] count] > 0)
         {
             if([SwiftFTUtils isDeviceiPhoneFamily])
                 return 35.0f;
             else
                 return 80.0f;
         }
        else
            return 0.0f;
    }
    else if(section == 2)
    {
         if([[self.dictionary objectForKey:@"app"] count] > 0)
         {
             if([SwiftFTUtils isDeviceiPhoneFamily])
                 return 35.0f;
             else
                 return 80.0f;
         }
        else
        {
            return 0.0f;
        }
    }
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.bounds), ([SwiftFTUtils isDeviceiPhoneFamily]) ? 35.0f: 80.0f)];
    label.backgroundColor = RGBCOLOR(235, 235, 241, 1);
    if([SwiftFTUtils isDeviceiPhoneFamily])
        label.font = [UIFont fontWithName:@"OpenSans" size:15];
    else
        label.font = [UIFont fontWithName:@"OpenSans" size:20];
    label.textColor = RGBCOLOR(96, 96, 96, 1);
    if(section == 0)
        label.text =[NSString stringWithFormat:@"   %@",[@"System Apps" myModification]];
    else if(section == 1)
        label.text = [NSString stringWithFormat:@"   %@",[@"Important Apps" myModification] ];
    else if(section == 2)
        label.text =[NSString stringWithFormat:@"   %@",[@"Other Apps" myModification]];
    else
        label.text = [NSString stringWithFormat:@"   %@",[@"Other Apps" myModification]];
    return label;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key;
    if(indexPath.section == 0)
        key = @"system";
    else if(indexPath.section == 1)
        key = @"important";
    else if(indexPath.section == 2)
        key = @"app";
    else
        key = @"app";
    
    SwiftPlacesCell *cell = (SwiftPlacesCell *)[tableView dequeueReusableCellWithIdentifier:@"PlacesCell"];
    if (cell == nil) {
        cell = (SwiftPlacesCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PlacesCell"];
    }
    BlistAppModel *model = [[self.dictionary objectForKey:key] objectAtIndex:indexPath.row];
    
    cell.place.text =  model.app_name;
    float fileSize = (model.size /1024) /1000;
    if(fileSize == 0.0)
        cell.address.text = [NSString stringWithFormat:@"%.2f KB",(fileSize / 1024) / 100];
    else
        cell.address.text = [NSString stringWithFormat:@"%.2f MB",fileSize];
    
    cell.editPlace.tag = indexPath.row;
    NSLog(@"%d",model.is_blacklisted);
    
    if(model.is_blacklisted)
        [cell.editPlace  setImage:[UIImage imageNamed:@"lock"] forState:UIControlStateNormal];
    else{
        [cell.editPlace  setImage:[UIImage imageNamed:@"unlock"] forState:UIControlStateNormal];
        
    }
    //[cell.editPlace  addTarget:self action:@selector(addApptoBlackList:event:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *imgName =[NSString stringWithFormat:@"iappsFilled_%i.png",(int)indexPath.row%4 + 1 ];
    [cell.placeImg setImage:[UIImage imageNamed:imgName]];
    
     if([delegate.selectedDashboardChild.device isEqualToString:@"iphone"])
         cell.editPlace.hidden = YES;
    else
         cell.editPlace.hidden = NO;
    
    //THIS ONE IS TEMPORARILY STOPPED: FAHAD
    cell.editPlace.hidden = YES;
  //  [self viewDidDisappear:YES];
    
    if([SwiftFTUtils isDeviceiPhoneFamily])
    {
        cell.place.font = [UIFont fontWithName:@"OpenSans" size:17];
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

//---DEPRICATED---//---BOTH BELOW APIS---//

//- (void)addApptoBlackList:(UIButton *)sender event:(id)event
//{
//    [SwiftFTUtils showHUDAddedTo:self.view withText:@"Requesting..." animated:YES];
//    NSDictionary *params;
//
//    NSSet *touches = [event allTouches];
//    UITouch *touch = [touches anyObject];
//    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
//    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
//
//    NSString *key;
//    BlistAppModel* model;
//    if (indexPath != nil)
//    {
//        if(indexPath.section == 0)
//            key = @"system";
//            else if(indexPath.section == 1)
//                key = @"important";
//        else
//            key = @"app";
//        model = [[self.dictionary objectForKey:key] objectAtIndex:indexPath.row];
//    }
////    NSString *url = model.is_blacklisted == 1 ? KRemoveBlackListedApp : KAddAppToBlackList;
//
//    //---DEPRICATED---//
//    NSString *url = model.is_blacklisted == 1 ? @"" : @""; //KAddAppToBlackList;
//
//
//    if(model.is_blacklisted == 1)
//    {
//        params = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:delegate.selectedDashboardChild.child_id],@"child_id",model.installedapp_id ,@"id", nil];
//
////        [JSONHTTPClient postJSONFromURLWithString:url
////                                           params:params
////                                       completion:^(id json, JSONModelError *err)
////         {
////             NSLog(@"%@",url);
////             NSLog(@"%@",params);
////             if([[json valueForKey:@"response"] intValue] == 200)
////             {
////                 [self.tableView reloadData];
////                 [self loadAppList];
////             }
////             else
////                 [CommonModel showAlert:[@"Error!" myModification] msg:[json valueForKey:@"message"]];
////
////             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
////         }];
//    }
//    else
//    {
//        DashboardChildPackageFeature *packageFeature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"appblocking"];
//        if (packageFeature.is_count_based == 1)
//        {
//            if (self.blockedCount < [packageFeature.count_limit integerValue])
//            {
//                NSString *idsParam = [NSString stringWithFormat:@"[%@]",model.installedapp_id];
//                model.installedapp_id = stringts;
//                params = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:delegate.selectedDashboardChild.child_id],@"child_id",idsParam ,@"ids", nil];
//
////                [JSONHTTPClient postJSONFromURLWithString:url
////                                                   params:params
////                                               completion:^(id json, JSONModelError *err)
////                 {
////                     // read response code
////                     NSLog(@"%@",url);
////                     NSLog(@"%@",params);
////                     if([[json valueForKey:@"response"] intValue] == 200)
////                     {
////                         //                                           model.is_blacklisted = 1;
////                         [self.tableView reloadData];
////                         [self loadAppList];
////                     }
////
////                     else
////                         [CommonModel showAlert:[@"Error!" myModification] msg:[json valueForKey:@"message"]];
////
////                     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
////                 }];
//            }
//            else
//            {
//                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//
////                NSString *popupTitle =[NSString stringWithFormat:@"%@\n",[@"Limit Exceeded!" myModification]];
////                NSString *firstParagraph = [[NSString stringWithFormat:@"\nThe Block App limit is exceeded; You can add only %@ App with free subscription.\n",packageFeature.count_limit] myModification];
////                NSString *firstTitle = @"";
////                NSString *firstDetails =[NSString stringWithFormat:@"\n%@",[@"Upgrade each child device to premium for a small monthly fee and get ultimate parenting satisfaction." myModification]];
////                NSString *secondTitle = @"\n";
////                NSString *secondDetails = [@"\nPlease login to your web Dashbord to upgrade the subscription and unrestricted access." myModification];
////                [SwiftFTUtils showPremiumPopupWith:self title:popupTitle firstParagraph:firstParagraph firstTitle:firstTitle firstDetails:firstDetails secondTitle:secondTitle secondDetails:secondDetails imageName:@"ic_premium" color:@"orange"];
//                [SwiftFTUtils showSwiftPremiumPopupOn:self];
//            }
//        }
//        else
//        {
//            NSString *idsParam = [NSString stringWithFormat:@"[%@]",model.installedapp_id];
//            model.installedapp_id = stringts;
//            params = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:delegate.selectedDashboardChild.child_id],@"child_id",idsParam ,@"ids", nil];
//
////            [JSONHTTPClient postJSONFromURLWithString:url
////                                               params:params
////                                           completion:^(id json, JSONModelError *err)
////             {
////                 NSLog(@"%@",url);
////                 NSLog(@"%@",params);
////                 if([[json valueForKey:@"response"] intValue] == 200)
////                 {
////                     [self.tableView reloadData];
////                     [self loadAppList];
////                 }
////
////                 else
////                     [CommonModel showAlert:[@"Error!" myModification] msg:[json valueForKey:@"message"]];
////
////                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
////             }];
//        }
//    }
//}
-(void)onthebook
{
    [refreshCont endRefreshing];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(236, 229,296,212)];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.image = [UIImage imageNamed:@"ipad_empty"];
        imgView.hidden=NO;
        [self.view addSubview:imgView];
        [self.view bringSubviewToFront:imgView];
        
        contentLbl=[[UILabel alloc]initWithFrame:CGRectMake(203, 489, 362, 41)];
        contentLbl.lineBreakMode=YES;
        contentLbl.textColor=[UIColor lightGrayColor];
        contentLbl.text=[@"It seems like there is no record to\n display." myModification];
        contentLbl.font=[UIFont systemFontOfSize:16];
        contentLbl.lineBreakMode = NSLineBreakByWordWrapping;
        contentLbl.numberOfLines = 2;
        contentLbl.textAlignment = NSTextAlignmentCenter;
        contentLbl.hidden=NO;
        [self.view addSubview:contentLbl];
        [self.view bringSubviewToFront:contentLbl];
    }
    else if(([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone))
    {
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(115, 152,145,104)];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.image = [UIImage imageNamed:@"ic_empty"];
        imgView.hidden=NO;
        [self.view addSubview:imgView];
        [self.view bringSubviewToFront:imgView];
        
        contentLbl=[[UILabel alloc]initWithFrame:CGRectMake(6, 279, 362, 45)];
        contentLbl.lineBreakMode=YES;
        contentLbl.textColor=[UIColor lightGrayColor];
        contentLbl.text=[@"It seems like there is no record to\n display." myModification];
        contentLbl.font=[UIFont systemFontOfSize:16];
        contentLbl.lineBreakMode = NSLineBreakByWordWrapping;
        contentLbl.numberOfLines = 2;
        contentLbl.textAlignment = NSTextAlignmentCenter;
        contentLbl.hidden=NO;
        [self.view addSubview:contentLbl];
        [self.view bringSubviewToFront:contentLbl];
    }
}
@end
