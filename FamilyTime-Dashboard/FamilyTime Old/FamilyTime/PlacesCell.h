//
//  PlacesCell.h
//  FamilyTime
//
//  Created by Sora Code on 28/04/2015.
//  Copyright (c) 2015 SoraCode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlacesCell : UITableViewCell
{
    
}

@property (weak, nonatomic) IBOutlet UIImageView *placeImg;
@property (weak, nonatomic) IBOutlet UILabel *place;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UIButton *editPlace;


@end
