//
//  BrowserCell.h
//  FamilyTime
//
//  Created by Sora Code on 1/14/15.
//  Copyright (c) 2015 SoraCode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrowserCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *cellImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *detail;
@property (weak, nonatomic) IBOutlet UIImageView *separator;

@end
