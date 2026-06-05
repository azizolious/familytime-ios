//
//  AddLimitScrenRule.m
//  FamilyTime - Dashboard
//
//  Created by Muhammad Ajmal on 05/08/2016.
//  Copyright © 2016 SoraCode. All rights reserved.
//

#import "AddLimitScrenRule.h"
#import "AppDelegate.h"
#import "FTUtils.h"
#import "MBProgressHUD.h"
//#import "JSONHTTPClient.h"
#import "LeftSidesTableViewCell.h"
#import "NSString+LockMustafa.h"

#import "FamilyTime-Swift.h"


AppDelegate *delegate;

@interface LimitScreenRuleStatusView : UIView
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UISwitch *statusSwitch;
@end

@implementation LimitScreenRuleStatusView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = RGBCOLOR(16, 132, 180, 1);
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.imageView.image = [UIImage imageNamed:@"ic_white_clock"];
        [self addSubview:self.imageView];
        
        self.statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.statusLabel.textColor = [UIColor whiteColor];
        self.statusLabel.textAlignment = NSTextAlignmentLeft;
        self.statusLabel.text = @"Enabled";
        [self addSubview:self.statusLabel];
        
        self.statusSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
        //self.statusSwitch.tintColor = RGBCOLOR(16, 132, 180, 1);
        self.statusSwitch.onTintColor = RGBCOLOR(24, 167, 225, 1);
        self.statusSwitch.on = YES;
        [self addSubview:self.statusSwitch];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat labelFont = 0.0f;
    if(IS_IPHONE_4)
    {
        labelFont = 14.0f;
    }
    else if(IS_IPHONE_5)
    {
        labelFont = 14.0f;
    }
    else if(IS_IPHONE_6)
    {
        labelFont = 15.0f;
    }
    else if(IS_IPHONE_6_PLUS)
    {
        labelFont = 15.0f;
    }
    else if(IS_IPHONE_X)
    {
        labelFont = 15.0f;
    }
    else
    {
        labelFont = 20.0f;
    }
    
    self.statusLabel.font = [UIFont fontWithName:@"OpenSans" size:labelFont];
    self.imageView.frame = CGRectMake(10.0f, CGRectGetMidY(self.bounds) - 14.5f, 29, 29);
    self.statusLabel.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame) + 10.0f, 0.0f, 150.0f, CGRectGetHeight(self.bounds));
    self.statusSwitch.frame = CGRectMake(CGRectGetMaxX(self.bounds) - 61.0f, CGRectGetMidY(self.bounds) - 15.5f, 51, 31);
}
@end

@interface LimitScreenPickerHeaderView : UIView
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;
@end

@implementation LimitScreenPickerHeaderView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.imageView];
        
        self.label = [[UILabel alloc] initWithFrame:CGRectZero];
        self.label.textColor = [UIColor darkGrayColor];
        self.label.textAlignment = NSTextAlignmentLeft;
        self.label.text = @"Enabled";
        [self addSubview:self.label];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat labelFont = 0.0f;
    if(IS_IPHONE_4)
    {
        labelFont = 14.0f;
    }
    else if(IS_IPHONE_5)
    {
        labelFont = 14.0f;
    }
    else if(IS_IPHONE_6)
    {
        labelFont = 15.0f;
    }
    else if(IS_IPHONE_6_PLUS)
    {
        labelFont = 15.0f;
    }
    else
    {
        labelFont = 20.0f;
    }
    self.label.font = [UIFont fontWithName:@"OpenSans" size:labelFont];
    self.imageView.frame = CGRectMake(10.0f, CGRectGetMidY(self.bounds) - 12.0f, 24, 24);
    self.label.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame) + 10.0f, 0.0f, 150.0f, CGRectGetHeight(self.bounds));
}
@end


@interface LimitScreenWeekDaysView : UIView
@property (nonatomic, strong) UIButton *mondayButton;
@property (nonatomic, strong) UIButton *tuesdayButton;
@property (nonatomic, strong) UIButton *wednesdayButton;
@property (nonatomic, strong) UIButton *thursdayButton;
@property (nonatomic, strong) UIButton *fridayButton;
@property (nonatomic, strong) UIButton *saturdayButton;
@property (nonatomic, strong) UIButton *sundayButton;
@property (nonatomic, strong) AccessControlRuleModel *rule;


//---INTERNET SCHEDULE---//
//@property (nonatomic, strong) AccessControlRuleModel *internetSchedule;

@end

