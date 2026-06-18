//
//  TextMessagesViewController.m
//  FamilyTime - Dashboard
//
//  Created by Muhammad Ajmal on 22/08/2016.
//  Copyright © 2016 SoraCode. All rights reserved.
//

#import "TextMessagesViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
//#import "JSONHTTPClient.h"
#import "MessageThreadCell.h"
#import "FTD.h"
#import "FTUtils.h"
//#import <Google/Analytics.h>
#import "DataModel.h"
#import "TextMessageDetailsViewController.h"
#import "NSString+LockMustafa.h"
#import "FamilyTime-Swift.h"
@class CoreDataUtility;

AppDelegate *delegate;

NSString *text_package_id = @"";
NSString *text_package_name = @"";
NSString *text_device = @"";

@interface TextMessagesViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSArray *contactColors;
@property (nonatomic, strong) UIRefreshControl *  refreshControl;
@end

@implementation TextMessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:[@"Text Messages" myModification]];
//    [ZendeskChatManager trackEvent:@"text Messages"];

    self.view.backgroundColor = [UIColor whiteColor];
    delegate = [AppDelegate appDelegate];
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 64.0f) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"MessageThreadCell" bundle:nil] forCellReuseIdentifier:@"messages_cell"];
    self.tableView.rowHeight = 80;
    self.contactColors = KCallColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    
    NSInteger child_id = delegate.selectedDashboardChild.child_id;
    int convertedChild_id = (int) child_id;
    
    text_package_id =  [CoreDataUtility fetchPackageIdForChild_id:(convertedChild_id)];
    text_package_name = [CoreDataUtility fetchPackageNameForChild_id:(convertedChild_id)];
    text_device =  [CoreDataUtility fetchPackageDeviceForChild_id:(convertedChild_id)];
    
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(236, 229,296,212)];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.image = [UIImage imageNamed:@"ipad_empty"];
        imgView.hidden=YES;
        [self.view addSubview:imgView];
        [self.view bringSubviewToFront:imgView];
        
        contentLbl=[[UILabel alloc]initWithFrame:CGRectMake(203, 489, 362, 41)];
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
    }
    else if(([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone))
    {
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(115, 152,145,104)];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.image = [UIImage imageNamed:@"ic_empty"];
        imgView.hidden=YES;
        [self.view addSubview:imgView];
        [self.view bringSubviewToFront:imgView];
        
        contentLbl=[[UILabel alloc]initWithFrame:CGRectMake(6, 279, 362, 45)];
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
    }
    
    //DashboardChildPackageFeature *packageFeature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"sms"];
    if ([text_package_id isEqualToString:@"3"]) {
        //if(packageFeature.is_time_based == 1 || packageFeature.is_count_based == 1)
            //[self showPremiumBanner:YES];
       // else
            //[self showPremiumBanner:NO];
        [self addPullRefresh];
        [self loadMessages];
    } else {
        [self showPremiumAlert];
        //[self showPremiumFeatureView:YES];
    }    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //DashboardChildPackageFeature *packageFeature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"sms"];
    if ([text_package_id isEqualToString:@"3"]) {
        //if(packageFeature.is_time_based == 1 || packageFeature.is_count_based == 1)
            //[self showPremiumBanner:YES];
       // else
            //[self showPremiumBanner:NO];
        
        //[self showPremiumAlert];
        [self addPullRefresh];
        [self loadMessages];
    } else {
        //[self showPremiumFeatureView:YES];
    }
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   
}

- (void) addPullRefresh
{
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(loadMessages) forControlEvents:UIControlEventValueChanged];
}

