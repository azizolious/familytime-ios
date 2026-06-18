//
//  UserProfileViewController.m
//  FamilyTime
//
//  Created by Sora Code on 12/31/14.
//  Copyright (c) 2014 SoraCode. All rights reserved.
//

#import "UserProfileViewController.h"
#import "UserDetailViewController.h"
#import "MBProgressHUD.h"
#import "JSONHTTPClient.h"
#import "AppDelegate.h"
#import "UserDeviceInfoTableViewController.h"
#import "UIViewController+Keyboard.h"
#import "SubscriptionViewController.h"
@import FirebaseAnalytics;
#import "FTUtils.h"

AppDelegate *delegate;
UIRefreshControl *  refreshControl;
UIImagePickerController  *imgPicker;

@interface UserProfileViewController ()

@end

@implementation UserProfileViewController

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [CommonModel removeKeyBoardObserver:self];
    [[NSNotificationCenter defaultCenter]  removeObserver:self name:@"updateuserName" object:nil];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [FIRAnalytics logEventWithName:@"screen_view"
                        parameters:@{@"screen_name": @"UserProfile",
                                     @"screen_class": @"UserProfileViewController"}];
    
    
  // [self uploadProfilePictures];
    NSString *color;
    NSString *profileImgUrl, *dpUrl;

    self.child = delegate.selectedChild;
     [self loadProfile];
    self.userName.text = self.child.name;
       color = self.child.color== nil ? @"purple": self.child.color;
    profileImgUrl =self.child.cover_img_src;
    dpUrl = self.child.profile_img_src;
    
    NSLog(@"%@",self.child.user_id);
    NSLog(@"%@",delegate.selectedChild.child_id);
    
    if(self.child.user_id == nil)
    {
        //self.profileLabel.text = self.child.duration!= nil ?[NSString stringWithFormat:@"%@ - %@ left",self.self.child.package,self.child.duration] : self.child.package;
        
        self.infoBtnView.hidden = NO;
        self.infoSeparator.hidden = NO;
        self.subBtnView.hidden = YES;
        [self setSelectedTab:0];
        
        if([self.child.active isEqualToString:@"0"]){
            self.infoBtnView.hidden = YES;
            self.infoSeparator.hidden = YES;
        }
        
//        [self.aboutBtnView setUserInteractionEnabled:YES];
    }
    else
    {
         //self.profileLabel.text = @"Premium";
        self.infoBtnView.hidden = YES;
        self.infoSeparator.hidden = YES;
        if([self.child.type isEqualToString:@"Sub"]){
            self.subBtnView.hidden = YES;
//            [self.aboutBtnView setUserInteractionEnabled:NO];
    }
    else
    {
            self.subBtnView.hidden = NO;
//            [self.aboutBtnView setUserInteractionEnabled:YES];
    }
        
    }
    
    if(![self.child.package isEqualToString:@"free"])
    {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"YYYY-MM-dd"];
        NSDate *expiryDate = [df dateFromString:self.child.expiry_date];
        NSDate *today = [NSDate date];
        NSString *diff = [CommonModel remaningTimeInDays:today endDate:expiryDate];
        
        NSString *firstCapChar = [[self.child.package substringToIndex:1] capitalizedString];
        NSString *cappedString = [self.child.package stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:firstCapChar];
        
        self.profileLabel.text = [NSString stringWithFormat:@"%@ - %@ left",cappedString, diff];
    }
    else
    {
        NSString *firstCapChar = [[self.child.package substringToIndex:1] capitalizedString];
        NSString *cappedString = [self.child.package stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:firstCapChar];
        
        self.profileLabel.text = [NSString stringWithFormat:@"%@ Package",cappedString];
    }
    
    
    [self.bgView setBackgroundColor:[CommonModel colorFromHexString:color]];
    //set avatar
    int r = [color isEqualToString:@"orange"] ? 1 : [color isEqualToString:@"green"] ? 2  :[color isEqualToString:@"purple"] ? 3 : 4  ;
    [self.dbBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"addUser_avater_%i.png",r]] forState:UIControlStateNormal];
    
    
    [self initPageViewController];
    [self setSelectedTab:0];
    [CommonModel addKeyBoardObserver:self];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserName) name:@"updateuserName" object:nil];
    // register for keyboard notifications
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        UIImage *temp =[CommonModel userImage:dpUrl];
        dispatch_sync(dispatch_get_main_queue(), ^{
            
        if(temp != nil)
        {
            int radius = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 60 :45;
            [self.dbBtn setImage:temp forState:UIControlStateNormal];
            [self.dbBtn.layer setCornerRadius:radius];
            [self.dbBtn.layer setBorderWidth:2];
            [self.dbBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
            self.dbBtn.clipsToBounds = YES;
        }
        });
       UIImage *temp2 = [CommonModel userImage:profileImgUrl];
        dispatch_sync(dispatch_get_main_queue(), ^{
            
        if(temp2 != nil) {
            [self.coverImg setImage:temp2];
            self.coverImg.clipsToBounds = YES;
        }
        });
    });
    
    self.aboutBtnView.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.aboutBtnView.superview.frame)/2.0f, CGRectGetHeight(self.aboutBtnView.superview.frame));
    self.infoBtnView.frame = CGRectMake(CGRectGetMidX(self.infoBtnView.superview.frame), 0.0f, CGRectGetWidth(self.infoBtnView.superview.frame)/2.0f, CGRectGetHeight(self.infoBtnView.superview.frame));
    
}
-(void)updateUserName
{
//    if(delegate.selectedChild != nil)
        self.userName.text = delegate.selectedChild.name;
//    else
//        self.userName.text = delegate.selectedParent.name;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"";
    [self.navigationItem setTitle:@"User Profile"];
    
    delegate = [AppDelegate appDelegate];
//    if(self.currentTab == nil)
//        self.currentTab = self.infoBtnView;
//    
//    if (self.currentTab!=nil) {
//        self.currentTab=self.infoBtnView;
//    }
    //self.currentTab=self.infoBtnView;
    
    [self performSelector:@selector(selectTab:) withObject:0];
    self.pagerY = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 330 : 225;
    //[self setupImagePicker];
     self.infoBtnView.tag = 0;
    self.aboutBtnView.tag = 1;
    self.subBtnView.tag = 2;
    // addtaping gestures on button
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTab:)];
    //[self.aboutBtnView addGestureRecognizer:gesture];
    [self.infoBtnView addGestureRecognizer:gesture];
    gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTab:)];
    [self.aboutBtnView addGestureRecognizer:gesture];
    gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTab:)];
    [self.subBtnView addGestureRecognizer:gesture];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark TextField delegates
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //    if (textField == self.userID)
    //        [self.psw becomeFirstResponder];
    //    else
    //        [self.psw resignFirstResponder];
    return YES;
    
}

