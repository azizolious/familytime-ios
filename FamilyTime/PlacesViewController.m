//
//  PlacesViewController.m
//  FamilyTime
//
//  Created by Sora Code on 11/25/14.
//  Copyright (c) 2014 SoraCode. All rights reserved.
//

#import "PlacesViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
//#import "JSONHTTPClient.h"

#import "PlacesCell.h"
#import "FTD.h"
#import "NEIServiceManager.h"
#import "FTUtils.h"
//#import <Google/Analytics.h>
#import "Dashboard.h"
#import "NSString+LockMustafa.h"
#import "FamilyTime-Swift.h"



AppDelegate *delegate;
UIRefreshControl *  refreshControl;
@interface PlacesViewController ()
@end

@implementation PlacesViewController
- (void)viewWillAppear:(BOOL)animated {
        [super viewWillAppear:YES];
    
    
    DashboardChildPackageFeature *placesPackageFeature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"place"];
    isCountBased = placesPackageFeature.is_count_based;
    countLimit = [placesPackageFeature.count_limit integerValue];
    
    [self loadPlaces];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setTitle:[@"Places (Geo-fence)" myModification]];
    
    delegate = [AppDelegate appDelegate];
    self.addPlacesCont = [[SwiftAddPlacesViewController alloc] initWithNibName:@"AddPlacesViewController2~iphone" bundle:nil];
    [self.tableView registerNib:[UINib nibWithNibName:@"PlacesCell" bundle:nil] forCellReuseIdentifier:@"PlacesCell"];
    if([SwiftFTUtils isDeviceiPhoneFamily])
    {
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 90;
    }
    else
    {
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 120;
    }
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    if (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width) == 667))
    {
        self.tableView.frame=CGRectMake(0, 20, 375, 600);
    }
    else if (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width) == 736))
    {
        self.view.frame=CGRectMake(0, 0, 414, 1800);
        self.tableView.frame=CGRectMake(0, 20, 414, 1700);
    }
    
    add = [[UIBarButtonItem alloc]initWithTitle:[[@"Add" myModification] myModification] style:UIBarButtonItemStylePlain target:self action:@selector(addPlace:)];
    [self.navigationItem setRightBarButtonItems:@[add]];
    self.contactImage.hidden = YES;
    self.lblText.hidden = YES;
    
    self.lblText.text=[self.lblText.text myModification];
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(236, 229,296,212)];
        
        imgView.image = [UIImage imageNamed:@"ipad_empty"];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.hidden=YES;
        [self.view addSubview:imgView];
        [self.view bringSubviewToFront:imgView];
        
        oopsLbl=[[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2-40, 461, 70, 30)];
        oopsLbl.text=[@"Oops!" myModification];
        oopsLbl.font=[UIFont boldSystemFontOfSize:20];
        oopsLbl.hidden=YES;
        [self.view addSubview:oopsLbl];
        [self.view bringSubviewToFront:oopsLbl];
        
        contentLbl=[[UILabel alloc]initWithFrame:CGRectMake(203, 511, 362, 45)];
        contentLbl.lineBreakMode=YES;
        contentLbl.textColor=[UIColor lightGrayColor];
        contentLbl.text=[@"It's lonely in here. Define places to set virtual Geo-fences around them." myModification];
        contentLbl.font=[UIFont systemFontOfSize:16];
        contentLbl.lineBreakMode = NSLineBreakByWordWrapping;
        contentLbl.numberOfLines = 2;
        contentLbl.textAlignment = NSTextAlignmentCenter;
        contentLbl.hidden=YES;
        [self.view addSubview:contentLbl];//
        [self.view bringSubviewToFront:contentLbl];
    }
    if (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width) == 568))
    {
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(57, 98,206,151)];
        
        imgView.image = [UIImage imageNamed:@"ic_empty"];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.hidden=YES;
        [self.view addSubview:imgView];
        [self.view bringSubviewToFront:imgView];
        
        oopsLbl=[[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2-20, 259, 70, 30)];
        oopsLbl.text=[@"Oops!" myModification];
        oopsLbl.font=[UIFont boldSystemFontOfSize:18];
        oopsLbl.hidden=YES;
        [self.view addSubview:oopsLbl];
        [self.view bringSubviewToFront:oopsLbl];
        
        contentLbl=[[UILabel alloc]initWithFrame:CGRectMake(3, 294, 315, 41)];
        contentLbl.lineBreakMode=YES;
        contentLbl.textColor=[UIColor lightGrayColor];
        contentLbl.text=[@"It's lonely in here. Define places to set virtual Geo-fences around them." myModification];
        contentLbl.font=[UIFont systemFontOfSize:16];
        contentLbl.lineBreakMode = NSLineBreakByWordWrapping;
        contentLbl.numberOfLines = 2;
        contentLbl.textAlignment = NSTextAlignmentCenter;
        contentLbl.hidden=YES;
        [self.view addSubview:contentLbl];
        [self.view bringSubviewToFront:contentLbl];
    }
    else if (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width) == 667))
    {
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(115, 152,145,104)];
        
        imgView.image = [UIImage imageNamed:@"ic_empty"];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.hidden=YES;
        [self.view addSubview:imgView];
        [self.view bringSubviewToFront:imgView];
        
        oopsLbl=[[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2-20, 266, 70, 30)];
        oopsLbl.text=[@"Oops!" myModification];
        oopsLbl.font=[UIFont boldSystemFontOfSize:18];
        oopsLbl.hidden=YES;
        [self.view addSubview:oopsLbl];
        [self.view bringSubviewToFront:oopsLbl];
        
        contentLbl=[[UILabel alloc]initWithFrame:CGRectMake(30, 301, 315, 41)];
        contentLbl.lineBreakMode=YES;
        contentLbl.textColor=[UIColor lightGrayColor];
        contentLbl.text=[@"It's lonely in here. Define places to set virtual Geo-fences around them." myModification];
        contentLbl.font=[UIFont systemFontOfSize:17];
        contentLbl.lineBreakMode = NSLineBreakByWordWrapping;
        contentLbl.numberOfLines = 2;
        contentLbl.textAlignment = NSTextAlignmentCenter;
        contentLbl.hidden=YES;
        [self.view addSubview:contentLbl];
        [self.view bringSubviewToFront:contentLbl];
    }
    else if (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width) == 736))
    {
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(127, 168,160,114)];
        
        imgView.image = [UIImage imageNamed:@"ic_empty"];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.hidden=YES;
        [self.view addSubview:imgView];
        [self.view bringSubviewToFront:imgView];
        
        
        oopsLbl=[[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2-20, 292, 70, 30)];
        oopsLbl.text=[@"Oops!" myModification];
        oopsLbl.font=[UIFont boldSystemFontOfSize:18];
        oopsLbl.hidden=YES;
        [self.view addSubview:oopsLbl];
        [self.view bringSubviewToFront:oopsLbl];
        
        contentLbl=[[UILabel alloc]initWithFrame:CGRectMake(26, 327, 362, 45)];
        contentLbl.lineBreakMode=YES;
        contentLbl.textColor=[UIColor lightGrayColor];
        contentLbl.text=[@"It's lonely in here. Define places to set virtual Geo-fences around them." myModification];
        contentLbl.font=[UIFont systemFontOfSize:16];
        contentLbl.lineBreakMode = NSLineBreakByWordWrapping;
        contentLbl.numberOfLines = 2;
        contentLbl.textAlignment = NSTextAlignmentCenter;
        contentLbl.hidden=YES;
        [self.view addSubview:contentLbl];
        [self.view bringSubviewToFront:contentLbl];
    }
    
    add.enabled=YES;
    [self addPullRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateUI
{
    if (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width) == 568))
    {
        imgView.hidden=NO;
        contentLbl.hidden=NO;
        oopsLbl.hidden=NO;
        
        self.contactImage.hidden=YES;
        self.lblText.hidden=YES;
    }
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        imgView.hidden=NO;
        contentLbl.hidden=NO;
        oopsLbl.hidden=NO;
        
        self.contactImage.hidden=YES;
        self.lblText.hidden=YES;
    }
    if (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width) == 667))
    {
        imgView.hidden=NO;
        contentLbl.hidden=NO;
        oopsLbl.hidden=NO;
        
        self.contactImage.hidden=YES;
        self.lblText.hidden=YES;
    }
    else if (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width) == 736))
    {
        imgView.hidden=NO;
        contentLbl.hidden=NO;
        oopsLbl.hidden=NO;
        
        self.contactImage.hidden=YES;
        self.lblText.hidden=YES;
    }
}

