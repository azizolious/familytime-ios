//
//  DataModel.h
//  FamilyTime
//
//  Created by Sora Code on 11/14/14.
//  Copyright (c) 2014 SoraCode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface DataModel : JSONModel

@end

@protocol UserModel
@end

@protocol UserDeviceModel
@end

@protocol ChildPrefence
@end

@protocol ChildModel
@end



@protocol FamilyModel
@end

@protocol PlaceModel
@end

@protocol PlaceVisit
@end

@protocol LocationModel
@end

@protocol RuleModel
@end

@protocol InternetScheduleModel
@end

@protocol InternetScheduleInnerModel
@end

@protocol MessageThreadModel
@end

@protocol MessageModel
@end

@protocol AccessControlRuleModel
@end

//@protocol AllSyncSettingsModel
//@end

@protocol IOSAppBlockerModel
@end


@protocol SyncSettingModel
@end

@protocol SyncSettingModelInternetFilter
@end

//---SANA CHANGE---//---SyncSettingModelInternetFilter WILL BE DEPRICATED---//

@protocol InternetFilterModel
@end

@protocol FilterModel
@end

@protocol InternetFilterMainModel
@end

//---SANA CHANGE---//---SyncSettingModelInternetFilter WILL BE DEPRICATED---//

@protocol SyncSettingResponse
@end

@protocol SyncSettingsApps
@end

@protocol BlistAppModel
@end

@protocol Preferences
@end




//===========App Blocker Android

@protocol AppBlockerModel
@end

@protocol AppBlockerResponse
@end

@protocol AppBlockerApp
@end

//------------Daily limit--------
@protocol DailyLimitApp
@end

@protocol DailyLimitResponse
@end


@protocol DailyLimitDashboard
@end

//---NEW SANA IAP PRODUCTS API RESPONSE MODELS---//

@protocol IAP_Product
@end


@protocol IAP_Dashboard
@end



@protocol FuntimeModel
@end

@protocol FuntimeDataModel
@end

@protocol AppUsageModel
@end

@protocol AppUsageInnerModel
@end

//*************************************************
//                  UserModel
//*************************************************

@interface UserModel : JSONModel

@property (nonatomic, strong) NSString* user_id;
@property (nonatomic, strong) NSString <Optional> * active;
@property (nonatomic, strong) NSString <Optional> *checkSum;
@property (nonatomic, strong) NSString <Optional> * super_user_id;
@property (nonatomic, strong) NSString <Optional> * uhash;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString <Optional>*gender;
@property (nonatomic, strong) NSString <Optional>*phone;
@property (nonatomic, strong) NSString <Optional>*relationship;
@property (nonatomic, strong) NSString <Optional>*birthday;
@property (nonatomic, strong) NSString <Optional> *cover_img_src;
@property (nonatomic, strong) NSString <Optional> *profile_img_src;
@property (nonatomic, strong) NSString <Optional>*date_created;
@property (nonatomic, strong) NSString <Optional> *date_modified;
@property (nonatomic, strong) NSString <Optional> *color;
@property (nonatomic, strong) NSString <Optional> *language;
@property (nonatomic, strong) NSString <Optional> *billing_status;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *type;
//@property (nonatomic, strong) NSString <Optional> *phonelock_status;
//@property (nonatomic, strong) NSString <Optional> * duration;

@end

//*************************************************
//                  UserDeviceModel
//*************************************************

@interface UserDeviceModel : JSONModel
@property (nonatomic, strong) NSString <Optional> *accuracy;
@property (nonatomic, strong) NSString <Optional> * address;
@property (nonatomic, strong) NSString <Optional> *battery_remaining;
@property (nonatomic, strong) NSString <Optional> * date_created;
@property (nonatomic, strong) NSString <Optional> * date_modified;
@property (nonatomic, strong) NSString <Optional>*deleted;
@property (nonatomic, strong) NSString <Optional>*device_id;
@property (nonatomic, strong) NSString <Optional>*latitude;
@property (nonatomic, strong) NSString <Optional>*longitude;
@property (nonatomic, strong) NSString <Optional>*signal_strength;
@property (nonatomic, strong) NSString <Optional>*wifi_name;
@end
//*************************************************
//                  pushModel
//*************************************************
@interface PushModel : JSONModel
@property (nonatomic, strong) NSString <Optional> * child_id;
@property (nonatomic, strong) NSString <Optional> * lat;
@property (nonatomic, strong) NSString <Optional> * longi;
@property (nonatomic, strong) NSString <Optional> * time;
@property (nonatomic, strong) NSString <Optional> * address;
@property (nonatomic, strong) NSString <Optional> * imgsrc;




