//
//  LimitScreenViewController.m
//  FamilyTime - Dashboard
//
//  Created by Muhammad Ajmal on 04/08/2016.
//  Copyright © 2016 SoraCode. All rights reserved.
//

#import "LimitScreenViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
//#import "JSONHTTPClient.h"

#import "LimitScreenCell.h"
#import "FTD.h"
#import "NEIServiceManager.h"
#import "FTUtils.h"
//#import <Google/Analytics.h>
#import "AddLimitScrenRule.h"
#import "DataModel.h"
#import "NSString+LockMustafa.h"
#import "FamilyTime-Swift.h"

AppDelegate *delegate;
UIRefreshControl *  refreshControl;


@interface LimitScreenViewController ()<LimitScreenCellDelegate>
@end

@implementation LimitScreenViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self loadRules];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setTitle:[@"Schedule Screen Time" myModification]];
    self.view.backgroundColor = [UIColor whiteColor];
    delegate = [AppDelegate appDelegate];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 64) style:UITableViewStylePlain];
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[LimitScreenCell class] forCellReuseIdentifier:@"LIMIT_SCREEN_CELL"];
    self.tableView.backgroundColor = RGBCOLOR(243, 243, 243, 1);
    
    if([SwiftFTUtils isDeviceiPhoneFamily])
        self.tableView.rowHeight = 170;
    else
        self.tableView.rowHeight = 170;
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    add = [[UIBarButtonItem alloc]initWithTitle:[@"Add" myModification] style:UIBarButtonItemStylePlain target:self action:@selector(addRule:)];
    [self.navigationItem setRightBarButtonItems:@[add]];
    
    [self addPullRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Places
- (void) editPlace
{
    [self.tableView setEditing:!self.tableView.isEditing];
}

- (void) loadRules
{
    [SwiftFTUtils showHUDAddedTo:self.view withText:[@"Loading..." myModification] animated:YES];
    //NSString *url = [NSString stringWithFormat:@"%@/v2/ftd/settings/ios/autoappblocker/list/%ld",kBasUrl,(long)delegate.selectedDashboardChild.child_id];
    NSString *url = [NSString stringWithFormat:@"%@/dashboard/settings/ios/lst/applock/rules/%ld",kBasUrlNew_mesh2,(long)delegate.selectedDashboardChild.child_id];
    
    /*
    
    [JSONHTTPClient getJSONFromURLWithString:url
                                       params:nil
                                   completion:^(id json, JSONModelError *err) {
                                       NSError *error;
                                       // read response code
                                       if([[json valueForKey:@"status_code"] integerValue] == 200)
                                       {
                                           NSLog(@"limit screen time json = %@",json);
                                           
                                           AllAccessControlRulesModel *rules = [[AllAccessControlRulesModel alloc] initWithDictionary:json error:&error];
                                           NSLog(@"%@",rules);
                                           self.dataSource = [NSMutableArray arrayWithArray:rules.response];
                                           [self viewDidDisappear:YES];
                                       }
                                       else
                                           [CommonModel showAlert:[@"Error!" myModification] msg:[json valueForKey:@"status_message"]];
                                       [self refreshTable];
                                       [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                   }];
    
     */
    
    
    //---NATIVE API CALLING---//
    
    [[ApiManager shared] mesh_getApiWithApi:url withResponse:^(NSDictionary * _Nonnull json, NSInteger errorCode, NSString * _Nonnull message) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"Old Mesh api Limit Screen Time IOS json = %@",json);
            
            NSError *error;
            // read response code
            if([[json valueForKey:@"status"] integerValue] == 200)
            {
                AllAccessControlRulesModel *rules = [[AllAccessControlRulesModel alloc] initWithDictionary:json error:&error];
                NSLog(@"%@",rules);
                self.dataSource = [NSMutableArray arrayWithArray:rules.data];
                NSLog(@"count %lu",self.dataSource.count);
                [self viewDidDisappear:YES];
            }
            else
                [CommonModel showAlert:[@"Error!" myModification] msg:[json valueForKey:@"message"]];
            
            [self refreshTable];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        });
    }];
        
}

