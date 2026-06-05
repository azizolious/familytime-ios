//
//  Dashboard.m
//  FamilyTime - Dashboard
//
//  Created by Muhammad Ajmal on 07/10/2016.
//  Copyright © 2016 SoraCode. All rights reserved.
//

#import "Dashboard.h"
#import <Motis/Motis.h>

@implementation Dashboard



+ (NSDictionary*)mts_mapping
{
    return @{@"status_code" : mts_key(status_code),
             @"status_message" : mts_key(status_message),
             @"response.children" : mts_key(children),
             @"response.coparents" : mts_key(coparents),
             };
}

+ (NSDictionary*)mts_arrayClassMapping
{
    return @{mts_key(children): DashboardChild.class,
             mts_key(coparents): DashboardCoParent.class,
             };
}

- (void)deleteChild:(DashboardChild *)child
{
    for (NSInteger index = 0; index < self.children.count; index++)
    {
        DashboardChild *tchild = [self.children objectAtIndex:index];
        if (tchild.child_id == child.child_id)
        {
            [self.children removeObject:tchild];
        }
    }
}
    

- (void)sortChilds
{
    
//        NSArray *sortedArray;
//        sortedArray = [self.children sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
//            NSString *first = [(DashboardChild*)a name];
//            NSString *second = [(DashboardChild*)b name];
//            return [first compare:second];
//        }];
//        self.children = [NSMutableArray arrayWithArray:sortedArray];

//    [anArray sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    
//    NSSortDescriptor *sorter = [[[NSSortDescriptor alloc]
//                                 initWithKey:@"w"
//                                 ascending:YES
//                                 selector:@selector(localizedCaseInsensitiveCompare:)] autorelease];
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                 ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
    self.children = [[self.children sortedArrayUsingDescriptors:@[sortDescriptor]] mutableCopy];

    NSLog(@"Sort==%@",self.children);
//   self.children= [[[[self.children copy] reverseObjectEnumerator] allObjects] mutableCopy];
    /*
    //here is ===
    NSSortDescriptor *sortDescriptor2;
    sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                 ascending:YES];
    self.children = [[self.children sortedArrayUsingDescriptors:@[sortDescriptor2]] mutableCopy];
    
    //[[startArray reverseObjectEnumerator] allObjects];
    */
}

- (void)sortParents
{
//        NSArray *sortedArray;
//        sortedArray = [self.coparents sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
//            NSString *first = [(DashboardCoParent*)a name];
//            NSString *second = [(DashboardCoParent*)b name];
//            return [first compare:second];
//        }];
//        self.coparents = [NSMutableArray arrayWithArray:sortedArray];
//    
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                 ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
    self.coparents = [[self.coparents sortedArrayUsingDescriptors:@[sortDescriptor]] mutableCopy];
    
    NSLog(@"Sort==%@",self.coparents);

    
    
}

@end

@implementation DashboardCoParent
+ (NSDictionary*)mts_mapping
{
    return @{@"user_id" : mts_key(user_id),
             @"name" : mts_key(name),
             @"birthday" : mts_key(birthday),
             @"gender" : mts_key(gender),
             @"relationship" : mts_key(relationship),
             @"email" : mts_key(email),
             @"phone" : mts_key(phone),
             @"uhash" : mts_key(uhash),
             @"profile_img_src" : mts_key(profile_img_src),
             @"cover_img_src" : mts_key(cover_img_src),
             @"remote_ip" : mts_key(remote_ip),
             @"remote_country" : mts_key(remote_country),
             @"signup_plateform" : mts_key(signup_plateform),
             @"date_created" : mts_key(date_created),
             @"date_modified" : mts_key(date_modified),
             @"color" : mts_key(color),
             @"active" : mts_key(active),
             @"deleted" : mts_key(deleted),
             @"type" : mts_key(type),
             @"super_user_id" : mts_key(super_user_id),
             @"checksum" : mts_key(checksum),
             @"device" : mts_key(device),
             @"push_token" : mts_key(push_token),
             @"is_production_build" : mts_key(is_production_build),
             @"activation_code" : mts_key(activation_code),
             @"remaining_subscriptions" : mts_key(remaining_subscriptions),
             };
}
- (void)updateChildName:(NSString *)name
{
    self.name = name;
}
@end

