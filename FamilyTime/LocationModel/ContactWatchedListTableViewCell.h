//
//  ContactWatchedListTableViewCell.h
//  FamilyTime
//
//  Created by Ahmad on 4/3/18.
//  Copyright © 2018 YumyApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactWatchedListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *contactImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *mobile;
@property (weak, nonatomic) IBOutlet UILabel *email;
@property (weak, nonatomic) IBOutlet UIButton *add;
@property (weak, nonatomic) IBOutlet UISwitch *sw11;

@end
