//
//  ContactViewController.m
//  FamilyTime
//
//  Created by Sora Code on 12/18/14.
//  Copyright (c) 2014 SoraCode. All rights reserved.
//

#import "NoneWatchedContactViewController.h"
#import "MBProgressHUD.h"
//#import "JSONHTTPClient.h"
#import "AppDelegate.h"
#import "NEIServiceManager.h"
#import "FTD.h"
//#import <Google/Analytics.h>
#import "FTUtils.h"
#import "NSString+LockMustafa.h"
#import "FamilyTime-Swift.h"

AppDelegate *delegate;
UIRefreshControl *  refreshControl;
@interface NoneWatchedContactViewController ()

@end

@implementation NoneWatchedContactViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    
    [_btnaddtoWatchList setTitle:@"Add To Watchlist" forState:UIControlStateNormal];
    
    if( [[NSUserDefaults standardUserDefaults]objectForKey:@"gobacknow"]!=nil)
    {
        
        if([[[NSUserDefaults standardUserDefaults]objectForKey:@"gobacknow"] isEqualToString:@"YES"])
        {
            [[NSUserDefaults standardUserDefaults]setObject:@"NO"  forKey:@"gobacknow"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSUserDefaults standardUserDefaults]setObject:@"NO"  forKey:@"gobacknow"];
    [[NSUserDefaults standardUserDefaults]synchronize];

    
    [self.navigationItem setTitle:[@"Non-Watchlist Contacts" myModification]];
    delegate = [AppDelegate appDelegate];
    
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        [self.tableView registerNib:[UINib nibWithNibName:@"ContactsCell2~ipad" bundle:nil] forCellReuseIdentifier:@"contactCell2"];
    }
    else
    {
        [self.tableView registerNib:[UINib nibWithNibName:@"ContactsCell2~iphone" bundle:nil] forCellReuseIdentifier:@"contactCell2"];
    }
    self.tableView.rowHeight = 100;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
     self.dataSource = [[NSMutableArray alloc]init];
    self.contactColors = KCallColor;
    
    [self addPullRefresh];
    
    [self loadContacts];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Places
-(void) loadContacts
{
    [SwiftFTUtils showHUDAddedTo:self.view withText:@"Loading..." animated:YES];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:delegate.selectedDashboardChild.child_id],@"child_id", nil];
    
    //---DEPRICATED---//---THIS CLASS IS NOT BEING USED---//
    
//    [JSONHTTPClient postJSONFromURLWithString:@"" //KContactNoneWatchList
//                                       params:params
//                                   completion:^(id json, JSONModelError *err) {
//                                       NSError *error;
//                                        NSString *msg = [json valueForKey:@"message"] == nil ? [kErrorGeneral myModification]: [json valueForKey:@"message"];
//                                       // read response code
//                                       if([[json valueForKey:@"response"] intValue]== 200)
//                                       {
//                                           NSLog(@"%@",json);
//                                           AllContactsModel *model = [[AllContactsModel alloc] initWithDictionary:json error:&error];
//                                           self.dataSource = [NSMutableArray arrayWithArray:model.contacts.data];
//
//                                       }
//                                       else
//                                           [CommonModel showAlert:[@"Error!" myModification] msg:msg];
//                                         [self refreshTable];
//                                       [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                                   }];
    
}

#pragma mark - QBRefreshControlDelegate
-(void) addPullRefresh
{
    refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(loadContacts) forControlEvents:UIControlEventValueChanged];
    
}

