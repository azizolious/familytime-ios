//
//  UIView+AUISelectiveBorder.m
//  AUISelectiveBordersView
//  SlashNext
//
//  Created by Muhammad Ajmal on 15/05/2014.
//  Copyright (c) 2014 VirucideTech. All rights reserved.
//

#import "UIView+VTSelectiveBorder.h"

@implementation UIView (AUISelectiveBorder)

+(Class) layerClass {
    return [VTSelectiveBordersLayer class];
}

-(VTSelectiveBordersFlag) selectiveBorderFlag
{
    VTSelectiveBordersLayer *selectiveLayer = (VTSelectiveBordersLayer *)self.layer;
    return selectiveLayer.selectiveBorderFlag;
}

-(void) setSelectiveBorderFlag:(VTSelectiveBordersFlag)selectiveBorderFlag
{
    VTSelectiveBordersLayer *selectiveLayer = (VTSelectiveBordersLayer *)self.layer;
    selectiveLayer.selectiveBorderFlag = selectiveBorderFlag;
}

-(UIColor *)selectiveBordersColor
{
    VTSelectiveBordersLayer *selectiveLayer = (VTSelectiveBordersLayer *)self.layer;
    return selectiveLayer.selectiveBordersColor;
}

-(void) setSelectiveBordersColor:(UIColor *)selectiveBordersColor
{
    VTSelectiveBordersLayer *selectiveLayer = (VTSelectiveBordersLayer *)self.layer;
    selectiveLayer.selectiveBordersColor = selectiveBordersColor;
}

-(float) selectiveBordersWidth
{
    VTSelectiveBordersLayer *selectiveLayer = (VTSelectiveBordersLayer *)self.layer;
    return selectiveLayer.selectiveBordersWidth;
}

-(void) setSelectiveBordersWidth:(float)selectiveBordersWidth
{
    VTSelectiveBordersLayer *selectiveLayer = (VTSelectiveBordersLayer *)self.layer;
    selectiveLayer.selectiveBordersWidth = selectiveBordersWidth;
}

@end
