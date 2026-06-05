//
//  MessageThreadCell.m
//  FamilyTime - Dashboard
//
//  Created by Muhammad Ajmal on 22/08/2016.
//  Copyright © 2016 SoraCode. All rights reserved.
//

#import "MessageThreadCell.h"

@interface MessageThreadCell ()
@property (nonatomic, strong) UIView *borderView;
@end
@implementation MessageThreadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.borderView = [[UIView alloc] initWithFrame:CGRectZero];
    self.borderView.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.borderView];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.borderView.frame = CGRectMake(0, CGRectGetMaxY(self.contentView.frame) - 1, CGRectGetMaxX(self.contentView.frame), 0.5f);
}

@end
