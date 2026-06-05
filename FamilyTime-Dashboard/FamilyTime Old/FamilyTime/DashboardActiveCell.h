//
//  DashboardActiveCell.h
//  FamilyTime - Dashboard
//
//  Created by Muhammad Ajmal on 20/10/2016.
//  Copyright © 2016 SoraCode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dashboard.h"
#import <MBCircularProgressBar/MBCircularProgressBarView.h>

@protocol DashboardActiveCellDelegate <NSObject>

@optional
- (void)handleReportsWith:(DashboardChild *)child;
- (void)handleSettingsWith:(DashboardChild *)child;
- (void)handleUpgradeWith:(DashboardChild *)child;
- (void)handleLockWith:(DashboardChild *)child;
- (void)handleExpired;

- (void)handleActiveMenuWith:(DashboardChild *)child withButton:(UIButton *)btn with:(NSIndexPath *)indexPath;
- (void)handleActivePairWith:(DashboardChild *)child withButton:(UIButton *)btn with:(NSIndexPath *)indexPath;
- (void)handleZeroProgressWith:(DashboardChild *)child; //---TAKE USER TO DAILY LIMIT SCREEN IF 00 DAILY LIMIT---//
- (void)handleProgressWith:(DashboardChild *)child;  //---GET LATEST APP USAGE IF DAILY LIMIT IS NOT 00---//

- (void)handleProfileActionWith:(DashboardChild *)child;

@end

@interface DashboardActiveCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UILabel *centerLabel;

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UIImageView *centerImageView;

@property (weak, nonatomic) IBOutlet UIView *leftContainer;
@property (weak, nonatomic) IBOutlet UIView *rightContainer;
@property (weak, nonatomic) IBOutlet UIView *centerContainer;
@property (weak, nonatomic) IBOutlet UIView *cellContainerView;


@property (nonatomic, weak)   id<DashboardActiveCellDelegate> delegate;
@property (nonatomic, strong) DashboardChild *child;



//---SANA CHANGES---//
@property (weak, nonatomic) IBOutlet MBCircularProgressBarView *progressVu;

@property (weak, nonatomic) IBOutlet UIView   *expiredVu;
@property (weak, nonatomic) IBOutlet UILabel  *subscriptoinExpiredLbl;
@property (weak, nonatomic) IBOutlet UILabel  *timeLeftLbl;
@property (weak, nonatomic) IBOutlet UILabel  *hourMintLbl;
@property (weak, nonatomic) IBOutlet UIButton *pairBtn;

@property (nonatomic, strong) NSIndexPath *cellIndexPath;

@end
