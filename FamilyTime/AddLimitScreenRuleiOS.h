//
//  AddLimitScreenRuleiOS.h
//  FamilyTime - Dashboard
//
//  Created by Rao Mudassar Khalil on 05/07/2021.
//  Copyright © 2021 YumyApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"

@interface AddLimitScreenRuleiOS : UIViewController
@property (nonatomic, assign) BOOL isNew;
@property (nonatomic, assign) BOOL isCustom;
@property (nonatomic, strong) RuleModel *rule;
@property (nonatomic, strong) NSString *sunday_Day;
@property (nonatomic, strong) NSString *monday_Day;
@property (nonatomic, strong) NSString *tuesday_Day;
@property (nonatomic, strong) NSString *wednesday_Day;
@property (nonatomic, strong) NSString *thursday_Day;
@property (nonatomic, strong) NSString *friday_Day;
@property (nonatomic, strong) NSString *saturday_Day;
@end