@implementation DashboardChildDeviceInfo
+ (NSDictionary*)mts_mapping
{
    return @{@"signal_strength" : mts_key(signal_strength),
             @"battery_remaining" : mts_key(battery_remaining),
             @"wifi_name" : mts_key(wifi_name),
             @"accuracy" : mts_key(accuracy),
             @"latitude" : mts_key(latitude),
             @"longitude" : mts_key(longitude),
             @"address" : mts_key(address),
             @"device_os" : mts_key(device_os),
             
             @"device_name" : mts_key(device_name),
             @"device_manufacturer" : mts_key(device_manufacturer),
             @"device_model" : mts_key(device_model),
             @"device_language" : mts_key(device_language),
             @"device_timezone" : mts_key(device_timezone),
             @"app_version" : mts_key(app_version),
             @"app_build" : mts_key(app_build)
             
             };
}
@end


@implementation DashboardChildDailyLimit
+ (NSDictionary*)mts_mapping
{
    return @{@"child_id" : mts_key(child_id),
             @"duration" : mts_key(duration),
             @"remaining" : mts_key(remaining),
             @"remaining_limit" : mts_key(remaining_limit),
             @"auto_add" : mts_key(auto_add),
             @"is_active" : mts_key(is_active)
             };
}
@end

@implementation DashboardChild

-(id)init {
    if ( self = [super init] ) {
        self.preferences = [NSMutableArray new];
        self.notifications = [NSMutableArray new];
        self.package_features = [NSMutableArray new];
    }
    return self;
}

+ (NSDictionary*)mts_mapping
{
    return @{
             @"info.child_id" : mts_key(child_id),
             @"info.name" : mts_key(name),
             @"info.birthday" : mts_key(birthday),
             @"info.gender" : mts_key(gender),
             @"info.relationship" : mts_key(relationship),
             @"info.email" : mts_key(email),
             @"info.phone" : mts_key(phone),
             @"info.plateform_id" : mts_key(plateform_id),
             @"info.device" : mts_key(device),
             @"info.package_id" : mts_key(package_id),
             @"info.package_name" : mts_key(package_name),
             @"info.duration" : mts_key(duration),
             @"info.expiry_date" : mts_key(expiry_date),
             @"info.remaining_days" : mts_key(remaining_days),
             @"info.cover_img_src" : mts_key(cover_img_src),
             @"info.profile_img_src" : mts_key(profile_img_src),
             @"info.color" : mts_key(color),
             @"info.active" : mts_key(active),
             @"info.deleted" : mts_key(deleted),
             @"info.super_user_id" : mts_key(super_user_id),
             @"info.activation_code" : mts_key(activation_code),
             @"info.date_created" : mts_key(date_created),
             @"info.date_modified" : mts_key(date_modified),
             @"info.push_token" : mts_key(push_token),
             @"info.child_enrolled" : mts_key(child_enrolled),
             @"info.child_mdm_hash" : mts_key(child_mdm_hash),
             @"info.is_production_build" : mts_key(is_production_build),
             @"info.version_number" : mts_key(version_number),
             @"info.version_code" : mts_key(version_code),
             @"info.subscription_id" : mts_key(subscription_id),
             @"info.time_zone" : mts_key(time_zone),
             @"info.phonelock_status" : mts_key(phonelock_status),
             @"package_features" : mts_key(package_features),
             
             @"device_info" : mts_key(deviceInfo),
             @"daily_limit" : mts_key(dailyLimit),
             @"preferences" : mts_key(preferences),
             @"notifications" : mts_key(notifications)
             };
}

