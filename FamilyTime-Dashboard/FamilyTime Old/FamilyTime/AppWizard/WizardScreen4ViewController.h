//
//  WizardScreen4ViewController.h
//  FamilyTime - Dashboard
//
//  Created by Muhammad Ajmal on 09/12/2015.
//  Copyright © 2015 SoraCode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WizardScreen4ViewController : UIViewController
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) BOOL isChild;
@property (nonatomic, strong) NSString *timezone;
@property (nonatomic, assign) BOOL fromDashboard;
@property (nonatomic, assign) BOOL addingNewUserFromDashboard;
@end
