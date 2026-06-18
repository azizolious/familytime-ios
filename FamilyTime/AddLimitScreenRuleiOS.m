//
//  AddLimitScreenRuleiOS.m
//  FamilyTime
//
//  Created by Rao Mudassar Khalil on 05/07/2021.
//  Copyright © 2021 YumyApps. All rights reserved.
//

#import "AddLimitScreenRuleiOS.h"
#import "AppDelegate.h"
#import "FTUtils.h"
#import "MBProgressHUD.h"
//#import "JSONHTTPClient.h"
#import "LeftSidesTableViewCell.h"
#import "NSString+LockMustafa.h"
#import "FamilyTime-Swift.h"

AppDelegate *delegate;

@interface LimitScreenRuleStatusView1 : UIView
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UISwitch *statusSwitch;
@end

@implementation LimitScreenRuleStatusView1
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

@interface LimitScreenPickerHeaderView1 : UIView
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;
@end

@implementation LimitScreenPickerHeaderView1
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


@interface LimitScreenWeekDaysView1 : UIView
@property (nonatomic, strong) UIButton *mondayButton;
@property (nonatomic, strong) UIButton *tuesdayButton;
@property (nonatomic, strong) UIButton *wednesdayButton;
@property (nonatomic, strong) UIButton *thursdayButton;
@property (nonatomic, strong) UIButton *fridayButton;
@property (nonatomic, strong) UIButton *saturdayButton;
@property (nonatomic, strong) UIButton *sundayButton;
@property (nonatomic, strong) RuleModel *rule;


//---INTERNET SCHEDULE---//
//@property (nonatomic, strong) AccessControlRuleModel *internetSchedule;

@end

@implementation LimitScreenWeekDaysView1
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

- (void)setRule:(RuleModel *)rule
{
    
        
        _rule = rule;
    NSLog(@"%@", self.rule.on_tuesday);
    [self applyRuleOnButton:self.sundayButton isOn:([rule.on_sunday  isEqual: @"1"])];
    [self applyRuleOnButton:self.mondayButton isOn:([rule.on_monday  isEqual: @"1"])];
    [self applyRuleOnButton:self.tuesdayButton isOn:([rule.on_tuesday  isEqual: @"1"])];
    [self applyRuleOnButton:self.wednesdayButton isOn:([rule.on_wednesday  isEqual: @"1"])];
    [self applyRuleOnButton:self.thursdayButton isOn:([rule.on_thursday  isEqual: @"1"])];
    [self applyRuleOnButton:self.fridayButton isOn:([rule.on_friday  isEqual: @"1"])];
    [self applyRuleOnButton:self.saturdayButton isOn:([rule.on_saturday  isEqual: @"1"])];
    
    self.rule.on_sunday = rule.on_sunday;
    self.rule.on_monday = rule.on_monday;
    self.rule.on_tuesday = rule.on_tuesday;
    self.rule.on_wednesday = rule.on_wednesday;
    self.rule.on_thursday = rule.on_thursday;
    self.rule.on_friday = rule.on_friday;
    self.rule.on_saturday = rule.on_saturday;
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

        self.rule = [[RuleModel alloc] init];

    }
    
    NSLog(@"%@", self.rule);
