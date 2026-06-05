//
//  NEIServiceManager+FTD.m
//  FamilyTime - Dashboard
//
//  Created by Sora Code on 15/05/2015.
//  Copyright (c) 2015 SoraCode. All rights reserved.
//

#import "NEIServiceManager+FTD.h"


static NSString * const kUserAPILoginURL                = @"/child/mychildren";
//static NSString * const kChildAPIPackagesFeaturesURL    = @"/child/preference";

/*************** USER API Keys ***************/
NSString * const kUserAPIFirstNameKey   =@"package_features";
NSString * const kUserAPILastNameKey    =@"alerts";
NSString * const kUserAPIPasswordKey    =@"appblocking";
NSString * const kUserAPIEmailKey       =@"bookmark";
NSString * const kUserAPICountryCodeKey =@"browsinghistory";
NSString * const kUserAPIPhoneKey       =@"contact";
NSString * const kUserAPIDeviceTokenKey =@"contactwatchlist";
NSString * const kUserAPIPushTokenKey   =@"defineplace";

NSString * const kLoginAPIEmailKey      =@"geolocation";
NSString * const kLoginAPIPasswordKey   =@"installedapp";

NSString * const kresetAPIEmailKey      =@"phonelock";
NSString * const kresetAPICurrentPwdKey =@"place";
NSString * const kresetAPIIDKey =@"id";

NSString * const kFTDChildKey   = @"children";
NSString * const kFTDChildPreferenceKey   = @"preferences";

NSString * const kFTDChildIDKey   = @"id";
NSString * const kFTDChildPackagesKey   = @"preference";

@implementation NEIServiceManager (FTD)

#pragma mark - User API URLs

+ (NSString*)childAPIPackageFeaturesUrl
{
    return [NSString stringWithFormat:@"%@%@", kServiceManagerBaseURL, kUserAPILoginURL];
}

//+ (NSString*)childAPIPackageFeatures
//{
//    return [NSString stringWithFormat:@"%@%@", kServiceManagerBaseURL, kChildAPIPackagesFeaturesURL];
//}

/*
- (void)packagesFeaturesDetails:(NSString *)ID
               withSuccessBlock:(NEIServiceResponseSuccessBlock)successBlock
                  andErrorBlock:(NEIServiceResponseErrorBlock)errorBlock
{
    NSMutableDictionary * data = [NSMutableDictionary dictionaryWithDictionary:
                                  @{kresetAPIIDKey : ID,
                                    }];
    NSLog(@"%@",data);
    
    [self.manager  POST:[NEIServiceManager childAPIPackageFeaturesUrl]
             parameters:data
                success:successBlock
                failure:errorBlock];
}

- (void)packagesFeatures:(NSString *)childD
        withSuccessBlock:(NEIServiceResponseSuccessBlock)successBlock
           andErrorBlock:(NEIServiceResponseErrorBlock)errorBlock
{
    NSMutableDictionary * data = [NSMutableDictionary dictionaryWithDictionary:
                                  @{kFTDChildIDKey : childD,
                                    }];
    NSLog(@"%@",data);
    
    [self.manager  POST:[NEIServiceManager childAPIPackageFeatures]
             parameters:data
                success:successBlock
                failure:errorBlock];
}

*/
@end
