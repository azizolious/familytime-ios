//
//  SyncSettingsPopupController.m
//  FamilyTime - Dashboard
//
//  Created by Muhammad Ajmal on 05/06/2017.
//  Copyright © 2017 SoraCode. All rights reserved.
//

#import "SyncSettingsPopupController.h"
#import "FTUtils.h"
#import "CommonModel.h"
//#import <Google/Analytics.h>
#import "AppDelegate.h"
#import "UIView+VTSelectiveBorder.h"
#import "Constant.h"
//#import "JSONHTTPClient.h"
#import "MBProgressHUD.h"
#import "NSString+LockMustafa.h"
#import "FamilyTime-Swift.h"

@interface SyncSettingsPopupController ()<UIAlertViewDelegate>
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *syncButton;
@end

@implementation SyncSettingsPopupController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)setupUI
{
    self.imageView = [self setupImageView];
    [self.view addSubview:self.imageView];
    
    self.cancelButton = [self setupLaterButton];
    [self.cancelButton addTarget:self action:@selector(handleLater:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cancelButton];
    
    self.syncButton = [self setupSyncButton];
    [self.syncButton addTarget:self action:@selector(handleSync:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.syncButton];
    
    self.messageLabel = [self setupMessageLabel];
    [self.view addSubview:self.messageLabel];
}

- (void)handleLater:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"gobacknow"];
    [[NSUserDefaults standardUserDefaults]synchronize];
   //[self.navigationController popViewControllerAnimated:YES];
}

- (void)handleCancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)handleSync:(id)sender
{
  //  [self updateAppStore];
    [self synSettings];
}

- (void)synSettings
{
    [SwiftFTUtils showHUDAddedTo:self.view withText:[@"Loading..." myModification] animated:YES];
    AppDelegate *delegate = [AppDelegate appDelegate];
    NSString *url = [NSString stringWithFormat:@"%@/%ld",kSyncSettings,(long)delegate.selectedDashboardChild.child_id];
    
//    NSDictionary *params = @{@"settings":@"all"};
//
//    NSString *jsonString;
//    {
//
//        NSError *error;
//        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params
//                                                           options:NSJSONWritingPrettyPrinted // Pass 0 if you don't  care about the readability of the generated string
//                                                             error:&error];
//
//        if (! jsonData) {
//            NSLog(@"Got an error: %@", error);
//        } else {
//            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//            NSLog(@"%@", jsonString);
//        }
//    }
//
//    NSLog(@"url = %@ and bodyString = %@", url, jsonString);
    /*
     
    [JSONHTTPClient getJSONFromURLWithString:url
                                      params:nil
                                  completion:^(id json, JSONModelError *err) {
                                      NSError *error;
                                      
                                      UpdateSyncSettings *updateSettings = [[UpdateSyncSettings alloc] initWithDictionary:json error:&error];
                                      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                      
                                      if(updateSettings.status_code != 200)
                                      {
                                          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[@"Error!" myModification] message:updateSettings.response delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                          [alert show];
                                      }
                                      else
                                      {
                                          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[@"Sync Settings" myModification] message:updateSettings.response delegate:self cancelButtonTitle:[@"OK" myModification] otherButtonTitles:nil, nil];
                                          [alert show];

                                          [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"gobacknow"];
                                          [[NSUserDefaults standardUserDefaults]synchronize];

                                      }
                                  }];
    
     */
    
    //---NATIVE API CALLING---//
    
    [[ApiManager shared] mesh_postApiWithOutParam:url withResponse:^(NSDictionary * _Nonnull json, NSInteger errorCode, NSString * _Nonnull message) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"syncSettingsPopup api response = %@", json);
            
            NSError *error;
            //UpdateSyncSettings *updateSettings = [[UpdateSyncSettings alloc] initWithDictionary:json error:&error];
           // NSDictionary *response = [[NSDictionary alloc] init];
           // response = [json objectForKey:@"response"];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            NSLog(@"after parsing model = %@", json);
            
            int status = [[json objectForKey:@"status"] intValue];
            
            if(status != 200)
            {
                NSString *message = [json objectForKey:@"message"];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[@"Error!" myModification] message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
            else
            {
                NSString *message = [json objectForKey:@"message"];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[@"Sync Settings" myModification] message:message delegate:self cancelButtonTitle:[@"OK" myModification] otherButtonTitles:nil, nil];
                [alert show];
                
                
                [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"gobacknow"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                //[self.navigationController popViewControllerAnimated:YES];
                
            }
            
        });
    }];
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self dismissViewControllerAnimated:YES completion:^{
       //[super.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"syncComplete" object:nil];
        
    }];
}