#pragma mark Places
-(void) editPlace
{
    [self.tableView setEditing:!self.tableView.isEditing];
}

-(void) loadPlaces
{
    [SwiftFTUtils showHUDAddedTo:self.view withText:@"Loading..." animated:YES];
//
    
    NSString *url = [NSString stringWithFormat:@"%@%ld", kPlaces_mesh2, (long)delegate.selectedDashboardChild.child_id];
    
    [[ApiManager shared] getPlacesApiWithVC:self andUrl:url withResponse:^(AllPlacesModel * _Nonnull model, NSString *message, NSInteger statusCode) {
        
        NSLog(@"%@", url);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            if(statusCode == 1)//---1 MEANS RESPONSE DATA IS NIL---//
            {
                [CommonModel showAlert:@"Error!" msg:message];
            }
            else if (statusCode == 200){
                NSLog(@"api success with message =  %@",model.message);
                
                self.dataSource = [[NSMutableArray alloc]init];
                self.dataSource = [NSMutableArray arrayWithArray:model.data];
                [self viewDidDisappear:YES];
                [self refreshTable];
            }
            else
                [CommonModel showAlert:@"Error!" msg:model.message];
            
            [self updateUI];
        });
    }];
    
    //---DEPRICATED---//
    
//    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:delegate.selectedDashboardChild.child_id],@"child_id", nil];
//    [JSONHTTPClient postJSONFromURLWithString:@"" //KPlaces
//                                       params:params
//                                   completion:^(id json, JSONModelError *err) {
//                                       NSError *error;
//                                       // read response code
//
//                                       NSLog(@"places json response = %@",json);
//
//                                       if([[json valueForKey:@"response"] intValue]== 200)
//                                       {
//                                           NSLog(@"%@",json);
//                                           AllPlacesModel *places = [[AllPlacesModel alloc] initWithDictionary:json error:&error];
//                                           NSLog(@"%@",places);
//                                           self.dataSource = [[NSMutableArray alloc]init];
//                                           self.dataSource = [NSMutableArray arrayWithArray:places.data];
//
//                                           [self viewDidDisappear:YES];
//                                       }
//                                       else
//                                           [CommonModel showAlert:@"Error!" msg:[json valueForKey:@"message"]];
//                                            [self refreshTable];
//
//                                       if (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width) == 568))
//                                       {
//                                           imgView.hidden=NO;
//                                           contentLbl.hidden=NO;
//
//                                           self.contactImage.hidden=YES;
//                                           self.lblText.hidden=YES;
//                                       }
//
//                                       if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//                                       {
//                                           imgView.hidden=NO;
//                                           contentLbl.hidden=NO;
//
//                                           self.contactImage.hidden=YES;
//                                           self.lblText.hidden=YES;
//                                       }
//                                        if (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width) == 667))
//                                       {
//                                           imgView.hidden=NO;
//                                           contentLbl.hidden=NO;
//
//                                           self.contactImage.hidden=YES;
//                                           self.lblText.hidden=YES;
//                                       }
//                                       else if (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width) == 736))
//                                       {
//                                           imgView.hidden=NO;
//                                           contentLbl.hidden=NO;
//
//                                           self.contactImage.hidden=YES;
//                                           self.lblText.hidden=YES;
//                                       }
//
//                                       [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                                   }];
    
}
- (void)viewDidDisappear:(BOOL)animated
{
    if (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width) == 568))
    {
        imgView.hidden=YES;
        contentLbl.hidden=YES;
        oopsLbl.hidden=YES;
    }
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        
        imgView.hidden=YES;
        contentLbl.hidden=YES;
        oopsLbl.hidden=YES;
    }
    if (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width) == 667))
    {
        imgView.hidden=YES;
        contentLbl.hidden=YES;
        oopsLbl.hidden=YES;
    }
    else if (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width) == 736))
    {
        imgView.hidden=YES;
        contentLbl.hidden=YES;
        oopsLbl.hidden=YES;
    }
    [refreshControl endRefreshing];
}


