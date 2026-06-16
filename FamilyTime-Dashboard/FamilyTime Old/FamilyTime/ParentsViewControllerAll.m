//
//  AppUsageViewController.m
//  FamilyTime - Dashboard
//
//  Created by Ahmad on 8/21/17.
//  Copyright © 2017 SoraCode. All rights reserved.
//

//
//  AppUsageViewController.m
//  FamilyTime - Dashboard
//
//  Created by Ahmad on 8/21/17.
//  Copyright © 2017 SoraCode. All rights reserved.
//

#import "ParentsViewControllerAll.h"
#import "NSString+LockMustafa.h"

#import "MBProgressHUD.h"
//#import "JSONHTTPClient.h"
#import "FTUtils.h"
#import "DataModel.h"
#import "Constant.h"
#import "CommonModel.h"
#import "AppDelegate.h"
#import "Constant.h"

#import "NSString+LockMustafa.h"
#import "InviteCoparentViewController.h"
#import "FamilyTime-Swift.h"

AppDelegate *delegate;
UIRefreshControl *  refreshControl;

@interface ParentsViewControllerAll ()

@end

@implementation ParentsViewControllerAll 

BOOL canRefresh = TRUE;


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    
//    [ZendeskChatManager trackEvent:@"Parents Screen"];
    
    
    _rowDic=[NSMutableDictionary new];
    _Array1=[NSMutableArray new];
    _Array=[NSMutableArray new];
   
    
    //    self.tableView.hidden=NO;
    _arrOfBasicInfoImages=[NSMutableArray new];
    
    _arrOfBasicInfoData=[NSMutableArray new];
    
    [_arrOfBasicInfoImages addObject:@"p_name"];
    [_arrOfBasicInfoImages addObject:@"p_email"];
    [_arrOfBasicInfoImages addObject:@"p_phone"];
    [_arrOfBasicInfoImages addObject:@"p_relation"];
    
    [self viewParentdata];
    
    //    [self refreshTableView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self refreshTableView];
    
    
    //    [self.tableView setHidden:YES];
    _tableView.hidden=YES;
    
    checkpermissionInviteParent=0;
    
    //    [_arrOfBasicInfoData addObject:@"John"];
    //    [_arrOfBasicInfoData addObject:@"john453@gmail.com"];
    //    [_arrOfBasicInfoData addObject:@"+1 6756789"];
    //    [_arrOfBasicInfoData addObject:@"Father"];
    
    
    //    [self viewParentdata];
    
    
    //   self.tableView.layer
    //    [self.tableView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    //    [self.tableView.layer setBorderWidth:1.0f];
    //
    [_topView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [_topView.layer setBorderWidth:1.0f];
    
    
    
    _lblTotalMinutes.adjustsFontSizeToFitWidth=YES;
    
    IndexOfDate=0;
    
    self.title=[@"Parents" myModification];
    
    _rowArr=[NSMutableArray new];
    //    delegate = [AppDelegate appDelegate];
    //    [self.tableView registerNib:[UINib nibWithNibName:@"AppUsageTableViewCell" bundle:nil] forCellReuseIdentifier:@"AppUsageCell"];
    
    
    
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
    else if(([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone))
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
        contentLbl.text=[@"It seems like there is no record to\n display." myModification] ;
        contentLbl.font=[UIFont systemFontOfSize:17];
        contentLbl.lineBreakMode = NSLineBreakByWordWrapping;
        contentLbl.numberOfLines = 2;
        contentLbl.textAlignment = NSTextAlignmentCenter;
        contentLbl.hidden=YES;
        [self.view addSubview:contentLbl];
        [self.view bringSubviewToFront:contentLbl];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//-(void) loadAllAppUsageOfChild
//{
//    //    if(self.dates.count == 0)
//    //  /      return;
//
//    //set first last date in between next prev button
//    //    NSString *date  = [CommonModel date:[self.dates objectAtIndex:self.page] oldFormat:@"YYYY-MM-dd HH:mm:ss" format:@"EEE, MMM d, yyyy"];//d EEE,MMM yy
//    //    [self.locDate setText:date];
//    [SwiftFTUtils showHUDAddedTo:self.view withText:[@"Loading..." myModification] animated:YES];
//
//
//    //   NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:delegate.selectedDashboardChild.child_id],@"child_id",pDate,@"date", nil];
//
//
//    NSString *str= [NSString stringWithFormat:@"%ld",(long)delegate.selectedDashboardChild.child_id];
//
//
//    NSLog(@"greattt--%ld",(long)delegate.selectedDashboardChild.child_id);
//    //NSString *str= @"96685";
//    NSString *strCompleteUrl=[NSString stringWithFormat:@"%@/v2/ftd/appusage/list/%@/2017-08-03",kBasUrl,str];
//
//    NSLog(@"URL==%@",strCompleteUrl);
//    //@"https://mesh.familytime.io/v2/push/familytimemap/65279"
//    [JSONHTTPClient getJSONFromURLWithString:strCompleteUrl
//                                      params:[NSDictionary new]
//                                  completion:^(id json, JSONModelError *err) {
//                                      //                                      NSError *error;
//                                      NSLog(@"%@",json);
//
//
//                                      if([[json objectForKey:@"status_message"]isEqualToString:@"OK"])
//                                      {
//                                          _rowArr=[json objectForKey:@"response"];
//
//                                          int k=0;
//                                          for(int o=0;o<_rowArr.count;o++)
//                                          {
//                                              k= [[[_rowArr objectAtIndex:o] objectForKey:@"app_usage"] intValue]+k;
//
//                                          }
//                                          NSLog(@"Here is total seconds=%i",k);
//
//
//
//                                          TotalTime=k;
//                                          _lblTotalMinutes.text=[NSString stringWithFormat:@"%.1f minutes",k/60.0];
//
//                                          [_tableView reloadData];
//
//                                      }
//
//
//                                      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                                  }];
//
//
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(section==0)
    {
        return [_Array count];
        //        return 2.0;
        
    }
    else if(section==1)
    {
        return [_Array1 count];
        
        //        return 3.0;
    }
    else
    {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
   
    if(indexPath.section==0)
    {
        //---DEPRICATED---MESH2---HIDE SUPER PARENT INFO---ONLY SHOW CO PARENTS---//---1/4---//
        ///*
        if(indexPath.row==0)
        {
            //            is_super_parent
            
            static NSString *simpleTableIdentifier;
            
            //             int superParentt= [[[[_rowDic objectForKey:@"active"]objectAtIndex:indexPath.row]objectForKey:@"is_super_parent"] intValue];
            //            if(superParentt==1)
            //                simpleTableIdentifier = @"ActiveParentPersonal";
            //            else
            //                simpleTableIdentifier = @"ActiveParent";
            
            simpleTableIdentifier = @"ActiveParentPersonal";
            
            
            cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
            }
            
            
            UILabel *LabelTitle = (UILabel*)[cell viewWithTag:1];
            UILabel *LabelSubTitle = (UILabel*)[cell viewWithTag:2];
            
            UILabel *Label31 = (UILabel*)[cell viewWithTag:31];
            UILabel *Label32 = (UILabel*)[cell viewWithTag:32];
            UILabel *Label33 = (UILabel*)[cell viewWithTag:33];
            UILabel *Label34 = (UILabel*)[cell viewWithTag:34];
            
            Label31.text=[Label31.text myModification];
            Label32.text=[Label32.text myModification];
            Label33.text=[Label33.text myModification];
            Label34.text=[Label34.text myModification];
            
            //        UIButton *btnRemoveFromfamily = (UIButton*)[cell viewWithTag:5];
            
            
            UISwitch *switch1 = (UISwitch*)[cell viewWithTag:6];
            UISwitch *switch2 = (UISwitch*)[cell viewWithTag:7];
            UISwitch *switch3 = (UISwitch*)[cell viewWithTag:8];
            UISwitch *switch4 = (UISwitch*)[cell viewWithTag:9];
            
            [switch1 addTarget:self action:@selector(Switch1:) forControlEvents:UIControlEventValueChanged];
            [switch2 addTarget:self action:@selector(Switch2:) forControlEvents:UIControlEventValueChanged];
            [switch3 addTarget:self action:@selector(Switch3:) forControlEvents:UIControlEventValueChanged];
            [switch4 addTarget:self action:@selector(Switch4:) forControlEvents:UIControlEventValueChanged];
            
            
            
            UIImageView *imgview = (UIImageView*)[cell viewWithTag:10];
            //            if ([[delegate.parent.relationship lowercaseString] isEqualToString:@"mother"])
            //            {
            //                //in_parent_m
            //                imgview.image = [UIImage imageNamed:@"in_parent_f"];
            //            }
            //            else
            //            {
            //                imgview.image = [UIImage imageNamed:@"in_parent_m"];
            //            }
            
            UIView *vwBottt = (UIView*)[cell viewWithTag:22];
            
            if([_Array count]==1)
            {
                vwBottt.hidden=YES;
            }
            else
            {
                vwBottt.hidden=NO;
            }
            if([_Array1 count]==0)
            {
                vwBottt.hidden=YES;
            }
            else
            {
                vwBottt.hidden=NO;
            }
            
            
            if([vwBottt isHidden]==YES)
            {
                UIView *viewBottom = [[UIView alloc] initWithFrame:CGRectMake(0, 336, tableView.frame.size.width, 1)];
                viewBottom.backgroundColor=[UIColor colorWithRed:200.0/255.0 green:199.0/255.0
                                                            blue:204.0/255.0 alpha:1.0];
                [cell addSubview:viewBottom];
            }
            
            NSDictionary *dic = [_Array objectAtIndex:indexPath.row];
            
            NSLog(@"%@", dic);
            
            NSString *strgender = [dic valueForKey:@"gender"];
            
            if([strgender isEqualToString:@"female"])
            {
                imgview.image = [UIImage imageNamed:@"in_parent_f"];
            }
            else
            {
                imgview.image = [UIImage imageNamed:@"in_parent_m"];
            }
            
            //---SANA CHANGE---//---ADD STROKE TO PARENT ICON---//
            imgview.layer.borderColor  = [[UIColor lightGrayColor] CGColor];
            imgview.layer.borderWidth  = 1.0;
            imgview.layer.cornerRadius = imgview.frame.size.width / 2;
            
            if( [[NSUserDefaults standardUserDefaults]objectForKey:@"ParentRelationship"]==nil)
            {
                
            }
            else
            {
                //---SANA CHANGE---//
                if ([[delegate.parent.relationship lowercaseString] isEqualToString:NSLocalizedString(@"Mother",nil)])
                {
                    imgview.image = [UIImage imageNamed:@"parent_profile_f"];
                }
                else
                {
                    imgview.image = [UIImage imageNamed:@"parent_profile_m"];
                }
            }
            
            //        [btnRemoveFromfamily addTarget:self action:@selector(RemoveActiveFamily:) forControlEvents:UIControlEventTouchUpInside];
            //
            //            [btnRemoveFromfamily setHidden:YES];
            
            //        switch1.state=1;
            
            if([dic objectForKey:@"settings"]!=[NSNull null])
            {
                
                switch1.on= [[[[dic objectForKey:@"settings"] objectAtIndex:0]objectForKey:@"status"] intValue];
                
                switch2.on= [[[[dic objectForKey:@"settings"] objectAtIndex:1]objectForKey:@"status"] intValue];
                
                switch3.on= [[[[dic objectForKey:@"settings"] objectAtIndex:2]objectForKey:@"status"] intValue];
                
                switch4.on= [[[[dic objectForKey:@"settings"] objectAtIndex:3]objectForKey:@"status"] intValue];
            }
            //
            //            LabelTitle.text=@"Nicolas ka";
            //            LabelSubTitle.text=@"nicolas@gmail.com";
            LabelTitle.text=  [dic objectForKey:@"name"];
            
            LabelSubTitle.text=  [dic objectForKey:@"email"];
        }
        else
        {
        
         //---DEPRICATED---MESH2---HIDE SUPER PARENT INFO---ONLY SHOW CO PARENTS---//---2/4---//
         
         //*/
        
        
            NSDictionary *dic = [_Array objectAtIndex:indexPath.row];
            static NSString *simpleTableIdentifier = @"ActiveParent";
            
            cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
            }
            
            
            UILabel *LabelTitle = (UILabel*)[cell viewWithTag:1];
            UILabel *LabelSubTitle = (UILabel*)[cell viewWithTag:2];
            
            UILabel *Label31 = (UILabel*)[cell viewWithTag:31];
            UILabel *Label32 = (UILabel*)[cell viewWithTag:32];
            UILabel *Label33 = (UILabel*)[cell viewWithTag:33];
            UILabel *Label34 = (UILabel*)[cell viewWithTag:34];
        
            Label31.text=[Label31.text myModification];
            Label32.text=[Label32.text myModification];
            Label33.text=[Label33.text myModification];
            Label34.text=[Label34.text myModification];
            
            
            UIButton *btnRemoveFromfamily = (UIButton*)[cell viewWithTag:5];
            
            
            UISwitch *switch1 = (UISwitch*)[cell viewWithTag:6];
            UISwitch *switch2 = (UISwitch*)[cell viewWithTag:7];
            UISwitch *switch3 = (UISwitch*)[cell viewWithTag:8];
            UISwitch *switch4 = (UISwitch*)[cell viewWithTag:9];
            
            [switch1 addTarget:self action:@selector(Switch1:) forControlEvents:UIControlEventValueChanged];
            [switch2 addTarget:self action:@selector(Switch2:) forControlEvents:UIControlEventValueChanged];
            [switch3 addTarget:self action:@selector(Switch3:) forControlEvents:UIControlEventValueChanged];
            [switch4 addTarget:self action:@selector(Switch4:) forControlEvents:UIControlEventValueChanged];
            
            
            [btnRemoveFromfamily addTarget:self action:@selector(RemoveActiveFamily:) forControlEvents:UIControlEventTouchUpInside];
            
            [btnRemoveFromfamily setTitle:[@"Remove From Family" myModification] forState:UIControlStateNormal];
            
            //        switch1.state=1;
         
            if( [[dic objectForKey:@"settings"] count]==0)
            {
                //          switch1.on
                
                switch1.on=NO;
                switch2.on=NO;
                switch3.on=NO;
                switch4.on=NO;
            }
            else
            {
                switch1.on= [[[[dic objectForKey:@"settings"] objectAtIndex:0]objectForKey:@"status"] intValue];
                
                switch2.on= [[[[dic objectForKey:@"settings"] objectAtIndex:1]objectForKey:@"status"] intValue];
                
                switch3.on= [[[[dic objectForKey:@"settings"] objectAtIndex:2]objectForKey:@"status"] intValue];
                
                switch4.on= [[[[dic objectForKey:@"settings"] objectAtIndex:3]objectForKey:@"status"] intValue];
            }
            //
            //            LabelTitle.text=@"Nicolas ka";
            //            LabelSubTitle.text=@"nicolas@gmail.com";
            LabelTitle.text      =   [dic objectForKey:@"name"];
            
            LabelSubTitle.text   =   [dic objectForKey:@"email"];
            
            NSString *strgender  =  [dic objectForKey:@"gender"];
            
            UIImageView *imgview = (UIImageView*)[cell viewWithTag:10];
            
            imgview.layer.borderColor  = [[UIColor lightGrayColor] CGColor];
            imgview.layer.borderWidth  = 1.0;
            imgview.layer.cornerRadius = imgview.frame.size.width / 2;
            
            if([strgender isEqualToString:@"female"])
            {
                imgview.image = [UIImage imageNamed:@"in_parent_f"];
            }
            else
            {
                imgview.image = [UIImage imageNamed:@"in_parent_m"];
            }
            
            //---DEPRICATED---MESH2---HIDE SUPER PARENT INFO---ONLY SHOW CO PARENTS---//---3/4---//---COMMENT NEXT BRACES---//
        }
        
    }
    else if(indexPath.section==1)
    {
        //       if(indexPath.row==0)
        //        {
        //            static NSString *simpleTableIdentifier = @"InactiveParent";
        //
        //            cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        //
        //            if (cell == nil) {
        //                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        //            }
        //
        //        }
        //        else
        //        {
        NSDictionary *dic = [_Array1 objectAtIndex:indexPath.row];
        static NSString *simpleTableIdentifier = @"InactiveParent";
        
        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        
        UILabel *LabelTitle = (UILabel*)[cell viewWithTag:1];
        UILabel *LabelSubTitle = (UILabel*)[cell viewWithTag:2];
        
        UIButton *btnRemoveFromfamily = (UIButton*)[cell viewWithTag:5];
        UIButton *btnResendInvitation = (UIButton*)[cell viewWithTag:6];
        
        btnRemoveFromfamily.titleLabel.text=[btnRemoveFromfamily.titleLabel.text myModification];
        btnResendInvitation.titleLabel.text=[btnResendInvitation.titleLabel.text myModification];
        
        [btnRemoveFromfamily setTitle:[@"Revoke Invitation" myModification] forState:UIControlStateNormal];
        
        [btnResendInvitation setTitle:[@"Re-Send Invitation" myModification] forState:UIControlStateNormal];
        
        
        //      UIView *vwFooter = (UIView*)[cell viewWithTag:22];
        UIView *vwFooter1 = (UIView*)[cell viewWithTag:23];
        UIView *vwFooter2 = (UIView*)[cell viewWithTag:24];
        
        
        [btnRemoveFromfamily addTarget:self action:@selector(RevokeInvitation:) forControlEvents:UIControlEventTouchUpInside];
        
        [btnResendInvitation addTarget:self action:@selector(ResendInvitationFamily:) forControlEvents:UIControlEventTouchUpInside];
        
        
        LabelTitle.text=  [dic objectForKey:@"name"];;
        LabelSubTitle.text= [dic objectForKey:@"email"];;
        
        if([LabelTitle.text isEqualToString:@""])
        {
            LabelTitle.text=[@"Unknown" myModification];
        }
        
        if(indexPath.row==([_Array1 count]-1))
        {
            //            vwFooter.backgroundColor=[UIColor groupTableViewBackgroundColor];
            vwFooter1.hidden=NO;
            vwFooter2.hidden=YES;
        }
        else
        {
            vwFooter1.hidden=NO;
            vwFooter2.hidden=NO;
        }
        
        
        UIImageView *imgview = (UIImageView*)[cell viewWithTag:10];
        imgview.image = [UIImage imageNamed:@"in_parent_m"];
        
        imgview.layer.borderColor  = [[UIColor lightGrayColor] CGColor];
        imgview.layer.borderWidth  = 1.0;
        imgview.layer.cornerRadius = imgview.frame.size.width / 2;
    }
    else if(indexPath.section==2)
    {
        
        if(indexPath.row==0)
        {
            static NSString *simpleTableIdentifier = @"InviteParent";
            
            cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
            }
            UIButton *btn1 = (UIButton*)[cell viewWithTag:1];
            
            btn1.titleLabel.text=[btn1.titleLabel.text myModification];
            
            btn1.clipsToBounds = YES;
            btn1.layer.cornerRadius=btn1.frame.size.height/2;
            
            if(checkpermissionInviteParent==5)
            {
                btn1.enabled=YES;
            }
            else
            {
                btn1.enabled=NO;
            }
            
            [btn1 setTitle:[@"Invite Parent" myModification] forState:UIControlStateNormal];
        }
    }
    else
    {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        //---DEPRICATED---MESH2---HIDE SUPER PARENT INFO---ONLY SHOW CO PARENTS---//---4/4---//
        
        if(indexPath.row==0)
        {
            return 337.0;
        }
        else
        {
            //            return 403.0-15;
            return 383.0;
        }
    }
    else if(indexPath.section==1)
        return 205.0;
    
    return 98.0;
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


