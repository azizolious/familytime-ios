//
//  InstantLocation.h
//  OnDemandFeatures
//
//  Created by Sora Code on 8/15/14.
//  Copyright (c) 2014 Invisible. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface InstantLocation : NSObject <CLLocationManagerDelegate>//,MKAnnotation>

@property (nonatomic,strong) CLLocationManager * locationManager;
//@property (nonatomic,strong) NSString *curentAddress;// NSMutableArray *userLocation;

/**
 Initialize location updates
 
 @param number phone number that ll be sent along with location JSON to server
 */
+(InstantLocation *) sharedReference;
-(void) startLocation;//:(NSString *)number;
-(void) stopLocationUpdates;
@end
