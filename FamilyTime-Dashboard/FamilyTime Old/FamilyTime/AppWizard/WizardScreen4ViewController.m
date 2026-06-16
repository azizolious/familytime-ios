//
//  WizardScreen4ViewController.m
//  FamilyTime - Dashboard
//
//  Created by Muhammad Ajmal on 09/12/2015.
//  Copyright © 2015 SoraCode. All rights reserved.
//

#import "WizardScreen4ViewController.h"
#import "WizardScreen5ViewController.h"
#import "FTUtils.h"
#import "NIDropDown.h"
//#import "JSONHTTPClient.h"
#import "MBProgressHUD.h"
#import "Constant.h"
#import "CommonModel.h"
#import "DataModel.h"
#import "AppDelegate.h"
#import "UIView+VTSelectiveBorder.h"
//#import <Google/Analytics.h>
#import "NSString+LockMustafa.h"
#import "FamilyTime-Swift.h"

@interface DatePickerContainerView : UIView
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIButton *doneButton;
@end

@implementation DatePickerContainerView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    self.backgroundColor = RGBCOLOR(170, 170, 170, 1);
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0f, 35.0f, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - 35.0f)];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
//self.datePicker setDat
//    self.datePicker.datePickerMode = UIDatePickerModeDate;
    self.datePicker.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.datePicker];
    
    NSDate *currentDate = [NSDate date];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setYear:-3];
    NSDate *eightYearsAgo = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:currentDate options:0];
    [self.datePicker setMaximumDate:eightYearsAgo];
    //set min age to 18 years
    [dateComponents setYear:-18];
    NSDate *eighteenYears = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:currentDate options:0];
    [self.datePicker setMinimumDate:eighteenYears];
    
    self.doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.doneButton.frame = CGRectMake(CGRectGetMaxX(self.bounds) - 80.0f, 0.0f, 80.0f, 35.0f);
    [self.doneButton setTitle:[@"Done" myModification] forState:UIControlStateNormal];
    [self.doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:self.doneButton];
}
@end

@interface WizardScreen4ViewController ()<UITextFieldDelegate, NIDropDownDelegate, UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *logoImageView;
@property (strong, nonatomic) UILabel *firstLabel;
@property (strong, nonatomic) UILabel *secondLabel;
@property (strong, nonatomic) UIButton *dobButton;
@property (strong, nonatomic) UITextField *parentEmailField;
@property (strong, nonatomic) UITableView *genderTableView;
@property (strong, nonatomic) UIButton *genderButton;
@property (strong, nonatomic) UIButton *addDeviceButton;
@property (strong, nonatomic) UIButton *cancelButton;

@property (nonatomic, strong) NIDropDown *dropDown;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSDate *dateOfBorth;
@property (nonatomic, strong) NSString *emailOfParent;

@property (nonatomic, strong) DatePickerContainerView *datePickerCpntainerView;
@end

@implementation WizardScreen4ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:nil];
    
    
//    [FIRAnalytics logEventWithName:@"device_type"
//                        parameters:@{
//                                     @"stage":@"step2"
//                                     }];

    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];    
//    [ZendeskChatManager trackEvent:@"Add Child Screen 2"];

    
    [self setupUI];
    if(self.isChild)
    {
        if(self.gender == nil)
        {
            self.gender = @"Son";
            [self.genderButton setTitle:[@"SON" myModification] forState:UIControlStateNormal];
        }
        
    }
    else
    {
        if(self.gender == nil)
        {
            self.gender = NSLocalizedString(@"Mother",nil);
            [self.genderButton setTitle:[@"MOTHER" myModification] forState:UIControlStateNormal];
        }
    }
    
}

- (void)setupUI
{
    self.view.backgroundColor = RGBCOLOR(255, 139, 15, 1);
    
    self.containerView = [self setupContainerView];
    [self.view addSubview:self.containerView];
    
    self.titleLabel = [self setupTitleLabel];
    [self.containerView addSubview:self.titleLabel];
    
    self.logoImageView = [self setupLogoImage];
    [self.containerView addSubview:self.logoImageView];
    
    self.firstLabel = [self setupFirstLabel];
    [self.containerView addSubview:self.firstLabel];
    
    self.secondLabel = [self setupSecondLabel];
    [self.containerView addSubview:self.secondLabel];
    
    if(self.isChild)
    {
        self.dobButton = [self setupDOBButton];
        [self.containerView addSubview:self.dobButton];
    }
    else
    {
        self.parentEmailField = [self setupParentEmailField];
        [self.containerView addSubview:self.parentEmailField];
    }
    
    self.genderTableView = [self setupGenderTableView];
    [self.containerView addSubview:self.genderTableView];
    
    self.addDeviceButton = [self setupAddDeviceButton];
    [self.containerView addSubview:self.addDeviceButton];
    
    self.cancelButton = [self setupCancelButton];
    [self.containerView addSubview:self.cancelButton];
}

