//
//  AUISelectiveBordersLayer.h
//  AUISelectiveBordersView
//  SlashNext
//
//  Created by Muhammad Ajmal on 15/05/2014.
//  Copyright (c) 2014 VirucideTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

enum {
    AUISelectiveBordersFlagLeft = 1 <<  0,
    AUISelectiveBordersFlagRight = 1 <<  1, 
    AUISelectiveBordersFlagTop = 1 <<  2, 
    AUISelectiveBordersFlagBottom = 1 <<  3
};
typedef NSUInteger VTSelectiveBordersFlag;

@interface VTSelectiveBordersLayer : CALayer {
    CAShapeLayer *borderLayer;
}

@property (nonatomic, strong) UIColor *selectiveBordersColor;
@property (nonatomic) float selectiveBordersWidth;
@property (nonatomic) VTSelectiveBordersFlag selectiveBorderFlag;

@end
