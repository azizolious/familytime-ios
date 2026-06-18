 //
//  BaseViewController.m
//  FamilyTime
//
//  Created by Sora Code on 3/2/15.
//  Copyright (c) 2015 SoraCode. All rights reserved.
//

#import "NSString+LockMustafa.h"

#import "BaseViewController.h"
#import "FTUtils.h"
#import "NSString+LockMustafa.h"
#import "FamilyTime-Swift.h"

@implementation PremiumBannerView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat titleFont;
        CGFloat detailFont;
        if(IS_IPHONE_4)
        {
            titleFont = 14;
            detailFont = 10;
        }
        else if(IS_IPHONE_5)
        {
            titleFont = 14;
            detailFont = 10;
        }
        else if(IS_IPHONE_6)
        {
            titleFont = 15;
            detailFont = 11;
        }
        else if(IS_IPHONE_6_PLUS)
        {
            titleFont = 16;
            detailFont = 12;
        }
        else if(IS_IPHONE_X)
        {
            titleFont = 16;
            detailFont = 12;
        }
        else
        {
            titleFont = 18;
            detailFont = 14;
        }
        
        self.backgroundColor = RGBCOLOR(226, 226, 226, 1);
        self.imageview = [[UIImageView alloc] initWithFrame:CGRectMake(10.0f, CGRectGetMidY(self.bounds) - 40.0f, 80.0f, 80.0f)];
        self.imageview.image = [UIImage imageNamed:@"ic_premium"];
        [self addSubview:self.imageview];
        
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.imageview.frame) + 10.0f, CGRectGetMinY(self.imageview.frame), CGRectGetMaxX(self.bounds) - CGRectGetMaxX(self.imageview.frame) - 20.0f, 80.0f)];
        self.label.numberOfLines = 0;
        self.label.backgroundColor = [UIColor clearColor];
        [self addSubview:self.label];
        
        NSMutableAttributedString *finalStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n",[@"Limited Report Data!" myModification]] attributes:@{NSFontAttributeName : [UIFont fontWithName:@"OpenSans-Semibold" size:titleFont],
                                                                                                                                     NSForegroundColorAttributeName : RGBCOLOR( 68, 68, 68, 1)}];
        
        NSMutableAttributedString *added1 = [[NSMutableAttributedString alloc] initWithString:[@"This Report has been limited." myModification] attributes:@{NSFontAttributeName : [UIFont fontWithName:@"OpenSans-Light" size:detailFont],
                                                                                                                                       NSForegroundColorAttributeName : RGBCOLOR(79, 79, 79, 1)}];
        
        NSMutableAttributedString *added2 = [[NSMutableAttributedString alloc] initWithString:[@"in_app_purchase_content_5" myModification] attributes:@{NSFontAttributeName : [UIFont fontWithName:@"OpenSans-Light" size:detailFont],
                                                                                                                                           NSForegroundColorAttributeName : RGBCOLOR(79, 79, 79, 1)}];
        
        //---SANA CHANGE---//---UPDATE CONTENT FOR IAP ACCORDINGLY---//
        
        
//        NSMutableAttributedString *added2 = [[NSMutableAttributedString alloc] initWithString:[@" has been limited. Please login to" myModification] attributes:@{NSFontAttributeName : [UIFont fontWithName:@"OpenSans-Light" size:detailFont],
//                                                                                                                          NSForegroundColorAttributeName : RGBCOLOR(79, 79, 79, 1)}];
////
//        NSMutableAttributedString *added3 = [[NSMutableAttributedString alloc] initWithString:[@" Web Dashboard " myModification] attributes:@{NSFontAttributeName : [UIFont fontWithName:@"OpenSans" size:detailFont],
//                                                                                                                                                 NSForegroundColorAttributeName : RGBCOLOR(68, 68, 68, 1)}];
//
//        NSMutableAttributedString *added4 = [[NSMutableAttributedString alloc] initWithString:[@"to renew the subscription and enjoy unrestricted access. " myModification] attributes:@{NSFontAttributeName : [UIFont fontWithName:@"OpenSans-Light" size:detailFont],
//                                                                                                                              NSForegroundColorAttributeName : RGBCOLOR(79, 79, 79, 1)}];
        
        
        
        [finalStr appendAttributedString:added1];
        [finalStr appendAttributedString:added2];
//        [finalStr appendAttributedString:added3];
//        [finalStr appendAttributedString:added4];
        
        
        self.label.attributedText = finalStr;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
}
@end

@interface BaseViewController ()
@end

@implementation BaseViewController

-(void)viewWillAppear:(BOOL)animated{
//    NSLog(@"title *** %@",self.title);
    if(self.title != nil)
        self.title = [NSString stringWithFormat:@"%@",self.title ];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [[UIDevice currentDevice] setValue: [NSNumber numberWithInteger: UIInterfaceOrientationPortrait] forKey:@"orientation"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(BOOL) shouldAutorotate {
    return NO;
}

//- (NSUInteger)supportedInterfaceOrientations
//{
//    return  UIInterfaceOrientationMaskPortrait;
//}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (void)showPremiumFeatureView:(BOOL)show
{
    if (show)
    {
        self.premiumFeatureView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
        self.premiumFeatureView.image = [SwiftFTUtils isDeviceiPhoneFamily] ? [UIImage imageNamed:@"premium-reports"] : [UIImage imageNamed:@"premium-reports-ipad"];
        self.premiumFeatureView.contentMode = UIViewContentModeScaleAspectFill;
        [self.view addSubview:self.premiumFeatureView];
    }
    else
    {
        [self.premiumFeatureView removeFromSuperview];
        self.premiumFeatureView = nil;
    }
}

- (void)showPremiumBanner:(BOOL)show
{
    if(show)
    {
        self.premiumBannerView = [[PremiumBannerView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.bounds), 120.0f)];
        [self.view addSubview:self.premiumBannerView];
    }
    else
    {
        [self.premiumBannerView removeFromSuperview];
        self.premiumBannerView = nil;
    }
}

- (void) showHUDLoader:(UIView *)view {
    [SwiftFTUtils showHUDAddedTo:view withText:@"Loading..." animated:YES];
}

- (void) hideHUDLoader:(UIView *)view {
    [SwiftFTUtils hideHUDAddedTo:view animated:NO];
}

@end
