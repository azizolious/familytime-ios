//
//  NEIServiceManager+FTD.h
//  FamilyTime - Dashboard
//
//  Created by Sora Code on 15/05/2015.
//  Copyright (c) 2015 SoraCode. All rights reserved.
//

#import "NEIServiceManager.h"

@interface NEIServiceManager (FTD)

extern NSString * const kUserAPIFirstNameKey;
extern NSString * const kUserAPILastNameKey;
extern NSString * const kUserAPIPasswordKey;
extern NSString * const kUserAPIEmailKey;
extern NSString * const kUserAPICountryCodeKey;
extern NSString * const kUserAPIPhoneKey;
extern NSString * const kUserAPIDeviceTokenKey;
extern NSString * const kUserAPIPushTokenKey;

extern NSString * const kFTDChildKey;
extern NSString * const kFTDChildPreferenceKey;

extern NSString * const kLoginAPIEmailKey;


//- (void)packagesFeaturesDetails:(NSString *)email
//      withSuccessBlock:(NEIServiceResponseSuccessBlock)successBlock
//         andErrorBlock:(NEIServiceResponseErrorBlock)errorBlock;
//
//- (void)packagesFeatures:(NSString *)childD
//               withSuccessBlock:(NEIServiceResponseSuccessBlock)successBlock
//                  andErrorBlock:(NEIServiceResponseErrorBlock)errorBlock;


@end
