//
//  LimitScreenCell.h
//  FamilyTime - Dashboard
//
//  Created by Muhammad Ajmal on 04/08/2016.
//  Copyright © 2016 SoraCode. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "DataModel.h"

@protocol LimitScreenCellDelegate <NSObject>
@optional
- (void)didRuleStatusChanged:(BOOL)isActive indexPath:(NSIndexPath *)indexPath;
- (void)didOptionButtonTapped :(NSIndexPath *)indexPath;
@end

@interface LimitScreenCell : UITableViewCell
@property (nonatomic,strong) AccessControlRuleModel *rule;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) UISwitch *switchView;
@property (nonatomic, weak) id<LimitScreenCellDelegate> delegate;
@end
