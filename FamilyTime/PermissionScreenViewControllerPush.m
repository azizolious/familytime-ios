//
//  PermissionScreenViewControllerPush.m
//  FamilyTime
//
//  Created by Ahmad Mustafa on 03/05/2018.
//  Copyright © 2018 YumyApps. All rights reserved.
//

#import "PermissionScreenViewControllerPush.h"
#import "NSString+LockMustafa.h"

@interface PermissionScreenViewControllerPush ()

@end

@implementation PermissionScreenViewControllerPush

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _lblTitleName.text=_strDeviceName;
    _lblFirstLine.text=[NSString stringWithFormat:@"%@ %@ %@",[@"Open FamilyTime on your" myModification],_strDeviceName,[@"device" myModification]];
//"Take Me There"
    _lbl2.text=[NSString stringWithFormat:@"%@\"%@\" ",[@"Permission pop-up will come up, tap on" myModification],[@"Take Me There" myModification]];
    _lbl3.text=[_lbl3.text myModification];
    _lbl4.text=[_lbl4.text myModification];
    _lbl5.text=[_lbl5.text myModification];
    _lbl6.text=[_lbl6.text myModification];

    
    _lblHead.text=[_lblHead.text myModification];
    _lblSubHead.text=[_lblSubHead.text myModification];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark CLOSE BUTTON
-(IBAction)OkButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
