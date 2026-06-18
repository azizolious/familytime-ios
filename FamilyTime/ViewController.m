#import "ViewController.h"
#import "FamilyTime-Swift.h"

static const float CHAT_BUTTON_MARGIN = 30.0f;
static const float CHAT_BUTTON_HEIGHT = 44.0f;
static const float CHAT_BUTTON_SPACING = 54.0f;
static const float CHAT_BUTTON_CORNER_RADIUS = 4.0f;
static const float CHAT_BUTTON_BORDER_WIDTH = 1.0f;
static const float CHAT_CONTENT_HEIGHT = 410.0f;

#define CHAT_VC_BTN_BACKGROUND [UIColor colorWithWhite:0.95f alpha:1.0f]
#define CHAT_BTN_TITLE_NORMAL [UIColor colorWithWhite:0.2627f alpha:1.0f]
#define CHAT_BTN_TITLE_HIGHLIGHT [UIColor colorWithWhite:0.2627f alpha:0.3f]
#define CHAT_BTN_BORDER [UIColor colorWithWhite:0.8470f alpha:1.0f]

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

//    [ZendeskChatManager initializeChat];

    self.title = @"Chat SDK Sample";
    self.view.backgroundColor = [UIColor colorWithWhite:0.94f alpha:1.0f];

    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.scrollView];

    CGRect buttonFrame = CGRectMake(
        CHAT_BUTTON_MARGIN,
        CHAT_BUTTON_MARGIN,
        floorf(self.view.frame.size.width - 2 * CHAT_BUTTON_MARGIN),
        CHAT_BUTTON_HEIGHT
    );

    UIButton *button = [self buildButtonWithFrame:buttonFrame andTitle:@"Chat (all fields optional)"];
    button.accessibilityIdentifier = @"ModalChatAllFieldsOptional";
    [button addTarget:self action:@selector(allPreChatFieldsOptional) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:button];

    buttonFrame = CGRectMake(CHAT_BUTTON_MARGIN, floorf(buttonFrame.origin.y + CHAT_BUTTON_SPACING), floorf(self.view.frame.size.width - 2 * CHAT_BUTTON_MARGIN), CHAT_BUTTON_HEIGHT);
    button = [self buildButtonWithFrame:buttonFrame andTitle:@"Chat (all fields required)"];
    button.accessibilityIdentifier = @"PushedChatAllFieldsRequired";
    [button addTarget:self action:@selector(allPreChatFieldsRequired) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:button];

    buttonFrame = CGRectMake(CHAT_BUTTON_MARGIN, floorf(buttonFrame.origin.y + CHAT_BUTTON_SPACING), floorf(self.view.frame.size.width - 2 * CHAT_BUTTON_MARGIN), CHAT_BUTTON_HEIGHT);
    button = [self buildButtonWithFrame:buttonFrame andTitle:@"Chat (no pre-chat form)"];
    button.accessibilityIdentifier = @"PushedChatNoPreChatForm";
    [button addTarget:self action:@selector(noPreChatForm) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:button];

    buttonFrame = CGRectMake(CHAT_BUTTON_MARGIN, floorf(buttonFrame.origin.y + CHAT_BUTTON_SPACING), floorf(self.view.frame.size.width - 2 * CHAT_BUTTON_MARGIN), CHAT_BUTTON_HEIGHT);
    button = [self buildButtonWithFrame:buttonFrame andTitle:@"Chat (pre-set data)"];
    button.accessibilityIdentifier = @"PushedChatPreSetData";
    [button addTarget:self action:@selector(presetData) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:button];

    buttonFrame = CGRectMake(CHAT_BUTTON_MARGIN, floorf(buttonFrame.origin.y + CHAT_BUTTON_SPACING), floorf(self.view.frame.size.width - 2 * CHAT_BUTTON_MARGIN), CHAT_BUTTON_HEIGHT);
    button = [self buildButtonWithFrame:buttonFrame andTitle:@"Open modal view controller"];
    button.accessibilityIdentifier = @"PushModalViewController";
    button.backgroundColor = CHAT_VC_BTN_BACKGROUND;
    [button addTarget:self action:@selector(openModalViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:button];

    buttonFrame = CGRectMake(CHAT_BUTTON_MARGIN, floorf(buttonFrame.origin.y + CHAT_BUTTON_SPACING), floorf(self.view.frame.size.width - 2 * CHAT_BUTTON_MARGIN), CHAT_BUTTON_HEIGHT);
    button = [self buildButtonWithFrame:buttonFrame andTitle:@"Push view controller"];
    button.accessibilityIdentifier = @"PushViewController";
    button.backgroundColor = CHAT_VC_BTN_BACKGROUND;
    [button addTarget:self action:@selector(pushViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:button];

    buttonFrame = CGRectMake(CHAT_BUTTON_MARGIN, floorf(buttonFrame.origin.y + CHAT_BUTTON_SPACING), floorf(self.view.frame.size.width - 2 * CHAT_BUTTON_MARGIN), CHAT_BUTTON_HEIGHT);
    button = [self buildButtonWithFrame:buttonFrame andTitle:@"Override account key"];
    button.accessibilityIdentifier = @"UpdateAccountKey";
    button.backgroundColor = CHAT_VC_BTN_BACKGROUND;
    [button addTarget:self action:@selector(updateAccountKey) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:button];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, CHAT_CONTENT_HEIGHT);
    self.scrollView.contentInset = UIEdgeInsetsZero;
}

