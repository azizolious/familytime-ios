////
////  ParentRegViewController.m
////  FamilyTime
////
////  Created by Sora Code on 11/12/14.
////  Copyright (c) 2014 SoraCode. All rights reserved.
////
//
//#import "ParentRegViewController.h"
//#import "Constant.h"
//#import "UIViewController+Keyboard.h"
//#import "JSONHTTPClient.h"
//#import "AppDelegate.h"
//#import "MBProgressHUD.h"
//#import "WizardScreen1ViewController.h"
////#import <Google/Analytics.h>
//#import "FTUtils.h"
//
//@interface ParentRegViewController ()
//@property (weak, nonatomic) IBOutlet UIImageView *bgView;
//
//@end
//
//@implementation ParentRegViewController
//
//
//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//
//     [self.navigationController.navigationBar setHidden:NO];
//    
//    // register for keyboard notifications
//    [CommonModel addKeyBoardObserver:self];
//
//}
//-(void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    [CommonModel removeKeyBoardObserver:self];
//
//}
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    [self.navigationItem setTitle:@"Registration"];
//    
////    self.loginCont = [[ParentLoginViewController alloc] initWithNibName:@"ParentLoginViewController" bundle:nil];
//    self.actCont = [[ParentActivationViewController alloc] initWithNibName:@"ParentActivationViewController" bundle:nil];
////    self.nameTV.text = @"Ahad Nawaz";
////    self.emailTV.text = @"ahad.k@yumyapps.com";
//    //setting field(s) place holder color
//    self.nameTV.attributedPlaceholder = kTFColor(@"NAME");
//    self.emailTV.attributedPlaceholder = kTFColor(@"EMAIL");
//    
//    [self.nameTV setDelegate:self];
//    [self.emailTV setDelegate:self];
//    
//    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
//    self.nameTV.leftView = paddingView;
//    self.nameTV.leftViewMode = UITextFieldViewModeAlways;
//    paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
//    self.emailTV.leftView = paddingView;
//    self.emailTV.leftViewMode = UITextFieldViewModeAlways;
//    
//    if(IS_IPHONE_4)
//    {
//        self.bgView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"background_4s" ofType:@"png"]];
//    }
//    else if(IS_IPHONE_5)
//    {
//        self.bgView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"background_5s" ofType:@"png"]];
//    }
//    else if(IS_IPHONE_6)
//    {
//        self.bgView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"background_6s" ofType:@"png"]];
//    }
//    else if(IS_IPHONE_6_PLUS)
//    {
//        self.bgView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"background_6plus" ofType:@"png"]];
//    }
//    else if(IS_IPHONE_X)
//    {
//        
//        self.bgView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"background_6plus" ofType:@"png"]];
//    }
//    else
//    {
//        self.bgView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"background_ipad" ofType:@"png"]];
//    }
//
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//- (IBAction)login:(id)sender {
//    [self.navigationController popViewControllerAnimated:YES];
//}
//
//- (IBAction)activateAccount:(id)sender
//{
//    NSString *userName = [[self.nameTV text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    
//    NSString *email = [[self.emailTV text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    NSString *deviceToken = [[AppDelegate appDelegate].userDefault valueForKey:@"deviceToken"];
//    NSLog(@"%@",deviceToken);
//    if(userName.length <=0)
//        //Unsername required! Please enter your username and try again.
//
//        [CommonModel showAlert:@"Name required!" msg:@"Please enter your name and try again."];
//    else if(email.length <= 0)
//        //Email ID required! Please enter your email and try again.
//
//        [CommonModel showAlert:@"Email ID required!" msg:@"Please enter your email and try again."];
//    else if(![CommonModel isValidEmail:email])
//        //Email ID invalid! Please enter a valid email ID and try again.
//
//        [CommonModel showAlert:@"Email ID invalid!" msg:@"Please enter a valid email ID and try again."];
////    else if(deviceToken.length <=0)
////        [CommonModel showAlert:@"" msg:@"Network error please try later"];
//    
//    else
//    {
//
//    [SwiftFTUtils showHUDAddedTo:self.view withText:@"Creating Account..." animated:YES];
//    [JSONHTTPClient postJSONFromURLWithString:KUserAddUrl
//                                       params:@{@"name":userName,@"email":email,@"device":@"iphone",@"token":(deviceToken == nil) ? @"" : deviceToken}
//                                  completion:^(id json, JSONModelError *err) {
//                                      
//                                      if([[json valueForKey:@"response"] intValue] != 200 )
//                                          [CommonModel showAlert:@"Error!" msg:[json valueForKey:@"message"]];
//                                      else
//                                      {
//                                          NSLog(@"JSON: %@", [json valueForKey:@"data"]);
//                                          WizardScreen1ViewController *controller = [[WizardScreen1ViewController alloc] init];
//                                          controller.email = email;
//                                          UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
//                                          [self presentViewController:navController animated:YES completion:nil];
//                                     
//                                      }
//                                      
//                                      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                                  }];
//    }
//}
//
//#pragma mark - TextField Delegates
//-(BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    if (textField == self.nameTV)
//        [self.emailTV becomeFirstResponder];
//    else{
//        [self.emailTV resignFirstResponder];
//    }
//    return YES;
//}
//
//-(void)textFieldDidBeginEditing:(UITextField *)sender
//{
//    if ([sender isEqual:self.emailTV])// || [sender isEqual:self.nameTV] )
//    {
//
//    }
//}
//
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex ==0 && alertView.tag == 745)
//    {
//        [self.navigationController pushViewController:self.loginCont animated:YES];
//    }
//}
//
//@end
