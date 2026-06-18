//
//  PasscodeViewController.m
//  FamilyTime - Dashboard
//
//  Created by Muhammad Ajmal on 25/03/2016.
//  Copyright © 2016 SoraCode. All rights reserved.
//

#import "PasscodeViewController.h"
#import "FTUtils.h"
#import "CommonModel.h"
//#import <Google/Analytics.h>
#import "AppDelegate.h"
#import "UIView+VTSelectiveBorder.h"
#import "Dashboard.h"
#import "NSString+LockMustafa.h"
#import "FamilyTime-Swift.h"

@interface PasscodeViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *setButton;
@property (nonatomic, strong) UITextField *passcodeField;
@end

@implementation PasscodeViewController

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
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)]];
    [self setupUI];
}

- (void)handleTap:(UIGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateEnded)
    {
        [self.passcodeField resignFirstResponder];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.passcodeField becomeFirstResponder];
}

- (void)setupUI
{
    self.imageView = [self setupImageView];
    [self.view addSubview:self.imageView];
    
    self.cancelButton = [self setupCancelButton];
    [self.cancelButton addTarget:self action:@selector(handleCancel:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cancelButton];
    
    self.setButton = [self setupSetButton];
    [self.setButton addTarget:self action:@selector(handleSet:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.setButton];
    
    self.titleLabel = [self setupTitleLabel];
    [self.view addSubview:self.titleLabel];
    
    
    self.passcodeField = [self setupPasscodeField];
    [self.view addSubview:self.passcodeField];
}

- (void)handleCancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)handleSet:(id)sender
{
    if(self.passcodeField.text.length < 4 || self.passcodeField.text.length > 6)
        [CommonModel showAlert:@"" msg:[@"Please enter 4-6 digit Pin." myModification]];
    else
    {
//        AppDelegate *delegate = [AppDelegate appDelegate];
        NSDictionary *dict = @{//@"id":[NSNumber numberWithInteger:delegate.selectedDashboardChild.child_id],
                               @"name":@"phonelock_pin",
                               @"status":[NSNumber numberWithInteger:1],
                               @"value":self.passcodeField.text};
        
        NSLog(@"dict for phonlock = %@", dict);
        
        [CommonModel updatePreference:dict view:self isNotification:NO];
        
//        [CommonModel updatePreference:@{@"id":[NSNumber numberWithInteger:delegate.selectedDashboardChild.child_id],@"name":@"phonelock_pin",@"value":self.passcodeField.text} view:self];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (UIImageView *)setupImageView
{
    UIImageView *imageView;
    if(IS_IPHONE_4)
    {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds) - 72.0f/2.0f, 24.0f, 72.0f, 72.0f)];
    }
    else if(IS_IPHONE_5)
    {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds) - 72.0f/2.0f, 24.0f, 72.0f, 72.0f)];
    }
    else if(IS_IPHONE_6)
    {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds) - 96.0f/2.0f, 29.0f, 96.0f, 96.0f)];
    }
    else if(IS_IPHONE_6_PLUS)
    {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds) - 96.0f/2.0f, 31.0f, 96.0f, 96.0f)];
    }
    else if(IS_IPHONE_X)
    {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds) - 96.0f/2.0f, 31.0f, 96.0f, 96.0f)];
    }
    else
    {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds) - 116.0f/2.0f, 47.0f, 116.0f, 116.0f)];
    }
    imageView.image = [SwiftFTUtils isDeviceiPhoneFamily] ? [UIImage imageNamed:@"popup_passcode"] : [UIImage imageNamed:@"popup_ipad_passcode"];
    return imageView;
}

