//
//  HelpViewController.m
//  FamilyTime - Dashboard
//
//  Created by Muhammad Ajmal on 18/01/2016.
//  Copyright © 2016 SoraCode. All rights reserved.
//

#import "HelpViewController.h"
#import "FTUtils.h"
#import "NSString+LockMustafa.h"

#import <ZendeskCoreSDK/ZendeskCoreSDK.h>
#import "Constant.h"
#import "AppDelegate.h"
#import "NSString+LockMustafa.h"
#import "ViewController.h"
#import "AppDelegate.h"
#import "FamilyTime-Swift.h"

#import "IQKeyboardManager.h"

#define RGBCOLOR(R,G,B, A) [UIColor colorWithRed:R/255.2f green:G/255.2f blue:B/255.2f alpha:A]


static const float CHAT_BUTTON_CORNER_RADIUS = 4.0f;
static const float CHAT_BUTTON_BORDER_WIDTH = 1.0f;


#define CHAT_VC_BTN_BACKGROUND [UIColor colorWithWhite:0.95f alpha:1.0f]
#define CHAT_BTN_TITLE_NORMAL [UIColor colorWithWhite:0.2627f alpha:1.0f]
#define CHAT_BTN_TITLE_HIGHLIGHT [UIColor colorWithWhite:0.2627f alpha:0.3f]
#define CHAT_BTN_BORDER [UIColor colorWithWhite:0.8470f alpha:1.0f]




AppDelegate *delegate;


@interface HelpViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *createTicket;
@property (nonatomic, strong) UIButton *myTickets;
@property (nonatomic, strong) UIButton *helpCenter;
@end

@implementation HelpViewController

