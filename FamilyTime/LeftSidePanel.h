//
//  LeftSidePanel.h
//  FamilyTime
//
//  Created by Sora Code on 11/19/14.
//  Copyright (c) 2014 SoraCode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlacesViewController.h"
//#import "ChangePassViewController1.h"
#import "DataModel.h"
//#import "BListAppsViewController.h"
#import "ContactsWatchListViewController.h"
//#import "UserProfileViewController.h"
#import "BaseViewController.h"
//#import "AppDelegate.h"

@interface LeftSidePanel : BaseViewController <UITableViewDataSource,UITableViewDelegate>
{
    
}

@property (nonatomic,strong) PlacesViewController *placesCont;
//@property (nonatomic,strong) BListAppsViewController *blackListCont;
@property (nonatomic,strong) ContactsWatchListViewController *contactWListCont;
//@property (nonatomic,strong) ChangePassViewController1 *changPswCont;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSDictionary *dataSource;
@property (nonatomic,strong) NSArray *allKeys;

//@property (nonatomic,assign) AppDelegate *delegateee;


@end
