//
//  ContentFilterViewController.m
//  FamilyTime - Dashboard
//
//  Created by Muhammad Ajmal on 31/05/2016.
//  Copyright © 2016 SoraCode. All rights reserved.
//

#import "ContentFilterViewController.h"
#import "MBProgressHUD.h"
//#import "JSONHTTPClient.h"
#import "AppDelegate.h"
#import "PlacesCell.h"
#import "FTD.h"
#import "FTUtils.h"
//#import <Google/Analytics.h>
#import "LeftSidesTableViewCell.h"
#import "ContentFilterDetailsViewController.h"
#import "NSString+LockMustafa.h"

#import "FamilyTime-Swift.h"


AppDelegate *delegate;
@interface ContentFilterViewController ()
@property (nonatomic, strong) NSArray *options;
@property (nonatomic, strong) NSArray *images;

@property (nonatomic, assign) BOOL explicitContentiTunes;
@property (nonatomic, assign) BOOL explicitContentiBooks;
@property (nonatomic, assign) BOOL itunesLoaded;
@property (nonatomic, assign) BOOL iBooksLoaded;
@end

@implementation ContentFilterViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    
    [SwiftFTUtils showHUDAddedTo:self.view withText:[@"Loading..." myModification] animated:YES];
    [self loadExplicitItunesSettings];
    [self loadiBooksSettings];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    delegate = [AppDelegate appDelegate];
    [self.tableView registerNib:[UINib nibWithNibName:@"LeftSidesTableViewCell" bundle:nil] forCellReuseIdentifier:@"LeftSidesCell"];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        self.tableView.rowHeight = 75;
    else
        self.tableView.rowHeight = 75;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.navigationItem setTitle:[@"Content Filters" myModification]];
    
    self.options = @[@"Films", @"TV Programes", @"Apps"];
    self.images = @[@"ic_films2", @"ic_tv2", @"ic_apps2"];
    
    self.explicitContentiTunes = NO;
    self.explicitContentiBooks = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return 3;
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return 60;
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 60)];
        label.backgroundColor = [UIColor groupTableViewBackgroundColor];
        label.textColor = RGBCOLOR(138, 138, 138, 1);
        label.font = [UIFont fontWithName:@"OpenSans" size:16];
        label.text =[NSString stringWithFormat:@"    %@",[@"ALLOWED CONTENT" myModification]];
        return label;
    }
    UIView *tview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 15)];
    tview.backgroundColor = [UIColor clearColor];
    return tview;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        SettingTableViewCell *cell = (SettingTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"LeftSidesCell"];
        
        if (cell == nil) {
            cell = (SettingTableViewCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LeftSidesCell"];
        }
        cell.cellLabel.text = self.options[indexPath.row];
        cell.cellImage.image = [UIImage imageNamed:self.images[indexPath.row]];
        [cell.cellSwitch setHidden:YES];
        return cell;
    }
    else
    {
        SettingTableViewCell *cell = (SettingTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"LeftSidesCell"];
        
        if (cell == nil) {
            cell = (SettingTableViewCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LeftSidesCell"];
        }
        cell.cellLabel.text = (indexPath.row == 0) ? @"Explicit Content in iTunes" : @"Erotica in iBooks";
        cell.cellImage.image = (indexPath.row == 0) ? [UIImage imageNamed:@"iTunestore"] : [UIImage imageNamed:@"ibook"];
        [cell.cellSwitch setHidden:NO];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(indexPath.row == 0)
        {
            [cell.cellSwitch setOn:self.explicitContentiTunes];
        }
        else
        {
            [cell.cellSwitch setOn:self.explicitContentiBooks];
        }
        
        cell.onSwitchChange= ^(SettingTableViewCell *cellAffected){
            if(indexPath.section == 1 && indexPath.row == 0)
            {
                self.explicitContentiTunes = cellAffected.cellSwitch.isOn;
                [self saveExplicitItunesSettings];
            }
            else if(indexPath.section == 1 && indexPath.row == 1)
            {
                self.explicitContentiBooks = cellAffected.cellSwitch.isOn;
                [self saveiBooksSettings];
            }
        };
        
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        SettingTableViewCell *tcell = (SettingTableViewCell *)cell;
        [tcell showAccessoryview];
    }
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0)
    {
        ContentFilterDetailsViewController *controller = [[ContentFilterDetailsViewController alloc] initWithStyle:UITableViewStylePlain];
        controller.detailsType = (ContentFilterDetailsType)indexPath.row;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)loadExplicitItunesSettings
{
    NSString *url = [NSString stringWithFormat:@"%@/dashboard/settings/ios/contentfilters/explicitcontent/%ld", kBasUrlNew_mesh2, (long)delegate.selectedDashboardChild.child_id];
    
    /*
    
    [JSONHTTPClient getJSONFromURLWithString:url
                                       params:nil
                                   completion:^(id json, JSONModelError *err) {
                                       self.itunesLoaded = YES;
                                       if(self.itunesLoaded && self.iBooksLoaded)
                                           [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                       NSString *msg = [json valueForKey:@"status_message"] == nil ? [kErrorGeneral myModification]: [json valueForKey:@"status_message"];
                                       if([[json objectForKey:@"status_code"] integerValue] == 200)
                                       {
                                           NSString *status = [[json objectForKey:@"response"] objectForKey:@"value"];
                                           self.explicitContentiTunes = ([status isEqualToString:@"true"]) ? YES : NO;
                                           [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
                                       }
                                       else
                                           [CommonModel showAlert:@"Error!" msg:msg];
                                   }];
     
     */
    
    //---NATIVE API CALLING---//
    
    [[ApiManager shared] mesh2_commonGetApiWithVC:self andUrl:url withResponse:^(id  _Nonnull json) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"MESH native api get response = %@", json);
            
            self.itunesLoaded = YES;
            
            if(self.itunesLoaded && self.iBooksLoaded)
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            NSString *msg = [json valueForKey:@"message"] == nil ? [kErrorGeneral myModification]: [json valueForKey:@"message"];
            
            if([[json objectForKey:@"status"] integerValue] == 200)
            {
                NSString *status = [[json objectForKey:@"data"] objectForKey:@"value"];
                self.explicitContentiTunes = ([status isEqualToString:@"true"]) ? YES : NO;
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
            }
            else
                [CommonModel showAlert:@"Error!" msg:msg];
            
        });
        
    }];
}