- (UIImageView *)setupImageView
{
    UIImageView *imageView;
    if(IS_IPHONE_4)
    {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds) - 72.0f/2.0f, 24.0f, 72.0f, 72.0f)];
    }
    else if(IS_IPHONE_5)
    {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds) - 72.0f/2.0f, 24.0f, 72.0f, 72.0f)];
    }
    else if(IS_IPHONE_6)
    {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds) - 96.0f/2.0f, 29.0f, 96.0f, 96.0f)];
    }
    else if(IS_IPHONE_6_PLUS)
    {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds) - 96.0f/2.0f, 31.0f, 96.0f, 96.0f)];
    }
    else if(IS_IPHONE_X)
        {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds) - 96.0f/2.0f, 31.0f, 96.0f, 96.0f)];
        }
    else
    {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds) - 116.0f/2.0f, 47.0f, 116.0f, 116.0f)];
    }
    imageView.image = [UIImage imageNamed:self.imagename];
    return imageView;
}

- (UIButton *)setupCancelButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if(IS_IPHONE_4)
    {
        button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.view.bounds) - 40.0f, CGRectGetWidth(self.view.bounds)/2.0, 40.0f);
        button.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:13];
    }
    else if(IS_IPHONE_5)
    {
        button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.view.bounds) - 40.0f, CGRectGetWidth(self.view.bounds)/2.0, 40.0f);
        button.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:13];
    }
    else if(IS_IPHONE_6)
    {
        button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.view.bounds) - 46.0f, CGRectGetWidth(self.view.bounds)/2.0, 46.0f);
        button.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:14];
    }
    else if(IS_IPHONE_6_PLUS)
    {
        button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.view.bounds) - 52.0f, CGRectGetWidth(self.view.bounds)/2.0, 52.0f);
        button.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:15];
    }
    else if(IS_IPHONE_X)
        {
        button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.view.bounds) - 52.0f, CGRectGetWidth(self.view.bounds)/2.0, 52.0f);
        button.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:15];
        }
    else
    {
        button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.view.bounds) - 78.0f, CGRectGetWidth(self.view.bounds)/2.0, 78.0f);
        button.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:20];
    }
    //mustafa
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[CommonModel colorFromHexString:self.color]];
    [button setTitle:@"Cancel" forState:UIControlStateNormal];
    
    button.selectiveBorderFlag = AUISelectiveBordersFlagRight;
    button.selectiveBordersColor = [UIColor whiteColor];
    button.selectiveBordersWidth = 1.0;
    
    
    return button;
}
- (UIButton *)setupLaterButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if(IS_IPHONE_4)
    {
        button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.view.bounds) - 40.0f, CGRectGetWidth(self.view.bounds)/2.0, 40.0f);
        button.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:13];
    }
    else if(IS_IPHONE_5)
    {
        button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.view.bounds) - 40.0f, CGRectGetWidth(self.view.bounds)/2.0, 40.0f);
        button.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:13];
    }
    else if(IS_IPHONE_6)
    {
        button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.view.bounds) - 46.0f, CGRectGetWidth(self.view.bounds)/2.0, 46.0f);
        button.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:14];
    }
    else if(IS_IPHONE_6_PLUS)
    {
        button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.view.bounds) - 52.0f, CGRectGetWidth(self.view.bounds)/2.0, 52.0f);
        button.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:15];
    }
    else if(IS_IPHONE_X)
        {
        button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.view.bounds) - 52.0f, CGRectGetWidth(self.view.bounds)/2.0, 52.0f);
        button.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:15];
        }
    else
    {
        button.frame = CGRectMake(0.0f, CGRectGetMaxY(self.view.bounds) - 78.0f, CGRectGetWidth(self.view.bounds)/2.0, 78.0f);
        button.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:20];
    }
    //mustafa
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[CommonModel colorFromHexString:self.color]];
    [button setTitle:[@"Later" myModification] forState:UIControlStateNormal];
    
    button.selectiveBorderFlag = AUISelectiveBordersFlagRight;
    button.selectiveBordersColor = [UIColor whiteColor];
    button.selectiveBordersWidth = 1.0;
    
    
    return button;
}