- (void) presetData
{
    NSString *strUserEmail= [[NSUserDefaults standardUserDefaults]objectForKey:kUserEmail];
    NSString *timestamp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    NSString *name = [NSString stringWithFormat:@"Preconfig %@", timestamp];

    [ZendeskChatManager updateVisitorWithName:name email:strUserEmail phoneNumber:timestamp note:@"This is another note"];
    [ZendeskChatManager startChatOn:self.navigationController event:@"Chat button pressed: (pre-set data)" preChatFormEnabled:YES];
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
//    [[ZDKConfig instance] initializeWithAppId:@"754abc37f24b4e7447f58b3d3269f5c15a2c0c2dac8b4327" zendeskUrl:@"https://familytime.zendesk.com" clientId:@"mobile_sdk_client_6bd39d87391a41bd5860"];

    NSString *strUserEmail= [[NSUserDefaults standardUserDefaults]objectForKey:kUserEmail];
    
//    ZDKAnonymousIdentity *identity = [ZDKAnonymousIdentity new];
//    identity.name  = delegate.parent.name;
//    identity.email = strUserEmail;
//    [ZDKConfig instance].userIdentity = identity;
    
    [ZendeskChatManager initializeChat];
    [ZendeskChatManager updateVisitorWithName:delegate.parent.name email:strUserEmail phoneNumber:@"" note:nil];
    

    
//    [[ZDKConfig instance] initializeWithAppId:@"754abc37f24b4e7447f58b3d3269f5c15a2c0c2dac8b4327" zendeskUrl:@"https://familytime.zendesk.com" clientId:@"mobile_sdk_client_6bd39d87391a41bd5860"];

    
    self.title = [@"Help" myModification];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [ZendeskChatManager trackEvent:@"Help Screen"];
    
    [[IQKeyboardManager sharedManager] setEnable:true];

 //   _btnHelpCentre setTitle:<#(nullable NSString *)#> forState:<#(UIControlState)#>
//    [_btnHelpCentre setImage:[UIImage imageNamed:@"help_center"] forState:UIControlStateNormal];
//    [_btnMyTickets setImage:[UIImage imageNamed:@"my_tickets"] forState:UIControlStateNormal];
//    [_btnLiveChat setImage:[UIImage imageNamed:@"live_chat"] forState:UIControlStateNormal];
//    [_btnGiveFeedback setImage:[UIImage imageNamed:@"give_feedback"] forState:UIControlStateNormal];
    
    
    [_btnHelpCentre setTitle:[@"Help Centre" myModification] forState:UIControlStateNormal];
    [_btnMyTickets setTitle:[@"My Tickets" myModification] forState:UIControlStateNormal];
    [_btnLiveChat setTitle:[@"Live Chat" myModification] forState:UIControlStateNormal];
    [_btnGiveFeedback setTitle:[@"Give Feedback" myModification] forState:UIControlStateNormal];

    _btnGiveFeedback.imageView.contentMode=UIViewContentModeScaleAspectFit;
//    _btnGiveFeedback.imageView.size
    _lblHowCanWehelp.text=[@"How can we help you?" myModification];
    
    
    [_btnGiveFeedback setImage:[UIImage imageNamed:@"give_feedback"] forState:UIControlStateNormal];

    
    //    [self setupUI];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)setupUI
{
    UIFont *font;
    CGFloat imageSize;
    CGFloat leftMargin;
    CGFloat buttonsMargin;
    if(IS_IPHONE_4)
    {
        font = [UIFont fontWithName:@"OpenSans-Light" size:13];
        imageSize = 72;
        leftMargin = 50.0f;
        buttonsMargin = 15.0f;
    }
    else if(IS_IPHONE_5)
    {
        font = [UIFont fontWithName:@"OpenSans-Light" size:14];
        imageSize = 72;
        leftMargin = 50.0f;
        buttonsMargin = 20.0f;
    }
    else if(IS_IPHONE_6)
    {
        font = [UIFont fontWithName:@"OpenSans-Light" size:16];
        imageSize = 72;
        leftMargin = 50.0f;
        buttonsMargin = 20.0f;
    }
    else if(IS_IPHONE_6_PLUS)
    {
        font = [UIFont fontWithName:@"OpenSans-Light" size:17];
        imageSize = 72;
        leftMargin = 50.0f;
        buttonsMargin = 20.0f;
    }
    else if(IS_IPHONE_X)
    {
        font = [UIFont fontWithName:@"OpenSans-Light" size:17];
        imageSize = 72;
        leftMargin = 50.0f;
        buttonsMargin = 20.0f;
    }
    else
    {
        font = [UIFont fontWithName:@"OpenSans-Light" size:23];
        imageSize = 166;
        leftMargin = 150.0f;
        buttonsMargin = 25.0f;
    }
    
    self.createTicket = [UIButton buttonWithType:UIButtonTypeCustom];
    self.createTicket.frame = CGRectMake(leftMargin, CGRectGetMidY(self.view.bounds) - 20, CGRectGetWidth(self.view.bounds) - (leftMargin * 2.0f), 50.0f);
    [self.createTicket setTitle:[@"CREATE A TICKET" myModification] forState:UIControlStateNormal];
    [self.createTicket setBackgroundColor:RGBCOLOR(20, 148, 200, 1)];
    self.createTicket.titleLabel.font = font;
    [self.view addSubview:self.createTicket];
    
    self.myTickets = [UIButton buttonWithType:UIButtonTypeCustom];
    self.myTickets.frame = CGRectMake(leftMargin, CGRectGetMaxY(self.createTicket.frame) + buttonsMargin, CGRectGetWidth(self.view.bounds) - (leftMargin * 2.0f), 50.0f);
    [self.myTickets setTitle:[@"MY TICKETS" myModification] forState:UIControlStateNormal];
    [self.myTickets setBackgroundColor:RGBCOLOR(20, 148, 200, 1)];
    self.myTickets.titleLabel.font = font;
    [self.view addSubview:self.myTickets];
    
    self.helpCenter = [UIButton buttonWithType:UIButtonTypeCustom];
    self.helpCenter.frame = CGRectMake(leftMargin, CGRectGetMaxY(self.myTickets.frame) + buttonsMargin, CGRectGetWidth(self.view.bounds) - (leftMargin * 2.0f), 50.0f);
    [self.helpCenter setTitle:[@"HELP CENTER" myModification] forState:UIControlStateNormal];
    [self.helpCenter setBackgroundColor:RGBCOLOR(20, 148, 200, 1)];
    self.helpCenter.titleLabel.font = font;
    [self.view addSubview:self.helpCenter];
    
    [self.createTicket addTarget:self action:@selector(handleCreateTicket:) forControlEvents:UIControlEventTouchUpInside];
    [self.myTickets addTarget:self action:@selector(handleMyTickets:) forControlEvents:UIControlEventTouchUpInside];
    [self.helpCenter addTarget:self action:@selector(handleHelpCenter:) forControlEvents:UIControlEventTouchUpInside];
    
    self.createTicket.layer.borderColor = RGBCOLOR(18, 123, 167, 1).CGColor;
    self.createTicket.layer.borderWidth = 1.0f;
    self.createTicket.layer.cornerRadius = 3.0f;
    
    self.myTickets.layer.borderColor = RGBCOLOR(18, 123, 167, 1).CGColor;
    self.myTickets.layer.borderWidth = 1.0f;
    self.myTickets.layer.cornerRadius = 3.0f;
    
    self.helpCenter.layer.borderColor = RGBCOLOR(18, 123, 167, 1).CGColor;
    self.helpCenter.layer.borderWidth = 1.0f;
    self.helpCenter.layer.cornerRadius = 3.0f;
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"help_center_logo"]];
    self.imageView.frame = CGRectMake(CGRectGetMidX(self.view.bounds) - imageSize/2.0f, 64 + imageSize/2.0f, imageSize, imageSize);
    [self.view addSubview:self.imageView];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin, CGRectGetMaxY(self.imageView.frame), CGRectGetWidth(self.view.bounds) - leftMargin * 2.0f, CGRectGetMinY(self.createTicket.frame) - CGRectGetMaxY(self.imageView.frame))];
    self.label.backgroundColor = [UIColor clearColor];
    self.label.font = self.createTicket.titleLabel.font;
    self.label.text = [@"View our Help Center, Create a ticket or manage your existing tickets" myModification];
    self.label.numberOfLines = 0;
    self.label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.label];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)GiveFeedBack:(id)sender
{
    [self handleCreateTicket:nil];
}
-(IBAction)MyTickets:(id)sender
{
    [self handleMyTickets:nil];
}
-(IBAction)HelpCentreBtn:(id)sender
{
    [self handleHelpCenter:nil];
}
-(IBAction)LiveChatBtn:(id)sender
{
//    [self handleHelpCenter:nil];
    
    
    [self noPreChatForm];
//    [self allPreChatFieldsOptional];
}

