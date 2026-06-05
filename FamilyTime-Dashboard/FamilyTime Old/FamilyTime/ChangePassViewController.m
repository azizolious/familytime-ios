//
//  ForgotPassViewController.m
//  FamilyTime
//
//  Created by Sora Code on 11/18/14.
//  Copyright (c) 2014 SoraCode. All rights reserved.
//

#import "ChangePassViewController.h"
#import "AppDelegate.h"
#import "CommonModel.h"
#import "JSONHTTPClient.h"
#import "UIViewController+Keyboard.h"
#import "MBProgressHUD.h"
#import "ParentLoginViewController.h"
#import <Google/Analytics.h>
#import "FTUtils.h"

@interface ChangePassViewController ()

@property (nonatomic,strong) ParentLoginViewController *loginCont;

@end

@implementation ChangePassViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [FabricUtility logEventWithName:@"Change Password" contentType:@"Authentication" attributes:@{}];
    
    [self.navigationController.navigationBar setHidden:NO];
    
    // register for keyboard notifications
    [CommonModel addKeyBoardObserver:self];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [CommonModel removeKeyBoardObserver:self];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"Change Password"];
    self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc]
        initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    self.loginCont = [[ParentLoginViewController alloc] initWithNibName:@"ParentLoginViewController" bundle:nil];
    
    self.oldPswTF.delegate = self;
    self.PswTF.delegate = self;
    self.conPswTF.delegate = self;
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.oldPswTF.leftView = paddingView;
    self.oldPswTF.leftViewMode = UITextFieldViewModeAlways;
    paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.PswTF.leftView = paddingView;
    self.PswTF.leftViewMode = UITextFieldViewModeAlways;
    paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.conPswTF.leftView = paddingView;
    self.conPswTF.leftViewMode = UITextFieldViewModeAlways;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)resetPsw:(id)sender
{
    NSString *userName = [[AppDelegate appDelegate].userDefault valueForKey:@"forgotUserEmail"];
    
    NSString *oldPsw = [[self.oldPswTF text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString *psw = [[self.PswTF text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *cPsw = [[self.conPswTF text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if(oldPsw.length <=0)
        //Old password required! Please enter your old password and try again.

        [CommonModel showAlert:@"Old password required!" msg:@"Please enter your old password and try again."];
    else if(psw.length <= 0)
        //New password required! Please enter your new password and try again.

        [CommonModel showAlert:@"New password required!" msg:@"Please enter your new password and try again."];
    else if(psw.length < 4)
        [CommonModel showAlert:@"" msg:@"Password must be at least 4 digit"];
    else if(![psw isEqualToString:cPsw])
        //Passwords don't match! Please enter password and try again.

        [CommonModel showAlert:@"Passwords don't match!" msg:@"Please enter password and try again."];
    else{
        [FTUtils showHUDAddedTo:self.view withText:@"Changing password..." animated:YES];
        NSDictionary *params = @{@"user_name":userName,@"old_pass":oldPsw,@"new_pass":psw};
        [JSONHTTPClient postJSONFromURLWithString:KResetPswUrl
                                           params:params
                                       completion:^(id json, JSONModelError *err) {
                                           NSString *msg = [json valueForKey:@"message"] == nil ? kErrorGeneral : [json valueForKey:@"message"];
                                           
                                           // read response code
                                           if([[json valueForKey:@"response"] intValue] != 200 )
                                               [CommonModel showAlert:@"Error!" msg:[json valueForKey:@"message"]];
                                           else{
//                                               // reset keys
                                               [[AppDelegate appDelegate].userDefault setValue:@"" forKey:@"forgotUserEmail"];
                                               [[AppDelegate appDelegate].userDefault synchronize];
                                               
                                               [CommonModel showAlert:@"" msg:msg];
                                               [self.navigationController popToRootViewControllerAnimated:YES];
                                           }
                                           [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                       }];
    }
}

#pragma mark - TextField Delegates
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.oldPswTF)
        [self.PswTF becomeFirstResponder];
    else if (textField == self.PswTF)
        [self.conPswTF becomeFirstResponder];
    else
        [self.conPswTF resignFirstResponder];
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    if ([sender isEqual:self.oldPswTF] || [sender isEqual:self.PswTF] || [sender isEqual:self.conPswTF])
    {
        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
    }
}

@end