//---SANA CHANGE---//
@property (nonatomic, strong) NSString <Optional> * childName;
@property (nonatomic, strong) NSString <Optional> * accuracy;
@property (nonatomic, strong) NSString <Optional> * pushType;
@property (nonatomic, strong) NSString <Optional> * typeCore;
@property (nonatomic, strong) NSString <Optional> * gender;
@property (nonatomic, strong) NSString <Optional> * descriptionn;
@property (nonatomic, strong) NSString <Optional> * placeName;
@property (nonatomic, strong) NSString <Optional> * speedLimit;
@property (nonatomic, strong) NSString <Optional> * currentSpeed;
@property (nonatomic, strong) NSString <Optional> * startLatitude;
@property (nonatomic, strong) NSString <Optional> * startLongitude;
@property (nonatomic, strong) NSString <Optional> * endLatitude;
@property (nonatomic, strong) NSString <Optional> * endLongitude;
@property (nonatomic, strong) NSString <Optional> * push_content;

@end


@interface AppUsageInnerModel : JSONModel

@property (nonatomic, strong) NSString <Optional> * app_name;
@property (nonatomic, strong) NSString <Optional> * package_name;
@property (nonatomic, strong) NSString <Optional> * total_app_usage;

@end

@interface AppUsageModel : JSONModel

@property (nonatomic, strong) NSString <Optional> * message;
@property (nonatomic, strong) NSString <Optional> * to_date;
@property (nonatomic, strong) NSString <Optional> * from_date;
@property (nonatomic, strong) NSArray <AppUsageInnerModel,Optional> *appusage;

//@property (nonatomic, strong) NSArray <ChildModel,Optional> *parents;

@property (nonatomic, assign) int status;

@end

//*************************************************
//                  childModel
//*************************************************
@interface ChildPrefence : JSONModel
@property (nonatomic, strong) NSString <Optional> * app_blocking;
@property (nonatomic, strong) NSString <Optional> * bookmark_history;
@property (nonatomic, strong) NSString <Optional> * browsing_history;
@property (nonatomic, strong) NSString <Optional> * call_logs;
@property (nonatomic, strong) NSString <Optional> * contact_logs;
@property (nonatomic, strong) NSString <Optional> * contact_watchlist;
@property (nonatomic, strong) NSString <Optional> * location_tracking;
@property (nonatomic, strong) NSString <Optional> * monitor_places;
@property (nonatomic, strong) NSString <Optional> * word_watchlist;
@property (nonatomic, strong) NSString <Optional> * phonelock_pin;
@property (nonatomic, strong) NSString <Optional> * monitor_places_alert;
@property (nonatomic, strong) NSString <Optional> * sos_alert;
@property (nonatomic, strong) NSString <Optional> *pickup_alert;
@property (nonatomic, strong) NSString <Optional> *contact_watchlist_alert;
@property (nonatomic, strong) NSString <Optional> *app_blocking_alert;
@property (nonatomic, strong) NSString <Optional> *speed_limit_alert;
@property (nonatomic, strong) NSString <Optional> *installed_app_logs;
@end

