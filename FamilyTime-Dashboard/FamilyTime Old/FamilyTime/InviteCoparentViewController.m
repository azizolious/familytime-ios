//
//  ForgotPassViewController.m
//  FamilyTime
//
//  Created by Sora Code on 11/18/14.
//  Copyright (c) 2014 SoraCode. All rights reserved.
//

#import "InviteCoparentViewController.h"
#import "AppDelegate.h"
#import "CommonModel.h"
//#import "JSONHTTPClient.h"
#import "UIViewController+Keyboard.h"
#import "MBProgressHUD.h"
//#import "ParentLoginViewController.h"
//#import <Google/Analytics.h>
#import "FTUtils.h"
#import "NSString+LockMustafa.h"
#import "Constant.h"
#import "FamilyTime-Swift.h"

AppDelegate *delegate;

@interface InviteCoparentViewController ()

//@property (nonatomic,strong) ParentLoginViewController *loginCont;

@end

@implementation InviteCoparentViewController


-(void)resetPsw:(id)sender
{
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    _imgviewNew.hidden=YES;
    
    
    [ZendeskChatManager trackEvent:@"Invite Coparent Screen"];
    
    //    _lblSubtitle.adjustsFontSizeToFitWidth=YES;
    
    //    _imgview.translatesAutoresizingMaskIntoConstraints=YES;
    
    //    [_imgview setFrame:CGRectMake(_imgview.frame.origin.x, _imgview.frame.origin.y, 130.0, 130.0)];
        
    [self.navigationController.navigationBar setHidden:NO];
    
    // register for keyboard notifications
    [CommonModel addKeyBoardObserver:self];
    
    //    [self.txtEmail setLineColor:[UIColor colorWithRed:175.0/255.0f green:89.0/255.0f blue:167.0/255.0f alpha:1.0]];
    //
    //    [self.txtEmail setSelectedLineColor:[UIColor colorWithRed:175.0/255.0f green:89.0/255.0f blue:167.0/255.0f alpha:1.0]];
    
    //    self.txtEmail.tintColor=[UIColor colorWithRed:175.0/255.0f green:89.0/255.0f blue:167.0/255.0f alpha:1.0];
    
    //   self.txtEmail.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5f].CGColor;
    //    self.txtEmail.layer.borderWidth = 0.5f;
    //    [self.txtEmail setLineSelectedColor:[UIColor purpleColor]];
    
    
    _lblSubtitle.text=[_lblSubtitle.text myModification];
    
   // _txtName.placeholder=[@"NAME" myModification];
    //_txtEmail.placeholder=[@"EMAIL" myModification];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [CommonModel removeKeyBoardObserver:self];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_submitbuuton setTitle:[@"Send Invitation" myModification] forState:UIControlStateNormal];
    
    [_txtEmail setPlaceholder:NSLocalizedString(@"Email", nil)];
    [_txtName setPlaceholder:NSLocalizedString(@"Name", nil)];
    
    check=0;
    [self.navigationItem setTitle:[@"Invite Parent" myModification]];
    self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                                                         initWithTitle:[@"Back" myModification] style:UIBarButtonItemStylePlain target:nil action:nil];
    
    //    self.loginCont = [[ParentLoginViewController alloc] initWithNibName:@"ParentLoginViewController" bundle:nil];
    
    //    self.oldPswTF.delegate = self;
    //    self.PswTF.delegate = self;
    //    self.conPswTF.delegate = self;
    //    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    //    self.oldPswTF.leftView = paddingView;
    //    self.oldPswTF.leftViewMode = UITextFieldViewModeAlways;
    //    paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    //    self.PswTF.leftView = paddingView;
    //    self.PswTF.leftViewMode = UITextFieldViewModeAlways;
    //    paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    //    self.conPswTF.leftView = paddingView;
    //    self.conPswTF.leftViewMode = UITextFieldViewModeAlways;
    // Do any additional setup after loading the view from its nib.
    
    // self.txtEmail.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.txtEmail.superview.frame), [self autoLayoutHeightWithPoints:170]);
    
    
    _submitbuuton.layer.cornerRadius = _submitbuuton.frame.size.height/2.0;
    _submitbuuton.layer.masksToBounds = YES;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)SendInvitationButton:(id)sender
{
    if(check==0)
    {
        [self handleSave];
    }
    else
    {
        [self UnHideAll];
    }
}

#pragma mark - TextField Delegates
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //    if (textField == self.oldPswTF)
    //        [self.PswTF becomeFirstResponder];
    //    else if (textField == self.PswTF)
    //        [self.conPswTF becomeFirstResponder];
    //    else
    //        [self.conPswTF resignFirstResponder];
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    //    if ([sender isEqual:self.oldPswTF] || [sender isEqual:self.PswTF] || [sender isEqual:self.conPswTF])
    //    {
    //        //move the main view, so that the keyboard does not hide it.
    //        if  (self.view.frame.origin.y >= 0)
    //        {
    //            [self setViewMovedUp:YES];
    //        }
    //    }
}
- (BOOL)validateEmailWithString:(NSString*)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (CGFloat)autoLayoutHeightWithPoints:(CGFloat)position
{
    CGFloat pointsPerPercent = 2208.0f/100.0f;
    CGFloat positionInPercent = position/pointsPerPercent;
    
    CGFloat height = CGRectGetHeight(self.view.bounds);
    return (height/100.0f) * positionInPercent;
}

-(void)gradient
{
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = _submitbuuton.bounds;
    gradient.colors = @[(id)[UIColor whiteColor].CGColor, (id)[UIColor blackColor].CGColor];
    //    [_submitbuuton addSubview:gradient];
    
}




