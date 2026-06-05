//
//  ViewController.m
//  FamilyTime - Dashboard
//
//  Created by Ahmad on 8/18/17.
//  Copyright © 2017 SoraCode. All rights reserved.
//

#import "FamilyMapViewController.h"
#import "MBProgressHUD.h"
//#import "JSONHTTPClient.h"
#import "FTUtils.h"
//#import <Google/Analytics.h>
#import "DataModel.h"
#import "Constant.h"
#import "CommonModel.h"
#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import "Constant.h"
#import "NSString+LockMustafa.h"
#import "FamilyTime-Swift.h"

@class CoreDataUtility;

AppDelegate *delegate;

NSString *map_package_id = @"";
NSString *map_package_name = @"";
NSString *map_device = @"";

@interface FamilyMapViewController ()<CLLocationManagerDelegate>
{
    CLLocation* location2233;
}
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation FamilyMapViewController

@synthesize mapView=_mapView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
    self.title = [@"FamilyLocator" myModification];
    self.mapView.hidden=NO;
    
    [ZendeskChatManager trackEvent:@"Family Locator"];
    
    NSInteger child_id = delegate.selectedDashboardChild.child_id;
    int convertedChild_id = (int) child_id;
    
    map_package_id =  [CoreDataUtility fetchPackageIdForChild_id:(convertedChild_id)];
    map_package_name = [CoreDataUtility fetchPackageNameForChild_id:(convertedChild_id)];
    map_device =  [CoreDataUtility fetchPackageDeviceForChild_id:(convertedChild_id)];
    
    
    //    [self.locationManager startUpdatingLocation];
    
    if (self.locationManager == nil)
        self.locationManager = [[CLLocationManager alloc] init];
    
    [self.locationManager requestWhenInUseAuthorization];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    
    _allmarkerts=[NSMutableArray new];
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(Add:)];
    self.navigationItem.rightBarButtonItem = button;
    
    // Do any additional setup after loading the view from its nib.
    //    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86  longitude:131.20   zoom:6];
    //    self.mapView.camera = camera;
    self.mapView.delegate=self;
    //    [self addAnnotations:nil];
    //    [self loadAllFamilyLocations];
    if ([map_package_id isEqualToString:@"1"]) {
        //if(packageFeature.is_time_based == 1 || packageFeature.is_count_based == 1)
           // [self showPremiumBanner:YES];
        //else
            //[self showPremiumBanner:NO];
        [self showPremiumAlert];
    } else {
        [self loadAllFamilyLocations];
       // [self showPremiumFeatureView:YES];
    }
    //    [self AllChildren];
   // DashboardChildPackageFeature *packageFeature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"geolocation"];
   
}


-(IBAction)Add:(id)sender {
    //    [_allmarkerts removeAllObjects];
    [self.locationManager startUpdatingLocation];
    [_mapView clear];
    NSLog(@"here   ----");
    if ([map_package_id isEqualToString:@"1"]) {
        //if(packageFeature.is_time_based == 1 || packageFeature.is_count_based == 1)
           // [self showPremiumBanner:YES];
        //else
            //[self showPremiumBanner:NO];
        [self showPremiumAlert];
    } else {
        [self loadAllFamilyLocations];
       // [self showPremiumFeatureView:YES];
    }
}

-(void) addAnnotations:(CLLocation *)loc
{
    //    [self.mapView clear];
    GMSMarker *sydneyMarker = [[GMSMarker alloc] init];
    //    sydneyMarker.icon = [UIImage imageNamed:@"pin_man"];
    sydneyMarker.position = CLLocationCoordinate2DMake(loc.coordinate.latitude, loc.coordinate.longitude);
    sydneyMarker.map = self.mapView;
    //    GMSCameraPosition *sydney = [GMSCameraPosition cameraWithLatitude:loc.coordinate.latitude
    //                                                            longitude:loc.coordinate.longitude
    //                                                                 zoom:15];
    
    
    if ([[delegate.parent.relationship lowercaseString] isEqualToString:NSLocalizedString(@"Mother",nil)]) {
        sydneyMarker.icon = [UIImage imageNamed:@"pin_woman"];
    }
    else
    {
        sydneyMarker.icon = [UIImage imageNamed:@"pin_man"];
    }
    
    sydneyMarker.title   = [@"You" myModification];
    sydneyMarker.snippet = [NSString stringWithFormat:@"%@",[[UIDevice currentDevice] model]];
    
    
    [_allmarkerts addObject:sydneyMarker];
    
    //    [self.mapView setCamera:sydneyMarker];
    //    [self loadAllFamilyLocations];
}