@interface ChildModel : JSONModel
@property (nonatomic, strong) NSString <Optional> * child_id;
@property (nonatomic, strong) NSString <Optional> * active;
@property (nonatomic, strong) NSString <Optional> *device;
@property (nonatomic, strong) NSString <Optional> * super_user_id;
@property (nonatomic, strong) NSString <Optional> * duration;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString <Optional>*gender;
@property (nonatomic, strong) NSString <Optional>*phone;
@property (nonatomic, strong) NSString <Optional>*email;
@property (nonatomic, strong) NSString <Optional>*relationship;
@property (nonatomic, strong) NSString <Optional>*birthday;
@property (nonatomic, strong) NSString <Optional>*expiry_date;
@property (nonatomic, strong) NSString <Optional> *package;
@property (nonatomic, strong) NSString <Optional> *activation_code;
@property (nonatomic, strong) NSString <Optional>*rel_type;
@property (nonatomic, strong) NSString <Optional>*type;
@property (nonatomic, strong) NSString <Optional> *user_id;
@property (nonatomic, strong) NSString <Optional>*imei_no;
@property (nonatomic, strong) NSString <Optional> *cover_img_src;
@property (nonatomic, strong) NSString <Optional> *profile_img_src;
@property (nonatomic, strong) ChildPrefence <Optional> *preferences;
@property (nonatomic, strong) NSString <Optional> *color;
@property (nonatomic, strong) NSString <Optional> *phonelock_status;
@property (nonatomic, strong) NSString <Optional> *child_mdm_hash;
@property (nonatomic, strong) NSString <Optional> *time_zone;

@end

@interface Child: JSONModel
@property (nonatomic, strong) ChildModel <Optional> *child;
@property (nonatomic, strong) ChildPrefence <Optional> *preferences;
@end

@interface Preferences: JSONModel
@property (nonatomic, strong) NSDictionary <Optional> *package_features;
@property (nonatomic, strong) ChildPrefence <Optional> *preferences;
@end

//*************************************************
//                  FamilyModel
//*************************************************
@interface FamilyModel : JSONModel
@property (nonatomic, strong) NSArray <ChildModel,Optional> *children;
@property (nonatomic, strong) NSArray <ChildModel,Optional> *parents;
@property (nonatomic, strong) UserDeviceModel <Optional> *device;
@property (nonatomic, strong) ChildModel <Optional> *child;
@property (nonatomic, strong) ChildModel <Optional> *parent;
//@property (nonatomic, strong) NSString <Optional> *message;
//@property (nonatomic, strong) NSString <Optional> * response;

@end

@interface Family : JSONModel
@property (nonatomic, strong) FamilyModel *mychildren;
@end

//*************************************************
//                  PlaceModel
//*************************************************






//"radius": 150,

//"checkin_alert": 1,



@interface PlaceModel : JSONModel
//@property (nonatomic, strong) NSString <Optional> * user_id;
@property (strong, nonatomic) NSString <Optional> * child_id;
//@property (nonatomic, strong) NSString <Optional> * id;
@property (strong, nonatomic) NSString <Optional> * place_id;
@property (strong, nonatomic) NSString <Optional> * location;
@property (strong, nonatomic) NSString <Optional> * address;
@property (strong, nonatomic) NSString <Optional> * latitude;
@property (strong, nonatomic) NSString <Optional> * longitude;
@property (strong, nonatomic) NSString <Optional> * radius;
@property (strong, nonatomic) NSString <Optional> * checkin_alert;


//---MESH 2 NEW PARAMS---//

@property (strong, nonatomic) NSString <Optional> * date_created;
@property (strong, nonatomic) NSString <Optional> * date_modified;
@property (strong, nonatomic) NSString <Optional> * created_at;
@property (strong, nonatomic) NSString <Optional> * updated_at;
@property (strong, nonatomic) NSString <Optional> * predefined;

@property (strong, nonatomic) NSString <Optional> * created_by_id;
@property (strong, nonatomic) NSString <Optional> * modified_by_id;

@property (nonatomic, assign) BOOL is_active;
@property (nonatomic, assign) BOOL deleted;


@end

@interface AllPlacesModel : JSONModel
@property (nonatomic, strong) NSArray <PlaceModel> *data;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, assign) int status;
@end

//*************************************************
//                  PlaceVisit
//*************************************************
@interface PlaceVisit : JSONModel
@property (strong, nonatomic) NSString <Optional> * address;
@property (strong, nonatomic) NSString <Optional> * checkin_time;
@property (strong, nonatomic) NSString <Optional> * child_id;
@property (strong, nonatomic) NSString <Optional> * date_created;
@property (strong, nonatomic) NSString <Optional> *date_modified;
@property (strong, nonatomic) NSString <Optional> *deleted;
@property (strong, nonatomic) NSString <Optional> *latitude;
@property (strong, nonatomic) NSString <Optional> *longitude;
@property (strong, nonatomic) NSString <Optional> *location;
@property (strong, nonatomic) NSString <Optional> *placecount;
@property (strong, nonatomic) NSString <Optional> *place_id;
@property (strong, nonatomic) NSString <Optional> *placevisit_id;
@end

