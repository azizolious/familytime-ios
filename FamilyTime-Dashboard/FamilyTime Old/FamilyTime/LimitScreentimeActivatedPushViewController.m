//
//  LimitScreentimeActivatedPushViewController.m
//  FamilyTime - Dashboard
//
//  Created by Ahmad on 8/30/17.
//  Copyright © 2017 YumyApps. All rights reserved.
//

#import "LimitScreentimeActivatedPushViewController.h"
#import "NSString+LockMustafa.h"

@interface LimitScreentimeActivatedPushViewController ()

@end

@implementation LimitScreentimeActivatedPushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _submitbuuton.layer.cornerRadius = _submitbuuton.frame.size.height/2.0;
    _submitbuuton.layer.masksToBounds = YES;

    self.lblTitle.text    = self.title;
    self.lblSubTitle.text = self.subTitle;
    
//    _lblFirstLine.text = [NSString stringWithFormat:@"FamilyTime is paused on %@. this device remain unavailable unless you lock it.",_strDeviceName];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}


-(IBAction)OkButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];

}

@end
