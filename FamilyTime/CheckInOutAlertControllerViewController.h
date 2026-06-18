//
//  CheckInOutAlertControllerViewController.h
//  FamilyTime - Dashboard
//
//  Created by Muhammad Ajmal on 24/03/2016.
//  Copyright © 2016 SoraCode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MKMapView (ZoomLevel)

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;
@end

@interface CheckInOutAlertControllerViewController : UIViewController
//@property (nonatomic, weak) BIZPopupViewController *container;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, assign) BOOL checkedin;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *accuracy;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *placeName;
@property (nonatomic, strong) NSString *color;
@end
