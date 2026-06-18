//
//  ContentFilterDetailsViewController.m
//  FamilyTime - Dashboard
//
//  Created by Muhammad Ajmal on 01/06/2016.
//  Copyright © 2016 SoraCode. All rights reserved.
//

#import "ContentFilterDetailsViewController.h"
#import "MBProgressHUD.h"
//#import "JSONHTTPClient.h"
#import "AppDelegate.h"
#import "FTD.h"
#import "FTUtils.h"
//#import <Google/Analytics.h>
#import "UIView+VTSelectiveBorder.h"
#import "FamilyTime-Swift.h"

AppDelegate *delegate;
@interface ContentFilterDetailsViewController ()
@property (nonatomic, strong) NSString *filterValue;
@property (nonatomic, strong) NSArray *filters;
@property (nonatomic, strong) NSMutableArray *selectedIndices;
@end

@implementation ContentFilterDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"contentfilterdetails"];
    
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    delegate = [AppDelegate appDelegate];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        self.tableView.rowHeight = 75;
    else
        self.tableView.rowHeight = 60;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.selectedIndices = [NSMutableArray array];
    switch (self.detailsType)
    {
        case ContentFilterDetailsTypeApps:
            [self.navigationItem setTitle:@"Apps"];
            break;
        case ContentFilterDetailsTypeTVShows:
            [self.navigationItem setTitle:@"TV Programes"];
            break;
        case ContentFilterDetailsTypeMovies:
            [self.navigationItem setTitle:@"Films"];
            break;
        default:
            break;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    switch (self.detailsType)
    {
        case ContentFilterDetailsTypeApps:
            [self loadAppsSettings];
            break;
        case ContentFilterDetailsTypeTVShows:
            [self loadTVShowsSettings];
            break;
        case ContentFilterDetailsTypeMovies:
            [self loadMoviesSettings];
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filters.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 60)];
    label.backgroundColor = [UIColor groupTableViewBackgroundColor];
    label.textColor = RGBCOLOR(138, 138, 138, 1);
    label.font = [UIFont fontWithName:@"OpenSans" size:16];
    switch (self.detailsType) {
        case ContentFilterDetailsTypeMovies:
            label.text = @"    ALLOWED FILMS RATED";
            break;
        case ContentFilterDetailsTypeTVShows:
           label.text = @"    ALLOWED TV PROGRAMMES RATED";
            break;
        case ContentFilterDetailsTypeApps:
            label.text = @"    ALLOWED APPS RATED";
            break;
        default:
            break;
    }
    
    
    return label;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contentfilterdetails" forIndexPath:indexPath];
    if([self.filters[indexPath.row] isEqualToString:@"false"])
    {
        switch (self.detailsType) {
            case ContentFilterDetailsTypeMovies:
                cell.textLabel.text = @"Don't Allow Films";
                break;
            case ContentFilterDetailsTypeTVShows:
                 cell.textLabel.text = @"Don't Allow TV Programmes";
                break;
            case ContentFilterDetailsTypeApps:
                break;
            default:
                break;
        }
    }
    else if([self.filters[indexPath.row] isEqualToString:@"true"])
    {
        switch (self.detailsType) {
            case ContentFilterDetailsTypeMovies:
                cell.textLabel.text = @"Allow All Films";
                break;
            case ContentFilterDetailsTypeTVShows:
                cell.textLabel.text = @"Allow All TV Programmes";
                break;
            case ContentFilterDetailsTypeApps:
                cell.textLabel.text = @"Allow All Apps";
                break;
            default:
                break;
        }
    }
    else
    {
        cell.textLabel.text = self.filters[indexPath.row];
    }
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        cell.textLabel.font = [UIFont fontWithName:@"OpenSans" size:20.0f];
    else
        cell.textLabel.font = [UIFont fontWithName:@"OpenSans" size:15.0f];
    cell.textLabel.textColor = RGBCOLOR(85, 85, 85, 1);
    
    cell.selectiveBorderFlag = AUISelectiveBordersFlagBottom;
    cell.selectiveBordersColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5f];
    cell.selectiveBordersWidth = 0.5f;
    
    if([self.selectedIndices containsObject:[NSNumber numberWithInteger:indexPath.row]])
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (self.detailsType) {
        case ContentFilterDetailsTypeMovies:
        {
            [self handleMoviesSelectionAt:indexPath];
            self.filterValue = [self.filters objectAtIndex:indexPath.row];
            [self saveMoviesSettings];
        }
            break;
        case ContentFilterDetailsTypeTVShows:
        {
            [self handleTVShowsSelectionAt:indexPath];
            self.filterValue = [self.filters objectAtIndex:indexPath.row];
            [self saveTVShowsSettings];
        }
            break;
        case ContentFilterDetailsTypeApps:
        {
            [self handleAppsSelectionAt:indexPath];
            self.filterValue = [self.filters objectAtIndex:indexPath.row];
            [self saveAppsSettings];
        }
            break;
        default:
            break;
    }
}

