//
//  InstalledAppsViewController.m
//  FamilyTime
//
//  Created by Sora Code on 12/29/14.
//  Copyright (c) 2014 SoraCode. All rights reserved.
//

#import "InstalledAppsViewController.h"
#import "MBProgressHUD.h"
//#import "JSONHTTPClient.h"
#import "AppDelegate.h"
#import "PlacesCell.h"
#import "FTD.h"
#import "FTUtils.h"
//#import <Google/Analytics.h>
#import "NSString+LockMustafa.h"
#import "FamilyTime-Swift.h"

AppDelegate *delegate;
UIRefreshControl *refreshCont;
@interface InstalledAppsViewController ()
@property(nonatomic, strong) NSMutableDictionary *dictionary;
@end

@implementation InstalledAppsViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.tableView reloadData];
    
    [self loadAppList];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dictionary = [NSMutableDictionary dictionary];
    delegate = [AppDelegate appDelegate];
    [self.tableView registerNib:[UINib nibWithNibName:@"PlacesCell" bundle:nil] forCellReuseIdentifier:@"PlacesCell"];
    if([SwiftFTUtils isDeviceiPhoneFamily])
        self.tableView.rowHeight = 60;
    else
        self.tableView.rowHeight = 100;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.navigationItem setTitle:[[@"Add Blacklist Apps" myModification] myModification]];
//    [ZendeskChatManager trackEvent:@"Ad Blacklist Apps"];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma  mark pull down refresh 
- (void) addPullDownRefresh
{
    refreshCont = [[UIRefreshControl alloc] init];
    [self.tableView addSubview:refreshCont];
    [refreshCont addTarget:self action:@selector(loadAppList) forControlEvents:UIControlEventValueChanged];
}
- (void) refreshTable
{
    [refreshCont endRefreshing];
    [self.tableView reloadData];
}

#pragma mark Location dates from server
- (void) loadAppList
{
    [SwiftFTUtils showHUDAddedTo:self.view withText:[@"Loading..." myModification] animated:YES];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:delegate.selectedDashboardChild.child_id],@"child_id", nil];
//    [JSONHTTPClient postJSONFromURLWithString:KNoneBlackListedApps
//                                       params:params
//                                   completion:^(id json, JSONModelError *err) {
//                                       NSError *error;
//                                       NSString *msg = [json valueForKey:@"message"] == nil ? [kErrorGeneral myModification] : [json valueForKey:@"message"];
//
//                                       if([[json valueForKey:@"response"] intValue] == 200)
//                                       {
//                                           AllBlistAppsModel *model = [[AllBlistAppsModel alloc] initWithDictionary:json error:&error];
//                                           self.dataSource = [NSMutableArray arrayWithArray:model.data];
//                                           [self sortWithCategories];
//                                       }
//                                       else
//                                           [CommonModel showAlert:[@"Error!" myModification] msg:msg];
//                                           [self refreshTable];
//                                       [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                                   }];
}