#pragma mark - QBRefreshControlDelegate
- (void) addPullRefresh
{
    refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(loadPlaces) forControlEvents:UIControlEventValueChanged];
   
}
- (void)refreshTable
{
    [refreshControl endRefreshing];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    PlaceModel *place =  [self.dataSource objectAtIndex:indexPath.row] ;
    cell.place.text = place.location;
    cell.address.text = place.address;
    cell.editPlace.tag = indexPath.row;
    [cell.editPlace addTarget:self action:@selector(editing:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.editPlace setImage:[UIImage imageNamed:@"edit_1.png"] forState:UIControlStateNormal];
    
    NSString *imgName =[NSString stringWithFormat:@"geo0_%i.png",(int)indexPath.row%4 + 1 ];
    [cell.placeImg setImage:[UIImage imageNamed:imgName]];
    
    [self viewDidDisappear:YES];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self editPlace:(int)indexPath.row];
}

#pragma mark Edit Place
- (void)editing:(UIButton *) sender;
{
    [self editPlace:(int)sender.tag];
}

- (void)editPlace:(int) index;
{
    self.addPlacesCont = [[SwiftAddPlacesViewController alloc] initWithNibName:@"AddPlacesViewController2~iphone" bundle:nil];
    [self.navigationController pushViewController:self.addPlacesCont animated:YES];
    self.addPlacesCont.mode  = @"editing";
    self.addPlacesCont.place = [self.dataSource objectAtIndex:index];
}

