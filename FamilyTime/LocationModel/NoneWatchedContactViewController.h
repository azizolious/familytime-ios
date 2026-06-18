//
//  ContactViewController.h
//  FamilyTime
//
//  Created by Sora Code on 12/18/14.
//  Copyright (c) 2014 SoraCode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactsCell.h"
#import "LogsModel.h"
#import "DataModel.h"
#import "BaseViewController.h"

@interface NoneWatchedContactViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnaddtoWatchList;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSArray *contactColors;
@property (nonatomic,strong) NSString *parentCont;
- (IBAction)addContactsToWatchList:(id)sender;

@property (nonatomic, assign) NSInteger remainingCount;
@property (nonatomic, assign) BOOL checkCount;

@end
