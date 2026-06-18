//
//  UIViewController+Keyboard.h
//  FamilyTime
//
//  Created by Sora Code on 11/25/14.
//  Copyright (c) 2014 SoraCode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (UIViewController)

-(void)setViewMovedUp:(BOOL)movedUp;
-(void)keyboardWillShow;
-(void)keyboardWillHide;
@end
