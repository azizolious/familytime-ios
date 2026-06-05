//
//  DashboardActiveCell.m
//  FamilyTime - Dashboard
//
//  Created by Muhammad Ajmal on 20/10/2016.
//  Copyright © 2016 SoraCode. All rights reserved.
//

#import "DashboardActiveCell.h"
#import "UIView+VTSelectiveBorder.h"
#import "CommonModel.h"
#import "AppDelegate.h"
#import "FTUtils.h"
#import "NSString+LockMustafa.h"
#import "FamilyTime-Swift.h"

@interface DashboardActiveCell ()
@property (nonatomic, strong) UITapGestureRecognizer *rightTapGesture;
@property (nonatomic, strong) UITapGestureRecognizer *expiredGesture;
@property (nonatomic, strong) UITapGestureRecognizer *zeroProgressGesture;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarTopSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelTopSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *packageLabelTopSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftContainerHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightContainerHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerContainerHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftImageLeftMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftImageHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftImageWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftLabelLeading;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerImageLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerImageHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerImageWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerLabelLeading;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightImageLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightImageHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightImageWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightLabelLeading;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *expiredVuHeightConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *expiredVuWidthConst;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressVuHeightConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressVuWidthConst;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *expiredIconCenterConst;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pairBtnWidthConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pairBtnHeightConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuBtnWidthConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuBtnHeightConst;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pairBtnLeadingConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pairBtnBottomConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuBtnTrailingConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuBtnTopConst;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLeadingConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressVuCenterVerticallyConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *expiredVuCenterVerticallyConst;

@end
@implementation DashboardActiveCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.cellContainerView.layer.cornerRadius = 5.0f;
    self.cellContainerView.layer.masksToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.centerContainer.selectiveBorderFlag = AUISelectiveBordersFlagRight|AUISelectiveBordersFlagLeft;
    self.centerContainer.selectiveBordersColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5f];
    self.centerContainer.selectiveBordersWidth = 0.5f;
    
    self.expiredVu.layer.borderColor = [[UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1.0] CGColor];
    self.expiredVu.layer.borderWidth = 2.0;
    
    if(![SwiftFTUtils isDeviceiPhoneFamily])
    {
        self.nameLabel.font     = [UIFont fontWithName:@"OpenSans-Light" size:18];
        self.leftLabel.font     = [UIFont fontWithName:@"OpenSans-Light" size:18];
        self.rightLabel.font    = [UIFont fontWithName:@"OpenSans-Light" size:18];
        self.centerLabel.font   = [UIFont fontWithName:@"OpenSans-Light" size:18];
        
        
        self.timeLeftLbl.font               = [UIFont fontWithName:@"Dosis-Regular" size:16];
        self.hourMintLbl.font               = [UIFont fontWithName:@"Dosis-Regular" size:16];
        self.subscriptoinExpiredLbl.font    = [UIFont fontWithName:@"Dosis-Regular" size:14];
        
        
        self.avatarTopSpace.constant        = 12;
        self.avatarWidth.constant           = 45;
        self.avatarHeight.constant          = 45;
        
        self.leftContainerHeight.constant   = 75;
        self.rightContainerHeight.constant  = 75;
        self.centerContainerHeight.constant = 75;
        
        
        self.leftImageWidth.constant        = 48;
        self.leftImageHeight.constant       = 48;
        self.centerImageWidth.constant      = 48;
        self.centerImageHeight.constant     = 48;
        self.rightImageWidth.constant       = 48;
        self.rightImageHeight.constant      = 48;
        
        self.leftImageLeftMargin.constant   = 45;
        self.leftLabelLeading.constant      = 10;
        self.centerImageLeading.constant    = 45;
        self.centerLabelLeading.constant    = 10;
        self.rightImageLeading.constant     = 45;
        self.rightLabelLeading.constant     = 10;
        
        
        self.expiredVuHeightConst.constant  = 200;
        self.expiredVuWidthConst.constant   = 200;
        self.expiredVu.layer.cornerRadius   = 100;
        
        self.progressVuWidthConst.constant  = 200;
        self.progressVuHeightConst.constant = 200;
        
        self.progressVuCenterVerticallyConst.constant = -35;
        self.expiredVuCenterVerticallyConst.constant  = -35;
        
        self.pairBtnWidthConst.constant     = 30;
        self.pairBtnHeightConst.constant    = 30;
        self.menuBtnWidthConst.constant     = 30;
        self.menuBtnHeightConst.constant    = 30;
        
        self.pairBtnLeadingConst.constant   = 20;
        self.pairBtnBottomConst.constant    = 20;
        self.menuBtnTopConst.constant       = 20;
        self.menuBtnTrailingConst.constant  = 14;
        self.nameLeadingConst.constant      = 20;
    }
    
//    self.rightLabel.adjustsFontSizeToFitWidth   = YES;
//    self.centerLabel.adjustsFontSizeToFitWidth  = YES;
//    self.leftLabel.adjustsFontSizeToFitWidth    = YES;

    
    UITapGestureRecognizer *reportsTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleReports:)];
    [self.leftContainer addGestureRecognizer:reportsTapGesture];
    
    UITapGestureRecognizer *settingsTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSettings:)];
    [self.centerContainer addGestureRecognizer:settingsTapGesture];
}