//
    NSUserDefaults *data = [NSUserDefaults standardUserDefaults];
    
    if(button.tag == 101)//sunday
    {
        NSLog(@"%@", self.rule.on_sunday);
        
        if([self.rule.on_sunday isEqual: @"1"]){
            self.rule.on_sunday = @"0";
            //[data setValue:@"0" forKey:@"sunday_day"];
           // _rule.on_sunday = @"0";
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            button.layer.borderColor = [UIColor lightGrayColor].CGColor;
            button.layer.backgroundColor = UIColor.clearColor.CGColor;
        }
        else{
            self.rule.on_sunday = @"1";
           // [data setValue:@"1" forKey:@"sunday_day"];
           // _rule.on_sunday = @"1";
            [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
            button.layer.borderColor = RGBCOLOR(16, 132, 180, 1).CGColor;
            button.layer.backgroundColor = RGBCOLOR(16, 132, 180, 1).CGColor;
       // [self applyRuleOnButton:self.sundayButton isOn:([self.rule.is_sunday integerValue] == 1)];
        }
    }
    else if(button.tag == 102)//monday
    {
        if([self.rule.on_monday  isEqual: @"1"]){
           self.rule.on_monday = @"0";
            [data setValue:@"0" forKey:@"monday_day"];
            _rule.on_monday = @"0";
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            button.layer.borderColor = [UIColor lightGrayColor].CGColor;
            button.layer.backgroundColor = UIColor.clearColor.CGColor;
        }else{
           self.rule.on_monday = @"1";
            [data setValue:@"1" forKey:@"monday_day"];
            _rule.on_monday = @"1";
            [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
            button.layer.borderColor = RGBCOLOR(16, 132, 180, 1).CGColor;
            button.layer.backgroundColor = RGBCOLOR(16, 132, 180, 1).CGColor;
        //[self applyRuleOnButton:self.mondayButton isOn:([self.rule.is_monday integerValue] == 1)];
        }
    }
    else if(button.tag == 103)//tuesday
    {
        if([self.rule.on_tuesday isEqual: @"1"]){
            self.rule.on_tuesday = @"0";
            [data setValue:@"0" forKey:@"tuesday_day"];
            _rule.on_tuesday = @"0";
        
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            button.layer.borderColor = [UIColor lightGrayColor].CGColor;
            button.layer.backgroundColor = UIColor.clearColor.CGColor;
        }else{
            self.rule.on_tuesday = @"1";
            _rule.on_tuesday = @"1";
            [data setValue:@"1" forKey:@"tuesday_day"];
            [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
            button.layer.borderColor = RGBCOLOR(16, 132, 180, 1).CGColor;
            button.layer.backgroundColor = RGBCOLOR(16, 132, 180, 1).CGColor;
        //[self applyRuleOnButton:self.tuesdayButton isOn:([self.rule.is_tuesday integerValue] == 1)];
        }
    }
    else if(button.tag == 104)//wednesday
    {
        if([self.rule.on_wednesday isEqual: @"1"]){
            self.rule.on_wednesday = @"0";
            _rule.on_wednesday = @"0";
            [data setValue:@"0" forKey:@"wednesday_day"];
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            button.layer.borderColor = [UIColor lightGrayColor].CGColor;
            button.layer.backgroundColor = UIColor.clearColor.CGColor;
        }else{
           self.rule.on_wednesday = @"1";
            _rule.on_wednesday=@"1";
            [data setValue:@"1" forKey:@"wednesday_day"];
            [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
            button.layer.borderColor = RGBCOLOR(16, 132, 180, 1).CGColor;
            button.layer.backgroundColor = RGBCOLOR(16, 132, 180, 1).CGColor;
        //[self applyRuleOnButton:self.wednesdayButton isOn:([self.rule.is_wednesday integerValue] == 1)];
        }
    }
    else if(button.tag == 105)//thursday
    {
        if([self.rule.on_thursday isEqual: @"1"]){
            self.rule.on_thursday = @"0";
            _rule.on_thursday=@"0";
            [data setValue:@"0" forKey:@"thursday_day"];
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            button.layer.borderColor = [UIColor lightGrayColor].CGColor;
            button.layer.backgroundColor = UIColor.clearColor.CGColor;
        }else{
            self.rule.on_thursday = @"1";
            _rule.on_thursday = @"1";
            [data setValue:@"1" forKey:@"thursday_day"];
            [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
            button.layer.borderColor = RGBCOLOR(16, 132, 180, 1).CGColor;
            button.layer.backgroundColor = RGBCOLOR(16, 132, 180, 1).CGColor;
        //[self applyRuleOnButton:self.thursdayButton isOn:([self.rule.is_thursday integerValue] == 1)];
        }
    }
    else if(button.tag == 106)//friday
    {
        if([self.rule.on_friday isEqual: @"1"]){
            self.rule.on_friday = @"0";
            _rule.on_friday = @"0";
            [data setValue:@"0" forKey:@"friday_day"];
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            button.layer.borderColor = [UIColor lightGrayColor].CGColor;
            button.layer.backgroundColor = UIColor.clearColor.CGColor;
        }else{
            self.rule.on_friday = @"1";
            _rule.on_friday = @"1";
            [data setValue:@"1" forKey:@"friday_day"];
            [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
            button.layer.borderColor = RGBCOLOR(16, 132, 180, 1).CGColor;
            button.layer.backgroundColor = RGBCOLOR(16, 132, 180, 1).CGColor;
        //[self applyRuleOnButton:self.fridayButton isOn:([self.rule.is_friday integerValue] == 1)];
        }
    }
    else if(button.tag == 107)//saturday
    {
        if([self.rule.on_saturday isEqual: @"1"]){
           self.rule.on_saturday = @"0";
            _rule.on_saturday = @"0";
            [data setValue:@"0" forKey:@"saturday_day"];
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            button.layer.borderColor = [UIColor lightGrayColor].CGColor;
            button.layer.backgroundColor = UIColor.clearColor.CGColor;
        }else{
            self.rule.on_saturday = @"1";
            _rule.on_saturday = @"1";
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

@interface AddLimitScreenRuleiOS ()<UITextFieldDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) LimitScreenRuleStatusView1 *statusView;
@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) LimitScreenPickerHeaderView1 *firstHeaderView;
@property (nonatomic, strong) LimitScreenPickerHeaderView1 *secondHeaderView;
@property (nonatomic, strong) LimitScreenPickerHeaderView1 *repeatHeaderView;
@property (nonatomic, strong) LimitScreenWeekDaysView1 *weekDaysView;
@property (nonatomic, strong) UIDatePicker *startTimePicker;
@property (nonatomic, strong) UIDatePicker *endTimePicker;

@property (nonatomic, strong) NSArray *hours;
@property (nonatomic, strong) NSMutableArray *minutes;
@end

@implementation AddLimitScreenRuleiOS

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSUserDefaults standardUserDefaults]setObject:@"NO"  forKey:@"gobacknow"];
    [[NSUserDefaults standardUserDefaults]synchronize];

    
    self.view.backgroundColor = [UIColor whiteColor];
    delegate = [AppDelegate appDelegate];
    
    self.hours = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
    self.minutes = [NSMutableArray array];

    for (NSInteger index = 0; index < 60; index++)
    {
        [self.minutes addObject:[NSString stringWithFormat:@"%02ld",(long)index]];
    }
    if(self.isNew)
    {
        self.rule = [[RuleModel alloc] init];
        self.rule.child_id = [[NSNumber numberWithInteger:delegate.selectedDashboardChild.child_id] stringValue];
        self.rule.rule_name = @"";
        self.rule.time_start = @"";
        self.rule.time_end = @"";
        self.rule.on_sunday = @"0";
        self.rule.on_monday = @"0";
        self.rule.on_tuesday = @"0";
        self.rule.on_wednesday = @"0";
        self.rule.on_thursday = @"0";
        self.rule.on_friday = @"0";
        self.rule.on_saturday = @"0";
        self.rule.rule_type = @"timebased";
        self.rule.rule_function = @"phonelock";
        NSUserDefaults *data = [NSUserDefaults standardUserDefaults];
        [data setValue:@"0" forKey:@"monday_day"];
        [data setValue:@"0" forKey:@"tuesday_day"];
        [data setValue:@"0" forKey:@"wednesday_day"];
        [data setValue:@"0" forKey:@"thursday_day"];
        [data setValue:@"0" forKey:@"friday_day"];
        [data setValue:@"0" forKey:@"saturday_day"];
        [data setValue:@"0" forKey:@"sunday_day"];
        self.rule.is_active = @"0";
    }
    
    
    [self setupUI];

}

- (void)setupUI
{
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

    self.statusView = [[LimitScreenRuleStatusView1 alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.bounds), statusViewHeight)];
    [self.scrollView addSubview:self.statusView];
    self.statusView.statusSwitch.transform = CGAffineTransformMakeScale(switchViewSclaeFactor, switchViewSclaeFactor);
    self.statusView.statusLabel.text = ([self.rule.is_active integerValue] == 1) ? [@"Enable" myModification] : [@"Disable" myModification];
    self.statusView.imageView.image = [CommonModel imageForHeaderSST:self.rule.rule_name]; // [self imageForHeader:self.rule];
    self.statusView.statusSwitch.on = ([self.rule.is_active integerValue] == 1) ? YES : NO;
    [self.statusView.statusSwitch addTarget:self action:@selector(handleStatusSwitch:) forControlEvents:UIControlEventValueChanged];

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
        self.firstHeaderView = [[LimitScreenPickerHeaderView1 alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.nameField.frame) + verticalMargin, CGRectGetWidth(self.view.bounds), headerViewHeight)];
        [self.scrollView addSubview:self.firstHeaderView];
    }
    else
    {
        self.firstHeaderView = [[LimitScreenPickerHeaderView1 alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.statusView.frame) + verticalMargin, CGRectGetWidth(self.view.bounds), headerViewHeight)];
        [self.scrollView addSubview:self.firstHeaderView];
    }
    self.firstHeaderView.imageView.image = [UIImage imageNamed:@"ic_clock"];
    self.firstHeaderView.label.text = [@"Start Time" myModification];
 
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
    
    if(!self.isNew)
    {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"HH:mm:ss"];