@interface AllPlacesVisitModel : JSONModel
@property (nonatomic, strong) NSArray <PlaceVisit> *places;
@end

//*************************************************
//                  GeoLocaiton Model
//*************************************************
@interface LocationModel : JSONModel
@property (nonatomic, strong) NSString <Optional> *child_id;
@property (nonatomic, strong) NSString <Optional> *location;
@property (nonatomic, strong) NSString <Optional> *latitude;
@property (nonatomic, strong) NSString <Optional> *longitude;
@property (nonatomic, strong) NSString <Optional> *time_in;
@property (nonatomic, strong) NSString <Optional> *time_out;
@property (nonatomic, strong) NSString <Optional> *time_sent;

@end

@interface AllLocationModel : JSONModel
@property (nonatomic, strong) NSArray <LocationModel> *locations;
@end

//*************************************************
//                  BlacklistApps Model
//*************************************************
@interface BlistAppModel : JSONModel
@property (nonatomic, strong) NSString <Optional> *child_id;
@property (nonatomic, strong) NSString <Optional> *app_name;
@property (nonatomic, strong) NSString <Optional> *app_category;
@property (nonatomic, strong) NSString <Optional> *app_package_name;
@property (nonatomic, strong) NSString <Optional> *date_created;
@property (nonatomic, strong) NSString <Optional> *date_modified;
@property int deleted;
@property (nonatomic, strong) NSString <Optional> *installedapp_id;
@property int is_blacklisted;
@property float size;
@end

@interface AllBlistAppsModel : JSONModel
@property (nonatomic, strong) NSArray <BlistAppModel> *installedAppList;
@end


@interface InternetScheduleModel : JSONModel
@property (nonatomic, strong) NSArray <InternetScheduleInnerModel> *data;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, assign) int status;
@end


@interface InternetScheduleInnerModel : JSONModel
@property (nonatomic, assign) int  id;
@property (nonatomic, strong) NSString <Optional> * child_id;
@property (nonatomic, strong) NSString <Optional> * date_created;
@property (nonatomic, strong) NSString <Optional> *date_modified;
@property (nonatomic, strong) NSString <Optional> *is_active;
@property (nonatomic, strong) NSString <Optional> *is_activated;
@property (nonatomic, strong) NSString <Optional> *is_predefined;
@property (nonatomic, strong) NSString <Optional> *is_saturday;
@property (nonatomic, strong) NSString <Optional> *is_sunday;
@property (nonatomic, strong) NSString <Optional> *is_monday;
@property (nonatomic, strong) NSString <Optional> *is_tuesday;
@property (nonatomic, strong) NSString <Optional> *is_wednesday;
@property (nonatomic, strong) NSString <Optional> *is_thursday;
@property (nonatomic, strong) NSString <Optional> *is_friday;
@property (nonatomic, strong) NSString <Optional> *rule_name;
@property (nonatomic, strong) NSString <Optional> *time_end;
@property (nonatomic, strong) NSString <Optional> *time_start;
@property (nonatomic, strong) NSString <Optional> *function;
@property (nonatomic, strong) NSString <Optional> *rule_type;
@end

@interface AndroidRulesModel : JSONModel
@property (nonatomic, strong) NSArray <RuleModel> *data;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, assign) int status;
@end

@interface RuleModel : JSONModel
@property (nonatomic, strong) NSString <Optional> * child_id;
@property (nonatomic, strong) NSString <Optional> * date_created;
@property (nonatomic, strong) NSString <Optional> *date_modified;
@property (nonatomic, strong) NSString <Optional> *deleted;
@property (nonatomic, strong) NSString <Optional> *is_active;
@property (nonatomic, strong) NSString <Optional> *is_predefined;
@property (nonatomic, strong) NSString <Optional> *on_saturday;
@property (nonatomic, strong) NSString <Optional> *on_sunday;
@property (nonatomic, strong) NSString <Optional> *on_monday;
@property (nonatomic, strong) NSString <Optional> *on_tuesday;
@property (nonatomic, strong) NSString <Optional> *on_wednesday;
@property (nonatomic, strong) NSString <Optional> *on_thursday;
@property (nonatomic, strong) NSString <Optional> *on_friday;
@property (nonatomic, strong) NSString <Optional> *rule_function;
@property (nonatomic, strong) NSString <Optional> *rule_id;
@property (nonatomic, strong) NSString <Optional> *rule_name;
@property (nonatomic, strong) NSString <Optional> *rule_type;
@property (nonatomic, strong) NSString <Optional> *time_end;
@property (nonatomic, strong) NSString <Optional> *time_start;
@property (nonatomic, strong) NSString <Optional> * id;
@property (nonatomic, strong) NSMutableDictionary <Optional> *restriction;
@property (nonatomic, strong) NSMutableDictionary <Optional> *rule_config;

