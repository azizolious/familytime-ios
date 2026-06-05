//
//  MessageThreadCell.h
//  FamilyTime - Dashboard
//
//  Created by Muhammad Ajmal on 22/08/2016.
//  Copyright © 2016 SoraCode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageThreadCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *snippetLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end