//        //[df setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
//        self.rule.is_sunday = @"1";
//        [data setValue:@"1" forKey:@"sunday_day"];
//        [_rule.rule_config setObject:@"1" forKey:@"is_sunday"];
//        [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
//        button.layer.borderColor = RGBCOLOR(16, 132, 180, 1).CGColor;
//        button.layer.backgroundColor = RGBCOLOR(16, 132, 180, 1).CGColor;
        
        NSDate *start_date = [df dateFromString:self.rule.time_start];
        if(start_date!=nil)
        {
        [self.startTimePicker setDate:start_date];
        }
    }
    
    self.secondHeaderView = [[LimitScreenPickerHeaderView1 alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.startTimePicker.frame) + verticalMargin, CGRectGetWidth(self.view.bounds), headerViewHeight)];
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
    self.endTimePicker.datePickerMode = UIDatePickerModeTime;
    [self.endTimePicker setValue:RGBCOLOR(16, 132, 180, 1) forKey:@"textColor"];
    [self.scrollView addSubview:self.endTimePicker];
    if(!self.isNew)
    {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"HH:mm:ss"];
        //[df setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        NSDate *end_date = [df dateFromString:self.rule.time_end];
        [self.endTimePicker setDate:end_date];
    }
    
    self.repeatHeaderView = [[LimitScreenPickerHeaderView1 alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.endTimePicker.frame) + verticalMargin, CGRectGetWidth(self.view.bounds), headerViewHeight)];
    [self.scrollView addSubview:self.repeatHeaderView];
    self.repeatHeaderView.imageView.image = [UIImage imageNamed:@"blue_refresh"];
    self.repeatHeaderView.label.text = [@"Repeat" myModification];
    
    self.weekDaysView = [[LimitScreenWeekDaysView1 alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.repeatHeaderView.frame), CGRectGetWidth(self.view.bounds), weekdaysViewHeight)];
    [self.scrollView addSubview:self.weekDaysView];
    self.weekDaysView.rule = self.rule;

    if(![self.rule.is_predefined integerValue] && !self.isNew)
    {
        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteButton setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        deleteButton.frame = CGRectMake(15.0f, CGRectGetMaxY(self.weekDaysView.frame) + 10, 30, 30);
        [deleteButton addTarget:self action:@selector(handleDelete:) forControlEvents:UIControlEventTouchUpInside];
        deleteButton.tag = [self.rule.rule_id integerValue];
        [self.scrollView addSubview:deleteButton];
        
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds), CGRectGetMaxY(deleteButton.frame) + 10+70);
    }
    else
    {
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds), CGRectGetMaxY(self.weekDaysView.frame) + 10+70);
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

