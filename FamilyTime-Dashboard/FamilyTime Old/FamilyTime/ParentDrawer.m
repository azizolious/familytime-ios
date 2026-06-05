//
//  ParentDrawer.m
//  FamilyTime
//
//  Created by Sora Code on 3/2/15.
//  Copyright (c) 2015 SoraCode. All rights reserved.
//

#import "ParentDrawer.h"
#import "AppDelegate.h"
#import "FTUtils.h"
#import "DataModel.h"
//#import <Google/Analytics.h>
#import <ZendeskCoreSDK/ZendeskCoreSDK.h>
#import "TextMessagesViewController.h"
#import "ChangePasswordViewController1.h"
#import "iOSBrowserHistoryViewController.h"
#import "InviteCoparentViewController.h"
#import "NSString+LockMustafa.h"
#import "ViewController.h"

#import "FamilyTime-Swift.h"

@class CoreDataUtility;

//---REMOVE FACEBOOK DUE TO MDM---//
//#import <FBSDKCoreKit/FBSDKCoreKit.h>

#define RGBCOLOR(R,G,B, A) [UIColor colorWithRed:R/255.2f green:G/255.2f blue:B/255.2f alpha:A]

NSString *drawer_package_id = @"";
NSString *drawer_package_name = @"";
NSString *drawer_device = @"";
AppDelegate *delegate;
@interface ParentDrawer ()<UIAlertViewDelegate,GIDSignInUIDelegate>

@end

@implementation ParentDrawer

-(void)viewWillAppear:(BOOL)animated
{
    
    
    NSLog(@"Side menu here =");
    
    
    /*
     
     NSString * storyboardName = @"MyStory";
     UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
     UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"IDENTIFIER_OF_YOUR_VIEWCONTROLLER"];
     
     */
    
    
    
    delegate = [AppDelegate appDelegate];
    [super viewWillAppear:animated];
    [self reloadView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
    selector:@selector(showMainMenu:)
        name:@"updateDrawer" object:nil];
    
   
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"Parent Drawer"];
    [self.tableView setRowHeight:55];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setSeparatorColor:KSetBG(187, 186, 186, 1)];
    
    
    self.parentImage.layer.borderColor  = [[UIColor lightGrayColor] CGColor];
    self.parentImage.layer.borderWidth  = 1.0;
    self.parentImage.layer.cornerRadius = self.parentImage.frame.size.width / 2;
    
    NSInteger child_id = delegate.selectedDashboardChild.child_id;
    int convertedChild_id = (int) child_id;
    
    drawer_package_id =  [CoreDataUtility fetchPackageIdForChild_id:(convertedChild_id)];
    drawer_package_name = [CoreDataUtility fetchPackageNameForChild_id:(convertedChild_id)];
    drawer_device =  [CoreDataUtility fetchPackageDeviceForChild_id:(convertedChild_id)];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)btnPressedYes:(id)sender
{
    [delegate.userDefault setObject:nil forKey:@"user"];
    [[AppDelegate appDelegate] setNavigationbarAppearence:YES cont:self];
    [delegate setupDrawer:2];
    [self.alertSubView removeFromSuperview];
    [self.btnYes setTitleColor:[UIColor colorWithRed:29/255.0 green:166/255.0 blue:208/255.0 alpha:1.0] forState:UIControlStateSelected];
  
}



- (void)showMainMenu:(NSNotification *)note {
    //NSLog(@"Received Notification - Someone seems to have logged in");
    [self reloadView];
}

- (IBAction)btnPressedNo:(id)sender
{
    [self.btnNo setTitleColor:[UIColor colorWithRed:29/255.0 green:166/255.0 blue:208/255.0 alpha:1.0] forState:UIControlStateSelected];
    self.alertSubView.hidden=YES;
}

