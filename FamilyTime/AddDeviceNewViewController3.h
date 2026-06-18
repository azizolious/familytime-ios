//
//  AddDeviceNewViewController3.h
//  FamilyTime - Dashboard
//
//  Created by Ahmad on 10/18/17.
//  Copyright © 2017 YumyApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddDeviceNewViewController3 : UIViewController
{
    BOOL familymapEnable;

    IBOutlet UIButton *btnHwtoAct;
    IBOutlet UIButton *btnYesIdo;

    
    
    IBOutlet UILabel *txtVwData;
    IBOutlet UITextView *txtVwWW;
    
    int checkPopup;
}
@property(nonatomic,strong)NSString *strName;
@property(nonatomic,strong)NSString *strtype;
@property(nonatomic)BOOL newUser;
//@property(nonatomic,strong)IBOutlet UITextView *txtVwData;
@property(nonatomic,strong)IBOutlet UILabel *lblTitle;
@property(nonatomic,strong)IBOutlet UILabel *lblSubTitle;
@property(nonatomic,strong)NSString *urlString;
@end
