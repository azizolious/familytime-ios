//
//  ChangePasswordViewController.m
//  FamilyTime - Dashboard
//
//  Created by Muhammad Ajmal on 01/02/2017.
//  Copyright © 2017 SoraCode. All rights reserved.
//

#import "ChangePasswordViewController1.h"
#import "IQKeyboardManager.h"
#import "FTUtils.h"
#import "AppDelegate.h"
#import "CommonModel.h"
//#import "JSONHTTPClient.h"
#import "MBProgressHUD.h"
#import "NSString+LockMustafa.h"
#import "FamilyTime-Swift.h"



@interface ChangePasswordViewController1 ()<UIAlertViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *currentPasswotdTextField;
@property (weak, nonatomic) IBOutlet UITextField *nPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UIImageView *logoView;
@property (weak, nonatomic) IBOutlet UILabel     *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton    *changePasswordButton;

@end

@implementation ChangePasswordViewController1

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
//    _currentPasswotdTextField
    
    _currentPasswotdTextField.placeholder = [NSString stringWithFormat:@" %@",[@"CURRENT PASSWORD" myModification]];
    _nPasswordTextField.placeholder       = [NSString stringWithFormat:@" %@",[@"NEW PASSWORD" myModification]];
    _confirmPasswordTextField.placeholder = [NSString stringWithFormat:@" %@",[@"CONFIRM NEW PASSWORD" myModification]];

    _changePasswordButton.titleLabel.text = [_changePasswordButton.titleLabel.text myModification];
    
//    _nPasswordTextField.placeholder=[@"NEW PASSWORD" myModification]];
//    _confirmPasswordTextField.placeholder=[@"CONFIRM PASSWORD" myModification];
    
//    _currentPasswotdTextField.placeholder=[_currentPasswotdTextField.placeholder myModification];
//    _nPasswordTextField.placeholder=[_nPasswordTextField.placeholder myModification];
//    _confirmPasswordTextField.placeholder=[_confirmPasswordTextField.placeholder myModification];

    self.title = [@"Change Password" myModification];
    
    _currentPasswotdTextField.delegate = self;
    self.nPasswordTextField.delegate   = self;
    self.confirmPasswordTextField.delegate = self;
    
    
    self.currentPasswotdTextField.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5f].CGColor;
    self.currentPasswotdTextField.layer.borderWidth = 0.5f;
    self.nPasswordTextField.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5f].CGColor;
    self.nPasswordTextField.layer.borderWidth = 0.5f;
    self.confirmPasswordTextField.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5f].CGColor;
    self.confirmPasswordTextField.layer.borderWidth = 0.5f;
    
    UIView *currentPasswotdPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.currentPasswotdTextField.leftView = currentPasswotdPaddingView;
    self.currentPasswotdTextField.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *nPasswotdPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.nPasswordTextField.leftView = nPasswotdPaddingView;
    self.nPasswordTextField.leftViewMode = UITextFieldViewModeAlways;
    
    
    UIView *cPasswotdPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.confirmPasswordTextField.leftView = cPasswotdPaddingView;
    self.confirmPasswordTextField.leftViewMode = UITextFieldViewModeAlways;
    
    if(IS_IPHONE_4)
    {
        _nameLabel.font = [UIFont fontWithName:@"OpenSans" size:20];
        _currentPasswotdTextField.font = [UIFont fontWithName:@"OpenSans-Light" size:10];
        _nPasswordTextField.font = [UIFont fontWithName:@"OpenSans-Light" size:10];
        _confirmPasswordTextField.font = [UIFont fontWithName:@"OpenSans-Light" size:10];
        _changePasswordButton.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:12];
    }
    else if(IS_IPHONE_5)
    {
        _nameLabel.font = [UIFont fontWithName:@"OpenSans" size:21];
        _currentPasswotdTextField.font = [UIFont fontWithName:@"OpenSans-Light" size:11];
        _nPasswordTextField.font = [UIFont fontWithName:@"OpenSans-Light" size:11];
        _confirmPasswordTextField.font = [UIFont fontWithName:@"OpenSans-Light" size:11];
        _changePasswordButton.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:13];
    }
    else if(IS_IPHONE_6)
    {
        _nameLabel.font = [UIFont fontWithName:@"OpenSans" size:25];
        _currentPasswotdTextField.font = [UIFont fontWithName:@"OpenSans-Light" size:13];
        _nPasswordTextField.font = [UIFont fontWithName:@"OpenSans-Light" size:13];
        _confirmPasswordTextField.font = [UIFont fontWithName:@"OpenSans-Light" size:13];
        _changePasswordButton.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:16];
    }
    else if(IS_IPHONE_6_PLUS)
    {
        _nameLabel.font = [UIFont fontWithName:@"OpenSans" size:28];
        _currentPasswotdTextField.font = [UIFont fontWithName:@"OpenSans-Light" size:14];
        _nPasswordTextField.font = [UIFont fontWithName:@"OpenSans-Light" size:14];
        _confirmPasswordTextField.font = [UIFont fontWithName:@"OpenSans-Light" size:14];
        _changePasswordButton.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:17];
    }
    else if(IS_IPHONE_X)
    {
        _nameLabel.font = [UIFont fontWithName:@"OpenSans" size:28];
        _currentPasswotdTextField.font = [UIFont fontWithName:@"OpenSans-Light" size:14];
        _nPasswordTextField.font = [UIFont fontWithName:@"OpenSans-Light" size:14];
        _confirmPasswordTextField.font = [UIFont fontWithName:@"OpenSans-Light" size:14];
        _changePasswordButton.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:17];
    }
    else
    {
        _nameLabel.font = [UIFont fontWithName:@"OpenSans" size:45];
        _currentPasswotdTextField.font = [UIFont fontWithName:@"OpenSans-Light" size:25];
        _nPasswordTextField.font = [UIFont fontWithName:@"OpenSans-Light" size:25];
        _confirmPasswordTextField.font = [UIFont fontWithName:@"OpenSans-Light" size:25];
        _changePasswordButton.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:32];
    }
    
    [_changePasswordButton setTitle:[@"CHANGE PASSWORD" myModification] forState:UIControlStateNormal];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *delegate = [AppDelegate appDelegate];
