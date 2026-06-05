//
//  AddPlacesViewController.m
//  FamilyTime
//
//  Created by Sora Code on 11/25/14.
//  Copyright (c) 2014 SoraCode. All rights reserved.
//

#import "AddPlacesViewController.h"
#import "UIViewController+Keyboard.h"
#import "CommonModel.h"
#import "MBProgressHUD.h"
#import "Constant.h"
#import "AppDelegate.h"
//#import "JSONHTTPClient.h"
#import <AddressBookUI/AddressBookUI.h>
//#import <Google/Analytics.h>
#import "FTUtils.h"
#import "Dashboard.h"
#import <CoreLocation/CoreLocation.h>
#import "NSString+LockMustafa.h"
#import "FamilyTime-Swift.h"


#define hunderedFeet 30.48
#define twohunderedFeet 60.96
#define fiveHunderedFeet 152.40
#define halfMile 804.672
#define oneMile 1609.34
#define twoMile 3218.69

AppDelegate *delegate;

@interface AddPlacesViewController ()<CLLocationManagerDelegate>
@property (nonatomic, strong) NSString *placeName;
@property (nonatomic, strong) NSString *streetAdd;
@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation AddPlacesViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    _lblEntertheAddressOrdragme.text=[@"Enter the address OR drag map to find your location" myModification];
    NSLog(@"kaka==");
    
    
    
//    UIImage *image2 = [UIImage imageNamed:@"ic_family_pin"];
//    UIButton *myCustomButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
//    myCustomButton2.bounds = CGRectMake( 0, 0, image2.size.width, image2.size.height );
//    [myCustomButton2 setImage:image2 forState:UIControlStateNormal];
//    [myCustomButton2 addTarget:self action:@selector(familyMap) forControlEvents:UIControlEventTouchUpInside];
//
//
//
//    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithCustomView:myCustomButton2];
    
//    self.navigationItem.rightBarButtonItems =[NSArray arrayWithObjects:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addLocation:)],nil];
    
    
//    addButtonn = [[UIBarButtonItem alloc] initWithTitle:[@"Add Place" myModification]
//                                                             style:UIBarButtonItemStylePlain
//                                                            target:self
//                                                            action:@selector(addLocation:)];
//    [self.navigationItem setRightBarButtonItem:addButtonn animated:YES];
    
    
   if( [[NSUserDefaults standardUserDefaults]objectForKey:@"gobacknow"]!=nil)
   {

       if([[[NSUserDefaults standardUserDefaults]objectForKey:@"gobacknow"] isEqualToString:@"YES"])
       {
           [[NSUserDefaults standardUserDefaults]setObject:@"NO"  forKey:@"gobacknow"];
           [[NSUserDefaults standardUserDefaults]synchronize];
           [self.navigationController popViewControllerAnimated:YES];
       }
   
   }

    
    if([self.mode isEqualToString:@"editing"])
    {
    
        addButtonn.title=[@"Edit Place" myModification];
    
        [self.addPlace setTitle:[@"Edit Place" myModification] forState:UIControlStateNormal];
        self.placeTF.text = self.place.location; 
        self.addTF.text = self.place.address;
        [self.locAlerts setSelected:([self.place.checkin_alert isEqualToString:@"0"]? false : true)];
        CLLocationCoordinate2D location = CLLocationCoordinate2DMake([self.place.latitude floatValue], [self.place.longitude floatValue]);
        self.currentLocation = location;
        self.radius = [self.place.radius floatValue];
        if(![self.place.predefined  isEqual: @"1"]){
        UIBarButtonItem * add = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"places_delete.png"] style:UIBarButtonItemStylePlain target:self action:@selector(deletPlace)];
        [self.navigationItem setRightBarButtonItems:@[add]];
    }

    }
    else  if([self.mode isEqualToString:@"addPlace"])
    {
        [self.addPlace setTitle:[@"Add Place" myModification] forState:UIControlStateNormal];
        self.addTF.text = self.place.location;
        [self.locAlerts setSelected:YES];
        CLLocationCoordinate2D location = CLLocationCoordinate2DMake([self.place.latitude floatValue], [self.place.longitude floatValue]);
        self.currentLocation = location;
         self.radius = 150;
    }
    else {
        self.place = [[PlaceModel alloc] init];
        self.radius = 150;
        [self.locAlerts setSelected:YES];
        [self.addPlace setTitle:[@"Add Place" myModification] forState:UIControlStateNormal];
        
        if (self.locationManager == nil)
            self.locationManager = [[CLLocationManager alloc] init];
        [self.locationManager requestWhenInUseAuthorization];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [self.locationManager startUpdatingLocation];
    }
    [self setLocRadius];
    //enable/disable add place button
    if (self.currentLocation.longitude){
        [self.addPlace setEnabled:YES];
        [self.addPlace setBackgroundColor:KSetBG(24, 121, 162, 1)];
    }
    else{
        [self.addPlace setEnabled:NO];
        [self.addPlace setBackgroundColor:[UIColor colorWithRed:189/255.0 green:189/255.0 blue:189/255.0 alpha:1]];
    }
    //hide key board
    [self.placeTF resignFirstResponder];
    [self.addTF resignFirstResponder];
    
    [self.view setNeedsDisplay];
    
    _lblPlaceName.text=[_lblPlaceName.text myModification];
    _lblStreetAddress.text=[_lblStreetAddress.text myModification];
    _lblSendMeAcknoleghe.text=[@"Send me Checkin/Checkout alerts" myModification];

    _placeTF.placeholder=[@"House,School,Work" myModification];
    _addTF.placeholder=[@"Address" myModification];

}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (fabs(howRecent) < 15.0) {
        self.currentLocation = location.coordinate;
        [self.view setNeedsDisplay];
        [self.locationManager stopUpdatingLocation];
        [self setLocRadius];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _lblPlaceName.adjustsFontSizeToFitWidth=YES;
    
    [[NSUserDefaults standardUserDefaults]setObject:@"NO"  forKey:@"gobacknow"];
    [[NSUserDefaults standardUserDefaults]synchronize];

    
    delegate  = [AppDelegate appDelegate];
    self.user = [[UserModel alloc] initWithDictionary:[[AppDelegate appDelegate].userDefault objectForKey:@"user"] error:nil];
    
    if([self.mode isEqualToString:@"editing"])
        [self.navigationItem setTitle:[@"Edit Place" myModification]];
    else
        [self.navigationItem setTitle:[@"Add Place" myModification]];
    
    self.mapView.delegate =self;
    //self.mapView.
    [self.placeTF setDelegate:self];
    [self.addTF   setDelegate:self];
    if([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setLocRadius];
   
    self.addPlace.layer.cornerRadius = 3;
    self.addPlace.clipsToBounds = YES;
    //setup Google map
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86  longitude:152.20   zoom:6];
    self.mapView.camera = camera;
    [self.mapView setMyLocationEnabled:YES];
    [_mapView.settings setMyLocationButton:YES];
    self.mapView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TextField Delegates
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.placeTF)
        [self.placeTF resignFirstResponder];
        
    else{
        [self.addTF resignFirstResponder];
        [self searchLocation];
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)sender
{
}


