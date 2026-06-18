//
//  CallLogsViewController.m
//  FamilyTime
//
//  Created by Sora Code on 12/19/14.
//  Copyright (c) 2014 SoraCode. All rights reserved.
//

#import "CallLogsViewController.h"
#import "MBProgressHUD.h"
//#import "JSONHTTPClient.h"
#import "AppDelegate.h"
//#import <Google/Analytics.h>
#import "FTUtils.h"
#import "NSString+LockMustafa.h"
#import "FamilyTime-Swift.h"


#define iPhone6 ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width) == 667)
#define iPhone6Plus ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width) == 736)

AppDelegate *delegate;
UIRefreshControl *  refreshControl;

@interface CallLogsViewController ()
@property (nonatomic, assign) BOOL isPopupAppeared;
@end

@implementation CallLogsViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
//    [ZendeskChatManager trackEvent:@"Call History"];
    _lblText.text=[_lblText.text myModification];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:[@"Call History" myModification]];
    self.isPopupAppeared = NO;
    delegate = [AppDelegate appDelegate];
    [self.tableView registerNib:[UINib nibWithNibName:@"CallCell" bundle:nil] forCellReuseIdentifier:@"callCell"];
    self.contactImage.hidden=YES;
    self.lblText.hidden=YES;

    self.tableView.rowHeight = 80;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    self.contactColors = KCallColor;
    [self addPullRefresh];
//    [self loadCallLogs];
     self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    
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
    if (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone))
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
    [self loadCallLogs];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    DashboardChildPackageFeature *packageFeature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"call"];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - QBRefreshControlDelegate
-(void) addPullRefresh
{
//    [self hereloaddd];
    refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(loadCallLogs) forControlEvents:UIControlEventValueChanged];
    
}
- (void)refreshTable
{
    [refreshControl endRefreshing];
    [self.tableView reloadData];
}

