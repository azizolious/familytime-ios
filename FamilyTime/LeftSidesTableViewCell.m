//
//  LeftSidesTableViewCell.m
//  FamilyTime
//
//  Created by Sora Code on 29/04/2015.
//  Copyright (c) 2015 SoraCode. All rights reserved.
//

#import "LeftSidesTableViewCell.h"
#import "FTUtils.h"
#import "UIView+VTSelectiveBorder.h"

@implementation LeftSidesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.cellSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 51, 31)];
    self.cellSwitch.onTintColor = RGBCOLOR(24, 167, 225, 1);
    self.accessoryView = self.cellSwitch;
    [self.cellSwitch addTarget:self action:@selector(updatePrefence:) forControlEvents:UIControlEventValueChanged];
    
    self.selectiveBorderFlag = AUISelectiveBordersFlagBottom;
    self.selectiveBordersColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5f];
    self.selectiveBordersWidth = 0.5f;
    
    self.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)updatePrefence:(id)sender {
    self.onSwitchChange(self);
}

- (void)showAccessoryview{
    self.accessoryView = nil;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

@end
