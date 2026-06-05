//
//  SpeedAlertsViewController.m
//  FamilyTime - Dashboard
//
//  Created by Muhammad Ajmal on 20/07/2016.
//  Copyright © 2016 SoraCode. All rights reserved.
//

#import "SpeedAlertsViewController.h"
#import "FTUtils.h"
#import "CommonModel.h"
///#import <Google/Analytics.h>
#import <GoogleMaps/GoogleMaps.h>
#import "AppDelegate.h"
//@implementation Annotation
//@end

@interface SpeedAlertsViewController ()<GMSMapViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatraWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelTopMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *okButtonHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *accuracyBottomMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *blueCarLeftMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *currentSpeedLabelRightMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *overspeedLabelTopMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *accuracyLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *speedLimitLabelTitleTopMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *currentSpeedLabelTitleTopMargin;



@property (weak, nonatomic) IBOutlet GMSMapView *mapview;
@property (weak, nonatomic) IBOutlet UIImageView *avatraImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *overspeedLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *accuracyLabel;
@property (weak, nonatomic) IBOutlet UIButton *okButton;
@property (weak, nonatomic) IBOutlet UILabel *currentSpeedLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentSpeedTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedLimitLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedLimitTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *currentSpeedCarImageView;

@end

@implementation SpeedAlertsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(IS_IPHONE_4)
    {
        self.view.frame = CGRectMake(0.0f, 0.0f, 270.0f, 420.0f);
        _avatarHeightConstraint.constant = 54;
         _avatraWidthConstraint.constant = 54;
        _nameLabelTopMargin.constant = 5;
        _accuracyBottomMargin.constant = 10;
        _okButtonHeightConstraint.constant = 40;
        _blueCarLeftMargin.constant = 10;
        _currentSpeedLabelRightMargin.constant = 10;
        _accuracyLabelHeight.constant = 17;
        _addressLabelHeight.constant = 17;
        _speedLimitLabelTitleTopMargin.constant = -5;
        _currentSpeedLabelTitleTopMargin.constant = -5;
        
        _nameLabel.font = [UIFont fontWithName:@"OpenSans" size:16];
        _timeLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:12];
        _overspeedLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:12];
        _addressLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:11];
        _accuracyLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:12];
        _speedLimitLabel.font = [UIFont fontWithName:@"OpenSans" size:16];
        _speedLimitTitleLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:10];
        _currentSpeedLabel.font = [UIFont fontWithName:@"OpenSans" size:16];
        _currentSpeedTitleLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:10];
    }
    else if(IS_IPHONE_5)
    {
        self.view.frame = CGRectMake(0.0f, 0.0f, 270.0f, 420.0f);
        _avatarHeightConstraint.constant            = 54;
         _avatraWidthConstraint.constant            = 54;
        _nameLabelTopMargin.constant                = 5;
        _accuracyBottomMargin.constant              = 10;
        _okButtonHeightConstraint.constant          = 40;
        _blueCarLeftMargin.constant                 = 10;
        _currentSpeedLabelRightMargin.constant      = 10;
        _accuracyLabelHeight.constant               = 17;
        _addressLabelHeight.constant                = 17;
        _speedLimitLabelTitleTopMargin.constant     = -5;
         _currentSpeedLabelTitleTopMargin.constant  = -5;
        
        _nameLabel.font = [UIFont fontWithName:@"OpenSans" size:16];
        _timeLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:12];
        _overspeedLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:12];
        _addressLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:11];
        _accuracyLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:12];
        _speedLimitLabel.font = [UIFont fontWithName:@"OpenSans" size:16];
        _speedLimitTitleLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:10];
        _currentSpeedLabel.font = [UIFont fontWithName:@"OpenSans" size:16];
        _currentSpeedTitleLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:10];
        
    }
    else if(IS_IPHONE_6)
    {
        self.view.frame = CGRectMake(0.0f, 0.0f, 317.0f, 450.0f);
        _avatarHeightConstraint.constant = 72;
         _avatraWidthConstraint.constant = 72;
        _nameLabelTopMargin.constant = 5;
        _accuracyBottomMargin.constant = 15;
        _okButtonHeightConstraint.constant = 46;
        _blueCarLeftMargin.constant = 20;
        _currentSpeedLabelRightMargin.constant = 20;
        _accuracyLabelHeight.constant = 17;
        _addressLabelHeight.constant = 17;
        _speedLimitLabelTitleTopMargin.constant = -5;
         _currentSpeedLabelTitleTopMargin.constant = -5;
        
        _nameLabel.font = [UIFont fontWithName:@"OpenSans" size:18];
        _timeLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:14];
        _overspeedLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:13];
        _addressLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:13];
        _accuracyLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:14];
        _speedLimitLabel.font = [UIFont fontWithName:@"OpenSans" size:18];
        _speedLimitTitleLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:10];
        _currentSpeedLabel.font = [UIFont fontWithName:@"OpenSans" size:18];
        _currentSpeedTitleLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:10];
        
    }
    else if(IS_IPHONE_6_PLUS)
    {
        self.view.frame = CGRectMake(0.0f, 0.0f, 350.0f, 500.0f);
        _avatarHeightConstraint.constant = 72;
         _avatraWidthConstraint.constant = 72;
        _nameLabelTopMargin.constant = 5;
        _accuracyBottomMargin.constant = 15;
        _okButtonHeightConstraint.constant = 52;
        _speedLimitLabelTitleTopMargin.constant = -5;
        _currentSpeedLabelTitleTopMargin.constant = -5;
        
        _nameLabel.font = [UIFont fontWithName:@"OpenSans" size:20];
        _timeLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:15];
        _overspeedLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:12];
        _addressLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:14];
        _accuracyLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:15];
        _speedLimitLabel.font = [UIFont fontWithName:@"OpenSans" size:20];
        _speedLimitTitleLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:13];
        _currentSpeedLabel.font = [UIFont fontWithName:@"OpenSans" size:20];
        _currentSpeedTitleLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:13];
    }
    else if(IS_IPHONE_X)
    {
        self.view.frame = CGRectMake(0.0f, 0.0f, 350.0f, 500.0f);
        _avatarHeightConstraint.constant = 72;
        _avatraWidthConstraint.constant = 72;
        _nameLabelTopMargin.constant = 5;
        _accuracyBottomMargin.constant = 15;
        _okButtonHeightConstraint.constant = 52;
        _speedLimitLabelTitleTopMargin.constant = -5;
        _currentSpeedLabelTitleTopMargin.constant = -5;
        
        _nameLabel.font = [UIFont fontWithName:@"OpenSans" size:20];
        _timeLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:15];
        _overspeedLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:12];
        _addressLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:14];
        _accuracyLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:15];
        _speedLimitLabel.font = [UIFont fontWithName:@"OpenSans" size:20];
        _speedLimitTitleLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:13];
        _currentSpeedLabel.font = [UIFont fontWithName:@"OpenSans" size:20];
        _currentSpeedTitleLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:13];
    }
    else
    {
        self.view.frame = CGRectMake(0.0f, 0.0f, 525.0f, 715.0f);
        _avatarHeightConstraint.constant = 116;
        _avatraWidthConstraint.constant = 116;
        _nameLabelTopMargin.constant = 30;
        _accuracyBottomMargin.constant = 20;
        _okButtonHeightConstraint.constant = 78;
        _overspeedLabelTopMargin.constant = 10;
        _blueCarLeftMargin.constant = 50;
        _currentSpeedLabelRightMargin.constant = 50;
        _accuracyLabelHeight.constant = 25;
        _addressLabelHeight.constant = 25;
        _accuracyBottomMargin.constant = 25;
        _speedLimitLabelTitleTopMargin.constant = 5;
        _currentSpeedLabelTitleTopMargin.constant = 5;
        
        
        _nameLabel.font = [UIFont fontWithName:@"OpenSans" size:27];
        _timeLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:22];
        _overspeedLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:16];
        _addressLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:20];
        _accuracyLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:21];
        _speedLimitLabel.font = [UIFont fontWithName:@"OpenSans" size:36];
        _speedLimitTitleLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:16];
        _currentSpeedLabel.font = [UIFont fontWithName:@"OpenSans" size:36];
        _currentSpeedTitleLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:16];
        [_okButton.titleLabel setFont:[UIFont fontWithName:@"OpenSans" size:22]];
    }
    //_mapview.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupData:(NSInteger)childId childName:(NSString *)childName isSon:(BOOL)isSon startLatitude:(double)startLatitude startLongitude:(double)startLongitude endLatitude:(double)endLatitude endLongitude:(double)endLongitude speedLimit:(NSInteger)speedlimit currentSpeed:(NSInteger)currentSpeed address:(NSString *)address accuracy:(NSString *)accuracy isOverSpeed:(BOOL)isOverSpeed alertTime:(NSString *)alertTime
{
    _avatraImageView.image = isSon ? [UIImage imageNamed:@"avatar_boy1"] : [UIImage imageNamed:@"avatar_girl1"];
    _nameLabel.text = childName;
    NSDate *date = [self getUTCFormateFromString:alertTime];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a"];
    _timeLabel.text = [formatter stringFromDate:date];
    
    if(isOverSpeed)
    {
        _overspeedLabel.text = [NSString stringWithFormat:@"%@ is over speeding",childName];
        _currentSpeedLabel.textColor = [UIColor redColor];
        _currentSpeedCarImageView.image = [UIImage imageNamed:@"red_car"];
        
        [self.mapview clear];
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.icon = [UIImage imageNamed:@"speed_pin"];
        marker.position = CLLocationCoordinate2DMake(startLatitude, startLongitude);
        marker.map = self.mapview;
        
        GMSCameraPosition *position = [GMSCameraPosition cameraWithLatitude:startLatitude
                                                                longitude:startLongitude
                                                                     zoom:15];
        [self.mapview setCamera:position];
        
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:startLatitude  longitude:startLongitude   zoom:15];
        self.mapview.camera = camera;
    }
    else
    {
         _overspeedLabel.text = [NSString stringWithFormat:@"%@ is back to normal speed",childName];
        _currentSpeedLabel.textColor = RGBCOLOR(61, 211, 54, 1);
         _currentSpeedCarImageView.image = [UIImage imageNamed:@"green_car"];
        
        [self.mapview clear];
        GMSMarker *markerEnd = [[GMSMarker alloc] init];
        markerEnd.icon = [UIImage imageNamed:@"speed_pin"];
        markerEnd.position = CLLocationCoordinate2DMake(endLatitude, endLongitude);
        markerEnd.map = self.mapview;
        
        GMSMarker *markerStart = [[GMSMarker alloc] init];
        markerStart.icon = [UIImage imageNamed:@"red_speed_pin"];
        markerStart.position = CLLocationCoordinate2DMake(startLatitude, startLongitude);
        markerStart.map = self.mapview;
        
        GMSCameraPosition *position = [GMSCameraPosition cameraWithLatitude:endLatitude
                                                                  longitude:endLongitude
                                                                       zoom:15];
        [self.mapview setCamera:position];
        
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:endLatitude  longitude:endLongitude   zoom:15];
        self.mapview.camera = camera;
        
        
        CLLocation *from = [[CLLocation alloc] initWithLatitude:startLatitude longitude:startLongitude];
        CLLocation *to = [[CLLocation alloc] initWithLatitude:endLatitude longitude:endLongitude];
        [self drawRoute:from to:to];
    }
    
    _currentSpeedLabel.text = [NSString stringWithFormat:@"%ld kph",(long)currentSpeed];
    _speedLimitLabel.text = [NSString stringWithFormat:@"%ld kph",(long)speedlimit];
    _accuracyLabel.text = [NSString stringWithFormat:@"Accuracy: %@",accuracy];
    
    CLGeocoder *geoCoder  = [[CLGeocoder alloc] init];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:startLatitude longitude:startLongitude];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if(error == nil)
         {
             NSString * locationGeoCode = [self getDesiredReverseGeoCodeString:placemarks];
             locationGeoCode = [locationGeoCode stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
             _addressLabel.text = locationGeoCode;
         }
     }];
}