#pragma mark Places
-(void) loadCallLogs
{
//    [self hereloaddd];

    [SwiftFTUtils showHUDAddedTo:self.view withText:@"Loading..." animated:YES];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:delegate.selectedDashboardChild.child_id],@"child_id", nil];
    NSLog(@"%@",params);
    
    /*
    
    
    [JSONHTTPClient postJSONFromURLWithString:KCallLogs
                                       params:params
                                   completion:^(id json, JSONModelError *err) {
                                       NSError *error;
                                        NSString *msg = [json valueForKey:@"message"] == nil ? [kErrorGeneral myModification]: [json valueForKey:@"message"];
                                       // read response code
                                       if([[json valueForKey:@"response"] intValue]== 200)
                                       {
                                           [self viewDidDisappear:YES];

                                           AllCallLogsModel *logs = [[AllCallLogsModel alloc] initWithDictionary:json error:&error];
                                           NSLog(@"%@",logs);
                                           self.dataSource = [[NSMutableArray alloc]init];
                                           self.dataSource = [NSMutableArray arrayWithArray:logs.data];
                                           
                                           if([self.dataSource count]==0)
                                           {
                                               
                                               [self.contactImage removeFromSuperview];
                                               [self.lblText removeFromSuperview];

                                               _tableView.hidden=YES;
                                               
                                               [self hereloaddd];
                                           }
                                           else
                                           {
                                           _tableView.hidden=NO;
                                           [self.contactImage setHidden:YES];
                                           [self.lblText setHidden:YES];
                                           }
                                       }
                                       else
                                       {
                                           [CommonModel showAlert:@"Error!" msg:msg];
                                           _tableView.hidden=YES;

                                           [self.contactImage removeFromSuperview];
                                           [self.lblText removeFromSuperview];
                                           
                                           _tableView.hidden=YES;
                                           [self hereloaddd];
                                       }

                                       [self refreshTable];
                                       [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                   }];
    
    
    */
    
    //---NATIVE API CALLING---//
    
   
    
    NSString *paramsStr = [NSString stringWithFormat:@"%ld/%d", (long)delegate.selectedDashboardChild.child_id,60];
    
    NSString *url = @"";
    
        
       url = [KCallLogs stringByAppendingString:paramsStr];
    
     NSLog(@"CallLogs = %@", url);
   
    
    [[ApiManager shared] mesh_getApiWithApi:url withResponse:^(NSDictionary * _Nonnull json, NSInteger errorCode, NSString * _Nonnull message)
     {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"CALL history api response = %@", json);
            
            
            NSError *error;
            NSString *msg = [json valueForKey:@"message"] == nil ? [kErrorGeneral myModification]: [json valueForKey:@"message"];
            // read response code
            if([[json valueForKey:@"status"] intValue]== 200)
            {
                [self viewDidDisappear:YES];
                
                AllCallLogsModel *logs = [[AllCallLogsModel alloc] initWithDictionary:json error:&error];
                NSLog(@"%@",logs);
                self.dataSource = [[NSMutableArray alloc]init];
                self.dataSource = [NSMutableArray arrayWithArray:logs.callhistory];
                
                if([self.dataSource count]==0)
                {
                    
                    [self.contactImage removeFromSuperview];
                    [self.lblText removeFromSuperview];
                    
                    _tableView.hidden=YES;
                    
                    [self hereloaddd];
                }
                else
                {
                    _tableView.hidden=NO;
                    [self.contactImage setHidden:YES];
                    [self.lblText setHidden:YES];
                }
            }
            else
            {
                [CommonModel showAlert:@"Error!" msg:msg];
                _tableView.hidden=YES;
                
                [self.contactImage removeFromSuperview];
                [self.lblText removeFromSuperview];
                
                _tableView.hidden=YES;
                [self hereloaddd];
            }
            
            [self refreshTable];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
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
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *firstChar ;
    CallCell *cell = (CallCell *)[tableView dequeueReusableCellWithIdentifier:@"callCell"];
    
    if (cell == nil) {
        cell = (CallCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"callCell"];
    }
    CallLogsModel *model =  [self.dataSource objectAtIndex:indexPath.row] ;
  
    if(model.name == nil || [model.name isEqualToString:@""])
    {
        cell.name.text = model.number;
        
        NSDate * now = [NSDate date];
        
        serverdate =[CommonModel date:model.call_time oldFormat:@"YYYY-MM-dd HH:mm:ss" format:@"yyyy-MM-dd HH:mm"];
        NSDateFormatter *dateFormat7 = [[NSDateFormatter alloc] init];
        
        [dateFormat7 setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSDate *date7 = [dateFormat7 dateFromString:serverdate];
        
        double timeDateDiff =[self daysBetweenDate:date7 andDate:now];
        
        int DaywithTimeDiff=(int)timeDateDiff;
        
        if (DaywithTimeDiff==0)
        {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"HH:mm"];
            
            NSString *todayDate = [formatter stringFromDate:date7];
            NSLog(@"%@",todayDate);
            
            cell.lblDate.text =todayDate;
            
        }
        else if (DaywithTimeDiff==1)
        {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"HH:mm"];
            
            NSString *yesterdayDate = [formatter stringFromDate:date7];
            NSLog(@"%@",yesterdayDate);
            
            NSString *myString = @"Yesterday, ";
            NSString *test = [myString stringByAppendingString:yesterdayDate];
            NSLog(@"%@",test);
            cell.lblDate.text =test;
        }
        else if (DaywithTimeDiff>1)
        {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MMM dd, HH:mm"];
            
            NSString *oldDate = [formatter stringFromDate:date7];
            NSLog(@"%@",oldDate);
            
            cell.lblDate.text =oldDate;
        }
        else
        {
            cell.lblDate.text=[CommonModel date:model.call_time oldFormat:@"YYYY-MM-dd HH:mm:ss" format:@"MMM dd HH:mm"];
        }
        
        firstChar = @"U";
        [self.contactImage setHidden:YES];
        [self.lblText setHidden:YES];
        self.lblText.hidden=YES;
        self.contactImage.hidden=YES;
    }
    else
    {
        NSDate * now = [NSDate date];
    
        serverdate=[CommonModel date:model.call_time oldFormat:@"YYYY-MM-dd HH:mm:ss" format:@"yyyy-MM-dd HH:mm"];
        NSDateFormatter *dateFormat7 = [[NSDateFormatter alloc] init];
        
        [dateFormat7 setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSDate *date7 = [dateFormat7 dateFromString:serverdate];
        
        double timeDateDiff=[self daysBetweenDate:date7 andDate:now];
        
        int DaywithTimeDiff=(int)timeDateDiff;
        
        if (DaywithTimeDiff==0)
        {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"HH:mm"];
            
            NSString *todayDate = [formatter stringFromDate:date7];
            NSLog(@"%@",todayDate);
            cell.lblDate.text =todayDate;
        }
        else if (DaywithTimeDiff==1)
        {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"HH:mm"];
            
            NSString *yesterdayDate = [formatter stringFromDate:date7];
            NSLog(@"%@",yesterdayDate);
            
            NSString *myString = @"Yesterday,";
            NSString *test = [myString stringByAppendingString:yesterdayDate];
            NSLog(@"%@",test);
            cell.lblDate.text =test;//[NSString stringWithFormat:@"%@, %@",model.number,test];
            cell.lblDate.text=[cell.lblDate.text myModification];
        }
        else if (DaywithTimeDiff>1)
        {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MMM dd, HH:mm"];
            
            NSString *oldDate = [formatter stringFromDate:date7];
            NSLog(@"%@",oldDate);
            
            cell.lblDate.text =oldDate;
        }
    }
    
    [cell.separator setHidden:NO];
    NSString *contactImgName =[NSString stringWithFormat:@"call_circ_%i.png",(int)indexPath.row%4 + 1 ];
    
    NSString *avatarImgName =[NSString stringWithFormat:@"avater%i.png",(int)indexPath.row%4 + 1 ];
    
    
    NSString *imgName = [model.type  isEqual:@"Received"] ? @"received_call.png" : [model.type  isEqual: @"Dialed"] ? @"dialed_call.png" : @"missed_call.png";
