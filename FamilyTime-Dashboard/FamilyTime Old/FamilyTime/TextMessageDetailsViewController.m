//
//  TextMessageDetailsViewController.m
//  FamilyTime - Dashboard
//
//  Created by Muhammad Ajmal on 23/08/2016.
//  Copyright © 2016 SoraCode. All rights reserved.
//

#import "TextMessageDetailsViewController.h"
#import "MessageCell.h"

#import "AppDelegate.h"
#import "MBProgressHUD.h"
//#import "JSONHTTPClient.h"
#import "FTD.h"
#import "FTUtils.h"
//#import <Google/Analytics.h>
#import "DataModel.h"
#import "STBubbleTableViewCell.h"
#import "FamilyTime-Swift.h"

AppDelegate *delegate;
UIRefreshControl *  refreshControl;

@interface TextMessageDetailsViewController ()<STBubbleTableViewCellDataSource, STBubbleTableViewCellDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableDictionary *parsedMessages;
@property (nonatomic, strong) NSMutableArray *dates;
@end

@implementation TextMessageDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
     delegate = [AppDelegate appDelegate];
    
    if([SwiftFTUtils isDeviceiPhoneFamily])
        self.tableView = [[UITableView alloc] initWithFrame:CGRectInset(self.view.bounds, 20, 10) style:UITableViewStyleGrouped];
    else
        self.tableView = [[UITableView alloc] initWithFrame:CGRectInset(self.view.bounds, 35, 20) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f,self.view.frame.size.width, 10.0f)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    //[self.tableView registerClass:[MessageCell class] forCellReuseIdentifier: @"MessageCell"];
    
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 40, 0)];
    
    
    [self addPullRefresh];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [self loadMessagesDetails];
}

- (void) addPullRefresh
{
    refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(loadMessagesDetails) forControlEvents:UIControlEventValueChanged];
}

