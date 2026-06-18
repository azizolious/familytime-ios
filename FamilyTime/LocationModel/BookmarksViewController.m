//
//  BookmarksViewController.m
//  FamilyTime
//
//  Created by Sora Code on 12/19/14.
//  Copyright (c) 2014 SoraCode. All rights reserved.
//

#import "BookmarksViewController.h"
#import "MBProgressHUD.h"
//#import "JSONHTTPClient.h"
#import "AppDelegate.h"
#import "PlaceCell.h"
#import "PlacesCell.h"
//#import <Google/Analytics.h>
#import "FTUtils.h"
#import "NSString+LockMustafa.h"
#import "FamilyTime-Swift.h"
AppDelegate *delegate;
UIRefreshControl *  refreshControl;
@interface BookmarksViewController ()
@end

@implementation BookmarksViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:[@"Bookmarks" myModification]];
    delegate = [AppDelegate appDelegate];
    [self.tableView registerNib:[UINib nibWithNibName:@"PlacesCell" bundle:nil] forCellReuseIdentifier:@"PlacesCell"];
    if([SwiftFTUtils isDeviceiPhoneFamily])
        self.tableView.rowHeight = 60;
    else
        self.tableView.rowHeight = 100;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self addPullRefresh];
    [self loadBookmarks];

    [self showNoDataView];
    
//    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//    {
//        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(236, 229,296,212)];
//        imgView.contentMode = UIViewContentModeScaleAspectFill;
//        imgView.image = [UIImage imageNamed:@"ipad_empty"];
//
//        imgView.hidden=YES;
//        [self.view addSubview:imgView];
//        [self.view bringSubviewToFront:imgView];
//
//        contentLbl=[[UILabel alloc]initWithFrame:CGRectMake(203, 489, 362, 45)];
//        contentLbl.lineBreakMode=YES;
//        contentLbl.textColor=[UIColor lightGrayColor];
//        contentLbl.text=[@"It seems like there is no record to\n display." myModification];
//        contentLbl.font=[UIFont systemFontOfSize:16];
//        contentLbl.lineBreakMode = NSLineBreakByWordWrapping;
//        contentLbl.numberOfLines = 2;
//        contentLbl.textAlignment = NSTextAlignmentCenter;
//        contentLbl.hidden=YES;
//        [self.view addSubview:contentLbl];
//        [self.view bringSubviewToFront:contentLbl];
//
//
//        self.lblText.text=[@"It seems like there is no record to\n display." myModification];
//    }
//    else if (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone ))
//    {
//        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(115, 152,145,104)];
//        imgView.contentMode = UIViewContentModeScaleAspectFill;
//
//        imgView.image = [UIImage imageNamed:@"ic_empty"];
//        imgView.hidden=YES;
//        [self.view addSubview:imgView];
//        [self.view bringSubviewToFront:imgView];
//
//        contentLbl=[[UILabel alloc]initWithFrame:CGRectMake(30, 279, 315, 41)];
//        contentLbl.lineBreakMode=YES;
//        contentLbl.textColor=[UIColor lightGrayColor];
//        contentLbl.text=[@"It seems like there is no record to\n display." myModification];
//        contentLbl.font=[UIFont systemFontOfSize:17];
//        contentLbl.lineBreakMode = NSLineBreakByWordWrapping;
//        contentLbl.numberOfLines = 2;
//        contentLbl.textAlignment = NSTextAlignmentCenter;
//        contentLbl.hidden=YES;
//        [self.view addSubview:contentLbl];
//        [self.view bringSubviewToFront:contentLbl];
//    }
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
        
        
        self.lblText.text=[@"It seems like there is no record to\n display." myModification];
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


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    DashboardChildPackageFeature *packageFeature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"bookmark"];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - QBRefreshControlDelegate

//---DEPRICATED---//---WE DON'T NEED THESE ANYMORE---//

-(void) addPullRefresh
{
//    refreshControl = [[UIRefreshControl alloc]init];
//    [self.tableView addSubview:refreshControl];
//    [refreshControl addTarget:self action:@selector(loadBookmarks) forControlEvents:UIControlEventValueChanged];
}

- (void)refreshTable
{
//    [refreshControl endRefreshing];
//    [self.tableView reloadData];
}

#pragma mark Places
-(void) editHistory
{
    [self.tableView setEditing:!self.tableView.isEditing];
}

-(void) loadBookmarks
{
    
    self.contactImage.hidden = NO;
    self.lblText.hidden      = NO;
    
    /*
    
    [SwiftFTUtils showHUDAddedTo:self.view withText:[@"Loading..." myModification] animated:YES];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:delegate.selectedDashboardChild.child_id],@"child_id", nil];
    [JSONHTTPClient postJSONFromURLWithString:KBookmarksLogs
                                       params:params
                                   completion:^(id json, JSONModelError *err) {
                                       NSError *error;
                                        NSString *msg = [json valueForKey:@"message"] == nil ? [kErrorGeneral myModification] : [json valueForKey:@"message"];
                                       // read response code
                                       if([[json valueForKey:@"response"] intValue]== 200){
                                           AllBookmarksModel *places = [[AllBookmarksModel alloc] initWithDictionary:json error:&error];
                                           self.dataSource = [[NSMutableArray alloc]init];
                                           self.dataSource = [NSMutableArray arrayWithArray:places.data];
                                           [self viewDidDisappear:YES];
                                       }
                                       else
                                           [CommonModel showAlert:[@"Error!" myModification] msg:msg];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;//self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SwiftPlacesCell *cell = (SwiftPlacesCell *)[tableView dequeueReusableCellWithIdentifier:@"PlacesCell"];
    
    if (cell == nil) {
        cell = (SwiftPlacesCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PlacesCell"];
        //        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    // Configure the cell...
    BookmarksModel *model =  [self.dataSource objectAtIndex:indexPath.row] ;
    cell.place.text = model.title;
    cell.address.text = model.domain;
     NSString *imgName =[NSString stringWithFormat:@"bm_%i.png",(int)indexPath.row%4 + 1 ];
    [cell.editPlace setImage:nil forState:UIControlStateNormal];
    [cell.placeImg setImage:[UIImage imageNamed:imgName]];
    [self viewDidDisappear:YES];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    [self editPlace:indexPath.row];
}


@end