-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    
    //    if ([sender isEqual:self.userID] || [sender isEqual:self.psw])
    //    {
    //        //move the main view, so that the keyboard does not hide it.
    if  (self.view.frame.origin.y > 0)
    {
        [self setViewMovedUp:YES];
    }
    //    }
}

-(void) loadProfile//:(NSString *)url userID:(NSString *)userId
{
    NSString *url, *userId;
    NSLog(@"%@",delegate.selectedChild.user_id);
    NSLog(@"%@",delegate.selectedChild.child_id);
    
    url = delegate.selectedChild.user_id == nil ? KChildProfile : KParentProfile;
    userId = delegate.selectedChild.user_id != nil ? delegate.selectedChild.user_id : delegate.selectedChild.child_id;
    [FTUtils showHUDAddedTo:self.view withText:@"Loading..." animated:YES];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:userId,@"id", nil];
//    NSString *url = [NSString stringWithFormat:@"%@",];
    [JSONHTTPClient postJSONFromURLWithString:KChildProfile
                                       params:params
                                   completion:^(id json, JSONModelError *err) {
                                       NSError *error;
                                       NSString *msg = [json valueForKey:@"message"] == nil ? kErrorGeneral : [json valueForKey:@"message"];
                                       // read response code
                                       if([[json valueForKey:@"response"] intValue]== 200){
                                           FamilyModel *family = [[FamilyModel alloc] initWithDictionary:json error:&error];
                                           NSLog(@"%@",family);
                                           NSLog(@"%@",delegate.selectedChild.child_id);
                                           if(delegate.selectedChild.child_id != nil)
                                           {
                                               ChildPrefence *prefer = delegate.selectedChild.preferences;
                                               delegate.selectedChild = family.child;
                                               delegate.selectedChild.preferences = prefer;
                                               delegate.userDevice = family.device;
                                           }
                                           else{
//                                               ChildModel *child = [[ChildModel alloc] init];
//                                               child.name =  family.parent.name;
//                                               child.super_user_id = family.parent.super_user_id;
//                                               child.gender =  family.parent.gender;
//                                               child.phone = family.parent.phone;
//                                               child.name =  family.parent.name;
//                                               child.relationship = family.parent.relationship;
//                                               child.birthday =  family.parent.birthday;
//                                               child.cover_img_src = family.parent.cover_img_src;
//                                               child.birthday =  family.parent.birthday;
//                                               child.cover_img_src = family.parent.cover_img_src;
//                                               child.profile_img_src =  family.parent.profile_img_src;
//                                               child.cover_img_src = family.parent.cover_img_src;
//                                               child.color = family.parent.color;
//                                               child.email = family.parent.email;
//                                               child.type = family.parent.type;
//                                               delegate.selectedChild = child;
                                               delegate.selectedChild =  family.parent;                                           }
                                           
                                       }
                                       else
                                           [CommonModel showAlert:@"Error!" msg:msg];
                                       
                                       [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                   }];
    
}
-(void) updateChildInfo:(NSString *)fieldName value:(NSString *) value 
{
    NSString *url, *userId;
    url = delegate.selectedChild.user_id == nil ? KChildEditProfile : KParentEditProfile;
    userId = delegate.selectedChild.user_id != nil ? delegate.selectedChild.user_id : delegate.selectedChild.child_id;
    
    [FTUtils showHUDAddedTo:self.view withText:@"Updating..." animated:YES];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:userId,@"id",value,fieldName, nil];
   
    [JSONHTTPClient postJSONFromURLWithString:url
                                       params:params
                                        completion:^(id json, JSONModelError *err) {
                                  //     NSError *error;
                                       // read response code
                                       if([[json valueForKey:@"response"] intValue]== 200){
                                           [self loadProfile];
                                       }
                                       else
                                           [CommonModel showAlert:@"Error!" msg:[json valueForKey:@"message"]];
                                       
                                       [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                   }];
}

