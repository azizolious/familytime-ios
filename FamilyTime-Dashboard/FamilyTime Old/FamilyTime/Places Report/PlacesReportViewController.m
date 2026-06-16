//
//  PlacesReportViewController.m
//  FamilyTime
//
//  Created by Sora Code on 12/10/14.
//  Copyright (c) 2014 SoraCode. All rights reserved.
//
// Refernce
//http://www.devfright.com/mkpointannotation-tutorial/

#import "NSString+LockMustafa.h"

#import "PlacesReportViewController.h"
#import "MBProgressHUD.h"
//#import "JSONHTTPClient.h"
#import "AppDelegate.h"
#import "InstantLocation.h"
#import "PlacesCell.h"
#import "FTD.h"
#import "FTUtils.h"
//#import <Google/Analytics.h>
#import <CoreLocation/CoreLocation.h>
#import "FamilyTime-Swift.h"
@class CoreDataUtility;

#define iPhone6 ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width) == 667)
#define iPhone6Plus ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width) == 736)
#define iPhone5 ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width) == 320)

NSString *place_package_id = @"";
NSString *place_package_name = @"";
NSString *place_device = @"";

AppDelegate *delegate;
UIRefreshControl *  refreshControl;
@interface PlacesReportViewController ()

@end

@implementation PlacesReportViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
//    [ZendeskChatManager trackEvent:@"Places history"];
    
   
    if (([place_device isEqualToString:@"iphone"] && ([place_package_id isEqualToString:@"6"])) || ([place_device isEqualToString:@"android"] && ([place_package_id isEqualToString:@"1"])))
    {
//        if(packageFeature.is_time_based == 1 || packageFeature.is_count_based == 1)
       // [self showPremiumBanner:YES];
//        else
//            [self showPremiumBanner:NO];
        
       // [self showPremiumAlert];
        
        imgView.hidden=NO;
        contentLbl.hidden=NO;
        oopsLbl.hidden=NO;
        _TopViewForArrows.hidden=YES;
        _mapView.hidden=YES;
    }
    else
    {
        [self refreshTable];
        [self loadDates];
    }

   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    delegate = [AppDelegate appDelegate];
    [self.tableView registerNib:[UINib nibWithNibName:@"PlacesCell" bundle:nil] forCellReuseIdentifier:@"PlacesCell"];
    
    NSInteger child_id = delegate.selectedDashboardChild.child_id;
    int convertedChild_id = (int) child_id;
    
    place_package_id =  [CoreDataUtility fetchPackageIdForChild_id:(convertedChild_id)];
    place_package_name = [CoreDataUtility fetchPackageNameForChild_id:(convertedChild_id)];
    place_device =  [CoreDataUtility fetchPackageDeviceForChild_id:(convertedChild_id)];
    
    if([SwiftFTUtils isDeviceiPhoneFamily])
        self.tableView.rowHeight = 70;
    else
        self.tableView.rowHeight = 100;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.navigationItem setTitle:[@"Places History" myModification]];
    
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
        
        oopsLbl=[[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2-40, 461, 70, 30)];
        oopsLbl.text=[@"Oops!" myModification];
        oopsLbl.font=[UIFont boldSystemFontOfSize:20];
        oopsLbl.hidden=YES;
        [self.view addSubview:oopsLbl];
        [self.view bringSubviewToFront:oopsLbl];
        
        contentLbl=[[UILabel alloc]initWithFrame:CGRectMake(203, 511, 362, 45)];
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
            imgView = [[UIImageView alloc] initWithFrame:CGRectMake(115-20, 152,screenRect.size.width-20,104)];
            imgView.contentMode = UIViewContentModeScaleAspectFit;
            imgView.image = [UIImage imageNamed:@"ic_empty"];
            imgView.hidden=YES;
            [self.view addSubview:imgView];
            [self.view bringSubviewToFront:imgView];
            
            oopsLbl=[[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2-20, 259, 70, 30)];
            oopsLbl.text=[@"Oops!" myModification];
            oopsLbl.font=[UIFont boldSystemFontOfSize:18];
            oopsLbl.hidden=YES;
            [self.view addSubview:oopsLbl];
            [self.view bringSubviewToFront:oopsLbl];
            
            contentLbl=[[UILabel alloc]initWithFrame:CGRectMake(6-4, 294, 362, 45)];
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
            
            oopsLbl=[[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2-20, 266, 70, 30)];
            oopsLbl.text=[@"Oops!" myModification];
            oopsLbl.font=[UIFont boldSystemFontOfSize:18];
            oopsLbl.hidden=YES;
            [self.view addSubview:oopsLbl];
            [self.view bringSubviewToFront:oopsLbl];
        
        contentLbl=[[UILabel alloc]initWithFrame:CGRectMake(6, 301, 362, 45)];
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
    
    //DashboardChildPackageFeature *packageFeature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"place"];
    if ([place_package_id isEqualToString:@"1"])
    {
//        if(packageFeature.is_time_based == 1 || packageFeature.is_count_based == 1)
        //[self showPremiumBanner:YES];
//        else
//            [self showPremiumBanner:NO];
        
        imgView.hidden=NO;
        contentLbl.hidden=NO;
        oopsLbl.hidden=NO;
        _TopViewForArrows.hidden=YES;
        _mapView.hidden=YES;
        
        [self showPremiumAlert];
    }
    else
    {
        [self addPullRefresh];
        [self refreshTable];
        [self loadDates];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - QBRefreshControlDelegate
-(void) addPullRefresh
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
    self.page = 0;
    self.dates = [[NSMutableArray alloc] init];
    [SwiftFTUtils showHUDAddedTo:self.view withText:[@"Loading..." myModification] animated:YES];
    
    
    
    /*
    
     NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:delegate.selectedDashboardChild.child_id],@"child_id", nil];
     
    [JSONHTTPClient postJSONFromURLWithString:KPlacesReportDatesUrl
                                       params:params
                                   completion:^(id json, JSONModelError *err) {
                                       
                                       NSLog(@"place report date response = %@", json);
                                       
                                       NSString *msg = [json valueForKey:@"message"] == nil ? [kErrorGeneral myModification] : [json valueForKey:@"message"];
                                       if([[json valueForKey:@"response"] intValue] == 200)
                                       {
                                           NSArray *jsonObject =  [[json valueForKey:@"data"] copy];
                                           self.dates = [NSMutableArray arrayWithArray:jsonObject];
                                           [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                           [self loadLoactions];
                                           
                                           imgView.hidden=YES;
                                           contentLbl.hidden=YES;
                                           _TopViewForArrows.hidden=NO;
                                           _mapView.hidden=NO;
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
                                           [CommonModel showAlert:[@"Error!" myModification] msg:msg];
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
    //NSString *url = [KPlacesReportDatesUrl stringByAppendingString:paramsStr];
    
    NSString *url = @"";
    
    if([delegate.selectedDashboardChild.device isEqual: @"iphone"]){
        
       url = [KPlacesReportDatesUrliOS stringByAppendingString:paramsStr];
    }else{
        
        url = [KPlacesReportDatesUrlAndroid stringByAppendingString:paramsStr];
    }
    
   [[ApiManager shared] mesh_getApiWithApi:url withResponse:^(NSDictionary * _Nonnull json, NSInteger errorCode, NSString * _Nonnull message)
     {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"place report date response = %@", json);
            
            NSString *msg = [json valueForKey:@"message"] == nil ? [kErrorGeneral myModification] : [json valueForKey:@"message"];
            if([[json valueForKey:@"status"] intValue] == 200)
            {
                NSArray *jsonObject =  [[json valueForKey:@"checkindates"] copy];
                self.dates = [NSMutableArray arrayWithArray:jsonObject];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [self loadLoactions];
                
                imgView.hidden=YES;
                contentLbl.hidden=YES;
                oopsLbl.hidden=YES;
                _TopViewForArrows.hidden=NO;
                _mapView.hidden=NO;
                if([self.dates count]==0)
                {
                    imgView.hidden=NO;
                    contentLbl.hidden=NO;
                    oopsLbl.hidden=NO;
                    _TopViewForArrows.hidden=YES;
                    _mapView.hidden=YES;
                }
            }
            else
            {
                [CommonModel showAlert:[@"Error!" myModification] msg:msg];
                [self refreshTable];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                
                imgView.hidden=NO;
                contentLbl.hidden=NO;
                oopsLbl.hidden=NO;
                _TopViewForArrows.hidden=YES;
                _mapView.hidden=YES;
            }
        });
        
    }];
    
    
    
    
    
}

- (void)showPremiumAlert
{
    [SwiftFTUtils showSwiftPremiumPopupOn:self];
}

-(void) loadLoactions
{
    if(self.dates.count == 0)
        return;
    
    //set first last date in between next prev button
    NSDictionary *myDict = [self.dates objectAtIndex:self.page];
    NSString *myDate = [myDict objectForKey:@"date"];
    NSString *date  = [CommonModel date:myDate oldFormat:@"YYYY-MM-dd" format:@"EEE, MMM d, yyyy"];//d EEE,MMM yy
    
    if(date==nil)
    {
        //        date  = [CommonModel date:[self.dates objectAtIndex:self.page] oldFormat:@"YYYY-MM-dd HH:mm:ss" format:@"YYYY-MM-dd HH:mm:ss"];//d EEE,MMM yy
        
        date= myDate;
    }
    [self.locDate setText:date];
        
    
    [SwiftFTUtils showHUDAddedTo:self.view withText:[@"Loading..." myModification] animated:YES];
    
    NSDate *date1 = date;
    
//    NSDate *date1 = [CommonModel dateWithTimestamp:[self.dates objectAtIndex:self.page]];
//    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date1];
//    int Day = (int)[components day];
//    int month = (int)[components month];
//    int year = (int)[components year];
//    NSString *pDate = [NSString stringWithFormat:@"%d-%02d-%02d",year, month,Day];
    
    
    
//    NSString *strdate= [self.dates objectAtIndex:self.page];
//    NSArray *arrNew=[strdate componentsSeparatedByString:@" "];
//    strdate=[arrNew objectAtIndex:0];
//    
//    if(date1==nil)
//    {
//        pDate=strdate;
//    }

    /*
     
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:delegate.selectedDashboardChild.child_id],@"child_id",date1,@"date", nil];
    [JSONHTTPClient postJSONFromURLWithString:KPlaceHistoryUrl
                                       params:params
                                   completion:^(id json, JSONModelError *err) {
                                       NSError *error;
                                       NSString *msg = [json valueForKey:@"message"] == nil ? [kErrorGeneral myModification] : [json valueForKey:@"message"];
                                       // read response code
                                       if([[json valueForKey:@"response"] intValue] == 200)
                                       {
                                           AllPlacesVisitModel *places = [[AllPlacesVisitModel alloc] initWithDictionary:json error:&error];
                                           NSLog(@"%@",places);
                                           self.dataSource = [NSMutableArray arrayWithArray:places.data];
                                           
                                           //place marker on of first location
                                           if(self.dataSource.count > 0)
                                           {
                                               PlaceVisit *visit =  [self.dataSource objectAtIndex:0];
                                               [self addAnnotations:visit];
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
        
       url = [KPlaceHistoryUrliOS stringByAppendingString:paramsStr];
    }else{
        
        url = [KPlaceHistoryUrlAndroid stringByAppendingString:paramsStr];
    }
    
    [[ApiManager shared] mesh_getApiWithApi:url withResponse:^(NSDictionary * _Nonnull json, NSInteger errorCode, NSString * _Nonnull message)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSError *error;
             NSString *msg = [json valueForKey:@"message"] == nil ? [kErrorGeneral myModification] : [json valueForKey:@"message"];
             // read response code
             
             NSLog(@"place history detail (placevisit) response = %@", json);
             
             if([[json valueForKey:@"status"] intValue] == 200)
             {
                 AllPlacesVisitModel *places = [[AllPlacesVisitModel alloc] initWithDictionary:json error:&error];
                 NSLog(@"%@",places);
                 self.dataSource = [NSMutableArray arrayWithArray:places.places];
                 
                 //place marker on of first location
                 if(self.dataSource.count > 0)
                 {
                     PlaceVisit *visit =  [self.dataSource objectAtIndex:0];
                     [self addAnnotations:visit];
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
    if (cell == nil) {
        cell = (SwiftPlacesCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PlacesCell"];
    }
    PlaceVisit *loc =  [self.dataSource objectAtIndex:indexPath.row];
    
    NSString *imgName =[NSString stringWithFormat:@"geo0_%i.png",(int)indexPath.row%4 + 1 ];
    [cell.placeImg setImage:[UIImage imageNamed:imgName]];
    cell.place.text = loc.location;
    if ([loc.placecount intValue] == 1)
        cell.address.text = [NSString stringWithFormat:@"%@ visit",loc.placecount];
    else
        cell.address.text = [NSString stringWithFormat:@"%@ visits",loc.placecount];
    cell.editPlace.hidden = YES;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PlaceVisit *visit =  [self.dataSource objectAtIndex:indexPath.row];
    [self addAnnotations:visit];
}
#pragma mark - GMSMapViewDelegate

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    NSLog(@"You tapped at %f,%f", coordinate.latitude, coordinate.longitude);
}

#pragma mark Annotations on MAP

- (void) addAnnotations:(PlaceVisit *)loc
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
    if(sender.tag == 0 && self.page < self.dates.count-1){
        self.page++;
        [self loadLoactions];
    }
    else if(sender.tag == 1 && self.page > 0){
        self.page --;
        [self loadLoactions];
    }
}

- (IBAction)LocHist2:(id)sender {
}

- (void)showAllMarkers
{
    PlaceVisit *firstVisist = (PlaceVisit *)[self.dataSource firstObject];
    CLLocationCoordinate2D firstLocation = CLLocationCoordinate2DMake(firstVisist.latitude.doubleValue, firstVisist.longitude.doubleValue);
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:firstLocation coordinate:firstLocation];
    
    for (PlaceVisit *marker in self.dataSource) {
        CLLocationCoordinate2D location = CLLocationCoordinate2DMake(marker.latitude.doubleValue, marker.longitude.doubleValue);
        bounds = [bounds includingCoordinate:location];
    }
    
    [self.mapView animateWithCameraUpdate:[GMSCameraUpdate fitBounds:bounds withPadding:50.0f]];
}
@end
