//
//  ContentFilterTableViewCell.m
//  FamilyTime - Dashboard
//
//  Created by Muhammad Ajmal on 31/05/2016.
//  Copyright © 2016 SoraCode. All rights reserved.
//

#import "ContentFilterTableViewCell.h"
#import "FTUtils.h"
#import "UIView+VTSelectiveBorder.h"

@interface ContentFilterTableViewCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellImageViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellImageViewWidth;

@end
@implementation ContentFilterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    if([FTUtils isDeviceiPhoneFamily])
    {
        self.cellImageViewWidth.constant = 40;
        self.cellImageViewHeight.constant = 40;
        
    }
    else
    {
        self.cellImageViewWidth.constant = 72;
        self.cellImageViewHeight.constant = 72;
    }
    self.selectiveBorderFlag = AUISelectiveBordersFlagBottom;
    self.selectiveBordersColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5f];
    self.selectiveBordersWidth = 0.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
