//
//  LimitScreenCell.m
//  FamilyTime - Dashboard
//
//  Created by Muhammad Ajmal on 04/08/2016.
//  Copyright © 2016 SoraCode. All rights reserved.
//

#import "LimitScreenCell.h"
#import "FTUtils.h"
#import "UIView+VTSelectiveBorder.h"
#import "NSString+LockMustafa.h"
#import "CommonModel.h"
#import "FamilyTime-Swift.h"

@interface LimitScreenCell ()
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *weekdaysLabel;
//@property (nonatomic, strong) UIImageView *refreshImage;
@property (nonatomic, strong) UIView *borderView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *titleImage;
@property (nonatomic, strong) UILabel *timeLabel1;
@property (nonatomic, strong) UILabel *startPm;
@property (nonatomic, strong) UILabel *endPm;
@property (nonatomic, strong) UIButton *optionButton;
@end

@implementation LimitScreenCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.tintColor = [UIColor redColor];
        
        self.title = [[UILabel alloc] initWithFrame:CGRectZero];
        self.title.backgroundColor = [UIColor clearColor];
        self.title.textColor = [UIColor lightGrayColor];
        self.title.textAlignment = NSTextAlignmentLeft;
        
        self.title.text=[self.title.text myModification];
        
        [self.contentView addSubview:self.title];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.timeLabel.backgroundColor = [UIColor clearColor];
        self.timeLabel.textColor = [UIColor lightGrayColor];
        self.timeLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.timeLabel];
        
        self.timeLabel1 = [[UILabel alloc] initWithFrame:CGRectZero];
        self.timeLabel1.backgroundColor = [UIColor clearColor];
        self.timeLabel1.textColor = [UIColor lightGrayColor];
        self.timeLabel1.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.timeLabel1];
        
        self.startPm = [[UILabel alloc] initWithFrame:CGRectZero];
        self.startPm.backgroundColor = [UIColor clearColor];
        self.startPm.textColor = [UIColor lightGrayColor];
        self.startPm.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.startPm];
        
        self.endPm = [[UILabel alloc] initWithFrame:CGRectZero];
        self.endPm.backgroundColor = [UIColor clearColor];
        self.endPm.textColor = [UIColor lightGrayColor];
        self.endPm.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.endPm];
        
        self.weekdaysLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.weekdaysLabel.backgroundColor  = [UIColor clearColor];
        self.weekdaysLabel.textColor        = [UIColor lightGrayColor];
        self.weekdaysLabel.textAlignment    = NSTextAlignmentLeft;
        [self.contentView addSubview:self.weekdaysLabel];
        
        self.titleImage       = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.titleImage.image = [UIImage imageNamed:@"st_book_blue"];
        [self.contentView addSubview:self.titleImage];
        
        self.optionButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [self.optionButton setImage:[UIImage imageNamed:@"menu_grey"] forState:normal];
        [self.optionButton addTarget:self action:@selector(handleMenuList:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.optionButton];
        
        self.selectiveBorderFlag   = AUISelectiveBordersFlagRight;
        self.selectiveBordersColor = [UIColor lightGrayColor];
        self.selectiveBordersWidth = 1.0;
        
        self.borderView = [[UIView alloc] initWithFrame:CGRectZero];
        self.borderView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5f];
        [self addSubview:self.borderView];
        
        self.switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
        self.switchView.onTintColor = RGBCOLOR(24, 167, 225, 1);
        //self.accessoryView = self.switchView;
        self.switchView.backgroundColor = UIColor.clearColor;
        [self.switchView addTarget:self action:@selector(handleStatusChange:) forControlEvents:UIControlEventValueChanged];
        [self.optionButton addTarget:self action:@selector(handleMenuList:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.switchView];
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if([SwiftFTUtils isDeviceiPhoneFamily])
    {
        self.contentView.backgroundColor = UIColor.whiteColor;
        self.contentView.frame = CGRectMake(10.0f, 10.0f, CGRectGetWidth(self.bounds) - 20.0f, CGRectGetHeight(self.bounds) - 10.0f);
        
        self.title.font = [UIFont fontWithName:@"OpenSans" size:17];
        self.timeLabel.font = [UIFont fontWithName:@"OpenSans" size:25];
        self.weekdaysLabel.font = [UIFont fontWithName:@"OpenSans" size:14];
        
        self.timeLabel1.font = [UIFont fontWithName:@"OpenSans" size:25];
        self.startPm.font = [UIFont fontWithName:@"OpenSans" size:13];
        self.endPm.font = [UIFont fontWithName:@"OpenSans" size:13];
        
        self.titleImage.frame = CGRectMake(15.0f, 15.0f, 35.0f, 35.0f);
        
        self.title.frame = CGRectMake(60.0f, 20.5f, CGRectGetWidth(self.contentView.bounds) - 20.0f, 25.0f);
        self.optionButton.frame = CGRectMake(CGRectGetMaxX(self.contentView.frame) - 40.0f , 20.5f, 25.0f, 27.0f);
        self.borderView.frame = CGRectMake(10.0f, 70.0f, CGRectGetWidth(self.contentView.bounds), 1.0f);
        self.switchView.frame = CGRectMake(CGRectGetMaxX(self.borderView.frame) - 65.0f, CGRectGetMaxY(self.borderView.frame) + 20.0f, 51, 46);
        self.timeLabel.frame = CGRectMake(15.0f, CGRectGetMaxY(self.borderView.frame) + 10.0f, 64.0f, 30.0f);
        self.weekdaysLabel.frame = CGRectMake(15.0f, CGRectGetMaxY(self.timeLabel.frame) + 10.0f, 200, 15.0f);
        self.startPm.frame = CGRectMake(80.0f, CGRectGetMaxY(self.borderView.frame) + 8.0f, 22.0f, 20.0f);
        self.timeLabel1.frame = CGRectMake(113.0f, CGRectGetMaxY(self.borderView.frame) + 10.0f, 96.0f, 30.0f);
        self.endPm.frame = CGRectMake(205.0f, CGRectGetMaxY(self.borderView.frame) + 8.0f, 26.0f, 15.0f);
//      self.refreshImage.frame = CGRectMake(CGRectGetMaxX(self.weekdaysLabel.frame), CGRectGetMinY(self.weekdaysLabel.frame), 16, 16);
    }
    else
    {
        self.title.font = [UIFont fontWithName:@"OpenSans" size:20];
        self.timeLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:17];
        self.weekdaysLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:17];

        self.title.frame = CGRectMake(20.0f, 5.0f, CGRectGetWidth(self.contentView.bounds) - 40.0f, 30.0f);
        self.timeLabel.frame = CGRectMake(20.0f, CGRectGetMaxY(self.title.frame), 64.0f, 25.0f);

        self.weekdaysLabel.frame = CGRectMake(20.0f, CGRectGetMaxY(self.timeLabel.frame), 135, 25.0f);
