//
//  AppUsageViewController.m
//  FamilyTime - Dashboard
//
//  Created by Ahmad on 8/21/17.
//  Copyright © 2017 SoraCode. All rights reserved.
//

//
//  AppUsageViewController.m
//  FamilyTime - Dashboard
//
//  Created by Ahmad on 8/21/17.
//  Copyright © 2017 YumyApps. All rights reserved.
//

#import "IQKeyboardManager.h"

#import "ParentProfileViewController.h"
#import "NSString+LockMustafa.h"

#import "MBProgressHUD.h"
//#import "JSONHTTPClient.h"
#import "FTUtils.h"
#import "DataModel.h"
#import "Constant.h"
#import "CommonModel.h"
#import "AppDelegate.h"
#import "Constant.h"
#import "FIRConstants.h"

#import "NSString+LockMustafa.h"
#import "ChangePasswordViewController1.h"

#import "IQDropDownTextField.h"
#import "FamilyTime-Swift.h"



AppDelegate *delegate;
UIRefreshControl *  refreshControl;

@interface ParentProfileViewController ()

@end

@implementation ParentProfileViewController
-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:YES];
    
    //        NSString * language;
    //        if([[NSLocale preferredLanguages] count]>1)
    //        {
    //            language = [[NSLocale preferredLanguages] objectAtIndex:0];
    //        }
    //        NSLog(@"Language=%@",language);
    
    
    // [[IQKeyboardManager sharedManager]setEnableAutoToolbar:NO];
    
    
//    [ZendeskChatManager trackEvent:@"Account Screen"];
    
    //[_txtPhone setKeyboardType:UIKeyboardTypeNumberPad];
    _txtPhone.keyboardType = UIKeyboardTypeNamePhonePad;
    
    [txtRelation resignFirstResponder];
    [txtLang resignFirstResponder];
    
    
    
    //    NSArray *arr=[[NSArray alloc]initWithObjects:@{@"type":@"add_device",@"status":SwitchState}, nil];
    
    _rowklanguages=[NSMutableArray new];
    
    NSDictionary *params = @{@"code":@"en",@"name":@"English"};
    NSDictionary *params2 = @{@"code":@"es",@"name":@"Español"};
    NSDictionary *params3 = @{@"code":@"fi",@"name":@"suomi"};
    NSDictionary *params4 = @{@"code":@"ja",@"name":@"日本語"};
    NSDictionary *params5 = @{@"code":@"pt",@"name":@"Português"};
    NSDictionary *params6 = @{@"code":@"de",@"name":@"Deutsch"};
    
    NSDictionary *params7 = @{@"code":@"fr",@"name":@"Français"};
    NSDictionary *chineseLang = @{@"code":@"zh",@"name":@"中文"}; //---Chinese---//
    NSDictionary *italianLang = @{@"code":@"it",@"name":@"italiano"}; //---Italian---//
//    NSDictionary *arabicLang  = @{@"code":@"ar",@"name":@"عربى"}; //---Arabic---//
    
    
    //    NSArray *arr=[[NSArray alloc]initWithObjects:params,params2, nil];
    NSArray *arr=[[NSArray alloc]initWithObjects:params,params2,params3,params4,params5,params6,params7,chineseLang,italianLang, nil];
    
    _rowklanguages=[arr mutableCopy];
}

-(IBAction)EditBtnhere:(id)sender
{
    
    //    [_txtName becomeFirstResponder];
    if([rightButton.title isEqualToString:[@"Save" myModification]])
    {
        [self UpdateProfile];
        [rightButton setTitle:[@"Edit" myModification]];
        
//        _txtName.enabled=NO;
//        _txtEmail.enabled=NO;
//        _txtPhone.enabled=NO;
//        txtLang.enabled=NO;
//        txtRelation.enabled=NO;
        
        _txtName.userInteractionEnabled=NO;
                _txtEmail.userInteractionEnabled=NO;
                _txtPhone.userInteractionEnabled=NO;
                txtLang.userInteractionEnabled=NO;
                txtRelation.userInteractionEnabled=NO;
    }
    else
    {
//        _txtName.enabled=YES;
//        _txtEmail.enabled=NO;
//        _txtPhone.enabled=YES;
//        txtLang.enabled=YES;
//        txtRelation.enabled=YES;
        
        _txtName.userInteractionEnabled=YES;
        _txtEmail.userInteractionEnabled=NO;
        _txtPhone.userInteractionEnabled=YES;
        txtLang.userInteractionEnabled=YES;
        txtRelation.userInteractionEnabled=YES;
        
        
        [_txtName becomeFirstResponder];
        [rightButton setTitle:[@"Save" myModification]];
    }
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self refreshTableView];
    
    //    [IQKeyboardManager setEnableAutoToolbar:NO];
    
    
     _txtName.userInteractionEnabled=NO;
                   _txtEmail.userInteractionEnabled=NO;
                   _txtPhone.userInteractionEnabled=NO;
                   txtLang.userInteractionEnabled=NO;
                   txtRelation.userInteractionEnabled=NO;
    
   // self.txtPhone.keyboardType = UIKeyboardTypePhonePad;
    
   
    
   // [_txtPhone.delegate]
    
    
    _txtName.delegate=self;
    _txtEmail.delegate=self;
    _txtPhone.delegate=self;
    
    
    rightButton= [[UIBarButtonItem alloc] initWithTitle:[@"Edit" myModification] style:UIBarButtonItemStylePlain target:self action:@selector(EditBtnhere:)];
    self.navigationItem.rightBarButtonItems =[NSArray arrayWithObjects:rightButton,nil];
    
    checklanguageChange=0;
    _strRelationShip=@"Father";
    _strLanguage=@"";
    _strName=@"";
    _strPhone=@"";
    _strEmail=@"";
    
    _rowDic =[NSMutableDictionary new];
    _rowkSettings=[NSMutableArray new];
    
    
    self.tableView.hidden=NO;
    _arrOfBasicInfoImages=[NSMutableArray new];
    
    _arrOfBasicInfoData=[NSMutableArray new];
    
    [_arrOfBasicInfoImages addObject:@"p_name"];
    [_arrOfBasicInfoImages addObject:@"p_email"];
    [_arrOfBasicInfoImages addObject:@"p_phone"];
    [_arrOfBasicInfoImages addObject:@"p_relation"];
    
    [_arrOfBasicInfoData addObject:[@"Loading..." myModification]];
    [_arrOfBasicInfoData addObject:[@"Loading..." myModification]];
    [_arrOfBasicInfoData addObject:[@"Loading..." myModification]];
    [_arrOfBasicInfoData addObject:[@"Loading..." myModification]];
    
    
    //   self.tableView.layer
    //    [self.tableView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    //    [self.tableView.layer setBorderWidth:1.0f];
    //
    [_topView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [_topView.layer setBorderWidth:1.0f];
    
    
    
    _lblTotalMinutes.adjustsFontSizeToFitWidth=YES;
    
    IndexOfDate = 0;
    
    self.title = [@"Account" myModification];
    
    _rowArr=[NSMutableArray new];
    //    delegate = [AppDelegate appDelegate];
    //    [self.tableView registerNib:[UINib nibWithNibName:@"AppUsageTableViewCell" bundle:nil] forCellReuseIdentifier:@"AppUsageCell"];
    
    
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(236, 229,296,212)];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.image = [UIImage imageNamed:@"ipad_empty"];
        imgView.hidden=YES;
        [self.view addSubview:imgView];
        [self.view bringSubviewToFront:imgView];
        
        contentLbl=[[UILabel alloc]initWithFrame:CGRectMake(203, 489, 362, 45)];
        contentLbl.lineBreakMode=YES;
        contentLbl.textColor=[UIColor lightGrayColor];
        contentLbl.text=[@"It seems like there is no record to\n display." myModification];
        contentLbl.font=[UIFont systemFontOfSize:16];
        contentLbl.lineBreakMode = NSLineBreakByWordWrapping;
        contentLbl.numberOfLines = 2;
        contentLbl.textAlignment = NSTextAlignmentCenter;
        contentLbl.hidden=YES;
        [self.view addSubview:contentLbl];
        [self.view bringSubviewToFront:contentLbl];
    }
    else if(([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone))
    {
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(115, 152,145,104)];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.image = [UIImage imageNamed:@"ic_empty"];
        imgView.hidden=YES;
        [self.view addSubview:imgView];
        [self.view bringSubviewToFront:imgView];
        
        contentLbl=[[UILabel alloc]initWithFrame:CGRectMake(30, 279, 315, 41)];
        contentLbl.lineBreakMode=YES;
        contentLbl.textColor=[UIColor lightGrayColor];
        contentLbl.text=[@"It seems like there is no record to\n display." myModification] ;
        contentLbl.font=[UIFont systemFontOfSize:17];
        contentLbl.lineBreakMode = NSLineBreakByWordWrapping;
        contentLbl.numberOfLines = 2;
        contentLbl.textAlignment = NSTextAlignmentCenter;
        contentLbl.hidden=YES;
        [self.view addSubview:contentLbl];
        [self.view bringSubviewToFront:contentLbl];
    }
    
    [_tableView reloadData];
   // [self viewParentProfiledata];
    
    // Do any additional setup after loading the view from its nib.
    
    //    [self loadAllAppUsageOfChild];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)validateString:(NSString *)string withPattern:(NSString *)pattern
{
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];

    NSAssert(regex, @"Unable to create regular expression");

    NSRange textRange = NSMakeRange(0, string.length);
    NSRange matchRange = [regex rangeOfFirstMatchInString:string options:NSMatchingReportProgress range:textRange];

    BOOL didValidate = NO;

    // Did we find a matching range
    if (matchRange.location != NSNotFound)
        didValidate = YES;

    return didValidate;
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

