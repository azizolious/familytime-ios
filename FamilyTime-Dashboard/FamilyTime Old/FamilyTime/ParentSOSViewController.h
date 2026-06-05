//
//  ParentSOSViewController.h
//  FamilyTime
//
//  Created by Sora Code on 3/12/15.
//  Copyright (c) 2015 SoraCode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface ParentSOSViewController : BaseViewController <UIAlertViewDelegate,GMSMapViewDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *currentAddress;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (nonatomic,strong) NSString *message;
@property (weak, nonatomic) IBOutlet UIButton *gotitOnmyWay;
@property (weak, nonatomic) IBOutlet UILabel *sendCustomMsg;

- (IBAction)sos:(id)sender;

@end
