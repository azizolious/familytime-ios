//
//  WizardScreen1ViewController.m
//  FamilyTime - Dashboard
//
//  Created by Muhammad Ajmal on 09/12/2015.
//  Copyright © 2015 SoraCode. All rights reserved.
//

#import "WizardScreen1ViewController.h"
#import "WizardScreen2ViewController.h"
#import "FTUtils.h"
//#import "JSONHTTPClient.h"
#import "MBProgressHUD.h"
#import "Constant.h"
#import "CommonModel.h"
#import "DataModel.h"
#import "AppDelegate.h"
#import "FIRConstants.h"
//#import <Google/Analytics.h>

#import "NSString+LockMustafa.h"
#import "FamilyTime-Swift.h"



#define RGBCOLOR(R,G,B, A) [UIColor colorWithRed:R/255.2f green:G/255.2f blue:B/255.2f alpha:A]

@interface WizardScreen1ViewController ()<UITextFieldDelegate, UITextViewDelegate>
@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *logoImageView;
@property (strong, nonatomic) UILabel *firstLabel;
@property (strong, nonatomic) UILabel *emailLabel;
@property (strong, nonatomic) UITextView *startoverTextView;
@property (strong, nonatomic) UITextField *verificationCodeField;
@property (strong, nonatomic) UIButton *verificationCodeButton;
@end

@implementation WizardScreen1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"RemoveSteps"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification22:)
                                                 name:@"RemoveStepsPrevious"
                                               object:nil];

    //RemoveStepsPrevious
    _firstLabel.text=[_firstLabel.text myModification];
    _titleLabel.text=[_titleLabel.text myModification];
    
    _verificationCodeField.placeholder=[_verificationCodeField.placeholder myModification];
    
    [self.navigationController setNavigationBarHidden:YES];
    [self setupUI];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.emailLabel.text = self.email;
}

- (void)setupUI
{
    self.view.backgroundColor = RGBCOLOR(43, 181, 227, 1);
    
    self.containerView = [self setupContainerView];
    [self.view addSubview:self.containerView];
    
    self.titleLabel = [self setupTitleLabel];
    [self.containerView addSubview:self.titleLabel];
    
    self.logoImageView = [self setupLogoImage];
    [self.containerView addSubview:self.logoImageView];
    
    self.firstLabel = [self setupFirstLabel];
    [self.containerView addSubview:self.firstLabel];
    
    self.emailLabel = [self setupEmailLabel];
    [self.containerView addSubview:self.emailLabel];
    
    self.startoverTextView = [self setupStartoverTextView];
    [self.containerView addSubview:self.startoverTextView];
    
    self.verificationCodeField = [self setupVerificationField];
    [self.containerView addSubview:self.verificationCodeField];
    
    self.verificationCodeButton = [self setupVerificationCodeButton];
    [self.containerView addSubview:self.verificationCodeButton];
}

- (UIView *)setupContainerView
{
    UIView *container;
    
    //---UI ISSUE FIX---//
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        container = [[UIView alloc] initWithFrame:CGRectMake(24, 0, CGRectGetWidth(self.view.bounds) - 24 * 2.0f, CGRectGetHeight(self.view.bounds))];
    }
    else{
        
        if(IS_IPHONE_4)
        {
            container = [[UIView alloc] initWithFrame:CGRectMake(18, 0, CGRectGetWidth(self.view.bounds) - 18 * 2.0f, CGRectGetHeight(self.view.bounds))];
        }
        else if(IS_IPHONE_5)
        {
            container = [[UIView alloc] initWithFrame:CGRectMake(20, 0, CGRectGetWidth(self.view.bounds) - 20 * 2.0f, CGRectGetHeight(self.view.bounds))];
        }
        else if(IS_IPHONE_6)
        {
             container = [[UIView alloc] initWithFrame:CGRectMake(22, 0, CGRectGetWidth(self.view.bounds) - 22 * 2.0f, CGRectGetHeight(self.view.bounds))];
        }
//        else if(IS_IPHONE_6_PLUS)
//        {
//             container = [[UIView alloc] initWithFrame:CGRectMake(24, 0, CGRectGetWidth(self.view.bounds) - 24 * 2.0f, CGRectGetHeight(self.view.bounds))];
//        }
        else //if(IS_IPHONE_X)
        {
            container = [[UIView alloc] initWithFrame:CGRectMake(24, 0, CGRectGetWidth(self.view.bounds) - 24 * 2.0f, CGRectGetHeight(self.view.bounds))];
        }
        
    }
    
    
    /*
    
    if(IS_IPHONE_4)
    {
        container = [[UIView alloc] initWithFrame:CGRectMake(18, 0, CGRectGetWidth(self.view.bounds) - 18 * 2.0f, CGRectGetHeight(self.view.bounds))];
    }
    else if(IS_IPHONE_5)
    {
        container = [[UIView alloc] initWithFrame:CGRectMake(20, 0, CGRectGetWidth(self.view.bounds) - 20 * 2.0f, CGRectGetHeight(self.view.bounds))];
    }
    else if(IS_IPHONE_6)
    {
         container = [[UIView alloc] initWithFrame:CGRectMake(22, 0, CGRectGetWidth(self.view.bounds) - 22 * 2.0f, CGRectGetHeight(self.view.bounds))];
    }
    else if(IS_IPHONE_6_PLUS)
    {
         container = [[UIView alloc] initWithFrame:CGRectMake(24, 0, CGRectGetWidth(self.view.bounds) - 24 * 2.0f, CGRectGetHeight(self.view.bounds))];
    }
    else if(IS_IPHONE_X)
    {
        container = [[UIView alloc] initWithFrame:CGRectMake(24, 0, CGRectGetWidth(self.view.bounds) - 24 * 2.0f, CGRectGetHeight(self.view.bounds))];
    }
    else
    {
    
    container = [[UIView alloc] initWithFrame:CGRectMake(24, 0, CGRectGetWidth(self.view.bounds) - 24 * 2.0f, CGRectGetHeight(self.view.bounds))];

//        container = [[UIView alloc] initWithFrame:CGRectMake(116, 0, CGRectGetWidth(self.view.bounds) - 116*2.0f, CGRectGetHeight(self.view.bounds))];
    }
     
     */
    container.backgroundColor = [UIColor clearColor];
    return container;
}