@implementation LimitScreenWeekDaysView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        CGFloat height = CGRectGetHeight(frame);
        CGFloat leftMargin;
        if(IS_IPHONE_4)
        {
            //height = 30.0f;
            leftMargin = 15.0f;
        }
        else if(IS_IPHONE_5)
        {
            //height = 30.0f;
            leftMargin = 15.0f;
        }
        else if(IS_IPHONE_6)
        {
            //height = 35.0f;
            leftMargin = 15.0f;
        }
        else if(IS_IPHONE_6_PLUS)
        {
            //height = 40.0f;
            leftMargin = 17.0f;
        }
        else
        {
            //height = 50.0f;
            leftMargin = 17.0f;
        }
        CGFloat spacesBetwwenButtons = ((CGRectGetWidth(self.bounds) - leftMargin) - (height*7))/7.0f;
        self.sundayButton = [self newButtonWithTitle:@"S" frame:CGRectMake(leftMargin, 0.0f, height, height) enable:YES];
        self.sundayButton.tag = 101;
        [self.sundayButton addTarget:self action:@selector(handleWeekDayButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.sundayButton];
        
        self.mondayButton = [self newButtonWithTitle:@"M" frame:CGRectMake(CGRectGetMaxX(self.sundayButton.frame) + spacesBetwwenButtons, 0.0f, height, height) enable:YES];
        self.mondayButton.tag = 102;
        [self.mondayButton addTarget:self action:@selector(handleWeekDayButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.mondayButton];
        
        self.tuesdayButton = [self newButtonWithTitle:@"T" frame:CGRectMake(CGRectGetMaxX(self.mondayButton.frame) + spacesBetwwenButtons, 0.0f, height, height) enable:YES];
        self.tuesdayButton.tag = 103;
        [self.tuesdayButton addTarget:self action:@selector(handleWeekDayButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.tuesdayButton];
        
        self.wednesdayButton = [self newButtonWithTitle:@"W" frame:CGRectMake(CGRectGetMaxX(self.tuesdayButton.frame) + spacesBetwwenButtons, 0.0f, height, height) enable:YES];
        self.wednesdayButton.tag = 104;
        [self.wednesdayButton addTarget:self action:@selector(handleWeekDayButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.wednesdayButton];
        
        self.thursdayButton = [self newButtonWithTitle:@"T" frame:CGRectMake(CGRectGetMaxX(self.wednesdayButton.frame) + spacesBetwwenButtons, 0.0f, height, height) enable:YES];
        self.thursdayButton.tag = 105;
        [self.thursdayButton addTarget:self action:@selector(handleWeekDayButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.thursdayButton];
        
        self.fridayButton = [self newButtonWithTitle:@"F" frame:CGRectMake(CGRectGetMaxX(self.thursdayButton.frame) + spacesBetwwenButtons, 0.0f, height, height) enable:YES];
        self.fridayButton.tag = 106;
        [self.fridayButton addTarget:self action:@selector(handleWeekDayButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.fridayButton];
        
        self.saturdayButton = [self newButtonWithTitle:@"S" frame:CGRectMake(CGRectGetMaxX(self.fridayButton.frame) + spacesBetwwenButtons, 0.0f, height, height) enable:YES];
        self.saturdayButton.tag = 107;
        [self.saturdayButton addTarget:self action:@selector(handleWeekDayButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.saturdayButton];
    }
    return self;
}

- (UIButton *)newButtonWithTitle:(NSString *)title frame:(CGRect)frame enable:(BOOL)enable
{
    CGFloat fontSize = 0.0f;
    if(IS_IPHONE_4)
    {
        fontSize = 22;
    }
    else if(IS_IPHONE_5)
    {
        fontSize = 22.0f;
    }
    else if(IS_IPHONE_6)
    {
        fontSize = 23.0f;
    }
    else if(IS_IPHONE_6_PLUS)
    {
        fontSize = 24.0f;
    }
    else
    {
        fontSize = 30.0f;
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont fontWithName:@"OpenSans" size:fontSize]];
    [button setTitleColor:enable ? RGBCOLOR(16, 132, 180, 1) : [UIColor lightGrayColor] forState:UIControlStateNormal];
    button.frame = frame;
    button.layer.cornerRadius = CGRectGetWidth(frame)/2.0f;
    button.layer.borderColor = enable ? RGBCOLOR(16, 132, 180, 1).CGColor : [UIColor lightGrayColor].CGColor;
    button.layer.borderWidth = 1.0f;
    button.layer.masksToBounds = YES;
    return button;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setRule:(AccessControlRuleModel *)rule
{
    
        
        _rule = rule;
   
   
    [self applyRuleOnButton:self.sundayButton isOn:([[rule.rule_config objectForKey:@"is_sunday"] integerValue] == 1)];
    [self applyRuleOnButton:self.mondayButton isOn:([[rule.rule_config objectForKey:@"is_monday"] integerValue] == 1)];
    [self applyRuleOnButton:self.tuesdayButton isOn:([[rule.rule_config objectForKey:@"is_tuesday"] integerValue] == 1)];
    [self applyRuleOnButton:self.wednesdayButton isOn:([[rule.rule_config objectForKey:@"is_wednesday"] integerValue] == 1)];
    [self applyRuleOnButton:self.thursdayButton isOn:([[rule.rule_config objectForKey:@"is_thursday"] integerValue] == 1)];
    [self applyRuleOnButton:self.fridayButton isOn:([[rule.rule_config objectForKey:@"is_friday"] integerValue] == 1)];
    [self applyRuleOnButton:self.saturdayButton isOn:([[rule.rule_config objectForKey:@"is_saturday"] integerValue] == 1)];
    
    self.rule.is_sunday = [rule.rule_config objectForKey:@"is_sunday"];
    self.rule.is_monday = [rule.rule_config objectForKey:@"is_monday"];
    self.rule.is_tuesday = [rule.rule_config objectForKey:@"is_tuesday"];
    self.rule.is_wednesday = [rule.rule_config objectForKey:@"is_wednesday"];
    self.rule.is_thursday = [rule.rule_config objectForKey:@"is_thursday"];
    self.rule.is_friday = [rule.rule_config objectForKey:@"is_friday"];
    self.rule.is_saturday = [rule.rule_config objectForKey:@"is_saturday"];
}

- (void)applyRuleOnButton:(UIButton *)button isOn:(BOOL)isOn
{
    [button setTitleColor:isOn ? UIColor.whiteColor : [UIColor lightGrayColor] forState:UIControlStateNormal];
    button.layer.borderColor = isOn ? RGBCOLOR(16, 132, 180, 1).CGColor : [UIColor lightGrayColor].CGColor;
    button.layer.backgroundColor = isOn ? RGBCOLOR(16, 132, 180, 1).CGColor : [UIColor clearColor].CGColor;
    [button setNeedsDisplay];
}

- (void)handleWeekDayButton:(UIButton *)button
{
    if(self.rule == nil){

        self.rule = [[AccessControlRuleModel alloc] init];

    }
    
    NSLog(@"%@", self.rule);
//
    NSUserDefaults *data = [NSUserDefaults standardUserDefaults];
    
    if(button.tag == 101)//sunday
    {
        NSLog(@"%@", self.rule.is_sunday);
        
        if([self.rule.is_sunday integerValue] == 1){
            self.rule.is_sunday = @"0";
            [data setValue:@"0" forKey:@"sunday_day"];
        [_rule.rule_config setObject:@"0" forKey:@"is_sunday"];
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            button.layer.borderColor = [UIColor lightGrayColor].CGColor;
            button.layer.backgroundColor = UIColor.clearColor.CGColor;
        }
        else{
            self.rule.is_sunday = @"1";
            [data setValue:@"1" forKey:@"sunday_day"];
            [_rule.rule_config setObject:@"1" forKey:@"is_sunday"];
            [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
            button.layer.borderColor = RGBCOLOR(16, 132, 180, 1).CGColor;
            button.layer.backgroundColor = RGBCOLOR(16, 132, 180, 1).CGColor;
       // [self applyRuleOnButton:self.sundayButton isOn:([self.rule.is_sunday integerValue] == 1)];
        }
    }
    else if(button.tag == 102)//monday
    {
        if([self.rule.is_monday integerValue] == 1){
           self.rule.is_monday = @"0";
            [data setValue:@"0" forKey:@"monday_day"];
            [_rule.rule_config setObject:@"0" forKey:@"is_monday"];
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            button.layer.borderColor = [UIColor lightGrayColor].CGColor;
            button.layer.backgroundColor = UIColor.clearColor.CGColor;
        }else{
           self.rule.is_monday = @"1";
            [data setValue:@"1" forKey:@"monday_day"];
             [_rule.rule_config setObject:@"1" forKey:@"is_monday"];
            [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
            button.layer.borderColor = RGBCOLOR(16, 132, 180, 1).CGColor;
            button.layer.backgroundColor = RGBCOLOR(16, 132, 180, 1).CGColor;
        //[self applyRuleOnButton:self.mondayButton isOn:([self.rule.is_monday integerValue] == 1)];
        }
    }
    else if(button.tag == 103)//tuesday
    {
        if([self.rule.is_tuesday integerValue] == 1){
            self.rule.is_tuesday = @"0";
            [data setValue:@"0" forKey:@"tuesday_day"];
             [_rule.rule_config setObject:@"0" forKey:@"is_tuesday"];
        
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            button.layer.borderColor = [UIColor lightGrayColor].CGColor;
            button.layer.backgroundColor = UIColor.clearColor.CGColor;
        }else{
            self.rule.is_tuesday = @"1";
            [_rule.rule_config setObject:@"1" forKey:@"is_tuesday"];
            [data setValue:@"1" forKey:@"tuesday_day"];
            [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
            button.layer.borderColor = RGBCOLOR(16, 132, 180, 1).CGColor;
            button.layer.backgroundColor = RGBCOLOR(16, 132, 180, 1).CGColor;
        //[self applyRuleOnButton:self.tuesdayButton isOn:([self.rule.is_tuesday integerValue] == 1)];
        }
    }
    else if(button.tag == 104)//wednesday
    {
        if([self.rule.is_wednesday integerValue] == 1){
            self.rule.is_wednesday = @"0";
            [_rule.rule_config setObject:@"0" forKey:@"is_wednesday"];
            [data setValue:@"0" forKey:@"wednesday_day"];
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            button.layer.borderColor = [UIColor lightGrayColor].CGColor;
            button.layer.backgroundColor = UIColor.clearColor.CGColor;
        }else{
           self.rule.is_wednesday = @"1";
            [_rule.rule_config setObject:@"1" forKey:@"is_wednesday"];
            [data setValue:@"1" forKey:@"wednesday_day"];
            [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
            button.layer.borderColor = RGBCOLOR(16, 132, 180, 1).CGColor;
            button.layer.backgroundColor = RGBCOLOR(16, 132, 180, 1).CGColor;
        //[self applyRuleOnButton:self.wednesdayButton isOn:([self.rule.is_wednesday integerValue] == 1)];
        }
    }
    else if(button.tag == 105)//thursday
    {
        if([self.rule.is_thursday integerValue] == 1){
            self.rule.is_thursday = @"0";
            [_rule.rule_config setObject:@"0" forKey:@"is_thursday"];
            [data setValue:@"0" forKey:@"thursday_day"];
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            button.layer.borderColor = [UIColor lightGrayColor].CGColor;
            button.layer.backgroundColor = UIColor.clearColor.CGColor;
        }else{
            self.rule.is_thursday = @"1";
            [_rule.rule_config setObject:@"1" forKey:@"is_thursday"];
            [data setValue:@"1" forKey:@"thursday_day"];
            [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
            button.layer.borderColor = RGBCOLOR(16, 132, 180, 1).CGColor;
            button.layer.backgroundColor = RGBCOLOR(16, 132, 180, 1).CGColor;
        //[self applyRuleOnButton:self.thursdayButton isOn:([self.rule.is_thursday integerValue] == 1)];
        }
    }
    else if(button.tag == 106)//friday
    {
        if([self.rule.is_friday integerValue] == 1){
            self.rule.is_friday = @"0";
             [_rule.rule_config setObject:@"0" forKey:@"is_friday"];
            [data setValue:@"0" forKey:@"friday_day"];
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            button.layer.borderColor = [UIColor lightGrayColor].CGColor;
            button.layer.backgroundColor = UIColor.clearColor.CGColor;
        }else{
            self.rule.is_friday = @"1";
            [_rule.rule_config setObject:@"1" forKey:@"is_friday"];
            [data setValue:@"1" forKey:@"friday_day"];
            [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
            button.layer.borderColor = RGBCOLOR(16, 132, 180, 1).CGColor;
            button.layer.backgroundColor = RGBCOLOR(16, 132, 180, 1).CGColor;
        //[self applyRuleOnButton:self.fridayButton isOn:([self.rule.is_friday integerValue] == 1)];
        }
    }
    else if(button.tag == 107)//saturday
    {
        if([self.rule.is_saturday integerValue] == 1){
           self.rule.is_saturday = @"0";
         [_rule.rule_config setObject:@"0" forKey:@"is_saturday"];
            [data setValue:@"0" forKey:@"saturday_day"];
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            button.layer.borderColor = [UIColor lightGrayColor].CGColor;
            button.layer.backgroundColor = UIColor.clearColor.CGColor;
        }else{
            self.rule.is_saturday = @"1";
             [_rule.rule_config setObject:@"1" forKey:@"is_saturday"];
            [data setValue:@"1" forKey:@"saturday_day"];
            [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
            button.layer.borderColor = RGBCOLOR(16, 132, 180, 1).CGColor;
            button.layer.backgroundColor = RGBCOLOR(16, 132, 180, 1).CGColor;
        //[self applyRuleOnButton:self.saturdayButton isOn:([self.rule.is_saturday integerValue] == 1)];
        }
    }
    
    [data synchronize];
}

@end

@interface AddLimitScrenRule ()<UITextFieldDelegate, UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource>
{
    BOOL is_Safari, is_Camera, is_Siri, is_iTunes, is_installinApps, is_inappPurchases, is_otherApps;
}

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) LimitScreenRuleStatusView *statusView;
@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) LimitScreenPickerHeaderView *firstHeaderView;
@property (nonatomic, strong) LimitScreenPickerHeaderView *secondHeaderView;
@property (nonatomic, strong) LimitScreenPickerHeaderView *repeatHeaderView;
@property (nonatomic, strong) LimitScreenWeekDaysView *weekDaysView;
@property (nonatomic, strong) UIDatePicker *startTimePicker;
@property (nonatomic, strong) UIDatePicker *endTimePicker;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *hours;
@property (nonatomic, strong) NSMutableArray *minutes;
@property (nonatomic, strong) NSArray *appsTitles0;
@property (nonatomic, strong) NSArray *appsImages0;
@property (nonatomic, strong) NSArray *appsTitles1;
@property (nonatomic, strong) NSArray *appsImages1;
@property (nonatomic, strong) NSArray *appsTitles2;
@property (nonatomic, strong) NSArray *appsImages2;

@end

@implementation AddLimitScrenRule

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSUserDefaults standardUserDefaults]setObject:@"NO"  forKey:@"gobacknow"];
    [[NSUserDefaults standardUserDefaults]synchronize];

    
    self.view.backgroundColor = [UIColor whiteColor];
    delegate = [AppDelegate appDelegate];
    
    self.hours = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
    self.minutes = [NSMutableArray array];
    
    self.appsTitles0 = @[@"Safari", @"Camera", @"Siri & Dictation"];
    self.appsImages0 = @[@"safari", @"camera", @"siri"];
    
    self.appsTitles1 = @[@"iTunes Store", @"Installing Apps", @"In App Purchases"];
    self.appsImages1 = @[@"itunesStore", @"installingApps", @"inappPurchases"];
    
    self.appsTitles2 = @[@"Other Apps"];
    self.appsImages2 = @[@"inappPurchases"];
    
    for (NSInteger index = 0; index < 60; index++)
    {
        [self.minutes addObject:[NSString stringWithFormat:@"%02ld",(long)index]];
    }
    
    
    [self setupUI];

}

- (void)setupUI
{
    
    NSLog(@"%@", self.rule);
    NSLog(@"%@", self.rule.is_wednesday);
    
    CGFloat verticalMargin = 0;
    CGFloat weekdaysViewHeight = 0;
    CGFloat headerViewHeight = 0;
    CGFloat timePickerHeight;
    CGFloat nameFieldHeight = 0;
    CGFloat statusViewHeight = 0;
    CGFloat switchViewSclaeFactor = 1.0f;
    if(IS_IPHONE_4)
    {
        verticalMargin = 10.0f;
        weekdaysViewHeight = 35;
        headerViewHeight = 20.0f;
        timePickerHeight = 100.0f;
        nameFieldHeight = 25.0f;
        statusViewHeight = 40.0f;
        switchViewSclaeFactor = 1.0f;
    }
    else if(IS_IPHONE_5)
    {
        verticalMargin = 15.0f;
        weekdaysViewHeight = 35;
        headerViewHeight = 25.0f;
        timePickerHeight = 120.0f;
        nameFieldHeight = 30.0f;
        statusViewHeight = 40.0f;
        switchViewSclaeFactor = 1.0f;
    }
    else if(IS_IPHONE_6)
    {
        verticalMargin = 25.0f;
        weekdaysViewHeight = 40;
        headerViewHeight = 35.0f;
        timePickerHeight = 130.0f;
        nameFieldHeight = 35.0f;
        statusViewHeight = 40.0f;
        switchViewSclaeFactor = 1.0f;
    }
    else if(IS_IPHONE_6_PLUS)
    {
        verticalMargin = 25.0f;
        weekdaysViewHeight = 45;
        headerViewHeight = 45.0f;
        timePickerHeight = 130.0f;
        nameFieldHeight = 40.0f;
        statusViewHeight = 50.0f;
        switchViewSclaeFactor = 1.0f;
    }
    else
    {
        verticalMargin = 30.0f;
        weekdaysViewHeight = 45;
        headerViewHeight = 50.0f;
        timePickerHeight = 230.0f;
        nameFieldHeight = 40.0f;
        statusViewHeight = 60.0f;
        switchViewSclaeFactor = 1.0f;
    }
    
    
    self.title = self.isNew ? [@"Custom Rule" myModification] : self.rule.rule_name;
    
    self.title=[self.title myModification];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    self.scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.scrollView];
    
    self.statusView = [[LimitScreenRuleStatusView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.bounds), statusViewHeight)];
    [self.scrollView addSubview:self.statusView];
    self.statusView.statusSwitch.transform = CGAffineTransformMakeScale(switchViewSclaeFactor, switchViewSclaeFactor);
    self.statusView.statusLabel.text = ([self.rule.is_active integerValue] == 1) ? [@"Enable" myModification] : [@"Disable" myModification];
    self.statusView.imageView.image = [CommonModel imageForHeaderSST:self.rule.rule_name]; // [self imageForHeader:self.rule];
    self.statusView.statusSwitch.on = ([self.rule.is_active integerValue] == 1) ? YES : NO;
    [self.statusView.statusSwitch addTarget:self action:@selector(handleStatusSwitch:) forControlEvents:UIControlEventValueChanged];
    
    NSLog(@"%@", self.rule);
    NSLog(@"%@", self.rule.is_wednesday);
    
    if(self.isNew || ![self.rule.is_predefined integerValue])
    {
        self.nameField = [[UITextField alloc] initWithFrame:CGRectMake(20.0f, CGRectGetMaxY(self.statusView.frame) + verticalMargin, CGRectGetWidth(self.view.bounds) - 40.0f, nameFieldHeight)];
        self.nameField.placeholder = [NSString stringWithFormat:@" %@",[@"Enter Rule Name" myModification]];
        self.nameField.font = [UIFont fontWithName:@"OpenSans" size:13.0f];
        self.nameField.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5f].CGColor;
        self.nameField.layer.borderWidth = 1.0f;
        self.nameField.layer.cornerRadius = 3.0f;
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
        self.nameField.leftView = paddingView;
        self.nameField.leftViewMode = UITextFieldViewModeAlways;
        self.nameField.delegate = self;
        self.nameField.returnKeyType = UIReturnKeyDone;
        self.nameField.text = self.rule.rule_name;
        [self.scrollView addSubview:self.nameField];
    }
    
    if(self.isNew || ![self.rule.is_predefined integerValue])
    {
        self.firstHeaderView = [[LimitScreenPickerHeaderView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.nameField.frame) + verticalMargin, CGRectGetWidth(self.view.bounds), headerViewHeight)];
        [self.scrollView addSubview:self.firstHeaderView];
    }
    else
    {
        self.firstHeaderView = [[LimitScreenPickerHeaderView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.statusView.frame) + verticalMargin, CGRectGetWidth(self.view.bounds), headerViewHeight)];
        [self.scrollView addSubview:self.firstHeaderView];
    }
    self.firstHeaderView.imageView.image = [UIImage imageNamed:@"ic_clock"];
    self.firstHeaderView.label.text = [@"Start Time" myModification];
    
    NSLog(@"%@", self.rule);
    NSLog(@"%@", self.rule.is_wednesday);
 
    //self.startTimePicker.datePickerMode = UIDatePickerModeTime;
    if (@available(iOS 14.0, *)) {
        if(IS_IPHONE_5)
       {
           self.startTimePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(self.view.center.x - 155, CGRectGetMaxY(self.firstHeaderView.frame), CGRectGetWidth(self.view.bounds), timePickerHeight)];
       }
       else if(IS_IPHONE_6)
       {
           self.startTimePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(self.view.center.x - 160, CGRectGetMaxY(self.firstHeaderView.frame), CGRectGetWidth(self.view.bounds), timePickerHeight)];
       }
       else if(IS_IPHONE_6_PLUS)
       {
           self.startTimePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(self.view.center.x - 165, CGRectGetMaxY(self.firstHeaderView.frame), CGRectGetWidth(self.view.bounds), timePickerHeight)];
       }
       else if(IS_IPHONE_X)
       {
           self.startTimePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(self.view.center.x - 162, CGRectGetMaxY(self.firstHeaderView.frame), CGRectGetWidth(self.view.bounds), timePickerHeight)];
       }else{
           
           self.startTimePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(self.view.center.x - 170, CGRectGetMaxY(self.firstHeaderView.frame), CGRectGetWidth(self.view.bounds), timePickerHeight)];
           
       }
        self.startTimePicker.preferredDatePickerStyle =  UIDatePickerStyleWheels;
    } else {
        self.startTimePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.firstHeaderView.frame), CGRectGetWidth(self.view.bounds), timePickerHeight)];
    }
    self.startTimePicker.tag = 101;
    self.startTimePicker.datePickerMode = UIDatePickerModeTime;
    [self.startTimePicker setValue:RGBCOLOR(16, 132, 180, 1) forKey:@"textColor"];
    [self.scrollView addSubview:self.startTimePicker];
    
    NSLog(@"%@", self.rule);
    NSLog(@"%@", self.rule.is_wednesday);
    
    if(!self.isNew)
    {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"HH:mm:ss"];
        //[df setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        NSDate *start_date = [df dateFromString:[self.rule.rule_config objectForKey:@"time_start"]];
        if(start_date!=nil)
        {
        [self.startTimePicker setDate:start_date];
        }
    }
    
    self.secondHeaderView = [[LimitScreenPickerHeaderView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.startTimePicker.frame) + verticalMargin, CGRectGetWidth(self.view.bounds), headerViewHeight)];
    [self.scrollView addSubview:self.secondHeaderView];
    self.secondHeaderView.imageView.image = [UIImage imageNamed:@"ic_clock"];
    self.secondHeaderView.label.text = [@"End Time" myModification];
    

 
    self.endTimePicker.tintColor = RGBCOLOR(16, 132, 180, 1);
    self.endTimePicker.tag = 102;
    //self.endTimePicker.datePickerMode = UIDatePickerModeTime;
    
    
        if (@available(iOS 14.0, *)) {
            if(IS_IPHONE_5)
           {
               self.endTimePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(self.view.center.x - 155, CGRectGetMaxY(self.secondHeaderView.frame), CGRectGetWidth(self.view.bounds), timePickerHeight)];
           }
           else if(IS_IPHONE_6)
           {
               self.endTimePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(self.view.center.x - 160, CGRectGetMaxY(self.secondHeaderView.frame), CGRectGetWidth(self.view.bounds), timePickerHeight)];
           }
           else if(IS_IPHONE_6_PLUS)
           {
               self.endTimePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(self.view.center.x - 165, CGRectGetMaxY(self.secondHeaderView.frame), CGRectGetWidth(self.view.bounds), timePickerHeight)];
           }
           else if(IS_IPHONE_X)
           {
               self.endTimePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(self.view.center.x - 162, CGRectGetMaxY(self.secondHeaderView.frame), CGRectGetWidth(self.view.bounds), timePickerHeight)];
           }else{
               
               self.endTimePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(self.view.center.x - 170, CGRectGetMaxY(self.secondHeaderView.frame), CGRectGetWidth(self.view.bounds), timePickerHeight)];
               
           }
            self.endTimePicker.preferredDatePickerStyle =  UIDatePickerStyleWheels;
        } else {
            // Fallback on earlier versions
            self.endTimePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.secondHeaderView.frame), CGRectGetWidth(self.view.bounds), timePickerHeight)];
        }
    
    NSLog(@"%@", self.rule);
    NSLog(@"%@", self.rule.is_wednesday);
    
    self.endTimePicker.datePickerMode = UIDatePickerModeTime;
    [self.endTimePicker setValue:RGBCOLOR(16, 132, 180, 1) forKey:@"textColor"];
    [self.scrollView addSubview:self.endTimePicker];
    if(!self.isNew)
    {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"HH:mm:ss"];
        //[df setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        NSDate *end_date = [df dateFromString:[self.rule.rule_config objectForKey:@"time_end"]];
        [self.endTimePicker setDate:end_date];
    }
    
    self.repeatHeaderView = [[LimitScreenPickerHeaderView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.endTimePicker.frame) + verticalMargin, CGRectGetWidth(self.view.bounds), headerViewHeight)];
    [self.scrollView addSubview:self.repeatHeaderView];
    self.repeatHeaderView.imageView.image = [UIImage imageNamed:@"blue_refresh"];
    self.repeatHeaderView.label.text = [@"Repeat" myModification];
    
    NSLog(@"%@", self.rule);
    NSLog(@"%@", self.rule.is_wednesday);
    
    self.weekDaysView = [[LimitScreenWeekDaysView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.repeatHeaderView.frame), CGRectGetWidth(self.view.bounds), weekdaysViewHeight)];
    [self.scrollView addSubview:self.weekDaysView];
    self.weekDaysView.rule = self.rule;
    
    NSLog(@"%@", self.rule);
    NSLog(@"%@", self.rule.is_wednesday);
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.weekDaysView.frame) + 20, CGRectGetWidth(self.view.bounds), 75.0*8.0) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.rowHeight = 75;
    [self.tableView registerNib:[UINib nibWithNibName:@"LeftSidesTableViewCell" bundle:nil] forCellReuseIdentifier:@"LeftSidesCell"];
    [self.scrollView addSubview:self.tableView];
    
    NSLog(@"%@", self.rule);
    NSLog(@"%@", self.rule.is_wednesday);

    if(![self.rule.is_predefined integerValue] && !self.isNew)
    {
        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteButton setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        deleteButton.frame = CGRectMake(15.0f, CGRectGetMaxY(self.self.tableView.frame) + 10, 30, 30);
        [deleteButton addTarget:self action:@selector(handleDelete:) forControlEvents:UIControlEventTouchUpInside];
        deleteButton.tag = [self.rule.id integerValue];
        [self.scrollView addSubview:deleteButton];
        
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds), CGRectGetMaxY(deleteButton.frame) + 10+70);
    }
    else
    {
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds), CGRectGetMaxY(self.tableView.frame) + 10+70);
    }
    if([self.rule.is_predefined integerValue] && !self.isNew){
    NSData *data = [[self.rule.rule_config objectForKey:@"restriction"] dataUsingEncoding:NSUTF8StringEncoding];
    //id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        NSLog(@"%@", self.rule);
        NSLog(@"%@", self.rule.is_wednesday);
    
    if([json objectForKey:@"safari"] != nil)
        is_Safari = [[json objectForKey:@"safari"] integerValue];
    else
        is_Safari = NO;
    
    if([json objectForKey:@"camera"] != nil)
        is_Camera = [[json objectForKey:@"camera"] integerValue];
        else
            is_Camera = NO;
    
    if([json objectForKey:@"siri"] != nil)
        is_Siri = [[json objectForKey:@"siri"] integerValue];
        else
            is_Siri = NO;
    
    if([json objectForKey:@"itunesStore"] != nil)
        is_iTunes = [[json objectForKey:@"itunesStore"] integerValue];
        else
            is_iTunes = NO;
    
    if([json objectForKey:@"installingApps"] != nil)
        is_installinApps = [[json objectForKey:@"installingApps"] integerValue];
        else
            is_installinApps = NO;
    
    if([json objectForKey:@"inappPurchases"] != nil)
        is_inappPurchases = [[json objectForKey:@"inappPurchases"] integerValue];
        else
            is_inappPurchases = NO;
    
    if([json objectForKey:@"externalApps"] != nil)
        is_otherApps = [[json objectForKey:@"externalApps"] integerValue];
        else
            is_otherApps = NO;
    
    NSLog(@"here%@",self.rule.restriction);
    }else if(![self.rule.is_predefined integerValue] && !self.isNew){
        
        NSData *data = [[self.rule.rule_config objectForKey:@"restriction"] dataUsingEncoding:NSUTF8StringEncoding];
        //id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        if([json objectForKey:@"safari"] != nil)
            is_Safari = [[json objectForKey:@"safari"] integerValue];
        else
            is_Safari = NO;
        
        if([json objectForKey:@"camera"] != nil)
            is_Camera = [[json objectForKey:@"camera"] integerValue];
            else
                is_Camera = NO;
        
        if([json objectForKey:@"siri"] != nil)
            is_Siri = [[json objectForKey:@"siri"] integerValue];
            else
                is_Siri = NO;
        
        if([json objectForKey:@"itunesStore"] != nil)
            is_iTunes = [[json objectForKey:@"itunesStore"] integerValue];
            else
                is_iTunes = NO;
        
        if([json objectForKey:@"installingApps"] != nil)
            is_installinApps = [[json objectForKey:@"installingApps"] integerValue];
            else
                is_installinApps = NO;
        
        if([json objectForKey:@"inappPurchases"] != nil)
            is_inappPurchases = [[json objectForKey:@"inappPurchases"] integerValue];
            else
                is_inappPurchases = NO;
        
        if([json objectForKey:@"externalApps"] != nil)
            is_otherApps = [[json objectForKey:@"externalApps"] integerValue];
            else
                is_otherApps = NO;
        
        NSLog(@"here%@",self.rule.restriction);
        
    }