- (void) reloadView
{
    self.parentName.text = delegate.parent.name;
    if([self.contName isEqualToString:@"Reports"])
    {
        NSLog(@"Version ==%@",delegate.selectedDashboardChild.deviceInfo.device_os);
        
        NSLog(@"Here ==%@",delegate.selectedDashboardChild.device);

        //        if([delegate.selectedDashboardChild.device isEqualToString:@"iphone"])
        
        if(delegate.selectedDashboardChild.plateform_id == 2)//---IOS CHILD---//
        {
            

            
            //---AS MDM FUNCTIONALITIES REMOVED, SO ONLY SHOW THIS---//
//            //---REMOVE INSTALLED APPS DUE TO MDM REMOVEMENT---//
//            self.dataSource = [[NSArray alloc] initWithObjects:NSLocalizedString(@"MyKids", nil),NSLocalizedString(@"Location History", nil),NSLocalizedString(@"Places History", nil),NSLocalizedString(@"Contacts", nil),NSLocalizedString(@"Settings", nil),NSLocalizedString(@"Device Info", nil),NSLocalizedString(@"Logout", nil), nil];
            
            
            self.dataSource = [[NSArray alloc] initWithObjects:NSLocalizedString(@"MyKids", nil),NSLocalizedString(@"Location History", nil),NSLocalizedString(@"Places History", nil),NSLocalizedString(@"Contacts", nil),NSLocalizedString(@"Installed Apps", nil),NSLocalizedString(@"Settings", nil),NSLocalizedString(@"Device Info", nil),NSLocalizedString(@"Logout", nil), nil];
            
            //---AS MDM FUNCTIONALITIES REMOVED, SO ONLY SHOW THIS---//
            //---REMOVE INSTALLED APPS DUE TO MDM REMOVEMENT---//
            
            self.dataSourceNew = [[NSArray alloc] initWithObjects:@"MyKids",@"Location History",@"Places History",@"Contacts",@"Installed Apps",@"Settings",@"Device Info",@"Logout", nil];
        }
        else
        {
            //---ANDROID CHILD---//
            NSString *android_device_os = delegate.selectedDashboardChild.deviceInfo.device_os;
            NSLog(@"android_device_os = %@", android_device_os);
            
//            strnew = [strnew substringToIndex:2];
            
            if(android_device_os == NULL || [android_device_os isEqualToString:@""])
            {
                [self populateData];
            }
            
            else if(android_device_os.length > 2)
            {
                if ([[android_device_os substringToIndex:2] doubleValue] < 6.0){
                    [self populateForAndroidLowVersion];
                }
                else{
                    [self populateData];
                }
            }
        }
        
        self.parentName.text = delegate.selectedDashboardChild.name;
        
//        @"avatar_boy1" : @"avatar_girl1"
        
        if([[delegate.selectedDashboardChild.gender lowercaseString] isEqualToString:@"male"])
            self.parentImage.image = [UIImage imageNamed:@"avatar_boy1"];
        else
            self.parentImage.image = [UIImage imageNamed:@"avatar_girl1"];
    }
    else
    {
        NSString *gender;
        
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"userRelation"] == nil){
            
            gender = delegate.parent.relationship;
            
        }else{
            
            gender = [[NSUserDefaults standardUserDefaults] objectForKey:@"userRelation"];
        }
        //delegate.parent.relationship = [[NSUserDefaults standardUserDefaults] objectForKey:@"userRelation"];
        
        NSLog(@"Relation==%@",gender);
        if ([gender isEqualToString:NSLocalizedString(@"Mother",nil)])
        {
            self.parentImage.image = [UIImage imageNamed:@"parent_profile_f"];
        }
        else
        {
            //       self.parentImage.image = [UIImage imageNamed:@"in_parent_m"];
            self.parentImage.image = [UIImage imageNamed:@"parent_profile_m"];
            //         self.parentImage.image = [[UIImage imageNamed:@"avater"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            //            [self.parentImage setTintColor:[UIColor redColor]];
        }
        
        //---SANA CHANGE---//
        