- (UILabel *)setupTitleLabel
{
    UILabel *label;
    
    //---UI ISSUE FIX---//
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, CGRectGetWidth(self.containerView.bounds), 55)];
        label.font = [UIFont fontWithName:@"OpenSans-Semibold" size:38];
    }
    else{
        
        if(IS_IPHONE_4)
        {
            label = [[UILabel alloc] initWithFrame:CGRectMake(0, 23, CGRectGetWidth(self.containerView.bounds), 25)];
            label.font = [UIFont fontWithName:@"OpenSans-Semibold" size:20];
        }
        else if(IS_IPHONE_5)
        {
            label = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, CGRectGetWidth(self.containerView.bounds), 25)];
            label.font = [UIFont fontWithName:@"OpenSans-Semibold" size:20];
        }
        else if(IS_IPHONE_6)
        {
            label = [[UILabel alloc] initWithFrame:CGRectMake(0, 46, CGRectGetWidth(self.containerView.bounds), 28)];
            label.font = [UIFont fontWithName:@"OpenSans-Semibold" size:23];
        }
//        else if(IS_IPHONE_6_PLUS)
//        {
//            label = [[UILabel alloc] initWithFrame:CGRectMake(0, 54, CGRectGetWidth(self.containerView.bounds), 35)];
//            label.font = [UIFont fontWithName:@"OpenSans-Semibold" size:25];
//        }
        else //if(IS_IPHONE_X)
        {
            label = [[UILabel alloc] initWithFrame:CGRectMake(0, 54, CGRectGetWidth(self.containerView.bounds), 35)];
            label.font = [UIFont fontWithName:@"OpenSans-Semibold" size:25];
        }
        
    }
    
    /*
    
    if(IS_IPHONE_4)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 23, CGRectGetWidth(self.containerView.bounds), 25)];
        label.font = [UIFont fontWithName:@"OpenSans-Semibold" size:20];
    }
    else if(IS_IPHONE_5)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, CGRectGetWidth(self.containerView.bounds), 25)];
        label.font = [UIFont fontWithName:@"OpenSans-Semibold" size:20];
    }
    else if(IS_IPHONE_6)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 46, CGRectGetWidth(self.containerView.bounds), 28)];
        label.font = [UIFont fontWithName:@"OpenSans-Semibold" size:23];
    }
    else if(IS_IPHONE_6_PLUS)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 54, CGRectGetWidth(self.containerView.bounds), 35)];
        label.font = [UIFont fontWithName:@"OpenSans-Semibold" size:25];
    }
    else if(IS_IPHONE_X)
        {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 54, CGRectGetWidth(self.containerView.bounds), 35)];
        label.font = [UIFont fontWithName:@"OpenSans-Semibold" size:25];
        }
    else
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, CGRectGetWidth(self.containerView.bounds), 55)];
        label.font = [UIFont fontWithName:@"OpenSans-Semibold" size:38];
    }
     
     */
     
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [@"Verify FamilyTime Account" myModification];
    
    label.adjustsFontSizeToFitWidth=YES;
    return label;
}

