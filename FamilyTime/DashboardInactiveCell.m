//
//  DashboardInactiveCell.m
//  FamilyTime - Dashboard
//
//  Created by Muhammad Ajmal on 20/10/2016.
//  Copyright © 2016 SoraCode. All rights reserved.
//

#import "DashboardInactiveCell.h"
#import "UIView+VTSelectiveBorder.h"
#import "CommonModel.h"
#import "AppDelegate.h"
#import "FTUtils.h"
#import "NSString+LockMustafa.h"
#import "FamilyTime-Swift.h"

@interface DashboardInactiveCell ()
@property (nonatomic, strong) UITapGestureRecognizer *leftTapGesture;
@property (nonatomic, strong) UITapGestureRecognizer *activateTapGesture;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarTopSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarWidth;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelTopSpace;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *packageLabelTopSpace;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftContainerHeight;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftImageLeftMargin;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftImageHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftImageWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *howToActivateVuHeightConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *howToActivateVuWidthConst;

//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftLabelLeading;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pairBtnWidthConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pairBtnHeightConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuBtnWidthConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuBtnHeightConst;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightContainerHeight;

@property (weak, nonatomic) IBOutlet UILabel *howToActivateLbl;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pairBtnLeadingConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pairBtnBottomConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuBtnTrailingConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuBtnTopConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLeadingConst;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *howToActivateVerticallyCenterConst;


@end

@implementation DashboardInactiveCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.cellContainerView.layer.cornerRadius  = 5.0f;
    self.cellContainerView.layer.masksToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.leftContainer.selectiveBorderFlag   = AUISelectiveBordersFlagRight;
    self.leftContainer.selectiveBordersColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5f];
    self.leftContainer.selectiveBordersWidth = 0.5f;
    
    self.howToActivateVu.layer.borderColor = [[UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1.0] CGColor];
    self.howToActivateVu.layer.borderWidth = 2.0;
    
    if(![SwiftFTUtils isDeviceiPhoneFamily])
    {
        self.leftLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:18];

        self.nameLabel.font         = [UIFont fontWithName:@"OpenSans" size:18];
        self.leftLabel.font         = [UIFont fontWithName:@"OpenSans-Light" size:18];
        self.howToActivateLbl.font  = [UIFont fontWithName:@"OpenSans-Light" size:16];
        
        
        self.avatarTopSpace.constant = 12;
        self.avatarWidth.constant  = 45;
        self.avatarHeight.constant = 45;
        
        
        self.leftContainerHeight.constant = 75;
//        self.rightContainerHeight.constant = 75;
//        self.leftImageLeftMargin.constant = 45;
        
//        self.leftLabelLeading.constant = 10;
//        self.rightImageLeading.constant = 45;
//        self.rightImageWidth.constant = 55;
//        self.rightImageHeight.constant = 55;
//        self.rightLabelLeading.constant = 10;
        
        
        
        self.leftImageWidth.constant  = 48;
        self.leftImageHeight.constant = 48;
        
        self.howToActivateVuHeightConst.constant = 200;
        self.howToActivateVuWidthConst.constant  = 200;
        self.howToActivateVu.layer.cornerRadius  = 100;
//        self.howToActivateVu.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1]);
        
        self.pairBtnWidthConst.constant     = 30;
        self.pairBtnHeightConst.constant    = 30;
        self.menuBtnWidthConst.constant     = 30;
        self.menuBtnHeightConst.constant    = 30;
        
        self.pairBtnLeadingConst.constant   = 20;
        self.pairBtnBottomConst.constant    = 20;
        self.menuBtnTopConst.constant       = 20;
        self.menuBtnTrailingConst.constant  = 14;
        self.nameLeadingConst.constant      = 20;
        
        self.howToActivateVerticallyCenterConst.constant = -35;
    }
    
//    self.rightLabel.adjustsFontSizeToFitWidth = YES;
    self.leftLabel.adjustsFontSizeToFitWidth  = YES;
}