//        if( [[NSUserDefaults standardUserDefaults]objectForKey:@"ParentRelationship"]==nil)
//        {
//        }
//        else
//        {
//            if([[[NSUserDefaults standardUserDefaults]objectForKey:@"ParentRelationship"] isEqualToString:@"Mother"])
//            {
//                //           self.parentImage.image = [UIImage imageNamed:@"avater"];
//                self.parentImage.image = [UIImage imageNamed:@"parent_profile_f"];//m for mother
//            }
//            else
//            {
//                //           self.parentImage.image = [UIImage imageNamed:@"avater_m"];
//                self.parentImage.image = [UIImage imageNamed:@"parent_profile_m"];
//            }
//        }
        
        
        if([delegate.parent.type isEqualToString:@"Super"])
        {
            self.dataSource = [[NSArray alloc] initWithObjects:NSLocalizedString(@"MyKids", nil),NSLocalizedString(@"Notifications", nil),NSLocalizedString(@"FamilyLocator", nil),NSLocalizedString(@"Parents", nil),NSLocalizedString(@"Account",nil), NSLocalizedString(@"Help", nil), NSLocalizedString(@"Terms of Use", nil), NSLocalizedString(@"Privacy Policy", nil), NSLocalizedString(@"Data Collection and Use", nil), NSLocalizedString(@"Logout", nil), nil];
            self.dataSourceNew = [[NSArray alloc] initWithObjects:@"MyKids",@"Notifications",@"FamilyLocator",@"Parents",@"Account", @"Help", @"Terms of Use", @"Privacy Policy", @"Data Collection and Use", @"Logout", nil];
        }
        else
        {
            self.dataSource = [[NSArray alloc] initWithObjects:NSLocalizedString(@"MyKids", nil),NSLocalizedString(@"FamilyLocator", nil),NSLocalizedString(@"Account",nil),  NSLocalizedString(@"Help", nil), NSLocalizedString(@"Terms of Use", nil), NSLocalizedString(@"Privacy Policy", nil), NSLocalizedString(@"Data Collection and Use", nil), NSLocalizedString(@"Logout", nil), nil];
            self.dataSourceNew = [[NSArray alloc] initWithObjects:@"MyKids",@"FamilyLocator",@"Account", @"Help", @"Terms of Use", @"Privacy Policy", @"Data Collection and Use", @"Logout", nil];
        }
    }
    
    [self.tableView reloadData];
}

//---SANA OPTIMIZATION---//---REDUNDANCY REMOVED---//
-(void) populateData{
    self.dataSource = [[NSArray alloc] initWithObjects:NSLocalizedString(@"MyKids", nil),NSLocalizedString(@"Location History", nil),NSLocalizedString(@"Places History", nil),NSLocalizedString(@"Text Messages", nil),NSLocalizedString(@"Call History", nil),NSLocalizedString(@"Contacts", nil),NSLocalizedString(@"Installed Apps", nil),NSLocalizedString(@"App Usage", nil),NSLocalizedString(@"Settings", nil),NSLocalizedString(@"Device Info", nil),NSLocalizedString(@"Logout", nil), nil];
    
    self.dataSourceNew = [[NSArray alloc] initWithObjects:@"MyKids" ,@"Location History",@"Places History" ,@"Text Messages",@"Call History",@"Contacts" ,@"Installed Apps" ,@"App Usage",@"Settings" ,@"Device Info" ,@"Logout", nil];
}

-(void)populateForAndroidLowVersion{
    self.dataSource = [[NSArray alloc] initWithObjects:NSLocalizedString(@"MyKids", nil),NSLocalizedString(@"Location History", nil),NSLocalizedString(@"Places History", nil),NSLocalizedString(@"Text Messages", nil),NSLocalizedString(@"Call History", nil),NSLocalizedString(@"Contacts", nil),NSLocalizedString(@"Bookmarks", nil),NSLocalizedString(@"Web History", nil),NSLocalizedString(@"Installed Apps", nil),NSLocalizedString(@"App Usage", nil),NSLocalizedString(@"Settings", nil),NSLocalizedString(@"Device Info", nil),NSLocalizedString(@"Logout", nil), nil];
    
    self.dataSourceNew = [[NSArray alloc] initWithObjects:@"MyKids",@"Location History",@"Places History" ,@"Text Messages" ,@"Call History",@"Contacts" ,@"Bookmarks" ,@"Web History",@"Installed Apps" ,@"App Usage" ,@"Settings",@"Device Info" ,@"Logout", nil];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"callCell"];
        
    }
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [self.dataSource objectAtIndex:indexPath.row];
    cell.textLabel.textColor = RGBCOLOR(33, 33, 33, 1);
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(10,7.5f,40,40)];
    
    NSString *strnew1 = self.dataSourceNew[indexPath.row];
    
    [img setImage:[UIImage imageNamed:[NSString stringWithFormat:@"pdb_%@",strnew1]]];
    
    
    if([self.dataSource[indexPath.row] isEqualToString:NSLocalizedString(@"FamilyLocator", nil)])
    {
        [img setImage:[UIImage imageNamed:@"ic_familymap"]];
    }
    if([self.dataSource[indexPath.row] isEqualToString:NSLocalizedString(@"Notifications", nil)])
    {
        [img setImage:[UIImage imageNamed:@"ic_notification"]];
    }
    else if([self.dataSource[indexPath.row] isEqualToString:NSLocalizedString(@"App Usage", nil)])
    {
        [img setImage:[UIImage imageNamed:@"ic_app_usage"]];
    }
    //---DEPRICATED---//
