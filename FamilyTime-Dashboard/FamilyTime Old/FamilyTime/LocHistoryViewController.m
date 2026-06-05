//
//  LocHistoryViewController.m
//  FamilyTime
//
//  Created by Sora Code on 12/10/14.
//  Copyright (c) 2014 SoraCode. All rights reserved.
//
// Refernce
//http://www.devfright.com/mkpointannotation-tutorial/

#import "NSString+LockMustafa.h"
#import "LocHistoryViewController.h"
#import "MBProgressHUD.h"
//#import "JSONHTTPClient.h"
#import "AppDelegate.h"
#import "InstantLocation.h"
#import "PlacesCell.h"
#import "FTD.h"
#import "FTUtils.h"
//#import <Google/Analytics.h>
#import "FamilyTime-Swift.h"

@class CoreDataUtility;

NSString *location_package_id = @"";
NSString *location_package_name = @"";
NSString *location_device = @"";


AppDelegate *delegate;
UIRefreshControl *  refreshControl;
@interface LocHistoryViewController ()
@end

@implementation LocHistoryViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [ZendeskChatManager trackEvent:@"Location History"];

    
    NSLog(@"here 1=%@",delegate.selectedChild.child_id);
    NSLog(@"here 2=%@",delegate.selectedChild.user_id);
    
    //DashboardChildPackageFeature *packageFeature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"geolocation"];
    if (([location_device isEqualToString:@"iphone"] && ([location_package_id isEqualToString:@"6"])) || ([location_device isEqualToString:@"android"] && ([location_package_id isEqualToString:@"1"])))
    {
       // if(packageFeature.is_time_based == 1 || packageFeature.is_count_based == 1)
           // [self showPremiumBanner:YES];
        //else
            //[self showPremiumBanner:NO];
        imgView.hidden=NO;
        contentLbl.hidden=NO;
        _TopViewForArrows.hidden=YES;
        _mapView.hidden=YES;
       // [self showPremiumAlert];
        
    }
    else
    {
        [self refreshTable];
        [self loadDates];
        [self showPremiumFeatureView:YES];
    }
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    delegate = [AppDelegate appDelegate];
    [self.tableView registerNib:[UINib nibWithNibName:@"PlacesCell" bundle:nil] forCellReuseIdentifier:@"PlacesCell"];
    self.addPlaceCont = [[AddPlacesViewController alloc] initWithNibName:@"AddPlacesViewController2~iphone" bundle:nil];
    if([SwiftFTUtils isDeviceiPhoneFamily])
    {
        self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 90;
    }
    else
    {
        self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 120;
    }
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
       
    [self.navigationItem setTitle:NSLocalizedString(@"Location History",nil)];
    
    NSInteger child_id = delegate.selectedDashboardChild.child_id;
    int convertedChild_id = (int) child_id;
    
    location_package_id =  [CoreDataUtility fetchPackageIdForChild_id:(convertedChild_id)];
    location_package_name = [CoreDataUtility fetchPackageNameForChild_id:(convertedChild_id)];
    location_device =  [CoreDataUtility fetchPackageDeviceForChild_id:(convertedChild_id)];
    

    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86  longitude:131.20   zoom:6];
    self.mapView.camera = camera;
    
    
    
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
        CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
        if (screenRect.size.height == 568)
        {
            // this is an iPhone 5+
            imgView = [[UIImageView alloc] initWithFrame:CGRectMake(115, 152,screenRect.size.width-20,104)];
            imgView.contentMode = UIViewContentModeScaleAspectFit;
            imgView.image = [UIImage imageNamed:@"ic_empty"];
            imgView.hidden=YES;
            [self.view addSubview:imgView];
            [self.view bringSubviewToFront:imgView];
            
            contentLbl=[[UILabel alloc]initWithFrame:CGRectMake(6, 279, 362, 45)];
            contentLbl.lineBreakMode=YES;
            contentLbl.textColor=[UIColor lightGrayColor];
            contentLbl.text=[@"It seems like there is no record to\n display." myModification];
            contentLbl.font=[UIFont systemFontOfSize:14];
            contentLbl.lineBreakMode = NSLineBreakByWordWrapping;
            contentLbl.numberOfLines = 2;
            contentLbl.textAlignment = NSTextAlignmentCenter;
            contentLbl.hidden=YES;
            [self.view addSubview:contentLbl];
            [self.view bringSubviewToFront:contentLbl];
        }
        else
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
    }
    
    //DashboardChildPackageFeature *packageFeature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"geolocation"];
    if ([location_package_id isEqualToString:@"1"])
    {
       // if(packageFeature.is_time_based == 1 || packageFeature.is_count_based == 1)
           // [self showPremiumBanner:YES];
        //else
            //[self showPremiumBanner:NO];
        imgView.hidden=NO;
        contentLbl.hidden=NO;
        _TopViewForArrows.hidden=YES;
        _mapView.hidden=YES;
        [self showPremiumAlert];
        
    }
    else
    {
        [self addPullRefresh];
        [self showPremiumFeatureView:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - QBRefreshControlDelegate
-(void) addPullRefresh
{
    refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(loadDates) forControlEvents:UIControlEventValueChanged];
}

- (void)showPremiumAlert
{
    [SwiftFTUtils showSwiftPremiumPopupOn:self];
}

- (void)refreshTable
{
    
    //DashboardChildPackageFeature *packageFeature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"geolocation"];
    if ([location_package_id isEqualToString:@"1"])
    {
    
    }else{
        
        [refreshControl endRefreshing];
        [self.tableView reloadData];
    }
}

#pragma Next-Prev history
- (IBAction)requestLocHistory:(UIButton *)sender
{
    if(sender.tag == 0 && self.page < self.dates.count-1)
    {
        self.page++;
        [self loadLoactions];
    }
    else if(sender.tag == 1 && self.page > 0)
    {
        self.page --;
        [self loadLoactions];
    }
}

#pragma mark Location dates from server
-(void) loadDates
{
    
    NSLog(@"greattt--%ld",(long)delegate.selectedDashboardChild.child_id);
    self.page = 0;
    self.dates = [[NSMutableArray alloc] init];
    [SwiftFTUtils showHUDAddedTo:self.view withText:@"Loading..." animated:YES];
    
    
    /*
    
     NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:delegate.selectedDashboardChild.child_id],@"child_id", nil];
     
     NSLog(@"url = %@ and params = %@", KLocationDates, params);
     
    [JSONHTTPClient postJSONFromURLWithString:KLocationDates
                                       params:params
                                   completion:^(id json, JSONModelError *err) {
                                       
                                       NSLog(@"json = %@ and error = %@", json, err);
                                       NSString *msg = [json valueForKey:@"message"] == nil ? [kErrorGeneral myModification] : [json valueForKey:@"message"];
                                       
                                       if([[json valueForKey:@"response"] intValue] == 200)
                                       {
                                           NSArray *jsonObject =  [[json valueForKey:@"data"] copy];
                                           self.dates = [NSMutableArray arrayWithArray:jsonObject];
                                           [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                           
                                           [self loadLoactions];
                                        
                                           _TopViewForArrows.hidden=NO;
                                           _mapView.hidden=NO;
                                           imgView.hidden=YES;
                                           contentLbl.hidden=YES;
                                           
                                           if([self.dates count]==0)
                                           {
                                               imgView.hidden=NO;
                                               contentLbl.hidden=NO;
                                               _TopViewForArrows.hidden=YES;
                                               _mapView.hidden=YES;
                                           }
                                       }
                                       else
                                       {
                                           [CommonModel showAlert:@"Error!" msg:msg];
                                           [self refreshTable];
                                           [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                          
                                           imgView.hidden=NO;
                                           contentLbl.hidden=NO;
                                           _TopViewForArrows.hidden=YES;
                                           _mapView.hidden=YES;
                                       }
                                   }];
    
    
    */
    
    //---NATIVE API CALLING---//
    
    NSString *paramsStr = [NSString stringWithFormat:@"%ld", (long)delegate.selectedDashboardChild.child_id];
    NSString *url = @"";
    
    if([delegate.selectedDashboardChild.device isEqual: @"iphone"]){
        
        url = [KLocationDatesiOS stringByAppendingString:paramsStr];
    }else{
        
        url = [KLocationDatesAndroid stringByAppendingString:paramsStr];
    }

    NSLog(@"Location history = %@", url);
    
    //[[ApiManager shared] mesh_postApiWithParamString:paramsStr withApi:KLocationDates withResponse:^(NSDictionary * _Nonnull json, NSInteger errorCode, NSString * _Nonnull message)
    
    [[ApiManager shared] mesh_getApiWithApi:url withResponse:^(NSDictionary * _Nonnull json, NSInteger errorCode, NSString * _Nonnull message) {
   
         dispatch_async(dispatch_get_main_queue(), ^{
             NSLog(@"place report date response = %@", json);
             
             NSString *msg = [json valueForKey:@"message"] == nil ? [kErrorGeneral myModification] : [json valueForKey:@"message"];
             
             if([[json valueForKey:@"status"] intValue] == 200)
             {
                 NSArray *jsonObject =  [[json valueForKey:@"checkindates"] copy];
                 self.dates = [NSMutableArray arrayWithArray:jsonObject];
                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                 
                 [self loadLoactions];
                 
                 _TopViewForArrows.hidden=NO;
                 _mapView.hidden=NO;
                 imgView.hidden=YES;
                 contentLbl.hidden=YES;
                 
                 if([self.dates count]==0)
                 {
                     imgView.hidden=NO;
                     contentLbl.hidden=NO;
                     _TopViewForArrows.hidden=YES;
                     _mapView.hidden=YES;
                 }
             }
             else
             {
                 [CommonModel showAlert:@"Error!" msg:msg];
                 [self refreshTable];
                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                 
                 imgView.hidden=NO;
                 contentLbl.hidden=NO;
                 _TopViewForArrows.hidden=YES;
                 _mapView.hidden=YES;
             }
         });
         
     }];
}

-(void) loadLoactions
{
    if(self.dates.count == 0)
        return;
    
    //set first last date in between next prev button
    NSDictionary *myDict = [self.dates objectAtIndex:self.page];
    NSString *myDate = [myDict objectForKey:@"date"];
    NSString *date  = [CommonModel date:myDate oldFormat:@"YYYY-MM-dd" format:@"EEE,MMM d, yyyy"];//d EEE,MMM yy
    if(date==nil)
    {
        NSDictionary *myDict = [self.dates objectAtIndex:self.page];
           NSString *myDate = [myDict objectForKey:@"date"];
        date  = [CommonModel date:myDate oldFormat:@"YYYY-MM-dd" format:@"EEE, MM d, yyyy"];//d EEE,MMM yy
        date= myDate;
    }
    [self.locDate setText:date];
    [SwiftFTUtils showHUDAddedTo:self.view withText:[@"Loading..." myModification] animated:YES];
    
    NSDate *date1 = [CommonModel dateWithTimestamp:date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date1];
    int Day = (int)[components day];
    int month = (int)[components month];
    int year = (int)[components year];
    NSString *pDate = [NSString stringWithFormat:@"%d-%02d-%02d",year, month,Day];
    NSLog(@"here==%@",date);
    
    NSString *strdate= date;
    NSArray *arrNew=[strdate componentsSeparatedByString:@" "];
   strdate=[arrNew objectAtIndex:0];
    
    if(date1==nil)
    {
        pDate=strdate;
    }
    
    /*
     
     
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:delegate.selectedDashboardChild.child_id],@"child_id",pDate,@"date", nil];
    
//    //---SEND_HEADERS----//
//    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:kSendHeaders];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [JSONHTTPClient postJSONFromURLWithString:KLocationUrl
                                       params:params
                                   completion:^(id json, JSONModelError *err) {
                                       
//                                       //---SEND_HEADERS----//
//                                       [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:kSendHeaders];
//                                       [[NSUserDefaults standardUserDefaults] synchronize];
                                       
                                       NSLog(@"json = %@ and error = %@", json, err);
                                       
                                       NSError *error;
                                       NSString *msg = [json valueForKey:@"message"] == nil ? [kErrorGeneral myModification] : [json valueForKey:@"message"];
                                       // read response code
                                       if([[json valueForKey:@"response"] intValue] == 200)
                                       {
                                           AllLocationModel *places = [[AllLocationModel alloc] initWithDictionary:json error:&error];
                                           NSLog(@"%@",places);
                                           self.dataSource = [NSMutableArray arrayWithArray:places.data];
                                           
                                           //place marker on of first location
                                           if(self.dataSource.count > 0)
                                           {
                                               LocationModel *loc =  [self.dataSource objectAtIndex:0];
                                               [self addAnnotations:loc];
                                           }
                                       }
                                       else
                                           [CommonModel showAlert:@"Error!" msg:msg];
                                       [self refreshTable];
                                       [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                   }];
    
     */
    
    //---NATIVE API CALLING---//
    
    NSString *paramsStr = [NSString stringWithFormat:@"%ld/%@", (long)delegate.selectedDashboardChild.child_id, myDate];
    
    NSString *url = @"";
       
       if([delegate.selectedDashboardChild.device isEqual: @"iphone"]){
           
          url = [KLocationUrliOS stringByAppendingString:paramsStr];
       }else{
           
           url = [KLocationUrlAndroid stringByAppendingString:paramsStr];
       }

    [[ApiManager shared] mesh_getApiWithApi:url withResponse:^(NSDictionary * _Nonnull json, NSInteger errorCode, NSString * _Nonnull message)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSLog(@"place report date response = %@", json);

             NSError *error;
             NSString *msg = [json valueForKey:@"message"] == nil ? [kErrorGeneral myModification] : [json valueForKey:@"message"];
             // read response code
             if([[json valueForKey:@"status"] intValue] == 200)
             {
                 AllLocationModel *places = [[AllLocationModel alloc] initWithDictionary:json error:&error];
                 NSLog(@"%@",places);
                 self.dataSource = [NSMutableArray arrayWithArray:places.locations];
                 
                 //place marker on of first location
                 if(self.dataSource.count > 0)
                 {
                     LocationModel *loc =  [self.dataSource objectAtIndex:0];
                     [self addAnnotations:loc];
                 }
             }
             else
                 [CommonModel showAlert:@"Error!" msg:msg];
             [self refreshTable];
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         });
         
     }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SwiftPlacesCell *cell = (SwiftPlacesCell *)[tableView dequeueReusableCellWithIdentifier:@"PlacesCell"];
    NSString *diff= @"";
    if (cell == nil) {
        cell = (SwiftPlacesCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PlacesCell"];
    }
    LocationModel *loc =  [self.dataSource objectAtIndex:indexPath.row];
    if(indexPath.row != 0)
    {
        LocationModel *nextLoc = [self.dataSource objectAtIndex:indexPath.row - 1];
        NSDate *startDate = [CommonModel dateWithTimestamp:loc.time_in];
        NSDate *endDate = [CommonModel dateWithTimestamp:nextLoc.time_in];
        diff = [CommonModel remaningTime:startDate endDate:endDate];
    }
    
    NSString* serverdate = [CommonModel date:loc.time_in oldFormat:@"YYYY-MM-dd HH:mm:ss" format:@"yyyy-MM-dd HH:mm"];
    if(serverdate==nil)
    {
        serverdate = loc.time_in;
    
    }
    
    NSDateFormatter *dateFormat7 = [[NSDateFormatter alloc] init];
    
    [dateFormat7 setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date7 = [dateFormat7 dateFromString:serverdate];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
        
    NSString *todayDate = [formatter stringFromDate:date7];
    NSLog(@"%@",todayDate);
    
    NSLog(@"%@",diff);
    
    if ([diff isEqualToString:@""])
    {
        NSLog(@"%@",diff);
        cell.place.text =[NSString stringWithFormat:@"%@",todayDate];
        NSLog(@"%@",cell.place.text);
    }
    else
    {
        cell.place.text =[NSString stringWithFormat:@"%@  %@",todayDate,diff];
    }
    //UK Locale issue
    NSLog(@"mus=%@",cell.place.text);
    if(todayDate==nil)
    {
        cell.place.text=serverdate;
    
    }
    
    
    NSLog(@"%@",loc.location);
    if (loc.location == (id)[NSNull null] || loc.location.length == 0 )
    {
        CGFloat strFloat = (CGFloat)[loc.latitude floatValue];
        
        CGFloat strFloat2 = (CGFloat)[loc.longitude floatValue];
        
        NSString* latVal = [NSString stringWithFormat:@"%.02f", strFloat];
        
        NSString* langVal = [NSString stringWithFormat:@"%.02f", strFloat2];
        
        cell.address.text=[NSString stringWithFormat:@"%@ %@, %@",[@"At" myModification],latVal,langVal];
        
    }
    else if ([loc.location isEqualToString:@""])
    {
        CGFloat strFloat = (CGFloat)[loc.latitude floatValue];
        
        CGFloat strFloat2 = (CGFloat)[loc.longitude floatValue];

        NSString* latVal = [NSString stringWithFormat:@"%.02f", strFloat];

        NSString* langVal = [NSString stringWithFormat:@"%.02f", strFloat2];
       
        cell.address.text=[NSString stringWithFormat:@"%@ %@, %@",[@"At" myModification],latVal,langVal];
    }
    else
    {
        cell.address.text = [NSString stringWithFormat:@"%@ %@",[@"Near" myModification],loc.location];//@"Jail road Lahore,Pakistan";
    }
    
    cell.editPlace.tag = indexPath.row;
    
    [cell.editPlace setImage:[UIImage imageNamed:@"geo_edit11.png"] forState:UIControlStateNormal];
    
    NSString *imgName =[NSString stringWithFormat:@"geo0_%i.png",(int)indexPath.row%4 + 1 ];
    
    [cell.placeImg setImage:[UIImage imageNamed:imgName]];
    
    [cell.editPlace addTarget:self action:@selector(addPlace:) forControlEvents:UIControlEventTouchUpInside];
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

-(void) addPlace:(UIButton *)sender
{
    LocationModel *loc =  [self.dataSource objectAtIndex:sender.tag];
    PlaceModel *place = [[PlaceModel alloc] init];
    place.latitude = loc.latitude;
    place.longitude = loc.longitude;
    place.location = loc.location;
    
    [self.navigationController pushViewController:self.addPlaceCont animated:YES];
    self.addPlaceCont.mode = @"addPlace";
    self.addPlaceCont.place = place;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    LocationModel *loc =  [self.dataSource objectAtIndex:indexPath.row];
    [self addAnnotations:loc];
}
#pragma mark - GMSMapViewDelegate

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    NSLog(@"You tapped at %f,%f", coordinate.latitude, coordinate.longitude);
}

#pragma mark Annotations on MAP

-(void) addAnnotations:(LocationModel *)loc
{
    [self.mapView clear];
    GMSMarker *sydneyMarker = [[GMSMarker alloc] init];
    sydneyMarker.icon = [UIImage imageNamed:@"v2_map_pin"];
    sydneyMarker.position = CLLocationCoordinate2DMake(loc.latitude.doubleValue, loc.longitude.doubleValue);
    sydneyMarker.map = self.mapView;
    GMSCameraPosition *sydney = [GMSCameraPosition cameraWithLatitude:loc.latitude.doubleValue
                                                            longitude:loc.longitude.doubleValue
                                                                 zoom:15];
    [self.mapView setCamera:sydney];
}

- (IBAction)ReqLocHis:(UIButton *)sender
{
    if(sender.tag == 0 && self.page < self.dates.count-1)
    {
        self.page++;
        [self loadLoactions];
    }
    else if(sender.tag == 1 && self.page > 0)
    {
        self.page --;
        [self loadLoactions];
    }
}
- (IBAction)LocHist2:(id)sender
{
    
}
@end
