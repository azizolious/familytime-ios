//
//  CheckInOutAlertControllerViewController.m
//  FamilyTime - Dashboard
//
//  Created by Muhammad Ajmal on 24/03/2016.
//  Copyright © 2016 SoraCode. All rights reserved.
//

#import "CheckInOutAlertControllerViewController.h"
#import "FTUtils.h"
#import "CommonModel.h"
//#import <Google/Analytics.h>
//#import "UIViewController+BIZChildViewController.h"
#import "Constant.h"
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"

@interface MapAnnotation : NSObject<MKAnnotation>
@property(nonatomic, assign) CLLocationCoordinate2D coordinate;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *subtitle;
@end

@implementation MapAnnotation
@end

@implementation MKMapView (ZoomLevel)
- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel animated:(BOOL)animated {
    MKCoordinateSpan span = MKCoordinateSpanMake(0, 360/pow(2, zoomLevel)*self.frame.size.width/256);
    [self setRegion:MKCoordinateRegionMake(centerCoordinate, span) animated:animated];
}
@end

@interface CheckInOutAlertControllerViewController ()<MKMapViewDelegate>
@property (nonatomic, strong) MKMapView *mapview;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *detailsLabel;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UILabel *messageLabel;
@end

@implementation CheckInOutAlertControllerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if(IS_IPHONE_4)
    {
        self.view.frame = CGRectMake(0.0f, 0.0f, 270.0f, 420.0f);
    }
    else if(IS_IPHONE_5)
    {
        self.view.frame = CGRectMake(0.0f, 0.0f, 270.0f, 420.0f);
    }
    else if(IS_IPHONE_6)
    {
        self.view.frame = CGRectMake(0.0f, 0.0f, 317.0f, 450.0f);
    }
    else if(IS_IPHONE_6_PLUS)
    {
        self.view.frame = CGRectMake(0.0f, 0.0f, 350.0f, 500.0f);
    }
    else if(IS_IPHONE_X)
    {
        self.view.frame = CGRectMake(0.0f, 0.0f, 350.0f, 500.0f);
    }
    else
    {
        self.view.frame = CGRectMake(0.0f, 0.0f, 525.0f, 715.0f);
    }
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:[self.latitude doubleValue] longitude:[self.longitude doubleValue]];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         //        for (CLPlacemark * placemark in placemarks) {
         if(placemarks.count)
         {//mustafa
             CLPlacemark * placemark =[placemarks objectAtIndex:0];
             NSString *address;
             address = [NSString stringWithFormat:@"%@ %@ %@",[[placemark addressDictionary] valueForKey:@"Street"],[[placemark addressDictionary] valueForKey:@"State"],[[placemark addressDictionary] valueForKey:@"Country"]];
//             self.address = address;

             if(([[placemark addressDictionary] valueForKey:@"Street"]==[NSNull null])||([[placemark addressDictionary] valueForKey:@"Street"]==nil)||([[placemark addressDictionary] valueForKey:@"Street"]==NULL))
             {
                 address = [NSString stringWithFormat:@"%@ %@",[[placemark addressDictionary] valueForKey:@"State"],[[placemark addressDictionary] valueForKey:@"Country"]];
             }
             
             self.address = address;
             [self updateMessageLabel];
         }
     }];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self addLocationMarkupOnMap:self.latitude lon:self.longitude name:self.name];
}

- (void)setupUI
{
    self.mapview = [self setupMapView];
    self.mapview.delegate = self;
    [self.view addSubview:self.mapview];
    
    self.imageView = [self setupImageView];
    [self.view addSubview:self.imageView];
    
    self.nameLabel = [self setupNameLabel];
    [self.view addSubview:self.nameLabel];
    
    self.timeLabel = [self setupTimeLabel];
    [self.view addSubview:self.timeLabel];
    
    self.closeButton = [self setupCloseButton];
    [self.closeButton addTarget:self action:@selector(handleClose:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.closeButton];
    
    self.messageLabel = [self setupMessageLabel];
    [self.view addSubview:self.messageLabel];
}

- (void)addLocationMarkupOnMap:(NSString *)lat lon:(NSString *)lon name:(NSString *)name
{
    [self.mapview removeAnnotations:self.mapview.annotations];
    
    MapAnnotation *ann = [[MapAnnotation alloc] init];
    ann.title = name;
    ann.coordinate = CLLocationCoordinate2DMake([lat doubleValue], [lon doubleValue]);
    [self.mapview addAnnotation:ann];
    
    if(CLLocationCoordinate2DIsValid([ann coordinate]))
        [self.mapview setCenterCoordinate:[ann coordinate] zoomLevel:12 animated:YES];
}

#pragma mark - MKMapViewDelegate
-(MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    static NSString *annotationIdentifier = @"AnnotationIdentifier";
    
    MKPinAnnotationView *pinView = (MKPinAnnotationView *) [mapView
                                                            dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
    
    if (!pinView)
    {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"apploc"];
        pinView.canShowCallout = YES;
        pinView.image = [UIImage imageNamed:@"glow-marker"];
    }
    else
    {
        pinView.annotation = annotation;
    }
    return pinView;
}

- (void)handleClose:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
   // [self.container dismissPopupViewControllerAnimated:YES];
}