- (UIView *)setupContainerView
{
    UIView *container;
    if(IS_IPHONE_4)
    {
        container = [[UIView alloc] initWithFrame:CGRectMake(16, 0, CGRectGetWidth(self.view.bounds) - 16 * 2.0f, CGRectGetHeight(self.view.bounds))];
    }
    else if(IS_IPHONE_5)
    {
        container = [[UIView alloc] initWithFrame:CGRectMake(16, 0, CGRectGetWidth(self.view.bounds) - 16 * 2.0f, CGRectGetHeight(self.view.bounds))];
    }
    else if(IS_IPHONE_6)
    {
        container = [[UIView alloc] initWithFrame:CGRectMake(18, 0, CGRectGetWidth(self.view.bounds) - 18 * 2.0f, CGRectGetHeight(self.view.bounds))];
    }
    else if(IS_IPHONE_6_PLUS)
    {
        container = [[UIView alloc] initWithFrame:CGRectMake(20, 0, CGRectGetWidth(self.view.bounds) - 20 * 2.0f, CGRectGetHeight(self.view.bounds))];
    }
    else if(IS_IPHONE_X)
        {
        container = [[UIView alloc] initWithFrame:CGRectMake(20, 0, CGRectGetWidth(self.view.bounds) - 20 * 2.0f, CGRectGetHeight(self.view.bounds))];
        }
    else
    {
        container = [[UIView alloc] initWithFrame:CGRectMake(116, 0, CGRectGetWidth(self.view.bounds) - 116*2.0f, CGRectGetHeight(self.view.bounds))];
    }
    container.backgroundColor = [UIColor clearColor];
    return container;
}

- (UILabel *)setupTitleLabel
{
    UILabel *label;
    if(IS_IPHONE_4)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 27, CGRectGetWidth(self.containerView.bounds), 25)];
        label.font = [UIFont fontWithName:@"OpenSans-Semibold" size:20];
    }
    else if(IS_IPHONE_5)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 51, CGRectGetWidth(self.containerView.bounds), 25)];
        label.font = [UIFont fontWithName:@"OpenSans-Semibold" size:20];
    }
    else if(IS_IPHONE_6)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, CGRectGetWidth(self.containerView.bounds), 28)];
        label.font = [UIFont fontWithName:@"OpenSans-Semibold" size:23];
    }
    else if(IS_IPHONE_6_PLUS)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 65, CGRectGetWidth(self.containerView.bounds), 35)];
        label.font = [UIFont fontWithName:@"OpenSans-Semibold" size:25];
    }
    else if(IS_IPHONE_X)
        {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 65, CGRectGetWidth(self.containerView.bounds), 35)];
        label.font = [UIFont fontWithName:@"OpenSans-Semibold" size:25];
        }
    else
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, CGRectGetWidth(self.containerView.bounds), 55)];
        label.font = [UIFont fontWithName:@"OpenSans-Semibold" size:38];
    }
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [@"Add New Device" myModification];
    return label;
}

- (UIImageView *)setupLogoImage
{
    UIImageView *imageView;
    if(IS_IPHONE_4)
    {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.containerView.bounds) - 85/2.0f, CGRectGetMaxY(self.titleLabel.frame) + 15.0f, 85, 107)];
        imageView.image = [UIImage imageNamed:@"ic_device"];
    }
    else if(IS_IPHONE_5)
    {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.containerView.bounds) - 85/2.0f, CGRectGetMaxY(self.titleLabel.frame) + 38.0f, 85, 107)];
        imageView.image = [UIImage imageNamed:@"ic_device"];
    }
    else if(IS_IPHONE_6)
    {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.containerView.bounds) - 113/2.0f, CGRectGetMaxY(self.titleLabel.frame) + 48.0f, 113, 142)];
        imageView.image = [UIImage imageNamed:@"ic_device"];
    }
    else if(IS_IPHONE_6_PLUS)
    {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.containerView.bounds) - 113/2.0f, CGRectGetMaxY(self.titleLabel.frame) + 47.0f, 113, 142)];
        imageView.image = [UIImage imageNamed:@"ic_device"];
    }
    else if(IS_IPHONE_X)
        {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.containerView.bounds) - 113/2.0f, CGRectGetMaxY(self.titleLabel.frame) + 47.0f, 113, 142)];
        imageView.image = [UIImage imageNamed:@"ic_device"];
        }
    else
    {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.containerView.bounds) - 128.0f/2.0f, CGRectGetMaxY(self.titleLabel.frame) + 20.0f, 128, 168)];
        imageView.image = [UIImage imageNamed:@"ic_device_ipad"];
    }
    return imageView;
}