- (void)showPremiumAlert
{
    [SwiftFTUtils showSwiftPremiumPopupOn:self];
}

-(void) addAnnotationsNew:(NSDictionary *)loc
{
    if(([loc objectForKey:@"latitude"]==[NSNull null])||([loc objectForKey:@"longitude"]==[NSNull null]))
    {
        
    }
    else
    {
        //gender
        NSLog(@"haha%f",[[loc objectForKey:@"latitude"] doubleValue]);
        //    [self.mapView clear];
        GMSMarker *sydneyMarker = [[GMSMarker alloc] init];
        //    sydneyMarker.icon = [UIImage imageNamed:@"glow-marker"];
        sydneyMarker.position = CLLocationCoordinate2DMake([[loc objectForKey:@"latitude"] doubleValue], [[loc objectForKey:@"longitude"] doubleValue]);
        
        /*
         [self drawRoute:CLLocationCoordinate2DMake([[loc objectForKey:@"latitude"] doubleValue], [[loc objectForKey:@"longitude"] doubleValue]) destination:CLLocationCoordinate2DMake([[loc objectForKey:@"latitude"] doubleValue], [[loc objectForKey:@"longitude"] doubleValue])];
         */
        sydneyMarker.map = self.mapView;
        
        sydneyMarker.title = [loc objectForKey:@"name"];
        
        if([loc objectForKey:@"address"]!=[NSNull null])
        {
            sydneyMarker.snippet = [loc objectForKey:@"address"];
        }
        else
        {
            //          sydneyMarker.snippet = [NSString stringWithFormat:@"At %f,%f",[[loc objectForKey:@"latitude"] doubleValue],[[loc objectForKey:@"longitude"] doubleValue]] ;
            sydneyMarker.snippet = @"";
        }
        
        //COMMENTED CODE HERE
        /*
         //HERE
         GMSMutablePath *path = [GMSMutablePath path];
         [path addCoordinate:CLLocationCoordinate2DMake(@([[loc objectForKey:@"latitude"] doubleValue]).doubleValue,@([[loc objectForKey:@"longitude"] doubleValue]).doubleValue)];
         [path addCoordinate:CLLocationCoordinate2DMake(@(31.53125).doubleValue,@(74.352886).doubleValue)];
         //      [path addCoordinate:CLLocationCoordinate2DMake(@(31.53125).doubleValue,@(71.8567).doubleValue)];
         //63.198073
         GMSPolyline *rectangle = [GMSPolyline polylineWithPath:path];
         rectangle.strokeWidth = 2.f;
         rectangle.map = _mapView;
         
         //      self.view=_mapView;
         //HERE
         */
        
        
        NSLog(@"loc = %@", loc);
        
        
        //    if([[loc objectForKey:@"gender"] isEqualToString:@"male"])
        
        //---SANA CRASH FIXED---//---IF GENDER IS NULL THEN SHOW DEFAULT MALE---//
        if([loc objectForKey:@"gender"] == [NSNull null] || [[loc objectForKey:@"gender"] isEqualToString:@"male"] || [[loc objectForKey:@"gender"] isEqualToString:@"Male"])
        {
            if([[loc objectForKey:@"color"] isEqualToString:@"orange"])
            {
                sydneyMarker.icon = [UIImage imageNamed:@"o_pin_boy"];
            }
            if([[loc objectForKey:@"color"] isEqualToString:@"red"])
            {
                sydneyMarker.icon = [UIImage imageNamed:@"r_pin_boy"];
            }
            if([[loc objectForKey:@"color"] isEqualToString:@"purple"])
            {
                sydneyMarker.icon = [UIImage imageNamed:@"p_pin_boy"];
            }
            if([[loc objectForKey:@"color"] isEqualToString:@"green"])
            {
                sydneyMarker.icon = [UIImage imageNamed:@"g_pin_boy"];
            }
        }
        else if([[loc objectForKey:@"gender"] isEqualToString:@"Female"] || [[loc objectForKey:@"gender"] isEqualToString:@"female"])
        {
            if([[loc objectForKey:@"color"] isEqualToString:@"orange"])
            {
                sydneyMarker.icon = [UIImage imageNamed:@"o_pin_girl"];
            }
            if([[loc objectForKey:@"color"] isEqualToString:@"red"])
            {
                sydneyMarker.icon = [UIImage imageNamed:@"r_pin_girl"];
            }
            if([[loc objectForKey:@"color"] isEqualToString:@"purple"])
            {
                sydneyMarker.icon = [UIImage imageNamed:@"p_pin_girl"];
            }
            if([[loc objectForKey:@"color"] isEqualToString:@"green"])
            {
                sydneyMarker.icon = [UIImage imageNamed:@"g_pin_girl"];
            }
        }
        //    sydneyMarker.icon = [GMSMarker markerImageWithColor:[UIColor blackColor]];
        
        //    if([[loc objectForKey:@"gender"] isEqualToString:@"male"])
        //    {
        //
        //    }
        //    if([[loc objectForKey:@"gender"] isEqualToString:@"male"])
        //    {
        //
        //    }
        
        
        //    GMSCameraPosition *sydney = [GMSCameraPosition cameraWithLatitude:[[loc objectForKey:@"latitude"] doubleValue]
        //                                                            longitude:[[loc objectForKey:@"longitude"] doubleValue]
        //                                                                 zoom:6];
        //    sydneyMarker.title = @"London";
        //    sydneyMarker.snippet = @"Population: 8,174,100";
        //    [self.mapView setCamera:sydney];
        
        
        
        [_allmarkerts addObject:sydneyMarker];
    }
}

