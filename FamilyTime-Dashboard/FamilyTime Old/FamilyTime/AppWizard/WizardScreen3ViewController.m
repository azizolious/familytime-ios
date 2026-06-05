////
////  WizardScreen3ViewController.m
////  FamilyTime - Dashboard
////
////  Created by Muhammad Ajmal on 09/12/2015.
////  Copyright © 2015 SoraCode. All rights reserved.
////
//
//#import "WizardScreen3ViewController.h"
//#import "WizardScreen4ViewController.h"
//#import "FTUtils.h"
//#import "NIDropDown.h"
//#import "CommonModel.h"
//#import "UIView+VTSelectiveBorder.h"
////#import <Google/Analytics.h>
//#import "TimeZonesViewController.h"
//#import "MSCellAccessory.h"
//#import "GMTTimezone.h"
//#import "AppDelegate.h"
//#import "NSString+LockMustafa.h"
//
//
//#define RGBCOLOR(R,G,B, A) [UIColor colorWithRed:R/255.2f green:G/255.2f blue:B/255.2f alpha:A]
//
//@interface WizardScreen3ViewController ()<UITextFieldDelegate, NIDropDownDelegate, UITableViewDataSource, UITableViewDelegate, TimeZonesViewControllerDelegate>
//
//@property (strong, nonatomic) UIView *containerView;
//@property (strong, nonatomic) UILabel *titleLabel;
//@property (strong, nonatomic) UIImageView *logoImageView;
//@property (strong, nonatomic) UILabel *firstLabel;
//@property (strong, nonatomic) UILabel *secondLabel;
//@property (strong, nonatomic) UITextField *nameField;
//@property (strong, nonatomic) UITableView *relationTableView;
//@property (strong, nonatomic) UIButton *childField;
//@property (strong, nonatomic) UIButton *addDeviceButton;
//@property (strong, nonatomic) UIButton *cancelButton;
//
//@property (nonatomic, strong) NIDropDown *dropDown;
//
//@property (nonatomic, strong) NSString *relationship;
//@property (nonatomic, assign) NSInteger selectedTimeZoneIndex;
//@property (nonatomic, strong) NSString *selectedTimeZone;
//@property (nonatomic, strong) NSArray *timezones;
//@property (nonatomic, strong) NSMutableArray *gmtTimezones;
//@end
//
//@implementation WizardScreen3ViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    [self.navigationController setNavigationBarHidden:YES];
//    [self setupUI];
//
////    [FIRAnalytics logEventWithName:@"device_type"
////                        parameters:@{
////                                     @"stage":@"step1"
////                                     }];
//
////stage    step1
//
//
////    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow)
////                                                 name:UIKeyboardWillShowNotification
////                                               object:nil];
////
////    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide)
////                                                 name:UIKeyboardWillHideNotification
////                                               object:nil];
//}
//
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//
//    [ZendeskChatManager trackEvent:@"Add Child"];
//
//
//
//
//}
//
//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    if(self.timezones == nil)
//    {
//        self.timezones = [NSTimeZone knownTimeZoneNames];
//        self.gmtTimezones = [NSMutableArray array];
//        for (NSString *timezone in self.timezones)
//        {
//            [self.gmtTimezones addObject:[self gettimeZoneWithName:timezone]];
//        }
//
//        NSSortDescriptor *sortDescriptor;
//        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"gmtDiff"
//                                                     ascending:YES];
//        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
//        self.gmtTimezones = [NSMutableArray arrayWithArray:[self.gmtTimezones sortedArrayUsingDescriptors:sortDescriptors]];
//
//        self.selectedTimeZoneIndex = [self getIndexOfSelectedTimeZone];
//        [self.relationTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
//    }
//}
//
//- (NSInteger)getIndexOfSelectedTimeZone {
//    NSInteger i = -1;
//    for (NSInteger index = 0; index < self.gmtTimezones.count; index++)
//    {
//        GMTTimezone *tz = (GMTTimezone *)[self.gmtTimezones objectAtIndex:index];
//        if ([tz.name isEqualToString:self.selectedTimeZone])
//        {
//            i = index;
//            break;
//        }
//    }
//    return i;
//}
//
//-(GMTTimezone *)gettimeZoneWithName:(NSString*)name {
//
//    GMTTimezone *tz = [[GMTTimezone alloc] init];
//
//    NSTimeZone *atimezone=[NSTimeZone timeZoneWithName:name];
//    NSInteger minutes = (atimezone.secondsFromGMT / 60) % 60;
//    NSInteger hours = atimezone.secondsFromGMT / 3600;
//    NSString *aStrOffset;
//    if(hours > 0)
//        aStrOffset =[NSString stringWithFormat:@"+%02ld:%02ld",(long)hours, (long)minutes];
//    else
//        aStrOffset =[NSString stringWithFormat:@"%02ld:%02ld",(long)hours, (long)minutes];
//    tz.strRep = [NSString stringWithFormat:@"(GMT %@) %@",aStrOffset, name];
//    tz.gmtDiff = atimezone.secondsFromGMT;
//    tz.name = name;
//    return tz;
//}
//
//- (void)setupUI
//{
//    self.view.backgroundColor = RGBCOLOR(162, 201, 34, 1);
////    self.view.backgroundColor = [UIColor whiteColor];
//
//    self.relationship = @"Child";
//    NSTimeZone *timeZoneLocal = [NSTimeZone localTimeZone];
//    self.selectedTimeZone = [timeZoneLocal name];
//
//    self.containerView = [self setupContainerView];
//    [self.view addSubview:self.containerView];
//
//    self.titleLabel = [self setupTitleLabel];
//    [self.containerView addSubview:self.titleLabel];
//
//    self.logoImageView = [self setupLogoImage];
//    [self.containerView addSubview:self.logoImageView];
//
//    self.firstLabel = [self setupFirstLabel];
//    [self.containerView addSubview:self.firstLabel];
//
//    self.secondLabel = [self setupSecondLabel];
//    [self.containerView addSubview:self.secondLabel];
//
//    self.nameField = [self setupNameField];
//    [self.containerView addSubview:self.nameField];
//
//    self.relationTableView = [self setupRelationTableView:YES];
//    [self.containerView addSubview:self.relationTableView];
//
//    self.addDeviceButton = [self setupAddDeviceButton];
//    [self.containerView addSubview:self.addDeviceButton];
//
//    self.cancelButton = [self setupCancelButton];
//    [self.containerView addSubview:self.cancelButton];
//}
//
//- (UIView *)setupContainerView
//{
//    UIView *container;
//    if(IS_IPHONE_4)
//    {
//        container = [[UIView alloc] initWithFrame:CGRectMake(16, 0, CGRectGetWidth(self.view.bounds) - 16 * 2.0f, CGRectGetHeight(self.view.bounds))];
//    }
//    else if(IS_IPHONE_5)
//    {
//        container = [[UIView alloc] initWithFrame:CGRectMake(16, 0, CGRectGetWidth(self.view.bounds) - 16 * 2.0f, CGRectGetHeight(self.view.bounds))];
//    }
//    else if(IS_IPHONE_6)
//    {
//        container = [[UIView alloc] initWithFrame:CGRectMake(18, 0, CGRectGetWidth(self.view.bounds) - 18 * 2.0f, CGRectGetHeight(self.view.bounds))];
//    }
//    else if(IS_IPHONE_6_PLUS)
//    {
//        container = [[UIView alloc] initWithFrame:CGRectMake(20, 0, CGRectGetWidth(self.view.bounds) - 20 * 2.0f, CGRectGetHeight(self.view.bounds))];
//    }
//    else if(IS_IPHONE_X)
//        {
//        container = [[UIView alloc] initWithFrame:CGRectMake(20, 0, CGRectGetWidth(self.view.bounds) - 20 * 2.0f, CGRectGetHeight(self.view.bounds))];
//        }
//    else
//    {
//        container = [[UIView alloc] initWithFrame:CGRectMake(116, 0, CGRectGetWidth(self.view.bounds) - 116*2.0f, CGRectGetHeight(self.view.bounds))];
//    }
//    container.backgroundColor = [UIColor clearColor];
//    return container;
//}
//
//- (UILabel *)setupTitleLabel
//{
//    UILabel *label;
//    if(IS_IPHONE_4)
//    {
//        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 13.5, CGRectGetWidth(self.containerView.bounds), 25)];
//        label.font = [UIFont fontWithName:@"OpenSans-Semibold" size:20];
//    }
//    else if(IS_IPHONE_5)
//    {
//        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 25.5, CGRectGetWidth(self.containerView.bounds), 25)];
//        label.font = [UIFont fontWithName:@"OpenSans-Semibold" size:20];
//    }
//    else if(IS_IPHONE_6)
//    {
//        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, CGRectGetWidth(self.containerView.bounds), 28)];
//        label.font = [UIFont fontWithName:@"OpenSans-Semibold" size:23];
//    }
//    else if(IS_IPHONE_6_PLUS)
//    {
//        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 32.5, CGRectGetWidth(self.containerView.bounds), 35)];
//        label.font = [UIFont fontWithName:@"OpenSans-Semibold" size:25];
//    }
//    else if(IS_IPHONE_X)
//        {
//        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 32.5, CGRectGetWidth(self.containerView.bounds), 35)];
//        label.font = [UIFont fontWithName:@"OpenSans-Semibold" size:25];
//        }
//    else
//    {
//        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, CGRectGetWidth(self.containerView.bounds), 55)];
//        label.font = [UIFont fontWithName:@"OpenSans-Semibold" size:38];
//    }
//    label.backgroundColor = [UIColor clearColor];
//    label.textColor = [UIColor whiteColor];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.text = NSLocalizedString(@"Add New Device", nil);
//    return label;
//}
//
//- (UIImageView *)setupLogoImage
//{
//    UIImageView *imageView;
//    if(IS_IPHONE_4)
//    {
//        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.containerView.bounds) - 85/2.0f, CGRectGetMaxY(self.titleLabel.frame) + 8.5f, 85, 107)];
//        imageView.image = [UIImage imageNamed:@"ic_device"];
//    }
//    else if(IS_IPHONE_5)
//    {
//        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.containerView.bounds) - 85/2.0f, CGRectGetMaxY(self.titleLabel.frame) + 20.5f, 85, 107)];
//        imageView.image = [UIImage imageNamed:@"ic_device"];
//    }
//    else if(IS_IPHONE_6)
//    {
//        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.containerView.bounds) - 113/2.0f, CGRectGetMaxY(self.titleLabel.frame) + 22.5f, 113, 142)];
//        imageView.image = [UIImage imageNamed:@"ic_device"];
//    }
//    else if(IS_IPHONE_6_PLUS)
//    {
//        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.containerView.bounds) - 113/2.0f, CGRectGetMaxY(self.titleLabel.frame) + 22.5f, 113, 142)];
//        imageView.image = [UIImage imageNamed:@"ic_device"];
//    }
//    else if(IS_IPHONE_X)
//        {
//        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.containerView.bounds) - 113/2.0f, CGRectGetMaxY(self.titleLabel.frame) + 22.5f, 113, 142)];
//        imageView.image = [UIImage imageNamed:@"ic_device"];
//        }
//    else
//    {
//        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.containerView.bounds) - 128.0f/2.0f, CGRectGetMaxY(self.titleLabel.frame) + 27.5f, 128, 168)];
//        imageView.image = [UIImage imageNamed:@"ic_device_ipad"];
//    }
//    return imageView;
//}
//
//- (UILabel *)setupFirstLabel
//{
//    UILabel *label;
//    if(IS_IPHONE_4)
//    {
//        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.logoImageView.frame) + 15.5, CGRectGetWidth(self.containerView.bounds), 25.0f)];
//        label.font = [UIFont fontWithName:@"OpenSans-Light" size:14];
//    }
//    else if(IS_IPHONE_5)
//    {
//        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.logoImageView.frame) + 22.5f, CGRectGetWidth(self.containerView.bounds), 25.0f)];
//        label.font = [UIFont fontWithName:@"OpenSans-Light" size:14];
//    }
//    else if(IS_IPHONE_6)
//    {
//        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.logoImageView.frame) + 19.0f, CGRectGetWidth(self.containerView.bounds), 25.0f)];
//        label.font = [UIFont fontWithName:@"OpenSans-Light" size:16];
//    }
//    else if(IS_IPHONE_6_PLUS)
//    {
//        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.logoImageView.frame) + 41.5f, CGRectGetWidth(self.containerView.bounds), 30.0f)];
//        label.font = [UIFont fontWithName:@"OpenSans-Light" size:17];
//    }
//    else if(IS_IPHONE_X)
//        {
//        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.logoImageView.frame) + 41.5f, CGRectGetWidth(self.containerView.bounds), 30.0f)];
//        label.font = [UIFont fontWithName:@"OpenSans-Light" size:17];
//        }
//    else
//    {
//        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.logoImageView.frame) + 46.0f, CGRectGetWidth(self.containerView.bounds), 50.0f)];
//        label.font = [UIFont fontWithName:@"OpenSans-Light" size:23];
//    }
//    label.backgroundColor = [UIColor clearColor];
//    label.textColor = RGBCOLOR(237, 255, 179, 1);
//    label.textAlignment = NSTextAlignmentCenter;
//    label.numberOfLines = 0;
//    label.text = NSLocalizedString(@"Please enter the device name in the given field.", nil);
//    return label;
//}
//
//- (UILabel *)setupSecondLabel
//{
//    UILabel *label;
//    if(IS_IPHONE_4)
//    {
//        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.firstLabel.frame) + 10.0f, CGRectGetWidth(self.containerView.frame), 40.0f)];
//        label.font = [UIFont fontWithName:@"OpenSans-Light" size:14];
//    }
//    else if(IS_IPHONE_5)
//    {
//        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.firstLabel.frame) + 10.0f, CGRectGetWidth(self.containerView.frame), 40.0f)];
//        label.font = [UIFont fontWithName:@"OpenSans-Light" size:14];
//    }
//    else if(IS_IPHONE_6)
//    {
//        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.firstLabel.frame) + 12.0f, CGRectGetWidth(self.containerView.frame), 50.0f)];
//        label.font = [UIFont fontWithName:@"OpenSans-Light" size:16];
//    }
//    else if(IS_IPHONE_6_PLUS)
//    {
//        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.firstLabel.frame) + 14.0f, CGRectGetWidth(self.containerView.frame), 60.0f)];
//        label.font = [UIFont fontWithName:@"OpenSans-Light" size:17];
//    }
//    else if(IS_IPHONE_X)
//        {
//        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.firstLabel.frame) + 14.0f, CGRectGetWidth(self.containerView.frame), 60.0f)];
//        label.font = [UIFont fontWithName:@"OpenSans-Light" size:17];
//        }
//    else
//    {
//        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.firstLabel.frame) + 65.0f, CGRectGetWidth(self.containerView.frame), 75.0f)];
//        label.font = [UIFont fontWithName:@"OpenSans-Light" size:23];
//    }
//    label.backgroundColor = [UIColor clearColor];
//     label.textColor = RGBCOLOR(237, 255, 179, 1);
//    label.textAlignment = NSTextAlignmentCenter;
//    label.numberOfLines = 0;
//    label.text = NSLocalizedString(@"You can change the name afterwards from the profile screen.", nil);
//    return label;
//}
//
//- (UITextField *)setupNameField
//{
//    UITextField *field;
//    if(IS_IPHONE_4)
//    {
//        field = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.secondLabel.frame) + 20.0f, CGRectGetWidth(self.containerView.frame), 37)];
//        field.font = [UIFont systemFontOfSize:15];
//    }
//    else if(IS_IPHONE_5)
//    {
//        field = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.secondLabel.frame) + 25.0f, CGRectGetWidth(self.containerView.frame), 37)];
//        field.font = [UIFont systemFontOfSize:15];
//    }
//    else if(IS_IPHONE_6)
//    {
//        field = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.secondLabel.frame) + 30.0f, CGRectGetWidth(self.containerView.frame), 43)];
//        field.font = [UIFont systemFontOfSize:16];
//    }
//    else if(IS_IPHONE_6_PLUS)
//    {
//        field = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.secondLabel.frame) + 35.0f, CGRectGetWidth(self.containerView.frame), 47)];
//        field.font = [UIFont systemFontOfSize:17];
//    }
//    else if(IS_IPHONE_X)
//        {
//        field = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.secondLabel.frame) + 35.0f, CGRectGetWidth(self.containerView.frame), 47)];
//        field.font = [UIFont systemFontOfSize:17];
//        }
//    else
//    {
//        field = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.secondLabel.frame) + 55.0f, CGRectGetWidth(self.containerView.frame), 68)];
//        field.font = [UIFont systemFontOfSize:19];
//    }
//    field.backgroundColor = RGBCOLOR(172, 206, 58, 1);
//    field.textColor = [UIColor whiteColor];
//    field.textAlignment = NSTextAlignmentLeft;
//    field.placeholder = [@"NAME" myModification];
//    field.tintColor = [UIColor whiteColor];
//    field.delegate = self;
//    field.autocorrectionType = UITextAutocorrectionTypeNo;
//    field.spellCheckingType = UITextSpellCheckingTypeNo;
//
//    field.layer.borderColor = RGBCOLOR(199, 223, 123, 1).CGColor;
//    field.layer.borderWidth = [SwiftFTUtils isDeviceiPhoneFamily] ? 1 : 2;
//
//    UIView *tempMarginView1 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 15.0f, 10.0f)];
//    tempMarginView1.backgroundColor = [UIColor clearColor];
//    field.leftView = tempMarginView1;
//    field.leftViewMode = UITextFieldViewModeAlways;
//
//    return field;
//}
//
//- (UITableView *)setupRelationTableView:(BOOL)showZones
//{
//    UITableView *tableview;
//    if(IS_IPHONE_4)
//    {
//        tableview = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.nameField.frame) + 10.0f, CGRectGetWidth(self.containerView.frame), 37 * (showZones ? 3 : 2) + 10-37) style:UITableViewStylePlain];
//        tableview.rowHeight = 37.0f;
//    }
//    else if(IS_IPHONE_5)
//    {
//        tableview = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.nameField.frame) + 10.0f, CGRectGetWidth(self.containerView.frame), 37 * (showZones ? 3 : 2) + 10-37) style:UITableViewStylePlain];
//        tableview.rowHeight = 37.0f;
//    }
//    else if(IS_IPHONE_6)
//    {
//        tableview = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.nameField.frame) + 12.0f, CGRectGetWidth(self.containerView.frame), 43 * (showZones ? 3 : 2) + 12-43) style:UITableViewStylePlain];
//        tableview.rowHeight = 43.0f;
//    }
//    else if(IS_IPHONE_6_PLUS)
//    {
//        tableview = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.nameField.frame) + 12.0f, CGRectGetWidth(self.containerView.frame), 47 * (showZones ? 3 : 2) + 12 -47) style:UITableViewStylePlain];
//        tableview.rowHeight = 47.0f;
//    }
//    else if(IS_IPHONE_X)
//        {
//        tableview = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.nameField.frame) + 12.0f, CGRectGetWidth(self.containerView.frame), 47 * (showZones ? 3 : 2) + 12 -47) style:UITableViewStylePlain];
//        tableview.rowHeight = 47.0f;
//        }
//    else
//    {
//         tableview = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.nameField.frame) + 12.0f, CGRectGetWidth(self.containerView.frame), 68 * (showZones ? 3 : 2) + 12-68) style:UITableViewStylePlain];
//        tableview.rowHeight = 68.0f;
//    }
//
//    tableview.backgroundColor = [UIColor clearColor];
//    tableview.delegate = self;
//    tableview.dataSource = self;
//    tableview.layer.borderColor = RGBCOLOR(199, 223, 123, 1).CGColor;
//    tableview.layer.borderWidth = [SwiftFTUtils isDeviceiPhoneFamily] ? 1 : 2;
//    tableview.separatorColor = RGBCOLOR(199, 223, 123, 1);
//    tableview.scrollEnabled = NO;
//    tableview.tintColor = [UIColor whiteColor];
//    return tableview;
//}
//
//- (UIButton *)setupChildField
//{
//    UIButton *field = [UIButton buttonWithType:UIButtonTypeCustom];
//    [field setBackgroundColor:RGBCOLOR(172, 206, 58, 1)];
//    [field setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [field setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    field.layer.borderColor = RGBCOLOR(199, 223, 123, 1).CGColor;
//    field.layer.borderWidth = [SwiftFTUtils isDeviceiPhoneFamily] ? 1 : 2;
//    [field setTitle:[@"CHILD" myModification] forState:UIControlStateNormal];
//    [field setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
//    [field addTarget:self action:@selector(handleGenderDropDown:) forControlEvents:UIControlEventTouchUpInside];
//    if(IS_IPHONE_4)
//    {
//        field.frame = CGRectMake(0.0f, CGRectGetMaxY(self.nameField.frame) + 10.0f, CGRectGetWidth(self.containerView.frame), 37);
//        field.titleLabel.font = [UIFont systemFontOfSize:15];
//    }
//    else if(IS_IPHONE_5)
//    {
//        field.frame = CGRectMake(0.0f, CGRectGetMaxY(self.nameField.frame) + 10.0f, CGRectGetWidth(self.containerView.frame), 37);
//        field.titleLabel.font = [UIFont systemFontOfSize:15];
//    }
//    else if(IS_IPHONE_6)
//    {
//        field.frame = CGRectMake(0.0f, CGRectGetMaxY(self.nameField.frame) + 12.0f, CGRectGetWidth(self.containerView.frame), 43);
//        field.titleLabel.font = [UIFont systemFontOfSize:16];
//    }
//    else if(IS_IPHONE_6_PLUS)
//    {
//        field.frame = CGRectMake(0.0f, CGRectGetMaxY(self.nameField.frame) + 12.0f, CGRectGetWidth(self.containerView.frame), 47);
//        field.titleLabel.font = [UIFont systemFontOfSize:17];
//    }
//    else if(IS_IPHONE_X)
//        {
//        field.frame = CGRectMake(0.0f, CGRectGetMaxY(self.nameField.frame) + 12.0f, CGRectGetWidth(self.containerView.frame), 47);
//        field.titleLabel.font = [UIFont systemFontOfSize:17];
//        }
//    else
//    {
//        field.frame = CGRectMake(0.0f, CGRectGetMaxY(self.nameField.frame) + 12.0f, CGRectGetWidth(self.containerView.frame), 68);
//        field.titleLabel.font = [UIFont systemFontOfSize:19];
//    }
//    field.imageEdgeInsets = UIEdgeInsetsMake(0, CGRectGetWidth(field.frame) - 40, 0, 0);
//    [field setImage:[SwiftFTUtils imageWithTint:[UIColor whiteColor] image:[UIImage imageNamed:@"down_arrow"]] forState:UIControlStateNormal];
//
//    return field;
//}
//
//- (UIButton *)setupAddDeviceButton
//{
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setTitle:[@"NEXT" myModification] forState:UIControlStateNormal];
//    [button.titleLabel setAdjustsFontSizeToFitWidth:YES];
//
//    button.backgroundColor = RGBCOLOR(126, 159, 17, 1);
//    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
//
//    [button addTarget:self action:@selector(handleAddDevice:) forControlEvents:UIControlEventTouchUpInside];
//    if(IS_IPHONE_4)
//    {
//        if(!self.addingFirstUser)
//            button.frame = CGRectMake(CGRectGetMidX(self.containerView.bounds), CGRectGetMaxY(self.relationTableView.frame) + 12.0f, CGRectGetWidth(self.containerView.frame)/2.0f, 37);
//        else
//            button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.relationTableView.frame) + 12.0f, CGRectGetWidth(self.containerView.frame), 37);
//        button.titleLabel.font = [UIFont systemFontOfSize:15];
//    }
//    else if(IS_IPHONE_5)
//    {
//         if(!self.addingFirstUser)
//             button.frame = CGRectMake(CGRectGetMidX(self.containerView.bounds), CGRectGetMaxY(self.relationTableView.frame) + 30.0f, CGRectGetWidth(self.containerView.frame)/2.0f, 37);
//        else
//            button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.relationTableView.frame) + 30.0f, CGRectGetWidth(self.containerView.frame), 37);
//        button.titleLabel.font = [UIFont systemFontOfSize:15];
//    }
//    else if(IS_IPHONE_6)
//    {
//        if(!self.addingFirstUser)
//            button.frame = CGRectMake(CGRectGetMidX(self.containerView.bounds), CGRectGetMaxY(self.relationTableView.frame) + 35.0f, CGRectGetWidth(self.containerView.frame)/2.0f, 43);
//        else
//            button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.relationTableView.frame) + 35.0f, CGRectGetWidth(self.containerView.frame), 43);
//        button.titleLabel.font = [UIFont systemFontOfSize:16];
//    }
//    else if(IS_IPHONE_6_PLUS)
//    {
//        if(!self.addingFirstUser)
//            button.frame = CGRectMake(CGRectGetMidX(self.containerView.bounds), CGRectGetMaxY(self.relationTableView.frame) + 35.0f, CGRectGetWidth(self.containerView.frame)/2.0f, 47);
//        else
//            button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.relationTableView.frame) + 35.0f, CGRectGetWidth(self.containerView.frame), 47);
//        button.titleLabel.font = [UIFont systemFontOfSize:17];
//    }
//    else if(IS_IPHONE_X)
//        {
//        if(!self.addingFirstUser)
//            button.frame = CGRectMake(CGRectGetMidX(self.containerView.bounds), CGRectGetMaxY(self.relationTableView.frame) + 35.0f, CGRectGetWidth(self.containerView.frame)/2.0f, 47);
//        else
//            button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.relationTableView.frame) + 35.0f, CGRectGetWidth(self.containerView.frame), 47);
//        button.titleLabel.font = [UIFont systemFontOfSize:17];
//        }
//    else
//    {
//        if(!self.addingFirstUser)
//            button.frame = CGRectMake(CGRectGetMidX(self.containerView.bounds), CGRectGetMaxY(self.relationTableView.frame) + 20.0f, CGRectGetWidth(self.containerView.frame)/2.0f, 68);
//        else
//            button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.relationTableView.frame) + 20.0f, CGRectGetWidth(self.containerView.frame), 68);
//        button.titleLabel.font = [UIFont systemFontOfSize:19];
//    }
//    if(!self.addingFirstUser)
//        button.selectiveBorderFlag = AUISelectiveBordersFlagRight|AUISelectiveBordersFlagTop|AUISelectiveBordersFlagBottom;
//    else
//        button.selectiveBorderFlag = AUISelectiveBordersFlagRight|AUISelectiveBordersFlagLeft|AUISelectiveBordersFlagTop|AUISelectiveBordersFlagBottom;
//    button.selectiveBordersColor = RGBCOLOR(199, 223, 123, 1);
//    button.selectiveBordersWidth = 1.0;
//
//    return button;
//}
//
//- (UIButton *)setupCancelButton
//{
//    if(self.addingFirstUser)
//    {
//        return nil;
//    }
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    if(self.addingNewUserFromDashboard)
//        [button setTitle:[@"CANCEL" myModification] forState:UIControlStateNormal];
//    else
//        [button setTitle:[@"BACK" myModification] forState:UIControlStateNormal];
//    button.backgroundColor = RGBCOLOR(126, 159, 17, 1);
//    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
//    [button addTarget:self action:@selector(handleCancel:) forControlEvents:UIControlEventTouchUpInside];
//    if(IS_IPHONE_4)
//    {
//        button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.relationTableView.frame) + 12.0f, CGRectGetWidth(self.containerView.frame)/2.0f, 37);
//        button.titleLabel.font = [UIFont systemFontOfSize:15];
//    }
//    else if(IS_IPHONE_5)
//    {
//        button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.relationTableView.frame) + 30.0f, CGRectGetWidth(self.containerView.frame)/2.0f, 37);
//        button.titleLabel.font = [UIFont systemFontOfSize:15];
//    }
//    else if(IS_IPHONE_6)
//    {
//        button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.relationTableView.frame) + 35.0f, CGRectGetWidth(self.containerView.frame)/2.0f, 43);
//        button.titleLabel.font = [UIFont systemFontOfSize:16];
//    }
//    else if(IS_IPHONE_6_PLUS)
//    {
//        button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.relationTableView.frame) + 35.0f, CGRectGetWidth(self.containerView.frame)/2.0f, 47);
//        button.titleLabel.font = [UIFont systemFontOfSize:17];
//    }
//    else if(IS_IPHONE_X)
//        {
//        button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.relationTableView.frame) + 35.0f, CGRectGetWidth(self.containerView.frame)/2.0f, 47);
//        button.titleLabel.font = [UIFont systemFontOfSize:17];
//        }
//    else
//    {
//        button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.relationTableView.frame) + 20.0f, CGRectGetWidth(self.containerView.frame)/2.0f, 68);
//        button.titleLabel.font = [UIFont systemFontOfSize:19];
//    }
//    button.selectiveBorderFlag = AUISelectiveBordersFlagRight|AUISelectiveBordersFlagLeft|AUISelectiveBordersFlagTop|AUISelectiveBordersFlagBottom;
//    button.selectiveBordersColor = RGBCOLOR(199, 223, 123, 1);
//    button.selectiveBordersWidth = 1.0;
//    return button;
//}
//
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//- (IBAction)handleAddDevice:(id)sender
//{
//    if([self validateData])
//    {
//        WizardScreen4ViewController *controller = [[WizardScreen4ViewController alloc] init];
//        controller.name = [[self.nameField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//        controller.isChild = ([self.relationship isEqualToString:@"Child"]) ? YES : NO;
//        controller.fromDashboard = self.fromDashboard;
//        GMTTimezone *tz;
//        if(self.selectedTimeZoneIndex==-1)
//        {
//
//        }
//        else
//        {
//        tz = (GMTTimezone *)[self.gmtTimezones objectAtIndex:self.selectedTimeZoneIndex];
//        }
//        controller.timezone = tz.name;
//        [self.navigationController pushViewController:controller animated:YES];
//    }
//}
//
//
//
//- (void)handleCancel:(id)sender
//{
//    if(self.addingNewUserFromDashboard)
//        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//    else
//        [self.navigationController popViewControllerAnimated:YES];
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
////- (void)keyboardWillShow
////{
////    CGRect containerFrame;
////    if(IS_IPHONE_4)
////    {
////        containerFrame = CGRectMake(CGRectGetMinX(self.containerView.frame), -250.0f, CGRectGetWidth(self.containerView.frame), CGRectGetHeight(self.containerView.frame));
////    }
////    else if(IS_IPHONE_5)
////    {
////        containerFrame = CGRectMake(CGRectGetMinX(self.containerView.frame), -250.0f, CGRectGetWidth(self.containerView.frame), CGRectGetHeight(self.containerView.frame));
////    }
////    else if(IS_IPHONE_6)
////    {
////        containerFrame = CGRectMake(CGRectGetMinX(self.containerView.frame), -250.0f, CGRectGetWidth(self.containerView.frame), CGRectGetHeight(self.containerView.frame));
////    }
////    else if(IS_IPHONE_6_PLUS)
////    {
////        containerFrame = CGRectMake(CGRectGetMinX(self.containerView.frame), -250.0f, CGRectGetWidth(self.containerView.frame), CGRectGetHeight(self.containerView.frame));
////    }
////    else
////    {
////        containerFrame = CGRectMake(CGRectGetMinX(self.containerView.frame), -300.0f, CGRectGetWidth(self.containerView.frame), CGRectGetHeight(self.containerView.frame));
////    }
////
////    [UIView animateWithDuration:0.5f animations:^{
////        self.containerView.frame = containerFrame;
////    }];
////}
////
////- (void)keyboardWillHide
////{
////    CGRect containerFrame = CGRectMake(CGRectGetMinX(self.containerView.frame), 0.0f, CGRectGetWidth(self.containerView.frame), CGRectGetHeight(self.containerView.frame));
////    [UIView animateWithDuration:0.5f animations:^{
////        self.containerView.frame = containerFrame;
////    }];
////}
//
//- (void)handleGenderDropDown:(UIButton *)sender
//{
//    NSArray * array = @[@"Child", @"Parent"];
//    if(self.dropDown == nil)
//    {
//        CGFloat height;
//        self.dropDown = [[NIDropDown alloc] showDropDown:sender height:&height array:array tableHeight:100 direction:@"down"];
//        self.dropDown.delegate = self;
//    }
//    else
//    {
//        [self.dropDown hideDropDown:sender];
//        self.dropDown = nil;
//    }
//}
//
//- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
//    NSLog(@"%@",sender.selectedUser);
//    if([sender.selectedUser isEqualToString:@"Child"])
//    {
//        [self.childField setTitle:[@"CHILD" myModification] forState:UIControlStateNormal];
//    }
//    else
//    {
//        [self.childField setTitle:[@"PARENT" myModification] forState:UIControlStateNormal];
//    }
//    self.relationship = sender.selectedUser;
//    self.dropDown = nil;
//}
//
//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    [textField resignFirstResponder];
//    [self handleAddDevice:nil];
//    return YES;
//}
//
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    return YES;
//}
//
//- (BOOL)validateData
//{
//    NSString *userName = [[self.nameField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    if(userName.length <= 0)
//    {
//        [CommonModel showAlert:@"" msg:[@"Device name is required" myModification]];
//        return NO;
//    }
//    return YES;
//}
//
//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    if([self.relationship isEqualToString:@"Child"])
//        return 2;
//    else
//        return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    if(section == 0)
//        return 1;
//    return 1;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    if(section == 0)
//    {
//        if(IS_IPHONE_4)
//        {
//            return 10.0f;
//        }
//        else if(IS_IPHONE_5)
//        {
//            return 10.0f;
//        }
//        else if(IS_IPHONE_6)
//        {
//            return 12.0f;
//        }
//        else if(IS_IPHONE_6_PLUS)
//        {
//            return 12.0f;
//        }
//        else if(IS_IPHONE_X)
//            {
//            return 12.0f;
//            }
//        else
//        {
//            return 12.0f;
//        }
//    }
//    return 0.0f;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    if(section == 0)
//    {
//        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
//        footer.backgroundColor = [UIColor clearColor];
//        return footer;
//    }
//    return nil;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if(indexPath.section == 0)
//    {
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FILTER_CELL"];
//        if(cell == nil)
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FILTER_CELL"];
//        cell.backgroundColor = RGBCOLOR(172, 206, 58, 1);
//        cell.contentView.backgroundColor = RGBCOLOR(172, 206, 58, 1);
//        cell.textLabel.textColor = [UIColor whiteColor];
//        if(indexPath.row == 0)
//        {
//            cell.textLabel.text = [@"CHILD" myModification];
//            if([self.relationship isEqualToString:@"Child"])
//                cell.accessoryType = UITableViewCellAccessoryCheckmark;
//            else
//                cell.accessoryType = UITableViewCellAccessoryNone;
//        }
//        else
//        {
//            cell.textLabel.text = @"";
//            if([self.relationship isEqualToString:@"Parent"])
//                cell.accessoryType = UITableViewCellAccessoryCheckmark;
//            else
//                cell.accessoryType = UITableViewCellAccessoryNone;
//        }
//
//        if(IS_IPHONE_4)
//        {
//            cell.textLabel.font = [UIFont systemFontOfSize:15];
//        }
//        else if(IS_IPHONE_5)
//        {
//            cell.textLabel.font = [UIFont systemFontOfSize:15];
//        }
//        else if(IS_IPHONE_6)
//        {
//            cell.textLabel.font = [UIFont systemFontOfSize:16];
//        }
//        else if(IS_IPHONE_6_PLUS)
//        {
//            cell.textLabel.font = [UIFont systemFontOfSize:17];
//        }
//        else if(IS_IPHONE_X)
//            {
//            cell.textLabel.font = [UIFont systemFontOfSize:17];
//            }
//        else
//        {
//            cell.textLabel.font = [UIFont systemFontOfSize:19];
//        }
//        cell.tintColor = [UIColor whiteColor];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        return cell;
//    }
//    else
//    {
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZONE_CELL"];
//        if(cell == nil)
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZONE_CELL"];
//        cell.tintColor = [UIColor whiteColor];
//        cell.backgroundColor = RGBCOLOR(172, 206, 58, 1);
//        cell.contentView.backgroundColor = RGBCOLOR(172, 206, 58, 1);
//        cell.textLabel.textColor = [UIColor whiteColor];
//        if(indexPath.row> self.gmtTimezones.count-1)
//        {
//            cell.textLabel.text = @"Select Timezone";
//            if(IS_IPHONE_4)
//            {
//                cell.textLabel.font = [UIFont systemFontOfSize:15];
//            }
//            else if(IS_IPHONE_5)
//            {
//                cell.textLabel.font = [UIFont systemFontOfSize:15];
//            }
//            else if(IS_IPHONE_6)
//            {
//                cell.textLabel.font = [UIFont systemFontOfSize:16];
//            }
//            else if(IS_IPHONE_6_PLUS)
//            {
//                cell.textLabel.font = [UIFont systemFontOfSize:17];
//            }
//            else if(IS_IPHONE_X)
//                {
//                cell.textLabel.font = [UIFont systemFontOfSize:17];
//                }
//            else
//            {
//                cell.textLabel.font = [UIFont systemFontOfSize:19];
//            }
//        }
//        else
//        {
//            if(self.gmtTimezones.count>0)
//            {
//                NSLog(@"Here is Ahmad=%li",(long)self.selectedTimeZoneIndex);
//
//                if(self.selectedTimeZoneIndex==-1)
//                {
//                    cell.textLabel.text=@"Default Timezone";
//
//                }
//                else
//                {
//
//                    GMTTimezone *tz = (GMTTimezone *)[self.gmtTimezones objectAtIndex:self.selectedTimeZoneIndex];
//                    cell.textLabel.text = tz.strRep;
//                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//
//                    if(IS_IPHONE_4)
//                    {
//                        cell.textLabel.font = [UIFont systemFontOfSize:15];
//                    }
//                    else if(IS_IPHONE_5)
//                    {
//                        cell.textLabel.font = [UIFont systemFontOfSize:15];
//                    }
//                    else if(IS_IPHONE_6)
//                    {
//                        cell.textLabel.font = [UIFont systemFontOfSize:16];
//                    }
//                    else if(IS_IPHONE_6_PLUS)
//                    {
//                        cell.textLabel.font = [UIFont systemFontOfSize:17];
//                    }
//                    else if(IS_IPHONE_X)
//                    {
//                        cell.textLabel.font = [UIFont systemFontOfSize:17];
//                    }
//                    else
//                    {
//                        cell.textLabel.font = [UIFont systemFontOfSize:19];
//                    }
//                    cell.tintColor = [UIColor whiteColor];
//                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                    cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_DISCLOSURE_INDICATOR color:[UIColor whiteColor]];
//                }
//            }
//            else
//            {
//                cell.textLabel.text=@"Default Timezone";
//            }
//
//        }
//        return cell;
//    }
//
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
//{
//    [tableView  deselectRowAtIndexPath:indexPath animated:YES];
//
//    if(self.selectedTimeZoneIndex==-1)
//    {
//    }
//    else if(indexPath.section == 0)
//    {
////        if(indexPath.row == 0)
////            self.relationship = @"Child";
////        else
////            self.relationship = @"Parent";
////        [self.relationTableView reloadData];
////        BOOL b = [self.relationship isEqualToString:@"Child"];
////        [self resetTableFrames:b];
//    }
//    else
//    {
//
//
//        if(self.gmtTimezones.count>0)
//        {
//        TimeZonesViewController *controller = [[TimeZonesViewController alloc] initWithStyle:UITableViewStylePlain];
//        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
//        controller.selectedIndex = self.selectedTimeZoneIndex;
//        controller.timezones = self.gmtTimezones;
//        controller.controllerDelegate = self;
//        [self presentViewController:navController animated:YES completion:nil];
//        }
//    }
//}
//
//- (void)resetTableFrames:(BOOL)showZones {
//    [UIView animateWithDuration:0.65f animations:^{
//        if(IS_IPHONE_4)
//        {
//            self.relationTableView.frame = CGRectMake(0.0f, CGRectGetMaxY(self.nameField.frame) + 10.0f, CGRectGetWidth(self.containerView.frame), 37 * (showZones ? 3 : 2) + (showZones ? 10 : 0));
//        }
//        else if(IS_IPHONE_5)
//        {
//            self.relationTableView.frame = CGRectMake(0.0f, CGRectGetMaxY(self.nameField.frame) + 10.0f, CGRectGetWidth(self.containerView.frame), 37 * (showZones ? 3 : 2) + (showZones ? 10 : 0));
//        }
//        else if(IS_IPHONE_6)
//        {
//            self.relationTableView.frame = CGRectMake(0.0f, CGRectGetMaxY(self.nameField.frame) + 12.0f, CGRectGetWidth(self.containerView.frame), 43 * (showZones ? 3 : 2) + (showZones ? 12 : 0));
//        }
//        else if(IS_IPHONE_6_PLUS)
//        {
//            self.relationTableView.frame = CGRectMake(0.0f, CGRectGetMaxY(self.nameField.frame) + 12.0f, CGRectGetWidth(self.containerView.frame), 47 * (showZones ? 3 : 2) + (showZones ? 12 : 0));
//        }
//        else if(IS_IPHONE_X)
//            {
//            self.relationTableView.frame = CGRectMake(0.0f, CGRectGetMaxY(self.nameField.frame) + 12.0f, CGRectGetWidth(self.containerView.frame), 47 * (showZones ? 3 : 2) + (showZones ? 12 : 0));
//            }
//        else
//        {
//            self.relationTableView.frame = CGRectMake(0.0f, CGRectGetMaxY(self.nameField.frame) + 12.0f, CGRectGetWidth(self.containerView.frame), 68 * (showZones ? 3 : 2) + (showZones ? 12 : 0));
//        }
//    }];
//}
//
//- (void)didTimeZoneChangedTo:(NSInteger )selectedIndex
//{
//    self.selectedTimeZoneIndex = selectedIndex;
//    [self.relationTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
//}
//@end