- (void)setCoparent:(DashboardCoParent *)coparent
{
    _coparent = coparent;
    self.avatarImageView.image = [UIImage imageNamed:[coparent.relationship.lowercaseString isEqualToString:NSLocalizedString(@"Mother",nil)] ? @"sub_parent_avater" : @"parent_avater"];
    self.nameLabel.text = coparent.name;
//    self.packageLabel.text = @"Co-Parent";
    self.leftImageView.image = [UIImage imageNamed:@"profile"];
    self.leftLabel.text = [@"Update Profile" myModification];
//    self.rightLabel.text = [@"Parent Card" myModification];
//    self.rightImageView.image = [UIImage imageNamed:@"parent_badge"];
    self.cellContainerView.backgroundColor = [CommonModel colorFromHexString:coparent.color];
    
    [self.leftContainer removeGestureRecognizer:self.leftTapGesture];
    self.leftTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleProfile:)];
    [self.leftContainer addGestureRecognizer:self.leftTapGesture];
}

- (void)setChild:(DashboardChild *)child
{
    _child = child;
    self.avatarImageView.image = [UIImage imageNamed:[child.gender.lowercaseString isEqualToString:@"male"] ? @"avatar_boy1" : @"avatar_girl1"];
    self.nameLabel.text = child.name;

    self.leftLabel.text = NSLocalizedString(@"Setup instruction to activate this device", nil);
    self.howToActivateLbl.text = [@"HOW TO ACTIVATE" myModification];
    
    [self.leftContainer removeGestureRecognizer:self.leftTapGesture];
    self.leftTapGesture     = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleInstall:)];
    self.activateTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleInstall:)];
    
    [self.leftContainer     addGestureRecognizer:self.leftTapGesture];
    [self.howToActivateVu   addGestureRecognizer:_activateTapGesture];
    
    
    //---ANDROID = 1 OR IOS = 2---//
    if (child.plateform_id == 1){
        
        if(child.active == 1)
            [self.pairBtn setImage:[UIImage imageNamed:@"ic_pair"] forState:UIControlStateNormal];
        else
            [self.pairBtn setImage:[UIImage imageNamed:@"ic_not_pair"] forState:UIControlStateNormal];
    }
    else{//---IOS CASE---//
        
        if(child.child_enrolled == 1)
            [self.pairBtn setImage:[UIImage imageNamed:@"ic_pair"] forState:UIControlStateNormal];
        else
            [self.pairBtn setImage:[UIImage imageNamed:@"ic_not_pair"] forState:UIControlStateNormal];
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)handleProfile:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        if ([self.delegate respondsToSelector:@selector(handleProfileWith:)])
            [self.delegate handleProfileWith:self.coparent];
    }
    
}

- (void)handleInstall:(UIGestureRecognizer *)sender
{
    NSLog(@"%@",@"New Here");
    
    NSLog(@"%@",_child.gender);
    NSLog(@"%@",_child.name);
    
    
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        if ([self.delegate respondsToSelector:@selector(handleStep2:and:)])
            [self.delegate handleStep2:_child.name and:_child.gender];
        
//        if ([self.delegate respondsToSelector:@selector(handleHowToInstall)])
//            [self.delegate handleHowToInstall];
        
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kHowToInstallUrl] options:@{} completionHandler:nil];
    }
    
}

- (IBAction)topMenuAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(handleInactiveMenuWith:withButton:with:)])
        [self.delegate handleInactiveMenuWith:self.child withButton:sender with:_cellIndexPath];
}

- (IBAction)pairActoin:(id)sender {
    if ([self.delegate respondsToSelector:@selector(handleInactivePairWith:withButton:with:)])
        [self.delegate handleInactivePairWith:self.child withButton:sender with:_cellIndexPath];
}

- (IBAction)invisibleProfileAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(handleProfileActionWith:)])
        [self.delegate handleProfileActionWith:self.child];
}

@end
