//
//  DataModel.m
//  FamilyTime
//
//  Created by Sora Code on 11/14/14.
//  Copyright (c) 2014 SoraCode. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel

@end

@implementation UserModel

@end

@implementation PushModel
@end

@implementation UserDeviceModel
@end

@implementation Family
@end

@implementation FamilyModel
@end
@implementation ChildModel
@end
@implementation ChildPrefence
@end
@implementation Child
@end

@implementation PlaceModel
@end

@implementation AllPlacesModel
@end

@implementation AllPlacesVisitModel
@end

@implementation PlaceVisit
@end


@implementation LocationModel
@end

@implementation AllLocationModel
@end

@implementation BlistAppModel
@end

@implementation AllBlistAppsModel
@end

@implementation Preferences
@end

@implementation RuleModel
@end

@implementation InternetScheduleModel
@end

@implementation InternetScheduleInnerModel
@end



@implementation AndroidRulesModel
@end

@implementation AllAccessControlRulesModel
@end

@implementation AccessControlRuleModel
@end

//@implementation AllSyncSettingsModel
//@end

@implementation IOSAppBlockerModel
@end

@implementation SyncSettingModel
@end

@implementation SyncSettingResponse
@end

@implementation SyncSettingsApps
@end

@implementation UpdateSyncSettings
@end

@implementation MessageThreadsModel
@end

@implementation MessageThreadModel
@end

@implementation MessagesModel
@end

@implementation MessageModel
@end

//--------App blocker Android------
@implementation AppBlockerApp
@end

@implementation AppBlockerResponse
@end

@implementation AppBlockerModel
@end


@implementation AppBlockerModel_mesh2
@end

@implementation AgreementInnerModel
@end

@implementation AgreementModel
@end

//--------Daily Limit---------------
@implementation DailyLimitApp
@end

@implementation DailyLimitResponse
@end


@implementation DailyLimitDashboard
@end

@implementation SyncSettingModelInternetFilter
@end


@implementation InternetFilterModel
@end

@implementation FilterModel
@synthesize description;
@end

@implementation InternetFilterMainModel
@end


//---NEW SANA IAP PRODUCTS API RESPONSE MODELS---//

@implementation IAP_Product


+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    if([propertyName isEqualToString:@"title"] || [propertyName isEqualToString:@"product_description"] || [propertyName isEqualToString:@"color"])
        return YES;
    
    return NO;
}

@end



@implementation IAP_Dashboard
@end


@implementation FuntimeModel
@end

@implementation FuntimeDataModel
@end


@implementation AppUsageModel
@end

@implementation AppUsageInnerModel
@end