//    else if([self.dataSource[indexPath.row] isEqualToString:NSLocalizedString(@"Invite Parent", nil)])
//    {
//        [img setImage:[UIImage imageNamed:@"ic_invite"]];
//    }
    else if([self.dataSource[indexPath.row] isEqualToString:NSLocalizedString(@"Account", nil)])
    {
        [img setImage:[UIImage imageNamed:@"pdb_Settings"]];
    }
    else if([self.dataSource[indexPath.row] isEqualToString:NSLocalizedString(@"Parents", nil)])
    {
        [img setImage:[UIImage imageNamed:@"ic_parents"]];
    }
    
    else if([self.dataSource[indexPath.row] isEqualToString:NSLocalizedString(@"Terms of Use", nil)])
    {
        [img setImage:[UIImage imageNamed:@"ic_terms_of_use"]];
    }
    else if([self.dataSource[indexPath.row] isEqualToString:NSLocalizedString(@"Privacy Policy", nil)])
    {
        [img setImage:[UIImage imageNamed:@"ic_privacy_policy"]];
    }
    else if([self.dataSource[indexPath.row] isEqualToString:NSLocalizedString(@"Data Collection and Use", nil)])
    {
        [img setImage:[UIImage imageNamed:@"ic_data_collection"]];
    }
    
    //ic_profile
    
    //    Invite Coparent
    
    [cell.contentView addSubview:img];
    cell.textLabel.adjustsFontSizeToFitWidth=YES;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *label = [self.dataSource objectAtIndex:indexPath.row];
    
    if([label isEqualToString:NSLocalizedString(@"Account", nil)])
    {
        NSString * storyboardName = @"MyStoryboard";
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: [NSBundle mainBundle]];
        
        self.parentProfile  = [storyboard instantiateViewControllerWithIdentifier:@"ParentProfileViewController"];
        delegate.centerNavController = [[UINavigationController alloc] initWithRootViewController:self.parentProfile];
        delegate.jasidePanel.centerPanel = delegate.centerNavController;
        [delegate.jasidePanel toggleLeftPanel:nil];
    }
    else if([label isEqualToString:NSLocalizedString(@"Notifications", nil)])
    {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Dashboard" bundle:nil];
        TermsVC *vc = [sb instantiateViewControllerWithIdentifier:@"NotificationViewController"];
        
        delegate.centerNavController = [[UINavigationController alloc] initWithRootViewController:vc];
        delegate.jasidePanel.centerPanel = delegate.centerNavController;
        [delegate.jasidePanel toggleLeftPanel:nil];
    }
    else if([label isEqualToString:NSLocalizedString(@"MyKids", nil)])
    {
        self.contName = @"Drawer";
        [self reloadView];
        [delegate setupDrawer:0];
        [delegate.jasidePanel toggleLeftPanel:nil];
    }
    
    else if([label isEqualToString:NSLocalizedString(@"FamilyLocator", nil)])
    {
        if( [[NSUserDefaults standardUserDefaults]boolForKey:@"familymapEnable"]==YES)
        {
            SwiftFamilyMapViewController *vc = [[SwiftFamilyMapViewController alloc] initWithNibName:@"FamilyMapViewController" bundle:nil];
            delegate.centerNavController = [[UINavigationController alloc] initWithRootViewController:vc];
            delegate.jasidePanel.centerPanel = delegate.centerNavController;
            [delegate.jasidePanel toggleLeftPanel:nil];
        }
        else
        {
            [SwiftFTUtils showActivateForfamilyMap:self];
        }
    }
    
    else if([label isEqualToString:NSLocalizedString(@"Terms of Use", nil)])
    {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Dashboard" bundle:nil];
        TermsVC *vc = [sb instantiateViewControllerWithIdentifier:@"TermsVC"];
        
        vc.isPrivacyPolicy = NO;
        
        delegate.centerNavController = [[UINavigationController alloc] initWithRootViewController:vc];
        delegate.jasidePanel.centerPanel = delegate.centerNavController;
        [delegate.jasidePanel toggleLeftPanel:nil];
    }
    
    else if([label isEqualToString:NSLocalizedString(@"Privacy Policy", nil)])
    {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Dashboard" bundle:nil];
        TermsVC *vc = [sb instantiateViewControllerWithIdentifier:@"TermsVC"];
        
        vc.isPrivacyPolicy = YES;
        
        delegate.centerNavController = [[UINavigationController alloc] initWithRootViewController:vc];
        delegate.jasidePanel.centerPanel = delegate.centerNavController;
        [delegate.jasidePanel toggleLeftPanel:nil];
        
    }
    
    else if([label isEqualToString:NSLocalizedString(@"Data Collection and Use", nil)])
    {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Dashboard" bundle:nil];
        DataUseVC *vc = [sb instantiateViewControllerWithIdentifier:@"DataUseVC"];
        delegate.centerNavController = [[UINavigationController alloc] initWithRootViewController:vc];
        delegate.jasidePanel.centerPanel = delegate.centerNavController;
        [delegate.jasidePanel toggleLeftPanel:nil];
        
    }
    else if([label isEqualToString:NSLocalizedString(@"Help", nil)])
    {
        
        NSString * storyboardName = @"MyStoryboard";
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: [NSBundle mainBundle]];
        
        self.helpViewController  = [storyboard instantiateViewControllerWithIdentifier:@"HelpViewController"];
        delegate.centerNavController = [[UINavigationController alloc] initWithRootViewController:self.helpViewController];
        delegate.jasidePanel.centerPanel = delegate.centerNavController;
        [delegate.jasidePanel toggleLeftPanel:nil];
                
    }
    else if ([label isEqualToString:NSLocalizedString(@"Change Password", nil)])
    {
        ChangePasswordViewController1 *vc = [[ChangePasswordViewController1 alloc] initWithNibName:@"ChangePasswordViewController" bundle:[NSBundle mainBundle]];
        delegate.centerNavController = [[UINavigationController alloc] initWithRootViewController:vc];
        delegate.jasidePanel.centerPanel = delegate.centerNavController;
        [delegate.jasidePanel toggleLeftPanel:nil];
    }
    
    //---DEPRICATED---//
    