- (UILabel *)setupFirstLabel
{
    UILabel *label;
    if(IS_IPHONE_4)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.logoImageView.frame) + 15.5f, CGRectGetWidth(self.containerView.bounds), 40.0f)];
        label.font = [UIFont fontWithName:@"OpenSans-Light" size:14];
    }
    else if(IS_IPHONE_5)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.logoImageView.frame) + 18.5f, CGRectGetWidth(self.containerView.bounds), 40.0f)];
        label.font = [UIFont fontWithName:@"OpenSans-Light" size:14];
    }
    else if(IS_IPHONE_6)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.logoImageView.frame) + 18.5f, CGRectGetWidth(self.containerView.bounds), 50.0f)];
        label.font = [UIFont fontWithName:@"OpenSans-Light" size:16];
    }
    else if(IS_IPHONE_6_PLUS)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.logoImageView.frame) + 41.5f, CGRectGetWidth(self.containerView.bounds), 60.0f)];
        label.font = [UIFont fontWithName:@"OpenSans-Light" size:17];
    }
    else if(IS_IPHONE_X)
        {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.logoImageView.frame) + 41.5f, CGRectGetWidth(self.containerView.bounds), 60.0f)];
        label.font = [UIFont fontWithName:@"OpenSans-Light" size:17];
        }
    else
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.logoImageView.frame) + 46.0f, CGRectGetWidth(self.containerView.bounds), 75)];
        label.font = [UIFont fontWithName:@"OpenSans-Light" size:23];
    }
    label.backgroundColor = [UIColor clearColor];
    label.textColor = RGBCOLOR(255, 232, 211, 1);
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    if(self.isChild)
        label.text = [@"Please enter the date of birth of your child and specify their gender." myModification];
    else
        label.text = [@"Please enter the email address of co-parent and specify their gender" myModification];
    return label;
}

- (UILabel *)setupSecondLabel
{
    UILabel *label;
    if(IS_IPHONE_4)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.firstLabel.frame) + 10.0f, CGRectGetWidth(self.containerView.frame), 25.0f)];
        label.font = [UIFont fontWithName:@"OpenSans-Light" size:14];
    }
    else if(IS_IPHONE_5)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.firstLabel.frame) + 10.0f, CGRectGetWidth(self.containerView.frame), 25.0f)];
        label.font = [UIFont fontWithName:@"OpenSans-Light" size:14];
    }
    else if(IS_IPHONE_6)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.firstLabel.frame) + 10.0f, CGRectGetWidth(self.containerView.frame), 25.0f)];
        label.font = [UIFont fontWithName:@"OpenSans-Light" size:16];
    }
    else if(IS_IPHONE_6_PLUS)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.firstLabel.frame) + 10.0f, CGRectGetWidth(self.containerView.frame), 30.0f)];
        label.font = [UIFont fontWithName:@"OpenSans-Light" size:17];
    }
    else if(IS_IPHONE_X)
        {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.firstLabel.frame) + 10.0f, CGRectGetWidth(self.containerView.frame), 30.0f)];
        label.font = [UIFont fontWithName:@"OpenSans-Light" size:17];
        }
    else
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.firstLabel.frame) + 51.0f, CGRectGetWidth(self.containerView.frame), 50)];
        label.font = [UIFont fontWithName:@"OpenSans-Light" size:23];
    }
    label.backgroundColor = [UIColor clearColor];
    label.textColor = RGBCOLOR(255, 232, 211, 1);
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.text = [@"Choose the option from the drop down." myModification];
    return label;
}