//    if ([model.name isEqualToString:@""])
//    {
//        cell.name.text=model.number;
//        cell.lblCallNumber.text=@"Unsaved";
//        
//        [cell.callType setBackgroundImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
//        
//        [cell.contactImage setBackgroundImage:[UIImage imageNamed:avatarImgName] forState:UIControlStateNormal];
//        cell.lblCallDuration.text=model.duration;
//        [cell.contactImage setTitleColor:[self.contactColors objectAtIndex:indexPath.row %4] forState:UIControlStateNormal];
//        cell.btnBlackList.hidden=YES;
//    }

    if ([model.name isEqualToString:@"Unknown"])
    {
        cell.name.text=model.number;
        cell.lblCallNumber.text=@"Unsaved";
        
        [cell.callType setBackgroundImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
        
        [cell.contactImage setBackgroundImage:[UIImage imageNamed:avatarImgName] forState:UIControlStateNormal];
        cell.lblCallDuration.text=model.duration;
         [cell.contactImage setTitleColor:[self.contactColors objectAtIndex:indexPath.row %4] forState:UIControlStateNormal];
        cell.btnBlackList.hidden=YES;
    }
    else
    {
        cell.name.text=model.name;
        cell.lblCallNumber.text=model.number;
        
        [cell.callType setBackgroundImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
        
        [cell.contactImage setBackgroundImage:[UIImage imageNamed:contactImgName] forState:UIControlStateNormal];
        cell.lblCallDuration.text=model.duration;
        cell.lblCallDuration.text=model.duration;

        NSString *phoneName=[[NSString stringWithFormat:@"%@",model.name]uppercaseString];
        
        firstChar = [NSString stringWithFormat:@"%c",[phoneName characterAtIndex:0]];
        int ahm=indexPath.row %4;
        UIColor *col= [self.contactColors objectAtIndex:ahm];
        
        [cell.contactImage setTitleColor:col forState:UIControlStateNormal];
        cell.btnBlackList.hidden=NO;
    }

    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];

    if([firstChar isEqualToString:@"("])
    {
        cell.name.text=@"Unknown";
        NSString *avatarImgName2 =[NSString stringWithFormat:@"avater%i.png",(int)indexPath.row%4 + 1 ];

        [cell.contactImage setBackgroundImage:[UIImage imageNamed:avatarImgName2] forState:UIControlStateNormal];
        [cell.contactImage setTitle:@"" forState:UIControlStateNormal];
    }
    else if ([firstChar rangeOfCharacterFromSet:notDigits].location == NSNotFound)
    {
        NSString *avatarImgName2 =[NSString stringWithFormat:@"avater%i.png",(int)indexPath.row%4 + 1 ];
        
        [cell.contactImage setBackgroundImage:[UIImage imageNamed:avatarImgName2] forState:UIControlStateNormal];
        [cell.contactImage setTitle:@"" forState:UIControlStateNormal];
        
        
            // newString consists only of the digits 0 through 9
    }
    else
    {
    [cell.contactImage setTitle:firstChar forState:UIControlStateNormal];
    }

    [cell.btnBlackList addTarget:self
               action:@selector(buttonClicked:)forControlEvents:UIControlEventTouchUpInside];
     
      cell.btnBlackList.tag = indexPath.row;

    //we are hiding this button for now unleass we resolve the API issue of adding it into watchlist and remove from watchlist, because contact_id is coming null form server in all cases.
    cell.btnBlackList.hidden = YES;
    return cell;
}

