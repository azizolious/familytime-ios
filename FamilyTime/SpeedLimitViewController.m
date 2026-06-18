//
//  SpeedLimitViewController.m
//  FamilyTime - Dashboard
//
//  Created by Muhammad Ajmal on 12/07/2016.
//  Copyright © 2016 SoraCode. All rights reserved.
//

#import "SpeedLimitViewController.h"
#import "FTUtils.h"
//#import <Google/Analytics.h>
#import "AppDelegate.h" 
#import "MBProgressHUD.h"
//#import "JSONHTTPClient.h"
#import "Dashboard.h"
#import "NSString+LockMustafa.h"
#import "CommonModel.h"
#import "FamilyTime-Swift.h"

AppDelegate *delegate;
@interface SpeedLimitViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *speedTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textfieldHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *speedTitleTopMargin;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
@property (weak, nonatomic) IBOutlet UILabel *overspeedLabel;
@property (weak, nonatomic) IBOutlet UILabel *enableSpeedLimit;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *speedometerTopMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *saveButtonBottomMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *speedometerImageHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *speedometerImageWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textfieldWidth;
@property (weak, nonatomic) IBOutlet UISwitch *switchView;

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@end

@implementation SpeedLimitViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}
- (IBAction)switchValueChanged:(id)sender {
    
   // [self updateActivation];
    
   UISwitch *mySwitch = (UISwitch *)sender;
   if ([mySwitch isOn]) {
      _speedTextField.userInteractionEnabled=YES;
   } else {
       _speedTextField.userInteractionEnabled=NO;
   }
    
   // [self updateActivation];
}
- (IBAction)handleSaveButton:(id)sender {
    
    //[self updateSpeed];
    
     [self updateActivation];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _speedLabel.adjustsFontSizeToFitWidth=YES;
     _speedTextField.userInteractionEnabled=NO;
    _enableSpeedLimit.text=[@"Enable Speed Limit" myModification];
    
    rightButton= [[UIBarButtonItem alloc] initWithTitle:[@"Save" myModification] style:UIBarButtonItemStylePlain target:self action:@selector(handleSaveButton:)];
    self.navigationItem.rightBarButtonItems =[NSArray arrayWithObjects:rightButton,nil];
    
    self.title = [@"Speed Limit" myModification];
    delegate = [AppDelegate appDelegate];
     _speedTextField.text = @"";
    _speedTextField.tintColor = [UIColor redColor];
    _speedTextField.delegate = self;
    if(IS_IPHONE_4)
    {
        _speedometerTopMargin.constant = 10;
        _speedTextField.font = [UIFont fontWithName:@"Open24DisplaySt" size:100];
        _textfieldHeightConstraint.constant = 90;
        _speedTitleTopMargin.constant = 30;
        _speedLabel.font = [UIFont fontWithName:@"OpenSans" size:25];
        _overspeedLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:13];
        _saveButtonBottomMargin.constant = 15;
    }
    else if(IS_IPHONE_5)
    {
        _speedometerTopMargin.constant = 40;
        _speedTextField.font = [UIFont fontWithName:@"Open24DisplaySt" size:100];
        _textfieldHeightConstraint.constant = 90;
        _speedTitleTopMargin.constant = 60;
        _speedLabel.font = [UIFont fontWithName:@"OpenSans" size:25];
        _overspeedLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:13];
    }
    else if(IS_IPHONE_6)
    {
        _speedTextField.font = [UIFont fontWithName:@"Open24DisplaySt" size:100];
        _textfieldHeightConstraint.constant = 90;
        _speedTitleTopMargin.constant = 100;
        _speedLabel.font = [UIFont fontWithName:@"OpenSans" size:35];
        _overspeedLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:15];
    }
    else if(IS_IPHONE_6_PLUS)
    {
         _speedTextField.font = [UIFont fontWithName:@"Open24DisplaySt" size:100];
        _textfieldHeightConstraint.constant = 90;
        _speedTitleTopMargin.constant = 100;
        _speedLabel.font = [UIFont fontWithName:@"OpenSans" size:30];
        _overspeedLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:15];
    }
    else if(IS_IPHONE_X)
    {
        _speedTextField.font = [UIFont fontWithName:@"Open24DisplaySt" size:100];
        _textfieldHeightConstraint.constant = 90;
        _speedTitleTopMargin.constant = 100;
        _speedLabel.font = [UIFont fontWithName:@"OpenSans" size:35];
        _overspeedLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:15];
    }
    else
    {
        _speedometerImageWidth.constant = 568;
        _speedometerImageHeight.constant = 280;
        _textfieldWidth.constant = 120;
        _speedTextField.font = [UIFont fontWithName:@"Open24DisplaySt" size:100];
        _textfieldHeightConstraint.constant = 140;
        _speedTitleTopMargin.constant = 150;
        _speedLabel.font = [UIFont fontWithName:@"OpenSans" size:55];
        _overspeedLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:20];
        _saveButtonBottomMargin.constant = 75;
    }
    
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:self.tapGesture];
    
    _speedLabel.text=[_speedLabel.text myModification];
    _overspeedLabel.text=[_overspeedLabel.text myModification];
    
}

