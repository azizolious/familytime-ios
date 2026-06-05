//
//  LogsModel.h
//  FamilyTime
//
//  Created by Sora Code on 12/18/14.
//  Copyright (c) 2014 SoraCode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@protocol ContactsModel
@end

@protocol BrowserModel
@end

@protocol BookmarksModel
@end

@protocol CallLogsModel
@end

@protocol BrowserBlockModel
@end

@interface LogsModel : NSObject

@end

@protocol BrowserHistoryModel
@end

//*************************************************
//                  ContactModel
//*************************************************
@interface ContactsModel : JSONModel
//@property (nonatomic, strong) NSString <Optional> * child_id;
//@property (nonatomic, strong) NSString <Optional> * contact_id;
//@property (nonatomic, strong) NSString <Optional> * date_created;
//@property (nonatomic, strong) NSString <Optional> * date_modified;
//@property (nonatomic, strong) NSString <Optional> * deleted;
@property (nonatomic, strong) NSString <Optional> *name;
@property (nonatomic, strong) NSString <Optional> * email;
@property int is_watched;
@property (nonatomic, strong) NSString <Optional> *phone_mobile;
@property (nonatomic, strong) NSString <Optional> *phone_home;
@property (nonatomic, strong) NSString <Optional> *phone_work;

@end

@interface ContactInnerModel : JSONModel

@property (nonatomic, strong) NSArray <ContactsModel> *data;

@property (nonatomic, strong) NSString <Optional> *first_page_url;
@property (nonatomic, strong) NSString <Optional> *last_page_url;
@property (nonatomic, strong) NSString <Optional> *next_page_url;
@property (nonatomic, strong) NSString <Optional> *path;
@property (nonatomic, strong) NSString <Optional> *prev_page_url;



@property (nonatomic, assign) int current_page;
@property (nonatomic, assign) int from;
@property (nonatomic, assign) int last_page;
@property (nonatomic, assign) int per_page;
@property (nonatomic, assign) int to;
@property (nonatomic, assign) int total;

@end
 
@interface AllContactsModel : JSONModel
@property (nonatomic, strong) ContactInnerModel <Optional> *contacts;
@property (nonatomic, strong) NSString <Optional> *message;
@property (nonatomic, assign) int status;
@end

//*************************************************
//                  BrowserModel
//*************************************************
@interface BookmarksModel : JSONModel
@property (nonatomic, strong) NSString <Optional> * browsinghistory_id;
@property (nonatomic, strong) NSString <Optional> *deleted;
@property (nonatomic, strong) NSString <Optional> *time_visit;
@property (nonatomic, strong) NSString <Optional> *title;
@property (nonatomic, strong) NSString <Optional> *url;
@property (nonatomic, strong) NSString <Optional> *domain;
@property (nonatomic, strong) NSString <Optional> *date_created;
@property (nonatomic, strong) NSString <Optional> *date_modified;
@end

@interface AllBookmarksModel : JSONModel
@property (nonatomic, strong) NSArray <BookmarksModel> *data;
@end
//*************************************************
//                  BrowserModel
//*************************************************
@interface BrowserModel : JSONModel
@property (nonatomic, strong) NSString <Optional> * browsinghistory_id;
@property (nonatomic, strong) NSString <Optional> *deleted;
@property (nonatomic, strong) NSString <Optional> *time_visit;
@property (nonatomic, strong) NSString <Optional> *title;
@property (nonatomic, strong) NSString <Optional> *url;
@property (nonatomic, strong) NSString <Optional> *domain;
@property (nonatomic, strong) NSString <Optional> *date_created;
@property (nonatomic, strong) NSString <Optional> *date_modified;
@end

@interface BrowserBlockModel : JSONModel
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSArray <BrowserModel> *logs;
@end

@interface AllBrowserModel : JSONModel
@property (nonatomic, strong) NSArray <BrowserBlockModel> *data;
@end
//*************************************************
//                  CallLogsModel
//*************************************************
@interface CallLogsModel : JSONModel
@property (nonatomic, strong) NSString <Optional> * call_id;
@property (nonatomic, strong) NSString <Optional> *deleted;
@property (nonatomic, strong) NSString <Optional> *call_time;
@property (nonatomic, strong) NSString <Optional> *contact_id;
@property (nonatomic, strong) NSString <Optional> *duration;
@property (nonatomic, strong) NSString <Optional> *date_created;
@property (nonatomic, strong) NSString <Optional> *date_modified;
@property (nonatomic, strong) NSString <Optional> *name;
@property (nonatomic, strong) NSString <Optional> *number;
@property (nonatomic, strong) NSString <Optional> *type;

@end

@interface AllCallLogsModel : JSONModel
@property (nonatomic, strong) NSArray <CallLogsModel> *callhistory;
@end
//*************************************************
//                  iOS Browser History
//*************************************************
@interface BrowserHistoryModel : JSONModel
@property (nonatomic, strong) NSString <Optional> * domain;
@property (nonatomic, strong) NSString <Optional> *title;
@property (nonatomic, strong) NSString <Optional> *total_visits;
@property (nonatomic, strong) NSString <Optional> *url;
@end

@interface BrowserHistory : JSONModel
@property (nonatomic, strong) NSArray <BrowserHistoryModel> *response;
@end
