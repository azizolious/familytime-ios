//
//  AddDeviceNewViewController3.m
//  FamilyTime - Dashboard
//
//  Created by Ahmad on 10/18/17.
//  Copyright © 2017 YumyApps. All rights reserved.
//

#import "AddDeviceNewViewController3.h"
#import "MBProgressHUD.h"
//#import "JSONHTTPClient.h"
#import "AppDelegate.h"
#import "FTUtils.h"
#import "FamilyTime-Swift.h"

AppDelegate *delegate;


@interface AddDeviceNewViewController3 ()

@end

@implementation AddDeviceNewViewController3

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    _lblTitle.text=[@"Setup instructions" myModification];
    _lblSubTitle.text=[@"Nice and easy, you will be up and running in no time." myModification];
    
    [btnHwtoAct setTitle:[@"View Detailed Instructions" myModification] forState:UIControlStateNormal];
    [btnYesIdo setTitle:[@"Yes, I've done it" myModification] forState:UIControlStateNormal];
    
    //btnYesIdo
    
    _lblTitle.text=[_lblTitle.text myModification];
    _lblSubTitle.text=[_lblSubTitle.text myModification];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(goBackNotification:)
                                                 name:@"GoBackNowStep2"
                                               object:nil];
    
    NSString *strRealID;
//    NSString *str= [[NSUserDefaults standardUserDefaults]objectForKey:@"CurrentUserID"];
    NSLog(@"Oee");
//    NSLog(@"%@",str);
    NSLog(@"Oee");
    
    NSLog(@"%@",delegate.parent.user_id);
    
    
    // Do any additional setup after loading the view.
    btnHwtoAct.hidden=NO;
    checkPopup=1;
    //    self.navigationController.navigationBarHidden=NO;
    NSLog(@"%@",@"real time data");
    
    [self addAttributedTextToTextView];
    
//    NSLog(@"%@",txtVwData.text);
//    NSLog(@"%@",txtVwData.attributedText);
    
    //    NSAttributedString *attributedString = txtVwData.attributedText;
    //    NSAttributedString *anotherAttributedString=[[NSMutableAttributedString alloc] initWithString:@"kaka"]; ;
    ////    NSAttributedString *anotherAttributedString = [[NSAttributedString alloc]initWithString: attributes:nil]; //@"kaka"; //the string which will replace
    //
    //    while ([txtVwWW.attributedText.string containsString:@"{'Device Name'}"]) {
    //        NSRange range = [attributedString.string rangeOfString:@"{'Device Name'}"];
    //[attributedString replaceCharactersInRange:range  withAttributedString:anotherAttributedString];
    //
    //    }
    
    
    
    
    //  txtVwData.attributedText= [ [txtVwData.attributedText string]  stringByReplacingOccurrencesOfString:@"{'Device Name'}"
    //        withString:@"kaka"];
    
    
    //str = [str stringByReplacingOccurrencesOfString:@"string"
    //withString:@"duck"];
    
    //    txtVwData.attributedText=[txtVwData.text stringByReplacingOccurrencesOfString:@"{'Device Name'}" withString:_strName];
    
    
    //    NSMutableAttributedString *newAttString999 = [[NSMutableAttributedString alloc] initWithString:[txtVwData.attributedText string]];
    //    [txtVwData.attributedText string]
    
    //    newAttString999 string
    
    
    
//    NSLog(@"%@",[txtVwData.attributedText string]);
//    NSLog(@"%@",txtVwData.attributedText);
    
    //
    //    [txtVwData.attributedText string];
    
    
    //{'Device Name'}
    
//    NSString *strText=[NSString stringWithFormat:@"1.     Open get.familytime.io in Browser, on your %@ device.\n2.     Download FamilyTime for Kids app on your child's device\n3.     When the app opens, log in with your account information.\n4.     Select 'Activate this device' and follow the on-screen instructions.\n 5.     Finish the set up on %@ device\n6.     Log back on this page after you are done there",_strName,_strName];
    
    //NSString *strText=[NSString stringWithFormat:@"1.     Open get.familytime.io in browser of kid's device.\n2.     Download FamilyTime for Kids app on your child's device\n3.     When the app opens, log in with your account information.\n4.     Select 'Activate this device' and follow the on-screen instructions.\n 5.     Finish the setup on your kid's device.\n6.     Log back on this page after you are done there"];
    
    /*
     1.     Open get.familytime.io in Browser, on your {'Device Name'} device.
     2.     Download FamilyTime for Kids app on your child's device
     3.     When the app opens, log in with your account information.
     4.     Select 'Activate this device' and follow the on-screen instructions.
     5.     Finish the set up on {'Device Name'} device
     6.     Log back on this page after you are done there
     
     
     1 and 5 are changed, made generic, after rejection from apple.
     
     1. Open get.familytime.io in browser of kid's device.
     5. Finish the setup on your kid's device.
     
     */
    
    //txtVwData.text=strText;
    
    //[self addAttributedTextToTextView];
    