- (void)viewDidDisappear:(BOOL)animated
{
    [refreshControl endRefreshing];
}

#pragma mark - QBRefreshControlDelegate
- (void) addPullRefresh
{
    refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(loadRules) forControlEvents:UIControlEventValueChanged];
    
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
    LimitScreenCell *cell = (LimitScreenCell *)[tableView dequeueReusableCellWithIdentifier:@"LIMIT_SCREEN_CELL"];
    
    if (cell == nil) {
        cell = (LimitScreenCell *)[[LimitScreenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ACCESS_CELL"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    AccessControlRuleModel *rule =  [self.dataSource objectAtIndex:indexPath.row];
    cell.rule = rule;
    cell.delegate = self;
    cell.indexPath = indexPath;
    [self viewDidDisappear:YES];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddLimitScrenRule *controller = [[AddLimitScrenRule alloc] init];
    controller.isNew = NO;
    AccessControlRuleModel *rule =  [self.dataSource objectAtIndex:indexPath.row];
    controller.rule = rule;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:NULL action:NULL];

//    self.navigationItem.backBarButtonItem = nil;
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)addRule:(id)sender
{
    AddLimitScrenRule *controller = [[AddLimitScrenRule alloc] init];
    controller.isNew = YES;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:NULL action:NULL];
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didRuleStatusChanged:(BOOL)isActive indexPath:(NSIndexPath *)indexPath
{
    AccessControlRuleModel *rule = [self.dataSource objectAtIndex:indexPath.row];
    [SwiftFTUtils showHUDAddedTo:self.view withText:[@"Updating..." myModification] animated:YES];
   // NSString *url = [NSString stringWithFormat:@"%@/dashboard/settings/ios/lst/applock/rules/%ld/%@",kBasUrl,(long)delegate.selectedDashboardChild.child_id,rule.id];
    
    AccessControlRuleModel *dict = [self.dataSource objectAtIndex:indexPath.row];
    dict.is_active = isActive ? @"1":@"0";
    [self.dataSource replaceObjectAtIndex:indexPath.row withObject:dict];

    NSString *url = [NSString stringWithFormat:@"%@/dashboard/settings/ios/lst/applock/rule/%ld/%@",kBasUrlNew_mesh2,(long)delegate.selectedDashboardChild.child_id,rule.id];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:isActive ? @"1" : @"0" forKey:@"is_active"];
    [params setObject:@"changeStatus" forKey:@"type"];
    
    NSError *error;
    NSData * jsonData  = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
    NSString *myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    
    /*
    
    [JSONHTTPClient patchJSONFromURLWithString:url
                                      bodyString:myString
                                  completion:^(id json, JSONModelError *err) {
                                      if([[json valueForKey:@"status_code"] integerValue] == 200)
                                      {
                                          NSLog(@"%@",json);
                                          [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                          [SwiftFTUtils showSyncSettingsPopupWith:self];
                                      }
                                      else
                                          [CommonModel showAlert:[@"Error!" myModification] msg:[json valueForKey:@"status_message"]];
                                      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                  }];
    
    */
    
    
    //---NATIVE API CALLING---//
    
    [[ApiManager shared] mesh_patch_withJson_ApiWithParamString:myString withApi:url withResponse:^(NSDictionary * _Nonnull json, NSInteger errorCode, NSString * _Nonnull message) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"Patch native api with json call response = %@", json);
            
            if([[json valueForKey:@"status"] integerValue] == 200)
            {
                NSLog(@"%@",json);
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [SwiftFTUtils showSyncSettingsPopupWith:self];
                [_tableView reloadData];
            }
            else
                [CommonModel showAlert:[@"Error!" myModification] msg:[json valueForKey:@"message"]];
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        });
        
    }];
    
    /*
    
    //---NATIVE API CALLING---//
    
    [[ApiManager shared] mesh_patchApiWithParamString:url withApi:myString withResponse:^(NSDictionary * _Nonnull json, NSInteger errorCode, NSString * _Nonnull message) {
      
        dispatch_async(dispatch_get_main_queue(), ^{
           
            NSLog(@"Patch native api call response = %@", json);
            
            if([[json valueForKey:@"status_code"] integerValue] == 200)
            {
                NSLog(@"%@",json);
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [SwiftFTUtils showSyncSettingsPopupWith:self];
            }
            else
                [CommonModel showAlert:[@"Error!" myModification] msg:[json valueForKey:@"status_message"]];
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        });
    }];
    
    */
}
- (void)didOptionButtonTapped:(NSIndexPath *)indexPath
{
    NSLog(@"tada");
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];



    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Edit" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

        AddLimitScrenRule *controller = [[AddLimitScrenRule alloc] init];
        controller.isNew = NO;
        AccessControlRuleModel *rule =  [self.dataSource objectAtIndex:indexPath.row];
        controller.rule = rule;
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:NULL action:NULL];

    //    self.navigationItem.backBarButtonItem = nil;
        [self.navigationController pushViewController:controller animated:YES];
        
    }]];
    
    AccessControlRuleModel *rule =  [self.dataSource objectAtIndex:indexPath.row];
    if (![rule.rule_name  isEqual: @"Bedtime"] && ![rule.rule_name  isEqual: @"Dinner Time"] && ![rule.rule_name  isEqual: @"Homework Time"]){
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

            // Distructive button tapped.
            self.ruleid = rule.id;
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete Rule" message:@"Do you want to delete rule?" preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                
                
            }]];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                [self deleteApi];
                
            }]];
            
            // Present action sheet.
            [self presentViewController:alert animated:YES completion:nil];

