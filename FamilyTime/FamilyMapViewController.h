//
//  ViewController.h
//  FamilyTime - Dashboard
//
//  Created by Ahmad on 8/18/17.
//  Copyright © 2017 SoraCode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
//#import "MapPoint.h"
//#import "LameAnnotationView.h"
#import <GoogleMaps/GoogleMaps.h>
#import "BaseViewController.h"

@interface FamilyMapViewController : BaseViewController <GMSMapViewDelegate> {
    
    CLLocationManager *locationManager;
    IBOutlet MKMapView *mapView;
    
}

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (strong, nonatomic) NSMutableArray *allmarkerts;


@end
