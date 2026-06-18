//
//  InstantLocation.m
//  OnDemandFeatures
//
//  Created by Sora Code on 8/15/14.
//  Copyright (c) 2014 Invisible. All rights reserved.
//

//******* REference
//http://mobileoop.com/background-location-update-programming-for-ios-7

#import "InstantLocation.h"
#import "DataModel.h"
#import "CommonModel.h"
#import "AppDelegate.h"
#import <AddressBookUI/AddressBookUI.h>

static InstantLocation *sharedRefer;
@implementation InstantLocation

#pragma mark Location
+(InstantLocation *) sharedReference
{
    if (sharedRefer == nil) {
        sharedRefer = [[InstantLocation alloc] init];
    }
    
    return sharedRefer;
}
-(void) startLocation//:(NSString *)number
{
    //    phoneNumber = number;
    NSLog(@"Init location **");
    
    @try {
        
        self.locationManager = [[CLLocationManager alloc] init];
        
        /* Pinpoint our location with the following accuracy:
         *
         *     kCLLocationAccuracyBestForNavigation  highest + sensor data
         *     kCLLocationAccuracyBest               highest
         *     kCLLocationAccuracyNearestTenMeters   10 meters
         *     kCLLocationAccuracyHundredMeters      100 meters
         *     kCLLocationAccuracyKilometer          1000 meters
         *     kCLLocationAccuracyThreeKilometers    3000 meters
         *****/
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        self.locationManager.delegate = self;
        
        /* Notify changes when device has moved x meters.
         * Default value is kCLDistanceFilterNone: all movements are reported.
         */
        
        self.locationManager.distanceFilter =  kCLDistanceFilterNone;
        //        self.curentAddress = @"";
        [self.locationManager startUpdatingLocation];
        //        [self.locationManager startMonitoringSignificantLocationChanges];
        
    }
    @catch (NSException *exception) {
        NSLog(@"Error in Init location ** %@",exception);
    }
    @finally {}
    
}
-(void) stopLocationUpdates
{
    [self.locationManager stopUpdatingLocation];
    
}
-(void) curentAddress:(CLLocation * )location
{
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    AppDelegate *delegate = [AppDelegate appDelegate];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        //        for (CLPlacemark * placemark in placemarks) {
        if(placemarks.count){
            CLPlacemark * placemark =[placemarks objectAtIndex:0];
            NSString *address = ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO);
            [delegate.userDefault setValue:address forKey:@"instantLoc"];
            [delegate.userDefault setValue:[NSString stringWithFormat:@"%f",location.coordinate.latitude] forKey:@"instantLat"];
            [delegate.userDefault setValue:[NSString stringWithFormat:@"%f",location.coordinate.longitude] forKey:@"instantLong"];
            [delegate.userDefault synchronize];
            //                NSLog(@"**instant location *** %@ Accuracy %f",address,location.horizontalAccuracy);
            [self stopLocationUpdates];
        }
        
        
    }];
}

-(void)locationManager:(CLLocationManager*)manager didUpdateLocations:(NSArray*)locations
{
    NSLog(@"on Demand did update to location ***");
    [self curentAddress:[locations objectAtIndex:0]];
    //    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    //    CLLocation *newLocation = [locations objectAtIndex:0];
    //    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
    //        //        for (CLPlacemark * placemark in placemarks) {
    //        CLPlacemark * placemark =[placemarks objectAtIndex:0];
    //
    ////        if([placemark locality] !=nil){
    //
    //            if([placemark addressDictionary] != NULL){
    //                NSString *address = [NSString stringWithFormat:@"%@, %@, %@",[[placemark addressDictionary] valueForKey:@"Street"],[[placemark addressDictionary] valueForKey:@"State"],[[placemark addressDictionary] valueForKey:@"Country"]];
    //                [[AppDelegate appDelegate].userDefault setValue:address forKey:@"instantLoc"];
    //                [[AppDelegate appDelegate].userDefault synchronize];
    //                  NSLog(@"**instant location *** %@",address);
    ////            }
    //
    //
    //
    //            [self stopLocationUpdates];
    //        }
    //
    //    }];
    
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Faild Location Manager with error ***** %@", error);
    
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSString *msg = @"";
    if([CLLocationManager locationServicesEnabled]) {
        // Location Services Are Enabled
        //mustafa
        switch([CLLocationManager authorizationStatus]) {
            case kCLAuthorizationStatusAuthorizedAlways:{
                msg = @"";
                break;
            }
            case kCLAuthorizationStatusNotDetermined:
                msg = @"";//@"User has not yet made a choice with regards to this application.";
                break;
            case kCLAuthorizationStatusRestricted:
                msg = @"This application is not authorized to use location services. Due to active restrictions on location services, the user cannot change";
                // this status, and may not have personally denied authorization
                break;
            case kCLAuthorizationStatusAuthorizedWhenInUse:
                msg=@"";
                break;
            case kCLAuthorizationStatusDenied:
                msg =@"Kindly authorize application from location services from Settings";
                break;
                
        }
    } else {
        msg = @"Location services are disabled";
    }
    if(msg.length >0)
        [CommonModel showAlert:@"" msg:msg];
    
}

@end