//    if([_strtype isEqualToString:@"ios"])
//    {
//
//        NSMutableAttributedString *FinalAttString = [[NSMutableAttributedString alloc] initWithString:@"1. "];
//        [FinalAttString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,2)];
//
//        NSMutableAttributedString *newAttString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@ %@.\n\n",[@"Open get.familytime.io in Safari, on your" myModification],_strName,[@"device" myModification]]];
//
//
//        NSMutableAttributedString *FinalAttString2 = [[NSMutableAttributedString alloc] initWithString:@"2. "];
//        [FinalAttString2 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,2)];
//        NSMutableAttributedString *newAttString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n\n",[@"Download FamilyTime for Kids app on your child's device" myModification]]];
//        /////////
//        //            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//        //            paragraphStyle.alignment = NSTextAlignmentLeft;
//        //            [newAttString2 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, newAttString2.length)];
//
//        ///////
//
//        NSMutableAttributedString *FinalAttString3 = [[NSMutableAttributedString alloc] initWithString:@"3. "];
//        [FinalAttString3 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,2)];
//        NSMutableAttributedString *newAttString3 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n\n",[@"When the app opens, log in with your account information." myModification]]];
//
//        NSMutableAttributedString *FinalAttString4 = [[NSMutableAttributedString alloc] initWithString:@"4. "];
//        [FinalAttString4 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,2)];
//        NSMutableAttributedString *newAttString4 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n\n",[@"Select 'Activate this device' and follow the on-screen instructions." myModification]]];
//
//
//        NSMutableAttributedString *FinalAttString5 = [[NSMutableAttributedString alloc] initWithString:@"5. "];
//        [FinalAttString5 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,2)];
//        NSMutableAttributedString *newAttString5 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@ %@\n\n",[@"Finish the set up on " myModification],_strName,[@"device" myModification]]];
//
//        NSMutableAttributedString *FinalAttString6 = [[NSMutableAttributedString alloc] initWithString:@"6. "];
//        [FinalAttString6 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,2)];
//        NSMutableAttributedString *newAttString6 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",[@"Log back on this page after you are done there" myModification]]];
//
//
//        [FinalAttString appendAttributedString:newAttString];
//        [FinalAttString appendAttributedString:FinalAttString2];
//        [FinalAttString appendAttributedString:newAttString2];
//
//        [FinalAttString appendAttributedString:FinalAttString3];
//        [FinalAttString appendAttributedString:newAttString3];
//
//        [FinalAttString appendAttributedString:FinalAttString4];
//        [FinalAttString appendAttributedString:newAttString4];
//
//        [FinalAttString appendAttributedString:FinalAttString5];
//        [FinalAttString appendAttributedString:newAttString5];
//
//        [FinalAttString appendAttributedString:FinalAttString6];
//        [FinalAttString appendAttributedString:newAttString6];
//
//        //    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//        //    paragraphStyle.alignment = NSTextAlignmentLeft;
//        //    [FinalAttString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, FinalAttString.length)];
//
//        txtVwData.attributedText=FinalAttString;
//
//    }
//    else
//    {
//        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init] ;
//        [paragraphStyle setAlignment:NSTextAlignmentCenter];
//
//        NSMutableAttributedString *FinalAttString = [[NSMutableAttributedString alloc] initWithString:@"1. "];
//        [FinalAttString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,2)];
//
//
//        NSMutableAttributedString *newAttString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@ %@.\n\n",[@"Open get.familytime.io in Safari, on your" myModification],_strName,[@"device" myModification]]];
//        //attributes:@{NSParagraphStyleAttributeName:paragraphStyle}
//
//        NSMutableAttributedString *FinalAttString2 = [[NSMutableAttributedString alloc] initWithString:@"2. "];
//        [FinalAttString2 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,2)];
//        NSMutableAttributedString *newAttString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n\n",[@"Download FamilyTime for Kids app on your child's device" myModification]]];
//
//        NSMutableAttributedString *FinalAttString3 = [[NSMutableAttributedString alloc] initWithString:@"3. "];
//        [FinalAttString3 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,2)];
//        NSMutableAttributedString *newAttString3 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n\n",[@"When the app opens, log in with your account information." myModification]]];
//
//        NSMutableAttributedString *FinalAttString4 = [[NSMutableAttributedString alloc] initWithString:@"4. "];
//        [FinalAttString4 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,2)];
//        NSMutableAttributedString *newAttString4 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n\n",[@"Select 'Activate this device' and follow the on-screen instructions." myModification]]];
//
//
//        NSMutableAttributedString *FinalAttString5 = [[NSMutableAttributedString alloc] initWithString:@"5. "];
//        [FinalAttString5 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,2)];
//        NSMutableAttributedString *newAttString5 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@ %@\n\n",[@"Finish the set up on " myModification],_strName,[@"device" myModification]]];
//
//        NSMutableAttributedString *FinalAttString6 = [[NSMutableAttributedString alloc] initWithString:@"6. "];
//        [FinalAttString6 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,2)];
//        NSMutableAttributedString *newAttString6 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",[@"Log back on this page after you are done there" myModification]]];
//
//
//
//
//        [FinalAttString appendAttributedString:newAttString];
//        [FinalAttString appendAttributedString:FinalAttString2];
//        [FinalAttString appendAttributedString:newAttString2];
//
//        [FinalAttString appendAttributedString:FinalAttString3];
//        [FinalAttString appendAttributedString:newAttString3];
//
//        [FinalAttString appendAttributedString:FinalAttString4];
//        [FinalAttString appendAttributedString:newAttString4];
//
//        [FinalAttString appendAttributedString:FinalAttString5];
//        [FinalAttString appendAttributedString:newAttString5];
//
//        [FinalAttString appendAttributedString:FinalAttString6];
//        [FinalAttString appendAttributedString:newAttString6];
//
//
//        txtVwData.attributedText=FinalAttString;
//
//    }
    
    
    //     if(IS_IPHONE_5)
    //     {
    //         if([_strtype isEqualToString:@"ios"])
    //         {
    //             NSString *strText=[NSString stringWithFormat:@"1.Open get.familytime.io in Safari, on your %@ device.\n2.Download FamilyTime for Kids app on your child's device\n3.When the app opens, log in with your account information.\n4.Select 'Activate this device' and follow the on-screen instructions.\n5.Finish the set up on %@ device\n6.Log back on this page after you are done there",_strName,_strName];
    //             txtVwData.text=strText;
    //
    //         }
    //         else
    //         {
    //             NSString *strText=[NSString stringWithFormat:@"1.Open get.familytime.io in Chrome, on your %@ device.\n2.Download FamilyTime for Kids app on your child's device\n3.When the app opens, log in with your account information.\n4.Select 'Activate this device' and follow the on-screen instructions.\n5.Finish the set up on %@ device\n6.Log back on this page after you are done there",_strName,_strName];
    //             txtVwData.text=strText;
    //
    //         }
    //
    //     }
    // */
    
    
    //    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:txtVwData.text];
    //    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,2)];
    //    [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(10,7)];
    //    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0] range:NSMakeRange(20, 10)];
    //    label.attributedText = str;
    //    txtVwData.attributedText=str;
    
    //    txtVwData.attributedText=@"Online HTML Editor, Text to HTML Converter FreeDownload example.htmldownload HTML code as f";
    