- (UIImageView *)setupLogoImage
{
    UIImageView *imageView;
    
    //---UI ISSUE FIX---//
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.containerView.bounds) - 178.0f/2.0f, CGRectGetMaxY(self.titleLabel.frame) + 80.0f, 178, 143)];
        imageView.image = [UIImage imageNamed:@"ic_email111"];
    }
    else{
        
        if(IS_IPHONE_4)
        {
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.containerView.bounds) - 96.0f/2.0f, CGRectGetMaxY(self.titleLabel.frame) + 23.0f, 96, 77)];
            imageView.image = [UIImage imageNamed:@"ic_email111"];
        }
        else if(IS_IPHONE_5)
        {
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.containerView.bounds) - 96.0f/2.0f, CGRectGetMaxY(self.titleLabel.frame) + 40.0f, 96, 77)];
            imageView.image = [UIImage imageNamed:@"ic_email111"];
        }
        else if(IS_IPHONE_6)
        {
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.containerView.bounds) - 128.0f/2.0f, CGRectGetMaxY(self.titleLabel.frame) + 46.0f, 128, 102)];
            imageView.image = [UIImage imageNamed:@"ic_email111"];
        }
//        else if(IS_IPHONE_6_PLUS)
//        {
//            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.containerView.bounds) - 128.0f/2.0f, CGRectGetMaxY(self.titleLabel.frame) + 54.0f, 128, 102)];
//            imageView.image = [UIImage imageNamed:@"ic_email111"];
//        }
        else //if(IS_IPHONE_X)
        {
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.containerView.bounds) - 128.0f/2.0f, CGRectGetMaxY(self.titleLabel.frame) + 54.0f, 128, 102)];
            imageView.image = [UIImage imageNamed:@"ic_email111"];
        }
        
    }
    
    
    /*
     
    if(IS_IPHONE_4)
    {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.containerView.bounds) - 96.0f/2.0f, CGRectGetMaxY(self.titleLabel.frame) + 23.0f, 96, 77)];
        imageView.image = [UIImage imageNamed:@"ic_email111"];
    }
    else if(IS_IPHONE_5)
    {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.containerView.bounds) - 96.0f/2.0f, CGRectGetMaxY(self.titleLabel.frame) + 40.0f, 96, 77)];
        imageView.image = [UIImage imageNamed:@"ic_email111"];
    }
    else if(IS_IPHONE_6)
    {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.containerView.bounds) - 128.0f/2.0f, CGRectGetMaxY(self.titleLabel.frame) + 46.0f, 128, 102)];
        imageView.image = [UIImage imageNamed:@"ic_email111"];
    }
    else if(IS_IPHONE_6_PLUS)
    {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.containerView.bounds) - 128.0f/2.0f, CGRectGetMaxY(self.titleLabel.frame) + 54.0f, 128, 102)];
        imageView.image = [UIImage imageNamed:@"ic_email111"];
    }
    else if(IS_IPHONE_X)
        {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.containerView.bounds) - 128.0f/2.0f, CGRectGetMaxY(self.titleLabel.frame) + 54.0f, 128, 102)];
        imageView.image = [UIImage imageNamed:@"ic_email111"];
        }
    else
    {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.containerView.bounds) - 178.0f/2.0f, CGRectGetMaxY(self.titleLabel.frame) + 80.0f, 178, 143)];
        imageView.image = [UIImage imageNamed:@"ic_email111"];
    }
     
     */
    
    return imageView;
}

- (UILabel *)setupFirstLabel
{
    UILabel *label;
    
    //---UI ISSUE FIX---//
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.logoImageView.frame) + 56.0f, CGRectGetWidth(self.containerView.bounds), 100.0f)];
        label.font = [UIFont fontWithName:@"OpenSans-Light" size:23];
    }
    else{
        
        if(IS_IPHONE_4)
        {
            label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.logoImageView.frame) + 16.0f, CGRectGetWidth(self.containerView.bounds), 55.0f)];
            label.font = [UIFont fontWithName:@"OpenSans-Light" size:14];
        }
        else if(IS_IPHONE_5)
        {
            label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.logoImageView.frame) + 40.0f, CGRectGetWidth(self.containerView.bounds), 60.0f)];
            label.font = [UIFont fontWithName:@"OpenSans-Light" size:14];
        }
        else if(IS_IPHONE_6)
        {
            label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.logoImageView.frame) + 46.0f, CGRectGetWidth(self.containerView.bounds), 70.0f)];
            label.font = [UIFont fontWithName:@"OpenSans-Light" size:16];
        }
