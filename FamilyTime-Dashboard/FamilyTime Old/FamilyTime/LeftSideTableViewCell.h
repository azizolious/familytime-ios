//
//  LeftSideTableViewCell.h
//  FamilyTime
//
//  Created by Sora Code on 11/24/14.
//  Copyright (c) 2014 SoraCode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftSideTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cellImage;
@property (weak, nonatomic) IBOutlet UILabel *cellLabel;
@property (weak, nonatomic) IBOutlet UIButton *arrow;
@property (weak, nonatomic) IBOutlet UISwitch *cellSwitch;
@property (nonatomic,copy) void (^onSwitchChange)(LeftSideTableViewCell *cell);
- (IBAction)updatePrefence:(id)sender;

@end