//    NSLog(@"here%@",is_otherApps);
//    is_otherApps=YES;
    
    NSLog(@"%@", self.rule);
    NSLog(@"%@", self.rule.is_wednesday);
 
}

//- (UIImage *)imageForHeader:(AccessControlRuleModel *)rule
//{
//    if([rule.rule_name isEqualToString:@"Bedtime"])
//        return [UIImage imageNamed:@"ic_moon"];
//    else if([rule.rule_name isEqualToString:@"Dinner Time"])
//        return [UIImage imageNamed:@"ic_dinner"];
//    else if([rule.rule_name isEqualToString:@"Homework Time"])
//        return [UIImage imageNamed:@"ic_homework"];
//    else
//        return [UIImage imageNamed:@"ic_white_clock"];
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return self.appsTitles0.count;
    else if(section == 1)
        return self.appsTitles1.count;
    else
    return self.appsTitles2.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 0)
        return 60;
    return 10;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 60)];
        label.backgroundColor = [UIColor groupTableViewBackgroundColor];
        label.textColor = RGBCOLOR(138, 138, 138, 1);
        label.font = [UIFont fontWithName:@"OpenSans" size:16];
        label.text = [NSString stringWithFormat:@"    %@",[@"ALLOWED APPS" myModification]];
        return label;
    }
    else if(section == 1 || section == 2)
    {
        UIView *label = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 10)];
        label.backgroundColor = [UIColor groupTableViewBackgroundColor];
        return label;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingTableViewCell *cell = (SettingTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"LeftSidesCell"];
    
    if (cell == nil) {
        cell = (SettingTableViewCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LeftSidesCell"];
    }
    if(indexPath.section == 0)
    {
        cell.cellLabel.text = self.appsTitles0[indexPath.row];
        cell.cellImage.image = [UIImage imageNamed:self.appsImages0[indexPath.row]];
    }
    else if(indexPath.section == 1)
    {
        cell.cellLabel.text = self.appsTitles1[indexPath.row];
        cell.cellImage.image = [UIImage imageNamed:self.appsImages1[indexPath.row]];
    }
    else if(indexPath.section == 2)
    {
        cell.cellLabel.text = self.appsTitles2[indexPath.row];
        cell.cellImage.image = [UIImage imageNamed:self.appsImages2[indexPath.row]];
    }
    [cell.cellSwitch setHidden:NO];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            [cell.cellSwitch setOn:is_Safari];
        }
        else if(indexPath.row == 1)
        {
            [cell.cellSwitch setOn:is_Camera];
        }
        if(indexPath.row == 2)
        {
            [cell.cellSwitch setOn:is_Siri];
        }
    }
    else if(indexPath.section == 1)
    {
        if(indexPath.row == 0)
        {
            [cell.cellSwitch setOn:is_iTunes];
        }
        else if(indexPath.row == 1)
        {
            [cell.cellSwitch setOn:is_installinApps];
        }
        if(indexPath.row == 2)
        {
            [cell.cellSwitch setOn:is_inappPurchases];
        }
    }
    else if(indexPath.section == 2)
    {
        [cell.cellSwitch setOn:is_otherApps];
    }
    
    cell.onSwitchChange = ^(SettingTableViewCell *cellAffected){
        if(indexPath.section == 0 && indexPath.row == 0)
        {
            is_Safari = cellAffected.cellSwitch.isOn;
        }
        else if(indexPath.section == 0 && indexPath.row == 1)
        {
            is_Camera = cellAffected.cellSwitch.isOn;
        }
        else if(indexPath.section == 0 && indexPath.row == 2)
        {
            is_Siri = cellAffected.cellSwitch.isOn;
        }
        else if(indexPath.section == 1 && indexPath.row == 0)
        {
            is_iTunes = cellAffected.cellSwitch.isOn;
        }
        else if(indexPath.section == 1 && indexPath.row == 1)
        {
            is_installinApps = cellAffected.cellSwitch.isOn;
        }
        else if(indexPath.section == 1 && indexPath.row == 2)
        {
            is_inappPurchases = cellAffected.cellSwitch.isOn;
        }
        else if(indexPath.section == 2 && indexPath.row == 0)
        {
            is_otherApps = cellAffected.cellSwitch.isOn;
        }
    };
    
    return cell;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"%@", self.rule);
    NSLog(@"%@", self.rule.is_wednesday);
    
    if(self.isNew)
    {
        self.rule = [[AccessControlRuleModel alloc] init];
        self.rule.child_id = [[NSNumber numberWithInteger:delegate.selectedDashboardChild.child_id] stringValue];
        self.rule.rule_name = @"";
        self.rule.time_start = @"";
        self.rule.time_end = @"";
        self.rule.is_sunday = @"0";
        self.rule.is_monday = @"0";
        self.rule.is_tuesday = @"0";
        self.rule.is_wednesday = @"0";
        self.rule.is_thursday = @"0";
        self.rule.is_friday = @"0";
        self.rule.is_saturday = @"0";
        [self.rule.rule_config setObject:@"" forKey:@"time_start"];
        [self.rule.rule_config setObject:@"" forKey:@"time_end"];
        [self.rule.rule_config setObject:@"0" forKey:@"is_sunday"];
        [self.rule.rule_config setObject:@"0" forKey:@"is_monday"];
        [self.rule.rule_config setObject:@"0" forKey:@"is_tuesday"];
        [self.rule.rule_config setObject:@"0" forKey:@"is_wednesday"];
        [self.rule.rule_config setObject:@"0" forKey:@"is_thursday"];
        [self.rule.rule_config setObject:@"0" forKey:@"is_friday"];
        [self.rule.rule_config setObject:@"0" forKey:@"is_saturday"];
        NSUserDefaults *data = [NSUserDefaults standardUserDefaults];
        [data setValue:@"0" forKey:@"monday_day"];
        [data setValue:@"0" forKey:@"tuesday_day"];
        [data setValue:@"0" forKey:@"wednesday_day"];
        [data setValue:@"0" forKey:@"thursday_day"];
        [data setValue:@"0" forKey:@"friday_day"];
        [data setValue:@"0" forKey:@"saturday_day"];
        [data setValue:@"0" forKey:@"sunday_day"];
    
      

        self.rule.is_active = @"0";
        self.rule.restriction = [NSMutableDictionary dictionary];
        [self.rule.restriction setObject:is_Safari? @"1":@"0" forKey:@"safari"];
        [self.rule.restriction setObject:is_Camera? @"1":@"0" forKey:@"camera"];
        [self.rule.restriction setObject:is_Siri? @"1":@"0" forKey:@"siri"];
        [self.rule.restriction setObject:is_iTunes? @"1":@"0" forKey:@"itunesStore"];
        [self.rule.restriction setObject:is_installinApps? @"1":@"0" forKey:@"installingApps"];
        [self.rule.restriction setObject:is_inappPurchases? @"1":@"0" forKey:@"inappPurchases"];
        [self.rule.restriction setObject:is_otherApps? @"1":@"0" forKey:@"externalApps"];
    }
