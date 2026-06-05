//
//  SpeedAlertsViewController.h
//  FamilyTime - Dashboard
//
//  Created by Muhammad Ajmal on 20/07/2016.
//  Copyright © 2016 SoraCode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
//
//@interface Annotation : NSObject <MKAnnotation> {
//    
//    CLLocationCoordinate2D coordinate;
//    NSString *title;
//    NSString *subtitle;
//    
//}

//@property(nonatomic, assign) CLLocationCoordinate2D coordinate;
//@property(nonatomic, copy) NSString *title;
//@property(nonatomic, copy) NSString *subtitle;
//
//@end

@interface SpeedAlertsViewController : UIViewController
- (void)setupData:(NSInteger)childId childName:(NSString *)childName isSon:(BOOL)isSon startLatitude:(double)startLatitude startLongitude:(double)startLongitude endLatitude:(double)endLatitude endLongitude:(double)endLongitude speedLimit:(NSInteger)speedlimit currentSpeed:(NSInteger)currentSpeed address:(NSString *)address accuracy:(NSString *)accuracy isOverSpeed:(BOOL)isOverSpeed alertTime:(NSString *)alertTime;
@end