- (IBAction)addPlace:(id)sender
{
    if (isCountBased)
    {
        if (self.dataSource.count < countLimit)
        {
            self.addPlacesCont = [[SwiftAddPlacesViewController alloc] initWithNibName:@"AddPlacesViewController2~iphone" bundle:nil];
            [self.navigationController pushViewController:self.addPlacesCont animated:YES];
            self.addPlacesCont.mode  = @"";
        }
        else
        {
//            NSString *popupTitle = [NSString stringWithFormat:@"\n%@",[@"Limit Exceeded!" myModification]];
//            NSString *firstParagraph = [NSString stringWithFormat:@"\n%@\n",[@"The Places limit is exceeded; You can add only 1 Place with free subscription." myModification]];
//            NSString *firstTitle = @"";
//            NSString *firstDetails = [NSString stringWithFormat:@"\n%@",[@"Upgrade each child device to premium for a small monthly fee and get ultimate parenting satisfaction." myModification]];
//            NSString *secondTitle = @"\n";
//            NSString *secondDetails = [NSString stringWithFormat:@"\n%@",[@"Please login to your web Dashbord to upgrade the subscription and unrestricted access." myModification]];
//            [SwiftFTUtils showPremiumPopupWith:self title:popupTitle firstParagraph:firstParagraph firstTitle:firstTitle firstDetails:firstDetails secondTitle:secondTitle secondDetails:secondDetails imageName:@"ic_premium" color:@"orange"];
            [SwiftFTUtils showSwiftPremiumPopupOn:self];
        }
    }
    else
    {
        self.addPlacesCont = [[SwiftAddPlacesViewController alloc] initWithNibName:@"AddPlacesViewController2~iphone" bundle:nil];
        [self.navigationController pushViewController:self.addPlacesCont animated:YES];
        self.addPlacesCont.mode  = @"";
    }
}

@end