//        else if(IS_IPHONE_6_PLUS)
//        {
//            label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.logoImageView.frame) + 54.0f, CGRectGetWidth(self.containerView.bounds), 75.0f)];
//            label.font = [UIFont fontWithName:@"OpenSans-Light" size:17];
//        }
        else //if(IS_IPHONE_X)
        {
            label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.logoImageView.frame) + 54.0f, CGRectGetWidth(self.containerView.bounds), 75.0f)];
            label.font = [UIFont fontWithName:@"OpenSans-Light" size:17];
        }
    }
    
    /*
     
    if(IS_IPHONE_4)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.logoImageView.frame) + 16.0f, CGRectGetWidth(self.containerView.bounds), 55.0f)];
        label.font = [UIFont fontWithName:@"OpenSans-Light" size:14];
    }
    else if(IS_IPHONE_5)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.logoImageView.frame) + 40.0f, CGRectGetWidth(self.containerView.bounds), 60.0f)];
        label.font = [UIFont fontWithName:@"OpenSans-Light" size:14];
    }
    else if(IS_IPHONE_6)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.logoImageView.frame) + 46.0f, CGRectGetWidth(self.containerView.bounds), 70.0f)];
        label.font = [UIFont fontWithName:@"OpenSans-Light" size:16];
    }
    else if(IS_IPHONE_6_PLUS)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.logoImageView.frame) + 54.0f, CGRectGetWidth(self.containerView.bounds), 75.0f)];
        label.font = [UIFont fontWithName:@"OpenSans-Light" size:17];
    }
    else if(IS_IPHONE_X)
        {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.logoImageView.frame) + 54.0f, CGRectGetWidth(self.containerView.bounds), 75.0f)];
        label.font = [UIFont fontWithName:@"OpenSans-Light" size:17];
        }
    else
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.logoImageView.frame) + 56.0f, CGRectGetWidth(self.containerView.bounds), 100.0f)];
        label.font = [UIFont fontWithName:@"OpenSans-Light" size:23];
    }
     
     */
     
    label.backgroundColor = [UIColor clearColor];
    label.textColor = RGBCOLOR(213, 245, 255, 1);
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
//    label.text = [@"Thank you for registering with FamilyTime Dashboard. Verification code has been sent to your registered email:" myModification];
    
    label.text = [NSString stringWithFormat:@"%@%@",[@"thankyou_for_registering_for_familyTime_parental_control" myModification], [@"A verification code has been sent to your registered email:" myModification]];

    return label;
}

- (UILabel *)setupEmailLabel
{
    UILabel *label;
    
    //---UI ISSUE FIX---//
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.firstLabel.frame) + 36.0f, CGRectGetWidth(self.containerView.frame), 35.0f)];
        label.font = [UIFont fontWithName:@"OpenSans-Semibold" size:23];
    }
    else{
        
        if(IS_IPHONE_4)
        {
            label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.firstLabel.frame) + 16.0f, CGRectGetWidth(self.containerView.frame), 20.0f)];
            label.font = [UIFont fontWithName:@"OpenSans-Semibold" size:14];
        }
        else if(IS_IPHONE_5)
        {
            label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.firstLabel.frame) + 18.0f, CGRectGetWidth(self.containerView.frame), 20.0f)];
            label.font = [UIFont fontWithName:@"OpenSans-Semibold" size:14];
        }
        else if(IS_IPHONE_6)
        {
            label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.firstLabel.frame) + 20.0f, CGRectGetWidth(self.containerView.frame), 25.0f)];
            label.font = [UIFont fontWithName:@"OpenSans-Semibold" size:16];
        }
//        else if(IS_IPHONE_6_PLUS)
//        {
//            label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.firstLabel.frame) + 22.0f, CGRectGetWidth(self.containerView.frame), 30.0f)];
//            label.font = [UIFont fontWithName:@"OpenSans-Semibold" size:17];
//        }
        else //if(IS_IPHONE_X)
        {
            label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.firstLabel.frame) + 22.0f, CGRectGetWidth(self.containerView.frame), 30.0f)];
            label.font = [UIFont fontWithName:@"OpenSans-Semibold" size:17];
        }
    }
    
    /*
    
    if(IS_IPHONE_4)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.firstLabel.frame) + 16.0f, CGRectGetWidth(self.containerView.frame), 20.0f)];
        label.font = [UIFont fontWithName:@"OpenSans-Semibold" size:14];
    }
    else if(IS_IPHONE_5)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.firstLabel.frame) + 18.0f, CGRectGetWidth(self.containerView.frame), 20.0f)];
        label.font = [UIFont fontWithName:@"OpenSans-Semibold" size:14];
    }
    else if(IS_IPHONE_6)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.firstLabel.frame) + 20.0f, CGRectGetWidth(self.containerView.frame), 25.0f)];
        label.font = [UIFont fontWithName:@"OpenSans-Semibold" size:16];
    }
    else if(IS_IPHONE_6_PLUS)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.firstLabel.frame) + 22.0f, CGRectGetWidth(self.containerView.frame), 30.0f)];
        label.font = [UIFont fontWithName:@"OpenSans-Semibold" size:17];
    }
    else if(IS_IPHONE_X)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.firstLabel.frame) + 22.0f, CGRectGetWidth(self.containerView.frame), 30.0f)];
        label.font = [UIFont fontWithName:@"OpenSans-Semibold" size:17];
    }
    else
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.firstLabel.frame) + 36.0f, CGRectGetWidth(self.containerView.frame), 35.0f)];
        label.font = [UIFont fontWithName:@"OpenSans-Semibold" size:23];
    }
    
    */
    
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    return label;
}

