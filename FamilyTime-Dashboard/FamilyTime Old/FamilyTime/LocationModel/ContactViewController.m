//
//  ContactViewController.m
//  FamilyTime
//
//  Created by Sora Code on 12/18/14.
//  Copyright (c) 2014 SoraCode. All rights reserved.
//
#import "NSString+LockMustafa.h"

#import "ContactViewController.h"
#import "MBProgressHUD.h"
//#import "JSONHTTPClient.h"
#import "AppDelegate.h"
#import "ContactCells.h"
#import "FTD.h"
#import "NEIServiceManager.h"
//#import <Google/Analytics.h>
#import "FTUtils.h"
#import "NSString+LockMustafa.h"
#import "FamilyTime-Swift.h"

@class CoreDataUtility;

NSString *contact_package_id = @"";
NSString *contact_package_name = @"";
NSString *contact_device = @"";

AppDelegate *delegate;
UIRefreshControl *  refreshControl;
@interface ContactViewController (){
    NSString *nextPageURL;
    NSString *baseURL;
    BOOL isBaseURL;
}
@property (nonatomic, assign) NSInteger watchlistCount;
@end

@implementation ContactViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:[@"Contacts" myModification]];
    delegate = [AppDelegate appDelegate];
    [self.tableView registerNib:[UINib nibWithNibName:@"ContactCells" bundle:nil] forCellReuseIdentifier:@"ContactCells"];
    self.tableView.rowHeight = 85;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    self.dataSource = [[NSMutableArray alloc]init];
    self.contactColors = KCallColor;
    
    NSInteger child_id = delegate.selectedDashboardChild.child_id;
    int convertedChild_id = (int) child_id;
    
    contact_package_id =  [CoreDataUtility fetchPackageIdForChild_id:(convertedChild_id)];
    contact_package_name = [CoreDataUtility fetchPackageNameForChild_id:(convertedChild_id)];
    contact_device =  [CoreDataUtility fetchPackageDeviceForChild_id:(convertedChild_id)];
    
    nextPageURL = @"";
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(236, 229,296,212)];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.image = [UIImage imageNamed:@"ipad_empty"];
        imgView.hidden=YES;
        [self.view addSubview:imgView];
        [self.view bringSubviewToFront:imgView];
        
        contentLbl=[[UILabel alloc]initWithFrame:CGRectMake(203, 489, 362, 45)];
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
    else if (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone))
    {
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(115, 152,145,104)];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.image = [UIImage imageNamed:@"ic_empty"];
        imgView.hidden=YES;
        [self.view addSubview:imgView];
        [self.view bringSubviewToFront:imgView];
        
        contentLbl=[[UILabel alloc]initWithFrame:CGRectMake(30, 279, 315, 41)];
        contentLbl.lineBreakMode=YES;
        contentLbl.textColor=[UIColor lightGrayColor];
        contentLbl.text=[@"It seems like there is no record to\n display." myModification];
        contentLbl.font=[UIFont systemFontOfSize:17];
        contentLbl.lineBreakMode = NSLineBreakByWordWrapping;
        contentLbl.numberOfLines = 2;
        contentLbl.textAlignment = NSTextAlignmentCenter;
        contentLbl.hidden=YES;
        [self.view addSubview:contentLbl];
        [self.view bringSubviewToFront:contentLbl];
    }
        
    baseURL     = [NSString stringWithFormat:@"%@%ld", kGet_Contacts_mesh2, (long)delegate.selectedDashboardChild.child_id];
    nextPageURL = @"";
    isBaseURL   = YES;
        
    self.lblText.text=[@"It seems like there is no record to\n display." myModification];
    
    //DashboardChildPackageFeature *packageFeature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"contact"];
    if ([contact_package_id isEqualToString:@"1"])
    {
        //if(packageFeature.is_time_based == 1 || packageFeature.is_count_based == 1)
            //[self showPremiumBanner:YES];
       // else
            //[self showPremiumBanner:NO];
        
        [self showPremiumAlert];
    }
    else
    {
        [self addPullRefresh];
        [self loadContacts];
        [self showPremiumFeatureView:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)showPremiumAlert
{
    [SwiftFTUtils showSwiftPremiumPopupOn:self];
}


-(void)updateUI{
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        imgView.hidden=NO;
        contentLbl.hidden=NO;
        self.view.backgroundColor = [UIColor whiteColor];
        
        self.contactImage.hidden=YES;
        self.lblText.hidden=YES;
    }
    if (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width) == 667))
    {
        imgView.hidden=NO;
        contentLbl.hidden=NO;
        self.view.backgroundColor = [UIColor whiteColor];
        
        self.contactImage.hidden=YES;
        self.lblText.hidden=YES;
    }
    else if (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width) == 736))
    {
        imgView.hidden=NO;
        contentLbl.hidden=NO;
        self.view.backgroundColor = [UIColor whiteColor];
        
        self.contactImage.hidden=YES;
        self.lblText.hidden=YES;
    }
    
    
    if(self.dataSource.count ==0)
    {
        _tableView.hidden=YES;
    }
}