@end


@interface AllAccessControlRulesModel : JSONModel
@property (nonatomic, strong) NSString *message;
@property (nonatomic, assign) int status;
@property (nonatomic, strong) NSArray <AccessControlRuleModel> *data;
@end

@interface AccessControlRuleModel : JSONModel
@property (nonatomic, strong) NSString <Optional> * id;
@property (nonatomic, strong) NSString <Optional> * child_id;
@property (nonatomic, strong) NSString <Optional> *rule_name;
@property (nonatomic, strong) NSString <Optional> *is_active;
@property (nonatomic, strong) NSString <Optional> *rule_id;
@property (nonatomic, strong) NSString <Optional> *is_predefined;
@property (nonatomic, strong) NSString <Optional> *date_created;
@property (nonatomic, strong) NSString <Optional> *date_modified;
@property (nonatomic, strong) NSString <Optional> *is_saturday;
@property (nonatomic, strong) NSString <Optional> *is_sunday;
@property (nonatomic, strong) NSString <Optional> *is_monday;
@property (nonatomic, strong) NSString <Optional> *is_tuesday;
@property (nonatomic, strong) NSString <Optional> *is_wednesday;
@property (nonatomic, strong) NSString <Optional> *is_thursday;
@property (nonatomic, strong) NSString <Optional> *is_friday;
@property (nonatomic, strong) NSString <Optional> *time_end;
@property (nonatomic, strong) NSString <Optional> *time_start;
@property (nonatomic, strong) NSDictionary <Optional> *mdm_payload;
@property (nonatomic, strong) NSMutableDictionary <Optional> *restriction;
@property (nonatomic, strong) NSMutableDictionary <Optional> *rule_config;
@property (nonatomic, strong) NSString <Optional> *rule_function;
@property (nonatomic, strong) NSString <Optional> *deleted;
@property (nonatomic, strong) NSString <Optional> *rule_type;

@end

@interface MessageThreadsModel : JSONModel
@property (nonatomic, assign) int status;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSArray <MessageThreadModel> *messages;
@end

@interface MessageThreadModel : JSONModel
@property (nonatomic, strong) NSString <Optional> * id;
@property (nonatomic, strong) NSString <Optional> * child_id;
@property (nonatomic, strong) NSString <Optional> *thread_id;
@property (nonatomic, strong) NSString <Optional> *contact_name;
@property (nonatomic, strong) NSString <Optional> *snippet;
@property (nonatomic, strong) NSString <Optional> *thread_date;
@property (nonatomic, strong) NSString <Optional> *date_created;
@property (nonatomic, strong) NSString <Optional> *date_modified;
@property (nonatomic, strong) NSString <Optional> *deleted;
@end

@interface MessagesModel : JSONModel
@property (nonatomic, assign) int status;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSArray <MessageModel> *messages;
@end

@interface MessageModel : JSONModel
@property (nonatomic, strong) NSString <Optional> * id;
@property (nonatomic, strong) NSString <Optional> * child_id;
@property (nonatomic, strong) NSString <Optional> *thread_id;
@property (nonatomic, strong) NSString <Optional> *sms_id;
@property (nonatomic, strong) NSString <Optional> *contact_name;
@property (nonatomic, strong) NSString <Optional> *body;
@property (nonatomic, strong) NSString <Optional> *is_sent;
@property (nonatomic, strong) NSString <Optional> *is_received;
@property (nonatomic, strong) NSString <Optional> *message_date;
@property (nonatomic, strong) NSString <Optional> *deleted;
@end