//-(void) loadAllAppUsageOfChild
//{
//    //    if(self.dates.count == 0)
//    //  /      return;
//
//    //set first last date in between next prev button
//    //    NSString *date  = [CommonModel date:[self.dates objectAtIndex:self.page] oldFormat:@"YYYY-MM-dd HH:mm:ss" format:@"EEE, MMM d, yyyy"];//d EEE,MMM yy
//    //    [self.locDate setText:date];
//    [SwiftFTUtils showHUDAddedTo:self.view withText:[@"Loading..." myModification] animated:YES];
//
//
//    //   NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:delegate.selectedDashboardChild.child_id],@"child_id",pDate,@"date", nil];
//
//
//    NSString *str= [NSString stringWithFormat:@"%ld",(long)delegate.selectedDashboardChild.child_id];
//
//
//    NSLog(@"greattt--%ld",(long)delegate.selectedDashboardChild.child_id);
//    //NSString *str= @"96685";
//    NSString *strCompleteUrl=[NSString stringWithFormat:@"%@/v2/ftd/appusage/list/%@/2017-08-03",kBasUrl,str];
//
//    NSLog(@"URL==%@",strCompleteUrl);
//    //@"https://mesh.familytime.io/v2/push/familytimemap/65279"
//    [JSONHTTPClient getJSONFromURLWithString:strCompleteUrl
//                                      params:[NSDictionary new]
//                                  completion:^(id json, JSONModelError *err) {
//                                      //                                      NSError *error;
//                                      NSLog(@"%@",json);
//
//
//                                      if([[json objectForKey:@"status_message"]isEqualToString:@"OK"])
//                                      {
//                                          _rowArr=[json objectForKey:@"response"];
//
//                                          int k=0;
//                                          for(int o=0;o<_rowArr.count;o++)
//                                          {
//                                              k= [[[_rowArr objectAtIndex:o] objectForKey:@"app_usage"] intValue]+k;
//                                          }
//                                          NSLog(@"Here is total seconds=%i",k);
//
//                                          TotalTime=k;
//                                          _lblTotalMinutes.text=[NSString stringWithFormat:@"%.1f minutes",k/60.0];
//
//                                          [_tableView reloadData];
//                                      }
//
//                                      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                                  }];
//
//
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==1)
    {
        return 2.0;
    }
    else if(section==2)
    {
        return _arrOfBasicInfoImages.count;
    }
    else if(section==3)
    {
        return 1.0;
    }
    else
    {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if(indexPath.section==0)
    {
        if(indexPath.row==0)
        {
            static NSString *simpleTableIdentifier = @"ProfilePic";
            
            cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
            }
            
            
            UILabel *LabelTitle = (UILabel*)[cell viewWithTag:1];
            UILabel *LabelSubTitle = (UILabel*)[cell viewWithTag:2];
            UIImageView *imgview = (UIImageView*)[cell viewWithTag:3];
            
            //if([[_rowDic objectForKey:@"info"] objectForKey:@"name"]!=nil)
            //{
                //LabelTitle.text    = [[_rowDic objectForKey:@"info"]objectForKey:@"name"];
               // LabelSubTitle.text = [[_rowDic objectForKey:@"info"]objectForKey:@"email"];
            //}
            
            LabelTitle.text = [NSUserDefaults.standardUserDefaults stringForKey:@"userName"];
            LabelSubTitle.text = [NSUserDefaults.standardUserDefaults stringForKey:@"userEmail"];
            
           // if ([[_rowDic objectForKey:@"info"] objectForKey:@"relationship"] != [NSNull null]){
                //_strRelationShip=[[_rowDic objectForKey:@"info"]objectForKey:@"relationship"];
            
            
            
                _strRelationShip =[NSUserDefaults.standardUserDefaults stringForKey:@"userRelation"];
           // _strRelationShip = delegate.parent.relationship;
                
                _strRelationShip = [NSString stringWithFormat:@"%@%@",[[_strRelationShip substringToIndex:1] uppercaseString],[_strRelationShip substringFromIndex:1] ];
            //}
            
//            if ([[_strRelationShip lowercaseString] isEqualToString:@"mother"])
//            {
//                imgview.image = [UIImage imageNamed:@"in_parent_f"];
//            }
//            else
//            {
//                imgview.image = [UIImage imageNamed:@"in_parent_m"];
//            }
            
            if ([_strRelationShip isEqualToString:NSLocalizedString(@"Mother",nil)])
                        {
                            imgview.image = [UIImage imageNamed:@"in_parent_f"];
                        }
                        else
                        {
                            imgview.image = [UIImage imageNamed:@"in_parent_m"];
                        }
            
            
            //---SANA CHANGE---//---NEW AVATAR CHANGED---//
            
           
        }
        
        
    }
    else if(indexPath.section==1)
    {
        if(indexPath.row==0)
        {
            static NSString *simpleTableIdentifier = @"Free";
            
            cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
            }
            
        }
        else if(indexPath.row==1)
        {
            static NSString *simpleTableIdentifier = @"GoPremium";
            
            cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
            }
        }
        
    }
    else if(indexPath.section==2)
    {
        if(indexPath.row==_arrOfBasicInfoImages.count-1)
        {
            static NSString *simpleTableIdentifier = @"BasicInfoList";
            cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
            }
            UIImageView *imgView11 = (UIImageView*)[cell viewWithTag:1];
            UILabel *lblTitle = (UILabel*)[cell viewWithTag:2];
            
            imgView11.image=[UIImage imageNamed:[_arrOfBasicInfoImages objectAtIndex:indexPath.row]];
            lblTitle.text= [_arrOfBasicInfoData objectAtIndex:indexPath.row];
            lblTitle.text=@"";
            
            
            //            UIToolbar *toolbar = [[UIToolbar alloc] init];
            //            [toolbar setBarStyle:UIBarStyleBlackTranslucent];
            //            [toolbar sizeToFit];
            //            UIBarButtonItem *buttonflexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            //            UIBarButtonItem *buttonDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneClicked:)];
            //
            //            [toolbar setItems:[NSArray arrayWithObjects:buttonflexible,buttonDone, nil]];
            
            //UIte
            //            UITextField
            IQDropDownTextField *textFieldTextPicker = (IQDropDownTextField*)[cell viewWithTag:3];
            
            //            textFieldTextPicker.tag=101;
            textFieldTextPicker.delegate = self;
            
            textFieldTextPicker.isOptionalDropDown = NO;
            
            //---REMOVE GUARDIAN---SPRINT 4---IN-APP PURCHASE---//
            //            [textFieldTextPicker setItemList:[NSArray arrayWithObjects:@"Father",@"Mother",@"Guardian", nil]];
            [textFieldTextPicker setItemList:[NSArray arrayWithObjects:NSLocalizedString(@"Father",nil),NSLocalizedString(@"Mother",nil), nil]];
            //            textFieldTextPicker.text=[_arrOfBasicInfoData objectAtIndex:indexPath.row];
            
           // textFieldTextPicker.text=[_arrOfBasicInfoData objectAtIndex:indexPath.row];
            
            textFieldTextPicker.selectedItem=[NSUserDefaults.standardUserDefaults stringForKey:@"userRelation"];
            
           // textFieldTextPicker.selectedItem =[_arrOfBasicInfoData objectAtIndex:indexPath.row];
            
            txtRelation=textFieldTextPicker;
            
        }
        else
        {
            static NSString *simpleTableIdentifier = @"BasicInfo";
            
            cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
            }
            UIImageView *imgView11 = (UIImageView*)[cell viewWithTag:1];
            UILabel *lblTitle = (UILabel*)[cell viewWithTag:2];
            UITextField *txtFieldTitle = (UITextField*)[cell viewWithTag:3];
            
            
            imgView11.image=[UIImage imageNamed:[_arrOfBasicInfoImages objectAtIndex:indexPath.row]];
            
            lblTitle.text= [_arrOfBasicInfoData objectAtIndex:indexPath.row];
            lblTitle.hidden=YES;
            //txtFieldTitle.text=[_arrOfBasicInfoData objectAtIndex:indexPath.row];
            if(indexPath.row==0)
            {
                txtFieldTitle.text = [NSUserDefaults.standardUserDefaults stringForKey:@"userName"];
                _txtName=txtFieldTitle;
               
            }
            else if(indexPath.row==1)
            {
                txtFieldTitle.text = [NSUserDefaults.standardUserDefaults stringForKey:@"userEmail"];
                _txtEmail=txtFieldTitle;
                
            }
            else if(indexPath.row==2)
            {
                txtFieldTitle.text = [NSUserDefaults.standardUserDefaults stringForKey:@"userPhone"];
                _txtPhone=txtFieldTitle;
            }
            
        }
        
    }
    else if(indexPath.section==3)
    {
        static NSString *simpleTableIdentifier = @"BasicInfoListChangelanguage";
        
        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        UIImageView *imgView11 = (UIImageView*)[cell viewWithTag:1];
        imgView11.image=[UIImage imageNamed:@"p_english"];
        
        UILabel *lbllanguagessss = (UILabel*)[cell viewWithTag:55];
        
        lbllanguagessss.text=[lbllanguagessss.text myModification];
        
        UILabel *lblTitle = (UILabel*)[cell viewWithTag:2];
        UIView *vwLine = (UIView*)[cell viewWithTag:12];
        vwLine.hidden=YES;
        
        IQDropDownTextField *textFieldTextPicker = (IQDropDownTextField*)[cell viewWithTag:3];
        //        textFieldTextPicker.tag=102;
        
        
        
        textFieldTextPicker.isOptionalDropDown = NO;
        
        NSMutableArray *arrTest=[NSMutableArray new];
        
        NSLog(@"ALL=");
        
        NSLog(@"%@",_rowklanguages);
        ///*
        if(_rowklanguages.count>0)
        {
            for(int i=0;i<_rowklanguages.count;i++)
            {
                [arrTest addObject:[[_rowklanguages objectAtIndex:i] objectForKey:@"name"]];
                
            }
            
            NSLog(@"Language: %@", arrTest);
            //            [textFieldTextPicker setTextColor:[UIColor lightGrayColor]];
            [textFieldTextPicker setDropDownMode:IQDropDownModeTextPicker];
            textFieldTextPicker.isOptionalDropDown = NO;
            [textFieldTextPicker setItemList:[arrTest copy]];
            
            
            //            [textFieldTextPicker setItemList:[NSArray arrayWithObjects:@"English",@"Spanish",@"Spanish",@"Spanish", nil]];
            //        [textFieldTextPicker setItemList:[NSArray arrayWithObjects:@"",@"", nil]];
        }
        else
        {
            [textFieldTextPicker setItemList:[NSArray arrayWithObjects:@"English", nil]];
            //            [textFieldTextPicker setItemList:[NSArray new]];
        }
        
        //            NSString *languageCodee = [[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0];
        
        
        
        
        //*/
        
        //        [textFieldTextPicker setItemList:[NSArray new]];
        
        //        [textFieldTextPicker setItemList:[NSArray arrayWithObjects:@"English",@"Spanish", nil]];
        textFieldTextPicker.delegate=self;
        
        NSString *Language_id=@"";
                       for(int i=0;i<[_rowklanguages count];i++)
                       {
                           NSString *strTemp=  [[_rowklanguages objectAtIndex:i] objectForKey:@"code"];
                           if([strTemp isEqualToString:[NSUserDefaults.standardUserDefaults stringForKey:@"userlanguage"]])
                           {
                               Language_id=[[_rowklanguages objectAtIndex:i] objectForKey:@"name"];
                               break;
                           }
                       }
                       _strLanguage=  Language_id;
        
        
        lblTitle.text=@"";
        textFieldTextPicker.selectedItem= _strLanguage;
        txtLang=textFieldTextPicker;
        
        
        NSString *language11 = [[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0];
        
        //        language11 = [language11 substringFromIndex:2];
        //  language11=@"ja";
        NSArray *arrNew=[language11 componentsSeparatedByString:@"-"];
        language11=  [arrNew objectAtIndex:0];
        NSLog(@"%@",language11);
        //language11=language11
        NSString *LanguageHere=@"";
        for(int i=0;i<[_rowklanguages count];i++)
        {
            
            NSString *strTemp=  [[_rowklanguages objectAtIndex:i] objectForKey:@"code"];
            if([strTemp isEqualToString:language11])
            {
                LanguageHere=[[_rowklanguages objectAtIndex:i] objectForKey:@"name"];
                break;
            }
        }
        if([LanguageHere isEqualToString:@""])
        {
            textFieldTextPicker.selectedItem=@"English";
            
        }
        else
        {
            
            textFieldTextPicker.selectedItem=LanguageHere;
        }
        
        
    }
    else if(indexPath.section==4)
    {
        static NSString *simpleTableIdentifier = @"ChangePassword";
        
        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        
        UIButton *btnMain = (UIButton*)[cell viewWithTag:33];
        
//        btnMain.titleLabel.text=[btnMain.titleLabel.text myModification];
        
        NSLog(@"change password translation = %@", [@"Change Password" myModification]);
        
        [btnMain setTitle:NSLocalizedString(@"Change Password", nil) forState:UIControlStateNormal];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        //        UIImageView *imgView11 = (UIImageView*)[cell viewWithTag:1];
        //        imgView11.image=[UIImage imageNamed:@"p_english"];
        
        
    }
    else
    {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        //        static NSString *simpleTableIdentifier = @"ChangePassword";
        //
        //        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        //
        //        if (cell == nil)
        //        {
        //            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        //        }
        //
        //ChangePassword
        //        static NSString *simpleTableIdentifier = @"ProfilePic";
        //
        //       cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
    }
    
    //BasicInfo
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section==0)
    {
        //405
        //        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        //        {
        //            return 405.0;
        //
        //        }
        //        else
        //        {
        return 219.0;
        //        }
    }
    else if(indexPath.section==1)
    {
        return 0.0;
    }
    else if(indexPath.section==3)
    {
        return 107.0;
    }
    else
    {
        return 51.0;
    }
    
}


