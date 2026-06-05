////
////  NotSureAdddevice3ViewController.m
////  FamilyTime - Dashboard
////
////  Created by Ahmad on 1/22/18.
////  Copyright © 2018 YumyApps. All rights reserved.
////
//
//#import "NotSureAdddevice3ViewController.h"
//
//#import "MBProgressHUD.h"
//#import "JSONHTTPClient.h"
//#import "AppDelegate.h"
//#import "FTUtils.h"
//#import "NSString+LockMustafa.h"
//
//AppDelegate *delegate;
//
//@interface NotSureAdddevice3ViewController ()
//
//@end
//
//@implementation NotSureAdddevice3ViewController
//
//
//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:YES];
//
//    txtVw.scrollsToTop=YES;
//
//    NSRange lastLine = NSMakeRange(0, 0);
//    [txtVw scrollRangeToVisible:lastLine];
//
//
//    [btnBack setTitle:[@"Back" myModification] forState:UIControlStateNormal];
//
//}
//
//-(void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:YES];
//
//    txtVw.scrollsToTop=YES;
//   // txtVw.scrollRangeToVisible(NSMakeRange(0, 0))
//    NSRange lastLine = NSMakeRange(0, 0);
//    [txtVw scrollRangeToVisible:lastLine];
//}
//- (void)viewDidLoad {
//    [super viewDidLoad];
//
//    _lblTitle.text=[@"I am not sure" myModification];
//    _lblSubtitle.text=[@"No Problem, we will help you figure it out."
// myModification];
//
//    [btnBack setTitle:[@"Back" myModification] forState:UIControlStateNormal];
////    [btnBack setTitle:[@"Back" myModification] forState:UIControlStateNormal];
//
////    View Detailed Instructions
////  back
//
//    // Do any additional setup after loading the view.
////    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"Blogggg" ofType:@"rtfd"];
////
////    NSString *myText = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
////    txtVw.text  = myText;
//
//
////
////    NSBundle *myBundle = [NSBundle mainBundle];
////    NSString *sFile= [myBundle pathForResource:@"Blogggg" ofType:@"rtfd"];
////    [txtVw readRTFDFromFile:sFile];
//
//
//    /*
//    txtVw.attributedText =
//    [   NSAttributedString.alloc
//     initWithFileURL:[ NSBundle.mainBundle URLForResource:@"Blogggg" withExtension:@"rtfd"]
//     options:nil
//     documentAttributes:nil
//     error:nil
//     ];
//
//    txtVw.scrollsToTop=YES;
//
//
//
//    if(IS_IPHONE_5)
//    {
//        txtVw.font= [UIFont fontWithName:@"OpenSans" size:18];
//    }
//    else if(IS_IPHONE_6)
//    {
//        txtVw.font= [UIFont fontWithName:@"OpenSans" size:18];
//    }
//    else if(IS_IPHONE_6_PLUS)
//    {
//        txtVw.font= [UIFont fontWithName:@"OpenSans" size:18];
//    }
//    else if(IS_IPHONE_X)
//    {
//        txtVw.font= [UIFont fontWithName:@"OpenSans" size:18];
//    }
//    else
//    {
//        txtVw.font= [UIFont fontWithName:@"OpenSans" size:25];
//    }
//
//    */
//
//    //START
//    /*
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"before after"];
//    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
//    textAttachment.image = [UIImage imageNamed:@"ic_device_ios-1"];
//
//    CGFloat oldWidth = textAttachment.image.size.width;
//
//        //I'm subtracting 10px to make the image display nicely, accounting
//        //for the padding inside the textView
//    CGFloat scaleFactor = oldWidth / (txtVw.frame.size.width - 10);
//    textAttachment.image = [UIImage imageWithCGImage:textAttachment.image.CGImage scale:scaleFactor orientation:UIImageOrientationUp];
//    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
//    [attributedString replaceCharactersInRange:NSMakeRange(6, 1) withAttributedString:attrStringWithImage];
//    txtVw.attributedText = attributedString;
//
//
//    */
//    //END
//
//    NSString *str1=[@"First, Check the back of the device. If it has Apple logo on it, then it is an iPhone, iPad or iPod Touch. Go back and choose iOS for instructions." myModification];
//
//
//    NSString *str2=[@"Otherwise, it is likely to be an Android device. It may have a logo manufacture of the companies which make them(like LG, Samsung, Motorola, HTC, etc.)" myModification];
//
//
//    NSString *str3=[@"To make sure it is an Android device, just check that it has Google Play Store app installed on it. If so then go back and choose Android for instructions." myModification];
//
//
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n\n\n\n%@\n\n\n\n\n\n\n%@\n\n%@\n",str1,str2,str3]];
//
//
////    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
////    textAttachment.image = [UIImage imageNamed:@"ic_device_ios-1"];
////
////    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
////
////    [attributedString replaceCharactersInRange:NSMakeRange(4, 1) withAttributedString:attrStringWithImage];
////
//    txtVw.attributedText =attributedString;
//    ////
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"im_ios"]];
//    CGRect aRect = CGRectMake(txtVw.frame.size.width/2 -33 +30 , 8, 66, 66);
//        if(IS_IPHONE_5)
//        {
//
//        attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n\n\n\n\n\n%@\n\n\n\n\n\n\n\n\n\n\n\n%@\n\n%@\n",str1,str2,str3]];
//
//        aRect = CGRectMake(txtVw.frame.size.width/2 -30 +30 -33, 8, 66, 66);
//        }
//        else if(IS_IPHONE_6_PLUS)
//        {
//
//        aRect = CGRectMake(txtVw.frame.size.width/2 -33 +30 +20 , 8, 66, 66);
//        }
//        else if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//        {
//
//            aRect = CGRectMake(txtVw.frame.size.width/2 -60 +30+30+30 , 8, 120, 120);
//        }
//
//    [imageView setFrame:aRect];
//    UIBezierPath *exclusionPath = [UIBezierPath bezierPathWithRect:CGRectMake(CGRectGetMinX(imageView.frame), CGRectGetMinY(imageView.frame), CGRectGetWidth(txtVw.frame), CGRectGetHeight(imageView.frame))];
//    txtVw.textContainer.exclusionPaths = @[exclusionPath];
//    [txtVw addSubview:imageView];
//
//    UIImageView *imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_device_android-1"]];
//    CGRect aRect2 = CGRectMake(txtVw.frame.size.width/2 -33 +30, 230-20, 66, 66);
//
//    if(IS_IPHONE_5)
//    {
//            aRect2 = CGRectMake(txtVw.frame.size.width/2 -40 +30-33+10, 280-35-30-30-10, 66, 66);
//    }
//    else if(IS_IPHONE_6_PLUS)
//    {
//
//        aRect2 = CGRectMake(txtVw.frame.size.width/2 -33 +30+20, 230-20-20, 66, 66);
//
//    }
//    else if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//    {
//        aRect2 = CGRectMake(txtVw.frame.size.width/2 -60 +30+30+30, 230-20, 120, 120);
//
//    }
//
//
//    [imageView2 setFrame:aRect2];
//    UIBezierPath *exclusionPath2 = [UIBezierPath bezierPathWithRect:CGRectMake(CGRectGetMinX(imageView2.frame), CGRectGetMinY(imageView2.frame), CGRectGetWidth(txtVw.frame), CGRectGetHeight(imageView2.frame))];
//    txtVw.textContainer.exclusionPaths = @[exclusionPath2];
//    [txtVw addSubview:imageView2];
//
//
//    if(IS_IPHONE_5)
//    {
//        txtVw.font= [UIFont fontWithName:@"OpenSans" size:13];
//    }
//    else if(IS_IPHONE_6)
//    {
//        txtVw.font= [UIFont fontWithName:@"OpenSans" size:15];
//    }
//    else if(IS_IPHONE_6_PLUS)
//    {
//        txtVw.font= [UIFont fontWithName:@"OpenSans" size:15];
//    }
//    else if(IS_IPHONE_X)
//    {
//        txtVw.font= [UIFont fontWithName:@"OpenSans" size:15];
//    }
//    else
//    {
//        txtVw.font= [UIFont fontWithName:@"OpenSans" size:23];
//    }
//
//    btnBack.layer.cornerRadius=btnBack.frame.size.height/2.0;
//    btnBack.layer.masksToBounds=YES;
//
//
//
////    btnBack.backgroundColor= [UIColor colorWithRed:255.0/255.0 green:162.0/255.0
////                                              blue:23.0/255.0 alpha:1.0];
//
//    txtVw.editable=NO;
//
//
//
//}
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/
//
//
//
//-(IBAction)YesIdoneIt:(id)sender
//{
//
//    [self.navigationController popViewControllerAnimated:YES];
//
////    [self dismissViewControllerAnimated:YES completion:^{
////        [[NSNotificationCenter defaultCenter] postNotificationName:@"RELOAD_DASHBOARD" object:nil];
////    }];
////
//}
//
//
//- (void) loadDashboard
//{
//    [SwiftFTUtils showHUDAddedTo:self.view withText:[@"Loading..." myModification] animated:YES];
//    NSLog(@"%@",delegate.parent.user_id);
//
////    NSString *url = [NSString stringWithFormat:@"%@%@",KDashboardNew,delegate.parent.user_id];
//
//
//    //---DEPRICATED---//
//    NSString *url = [NSString stringWithFormat:@"%@%@",@"",delegate.parent.user_id];
//
//    [JSONHTTPClient getJSONFromURLWithString:url
//                                      params:nil
//                                  completion:^(id json, JSONModelError *err) {
//                                      if([[json valueForKey:@"status_code"] intValue]== 200)
//                                      {
//                                          NSLog(@"here=%@",json);
//
//                                          //                                           [[NSUserDefaults standardUserDefaults]setObject:json forKey:@"Dashboard"];
//
//
//                                          NSArray *arr= [[json objectForKey:@"response"]objectForKey:@"children"];
//                                          NSMutableArray *arrnew=[NSMutableArray new];
//
//                                          for(int o=0;o<arr.count;o++)
//                                          {
//                                              if([[arr objectAtIndex:o]objectForKey:@"device_info"]!=nil)
//                                              {
//                                                  if(([[[arr objectAtIndex:o]objectForKey:@"device_info"]objectForKey:@"latitude"]==[NSNull null])||([[[arr objectAtIndex:o]objectForKey:@"device_info"]objectForKey:@"longitude"]==[NSNull null]))
//                                                  {
//
//                                                  }
//                                                  else
//                                                  {
//                                                      NSString *strlat=  [[[arr objectAtIndex:o]objectForKey:@"device_info"]objectForKey:@"latitude"];
//                                                      NSString *strlong=  [[[arr objectAtIndex:o]objectForKey:@"device_info"]objectForKey:@"longitude"];
//                                                      NSMutableDictionary *dic=[NSMutableDictionary new];
//                                                      [dic setValue:strlat forKey:@"lat"];
//                                                      [dic setValue:strlong forKey:@"long"];
//
//                                                      [arrnew addObject:dic];
//                                                  }
//
//                                              }
//                                          }
//
//
//                                          [[NSUserDefaults standardUserDefaults]setObject:[arrnew copy] forKey:@"ChildrenAll"];
//                                          [[NSUserDefaults standardUserDefaults] synchronize];
//
////                                          self.dashboard = [[Dashboard alloc] init];
////                                          [self.dashboard mts_setValuesForKeysWithDictionary:json];
////                                          [self.dashboard sortParents];
////                                          [self.dashboard sortChilds];
////
////                                          delegate.dashboard = self.dashboard;
//
//
//                                          /*
//                                           NSSortDescriptor *sortDescriptor;
//                                           sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"info.name"
//                                           ascending:YES];
//                                           NSArray *sortedArray = [arr sortedArrayUsingDescriptors:@[sortDescriptor]];
//
//                                           NSLog(@"sortedArray=%@",sortedArray);
//
//                                           */
//
//
//
//
//
//
//
//
//                                          //                                           delegate.dashboard.children=[sortedArray mutableCopy];
//
//
//
//                                          //                                           NSSortDescriptor *sortDescriptor;
//                                          //                                           sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"device_info" ascending:YES];
//                                          //                                           NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
//                                          //                                           NSArray *sortedArray;
//                                          //                                           sortedArray = [delegate.dashboard.children sortedArrayUsingDescriptors:sortDescriptors];
//                                          //                                           delegate.dashboard.children=[sortedArray mutableCopy];
//
//                                          if(delegate.dashboard.coparents.count == 0 && delegate.dashboard.children.count == 0)
//                                          {
////                                              WizardScreen3ViewController *controller = [[WizardScreen3ViewController alloc] init];
////                                              controller.fromDashboard = YES;
////                                              controller.addingFirstUser = YES;
////                                              UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
////                                              [self presentViewController:navController animated:YES completion:nil];
//                                          }
//                                          //    return delegate.dashboard.coparents.count + delegate.dashboard.children.count;
//
//                                          for(int o=0;o<delegate.dashboard.children.count;o++)
//                                          {
//                                              DashboardChild *child = (DashboardChild *)[delegate.dashboard.children objectAtIndex:o];
//                                              if (child.active == 0)
//                                              {
//                                                  //                                               inactiveCell.child = child;
//                                                  //                                               return inactiveCell;
//                                                  [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"familymapEnable"];
//
//                                                  familymapEnable=NO;
//
//                                              }
//                                              else
//                                              {
//
//                                                  [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"familymapEnable"];
//                                                  familymapEnable=YES;
//
//                                                  break;
//                                                  //                                               activeCell.child = child;
//                                                  //                                               return activeCell;
//                                              }
//                                          }
//
//                                      }
//                                      else
//                                          [CommonModel showAlert:@"Error!" msg:[json valueForKey:@"status_message"]];
//                                      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//
//                                  }];
//}
//@end