//    if(IS_IPHONE_5)
//    {
//        txtVwData.font= [UIFont fontWithName:@"OpenSans" size:15];
//    }
//    else if(IS_IPHONE_6)
//    {
//        txtVwData.font= [UIFont fontWithName:@"OpenSans" size:16];
//    }
//    else if(IS_IPHONE_6_PLUS)
//    {
//        txtVwData.font= [UIFont fontWithName:@"OpenSans" size:18];
//    }
//    else if(IS_IPHONE_X)
//    {
//        txtVwData.font= [UIFont fontWithName:@"OpenSans" size:20];
//    }
//    else
//    {
//        txtVwData.font= [UIFont fontWithName:@"OpenSans" size:25];
//    }
    
    //mustafa
    //    NSString *strText2=[NSString stringWithFormat:@"1.Open get.familytime.io in Chrome, on your %@ device.\n2.Download FamilyTime for Kids app on your child's device\n3.When the app opens, log in with your account information.\n4.Select 'Activate this device' and follow the on-screen instructions.\n5.Finish the set up on %@ device\n6.Log back on this page after you are done there",_strName,_strName];
    //    txtVwData.text=strText2;
    //txtVwWW.text=strText2;
    
    
    
    txtVwData.adjustsFontSizeToFitWidth=YES;
    // */
