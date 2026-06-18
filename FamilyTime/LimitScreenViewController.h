//
//  LimitScreenViewController.h
//  FamilyTime - Dashboard
//
//  Created by Muhammad Ajmal on 04/08/2016.
//  Copyright © 2016 SoraCode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"


@interface LimitScreenViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UIBarButtonItem * add;
}
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSString *ruleid;

@end