#pragma mark PageController delegates
- (void) initPageViewController
{
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageController.dataSource = self;
    [[self.pageController view] setFrame:[self.scrollView bounds]];
    
    UserDetailViewController *initialViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    //    [self addChildViewController:self.pageController];
    //    [self.container addSubview:[self.pageController view]];
    //    [self.pageController didMoveToParentViewController:self];
    
    [self addChildViewController:self.pageController];
   [[self.pageController view] setFrame:CGRectMake(0, self.pagerY, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
    [self.scrollView addSubview:[self.pageController view]];
    
    [self.pageController didMoveToParentViewController:self];
}

-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    NSLog(@"completed ");
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    return nil;
    NSUInteger index = [(UserDeviceInfoTableViewController *)viewController index];
    [self setSelectedTab:index];
    //    if(self.currentTab != nil)
    //        [self.currentTab setBackgroundColor:[UIColor clearColor]];
    //    if(index == 0)
    //        self.currentTab = self.aboutBtnView;
    //    else if(index == 1)
    //        self.currentTab = self.infoBtnView;
    //    else if(index == 2)
    //        self.currentTab = self.subBtnView;
    //    [self.currentTab setBackgroundColor:[UIColor darkGrayColor]];
    
//    if (index == 0) {
//        return nil;
//    }
//    index--;
//    [self.pageController.view setNeedsDisplay];
    if(index == 0)
        return [self viewControllerAtIndex2:index];
    else if(index == 1)
        return [self viewControllerAtIndex:index];
//    else
//        return [self viewControllerAtIndex3:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    return nil;
    NSUInteger index = [(UserDetailViewController *)viewController index];
    [self setSelectedTab:index];
    //    if(self.currentTab != nil)
    //        [self.currentTab setBackgroundColor:[UIColor clearColor]];
    //    if(index == 0)
    //        self.currentTab = self.aboutBtnView;
    //    else if(index == 1)
    //        self.currentTab = self.infoBtnView;
    //    else if(index == 2)
    //        self.currentTab = self.subBtnView;
    //    [self.currentTab setBackgroundColor:[UIColor darkGrayColor]];
    
    //index++;
    
//    if (index == 3)
//    {
//        return nil;
//    }
    
//    [self.pageController.view setNeedsDisplay];
    if(index == 0)
        return [self viewControllerAtIndex2:index];
    else if(index == 1)
        return [self viewControllerAtIndex:index];
//    else
//        return [self viewControllerAtIndex3:index];
}


-(UserDeviceInfoTableViewController *)viewControllerAtIndex2:(NSUInteger)index
{
    UserDeviceInfoTableViewController *childViewController = [[UserDeviceInfoTableViewController alloc] initWithNibName:@"UserDeviceInfoTableViewController" bundle:nil];
    childViewController.index = index;
    [[self.pageController view] setFrame:CGRectMake(0, self.pagerY, self.scrollView.frame.size.width, 485)];
    
    if (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width) == 667))
    {
        [[self.pageController view] setFrame:CGRectMake(0, self.pagerY, 375, self.scrollView.frame.size.height)];
    }
    else if (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width) == 736))
    {
        [[self.pageController view] setFrame:CGRectMake(0, self.pagerY, 414, self.scrollView.frame.size.height)];
    }
    
    CGRect contentRect = CGRectZero;
    for (UIView *view in self.scrollView.subviews) {
        contentRect = CGRectUnion(contentRect, view.frame);
    }
    self.scrollView.contentSize = contentRect.size;
    return childViewController;
    
}

