//
//  LeftSidePanel.h
//  FamilyTime
//
//  Created by Sora Code on 11/19/14.
//  Copyright (c) 2014 SoraCode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlacesViewController.h"
#import "DataModel.h"
#import "ContactsWatchListViewController.h"
#import "BaseViewController.h"

@interface LeftSidePaneliOS : BaseViewController <UITableViewDataSource,UITableViewDelegate>
{
    //NSDictionary *CallLogs, *ContactDetails, *GeoLocation, *BookMarks, *BrowsingHistory, *PhoneLockStatus, *Alerts, *speedAlerts, *installedApps;
}

@property (nonatomic,strong) PlacesViewController *placesCont;
//@property (nonatomic,strong) BListAppsViewController *blackListCont;
@property (nonatomic,strong) ContactsWatchListViewController *contactWListCont;
//@property (nonatomic,strong) ChangePassViewController1 *changPswCont;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSDictionary *dataSource;
@property (nonatomic,strong) NSArray *allKeys;


@property (weak, nonatomic) IBOutlet UIView *popupVu;
@property (weak, nonatomic) IBOutlet UILabel *featureUpdateLbl;
@property (weak, nonatomic) IBOutlet UILabel *notAvailableLbl;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

@end
