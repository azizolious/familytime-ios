//
//  ParentSOSViewController.m
//  FamilyTime
//
//  Created by Sora Code on 3/12/15.
//  Copyright (c) 2015 SoraCode. All rights reserved.
//

#import "ParentSOSViewController.h"
#import "MBProgressHUD.h"
//#import "JSONHTTPClient.h"
#import "AppDelegate.h"
#import "CustomIOS7AlertView.h"
//#import <Google/Analytics.h>
#import "FTUtils.h"
#import "NSString+LockMustafa.h"
#import "FamilyTime-Swift.h"

#define fiveHunderedFeet 152.40
AppDelegate *delegate;
@interface ParentSOSViewController ()

@end

@implementation ParentSOSViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:[delegate.childPush.lat doubleValue] longitude:[delegate.childPush.longi doubleValue]];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         //        for (CLPlacemark * placemark in placemarks) {
         if(placemarks.count)
         {
             CLPlacemark * placemark =[placemarks objectAtIndex:0];
             NSString *address = [NSString stringWithFormat:@"%@ %@ %@",[[placemark addressDictionary] valueForKey:@"Street"],[[placemark addressDictionary] valueForKey:@"State"],[[placemark addressDictionary] valueForKey:@"Country"]];
             self.currentAddress.text = address;
         }
     }];
    
    
    [_gotitOnmyWay setTitle:[@"Got it, on my way!" myModification] forState:UIControlStateNormal];
    
    _sendCustomMsg.text=[_sendCustomMsg.text myModification];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    delegate = [AppDelegate appDelegate];
            self.message = @"";
    //setup Google map
    //self.currentAddress.text = delegate.childPush.address;
    self.time.text = [CommonModel pushTime:delegate.childPush.time];
    
//    CLLocationCoordinate2D location =  CLLocationCoordinate2DMake(delegate.childPush.lat.doubleValue, delegate.childPush.longi.doubleValue);
//    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:location.latitude  longitude: location.longitude   zoom:16];
//    self.mapView.camera=camera;
    
//    [self addCircle:location];
    
    [self performSelector:@selector(Addcircle) withObject:self afterDelay:2.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)Addcircle
{
    CLLocationCoordinate2D location =  CLLocationCoordinate2DMake(delegate.childPush.lat.doubleValue, delegate.childPush.longi.doubleValue);
    [self addCircle:location];
}


//-(UIView *)mapView:(GMSMapView *)mapView markerInfoContents:(GMSMarker *)marker
//{
//}

- (IBAction)sos:(UIButton *)sender {
    if(sender.tag == 0)
        [self sendSOS:@"Got it, on my way!"];
    else if(sender.tag == 1){
        
        // Here we need to pass a full frame
        CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
        
        // Add some custom content to the alert view
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 300, 130)];
        textView.keyboardAppearance = UIKeyboardAppearanceAlert;
        textView.backgroundColor = [UIColor clearColor];
        [textView setText:@"Message"];
        [textView setFont:[UIFont fontWithName:@"OpenSans" size:16]];
        [textView setTextColor:[UIColor grayColor]];
        textView.tag = 222;
        textView.delegate = self;
        [alertView setContainerView:textView];
        
        // Modify the parameters
        [alertView setButtonTitles:[NSMutableArray arrayWithObjects:[@"CANCEL" myModification], [@"SEND" myModification], nil]];
        
        // You may use a Block, rather than a delegate.
        [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
            NSString *msg = [(UITextView *)[alertView viewWithTag:222] text];
            if (buttonIndex == 0)
            {
                [alertView close];
                return;
            }
            if(msg.length == 0 || [msg isEqualToString:@"Message"])
                [CommonModel showAlert:@"" msg:@"Please write a message"];
            else
                [self sendSOS:msg];
            [alertView close];
        }];
        //        [alertView setUseMotionEffects:true];
        // And launch the dialog
        [alertView show];
        
    }
    else if (sender.tag==2)
    {
        //[self sendSOS:@"5 Minutes Ago!"];
    }
}

-(void) sendSOS:(NSString *)message
{
    self.message = message;
    NSLog(@"%@",delegate.parent.user_id);
    NSLog(@"%@",delegate.childPush.child_id);
    
    NSDictionary *params = @{@"user_id":delegate.parent.user_id,@"child_id":delegate.childPush.child_id,@"push_type":@"panic_back",@"message":message};
    NSLog(@"%@",params);
    [SwiftFTUtils showHUDAddedTo:self.view withText:@"Sending SOS..." animated:YES];
    
//    [JSONHTTPClient postJSONFromURLWithString:@"" //KPushBack
//                                       params:params
//                                   completion:^(id json, JSONModelError *err)
//        {
//                                       // read response code
//                                       if([[json valueForKey:@"response"] intValue] == 200){
//                                           [self dismissViewControllerAnimated:YES completion:nil];
//                                           
//                                       }
//                                       else{
//                                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[@"Something went wrong" myModification] message:[@"Please check your internet connection." myModification] delegate:self cancelButtonTitle:[@"Cancel" myModification] otherButtonTitles:[@"Try again" myModification], nil];
//                                           [alert show];
//                                       }
//                                      
//                                       [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                                   }];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1)
    {
        [self sendSOS:self.message];
    }
    else{
        self.message = @"";
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.text = @"";
}

// update changes

-(void)addCircle:(CLLocationCoordinate2D )loc
{
    [self.mapView clear];
    GMSMarker *marker = [[GMSMarker alloc] init];
//    [marker setDraggable:YES];
    marker.icon = [UIImage imageNamed:@"default_marker"];
    marker.position = loc;//CLLocationCoordinate2DMake(loc.latitude, loc.longitude);
    marker.map = self.mapView;
    [self.mapView animateToLocation:loc];
    //
        GMSCameraPosition *cameraPos = [GMSCameraPosition cameraWithLatitude:loc.latitude longitude:loc.longitude  zoom:16];
        [self.mapView setCamera:cameraPos];
    
    GMSCircle *fence = [GMSCircle circleWithPosition:loc radius:fiveHunderedFeet];
    [fence setFillColor:[UIColor colorWithRed:250.0/255 green:138.0/255 blue:138.0/255 alpha:0.3]];
    
    [fence setStrokeColor:[UIColor colorWithRed:234.0/255 green:78/255 blue:78/255 alpha:0.7]];
    [fence setMap: self.mapView];
    
}

@end