- (void)setChild:(DashboardChild *)child
{
    self.leftLabel.text   = NSLocalizedString(@"Reports", nil);
    self.centerLabel.text = NSLocalizedString(@"Settings", nil);
    self.subscriptoinExpiredLbl.text = NSLocalizedString(@"SUBSCRIPTION\nEXPIRED", nil);
    
    _child = child;
    
    self.avatarImageView.image  = [UIImage imageNamed:[child.gender.lowercaseString isEqualToString:@"male"] ? @"avatar_boy1" : @"avatar_girl1"];
    self.nameLabel.text         = child.name;
    
    [self handleActiveInactive];

    
    //---ADD LOCK GESTURE---WILL BE OVERIDE IF ITS UPDATE----//
    self.rightTapGesture    = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleLock:)];
    [self.rightContainer    addGestureRecognizer:self.rightTapGesture];
    
    
    //---SHOW/HIDE SUBSCRIPTION VIEW AND COLOR---//
    if (child.package_id == 1 || child.package_id == 6){
        self.cellContainerView.backgroundColor = [CommonModel colorFromHexString:kDarkGray];
        [self.expiredVu setHidden:false];
        [self.progressVu setHidden:true];
        
        [self.rightImageView setImage:[UIImage imageNamed:@"ic_upgrade"]];
        [self.rightLabel     setText:NSLocalizedString(@"Upgrade", nil)];
        [self.rightLabel     setTextColor:KDashboardRedColor()];
        
        self.expiredGesture  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleUpgrade:)];
        self.rightTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleUpgrade:)];
        
        [self.expiredVu         addGestureRecognizer:self.expiredGesture];
        [self.rightContainer    addGestureRecognizer:self.rightTapGesture];
    }
    else{
        self.cellContainerView.backgroundColor = [CommonModel colorFromHexString:child.color];
        [self.expiredVu setHidden:true];
        
//        [self.rightLabel setTextColor:KDashboardRedColor()];
        
        //---ANDROID = 1 OR IOS = 2---//
        if (child.plateform_id == 1)
        {
            [self handleAndroidCaseWithChild:child];
        }
        else{//---IOS CASE---//
            [self.progressVu setHidden:true];
            
//            if(child.active == 1)
//                [self.pairBtn setImage:[UIImage imageNamed:@"ic_pair"] forState:UIControlStateNormal];
//            else
//                [self.pairBtn setImage:[UIImage imageNamed:@"ic_not_pair"] forState:UIControlStateNormal];
        }
    }
    
    //---THIS IS SAME NOW, BEFORE IT WAS CHECKED ON ENROLLED, NOT MDM IS REMOVED SO, NOW IT IS CONNECTED TO ACTIVE AS ANDROID---//
    if(child.active == 1)
        [self.pairBtn setImage:[UIImage imageNamed:@"ic_pair"] forState:UIControlStateNormal];
    else
        [self.pairBtn setImage:[UIImage imageNamed:@"ic_not_pair"] forState:UIControlStateNormal];
    
    //---hide for testing---//
//    [self.progressVu setHidden:true];
    
}

#pragma mark - CUSTOM METHODS

-(void)handleActiveInactive{
    //---DUE TO APPLE RESTRICTION, ONLY SHOW ACTIVE AND INACTIVE FOR IOS CHILD---//
    
    
    //---AS MDM FUNCTIONALITIES REMOVED, SO ONLY SHOW THIS---//
    //---MDM REMOVED FOR IOS CHILD---//---IN 221 BUILD---//---MDM---//---AGAIN REMOVED IN 240 BUILD---//
    
    /*
    if (self.child.plateform_id == 1)
    {
        if (self.child.phonelock_status == 0){
            self.rightImageView.image   = [UIImage imageNamed:@"ic_unpause"];
            self.rightLabel.text        = NSLocalizedString(@"In-use", nil);
            [self.rightLabel setTextColor:KDashboardGreyBtnColor()];
        }
        else{
            self.rightImageView.image   = [UIImage imageNamed:@"ic_pause"];
            self.rightLabel.text        = NSLocalizedString(@"Paused", nil);
            [self.rightLabel     setTextColor:KDashboardRedColor()];
        }
    }
    else
    {
        [self.rightImageView setImage:[UIImage imageNamed:@"ic_active"]];
        self.rightLabel.text        = NSLocalizedString(@"Active", nil);
        [self.rightLabel setTextColor:KDashboardBlueBtnColor()];
    }
    
     */
    
    ///*
     //---TO ACTIVATE MDM FEATURES UNCOMMENT BELOW CODE AND COMMENT ABOVE---//
     
     if (self.child.phonelock_status == 0){
         self.rightImageView.image   = [UIImage imageNamed:@"ic_unpause"];
         self.rightLabel.text        = NSLocalizedString(@"In-use", nil);
         [self.rightLabel setTextColor:KDashboardGreyBtnColor()];
     }
     else{
         self.rightImageView.image   = [UIImage imageNamed:@"ic_pause"];
         self.rightLabel.text        = NSLocalizedString(@"Paused", nil);
         [self.rightLabel     setTextColor:KDashboardRedColor()];
     }
     
     //*/
}

