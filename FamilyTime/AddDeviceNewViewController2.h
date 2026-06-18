//
//  AddDeviceNewViewController2.h
//  FamilyTime - Dashboard
//
//  Created by Ahmad on 10/18/17.
//  Copyright © 2017 YumyApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddDeviceNewViewController2 : UIViewController
{

    int check;
    
    IBOutlet UIButton *btnSkip;
    IBOutlet UIButton *btnNext;
    
}

@property(nonatomic,strong)NSString *strName;
@property(nonatomic,strong)NSString *strReltionship;
@property(nonatomic,strong)IBOutlet UILabel *lblTitle;
@property(nonatomic,strong)IBOutlet UILabel *lblSubTitle;
@property(nonatomic,strong)NSString *strCheck;

@property(nonatomic,strong)IBOutlet UIView *viewLine1;
@property(nonatomic,strong)IBOutlet UIView *viewLine2;
@property(nonatomic,strong)IBOutlet UIView *viewLine3;

@property(nonatomic,strong)IBOutlet UIImageView *imgtick1;
@property(nonatomic,strong)IBOutlet UIImageView *imgtick2;
@property(nonatomic,strong)IBOutlet UIImageView *imgtick3;


@property(nonatomic,strong)IBOutlet UILabel *lbl_ios;
@property(nonatomic,strong)IBOutlet UILabel *lbl_android;
@property(nonatomic,strong)IBOutlet UILabel *lbl_notsure;



@end
