//
//  WizardScreen2ViewController.m
//  FamilyTime - Dashboard
//
//  Created by Muhammad Ajmal on 09/12/2015.
//  Copyright © 2015 SoraCode. All rights reserved.
//

#import "WizardScreen2ViewController.h"
//#import "WizardScreen3ViewController.h"
#import "FTUtils.h"
#import "UIView+VTSelectiveBorder.h"
//#import <Google/Analytics.h>
#import "AppDelegate.h"
#import "NSString+LockMustafa.h"

#import "FamilyTime-Swift.h"

@interface WizardScreen2ViewController ()
@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *logoImageView;
@property (strong, nonatomic) UILabel *firstLabel;
@property (strong, nonatomic) UILabel *secondLabel;
@property (strong, nonatomic) UIButton *addDeviceButton;
@end

@implementation WizardScreen2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _titleLabel.text=[_titleLabel.text myModification];
    _firstLabel.text=[_firstLabel.text myModification];
    _secondLabel.text=[_secondLabel.text myModification];

    [self setupUI];
}

- (void)setupUI
{
    self.view.backgroundColor = RGBCOLOR(245, 87, 87, 1);
    
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
    
    self.addDeviceButton = [self setupAddDeviceButton];
    [self.containerView addSubview:self.addDeviceButton];
}

- (UIView *)setupContainerView
{
    UIView *container;
    if(IS_IPHONE_4)
    {
        container = [[UIView alloc] initWithFrame:CGRectMake(26, 0, CGRectGetWidth(self.view.bounds) - 26 * 2.0f, CGRectGetHeight(self.view.bounds))];
    }
    else if(IS_IPHONE_5)
    {
        container = [[UIView alloc] initWithFrame:CGRectMake(28, 0, CGRectGetWidth(self.view.bounds) - 28 * 2.0f, CGRectGetHeight(self.view.bounds))];
    }
    else if(IS_IPHONE_6)
    {
        container = [[UIView alloc] initWithFrame:CGRectMake(28, 0, CGRectGetWidth(self.view.bounds) - 28 * 2.0f, CGRectGetHeight(self.view.bounds))];
    }
    else if(IS_IPHONE_6_PLUS)
    {
        container = [[UIView alloc] initWithFrame:CGRectMake(35, 0, CGRectGetWidth(self.view.bounds) - 35 * 2.0f, CGRectGetHeight(self.view.bounds))];
    }
    else if(IS_IPHONE_X)
    {
        container = [[UIView alloc] initWithFrame:CGRectMake(35, 0, CGRectGetWidth(self.view.bounds) - 35 * 2.0f, CGRectGetHeight(self.view.bounds))];
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
    label.text = [@"Almost Done" myModification];
    return label;
}

- (UIImageView *)setupLogoImage
{
    UIImageView *imageView;
    if(IS_IPHONE_4)
    {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.containerView.bounds) - 126/2.0f, CGRectGetMaxY(self.titleLabel.frame) + 27.0f, 126, 107)];
        imageView.image = [UIImage imageNamed:@"ic_lock"];
    }
    else if(IS_IPHONE_5)
    {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.containerView.bounds) - 126/2.0f, CGRectGetMaxY(self.titleLabel.frame) + 51.0f, 126, 107)];
        imageView.image = [UIImage imageNamed:@"ic_lock"];
    }
    else if(IS_IPHONE_6)
    {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.containerView.bounds) - 168/2.0f, CGRectGetMaxY(self.titleLabel.frame) + 60.0f, 168, 142)];
        imageView.image = [UIImage imageNamed:@"ic_lock"];
    }
    else if(IS_IPHONE_6_PLUS)
    {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.containerView.bounds) - 168/2.0f, CGRectGetMaxY(self.titleLabel.frame) + 65.0f, 168, 142)];
        imageView.image = [UIImage imageNamed:@"ic_lock"];
    }
    else if(IS_IPHONE_X)
        {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.containerView.bounds) - 168/2.0f, CGRectGetMaxY(self.titleLabel.frame) + 65.0f, 168, 142)];
        imageView.image = [UIImage imageNamed:@"ic_lock"];
        }
    else
    {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.containerView.bounds) - 224.0f/2.0f, CGRectGetMaxY(self.titleLabel.frame) + 80.0f, 224, 207)];
        imageView.image = [UIImage imageNamed:@"ic_lock_ipad"];
    }
    return imageView;
}