- (UITextView *)setupStartoverTextView
{
    UITextView *label;
    UIFont *font;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        label = [[UITextView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.emailLabel.frame) + 36.0f, CGRectGetWidth(self.containerView.frame), 140)];
        font = [UIFont fontWithName:@"OpenSans-Light" size:23];
    }
    else{
        
        if(IS_IPHONE_4)
        {
            label = [[UITextView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.emailLabel.frame) + 16.0f, CGRectGetWidth(self.containerView.frame), 85)];
            font = [UIFont fontWithName:@"OpenSans-Light" size:14];
        }
        else if(IS_IPHONE_5)
        {
            label = [[UITextView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.emailLabel.frame) + 18.0f, CGRectGetWidth(self.containerView.frame), 100)];
            font = [UIFont fontWithName:@"OpenSans-Light" size:14];
        }
        else if(IS_IPHONE_6)
        {
            label = [[UITextView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.emailLabel.frame) + 20.0f, CGRectGetWidth(self.containerView.frame), 105)];
            font = [UIFont fontWithName:@"OpenSans-Light" size:16];
        }
//        else if(IS_IPHONE_6_PLUS)
//        {
//            label = [[UITextView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.emailLabel.frame) + 22.0f, CGRectGetWidth(self.containerView.frame), 100)];
//            font = [UIFont fontWithName:@"OpenSans-Light" size:17];
//        }
        else //if(IS_IPHONE_X)
        {
            label = [[UITextView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.emailLabel.frame) + 22.0f, CGRectGetWidth(self.containerView.frame), 120)];
            font = [UIFont fontWithName:@"OpenSans-Light" size:17];
        }
        
    }
    
    /*
     
    //---UI ISSUE FIX---//
    
    if(IS_IPHONE_4)
    {
        label = [[UITextView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.emailLabel.frame) + 16.0f, CGRectGetWidth(self.containerView.frame), 85)];
        font = [UIFont fontWithName:@"OpenSans-Light" size:14];
    }
    else if(IS_IPHONE_5)
    {
        label = [[UITextView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.emailLabel.frame) + 18.0f, CGRectGetWidth(self.containerView.frame), 90)];
        font = [UIFont fontWithName:@"OpenSans-Light" size:14];
    }
    else if(IS_IPHONE_6)
    {
        label = [[UITextView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.emailLabel.frame) + 20.0f, CGRectGetWidth(self.containerView.frame), 95)];
        font = [UIFont fontWithName:@"OpenSans-Light" size:16];
    }
    else if(IS_IPHONE_6_PLUS)
    {
        label = [[UITextView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.emailLabel.frame) + 22.0f, CGRectGetWidth(self.containerView.frame), 100)];
        font = [UIFont fontWithName:@"OpenSans-Light" size:17];
    }
    else if(IS_IPHONE_X)
    {
        label = [[UITextView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.emailLabel.frame) + 22.0f, CGRectGetWidth(self.containerView.frame), 100)];
        font = [UIFont fontWithName:@"OpenSans-Light" size:17];
    }
    else
    {
        label = [[UITextView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.emailLabel.frame) + 36.0f, CGRectGetWidth(self.containerView.frame), 140)];
        font = [UIFont fontWithName:@"OpenSans-Light" size:23];
    }
     
     */
    
    label.backgroundColor = [UIColor clearColor];
    label.editable      = NO;
    label.selectable    = YES;
    label.scrollEnabled = NO;
    label.delegate      = self;
    
    label.linkTextAttributes = @{NSForegroundColorAttributeName:RGBCOLOR(140, 226, 255, 1)};
    NSMutableAttributedString *finalStr = [[NSMutableAttributedString alloc] initWithString:[@"Please insert the code below from your email to verify the account. If this email account doesn’t belong to you, please " myModification]];
    [finalStr addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(213, 245, 255, 1) range:NSMakeRange(0, finalStr.length)];
    [finalStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, finalStr.length)];
    
    NSMutableAttributedString *firstLink = [[NSMutableAttributedString alloc] initWithString:@"StartOver"];
    [firstLink addAttribute: NSLinkAttributeName value: @"" range: NSMakeRange(0, firstLink.length)];
    [firstLink addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, firstLink.length)];
    [finalStr appendAttributedString:firstLink];

    NSMutableAttributedString *andStr = [[NSMutableAttributedString alloc] initWithString:@" and sign up again."];
    [andStr addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(213, 245, 255, 1) range:NSMakeRange(0, andStr.length)];
    [andStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, andStr.length)];
    [finalStr appendAttributedString:andStr];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [finalStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, finalStr.length)];
    label.attributedText = finalStr;
    return label;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)url inRange:(NSRange)characterRange
{
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
    return YES;
}

