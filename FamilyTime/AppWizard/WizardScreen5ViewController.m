//
//  WizardScreen5ViewController.m
//  FamilyTime - Dashboard
//
//  Created by Muhammad Ajmal on 09/12/2015.
//  Copyright © 2015 SoraCode. All rights reserved.
//

#import "WizardScreen5ViewController.h"
#import "FTUtils.h"
#import "AppDelegate.h"
//#import <Google/Analytics.h>
#import "NSString+LockMustafa.h"

@interface WizardScreen5ViewController ()
@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *firstLabel;
@property (strong, nonatomic) UILabel *secondLabel;
@property (strong, nonatomic) UIImageView *logoImageView;
@property (strong, nonatomic) UIButton *gotoButton;
@property (nonatomic, strong) UILabel *thanksYouView;
@property (nonatomic, strong) UIImageView *arrowImageView;
@end

@implementation WizardScreen5ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)setupUI
{
    self.view.backgroundColor = RGBCOLOR(119, 107, 192, 1);
    
    self.containerView = [self setupContainerView];
    [self.view addSubview:self.containerView];
    
    self.titleLabel = [self setupTitleLabel];
    [self.containerView addSubview:self.titleLabel];
    
    self.firstLabel = [self setupFirstLabel];
    [self.containerView addSubview:self.firstLabel];
    
    self.secondLabel = [self setupSecondLabel];
    [self.containerView addSubview:self.secondLabel];
    
    self.logoImageView = [self setupLogoImage];
    [self.containerView addSubview:self.logoImageView];
    
    self.gotoButton = [self setupGotoButton];
    [self.containerView addSubview:self.gotoButton];
    
    self.thanksYouView = [self setupThankYouView];
    [self.view addSubview:self.thanksYouView];
    
    self.arrowImageView = [self setupArrowImageView];
    [self.view addSubview:self.arrowImageView];
}

- (UILabel *)setupThankYouView
{
    UILabel *container;
    UIImageView *addButton;
    [addButton setBackgroundColor:RGBCOLOR(119, 107, 192, 1)];
    
    if(IS_IPHONE_4)
    {
        container = [[UILabel alloc] initWithFrame:CGRectMake(0, 22, CGRectGetWidth(self.view.bounds), 40)];
        container.font = [UIFont fontWithName:@"OpenSans" size:15];
        
        addButton = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(container.frame) - 30.0f - 10.0f, CGRectGetMidY(container.bounds) - 15.0f, 30.0f, 30.0f)];
        addButton.image = [UIImage imageNamed:@"ic_add_button_ipad"];
    }
    else if(IS_IPHONE_5)
    {
        container = [[UILabel alloc] initWithFrame:CGRectMake(0, 38, CGRectGetWidth(self.view.bounds), 45)];
        container.font = [UIFont fontWithName:@"OpenSans" size:15];
        
        addButton = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(container.frame) - 35.0f - 10.0f, CGRectGetMidY(container.bounds) - 17.5f, 35.0f, 35.0f)];
        addButton.image = [UIImage imageNamed:@"ic_add_button_ipad"];
    }
    else if(IS_IPHONE_6)
    {
        container = [[UILabel alloc] initWithFrame:CGRectMake(0, 46, CGRectGetWidth(self.view.bounds), 50)];
        container.font = [UIFont fontWithName:@"OpenSans" size:15];
        
        addButton = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(container.frame) - 36.0f - 12.0f, CGRectGetMidY(container.bounds) - 18, 36.0f, 36.0f)];
        addButton.image = [UIImage imageNamed:@"ic_add_button_ipad"];
    }
    else if(IS_IPHONE_6_PLUS)
    {
        container = [[UILabel alloc] initWithFrame:CGRectMake(0, 53, CGRectGetWidth(self.view.bounds), 55)];
        container.font = [UIFont fontWithName:@"OpenSans" size:15];
        
        addButton = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(container.frame) - 36.0f - 12.0f, CGRectGetMidY(container.bounds) - 18, 36.0f, 36.0f)];
        addButton.image = [UIImage imageNamed:@"ic_add_button_ipad"];
    }
    else
    {
        container = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, CGRectGetWidth(self.view.bounds), 76.0f)];
        container.font = [UIFont fontWithName:@"OpenSans" size:25];
        
        addButton = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(container.frame) - 50.0f - 20.0f, CGRectGetMidY(container.bounds) - 25.0f, 50.0f, 50.0f)];
        addButton.image = [UIImage imageNamed:@"ic_add_button_ipad"];
    }
    container.userInteractionEnabled = YES;
    container.backgroundColor = RGBCOLOR(90, 80, 150, 1);
    container.text = @"";
    container.textAlignment = NSTextAlignmentLeft;
    container.textColor = [UIColor whiteColor];
    
    [container addSubview:addButton];
    
    return container;
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
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, CGRectGetWidth(self.containerView.bounds), 25)];
        label.font = [UIFont fontWithName:@"OpenSans-Semibold" size:20];
    }
    else if(IS_IPHONE_5)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 125, CGRectGetWidth(self.containerView.bounds), 25)];
        label.font = [UIFont fontWithName:@"OpenSans-Semibold" size:20];
    }
    else if(IS_IPHONE_6)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, CGRectGetWidth(self.containerView.bounds), 28)];
        label.font = [UIFont fontWithName:@"OpenSans-Semibold" size:23];
    }
    else if(IS_IPHONE_6_PLUS)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 165, CGRectGetWidth(self.containerView.bounds), 35)];
        label.font = [UIFont fontWithName:@"OpenSans-Semibold" size:25];
    }
    else
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 210, CGRectGetWidth(self.containerView.bounds), 55)];
        label.font = [UIFont fontWithName:@"OpenSans-Semibold" size:38];
    }
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"That's All";
    return label;
}