- (void)handleMoviesSelectionAt:(NSIndexPath *)indexPath
{
    [self.selectedIndices removeAllObjects];
    if(indexPath.row == 0)//first
    {
        [self.selectedIndices addObject:[NSNumber numberWithInteger:0]];
    }
    else if(indexPath.row == self.filters.count - 1)//last
    {
        for(NSInteger index = 1; index < self.filters.count; index++)
            [self.selectedIndices addObject:[NSNumber numberWithInteger:index]];
            
    }
    else//others
    {
        for(NSInteger index = indexPath.row; index > 0; index--)
            [self.selectedIndices addObject:[NSNumber numberWithInteger:index]];
    }
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)handleTVShowsSelectionAt:(NSIndexPath *)indexPath
{
    [self.selectedIndices removeAllObjects];
    if(indexPath.row == 0)//first
    {
        [self.selectedIndices addObject:[NSNumber numberWithInteger:0]];
    }
    else if(indexPath.row == self.filters.count - 1)//last
    {
        for(NSInteger index = 1; index < self.filters.count; index++)
            [self.selectedIndices addObject:[NSNumber numberWithInteger:index]];
        
    }
    else//others
    {
        for(NSInteger index = indexPath.row; index > 0; index--)
            [self.selectedIndices addObject:[NSNumber numberWithInteger:index]];
    }
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)handleAppsSelectionAt:(NSIndexPath *)indexPath
{
    [self.selectedIndices removeAllObjects];
    if(indexPath.row == self.filters.count - 1)//last
    {
        for(NSInteger index = 0; index < self.filters.count; index++)
            [self.selectedIndices addObject:[NSNumber numberWithInteger:index]];
        
    }
    else//others
    {
        for(NSInteger index = indexPath.row; index >= 0; index--)
            [self.selectedIndices addObject:[NSNumber numberWithInteger:index]];
    }
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma 
#pragma mark - API

- (void)loadAppsSettings
{
    [SwiftFTUtils showHUDAddedTo:self.view withText:@"Loading..." animated:YES];
    NSString *url = [NSString stringWithFormat:@"%@/dashboard/settings/ios/contentfilters/apps/%ld", kBasUrlNew_mesh2, (long)delegate.selectedDashboardChild.child_id];
    
    /*
    
    [JSONHTTPClient getJSONFromURLWithString:url
                                      params:nil
                                  completion:^(id json, JSONModelError *err) {
                                          [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                      NSString *msg = [json valueForKey:@"message"] == nil ? [kErrorGeneral myModification]: [json valueForKey:@"message"];
                                      if([[json objectForKey:@"status"] integerValue] == 200)
                                      {
                                          self.filters = [[json objectForKey:@"data"] objectForKey:@"list"];
                                          NSString *filter = [[json objectForKey:@"data"] objectForKey:@"value"];
                                          if([self.filters containsObject:filter])
                                          {
                                              NSInteger index = [self.filters indexOfObject:filter];
                                              self.filterValue = filter;
                                              [self handleAppsSelectionAt:[NSIndexPath indexPathForRow:index inSection:0]];
                                          }
                                          else
                                          {
                                              self.filterValue = @"true";
                                              [self handleAppsSelectionAt:[NSIndexPath indexPathForRow:self.filters.count - 1 inSection:0]];
                                          }
                                      }
                                      else
                                          [CommonModel showAlert:@"Error!" msg:msg];
                                  }];
    
     */
    
    
    //---NATIVE API CALLING---//
    
    [[ApiManager shared] mesh_getApiWithApi:url withResponse:^(NSDictionary * _Nonnull json, NSInteger errorCode, NSString * _Nonnull message) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            NSLog(@"Old Mesh load apps content filter ios api response = %@", json);
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            NSString *msg = [json valueForKey:@"message"] == nil ? [kErrorGeneral myModification]: [json valueForKey:@"message"];
            if([[json objectForKey:@"status"] integerValue] == 200)
            {
                self.filters = [[json objectForKey:@"data"] objectForKey:@"list"];
                NSString *filter = [[json objectForKey:@"data"] objectForKey:@"value"];
                if([self.filters containsObject:filter])
                {
                    NSInteger index = [self.filters indexOfObject:filter];
                    self.filterValue = filter;
                    [self handleAppsSelectionAt:[NSIndexPath indexPathForRow:index inSection:0]];
                }
                else
                {
                    self.filterValue = @"true";
                    [self handleAppsSelectionAt:[NSIndexPath indexPathForRow:self.filters.count - 1 inSection:0]];
                }
            }
            else
                [CommonModel showAlert:@"Error!" msg:msg];
            
        });
        
    }];
    
    
}

