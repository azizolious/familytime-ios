//
//  LocationTracker.m
//  Location
//
//  Created by Rick
//  Copyright (c) 2014 Location All rights reserved.
//

#import "LocationTracker.h"
#import "CommonModel.h"
#import "AppDelegate.h"

#define LATITUDE @"latitude"
#define LONGITUDE @"longitude"
#define ACCURACY @"theAccuracy"

//#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@implementation LocationTracker

+ (CLLocationManager *)sharedLocationManager {
    static CLLocationManager *_locationManager;
    
    @synchronized(self) {
        if (_locationManager == nil) {
            _locationManager = [[CLLocationManager alloc] init];
            _locationManager.desiredAccuracy = kCLLocationAccuracyBest;//ForNavigation;
            _locationManager.distanceFilter = DISTANCE_FILTER;
            /* Notify heading changes when heading is > 5.
             * Default value is kCLHeadingFilterNone: all movements are reported.
             */
            //            _locationManager.headingFilter = 5;
            
        }
    }
    return _locationManager;
}

- (id)init {
    if (self==[super init]) {
        //Get the share model and also initialize myLocationArray
        self.shareModel = [LocationShareModel sharedModel];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}

-(void)applicationEnterBackground{
    [self startLocationTracking];
    
    //Use the BackgroundTaskManager to manage all the background Task
    self.shareModel.bgTask = [BackgroundTaskManager sharedBackgroundTaskManager];
    [self.shareModel.bgTask beginNewBackgroundTask];
}

- (void) restartLocationUpdates
{
    NSLog(@"restartLocationUpdates");
    
    if (self.shareModel.timer) {
        [self.shareModel.timer invalidate];
        self.shareModel.timer = nil;
    }
    [self startLocationTracking];
    
}


- (void)startLocationTracking
{
//    self.launchOptions = launchOptions;
    NSLog(@"startLocationTracking");
    
    if ([CLLocationManager locationServicesEnabled] == NO) {
        NSLog(@"locationServicesEnabled false");
       
    } else {
        CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
        
        if(authorizationStatus == kCLAuthorizationStatusDenied || authorizationStatus == kCLAuthorizationStatusRestricted){
            NSLog(@"authorizationStatus failed");
        } else {
            NSLog(@"authorizationStatus authorized");
            CLLocationManager *locationManager = [LocationTracker sharedLocationManager];
            locationManager.delegate = self;
            locationManager.desiredAccuracy = kCLLocationAccuracyBest;//ForNavigation;
            locationManager.distanceFilter = DISTANCE_FILTER;
            
            if(IS_OS_8_OR_LATER) {
                [locationManager requestAlwaysAuthorization];
            }
//            if(self.launchOptions)
//                [locationManager startMonitoringSignificantLocationChanges];
//            else
                [locationManager startUpdatingLocation];
        }
    }
}


- (void)stopLocationTracking {
    NSLog(@"stopLocationTracking");
    
    if (self.shareModel.timer) {
        [self.shareModel.timer invalidate];
        self.shareModel.timer = nil;
    }
    
    CLLocationManager *locationManager = [LocationTracker sharedLocationManager];
    [locationManager stopUpdatingLocation];
//    [locationManager stopMonitoringSignificantLocationChanges];
}

#pragma mark - CLLocationManagerDelegate Methods
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    NSLog(@"-:BF:- locationManager didUpdateLocations");
    for(int i=0;i<locations.count;i++){
        CLLocation * newLocation = [locations objectAtIndex:i];
        CLLocation * oldLocation = [[CLLocation alloc] initWithLatitude: self.myLastLocation.latitude longitude: self.myLastLocation.longitude];
        CLLocationCoordinate2D theLocation = newLocation.coordinate;
        CLLocationAccuracy theAccuracy = newLocation.horizontalAccuracy;
        CLLocationAccuracy oldAccuracy = oldLocation.horizontalAccuracy;
        if(self.myLastLocation.longitude <=0)
            oldAccuracy = theAccuracy;
        
        NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
        
        if (locationAge > 30.0)
        {
            continue;
        }
        
        //Select only valid location and also location with good accuracy
        if(newLocation!=nil&&theAccuracy>0  && theAccuracy<2000 &&(!(theLocation.latitude==0.0 && theLocation.longitude==0.0))
           && theAccuracy <= oldAccuracy)
        {
            
            CLLocationDistance distance = [newLocation distanceFromLocation:oldLocation];
            NSLog(@"distance == %f **** l0caitno %f , %f",distance,theLocation.latitude,theLocation.longitude);
            self.myLastLocation = theLocation;
            self.myLastLocationAccuracy= theAccuracy;
            if(distance >= DISTANCE_FILTER)
                [CommonModel storeLocationInPlist:theLocation];
        }
    }
        //If the timer still valid, return it (Will not run the code below)
        if (self.shareModel.timer) {
            return;
        }
        
        self.shareModel.bgTask = [BackgroundTaskManager sharedBackgroundTaskManager];
        [self.shareModel.bgTask beginNewBackgroundTask];
        
        //Restart the locationMaanger after 5 minute
        self.shareModel.timer = [NSTimer scheduledTimerWithTimeInterval:LOC_MANAGER_INTERVAL target:self
                                                               selector:@selector(restartLocationUpdates)
                                                               userInfo:nil
                                                                repeats:NO];
        
        //Will only stop the locationManager after 10 seconds, so that we can get some accurate locations
        //The location manager will only operate for 10 seconds to save battery
        if (self.shareModel.delay10Seconds) {
            [self.shareModel.delay10Seconds invalidate];
            self.shareModel.delay10Seconds = nil;
        }
        
        self.shareModel.delay10Seconds = [NSTimer scheduledTimerWithTimeInterval:10 target:self
                                                                        selector:@selector(stopLocationDelayBy10Seconds)
                                                                        userInfo:nil
                                                                         repeats:NO];
//    }
    
}

//Stop the locationManager
-(void)stopLocationDelayBy10Seconds{
    CLLocationManager *locationManager = [LocationTracker sharedLocationManager];
    [locationManager stopUpdatingLocation];
    NSLog(@"locationManager stop Updating after 10 seconds");
}


- (void)locationManager: (CLLocationManager *)manager didFailWithError: (NSError *)error
{
    // NSLog(@"locationManager error:%@",error);
    
    switch([error code])
    {
        case kCLErrorNetwork: // general, network-related error
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Please check your network connection." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        case kCLErrorDenied:{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enable Location Service" message:@"You have to enable the Location Service to use this App. To enable, please go to Settings->Privacy->Location Services" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        default:
        {
            
        }
            break;
    }
}
 

//Send the location to Server
- (void)updateLocationToServer {
    
    //    if(self.myLocation.longitude > 0){
//    [CommonModel sendLocationToServer];
    //    }
    
}


@end
