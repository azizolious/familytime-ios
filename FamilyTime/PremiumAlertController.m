//
//  PremiumAlertController.m
//  FamilyTime - Dashboard
//
//  Created by Muhammad Ajmal on 14/12/2015.
//  Copyright © 2015 SoraCode. All rights reserved.
//

#import "PremiumAlertController.h"
#import "FTUtils.h"
#import "CommonModel.h"
//#import <Google/Analytics.h>
#import "AppDelegate.h"
#import "NSString+LockMustafa.h"

//#import "UIViewController+BIZChildViewController.h"

@interface PremiumAlertController ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIButton *closeButton;
@end

@implementation PremiumAlertController

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
    [self setupUI];
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)setupUI
{
    self.imageView = [self setupImageView];
    [self.view addSubview:self.imageView];
    
    self.closeButton = [self setupCloseButton];
    [self.closeButton addTarget:self action:@selector(handleClose:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.closeButton];
    
    self.messageLabel = [self setupMessageLabel];
    [self.view addSubview:self.messageLabel];
}

- (void)handleClose:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.container dismissPopupViewControllerAnimated:YES];
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
    imageView.image = [UIImage imageNamed:self.imagename];
    return imageView;
}

- (UIButton *)setupCloseButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if(IS_IPHONE_4)
    {
        button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.view.bounds) - 40.0f, CGRectGetWidth(self.view.bounds), 40.0f);
        button.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:13];
    }
    else if(IS_IPHONE_5)
    {
        button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.view.bounds) - 40.0f, CGRectGetWidth(self.view.bounds), 40.0f);
        button.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:13];
    }
    else if(IS_IPHONE_6)
    {
        button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.view.bounds) - 46.0f, CGRectGetWidth(self.view.bounds), 46.0f);
        button.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:14];
    }
    else if(IS_IPHONE_6_PLUS)
    {
        button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.view.bounds) - 52.0f, CGRectGetWidth(self.view.bounds), 52.0f);
        button.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:15];
    }
    else if(IS_IPHONE_X)
    {
        button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.view.bounds) - 52.0f, CGRectGetWidth(self.view.bounds), 52.0f);
        button.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:15];
    }
    else
    {
        button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.view.bounds) - 78.0f, CGRectGetWidth(self.view.bounds), 78.0f);
        button.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:20];
    }
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[CommonModel colorFromHexString:self.color]];
    [button setTitle:[@"CLOSE" myModification] forState:UIControlStateNormal];
    return button;
}

