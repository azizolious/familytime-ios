//
//  PremiumAlertController.h
//  FamilyTime - Dashboard
//
//  Created by Muhammad Ajmal on 14/12/2015.
//  Copyright © 2015 SoraCode. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "BIZPopupViewController.h"

@interface PremiumAlertController : UIViewController
@property (nonatomic, strong) NSString *alertTitle;
@property (nonatomic, strong) NSString *firstParagraph;
@property (nonatomic, strong) NSString *firstTitle;
@property (nonatomic, strong) NSString *firstDetails;
@property (nonatomic, strong) NSString *secondTitle;
@property (nonatomic, strong) NSString *secondDetails;
@property (nonatomic, strong) NSString *imagename;
@property (nonatomic, strong) NSString *color;
//@property (nonatomic, weak) BIZPopupViewController *container;
@end