- (UIButton *)setupDOBButton
{
    UIButton *field = [UIButton buttonWithType:UIButtonTypeCustom];
    [field setBackgroundColor:RGBCOLOR(253, 151, 42, 1)];
    [field setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [field setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    field.layer.borderColor = RGBCOLOR(255, 182, 103, 1).CGColor;
    field.layer.borderWidth = [SwiftFTUtils isDeviceiPhoneFamily] ? 1 : 2;
    [field setTitle:[@"DOB" myModification] forState:UIControlStateNormal];
    [field setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [field setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 0.0f)];
    [field addTarget:self action:@selector(handleDOB:) forControlEvents:UIControlEventTouchUpInside];
    field.tag = 101;
    if(IS_IPHONE_4)
    {
        field.frame = CGRectMake(0.0f, CGRectGetMaxY(self.secondLabel.frame) + 20.0f, CGRectGetWidth(self.containerView.frame), 37);
        field.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    else if(IS_IPHONE_5)
    {
        field.frame = CGRectMake(0.0f, CGRectGetMaxY(self.secondLabel.frame) + 25.0f, CGRectGetWidth(self.containerView.frame), 37);
        field.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    else if(IS_IPHONE_6)
    {
        field.frame = CGRectMake(0.0f, CGRectGetMaxY(self.secondLabel.frame) + 30.0f, CGRectGetWidth(self.containerView.frame), 43);
        field.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    else if(IS_IPHONE_6_PLUS)
    {
        field.frame = CGRectMake(0.0f, CGRectGetMaxY(self.secondLabel.frame) + 35.0f, CGRectGetWidth(self.containerView.frame), 47);
        field.titleLabel.font = [UIFont systemFontOfSize:17];
    }
    else if(IS_IPHONE_X)
        {
        field.frame = CGRectMake(0.0f, CGRectGetMaxY(self.secondLabel.frame) + 35.0f, CGRectGetWidth(self.containerView.frame), 47);
        field.titleLabel.font = [UIFont systemFontOfSize:17];
        }
    else
    {
        field.frame = CGRectMake(0.0f, CGRectGetMaxY(self.secondLabel.frame) + 70.0f, CGRectGetWidth(self.containerView.frame), 68);
        field.titleLabel.font = [UIFont systemFontOfSize:19];
    }
    
//    field.imageEdgeInsets = UIEdgeInsetsMake(0, CGRectGetWidth(field.frame) - 40, 0, 0);
//    [field setImage:[SwiftFTUtils imageWithTint:[UIColor whiteColor] image:[UIImage imageNamed:@"ic_calendar"]] forState:UIControlStateNormal];

    
   // [field setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    return field;
}

- (UITextField *)setupParentEmailField
{
    UITextField *field;
    if(IS_IPHONE_4)
    {
        field = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.secondLabel.frame) + 20.0f, CGRectGetWidth(self.containerView.frame), 37)];
        field.font = [UIFont systemFontOfSize:15];
    }
    else if(IS_IPHONE_5)
    {
        field = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.secondLabel.frame) + 25.0f, CGRectGetWidth(self.containerView.frame), 37)];
        field.font = [UIFont systemFontOfSize:15];
    }
    else if(IS_IPHONE_6)
    {
        field = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.secondLabel.frame) + 30.0f, CGRectGetWidth(self.containerView.frame), 43)];
        field.font = [UIFont systemFontOfSize:16];
    }
    else if(IS_IPHONE_6_PLUS)
    {
        field = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.secondLabel.frame) + 35.0f, CGRectGetWidth(self.containerView.frame), 47)];
        field.font = [UIFont systemFontOfSize:17];
    }
    else if(IS_IPHONE_X)
        {
        field = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.secondLabel.frame) + 35.0f, CGRectGetWidth(self.containerView.frame), 47)];
        field.font = [UIFont systemFontOfSize:17];
        }
    else
    {
        field = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.secondLabel.frame) + 70.0f, CGRectGetWidth(self.containerView.frame), 68)];
        field.font = [UIFont systemFontOfSize:19];
    }
    field.backgroundColor = RGBCOLOR(253, 151, 42, 1);
    field.textColor = [UIColor whiteColor];
    field.textAlignment = NSTextAlignmentLeft;
    field.placeholder = [@"Parent Email" myModification];
    field.tintColor = [UIColor whiteColor];
    field.delegate = self;
    field.autocorrectionType = UITextAutocorrectionTypeNo;
    field.spellCheckingType = UITextSpellCheckingTypeNo;
    
    field.layer.borderColor = RGBCOLOR(255, 182, 103, 1).CGColor;
    field.layer.borderWidth = [SwiftFTUtils isDeviceiPhoneFamily] ? 1 : 2;
    
    UIView *tempMarginView1 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 15.0f, 10.0f)];
    tempMarginView1.backgroundColor = [UIColor clearColor];
    field.leftView = tempMarginView1;
    field.leftViewMode = UITextFieldViewModeAlways;
    
    return field;
}