- (UserDetailViewController *)viewControllerAtIndex:(NSUInteger)index {
    UserDetailViewController *childViewController;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        childViewController = [[UserDetailViewController alloc] initWithNibName:@"UserDetailViewController2~ipad" bundle:nil];
    }
    else
    {
        childViewController = [[UserDetailViewController alloc] initWithNibName:@"UserDetailViewController2~iphone" bundle:nil];
    }
    
    childViewController.index = index;
    int h = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 440 :320;
    
    [[self.pageController view] setFrame:CGRectMake(0, self.pagerY, self.scrollView.frame.size.width, h)];
    
    if (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width) == 667))
    {
        [[self.pageController view] setFrame:CGRectMake(0, self.pagerY, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
    }
    else if (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width) == 736))
    {
        [[self.pageController view] setFrame:CGRectMake(0, self.pagerY, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
    }
    CGRect contentRect = CGRectZero;
    for (UIView *view in self.scrollView.subviews)
    {
        contentRect = CGRectUnion(contentRect, view.frame);
    }
    self.scrollView.contentSize = contentRect.size;
    
    return childViewController;
    
}
- (SubscriptionViewController *)viewControllerAtIndex3:(NSUInteger)index {
    
    SubscriptionViewController *childViewController = [[SubscriptionViewController alloc] initWithNibName:@"SubscriptionViewController" bundle:nil];
    childViewController.index = index;
    [[self.pageController view] setFrame:CGRectMake(0, self.pagerY, self.scrollView.frame.size.width, 310)];
    
    CGRect contentRect = CGRectZero;
    for (UIView *view in self.scrollView.subviews) {
        contentRect = CGRectUnion(contentRect, view.frame);
    }
    self.scrollView.contentSize = contentRect.size;
    return childViewController;
    
}
- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    return 0;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}
-(void)setSelectedTab:(int)index
{
//    if(self.currentTab != nil)
//    {
//        [self.currentTab setBackgroundColor:[UIColor clearColor]];
//        self.aboutImg.image  = [UIImage imageNamed:@"about_btn_0"];
//        [self.aboutLabel setTextColor:[UIColor grayColor]];
//        self.infoImg.image  = [UIImage imageNamed:@"device"];
//        [self.infolabel setTextColor:[UIColor grayColor]];
//        self.subImg.image  = [UIImage imageNamed:@"Subscription_0"];
//        [self.subLabel setTextColor:[UIColor grayColor]];
//    }
    if(index == 0)
    {
        self.currentTab = self.infoBtnView;
        self.infoImg.image  = [UIImage imageNamed:@"device1"];
        [self.infolabel setTextColor:kBarTextColor()];
    }
    else if(index == 1){
        
        
        self.currentTab = self.aboutBtnView;
        self.aboutImg.image  = [UIImage imageNamed:@"about_btn_1"];
        [self.aboutLabel setTextColor:kBarTextColor()];
    }
    else if(index == 2){
        self.currentTab = self.subBtnView;
        self.subImg.image  = [UIImage imageNamed:@"Subscription_1"];
        [self.subLabel setTextColor:kBarTextColor()];
    }
    [self.currentTab setBackgroundColor:KSetBG(233, 237, 238, 1)];
    
    
}
- (IBAction)selectTab:(UITapGestureRecognizer *)sender {
    int index = (int)sender.view.tag;
    [self setSelectedTab:index];
    
    NSArray *viewControllers;
    if(index == 0){
        UserDeviceInfoTableViewController *startingViewController = [self viewControllerAtIndex2:index];
        viewControllers = @[startingViewController];
    }
    else if(index == 1)
    {
        UserDetailViewController *startingViewController = [self viewControllerAtIndex:index];
        viewControllers = @[startingViewController];
    }
    else
    {
        SubscriptionViewController *startingViewController = [self viewControllerAtIndex3:index];
        viewControllers = @[startingViewController];
    }
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    
}
#pragma action Sheet

