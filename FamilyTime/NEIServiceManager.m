//
//  NEIServiceManager.m
//  FamilyTime - Dashboard
//
//  Created by Sora Code on 15/05/2015.
//  Copyright (c) 2015 SoraCode. All rights reserved.
//

#import "NEIServiceManager.h"
#pragma mark - Constants

NSString * const kServiceManagerBaseURL         = @"https://mesh2.familytime.io";

NSString * const kServiceManagerResponseInvalid=@"Not a valid request";
NSString * const kServiceManagerResponseSuccess  = @"Success";
NSString * const kServiceManagerResponseMessage = @"record already exists or not found";
NSString * const kServiceManagerResponseFormat = @"Invalid Email Format";
NSString * const kServiceManagerResponse = @"response";
NSString * const kServiceDataManagerResponse = @"data";


static NEIServiceManager *sharedInstance = nil;

@implementation NEIServiceManager

#pragma mark - Lyfe Cycle

+ (NEIServiceManager *)sharedInstance
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (id)init
{
    if (self = [super init])
    {
//        _manager = [AFHTTPSessionManager manager];
    }
    
    return self;
}



@end