- (UITableView *)setupGenderTableView
{
    UITableView *tableview;
    if(IS_IPHONE_4)
    {
        tableview = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.isChild ? self.dobButton.frame : self.parentEmailField.frame) + 10.0f, CGRectGetWidth(self.containerView.frame), 37 * 2) style:UITableViewStylePlain];
        tableview.rowHeight = 37.0f;
    }
    else if(IS_IPHONE_5)
    {
        tableview = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.isChild ? self.dobButton.frame : self.parentEmailField.frame) + 10.0f, CGRectGetWidth(self.containerView.frame), 37 * 2) style:UITableViewStylePlain];
        tableview.rowHeight = 37.0f;
    }
    else if(IS_IPHONE_6)
    {
        tableview = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.isChild ? self.dobButton.frame : self.parentEmailField.frame) + 12.0f, CGRectGetWidth(self.containerView.frame), 43 * 2) style:UITableViewStylePlain];
        tableview.rowHeight = 43.0f;
    }
    else if(IS_IPHONE_6_PLUS)
    {
        tableview = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.isChild ? self.dobButton.frame : self.parentEmailField.frame) + 12.0f, CGRectGetWidth(self.containerView.frame), 47 * 2) style:UITableViewStylePlain];
        tableview.rowHeight = 47.0f;
    }
    else if(IS_IPHONE_X)
        {
        tableview = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.isChild ? self.dobButton.frame : self.parentEmailField.frame) + 12.0f, CGRectGetWidth(self.containerView.frame), 47 * 2) style:UITableViewStylePlain];
        tableview.rowHeight = 47.0f;
        }
    else
    {
        tableview = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.isChild ? self.dobButton.frame : self.parentEmailField.frame) + 12.0f, CGRectGetWidth(self.containerView.frame), 68 * 2) style:UITableViewStylePlain];
        tableview.rowHeight = 68.0f;
    }
    
    tableview.backgroundColor = RGBCOLOR(253, 151, 42, 1);
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.layer.borderColor = RGBCOLOR(255, 182, 103, 1).CGColor;
    tableview.layer.borderWidth = [SwiftFTUtils isDeviceiPhoneFamily] ? 1 : 2;
    tableview.separatorColor = RGBCOLOR(255, 182, 103, 1);
    tableview.scrollEnabled = NO;
    return tableview;
}