- (void)loadiBooksSettings
{
    NSString *url = [NSString stringWithFormat:@"%@/dashboard/settings/ios/contentfilters/bookstoreerotica/%ld", kBasUrlNew_mesh2, (long)delegate.selectedDashboardChild.child_id];
    
    /*
    
    [JSONHTTPClient getJSONFromURLWithString:url
                                      params:nil
                                  completion:^(id json, JSONModelError *err) {
                                      self.iBooksLoaded = YES;
                                      if(self.itunesLoaded && self.iBooksLoaded)
                                          [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                      NSString *msg = [json valueForKey:@"status_message"] == nil ? [kErrorGeneral myModification] : [json valueForKey:@"status_message"];
                                      if([[json objectForKey:@"status_code"] integerValue] == 200)
                                      {
                                          NSString *status = [[json objectForKey:@"response"] objectForKey:@"value"];
                                          self.explicitContentiBooks = ([status isEqualToString:@"true"]) ? YES : NO;
                                          [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
                                      }
                                      else
                                          [CommonModel showAlert:@"Error!" msg:msg];
                                  }];
     
     */
    
    //---NATIVE API CALLING---//
    
    [[ApiManager shared] mesh_getApiWithApi:url withResponse:^(NSDictionary * _Nonnull json, NSInteger errorCode, NSString * _Nonnull message) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"MESH native api get response = %@", json);
            
            self.iBooksLoaded = YES;
            
            if(self.itunesLoaded && self.iBooksLoaded)
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            NSString *msg = [json valueForKey:@"message"] == nil ? [kErrorGeneral myModification] : [json valueForKey:@"message"];
            
            if([[json objectForKey:@"status"] integerValue] == 200)
            {
                NSString *status = [[json objectForKey:@"data"] objectForKey:@"value"];
                self.explicitContentiBooks = ([status isEqualToString:@"true"]) ? YES : NO;
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
            }
            else
                [CommonModel showAlert:@"Error!" msg:msg];
            
        });
        
    }];
    
}

- (void)saveExplicitItunesSettings
{
    [SwiftFTUtils showHUDAddedTo:self.view withText:@"Updating..." animated:YES];
    NSString *url = [NSString stringWithFormat:@"%@/dashboard/settings/ios/contentfilters/explicitcontent/%ld", kBasUrlNew_mesh2, (long)delegate.selectedDashboardChild.child_id];
    NSString *parameter = (self.explicitContentiTunes) ? @"true" : @"false";
    
    /*
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:parameter , @"filter_value", nil];
    
    
    [JSONHTTPClient postJSONFromURLWithString:url
                                      params:params
                                  completion:^(id json, JSONModelError *err) {
                                       [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                      if([[json objectForKey:@"status_code"] integerValue] == 200)
                                      {
                                          [self loadExplicitItunesSettings];
                                      }
                                  }];
    
    */
     
    //---NATIVE API CALLING---//
    
//    NSString *paramStr = [NSString stringWithFormat:@"filter_value=%@", parameter];
//
//    [[ApiManager shared] mesh_postApiWithParamString:paramStr withApi:url withResponse:^(NSDictionary * _Nonnull json, NSInteger errorCode, NSString * _Nonnull message) {
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//            NSLog(@"Old Mesh content filter api json response = %@", json);
//
//            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//            if([[json objectForKey:@"status_code"] integerValue] == 200)
//                [self loadExplicitItunesSettings];
//        });
//
//    }];
    
    [[ApiManager shared] mesh2_commonGetApiWithVC:self andUrl:url withResponse:^(id  _Nonnull json) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"Old Mesh content filter api json response = %@", json);
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if([[json objectForKey:@"status"] integerValue] == 200)
                [self loadExplicitItunesSettings];
        });
        
    }];
   
}

- (void)saveiBooksSettings
{
    [SwiftFTUtils showHUDAddedTo:self.view withText:@"Updating..." animated:YES];
    NSString *url = [NSString stringWithFormat:@"%@/dashboard/settings/ios/contentfilters/bookstoreerotica/%ld", kBasUrlNew_mesh2, (long)delegate.selectedDashboardChild.child_id];
    NSString *parameter = (self.explicitContentiBooks) ? @"true" : @"false";
    
    /*
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:parameter , @"filter_value", nil];
    [JSONHTTPClient postJSONFromURLWithString:url
                                       params:params
                                   completion:^(id json, JSONModelError *err) {
                                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                       if([[json objectForKey:@"status_code"] integerValue] == 200)
                                       {
                                           [self loadiBooksSettings];
                                       }
                                   }];
    
     */
    
    //---NATIVE API CALLING---//
    
    NSString *paramStr = [NSString stringWithFormat:@"filter_value=%@", parameter];
    
    [[ApiManager shared] mesh_postApiWithParamString:paramStr withApi:url withResponse:^(NSDictionary * _Nonnull json, NSInteger errorCode, NSString * _Nonnull message) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"Old Mesh content filter api json response = %@", json);
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if([[json objectForKey:@"status"] integerValue] == 200)
                [self loadExplicitItunesSettings];
        });
        
    }];
    
}
@end
