//
//  UIView+AUISelectiveBorder.h
//  AUISelectiveBordersView
//  SlashNext
//
//  Created by Muhammad Ajmal on 15/05/2014.
//  Copyright (c) 2014 VirucideTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VTSelectiveBordersLayer.h"

@interface UIView (VTSelectiveBorder)

@property (nonatomic, strong) UIColor *selectiveBordersColor;
@property (nonatomic) float selectiveBordersWidth;
@property (nonatomic) VTSelectiveBordersFlag selectiveBorderFlag;

@end
