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

#import "AppUsageViewController.h"
//#import "AppUsageTableViewCell.h"
#import "NSString+LockMustafa.h"

#import "MBProgressHUD.h"
//#import "JSONHTTPClient.h"
#import "FTUtils.h"
//#import <Google/Analytics.h>
#import "DataModel.h"
#import "Constant.h"
#import "CommonModel.h"
#import "AppDelegate.h"
#import "Constant.h"
#import "FamilyTime-Swift.h"

#import "NSString+LockMustafa.h"
UIRefreshControl *  refreshControl;

AppDelegate *delegate;

@interface AppUsageViewController ()

@end

@implementation AppUsageViewController

- (void)viewDidLoad
    {

    [super viewDidLoad];
   
    
    [self refreshTableView];

    _lblTotalDeviceusage1.text=[NSString stringWithFormat:@"%@:",[@"Total Device Usage" myModification]];
    
//    [ZendeskChatManager trackEvent:@"App Usage Screen"];

    self.tableView.hidden=YES;
 //   self.tableView.layer
//    [self.tableView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
//    [self.tableView.layer setBorderWidth:1.0f];
//
    [_topView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [_topView.layer setBorderWidth:1.0f];

    
    
    _lblTotalMinutes.adjustsFontSizeToFitWidth=YES;

    IndexOfDate=0;
    
    self.title=[@"App Usage" myModification];
    [self loadDates];
    
    _rowArr=[NSMutableArray new];
//    delegate = [AppDelegate appDelegate];
    [self.tableView registerNib:[UINib nibWithNibName:@"AppUsageTableViewCell" bundle:nil] forCellReuseIdentifier:@"AppUsageCell"];
    
    
    
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
    
    
    
    
    // Do any additional setup after loading the view from its nib.
    
//    [self loadAllAppUsageOfChild];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void) loadAllAppUsageOfChild
{
    //    if(self.dates.count == 0)
    //  /      return;
    
    //set first last date in between next prev button
    //    NSString *date  = [CommonModel date:[self.dates objectAtIndex:self.page] oldFormat:@"YYYY-MM-dd HH:mm:ss" format:@"EEE, MMM d, yyyy"];//d EEE,MMM yy
    //    [self.locDate setText:date];
    [SwiftFTUtils showHUDAddedTo:self.view withText:[@"Loading..." myModification] animated:YES];
    
    
    //   NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:delegate.selectedDashboardChild.child_id],@"child_id",pDate,@"date", nil];
    
    
    NSString *str= [NSString stringWithFormat:@"%ld",(long)delegate.selectedDashboardChild.child_id];
    
    
     NSLog(@"greattt--%ld",(long)delegate.selectedDashboardChild.child_id);
 //NSString *str= @"96685";
    
    //---DEPRICATED---VC---//
    NSString *strCompleteUrl = @""; // [NSString stringWithFormat:@"%@/v2/ftd/appusage/list/%@/2017-08-03",kBasUrl,str];
    
    NSLog(@"URL==%@",strCompleteUrl);
    //@"https://mesh.familytime.io/v2/push/familytimemap/65279"
//    [JSONHTTPClient getJSONFromURLWithString:strCompleteUrl
//                                      params:[NSDictionary new]
//                                  completion:^(id json, JSONModelError *err) {
////                                      NSError *error;
//                                      NSLog(@"%@",json);
//
//
//                                      if([[json objectForKey:@"status_message"]isEqualToString:@"OK"])
//                                      {
//                                      _rowArr=[json objectForKey:@"response"];
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
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _rowArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    
    UILabel *LabelTitle = (UILabel*)[cell viewWithTag:2];
    UILabel *LabelSubTitle = (UILabel*)[cell viewWithTag:3];
    UIProgressView *progressBar = (UIProgressView*)[cell viewWithTag:4];
    UILabel *LabelPercent= (UILabel*)[cell viewWithTag:5];

    
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 0.5f);
    progressBar.transform = transform;
    
    LabelTitle.text=[[_rowArr objectAtIndex:indexPath.row] objectForKey:@"app_name"];
//    LabelSubTitle.text=[[_rowArr objectAtIndex:indexPath.row] objectForKey:@"package_name"];
   
    [progressBar setProgressTintColor:[UIColor colorWithRed:21/255.0 green:179/255.0 blue:243/255.0 alpha:1.0]];
    [progressBar setUserInteractionEnabled:NO];
    progressBar.progress=[[[_rowArr objectAtIndex:indexPath.row] objectForKey:@"app_usage"] floatValue]/(float)TotalTime;   // TotalTime
    float tt=[[[_rowArr objectAtIndex:indexPath.row] objectForKey:@"app_usage"] floatValue]/(float)TotalTime;
    tt=tt*100.0;
    if(tt<1)
    {
//        LabelPercent.text=[NSString stringWithFormat:@"1%%"];
        LabelPercent.text=@"1%";
    }
    else
    {
    LabelPercent.text=[NSString stringWithFormat:@"%.0f%%",tt];
    }
    float p= [[[_rowArr objectAtIndex:indexPath.row] objectForKey:@"app_usage"] floatValue]/60.0;
    
//    int roundedUp = ceil(p);
    int roundedUp = (int)p;
    
    int kk=roundedUp*60;
    int totalSec=[[[_rowArr objectAtIndex:indexPath.row] objectForKey:@"app_usage"] intValue];
    totalSec=totalSec-kk;

    LabelSubTitle.text=[NSString stringWithFormat:@"%i min %i sec",roundedUp,totalSec];
   if(roundedUp==0)
   {
       LabelSubTitle.text=[NSString stringWithFormat:@"%i sec",totalSec];

   }
    
//    int seconds = [[[_rowArr objectAtIndex:indexPath.row] objectForKey:@"app_usage"] intValue] % 60;
//    int minutes = ([[[_rowArr objectAtIndex:indexPath.row] objectForKey:@"app_usage"] intValue] / 60) % 60;
    
    int hours = [[[_rowArr objectAtIndex:indexPath.row] objectForKey:@"app_usage"] intValue] / 3600;
   
    int totalSeccc= hours*60*60;
    int minSeccc=  [[[_rowArr objectAtIndex:indexPath.row] objectForKey:@"app_usage"] intValue]-totalSeccc;
    int minutesNew = (minSeccc / 60) % 60;
    if(hours>0)
    {
        LabelSubTitle.text=[NSString stringWithFormat:@"%i hrs %i min",hours,minutesNew];
    }
    
    LabelSubTitle.adjustsFontSizeToFitWidth=YES;
    
//    NSLog(@"here is one=%f",[[[_rowArr objectAtIndex:indexPath.row] objectForKey:@"app_usage"] floatValue]);
//    progressBar.progress=0.5f;
    
//    cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    
//    progressBar.translatesAutoresizingMaskIntoConstraints=YES;
//    progressBar.frame=CGRectMake(progressBar.frame.origin.x, progressBar.frame.origin.y, progressBar.frame.size.width, progressBar.frame.size.height);
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
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
-(void) loadDates
{
    _view1.hidden=NO;
    _view2.hidden=NO;

    NSLog(@"greattt--%ld",(long)delegate.selectedDashboardChild.child_id);
    self.page = 0;
    self.dates = [[NSMutableArray alloc] init];
    [SwiftFTUtils showHUDAddedTo:self.view withText:@"Loading..." animated:YES];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:delegate.selectedDashboardChild.child_id],@"child_id", nil];
    
    NSString *struserCheck=[NSString stringWithFormat:@"%@%@/%ld",kBasUrlNew_mesh2,@"/v2/ftd/appusage/checkindates",(long)delegate.selectedDashboardChild.child_id];
//    [JSONHTTPClient postJSONFromURLWithString:struserCheck
//                                       params:params
//                                   completion:^(id json, JSONModelError *err) {
//                                       NSString *msg = [json valueForKey:@"status_message"] == nil ? [kErrorGeneral myModification] : [json valueForKey:@"status_message"];
//
//                                       NSLog(@"Load dates==%@",json);
//                                       if([[json valueForKey:@"status_code"] intValue] == 200){
//                                           NSArray *jsonObject =  [[json valueForKey:@"response"] copy];
////                                           self.dates = [NSMutableArray arrayWithArray:jsonObject];
//                                          NSMutableArray *arr = [NSMutableArray arrayWithArray:jsonObject];
//
//                                           [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//
//
//                                     self.dates= [[[[arr copy] reverseObjectEnumerator] allObjects] mutableCopy];
//
//                                           if([self.dates count]>0)
//                                           {
//                                               [self loadAllAppUsageOfChildNew:[self.dates objectAtIndex:IndexOfDate]];
//
////                                               imgView.hidden=NO;
////                                               contentLbl.hidden=NO;
////
////                                               _view1.hidden=YES;
////                                               _view2.hidden=YES;
////                                               [self.view setBackgroundColor:[UIColor whiteColor]];
////                                               self.tableView.hidden=YES;
//                                           }
//                                           else
//                                           {
//                                               [self NodataShow];
////                                               [self.view addSubview:imgView];
////                                               [self.view addSubview:contentLbl];
////                                               imgView.hidden=NO;
////                                               contentLbl.hidden=NO;
////
////                                               _view1.hidden=YES;
////                                               _view2.hidden=YES;
////                                               [self.view setBackgroundColor:[UIColor whiteColor]];
////                                               self.tableView.hidden=YES;
//                                           }
//
////                                           [self loadLoactions];
//
//                                       }
//                                       else
//                                       {
//                                           [CommonModel showAlert:@"Error!" msg:msg];
//                                           [self NodataShow];
//
////                                           [self refreshTable];
//                                           [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                                       }
//                                   }];
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
    
    [refreshControl endRefreshing];

                                                   imgView.hidden=NO;
                                                   contentLbl.hidden=NO;
    
                                                   _view1.hidden=YES;
                                                   _view2.hidden=YES;
                                                   [self.view setBackgroundColor:[UIColor whiteColor]];
                                                   self.tableView.hidden=YES;

}

