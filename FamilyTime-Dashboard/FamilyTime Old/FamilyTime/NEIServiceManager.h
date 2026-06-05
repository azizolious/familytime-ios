//
//  NEIServiceManager.h
//  FamilyTime - Dashboard
//
//  Created by Sora Code on 15/05/2015.
//  Copyright (c) 2015 SoraCode. All rights reserved.
//

#import <Foundation/Foundation.h>

//#import "AFHTTPRequestOperation.h"
//#import "AFHTTPRequestOperationManager.h"
//#import "AFHTTPSessionManager.h"

//#define USE_MOCKED_RESPONSES

//typedef void(^NEIServiceResponseSuccessBlock)(AFHTTPSessionManager *operation, id responseObject);
//typedef void(^NEIServiceResponseErrorBlock)(AFHTTPSessionManager *operation, NSError *error);
//
extern NSString * const kServiceManagerBaseURL;
//extern NSString * const kServiceManagerResponseInvalid;
//extern NSString * const kServiceManagerResponseSuccess;
//extern NSString * const kServiceManagerResponseMessage;
//extern NSString * const kServiceManagerResponseFormat;
//extern NSString * const kServiceManagerResponse;
//extern NSString * const kServiceDataManagerResponse;

@interface NEIServiceManager : NSObject

//@property (nonatomic, strong) AFHTTPSessionManager *manager;

+ (NEIServiceManager *)sharedInstance;

//@interface NEIServiceManager : NSObject

@end