#pragma mark - GMSMapViewDelegate

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    NSLog(@"You tapped at %f,%f", coordinate.latitude, coordinate.longitude);
}

- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker
{
    NSLog(@"You tapped at %@", marker.title);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void) loadAllFamilyLocations
{
    
    //    [_mapView clear];
    [_allmarkerts removeAllObjects];
    
    //set first last date in between next prev button
    //    NSString *date  = [CommonModel date:[self.dates objectAtIndex:self.page] oldFormat:@"YYYY-MM-dd HH:mm:ss" format:@"EEE, MMM d, yyyy"];//d EEE,MMM yy
    //    [self.locDate setText:date];
    [SwiftFTUtils showHUDAddedTo:self.view withText:[@"Loading..." myModification] animated:YES];
    
    
    //   NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:delegate.selectedDashboardChild.child_id],@"child_id",pDate,@"date", nil];
    
    _mapView.myLocationEnabled = NO;
    
    
    [[ApiManager shared] commonGetApiWithVC:self andUrl:kFamilyMap_Mesh2 withResponse:^(id  _Nonnull response, JSONModelError * _Nonnull error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"response = %@", response);
            NSString *msg = [response valueForKey:@"message"] == nil ? [kErrorGeneral myModification] : [response valueForKey:@"message"];
            
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            if([[response objectForKey:@"status"]intValue] == 200)
            {
                [self addAnnotations:location2233];
                
                NSMutableArray *locations = [[response valueForKey:@"response"] mutableCopy];
                //place marker on of first location
                for(int k=0;k<locations.count;k++)
                    [self addAnnotationsNew:[locations objectAtIndex:k]];
                
                [self loadtoActuall];
            }
            else
            {
                [CommonModel showAlert:@"Error!" msg:msg];
            }
        });
    } failure:^(NSString * _Nonnull error, NSInteger errorCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [CommonModel showAlert:@"Error!" msg:error];
        });
    }];
}