- (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}


//-(void) loadDates
//{
//    _view1.hidden=NO;
//    _view2.hidden=NO;
//
//    NSLog(@"greattt--%ld",(long)delegate.selectedDashboardChild.child_id);
//    self.page = 0;
//    self.dates = [[NSMutableArray alloc] init];
//    [SwiftFTUtils showHUDAddedTo:self.view withText:[@"Loading..." myModification] animated:YES];
//    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:delegate.selectedDashboardChild.child_id],@"child_id", nil];
//
//    NSString *struserCheck=[NSString stringWithFormat:@"%@%@/%ld",kBasUrl,@"/v2/ftd/appusage/checkindates",(long)delegate.selectedDashboardChild.child_id];
//    [JSONHTTPClient postJSONFromURLWithString:struserCheck
//                                       params:params
//                                   completion:^(id json, JSONModelError *err) {
//                                       NSString *msg = [json valueForKey:@"status_message"] == nil ? [kErrorGeneral myModification] : [json valueForKey:@"status_message"];
//
//                                       NSLog(@"Load dates==%@",json);
//                                       if([[json valueForKey:@"status_code"] intValue] == 200){
//                                           NSArray *jsonObject =  [[json valueForKey:@"response"] copy];
//                                           //                                           self.dates = [NSMutableArray arrayWithArray:jsonObject];
//                                           NSMutableArray *arr = [NSMutableArray arrayWithArray:jsonObject];
//
//                                           [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//
//
//                                           self.dates= [[[[arr copy] reverseObjectEnumerator] allObjects] mutableCopy];
//
//                                           if([self.dates count]>0)
//                                           {
//                                               [self loadAllAppUsageOfChildNew:[self.dates objectAtIndex:IndexOfDate]];
//
//                                               //                                               imgView.hidden=NO;
//                                               //                                               contentLbl.hidden=NO;
//                                               //
//                                               //                                               _view1.hidden=YES;
//                                               //                                               _view2.hidden=YES;
//                                               //                                               [self.view setBackgroundColor:[UIColor whiteColor]];
//                                               //                                               self.tableView.hidden=YES;
//
//                                           }
//                                           else
//                                           {
//                                               [self NodataShow];
//                                               //                                               [self.view addSubview:imgView];
//                                               //                                               [self.view addSubview:contentLbl];
//                                               //                                               imgView.hidden=NO;
//                                               //                                               contentLbl.hidden=NO;
//                                               //
//                                               //                                               _view1.hidden=YES;
//                                               //                                               _view2.hidden=YES;
//                                               //                                               [self.view setBackgroundColor:[UIColor whiteColor]];
//                                               //                                               self.tableView.hidden=YES;
//
//                                           }
//
//                                           //                                           [self loadLoactions];
//
//                                       }
//                                       else
//                                       {
//                                           [CommonModel showAlert:@"Error!" msg:msg];
//                                           [self NodataShow];
//
//                                           //                                           [self refreshTable];
//                                           [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                                       }
//                                   }];
//}


