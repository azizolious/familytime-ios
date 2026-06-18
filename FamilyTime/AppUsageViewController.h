//
//  AppUsageViewController.h
//  FamilyTime - Dashboard
//
//  Created by Ahmad on 8/21/17.
//  Copyright © 2017 SoraCode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface AppUsageViewController : BaseViewController
{
    int TotalTime;
    int IndexOfDate;
    
    
    IBOutlet UIButton *btnNext;
    IBOutlet UIButton *btnPrev;
    
    UIImageView *imgView;
    UILabel *contentLbl;

    
}
    
@property (strong, nonatomic) IBOutlet UILabel *lblTotalDeviceusage1;

@property (strong, nonatomic) IBOutlet UIView *topView;

@property (strong, nonatomic) IBOutlet UILabel *lblDaySelected;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalMinutes;


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *rowArr;
@property (nonatomic,strong) NSMutableArray * dates;
@property int page;


@property (strong, nonatomic) IBOutlet UIView *view1;
@property (strong, nonatomic) IBOutlet UIView *view2;



@end
