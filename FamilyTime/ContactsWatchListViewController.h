//
//  ContactsWatchListViewController.h
//  FamilyTime
//
//  Created by Sora Code on 12/30/14.
//  Copyright (c) 2014 SoraCode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"
#import "NoneWatchedContactViewController.h"
#import "BaseViewController.h"

@interface ContactsWatchListViewController : BaseViewController  <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NoneWatchedContactViewController *contactCont;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSMutableArray *StatusAllArray;
@property (nonatomic,strong) NSMutableArray *IDsAllArray;

@property (weak, nonatomic) IBOutlet UILabel *enableLabel;
@property (weak, nonatomic) IBOutlet UISwitch *contPrefer;

- (IBAction)updateContPrefer:(id)sender;
-(void) refreshView;
@end