- (UITextField *)setupVerificationField
{
    UITextField *field;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        field = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.startoverTextView.frame) + 65.0f, CGRectGetWidth(self.containerView.frame), 68)];
        field.font = [UIFont systemFontOfSize:19];
    }
    else
    {
        if(IS_IPHONE_4)
        {
            field = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.startoverTextView.frame) + 16.0f, CGRectGetWidth(self.containerView.frame), 37)];
            field.font = [UIFont systemFontOfSize:15];
        }
        else if(IS_IPHONE_5)
        {
            field = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.startoverTextView.frame) + 35.0f, CGRectGetWidth(self.containerView.frame), 37)];
            field.font = [UIFont systemFontOfSize:15];
        }
        else if(IS_IPHONE_6)
        {
            field = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.startoverTextView.frame) + 40.0f, CGRectGetWidth(self.containerView.frame), 43)];
            field.font = [UIFont systemFontOfSize:16];
        }
//        else if(IS_IPHONE_6_PLUS)
//        {
//            field = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.startoverTextView.frame) + 45.0f, CGRectGetWidth(self.containerView.frame), 47)];
//            field.font = [UIFont systemFontOfSize:17];
//        }
        else //if(IS_IPHONE_X)
        {
            field = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.startoverTextView.frame) + 45.0f, CGRectGetWidth(self.containerView.frame), 47)];
            field.font = [UIFont systemFontOfSize:17];
        }
    }
    
    
    /*
     
    if(IS_IPHONE_4)
    {
        field = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.startoverTextView.frame) + 16.0f, CGRectGetWidth(self.containerView.frame), 37)];
        field.font = [UIFont systemFontOfSize:15];
    }
    else if(IS_IPHONE_5)
    {
        field = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.startoverTextView.frame) + 35.0f, CGRectGetWidth(self.containerView.frame), 37)];
        field.font = [UIFont systemFontOfSize:15];
    }
    else if(IS_IPHONE_6)
    {
        field = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.startoverTextView.frame) + 40.0f, CGRectGetWidth(self.containerView.frame), 43)];
        field.font = [UIFont systemFontOfSize:16];
    }
    else if(IS_IPHONE_6_PLUS)
    {
        field = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.startoverTextView.frame) + 45.0f, CGRectGetWidth(self.containerView.frame), 47)];
        field.font = [UIFont systemFontOfSize:17];
    }
    else if(IS_IPHONE_X)
    {
        field = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.startoverTextView.frame) + 45.0f, CGRectGetWidth(self.containerView.frame), 47)];
        field.font = [UIFont systemFontOfSize:17];
    }
    else
    {
        field = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.startoverTextView.frame) + 65.0f, CGRectGetWidth(self.containerView.frame), 68)];
        field.font = [UIFont systemFontOfSize:19];
    }
    
     */
    
    
    field.backgroundColor = RGBCOLOR(66, 188, 229, 1);
    field.textColor = [UIColor whiteColor];
    field.textAlignment = NSTextAlignmentCenter;
    field.placeholder = [@"VERIFICATION CODE" myModification];
    field.tintColor = [UIColor whiteColor];
    field.layer.borderColor = RGBCOLOR(98, 200, 233, 1).CGColor;
    field.layer.borderWidth = [SwiftFTUtils isDeviceiPhoneFamily] ? 1 : 2;
    field.delegate = self;
    field.keyboardType = UIKeyboardTypeNumberPad;
    field.autocorrectionType = UITextAutocorrectionTypeNo;
    field.spellCheckingType = UITextSpellCheckingTypeNo;
    return field;
}