- (void)drawRoute:(CLLocation *)from to:(CLLocation *)to
{
    [self fetchPolylineWithOrigin:from destination:to completionHandler:^(GMSPolyline *polyline)
     {
         if(polyline)
             polyline.map = self.mapview;
         
         NSMutableArray *array = [[NSMutableArray alloc]initWithObjects:[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%f",from.coordinate.latitude],@"latitude",[NSString stringWithFormat:@"%f",from.coordinate.longitude],@"longitude", nil],
                                  [[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%f",to.coordinate.latitude],@"latitude",[NSString stringWithFormat:@"%f",to.coordinate.longitude],@"longitude", nil],
                                  nil];
         GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] init];
         CLLocationCoordinate2D location;
         for (NSDictionary *dictionary in array)
         {
             location.latitude = [dictionary[@"latitude"] floatValue];
             location.longitude = [dictionary[@"longitude"] floatValue];
             bounds = [bounds includingCoordinate:CLLocationCoordinate2DMake(location.latitude, location.longitude)];
         }
         [self.mapview animateWithCameraUpdate:[GMSCameraUpdate fitBounds:bounds withPadding:50.0f]];
     }];
}

- (void)fetchPolylineWithOrigin:(CLLocation *)origin destination:(CLLocation *)destination completionHandler:(void (^)(GMSPolyline *))completionHandler
{
    NSString *originString = [NSString stringWithFormat:@"%f,%f", origin.coordinate.latitude, origin.coordinate.longitude];
    NSString *destinationString = [NSString stringWithFormat:@"%f,%f", destination.coordinate.latitude, destination.coordinate.longitude];
    NSString *directionsAPI = @"https://maps.googleapis.com/maps/api/directions/json?";
    NSString *directionsUrlString = [NSString stringWithFormat:@"%@&origin=%@&destination=%@&mode=driving", directionsAPI, originString, destinationString];
    NSURL *directionsUrl = [NSURL URLWithString:directionsUrlString];
    
    
    NSURLSessionDataTask *fetchDirectionsTask = [[NSURLSession sharedSession] dataTaskWithURL:directionsUrl completionHandler:
                                                 ^(NSData *data, NSURLResponse *response, NSError *error)
                                                 {
                                                     NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                                     if(error)
                                                     {
                                                         if(completionHandler)
                                                             completionHandler(nil);
                                                         return;
                                                     }
                                                     
                                                     NSArray *routesArray = [json objectForKey:@"routes"];
                                                     __block GMSPolyline *polyline = nil;
                                                     
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         if ([routesArray count] > 0)
                                                         {
                                                             NSDictionary *routeDict = [routesArray objectAtIndex:0];
                                                             NSDictionary *routeOverviewPolyline = [routeDict objectForKey:@"overview_polyline"];
                                                             NSString *points = [routeOverviewPolyline objectForKey:@"points"];
                                                             GMSPath *path = [GMSPath pathFromEncodedPath:points];
                                                             polyline = [GMSPolyline polylineWithPath:path];
                                                             polyline.strokeColor = RGBCOLOR(35, 183, 229, 1);
                                                             polyline.strokeWidth = 5;
                                                         }
                                                         if(completionHandler)
                                                             completionHandler(polyline);
      
                                                     });
                                                     
                                                 }];
    [fetchDirectionsTask resume];
}

- (NSString *) getDesiredReverseGeoCodeString:(NSArray *)placeMarkers{
    
    CLPlacemark * placeMarker = [placeMarkers lastObject];
    NSString * textString= [NSString stringWithFormat:@"%@, %@, %@, %@, %@, %@",
                            placeMarker.subThoroughfare, placeMarker.thoroughfare,
                            placeMarker.postalCode, placeMarker.locality,
                            placeMarker.administrativeArea,
                            placeMarker.country];
    
    textString = [textString stringByReplacingOccurrencesOfString:@"(null),"
                                                       withString:@""];
    return textString;
}

- (NSString *)getUTCFormateDate:(NSDate *)localDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:localDate];
    NSLog(@"%@",dateString);
    return dateString;
}

- (NSDate *)getUTCFormateFromString:(NSString *)localDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateString = [dateFormatter dateFromString:localDate];
    return dateString;
}

- (IBAction)handleOkButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
//    MKPinAnnotationView *MyPin=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"current"];
//    MyPin.highlighted = NO;
//    MyPin.canShowCallout = NO;
//    MyPin.image = [UIImage imageNamed:@"speed_pin"];
//    
//    return MyPin;
//}
@end
