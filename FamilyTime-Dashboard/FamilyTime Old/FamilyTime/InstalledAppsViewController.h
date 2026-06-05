//
//  InstalledAppsViewController.h
//  FamilyTime
//
//  Created by Sora Code on 12/29/14.
//  Copyright (c) 2014 SoraCode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"
#import "BaseViewController.h"

@interface InstalledAppsViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger remainingCount;
@property (nonatomic, assign) BOOL checkCount;
- (IBAction)addtoWatchlist:(id)sender;
@end