- (MKMapView *)setupMapView
{
    MKMapView *mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)/3.0f)];
    return mapView;
}

- (UIImageView *)setupImageView
{
    UIImageView *imageView;
    if(IS_IPHONE_4)
    {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15.0f, CGRectGetMaxY(self.mapview.frame) - 36.0f, 72.0f, 72.0f)];
    }
    else if(IS_IPHONE_5)
    {
         imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15.0f, CGRectGetMaxY(self.mapview.frame) - 36.0f, 72.0f, 72.0f)];
    }
    else if(IS_IPHONE_6)
    {
         imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15.0f, CGRectGetMaxY(self.mapview.frame) - 48.0f, 96.0f, 96.0f)];
    }
    else if(IS_IPHONE_6_PLUS)
    {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15.0f, CGRectGetMaxY(self.mapview.frame) - 48.0f, 96.0f, 96.0f)];
    }
    else if(IS_IPHONE_X)
        {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15.0f, CGRectGetMaxY(self.mapview.frame) - 48.0f, 96.0f, 96.0f)];
        }
    else
    {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15.0f, CGRectGetMaxY(self.mapview.frame) - 58.0f, 116.0f, 116.0f)];
    }
    imageView.image = self.image;
    return imageView;
}

- (UILabel *)setupNameLabel
{
    UILabel *label;
    if(IS_IPHONE_4)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, CGRectGetMaxY(self.imageView.frame) + 10, CGRectGetWidth(self.view.bounds) - 110, 20.0f)];
        label.font = [UIFont fontWithName:@"OpenSans-Light" size:18];
    }
    else if(IS_IPHONE_5)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, CGRectGetMaxY(self.imageView.frame) + 10, CGRectGetWidth(self.view.bounds) - 110, 20.0f)];
        label.font = [UIFont fontWithName:@"OpenSans-Light" size:18];
    }
    else if(IS_IPHONE_6)
    {
       label = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, CGRectGetMaxY(self.imageView.frame) + 15, CGRectGetWidth(self.view.bounds) - 110, 20.0f)];
        label.font = [UIFont fontWithName:@"OpenSans-Light" size:20];
    }
    else if(IS_IPHONE_6_PLUS)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, CGRectGetMaxY(self.imageView.frame) + 15, CGRectGetWidth(self.view.bounds) - 110, 20.0f)];
        label.font = [UIFont fontWithName:@"OpenSans-Light" size:22];
    }
    else if(IS_IPHONE_X)
        {
        label = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, CGRectGetMaxY(self.imageView.frame) + 15, CGRectGetWidth(self.view.bounds) - 110, 20.0f)];
        label.font = [UIFont fontWithName:@"OpenSans-Light" size:22];
        }
    else
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, CGRectGetMaxY(self.imageView.frame) + 15, CGRectGetWidth(self.view.bounds) - 110, 30.0f)];
        label.font = [UIFont fontWithName:@"OpenSans-Light" size:36];
    }
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = RGBCOLOR(102, 102, 102, 1);
    label.text = self.name;
    
    return label;
}