//- (void)allPreChatFieldsOptional
//{
//    [ZendeskChatManager startChatOn:self.navigationController event:@"Chat button pressed: (all fields optional)" preChatFormEnabled:YES];
//}
//
//- (void)allPreChatFieldsRequired
//{
//    [ZendeskChatManager startChatOn:self.navigationController event:@"Chat button pressed: (all fields required)"];
//}
//
//- (void)noPreChatForm
//{
//    [ZendeskChatManager startChatOn:self.navigationController event:@"Chat button pressed: (no pre-chat form)"];
//}

- (void)presetData
{
    NSString *timestamp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    NSString *name = [NSString stringWithFormat:@"Preconfig %@", timestamp];
    NSString *email = [NSString stringWithFormat:@"chattest+%@@test.com", timestamp];
//    [ZendeskChatManager updateVisitorWithName:name email:email phoneNumber:timestamp note:@"This is another note"];
//    [ZendeskChatManager startChatOn:self.navigationController event:@"Chat button pressed: (pre-set data)" preChatFormEnabled:YES];
}

- (void)openModalViewController
{
//    [ZendeskChatManager trackEvent:@"Modal View Controller opened"];

    ViewController *vc = [[ViewController alloc] initWithNibName:nil bundle:nil];
    vc.modal = YES;

    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
    navController.modalPresentationStyle = UIModalPresentationFormSheet;

    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                            style:UIBarButtonItemStylePlain
                                                           target:self
                                                           action:@selector(dismiss)];
    vc.navigationItem.rightBarButtonItem = bbi;

    [self presentViewController:navController animated:YES completion:nil];
}

- (void)pushViewController
{
//    [ZendeskChatManager trackEvent:@"View Controller pushed"];

    ViewController *vc = [[ViewController alloc] initWithNibName:nil bundle:nil];
    vc.nested = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIButton *)buildButtonWithFrame:(CGRect)frame andTitle:(NSString *)title
{
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    button.backgroundColor = [UIColor whiteColor];
    button.layer.borderColor = CHAT_BTN_BORDER.CGColor;
    button.layer.borderWidth = CHAT_BUTTON_BORDER_WIDTH;
    button.layer.cornerRadius = CHAT_BUTTON_CORNER_RADIUS;
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleColor:CHAT_BTN_TITLE_NORMAL forState:UIControlStateNormal];
    [button setTitleColor:CHAT_BTN_TITLE_HIGHLIGHT forState:UIControlStateHighlighted];
    [button setTitleColor:CHAT_BTN_TITLE_HIGHLIGHT forState:UIControlStateDisabled];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateHighlighted];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    return button;
}

- (void)updateAccountKey
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }

    UITextField *textField = [alertView textFieldAtIndex:0];
    if (textField.text.length > 0) {
//        [ZendeskChatManager initializeChatWithAccountKey:textField.text];
    }
}

@end
