//
//  LeftSidesTableViewCell.h
//  FamilyTime
//
//  Created by Sora Code on 29/04/2015.
//  Copyright (c) 2015 SoraCode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftSidesTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cellImage;
@property (weak, nonatomic) IBOutlet UILabel *cellLabel;
@property (weak, nonatomic) IBOutlet UIButton *arrow;
@property (strong, nonatomic) UISwitch *cellSwitch;
@property (nonatomic,copy) void (^onSwitchChange)(LeftSidesTableViewCell *cell);
- (IBAction)updatePrefence:(id)sender;
- (void)showAccessoryview;
@end