- (void)refreshTable
{
    [refreshControl endRefreshing];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadMessagesDetails
{
    [SwiftFTUtils showHUDAddedTo:self.view withText:@"Loading..." animated:YES];
    NSString *child_id = [[NSUserDefaults standardUserDefaults] stringForKey:@"selectedChildId"];
    double childId = [child_id doubleValue];
    NSString *url = [NSString stringWithFormat:@"%@/dashboard/messages/%@/%@",kBasUrlNew_mesh2,child_id,self.thread_id];
    
    NSLog(@"%@", url);
    
    /*
    
    [JSONHTTPClient getJSONFromURLWithString:url
                                      params:nil
                                  completion:^(id json, JSONModelError *err) {
                                      NSError *error;
                                      // read response code
                                      if([[json valueForKey:@"status_code"] integerValue] == 200)
                                      {
                                          NSLog(@"%@",json);
                                          
                                          MessagesModel *thread = [[MessagesModel alloc] initWithDictionary:json error:&error];
                                          NSLog(@"%@",thread);
                                          self.parsedMessages = [NSMutableDictionary dictionary];
                                          self.messages = [NSMutableArray array];
                                          self.dates = [NSMutableArray array];
                                          
                                          for (NSInteger index = 0; index < thread.response.count; index++)
                                          {
                                              MessageModel *tmsg = (MessageModel *)[thread.response objectAtIndex:index];
                                              Message *message = [[Message alloc] init];
                                              if([tmsg.is_sent integerValue])
                                              {
                                                  message.sender = MessageSenderMyself;
                                                  message.status = MessageStatusSent;
                                                  
                                                  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                                                  [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                                                  NSDate *date = [dateFormatter dateFromString:tmsg.message_date];
                                                  message.date = date;
                                              }
                                              if([tmsg.is_received integerValue])
                                              {
                                                  message.sender = MessageSenderSomeone;
                                                  message.status = MessageStatusReceived;
                                                  
                                                  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                                                  [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                                                  NSDate *date = [dateFormatter dateFromString:tmsg.message_date];
                                                  message.date = date;
                                              }
                                              message.identifier = tmsg.sms_id;
                                              message.chat_id = tmsg.thread_id;
                                              message.text  = tmsg.body;
                                              
                                              [self.messages addObject:message];
                                              
                                              
                                              //add message to parsed data
                                              if([self isdateAlreadyExists:message])
                                              {
                                                  [self addMessageToExistingDate:message];
                                              }
                                              else
                                              {
                                                  [self addNewDateWithMessage:message];
                                              }
                                          }
                                      }
                                      else
                                          [CommonModel showAlert:@"Error!" msg:[json valueForKey:@"status_message"]];
                                      [refreshControl endRefreshing];
                                      [self refreshTable];
                                      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                  }];
    
    */
    
    //---NATIVE API CALLING---//
    
    [[ApiManager shared] mesh_getApiWithApi:url withResponse:^(NSDictionary * _Nonnull json, NSInteger errorCode, NSString * _Nonnull message) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"Old Mesh api Text MEssages Detail json = %@",json);
            
            NSError *error;
            // read response code
            if([[json valueForKey:@"status"] integerValue] == 200)
            {
                MessagesModel *thread = [[MessagesModel alloc] initWithDictionary:json error:&error];
                NSLog(@"Message Thread = %@",thread);
                
                self.parsedMessages = [NSMutableDictionary dictionary];
                self.messages = [NSMutableArray arrayWithArray:thread.messages];
                
                self.dates = [NSMutableArray array];
//                self.dataSource = [[[self.messages reverseObjectEnumerator] allObjects] mutableCopy];
                
//                self.dataSource = [NSMutableArray arrayWithArray:self.messages];
//                NSMutableArray *threadsArray = [NSMutableArray]
                
                //This code is use for sorting date in descending order according to date
                NSArray *sortedArray;
                sortedArray = [self.messages sortedArrayUsingComparator:^NSComparisonResult(MessageModel *a, MessageModel *b) {
                    return [a.message_date compare:b.message_date];
                    
                }];
                
                self.dataSource = [[[sortedArray reverseObjectEnumerator] allObjects] mutableCopy];
                //This code is use for sorting date in descending order according to date// end
                
                NSLog(@"%i", self.dataSource.count);
                
                for (NSInteger index = 0; index < self.dataSource.count; index++)
                {
                    MessageModel *tmsg = (MessageModel *)[self.dataSource objectAtIndex:index];
                    Message *message = [[Message alloc] init];
                    NSLog(@"isSend = %@",tmsg.is_sent);
                    
                    if([tmsg.is_sent integerValue])
                    {
                        message.sender = MessageSenderMyself;
                        message.status = MessageStatusSent;
                        
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                        NSDate *date = [dateFormatter dateFromString:tmsg.message_date];
                        message.date = date;
                    }
                    if([tmsg.is_received integerValue])
                    {
                        message.sender = MessageSenderSomeone;
                        message.status = MessageStatusReceived;
                        
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                        NSDate *date = [dateFormatter dateFromString:tmsg.message_date];
                        message.date = date;
                    }
                    message.identifier = tmsg.sms_id;
                    message.chat_id = tmsg.thread_id;
                    message.text  = tmsg.body;
                    
                    [self.messages addObject:message];
                    
                    
                    //add message to parsed data
                    if([self isdateAlreadyExists:message])
                    {
                        [self addMessageToExistingDate:message];
                    }
                    else
                    {
                        [self addNewDateWithMessage:message];
                    }
                }
            }
            else
                [CommonModel showAlert:@"Error!" msg:[json valueForKey:@"message"]];
            
            [refreshControl endRefreshing];
            [self refreshTable];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        });
    }];
    
}

- (BOOL)isdateAlreadyExists:(Message *)message
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [dateFormatter stringFromDate:message.date];

    for (NSString *date in self.dates)
    {
        if([date isEqualToString:strDate])
            return YES;
    }
    return NO;
}

- (void)addNewDateWithMessage:(Message *)message
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [dateFormatter stringFromDate:message.date];
    if(strDate==nil)
    {
        strDate=@"";
    }
    [self.dates addObject:strDate];
    
    NSMutableArray *newArray = [NSMutableArray array];
    [newArray addObject:message];
    [self.parsedMessages setObject:newArray forKey:strDate];
}