#pragma mark Places
-(void) loadContacts
{
    [SwiftFTUtils showHUDAddedTo:self.view withText:@"Loading..." animated:YES];
    
    
    //---MESH2 IMPLEMENTATION---//
    NSString *url = isBaseURL ? baseURL : nextPageURL;

    NSLog(@"url to load contacts = %@", url);
    
    [[ApiManager shared] mesh2_commonGetApiWithVC:self andUrl:url withResponse:^(id  _Nonnull json) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            NSLog(@"json response = %@",json);
            
            NSError *error;
            NSString *msg = [json valueForKey:@"message"] == nil ? [kErrorGeneral myModification] : [json valueForKey:@"message"];
            // read response code
            if([[json valueForKey:@"status"] intValue] == 200)
            {
                
                AllContactsModel *mainModel = [[AllContactsModel alloc] initWithDictionary:json error:&error];
                self.watchlistCount = 0;
                for (ContactsModel *model in mainModel.contacts.data)
                {
                    if (model.is_watched == 1)
                        self.watchlistCount += 1;
                }
                NSLog(@"contacts count = %lu",(unsigned long)mainModel.contacts.data.count);
                
                if (mainModel.contacts.next_page_url != NULL)
                    nextPageURL = mainModel.contacts.next_page_url;
                else
                    nextPageURL = @"";
                
                if (isBaseURL)
                    self.dataSource = [NSMutableArray arrayWithArray:mainModel.contacts.data];
                else
                    [self.dataSource addObjectsFromArray:[NSMutableArray arrayWithArray:mainModel.contacts.data]];
                
                
                [self viewDidDisappear:YES];
                [self refreshTable];
            }
            else
                [CommonModel showAlert:[@"Error!" myModification] msg:msg];
            
            
            self.contactImage.hidden = NO;
            self.lblText.hidden = NO;
            
            [self updateUI];
        });
    }];
    
    
    
    //---OLD IMPLEMENTATION---//
    
    /*
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:delegate.selectedDashboardChild.child_id],@"child_id", nil];
    [JSONHTTPClient postJSONFromURLWithString:KContacts
                                       params:params
                                   completion:^(id json, JSONModelError *err) {
                                       NSError *error;
                                       NSString *msg = [json valueForKey:@"message"] == nil ? [kErrorGeneral myModification] : [json valueForKey:@"message"];
                                       // read response code
                                       if([[json valueForKey:@"response"] intValue]== 200)
                                       {
                                           NSLog(@"%@",json);
                                           AllContactsModel *contacts = [[AllContactsModel alloc] initWithDictionary:json error:&error];
                                           self.watchlistCount = 0;
                                           for (ContactsModel *model in contacts.data)
                                           {
                                               if (model.is_watched == 1)
                                                   self.watchlistCount += 1;
                                           }
                                           NSLog(@"%@",contacts);
                                           
                                           self.dataSource = [NSMutableArray arrayWithArray:contacts.data];
                                           [self viewDidDisappear:YES];
                                       }
                                       else
                                       {
                                           [CommonModel showAlert:[@"Error!" myModification] msg:msg];
                                       }
                                       [self refreshTable];
                                       self.contactImage.hidden=NO;
                                       self.lblText.hidden=NO;
                                       
                                       if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                                       {
                                           imgView.hidden=NO;
                                           contentLbl.hidden=NO;
                                           self.view.backgroundColor = [UIColor whiteColor];
                                           
                                           self.contactImage.hidden=YES;
                                           self.lblText.hidden=YES;
                                       }
                                       if (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width) == 667))
                                       {
                                           imgView.hidden=NO;
                                           contentLbl.hidden=NO;
                                           self.view.backgroundColor = [UIColor whiteColor];
                                           
                                           self.contactImage.hidden=YES;
                                           self.lblText.hidden=YES;
                                       }
                                       else if (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width) == 736))
                                       {
                                           imgView.hidden=NO;
                                           contentLbl.hidden=NO;
                                           self.view.backgroundColor = [UIColor whiteColor];
                                           
                                           self.contactImage.hidden=YES;
                                           self.lblText.hidden=YES;
                                       }
                                       
                                       
                                       if(self.dataSource.count ==0)
                                       {
                                           _tableView.hidden=YES;
                                       }
                                       [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                   }];
     */
}