- (UILabel *)setupFirstLabel
{
    UILabel *label;
    if(IS_IPHONE_4)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.titleLabel.frame) + 28.0f, CGRectGetWidth(self.containerView.bounds), 60.0f)];
        label.font = [UIFont fontWithName:@"OpenSans-Light" size:14];
    }
    else if(IS_IPHONE_5)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.titleLabel.frame) + 28.0f, CGRectGetWidth(self.containerView.bounds), 65.0f)];
        label.font = [UIFont fontWithName:@"OpenSans-Light" size:14];
    }
    else if(IS_IPHONE_6)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.titleLabel.frame) + 35.0f, CGRectGetWidth(self.containerView.bounds), 75.0f)];
        label.font = [UIFont fontWithName:@"OpenSans-Light" size:16];
    }
    else if(IS_IPHONE_6_PLUS)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.titleLabel.frame) + 35.0f, CGRectGetWidth(self.containerView.bounds), 80.0f)];
        label.font = [UIFont fontWithName:@"OpenSans-Light" size:17];
    }
    else
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.titleLabel.frame) + 70.0f, CGRectGetWidth(self.containerView.bounds), 100)];
        label.font = [UIFont fontWithName:@"OpenSans-Light" size:23];
    }
    label.backgroundColor = [UIColor clearColor];
    label.textColor = RGBCOLOR(229, 225, 255, 1);
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
//    label.text = [@"You have successfully added the new device. To add another device, click on + sign from  your Dashboard." myModification];
 
    //You have successfully added the new device. To add another device
    
    label.text =[NSString stringWithFormat:@"%@, click on + sign from  your Dashboard.",[@"You have successfully added the new device. To add another device" myModification]];
    
    return label;
}

- (UILabel *)setupSecondLabel
{
    UILabel *label;
    if(IS_IPHONE_4)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.firstLabel.frame) + 14.0f, CGRectGetWidth(self.containerView.frame), 40.0f)];
        label.font = [UIFont fontWithName:@"OpenSans-Light" size:14];
    }
    else if(IS_IPHONE_5)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.firstLabel.frame) + 16.0f, CGRectGetWidth(self.containerView.frame), 40.0f)];
        label.font = [UIFont fontWithName:@"OpenSans-Light" size:14];
    }
    else if(IS_IPHONE_6)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.firstLabel.frame) + 22.0f, CGRectGetWidth(self.containerView.frame), 50.0f)];
        label.font = [UIFont fontWithName:@"OpenSans-Light" size:16];
    }
    else if(IS_IPHONE_6_PLUS)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.firstLabel.frame) + 22.0f, CGRectGetWidth(self.containerView.frame), 60.0f)];
        label.font = [UIFont fontWithName:@"OpenSans-Light" size:17];
    }
    else
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.firstLabel.frame) + 30.0f, CGRectGetWidth(self.containerView.frame), 75)];
        label.font = [UIFont fontWithName:@"OpenSans-Light" size:23];
    }
    label.backgroundColor = [UIColor clearColor];
    label.textColor = RGBCOLOR(229, 225, 255, 1);
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.text = [@"To explore FamilyTime's features, go to your Dashboard and experience Smart Parenting." myModification];
    return label;
}

