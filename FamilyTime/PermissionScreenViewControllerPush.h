//
//  PermissionScreenViewControllerPush.h
//  FamilyTime
//
//  Created by Ahmad Mustafa on 03/05/2018.
//  Copyright © 2018 YumyApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PermissionScreenViewControllerPush : UIViewController
@property (strong, nonatomic) NSDictionary *rowDic;
@property (strong, nonatomic) NSString *strDeviceName;

@property (strong, nonatomic) IBOutlet UILabel *lblTitleName;
@property (strong, nonatomic) IBOutlet UILabel *lblFirstLine;
@property (strong, nonatomic) IBOutlet UILabel *lbl2;
@property (strong, nonatomic) IBOutlet UILabel *lbl3;
@property (strong, nonatomic) IBOutlet UILabel *lbl4;
@property (strong, nonatomic) IBOutlet UILabel *lbl5;
@property (strong, nonatomic) IBOutlet UILabel *lbl6;


@property (strong, nonatomic) IBOutlet UILabel *lblHead;
@property (strong, nonatomic) IBOutlet UILabel *lblSubHead;


@end