- (UILabel *)setupMessageLabel
{
    UILabel *label;
    NSMutableAttributedString *finalMessage = [[NSMutableAttributedString alloc] init];
    
    NSMutableAttributedString *titleMessage = [[NSMutableAttributedString alloc] initWithString:self.alertTitle];
    [titleMessage addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(96, 96, 96, 1) range:NSMakeRange(0, titleMessage.length)];
    NSMutableParagraphStyle *paragraphStyleTitle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyleTitle.alignment = NSTextAlignmentCenter;
    [titleMessage addAttribute:NSParagraphStyleAttributeName value:paragraphStyleTitle range:NSMakeRange(0, titleMessage.length)];
    
    NSMutableAttributedString *firstParagraph = [[NSMutableAttributedString alloc] initWithString:self.firstParagraph];
    [firstParagraph addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(118, 118, 118, 1) range:NSMakeRange(0, firstParagraph.length)];
    NSMutableParagraphStyle *paragraphStyleFirstParagraph = [[NSMutableParagraphStyle alloc] init];
    paragraphStyleFirstParagraph.alignment = NSTextAlignmentLeft;
    [firstParagraph addAttribute:NSParagraphStyleAttributeName value:paragraphStyleFirstParagraph range:NSMakeRange(0, firstParagraph.length)];
    
    
    NSMutableAttributedString *doNotPanicTitleStr = [[NSMutableAttributedString alloc] initWithString:self.firstTitle];
    [doNotPanicTitleStr addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(240, 80, 80, 1) range:NSMakeRange(0, doNotPanicTitleStr.length)];
    NSMutableParagraphStyle *paragraphStyledoNotPanicTitle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyledoNotPanicTitle.alignment = NSTextAlignmentLeft;
    [doNotPanicTitleStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyledoNotPanicTitle range:NSMakeRange(0, doNotPanicTitleStr.length)];
    
    NSMutableAttributedString *doNotPanicDetailStr = [[NSMutableAttributedString alloc] initWithString:self.firstDetails];
    [doNotPanicDetailStr addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(118, 118, 118, 1) range:NSMakeRange(0, doNotPanicDetailStr.length)];
    NSMutableParagraphStyle *paragraphStyledoNotPanicDetail = [[NSMutableParagraphStyle alloc] init];
    paragraphStyledoNotPanicDetail.alignment = NSTextAlignmentLeft;
    [doNotPanicDetailStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyledoNotPanicDetail range:NSMakeRange(0, doNotPanicDetailStr.length)];
    
    NSMutableAttributedString *stayCalmTitleStr = [[NSMutableAttributedString alloc] initWithString:self.secondTitle];
    [stayCalmTitleStr addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(240, 80, 80, 1) range:NSMakeRange(0, stayCalmTitleStr.length)];
    NSMutableParagraphStyle *paragraphStylestayCalmTitle = [[NSMutableParagraphStyle alloc] init];
    paragraphStylestayCalmTitle.alignment = NSTextAlignmentLeft;
    [stayCalmTitleStr addAttribute:NSParagraphStyleAttributeName value:paragraphStylestayCalmTitle range:NSMakeRange(0, stayCalmTitleStr.length)];
    
    NSMutableAttributedString *stayCalmDetailStr = [[NSMutableAttributedString alloc] initWithString:self.secondDetails];
    [stayCalmDetailStr addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(118, 118, 118, 1) range:NSMakeRange(0, stayCalmDetailStr.length)];
    NSMutableParagraphStyle *paragraphStylestayCalmDetail = [[NSMutableParagraphStyle alloc] init];
    paragraphStylestayCalmDetail.alignment = NSTextAlignmentLeft;
    [stayCalmDetailStr addAttribute:NSParagraphStyleAttributeName value:paragraphStylestayCalmDetail range:NSMakeRange(0, stayCalmDetailStr.length)];
    
    if(IS_IPHONE_4)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(18.0f, CGRectGetMaxY(self.imageView.frame) + 15.0f, CGRectGetWidth(self.view.bounds) - 36.0f, CGRectGetMinY(self.closeButton.frame) - CGRectGetMaxY(self.imageView.frame) - 15.0f)];
        
        [titleMessage addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Semibold" size:20] range:NSMakeRange(0, titleMessage.length)];
        [firstParagraph addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Light" size:12] range:NSMakeRange(0, firstParagraph.length)];
        [doNotPanicTitleStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Semibold" size:12] range:NSMakeRange(0, doNotPanicTitleStr.length)];
        [doNotPanicDetailStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Light" size:12] range:NSMakeRange(0, doNotPanicDetailStr.length)];
        [stayCalmTitleStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Semibold" size:12] range:NSMakeRange(0, stayCalmTitleStr.length)];
        [stayCalmDetailStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Light" size:12] range:NSMakeRange(0, stayCalmDetailStr.length)];
    }
    else if(IS_IPHONE_5)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(18.0f, CGRectGetMaxY(self.imageView.frame) + 15.0f, CGRectGetWidth(self.view.bounds) - 36.0f, CGRectGetMinY(self.closeButton.frame) - CGRectGetMaxY(self.imageView.frame) - 15.0f)];
        [titleMessage addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Semibold" size:20] range:NSMakeRange(0, titleMessage.length)];
        [firstParagraph addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Light" size:12] range:NSMakeRange(0, firstParagraph.length)];
        [doNotPanicTitleStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Semibold" size:12] range:NSMakeRange(0, doNotPanicTitleStr.length)];
        [doNotPanicDetailStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Light" size:12] range:NSMakeRange(0, doNotPanicDetailStr.length)];
        [stayCalmTitleStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Semibold" size:12] range:NSMakeRange(0, stayCalmTitleStr.length)];
        [stayCalmDetailStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Light" size:12] range:NSMakeRange(0, stayCalmDetailStr.length)];
    }
    else if(IS_IPHONE_6)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(25.0f, CGRectGetMaxY(self.imageView.frame) + 15.0f, CGRectGetWidth(self.view.bounds) - 50.0f, CGRectGetMinY(self.closeButton.frame) - CGRectGetMaxY(self.imageView.frame) - 15.0f)];
        [titleMessage addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Semibold" size:22] range:NSMakeRange(0, titleMessage.length)];
        [firstParagraph addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Light" size:13] range:NSMakeRange(0, firstParagraph.length)];
        [doNotPanicTitleStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Semibold" size:13] range:NSMakeRange(0, doNotPanicTitleStr.length)];
        [doNotPanicDetailStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Light" size:13] range:NSMakeRange(0, doNotPanicDetailStr.length)];
        [stayCalmTitleStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Semibold" size:13] range:NSMakeRange(0, stayCalmTitleStr.length)];
        [stayCalmDetailStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Light" size:13] range:NSMakeRange(0, stayCalmDetailStr.length)];
    }
    else if(IS_IPHONE_6_PLUS)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(31.0f, CGRectGetMaxY(self.imageView.frame) + 15.0f, CGRectGetWidth(self.view.bounds) - 62.0f, CGRectGetMinY(self.closeButton.frame) - CGRectGetMaxY(self.imageView.frame) - 15.0f)];
        [titleMessage addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Semibold" size:24] range:NSMakeRange(0, titleMessage.length)];
        [firstParagraph addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Light" size:14] range:NSMakeRange(0, firstParagraph.length)];
        [doNotPanicTitleStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Semibold" size:14] range:NSMakeRange(0, doNotPanicTitleStr.length)];
        [doNotPanicDetailStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Light" size:14] range:NSMakeRange(0, doNotPanicDetailStr.length)];
        [stayCalmTitleStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Semibold" size:14] range:NSMakeRange(0, stayCalmTitleStr.length)];
        [stayCalmDetailStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Light" size:14] range:NSMakeRange(0, stayCalmDetailStr.length)];
    }
    else if(IS_IPHONE_X)
        {
        label = [[UILabel alloc] initWithFrame:CGRectMake(31.0f, CGRectGetMaxY(self.imageView.frame) + 15.0f, CGRectGetWidth(self.view.bounds) - 62.0f, CGRectGetMinY(self.closeButton.frame) - CGRectGetMaxY(self.imageView.frame) - 15.0f)];
        [titleMessage addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Semibold" size:24] range:NSMakeRange(0, titleMessage.length)];
        [firstParagraph addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Light" size:14] range:NSMakeRange(0, firstParagraph.length)];
        [doNotPanicTitleStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Semibold" size:14] range:NSMakeRange(0, doNotPanicTitleStr.length)];
        [doNotPanicDetailStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Light" size:14] range:NSMakeRange(0, doNotPanicDetailStr.length)];
        [stayCalmTitleStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Semibold" size:14] range:NSMakeRange(0, stayCalmTitleStr.length)];
        [stayCalmDetailStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Light" size:14] range:NSMakeRange(0, stayCalmDetailStr.length)];
        }
    else
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(47.0f, CGRectGetMaxY(self.imageView.frame) + 34.0f, CGRectGetWidth(self.view.bounds) - 94.0f, CGRectGetMinY(self.closeButton.frame) - CGRectGetMaxY(self.imageView.frame) - 34.0f)];
        [titleMessage addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Semibold" size:36] range:NSMakeRange(0, titleMessage.length)];
        [firstParagraph addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Light" size:19] range:NSMakeRange(0, firstParagraph.length)];
        [doNotPanicTitleStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Semibold" size:19] range:NSMakeRange(0, doNotPanicTitleStr.length)];
        [doNotPanicDetailStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Light" size:19] range:NSMakeRange(0, doNotPanicDetailStr.length)];
        [stayCalmTitleStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Semibold" size:19] range:NSMakeRange(0, stayCalmTitleStr.length)];
        [stayCalmDetailStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Light" size:19] range:NSMakeRange(0, stayCalmDetailStr.length)];
    }
    
    [finalMessage appendAttributedString:titleMessage];
    [finalMessage appendAttributedString:firstParagraph];
    [finalMessage appendAttributedString:doNotPanicTitleStr];
    [finalMessage appendAttributedString:doNotPanicDetailStr];
    [finalMessage appendAttributedString:stayCalmTitleStr];
    [finalMessage appendAttributedString:stayCalmDetailStr];
    label.numberOfLines = 0;
    
    CGRect rect = [finalMessage boundingRectWithSize:CGSizeMake(CGRectGetWidth(label.bounds), 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    label.frame = CGRectMake(CGRectGetMinX(label.frame), CGRectGetMinY(label.frame), CGRectGetWidth(label.frame), CGRectGetHeight(rect));
    label.attributedText = finalMessage;
    //label.backgroundColor = [UIColor redColor];
    return label;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