- (void)addMessageToExistingDate:(Message *)message {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [dateFormatter stringFromDate:message.date];
    
    NSMutableArray *existingArray = (NSMutableArray *)[self.parsedMessages objectForKey:strDate];
    [existingArray addObject:message];
    [self.parsedMessages setObject:existingArray forKey:strDate];
}

/*
#pragma mark - TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dates.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = [self.dates objectAtIndex:section];
    NSMutableArray *messages = [self.parsedMessages objectForKey:key];
    return messages.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MessageCell";
    NSString *key = [self.dates objectAtIndex:indexPath.section];
    NSMutableArray *messages = [self.parsedMessages objectForKey:key];
    
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.message = [messages objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Message *message = [self.messages objectAtIndex:indexPath.row];
    return message.heigh;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *key = [self.dates objectAtIndex:section];
    NSMutableArray *messages = [self.parsedMessages objectForKey:key];
    Message *message = (Message *)[messages objectAtIndex:0];
    NSInteger days = [self daysBetweenDate:message.date andDate:[NSDate date]];
    
     if (days == 0)
     {
         return @"TODAY";
     }
    else if(days == 1)
    {
        return @"YESTERDAY";
    }
    else
    {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"EEEE, MMM dd"];
        return [df stringFromDate:message.date];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect frame = CGRectMake(0, 0, tableView.frame.size.width, 40);
    
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor clearColor];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    UILabel *label = [[UILabel alloc] init];
    label.text = [self tableView:tableView titleForHeaderInSection:section];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"Helvetica" size:20.0];
    [label sizeToFit];
    label.center = view.center;
    label.font = [UIFont fontWithName:@"Helvetica" size:13.0];
    label.backgroundColor = [UIColor colorWithRed:207/255.0 green:220/255.0 blue:252.0/255.0 alpha:1];
    label.layer.cornerRadius = 10;
    label.layer.masksToBounds = YES;
    label.autoresizingMask = UIViewAutoresizingNone;
    [view addSubview:label];
    
    return view;
}
*/

#pragma mark - UITableViewDatasource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dates.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = [self.dates objectAtIndex:section];
    NSMutableArray *messages = [self.parsedMessages objectForKey:key];
    return messages.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *key = [self.dates objectAtIndex:section];
    NSMutableArray *messages = [self.parsedMessages objectForKey:key];
    Message *message = (Message *)[messages objectAtIndex:0];
    NSInteger days = [self daysBetweenDate:message.date andDate:[NSDate date]];
    
    if (days == 0)
    {
        return [@"Today" myModification];
    }
    else if(days == 1)
    {
        return [@"Yesterday" myModification];
    }
    else
    {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"EEEE, MMM dd"];
        return [df stringFromDate:message.date];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect frame = CGRectMake(0, 0, tableView.frame.size.width, 40);
    
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor clearColor];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    UILabel *label = [[UILabel alloc] init];
    label.text = [self tableView:tableView titleForHeaderInSection:section];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"Helvetica" size:20.0];
    [label sizeToFit];
    label.center = view.center;
    label.font = [UIFont fontWithName:@"Helvetica" size:13.0];
