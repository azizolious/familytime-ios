//
//  AddLimitScrenRule.h
//  FamilyTime - Dashboard
//
//  Created by Muhammad Ajmal on 05/08/2016.
//  Copyright © 2016 SoraCode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"

@interface AddLimitScrenRule : UIViewController
@property (nonatomic, assign) BOOL isNew;
@property (nonatomic, assign) BOOL isCustom;
@property (nonatomic, strong) AccessControlRuleModel *rule;
@property (nonatomic, strong) NSString *sunday_Day;
@property (nonatomic, strong) NSString *monday_Day;
@property (nonatomic, strong) NSString *tuesday_Day;
@property (nonatomic, strong) NSString *wednesday_Day;
@property (nonatomic, strong) NSString *thursday_Day;
@property (nonatomic, strong) NSString *friday_Day;
@property (nonatomic, strong) NSString *saturday_Day;
@end
