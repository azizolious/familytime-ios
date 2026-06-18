//
//  ForgotPassViewController.h
//  FamilyTime
//
//  Created by Sora Code on 11/18/14.
//  Copyright (c) 2014 SoraCode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SingleLineTextField.h"
#import "FamilyTime-Swift.h"

@interface InviteCoparentViewController : BaseViewController <UITextFieldDelegate>
{

    int check;
}
//@property (weak, nonatomic) IBOutlet UITextField *txtEmail;

@property (weak, nonatomic) IBOutlet SkyFloatingLabelTextField *txtName;

@property (weak, nonatomic) IBOutlet SkyFloatingLabelTextField *txtEmail;
@property (weak, nonatomic) IBOutlet UIButton *submitbuuton;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblSubtitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgview;

@property (weak, nonatomic) IBOutlet UIImageView *imgviewNew;



-(IBAction)resetPsw:(id)sender;

@end