//    btnHwtoAct.layer.cornerRadius=btnHwtoAct.frame.size.height/2.0;
//    btnHwtoAct.layer.masksToBounds=YES;
    
//    btnYesIdo.layer.cornerRadius=btnYesIdo.frame.size.height/2.0;
//    btnYesIdo.layer.masksToBounds=YES;
    [btnYesIdo setHidden:YES];
    
    
//    [FIRAnalytics logEventWithName:@"device_type"
//                        parameters:@{
//                                     @"stage":@"step3"
//                                     }];


    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//---SANA CHANGE---//

-(void)addAttributedTextToTextView
{


    CGFloat normalTextSize = 17.0;
    CGFloat boldTextSize = 15.0;
    if(([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad))
    {
        normalTextSize = 25.0;
        boldTextSize = 20.0;
    }


    NSString *point1 = @" On your child's device, open the following link in safari: get.familytime.io\n\n";
    NSString *point2 = @" Download FamilyTime Jr. app on your child's device.\n\n";
    NSString *point3 = @" When the app opens, log in with your account information.\n\n";
    NSString *point4 = @" Select Activate this device and follow the on-screen instructions.\n\n";
    NSString *point5 = @" Come back here when you have finished the setup on your child's device.\n\n";

    NSAttributedString *p_1_1 = [@"1." attributedString:@[@"1."] color:[UIColor FTOragneColor] font:[UIFont appFontWithType:FontTypeBold size:normalTextSize]];
    NSAttributedString *p_1_2 = [point1 attributedString:@[@"get.familytime.io"] color:[UIColor FTOragneColor] font:[UIFont appFontWithType:FontTypeSemiBold size:boldTextSize]];
    NSMutableAttributedString *p_1_final = [[NSMutableAttributedString alloc] initWithAttributedString:p_1_1];
    [p_1_final appendAttributedString:p_1_2];

    NSAttributedString *p_2_1 = [@"2." attributedString:@[@"2."] color:[UIColor FTOragneColor] font:[UIFont appFontWithType:FontTypeBold size:normalTextSize]];
    NSAttributedString *p_2_2 = [point2 attributedString:@[@"FamilyTime Jr."] color:[UIColor blackColor] font:[UIFont appFontWithType:FontTypeSemiBold size:boldTextSize]];
    NSMutableAttributedString *p_2_final = [[NSMutableAttributedString alloc] initWithAttributedString:p_2_1];
    [p_2_final appendAttributedString:p_2_2];

    NSAttributedString *p_3_1 = [@"3." attributedString:@[@"3."] color:[UIColor FTOragneColor] font:[UIFont appFontWithType:FontTypeBold size:normalTextSize]];
    NSMutableAttributedString *p_3_final = [[NSMutableAttributedString alloc] initWithAttributedString:p_3_1];
    [p_3_final appendAttributedString:[[NSAttributedString alloc] initWithString:point3]];

    NSAttributedString *p_4_1 = [@"4." attributedString:@[@"4."] color:[UIColor FTOragneColor] font:[UIFont appFontWithType:FontTypeBold size:normalTextSize]];
    NSAttributedString *p_4_2 = [point4 attributedString:@[@"Activate this device"] color:[UIColor blackColor] font:[UIFont appFontWithType:FontTypeSemiBold size:boldTextSize]];
    NSMutableAttributedString *p_4_final = [[NSMutableAttributedString alloc] initWithAttributedString:p_4_1];
    [p_4_final appendAttributedString:p_4_2];

    NSAttributedString *p_5_1 = [@"5." attributedString:@[@"5."] color:[UIColor FTOragneColor] font:[UIFont appFontWithType:FontTypeBold size:normalTextSize]];
    NSMutableAttributedString *p_5_final = [[NSMutableAttributedString alloc] initWithAttributedString:p_5_1];
    [p_5_final appendAttributedString:[[NSAttributedString alloc] initWithString:point5]];

    NSMutableAttributedString *finalText = [[NSMutableAttributedString alloc] initWithAttributedString:p_1_final];
    [finalText appendAttributedString:p_2_final];
    [finalText appendAttributedString:p_3_final];
    [finalText appendAttributedString:p_4_final];
    [finalText appendAttributedString:p_5_final];
    
    txtVwData.attributedText = finalText;
    
}


-(IBAction)YesIdoneIt:(id)sender
{
    //    NSString * storyboardName = @"MyStoryboard";
    //    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: [NSBundle mainBundle]];
    //
    //    AddDeviceNewViewController3 *controller  = [storyboard instantiateViewControllerWithIdentifier:@"AddDeviceNewViewController3"];
    //
    //    [self.navigationController pushViewController:controller animated:YES];
    //
    
//    [self loadDashboard];
    if (![[[[UIApplication sharedApplication] keyWindow] rootViewController] isKindOfClass:JASidePanelController.class]) {
        
        [delegate setupDrawer:0];
        
    }else {
        
        [self dissmisshere];
        
    }
    
}

-(void)dissmisshere
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"RemoveStepsPrevious"
     object:self];
    
    //---IOS 13 MODEL SCREEN ISSUE---//
    