-(void)loadtoActuall
{
    
    //    NSArray *myMarkers;   // array of marker which sets in Mapview
    
    NSArray *myMarkers=[_allmarkerts copy];
    //     NSArray *myMarkers=_mapView.
    GMSMutablePath *path = [GMSMutablePath path];
    
    for (GMSMarker *marker in myMarkers)
    {
        [path addCoordinate: marker.position];
    }
    
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithPath:path];
    
    //    [_mapView animateWithCameraUpdate:[GMSCameraUpdate fitBounds:bounds]];
    //    previous is 170
    
    [_mapView animateWithCameraUpdate:[GMSCameraUpdate fitBounds:bounds withPadding:90]];
    //    [_mapView setCamera:[GMSCameraUpdate fitBounds:bounds withPadding:140]];
    //[_mapView setCamera:];
    
    NSLog(@"zoom max level=%f",_mapView.maxZoom);
    NSLog(@"zoom min level=%f",_mapView.minZoom);
    NSLog(@"current zoom level=%f",_mapView.camera.zoom);
    //    if(_mapView.camera.zoom<15)
    //    {
    //
    //        CGPoint point = mapView.center;
    //        CLLocationCoordinate2D coor = [_mapView.projection coordinateForPoint:point];
    //
    //
    ////        GMSMarker *markerlast=[myMarkers objectAtIndex:myMarkers.count-1];
    //
    //        GMSCameraPosition *sydney = [GMSCameraPosition cameraWithLatitude:coor.latitude
    //                                                                longitude:coor.longitude
    //                                                                     zoom:15];
    //        [self.mapView setCamera:sydney];
    //    }
    
    self.mapView.hidden = NO;
}

- (void)focusMapToShowAllMarkers
{
    //     NSArray *myMarkers;
    //    CLLocationCoordinate2D myLocation = ((GMSMarker *)_markers.firstObject).position;
    //    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:myLocation coordinate:myLocation];
    //
    //    for (GMSMarker *marker in _markers)
    //        bounds = [bounds includingCoordinate:marker.position];
    //
    //    [_mapView animateWithCameraUpdate:[GMSCameraUpdate fitBounds:bounds withPadding:15.0f]];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    // If it's a relatively recent event, turn off updates to save power.
    
    
    //     [_mapView clear];
    location2233 = [locations lastObject];
    //    [self addAnnotations:location2233];
    
    [self.locationManager stopUpdatingLocation];
    
    
    //    NSDate* eventDate = location.timestamp;
    //    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    //    if (fabs(howRecent) < 15.0) {
    //        self.currentLocation = location.coordinate;
    //        [self.view setNeedsDisplay];
    //        [self.locationManager stopUpdatingLocation];
    //        [self setLocRadius];
    //    }
}

-(void)AllChildren
{
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"ChildrenAll"]!=nil)
    {
        NSArray *arr= [[NSUserDefaults standardUserDefaults]objectForKey:@"ChildrenAll"];
        for(int k=0;k<arr.count;k++)
        {
            [self addAnnotationsNew11:[arr objectAtIndex:k]];
        }
    }
    [self loadtoActuall];
}