- (void)refreshTable {
    [refreshControl endRefreshing];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ContactsCell *cell = (ContactsCell *)[tableView dequeueReusableCellWithIdentifier:@"contactCell2"];
    
    if (cell == nil) {
        cell = (ContactsCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"contactCell2"];
    }
    ContactsModel *contact =  [self.dataSource objectAtIndex:indexPath.row] ;
    cell.name.text = contact.name;
    cell.mobile.text = contact.phone_mobile;
    cell.email.text = contact.email;
     [cell.contactImage setTitle:[[NSString stringWithFormat:@"%c",[contact.name characterAtIndex:0]] uppercaseString] forState:UIControlStateNormal];
    NSString *contactImgName =[NSString stringWithFormat:@"call_circ_%i.png",(int)indexPath.row%4 + 1 ];
     [cell.contactImage setBackgroundImage:[UIImage imageNamed:contactImgName] forState:UIControlStateNormal];
    [cell.contactImage setTitleColor:[self.contactColors objectAtIndex:indexPath.row %4] forState:UIControlStateNormal];
    if(contact.is_watched)
        [cell.add  setImage:[UIImage imageNamed:@"checked_small"] forState:UIControlStateNormal];
    else{
        [cell.add  setImage:[UIImage imageNamed:@"unchecked_small"] forState:UIControlStateNormal];
        
    }

    cell.add.tag = indexPath.row;
    [cell.add addTarget:self action:@selector(addContactToWatchList:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}
#pragma mark Edit Place
-(void)editContacts:(UIButton *) sender;
{
    [self.tableView setEditing:!self.tableView.isEditing];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
        [self deletContact:(int)indexPath.row];
    
    NSLog(@"apply changes");
}
#pragma mark delet Place
-(void)deletContact:(int)index
{
    //delete place
    ContactsModel *contact =  [self.dataSource objectAtIndex:index];
    //---DELETE CONTACT FUNCTIONALITY REMOVED---//
    NSDictionary *params = @{@"id":@""}; //contact.contact_id};
    [SwiftFTUtils showHUDAddedTo:self.view withText:@"Deleting..." animated:YES];
    
    //---REMOVED THIS FUNCTIONALITY---//
//    [JSONHTTPClient postJSONFromURLWithString:@"" //KDeleteContacts
//                                       params:params
//                                   completion:^(id json, JSONModelError *err) {
//                                //       NSError *error;
//                                       // read response code
//                                       if([[json valueForKey:@"response"] intValue] == 200){
//                                           [self.dataSource removeObjectAtIndex:index];
//                                           [self loadContacts];
//                                       }
//                                       [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                                   }];
    
}
-(void)addContactToWatchList:(UIButton *)sender
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    ContactsModel *model = [self.dataSource objectAtIndex:sender.tag];
    model.is_watched = !model.is_watched;
    [self.dataSource replaceObjectAtIndex:sender.tag withObject:model];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (IBAction)addContactsToWatchList:(UIButton *)sender
{
    ContactsModel *model ;
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for (int i =0; i<self.dataSource.count; i++)
    {
        model = [self.dataSource objectAtIndex:i];

        //---AS THIS CLASS IS DEPRICATED---//
        
//        if(model.is_watched)
//            [temp addObject:[NSNumber numberWithInt:model.contact_id.intValue]];
    }
    
    if(temp.count == 0)
    {
        return;
    }
    if (!self.checkCount)
    {
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:temp options:0 error:nil];
        NSString* jsonString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
        
        [SwiftFTUtils showHUDAddedTo:self.view withText:[@"Adding Watchlist..." myModification] animated:YES];
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:delegate.selectedDashboardChild.child_id],@"child_id",jsonString,@"ids", nil];
        NSLog(@"%@",params);
//        [JSONHTTPClient postJSONFromURLWithString:KAddContactToWatchList
//                                           params:params
//                                       completion:^(id json, JSONModelError *err)
//         {
//             if([[json valueForKey:@"response"] intValue] == 200)
//             {
//                 model.is_watched = !model.is_watched;
//
////                 [self.navigationController popViewControllerAnimated:YES];
//                 [SwiftFTUtils showSyncSettingsPopupWith:self];
//
//
//             }
//             else
//                 [CommonModel showAlert:[@"Error!" myModification] msg:[json valueForKey:@"message"]];
//
//             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//         }];
    }
    else
    {
        if (temp.count <= self.remainingCount)
        {
            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:temp options:0 error:nil];
            NSString* jsonString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
            
            [SwiftFTUtils showHUDAddedTo:self.view withText:[@"Adding Watchlist..." myModification] animated:YES];
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:delegate.selectedDashboardChild.child_id],@"child_id",jsonString,@"ids", nil];
            NSLog(@"%@",params);
//            [JSONHTTPClient postJSONFromURLWithString:KAddContactToWatchList
//                                               params:params
//                                           completion:^(id json, JSONModelError *err)
//             {
//                 if([[json valueForKey:@"response"] intValue] == 200)
//                 {
//                     model.is_watched = !model.is_watched;
////                     [self.navigationController popViewControllerAnimated:YES];
//                     [SwiftFTUtils showSyncSettingsPopupWith:self];
//
//                 }
//                 else
//                     [CommonModel showAlert:[@"Error!" myModification] msg:[json valueForKey:@"message"]];
//                 
//                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//             }];
        }
        else
        {
//            NSString *popupTitle = [NSString stringWithFormat:@"%@\n",[@"Limit Exceeded!" myModification]];
//            NSString *firstParagraph = [NSString stringWithFormat:@"\n%@\n",[@"The Contact Watchlist limit is exceeded; You can add only 1 Contact with free subscription." myModification]];
//            NSString *firstTitle = @"";
//            NSString *firstDetails = [NSString stringWithFormat:@"\n%@",[@"Upgrade each child device to premium for a small monthly fee and get ultimate parenting satisfaction." myModification]];
//            NSString *secondTitle = @"\n";
//            NSString *secondDetails =[NSString stringWithFormat:@"\n%@",[@"Please login to your web Dashbord to upgrade the subscription and unrestricted access." myModification]];
//            [SwiftFTUtils showPremiumPopupWith:self title:popupTitle firstParagraph:firstParagraph firstTitle:firstTitle firstDetails:firstDetails secondTitle:secondTitle secondDetails:secondDetails imageName:@"ic_premium" color:@"orange"];
            
            [SwiftFTUtils showSwiftPremiumPopupOn:self];
        }
    }
}
@end