#pragma mark image
- (IBAction)selectImg:(UIButton *)sender {
//    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Gallery",@"Take Photo", nil];
//    actionSheet.tag = sender.tag;
//    [actionSheet showInView:self.view];
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex ==2)
        return;
    if(actionSheet.tag == 0)
        [self.dbBtn setSelected:YES];
    
    else
        [self.dbBtn setSelected:NO];
    if(buttonIndex == 0)
    {
        [self setupImagePicker];
        imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    else
    {
        [self setupImagePicker];
        imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    
    //[self dismissViewControllerAnimated:NO completion:nil];
    [self presentViewController:imgPicker animated:YES completion:nil];
    
}
-(void) setupImagePicker
{
//    // Setup UIImagePicker Controller
//    imgPicker = [[UIImagePickerController alloc] init];
//    imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    //[imgPicker setMediaTypes:@[@"addUser_avater_1.png"]];//UIImagePickerControllerSourceTypePhotoLibrary
//    imgPicker.delegate = self;
//    imgPicker.allowsEditing = YES;
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* outputImage = [info objectForKey:UIImagePickerControllerEditedImage];
    if (outputImage == nil) {
        outputImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImageWriteToSavedPhotosAlbum(outputImage, nil, nil, nil);
        });
    }
    else
        [picker dismissViewControllerAnimated:YES completion:nil];
    
    if (outputImage) {
        NSString *imageName = [NSString stringWithFormat:@"%@-%@.JPEG",self.child.name,[CommonModel currentDate]];
        NSLog(@"%@",imageName);
        if(self.dbBtn.isSelected){
            int radius = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 60 :45;
            [self.dbBtn setSelected:NO];
            [self.dbBtn setImage:outputImage forState:UIControlStateNormal];
            self.dbBtn.layer.cornerRadius = radius;
            self.dbBtn.layer.borderWidth = 3;
            self.dbBtn.layer.borderColor = [UIColor whiteColor].CGColor;
            self.dbBtn.clipsToBounds = YES;
            self.isCoverImg = false;
        }
        else{
            [self.coverImg setImage:outputImage];
//            self.coverImg.contentMode = UIViewContentModeScaleAspectFill;
//            self.coverImg.clipsToBounds = YES;
            self.isCoverImg = true;
        }
        self.imagePath = [CommonModel storeImage:outputImage name:[NSString stringWithFormat:@"%@.png",[CommonModel currentDate]]];
        [self uploadProfilePictures];
        // store image on Amazone Bitbucket
        //send info to sync server
        
    }
    
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    //    self.captureImage = nil;
}
-(void) uploadProfilePictures{
    @try {
        //        [FTUtils showHUDAddedTo:self.view withText:@"Uploading Photo..." animated:YES];
        //uploading photo to S3 bucket
        UIImage *imgg=[UIImage imageNamed:@"addUser_avater_1"];
        NSLog(@"%@",imgg);
        self.imagePath=[CommonModel storeImage:imgg name:[NSString stringWithFormat:@"%@.png",[CommonModel currentDate]]];
        NSLog(@"%@",self.imagePath);
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,  0ul);
        dispatch_async(queue, ^{
            NSLog(@"image path %@***",self.imagePath);
        });
    }
    @catch (NSException *exception) {
        [CommonModel showAlert:@"" msg:@"unable to load image from bucket"];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }
    @finally {}
}