- (UIButton *)setupSyncButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if(IS_IPHONE_4)
    {
        button.frame = CGRectMake(CGRectGetWidth(self.view.bounds)/2.0, CGRectGetMaxY(self.view.bounds) - 40.0f, CGRectGetWidth(self.view.bounds)/2.0, 40.0f);
        button.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:13];
    }
    else if(IS_IPHONE_5)
    {
        button.frame = CGRectMake(CGRectGetWidth(self.view.bounds)/2.0, CGRectGetMaxY(self.view.bounds) - 40.0f, CGRectGetWidth(self.view.bounds)/2.0, 40.0f);
        button.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:13];
    }
    else if(IS_IPHONE_6)
    {
        button.frame = CGRectMake(CGRectGetWidth(self.view.bounds)/2.0 , CGRectGetMaxY(self.view.bounds) - 46.0f, CGRectGetWidth(self.view.bounds)/2.0, 46.0f);
        button.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:14];
    }
    else if(IS_IPHONE_6_PLUS)
    {
        button.frame = CGRectMake(CGRectGetWidth(self.view.bounds)/2.0, CGRectGetMaxY(self.view.bounds) - 52.0f, CGRectGetWidth(self.view.bounds)/2.0, 52.0f);
        button.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:15];
    }
    else if(IS_IPHONE_X)
        {
        button.frame = CGRectMake(CGRectGetWidth(self.view.bounds)/2.0, CGRectGetMaxY(self.view.bounds) - 52.0f, CGRectGetWidth(self.view.bounds)/2.0, 52.0f);
        button.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:15];
        }
    else
    {
        button.frame = CGRectMake(CGRectGetWidth(self.view.bounds)/2.0, CGRectGetMaxY(self.view.bounds) - 78.0f, CGRectGetWidth(self.view.bounds)/2.0, 78.0f);
        button.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:20];
    }
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[CommonModel colorFromHexString:self.color]];
    [button setTitle:[@"Sync" myModification] forState:UIControlStateNormal];
    return button;
}


