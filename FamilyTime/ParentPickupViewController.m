////
////  ParentPickupViewController.m
////  FamilyTime
////
////  Created by Sora Code on 3/10/15.
////  Copyright (c) 2015 SoraCode. All rights reserved.
////
//
//#import "ParentPickupViewController.h"
//#import "AppDelegate.h"
////#import "JSONHTTPClient.h"
//#import "MBProgressHUD.h"
//#import "CustomIOS7AlertView.h"
////#import <Google/Analytics.h>
//#import "FTUtils.h"
//#import <CoreLocation/CoreLocation.h>
//#import "NSString+LockMustafa.h"
//
//#define fiveHunderedFeet 152.40
//
//AppDelegate *delegate;
//@interface ParentPickupViewController ()
//
//@end
//
//@implementation ParentPickupViewController
//
//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//
//    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
//    CLLocation *location = [[CLLocation alloc] initWithLatitude:[delegate.childPush.lat doubleValue] longitude:[delegate.childPush.longi doubleValue]];
//    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
//     {
//         //        for (CLPlacemark * placemark in placemarks) {
//         if(placemarks.count)
//         {
//             CLPlacemark * placemark =[placemarks objectAtIndex:0];
//             NSString *address = [NSString stringWithFormat:@"%@ %@ %@",[[placemark addressDictionary] valueForKey:@"Street"],[[placemark addressDictionary] valueForKey:@"State"],[[placemark addressDictionary] valueForKey:@"Country"]];
//             self.currentAddress.text = address;
//         }
//     }];
//
//    [_soryIcant setTitle:[@"Sorry, I can't!" myModification] forState:UIControlStateNormal];
//    [_okcoming setTitle:[@"Ok, coming!" myModification] forState:UIControlStateNormal];
//
//}
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//      self.message = @"";
//    delegate = [AppDelegate appDelegate];
//    self.currentAddress.text = delegate.childPush.address;
//    self.time.text =  [CommonModel pushTime:delegate.childPush.time];
//    //setup Google map
//    [self performSelector:@selector(Addcircle) withObject:self afterDelay:2.0];
//}
//
//-(void)Addcircle
//{
//    CLLocationCoordinate2D location =  CLLocationCoordinate2DMake(delegate.childPush.lat.doubleValue, delegate.childPush.longi.doubleValue);
//    [self addCircle:location];
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//-(UIImage*) drawImage:(UIImage*)fgImage inImage:(UIImage*)bgImage  atPoint:(CGPoint)  point
//{
////    fgImage.layer.cornerRadius = radius;
////    fgImage.layer.borderWidth = 3;
////    CALayer *imageLayer = [CALayer layer];
////    imageLayer.frame = CGRectMake(0, 0, 30,30);
////    imageLayer.contents = (id) fgImage.CGImage;
////
////    imageLayer.masksToBounds = YES;
////    imageLayer.cornerRadius = 15;
//
//    UIGraphicsBeginImageContextWithOptions(bgImage.size, FALSE, 0.0);
//    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//        [fgImage drawInRect:CGRectMake( 36, 24, bgImage.size.width/2, bgImage.size.height/2)];
//    else
//        [fgImage drawInRect:CGRectMake( 25, 6, 50, 50)];
//    [bgImage drawInRect:CGRectMake( 0, 0, bgImage.size.width, bgImage.size.height)];
//
////    [imageLayer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//
//    return newImage;
//}
//
//
//- (IBAction)pickHim:(UIButton *)sender {
//    if(sender.tag == 0)
//        [self sendAck:@"OK, coming!"];
//    else if(sender.tag == 1)
//        [self sendAck:@"Sorry, I can't!"];
//    else if(sender.tag == 2){
//
//        // Here we need to pass a full frame
//        CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
//
//        // Add some custom content to the alert view
//        UITextView *textView;
//        if (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width) == 667))
//        {
//            textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 300, 130)];
//        }
//        else if (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width) == 736))
//        {
//            textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 300, 130)];
//        }
//        else
//        {
//            textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 300, 130)];
//        }
////        textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 300, 130)];
//        textView.keyboardAppearance = UIKeyboardAppearanceAlert;
//        textView.backgroundColor = [UIColor clearColor];
//        [textView setText:@"Message"];
//        [textView setFont:[UIFont fontWithName:@"OpenSans" size:16]];
//        [textView setTextColor:[UIColor grayColor]];
//        textView.tag = 222;
//        textView.delegate = self;
//        [alertView setContainerView:textView];
//
//        // Modify the parameters
//        [alertView setButtonTitles:[NSMutableArray arrayWithObjects:[@"CANCEL" myModification], [@"SEND" myModification], nil]];
//
//        // You may use a Block, rather than a delegate.
//        [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
//            NSString *msg = [(UITextView *)[alertView viewWithTag:222] text];
//            if (buttonIndex == 0)
//            {
//                [alertView close];
//                return;
//            }
//
//            if(msg.length == 0 || [msg isEqualToString:@"Message"])
//                [CommonModel showAlert:@"" msg:[@"Please write a message" myModification]];
//            else
//                [self sendAck:msg];
//            [alertView close];
//        }];
////        [alertView setUseMotionEffects:true];
//        // And launch the dialog
//        [alertView show];
//
//    }
//}
//
//-(void)textViewDidBeginEditing:(UITextView *)textView
//{
//    textView.text = @"";
//}
//
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if(buttonIndex == 1)
//    {
//        [self sendAck:self.message];
//    }
//    else{
//        self.message = @"";
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }
//}
//
//-(void) sendAck:(NSString *)message
//{
//    self.message = message;
//    NSDictionary *params = @{@"user_id":delegate.parent.user_id,
//                             @"child_id":delegate.childPush.child_id,
//                             @"push_type":@"pickup_back",
//                             @"message":message};
//
//    [SwiftFTUtils showHUDAddedTo:self.view withText:@"Sending Acknowledgement..." animated:YES];
//
////    [JSONHTTPClient postJSONFromURLWithString:@"" //KPushBack
////                                       params:params
////                                   completion:^(id json, JSONModelError *err) {
////                                 //      NSError *error;
////                                   //    NSString *msg = [json valueForKey:@"message"] == nil ? kErrorGeneral : [json valueForKey:@"message"];
////
////                                       // read response code
////                                       if([[json valueForKey:@"response"] intValue] == 200){
////                                           [self dismissViewControllerAnimated:YES completion:nil];
////
////                                             }
////                                       else{
////                                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[@"Something went wrong" myModification] message:[@"Please check your internet connection." myModification] delegate:self cancelButtonTitle:[@"Cancel" myModification] otherButtonTitles:[@"Try again" myModification], nil];
////                                           [alert show];
////                                       }
////
////                                       [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
////                                   }];
//}
//
//-(void)addCircle:(CLLocationCoordinate2D )loc
//{
//    [self.mapView clear];
//    GMSMarker *marker = [[GMSMarker alloc] init];
//    //    [marker setDraggable:YES];
//    marker.icon = [UIImage imageNamed:@"default_marker"];
//    marker.position = loc;//CLLocationCoordinate2DMake(loc.latitude, loc.longitude);
//    marker.map = self.mapView;
//    [self.mapView animateToLocation:loc];
//    //
//    GMSCameraPosition *cameraPos = [GMSCameraPosition cameraWithLatitude:loc.latitude longitude:loc.longitude  zoom:16];
//    [self.mapView setCamera:cameraPos];
//
//    GMSCircle *fence = [GMSCircle circleWithPosition:loc radius:fiveHunderedFeet];
//    [fence setFillColor:[UIColor colorWithRed:29/255 green:166.0/255 blue:208.0/255 alpha:0.3]];
//
//    [fence setStrokeColor:[UIColor colorWithRed:80.0/255 green:148/255 blue:168/255 alpha:0.7]];
//    [fence setMap: self.mapView];
//}
//
//@end
