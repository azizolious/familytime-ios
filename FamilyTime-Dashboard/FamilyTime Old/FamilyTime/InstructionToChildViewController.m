//
//  InstructionToChildViewController.m
//  FamilyTime - Dashboard
//
//  Created by Ahmad on 10/12/17.
//  Copyright © 2017 YumyApps. All rights reserved.
//

#import "InstructionToChildViewController.h"

@interface InstructionToChildViewController ()

@end

@implementation InstructionToChildViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    _btn1.clipsToBounds = YES;
    _btn1.layer.cornerRadius=_btn1.frame.size.height/2;


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

-(IBAction)doneBtn:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
//        [delegate setupDrawer:0];

}
@end