//    [self setupUI];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(handleSave:)];
    
    
    self.tableView.frame=CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height-self.tableView.rowHeight+200);

    
//    if( [[NSUserDefaults standardUserDefaults]objectForKey:@"gobacknow"]!=nil)
//    {
//        
//        if([[[NSUserDefaults standardUserDefaults]objectForKey:@"gobacknow"] isEqualToString:@"YES"])
//        {
//            [[NSUserDefaults standardUserDefaults]setObject:@"NO"  forKey:@"gobacknow"];
//            [[NSUserDefaults standardUserDefaults]synchronize];
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//    }

    [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(showMainMenu:)
                                                     name:@"syncComplete" object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if( [[NSUserDefaults standardUserDefaults]objectForKey:@"gobacknow"]!=nil)
    {
        
        if([[[NSUserDefaults standardUserDefaults]objectForKey:@"gobacknow"] isEqualToString:@"YES"])
        {
            [[NSUserDefaults standardUserDefaults]setObject:@"NO"  forKey:@"gobacknow"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}


- (void)showMainMenu:(NSNotification *)note {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)handleStatusSwitch:(UISwitch *)switchView
{
    if(switchView.isOn)
    {
        self.rule.is_active = @"1";
        self.statusView.statusLabel.text = [@"Enable" myModification];
    }
    else
    {
        self.rule.is_active = @"0";
        self.statusView.statusLabel.text = [@"Disable" myModification];
        
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == 0)
        return self.hours.count;
    else if(component == 1)
        return self.minutes.count;
    return 2;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return CGRectGetWidth(self.startTimePicker.frame)/3.0f;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return CGRectGetHeight(self.startTimePicker.frame)/4.0f;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component == 0)
    {
        NSMutableAttributedString *rowTitle = [[NSMutableAttributedString alloc] initWithString:self.hours[row]];
        [rowTitle addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(16, 132, 180, 1) range:NSMakeRange(0, rowTitle.length)];
        return rowTitle;
        
    }
    else if(component == 1)
    {
        NSMutableAttributedString *rowTitle = [[NSMutableAttributedString alloc] initWithString:self.minutes[row]];
        [rowTitle addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(16, 132, 180, 1) range:NSMakeRange(0, rowTitle.length)];
        return rowTitle;
    }
    else
    {
        if(row == 0)
        {
            NSMutableAttributedString *rowTitle = [[NSMutableAttributedString alloc] initWithString:@"AM"];
            [rowTitle addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(16, 132, 180, 1) range:NSMakeRange(0, rowTitle.length)];
            return rowTitle;
        }
        else
        {
            NSMutableAttributedString *rowTitle = [[NSMutableAttributedString alloc] initWithString:@"PM"];
            [rowTitle addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(16, 132, 180, 1) range:NSMakeRange(0, rowTitle.length)];
            return rowTitle;
        }
    }
}

- (void)handleSave:(id)sender
{
    if(!self.isNew)
    {
        if(self.nameField.text.length == 0 && [self.rule.is_predefined integerValue] == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[@"Enter Rule Name" myModification] message:[@"Please provide rule name" myModification] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }else{
            
        //start time
        {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"HH:mm"];
            //[formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
            NSString *startTime = [formatter stringFromDate:self.startTimePicker.date];
            //self.rule.time_start = startTime;
            [self.rule.rule_config setObject:startTime forKey:@"time_start"];
        }
        
        //end time
        {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"HH:mm"];
            //[formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
            NSString *endTimeTime = [formatter stringFromDate:self.endTimePicker.date];
           // self.rule.time_end    = endTimeTime;
            [self.rule.rule_config setObject:endTimeTime forKey:@"time_end"];
        }
        
        
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:self.rule.rule_name forKey:@"rule_name"];
        [params setObject:[self.rule.rule_config objectForKey:@"time_start"] forKey:@"time_start"];
        [params setObject:[self.rule.rule_config objectForKey:@"time_end"]  forKey:@"time_end"];
        [params setObject:[self.rule.rule_config objectForKey:@"is_monday"]  forKey:@"is_monday"];
        [params setObject:[self.rule.rule_config objectForKey:@"is_tuesday"]  forKey:@"is_tuesday"];
        [params setObject:[self.rule.rule_config objectForKey:@"is_wednesday"]  forKey:@"is_wednesday"];
        [params setObject:[self.rule.rule_config objectForKey:@"is_thursday"]  forKey:@"is_thursday"];
        [params setObject:[self.rule.rule_config objectForKey:@"is_friday"]  forKey:@"is_friday"];
        [params setObject:[self.rule.rule_config objectForKey:@"is_saturday"]  forKey:@"is_saturday"];
        [params setObject:[self.rule.rule_config objectForKey:@"is_sunday"]  forKey:@"is_sunday"];
        [params setObject:self.rule.is_active  forKey:@"is_active"];
        [params setObject:@"updateAppRule" forKey:@"type"];
        
        self.rule.restriction = [NSMutableDictionary dictionary];
        [self.rule.restriction setObject:is_Safari? @"1":@"0" forKey:@"safari"];
        [self.rule.restriction setObject:is_Camera? @"1":@"0" forKey:@"camera"];
        [self.rule.restriction setObject:is_Siri? @"1":@"0" forKey:@"siri"];
        [self.rule.restriction setObject:is_iTunes? @"1":@"0" forKey:@"itunesStore"];
        [self.rule.restriction setObject:is_installinApps? @"1":@"0" forKey:@"installingApps"];
        [self.rule.restriction setObject:is_inappPurchases? @"1":@"0" forKey:@"inappPurchases"];
        [self.rule.restriction setObject:is_otherApps? @"1":@"0" forKey:@"externalApps"];
        
        [params setObject:self.rule.restriction  forKey:@"rules"];

            if([[params valueForKey:@"is_tuesday"] integerValue] == 1 || [[params valueForKey:@"is_tuesday"] integerValue] == 1  || [[params valueForKey:@"is_wednesday"] integerValue] == 1  || [[params valueForKey:@"is_thursday"] integerValue] == 1 ||[[params valueForKey:@"is_friday"]integerValue] == 1 || [[params valueForKey:@"is_saturday"]integerValue] == 1 || [[params valueForKey:@"is_sunday"] integerValue] == 1 ){
        
        
       // NSString  *url = [NSString stringWithFormat:@"%@/v2/ftd/settings/ios/autoappblocker/rule/%ld/%@",kBasUrl,(long)delegate.selectedDashboardChild.child_id,self.rule.id];
                [SwiftFTUtils showHUDAddedTo:self.view withText:@"Updating..." animated:YES];
        NSString  *url = [NSString stringWithFormat:@"%@/dashboard/settings/ios/lst/applock/rule/%ld/%@",kBasUrlNew_mesh2,(long)delegate.selectedDashboardChild.child_id,self.rule.id];
        
        NSError *error;
        NSData * jsonData  = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
        NSString *myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        
        /*
         
         
         
        [JSONHTTPClient patchJSONFromURLWithString:url
                                            bodyString:myString
                                        completion:^(id json, JSONModelError *err) {
                                            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                                            //NSError *error;
                                            // read response code
                                            if([[json valueForKey:@"status_code"] intValue]== 200)
                                            {
                                                NSLog(@"%@",json);
                                                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

                                                [SwiftFTUtils showSyncSettingsPopupWith:self];

                                            }
                                            else
                                                [CommonModel showAlert:[@"Error!" myModification] msg:[json valueForKey:@"status_message"]];
                                            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                            [self.navigationController popViewControllerAnimated:YES];
                                        }];
        
        */
        
        //---NATIVE API CALLING---//
        
        [[ApiManager shared] mesh_patch_withJson_ApiWithParamString:myString withApi:url withResponse:^(NSDictionary * _Nonnull json, NSInteger errorCode, NSString * _Nonnull message) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSLog(@"Patch native api call response = %@", json);
                
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                
                if([[json valueForKey:@"status"] intValue]== 200)
                {
                    NSLog(@"%@",json);
                    
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    [SwiftFTUtils showSyncSettingsPopupWith:self];
                    
                }
                else
                    [CommonModel showAlert:[@"Error!" myModification] msg:[json valueForKey:@"message"]];
                
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }];
            }else{
                
                [CommonModel showAlert:@"Error!".myModification msg:@"Please select atleast one day of a week".myModification];
            }
            
        }
        
    }
    else
    {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        self.sunday_Day = [prefs stringForKey:@"sunday_day"];
        self.monday_Day = [prefs stringForKey:@"monday_day"];
        self.tuesday_Day = [prefs stringForKey:@"tuesday_day"];
        self.wednesday_Day = [prefs stringForKey:@"wednesday_day"];
        self.thursday_Day = [prefs stringForKey:@"thursday_day"];
        self.friday_Day = [prefs stringForKey:@"friday_day"];
        self.saturday_Day = [prefs stringForKey:@"saturday_day"];
        
        
        NSLog(@"%@", self.monday_Day);
        
        NSString *startTime = @"";
        NSString *endTimeTime = @"";
        //start time
        {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"HH:mm"];
            //[formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
         startTime = [formatter stringFromDate:self.startTimePicker.date];
            //self.rule.time_start = startTime;
            [self.rule.rule_config setObject:startTime forKey:@"time_start"];
        }
        
        //end time
        {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"HH:mm"];
            //[formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
            endTimeTime = [formatter stringFromDate:self.endTimePicker.date];
            //self.rule.time_end = endTimeTime;
            [self.rule.rule_config setObject:endTimeTime forKey:@"time_end"];
        }
        self.rule.rule_name = self.nameField.text;
        
        if(self.nameField.text.length == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[@"Enter Rule Name" myModification] message:[@"Please provide rule name" myModification] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            
            if([self.monday_Day  isEqual: @"1"] || [self.tuesday_Day  isEqual: @"1"] || [self.wednesday_Day  isEqual: @"1"] || [self.thursday_Day  isEqual: @"1"] || [self.friday_Day  isEqual: @"1"] || [self.saturday_Day  isEqual: @"1"] || [self.sunday_Day  isEqual: @"1"]){
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setObject:self.rule.rule_name forKey:@"rule_name"];
            [params setObject:startTime forKey:@"time_start"];
            [params setObject:endTimeTime  forKey:@"time_end"];
            [params setObject:self.monday_Day  forKey:@"is_monday"];
            [params setObject:self.tuesday_Day   forKey:@"is_tuesday"];
            [params setObject:self.wednesday_Day   forKey:@"is_wednesday"];
            [params setObject:self.thursday_Day  forKey:@"is_thursday"];
            [params setObject:self.friday_Day  forKey:@"is_friday"];
            [params setObject:self.saturday_Day  forKey:@"is_saturday"];
            [params setObject:self.sunday_Day   forKey:@"is_sunday"];
            [params setObject:self.rule.is_active  forKey:@"is_active"];
            
            self.rule.restriction = [NSMutableDictionary dictionary];
            [self.rule.restriction setObject:is_Safari? @"1":@"0" forKey:@"safari"];
            [self.rule.restriction setObject:is_Camera? @"1":@"0" forKey:@"camera"];
            [self.rule.restriction setObject:is_Siri? @"1":@"0" forKey:@"siri"];
            [self.rule.restriction setObject:is_iTunes? @"1":@"0" forKey:@"itunesStore"];
            [self.rule.restriction setObject:is_installinApps? @"1":@"0" forKey:@"installingApps"];
            [self.rule.restriction setObject:is_inappPurchases? @"1":@"0" forKey:@"inappPurchases"];
            [self.rule.restriction setObject:is_otherApps? @"1":@"0" forKey:@"externalApps"];
            
            [params setObject:self.rule.restriction  forKey:@"rules"];
            
            //NSString *url = [NSString stringWithFormat:@"%@/v2/ftd/settings/ios/autoappblocker/rule/%ld",kBasUrl,(long)delegate.selectedDashboardChild.child_id];
            NSString *url = [NSString stringWithFormat:@"%@/dashboard/settings/ios/lst/applock/rule/%ld",kBasUrlNew_mesh2,(long)delegate.selectedDashboardChild.child_id];
            
            NSError *error;
            NSData * jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
            NSString *myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
            
            
            /*
            
            [JSONHTTPClient postJSONFromURLWithString:url bodyString:myString completion:^(id json, JSONModelError *err) {
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                if([[json valueForKey:@"status_code"] intValue]== 200)
                {
                    NSLog(@"%@",json);
//                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                    [self viewWillAppear:YES];
                    [SwiftFTUtils showSyncSettingsPopupWith:self];

                }
                else
                    [CommonModel showAlert:@"Error!" msg:[json valueForKey:@"status_message"]];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
            
            */
            
            //---NATIVE API CALLING---//
            
            [[ApiManager shared] mesh_postApiWithParamString:myString withApi:url withResponse:^(NSDictionary * _Nonnull json, NSInteger errorCode, NSString * _Nonnull message) {
              
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                    
                    
                    NSLog(@"mesh api ios new rule add response = %@", json);
                    
                    if([[json valueForKey:@"status"] intValue]== 200)
                    {
                        NSLog(@"%@",json);
                       
                        [SwiftFTUtils showSyncSettingsPopupWith:self];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    else
                        [CommonModel showAlert:@"Error!" msg:[json valueForKey:@"message"]];
                    
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    [self.navigationController popViewControllerAnimated:YES];
                });
                
            }];
            
            
        }else{
            
            [CommonModel showAlert:@"Error!".myModification msg:@"Please select atleast one day of a week".myModification];
        }
        
        }
    }
    
}

