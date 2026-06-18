//
//  LimitScreentimeActivatedPushViewController.h
//  FamilyTime - Dashboard
//
//  Created by Ahmad on 8/30/17.
//  Copyright © 2017 YumyApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LimitScreentimeActivatedPushViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *submitbuuton;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblSubTitle;

//@property (strong, nonatomic) NSDictionary *rowDic;

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *subTitle;


//@property (strong, nonatomic) IBOutlet UILabel *lblFirstLine;

@end