- (id)mts_willCreateObjectOfClass:(Class)typeClass withDictionary:(NSDictionary*)dictionary forKey:(NSString*)key abort:(BOOL*)abort
{
    if (typeClass == [DashboardChildDeviceInfo class])
    {
        DashboardChildDeviceInfo *object = [[DashboardChildDeviceInfo alloc] init];
         [object mts_setValuesForKeysWithDictionary:dictionary];
        return object;
    }
    else if (typeClass == [DashboardChildDailyLimit class])
    {
        DashboardChildDailyLimit *object = [[DashboardChildDailyLimit alloc] init];
        [object mts_setValuesForKeysWithDictionary:dictionary];
        return object;
    }
    
    return nil;
}


+ (NSDictionary*)mts_arrayClassMapping
{
    return @{mts_key(preferences): DashboardChildPreference.class,
             mts_key(notifications): DashboardChildNotification.class,
             mts_key(package_features): DashboardChildPackageFeature.class,
             };
}

- (DashboardChildPackageFeature *)getPackageFeatureWithName:(NSString *)name
{
    for (DashboardChildPackageFeature *feature in self.package_features)
    {
        NSLog(@"child package feature name = %@ and isapplied = %ld", feature.feature_name, (long)feature.package_id);
        if ([feature.feature_name isEqualToString:name])
            return feature;
    }
    return nil;
}


- (DashboardChildPreference *)getPreferencesWithName:(NSString *)name
{
    for (DashboardChildPreference *preference in self.preferences)
    {
        if ([preference.name isEqualToString:name])
            return preference;
    }
    return nil;
}

- (DashboardChildNotification *)getNotificationsWithName:(NSString *)name
{
    for (DashboardChildNotification *notification in self.notifications)
    {
        if ([notification.name isEqualToString:name])
            return notification;
    }
    return nil;
}

- (void)updatePreferenceWitPreference:(DashboardChildPreference *)preference
{
    for (NSInteger index = 0; index < self.preferences.count; index++)
    {
        DashboardChildPreference *previous = [self.preferences objectAtIndex:index];
        if ([previous.name isEqualToString:preference.name])
        {
            [self.preferences replaceObjectAtIndex:index withObject:preference];
        }
    }
}

- (void)updateNotificationWitNotification:(DashboardChildNotification *)notification
{
    NSLog(@"notification array count = %lu", (unsigned long)self.notifications.count);
    
    for (NSInteger index = 0; index < self.notifications.count; index++)
    {
        DashboardChildNotification *previous = [self.notifications objectAtIndex:index];
        
        NSLog(@"prev notif name = %@ and notif name = %@", previous.name, notification.name);
        
        if ([previous.name isEqualToString:notification.name])
        {
            [self.notifications replaceObjectAtIndex:index withObject:notification];
        }
    }
}

- (void)updateChildName:(NSString *)name
{
    self.name = name;
}
@end

@implementation DashboardChildPackageFeature
+ (NSDictionary*)mts_mapping
{
    return @{@"name" : mts_key(name),
             @"feature_name" : mts_key(feature_name),
             @"package_id" : mts_key(package_id),
             @"is_active" : mts_key(is_active),
             @"is_count_based" : mts_key(is_count_based),
             @"count_limit" : mts_key(count_limit),
             @"is_time_based" : mts_key(is_time_based),
             @"time_limit" : mts_key(time_limit),
             };
}
@end

@implementation DashboardChildNotification
+ (NSDictionary*)mts_mapping
{
    return @{@"name" : mts_key(name),
             @"status" : mts_key(status),
             @"value" : mts_key(value),
             };
}
@end

@implementation DashboardChildPreference
+ (NSDictionary*)mts_mapping
{
    return @{@"name" : mts_key(name),
             @"status" : mts_key(status),
             @"value" : mts_key(value),
             };
}
@end