- (void)handleDelete:(UIButton *)sender
{
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"Delete Rule" message:@"Do you want to delete rule?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    alertview.tag = sender.tag;
    [alertview show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
        return;
    
    [SwiftFTUtils showHUDAddedTo:self.view withText:@"Deleting..." animated:YES];
    //NSString *url = [NSString stringWithFormat:@"%@/v2/ftd/settings/ios/autoappblocker/rule/%ld/%@",kBasUrl,(long)delegate.selectedDashboardChild.child_id,self.rule.id];
    
    NSString *url = [NSString stringWithFormat:@"%@/dashboard/settings/ios/lst/applock/rule/%ld/%@",kBasUrlNew_mesh2,(long)delegate.selectedDashboardChild.child_id,self.rule.id];
    /*
     
    [JSONHTTPClient deleteJSONFromURLWithString:url
                                       params:nil
                                   completion:^(id json, JSONModelError *err) {
                                       //NSError *error;
                                       // read response code
                                       if([[json valueForKey:@"status_code"] integerValue] == 200)
                                       {
                                           NSLog(@"%@",json);
                                       }
                                       else
                                           [CommonModel showAlert:@"Error!" msg:[json valueForKey:@"status_message"]];
                                       [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                       [self.navigationController popViewControllerAnimated:YES];
                                   }];
    
     */
    
    //---NATIVE API CALLING---//
    
    [[ApiManager shared] mesh_deleteApiWithApi:url withResponse:^(NSDictionary * _Nonnull json, NSInteger errorCode, NSString * _Nonnull message) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            NSLog(@"delete ios child rule native api response = %@", json);
            
            if([[json valueForKey:@"status"] integerValue] != 200)
                [CommonModel showAlert:@"Error!" msg:[json valueForKey:@"message"]];
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self.navigationController popViewControllerAnimated:YES];
            
        });
        
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    self.rule.rule_name = textField.text;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.rule.rule_name = textField.text;
}

@end