-(void)dataShowAll
{
    imgView.hidden=YES;
    contentLbl.hidden=YES;
    
    _view1.hidden=NO;
    _view2.hidden=NO;
    //    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.tableView.hidden=NO;
    
    
}
-(void)NodataShow
{
    imgView.hidden=NO;
    contentLbl.hidden=NO;
    
    _view1.hidden=YES;
    _view2.hidden=YES;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.tableView.hidden=YES;
    
}

-(void)NodataShowNew
{
    imgView.hidden=NO;
    //    contentLbl.hidden=NO;
    
    _view1.hidden=NO;
    _view2.hidden=YES;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.tableView.hidden=YES;
    
}

-(IBAction)buttonNext:(id)sender
{
//    if(IndexOfDate==0)
//    {
//    }
//    else
//    {
//        IndexOfDate--;
//        [self loadAllAppUsageOfChildNew:[self.dates objectAtIndex:IndexOfDate]];
//
//    }
    
}

-(IBAction)buttonPrevious:(id)sender
{
//    if([self.dates count]-1==IndexOfDate)
//    {
//    }
//    else
//    {
//        IndexOfDate++;
//        [self loadAllAppUsageOfChildNew:[self.dates objectAtIndex:IndexOfDate]];
//    }
    
    //loadAllAppUsageOfChildNew
}
#pragma mark With parameter
//-(void) loadAllAppUsageOfChildNew:(NSString *)strDate
//{
//    NSString *date  = [CommonModel date:[self.dates objectAtIndex:IndexOfDate] oldFormat:@"YYYY-MM-dd" format:@"EEE, MMM d, yyyy"];//d EEE,MMM yy
//    [_lblDaySelected setText:date];
//
//
//
//    [SwiftFTUtils showHUDAddedTo:self.view withText:@"Loading..." animated:YES];
//
//
//    NSString *str= [NSString stringWithFormat:@"%ld",(long)delegate.selectedDashboardChild.child_id];
//
//    NSArray *arr=[strDate componentsSeparatedByString:@" "];
//
//    NSString *strDate1= [arr objectAtIndex:0];
//    //    _lblDaySelected.text=strDate1;
//
//    NSLog(@"greattt--%ld",(long)delegate.selectedDashboardChild.child_id);
//    //NSString *str= @"96685";
//    NSString *strCompleteUrl=[NSString stringWithFormat:@"%@/v2/ftd/appusage/list/%@/%@",kBasUrl,str,strDate1];
//
//    NSLog(@"URL==%@",strCompleteUrl);
//    //@"https://mesh.familytime.io/v2/push/familytimemap/65279"
//    [JSONHTTPClient getJSONFromURLWithString:strCompleteUrl
//                                      params:[NSDictionary new]
//                                  completion:^(id json, JSONModelError *err) {
//                                      //                                      NSError *error;
//                                      NSLog(@"%@",json);
//
//
//                                      if([[json objectForKey:@"status_message"]isEqualToString:@"OK"])
//                                      {
//                                          self.tableView.hidden=NO;
//
//                                          _rowArr=[json objectForKey:@"response"];
//
//                                          int k=0;
//                                          for(int o=0;o<_rowArr.count;o++)
//                                          {
//                                              k= [[[_rowArr objectAtIndex:o] objectForKey:@"app_usage"] intValue]+k;
//
//                                          }
//                                          NSLog(@"Here is total seconds=%i",k);
//
//                                          TotalTime=k;
//
//                                          int roundedUp = ceil(k/60.0);
//                                          _lblTotalMinutes.text=[NSString stringWithFormat:@"%i %@",roundedUp,[@"Minutes" myModification]];
//
//                                          int hours = k / 3600;
//                                          if(hours>0)
//                                          {
//                                              _lblTotalMinutes.text=[NSString stringWithFormat:@"%i %@",hours,[@"Hours" myModification]];
//                                          }
//
//
//
//                                          if(_rowArr.count==0)
//                                          {
//                                              [self NodataShowNew];
//                                          }
//                                          else
//                                          {
//                                              [self dataShowAll];
//                                          }
//
//                                          [_tableView reloadData];
//
//                                      }
//
//                                      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                                  }];
//
//
//}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if(section==0)
//    {
//        return 0.0;
//    }
//    //    if(section==1)
//    //    {
//    //    return 22.0;
//    //    }
//    else
//    {
//        return 0.0;
//    }
//}

//- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//
//    if(section==0)
//    {
//        return @"Active Parents";
//
//    }
//    else if(section==1)
//    {
//        return @"InActive Parents";
//
//    }
//    else if(section==2)
//    {
//        return @"Invite Parent";
//
//    }
//    else if(section==3)
//    {
//        return @"Invite Parent";
//
//    }
//    else
//    {
//        return @"";
//    }
//}

// fixed font style. use custom view (UILabel) if you want something different
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 0.0;
//
//}
//- (nullable NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
//{
//    return @"";
//}
//- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//
//    UILabel *sectionlabelView=[[UILabel alloc] initWithFrame:
//                               CGRectMake(0, 0, tableView.frame.size.width, 44.0)];
//
//    if(section==1)
//    {
//       sectionlabelView.text= @"Subscription";
//        
//    }
//    else if(section==2)
//    {
//       sectionlabelView.text= @"Basic information";
//        
//    }
//    else if(section==3)
//    {
//      sectionlabelView.text= @"Languages";
//        
//    }
//    else
//    {
//      sectionlabelView.text= @"";
//    }
//    
//    
//    UIView *sectionHeaderView;
//    
//    sectionHeaderView = [[UIView alloc] initWithFrame:
//                         CGRectMake(0, 0, tableView.frame.size.width, 44.0)];
//    
//    sectionHeaderView.backgroundColor=[UIColor groupTableViewBackgroundColor];
//    [sectionHeaderView addSubview:sectionlabelView];
//    return sectionHeaderView;
//
//}
// custom view for header. will be adjusted to default or specified header height

//- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *sectionHeaderView;
//    
//    sectionHeaderView = [[UIView alloc] initWithFrame:
//                         CGRectMake(0, 0, tableView.frame.size.width, 7.0)];
//    
//    sectionHeaderView.backgroundColor=[UIColor whiteColor];
//
//    
//    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0,
//                                                                sectionHeaderView.frame.size.height - 1.0+5,
//                                                                sectionHeaderView.frame.size.width, 1)];
//    
//    lineView.backgroundColor = [UIColor lightGrayColor];
//    [sectionHeaderView addSubview:lineView];
//    
//    
//    return sectionHeaderView;
//}// custom view for footer. will be adjusted to default or specified footer height

-(IBAction)buttonInviteParent:(id)sender
{
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        InviteCoparentViewController *vc = [[InviteCoparentViewController alloc] initWithNibName:@"inviteViewControllerIPAD" bundle:[NSBundle mainBundle]];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        InviteCoparentViewController *vc = [[InviteCoparentViewController alloc] initWithNibName:@"inviteViewController" bundle:[NSBundle mainBundle]];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}
#pragma mark Update parent data

-(void)viewParentdata
{
    
    [_rowDic removeAllObjects];
    [_Array removeAllObjects];
    [_Array1 removeAllObjects];
    [SwiftFTUtils showHUDAddedTo:self.view withText:[@"loading..." myModification] animated:YES];
    
//    NSString *url = [NSString stringWithFormat:@"%@%@%@",kBasUrl,kViewParentAll, delegate.parent.user_id];
//    NSLog(@"Here Ahmad==%@",url);
//    NSString * language;
//    if([[NSLocale preferredLanguages] count]>1)
//    {
//        language = [[NSLocale preferredLanguages] objectAtIndex:0];
//    }
    //   NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    
//    [[ApiManager shared] mesh2_commonGetApiWithVC:self andUrl:kCoparents_mesh2 withResponse:^(id  _Nonnull json) {
//        [SwiftFTUtils hideHUDAddedTo:self.view animated:YES];
//
//        NSLog(@"coparents response = %@", json);
//
//        [refreshControl endRefreshing];
//
//        if([[json valueForKey:@"status"] intValue] == 200)
//        {
//            NSLog(@"Great");
//
//            NSLog(@"%@",json);
//
//            _rowDic=[[json objectForKey:@"coparents"] mutableCopy];
//
////            [self CheckCoparent];
//            [_tableView reloadData];
//        }
//        else
//        {
//            [CommonModel showAlert:@"Error!" msg:kErrorGeneral];
//        }
//    }];
    
    
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kBasUrlNew_mesh2,kViewParentAll];
    /*
    
    //---DEPRICATED---//---MESH API---//
    [_rowDic removeAllObjects];
    [SwiftFTUtils showHUDAddedTo:self.view withText:[@"loading..." myModification] animated:YES];

    
    NSLog(@"Here Ahmad==%@",url);
    NSString * language;
    if([[NSLocale preferredLanguages] count]>1)
    {
        language = [[NSLocale preferredLanguages] objectAtIndex:0];
    }
    //   NSTimeZone *timeZone = [NSTimeZone localTimeZone];

    
    
    [JSONHTTPClient getJSONFromURLWithString:url completion:^(id json, JSONModelError *err) {

        //        [self.tableView setHidden:NO];
        _tableView.hidden=NO;

        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        NSLog(@"%@",json);
        [refreshControl endRefreshing];

        if([[json valueForKey:@"status_code"] intValue] == 200)
        {
            NSLog(@"Great");

            NSLog(@"%@",json);

            _rowDic=[[json objectForKey:@"response"] mutableCopy];

            [self CheckCoparent];
            [_tableView reloadData];
        }
        else
        {
            [CommonModel showAlert:@"" msg:[json valueForKey:@"response"]];
        }
    }];
    
    
    */
    
    
    //---NATIVE API CALLING---//
    
    NSURLSession *session        = [ApiManager getMesh2NativeApiSession];
    NSMutableURLRequest *request = [ApiManager getMesh2NativeApiRequestWithUrl:url andMethod:kGetMethod sendHeader:NO];
    
    NSError *paramsError;