- (UIButton *)setupVerificationCodeButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:NSLocalizedString(@"VERIFY ACCOUNT", nil) forState:UIControlStateNormal];
    button.backgroundColor = RGBCOLOR(30, 146, 184, 1);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(handleVerification:) forControlEvents:UIControlEventTouchUpInside];
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.verificationCodeField.frame) + 15.0f, CGRectGetWidth(self.containerView.frame), 68);
        button.titleLabel.font = [UIFont systemFontOfSize:19];
    }
    else{
        if(IS_IPHONE_4)
        {
            button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.verificationCodeField.frame) + 10.0f, CGRectGetWidth(self.containerView.frame), 37);
            button.titleLabel.font = [UIFont systemFontOfSize:15];
        }
        else if(IS_IPHONE_5)
        {
            button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.verificationCodeField.frame) + 10.0f, CGRectGetWidth(self.containerView.frame), 37);
            button.titleLabel.font = [UIFont systemFontOfSize:15];
        }
        else if(IS_IPHONE_6)
        {
            button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.verificationCodeField.frame) + 10.0f, CGRectGetWidth(self.containerView.frame), 43);
            button.titleLabel.font = [UIFont systemFontOfSize:16];
        }
//        else if(IS_IPHONE_6_PLUS)
//        {
//            button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.verificationCodeField.frame) + 13.0f, CGRectGetWidth(self.containerView.frame), 47);
//            button.titleLabel.font = [UIFont systemFontOfSize:17];
//        }
        else //if(IS_IPHONE_X)
        {
            button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.verificationCodeField.frame) + 13.0f, CGRectGetWidth(self.containerView.frame), 47);
            button.titleLabel.font = [UIFont systemFontOfSize:17];
        }
        
    }
    
    
    /*
    
    if(IS_IPHONE_4)
    {
        button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.verificationCodeField.frame) + 10.0f, CGRectGetWidth(self.containerView.frame), 37);
        button.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    else if(IS_IPHONE_5)
    {
        button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.verificationCodeField.frame) + 10.0f, CGRectGetWidth(self.containerView.frame), 37);
        button.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    else if(IS_IPHONE_6)
    {
        button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.verificationCodeField.frame) + 10.0f, CGRectGetWidth(self.containerView.frame), 43);
        button.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    else if(IS_IPHONE_6_PLUS)
    {
        button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.verificationCodeField.frame) + 13.0f, CGRectGetWidth(self.containerView.frame), 47);
        button.titleLabel.font = [UIFont systemFontOfSize:17];
    }
    else if(IS_IPHONE_X)
        {
        button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.verificationCodeField.frame) + 13.0f, CGRectGetWidth(self.containerView.frame), 47);
        button.titleLabel.font = [UIFont systemFontOfSize:17];
        }
    else
    {
        button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.verificationCodeField.frame) + 15.0f, CGRectGetWidth(self.containerView.frame), 68);
        button.titleLabel.font = [UIFont systemFontOfSize:19];
    }
     
     */
     
    return button;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleVerification:(id)sender
{
    if (self.verificationCodeField.text.length == 0)
    {
        [CommonModel showAlert:[@"Verification Code" myModification] msg:[@"Please provide verification code" myModification] ];
        return;
    }
    AppDelegate *delegate = [AppDelegate appDelegate];
    [self.verificationCodeField resignFirstResponder];
    
    
//    [SwiftFTUtils showHUDAddedTo:self.view withText:@"Verifying Account..." animated:YES];
//    [JSONHTTPClient postJSONFromURLWithString:KVerifyActivation
//                                       params:@{@"activation_code":self.verificationCodeField.text}
//                                   completion:^(id json, JSONModelError *err) {
//                                       NSError *error;
//                                       if([[json valueForKey:@"response"] intValue] != 200 )
//                                           [CommonModel showAlert:@"Error!" msg:[json valueForKey:@"message"]];
//                                       else
//                                       {
//                                           NSLog(@"verify signup JSON response : %@", [json valueForKey:@"data"]);
//
//
//                                           UserModel *userData = [[UserModel alloc] initWithDictionary:[json valueForKey:@"data"] error:&error];
//
//                                       NSString *strCurrentUserId=[[json valueForKey:@"data"]objectForKey:@"user_id"];
//                                       [[NSUserDefaults standardUserDefaults]setObject:strCurrentUserId forKey:@"CurrentUserID"];
//
//                                       //user_id
//
//                                           delegate.parent = userData;
//                                           [delegate.userDefault setObject:[userData toDictionary] forKey:@"user"];
//                                           NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
//                                           // saving an NSString
//                                           [defaults setObject:self.email forKey:kUserEmail];
//                                           [delegate setNavigationbarAppearence:NO cont:self];
//                                           [defaults synchronize];
//                                           [CommonModel updateDeviceToken];
//
//                                           [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                                           WizardScreen2ViewController *controller = [[WizardScreen2ViewController alloc] init];
//                                           [self.navigationController pushViewController:controller animated:YES];
//
//                                       }
//                                       [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                                   }];
    
    
    [SwiftFTUtils showHUDAddedTo:self.view withText:@"Verifying Account..." animated:YES];
    [[ApiManager shared] putApiToVerifySignupWithParams:@{@"activation_code":self.verificationCodeField.text} onController:self isContPresented:YES withResponse:^(NSString * _Nonnull error, NSInteger errorCode, UserModel * _Nonnull userModel) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            NSLog(@"error msg = %@, statusCode = %ld, userModel = %@", error, (long)errorCode, userModel);
            
            if (errorCode == 200){
                
                delegate.parent = userModel;
                [delegate.userDefault setObject:[userModel toDictionary] forKey:@"user"];
                NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                // saving an NSString
                [defaults setObject:self.email forKey:kUserEmail];
                [delegate setNavigationbarAppearence:NO cont:self];
                [defaults synchronize];
                [CommonModel updateDeviceToken];
                
                
                WizardScreen2ViewController *controller = [[WizardScreen2ViewController alloc] init];
                [self.navigationController pushViewController:controller animated:YES];
            }
            else{
                [CommonModel showAlert:@"Error!" msg:error];
            }
        });
    }];
    
    
    
    
}