- (void)loadTVShowsSettings
{
    [SwiftFTUtils showHUDAddedTo:self.view withText:@"Loading..." animated:YES];
    NSString *url = [NSString stringWithFormat:@"%@/dashboard/settings/ios/contentfilters/tvshows/%ld", kBasUrlNew_mesh2, delegate.selectedDashboardChild.child_id];
    
    /*
    
    [JSONHTTPClient getJSONFromURLWithString:url
                                      params:nil
                                  completion:^(id json, JSONModelError *err) {
                                      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                      NSString *msg = [json valueForKey:@"message"] == nil ? [kErrorGeneral myModification] : [json valueForKey:@"message"];
                                      if([[json objectForKey:@"status"] integerValue] == 200)
                                      {
                                          self.filters = [[json objectForKey:@"data"] objectForKey:@"list"];
                                          NSString *filter = [[json objectForKey:@"data"] objectForKey:@"value"];
                                          if([self.filters containsObject:filter])
                                          {
                                              NSInteger index = [self.filters indexOfObject:filter];
                                              self.filterValue = filter;
                                              [self handleTVShowsSelectionAt:[NSIndexPath indexPathForRow:index inSection:0]];
                                          }
                                          else
                                          {
                                              self.filterValue = @"true";
                                              [self handleTVShowsSelectionAt:[NSIndexPath indexPathForRow:self.filters.count - 1 inSection:0]];
                                          }
                                      }
                                      else
                                          [CommonModel showAlert:@"Error!" msg:msg];
                                  }];
    
     */
    
    //---NATIVE API CALLING---//
    
    [[ApiManager shared] mesh_getApiWithApi:url withResponse:^(NSDictionary * _Nonnull json, NSInteger errorCode, NSString * _Nonnull message) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"Old Mesh load apps content filter ios api response = %@", json);
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            NSString *msg = [json valueForKey:@"message"] == nil ? [kErrorGeneral myModification] : [json valueForKey:@"message"];
            if([[json objectForKey:@"status"] integerValue] == 200)
            {
                self.filters = [[json objectForKey:@"data"] objectForKey:@"list"];
                NSString *filter = [[json objectForKey:@"data"] objectForKey:@"value"];
                if([self.filters containsObject:filter])
                {
                    NSInteger index = [self.filters indexOfObject:filter];
                    self.filterValue = filter;
                    [self handleTVShowsSelectionAt:[NSIndexPath indexPathForRow:index inSection:0]];
                }
                else
                {
                    self.filterValue = @"true";
                    [self handleTVShowsSelectionAt:[NSIndexPath indexPathForRow:self.filters.count - 1 inSection:0]];
                }
            }
            else
                [CommonModel showAlert:@"Error!" msg:msg];
            
        });
        
    }];
}

- (void)loadMoviesSettings
{
    [SwiftFTUtils showHUDAddedTo:self.view withText:@"Loading..." animated:YES];
    NSString *url = [NSString stringWithFormat:@"%@/dashboard/settings/ios/contentfilters/movies/%ld", kBasUrlNew_mesh2, delegate.selectedDashboardChild.child_id];
    
    /*
     
    [JSONHTTPClient getJSONFromURLWithString:url
                                      params:nil
                                  completion:^(id json, JSONModelError *err) {
                                      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                      NSString *msg = [json valueForKey:@"message"] == nil ? [kErrorGeneral myModification] : [json valueForKey:@"message"];
                                      if([[json objectForKey:@"status"] integerValue] == 200)
                                      {
                                          self.filters = [[json objectForKey:@"data"] objectForKey:@"list"];
                                          NSString *filter = [[json objectForKey:@"data"] objectForKey:@"value"];
                                          if([self.filters containsObject:filter])
                                          {
                                              NSInteger index = [self.filters indexOfObject:filter];
                                              self.filterValue = filter;
                                              [self handleMoviesSelectionAt:[NSIndexPath indexPathForRow:index inSection:0]];
                                          }
                                          else
                                          {
                                              self.filterValue = @"true";
                                              [self handleMoviesSelectionAt:[NSIndexPath indexPathForRow:self.filters.count - 1 inSection:0]];
                                          }
                                      }
                                      else
                                          [CommonModel showAlert:@"Error!" msg:msg];
                                  }];
     
     */
    
    
    //---NATIVE API CALLING---//
    
    [[ApiManager shared] mesh_getApiWithApi:url withResponse:^(NSDictionary * _Nonnull json, NSInteger errorCode, NSString * _Nonnull message) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"Old Mesh load apps content filter ios api response = %@", json);
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            NSString *msg = [json valueForKey:@"message"] == nil ? [kErrorGeneral myModification] : [json valueForKey:@"message"];
            if([[json objectForKey:@"status"] integerValue] == 200)
            {
                self.filters = [[json objectForKey:@"data"] objectForKey:@"list"];
                NSString *filter = [[json objectForKey:@"data"] objectForKey:@"value"];
                if([self.filters containsObject:filter])
                {
                    NSInteger index = [self.filters indexOfObject:filter];
                    self.filterValue = filter;
                    [self handleMoviesSelectionAt:[NSIndexPath indexPathForRow:index inSection:0]];
                }
                else
                {
                    self.filterValue = @"true";
                    [self handleMoviesSelectionAt:[NSIndexPath indexPathForRow:self.filters.count - 1 inSection:0]];
                }
            }
            else
                [CommonModel showAlert:@"Error!" msg:msg];
        });
        
    }];
     
     
}

