//
//  AddDeviceNewViewController2.m
//  FamilyTime - Dashboard
//
//  Created by Ahmad on 10/18/17.
//  Copyright © 2017 YumyApps. All rights reserved.
//

#import "AddDeviceNewViewController2.h"
#import "AddDeviceNewViewController3.h"
//#import "NotSureAdddevice3ViewController.h"
#import "NSString+LockMustafa.h"

#import "FamilyTime-Swift.h"


@interface AddDeviceNewViewController2 ()

@end

@implementation AddDeviceNewViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    check=1;
    
    _lbl_ios.text=[@"iOS" myModification];
    _lbl_android.text=[@"Android" myModification];
    _lbl_notsure.text=[@"I am not sure" myModification];

    
    [btnSkip setTitle:[@"Skip" myModification] forState:UIControlStateNormal];
    [btnNext setTitle:[@"NEXT" myModification] forState:UIControlStateNormal];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"RemoveSteps"
                                               object:nil];
    
    [self buttonCheck1:nil];
    
//    
//    [FIRAnalytics logEventWithName:@"device_type"
//                        parameters:@{
//                                     @"stage":@"step2"
//                                     }];
}

- (void) receiveNotification:(NSNotification *) notification
{
    // [notification name] should always be @"TestNotification"
    // unless you use this method for observation of other notifications
    // as well.
    
//    if ([[notification name] isEqualToString:@"TestNotification"])
//        NSLog (@"Successfully received the test notification!");
    
    [self SkipButton:nil];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    _imgtick1.image=[UIImage imageNamed:@"ic_check"];
    _imgtick2.image=[UIImage imageNamed:@""];
    _imgtick3.image=[UIImage imageNamed:@""];
    
//    btnSkip.hidden=YES;

    self.navigationController.navigationBarHidden=YES;

    _lblTitle.text=[NSString stringWithFormat:@"%@ \"%@\"",[@"Next add a device for" myModification],_strName];
    _lblSubTitle.text=[NSString stringWithFormat:@"%@ %@ %@",[@"Choose the device" myModification],_strName,[@"has to see setup instructions." myModification]];

    if([_strCheck isEqualToString:@"Skip"])
    {
        btnSkip.hidden=NO;
    }
    else
    {
        btnSkip.hidden = YES;
    }
    
//    btnNext.layer.clip

    btnNext.layer.cornerRadius=btnNext.frame.size.height/2.0;
    btnNext.layer.masksToBounds=YES;
    
    btnSkip.layer.cornerRadius=btnSkip.frame.size.height/2.0;
    btnSkip.layer.masksToBounds=YES;
    
    
//    btnNext.backgroundColor= [UIColor colorWithRed:255.0/255.0 green:162.0/255.0
//                                              blue:23.0/255.0 alpha:1.0];
//    
    [UIColor colorWithRed:255.0/255.0 green:162.0/255.0
                     blue:23.0/255.0 alpha:1.0];
    
    
    [UIColor colorWithRed:167.0/255.0 green:178.0/255.0
                     blue:182.0/255.0 alpha:1.0];

    
    [self buttonCheck1:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(IBAction)NextToThirdScreen:(id)sender
{
    
    if(check==1)
    {
        [self NextAndroid];
    }
    else if(check==2)
    {
        [self NextIOS];
        
    }
    else
    {
        [self NotSureScreen];

    }
    
//    NSString * storyboardName = @"Steps";
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: [NSBundle mainBundle]];
//    
//    AddDeviceNewViewController3 *controller  = [storyboard instantiateViewControllerWithIdentifier:@"AddDeviceNewViewController3"];
//    
//    [self.navigationController pushViewController:controller animated:YES];

    /*
    NSString * storyboardName = @"Steps";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: [NSBundle mainBundle]];

    NotSureAdddevice3ViewController *controller  = [storyboard instantiateViewControllerWithIdentifier:@"NotSureAdddevice3ViewController"];
    
    [self.navigationController pushViewController:controller animated:YES];
     */
    //NotSureAdddevice3ViewController
}
-(void)NextIOS
{
    NSString * storyboardName = @"Steps";
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
    storyboardName=@"Steps_Ipad";
    
    }
    else
    {
        
    }
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: [NSBundle mainBundle]];
    
    AddDeviceNewViewController3 *controller  = [storyboard instantiateViewControllerWithIdentifier:@"AddDeviceNewViewController3"];
    controller.strName=_strName;
    controller.strtype=@"ios";

    [self.navigationController pushViewController:controller animated:YES];
}

-(void)NextAndroid
{
    NSString * storyboardName = @"Steps";
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
        storyboardName=@"Steps_Ipad";
        }
    else
        {
        
        }
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: [NSBundle mainBundle]];
    
    AddDeviceNewViewController3 *controller  = [storyboard instantiateViewControllerWithIdentifier:@"AddDeviceNewViewController3"];
    controller.strName=_strName;
    controller.strtype=@"Android";
    
    [self.navigationController pushViewController:controller animated:YES];
  
}

-(void)NotSureScreen
{
    NSString * storyboardName = @"Steps";
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
        storyboardName=@"Steps_Ipad";
        
        }
    else
        {
        
        }
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: [NSBundle mainBundle]];
    
//    NotSureAdddevice3ViewController *controller  = [storyboard instantiateViewControllerWithIdentifier:@"NotSureAdddevice3ViewController"];
//
//    [self.navigationController pushViewController:controller animated:YES];


}

-(IBAction)buttonCheck1:(id)sender
{
    check=1;
    
    _viewLine1.backgroundColor=[UIColor colorWithRed:255.0/255.0 green:162.0/255.0
                                                blue:23.0/255.0 alpha:1.0];
    _viewLine2.backgroundColor=[UIColor lightGrayColor];
    _viewLine3.backgroundColor=[UIColor lightGrayColor];
    
    _imgtick1.image=[UIImage imageNamed:@"ic_check"];
    _imgtick2.image=[UIImage imageNamed:@""];
    _imgtick3.image=[UIImage imageNamed:@""];

}
-(IBAction)buttonCheck2:(id)sender
{
    check=2;

    _viewLine1.backgroundColor=[UIColor lightGrayColor];
    _viewLine2.backgroundColor=[UIColor colorWithRed:255.0/255.0 green:162.0/255.0
                                                blue:23.0/255.0 alpha:1.0];
    _viewLine3.backgroundColor=[UIColor lightGrayColor];
    
    _imgtick1.image=[UIImage imageNamed:@""];
    _imgtick2.image=[UIImage imageNamed:@"ic_check"];
    _imgtick3.image=[UIImage imageNamed:@""];

}
-(IBAction)buttonCheck3:(id)sender
{
    check=3;

    _viewLine1.backgroundColor=[UIColor lightGrayColor];
    _viewLine2.backgroundColor=[UIColor lightGrayColor];
    _viewLine3.backgroundColor=[UIColor colorWithRed:255.0/255.0 green:162.0/255.0
                                                blue:23.0/255.0 alpha:1.0];

    _imgtick1.image=[UIImage imageNamed:@""];
    _imgtick2.image=[UIImage imageNamed:@""];
    _imgtick3.image=[UIImage imageNamed:@"ic_check"];

}

-(IBAction)SkipButton:(id)sender
{
    [self dissmisshere];
}

-(void)dissmisshere
{
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RELOAD_DASHBOARD" object:nil];
    }];
}

@end
