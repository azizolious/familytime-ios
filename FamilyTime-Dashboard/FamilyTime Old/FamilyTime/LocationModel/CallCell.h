//
//  CallCell.h
//  FamilyTime
//
//  Created by Sora Code on 12/23/14.
//  Copyright (c) 2014 SoraCode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CallCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *contactImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
//@property (weak, nonatomic) IBOutlet UILabel *mobile;
//@property (weak, nonatomic) IBOutlet UILabel *email;
@property (weak, nonatomic) IBOutlet UIButton *add;
@property (weak, nonatomic) IBOutlet UIImageView *separator;
@property (weak, nonatomic) IBOutlet UIButton *callType;

@property (weak, nonatomic) IBOutlet UILabel *lblSavedName;
@property (weak, nonatomic) IBOutlet UILabel *lblCallNumber;

@property (weak, nonatomic) IBOutlet UIButton *btnBlackList;

@property (weak, nonatomic) IBOutlet UILabel *lblCallDuration;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;

@end