- (UILabel *)setupMessageLabel
{
    UILabel *label;
    NSMutableAttributedString *finalMessage = [[NSMutableAttributedString alloc] init];
    
    NSMutableAttributedString *titleMessage = [[NSMutableAttributedString alloc] initWithString:self.alertTitle];
    [titleMessage addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(96, 96, 96, 1) range:NSMakeRange(0, titleMessage.length)];
    NSMutableParagraphStyle *paragraphStyleTitle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyleTitle.alignment = NSTextAlignmentCenter;
    [titleMessage addAttribute:NSParagraphStyleAttributeName value:paragraphStyleTitle range:NSMakeRange(0, titleMessage.length)];
    
    NSMutableAttributedString *firstParagraph = [[NSMutableAttributedString alloc] initWithString:self.firstParagraph];
    [firstParagraph addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(118, 118, 118, 1) range:NSMakeRange(0, firstParagraph.length)];
    NSMutableParagraphStyle *paragraphStyleFirstParagraph = [[NSMutableParagraphStyle alloc] init];
    paragraphStyleFirstParagraph.alignment = NSTextAlignmentLeft;
    [firstParagraph addAttribute:NSParagraphStyleAttributeName value:paragraphStyleFirstParagraph range:NSMakeRange(0, firstParagraph.length)];
    
    if(IS_IPHONE_4)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(18.0f, CGRectGetMaxY(self.imageView.frame) + 15.0f, CGRectGetWidth(self.view.bounds) - 36.0f, CGRectGetMinY(self.cancelButton.frame) - CGRectGetMaxY(self.imageView.frame) - 15.0f)];
        
        [titleMessage addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Semibold" size:20] range:NSMakeRange(0, titleMessage.length)];
        [firstParagraph addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Light" size:12] range:NSMakeRange(0, firstParagraph.length)];
    }
    else if(IS_IPHONE_5)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(18.0f, CGRectGetMaxY(self.imageView.frame) + 15.0f, CGRectGetWidth(self.view.bounds) - 36.0f, CGRectGetMinY(self.cancelButton.frame) - CGRectGetMaxY(self.imageView.frame) - 15.0f)];
        [titleMessage addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Semibold" size:20] range:NSMakeRange(0, titleMessage.length)];
        [firstParagraph addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Light" size:12] range:NSMakeRange(0, firstParagraph.length)];
    }
    else if(IS_IPHONE_6)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(25.0f, CGRectGetMaxY(self.imageView.frame) + 15.0f, CGRectGetWidth(self.view.bounds) - 50.0f, CGRectGetMinY(self.cancelButton.frame) - CGRectGetMaxY(self.imageView.frame) - 15.0f)];
        [titleMessage addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Semibold" size:22] range:NSMakeRange(0, titleMessage.length)];
        [firstParagraph addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Light" size:13] range:NSMakeRange(0, firstParagraph.length)];
    }
    else if(IS_IPHONE_6_PLUS)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(31.0f, CGRectGetMaxY(self.imageView.frame) + 15.0f, CGRectGetWidth(self.view.bounds) - 62.0f, CGRectGetMinY(self.cancelButton.frame) - CGRectGetMaxY(self.imageView.frame) - 15.0f)];
        [titleMessage addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Semibold" size:24] range:NSMakeRange(0, titleMessage.length)];
        [firstParagraph addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Light" size:14] range:NSMakeRange(0, firstParagraph.length)];
    }
    else if(IS_IPHONE_X)
        {
        label = [[UILabel alloc] initWithFrame:CGRectMake(31.0f, CGRectGetMaxY(self.imageView.frame) + 15.0f, CGRectGetWidth(self.view.bounds) - 62.0f, CGRectGetMinY(self.cancelButton.frame) - CGRectGetMaxY(self.imageView.frame) - 15.0f)];
        [titleMessage addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Semibold" size:24] range:NSMakeRange(0, titleMessage.length)];
        [firstParagraph addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Light" size:14] range:NSMakeRange(0, firstParagraph.length)];
        }
    else
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(47.0f, CGRectGetMaxY(self.imageView.frame) + 34.0f, CGRectGetWidth(self.view.bounds) - 94.0f, CGRectGetMinY(self.cancelButton.frame) - CGRectGetMaxY(self.imageView.frame) - 34.0f)];
        [titleMessage addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Semibold" size:36] range:NSMakeRange(0, titleMessage.length)];
        [firstParagraph addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Light" size:19] range:NSMakeRange(0, firstParagraph.length)];
    }
    
    [finalMessage appendAttributedString:titleMessage];
    [finalMessage appendAttributedString:firstParagraph];
    label.numberOfLines = 0;
    
    CGRect rect = [finalMessage boundingRectWithSize:CGSizeMake(CGRectGetWidth(label.bounds), 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    label.frame = CGRectMake(CGRectGetMinX(label.frame), CGRectGetMinY(label.frame), CGRectGetWidth(label.frame), CGRectGetHeight(rect));
    label.attributedText = finalMessage;
    //label.backgroundColor = [UIColor redColor];
    return label;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