- (UIButton *)setupGenderButton
{
    UIButton *field = [UIButton buttonWithType:UIButtonTypeCustom];
    [field setBackgroundColor:RGBCOLOR(253, 151, 42, 1)];
    [field setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [field setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    field.layer.borderColor = RGBCOLOR(255, 182, 103, 1).CGColor;
    field.layer.borderWidth = [SwiftFTUtils isDeviceiPhoneFamily] ? 1 : 2;
    [field setTitle:[@"SON" myModification] forState:UIControlStateNormal];
    [field setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [field addTarget:self action:@selector(handleGenderDropDown:) forControlEvents:UIControlEventTouchUpInside];
    field.tag = 102;
    if(IS_IPHONE_4)
    {
        field.frame = CGRectMake(0.0f, CGRectGetMaxY(self.isChild ? self.dobButton.frame : self.parentEmailField.frame) + 10.0f, CGRectGetWidth(self.containerView.frame), 37);
        field.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    else if(IS_IPHONE_5)
    {
        field.frame = CGRectMake(0.0f, CGRectGetMaxY(self.isChild ? self.dobButton.frame : self.parentEmailField.frame) + 10.0f, CGRectGetWidth(self.containerView.frame), 37);
        field.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    else if(IS_IPHONE_6)
    {
        field.frame = CGRectMake(0.0f, CGRectGetMaxY(self.isChild ? self.dobButton.frame : self.parentEmailField.frame) + 12.0f, CGRectGetWidth(self.containerView.frame), 43);
        field.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    else if(IS_IPHONE_6_PLUS)
    {
        field.frame = CGRectMake(0.0f, CGRectGetMaxY(self.isChild ? self.dobButton.frame : self.parentEmailField.frame) + 12.0f, CGRectGetWidth(self.containerView.frame), 47);
        field.titleLabel.font = [UIFont systemFontOfSize:17];
    }
    else if(IS_IPHONE_X)
        {
        field.frame = CGRectMake(0.0f, CGRectGetMaxY(self.isChild ? self.dobButton.frame : self.parentEmailField.frame) + 12.0f, CGRectGetWidth(self.containerView.frame), 47);
        field.titleLabel.font = [UIFont systemFontOfSize:17];
        }
    else
    {
        field.frame = CGRectMake(0.0f, CGRectGetMaxY(self.isChild ? self.dobButton.frame : self.parentEmailField.frame) + 12.0f, CGRectGetWidth(self.containerView.frame), 68);
        field.titleLabel.font = [UIFont systemFontOfSize:19];
    }
    field.imageEdgeInsets = UIEdgeInsetsMake(0, CGRectGetWidth(field.frame) - 40, 0, 0);
    [field setImage:[SwiftFTUtils imageWithTint:[UIColor whiteColor] image:[UIImage imageNamed:@"down_arrow"]] forState:UIControlStateNormal];
  
//    UILabel * leftView = [[UILabel alloc] initWithFrame:CGRectMake(10,0,7,26)];
//    leftView.backgroundColor = [UIColor clearColor];
//    [field setTitleEdgeInsets:UIEdgeInsetsMake(0, 30, 0, 0)];

    //field.titleLabel setTitl

    
    return field;
}

- (UIButton *)setupAddDeviceButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:[@"ADD DEVICE" myModification] forState:UIControlStateNormal];
    button.backgroundColor = RGBCOLOR(202, 107, 5, 1);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(handleAddDevice:) forControlEvents:UIControlEventTouchUpInside];
    if(IS_IPHONE_4)
    {
        button.frame = CGRectMake(CGRectGetMidX(self.containerView.bounds), CGRectGetMaxY(self.genderTableView.frame) + 12.0f, CGRectGetWidth(self.containerView.frame)/2.0f, 37);
        button.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    else if(IS_IPHONE_5)
    {
        button.frame = CGRectMake(CGRectGetMidX(self.containerView.bounds), CGRectGetMaxY(self.genderTableView.frame) + 30.0f, CGRectGetWidth(self.containerView.frame)/2.0f, 37);
        button.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    else if(IS_IPHONE_6)
    {
        button.frame = CGRectMake(CGRectGetMidX(self.containerView.bounds), CGRectGetMaxY(self.genderTableView.frame) + 35.0f, CGRectGetWidth(self.containerView.frame)/2.0f, 43);
        button.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    else if(IS_IPHONE_6_PLUS)
    {
        button.frame = CGRectMake(CGRectGetMidX(self.containerView.bounds), CGRectGetMaxY(self.genderTableView.frame) + 35.0f, CGRectGetWidth(self.containerView.frame)/2.0f, 47);
        button.titleLabel.font = [UIFont systemFontOfSize:17];
    }
    else if(IS_IPHONE_X)
        {
        button.frame = CGRectMake(CGRectGetMidX(self.containerView.bounds), CGRectGetMaxY(self.genderTableView.frame) + 35.0f, CGRectGetWidth(self.containerView.frame)/2.0f, 47);
        button.titleLabel.font = [UIFont systemFontOfSize:17];
        }
    else
    {
        button.frame = CGRectMake(CGRectGetMidX(self.containerView.bounds), CGRectGetMaxY(self.genderTableView.frame) + 20.0f, CGRectGetWidth(self.containerView.frame)/2.0f, 68);
        button.titleLabel.font = [UIFont systemFontOfSize:19];
    }
    button.selectiveBorderFlag = AUISelectiveBordersFlagRight|AUISelectiveBordersFlagTop|AUISelectiveBordersFlagBottom;
    button.selectiveBordersColor = RGBCOLOR(255, 182, 103, 1);
    button.selectiveBordersWidth = 1.0;
    return button;
}

- (UIButton *)setupCancelButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:[@"BACK" myModification] forState:UIControlStateNormal];
    button.backgroundColor = RGBCOLOR(202, 107, 5, 1);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(handleBack:) forControlEvents:UIControlEventTouchUpInside];
    if(IS_IPHONE_4)
    {
        button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.genderTableView.frame) + 12.0f, CGRectGetWidth(self.containerView.frame)/2.0f, 37);
        button.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    else if(IS_IPHONE_5)
    {
        button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.genderTableView.frame) + 30.0f, CGRectGetWidth(self.containerView.frame)/2.0f, 37);
        button.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    else if(IS_IPHONE_6)
    {
        button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.genderTableView.frame) + 35.0f, CGRectGetWidth(self.containerView.frame)/2.0f, 43);
        button.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    else if(IS_IPHONE_6_PLUS)
    {
        button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.genderTableView.frame) + 35.0f, CGRectGetWidth(self.containerView.frame)/2.0f, 47);
        button.titleLabel.font = [UIFont systemFontOfSize:17];
    }
    else if(IS_IPHONE_X)
        {
        button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.genderTableView.frame) + 35.0f, CGRectGetWidth(self.containerView.frame)/2.0f, 47);
        button.titleLabel.font = [UIFont systemFontOfSize:17];
        }
    else
    {
        button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.genderTableView.frame) + 20.0f, CGRectGetWidth(self.containerView.frame)/2.0f, 68);
        button.titleLabel.font = [UIFont systemFontOfSize:19];
    }
    button.selectiveBorderFlag = AUISelectiveBordersFlagRight|AUISelectiveBordersFlagLeft|AUISelectiveBordersFlagTop|AUISelectiveBordersFlagBottom;
    button.selectiveBordersColor = RGBCOLOR(255, 182, 103, 1);
    button.selectiveBordersWidth = 1.0;
    return button;
}

- (void)handleDOB:(id)sender
{
    if(self.datePickerCpntainerView == nil)
    {
        self.datePickerCpntainerView = [[DatePickerContainerView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.view.bounds), CGRectGetWidth(self.view.bounds), 200.0f)];
        [self.datePickerCpntainerView.doneButton addTarget:self action:@selector(handleDone:) forControlEvents:UIControlEventTouchUpInside];
        [self.datePickerCpntainerView.datePicker addTarget:self action:@selector(handleDatePickerChanged:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:self.datePickerCpntainerView];
        
        [UIView animateWithDuration:0.5f animations:^{
            self.datePickerCpntainerView.frame = CGRectMake(0.0f, CGRectGetMaxY(self.view.bounds) - 200, CGRectGetWidth(self.view.bounds), 200.0f);
        }];
        
    }
    
}

