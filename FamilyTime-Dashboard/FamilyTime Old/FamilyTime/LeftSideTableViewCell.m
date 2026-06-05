//
//  LeftSideTableViewCell.m
//  FamilyTime
//
//  Created by Sora Code on 11/24/14.
//  Copyright (c) 2014 SoraCode. All rights reserved.
//

#import "LeftSideTableViewCell.h"

@implementation LeftSideTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)updatePrefence:(id)sender {
    self.onSwitchChange(self);
}
@end