//    [self setupUI];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(handleSave:)];

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
            self.rule.time_start=startTime;
        }

        //end time
        {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"HH:mm"];
            //[formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
            NSString *endTimeTime = [formatter stringFromDate:self.endTimePicker.date];
           // self.rule.time_end    = endTimeTime;
            self.rule.time_end=endTimeTime;
        }
            NSString *ruleNew = @"";
            
            if (!_isNew){
                ruleNew = self.rule.rule_id;
            }
            
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:self.rule.rule_name forKey:@"rule_name"];
        [params setObject:self.rule.time_start forKey:@"time_start"];
        [params setObject:self.rule.time_end forKey:@"time_end"];
        [params setObject:self.rule.on_monday  forKey:@"on_monday"];
        [params setObject:self.rule.on_tuesday forKey:@"on_tuesday"];
        [params setObject:self.rule.on_wednesday forKey:@"on_wednesday"];
        [params setObject:self.rule.on_thursday forKey:@"on_thursday"];
        [params setObject:self.rule.on_friday forKey:@"on_friday"];
        [params setObject:self.rule.on_saturday forKey:@"on_saturday"];
        [params setObject:self.rule.on_sunday forKey:@"on_sunday"];
        [params setObject:self.rule.is_active  forKey:@"is_active"];
        [params setObject:self.rule.rule_type forKey:@"rule_type"];
        [params setObject:self.rule.rule_function forKey:@"rule_function"];
        [params setObject:ruleNew forKey:@"id"];

            if([[[params valueForKey:@"on_monday"] stringValue]  isEqual: @"1"] || [[[params valueForKey:@"on_tuesday"] stringValue]  isEqual: @"1"]  || [[[params valueForKey:@"on_wednesday"] stringValue]  isEqual: @"1"]  || [[[params valueForKey:@"on_thursday"] stringValue]  isEqual: @"1"] ||[[[params valueForKey:@"on_friday"]stringValue]  isEqual: @"1"] || [[[params valueForKey:@"on_saturday"]stringValue]  isEqual: @"1"] || [[[params valueForKey:@"on_sunday"] stringValue]  isEqual: @"1"] ){

       // NSString  *url = [NSString stringWithFormat:@"%@/v2/ftd/settings/ios/autoappblocker/rule/%ld/%@",kBasUrl,(long)delegate.selectedDashboardChild.child_id,self.rule.id];
                [SwiftFTUtils showHUDAddedTo:self.view withText:@"Updating..." animated:YES];
        NSString  *url = [NSString stringWithFormat:@"%@/dashboard/settings/android/lst/screenlock/rules/%ld",kBasUrlNew_mesh2,(long)delegate.selectedDashboardChild.child_id];

        NSError *error;
        NSData * jsonData  = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
        NSString *myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"Put api URL = %@ and params = %@",url, myString);

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

                [[ApiManager shared] putApi:url params:params controller:self isContPresented:false withResponse:^(NSString * _Nonnull msg, NSInteger code) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                        [SwiftFTUtils hideHUDAddedTo:self.view animated:true];
                        
                        [self viewDidDisappear:YES];
                        
                        if (code == 200)
                        {
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"kRefreshRules" object:nil];
                        [self.navigationController popViewControllerAnimated:true];
                        
                            [CommonModel showAlert:@"Sync Settings" msg:msg];
                        }
                        else
                        {
                            [CommonModel showAlert:@"Error!" msg:msg];

                        [self.navigationController popViewControllerAnimated:true];
                        }
                    });
                }];
            }else{

                [CommonModel showAlert:@"Error!".myModification msg:@"Please select atleast one day of a week".myModification];
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

    NSString *url = [NSString stringWithFormat:@"%@/dashboard/settings/android/lst/screenlock/rules/%ld/%@",kBasUrlNew_mesh2,(long)delegate.selectedDashboardChild.child_id,self.rule.rule_id];
    NSLog(@"%@", url);
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
    
    [[ApiManager shared] deleteApiWithParams:@{} andUrl:url andController:self withResponse:^(NSString * _Nonnull message, NSInteger code){
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            NSLog(@"delete ios child rule native api response = %@", message);
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            if(code == 200)
                [self.navigationController popViewControllerAnimated:YES];
            else{
                [CommonModel showAlert:[@"Error!" myModification] msg:message];
                [self.navigationController popViewControllerAnimated:YES];
            }
            
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
