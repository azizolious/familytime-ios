//
//  DashboardInactiveCell.h
//  FamilyTime - Dashboard
//
//  Created by Muhammad Ajmal on 20/10/2016.
//  Copyright © 2016 SoraCode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dashboard.h"

@protocol DashboardInactiveCellDelegate <NSObject>
@optional
- (void)handleProfileWith:(DashboardCoParent *)coparent;
//- (void)handleHowToInstall;
- (void)handleStep2:(NSString *)strName and:(NSString *)gender;
- (void)handleProfileActionWith:(DashboardChild *)child;

- (void)handleInactiveMenuWith:(DashboardChild *)child withButton:(UIButton *)btn with:(NSIndexPath *)indexPath;
- (void)handleInactivePairWith:(DashboardChild *)child withButton:(UIButton *)btn with:(NSIndexPath *)indexPath;

@end

@interface DashboardInactiveCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UIView *leftContainer;
@property (weak, nonatomic) IBOutlet UIView *cellContainerView;
@property (nonatomic, strong) DashboardChild *child;
@property (nonatomic, strong) DashboardCoParent *coparent;
@property (nonatomic, weak) id<DashboardInactiveCellDelegate> delegate;

@property (nonatomic, strong) NSIndexPath *cellIndexPath;
@property (weak, nonatomic) IBOutlet UIView *howToActivateVu;

@property (weak, nonatomic) IBOutlet UIButton *pairBtn;

@end