- (void)sortWithCategories
{
    self.dictionary = [NSMutableDictionary dictionary];
    for (BlistAppModel *model in self.dataSource)
    {
        NSMutableArray *array = [self.dictionary objectForKey:model.app_category];
        if(array == nil)
        {
            array = [NSMutableArray array];
            [array addObject:model];
        }
        else
        {
            [array addObject:model];
        }
        [self.dictionary setObject:array forKey:model.app_category];
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
    if([SwiftFTUtils isDeviceiPhoneFamily])
        return 35.0f;
    else
        return 80.0f;
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
        label.text = [NSString stringWithFormat:@"   %@",[@"System Apps" myModification]];
    else if(section == 1)
        label.text = [NSString stringWithFormat:@"   %@",[@"Important Apps" myModification]];
    else if(section == 2)
        label.text = [NSString stringWithFormat:@"   %@",[@"Other Apps" myModification]];
    else
        label.text = [NSString stringWithFormat:@"   %@",[@"Other Apps" myModification]];
    return label;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *key;
    if(indexPath.section == 0)
        key = @"system";
    else if(indexPath.section == 1)
        key = @"important";
    else if(indexPath.section == 2)
        key = @"app";
    else
        key = @"app";
    
    PlacesCell *cell = (PlacesCell *)[tableView dequeueReusableCellWithIdentifier:@"PlacesCell"];
    if (cell == nil) {
        cell = (PlacesCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PlacesCell"];
        }
    
    BlistAppModel *model = [[self.dictionary objectForKey:key] objectAtIndex:indexPath.row];
    cell.place.text =  model.app_name;
    float fileSize = (model.size /1024) /1000;
    if(fileSize == 0.0)
        cell.address.text = [NSString stringWithFormat:@"%.2f KB",(fileSize / 1024) / 100];
    else
      cell.address.text = [NSString stringWithFormat:@"%.f MB",fileSize];
    
     cell.editPlace.tag = indexPath.row;
    
    if(model.is_blacklisted)
        [cell.editPlace  setImage:[UIImage imageNamed:@"checked_small"] forState:UIControlStateNormal];
    else{
        [cell.editPlace  setImage:[UIImage imageNamed:@"unchecked_small"] forState:UIControlStateNormal];
       
    }
     [cell.editPlace  addTarget:self action:@selector(addApptoBlackList:event:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *imgName =[NSString stringWithFormat:@"iapp_%i.png",(int)indexPath.row%4 + 1 ];
    [cell.placeImg setImage:[UIImage imageNamed:imgName]];

    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (void)addApptoBlackList:(UIButton *)sender event:(id)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
    
    NSString *key;
    BlistAppModel* model;
    if (indexPath != nil)
    {
        if(indexPath.section == 0)
            key = @"system";
        else if(indexPath.section == 1)
            key = @"important";
        else
            key = @"app";
        model = [[self.dictionary objectForKey:key] objectAtIndex:indexPath.row];
    }
    
    model.is_blacklisted = !model.is_blacklisted;
    [self.dataSource replaceObjectAtIndex:sender.tag withObject:model];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (IBAction)addtoWatchlist:(id)sender
{
    //select black listed apps
    BlistAppModel *model;
    
    NSMutableSet *temp = [[NSMutableSet alloc] init];
    for (int i =0; i<self.dataSource.count; i++)
    {
        model = [self.dataSource objectAtIndex:i];
        if(model.is_blacklisted)
            [temp addObject:[NSNumber numberWithInt:model.installedapp_id.intValue]];
    }
    if(temp.count == 0)
    {
        return;
    }
    
    if (!self.checkCount)
    {
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:[temp allObjects] options:0 error:nil];
        NSString* jsonString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
        
        [SwiftFTUtils showHUDAddedTo:self.view withText:@"Adding Blacklist..." animated:YES];
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:delegate.selectedDashboardChild.child_id],@"child_id",jsonString,@"ids", nil];
        
        //---DEPRICATED---//
//        [JSONHTTPClient postJSONFromURLWithString:@"" //KAddAppToBlackList
//                                           params:params
//                                       completion:^(id json, JSONModelError *err)
//         {
//             // read response code
//             if([[json valueForKey:@"response"] intValue] == 200)
//             {
//                 [self.navigationController popViewControllerAnimated:YES];
//             }
//             else
//                 [CommonModel showAlert:@"Error!" msg:[json valueForKey:@"message"]];
//
//             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//         }];
    }
    else
    {
        if (temp.count <= self.remainingCount)
        {
            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:[temp allObjects] options:0 error:nil];
            NSString* jsonString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
            
            [SwiftFTUtils showHUDAddedTo:self.view withText:[@"Adding Blacklist..." myModification] animated:YES];
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:delegate.selectedDashboardChild.child_id],@"child_id",jsonString,@"ids", nil];
            
            //---DEPRICATED---//
//            [JSONHTTPClient postJSONFromURLWithString:@"" //KAddAppToBlackList
//                                               params:params
//                                           completion:^(id json, JSONModelError *err)
//             {
//                 // read response code
//                 if([[json valueForKey:@"response"] intValue] == 200)
//                 {
//                     [self.navigationController popViewControllerAnimated:YES];
//                 }
//                 else
//                     [CommonModel showAlert:[@"Error!" myModification] msg:[json valueForKey:@"message"]];
//                 
//                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//             }];
        }
        else
        {
//            NSString *popupTitle =[NSString stringWithFormat:@"\n%@",[@"Limit Exceeded!" myModification]];
//            NSString *firstParagraph = [NSString stringWithFormat:@"\n%@\n",[@"The Block App limit is exceeded; You can add only 1 App with free subscription." myModification]];
//            NSString *firstTitle = @"";
//            NSString *firstDetails = [NSString stringWithFormat:@"\n%@",[@"Upgrade each child device to premium for a small monthly fee and get ultimate parenting satisfaction." myModification]];
//            NSString *secondTitle = @"\n";
//            NSString *secondDetails = [NSString stringWithFormat:@"\n%@",[@"Please login to your web Dashbord to upgrade the subscription and unrestricted access." myModification]];
//            [SwiftFTUtils showPremiumPopupWith:self title:popupTitle firstParagraph:firstParagraph firstTitle:firstTitle firstDetails:firstDetails secondTitle:secondTitle secondDetails:secondDetails imageName:@"ic_premium" color:@"orange"];
            
            [SwiftFTUtils showSwiftPremiumPopupOn:self];
        }
    }
}
@end