//            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"Delete Rule" message:@"Do you want to delete rule?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
//            //alertview.tag = sender.tag;
//            [alertview show];
            
            
        }]];

    }
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

        // Cancel button tappped.
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];

    // Present action sheet.
    [self presentViewController:actionSheet animated:YES completion:nil];
}
- (void)deleteApi
{
//    if(buttonIndex == 0)
//        return;
    
    [SwiftFTUtils showHUDAddedTo:self.view withText:@"Deleting..." animated:YES];
    //NSString *url = [NSString stringWithFormat:@"%@/v2/ftd/settings/ios/autoappblocker/rule/%ld/%@",kBasUrl,(long)delegate.selectedDashboardChild.child_id,self.rule.id];

    NSString *url = [NSString stringWithFormat:@"%@/dashboard/settings/ios/lst/applock/rule/%ld/%@",kBasUrlNew_mesh2,(long)delegate.selectedDashboardChild.child_id,self.ruleid];
    NSLog(@"%@", url);
    /*
     
    [JSONHTTPClient deleteJSONFromURLWithString:url
                                       params:nil
                                   completion:^(id json, JSONModelError *err) {
                                       //NSError *error;
                                       // read response code
                                       if([[json valueForKey:@"status_code"] integerValue] == 200)
                                       {
                                           NSLog(@"%@",json);
                                       }
                                       else
                                           [CommonModel showAlert:@"Error!" msg:[json valueForKey:@"status_message"]];
                                       [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                       [self.navigationController popViewControllerAnimated:YES];
                                   }];
    
     */
    
    //---NATIVE API CALLING---//
    
    [[ApiManager shared] deleteApiWithParams:@{} andUrl:url andController:self withResponse:^(NSString * _Nonnull message, NSInteger code){
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            NSLog(@"delete ios child rule native api response = %@", message);
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            if(code == 200)
            {
                NSLog(@"%ld", (long)code);
                [self loadRules];
            }
            else{
                [CommonModel showAlert:[@"Error!" myModification] msg:message];
            //    [self.navigationController popViewControllerAnimated:YES];
            }
            
        });
        
    }];
}
@end