#pragma mark delete Place
-(void)deletPlace
{
    //delete place
    [SwiftFTUtils showHUDAddedTo:self.view withText:[@"Deleting Place..." myModification] animated:YES];
    NSString *url = @"";
    if (delegate.selectedDashboardChild.plateform_id == 1) //---1 FOR ANDROID---//
        url = [NSString stringWithFormat:@"%@%ld/%@", kPlaces_Delete_android_mesh2, (long)delegate.selectedDashboardChild.child_id, self.place.place_id];
    else
        url = [NSString stringWithFormat:@"%@%ld/%@", kPlaces_Delete_ios_mesh2, (long)delegate.selectedDashboardChild.child_id, self.place.place_id];
    
    NSLog(@"delete place url = %@", url);
    
    [[ApiManager shared] deleteApiWithParams:@{} andUrl:url andController:self withResponse:^(NSString * _Nonnull message, NSInteger code) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            if(code == 200)
                [self.navigationController popViewControllerAnimated:YES];
            else
                [CommonModel showAlert:[@"Error!" myModification] msg:message];
        });
    }];
    
    //---DEPRICATED---//
    
//    NSDictionary *params = @{@"id":self.place.place_id, @"child_id" : [NSNumber numberWithInteger:delegate.selectedDashboardChild.child_id]};
//    [JSONHTTPClient postJSONFromURLWithString:@"" //KPlacedeleteUrl
//                                       params:params
//                                   completion:^(id json, JSONModelError *err) {
//                                       [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//
//                                       if([[json valueForKey:@"response"] intValue] == 200){
//                                           [self.navigationController popViewControllerAnimated:YES];
//                                       }
//                                   }];
}