-(void) buttonClicked:(UIButton*)sender
{
    if ([sender isSelected])
    {
        [sender setImage:[UIImage imageNamed:@"blacklist_unselect.png"]
                forState:UIControlStateNormal];
        [sender setSelected:NO];
    }
    else
    {
        [sender setImage:[UIImage imageNamed:@"blacklist_select.png"]
                forState:UIControlStateSelected];
        [sender setSelected:YES];
        
        //[self addContactToWatchList:sender];
    }
}

- (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay
                                               fromDate:fromDate toDate:toDate options:0];
    return [difference day];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    [self editPlace:indexPath.row];
}

-(void)addContactToWatchList:(UIButton *)sender
{
    CallLogsModel *model = [self.dataSource objectAtIndex:sender.tag];
    [SwiftFTUtils showHUDAddedTo:self.view withText:[@"Adding..." myModification] animated:YES];
    NSDictionary *params = @{@"id" : model.contact_id,@"child_id" : [NSNumber numberWithInteger:delegate.selectedDashboardChild.child_id]};
//    [JSONHTTPClient postJSONFromURLWithString:KAddContactToWatchList
//                                       params:params
//                                   completion:^(id json, JSONModelError *err) {
//                                       //    NSError *error;
//                                       // read response code
//                                       if([[json valueForKey:@"response"] intValue] == 200){
//                                           //model.is_watched = 1;
//                                           [self.tableView reloadData];
//                                       }
//                                       else
//                                           [CommonModel showAlert:[@"Error!" myModification] msg:[json valueForKey:@"message"]];
//                                       
//                                       [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                                   }];
}
-(void)hereloaddd
{
//    self.isPopupAppeared = NO;
//    delegate = [AppDelegate appDelegate];
//    [self.tableView registerNib:[UINib nibWithNibName:@"CallCell" bundle:nil] forCellReuseIdentifier:@"callCell"];
//    self.contactImage.hidden=YES;
//    self.lblText.hidden=YES;
    
//    self.tableView.rowHeight = 80;
//    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
//    self.contactColors = KCallColor;

    [refreshControl endRefreshing];

    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(236, 229,296,212)];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.image = [UIImage imageNamed:@"ipad_empty"];
        imgView.hidden=NO;
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
        contentLbl.hidden=NO;
        [self.view addSubview:contentLbl];
        [self.view bringSubviewToFront:contentLbl];
    }
    if (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone))
    {
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(115, 152,145,104)];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.image = [UIImage imageNamed:@"ic_empty"];
        imgView.hidden=NO;
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
        contentLbl.hidden=NO;
        [self.view addSubview:contentLbl];
        [self.view bringSubviewToFront:contentLbl];
    }
}

@end