//    NSData *postData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&paramsError];
//    [request setHTTPBody:postData];
    

    NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:kHeaderToken];
       NSString *tokenWithBear = [NSString stringWithFormat:@"Bearer %@", token];
       NSString *lang = @"en";
       
       NSLog(@"Mesh Get api URL = %@",[[NSLocale currentLocale] languageCode]);
       
       
       if([[NSUserDefaults.standardUserDefaults stringForKey:@"userlanguage"] isEqual:nil] || [[NSUserDefaults.standardUserDefaults stringForKey:@"userlanguage"] isEqual:[NSNull null]]){
           
           lang  = [[NSLocale currentLocale] languageCode];
       }else{
           
           lang = [NSUserDefaults.standardUserDefaults stringForKey:@"userlanguage"];
       }
    
    
      [[NSUserDefaults standardUserDefaults] setValue:kNO forKey:kSendHeaders];
               [[NSUserDefaults standardUserDefaults] synchronize];
     NSDictionary *headers = @{ @"content-type": @"application/json",@"lang":lang,@"Authorization":tokenWithBear};
               
               request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
               [request setHTTPMethod:kGetMethod];
               [request setAllHTTPHeaderFields:headers];
   
           //---POSTMAN CODE---//
           
          // NSURLSession *session = [NSURLSession sharedSession];
           NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                       completionHandler:^(NSData *data, NSURLResponse *responsee, NSError *serverError) {
        //        NSLog(@"data = %@ response = %@ and error = %@", data, response, error);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            
            if (data == nil){
                [CommonModel showAlert:@"Error!" msg:[kErrorGeneral myModification]];
            }
            else{
                // Parse the JSON that came in into an NSDictionary
                NSError * parseError = nil;
                NSDictionary * json  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parseError];
                
                
                NSLog(@"Get Parents All api response after parsing = %@ and server error = %@", json, serverError);
                NSLog(@"parsed json =%@ and parsing error =%@", json, parseError);
                
                _tableView.hidden=NO;
                
                NSLog(@"%@",json);
                [refreshControl endRefreshing];
                canRefresh = YES;
                
                if (!serverError && !parseError){
                    //---CHECK FOR EX00401 CODE,---UNAUTHENTICATEED STATUS---//
                    if ([[json valueForKey:@"status"] isKindOfClass:[NSString class]]){
                        if ([[json valueForKey:@"status"] isEqualToString:kLogoutStatus])
                            [CommonModel showAlertAndLogoutOnVC:self isPresentedVC:NO];
                    }
                    else{
                        if([[json valueForKey:@"status"] intValue] == 200)
                        {
                            NSLog(@"%@",json);
                            
                            
                            
                            _rowDic=[[json objectForKey:@"coparents"] mutableCopy];
                            
                            NSArray *arr = [[NSArray alloc]init];
                            
                            arr = [json objectForKey:@"coparents"];
                            for (int i=0; i<[arr count]; i++){
                                NSMutableDictionary *dic  = [[NSMutableDictionary alloc]init];
                                dic = [arr objectAtIndex:i];
                                if([[dic valueForKey:@"active"] intValue] == 1){
                                    
                                    [_Array addObject:dic];
                                }else{
                                    
                                    [_Array1 addObject:dic];
                                }
                            }
                            
                            
                            [self CheckCoparent];
                            [_tableView reloadData];
                        }
                        else
                            [CommonModel showAlert:@"" msg:[json valueForKey:@"response"]];
                    }
                }
                else
                    [CommonModel showAlert:@"Error!" msg:[kErrorGeneral myModification]];
            }
                        
        });
        
    }];
    
    [dataTask resume];
}


