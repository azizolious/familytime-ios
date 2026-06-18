//
//  HelpViewController.h
//  FamilyTime - Dashboard
//
//  Created by Muhammad Ajmal on 18/01/2016.
//  Copyright © 2016 SoraCode. All rights reserved.
//

#import "BaseViewController.h"
#import "ImageCenterButton.h"
@interface HelpViewController : UIViewController
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) BOOL modal;
@property (nonatomic, assign) BOOL nested;


@property (nonatomic, weak) IBOutlet UIButton *btnHelpCentre;
@property (nonatomic, weak) IBOutlet UIButton *btnLiveChat;
@property (nonatomic, weak) IBOutlet UIButton *btnMyTickets;
@property (nonatomic, weak) IBOutlet ImageCenterButton *btnGiveFeedback;
@property (nonatomic, weak) IBOutlet UILabel *lblHowCanWehelp;



- (UIButton*) buildButtonWithFrame:(CGRect)frame andTitle:(NSString*)title;

@end
