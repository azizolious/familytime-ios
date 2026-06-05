//
//  BaseViewController.h
//  FamilyTime
//
//  Created by Sora Code on 3/2/15.
//  Copyright (c) 2015 SoraCode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonModel.h"

@interface PremiumBannerView : UIView
@property (nonatomic, strong) UIImageView *imageview;
@property (nonatomic, strong) UILabel *label;
@end

@interface BaseViewController : UIViewController <UINavigationControllerDelegate>
@property (nonatomic, strong) PremiumBannerView *premiumBannerView;
@property (nonatomic, strong) UIImageView *premiumFeatureView;
- (void)showPremiumBanner:(BOOL)show;
- (void)showPremiumFeatureView:(BOOL)show;
- (void) showHUDLoader:(UIView *)view;
- (void) hideHUDLoader:(UIView *)view;
@end