-(void) addAnnotationsNew11:(NSDictionary *)loc
{
    
    NSString *strlat  = [loc objectForKey:@"lat"];
    NSString *strlong = [loc objectForKey:@"long"];
    
    //gender
    //    NSLog(@"haha%f",[[loc objectForKey:@"latitude"] doubleValue]);
    //    [self.mapView clear];
    GMSMarker *sydneyMarker = [[GMSMarker alloc] init];
    //    sydneyMarker.icon = [UIImage imageNamed:@"glow-marker"];
    sydneyMarker.position = CLLocationCoordinate2DMake([strlat doubleValue], [strlong doubleValue]);
    sydneyMarker.map = self.mapView;
    
    sydneyMarker.title = @"";
    sydneyMarker.snippet = @"";
    
    //    if([[loc objectForKey:@"gender"] isEqualToString:@"male"])
    //    {
    //
    //        if([[loc objectForKey:@"color"] isEqualToString:@"orange"])
    //        {
    //            sydneyMarker.icon = [UIImage imageNamed:@"o_pin_boy"];
    //        }
    //        if([[loc objectForKey:@"color"] isEqualToString:@"red"])
    //        {
    //            sydneyMarker.icon = [UIImage imageNamed:@"r_pin_boy"];
    //        }
    //        if([[loc objectForKey:@"color"] isEqualToString:@"purple"])
    //        {
    //            sydneyMarker.icon = [UIImage imageNamed:@"p_pin_boy"];
    //        }
    //        if([[loc objectForKey:@"color"] isEqualToString:@"green"])
    //        {
    //            sydneyMarker.icon = [UIImage imageNamed:@"g_pin_boy"];
    //        }
    //    }
    //    else if([[loc objectForKey:@"gender"] isEqualToString:@"female"])
    //    {
    //
    //        if([[loc objectForKey:@"color"] isEqualToString:@"orange"])
    //        {
    //            sydneyMarker.icon = [UIImage imageNamed:@"o_pin_girl"];
    //        }
    //        if([[loc objectForKey:@"color"] isEqualToString:@"red"])
    //        {
    //            sydneyMarker.icon = [UIImage imageNamed:@"r_pin_girl"];
    //        }
    //        if([[loc objectForKey:@"color"] isEqualToString:@"purple"])
    //        {
    //            sydneyMarker.icon = [UIImage imageNamed:@"p_pin_girl"];
    //        }
    //        if([[loc objectForKey:@"color"] isEqualToString:@"green"])
    //        {
    //            sydneyMarker.icon = [UIImage imageNamed:@"g_pin_girl"];
    //        }
    //
    //    }
    sydneyMarker.icon = [UIImage imageNamed:@"g_pin_boy"];
    
    [_allmarkerts addObject:sydneyMarker];
}


#pragma mark New Drawing Lines
- (void)drawRoute :(CLLocationCoordinate2D)myOrigin destination:(CLLocationCoordinate2D)myDestination
{
    [self fetchPolylineWithOrigin:myOrigin destination:myDestination completionHandler:^(GMSPolyline *polyline1)
     {
         if(polyline1)
             polyline1.map = _mapView;
     }];
}


- (void)fetchPolylineWithOrigin:(CLLocationCoordinate2D )origin destination:(CLLocationCoordinate2D)destination completionHandler:(void (^)(GMSPolyline *))completionHandler
{
    NSString *originString = [NSString stringWithFormat:@"%f,%f", origin.latitude, origin.longitude];
    NSString *destinationString = [NSString stringWithFormat:@"%f,%f", destination.latitude, destination.longitude];
    NSString *directionsAPI = @"https://maps.googleapis.com/maps/api/directions/json?";
    NSString *directionsUrlString = [NSString stringWithFormat:@"%@&origin=%@&destination=%@&mode=driving", directionsAPI, originString, destinationString];
    NSURL *directionsUrl = [NSURL URLWithString:directionsUrlString];
    
    
    NSURLSessionDataTask *fetchDirectionsTask = [[NSURLSession sharedSession] dataTaskWithURL:directionsUrl completionHandler:
                                                 ^(NSData *data, NSURLResponse *response, NSError *error)
                                                 {
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         NSError *error;
                                                         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                                         if(error)
                                                         {
                                                             if(completionHandler)
                                                                 completionHandler(nil);
                                                             return;
                                                         }
                                                         
                                                         NSArray *routesArray = [json objectForKey:@"routes"];
                                                         
                                                         GMSPolyline *polyline = nil;
                                                         
                                                         if ([routesArray count] > 0)
                                                         {
                                                             NSDictionary *routeDict = [routesArray objectAtIndex:0];
                                                             NSDictionary *routeOverviewPolyline = [routeDict objectForKey:@"overview_polyline"];
                                                             NSString *points = [routeOverviewPolyline objectForKey:@"points"];
                                                             GMSPath *path = [GMSPath pathFromEncodedPath:points];
                                                             polyline = [GMSPolyline polylineWithPath:path];
                                                             polyline.strokeColor = [UIColor redColor];
                                                             polyline.strokeWidth = 5.0;
                                                         }
                                                         
                                                         if(completionHandler)
                                                             completionHandler(polyline);
                                                     });
                                                 }];
    [fetchDirectionsTask resume];
}

@end