- (UILabel *)setupTimeLabel
{
    UILabel *label;
    if(IS_IPHONE_4)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.view.bounds) - 120.0f, CGRectGetMaxY(self.imageView.frame) + 10, 110, 20.0f)];
        label.font = [UIFont fontWithName:@"OpenSans-Light" size:14];
    }
    else if(IS_IPHONE_5)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.view.bounds) - 120.0f, CGRectGetMaxY(self.imageView.frame) + 10, 110, 20.0f)];
        label.font = [UIFont fontWithName:@"OpenSans-Light" size:14];
    }
    else if(IS_IPHONE_6)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.view.bounds) - 120.0f, CGRectGetMaxY(self.imageView.frame) + 15, 110, 20.0f)];
        label.font = [UIFont fontWithName:@"OpenSans-Light" size:16];
    }
    else if(IS_IPHONE_6_PLUS)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.view.bounds) - 120.0f, CGRectGetMaxY(self.imageView.frame) + 15, 110, 20.0f)];
        label.font = [UIFont fontWithName:@"OpenSans-Light" size:16];
    }
    else if(IS_IPHONE_X)
        {
        label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.view.bounds) - 120.0f, CGRectGetMaxY(self.imageView.frame) + 15, 110, 20.0f)];
        label.font = [UIFont fontWithName:@"OpenSans-Light" size:16];
        }
    else
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.view.bounds) - 120.0f, CGRectGetMaxY(self.imageView.frame) + 15, 110, 30.0f)];
        label.font = [UIFont fontWithName:@"OpenSans-Light" size:28];
    }
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = RGBCOLOR(176, 176, 176, 1);
    
    //NSDate *date = [CommonModel dateWithTimestamp:self.time];
//    NSDateFormatter *df = [[NSDateFormatter alloc] init];
//    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZ"];
//    NSDate *date = [df dateFromString:self.time];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    //[dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:self.time];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a"];
    //NSTimeZone *outputTimeZone1 = [NSTimeZone systemTimeZone];
    //[formatter setTimeZone:outputTimeZone1];
    NSString *time = [formatter stringFromDate:date];
    
    label.text = time;
    
    return label;
}

- (UIButton *)setupCloseButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if(IS_IPHONE_4)
    {
        button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.view.bounds) - 40.0f, CGRectGetWidth(self.view.bounds), 40.0f);
        button.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:13];
    }
    else if(IS_IPHONE_5)
    {
        button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.view.bounds) - 40.0f, CGRectGetWidth(self.view.bounds), 40.0f);
        button.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:13];
    }
    else if(IS_IPHONE_6)
    {
        button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.view.bounds) - 46.0f, CGRectGetWidth(self.view.bounds), 46.0f);
        button.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:14];
    }
    else if(IS_IPHONE_6_PLUS)
    {
        button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.view.bounds) - 52.0f, CGRectGetWidth(self.view.bounds), 52.0f);
        button.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:15];
    }
    else if(IS_IPHONE_X)
        {
        button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.view.bounds) - 52.0f, CGRectGetWidth(self.view.bounds), 52.0f);
        button.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:15];
        }
    else
    {
        button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.view.bounds) - 78.0f, CGRectGetWidth(self.view.bounds), 78.0f);
        button.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:20];
    }
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[button setBackgroundColor:[CommonModel colorFromHexString:@"orange"]];
    [button setBackgroundColor:[CommonModel colorFromHexString:@"blue"]];
    [button setTitle:@"OK" forState:UIControlStateNormal];
    return button;
}