- (void) searchLocation
{
    [SwiftFTUtils showHUDAddedTo:self.view withText:[@"Searching..." myModification] animated:YES];
    NSString *address = [NSString stringWithFormat:@"%@",self.addTF.text];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks) {
            CLPlacemark *placemark = placemarks[0];
            self.currentLocation =  placemark.location.coordinate;
            [self.addPlace setEnabled:YES];
             [self.addPlace setBackgroundColor:KSetBG(24, 121, 162, 1)];

            [self addCircle:self.currentLocation];
        }
        else
            [CommonModel showAlert:[@"Something went wrong" myModification] msg:[@"Unable to find address" myModification]];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}
#pragma mark - GMSMapViewDelegate

-(void)mapView:(GMSMapView *)mapView didEndDraggingMarker:(GMSMarker *)marker
{
    [self.mapView clear];
    [self addCircle:marker.position];
    self.currentLocation = marker.position;
}

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{    self.currentLocation = coordinate;
    [self addCircle:self.currentLocation];
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
      [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
    {
        if(placemarks.count){
            CLPlacemark * placemark =[placemarks objectAtIndex:0];
            NSString *address = ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO);
            if(address != nil)
            {
                address = [address stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
                self.addTF.text = address;
                [self.addPlace setEnabled:YES];
                [self.addPlace setBackgroundColor:KSetBG(24, 121, 162, 1)];
            }
        }
      }];
}

-(void)addCircle:(CLLocationCoordinate2D )loc
{
    [self.mapView clear];
    GMSMarker *marker = [[GMSMarker alloc] init];
    [marker setDraggable:YES];
    marker.icon = [UIImage imageNamed:@"default_marker"];
    marker.position = loc;
    marker.map = self.mapView;
    [self.mapView animateToLocation:loc];
    GMSCircle *fence = [GMSCircle circleWithPosition:loc radius:self.radius];
    [fence setFillColor:[UIColor colorWithRed:102.0/255 green:178.0/255 blue:255.0/255 alpha:0.3]];
    [fence setMap: self.mapView];
}

#pragma mark - Helper

- (IBAction)addLocation:(id)sender
{
    self.placeName = [[self.placeTF text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.streetAdd = [[self.addTF text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if(self.placeName.length <= 0)
        [CommonModel showAlert:@"" msg:[@"Please enter place name!" myModification]];
    else
    {
        DashboardChildPackageFeature *placesPackageFeature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"place"];
        if (placesPackageFeature.is_count_based == 1)
        {
            [SwiftFTUtils showHUDAddedTo:self.view withText:[@"Loading..." myModification] animated:YES];
            
//            NSLog(@"Add Place url = %@ and params = %@", KPlaces, params);
            
            NSString *url = [NSString stringWithFormat:@"%@%ld", kPlaces_mesh2, (long)delegate.selectedDashboardChild.child_id];
            
            [[ApiManager shared] getPlacesApiWithVC:self andUrl:url withResponse:^(AllPlacesModel * _Nonnull model, NSString *message, NSInteger statusCode) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    
                    if(statusCode == 1)//---1 MEANS RESPONSE DATA IS NIL---//
                    {
                        [CommonModel showAlert:[@"Error!" myModification] msg:message];
                    }
                    else
                    {
                        if (model.status == 200){
                            NSLog(@"api success with message =  %@",model.message);
                        }
                        else
                            [CommonModel showAlert:[@"Error!" myModification] msg:model.message];
                        
                        if(model.data.count >= [placesPackageFeature.count_limit integerValue])
                            [SwiftFTUtils showSwiftPremiumPopupOn:self];
                        else
                            [self doAddPlace];
                    }
                    
                });
            }];
            
            
            //---DEPRICATED---//
            
//            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:delegate.selectedDashboardChild.child_id],@"child_id", nil];
//
//            [JSONHTTPClient postJSONFromURLWithString:@"" //KPlaces
//                                               params:params
//                                           completion:^(id json, JSONModelError *err) {
//                                               NSError *error;
//                                               AllPlacesModel *places;
//                                               if([[json valueForKey:@"response"] intValue]== 200)
//                                               {
//                                                   NSLog(@"%@",json);
//                                                   places = [[AllPlacesModel alloc] initWithDictionary:json error:&error];
//                                               }
//                                               else
//                                                   [CommonModel showAlert:[@"Error!" myModification] msg:[json valueForKey:@"message"]];
//                                               [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//
//                                               if(places.data.count >= [placesPackageFeature.count_limit integerValue])
//                                               {
//                                                   [SwiftFTUtils showSwiftPremiumPopupOn:self];
//                                               }
//                                               else
//                                               {
//                                                   [self doAddPlace];
//                                               }
//                                           }];
        }
        else
        {
            [self doAddPlace];
        }
    }
}