- (void)handleTap:(UIGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded)
    {
        [_speedTextField resignFirstResponder];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadSpeed];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self updateSpeed];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // allow adding of chars
    if (textField.text.length < 2 && string.integerValue >= 0 && string.integerValue <= 9) {
        return YES;
    }
    // allow deleting
    if (textField.text.length == 2 && string.length == 0 && string.integerValue >= 0 && string.integerValue <= 9) {
        return YES;
    }
    
    return NO;
}

- (void)loadSpeed
{
    DashboardChildPreference *speedlimitPreference = [delegate.selectedDashboardChild getPreferencesWithName:@"speed_limit"];
    [_switchView setOn:speedlimitPreference.status];
    _speedTextField.text = [NSString stringWithFormat:@"%@",speedlimitPreference.value];
    
    if([_switchView isOn]){
        _speedTextField.userInteractionEnabled=YES;
        
    }else{
        
        _speedTextField.userInteractionEnabled=NO;
    }
    
}

- (void)updateSpeed
{
    if (_speedTextField.text.integerValue <= 25)
    {
        [CommonModel showAlert:[@"Speed Limit" myModification] msg:[@"Speed Limit should be greather than 25" myModification]];
        return;
    }
    [SwiftFTUtils showHUDAddedTo:self.view withText:[@"Updating..." myModification] animated:YES];
    AppDelegate *delegate = [AppDelegate appDelegate];
   // NSString *url = [NSString stringWithFormat:@"%@/v2/ftd/settings/ios/speedlimit/%ld",kBasUrl,delegate.selectedDashboardChild.child_id];
     NSString *url = [NSString stringWithFormat:@"%@/dashboard/settings/ios/speedlimit/%ld",kBasUrlNew_mesh2,delegate.selectedDashboardChild.child_id];
    
    
    /*
     
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:_speedTextField.text,@"speed_limit", nil];
    
    [JSONHTTPClient postJSONFromURLWithString:url
                                      params:params
                                  completion:^(id json, JSONModelError *err) {
                                      
                                      if([json[@"status_code"] integerValue] == 200){
                                          DashboardChildPreference *speedlimitPreference = [delegate.selectedDashboardChild getPreferencesWithName:@"speed_limit"];
                                          speedlimitPreference.value = _speedTextField.text;
                                        [delegate.selectedDashboardChild updatePreferenceWitPreference:speedlimitPreference];
                                      }
                                      else{
                                          [CommonModel showAlert:[@"Error!" myModification] msg:[json valueForKey:@"message"]];                                       }
                                      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                  }];
    
    */
    
    //---NATIVE API CALLING---//
    
    ///*
    
    NSString *paramStr = [NSString stringWithFormat:@"speed_limit=%@", _speedTextField.text];
    
    [[ApiManager shared] mesh_postApiWithParamString:paramStr withApi:url withResponse:^(NSDictionary * _Nonnull json, NSInteger errorCode, NSString * _Nonnull message) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"Old Mesh update speed limit api json response = %@", json);
            
            if([json[@"status"] integerValue] == 200){
                DashboardChildPreference *speedlimitPreference = [delegate.selectedDashboardChild getPreferencesWithName:@"speed_limit"];
                speedlimitPreference.value = _speedTextField.text;
                [delegate.selectedDashboardChild updatePreferenceWitPreference:speedlimitPreference];
            }
            else
                [CommonModel showAlert:[@"Error!" myModification] msg:[json valueForKey:@"message"]];
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        });
        
    }];
     
     //*/
    
}

