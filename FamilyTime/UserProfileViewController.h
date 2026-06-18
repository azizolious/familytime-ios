//
//  UserProfileViewController.h
//  FamilyTime
//
//  Created by Sora Code on 12/31/14.
//  Copyright (c) 2014 SoraCode. All rights reserved.
//http://www.appcoda.com/uipageviewcontroller-storyboard-tutorial/

#import <UIKit/UIKit.h>
#import "DataModel.h"
#import "BaseViewController.h"

@interface UserProfileViewController : BaseViewController <UIPageViewControllerDataSource,UIPageViewControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIPageViewController *pageController;
@property (weak, nonatomic) IBOutlet UIView *container;
@property (nonatomic,strong) UIView *currentTab;
@property (nonatomic,strong) NSArray *dataSource;
@property (weak, nonatomic) IBOutlet UIButton *dbBtn;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *profileLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverImg;
@property (nonatomic,strong) NSString *imagePath;
@property (nonatomic,strong )ChildModel *child;
@property int pagerY;
@property BOOL isCoverImg;
@property (weak, nonatomic) IBOutlet UIView *aboutBtnView;
@property (weak, nonatomic) IBOutlet UIView *subBtnView;
@property (weak, nonatomic) IBOutlet UIView *infoBtnView;
@property (weak, nonatomic) IBOutlet UILabel *aboutLabel;
@property (weak, nonatomic) IBOutlet UIImageView *aboutImg;
@property (weak, nonatomic) IBOutlet UILabel *infolabel;
@property (weak, nonatomic) IBOutlet UIImageView *infoImg;
@property (weak, nonatomic) IBOutlet UIImageView *subImg;
@property (weak, nonatomic) IBOutlet UILabel *subLabel;
@property (weak, nonatomic) IBOutlet UIImageView *infoSeparator;

- (IBAction)selectImg:(id)sender;

- (IBAction)selectTab:(id)sender;
@end
