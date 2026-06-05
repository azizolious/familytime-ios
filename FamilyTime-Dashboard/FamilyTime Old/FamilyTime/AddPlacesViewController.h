//
//  AddPlacesViewController.h
//  FamilyTime
//
//  Created by Sora Code on 11/25/14.
//  Copyright (c) 2014 SoraCode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "DataModel.h"
#import <GoogleMaps/GoogleMaps.h>
#import "BaseViewController.h"

@interface AddPlacesViewController : BaseViewController <GMSMapViewDelegate,UITextFieldDelegate>
{
    
    UIBarButtonItem *addButtonn;
    
}
@property (nonatomic,strong) UserModel *user;
@property (nonatomic,strong) PlaceModel *place;
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (strong, nonatomic) NSString *mode;
@property (weak, nonatomic) IBOutlet UISegmentedControl *distanceSeg;
@property (weak, nonatomic) IBOutlet UIButton *locAlerts;
@property (weak, nonatomic) IBOutlet UITextField *placeTF;
@property (weak, nonatomic) IBOutlet UITextField *addTF;

@property (weak, nonatomic) IBOutlet UILabel *lblPlaceName;
@property (weak, nonatomic) IBOutlet UILabel *lblStreetAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblSendMeAcknoleghe;
@property (weak, nonatomic) IBOutlet UILabel *lblEntertheAddressOrdragme;




@property CLLocationCoordinate2D currentLocation;
@property float radius;
@property int zoom;
@property (weak, nonatomic) IBOutlet UIButton *addPlace;

- (IBAction)addLocation:(id)sender;
- (IBAction)locationAlert:(UIButton *)sender;
- (IBAction)distanceRadius:(id)sender;
@end
