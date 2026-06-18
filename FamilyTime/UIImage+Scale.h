//
//  UIImage+Scale.h
//  FamilyTime - Dashboard
//
//  Created by Muhammad Ajmal on 21/03/2016.
//  Copyright © 2016 SoraCode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Scale)
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;
@end