- (void)handleCreateTicket:(id)sender
{
//    [ZDKRequests showRequestCreationWithNavController:self.navigationController];

//    [ZDKRequests configure:^(ZDKAccount *account, ZDKRequestCreationConfig *requestCreationConfig) {
//        //Set the subject of requests created by the user.
//        requestCreationConfig.subject = @"App Ticket";
////        requestCreationConfig.em
//
//    }];
    
//    ZDKRequests creat

    
//    NSString *strUserEmail= [[NSUserDefaults standardUserDefaults]objectForKey:kUserEmail];
//
//    
//    ZDKAnonymousIdentity *identity = [ZDKAnonymousIdentity new];
//    identity.name = @"";
//    identity.email = strUserEmail;
//    [ZDKConfig instance].userIdentity = identity;
    
//    [ZDKRequests presentRequestCreationWithViewController:self];

    
}

- (void)handleMyTickets:(id)sender
{
 //   [ZDKRequests showRequestListWithNavController:self.navigationController];
//    [ZDKRequests pushRequestListWithNavigationController:self.navigationController];

    
}

- (void)handleHelpCenter:(id)sender
{
    
    
    //    [ZDKHelpCenter showHelpCenterWithNavController:self.navigationController layoutGuide:ZDKLayoutRespectAll];
    
//    ZDKHelpCenterOverviewContentModel *helpCenterContentModel = [ZDKHelpCenterOverviewContentModel defaultContent];
//    // Show Help Center
//    [ZDKHelpCenter pushHelpCenterOverview:self.navigationController withContentModel:helpCenterContentModel];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
//    _scrollView.contentSize = CGSizeMake(self.contentView.frame.size.width, CHAT_CONTENT_HEIGHT);
//    _scrollView.contentInset = UIEdgeInsetsMake([self topViewOffset], 0.0f, [self bottomViewOffset], 0.0f);
}