/*
@interface SyncSettingResponse : JSONModel
@property (nonatomic, assign) int feature_status;
@property (nonatomic, strong) NSMutableArray <SyncSettingModel> *apps;
@end

@interface SyncSettingModel : JSONModel
@property (nonatomic, strong) NSString *app_name;
@property (nonatomic, assign) int app_status;
@end

@interface AllSyncSettingsModel : JSONModel
@property (nonatomic, assign) int status_code;
@property (nonatomic, strong) NSString *status_message;
@property (nonatomic, strong) SyncSettingResponse *response;
@end
 */

@interface SyncSettingsApps : JSONModel
@property (nonatomic, strong) NSMutableArray <SyncSettingModel> *Block1;
@property (nonatomic, strong) NSMutableArray <SyncSettingModel> *Block2;
@property (nonatomic, strong) NSMutableArray <SyncSettingModel> *Block3;
@end

@interface SyncSettingResponse : JSONModel
@property (nonatomic, assign) int feature_status;
@property (nonatomic, strong) SyncSettingsApps *apps;
@end


@interface SyncSettingModelInternetFilter : JSONModel
@property (nonatomic, strong) NSString *app_name;
@property (nonatomic, assign) int app_status;
@property (nonatomic, strong) NSString *display_name;
@property (nonatomic, strong) NSString *subHeading;

@end


//---INTERNET FILTER MODEL---//

@interface InternetFilterModel : JSONModel
@property (nonatomic, assign) int internet_filter_status;
@property (nonatomic, strong) NSMutableArray <FilterModel> *category_list;
@property (nonatomic, strong) NSMutableArray <FilterModel> *search_category_list;
@end



@interface InternetFilterMainModel : JSONModel
@property (nonatomic, assign) int status;
@property (nonatomic, strong) NSString <Optional> *message;
@property (nonatomic, strong) InternetFilterModel *response;
@end

@interface FilterModel : JSONModel
@property (nonatomic, assign) int  id;
@property (nonatomic, strong) NSString <Optional> *name;
@property (nonatomic, strong) NSString <Optional> *description;
@property (nonatomic, assign) int  is_active;
@end

//---INTERNET FILTER MODEL---//

@interface SyncSettingModel : JSONModel
@property (nonatomic, strong) NSString *app_name;
@property (nonatomic, assign) int app_status;
@property (nonatomic, strong) NSString *display_name;
//@property (nonatomic, strong) NSString *subHeading;

@end

//@interface AllSyncSettingsModel : JSONModel
//@property (nonatomic, assign) int status_code;
//@property (nonatomic, strong) NSString *status_message;
//@property (nonatomic, strong) SyncSettingResponse *response;
//@end


@interface IOSAppBlockerModel : JSONModel
@property (nonatomic, assign) int status;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) SyncSettingResponse *data;
@end

@interface UpdateSyncSettings : JSONModel
@property (nonatomic, assign) int status_code;
@property (nonatomic, strong) NSString *status_message;
@property (nonatomic, strong) NSString *response;
@end


//--------------App Blocker Android---------------------

@interface AppBlockerApp : JSONModel
@property (nonatomic, strong) NSString *app_name;
@property (nonatomic, assign) int is_blacklisted;
@property (nonatomic, assign) int installedapp_id;
@end

@interface AppBlockerResponse : JSONModel
@property (nonatomic, assign) int is_enabled;
@property (nonatomic, strong) NSMutableArray <AppBlockerApp> *apps;

//---SANA CHANGE---//---MESH2 RESPNSE CHANGE---//
//@property (nonatomic, strong) NSMutableArray <AppBlockerApp> *applist;
@end


@interface AppBlockerModel : JSONModel
@property (nonatomic, assign) int status_code;
@property (nonatomic, strong) NSString *status_message;
@property (nonatomic, strong) AppBlockerResponse *response;

//---SANA CHANGE---//---MESH2 RESPNSE CHANGE---//
//@property (nonatomic, assign) int status;
//@property (nonatomic, strong) NSString *message;
//@property (nonatomic, strong) AppBlockerResponse *data;
@end


//@interface AppBlockerResponse_mesh2 : JSONModel
//@property (nonatomic, assign) int is_enabled;
////---SANA CHANGE---//---MESH2 RESPNSE CHANGE---//
//@property (nonatomic, strong) NSMutableArray <AppBlockerApp> *applist;
//@end


