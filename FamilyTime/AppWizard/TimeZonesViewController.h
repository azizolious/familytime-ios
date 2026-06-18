//
//  TimeZonesViewController.h
//  FamilyTime - Dashboard
//
//  Created by Muhammad Ajmal on 30/05/2016.
//  Copyright © 2016 SoraCode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMTTimezone.h"

@protocol TimeZonesViewControllerDelegate <NSObject>
@optional
- (void)didTimeZoneChangedTo:(NSInteger )selectedIndex;
@end

@interface TimeZonesViewController : UITableViewController
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) NSArray *timezones;
@property (nonatomic, weak) id<TimeZonesViewControllerDelegate> controllerDelegate;
@property (nonatomic, assign) BOOL isFromPopup;
@end