#pragma mark Parent Buttons

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
        NSDictionary *dic = [_Array objectAtIndex:indexPath.row];
        NSString *strUser_Id= [dic objectForKey:@"user_id"];
        NSString *switch_Id= [[[dic objectForKey:@"settings"] objectAtIndex:0]objectForKey:@"id"];

        [SwiftFTUtils showHUDAddedTo:self.view withText:[@"loading..." myModification] animated:YES];
        //        NSString *url = [NSString stringWithFormat:@"https://mesh.familytime.io/v2/ftd/user/invite"];
        NSString *url = [NSString stringWithFormat:@"%@/dashboard/settings/notifications/preferences/%@",kBasUrlNew_mesh2,strUser_Id];
        NSArray *arr=[[NSArray alloc]initWithObjects:@{@"id":switch_Id,@"status":SwitchState}, nil];

        NSDictionary *params = @{@"notifications":arr};

        NSString *jsonString;
        {
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params
                                                               options:NSJSONWritingPrettyPrinted // Pass 0 if you don't  care about the readability of the generated string
                                                                 error:&error];

            if (! jsonData) {
                NSLog(@"Got an error: %@", error);
            } else {
                jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                NSLog(@"%@", jsonString);
            }
        }

        NSLog(@"url = %@ and bodyString = %@", url, jsonString);

        /*

        [JSONHTTPClient patchJSONFromURLWithString:url bodyString:jsonString completion:^(id json, JSONModelError *err) {

            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];


            NSLog(@"hehe==%@",json);
            if([[json valueForKey:@"status_code"] intValue] == 200)
            {
                [CommonModel showAlert:@"" msg:[json valueForKey:@"response"]];
            }
            else
            {
                [CommonModel showAlert:@"" msg:[json valueForKey:@"response"]];
            }
        }];

        */

        [[ApiManager shared] mesh_putApiNotiWithParamString:jsonString withApi:url withResponse:^(NSDictionary * _Nonnull json, NSInteger errorCode, NSString * _Nonnull message) {

            dispatch_async(dispatch_get_main_queue(), ^{

                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];


                NSLog(@"Native patch api json response == %@",json);
                if([[json valueForKey:@"status"] intValue] == 200)
                    [CommonModel showAlert:@"" msg:[json valueForKey:@"message"]];
                else
                    [CommonModel showAlert:@"" msg:[json valueForKey:@"message"]];
            });
        }];
    }
}

- (IBAction)Switch2:(id)sender
{
    UISwitch *button = (UISwitch *)sender;
    int k=button.on;
    NSString *SwitchState=[NSString stringWithFormat:@"%i",k];


    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    if (indexPath)
    {
        NSLog(@"Row=%li  Section=%li",(long)indexPath.row,(long)indexPath.section);

        NSDictionary *dic = [_Array objectAtIndex:indexPath.row];
        NSString *strUser_Id= [dic objectForKey:@"user_id"];
        NSString *switch_Id= [[[dic objectForKey:@"settings"] objectAtIndex:1]objectForKey:@"id"];

        [SwiftFTUtils showHUDAddedTo:self.view withText:[@"loading..." myModification] animated:YES];
        //        NSString *url = [NSString stringWithFormat:@"https://mesh.familytime.io/v2/ftd/user/invite"];
        NSString *url = [NSString stringWithFormat:@"%@/dashboard/settings/notifications/preferences/%@",kBasUrlNew_mesh2,strUser_Id];
        NSArray *arr=[[NSArray alloc]initWithObjects:@{@"id":switch_Id,@"status":SwitchState}, nil];

        NSDictionary *params = @{@"notifications":arr};

        NSString *jsonString;
        {
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params
                                                               options:NSJSONWritingPrettyPrinted // Pass 0 if you don't  care about the readability of the generated string
                                                                 error:&error];

            if (! jsonData) {
                NSLog(@"Got an error: %@", error);
            } else {
                jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                NSLog(@"%@", jsonString);
            }
        }

        NSLog(@"url = %@ and bodyString = %@", url, jsonString);

        /*

        [JSONHTTPClient patchJSONFromURLWithString:url bodyString:jsonString completion:^(id json, JSONModelError *err) {

            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];


            NSLog(@"hehe==%@",json);
            if([[json valueForKey:@"status_code"] intValue] == 200)
            {
                [CommonModel showAlert:@"" msg:[json valueForKey:@"response"]];
            }
            else
            {
                [CommonModel showAlert:@"" msg:[json valueForKey:@"response"]];
            }
        }];

        */

        [[ApiManager shared] mesh_putApiNotiWithParamString:jsonString withApi:url withResponse:^(NSDictionary * _Nonnull json, NSInteger errorCode, NSString * _Nonnull message) {

            dispatch_async(dispatch_get_main_queue(), ^{

                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];


                NSLog(@"Native patch api json response == %@",json);
                if([[json valueForKey:@"status"] intValue] == 200)
                    [CommonModel showAlert:@"" msg:[json valueForKey:@"message"]];
                else
                    [CommonModel showAlert:@"" msg:[json valueForKey:@"message"]];
            });
        }];
    }
}