//    label.backgroundColor = [UIColor colorWithRed:207/255.0 green:220/255.0 blue:252.0/255.0 alpha:1];
    label.backgroundColor = [UIColor clearColor];
    label.textColor=[UIColor lightGrayColor];
    label.layer.cornerRadius = 10;
    label.layer.masksToBounds = YES;
    label.autoresizingMask = UIViewAutoresizingNone;
    [view addSubview:label];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Bubble Cell";
    
    STBubbleTableViewCell *cell = (STBubbleTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[STBubbleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = self.tableView.backgroundColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.dataSource = self;
        cell.delegate = self;
    }
    
    NSString *key = [self.dates objectAtIndex:indexPath.section];
    NSMutableArray *messages = [self.parsedMessages objectForKey:key];
    Message *message = [messages objectAtIndex:indexPath.row];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    
    NSMutableAttributedString *messageStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n",message.text]];
    if(message.sender == MessageSenderMyself)
    {
        [messageStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, messageStr.length)];
    }
    else
    {
        [messageStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x252525) range:NSMakeRange(0, messageStr.length)];
    }
    [messageStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:15.0f] range:NSMakeRange(0, messageStr.length)];
    [attributedString appendAttributedString:messageStr];
    
    //Set Text to Label
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.timeStyle = NSDateFormatterShortStyle;
    df.dateStyle = NSDateFormatterNoStyle;
    df.doesRelativeDateFormatting = YES;
    NSString *time = [df stringFromDate:message.date];
    
    NSMutableAttributedString *dateStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",time]];
    [dateStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:10.0f] range:NSMakeRange(0, dateStr.length)];
    if(message.sender == MessageSenderMyself)
    {
        [dateStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xcbe9fe) range:NSMakeRange(0, dateStr.length)];
    }
    else
    {
        [dateStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x656462) range:NSMakeRange(0, dateStr.length)];
    }
    [attributedString appendAttributedString:dateStr];

    if (message.sender == MessageSenderMyself)
    {
        cell.authorType = STBubbleTableViewCellAuthorTypeSelf;
        cell.bubbleView.tintColor = UIColorFromRGB(0x3daefe);
    }
    else
    {
        cell.authorType = STBubbleTableViewCellAuthorTypeOther;
        cell.bubbleView.tintColor = UIColorFromRGB(0xe6e5eb);
    }
    
    cell.textLabel.attributedText = attributedString;
    return cell;
}

#pragma mark - UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [self.dates objectAtIndex:indexPath.section];
    NSMutableArray *messages = [self.parsedMessages objectForKey:key];
    Message *message = [messages objectAtIndex:indexPath.row];
    
    NSString *str = [NSString stringWithFormat:@"%@\n%@",message.text,[[NSDate date] description]];
    
    CGSize size;
    
    if(false)// if message has avartar
    {
        size = [message.text boundingRectWithSize:CGSizeMake(self.tableView.frame.size.width - [self minInsetForCell:nil atIndexPath:indexPath] - STBubbleImageSize - 8.0f - STBubbleWidthOffset, CGFLOAT_MAX)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:15]}
                                             context:nil].size;
    }
    else
    {
        size = [str boundingRectWithSize:CGSizeMake(self.tableView.frame.size.width - [self minInsetForCell:nil atIndexPath:indexPath] - STBubbleWidthOffset, CGFLOAT_MAX)
                                 options:NSStringDrawingUsesLineFragmentOrigin
                              attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:15]}
                                 context:nil].size;
    }
    
    // This makes sure the cell is big enough to hold the avatar
    //if(size.height + 15.0f < STBubbleImageSize + 4.0f && message.avatar)
    if(size.height + 15.0f < STBubbleImageSize + 4.0f && false)
    {
        return STBubbleImageSize + 4.0f;
    }
    
    return size.height + 15.0f;
}

#pragma mark - STBubbleTableViewCellDataSource methods

- (CGFloat)minInsetForCell:(STBubbleTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if ([SwiftFTUtils isDeviceiPhoneFamily])
    {
        return 50.0f;
    }
    else
    {
        return 300;
    }
}

- (void)loadFakeMessages
{
    self.messages = [NSMutableArray array];
    for (NSInteger index = 0; index < 20; index++) {
        Message *message = [[Message alloc] init];
        int randNum = rand() % (10 - 0) + 0;
        if (randNum%2 == 0)
        {
            message.sender = MessageSenderMyself;
            message.status = MessageStatusSent;
        }
        else {
            message.sender = MessageSenderSomeone;
            message.status = MessageStatusReceived;
        }
        
        message.identifier = [NSString stringWithFormat:@"A%ld",(long)index];
        message.chat_id = [NSString stringWithFormat:@"AA%ld",(long)index];
        message.text = [NSString stringWithFormat:@"This is a simple message for testing number %ld", (long)index];
        message.date = [NSDate date];
        [self.messages addObject:message];
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

@end
