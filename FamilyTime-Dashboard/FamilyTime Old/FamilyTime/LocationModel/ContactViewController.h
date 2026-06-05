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

@interface ContactViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UIImageView *imgView;
    UILabel *contentLbl;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSArray *contactColors;
@property (weak, nonatomic) IBOutlet UIImageView *contactImage;
@property (weak, nonatomic) IBOutlet UILabel *lblText;
@end