- (void)updateActivation


{
    
    if (_speedTextField.text.integerValue <= 25)
    {
        [CommonModel showAlert:[@"Speed Limit" myModification] msg:[@"Speed Limit should be greather than 25" myModification]];
        return;
    }
    [SwiftFTUtils showHUDAddedTo:self.view withText:[@"Updating..." myModification] animated:YES];
    AppDelegate *delegate = [AppDelegate appDelegate];
    //NSString *url = [NSString stringWithFormat:@"%@/v2/ftd/settings/ios/speedlimit/%ld",kBasUrl,(long)delegate.selectedDashboardChild.child_id];
    
    NSString *url = [NSString stringWithFormat:@"%@/dashboard/settings/ios/speedlimit/%ld",kBasUrlNew_mesh2,(long)delegate.selectedDashboardChild.child_id];
    
    
    
    /*
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:_switchView.isOn ? @"1":@"0" ,@"status", nil];
     
    [JSONHTTPClient postJSONFromURLWithString:url
                                       params:params
                                   completion:^(id json, JSONModelError *err) {
                                       
                                       if([json[@"status_code"] integerValue] == 200){
                                           DashboardChildPreference *speedlimitPreference = [delegate.selectedDashboardChild getPreferencesWithName:@"speed_limit"];
                                           speedlimitPreference.status = _switchView.isOn ? 1 : 0;
                                           [delegate.selectedDashboardChild updatePreferenceWitPreference:speedlimitPreference];
                                       }
                                       else{
                                           [CommonModel showAlert:[@"Error!" myModification] msg:[json valueForKey:@"message"]];                                       }
                                       [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                   }];
    
    */
    
    //---NATIVE API CALLING---//
    
    ///*
     
   // NSString *paramStr = [NSString stringWithFormat:@"status=%@", _switchView.isOn ? @"1":@"0"];
    //NSString *paramStr = [NSString stringWithFormat:@"status=%@", _switchView.isOn ? @"1":@"0"];
       
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    
    [param setObject:_switchView.isOn ? @"1":@"0" forKey:@"status"];
    [param setObject:_speedTextField.text forKey:@"speed_limit"];
       
       //param = [@"status":_switchView.isOn ? @"1":@"0",@"speed_limit":@"45"];
    
    [[ApiManager shared] mesh_putApiWithParamString:param withApi:url withResponse:^(NSDictionary * _Nonnull json, NSInteger errorCode, NSString * _Nonnull message) {

        dispatch_async(dispatch_get_main_queue(), ^{

            NSLog(@"Old Mesh update speed limit api json response = %@", json);

            if([json[@"status"] integerValue] == 200){
                DashboardChildPreference *speedlimitPreference = [delegate.selectedDashboardChild getPreferencesWithName:@"speed_limit"];
                speedlimitPreference.status = _switchView.isOn ? 1 : 0;
                speedlimitPreference.value = _speedTextField.text;
                [delegate.selectedDashboardChild updatePreferenceWitPreference:speedlimitPreference];
                [CommonModel showAlert:[@"Successfully" myModification] msg:[json valueForKey:@"message"]]; 
            }
            else{
                [CommonModel showAlert:[@"Error!" myModification] msg:[json valueForKey:@"message"]];                                       }

            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        });

    }];

     
     //*/
}

@end
