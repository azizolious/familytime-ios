//
//  TimeZonesViewController.m
//  FamilyTime - Dashboard
//
//  Created by Muhammad Ajmal on 30/05/2016.
//  Copyright © 2016 SoraCode. All rights reserved.
//

#import "TimeZonesViewController.h"
#import "FTUtils.h"
#import "AppDelegate.h"
//#import <Google/Analytics.h>
//#import "NSSt
#import "NSString+LockMustafa.h"


@interface TimeZonesViewController ()

@end

@implementation TimeZonesViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [@"Child Timezone" myModification];
    
    if(self.isFromPopup)
    {
        if(IS_IPHONE_4)
        {
            self.view.frame = CGRectMake(0.0f, 0.0f, 270.0f, 420.0f);
        }
        else if(IS_IPHONE_5)
        {
            self.view.frame = CGRectMake(0.0f, 0.0f, 270.0f, 420.0f);
        }
        else if(IS_IPHONE_6)
        {
            self.view.frame = CGRectMake(0.0f, 0.0f, 317.0f, 450.0f);
        }
        else if(IS_IPHONE_6_PLUS)
        {
            self.view.frame = CGRectMake(0.0f, 0.0f, 350.0f, 500.0f);
        }
        else if(IS_IPHONE_X)
        {
            self.view.frame = CGRectMake(0.0f, 0.0f, 350.0f, 500.0f);
        }
        else
        {
            self.view.frame = CGRectMake(0.0f, 0.0f, 525.0f, 715.0f);
        }
    }
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(handleDone:)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(handlecancel:)];
    
    if(self.isFromPopup)
    {
        self.view.backgroundColor = [UIColor whiteColor];
        self.tableView.backgroundColor = [UIColor whiteColor];
    }
    else
    {
        self.view.backgroundColor = RGBCOLOR(172, 206, 58, 1);
        self.tableView.backgroundColor = RGBCOLOR(172, 206, 58, 1);
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (void)handleDone:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        if([self.controllerDelegate respondsToSelector:@selector(didTimeZoneChangedTo:)])
            [self.controllerDelegate didTimeZoneChangedTo:self.selectedIndex];
    }];
}

- (void)handlecancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)setupUI
{
    if(IS_IPHONE_4)
    {
        self.tableView.rowHeight= 37.0f;
    }
    else if(IS_IPHONE_5)
    {
        self.tableView.rowHeight = 37.0f;
    }
    else if(IS_IPHONE_6)
    {
        self.tableView.rowHeight = 43.0f;
    }
    else if(IS_IPHONE_6_PLUS)
    {
        self.tableView.rowHeight = 47.0f;
    }
    else if(IS_IPHONE_X)
        {
        self.tableView.rowHeight = 47.0f;
        }
    else
    {
        self.tableView.rowHeight = 68.0f;
    }
    
    self.tableView.tintColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.timezones.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FILTER_CELL"];
    if(cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FILTER_CELL"];
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    if(self.isFromPopup)
        cell.textLabel.textColor = RGBCOLOR(83, 83, 83, 1);
    else
        cell.textLabel.textColor = [UIColor whiteColor];
    GMTTimezone *tz = (GMTTimezone *)[self.timezones objectAtIndex:indexPath.row];
    cell.textLabel.text = tz.strRep;
    
    if(self.isFromPopup)
    {
        if(self.selectedIndex == indexPath.row)
        {
            cell.backgroundColor = RGBCOLOR(22, 151, 191, 1);
            cell.contentView.backgroundColor = RGBCOLOR(22, 151, 191, 1);
            cell.textLabel.textColor = [UIColor whiteColor];
        }
        else
        {
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.textLabel.textColor = RGBCOLOR(83, 83, 83, 1);
        }
    }
    else
    {
        if(self.selectedIndex == indexPath.row)
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        else
            cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    
    if(IS_IPHONE_4)
    {
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    else if(IS_IPHONE_5)
    {
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    else if(IS_IPHONE_6)
    {
        cell.textLabel.font = [UIFont systemFontOfSize:16];
    }
    else if(IS_IPHONE_6_PLUS)
    {
        cell.textLabel.font = [UIFont systemFontOfSize:17];
    }
    else if(IS_IPHONE_X)
        {
        cell.textLabel.font = [UIFont systemFontOfSize:17];
        }
    else
    {
        cell.textLabel.font = [UIFont systemFontOfSize:19];
    }
    cell.tintColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [tableView  deselectRowAtIndexPath:indexPath animated:YES];
    self.selectedIndex = indexPath.row;
    [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    
//    if(self.isFromPopup)
//    {
//        [self dismissViewControllerAnimated:YES completion:^{
//            if([self.controllerDelegate respondsToSelector:@selector(didTimeZoneChangedTo:)])
//                [self.controllerDelegate didTimeZoneChangedTo:self.selectedIndex];
//        }];
//    }
}

@end