- (void)handleSave
{
    //    [SwiftFTUtils showHUDAddedTo:self.view withText:@"loading..." animated:YES];
    //    NSString *url = [NSString stringWithFormat:@"https://mesh.familytime.io/v2/ftd/user/invite"];
    
    if(self.txtName.text.length == 0)
        [CommonModel showAlert:@"" msg:[@"Please enter valid name" myModification]];
    else if(![self validateEmailWithString:_txtEmail.text]){
        [CommonModel showAlert:@"" msg:[@"Please enter valid email" myModification]];
    }
    else{
        
        //---MESH 2 API CALL---//
        [SwiftFTUtils showHUDAddedTo:self.view withText:[@"loading..." myModification] animated:YES];
        
        NSDictionary *params = @{@"email" : self.txtEmail.text,
                                 @"name"  : self.txtName.text
                                 };
        
        NSLog(@"params = %@ and url = %@", params, kInvite_Coparent_mesh2);
        
        [[ApiManager shared] postApiWithVC:self isPresentedCont:NO andParams:params withApi:kInvite_Coparent_mesh2 withResponse:^(NSString * _Nonnull message, NSInteger statusCode) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [SwiftFTUtils hideHUDAddedTo:self.view animated:YES];
                
                NSLog(@"invite coparent msg = %@ and status code = %ld", message, (long)statusCode);
                
                if(statusCode == 200)
                    [self HideAll];
                else
                    [CommonModel showAlert:@"" msg:message];
            });
            
            
        }];
    }
        
    
    //---DEPRICATED---//
    /*
    
    if([self validateEmailWithString:_txtEmail.text])
    {
        [SwiftFTUtils showHUDAddedTo:self.view withText:[@"loading..." myModification] animated:YES];
        //        NSString *url = [NSString stringWithFormat:@"https://mesh.familytime.io/v2/ftd/user/invite"];
        NSString *url = [NSString stringWithFormat:@"%@%@",kBasUrl,Api_Invite_coparent];
        
        
        NSDictionary *params = @{@"user_id":delegate.parent.user_id,@"email":_txtEmail.text,@"name":_txtName.text};
        
        NSString *jsonString;
        {
            
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params
                                                               options:NSJSONWritingPrettyPrinted // Pass 0 if you don't  care about the readability of the generated string
                                                                 error:&error];
            
            if (! jsonData) {
                NSLog(@"Got an error: %@", error);
            } else {
                jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                NSLog(@"%@", jsonString);
            }
        }
        
        [JSONHTTPClient postJSONFromURLWithString:url bodyString:jsonString completion:^(id json, JSONModelError *err) {
            //NSError *error;
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            
            NSLog(@"%@",json);
            if([[json valueForKey:@"status_code"] intValue] == 200)
            {
                [self HideAll];
                //                    [CommonModel showAlert:@"" msg:[json valueForKey:@"response"]];
            }
            else
            {
                [CommonModel showAlert:@"" msg:[json valueForKey:@"response"]];
            }
            
        }];
        
    }
    else
    {
        [CommonModel showAlert:@"" msg:[@"Please enter valid email" myModification]];
    }
     
     */
}


-(void)HideAll
{
    
    
    //    [_imgview setFrame:CGRectMake(_imgview.frame.origin.x, _imgview.frame.origin.y+150, _imgview.frame.size.width, _imgview.frame.size.height)];
    
    
    [_txtEmail resignFirstResponder];
    [_txtName resignFirstResponder];
    
    _imgviewNew.hidden=YES;
    _imgview.hidden=NO;
    
    check=1;
    [_lblSubtitle setTextColor:[UIColor darkTextColor]];
    
    _lblSubtitle.text=[NSString stringWithFormat:[@"Invitation sent to %@. Please ask them to verify and create the FamilyTime account, so that they can manage kids from their own device." myModification],_txtEmail.text];
    [_submitbuuton setTitle:[@"Send Another Invite" myModification] forState:UIControlStateNormal];
    
    _lblTitle.hidden=YES;
    _txtEmail.hidden=YES;
    _txtName.hidden=YES;
    
    
    //    _imgview.hidden=NO;
    _lblSubtitle.hidden=NO;
    _submitbuuton.hidden=NO;
    
    
    [_imgview setImage:[UIImage imageNamed:@"send_invite_icon"]];
    [_imgviewNew setImage:[UIImage imageNamed:@"send_invite_icon"]];
    
}
-(void)UnHideAll
{
    [_lblSubtitle setTextColor:[UIColor darkTextColor]];
    
    
    //    [_imgview setFrame:CGRectMake(_imgview.frame.origin.x, _imgview.frame.origin.y-150, _imgview.frame.size.width, _imgview.frame.size.height)];
    
    _txtName.hidden=NO;
    _txtName.text=@"";
    
    _txtEmail.text=@"";
    _imgviewNew.hidden=YES;
    _imgview.hidden=NO;
    
    check=0;
    _lblSubtitle.text=[@"Invite another parent or guardian to access your FamilyTime account from their own device." myModification];
    [_submitbuuton setTitle:[@"Send Invitation" myModification] forState:UIControlStateNormal];
    
    
    _lblTitle.hidden=NO;
    _lblSubtitle.hidden=NO;
    //    _imgview.hidden=NO;
    _txtEmail.hidden=NO;
    _submitbuuton.hidden=NO;
    
    [_imgview setImage:[UIImage imageNamed:@"invite_icon"]];
    
}



@end
