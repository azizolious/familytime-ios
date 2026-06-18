//
//  ContactCells.h
//  FamilyTime
//
//  Created by Sora Code on 28/04/2015.
//  Copyright (c) 2015 SoraCode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactCells : UITableViewCell
{
    
}

@property (weak, nonatomic) IBOutlet UIButton *contactImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *mobile;
@property (weak, nonatomic) IBOutlet UILabel *email;
@property (weak, nonatomic) IBOutlet UIButton *add;
//@property (weak, nonatomic) IBOutlet UIImageView *separator;


@end