- (IBAction)Switch3:(id)sender
{
    UISwitch *button = (UISwitch *)sender;
    int k=button.on;
    NSString *SwitchState=[NSString stringWithFormat:@"%i",k];


    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    if (indexPath)
    {
        NSLog(@"Row=%li  Section=%li",(long)indexPath.row,indexPath.section);

        
        NSDictionary *dic = [_Array objectAtIndex:indexPath.row];
        NSString *strUser_Id= [dic objectForKey:@"user_id"];
        NSString *switch_Id= [[[dic objectForKey:@"settings"] objectAtIndex:2]objectForKey:@"id"];

        [SwiftFTUtils showHUDAddedTo:self.view withText:[@"loading..." myModification] animated:YES];
        //        NSString *url = [NSString stringWithFormat:@"https://mesh.familytime.io/v2/ftd/user/invite"];
        NSString *url = [NSString stringWithFormat:@"%@/dashboard/settings/notifications/preferences/%@",kBasUrlNew_mesh2,strUser_Id];
        NSArray *arr=[[NSArray alloc]initWithObjects:@{@"id":switch_Id,@"status":SwitchState}, nil];

        NSDictionary *params = @{@"notifications":arr};

        NSString *jsonString;
        {
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params
                                                               options:NSJSONWritingPrettyPrinted // Pass 0 if you don't  care about the readability of the generated string
                                                                 error:&error];

            if (! jsonData) {
                NSLog(@"Got an error: %@", error);
            } else {
                jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                NSLog(@"%@", jsonString);
            }
        }

        NSLog(@"url = %@ and bodyString = %@", url, jsonString);

        /*

        [JSONHTTPClient patchJSONFromURLWithString:url bodyString:jsonString completion:^(id json, JSONModelError *err) {

            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];


            NSLog(@"hehe==%@",json);
            if([[json valueForKey:@"status_code"] intValue] == 200)
            {
                [CommonModel showAlert:@"" msg:[json valueForKey:@"response"]];
            }
            else
            {
                [CommonModel showAlert:@"" msg:[json valueForKey:@"response"]];
            }
        }];

        */

        [[ApiManager shared] mesh_putApiNotiWithParamString:jsonString withApi:url withResponse:^(NSDictionary * _Nonnull json, NSInteger errorCode, NSString * _Nonnull message) {

            dispatch_async(dispatch_get_main_queue(), ^{

                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];


                NSLog(@"Native patch api json response == %@",json);
                if([[json valueForKey:@"status"] intValue] == 200)
                    [CommonModel showAlert:@"" msg:[json valueForKey:@"message"]];
                else
                    [CommonModel showAlert:@"" msg:[json valueForKey:@"message"]];
            });
        }];
    }
}
- (IBAction)Switch4:(id)sender
{
    UISwitch *button = (UISwitch *)sender;
    int k=button.on;
    NSString *SwitchState=[NSString stringWithFormat:@"%i",k];


    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    if (indexPath)
    {
        NSLog(@"Row=%li  Section=%li",(long)indexPath.row,(long)indexPath.section);

      
        NSDictionary *dic = [_Array objectAtIndex:indexPath.row];
        NSString *strUser_Id= [dic objectForKey:@"user_id"];
        NSString *switch_Id= [[[dic objectForKey:@"settings"] objectAtIndex:3]objectForKey:@"id"];

        [SwiftFTUtils showHUDAddedTo:self.view withText:[@"loading..." myModification] animated:YES];
        //        NSString *url = [NSString stringWithFormat:@"https://mesh.familytime.io/v2/ftd/user/invite"];
        NSString *url = [NSString stringWithFormat:@"%@/dashboard/settings/notifications/preferences/%@",kBasUrlNew_mesh2,strUser_Id];
        NSArray *arr=[[NSArray alloc]initWithObjects:@{@"id":switch_Id,@"status":SwitchState}, nil];

        NSDictionary *params = @{@"notifications":arr};

        NSString *jsonString;
        {
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params
                                                               options:NSJSONWritingPrettyPrinted // Pass 0 if you don't  care about the readability of the generated string
                                                                 error:&error];

            if (! jsonData) {
                NSLog(@"Got an error: %@", error);
            } else {
                jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                NSLog(@"%@", jsonString);
            }
        }

        NSLog(@"url = %@ and bodyString = %@", url, jsonString);

        /*

        [JSONHTTPClient patchJSONFromURLWithString:url bodyString:jsonString completion:^(id json, JSONModelError *err) {

            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];


            NSLog(@"hehe==%@",json);
            if([[json valueForKey:@"status_code"] intValue] == 200)
            {
                [CommonModel showAlert:@"" msg:[json valueForKey:@"response"]];
            }
            else
            {
                [CommonModel showAlert:@"" msg:[json valueForKey:@"response"]];
            }
        }];

        */

        [[ApiManager shared] mesh_putApiNotiWithParamString:jsonString withApi:url withResponse:^(NSDictionary * _Nonnull json, NSInteger errorCode, NSString * _Nonnull message) {

            dispatch_async(dispatch_get_main_queue(), ^{

                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];


                NSLog(@"Native patch api json response == %@",json);
                if([[json valueForKey:@"status"] intValue] == 200)
                    [CommonModel showAlert:@"" msg:[json valueForKey:@"message"]];
                else
                    [CommonModel showAlert:@"" msg:[json valueForKey:@"message"]];
            });
        }];
    }
}

