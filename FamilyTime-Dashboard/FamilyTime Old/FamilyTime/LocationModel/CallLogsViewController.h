//
//  CallLogsViewController.h
//  FamilyTime
//
//  Created by Sora Code on 12/19/14.
//  Copyright (c) 2014 SoraCode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CallCell.h"
#import "LogsModel.h"
#import "DataModel.h"
#import "BaseViewController.h"
#import "NSDate+Utilities.h"

@interface CallLogsViewController : BaseViewController  <UITableViewDataSource,UITableViewDelegate>
{
    UIImageView *imgView;
    UILabel *contentLbl;
    NSString *serverdate, *serverdate11;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSArray *contactColors;

@property (weak, nonatomic) IBOutlet UIView *errorscreen;
@property (weak, nonatomic) IBOutlet UIImageView *contactImage;
@property (weak, nonatomic) IBOutlet UILabel *lblText;

//+ (NSString *) dateDifference:(NSDate *)date;

@end