- (void) allPreChatFieldsOptional
{
    [[IQKeyboardManager sharedManager] setEnable:false];
    [ZendeskChatManager startChatOn:self.navigationController event:@"Chat button pressed: (all fields optional)" preChatFormEnabled:YES];
}


- (void) allPreChatFieldsRequired
{
    [ZendeskChatManager startChatOn:self.navigationController event:@"Chat button pressed: (all fields required)" preChatFormEnabled:YES];
}


- (void) noPreChatForm
{
    
    [[IQKeyboardManager sharedManager] setEnable:false];

    [ZendeskChatManager startChatOn:self.navigationController event:@"Help Chat Started"];
}


- (void) openModalViewController
{
    [ZendeskChatManager trackEvent:@"Modal View Controller opened"];
    
    // simple app navigation simulation
    ViewController *vc = [[ViewController alloc] initWithNibName:nil bundle:nil];
    vc.modal = YES;
    
    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:vc];
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                            style:(UIBarButtonItemStylePlain)
                                                           target:self
                                                           action:@selector(dismiss)];
    vc.navigationItem.rightBarButtonItem = bbi;
    [self presentViewController:navController animated:YES completion:^{ }];
}


- (void) pushViewController
{
    [ZendeskChatManager trackEvent:@"View Controller pushed"];
    
    // simple app navigation simulation
    ViewController *vc = [[ViewController alloc] initWithNibName:nil bundle:nil];
    vc.nested = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void) dismiss
{
    [self dismissViewControllerAnimated:YES completion:^{ }];
}


- (UIButton*) buildButtonWithFrame:(CGRect)frame andTitle:(NSString*)title
{
    // button helper
    UIButton *button          = [[UIButton alloc] initWithFrame:frame];
    button.backgroundColor    = [UIColor whiteColor];
    button.layer.borderColor  = CHAT_BTN_BORDER.CGColor;
    button.layer.borderWidth  = CHAT_BUTTON_BORDER_WIDTH;
    button.layer.cornerRadius = CHAT_BUTTON_CORNER_RADIUS;
    button.titleLabel.font    = [UIFont systemFontOfSize:14];
    [button setTitleColor:CHAT_BTN_TITLE_NORMAL forState:UIControlStateNormal];
    [button setTitleColor:CHAT_BTN_TITLE_HIGHLIGHT forState:UIControlStateHighlighted];
    [button setTitleColor:CHAT_BTN_TITLE_HIGHLIGHT forState:UIControlStateDisabled];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateHighlighted];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    return button;
}


#pragma mark account key


- (void) updateAccountKey
{

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Update account key"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Update", nil];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textField = [alert textFieldAtIndex:0];
    textField.placeholder = @"Account key";
    textField.accessibilityIdentifier = @"SampleViewController.accounttDialog.textField";
    [alert show];
}


- (void) alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
            
        case 0:
        {
             // cancelled
            break;
        }
        default: {
            
            UITextField *textField = [alertView textFieldAtIndex:0];
            
            if (textField.text.length > 0) {
                
                [ZendeskChatManager initializeChatWithAccountKey:textField.text];
            }
            break;
        }
    }
}

@end