- (void)handleDatePickerChanged:(UIDatePicker *)datePicker
{
    self.dateOfBorth = self.datePickerCpntainerView.datePicker.date;
//    [self.datePickerCpntainerView removeFromSuperview];
//    self.datePickerCpntainerView = nil;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"yyyy-MM-dd"];
    NSString *stringFromDate = [formatter stringFromDate:self.dateOfBorth];
    NSLog(@"Here we have=%@",stringFromDate);
}

- (void)handleDone:(id)sender
{
    [UIView animateWithDuration:0.5f animations:^{
        self.datePickerCpntainerView.frame = CGRectMake(0.0f, CGRectGetMaxY(self.view.bounds), CGRectGetWidth(self.view.bounds), 200.0f);
    } completion:^(BOOL finished)
    {
        self.dateOfBorth = self.datePickerCpntainerView.datePicker.date;
        [self.datePickerCpntainerView removeFromSuperview];
        self.datePickerCpntainerView = nil;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat: @"yyyy-MM-dd"];
        NSString *stringFromDate = [formatter stringFromDate:self.dateOfBorth];
        
        [self.dobButton setTitle:stringFromDate forState:UIControlStateNormal];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
        
}

- (IBAction)handleAddDevice:(id)sender
{
    [self.parentEmailField resignFirstResponder];
    
    NSDictionary *params;
    NSString *urlStr ;//= KChildRegUrl;
    NSString *type = self.isChild ? @"Child" : @"Parent";
    AppDelegate *delegate = [AppDelegate appDelegate];
    if([self validateData])
    {
        if([type isEqualToString:@"Child"])
        {
             NSString *dob = [self.dateOfBorth description];//[[self.dobBtn.titleLabel text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSString *genderp = @"male";
            if([self.gender isEqualToString:NSLocalizedString(@"Mother",nil)] || [self.gender isEqualToString:@"Daughter"])
                genderp = @"female";
            
            int r = (arc4random() % 4) + 1;
            NSString *randColor = [CommonModel randomColor:r];
            NSLog(@"haha=%@",self.timezone);
            if(self.timezone == [NSNull null])
            {
                NSTimeZone *timeZone = [NSTimeZone localTimeZone];
                NSString *tzName = [timeZone name];

                params = @{@"name":self.name,
                           @"id":delegate.parent.user_id,
                           @"birthday":dob,
                           @"gender":genderp,
                           @"relationship":self.gender,
                           @"package": @"Standard",
                           @"duration":@"1",
                           @"color":randColor,
                           @"time_zone": tzName
                           };
            }
            else if(self.timezone!=nil)
            {
                
            params = @{@"name":self.name,
                       @"id":delegate.parent.user_id,
                       @"birthday":dob,
                       @"gender":genderp,
                       @"relationship":self.gender,
                       @"package": @"Standard",
                       @"duration":@"1",
                       @"color":randColor,
                       @"time_zone": self.timezone
                       };
            }
            else
            {
                NSTimeZone *timeZone = [NSTimeZone localTimeZone];
                NSString *tzName = [timeZone name];

                params = @{@"name":self.name,
                           @"id":delegate.parent.user_id,
                           @"birthday":dob,
                           @"gender":genderp,
                           @"relationship":self.gender,
                           @"package": @"Standard",
                           @"duration":@"1",
                           @"color":randColor,
                           @"time_zone": tzName
                           };
            }
            //---DEPRICATED---//
            urlStr = @""; //KChildRegUrl;
        }
        
        else
        {
            NSString *email = [[self.parentEmailField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSString *genderp = @"male";
            if([self.gender isEqualToString:NSLocalizedString(@"Mother",nil)] || [self.gender isEqualToString:@"Daughter"])
                genderp = @"female";
            int r = (arc4random() % 4) + 1;
            NSString *randColor = [CommonModel randomColor:r];
            
            params  = @{ @"name":self.name,
                         @"id": delegate.parent.user_id,
                         @"email":email,
                         @"color":randColor,
                         @"gender":genderp,
                         @"relationship":self.gender
                         };
            
            //---SANA CHANGE---//---ONLY CHILD CAN BE ADDED FROM APP---//
            urlStr = @""; //KUserAddUrl;
        }
        
        [SwiftFTUtils showHUDAddedTo:self.view withText:@"Adding Profile..." animated:YES];
//        [JSONHTTPClient postJSONFromURLWithString:urlStr
//                                           params:params
//                                       completion:^(id json, JSONModelError *err)
//        {
//            NSLog(@"great===%@",json);
//                                           NSString *msg = [json valueForKey:@"message"] == nil ? [kErrorGeneral myModification] : [json valueForKey:@"message"];
//                                           if([[json valueForKey:@"response"] intValue] == 200)
//                                           {
//                                               if(self.fromDashboard)
//                                               {
//                                                   [self dismissViewControllerAnimated:YES completion:^{
//                                                       [[NSNotificationCenter defaultCenter] postNotificationName:@"RELOAD_DASHBOARD" object:nil];
//                                                   }];
//
//                                               }
//                                               else
//                                               {
//                                                   WizardScreen5ViewController *controller = [[WizardScreen5ViewController alloc] init];
//                                                   [self.navigationController pushViewController:controller animated:YES];
//                                               }
//                                           }
//                                           else
//                                               [CommonModel showAlert:[@"Error!" myModification] msg:msg];
//                                           [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                                           
//                                       }];
    }
    
    
}

- (BOOL)validateData
{
    if(self.isChild)
    {
        if(self.dateOfBorth == nil)
        {
             [CommonModel showAlert:@"" msg:[@"Choose date of birth" myModification]];
            return NO;
        }
        return YES;
    }
    else
    {
        NSString *email = [[self.parentEmailField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if(email.length <= 0)
            {
                [CommonModel showAlert:@"" msg:[@"Email required" myModification]];
                return NO;
            }
        else if(![self isValidEmail:email])
        {
            [CommonModel showAlert:@"" msg:[@"Email is not valid" myModification]];
            return NO;
        }
        return YES;
    }
}

- (BOOL)isValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}


- (void)handleGenderDropDown:(UIButton *)sender
{
    if(sender.tag == 101)
    {
        
    }
    else if(sender.tag == 102)
    {
        NSArray * array;
        if(self.isChild)
            array = @[@"Son", @"Daughter"];
        else
            array = @[@"Mother", @"Father"];
        if(self.dropDown == nil)
        {
            CGFloat height;
            self.dropDown = [[NIDropDown alloc] showDropDown:sender height:&height array:array tableHeight:100 direction:@"down"];
            self.dropDown.delegate = self;
        }
        else
        {
            [self.dropDown hideDropDown:sender];
            self.dropDown = nil;
        }
    }
}

- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    NSLog(@"%@",sender.selectedUser);
    if(self.isChild)
    {
        if([sender.selectedUser isEqualToString:@"Son"])
        {
            [self.genderButton setTitle:[@"SON" myModification] forState:UIControlStateNormal];
        }
        else
        {
            [self.genderButton setTitle:[@"DAUGHTER" myModification] forState:UIControlStateNormal];
        }
    }
    else
    {
        if([sender.selectedUser isEqualToString:@"Mother"])
        {
            [self.genderButton setTitle:[@"MOTHER" myModification] forState:UIControlStateNormal];
        }
        else
        {
            [self.genderButton setTitle:[@"FATHER" myModification] forState:UIControlStateNormal];
        }
    }
    self.gender = sender.selectedUser;
    self.dropDown = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FILTER_CELL"];
    if(cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FILTER_CELL"];
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    if(indexPath.row == 0)
    {
        if(self.isChild)
        {
            cell.textLabel.text = [@"SON" myModification];
            if([self.gender isEqualToString:@"Son"])
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            else
                cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else
        {
            cell.textLabel.text = [@"MOTHER" myModification];
            if([self.gender isEqualToString:@"Mother"])
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            else
                cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    else
    {
        if(self.isChild)
        {
            cell.textLabel.text = [@"DAUGHTER" myModification];
            if([self.gender isEqualToString:@"Daughter"])
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            else
                cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else
        {
            cell.textLabel.text = [@"FATHER" myModification];
            if([self.gender isEqualToString:@"Father"])
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            else
                cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    if(IS_IPHONE_4)
    {
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    else if(IS_IPHONE_5)
    {
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    else if(IS_IPHONE_6)
    {
        cell.textLabel.font = [UIFont systemFontOfSize:16];
    }
    else if(IS_IPHONE_6_PLUS)
    {
        cell.textLabel.font = [UIFont systemFontOfSize:17];
    }
    else if(IS_IPHONE_X)
        {
        cell.textLabel.font = [UIFont systemFontOfSize:17];
        }
    else
    {
        cell.textLabel.font = [UIFont systemFontOfSize:19];
    }
    cell.tintColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [tableView  deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.row == 0)
    {
        if(self.isChild)
            self.gender = @"Son";
        else
            self.gender = @"Mother";
    }
    else
    {
        if(self.isChild)
            self.gender = @"Daughter";
        else
            self.gender = @"Father";
    }
    
    [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}



@end