//    else if ([label isEqualToString:NSLocalizedString(@"Invite Parent", nil)])
//    {
//        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//        {
//            InviteCoparentViewController *vc = [[InviteCoparentViewController alloc] initWithNibName:@"inviteViewControllerIPAD" bundle:[NSBundle mainBundle]];
//            delegate.centerNavController = [[UINavigationController alloc] initWithRootViewController:vc];
//            delegate.jasidePanel.centerPanel = delegate.centerNavController;
//            [delegate.jasidePanel toggleLeftPanel:nil];
//        }
//        else
//        {
//            InviteCoparentViewController *vc = [[InviteCoparentViewController alloc] initWithNibName:@"inviteViewController" bundle:[NSBundle mainBundle]];
//            delegate.centerNavController = [[UINavigationController alloc] initWithRootViewController:vc];
//            delegate.jasidePanel.centerPanel = delegate.centerNavController;
//            [delegate.jasidePanel toggleLeftPanel:nil];
//        }
//    }
    
    else  if([label isEqualToString:NSLocalizedString(@"Parents", nil)])
    {
        NSString * storyboardName = @"MyStoryboard";
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: [NSBundle mainBundle]];
        
        self.parentVCAll  = [storyboard instantiateViewControllerWithIdentifier:@"ParentsViewControllerAll"];
        delegate.centerNavController = [[UINavigationController alloc] initWithRootViewController:self.parentVCAll];
        delegate.jasidePanel.centerPanel = delegate.centerNavController;
        [delegate.jasidePanel toggleLeftPanel:nil];
    }
    
    else if([label isEqualToString:NSLocalizedString(@"Logout", nil)])
    {
        [[[UIAlertView alloc] initWithTitle:[@"Logout" myModification] message:[@"Do you wish to Logout?" myModification] delegate:self cancelButtonTitle:[@"No" myModification] otherButtonTitles:[@"Logout" myModification], nil] show];
    }
    else {
        
        if([delegate.selectedDashboardChild.device isEqualToString:@"iphone"] &&
           ([label isEqualToString:@"Browser History"]
            || [label isEqualToString:@"Browser Bookmarks"]
            || [label isEqualToString:@"Call History"]))
            return;
        
        else if([label isEqualToString:NSLocalizedString(@"Location History", nil)])
        {
            
           // DashboardChildPackageFeature *feature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"geolocation"];
            
            if ([drawer_package_id isEqualToString:@"1"]) {
                UIStoryboard *sb    = [UIStoryboard storyboardWithName:@"Dashboard" bundle:nil];
                PremiumPopupVC *vc  = [sb instantiateViewControllerWithIdentifier:@"PremiumPopupVC"];
                vc.titleString      = @"Location History";
                vc.shouldHideTitle  = YES;
                delegate.centerNavController = [[UINavigationController alloc] initWithRootViewController:vc];
            }
            else{
                
                if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                {
                    self.locCont = [[LocHistoryViewController alloc] initWithNibName:@"LocHistoryViewController~ipad" bundle:nil];
                    delegate.centerNavController = [[UINavigationController alloc] initWithRootViewController:self.locCont];
                }
                else
                {
                    self.locCont = [[LocHistoryViewController alloc] initWithNibName:@"LocHistoryViewController" bundle:nil];
                    delegate.centerNavController = [[UINavigationController alloc] initWithRootViewController:self.locCont];
                }
            }
        }
        else if([label isEqualToString:NSLocalizedString(@"Contacts", nil)])
        {
            
            //DashboardChildPackageFeature *feature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"contact"];

            if ([drawer_package_id isEqualToString:@"1"]) {
                UIStoryboard *sb    = [UIStoryboard storyboardWithName:@"Dashboard" bundle:nil];
                PremiumPopupVC *vc  = [sb instantiateViewControllerWithIdentifier:@"PremiumPopupVC"];
                vc.titleString      = @"Contacts";
                vc.shouldHideTitle  = YES;
                delegate.centerNavController = [[UINavigationController alloc] initWithRootViewController:vc];
            }
            else{
                self.contactsCont = [[ContactViewController alloc] initWithNibName:@"ContactViewController" bundle:nil];
                delegate.centerNavController = [[UINavigationController alloc] initWithRootViewController:self.contactsCont];
            }
            
//            self.contactsCont = [[ContactViewController alloc] initWithNibName:@"ContactViewController" bundle:nil];
//            delegate.centerNavController = [[UINavigationController alloc] initWithRootViewController:self.contactsCont];
        }
        else if([label isEqualToString:NSLocalizedString(@"Web History", nil)])
        {
            //DashboardChildPackageFeature *feature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"browsinghistory"];
            if ([drawer_package_id isEqualToString:@"1"]) {
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Dashboard" bundle:nil];
                PremiumPopupVC *vc = [sb instantiateViewControllerWithIdentifier:@"PremiumPopupVC"];
                vc.titleString = @"Web History";
                vc.shouldHideTitle = YES;
                delegate.centerNavController = [[UINavigationController alloc] initWithRootViewController:vc];
            }
            else{
                if([delegate.selectedDashboardChild.device isEqualToString:@"iphone"])
                {
                    iOSBrowserHistoryViewController *controller = [[iOSBrowserHistoryViewController alloc] initWithNibName:@"iOSBrowserHistoryViewController" bundle:nil];
                    delegate.centerNavController = [[UINavigationController alloc] initWithRootViewController:controller];
                }
                else
                {
                    self.browserCont = [[BrowserLogsViewController alloc] initWithNibName:@"BrowserLogsViewController" bundle:nil];
                    delegate.centerNavController = [[UINavigationController alloc] initWithRootViewController:self.browserCont];
                }
            }
        }
        else if([label isEqualToString:NSLocalizedString(@"Bookmarks", nil)])
        {
            DashboardChildPackageFeature *feature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"bookmark"];
            if ([drawer_package_id isEqualToString:@"1"]) {
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Dashboard" bundle:nil];
                PremiumPopupVC *vc = [sb instantiateViewControllerWithIdentifier:@"PremiumPopupVC"];
                vc.titleString = @"Bookmarks";
                vc.shouldHideTitle = YES;
                delegate.centerNavController = [[UINavigationController alloc] initWithRootViewController:vc];
            }
            else{
                self.bookmarksCont = [[BookmarksViewController alloc] initWithNibName:@"BookmarksViewController" bundle:nil];
                delegate.centerNavController = [[UINavigationController alloc] initWithRootViewController:self.bookmarksCont];
            }
            
//            self.bookmarksCont = [[BookmarksViewController alloc] initWithNibName:@"BookmarksViewController" bundle:nil];
//            delegate.centerNavController = [[UINavigationController alloc] initWithRootViewController:self.bookmarksCont];
            
        }
        else if([label isEqualToString:NSLocalizedString(@"Call History", nil)])
        {
//            DashboardChildPackageFeature *feature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"call"];
//            if (feature.package_id == 0 || feature != nil)
//            {
//                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Dashboard" bundle:nil];
//                PremiumPopupVC *vc = [sb instantiateViewControllerWithIdentifier:@"PremiumPopupVC"];
//                vc.titleString = @"Call History";
//                vc.shouldHideTitle = YES;
//                delegate.centerNavController = [[UINavigationController alloc] initWithRootViewController:vc];
//            }
//            else{
                self.callLogsCont = [[CallLogsViewController alloc] initWithNibName:@"CallLogsViewController" bundle:nil];
                delegate.centerNavController = [[UINavigationController alloc] initWithRootViewController:self.callLogsCont];
//            }
            
//            self.callLogsCont = [[CallLogsViewController alloc] initWithNibName:@"CallLogsViewController" bundle:nil];
//            delegate.centerNavController = [[UINavigationController alloc] initWithRootViewController:self.callLogsCont];
        }
        
        else  if([label isEqualToString:NSLocalizedString(@"Places History", nil)])
        {
           // DashboardChildPackageFeature *feature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"place"];
            if ([drawer_package_id isEqualToString:@"1"]) {
                UIStoryboard *sb    = [UIStoryboard storyboardWithName:@"Dashboard" bundle:nil];
                PremiumPopupVC *vc  = [sb instantiateViewControllerWithIdentifier:@"PremiumPopupVC"];
                vc.titleString      = @"Places History";
                vc.shouldHideTitle  = YES;
                delegate.centerNavController = [[UINavigationController alloc] initWithRootViewController:vc];
            }
            else{
                
                if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                {
                    self.placesReportViewController = [[PlacesReportViewController alloc] initWithNibName:@"PlacesReportViewController~ipad" bundle:nil];
                    delegate.centerNavController = [[UINavigationController alloc] initWithRootViewController:self.placesReportViewController];
                }
                else
                {
                    self.placesReportViewController = [[PlacesReportViewController alloc] initWithNibName:@"PlacesReportViewController" bundle:nil];
                    delegate.centerNavController = [[UINavigationController alloc] initWithRootViewController:self.placesReportViewController];
                }
            }
            
            
//            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//            {
//                self.placesReportViewController = [[PlacesReportViewController alloc] initWithNibName:@"PlacesReportViewController~ipad" bundle:nil];
//                delegate.centerNavController = [[UINavigationController alloc] initWithRootViewController:self.placesReportViewController];
//            }
//            else
//            {
//                self.placesReportViewController = [[PlacesReportViewController alloc] initWithNibName:@"PlacesReportViewController" bundle:nil];
//                delegate.centerNavController = [[UINavigationController alloc] initWithRootViewController:self.placesReportViewController];
//            }
        }
        else  if([label isEqualToString:NSLocalizedString(@"Installed Apps", nil)])
        {
//            DashboardChildPackageFeature *feature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"installedapp"];
//            if (feature.package_id == 0 || feature != nil)
//            {
//                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Dashboard" bundle:nil];
//                PremiumPopupVC *vc = [sb instantiateViewControllerWithIdentifier:@"PremiumPopupVC"];
//                vc.titleString = @"Installed Apps";
//                vc.shouldHideTitle = YES;
//                delegate.centerNavController = [[UINavigationController alloc] initWithRootViewController:vc];
//            }
//            else{
                self.installAppsCont = [[AllInstalledAppsViewController alloc] initWithNibName:@"AllInstalledAppsViewController" bundle:nil];
                delegate.centerNavController = [[UINavigationController alloc] initWithRootViewController:self.installAppsCont];
 //           }
            
//            self.installAppsCont = [[AllInstalledAppsViewController alloc] initWithNibName:@"AllInstalledAppsViewController" bundle:nil];
//            delegate.centerNavController = [[UINavigationController alloc] initWithRootViewController:self.installAppsCont];
        }
        
        else  if([label isEqualToString:NSLocalizedString(@"App Usage", nil)])
        {
//            DashboardChildPackageFeature *feature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"app_usage"];
//            if (feature.package_id == 0 || feature != nil)
//            {
//                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Dashboard" bundle:nil];
//                PremiumPopupVC *vc = [sb instantiateViewControllerWithIdentifier:@"PremiumPopupVC"];
//                vc.titleString = @"App Usage";
//                vc.shouldHideTitle = YES;
//                delegate.centerNavController = [[UINavigationController alloc] initWithRootViewController:vc];
//            }
//            else{
                
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Dashboard" bundle:nil];
                AppUsageVC *vc = [sb instantiateViewControllerWithIdentifier:@"AppUsageVC"];
                delegate.centerNavController = [[UINavigationController alloc] initWithRootViewController:vc];
                
           // }
        }
        
        else  if([label isEqualToString:NSLocalizedString(@"Settings", nil)])
        {
            
            if(delegate.selectedDashboardChild.plateform_id == 1)
            {
                self.settingsCont = [[LeftSidePanel alloc] initWithNibName:@"LeftSidePanel" bundle:nil];
                delegate.centerNavController = [[UINavigationController alloc] initWithRootViewController:self.settingsCont];
            }
            else
            {
                self.settingsContiOS = [[LeftSidePaneliOS alloc] initWithNibName:@"LeftSidePaneliOS" bundle:nil];
                delegate.centerNavController = [[UINavigationController alloc] initWithRootViewController:self.settingsContiOS];
            }
        }
        
        else  if([label isEqualToString:NSLocalizedString(@"Device Info", nil)])
        {
//            self.profileCont = [[ProfileViewController alloc] init];
//            delegate.centerNavController = [[UINavigationController alloc] initWithRootViewController:self.profileCont];
            
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Dashboard" bundle:nil];
            DeviceVC *vc = [sb instantiateViewControllerWithIdentifier:@"DeviceVC"];
            vc.flagToHideNavBar = false;
            delegate.centerNavController = [[UINavigationController alloc] initWithRootViewController:vc];
        }
        else if([label isEqualToString:NSLocalizedString(@"Text Messages", nil)])
        {
            //DashboardChildPackageFeature *feature = [delegate.selectedDashboardChild getPackageFeatureWithName:@"sms"];
            if ([drawer_package_id isEqualToString:@"3"])
            {
                TextMessagesViewController *vc = [[TextMessagesViewController alloc] init];
                delegate.centerNavController = [[UINavigationController alloc] initWithRootViewController:vc];
            }
            else{
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Dashboard" bundle:nil];
                PremiumPopupVC *vc = [sb instantiateViewControllerWithIdentifier:@"PremiumPopupVC"];
                vc.titleString = @"Text Messages";
                vc.shouldHideTitle = YES;
                delegate.centerNavController = [[UINavigationController alloc] initWithRootViewController:vc];
            }
            
        }
        delegate.jasidePanel.centerPanel = delegate.centerNavController;
        [delegate.jasidePanel toggleLeftPanel:nil];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex != 0)
    {
        [SwiftFTUtils showHUDAddedTo:self.view withText:@"Logging out" animated:true];
        
        NSString *devicToken = [[NSUserDefaults standardUserDefaults] valueForKey:kDeviceToken];
        NSDictionary *dict = @{@"device_unique_identity" : devicToken,@"push_token":devicToken};
        
        [[ApiManager shared] postApiWithParamsLogout:dict andUrl:kLogoutUrl_mesh2 andController:self withResponse:^(NSString * _Nonnull error, Boolean errorCode) {
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [SwiftFTUtils hideHUDAddedTo:self.view animated:true];
                NSLog(@"logout api response with code = %ld", (long)errorCode);
                
                if (errorCode == true){
                   
                    self.contName = @"Drawer";
                    
                    //---REMOVE FACEBOOK DUE TO MDM---//
//                    [[FBSDKLoginManager new] logOut];
                    
                    
                    [CommonModel clearDataAndLogoutOnController:self isPresentedVC:false];
                    
                    //                [[AppDelegate appDelegate] setNavigationbarAppearence:YES cont:self];
                    //                [delegate setupDrawer:2];
                }
                else{
                    [SwiftFTUtils hideHUDAddedTo:self.view animated:true];
                    NSLog(@"logout api failed with error = %@", error);
                    [CommonModel showAlert:[@"Error!" myModification]  msg:error];
                }
            });
        }];
    }
}

@end