- (void)refreshTable
{
    [self.refreshControl endRefreshing];
    [self.refreshControl removeFromSuperview];
    self.refreshControl = nil;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showPremiumAlert
{
    [SwiftFTUtils showSwiftPremiumPopupOn:self];
}

- (void)loadMessages
{
    [SwiftFTUtils showHUDAddedTo:self.view withText:[@"Loading..." myModification] animated:YES];
    //NSString *url = [NSString stringWithFormat:@"%@/v2/ftd/reports/conversations/%ld",kBasUrl,(long)delegate.selectedDashboardChild.child_id];
    NSString *url = [NSString stringWithFormat:@"%@/dashboard/messages/%ld",kBasUrlNew_mesh2,(long)delegate.selectedDashboardChild.child_id];
    
    /*
    
    [JSONHTTPClient getJSONFromURLWithString:url
                                      params:nil
                                  completion:^(id json, JSONModelError *err) {
                                      NSError *error;
                                      // read response code
                                      if([[json valueForKey:@"status_code"] integerValue] == 200)
                                      {
                                          NSLog(@"%@",json);
                                          
                                          MessageThreadsModel *threads = [[MessageThreadsModel alloc] initWithDictionary:json error:&error];
                                          NSLog(@"%@",threads);
                                          self.dataSource = [NSMutableArray arrayWithArray:threads.response];
                                          
                                          if (threads.response.count > 0)
                                          {
                                              _tableView.hidden=NO;

                                              imgView.hidden=YES;
                                              contentLbl.hidden=YES;
                                              self.view.backgroundColor = UIColorFromRGB(0xEFEFF4);
                                          }
                                          else
                                          {
                                              _tableView.hidden=YES;
                                              imgView.hidden=NO;
                                              contentLbl.hidden=NO;
                                              self.view.backgroundColor = [UIColor whiteColor];
                                          }
                                      }
                                      else
                                      {
                                          [CommonModel showAlert:[@"Error!" myModification] msg:[json valueForKey:@"status_message"]];
                                          _tableView.hidden=YES;
                                          imgView.hidden=NO;
                                          contentLbl.hidden=NO;

                                          
                                      }
                                      [self refreshTable];
                                      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                  }];
    
    
    */
    
    //---NATIVE API CALLING---//
    
    [[ApiManager shared] mesh_getApiWithApi:url withResponse:^(NSDictionary * _Nonnull json, NSInteger errorCode, NSString * _Nonnull message) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"Old Mesh api Text MEssages json = %@",json);
            
            NSError *error;
            // read response code
            if([[json valueForKey:@"status"] integerValue] == 200)
            {
                MessageThreadsModel *threads = [[MessageThreadsModel alloc] initWithDictionary:json error:&error];
                NSLog(@"%@",threads);
                
                self.dataSource = [NSMutableArray arrayWithArray:threads.messages];
                self.dataSource = [[[self.dataSource reverseObjectEnumerator] allObjects] mutableCopy];
                if (threads.messages.count > 0)
                {
                    _tableView.hidden=NO;
                    
                    imgView.hidden=YES;
                    contentLbl.hidden=YES;
                    self.view.backgroundColor = UIColorFromRGB(0xEFEFF4);
                }
                else
                {
                    _tableView.hidden=YES;
                    imgView.hidden=NO;
                    contentLbl.hidden=NO;
                    self.view.backgroundColor = [UIColor whiteColor];
                }
            }
            else
            {
                [CommonModel showAlert:[@"Error!" myModification] msg:[json valueForKey:@"message"]];
                _tableView.hidden=YES;
                imgView.hidden=NO;
                contentLbl.hidden=NO;
            }
            
            [self refreshTable];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        });
    }];
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageThreadCell *cell = (MessageThreadCell *)[tableView dequeueReusableCellWithIdentifier:@"messages_cell" forIndexPath:indexPath];
    MessageThreadModel *thread = (MessageThreadModel *)[self.dataSource objectAtIndex:indexPath.row];
    cell.snippetLabel.text = thread.snippet;
    cell.nameLabel.text = thread.contact_name;
    NSString *contactImgName =[NSString stringWithFormat:@"call_circ_%i.png",(int)indexPath.row%4 + 1 ];
    NSString *avatarImgName =[NSString stringWithFormat:@"avater%i.png",(int)indexPath.row%4 + 1 ];
    
    unichar firstChar = [thread.contact_name characterAtIndex:0];
    BOOL isLetter = [[NSCharacterSet letterCharacterSet] characterIsMember: firstChar];
    
    
    if(isLetter)
    {
        NSString *fc = [NSString stringWithFormat:@"%c",[thread.contact_name characterAtIndex:0]];
        [cell.imageButton setTitle:fc forState:UIControlStateNormal];
        [cell.imageButton setBackgroundImage:[UIImage imageNamed:contactImgName] forState:UIControlStateNormal];
    }
    else
    {
        [cell.imageButton setTitle:@"" forState:UIControlStateNormal];
        [cell.imageButton setBackgroundImage:[UIImage imageNamed:avatarImgName] forState:UIControlStateNormal];
    }
    [cell.imageButton setTitleColor:[self.contactColors objectAtIndex:indexPath.row %4] forState:UIControlStateNormal];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:thread.thread_date];
    NSInteger days = [self daysBetweenDate:date andDate:[NSDate date]];
    
    if (days == 0)
    {
        cell.dateLabel.text = [@"Today" myModification];
    }
    else if(days == 1)
    {
        cell.dateLabel.text = [@"Yesterday" myModification];
    }
    else
    {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"EEE, MMM dd"];
        cell.dateLabel.text = [df stringFromDate:date];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TextMessageDetailsViewController *vc = [[TextMessageDetailsViewController alloc] init];
    MessageThreadModel *thread = (MessageThreadModel *)[self.dataSource objectAtIndex:indexPath.row];
    vc.thread_id = thread.thread_id;
    self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                                                         initWithTitle:[@"Back" myModification] style:UIBarButtonItemStylePlain target:nil action:nil];
    vc.title = thread.contact_name;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}
@end