//    [self dismissViewControllerAnimated:YES completion:^{
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"RELOAD_DASHBOARD" object:nil];
//    }];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RELOAD_DASHBOARD" object:nil];
//    [self.navigationController popToRootViewControllerAnimated:YES];
 
    //---IOS 13 MODEL SCREEN ISSUE---//
    
    
    
    if([self presentingViewController])
        [self dismissViewControllerAnimated:YES completion:nil];
    else
        [self.navigationController popToRootViewControllerAnimated:YES];
    
    //---CAN USE BELOW LINE TOO TO CHECK IF PRESENTED OR PUSHED---//
//        if([[[self navigationController] presentingViewController] presentedViewController] == [self navigationController])
//            [self dismissViewControllerAnimated:YES completion:nil];

}



-(IBAction)howtoActivate:(id)sender
{
    
    btnHwtoAct.hidden = YES;
    btnYesIdo.hidden  = NO;
    //    if ([delegate respondsToSelector:@selector(handleHowToInstall)])
    //    {
    //        [delegate handleHowToInstall];
    //    }
    [self handleHowToInstall];
    
}

- (void)handleHowToInstall
{

    //userlanguage
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    // getting an NSString
    NSString *userlanguage = [prefs stringForKey:@"userlanguage"];

    NSString *myString;

    if ([_urlString isEqualToString:@"iOS"]){
        if ([userlanguage isEqualToString:@"en"]){

            myString = @"https://familytime.io/how-to-install/child-app-on-ios.html?utm_source=dashboard&amp;utm_medium=android&amp;utm_campaign=ActivateChild";
        }else{

            myString = [NSString stringWithFormat:@"https://familytime.io/%@/how-to-install/child-app-on-ios.html?utm_source=dashboard&amp;utm_medium=android&amp;utm_campaign=ActivateChild",userlanguage];
        }


        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:myString]];
    }else if([_urlString isEqualToString:@"Android"]){

        if ([userlanguage isEqualToString:@"en"]){

            myString = @"https://familytime.io/how-to-install/child-app-on-android.html?utm_source=dashboard&amp;utm_medium=android&amp;utm_campaign=ActivateChild";
        }else{

            myString = [NSString stringWithFormat:@"https://familytime.io/%@/how-to-install/child-app-on-android.html?utm_source=dashboard&amp;utm_medium=android&amp;utm_campaign=ActivateChild",userlanguage];
        }

        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:myString]];


    }else{
        if ([userlanguage isEqualToString:@"en"]){

            myString = @"https://familytime.io/how-to-install/child-app-on-ios.html?utm_source=dashboard&amp;utm_medium=android&amp;utm_campaign=ActivateChild";
        }else{

            myString = [NSString stringWithFormat:@"https://familytime.io/%@/how-to-install/child-app-on-ios.html?utm_source=dashboard&amp;utm_medium=android&amp;utm_campaign=ActivateChild",userlanguage];
        }

        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:myString]];
    }
}

-(IBAction)btnBack:(id)sender
{
    //self.navigationController.navigationBarHidden
//    [self.navigationController popViewControllerAnimated:YES];
//    if (![[[[UIApplication sharedApplication] keyWindow] rootViewController] isKindOfClass:JASidePanelController.class]) {
//        AppDelegate *appDeleg = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//        [appDeleg setupDrawer: 0];
//    } else {
//        [self dissmisshere];
//    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden=YES;
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    if(checkPopup==2)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) goBackNotification:(NSNotification *) notification
{
    // [notification name] should always be @"TestNotification"
    // unless you use this method for observation of other notifications
    // as well.
    
    //    if ([[notification name] isEqualToString:@"TestNotification"])
    //        NSLog (@"Successfully received the test notification!");
    
    //    [self SkipButton:nil];
    //
    
    [self.navigationController popViewControllerAnimated:YES];
    
    //    [self dismissViewControllerAnimated:YES completion:^{
    //        [[NSNotificationCenter defaultCenter] postNotificationName:@"RELOAD_DASHBOARD" object:nil];
    //    }];
    
}

@end
