//
//  LocHistoryViewController.h
//  FamilyTime
//
//  Created by Sora Code on 12/10/14.
//  Copyright (c) 2014 SoraCode. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <MapKit/MapKit.h>
#import "DataModel.h"
#import <GoogleMaps/GoogleMaps.h>
#import "BaseViewController.h"
#import "AddPlacesViewController.h"

@interface LocHistoryViewController : BaseViewController <GMSMapViewDelegate> //<CLLocationManagerDelegate,MKMapViewDelegate>
{

    UIImageView *imgView;
    UILabel *contentLbl;


}


@property (nonatomic, strong) AddPlacesViewController *addPlaceCont;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSMutableArray * dates;
@property int page;
@property (weak, nonatomic) IBOutlet UILabel *locDate;
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;

- (IBAction)requestLocHistory:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *mapView2;
- (IBAction)ReqLocHis:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *LocDate;
- (IBAction)LocHist2:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView2;

@property (weak, nonatomic) IBOutlet UIView *TopViewForArrows;


@end