-(void)dataShowAll
{
    imgView.hidden=YES;
    contentLbl.hidden=YES;
    
    _view1.hidden=NO;
    _view2.hidden=NO;
    //    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.tableView.hidden=NO;
    
    
}
-(void)NodataShow
{
    imgView.hidden=NO;
    contentLbl.hidden=NO;
    
    _view1.hidden=YES;
    _view2.hidden=YES;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.tableView.hidden=YES;
    
}

-(void)NodataShowNew
{
    imgView.hidden=NO;
    //    contentLbl.hidden=NO;
    
    _view1.hidden=NO;
    _view2.hidden=YES;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.tableView.hidden=YES;
    
}

-(IBAction)buttonNext:(id)sender
{
//    if(IndexOfDate==0)
//    {
//    }
//    else
//    {
//        IndexOfDate--;
//        [self loadAllAppUsageOfChildNew:[self.dates objectAtIndex:IndexOfDate]];
//
//    }
    
}

-(IBAction)buttonPrevious:(id)sender
{
//    if([self.dates count]-1==IndexOfDate)
//    {
//    }
//    else
//    {
//        IndexOfDate++;
//        [self loadAllAppUsageOfChildNew:[self.dates objectAtIndex:IndexOfDate]];
//    }
    
    //loadAllAppUsageOfChildNew
}
#pragma mark With parameter
//-(void) loadAllAppUsageOfChildNew:(NSString *)strDate
//{
//    //    if(self.dates.count == 0)
//    //        return;
//
//    //set first last date in between next prev button
//    //    NSString *date  = [CommonModel date:[self.dates objectAtIndex:self.page] oldFormat:@"YYYY-MM-dd HH:mm:ss" format:@"EEE, MMM d, yyyy"];//d EEE,MMM yy
//    //    [self.locDate setText:date];
//
//
//    NSString *date  = [CommonModel date:[self.dates objectAtIndex:IndexOfDate] oldFormat:@"YYYY-MM-dd" format:@"EEE, MMM d, yyyy"];//d EEE,MMM yy
//    [_lblDaySelected setText:date];
//
//
//
//    [SwiftFTUtils showHUDAddedTo:self.view withText:[@"Loading..." myModification] animated:YES];
//
//
//    //   NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:delegate.selectedDashboardChild.child_id],@"child_id",pDate,@"date", nil];
//
//
//    NSArray *str= [NSString stringWithFormat:@"%ld",(long)delegate.selectedDashboardChild.child_id];
//
//    NSArray *arr=[strDate componentsSeparatedByString:@" "];
//
//    NSString *strDate1= [arr objectAtIndex:0];
//    //    _lblDaySelected.text=strDate1;
//
//    NSLog(@"greattt--%ld",(long)delegate.selectedDashboardChild.child_id);
//    //NSString *str= @"96685";
//    NSString *strCompleteUrl=[NSString stringWithFormat:@"%@/v2/ftd/appusage/list/%@/%@",kBasUrl,str,strDate1];
//
//    NSLog(@"URL==%@",strCompleteUrl);
//    //@"https://mesh.familytime.io/v2/push/familytimemap/65279"
//    [JSONHTTPClient getJSONFromURLWithString:strCompleteUrl
//                                      params:[NSDictionary new]
//                                  completion:^(id json, JSONModelError *err) {
//                                      //                                      NSError *error;
//                                      NSLog(@"%@",json);
//
//
//                                      if([[json objectForKey:@"status_message"]isEqualToString:@"OK"])
//                                      {
//                                          self.tableView.hidden=NO;
//
//                                          _rowArr=[json objectForKey:@"response"];
//
//                                          int k=0;
//                                          for(int o=0;o<_rowArr.count;o++)
//                                          {
//                                              k= [[[_rowArr objectAtIndex:o] objectForKey:@"app_usage"] intValue]+k;
//
//                                          }
//                                          NSLog(@"Here is total seconds=%i",k);
//
//                                          TotalTime=k;
//
//                                          int roundedUp = ceil(k/60.0);
//                                          _lblTotalMinutes.text=[NSString stringWithFormat:@"%i %@",roundedUp,[@"Minutes" myModification]];
//
//                                          int hours = k / 3600;
//                                          if(hours>0)
//                                          {
//                                              _lblTotalMinutes.text=[NSString stringWithFormat:@"%i %@",hours,[@"Hours" myModification]];
//                                          }
//
//
//
//                                          if(_rowArr.count==0)
//                                          {
//                                              [self NodataShowNew];
//                                          }
//                                          else
//                                          {
//                                              [self dataShowAll];
//                                          }
//
//                                          [_tableView reloadData];
//
//                                      }
//
//                                      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                                  }];
//
//
//}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==0)
    {
        return 0.0;
    }
    else if(section==1)
    {
        return 0.0;
    }
    else if(section==3)
    {
        return 0.0;
    }
    else if(section==4)
    {
        return 13.0;
    }
    //    else if(section==3)
    //    {
    //        return 0.0;
    //    }
    //    else if(section==4)
    //    {
    //        return 0.0;
    //    }
    else
    {
        return 29.0;
        
    }
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    if(section==0)
    {
        return @"Active Parents";
        
    }
    else if(section==1)
    {
        //        return @"Subscription";
        return nil;
        
        
    }
    else if(section==2)
    {
        return [@"Basic Information" myModification];
        
    }
    else if(section==3)
    {
        return @"";
        
    }
    else
    {
        return @"";
    }
}
// fixed font style. use custom view (UILabel) if you want something different
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0;
    
    if(section==0)
    {
        return 0.0;
    }
    else if(section==1)
    {
        return 0.0;
    }
    else if(section==2)
    {
        return 20.0;
    }
    else if(section==3)
    {
        return 0.0;
    }
    //    else if(section==4)
    //    {
    //        return 20.0;
    //    }
    else
    {
        return 0.0;
    }
    
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return nil;
}
//- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//
//    UILabel *sectionlabelView=[[UILabel alloc] initWithFrame:
//                               CGRectMake(0, 0, tableView.frame.size.width, 44.0)];
//
//    if(section==1)
//    {
//       sectionlabelView.text= @"Subscription";
//        
//    }
//    else if(section==2)
//    {
//       sectionlabelView.text= @"Basic information";
//        
//    }
//    else if(section==3)
//    {
//      sectionlabelView.text= @"Languages";
//        
//    }
//    else
//    {
//      sectionlabelView.text= @"";
//    }
//    
//    
//    UIView *sectionHeaderView;
//    
//    sectionHeaderView = [[UIView alloc] initWithFrame:
//                         CGRectMake(0, 0, tableView.frame.size.width, 44.0)];
//    
//    sectionHeaderView.backgroundColor=[UIColor groupTableViewBackgroundColor];
//    [sectionHeaderView addSubview:sectionlabelView];
//    return sectionHeaderView;
//
//}
// custom view for header. will be adjusted to default or specified header height

//- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *sectionHeaderView;
//    
//    sectionHeaderView = [[UIView alloc] initWithFrame:
//                         CGRectMake(0, 0, tableView.frame.size.width, 7.0)];
//    
//    sectionHeaderView.backgroundColor=[UIColor whiteColor];
//
//    
//    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0,
//                                                                sectionHeaderView.frame.size.height - 1.0+5,
//                                                                sectionHeaderView.frame.size.width, 1)];
//    
//    lineView.backgroundColor = [UIColor lightGrayColor];
//    [sectionHeaderView addSubview:lineView];
//    
//    
//    return sectionHeaderView;
//}// custom view for footer. will be adjusted to default or specified footer height


-(IBAction)btnChangePassword:(id)sender
{
    
    ChangePasswordViewController1 *vc = [[ChangePasswordViewController1 alloc] initWithNibName:@"ChangePasswordViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark View Profile
-(void)viewParentProfiledata
{
    
    [SwiftFTUtils showHUDAddedTo:self.view withText:[@"loading..." myModification] animated:YES];
    
    NSString *url = [NSString stringWithFormat:@"%@%@%@",kBasUrlNew_mesh2,kViewParentProfile, delegate.parent.user_id];
    
    NSString * language;
    if([[NSLocale preferredLanguages] count]>1)
    {
        language = [[NSLocale preferredLanguages] objectAtIndex:0];
    }
    //    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    //    NSString *tzName = [timeZone name];
    
    
    //    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    //    NSLog(@"OS=%f",[[UIDevice currentDevice].systemVersion floatValue]);
    //    NSLog(@"Model info=%@",[NSString stringWithCString:systemInfo.nodename
    //                                              encoding:NSUTF8StringEncoding]);
    //    NSDictionary *params=[NSDictionary new];
    
    
    
    /*
    
    
    [JSONHTTPClient getJSONFromURLWithString:url completion:^(id json, JSONModelError *err) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        [_arrOfBasicInfoData removeAllObjects];
        
        _txtName.enabled=NO;
        _txtEmail.enabled=NO;
        _txtPhone.enabled=NO;
        txtLang.enabled=NO;
        txtRelation.enabled=NO;
        
        
        NSLog(@"%@",json);
        [refreshControl endRefreshing];
        
        if([[json valueForKey:@"status_code"] intValue] == 200)
        {
            NSLog(@"Great");
            
            NSLog(@"%@",json);
            
            _rowDic=[[json objectForKey:@"response"] mutableCopy];
            
            //            _lblTitle.text=[[_rowDic objectForKey:@"info"]objectForKey:@"name"];
            //            _lblEmail.text=[[_rowDic objectForKey:@"info"]objectForKey:@"email"];
            
            [_arrOfBasicInfoData addObject: [[_rowDic objectForKey:@"info"]objectForKey:@"name"]];
            [_arrOfBasicInfoData addObject: [[_rowDic objectForKey:@"info"]objectForKey:@"email"]];
            if(([[_rowDic objectForKey:@"info"]objectForKey:@"phone"]!=nil)&&([[_rowDic objectForKey:@"info"]objectForKey:@"phone"]!=[NSNull null]))
            {
                [_arrOfBasicInfoData addObject: [[_rowDic objectForKey:@"info"]objectForKey:@"phone"]];
            }
            else
            {
                [_arrOfBasicInfoData addObject: @"xxxxxxxx"];
            }
            
            //            [_arrOfBasicInfoData addObject: [[_rowDic objectForKey:@"info"]objectForKey:@"relationship"]];
            
            //---CRASH FIXED---//
            //---IF RELATIONSHIP IS NIL THEN SHOW DEFAULT FATHER---//
            if ([[_rowDic objectForKey:@"info"] objectForKey:@"relationship"] != [NSNull null]){
                _strRelationShip=[[_rowDic objectForKey:@"info"]objectForKey:@"relationship"];
                
                _strRelationShip = [NSString stringWithFormat:@"%@%@",[[_strRelationShip substringToIndex:1] uppercaseString],[_strRelationShip substringFromIndex:1] ];
            }
            //---CRASH FIXED---//
            
            [_arrOfBasicInfoData addObject: _strRelationShip];
            
            
            _strName  = [[_rowDic objectForKey:@"info"]objectForKey:@"name"];
            _strEmail = [[_rowDic objectForKey:@"info"]objectForKey:@"email"];
            _strPhone = [[_rowDic objectForKey:@"info"]objectForKey:@"phone"];
            
            _strLanguage=[[_rowDic objectForKey:@"info"]objectForKey:@"language"];
            
            //            _rowklanguages=[[_rowDic objectForKey:@"languages"] mutableCopy];
            _rowkSettings=[[_rowDic objectForKey:@"settings"] mutableCopy];
            
            [txtLang resignFirstResponder];
            [txtRelation resignFirstResponder];
            
            txtRelation.selectedItem=_strRelationShip;
            NSLog(@"Mustafa007==%@",_strRelationShip);
            
            
            [[NSUserDefaults standardUserDefaults] setObject:_strRelationShip forKey:@"ParentRelationship"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSString *Language_id=@"";
            for(int i=0;i<[_rowklanguages count];i++)
            {
                NSString *strTemp=  [[_rowklanguages objectAtIndex:i] objectForKey:@"code"];
                if([strTemp isEqualToString:_strLanguage])
                {
                    Language_id=[[_rowklanguages objectAtIndex:i] objectForKey:@"name"];
                    break;
                }
            }
            _strLanguage=  Language_id;
            [_tableView reloadData];
        }
        else
        {
            [CommonModel showAlert:[@"Please connect your device with the Internet and try again." myModification] msg:@""];
        }
    }];
    
    
    */
    
    
    //---NATIVE API CALLING---//
    
    [[ApiManager shared] mesh_getApiWithApi:url withResponse:^(NSDictionary * _Nonnull json, NSInteger errorCode, NSString * _Nonnull message) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            [_arrOfBasicInfoData removeAllObjects];
            
            _txtName.enabled=NO;
            _txtEmail.enabled=NO;
            _txtPhone.enabled=NO;
            txtLang.enabled=NO;
            txtRelation.enabled=NO;
            
            
            NSLog(@"Old Mesh parent profile api json response = %@",json);
            [refreshControl endRefreshing];
            
            if([[json valueForKey:@"status_code"] intValue] == 200)
            {
                _rowDic = [[json objectForKey:@"response"] mutableCopy];
                
                
                [_arrOfBasicInfoData addObject: [[_rowDic objectForKey:@"info"]objectForKey:@"name"]];
                [_arrOfBasicInfoData addObject: [[_rowDic objectForKey:@"info"]objectForKey:@"email"]];
                
                if(([[_rowDic objectForKey:@"info"]objectForKey:@"phone"]!=nil)&&([[_rowDic objectForKey:@"info"]objectForKey:@"phone"]!=[NSNull null]))
                {
                    [_arrOfBasicInfoData addObject: [[_rowDic objectForKey:@"info"]objectForKey:@"phone"]];
                }
                else
                {
                    [_arrOfBasicInfoData addObject: @"xxxxxxxx"];
                }
                
                
                //---CRASH FIXED---//
                //---IF RELATIONSHIP IS NIL THEN SHOW DEFAULT FATHER---//
                if ([[_rowDic objectForKey:@"info"] objectForKey:@"relationship"] != [NSNull null]){
                    _strRelationShip=[[_rowDic objectForKey:@"info"]objectForKey:@"relationship"];
                    
                    _strRelationShip = [NSString stringWithFormat:@"%@%@",[[_strRelationShip substringToIndex:1] uppercaseString],[_strRelationShip substringFromIndex:1] ];
                }
                //---CRASH FIXED---//
                delegate.parent.relationship = _strRelationShip;
                [_arrOfBasicInfoData addObject: _strRelationShip];
                [[NSUserDefaults standardUserDefaults] setObject:_strRelationShip forKey:@"relationship"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                _strName  = [[_rowDic objectForKey:@"info"]objectForKey:@"name"];
                _strEmail = [[_rowDic objectForKey:@"info"]objectForKey:@"email"];
                _strPhone = [[_rowDic objectForKey:@"info"]objectForKey:@"phone"];
                
                _strLanguage=[[_rowDic objectForKey:@"info"]objectForKey:@"language"];
                _rowkSettings=[[_rowDic objectForKey:@"settings"] mutableCopy];
                
                [txtLang resignFirstResponder];
                [txtRelation resignFirstResponder];
                
                txtRelation.selectedItem=_strRelationShip;
                NSLog(@"Mustafa007==%@",_strRelationShip);
                
                [[NSUserDefaults standardUserDefaults] setObject:_strRelationShip forKey:@"ParentRelationship"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                NSString *Language_id=@"";
                for(int i=0;i<[_rowklanguages count];i++)
                {
                    NSString *strTemp=  [[_rowklanguages objectAtIndex:i] objectForKey:@"code"];
                    if([strTemp isEqualToString:_strLanguage])
                    {
                        Language_id=[[_rowklanguages objectAtIndex:i] objectForKey:@"name"];
                        break;
                    }
                }
                _strLanguage=  Language_id;
                //[_tableView reloadData];
                
                SwiftParentDrawer *drawerVC = (SwiftParentDrawer*)((JASidePanelController *)[[self parentViewController] parentViewController]).leftPanel;
                if(drawerVC != nil) {
                    [drawerVC reloadView];
                }
                
            }
            else
            {
                [CommonModel showAlert:[@"Please connect your device with the Internet and try again." myModification] msg:@""];
            }
            
        });
    }];
    
    
}
-(void)doneClicked:(UIBarButtonItem*)button
{
    [self.view endEditing:YES];
    //    [self UpdateProfile];
    
    //    NSLog(@"textFieldTextPicker.selectedItem: %@", textFieldTextPicker.selectedItem);
    //    NSLog(@"textFieldOptionalTextPicker.selectedItem: %@", textFieldOptionalTextPicker.selectedItem);
    //    NSLog(@"textFieldDatePicker.selectedItem: %@", textFieldDatePicker.selectedItem);
    //    NSLog(@"textFieldTimePicker.selectedItem: %@", textFieldTimePicker.selectedItem);
    //    NSLog(@"textFieldDateTimePicker.selectedItem: %@", textFieldDateTimePicker.selectedItem);
}

-(void)UpdateProfile
{
    
    [_txtName resignFirstResponder];
    [_txtPhone resignFirstResponder];
   // [_txtEmail resignFirstResponder];
    
    
    //    NSString *strUser_Id= [[[_rowDic objectForKey:@"active"] objectAtIndex:indexPath.row]objectForKey:@"user_id"];
    //    //https://mesh.familytime.io/v2/ftd/user/management/2922
    
    NSLog(@"%@",_strLanguage);
    NSLog(@"%@",_strRelationShip);
    
    [SwiftFTUtils showHUDAddedTo:self.view withText:[@"loading..." myModification] animated:YES];
    //        NSString *url = [NSString stringWithFormat:@"https://mesh.familytime.io/v2/ftd/user/invite"];
    NSString *url = [NSString stringWithFormat:@"%@/dashboard/user/",kBasUrlNew_mesh2];
    NSLog(@"URL=%@",url);
    
    //    NSArray *arr=[NSArray new];
    
    //**************
    
    NSString *Language_id=@"";
    //    NSMutableArray *arr= [[NSUserDefaults standardUserDefaults] objectForKey:@"AllBuilding"];
    for(int i=0;i<[_rowklanguages count];i++)
    {
        
        NSString *strTemp=  [[_rowklanguages objectAtIndex:i] objectForKey:@"name"];
        if([strTemp isEqualToString:_strLanguage])
        {
            Language_id=[[_rowklanguages objectAtIndex:i] objectForKey:@"code"];
            break;
        }
    }
    
    
    
    
    
    //***************
    
    _strName=_txtName.text;
    _strPhone=_txtPhone.text;
    //    _strPhone=_txtPhone.text;
    
    
    //NSDictionary *paramsDictionary = @{@"name":_strName,@"phone":_strPhone,@"relationship":_strRelationShip,@"language":Language_id};
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_strName forKey:@"name"];
    [params setObject:_strRelationShip forKey:@"relationship"];
    [params setObject:_strPhone forKey:@"phone"];
    [params setObject:Language_id forKey:@"language"];
      
      NSError *error;
      NSData * jsonData  = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
      NSString *myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    //    NSArray *params=[[NSArray alloc]initWithObjects:strUser_Id, nil];
    
//    NSString *jsonString;
//    {
//
//        NSError *error;
//        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params
//                                                           options:NSJSONWritingPrettyPrinted // Pass 0 if you don't  care about the readability of the generated string
//                                                             error:&error];
//
//        if (! jsonData)
//        {
//            NSLog(@"Got an error: %@", error);
//        }
//        else
//        {
//            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//            NSLog(@"%@", jsonString);
//        }
//    }
    
    NSLog(@"url = %@ and json = %@", url, myString);
    
    
    /*
    
    [JSONHTTPClient patchJSONFromURLWithString:url bodyString:jsonString completion:^(id json, JSONModelError *err) {
        //NSError *error;
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        
        NSLog(@"hehe==%@",json);
        if([[json valueForKey:@"status_code"] intValue] == 200)
        {
            //            [CommonModel showAlert:@"" msg:[json valueForKey:@"response"]];
            //   [self refreshScreen];
            if([Language_id isEqualToString:@""])
            {
            }
            else
            {
                if( checklanguageChange==1)
                {
                    [[NSUserDefaults standardUserDefaults] setObject:@[Language_id,@"ru"] forKey:@"AppleLanguages"];
                    
                    
                    UIAlertController *alertController = [UIAlertController
                                                          alertControllerWithTitle:[@"Application Language Changed" myModification]
                                                          message:[@"Please restart app to view app in new language" myModification]
                                                          preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *cancelAction = [UIAlertAction
                                                   actionWithTitle:NSLocalizedString(@"Ok", @"Cancel action")
                                                   style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction *action)
                                                   {
                                                       NSLog(@"Cancel action");
                                                   }];
                    
                    [alertController addAction:cancelAction];
                    //                [alertController addAction:okAction];
                    [self presentViewController:alertController animated:YES completion:nil];
                }
                else
                {
                    UIAlertController *alertController = [UIAlertController
                                                          alertControllerWithTitle:[@"Profile Updated" myModification]
                                                          message:[@"Profile updated successfully" myModification]
                                                          preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *cancelAction = [UIAlertAction
                                                   actionWithTitle:NSLocalizedString(@"Ok", @"Cancel action")
                                                   style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction *action)
                                                   {
                                                       NSLog(@"Cancel action");
                                                   }];
                    
                    [alertController addAction:cancelAction];
                    [self presentViewController:alertController animated:YES completion:nil];
                }
            }
        }
        else
        {
            [CommonModel showAlert:@"" msg:[json valueForKey:@"response"]];
        }
    }];
    
    
    */
    
    
    //---NATIVE API CALLING---//
    
    [[ApiManager shared] mesh_putApiWithParamString:params withApi:url withResponse:^(NSDictionary * _Nonnull json, NSInteger errorCode, NSString * _Nonnull message) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            
            NSLog(@"Native put api json response == %@",json);
            
            if([[json valueForKey:@"status"] intValue] == 200)
            {
//                UserModel  *threads = [[UserModel alloc] initWithDictionary:paramsDictionary error:nil];
//                delegate.parent = threads;
//                [delegate.userDefault setObject:threads forKey:@"user"];
//                threads.name = _strName;
//                threads.email = _strEmail;
//                threads.phone = _strPhone;
//                threads.language = Language_id;
                
                [NSUserDefaults.standardUserDefaults setObject:_strName forKey:@"userName"];
                [NSUserDefaults.standardUserDefaults setObject:_strPhone forKey:@"userPhone"];
                [NSUserDefaults.standardUserDefaults setObject:_strRelationShip forKey:@"userRelation"];
                [NSUserDefaults.standardUserDefaults setObject:Language_id forKey:@"userlanguage"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updateDrawer" object:nil];
                
                if([Language_id isEqualToString:@""]);
                else
                {
                    if( checklanguageChange==1)
                    {
                        [[NSUserDefaults standardUserDefaults] setObject:@[Language_id,@"ru"] forKey:@"AppleLanguages"];
                        
                        
                        UIAlertController *alertController = [UIAlertController
                                                              alertControllerWithTitle:[@"Application Language Changed" myModification]
                                                              message:[@"Please restart app to view app in new language" myModification]
                                                              preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *cancelAction = [UIAlertAction
                                                       actionWithTitle:NSLocalizedString(@"Ok", @"Cancel action")
                                                       style:UIAlertActionStyleCancel
                                                       handler:^(UIAlertAction *action)
                                                       {
                                                           NSLog(@"Cancel action");
                                                       }];
                        
                        [alertController addAction:cancelAction];
                        //                [alertController addAction:okAction];
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                    else
                    {
                        //[self viewParentProfiledata];
                        [_tableView reloadData];
                        UIAlertController *alertController = [UIAlertController
                                                              alertControllerWithTitle:[@"Profile Updated" myModification]
                                                              message:[@"Profile updated successfully" myModification]
                                                              preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *cancelAction = [UIAlertAction
                                                       actionWithTitle:NSLocalizedString(@"Ok", @"Cancel action")
                                                       style:UIAlertActionStyleCancel
                                                       handler:^(UIAlertAction *action)
                                                       {
                                                           NSLog(@"Cancel action");
                                                       }];
                        
                        [alertController addAction:cancelAction];
                        [self presentViewController:alertController animated:YES completion:nil];
                        
                        
                    }
                }
                
                [_tableView reloadData];
            }
            else
            {
                [CommonModel showAlert:@"" msg:[json valueForKey:@"response"]];
            }
        });
    }];

}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [rightButton setTitle:[@"Save" myModification]];
    
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField==txtRelation)
    {
        checklanguageChange = 0;
        _strRelationShip    = textField.text;
        //        [self UpdateProfile];
        
    }
    else if(textField==txtLang)
    {
        checklanguageChange=1;
        
        _strLanguage=textField.text;
        //        [self UpdateProfile];
        
    }
    //    */
    
    //    _strLanguage=textField.text;
    //    [self UpdateProfile];
    
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18+5)];
    UIView *viewTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 1)];
    UIView *viewBottom = [[UIView alloc] initWithFrame:CGRectMake(0, 17, tableView.frame.size.width, 1)];
    
    [viewTop setBackgroundColor:[UIColor lightGrayColor]];
    [viewBottom setBackgroundColor:[UIColor lightGrayColor]];
    
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(17+1, 10, tableView.frame.size.width, 23)];
    [label setFont:[UIFont boldSystemFontOfSize:12]];
    //    NSString *string =[list objectAtIndex:section];
    NSString *string =@"";
    [view setBackgroundColor:[UIColor whiteColor]];
    if(section==1)
    {
        string= @"Subscription";
        //        return @"Basic information";
        //        return @"Languages";
        
    }
    else if(section==2)
    {
        string= [@"Basic Information" myModification];
        
    }
    else if(section==3)
    {
        //        string= @"Change Language";
        string= @"";
        return nil;
        
        //        string= @"";
        //        [view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        //        UIView *viewTop = [[UIView alloc] initWithFrame:CGRectMake(0, -0.5, tableView.frame.size.width, 0.5)];
        //        UIView *viewBottom = [[UIView alloc] initWithFrame:CGRectMake(0, 28.5, tableView.frame.size.width, 0.5)];
        //        [viewTop setBackgroundColor:[UIColor lightGrayColor]];
        //        [viewBottom setBackgroundColor:[UIColor lightGrayColor]];
        //        [view addSubview:viewTop];
        //        [view addSubview:viewBottom];
        
    }
    else if(section==4)
    {
        //        return nil;
        string= @"";
        [view setFrame:CGRectMake(0, 0, tableView.frame.size.width, 13.0)];
        
        [view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        UIView *viewTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 0.5)];
        UIView *viewBottom = [[UIView alloc] initWithFrame:CGRectMake(0, 12.5, tableView.frame.size.width, 0.5)];
        
        
        //200 199 204
        [viewTop setBackgroundColor:[UIColor colorWithRed:200.0/255.0 green:199.0/255 blue:204.0/255 alpha:1.0]];
        [viewBottom setBackgroundColor:[UIColor colorWithRed:200.0/255.0 green:199.0/255 blue:204.0/255 alpha:1.0]];
        
        //        [viewBottom setBackgroundColor:[UIColor lightGrayColor]];
        [view addSubview:viewTop];
        [view addSubview:viewBottom];
        
    }
    else
    {
        string= @"";
    }
    /* Section header is in 0th index... */
    [label setText:string];
    [view addSubview:label];
    
    //    [view addSubview:viewTop];
    //    [view addSubview:viewBottom];
    
    
    //    [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:1.0]]; //your background color...
    //    [view setBackgroundColor:[UIColor whiteColor]]; //your background color...
    label.textColor=[UIColor colorWithRed:114.0/255.0 green:102.0/255.0 blue:186.0/255.0 alpha:1.0];
    
    
    label.font=[UIFont fontWithName:@"OpenSans-semibold" size:17];
    
    
    //    if(section==4)
    //    {
    //        //        return nil;
    //        return nil;
    //
    //    }
    return view;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
    
    
    if(section==0)
    {
        return nil;
    }
    else if(section==1)
    {
        return nil;
    }
    else if(section==2)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
        
        UIView *viewTop = [[UIView alloc] initWithFrame:CGRectMake(0, -0.5, tableView.frame.size.width, 0.5)];
        UIView *viewBottom = [[UIView alloc] initWithFrame:CGRectMake(0, 19.5, tableView.frame.size.width, 0.5)];
        
        [viewTop setBackgroundColor:[UIColor lightGrayColor]];
        [viewBottom setBackgroundColor:[UIColor lightGrayColor]];
        
        
        /* Create custom view to display section header... */
        //    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 18)];
        //    [label setFont:[UIFont boldSystemFontOfSize:12]];
        //    //    NSString *string =[list objectAtIndex:section];
        //    NSString *string =@"kakak";
        //
        //    /* Section header is in 0th index... */
        //    [label setText:string];
        //    [view addSubview:label];
        //    [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:1.0]]; //your background color...
        
        [view addSubview:viewTop];
        [view addSubview:viewBottom];
        
        [view setBackgroundColor:[UIColor groupTableViewBackgroundColor]]; //your background color...
        //    label.textColor=[UIColor blackColor];
        return view;
    }
    else if(section==3)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
        
        UIView *viewTop = [[UIView alloc] initWithFrame:CGRectMake(0, -0.5, tableView.frame.size.width, 0.5)];
        UIView *viewBottom = [[UIView alloc] initWithFrame:CGRectMake(0, 19.5, tableView.frame.size.width, 0.5)];
        
        [viewTop setBackgroundColor:[UIColor lightGrayColor]];
        [viewBottom setBackgroundColor:[UIColor lightGrayColor]];
        
        
        /* Create custom view to display section header... */
        //    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 18)];
        //    [label setFont:[UIFont boldSystemFontOfSize:12]];
        //    //    NSString *string =[list objectAtIndex:section];
        //    NSString *string =@"kakak";
        //
        //    /* Section header is in 0th index... */
        //    [label setText:string];
        //    [view addSubview:label];
        //    [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:1.0]]; //your background color...
        
        [view addSubview:viewTop];
        [view addSubview:viewBottom];
        
        [view setBackgroundColor:[UIColor groupTableViewBackgroundColor]]; //your background color...
        //    label.textColor=[UIColor blackColor];
        return view;
    }
    //    else if(section==4)
    //    {
    //        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
    //
    //        UIView *viewTop = [[UIView alloc] initWithFrame:CGRectMake(0, -0.5, tableView.frame.size.width, 0.5)];
    //        UIView *viewBottom = [[UIView alloc] initWithFrame:CGRectMake(0, 19.5, tableView.frame.size.width, 0.5)];
    //
    //        [viewTop setBackgroundColor:[UIColor lightGrayColor]];
    //        [viewBottom setBackgroundColor:[UIColor lightGrayColor]];
    //
    //
    //        /* Create custom view to display section header... */
    //        //    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 18)];
    //        //    [label setFont:[UIFont boldSystemFontOfSize:12]];
    //        //    //    NSString *string =[list objectAtIndex:section];
    //        //    NSString *string =@"kakak";
    //        //
    //        //    /* Section header is in 0th index... */
    //        //    [label setText:string];
    //        //    [view addSubview:label];
    //        //    [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:1.0]]; //your background color...
    //
    //        [view addSubview:viewTop];
    //        [view addSubview:viewBottom];
    //
    //        [view setBackgroundColor:[UIColor groupTableViewBackgroundColor]]; //your background color...
    //        //    label.textColor=[UIColor blackColor];
    //        return view;
    //    }
    else
    {
        return nil;
    }
    
}

- (void) refreshTableView
{
    refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(viewParentProfiledata) forControlEvents:UIControlEventValueChanged];
}

- (void)refreshTable
{
    [refreshControl endRefreshing];
    [self.tableView reloadData];
}
@end