-(void)handleAndroidCaseWithChild:(DashboardChild *)child{
    [self.progressVu setHidden:false];
    NSLog(@"dailyLimit = %@", child.dailyLimit);
    
//    if(child.active == 1)
//        [self.pairBtn setImage:[UIImage imageNamed:@"ic_pair"] forState:UIControlStateNormal];
//    else
//        [self.pairBtn setImage:[UIImage imageNamed:@"ic_not_pair"] forState:UIControlStateNormal];
    
    
    if (child.dailyLimit.is_active == 0){
        self.timeLeftLbl.text = NSLocalizedString(@"SET DAILY APP LIMIT", nil);
        [self showZeroProgress];
    }
    else{
        self.timeLeftLbl.text = NSLocalizedString(@"TIME LEFT TODAY", nil);
        [self setProgressForChild:child];
    }
}

-(void)setProgressForChild:(DashboardChild *)child{
    float result = ((child.dailyLimit.remaining_limit  * 100) / child.dailyLimit.duration);
    NSLog(@"remainingLimit = %f duration = %f and final result = %f", child.dailyLimit.remaining_limit, child.dailyLimit.duration, result);
    
    //---LOWER BOUND CHECK---//---IF MINUS THEN SHOW 0---//
    if (result < 0 || result != result)//---(result != result)---THIS CHECK FOR NAN---//---NOT A NUMBER---//
        [self showZeroProgress];
    else
        [self showNonZeroProgressWithResult:result andChild:child];
}

-(void)showZeroProgress{
    self.progressVu.value = 0;
    self.hourMintLbl.text = NSLocalizedString(@"00Hr : 00Min", nil);
    
    self.zeroProgressGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleZeroProgress:)];
    [self.progressVu addGestureRecognizer:self.zeroProgressGesture];
}

-(void)showNonZeroProgressWithResult:(float)result andChild:(DashboardChild*)child{
    NSLog(@"result = %f", result);
    if (result > 100)//---UPPER BOUND CHECK---//
        result = 100;
    self.progressVu.value = result;
    self.hourMintLbl.text = [CommonModel getHoursMinutesFromSeconds:child.dailyLimit.remaining_limit];
    
    self.zeroProgressGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDailyLimitProgress:)];
    [self.progressVu addGestureRecognizer:self.zeroProgressGesture];
}


#pragma mark - DELEGATE METHODS

- (void)handleReports:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        if ([self.delegate respondsToSelector:@selector(handleReportsWith:)])
            [self.delegate handleReportsWith:self.child];
    }
}

- (void)handleSettings:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        if ([self.delegate respondsToSelector:@selector(handleSettingsWith:)])
            [self.delegate handleSettingsWith:self.child];
    }
}

- (void)handleUpgrade:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        if ([self.delegate respondsToSelector:@selector(handleUpgradeWith:)])
            [self.delegate handleUpgradeWith:self.child];
    }
}

// handleZeroProgress
- (void)handleZeroProgress:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        if ([self.delegate respondsToSelector:@selector(handleZeroProgressWith:)])
            [self.delegate handleZeroProgressWith:self.child];
    }
}


- (void)handleDailyLimitProgress:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        if ([self.delegate respondsToSelector:@selector(handleProgressWith:)])
            [self.delegate handleProgressWith:self.child];
    }
}


- (void)handleLock:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        //---AS MDM FUNCTIONALITIES REMOVED, SO ONLY SHOW THIS---//
        //---MDM REMOVED FOR IOS CHILD---//---IN 221 BUILD---//---MDM---//---AGAIN REMOVED IN 240 BUILD---//
        
        /*
        
        if (self.child.plateform_id == 1)//---ANDROID---//---DUE TO APPLE RESTRICTION, NOT AVAILABLE FOR IOS---//
        {
            if ([self.delegate respondsToSelector:@selector(handleLockWith:)])
                [self.delegate handleLockWith:self.child];
        }
         
         */
        
        //---TO ACTIVATE MDM LOCK FEATURE UNCOMMENT BELOW CODE AND COMMENT ABOVE---//
        
        if ([self.delegate respondsToSelector:@selector(handleLockWith:)])
            [self.delegate handleLockWith:self.child];
    }
}

- (void)handleExpired:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        if ([self.delegate respondsToSelector:@selector(handleExpired)])
            [self.delegate handleExpired];
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)topMenuAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(handleActiveMenuWith:withButton:with:)])
        [self.delegate handleActiveMenuWith:self.child withButton:sender with:_cellIndexPath];
}

- (IBAction)pairActoin:(id)sender {
    if ([self.delegate respondsToSelector:@selector(handleActivePairWith:withButton:with:)])
        [self.delegate handleActivePairWith:self.child withButton:sender with:_cellIndexPath];
}

- (IBAction)invisibleProfileAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(handleProfileActionWith:)])
        [self.delegate handleProfileActionWith:self.child];
}



@end