- (UILabel *)setupFirstLabel
{
    UILabel *label;
    if(IS_IPHONE_4)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.logoImageView.frame) + 40.0f, CGRectGetWidth(self.containerView.bounds), 65.0f)];
        label.font = [UIFont fontWithName:@"OpenSans-Light" size:14];
    }
    else if(IS_IPHONE_5)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.logoImageView.frame) + 51.0f, CGRectGetWidth(self.containerView.bounds), 65.0f)];
        label.font = [UIFont fontWithName:@"OpenSans-Light" size:14];
    }
    else if(IS_IPHONE_6)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.logoImageView.frame) + 60.0f, CGRectGetWidth(self.containerView.bounds), 70.0f)];
        label.font = [UIFont fontWithName:@"OpenSans-Light" size:16];
    }
    else if(IS_IPHONE_6_PLUS)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.logoImageView.frame) + 65.0f, CGRectGetWidth(self.containerView.bounds), 75.0f)];
        label.font = [UIFont fontWithName:@"OpenSans-Light" size:17];
    }
    else if(IS_IPHONE_X)
        {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.logoImageView.frame) + 65.0f, CGRectGetWidth(self.containerView.bounds), 75.0f)];
        label.font = [UIFont fontWithName:@"OpenSans-Light" size:17];
        }
    else
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.logoImageView.frame) + 80.0f, CGRectGetWidth(self.containerView.bounds), 65.0f)];
        label.font = [UIFont fontWithName:@"OpenSans-Light" size:23];
    }
    label.backgroundColor = [UIColor clearColor];
    label.textColor = RGBCOLOR(255, 222, 222, 1);
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.text = [@"Thank you for verifying your account. Your login details have been sent to your email address." myModification];
    //Thank you for verifying your account. Your login details have been sent to your email address.
    return label;
}

- (UILabel *)setupSecondLabel
{
    UILabel *label;
    if(IS_IPHONE_4)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.firstLabel.frame) + 24.0f, CGRectGetWidth(self.containerView.frame), 65.0f)];
        label.font = [UIFont fontWithName:@"OpenSans-Light" size:14];
    }
    else if(IS_IPHONE_5)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.firstLabel.frame) + 24.0f, CGRectGetWidth(self.containerView.frame), 65.0f)];
        label.font = [UIFont fontWithName:@"OpenSans-Light" size:14];
    }
    else if(IS_IPHONE_6)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.firstLabel.frame) + 30.0f, CGRectGetWidth(self.containerView.frame), 70.0f)];
        label.font = [UIFont fontWithName:@"OpenSans-Light" size:16];
    }
    else if(IS_IPHONE_6_PLUS)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.firstLabel.frame) + 35.0f, CGRectGetWidth(self.containerView.frame), 75.0f)];
        label.font = [UIFont fontWithName:@"OpenSans-Light" size:17];
    }
    else if(IS_IPHONE_X)
        {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.firstLabel.frame) + 35.0f, CGRectGetWidth(self.containerView.frame), 75.0f)];
        label.font = [UIFont fontWithName:@"OpenSans-Light" size:17];
        }
    else
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.firstLabel.frame) + 70.0f, CGRectGetWidth(self.containerView.frame), 105.0f)];
       label.font = [UIFont fontWithName:@"OpenSans-Light" size:23];
    }
    label.backgroundColor = [UIColor clearColor];
    label.textColor = RGBCOLOR(255, 222, 222, 1);
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.text = NSLocalizedString(@"You can use these details to login from any device, anywhere. You are one step away! Click below to add your child's device.", nil);
    
    
    //You can use these details to login from any device, anywhere. You are one step away! Click below to add your child's device.
    return label;
}

- (UIButton *)setupAddDeviceButton
{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:[@"NEXT" myModification] forState:UIControlStateNormal];
    button.backgroundColor = RGBCOLOR(195, 64, 64, 1);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(handleAddDevice:) forControlEvents:UIControlEventTouchUpInside];
    if(IS_IPHONE_4)
    {
        button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.secondLabel.frame) + 35.0f, CGRectGetWidth(self.containerView.frame), 37);
        button.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    else if(IS_IPHONE_5)
    {
         button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.secondLabel.frame) + 40.0f, CGRectGetWidth(self.containerView.frame), 37);
        button.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    else if(IS_IPHONE_6)
    {
        button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.secondLabel.frame) + 45.0f, CGRectGetWidth(self.containerView.frame), 43);
        button.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    else if(IS_IPHONE_6_PLUS)
    {
        button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.secondLabel.frame) + 50.0f, CGRectGetWidth(self.containerView.frame), 47);
        button.titleLabel.font = [UIFont systemFontOfSize:17];
    }
    else if(IS_IPHONE_X)
        {
        button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.secondLabel.frame) + 50.0f, CGRectGetWidth(self.containerView.frame), 47);
        button.titleLabel.font = [UIFont systemFontOfSize:17];
        }
    else
    {
         button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.secondLabel.frame) + 145.0f, CGRectGetWidth(self.containerView.frame), 68);
        button.titleLabel.font = [UIFont systemFontOfSize:19];
    }
    return button;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)handleAddDevice:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Dashboard" bundle: [NSBundle mainBundle]];
    AddDeviceVC1 *controller  = [storyboard instantiateViewControllerWithIdentifier:@"AddDeviceVC1"];
    //_strCheck
//    controller.cancelButton = NO;
    
//    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
//    [self presentViewController:navController animated:YES completion:nil];

    [self.navigationController pushViewController:controller animated:YES];

}

@end