- (void)doAddPlace
{
    [SwiftFTUtils showHUDAddedTo:self.view withText:@"Adding Place..." animated:YES];
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    params[@"location"]      = self.placeName;
    params[@"address"]       = self.streetAdd;
    params[@"latitude"]      = [NSString stringWithFormat:@"%f",self.currentLocation.latitude];
    params[@"longitude"]     = [NSString stringWithFormat:@"%f",self.currentLocation.longitude];
    params[@"radius"]        = [NSString stringWithFormat:@"%.2f",self.radius];
    params[@"checkin_alert"] = [NSString stringWithFormat:@"%i",(self.locAlerts.isSelected)?1:0];
    
    //---UPDATE CASE---//
    if ([self.mode isEqualToString:@"editing"])
        params[@"id"] = self.place.place_id;
    
    NSString *url = [NSString stringWithFormat:@"%@%ld", kPlaces_mesh2, (long)delegate.selectedDashboardChild.child_id];
    NSLog(@"Add or update Place url = %@ and params = %@", url, params);
    
    
    [[ApiManager shared] putApi:url params:params controller:self isContPresented:NO withResponse:^(NSString * _Nonnull message, NSInteger statusCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            if (statusCode == 200){
                //---MESH2 API DOES THIS AUTO SO NO NEED FOR THIS---//
                //                SwiftFTUtils.showSyncSettingsPopup(with: self)
                
                [CommonModel showAlert:@"Sync Settings" msg:message];
                [self.navigationController popViewControllerAnimated:true];
            }
            else
                [CommonModel showAlert:@"Error!" msg:message];
        });
    }];
    
    
    
    //---DEPRICATED MESH, REPLACED WITH MESH2---//
    
//    self.place.child_id = [NSString stringWithFormat:@"%ld",(long)delegate.selectedDashboardChild.child_id];
//    self.place.latitude = [NSString stringWithFormat:@"%f",self.currentLocation.latitude];
//    self.place.longitude = [NSString stringWithFormat:@"%f",self.currentLocation.longitude];
//    self.place.radius = [NSString stringWithFormat:@"%.2f",self.radius];
//    self.place.checkin_alert = [NSString stringWithFormat:@"%i",(self.locAlerts.isSelected)?1:0];
//    self.place.location = self.placeName;
//    self.place.address  = self.streetAdd;
//
//    NSDictionary *params = [self.place toDictionary];
//    NSString *url = ([self.mode isEqualToString:@"editing"]? KPlaceEditUrl : KPlaceAddUrl);
//
//    NSLog(@"Add Place url = %@ and params = %@", url, params);
//
//    [JSONHTTPClient postJSONFromURLWithString:url
//                                       params:params
//                                   completion:^(id json, JSONModelError *err)
//     {
//         NSString *msg = [json valueForKey:@"message"] == nil ? [kErrorGeneral myModification] : [json valueForKey:@"message"];
//         if([[json valueForKey:@"response"] intValue]== 200){
//
//
//             //      [self.navigationController popViewControllerAnimated:YES];
//             [SwiftFTUtils showSyncSettingsPopupWith:self];
//         }
//         else
//             [CommonModel showAlert:@"Error!" msg:msg];
//
//         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//     }];
}

- (IBAction)distanceRadius:(UISegmentedControl *)sender
{
    if([sender selectedSegmentIndex] ==0)
        self.radius = 150.0f;
    else if([sender selectedSegmentIndex] ==1)
        self.radius = 300.0f;
    else if([sender selectedSegmentIndex] ==2)
        self.radius = 500.0f;
    else if([sender selectedSegmentIndex] ==3)
        self.radius = 1000.0f;
    [self setLocRadius];
}

- (void) setLocRadius
{
    if(self.radius <=150.0f)
    {
        [self.distanceSeg setSelectedSegmentIndex:0];
        self.zoom = 16;
    }
   else if(self.radius <=300.0f)
   {
        [self.distanceSeg setSelectedSegmentIndex:1];
        self.zoom = 15;
    }
    else if(self.radius <= 500.0f){
        [self.distanceSeg setSelectedSegmentIndex:2];
        self.zoom = 14;
    }
    else if(self.radius <= 1000.0f){
        [self.distanceSeg setSelectedSegmentIndex:3];
        self.zoom = 13;
    }
    [self.mapView animateToZoom:self.zoom];
    
    if(self.currentLocation.latitude)
        [self addCircle:self.currentLocation];
}

- (IBAction)locationAlert:(UIButton *)sender
{
    [self.locAlerts setSelected:!sender.isSelected];
}

@end