- (IBAction)RemoveActiveFamily:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    if (indexPath)
    {
        NSLog(@"Row=%li  Section=%li",(long)indexPath.row,(long)indexPath.section);
        
        NSString *coParentId = [[[_rowDic objectForKey:@"active"] objectAtIndex:indexPath.row]objectForKey:@"user_id"];
        
        [SwiftFTUtils showHUDAddedTo:self.view withText:[@"loading..." myModification] animated:YES];
        NSDictionary *params = @{@"co_parent_user_id" : coParentId,
                                 @"_method" : @"DELETE" //---HACK TO WORK DELETE API AS POST API---//
                                 };
        NSLog(@"remove coparent params = %@ and url = %@", params, kDelete_Coparent_mesh2);
        

        //---DELETE API AS POST---ADD ADDITIONAL KEY "_method" AND VALUE "DELETE"---//
        //---BASICALLY GET AND POST WERE USED THEN CAME DELETE, PUT, PATCH AND ALL OTHER METHODS, AND ALL THESE ARE DERIVED FROM POST, SO THIS IS HACK, SOMETIMES PUT, DELETE, PATCH COULDN'T GET PARAMS AND DON'T WORK, SO THIS IS WAY---//
        [[ApiManager shared] postApiWithVC:self isPresentedCont:NO andParams:params withApi:kDelete_Coparent_mesh2 withResponse:^(NSString * _Nonnull message, NSInteger code) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [SwiftFTUtils hideHUDAddedTo:self.view animated:YES];
                
                NSLog(@"delete coparent response message = %@ and code = %ld", message, (long)code);
                
                if(code == 200)
                    [self refreshScreen];
                
                [CommonModel showAlert:@"Alert" msg:message];
            });
        }];
        
        
        //---DEPRICATED---MESH---//
        
        /*
        NSString *url = [NSString stringWithFormat:@"%@/v2/ftd/user/management/%@",kBasUrl,delegate.parent.user_id];
        
        
        //        NSDictionary *params = @{@"user_id":delegate.parent.user_id,@"email":_txtEmail.text};
        NSArray *params=[[NSArray alloc]initWithObjects:coParentId, nil];
        
        NSString *jsonString;
        {
            
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params
                                                               options:NSJSONWritingPrettyPrinted // Pass 0 if you don't  care about the readability of the generated string
                                                                 error:&error];
            
            if (! jsonData) {
                NSLog(@"Got an error: %@", error);
            } else {
                jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                NSLog(@"%@", jsonString);
            }
        }
        
        [JSONHTTPClient getAllJSONFromURLWithString:url bodyString:jsonString completion:^(id json, JSONModelError *err) {
            //NSError *error;
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            
            NSLog(@"hehe==%@",json);
            if([[json valueForKey:@"status_code"] intValue] == 200)
            {
                [CommonModel showAlert:@"" msg:[json valueForKey:@"response"]];
                [self refreshScreen];
                
            }
            else
            {
                [CommonModel showAlert:@"" msg:[json valueForKey:@"response"]];
                
            }
            
        }];
        
         */
        
    }
}
- (IBAction)ResendInvitationFamily:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    if (indexPath)
    {
        
        NSLog(@"Row=%li  Section=%li",(long)indexPath.row,(long)indexPath.section);
        
        NSDictionary *dic = [_Array1 objectAtIndex:indexPath.row];
         NSString *strUser_Email= [dic objectForKey:@"email"];
        NSString *strUser_Name= [dic objectForKey:@"name"];
        
        [SwiftFTUtils showHUDAddedTo:self.view withText:[@"loading..." myModification] animated:YES];
        //        NSString *url = [NSString stringWithFormat:@"https://mesh.familytime.io/v2/ftd/user/invite"];
        NSString *url = [NSString stringWithFormat:@"%@/dashboard/coparent/invite",kBasUrlNew_mesh2];
        
        //{"type":"reinvite","user_id":7373}
        NSDictionary *params = @{@"email":strUser_Email,@"name":strUser_Name};
        //    NSArray *params=[[NSArray alloc]initWithObjects:strUser_Id, nil];
        
        NSString *jsonString;
        {
            
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params
                                                               options:NSJSONWritingPrettyPrinted // Pass 0 if you don't  care about the readability of the generated string
                                                                 error:&error];
            
            if (! jsonData) {
                NSLog(@"Got an error: %@", error);
            } else {
                jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                NSLog(@"%@", jsonString);
            }
        }
        
        NSLog(@"url = %@ and bodyString = %@", url, jsonString);
        
        /*
        
        [JSONHTTPClient patchJSONFromURLWithString:url bodyString:jsonString completion:^(id json, JSONModelError *err) {
            //NSError *error;
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            
            NSLog(@"hehe==%@",json);
            if([[json valueForKey:@"status_code"] intValue] == 200)
            {
                
                [CommonModel showAlert:@"" msg:[json valueForKey:@"response"]];
                [self refreshScreen];
            }
            else
            {
                [CommonModel showAlert:@"" msg:[json valueForKey:@"response"]];
            }
        }];
        
         */
        
        //---NATIVE API CALLING---//
        
        [[ApiManager shared] mesh_postApiWithParamString:jsonString withApi:url withResponse:^(NSDictionary * _Nonnull json, NSInteger errorCode, NSString * _Nonnull message) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                
                
                NSLog(@"Native patch api json response == %@",json);
                if([[json valueForKey:@"status"] intValue] == 200)
                    [CommonModel showAlert:@"" msg:[json valueForKey:@"message"]];
                else
                    [CommonModel showAlert:@"" msg:[json valueForKey:@"message"]];
            });
        }];
        
        
    }
}
- (IBAction)RevokeInvitation:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    if (indexPath)
    {
        
        NSLog(@"Row=%li  Section=%li",(long)indexPath.row,indexPath.section);
        
        NSDictionary *dic = [_Array1 objectAtIndex:indexPath.row];
         NSString *strUser_Id= [dic objectForKey:@"user_id"];
        
        [SwiftFTUtils showHUDAddedTo:self.view withText:[@"loading..." myModification] animated:YES];
        //        NSString *url = [NSString stringWithFormat:@"https://mesh.familytime.io/v2/ftd/user/invite"];
        NSString *url = [NSString stringWithFormat:@"%@/dashboard/coparent",kBasUrlNew_mesh2];
        
        //{"type":"reinvite","user_id":7373}
        NSDictionary *params = @{@"co_parent_user_id":strUser_Id};
        //    NSArray *params=[[NSArray alloc]initWithObjects:strUser_Id, nil];
        
        NSString *jsonString;
        {
            
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params
                                                               options:NSJSONWritingPrettyPrinted // Pass 0 if you don't  care about the readability of the generated string
                                                                 error:&error];
            
            if (! jsonData) {
                NSLog(@"Got an error: %@", error);
            } else {
                jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                NSLog(@"%@", jsonString);
            }
        }
        
        NSLog(@"url = %@ and bodyString = %@", url, jsonString);
        
        
        /*
        
        [JSONHTTPClient patchJSONFromURLWithString:url bodyString:jsonString completion:^(id json, JSONModelError *err) {
            //NSError *error;
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            
            NSLog(@"hehe==%@",json);
            if([[json valueForKey:@"status_code"] intValue] == 200)
            {
                //                [self HideAll];
                [CommonModel showAlert:@"" msg:[json valueForKey:@"response"]];
                [self refreshScreen];
            }
            else
            {
                [CommonModel showAlert:@"" msg:[json valueForKey:@"response"]];
                
            }
            
        }];
        
        
        */
        
        //---NATIVE API CALLING---//
        
        [[ApiManager shared] mesh_deleteApiWithStringParam:jsonString withApi:url withResponse:^(NSDictionary * _Nonnull json, NSInteger errorCode, NSString * _Nonnull message) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                
                
                NSLog(@"Native patch api json response == %@",json);
                if([[json valueForKey:@"status"] intValue] == 200)
                    [CommonModel showAlert:@"" msg:[json valueForKey:@"message"]];
                else
                    [CommonModel showAlert:@"" msg:[json valueForKey:@"message"]];
                 [self viewParentdata];
            });
        }];
        
        
    }
}
-(void)settingsOfParent
{
    
}

-(void)refreshScreen
{
    
    [self viewParentdata];
    
    
}

-(void)CheckCoparent
{
    //for(int i=0;i<[[_rowDic count];i++)
//    for (int i=0; i<[_rowDic count]; i++)
//
//    {
//        if([[[_rowDic valueForKey:@"is_super_parent"]objectAtIndex:i]intValue]==0)
//        {
//            checkpermissionInviteParent=5;
//            break;
//        }
//
//
//    }
    
    checkpermissionInviteParent=5;
}

- (void) refreshTableView
{
    refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(viewParentdata) forControlEvents:UIControlEventValueChanged];
}

- (void)refreshTable
{
    [refreshControl endRefreshing];
    [self.tableView reloadData];
}




- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSLog(@"Offset: %f", [scrollView contentOffset].y);
    if ([scrollView contentOffset].y < -150) {
        if (canRefresh && ![refreshControl isRefreshing]) {
            canRefresh = FALSE;
            [refreshControl beginRefreshing];
            [self viewParentdata];
        }
    }
    else if ([scrollView contentOffset].y >= 0) {
        canRefresh = TRUE;
    }
    
}


@end


