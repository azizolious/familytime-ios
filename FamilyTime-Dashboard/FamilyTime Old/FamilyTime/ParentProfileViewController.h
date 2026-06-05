//
//  AppUsageViewController.h
//  FamilyTime - Dashboard
//
//  Created by Ahmad on 8/21/17.
//  Copyright © 2017 SoraCode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "IQDropDownTextField.h"

@interface ParentProfileViewController : BaseViewController
{
    int TotalTime;
    int IndexOfDate;
    
    
    IBOutlet UIButton *btnNext;
    IBOutlet UIButton *btnPrev;
    
    UIImageView *imgView;
    UILabel *contentLbl;

    IQDropDownTextField *txtLang;
    IQDropDownTextField *txtRelation;
    
    
    int checklanguageChange;
    
    UIBarButtonItem *rightButton;
    
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
@property (strong, nonatomic) NSMutableArray *rowklanguages;
@property (strong, nonatomic) NSMutableArray *rowkSettings;

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblEmail;

@property (strong, nonatomic) IBOutlet UIImageView *imgVw;

@property (strong, nonatomic) NSString *strLanguage;
@property (strong, nonatomic) NSString *strRelationShip;
@property (strong, nonatomic) NSString *strName;
@property (strong, nonatomic) NSString *strPhone;
@property (strong, nonatomic) NSString *strEmail;


@property (strong, nonatomic) IBOutlet UITextField *txtName;
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtPhone;


@end
