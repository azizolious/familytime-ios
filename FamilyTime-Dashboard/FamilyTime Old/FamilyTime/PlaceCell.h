//
//  PlaceCell.h
//  FamilyTime
//
//  Created by Sora Code on 12/17/14.
//  Copyright (c) 2014 SoraCode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *placeImg;
@property (weak, nonatomic) IBOutlet UILabel *place;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UIButton *editPlace;


@end