- (UIButton *)setupCancelButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if(IS_IPHONE_4)
    {
        button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.view.bounds) - 40.0f, CGRectGetWidth(self.view.bounds)/2.0f, 40.0f);
        button.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:13];
    }
    else if(IS_IPHONE_5)
    {
        button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.view.bounds) - 40.0f, CGRectGetWidth(self.view.bounds)/2.0f, 40.0f);
        button.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:13];
    }
    else if(IS_IPHONE_6)
    {
        button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.view.bounds) - 46.0f, CGRectGetWidth(self.view.bounds)/2.0f, 46.0f);
        button.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:14];
    }
    else if(IS_IPHONE_6_PLUS)
    {
        button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.view.bounds) - 52.0f, CGRectGetWidth(self.view.bounds)/2.0f, 52.0f);
        button.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:15];
    }
    else if(IS_IPHONE_X)
    {
        button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.view.bounds) - 52.0f, CGRectGetWidth(self.view.bounds)/2.0f, 52.0f);
        button.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:15];
    }
    else
    {
        button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.view.bounds) - 78.0f, CGRectGetWidth(self.view.bounds)/2.0f, 78.0f);
        button.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:20];
    }
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[CommonModel colorFromHexString:self.color]];
    [button setTitle:[@"CANCEL" myModification] forState:UIControlStateNormal];
    
    button.selectiveBorderFlag = AUISelectiveBordersFlagRight;
    button.selectiveBordersColor = [UIColor whiteColor];
    button.selectiveBordersWidth = 0.5;
    return button;
}

- (UIButton *)setupSetButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if(IS_IPHONE_4)
    {
        button.frame = CGRectMake(CGRectGetMidX(self.view.bounds), CGRectGetMaxY(self.view.bounds) - 40.0f, CGRectGetWidth(self.view.bounds)/2.0f, 40.0f);
        button.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:13];
    }
    else if(IS_IPHONE_5)
    {
        button.frame = CGRectMake(CGRectGetMidX(self.view.bounds), CGRectGetMaxY(self.view.bounds) - 40.0f, CGRectGetWidth(self.view.bounds)/2.0f, 40.0f);
        button.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:13];
    }
    else if(IS_IPHONE_6)
    {
        button.frame = CGRectMake(CGRectGetMidX(self.view.bounds), CGRectGetMaxY(self.view.bounds) - 46.0f, CGRectGetWidth(self.view.bounds)/2.0f, 46.0f);
        button.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:14];
    }
    else if(IS_IPHONE_6_PLUS)
    {
        button.frame = CGRectMake(CGRectGetMidX(self.view.bounds), CGRectGetMaxY(self.view.bounds) - 52.0f, CGRectGetWidth(self.view.bounds)/2.0f, 52.0f);
        button.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:15];
    }
    else if(IS_IPHONE_X)
    {
        button.frame = CGRectMake(CGRectGetMidX(self.view.bounds), CGRectGetMaxY(self.view.bounds) - 52.0f, CGRectGetWidth(self.view.bounds)/2.0f, 52.0f);
        button.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:15];
    }
    else
    {
        button.frame = CGRectMake(CGRectGetMidX(self.view.bounds), CGRectGetMaxY(self.view.bounds) - 78.0f, CGRectGetWidth(self.view.bounds)/2.0f, 78.0f);
        button.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:20];
    }
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[CommonModel colorFromHexString:self.color]];
    [button setTitle:[@"SET" myModification] forState:UIControlStateNormal];
    return button;
}