- (void)saveAppsSettings
{
    [SwiftFTUtils showHUDAddedTo:self.view withText:@"Updating..." animated:YES];
    NSString *url = [NSString stringWithFormat:@"%@/dashboard/settings/ios/contentfilters/apps/%ld", kBasUrlNew_mesh2, delegate.selectedDashboardChild.child_id];
    
    /*
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.filterValue , @"filter_value", nil];
    [JSONHTTPClient postJSONFromURLWithString:url
                                       params:params
                                   completion:^(id json, JSONModelError *err) {
                                       [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                       if([[json objectForKey:@"status"] integerValue] == 200)
                                       {
                                           [self loadAppsSettings];
                                       }
                                   }];
    
     */
    
    
    ///*
    
    //---NATIVE API CALLING---//
    
    NSString *paramstr = [NSString stringWithFormat:@"filter_value=%@", self.filterValue];
    
    [[ApiManager shared] mesh_postApiWithParamString:paramstr withApi:url withResponse:^(NSDictionary * _Nonnull json, NSInteger errorCode, NSString * _Nonnull message) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"Old Mesh load apps content filter ios api response = %@", json);
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if([[json objectForKey:@"status"] integerValue] == 200)
                [self loadAppsSettings];
        });
    }];
     
     //*/
    
}

- (void)saveTVShowsSettings
{
    [SwiftFTUtils showHUDAddedTo:self.view withText:@"Updating..." animated:YES];
    NSString *url = [NSString stringWithFormat:@"%@/dashboard/settings/ios/contentfilters/tvshows/%ld", kBasUrlNew_mesh2, delegate.selectedDashboardChild.child_id];
    
    /*
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.filterValue , @"filter_value", nil];
    [JSONHTTPClient postJSONFromURLWithString:url
                                       params:params
                                   completion:^(id json, JSONModelError *err) {
                                       [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                       if([[json objectForKey:@"status"] integerValue] == 200)
                                       {
                                           [self loadTVShowsSettings];
                                       }
                                   }];
     
     
     */
    
    //---NATIVE API CALLING---//
    
    NSString *paramstr = [NSString stringWithFormat:@"filter_value=%@", self.filterValue];
    
    [[ApiManager shared] mesh_postApiWithParamString:paramstr withApi:url withResponse:^(NSDictionary * _Nonnull json, NSInteger errorCode, NSString * _Nonnull message) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"Old Mesh load apps content filter ios api response = %@", json);
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if([[json objectForKey:@"status"] integerValue] == 200)
                [self loadTVShowsSettings];
        });
    }];
    
}

- (void)saveMoviesSettings
{
    [SwiftFTUtils showHUDAddedTo:self.view withText:@"Updating..." animated:YES];
    NSString *url = [NSString stringWithFormat:@"%@/dashboard/settings/ios/contentfilters/movies/%ld", kBasUrlNew_mesh2, delegate.selectedDashboardChild.child_id];
    
    /*
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.filterValue , @"filter_value", nil];
    [JSONHTTPClient postJSONFromURLWithString:url
                                       params:params
                                   completion:^(id json, JSONModelError *err) {
                                       [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                       if([[json objectForKey:@"status"] integerValue] == 200)
                                       {
                                           [self loadMoviesSettings];
                                       }
                                   }];
    
    */
    
    //---NATIVE API CALLING---//
    
    NSString *paramstr = [NSString stringWithFormat:@"filter_value=%@", self.filterValue];
    
    [[ApiManager shared] mesh_postApiWithParamString:paramstr withApi:url withResponse:^(NSDictionary * _Nonnull json, NSInteger errorCode, NSString * _Nonnull message) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"Old Mesh load apps content filter ios api response = %@", json);
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if([[json objectForKey:@"status"] integerValue] == 200)
                [self loadMoviesSettings];
        });
    }];
    
}
@end