-(void)photoUploadStatus:(BOOL)status msg:(NSString *)msg
{
    //uploading photo path to server
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSString *type = self.isCoverImg ? @"cover" :@"profile";
    NSString *path = [NSString stringWithFormat:@"%@_%@/%@",delegate.parent.name,delegate.parent.user_id,self.imagePath.lastPathComponent];
    NSLog(@"%@",path);
    NSString *userId = delegate.selectedChild.user_id != nil ? delegate.selectedChild.user_id : delegate.selectedChild.child_id;
    NSString *url = delegate.selectedChild.user_id == nil ? KChildUpdatePhoto: KUserUpdatePhoto;
    if(status)
    {
        [FTUtils showHUDAddedTo:self.view withText:@"Updating info..." animated:YES];
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:userId,@"id",type,@"type",path,@"path", nil];
        [JSONHTTPClient postJSONFromURLWithString:url
                                           params:params
                                       completion:^(id json, JSONModelError *err)
        {
                                       //    NSError *error;
                                           // read response code
                                           if([[json valueForKey:@"response"] intValue]== 200)
                                           {
                                               NSLog(@"%@",url);
                                               NSLog(@"%@",json);
                                               NSLog(@"%@",params);
                                               
                                               //[self loadChildProfile];
                                               if([type isEqualToString:@"profile"])
                                                   delegate.selectedChild.profile_img_src = path;
                                               else
                                                   delegate.selectedChild.cover_img_src = path;
                                           }
                                           else
                                               [CommonModel showAlert:@"Error!" msg:[json valueForKey:@"message"]];
                                           
                                           [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                       }];
    }
    
    else{
        [CommonModel showAlert:@"" msg:@"Unable to upload Photo"];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }
    
}

@end