//---SANA CHANGE---//---MESH2 RESPNSE CHANGE---//


@interface AgreementInnerModel : JSONModel
@property (nonatomic, strong) NSString <Optional> * id;
@property (nonatomic, strong) NSString *page_name;
@property (nonatomic, strong) NSString *page_text;
@property (nonatomic, strong) NSString *page_language;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *updated_at;

@end

@interface AgreementModel : JSONModel
@property (nonatomic, assign) int status;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) AgreementInnerModel *data;
@end




@interface AppBlockerModel_mesh2 : JSONModel
@property (nonatomic, assign) int status;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSMutableArray <AppBlockerApp> *app_list;
@end





//---------------------Daily Limit Android-----------------

@interface DailyLimitApp : JSONModel
@property (nonatomic, strong) NSString *app_category;
@property (nonatomic, strong) NSString *app_name;
@property (nonatomic, strong) NSString *app_package_name;
@property (nonatomic, assign) int installedapp_id;
@property (nonatomic, assign) int in_daily_limit;

//---THESE CAN BE REMOVED ONCE ALL DONE IN SWIFT SCREEN---//
//@property (nonatomic, assign) int app_id;
//@property (nonatomic, assign) int is_enabled;


@end

@interface DailyLimitResponse : JSONModel
@property (nonatomic, strong) NSString *radian;
@property (nonatomic, strong) NSString *duration;
@property (nonatomic, assign) NSInteger remaining;
@property (nonatomic, assign) NSInteger auto_add;
@property (nonatomic, assign) NSInteger is_active;
@property (nonatomic, strong) NSMutableArray <DailyLimitApp> *apps;
@end


@interface DailyLimitDashboard : JSONModel
//@property (nonatomic, assign) int status_code; //---USING THESE FOR ANDROID TESTING---ONCE COMPLETED CONVERTED THEN THESE NO LONGER WILL BE NEEDED---//
//@property (nonatomic, strong) NSString *status_message;//---SAME AS ABOVE---//
//@property (nonatomic, strong) DailyLimitResponse *response;//---IN OLD API RESPONSE---//

@property (nonatomic, assign) int status; //---NEW STATUS IN MESH2 API RESPONSE---//
@property (nonatomic, strong) NSString *message;//---SAME ABOVE---//
@property (nonatomic, strong) DailyLimitResponse *data;//---IN NEW API RESPONSE---//

@end


//---NEW SANA IAP PRODUCTS API RESPONSE MODELS---//

@interface IAP_Product : JSONModel

//@property (nonatomic, assign) NSInteger product_id;


//---THESE 3 PROPERTIES WILL BE POPULATED FROM ITUNES---//

@property (nonatomic, strong) NSString<Optional> *apple_title;
@property (nonatomic, strong) NSString<Optional> *apple_desc;
@property (nonatomic, strong) NSString<Optional> *apple_price;
@property (nonatomic, strong) NSString<Optional> *color;

@property (nonatomic, strong) NSString *apple_product_id;
@property (nonatomic, assign) BOOL      is_default;

@end



@interface IAP_Dashboard : JSONModel

@property (nonatomic, assign) int status;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSMutableArray <IAP_Product> *products; //NSMutableArray <IAP_Product> *products;

@end


//---FUNTIME MODEL---//


@interface FuntimeDataModel : JSONModel

@property (nonatomic, strong) NSString <Optional> * id;
@property (nonatomic, strong) NSString<Optional> *start_radian;
@property (nonatomic, strong) NSString<Optional> *end_radian;

@property (nonatomic, assign) NSInteger child_id;
@property (nonatomic, assign) NSInteger deleted;
@property (nonatomic, assign) BOOL is_active;
@property (nonatomic, strong) NSString<Optional> *day;
@property (nonatomic, strong) NSString *time_start;
@property (nonatomic, strong) NSString *time_end;


@property (nonatomic, strong) NSString<Optional> *date_created;
@property (nonatomic, strong) NSString<Optional> *date_modified;

@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *updated_at;

@end


@interface FuntimeModel : JSONModel

@property (nonatomic, assign) int status;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) FuntimeDataModel *data;

@end


