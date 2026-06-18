//
//  AppUsageViewController.h
//  FamilyTime - Dashboard
//
//  Created by Ahmad on 8/21/17.
//  Copyright © 2017 SoraCode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ParentsViewControllerAll: BaseViewController <UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate, UIScrollViewDelegate>
{
    int TotalTime;
    int IndexOfDate;
    
    
    IBOutlet UIButton *btnNext;
    IBOutlet UIButton *btnPrev;
    
    UIImageView *imgView;
    UILabel *contentLbl;

    int checkpermissionInviteParent;
}

@property (strong, nonatomic) IBOutlet UIView *topView;

@property (strong, nonatomic) IBOutlet UILabel *lblDaySelected;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalMinutes;



@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *rowArr;
@property (nonatomic,strong) NSMutableArray * dates;
@property int page;

@property (strong, nonatomic) NSMutableArray *arrOfBasicInfoImages;
@property (strong, nonatomic) NSMutableArray *arrOfBasicInfoData;


@property (strong, nonatomic) IBOutlet UIView *view1;
@property (strong, nonatomic) IBOutlet UIView *view2;

@property (strong, nonatomic) NSMutableDictionary *rowDic;
@property (strong, nonatomic) NSMutableArray *Array1;
@property (strong, nonatomic) NSMutableArray *Array;




@end
