//
//  Dashboard.h
//  FamilyTime - Dashboard
//
//  Created by Muhammad Ajmal on 07/10/2016.
//  Copyright © 2016 SoraCode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DashboardChildPreference : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString *value;
@end

@interface DashboardChildNotification : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString *value;
@end

@interface DashboardChildPackageFeature : NSObject
@property (nonatomic, strong) NSString *name; //---CHANGED TO FEATURE_NAME---//TOOK ME MORE THAN HALF DAY TO FIGURE THIS OUT---//
@property (nonatomic, strong) NSString *feature_name;

@property (nonatomic, assign) NSInteger package_id;
@property (nonatomic, assign) NSInteger is_active;
@property (nonatomic, assign) NSInteger is_count_based;
@property (nonatomic, strong) NSString  *count_limit;
@property (nonatomic, assign) NSInteger is_time_based;
@property (nonatomic, assign) NSInteger time_limit;
@end

@interface DashboardChildDeviceInfo : NSObject
@property (nonatomic, strong) NSString *signal_strength;
@property (nonatomic, strong) NSString *battery_remaining;
@property (nonatomic, strong) NSString *wifi_name;
@property (nonatomic, strong) NSString *device;
@property (nonatomic, strong) NSString *accuracy;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *device_os;

//---SANA CHANGE---//---NEW 7 PROP ADDED, PARSE IT TO SHOW IN NEW DEVICE SCREEN---//
@property (nonatomic, strong) NSString *device_name;
@property (nonatomic, strong) NSString *device_model;
@property (nonatomic, strong) NSString *device_manufacturer;
@property (nonatomic, strong) NSString *device_language;
@property (nonatomic, strong) NSString *device_timezone;
@property (nonatomic, strong) NSString *app_version;
@property (nonatomic, strong) NSString *app_build;


@end


@interface DashboardChildDailyLimit : NSObject

@property (nonatomic, assign) NSInteger child_id;
@property (nonatomic, assign) float duration;
@property (nonatomic, assign) float remaining;
@property (nonatomic, assign) float remaining_limit;
@property (nonatomic, assign) NSInteger auto_add;
@property (nonatomic, assign) NSInteger is_active;


@end

@interface DashboardChild : NSObject
@property (nonatomic, assign) NSInteger child_id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *relationship;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, assign) NSInteger plateform_id;
@property (nonatomic, strong) NSString *device;
@property (nonatomic, assign) NSInteger package_id;
@property (nonatomic, strong) NSString *package_name;
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, strong) NSString *expiry_date;
@property (nonatomic, strong) NSString *remaining_days;
@property (nonatomic, strong) NSString *cover_img_src;
@property (nonatomic, strong) NSString *profile_img_src;
@property (nonatomic, strong) NSString *color;
@property (nonatomic, assign) NSInteger phonelock_status;
@property (nonatomic, assign) NSInteger active;
@property (nonatomic, assign) NSInteger deleted;
@property (nonatomic, assign) NSInteger super_user_id;
@property (nonatomic, strong) NSString *activation_code;
@property (nonatomic, strong) NSString *date_created;
@property (nonatomic, strong) NSString *date_modified;
@property (nonatomic, strong) NSString *push_token;
@property (nonatomic, assign) NSInteger child_enrolled;
@property (nonatomic, strong) NSString *child_mdm_hash;
@property (nonatomic, assign) NSInteger is_production_build;
@property (nonatomic, strong) NSString *version_number;
@property (nonatomic, strong) NSString *version_code;
@property (nonatomic, strong) NSString *subscription_id;
@property (nonatomic, strong) NSString *time_zone;
@property (nonatomic, strong) NSMutableArray *preferences;
@property (nonatomic, strong) NSMutableArray *notifications;
@property (nonatomic, strong) NSMutableArray *package_features;
@property (nonatomic, strong) DashboardChildDeviceInfo *deviceInfo;
@property (nonatomic, strong) DashboardChildDailyLimit *dailyLimit;



- (DashboardChildPackageFeature *)getPackageFeatureWithName:(NSString *)name;
- (DashboardChildPreference *)getPreferencesWithName:(NSString *)name;
- (DashboardChildNotification *)getNotificationsWithName:(NSString *)name;


- (void)updatePreferenceWitPreference:(DashboardChildPreference *)preference;
- (void)updateNotificationWitNotification:(DashboardChildNotification *)notification;
- (void)updateChildName:(NSString *)name;

@end

@interface DashboardCoParent : NSObject
@property (nonatomic, assign) NSInteger user_id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *relationship;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *uhash;
@property (nonatomic, strong) NSString *profile_img_src;
@property (nonatomic, strong) NSString *cover_img_src;
@property (nonatomic, strong) NSString *remote_ip;
@property (nonatomic, strong) NSString *remote_country;
@property (nonatomic, strong) NSString *signup_plateform;
@property (nonatomic, strong) NSString *date_created;
@property (nonatomic, strong) NSString *date_modified;
@property (nonatomic, strong) NSString *color;
@property (nonatomic, assign) NSInteger active;
@property (nonatomic, assign) NSInteger deleted;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, assign) NSInteger super_user_id;
@property (nonatomic, strong) NSString *checksum;
@property (nonatomic, strong) NSString *device;
@property (nonatomic, strong) NSString *push_token;
@property (nonatomic, assign) NSInteger is_production_build;
@property (nonatomic, strong) NSString *activation_code;
@property (nonatomic, strong) NSString *remaining_subscriptions;

- (void)updateChildName:(NSString *)name;
@end

@interface Dashboard : NSObject
@property (nonatomic, strong) NSString *status_code;
@property (nonatomic, strong) NSString *status_message;
@property (nonatomic, strong) NSMutableArray *children;
@property (nonatomic, strong) NSMutableArray *coparents;

- (void)deleteChild:(DashboardChild *)child;
    - (void)sortChilds;
    - (void)sortParents;

@end
