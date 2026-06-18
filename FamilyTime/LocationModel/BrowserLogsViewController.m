//
//  BrowserLogsViewController.m
//  FamilyTime
//
//  Created by Sora Code on 12/19/14.
//  Copyright (c) 2014 SoraCode. All rights reserved.
//

#import "BrowserLogsViewController.h"
#import "MBProgressHUD.h"
//#import "JSONHTTPClient.h"
#import "AppDelegate.h"
#import "PlacesCell.h"
//#import <Google/Analytics.h>
#import "FTUtils.h"
#import "NSString+LockMustafa.h"
#import "FamilyTime-Swift.h"
AppDelegate *delegate;
UIRefreshControl *  refreshControl;
@interface BrowserLogsViewController ()
@property (nonatomic, assign) BOOL isPopupAppeared;
@end

@implementation BrowserLogsViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:[@"Web History" myModification]];
    self.isPopupAppeared = NO;
    delegate = [AppDelegate appDelegate];
    [self.tableView registerNib:[UINib nibWithNibName:@"PlacesCell" bundle:nil] forCellReuseIdentifier:@"PlacesCell"];
    if([SwiftFTUtils isDeviceiPhoneFamily])
        self.tableView.rowHeight = 60;
    else
        self.tableView.rowHeight = 100;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.page = 1;
    
    [self addPullRefresh];
    [self loadBrowserLogs];
    
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(236, 229,296,212)];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.image = [UIImage imageNamed:@"ipad_empty"];
        imgView.hidden=YES;
        [self.view addSubview:imgView];
        [self.view bringSubviewToFront:imgView];
        
        contentLbl=[[UILabel alloc]initWithFrame:CGRectMake(203, 489, 362, 45)];
        contentLbl.lineBreakMode=YES;
        contentLbl.textColor=[UIColor lightGrayColor];
        contentLbl.text=[@"It seems like there is no record to display." myModification];
        contentLbl.font=[UIFont systemFontOfSize:16];
        contentLbl.lineBreakMode = NSLineBreakByWordWrapping;
        contentLbl.numberOfLines = 2;
        contentLbl.textAlignment = NSTextAlignmentCenter;
        contentLbl.hidden=YES;
        [self.view addSubview:contentLbl];
        [self.view bringSubviewToFront:contentLbl];
    }
    else if(([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone))
    {
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(115, 152,145,104)];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.image = [UIImage imageNamed:@"ic_empty"];
        imgView.hidden=YES;
        [self.view addSubview:imgView];
        [self.view bringSubviewToFront:imgView];
        
        contentLbl=[[UILabel alloc]initWithFrame:CGRectMake(30, 279, 315, 41)];
        contentLbl.lineBreakMode=YES;
        contentLbl.textColor=[UIColor lightGrayColor];
        contentLbl.text=[@"It seems like there is no record to display." myModification];
        contentLbl.font=[UIFont systemFontOfSize:17];
        contentLbl.lineBreakMode = NSLineBreakByWordWrapping;
        contentLbl.numberOfLines = 2;
        contentLbl.textAlignment = NSTextAlignmentCenter;
        contentLbl.hidden=YES;
        [self.view addSubview:contentLbl];
        [self.view bringSubviewToFront:contentLbl];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    DashboardChildPackageFeature *packageFeature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"browsinghistory"];
    if (packageFeature.package_id == 1 || packageFeature != nil)
    {
        if(packageFeature.is_time_based == 1 || packageFeature.is_count_based == 1)
            [self showPremiumBanner:YES];
        else
            [self showPremiumBanner:NO];
    }
    else
    {
        [self showPremiumFeatureView:YES];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - QBRefreshControlDelegate



-(void) addPullRefresh
{
//    refreshControl = [[UIRefreshControl alloc]init];
//    [self.tableView addSubview:refreshControl];
//    [refreshControl addTarget:self action:@selector(loadBrowserLogs) forControlEvents:UIControlEventValueChanged];
    
}

- (void)refreshTable
{
    //TODO: refresh your data
//    [refreshControl endRefreshing];
//    [self.tableView reloadData];
}

#pragma mark Places
-(void) editHistory
{
    [self.tableView setEditing:!self.tableView.isEditing];
}

-(void) loadBrowserLogs
{
    self.contactImage.hidden = NO;
    self.lblText.hidden      = NO;
    
    /*
     
    [SwiftFTUtils showHUDAddedTo:self.view withText:@"Loading..." animated:YES];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:delegate.selectedDashboardChild.child_id],@"child_id",[NSString stringWithFormat:@"%i",self.page],@"page", nil];
    [JSONHTTPClient postJSONFromURLWithString:KBrowserLogs
                                       params:params
                                   completion:^(id json, JSONModelError *err) {
                                       NSError *error;
                                       NSString *msg = [json valueForKey:@"message"] == nil ? [kErrorGeneral myModification]: [json valueForKey:@"message"];
                                       // read response code
                                       if([[json valueForKey:@"response"] intValue]== 200){
                                           AllBrowserModel *model = [[AllBrowserModel alloc] initWithDictionary:json error:&error];
                                           self.dataSource = [[NSMutableArray alloc]init];
                                           self.dataSource = [NSMutableArray arrayWithArray:model.data];
                                           [self viewDidDisappear:YES];
                                           
                                       }
                                       else
                                           [CommonModel showAlert:@"Error!" msg:msg];
                                       self.contactImage.hidden=NO;
                                       self.lblText.hidden=NO;
                                       if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                                       {
                                           imgView.hidden=NO;
                                           contentLbl.hidden=NO;
                                           self.view.backgroundColor = [UIColor whiteColor];
                                           
                                           self.contactImage.hidden=YES;
                                           self.lblText.hidden=YES;
                                       }
                                       if (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width) == 667))
                                       {
                                           imgView.hidden=NO;
                                           contentLbl.hidden=NO;
                                           self.view.backgroundColor = [UIColor whiteColor];
                                           
                                           self.contactImage.hidden=YES;
                                           self.lblText.hidden=YES;
                                       }
                                       else if (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width) == 736))
                                       {
                                           imgView.hidden=NO;
                                           contentLbl.hidden=NO;
                                           self.view.backgroundColor = [UIColor whiteColor];
                                           
                                           self.contactImage.hidden=YES;
                                           self.lblText.hidden=YES;
                                       }
                                       [self refreshTable];
                                       [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                   }];
     
     */
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.contactImage setHidden:YES];
    [self.lblText setHidden:YES];
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        imgView.hidden=YES;
        contentLbl.hidden=YES;
        self.view.backgroundColor = UIColorFromRGB(0xEFEFF4);
    }
    if (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width) == 667))
    {
        imgView.hidden=YES;
        contentLbl.hidden=YES;
        self.view.backgroundColor = UIColorFromRGB(0xEFEFF4);
    }
    else if (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width) == 736))
    {
        imgView.hidden=YES;
        contentLbl.hidden=YES;
        self.view.backgroundColor = UIColorFromRGB(0xEFEFF4);
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[[self.dataSource objectAtIndex:section] logs] count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 70;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect frame = [[UIScreen mainScreen]bounds];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 70)];
    [view setBackgroundColor:KListHeadingBGColor()];
    frame = view.frame;
    frame.origin.x = 20;
    UILabel *headertitle = [[UILabel alloc] initWithFrame:frame];
    [headertitle setTextColor:KListDetailColor()];
    NSString *title =[NSString stringWithFormat:@"%@",[[self.dataSource objectAtIndex:section] date]];
    [headertitle setText:[CommonModel date:title oldFormat:@"YYYY-MM-dd" format:@"EEEE, MMMM d, YYYY"]];
    [view addSubview:headertitle];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SwiftPlacesCell *cell = (SwiftPlacesCell *)[tableView dequeueReusableCellWithIdentifier:@"PlacesCell"];
    
    if (cell == nil) {
        cell = (SwiftPlacesCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PlacesCell"];
           }
    BrowserModel *model =  [[[self.dataSource objectAtIndex:indexPath.section] logs] objectAtIndex:indexPath.row];
    cell.place.text = model.title;
    cell.address.text = model.domain;
    NSString *imgName =[NSString stringWithFormat:@"web_%i.png",(int)indexPath.row%5 + 1 ];
    [cell.placeImg setImage:[UIImage imageNamed:imgName]];
    [cell.editPlace setImage:nil forState:UIControlStateNormal];
    [self viewDidDisappear:YES];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}


@end