- (void)keyboardWillShow
{
    CGRect containerFrame;
    if(IS_IPHONE_4)
    {
        containerFrame = CGRectMake(CGRectGetMinX(self.containerView.frame), -250.0f, CGRectGetWidth(self.containerView.frame), CGRectGetHeight(self.containerView.frame));
    }
    else if(IS_IPHONE_5)
    {
         containerFrame = CGRectMake(CGRectGetMinX(self.containerView.frame), -250.0f, CGRectGetWidth(self.containerView.frame), CGRectGetHeight(self.containerView.frame));
    }
    else if(IS_IPHONE_6)
    {
        containerFrame = CGRectMake(CGRectGetMinX(self.containerView.frame), -250.0f, CGRectGetWidth(self.containerView.frame), CGRectGetHeight(self.containerView.frame));
    }
    else if(IS_IPHONE_6_PLUS)
    {
        containerFrame = CGRectMake(CGRectGetMinX(self.containerView.frame), -250.0f, CGRectGetWidth(self.containerView.frame), CGRectGetHeight(self.containerView.frame));
    }
    else if(IS_IPHONE_X)
        {
        containerFrame = CGRectMake(CGRectGetMinX(self.containerView.frame), -250.0f, CGRectGetWidth(self.containerView.frame), CGRectGetHeight(self.containerView.frame));
        }
    else
    {
        containerFrame = CGRectMake(CGRectGetMinX(self.containerView.frame), -300.0f, CGRectGetWidth(self.containerView.frame), CGRectGetHeight(self.containerView.frame));
    }

    [UIView animateWithDuration:0.5f animations:^{
        self.containerView.frame = containerFrame;
    }];
}

- (void)keyboardWillHide
{
    CGRect containerFrame = CGRectMake(CGRectGetMinX(self.containerView.frame), 0.0f, CGRectGetWidth(self.containerView.frame), CGRectGetHeight(self.containerView.frame));
    [UIView animateWithDuration:0.5f animations:^{
        self.containerView.frame = containerFrame;
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (void) receiveNotification:(NSNotification *) notification
{
        // [notification name] should always be @"TestNotification"
        // unless you use this method for observation of other notifications
        // as well.
    
        //    if ([[notification name] isEqualToString:@"TestNotification"])
        //        NSLog (@"Successfully received the test notification!");
    
//    [self SkipButton:nil];
//
    
//    AppDelegateShared().setupDrawer(0)

    AppDelegate *delegate = [AppDelegate appDelegate];
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [delegate setupDrawer:0];
    }];

    
    
//    [self dismissViewControllerAnimated:YES completion:^{
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"RELOAD_DASHBOARD" object:nil];
//    }];
    
}
- (void) receiveNotification22:(NSNotification *) notification
{
        // [notification name] should always be @"TestNotification"
        // unless you use this method for observation of other notifications
        // as well.
    
        //    if ([[notification name] isEqualToString:@"TestNotification"])
        //        NSLog (@"Successfully received the test notification!");
    
        //    [self SkipButton:nil];
        //
    
        //    AppDelegateShared().setupDrawer(0)
    
    AppDelegate *delegate = [AppDelegate appDelegate];
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [delegate setupDrawer:0];
    }];
    
    
    
        //    [self dismissViewControllerAnimated:YES completion:^{
        //        [[NSNotificationCenter defaultCenter] postNotificationName:@"RELOAD_DASHBOARD" object:nil];
        //    }];
    
}
@end
