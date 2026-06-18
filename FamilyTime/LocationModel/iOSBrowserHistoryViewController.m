//
//  iOSBrowserHistoryViewController.m
//  FamilyTime - Dashboard
//
//  Created by Muhammad Ajmal on 21/02/2017.
//  Copyright © 2017 SoraCode. All rights reserved.
//

#import "iOSBrowserHistoryViewController.h"
#import "BrowserCell.h"
#import "MBProgressHUD.h"
//#import "JSONHTTPClient.h"
#import "AppDelegate.h"
#import "PlacesCell.h"
#import "FTD.h"
#import "FTUtils.h"
#import "NSString+LockMustafa.h"
#import "CommonModel.h"
#import "FamilyTime-Swift.h"

AppDelegate *delegate;
UIRefreshControl *  refreshControl;

@interface iOSBrowserHistoryViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (nonatomic, assign) NSInteger page;
@property (nonatomic,strong) NSMutableArray * dates;
@property (nonatomic,strong) NSMutableArray *dataSource;

@end

@implementation iOSBrowserHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    delegate = [AppDelegate appDelegate];
    [self.tableView registerNib:[UINib nibWithNibName:@"PlacesCell" bundle:nil] forCellReuseIdentifier:@"PlacesCell"];
    if([SwiftFTUtils isDeviceiPhoneFamily])
        self.tableView.rowHeight = 60;
    else
        self.tableView.rowHeight = 100;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self addPullRefresh];
    
    [self.navigationItem setTitle:[@"Web History" myModification]];
    
    [self showNoDataView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self refreshTable];
//    [self loadDates];
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


-(void)showNoDataView{
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
        contentLbl.text=[@"It seems like there is no record to\n display." myModification];
        contentLbl.font=[UIFont systemFontOfSize:16];
        contentLbl.lineBreakMode = NSLineBreakByWordWrapping;
        contentLbl.numberOfLines = 2;
        contentLbl.textAlignment = NSTextAlignmentCenter;
        contentLbl.hidden=YES;
        [self.view addSubview:contentLbl];
        [self.view bringSubviewToFront:contentLbl];
        
        
//        self.lblText.text=[@"It seems like there is no record to\n display." myModification];
    }
    else if (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone ))
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
        contentLbl.text=[@"It seems like there is no record to\n display." myModification];
        contentLbl.font=[UIFont systemFontOfSize:17];
        contentLbl.lineBreakMode = NSLineBreakByWordWrapping;
        contentLbl.numberOfLines = 2;
        contentLbl.textAlignment = NSTextAlignmentCenter;
        contentLbl.hidden=YES;
        [self.view addSubview:contentLbl];
        [self.view bringSubviewToFront:contentLbl];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - QBRefreshControlDelegate
-(void) addPullRefresh
{
//    refreshControl = [[UIRefreshControl alloc]init];
//    [self.tableView addSubview:refreshControl];
//    [refreshControl addTarget:self action:@selector(loadDates) forControlEvents:UIControlEventValueChanged];
}

- (void)refreshTable
{
//    [refreshControl endRefreshing];
//    [self.tableView reloadData];
}

#pragma Next-Prev history
- (IBAction)requestBrowsingHistory:(UIButton *)sender
{
    if(sender.tag == 0 && self.page < self.dates.count-1)
    {
        self.page++;
        [self loadHistory];
    }
    else if(sender.tag == 1 && self.page > 0)
    {
        self.page --;
        [self loadHistory];
    }
}

#pragma mark Location dates from server
-(void) loadDates
{
//    self.page = 0;
//    self.dates = [[NSMutableArray alloc] init];
//    [SwiftFTUtils showHUDAddedTo:self.view withText:[@"Loading..." myModification] animated:YES];
//    NSString *url = [NSString stringWithFormat:@"%@/v2/ftd/webhistory/checkindates/%ld",kBasUrl,(long)delegate.selectedDashboardChild.child_id];
//
//    [JSONHTTPClient getJSONFromURLWithString:url completion:^(id json, JSONModelError *err) {
//        NSString *msg = [json valueForKey:@"status_message"] == nil ? [kErrorGeneral myModification] : [json valueForKey:@"status_message"];
//        if([[json valueForKey:@"status_code"] intValue] == 200){
//            NSArray *jsonObject =  [[json valueForKey:@"response"] copy];
//            self.dates = [NSMutableArray arrayWithArray:jsonObject];
//            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//            [self loadHistory];
//        }
//        else
//        {
//            [CommonModel showAlert:[@"Error!" myModification] msg:msg];
//            [self refreshTable];
//            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//        }
//    }];
}

-(void) loadHistory
{
    if(self.dates.count == 0)
        return;
    
//    NSString *date  = [CommonModel date:[self.dates objectAtIndex:self.page] oldFormat:@"YYYY-MM-dd" format:@"EEE, MMM d, yyyy"];//d EEE,MMM yy
//    [self.dateLabel setText:date];
//    [SwiftFTUtils showHUDAddedTo:self.view withText:[@"Loading..." myModification] animated:YES];
//    NSString *pDate = [self.dates objectAtIndex:self.page];
//
//    NSString *url = [NSString stringWithFormat:@"%@/v2/ftd/webhistory/%ld/%@",kBasUrl,(long)delegate.selectedDashboardChild.child_id,pDate];
//    [JSONHTTPClient getJSONFromURLWithString:url completion:^(id json, JSONModelError *err) {
//        NSError *error;
//        NSString *msg = [json valueForKey:@"status_message"] == nil ? [kErrorGeneral myModification] : [json valueForKey:@"status_message"];
//        // read response code
//        if([[json valueForKey:@"status_code"] intValue] == 200)
//        {
//            BrowserHistory *history = [[BrowserHistory alloc] initWithDictionary:json error:&error];
//            NSLog(@"%@",history);
//            self.dataSource = [NSMutableArray arrayWithArray:history.response];
//        }
//        else
//            [CommonModel showAlert:[@"Error!" myModification] msg:msg];
//        [self refreshTable];
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SwiftPlacesCell *cell = (SwiftPlacesCell *)[tableView dequeueReusableCellWithIdentifier:@"PlacesCell"];
    
    if (cell == nil) {
        cell = (SwiftPlacesCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PlacesCell"];
    }
    BrowserHistoryModel *model =  [self.dataSource objectAtIndex:indexPath.row];
    cell.place.text = model.title;
    cell.address.text = model.domain;
    NSString *imgName =[NSString stringWithFormat:@"web_%i.png",(int)indexPath.row%5 + 1 ];
    [cell.placeImg setImage:[UIImage imageNamed:imgName]];
    [cell.editPlace setImage:nil forState:UIControlStateNormal];
    [self viewDidDisappear:YES];
    return cell;
}

@end