//    self.nameLabel.text = [NSString stringWithFormat:@"%@'s Family",delegate.parent.name];
    self.nameLabel.text = [NSString stringWithFormat:@"%@",delegate.parent.name];

    if ([[delegate.parent.relationship lowercaseString] isEqualToString:NSLocalizedString(@"Mother",nil)]) {
        self.logoView.image = [UIImage imageNamed:@"change_avater1"];
    }
    else {
        self.logoView.image = [UIImage imageNamed:@"change_avater"];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    NSLog(@"%@",NSStringFromCGRect(self.view.bounds));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)handleChangePassword:(id)sender
{
    if (![self validate]) {
        return;
    }
    
//    //---OLD API IMPLEMENTATION---//
//    [SwiftFTUtils showHUDAddedTo:self.view withText:@"Changing Password..." animated:YES];
//    AppDelegate *delegate = [AppDelegate appDelegate];
//    NSDictionary *params = @{@"user_name":delegate.parent.email,@"old_pass":self.currentPasswotdTextField.text,@"new_pass":self.nPasswordTextField.text};
//
//    NSLog(@"url for change password = %@)", kChangePassword_mesh2);
//
//    [JSONHTTPClient postJSONFromURLWithString:kChangePassword_mesh2 params:params completion:^(id json, JSONModelError *err) {
//        if([json[@"response"] integerValue] == 200)
//        {
//            [[[UIAlertView alloc] initWithTitle:@"Logout" message:[json valueForKey:@"message"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
//        }
//        else
//        {
//            [CommonModel showAlert:@"Error!" msg:[json valueForKey:@"message"]];
//        }
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//    }];
    
    
    //---MESH2 API IMPLEMENTATION---//
    [SwiftFTUtils showHUDAddedTo:self.view withText:@"Changing Password..." animated:YES];
    NSDictionary *params = @{@"current_password":self.currentPasswotdTextField.text,
                             @"new_password":self.nPasswordTextField.text};
    
    NSLog(@"url for change password = %@ and params = %@)", kChangePassword_mesh2, params);
    
    
    
    [[ApiManager shared] postApiWithPwdVC:self isPresentedCont:NO andParams:params withApi:kChangePassword_mesh2 withResponse:^(NSString * _Nonnull message, NSInteger statusCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"change password code = %ld", (long)statusCode);
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            if(statusCode == 200)
                [[[UIAlertView alloc] initWithTitle:@"Logout" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
            else
                [CommonModel showAlert:@"Error!" msg:message];
        });
    }];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    AppDelegate *delegate = [AppDelegate appDelegate];
    [delegate.userDefault setObject:nil forKey:@"user"];
    [[AppDelegate appDelegate] setNavigationbarAppearence:YES cont:self];
    [delegate setupDrawer:2];
}

- (BOOL)validate
{
    if (self.currentPasswotdTextField.text == nil || self.currentPasswotdTextField.text.length == 0)
    {
        [CommonModel showAlert:[@"Change Password" myModification] msg:[@"Please provide current password" myModification]];
        return NO;
    }
    if (self.nPasswordTextField.text == nil || self.nPasswordTextField.text.length == 0)
    {
        [CommonModel showAlert:[@"Change Password" myModification] msg:[@"Please provide new password" myModification]];
        return NO;
    }
    if (self.confirmPasswordTextField.text == nil || self.confirmPasswordTextField.text.length == 0)
    {
        [CommonModel showAlert:[@"Change Password" myModification] msg:[@"Please provide confirm password" myModification]];
        return NO;
    }
    if (![self.confirmPasswordTextField.text isEqualToString:self.nPasswordTextField.text])
    {
        [CommonModel showAlert:[@"Change Password" myModification] msg:[@"New password and Confirm passwords doesn't match" myModification]];
        return NO;
    }
    return YES;
}

#pragma mark UITextField Delegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];

    [self.view endEditing:YES];
    return YES;
}


- (void)keyboardDidShow:(NSNotification *)notification
{
//    [self.navigationController.navigationBar setUserInteractionEnabled:false];
//    [self.navigationController.navigationBar setHidden:true];
}

-(void)keyboardDidHide:(NSNotification *)notification
{
//    [self.navigationController.navigationBar setUserInteractionEnabled:true];
    
//    [self.navigationController.navigationBar setHidden:false];
}

@end