- (UILabel *)setupMessageLabel
{
    UILabel *label;
    
    NSMutableAttributedString *finalMessage = [[NSMutableAttributedString alloc] init];
    
    NSString *titleStr;
    if(self.checkedin)
        titleStr = [NSString stringWithFormat:@"Arrived at %@\n",self.placeName];
    else
        titleStr = [NSString stringWithFormat:@"Left %@\n",self.placeName];
    NSMutableAttributedString *titleMessage = [[NSMutableAttributedString alloc] initWithString:titleStr];
    if(self.checkedin)
        [titleMessage addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(0, 153, 102, 1) range:NSMakeRange(0, titleMessage.length)];
    else
        [titleMessage addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(153, 0, 51, 1) range:NSMakeRange(0, titleMessage.length)];
    NSMutableParagraphStyle *paragraphStyleTitle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyleTitle.alignment = NSTextAlignmentLeft;
    [titleMessage addAttribute:NSParagraphStyleAttributeName value:paragraphStyleTitle range:NSMakeRange(0, titleMessage.length)];
    
    NSMutableAttributedString *firstParagraph = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n",self.address]];
    [firstParagraph addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(176, 176, 176, 1) range:NSMakeRange(0, firstParagraph.length)];
    NSMutableParagraphStyle *paragraphStyleFirstParagraph = [[NSMutableParagraphStyle alloc] init];
    paragraphStyleFirstParagraph.alignment = NSTextAlignmentLeft;
    [firstParagraph addAttribute:NSParagraphStyleAttributeName value:paragraphStyleFirstParagraph range:NSMakeRange(0, firstParagraph.length)];
    
    
    NSMutableAttributedString *accuracyStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Accuracy: %.2fm",[self.accuracy floatValue]]];
    [accuracyStr addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(102, 102, 102, 1) range:NSMakeRange(0, accuracyStr.length)];
    NSMutableParagraphStyle *paragraphStyleAccuracy = [[NSMutableParagraphStyle alloc] init];
    paragraphStyleAccuracy.alignment = NSTextAlignmentLeft;
    [accuracyStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyleAccuracy range:NSMakeRange(0, accuracyStr.length)];
    
    if(IS_IPHONE_4)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, CGRectGetMaxY(self.nameLabel.frame) + 15.0f, CGRectGetWidth(self.view.bounds) - 30.0f, CGRectGetMinY(self.closeButton.frame) - 15.0f)];
        
        [titleMessage addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Light" size:16] range:NSMakeRange(0, titleMessage.length)];
        [firstParagraph addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Light" size:14] range:NSMakeRange(0, firstParagraph.length)];
        [accuracyStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Light" size:13] range:NSMakeRange(0, accuracyStr.length)];
    }
    else if(IS_IPHONE_5)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, CGRectGetMaxY(self.nameLabel.frame), CGRectGetWidth(self.view.bounds) - 30.0f, CGRectGetMinY(self.closeButton.frame) - CGRectGetMaxY(self.timeLabel.frame))];
        [titleMessage addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Light" size:16] range:NSMakeRange(0, titleMessage.length)];
        [firstParagraph addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Light" size:14] range:NSMakeRange(0, firstParagraph.length)];
        [accuracyStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Light" size:13] range:NSMakeRange(0, accuracyStr.length)];
    }
    else if(IS_IPHONE_6)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, CGRectGetMaxY(self.nameLabel.frame) + 15.0f, CGRectGetWidth(self.view.bounds) - 30.0f, CGRectGetMinY(self.closeButton.frame) - CGRectGetMaxY(self.nameLabel.frame) - 15.0f)];
        [titleMessage addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Light" size:18] range:NSMakeRange(0, titleMessage.length)];
        [firstParagraph addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Light" size:17] range:NSMakeRange(0, firstParagraph.length)];
        [accuracyStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Light" size:15] range:NSMakeRange(0, accuracyStr.length)];
    }
    else if(IS_IPHONE_6_PLUS)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, CGRectGetMaxY(self.nameLabel.frame) + 15.0f, CGRectGetWidth(self.view.bounds) - 62.0f, CGRectGetMinY(self.closeButton.frame) - CGRectGetMaxY(self.imageView.frame) - 15.0f)];
        [titleMessage addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Light" size:20] range:NSMakeRange(0, titleMessage.length)];
        [firstParagraph addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Light" size:18] range:NSMakeRange(0, firstParagraph.length)];
        [accuracyStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Light" size:16] range:NSMakeRange(0, accuracyStr.length)];
    }
    else if(IS_IPHONE_X)
        {
        label = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, CGRectGetMaxY(self.nameLabel.frame) + 15.0f, CGRectGetWidth(self.view.bounds) - 62.0f, CGRectGetMinY(self.closeButton.frame) - CGRectGetMaxY(self.imageView.frame) - 15.0f)];
        [titleMessage addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Light" size:20] range:NSMakeRange(0, titleMessage.length)];
        [firstParagraph addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Light" size:18] range:NSMakeRange(0, firstParagraph.length)];
        [accuracyStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Light" size:16] range:NSMakeRange(0, accuracyStr.length)];
        }
    else
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, CGRectGetMaxY(self.nameLabel.frame) + 34.0f, CGRectGetWidth(self.view.bounds) - 94.0f, CGRectGetMinY(self.closeButton.frame) - CGRectGetMaxY(self.imageView.frame) - 34.0f)];
        [titleMessage addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Light" size:32] range:NSMakeRange(0, titleMessage.length)];
        [firstParagraph addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Light" size:28] range:NSMakeRange(0, firstParagraph.length)];
        [accuracyStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Light" size:26] range:NSMakeRange(0, accuracyStr.length)];
    }
    
    [finalMessage appendAttributedString:titleMessage];
    [finalMessage appendAttributedString:firstParagraph];
    [finalMessage appendAttributedString:accuracyStr];
    label.numberOfLines = 0;
    
    //CGRect rect = [finalMessage boundingRectWithSize:CGSizeMake(CGRectGetWidth(label.bounds), 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    //label.frame = CGRectMake(CGRectGetMinX(label.frame), CGRectGetMinY(label.frame), CGRectGetWidth(label.frame), CGRectGetHeight(rect));
    label.attributedText = finalMessage;
    //label.backgroundColor = [UIColor redColor];
    return label;
}

- (void)updateMessageLabel
{
    NSMutableAttributedString *finalMessage = [[NSMutableAttributedString alloc] init];
    
    NSString *titleStr;
    if(self.checkedin)
        titleStr = [NSString stringWithFormat:@"Arrived at %@\n",self.placeName];
    else
        titleStr = [NSString stringWithFormat:@"Left %@\n",self.placeName];
    NSMutableAttributedString *titleMessage = [[NSMutableAttributedString alloc] initWithString:titleStr];
    if(self.checkedin)
        [titleMessage addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(0, 153, 102, 1) range:NSMakeRange(0, titleMessage.length)];
    else
        [titleMessage addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(153, 0, 51, 1) range:NSMakeRange(0, titleMessage.length)];
    NSMutableParagraphStyle *paragraphStyleTitle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyleTitle.alignment = NSTextAlignmentLeft;
    [titleMessage addAttribute:NSParagraphStyleAttributeName value:paragraphStyleTitle range:NSMakeRange(0, titleMessage.length)];
    
    NSMutableAttributedString *firstParagraph = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n",self.address]];
    [firstParagraph addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(176, 176, 176, 1) range:NSMakeRange(0, firstParagraph.length)];
    NSMutableParagraphStyle *paragraphStyleFirstParagraph = [[NSMutableParagraphStyle alloc] init];
    paragraphStyleFirstParagraph.alignment = NSTextAlignmentLeft;
    [firstParagraph addAttribute:NSParagraphStyleAttributeName value:paragraphStyleFirstParagraph range:NSMakeRange(0, firstParagraph.length)];
    
    
    NSMutableAttributedString *accuracyStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Accuracy: %.2fm",[self.accuracy floatValue]]];
    [accuracyStr addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(102, 102, 102, 1) range:NSMakeRange(0, accuracyStr.length)];
    NSMutableParagraphStyle *paragraphStyleAccuracy = [[NSMutableParagraphStyle alloc] init];
    paragraphStyleAccuracy.alignment = NSTextAlignmentLeft;
    [accuracyStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyleAccuracy range:NSMakeRange(0, accuracyStr.length)];
    
    if(IS_IPHONE_4)
    {
        [titleMessage addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Light" size:16] range:NSMakeRange(0, titleMessage.length)];
        [firstParagraph addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Light" size:14] range:NSMakeRange(0, firstParagraph.length)];
        [accuracyStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Light" size:13] range:NSMakeRange(0, accuracyStr.length)];
    }
    else if(IS_IPHONE_5)
    {
        [titleMessage addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Light" size:16] range:NSMakeRange(0, titleMessage.length)];
        [firstParagraph addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Light" size:14] range:NSMakeRange(0, firstParagraph.length)];
        [accuracyStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Light" size:13] range:NSMakeRange(0, accuracyStr.length)];
    }
    else if(IS_IPHONE_6)
    {
        [titleMessage addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Light" size:18] range:NSMakeRange(0, titleMessage.length)];
        [firstParagraph addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Light" size:17] range:NSMakeRange(0, firstParagraph.length)];
        [accuracyStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Light" size:15] range:NSMakeRange(0, accuracyStr.length)];
    }
    else if(IS_IPHONE_6_PLUS)
    {
        [titleMessage addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Light" size:20] range:NSMakeRange(0, titleMessage.length)];
        [firstParagraph addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Light" size:18] range:NSMakeRange(0, firstParagraph.length)];
        [accuracyStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Light" size:16] range:NSMakeRange(0, accuracyStr.length)];
    }
    else if(IS_IPHONE_X)
        {
        [titleMessage addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Light" size:20] range:NSMakeRange(0, titleMessage.length)];
        [firstParagraph addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Light" size:18] range:NSMakeRange(0, firstParagraph.length)];
        [accuracyStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Light" size:16] range:NSMakeRange(0, accuracyStr.length)];
        }
    else
    {
        [titleMessage addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Light" size:32] range:NSMakeRange(0, titleMessage.length)];
        [firstParagraph addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Light" size:28] range:NSMakeRange(0, firstParagraph.length)];
        [accuracyStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Light" size:26] range:NSMakeRange(0, accuracyStr.length)];
    }
    
    [finalMessage appendAttributedString:titleMessage];
    [finalMessage appendAttributedString:firstParagraph];
    [finalMessage appendAttributedString:accuracyStr];
    self.messageLabel.numberOfLines = 0;
    
    self.messageLabel.attributedText = finalMessage;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
