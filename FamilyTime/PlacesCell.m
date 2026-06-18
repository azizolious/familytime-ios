
//
//  PlacesCell.m
//  FamilyTime
//
//  Created by Sora Code on 28/04/2015.
//  Copyright (c) 2015 SoraCode. All rights reserved.
//

#import "PlacesCell.h"
#import "FTUtils.h"
#import "FamilyTime-Swift.h"


@implementation PlacesCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if(![SwiftFTUtils isDeviceiPhoneFamily])
    {
        self.placeImg.frame = CGRectMake(10, 21, 65, 65);
        self.place.frame = CGRectMake(75, 21.0f, CGRectGetMaxX(self.bounds) - CGRectGetMaxX(self.placeImg.frame) - 50.0f, 29.0f);
        self.address.frame = CGRectMake(75, 49, CGRectGetWidth(self.place.frame), 26);
        self.editPlace.frame = CGRectMake(CGRectGetMaxX(self.bounds) - 40, CGRectGetMidY(self.bounds) - 15.0f, 29, 29);
        self.place.font = [UIFont fontWithName:@"OpenSans" size:20];
        self.address.font = [UIFont fontWithName:@"OpenSans" size:16];
    }
    
    
}

@end