-(void)NodataShowNew
{
    [refreshControl endRefreshing];

    imgView.hidden=NO;
//    contentLbl.hidden=NO;
    
    _view1.hidden=NO;
    _view2.hidden=YES;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.tableView.hidden=YES;
    
}

-(IBAction)buttonNext:(id)sender
{
    if(IndexOfDate==0)
    {
    }
    else
    {
    IndexOfDate--;
    [self loadAllAppUsageOfChildNew:[self.dates objectAtIndex:IndexOfDate]];
    
    }

}

-(IBAction)buttonPrevious:(id)sender
{
    if([self.dates count]-1==IndexOfDate)
    {
    }
    else
    {
    IndexOfDate++;
    [self loadAllAppUsageOfChildNew:[self.dates objectAtIndex:IndexOfDate]];
    }
    
//loadAllAppUsageOfChildNew
}
#pragma mark With parameter
-(void) loadAllAppUsageOfChildNew:(NSString *)strDate
{
    //    if(self.dates.count == 0)
    //        return;
    
    //set first last date in between next prev button
    //    NSString *date  = [CommonModel date:[self.dates objectAtIndex:self.page] oldFormat:@"YYYY-MM-dd HH:mm:ss" format:@"EEE, MMM d, yyyy"];//d EEE,MMM yy
    //    [self.locDate setText:date];
    
    
    NSString *date  = [CommonModel date:[self.dates objectAtIndex:IndexOfDate] oldFormat:@"YYYY-MM-dd" format:@"EEE, MMM d, yyyy"];//d EEE,MMM yy
    [_lblDaySelected setText:date];

    
    
    [SwiftFTUtils showHUDAddedTo:self.view withText:@"Loading..." animated:YES];
    
    
    //   NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:delegate.selectedDashboardChild.child_id],@"child_id",pDate,@"date", nil];
    
    
    NSArray *str= [NSString stringWithFormat:@"%ld",(long)delegate.selectedDashboardChild.child_id];

    NSArray *arr=[strDate componentsSeparatedByString:@" "];

   NSString *strDate1= [arr objectAtIndex:0];
//    _lblDaySelected.text=strDate1;
    
    NSLog(@"greattt--%ld",(long)delegate.selectedDashboardChild.child_id);
    //NSString *str= @"96685";
    
    //---DEPRICATED---VC---//
    NSString *strCompleteUrl = @""; //[NSString stringWithFormat:@"%@/v2/ftd/appusage/list/%@/%@",kBasUrl,str,strDate1];
    
    NSLog(@"URL==%@",strCompleteUrl);
    //@"https://mesh.familytime.io/v2/push/familytimemap/65279"
//    [JSONHTTPClient getJSONFromURLWithString:strCompleteUrl
//                                      params:[NSDictionary new]
//                                  completion:^(id json, JSONModelError *err) {
////                                      NSError *error;
//                                      NSLog(@"%@",json);
//
//                                      [refreshControl endRefreshing];
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
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{

return @"";
}
// fixed font style. use custom view (UILabel) if you want something different
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0;

}
- (nullable NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    
    return @"";
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    
    UIView *sectionHeaderView;
    
    sectionHeaderView = [[UIView alloc] initWithFrame:
                         CGRectMake(0, 0, tableView.frame.size.width, 7.0)];
    
    sectionHeaderView.backgroundColor=[UIColor whiteColor];
    return sectionHeaderView;

}// custom view for header. will be adjusted to default or specified header height
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *sectionHeaderView;
    
    sectionHeaderView = [[UIView alloc] initWithFrame:
                         CGRectMake(0, 0, tableView.frame.size.width, 7.0)];
    
    sectionHeaderView.backgroundColor=[UIColor whiteColor];

    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                sectionHeaderView.frame.size.height - 1.0+5,
                                                                sectionHeaderView.frame.size.width, 1)];
    
    lineView.backgroundColor = [UIColor lightGrayColor];
    [sectionHeaderView addSubview:lineView];
    
    
    return sectionHeaderView;
}// custom view for footer. will be adjusted to default or specified footer height


- (void) refreshTableView
{
    refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(loadDates) forControlEvents:UIControlEventValueChanged];
}

- (void)refreshTable
{
    [refreshControl endRefreshing];
    [self.tableView reloadData];
}

@end