- (UILabel *)setupTitleLabel
{
    UILabel *label;
    if(IS_IPHONE_4)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, CGRectGetMaxY(self.imageView.frame) + 10, CGRectGetWidth(self.view.bounds) - 30.0f, 20.0f)];
        label.font = [UIFont fontWithName:@"OpenSans" size:15];
    }
    else if(IS_IPHONE_5)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, CGRectGetMaxY(self.imageView.frame) + 10, CGRectGetWidth(self.view.bounds) - 30.0f, 20.0f)];
        label.font = [UIFont fontWithName:@"OpenSans" size:15];
    }
    else if(IS_IPHONE_6)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, CGRectGetMaxY(self.imageView.frame) + 15, CGRectGetWidth(self.view.bounds) - 30.0f, 20.0f)];
        label.font = [UIFont fontWithName:@"OpenSans" size:17];
    }
    else if(IS_IPHONE_6_PLUS)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, CGRectGetMaxY(self.imageView.frame) + 15, CGRectGetWidth(self.view.bounds) - 30.0f, 20.0f)];
        label.font = [UIFont fontWithName:@"OpenSans" size:18];
    }
    else if(IS_IPHONE_X)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, CGRectGetMaxY(self.imageView.frame) + 15, CGRectGetWidth(self.view.bounds) - 30.0f, 20.0f)];
        label.font = [UIFont fontWithName:@"OpenSans" size:18];
    }
    else
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, CGRectGetMaxY(self.imageView.frame) + 15, CGRectGetWidth(self.view.bounds) - 40.0f, 30.0f)];
        label.font = [UIFont fontWithName:@"OpenSans" size:25];
    }
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor lightGrayColor];
    label.text = [@"Set Device Passcode" myModification];
    label.text=[label.text myModification];
    return label;
}

- (UITextField *)setupPasscodeField
{
    UITextField *field;
    if(IS_IPHONE_4)
    {
        field = [[UITextField alloc] initWithFrame:CGRectMake(15.0f, CGRectGetMaxY(self.titleLabel.frame) + 20.0f, CGRectGetWidth(self.view.bounds) - 30, 37)];
        field.font = [UIFont systemFontOfSize:15];
    }
    else if(IS_IPHONE_5)
    {
        field = [[UITextField alloc] initWithFrame:CGRectMake(15.0f, CGRectGetMaxY(self.titleLabel.frame) + 25.0f, CGRectGetWidth(self.view.bounds) - 30, 37)];
        field.font = [UIFont systemFontOfSize:15];
    }
    else if(IS_IPHONE_6)
    {
        field = [[UITextField alloc] initWithFrame:CGRectMake(15.0f, CGRectGetMaxY(self.titleLabel.frame) + 30.0f, CGRectGetWidth(self.view.bounds) - 30, 43)];
        field.font = [UIFont systemFontOfSize:16];
    }
    else if(IS_IPHONE_6_PLUS)
    {
        field = [[UITextField alloc] initWithFrame:CGRectMake(15.0f, CGRectGetMaxY(self.titleLabel.frame) + 35.0f, CGRectGetWidth(self.view.bounds) - 30, 47)];
        field.font = [UIFont systemFontOfSize:17];
    }
    else if(IS_IPHONE_X)
    {
        field = [[UITextField alloc] initWithFrame:CGRectMake(15.0f, CGRectGetMaxY(self.titleLabel.frame) + 35.0f, CGRectGetWidth(self.view.bounds) - 30, 47)];
        field.font = [UIFont systemFontOfSize:17];
    }
    else
    {
        field = [[UITextField alloc] initWithFrame:CGRectMake(20.0f, CGRectGetMaxY(self.titleLabel.frame) + 55.0f, CGRectGetWidth(self.view.bounds) - 40, 68)];
        field.font = [UIFont systemFontOfSize:19];
    }
    field.backgroundColor   = [UIColor clearColor];
    field.textColor         = [UIColor darkGrayColor];
    field.textAlignment     = NSTextAlignmentCenter;
    field.placeholder       = [NSString stringWithFormat:@"%@ ",[@"Device" myModification]];
    field.tintColor         = [UIColor darkGrayColor];
    field.delegate          = self;
    field.keyboardType      = UIKeyboardTypeNumberPad;
    field.layer.borderColor = [UIColor lightGrayColor].CGColor;
    field.layer.borderWidth = 0.5f;
    
    //---SANA CHANGE---//
    [field setSecureTextEntry:YES];
    
    AppDelegate *delegate = [AppDelegate appDelegate];
    DashboardChildPreference *preference = [delegate.selectedDashboardChild getPreferencesWithName:@"phonelock_pin"];
    if (preference != nil)
    {
        field.text = preference.value;
    }
    return field;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