- (UIImageView *)setupLogoImage
{
    UIImageView *imageView;
    if(IS_IPHONE_4)
    {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.containerView.bounds) - 97/2.0f, CGRectGetMaxY(self.secondLabel.frame) + 27.0f, 97, 103)];
        imageView.image = [UIImage imageNamed:@"ic_logo"];
    }
    else if(IS_IPHONE_5)
    {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.containerView.bounds) - 97/2.0f, CGRectGetMaxY(self.secondLabel.frame) + 27.0f, 97, 103)];
        imageView.image = [UIImage imageNamed:@"ic_logo"];
    }
    else if(IS_IPHONE_6)
    {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.containerView.bounds) - 129/2.0f, CGRectGetMaxY(self.secondLabel.frame) + 45.0f, 129, 138)];
        imageView.image = [UIImage imageNamed:@"ic_logo"];
    }
    else if(IS_IPHONE_6_PLUS)
    {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.containerView.bounds) - 129/2.0f, CGRectGetMaxY(self.secondLabel.frame) + 50.0f, 129, 138)];
        imageView.image = [UIImage imageNamed:@"ic_logo"];
    }
    else
    {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.containerView.bounds) - 168.0f/2.0f, CGRectGetMaxY(self.secondLabel.frame) + 80.0f, 168, 180)];
        imageView.image = [UIImage imageNamed:@"ic_logo_ipad"];
    }
    return imageView;
}

- (UIButton *)setupGotoButton
{
    

    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:[@"GO TO DASHBOARD" myModification] forState:UIControlStateNormal];
    button.backgroundColor = RGBCOLOR(90, 80, 150, 1);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(handleGoto:) forControlEvents:UIControlEventTouchUpInside];
    if(IS_IPHONE_4)
    {
        button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.logoImageView.frame) + 20.0f, CGRectGetWidth(self.containerView.frame), 37);
        button.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    else if(IS_IPHONE_5)
    {
        button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.logoImageView.frame) + 45.0f, CGRectGetWidth(self.containerView.frame), 37);
        button.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    else if(IS_IPHONE_6)
    {
        button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.logoImageView.frame) + 50.0f, CGRectGetWidth(self.containerView.frame), 43);
        button.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    else if(IS_IPHONE_6_PLUS)
    {
        button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.logoImageView.frame) + 55.0f, CGRectGetWidth(self.containerView.frame), 47);
        button.titleLabel.font = [UIFont systemFontOfSize:17];
    }
    else
    {
        button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.logoImageView.frame) + 80.0f, CGRectGetWidth(self.containerView.frame), 68);
        button.titleLabel.font = [UIFont systemFontOfSize:19];
    }
    return button;
}

- (UIImageView *)setupArrowImageView
{
    UIImageView *imageView;
    if(IS_IPHONE_4)
    {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.view.bounds) - 39.0f - 10 - 15, CGRectGetMaxY(self.thanksYouView.frame), 39, 72)];
        imageView.image = [UIImage imageNamed:@"ic_arrow"];
    }
    else if(IS_IPHONE_5)
    {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.view.bounds) - 39.0f - 10 - 17.5, CGRectGetMaxY(self.thanksYouView.frame), 39, 72)];
        imageView.image = [UIImage imageNamed:@"ic_arrow"];
    }
    else if(IS_IPHONE_6)
    {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.view.bounds) - 52.0f - 12 - 20, CGRectGetMaxY(self.thanksYouView.frame), 52, 96)];
        imageView.image = [UIImage imageNamed:@"ic_arrow"];
    }
    else if(IS_IPHONE_6_PLUS)
    {
       imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.view.bounds) - 52.0f - 12 - 20, CGRectGetMaxY(self.thanksYouView.frame), 52, 96)];
        imageView.image = [UIImage imageNamed:@"ic_arrow"];
    }
    else
    {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.view.bounds) - 105 - 20 - 25, CGRectGetMaxY(self.thanksYouView.frame), 105, 194)];
        imageView.image = [UIImage imageNamed:@"ic_arrow_ipad"];
    }
    return imageView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleGoto:(id)sender
{
//    [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"stoplogincheck"];
//    [[NSUserDefaults standardUserDefaults]synchronize];

    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]) setupDrawer: 0];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