#pragma mark - QBRefreshControlDelegate
-(void) addPullRefresh
{
    refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshControlAction) forControlEvents:UIControlEventValueChanged];
}

-(void)refreshControlAction{
    isBaseURL = YES;
    [self loadContacts];
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
    
    ContactCells *cell = (ContactCells *)[tableView dequeueReusableCellWithIdentifier:@"ContactCells"];
    
    if (cell == nil) {
        cell = (ContactCells *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ContactCells"];
    }
    ContactsModel *contact =  [self.dataSource objectAtIndex:indexPath.row] ;
    cell.name.text = contact.name;

    if (contact.phone_mobile !=nil)
    {
        cell.mobile.text = [NSString stringWithFormat:@"%@ %@",[@"Mobile:" myModification],contact.phone_mobile];
    }
    else
    {
        if (contact.phone_work !=nil) {
            cell.mobile.text = [NSString stringWithFormat:@"%@ %@",[@"Work:" myModification],contact.phone_work];
        }
        else if (contact.phone_home!=nil)
        {
            cell.mobile.text = [NSString stringWithFormat:@"%@ %@",[@"Home:" myModification],contact.phone_home];
        }
        else
        {
            cell.mobile.text=[NSString stringWithFormat:@"%@",[@"Phone: Not Available" myModification]];
        }
    }
    
    if (contact.email !=nil)
    {
        cell.email.text = [NSString stringWithFormat:@"%@: %@",[@"Email" myModification],contact.email];
    }
    else
    {
        cell.email.text = [NSString stringWithFormat:@"%@: Not Available",[@"Email" myModification]];
    }
     [cell.contactImage setTitle:[[NSString stringWithFormat:@"%c",[contact.name characterAtIndex:0]] uppercaseString] forState:UIControlStateNormal];
    NSString *contactImgName =[NSString stringWithFormat:@"call_circ_%i.png",(int)indexPath.row%4 + 1 ];
     [cell.contactImage setBackgroundImage:[UIImage imageNamed:contactImgName] forState:UIControlStateNormal];
    [cell.contactImage setTitleColor:[self.contactColors objectAtIndex:indexPath.row %4] forState:UIControlStateNormal];
    if(contact.is_watched)
        [cell.add  setImage:[UIImage imageNamed:@"blacklist_select.png"] forState:UIControlStateNormal];
    else{
        [cell.add  setImage:[UIImage imageNamed:@"blacklist_unselect.png"] forState:UIControlStateNormal];
        
    }

    cell.add.tag = indexPath.row;
   
    //[cell.add addTarget:self action:@selector(addContactToWatchList:) forControlEvents:UIControlEventTouchUpInside];
    if([SwiftFTUtils isDeviceiPhoneFamily])
    {
        cell.name.font = [UIFont fontWithName:@"OpenSans" size:17];
        cell.mobile.font = [UIFont fontWithName:@"OpenSans" size:14];
        cell.email.font = [UIFont fontWithName:@"OpenSans" size:14];
    }
    
    if([delegate.selectedDashboardChild.device isEqualToString:@"iphone"])
        cell.add.hidden = YES;
    else
        cell.add.hidden = NO;
    //ADDED TEMPORARILY: FAHAD
    cell.add.hidden = YES;
    [self viewDidDisappear:YES];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView
{
    NSArray *visibleRows = [self.tableView visibleCells];
    UITableViewCell *lastVisibleCell = [visibleRows lastObject];
    NSIndexPath *path = [self.tableView indexPathForCell:lastVisibleCell];
    if(path.section == 0 && path.row == self.dataSource.count - 1)
    {
        NSLog(@"load more cells");
        // Do something here
        if (nextPageURL.length > 0)
        {
            isBaseURL = NO;
            [self loadContacts];
        }
    }
}

#pragma mark Edit Place

//---SANA CHANGE---//---REMOVE DELETE CONTACT FUNCTIONALITY---//


//-(void)editContacts:(UIButton *) sender;
//{
//    [self.tableView setEditing:!self.tableView.isEditing];
//}
//-(void)addtoWatchList:(int) index;
//{
//
//}


//-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}
//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if(editingStyle == UITableViewCellEditingStyleDelete)
//        [self deletContact:(int)indexPath.row];
//
//    NSLog(@"apply changes");
//}

//-(void)deletContact:(int)index
//{
//    //delete place
//    ContactsModel *contact =  [self.dataSource objectAtIndex:index];
//    NSDictionary *params = @{@"id":contact.contact_id};
//    [SwiftFTUtils showHUDAddedTo:self.view withText:@"Deleting..." animated:YES];
//
//    [JSONHTTPClient postJSONFromURLWithString:@"" //KDeleteContacts
//                                       params:params
//                                   completion:^(id json, JSONModelError *err) {
//                                       if([[json valueForKey:@"response"] intValue] == 200){
//                                           [self.dataSource removeObjectAtIndex:index];
//                                           [self loadContacts];
//                                       }
//                                       [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                                   }];
//}


//---REMOVED THIS FUNCTIONALITY IN THIS SCREEN---//

/*
 
#pragma mark delet Place


- (void)addContactToWatchList:(UIButton *)sender
{
        ContactsModel *model = [self.dataSource objectAtIndex:sender.tag];
        NSDictionary *params;
        NSString *url = model.is_watched == 1 ? KRemoveContactFromWatchList : KAddContactToWatchList;
    
        if (model.is_watched == 1)
        {
            [SwiftFTUtils showHUDAddedTo:self.view withText:@"Removing..." animated:YES];
            params = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:delegate.selectedDashboardChild.child_id],@"child_id",model.contact_id,@"id", nil];
            NSLog(@"%@",params);
            
            [JSONHTTPClient postJSONFromURLWithString:url
                                               params:params
                                           completion:^(id json, JSONModelError *err)
             {
                 if([[json valueForKey:@"response"] intValue] == 200)
                 {
                     NSLog(@"%@",json);
                     model.is_watched = !model.is_watched;
                     NSLog(@"%@",params);
                     [self.tableView reloadData];
                     [self loadContacts];
                 }
                 else
                     [CommonModel showAlert:@"Error!" msg:[json valueForKey:@"message"]];
                 
                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             }];
        }
    else
    {
        DashboardChildPackageFeature *packageFeature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"contactwatchlist"];
        if (packageFeature.is_count_based == 1)
        {
            if (self.watchlistCount < [packageFeature.count_limit integerValue])
            {
                [SwiftFTUtils showHUDAddedTo:self.view withText:@"Adding..." animated:YES];
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:@[[NSNumber numberWithInt:model.contact_id.intValue]] options:0 error:nil];
                NSString* jsonString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
                
                params = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:delegate.selectedDashboardChild.child_id],@"child_id",jsonString,@"ids", nil];
                
                [JSONHTTPClient postJSONFromURLWithString:url
                                                   params:params
                                               completion:^(id json, JSONModelError *err)
                 {
                     if([[json valueForKey:@"response"] intValue] == 200)
                     {
                         NSLog(@"%@",json);
                         model.is_watched = !model.is_watched;
                         NSLog(@"%@",params);
                         
                         [self.tableView reloadData];
                         [self loadContacts];
                     }
                     else
                         [CommonModel showAlert:@"Error!" msg:[json valueForKey:@"message"]];
                     
                     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                 }];
            }
            else
            {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                
//                NSString *popupTitle = @"Limit Exceeded!\n";
//                NSString *firstParagraph = [NSString stringWithFormat:@"\nThe Contact Watchlist limit is exceeded; You can add only %@ Contact with free subscription.\n", packageFeature.count_limit];
//                NSString *firstTitle = @"";
//                NSString *firstDetails = @"\nUpgrade each child device to premium for a small monthly fee and get ultimate parenting satisfaction.";
//                NSString *secondTitle = @"\n";
//                NSString *secondDetails = @"\nPlease login to your web Dashbord to upgrade the subscription and unrestricted access.";
//                [SwiftFTUtils showPremiumPopupWith:self title:popupTitle firstParagraph:firstParagraph firstTitle:firstTitle firstDetails:firstDetails secondTitle:secondTitle secondDetails:secondDetails imageName:@"ic_premium" color:@"orange"];
                [SwiftFTUtils showSwiftPremiumPopupOn:self];
            }
        }
        else
        {
            [SwiftFTUtils showHUDAddedTo:self.view withText:@"Adding..." animated:YES];
            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:@[[NSNumber numberWithInt:model.contact_id.intValue]] options:0 error:nil];
            NSString* jsonString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
            
            params = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:delegate.selectedDashboardChild.child_id],@"child_id",jsonString,@"ids", nil];
            
            [JSONHTTPClient postJSONFromURLWithString:url
                                               params:params
                                           completion:^(id json, JSONModelError *err)
             {
                 if([[json valueForKey:@"response"] intValue] == 200)
                 {
                     NSLog(@"%@",json);
                     model.is_watched = !model.is_watched;
                     NSLog(@"%@",params);
                     
                     [self.tableView reloadData];
                     [self loadContacts];
                 }
                 else
                     [CommonModel showAlert:[@"Error!" myModification] msg:[[json valueForKey:@"message"] myModification]];
                 
                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             }];
        }
    }
}

*/
@end
