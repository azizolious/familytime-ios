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

@interface AllInstalledAppsViewController : BaseViewController
{
    UIImageView *imgView;
    UILabel *contentLbl;
    NSMutableString *stringts;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
- (IBAction)addtoWatchlist:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *contactImage;
@property (weak, nonatomic) IBOutlet UILabel *lblText;
@end