//        self.refreshImage.frame = CGRectMake(CGRectGetMaxX(self.weekdaysLabel.frame), CGRectGetMinY(self.weekdaysLabel.frame), 25, 25);
        self.borderView.frame = CGRectMake(0.0f, CGRectGetMaxY(self.bounds) - 1, CGRectGetWidth(self.bounds), 1.0f);
    }
}

- (void)setRule:(AccessControlRuleModel *)rule
{
    _rule = rule;
    self.title.text = _rule.rule_name;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"HH:mm:ss"];
    //[df setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    NSDate *start_date = [df dateFromString:[rule.rule_config objectForKey:@"time_start"]];
    NSDate *end_date = [df dateFromString:[rule.rule_config objectForKey:@"time_end"]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm"];
    //NSTimeZone *outputTimeZone1 = [NSTimeZone systemTimeZone];
    //[formatter setTimeZone:outputTimeZone1];
    NSString *startTime = [formatter stringFromDate:start_date];
    self.timeLabel.text = startTime;
    NSString *endTimeTime = [formatter stringFromDate:end_date];
    NSString *combined = [NSString stringWithFormat:@"%s%@", " -  ", endTimeTime];
    self.timeLabel1.text = combined;
    
    [formatter setDateFormat:@"a"];
    [formatter setAMSymbol:@"am"];
    [formatter setPMSymbol:@"pm"];
    NSString *startam = [formatter stringFromDate:start_date];
    self.startPm.text = startam;
    NSString *endam = [formatter stringFromDate:end_date];
    self.endPm.text = endam;
    
    
//    NSMutableAttributedString *finalStr1 = [[NSMutableAttributedString alloc] init];
//    NSMutableAttributedString *startMutable = [[NSMutableAttributedString alloc] initWithString:startTime];
//    [startMutable addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0,2)];
//
//    NSMutableAttributedString *endMutable = [[NSMutableAttributedString alloc] initWithString:endTimeTime];
//    [endMutable addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Light" size:13] range:NSMakeRange(endMutable.length-3,2)];
//
//    NSMutableAttributedString *dash = [[NSMutableAttributedString alloc] initWithString:@" - "];
//
//    [finalStr1 appendAttributedString:startMutable];
//    [finalStr1 appendAttributedString:dash];
//    [finalStr1 appendAttributedString:endMutable];
 //   self.timeLabel.attributedText = startMutable;
    if(startTime==[NSNull null])
    {
    self.timeLabel.text=@"";
    }
    NSMutableAttributedString *finalStr = [[NSMutableAttributedString alloc] init];
    //sunday
    NSMutableAttributedString *sunday = [[NSMutableAttributedString alloc] initWithString:@"SU  "];
    NSLog(@"%@", [rule.rule_config objectForKey:@"is_sunday"]);
    if([[rule.rule_config objectForKey:@"is_sunday"] integerValue] == 1 && [rule.is_active integerValue] == 1)
        [sunday addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(3, 169, 244, 1) range:NSMakeRange(0, sunday.length)];
    else
        [sunday addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, sunday.length)];
    [sunday addAttribute:NSFontAttributeName value:self.weekdaysLabel.font range:NSMakeRange(0, sunday.length)];
    [finalStr appendAttributedString:sunday];
    
    //monday
    NSMutableAttributedString *monday = [[NSMutableAttributedString alloc] initWithString:@"MO  "];
    if([[rule.rule_config objectForKey:@"is_monday"] integerValue] == 1 && [rule.is_active integerValue] == 1)
        [monday addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(3, 169, 244, 1) range:NSMakeRange(0, monday.length)];
    else
        [monday addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, monday.length)];
    [monday addAttribute:NSFontAttributeName value:self.weekdaysLabel.font range:NSMakeRange(0, monday.length)];
    [finalStr appendAttributedString:monday];
    
    //tuesdays
    NSMutableAttributedString *tuesday = [[NSMutableAttributedString alloc] initWithString:@"TU  "];
    if([[rule.rule_config objectForKey:@"is_tuesday"] integerValue] == 1 && [rule.is_active integerValue] == 1)
        [tuesday addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(3, 169, 244, 1) range:NSMakeRange(0, tuesday.length)];
    else
        [tuesday addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, tuesday.length)];
    [tuesday addAttribute:NSFontAttributeName value:self.weekdaysLabel.font range:NSMakeRange(0, tuesday.length)];
    [finalStr appendAttributedString:tuesday];
    
    //wednesday
    NSMutableAttributedString *wednesday = [[NSMutableAttributedString alloc] initWithString:@"WE  "];
    if([[rule.rule_config objectForKey:@"is_wednesday"] integerValue] == 1 && [rule.is_active integerValue] == 1)
        [wednesday addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(3, 169, 244, 1) range:NSMakeRange(0, wednesday.length)];
    else
        [wednesday addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, wednesday.length)];
    [wednesday addAttribute:NSFontAttributeName value:self.weekdaysLabel.font range:NSMakeRange(0, wednesday.length)];
    [finalStr appendAttributedString:wednesday];
    
    //thursday
    NSMutableAttributedString *thursday = [[NSMutableAttributedString alloc] initWithString:@"TH  "];
    if([[rule.rule_config objectForKey:@"is_thursday"] integerValue] == 1 && [rule.is_active integerValue] == 1)
        [thursday addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(3, 169, 244, 1) range:NSMakeRange(0, thursday.length)];
    else
        [thursday addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, thursday.length)];
    [thursday addAttribute:NSFontAttributeName value:self.weekdaysLabel.font range:NSMakeRange(0, thursday.length)];
    [finalStr appendAttributedString:thursday];
    
    //friday
    NSMutableAttributedString *friday = [[NSMutableAttributedString alloc] initWithString:@"FR  "];
    if([[rule.rule_config objectForKey:@"is_friday"] integerValue] == 1 && [rule.is_active integerValue] == 1)
        [friday addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(3, 169, 244, 1) range:NSMakeRange(0, friday.length)];
    else
        [friday addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, friday.length)];
    [friday addAttribute:NSFontAttributeName value:self.weekdaysLabel.font range:NSMakeRange(0, friday.length)];
    [finalStr appendAttributedString:friday];
    
    //saturday
    NSMutableAttributedString *saturday = [[NSMutableAttributedString alloc] initWithString:@"SA"];
    if([[rule.rule_config objectForKey:@"is_saturday"] integerValue] == 1 && [rule.is_active integerValue] == 1)
        [saturday addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(3, 169, 244, 1) range:NSMakeRange(0, saturday.length)];
    else
        [saturday addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, saturday.length)];
    [saturday addAttribute:NSFontAttributeName value:self.weekdaysLabel.font range:NSMakeRange(0, saturday.length)];
    [finalStr appendAttributedString:saturday];
    self.weekdaysLabel.attributedText = finalStr;
    
    if([rule.is_active integerValue] == 1)
    {
        self.switchView.on = YES;
        self.title.textColor = RGBCOLOR(3, 169, 244, 1);
        self.timeLabel1.textColor = RGBCOLOR(96, 96, 96, 1);
        self.timeLabel.textColor = RGBCOLOR(96, 96, 96, 1);
        self.startPm.textColor = RGBCOLOR(96, 96, 96, 1);
        self.endPm.textColor = RGBCOLOR(96, 96, 96, 1);
    }
    else
    {
        self.switchView.on = NO;
        self.title.textColor = UIColor.lightGrayColor;
        self.timeLabel1.textColor = UIColor.lightGrayColor;
        self.timeLabel.textColor = UIColor.lightGrayColor;
        self.startPm.textColor = UIColor.lightGrayColor;
        self.endPm.textColor = UIColor.lightGrayColor;
    }
    
    _titleImage.image = [CommonModel newImageForHeaderSST:rule.rule_name isRuleActive:_switchView.isOn];
}

- (void)handleStatusChange:(UISwitch *)switchView
{
    if([self.delegate respondsToSelector:@selector(didRuleStatusChanged:indexPath:)])
        [self.delegate didRuleStatusChanged:switchView.isOn indexPath:self.indexPath];
    
}

- (void)handleMenuList:(UIButton *)sender
{
    NSLog(@"Menu button was tapped");
    if([self.delegate respondsToSelector:@selector(didOptionButtonTapped:)])
        [self.delegate didOptionButtonTapped:self.indexPath];
    

    
}

@end

