//
//  ApiManager.m
//  FamilyTime
//
//  Created by Sana Ullah on 27/11/2018.
//  Copyright © 2018 YumyApps. All rights reserved.
//

#import "ApiManager.h"
//#import "JSONHTTPClient.h"
#import "Constant.h"
#import "CommonModel.h"
#import "AppDelegate.h"
#import "FTUtils.h"
#import "AppDelegate.h"
#import "FamilyTime-Swift.h"
#import <Motis/Motis.h>

AppDelegate *delegate;
@implementation ApiManager

+(ApiManager *)shared
{
    static ApiManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

//---NATIVE API CALLING HELPING METHODS---//

+(NSURLSession *) getMesh2NativeApiSession{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session                    = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    return session;
}

+(NSMutableURLRequest *) getMesh2NativeApiRequestWithUrl:(NSString *)url andMethod:(NSString *)method sendHeader:(BOOL)shouldSend{
    NSMutableURLRequest *request             = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                                       cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                                   timeoutInterval:20.0];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:kHeaderToken];
    NSString *tokenWithBear = [NSString stringWithFormat:@"Bearer %@", token];
    
    NSString *struserAgent=[NSString stringWithFormat:@"%@/%@ (%@; iOS %@; Scale/%0.2f)", [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleExecutableKey] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleIdentifierKey], [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleVersionKey], [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], [[UIScreen mainScreen] scale]];
    
    NSString * lang = [[[[NSLocale preferredLanguages] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:0];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:lang forHTTPHeaderField:@"language"];
    
    NSLocale *currentLocale = [NSLocale currentLocale];
    NSString *regionCode = [currentLocale objectForKey:NSLocaleCountryCode];
    NSString *currentLocaleCode = regionCode ? regionCode : @"pk";
    NSString *deviceType = @"0";
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *appBuildNumber = [mainBundle objectForInfoDictionaryKey:@"CFBundleVersion"];
    NSString *appVersionNumber = [mainBundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    NSString *userAgent = [NSString stringWithFormat:@"FamilyTime/%@ (iOS; Build:%@; SDK:%@);", appVersionNumber, appBuildNumber, systemVersion];

    if(shouldSend) {
#if TARGET_IPHONE_SIMULATOR
        deviceType = @"0";
#else
        deviceType = @"1";
#endif
        
        [request addValue:tokenWithBear   forHTTPHeaderField:@"Authorization"];
        [request addValue: appBuildNumber  forHTTPHeaderField:@"app-build"];
        [request addValue:appVersionNumber   forHTTPHeaderField:@"app-version"];
        [request addValue:systemVersion   forHTTPHeaderField:@"os-version"];
        [request addValue:@"iOS"   forHTTPHeaderField:@"os"];
        [request addValue:currentLocaleCode   forHTTPHeaderField:@"country"];
        [request addValue:userAgent   forHTTPHeaderField:@"user-agent"];
        [request addValue:deviceType   forHTTPHeaderField:@"device-type"];
    } else {
        [request addValue:struserAgent        forHTTPHeaderField:@"User-Agent"];
    }
    
    NSLog(@"Header token = %@ \nUser agent = %@", tokenWithBear, struserAgent);
    
    [request setHTTPMethod:method];
    return request;
}

- (void)hitDashboardApiwithController:(UIViewController *)vc isRefresh:(BOOL)isRefresh andSuccess:(void (^)(Dashboard *dashboardModel))success failure:(void (^)(NSString *error, NSInteger errorCode))failure
{
    // NSString *URL = isRefresh ? KRefreshDashboard_mesh2 : KDashboard_home_mesh2;
    NSString *URL = KDashboard_home_mesh2;
    NSLog(@"dashboard URL = %@",URL);
    //---NATIVE API CALLING---//
    
    NSURLSession *session        = [ApiManager getMesh2NativeApiSession];
    NSMutableURLRequest *request = [ApiManager getMesh2NativeApiRequestWithUrl:URL andMethod:kGetMethod sendHeader:YES];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *apiError) {
        if(data == nil)
        {
            NSLog(@"Response data is nil for API = %@", URL);
            failure([kErrorGeneral myModification], 1);
        }
        else{
            // Parse the JSON that came in into an NSDictionary
            NSError * parsingError = nil;
            NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parsingError];
            NSString *msg = [jsonDict valueForKey:@"message"] == nil ? [kErrorGeneral myModification] : [jsonDict valueForKey:@"message"];
            
            NSLog(@"dict after parsing = %@ and error = %@", jsonDict, parsingError);
            if (!apiError && !parsingError){ // if no error occurred, parse the array of objects as normal
                NSLog(@"parsing done and json dict = %@", jsonDict);
                
                if([[jsonDict valueForKey:@"status"] intValue] != 200)
                {
                    //---CHECK FOR EX00401 CODE,---UNAUTHENTICATEED STATUS---//
                    if ([[jsonDict valueForKey:@"status"] isKindOfClass:[NSString class]]){
                        if ([[jsonDict valueForKey:@"status"] isEqualToString:kLogoutStatus])
                            [CommonModel showAlertAndLogoutOnVC:vc isPresentedVC:NO];
                    }
                    else
                        failure(msg, [[jsonDict valueForKey:@"status"] intValue]);
                }
                else{
                    NSLog(@"success response = %@",jsonDict);
                    
                    Dashboard *dashboard = [[Dashboard alloc] init];
                    [dashboard mts_setValuesForKeysWithDictionary:jsonDict];
                    
                    NSLog(@"dashboard after motis parsing = %@", dashboard);
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    success(dashboard);
                }
                
            }else{ // an error occurred so we need to let the user know
                // Handle your error here
                NSLog(@"Api Error = %@ and parsing error = %@", apiError, parsingError);
                failure(msg, [[jsonDict valueForKey:@"status"] intValue]);
            }
        }
    }];
    
    [postDataTask resume];
}

//- (void)hitDashboardApi2withController:(UIViewController *)vc andSuccess:(void (^)(Dashboard *dashboardModel))success failure:(void (^)(NSString *error, NSInteger errorCode))failure
//{
//   // NSString *URL = isRefresh ? KRefreshDashboard_mesh2 : KDashboard_home_mesh2;
//    NSString *URL = [NSString stringWithFormat:@"https://core.familytime.io/api/old/home"];
//    NSLog(@"dashboard URL = %@",URL);
//        
//    //---NATIVE API CALLING---//
//    
//    NSURLSession *session        = [ApiManager getMesh2NativeApiSession];
//    NSMutableURLRequest *request = [ApiManager getMesh2NativeApiRequestWithUrl:URL andMethod:kGetMethod sendHeader:YES];
//    
//    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *apiError) {
//        
//        if(data == nil)
//        {
//            NSLog(@"Response data is nil for API = %@", URL);
//            failure([kErrorGeneral myModification], 1);
//        }
//        else{
//            // Parse the JSON that came in into an NSDictionary
//            NSError * parsingError = nil;
//            NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parsingError];
//            
//            NSString *msg = [jsonDict valueForKey:@"message"] == nil ? [kErrorGeneral myModification] : [jsonDict valueForKey:@"message"];
//            
//            NSLog(@"dict after parsing = %@ and error = %@", jsonDict, parsingError);
//                        
//            if (!apiError && !parsingError){ // if no error occurred, parse the array of objects as normal
//                // Parse the JSON dictionary 'jsonDict' here
//                
//                NSLog(@"parsing done and json dict = %@", jsonDict);
//                
//                
//                
//                if([[jsonDict valueForKey:@"status"] intValue] != 200)
//                {
//                    //---CHECK FOR EX00401 CODE,---UNAUTHENTICATEED STATUS---//
//                    if ([[jsonDict valueForKey:@"status"] isKindOfClass:[NSString class]]){
//                        if ([[jsonDict valueForKey:@"status"] isEqualToString:kLogoutStatus])
//                            [CommonModel showAlertAndLogoutOnVC:vc isPresentedVC:NO];
//                    }
//                    else
//                        failure(msg, [[jsonDict valueForKey:@"status"] intValue]);
//                }
//                else{
//                    NSLog(@"success response = %@",jsonDict);
//                    
//                    Dashboard *dashboard = [[Dashboard alloc] init];
//                    [dashboard mts_setValuesForKeysWithDictionary:jsonDict];
//                    
//                    NSLog(@"dashboard after motis parsing = %@", dashboard);
//                    [[NSUserDefaults standardUserDefaults] synchronize];
//                    
//                    success(dashboard);
//                }
//                
//                
//            }else{ // an error occurred so we need to let the user know
//                // Handle your error here
//                NSLog(@"Api Error = %@ and parsing error = %@", apiError, parsingError);
//                failure(msg, [[jsonDict valueForKey:@"status"] intValue]);
//            }
//        }
//        
//        
//    }];
//    
//    [postDataTask resume];
//    
//}


- (void)hitDailyLimitApiwithController:(UIViewController *)vc andSuccess:(void (^)(DailyLimitDashboard *dashboardModel))success failure:(void (^)(NSString *error, NSInteger errorCode))failure{
    NSString *childId = [[NSUserDefaults standardUserDefaults] stringForKey:@"selectedChildId"];
    NSString *url = [NSString stringWithFormat:@"%@%@", KDailyLimit_mesh2, childId];
    NSLog(@"daily limit URL = %@",url);
    /*
     
     //---SEND_HEADERS----//
     [[NSUserDefaults standardUserDefaults] setValue:kYES forKey:kSendHeaders];
     [[NSUserDefaults standardUserDefaults] synchronize];
     
     
     [JSONHTTPClient getJSONFromURLWithString:url
     params:nil
     completion:^(id json, JSONModelError *err) {
     
     //---SEND_HEADERS----//
     [[NSUserDefaults standardUserDefaults] setValue:kNO forKey:kSendHeaders];
     [[NSUserDefaults standardUserDefaults] synchronize];
     
     NSString *msg = [json valueForKey:@"message"] == nil ? [kErrorGeneral myModification] : [json valueForKey:@"message"];
     
     if([[json valueForKey:@"status"] intValue] != 200 ){
     //                                          failure(msg, [[json valueForKey:@"status"] intValue]);
     
     //---CHECK FOR EX00401 CODE,---UNAUTHENTICATEED STATUS---//
     if ([[json valueForKey:@"status"] isKindOfClass:[NSString class]]){
     if ([[json valueForKey:@"status"] isEqualToString:kLogoutStatus])
     [CommonModel showAlertAndLogoutOnVC:vc isPresentedVC:NO];
     }
     else
     failure(msg, [[json valueForKey:@"status"] intValue]);
     }
     else{
     NSLog(@"json response = %@",json);
     
     NSError *error;
     DailyLimitDashboard *dashboard = [[DailyLimitDashboard alloc] initWithDictionary:json error:&error];
     NSLog(@"dailyLimitDashboard model after parsing and sending back = %@",dashboard);
     success(dashboard);
     }
     }];
     
     */
    
    
    //---NATIVE API CALLING---//
    //         NSError *apiError;
    
    NSURLSession *session        = [ApiManager getMesh2NativeApiSession];
    NSMutableURLRequest *request = [ApiManager getMesh2NativeApiRequestWithUrl:url andMethod:kGetMethod sendHeader:YES];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *apiError) {
        
        
        if(data == nil)
        {
            NSLog(@"Response data is nil for API = %@", url);
            failure([kErrorGeneral myModification], 1);
        }
        else{
            // Parse the JSON that came in into an NSDictionary
            NSError * parsingError = nil;
            NSDictionary * json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parsingError];
            
            NSString *msg = [json valueForKey:@"message"] == nil ? [kErrorGeneral myModification] : [json valueForKey:@"message"];
            
            NSLog(@"dict after parsing = %@ and error = %@", json, parsingError);
            
            
            if (!apiError && !parsingError){ // if no error occurred, parse the array of objects as normal
                // Parse the JSON dictionary 'jsonDict' here
                
                NSLog(@"parsing done and json dict = %@", json);
                
                if([[json valueForKey:@"status"] intValue] != 200)
                {
                    //---CHECK FOR EX00401 CODE,---UNAUTHENTICATEED STATUS---//
                    if ([[json valueForKey:@"status"] isKindOfClass:[NSString class]]){
                        if ([[json valueForKey:@"status"] isEqualToString:kLogoutStatus])
                            [CommonModel showAlertAndLogoutOnVC:vc isPresentedVC:NO];
                    }
                    else
                        failure(msg, [[json valueForKey:@"status"] intValue]);
                }
                else{
                    NSLog(@"json response = %@",json);
                    
                    NSError *error;
                    DailyLimitDashboard *dashboard = [[DailyLimitDashboard alloc] initWithDictionary:json error:&error];
                    NSLog(@"dailyLimitDashboard model after parsing and sending back = %@",dashboard);
                    success(dashboard);
                }
                
                
            }else{ // an error occurred so we need to let the user know
                // Handle your error here
                NSLog(@"Api Error = %@ and parsing error = %@", apiError, parsingError);
                failure(msg, [[json valueForKey:@"status"] intValue]);
            }
        }
    }];
    
    [postDataTask resume];
    
}


#pragma mark - POST APIS

- (void)postApiWithVC:(UIViewController *)vc isPresentedCont:(BOOL)isPresent andParams:(NSDictionary*)params withApi:(NSString *)url withResponse:(void (^)(NSString *error, NSInteger errorCode))response{
    NSLog(@"post api URL = %@ and params = %@",url, params);
    
    /*
     
     //---SEND_HEADERS----//
     [[NSUserDefaults standardUserDefaults] setValue:kYES forKey:kSendHeaders];
     [[NSUserDefaults standardUserDefaults] synchronize];
     
     [JSONHTTPClient postJSONFromURLWithString:url
     params:params
     completion:^(id json, JSONModelError *err) {
     
     //---SEND_HEADERS----//
     [[NSUserDefaults standardUserDefaults] setValue:kNO forKey:kSendHeaders];
     [[NSUserDefaults standardUserDefaults] synchronize];
     
     NSLog(@"post api response = %@", json);
     
     //---CHECK FOR EX00401 CODE,---UNAUTHENTICATEED STATUS---//
     if ([[json valueForKey:@"status"] isKindOfClass:[NSString class]]){
     if ([[json valueForKey:@"status"] isEqualToString:kLogoutStatus])
     [CommonModel showAlertAndLogoutOnVC:vc isPresentedVC:isPresent];
     }
     else
     {
     NSString *msg = [json valueForKey:@"message"] == nil ? [kErrorGeneral myModification] : [json valueForKey:@"message"];
     response(msg, [[json valueForKey:@"status"] intValue]);
     }
     }];
     
     */
    
    //---NATIVE API CALLING---//
    
    
    NSURLSession *session        = [ApiManager getMesh2NativeApiSession];
    NSMutableURLRequest *request = [ApiManager getMesh2NativeApiRequestWithUrl:url andMethod:kPostMethod sendHeader:YES];
    
    NSError *paramsError;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&paramsError];
    [request setHTTPBody:postData];
    
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *responsee, NSError *serverError) {
        
        
        if(data == nil)
        {
            NSLog(@"Response data is nil for API = %@", url);
            response([kErrorGeneral myModification], 1);
        }
        else{
            // Parse the JSON that came in into an NSDictionary
            NSError * parseError = nil;
            NSDictionary * json  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parseError];
            
            
            NSLog(@"Post api response after parsing = %@ and server error = %@", json, serverError);
            NSString *msg = [json valueForKey:@"message"] == nil ? [kErrorGeneral myModification] : [json valueForKey:@"message"];
            
            
            NSLog(@"parsed json =%@ and parsing error =%@", json, parseError);
            
            if (!serverError && !parseError){
                //---CHECK FOR EX00401 CODE,---UNAUTHENTICATEED STATUS---//
                if ([[json valueForKey:@"status"] isKindOfClass:[NSString class]]){
                    if ([[json valueForKey:@"status"] isEqualToString:kLogoutStatus])
                        [CommonModel showAlertAndLogoutOnVC:vc isPresentedVC:NO];
                }
                else
                    response(msg, [[json valueForKey:@"status"] intValue]);
            }
            else
                response([kErrorGeneral myModification], [[json valueForKey:@"status"] intValue]);
        }
        
        
    }];
    
    [postDataTask resume];
    
}

- (void)postApiWithPwdVC:(UIViewController *)vc isPresentedCont:(BOOL)isPresent andParams:(NSDictionary*)params withApi:(NSString *)url withResponse:(void (^)(NSString *error, NSInteger errorCode))response{
    NSLog(@"post api URL = %@ and params = %@",url, params);
    
    /*
     
     //---SEND_HEADERS----//
     [[NSUserDefaults standardUserDefaults] setValue:kYES forKey:kSendHeaders];
     [[NSUserDefaults standardUserDefaults] synchronize];
     
     [JSONHTTPClient postJSONFromURLWithString:url
     params:params
     completion:^(id json, JSONModelError *err) {
     
     //---SEND_HEADERS----//
     [[NSUserDefaults standardUserDefaults] setValue:kNO forKey:kSendHeaders];
     [[NSUserDefaults standardUserDefaults] synchronize];
     
     NSLog(@"post api response = %@", json);
     
     //---CHECK FOR EX00401 CODE,---UNAUTHENTICATEED STATUS---//
     if ([[json valueForKey:@"status"] isKindOfClass:[NSString class]]){
     if ([[json valueForKey:@"status"] isEqualToString:kLogoutStatus])
     [CommonModel showAlertAndLogoutOnVC:vc isPresentedVC:isPresent];
     }
     else
     {
     NSString *msg = [json valueForKey:@"message"] == nil ? [kErrorGeneral myModification] : [json valueForKey:@"message"];
     response(msg, [[json valueForKey:@"status"] intValue]);
     }
     }];
     
     */
    
    //---NATIVE API CALLING---//
    
    
    [[NSUserDefaults standardUserDefaults] setValue:kNO forKey:kSendHeaders];
       [[NSUserDefaults standardUserDefaults] synchronize];
       
       
       ///*
       
       //---POSTMAN CODE---//
       

       NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:kHeaderToken];
          NSString *tokenWithBear = [NSString stringWithFormat:@"Bearer %@", token];
       NSString *lang = @"en";
          
          if([[NSUserDefaults.standardUserDefaults stringForKey:@"userlanguage"] isEqual:nil] || [[NSUserDefaults.standardUserDefaults stringForKey:@"userlanguage"] isEqual:[NSNull null]]){
              
              lang  = [[NSLocale preferredLanguages] firstObject];
          }else{
              
              lang = [NSUserDefaults.standardUserDefaults stringForKey:@"userlanguage"];
          }
      NSDictionary *headers = @{ @"content-type": @"application/json",@"lang":lang,@"Authorization":tokenWithBear};
       //                               @"cache-control": @"no-cache"};
       //@"postman-token": @"6e578cdb-f39e-3560-6119-b7f28bec6681" };
     NSError *paramsError;
      NSData *postData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&paramsError];
       
       NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:60.0];
       [request setHTTPMethod:kPostMethod];
       [request setAllHTTPHeaderFields:headers];
       [request setHTTPBody:postData];
       
       NSURLSession *session = [NSURLSession sharedSession];
       NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                   completionHandler:^(NSData *data, NSURLResponse *responsee, NSError *serverError) {
        
        
        if(data == nil)
        {
            NSLog(@"Response data is nil for API = %@", url);
            response([kErrorGeneral myModification], 1);
        }
        else{
            // Parse the JSON that came in into an NSDictionary
            NSError * parseError = nil;
            NSDictionary * json  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parseError];
            
            
            NSLog(@"Post api response after parsing = %@ and server error = %@", json, serverError);
            NSString *msg = [json valueForKey:@"message"] == nil ? [kErrorGeneral myModification] : [json valueForKey:@"message"];
            
            
            NSLog(@"parsed json =%@ and parsing error =%@", json, parseError);
            
            if (!serverError && !parseError){
                //---CHECK FOR EX00401 CODE,---UNAUTHENTICATEED STATUS---//
                if ([[json valueForKey:@"status"] isKindOfClass:[NSString class]]){
                    if ([[json valueForKey:@"status"] isEqualToString:kLogoutStatus])
                        [CommonModel showAlertAndLogoutOnVC:vc isPresentedVC:NO];
                }
                else
                    response(msg, [[json valueForKey:@"status"] intValue]);
            }
            else
                response([kErrorGeneral myModification], [[json valueForKey:@"status"] intValue]);
        }
        
        
    }];
    
    [dataTask resume];
    
}

- (void)postApiToValidateReceiptWithVC:(UIViewController *)vc andParams:(NSDictionary*)params withApi:(NSString *)url withResponse:(void (^)(NSString *error, NSInteger errorCode, NSInteger verifyReceiptStatus))response{
    NSLog(@"post api URL = %@ and params = %@",url, params);
    
    /*
     
     //---SEND_HEADERS----//
     [[NSUserDefaults standardUserDefaults] setValue:kYES forKey:kSendHeaders];
     [[NSUserDefaults standardUserDefaults] synchronize];
     
     [JSONHTTPClient postJSONFromURLWithString:url
     params:params
     completion:^(id json, JSONModelError *err) {
     
     //---SEND_HEADERS----//
     [[NSUserDefaults standardUserDefaults] setValue:kNO forKey:kSendHeaders];
     [[NSUserDefaults standardUserDefaults] synchronize];
     
     NSLog(@"post api response = %@", json);
     
     //---CHECK FOR EX00401 CODE,---UNAUTHENTICATEED STATUS---//
     if ([[json valueForKey:@"status"] isKindOfClass:[NSString class]]){
     if ([[json valueForKey:@"status"] isEqualToString:kLogoutStatus])
     [CommonModel showAlertAndLogoutOnVC:vc isPresentedVC:NO];
     }
     else
     {
     NSString *msg = [json valueForKey:@"message"] == nil ? [kErrorGeneral myModification] : [json valueForKey:@"message"];
     
     NSInteger verifyStatus = [[json valueForKeyPath:@"verification_data.status"] integerValue];
     response(msg, [[json valueForKey:@"status"] intValue], verifyStatus);
     }
     }];
     
     */
    
    //---NATIVE API CALLING---//
    
    
    NSURLSession *session        = [ApiManager getMesh2NativeApiSession];
    NSMutableURLRequest *request = [ApiManager getMesh2NativeApiRequestWithUrl:url andMethod:kPostMethod sendHeader:YES];
    
    NSError *paramsError;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&paramsError];
    [request setHTTPBody:postData];
    
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *responsee, NSError *serverError) {
        
        
        if(data == nil)
        {
            NSLog(@"Response data is nil for API = %@", url);
            response([kErrorGeneral myModification], 1, 1);
        }
        else{
            // Parse the JSON that came in into an NSDictionary
            NSError * parseError = nil;
            NSDictionary * json  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parseError];
            
            
            NSLog(@"Post api response after parsing = %@ and server error = %@", json, serverError);
            //        NSString *msg = [json valueForKey:@"message"] == nil ? [kErrorGeneral myModification] : [json valueForKey:@"message"];
            
            
            NSLog(@"parsed json =%@ and parsing error =%@", json, parseError);
            
            if (!serverError && !parseError){
                //---CHECK FOR EX00401 CODE,---UNAUTHENTICATEED STATUS---//
                if ([[json valueForKey:@"status"] isKindOfClass:[NSString class]]){
                    if ([[json valueForKey:@"status"] isEqualToString:kLogoutStatus])
                        [CommonModel showAlertAndLogoutOnVC:vc isPresentedVC:NO];
                }
                else{
                    NSString *msg = [json valueForKey:@"message"] == nil ? [kErrorGeneral myModification] : [json valueForKey:@"message"];
                    
                    NSInteger verifyStatus = [[json valueForKeyPath:@"verification_data.status"] integerValue];
                    response(msg, [[json valueForKey:@"status"] intValue], verifyStatus);
                }
            }
            else
                response([kErrorGeneral myModification], [[json valueForKey:@"status"] intValue], 1);//---unknown status---//---if server error or parse error then send 1---//
        }
    }];
    
    [postDataTask resume];
}


//---MESH APIS


- (void)mesh_postApiWithParamString:(NSString*)paramsStr withApi:(NSString *)url withResponse:(void (^)(NSDictionary *json, NSInteger errorCode, NSString *message))response{
    NSLog(@"post api URL = %@ and params = %@",url, paramsStr);
    
    
    //---NATIVE API CALLING---//
    //---SEND_HEADERS----//
    [[NSUserDefaults standardUserDefaults] setValue:kNO forKey:kSendHeaders];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    ///*
    
    //---POSTMAN CODE---//
    

    NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:kHeaderToken];
       NSString *tokenWithBear = [NSString stringWithFormat:@"Bearer %@", token];
    NSString *lang = @"en";
       
       if([[NSUserDefaults.standardUserDefaults stringForKey:@"userlanguage"] isEqual:nil] || [[NSUserDefaults.standardUserDefaults stringForKey:@"userlanguage"] isEqual:[NSNull null]]){
           
           lang  = [[NSLocale preferredLanguages] firstObject];
       }else{
           
           lang = [NSUserDefaults.standardUserDefaults stringForKey:@"userlanguage"];
       }
   NSDictionary *headers = @{ @"content-type": @"application/json",@"lang":lang,@"Authorization":tokenWithBear};
    //                               @"cache-control": @"no-cache"};
    //@"postman-token": @"6e578cdb-f39e-3560-6119-b7f28bec6681" };
    
    NSMutableData *postData = [[NSMutableData alloc] initWithData:[paramsStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    [request setHTTPMethod:kPostMethod];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *responsee, NSError *serverError) {
        if (serverError) {
            NSLog(@"%@", serverError);
        } else {
            
            
            if(data == nil)
            {
                NSLog(@"Response data is nil for API = %@", url);
                response(nil, 1, [kErrorGeneral myModification]);
            }
            else{
                // Parse the JSON that came in into an NSDictionary
                NSError * parseError = nil;
                NSDictionary * json  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parseError];
                
                
                NSLog(@"Post api response after parsing = %@ and server error = %@", json, serverError);
                NSString *msg = [json valueForKey:@"message"] == nil ? [kErrorGeneral myModification] : [json valueForKey:@"message"];
                
                
                NSLog(@"parsed json =%@ and parsing error =%@", json, parseError);
                
                if (!serverError && !parseError){
                    response(json, [[json valueForKey:@"status"] intValue], msg);
                }
                else
                    response(json, [[json valueForKey:@"status"] intValue], [kErrorGeneral myModification]);
            }
        }
    }];
    [dataTask resume];
    
    //*/
}


- (void)mesh_postApiWithOutParam:(NSString *)url withResponse:(void (^)(NSDictionary *json, NSInteger errorCode, NSString *message))response{
    
    NSLog(@"%@", url);
    
    
    //---NATIVE API CALLING---//
    //---SEND_HEADERS----//
    [[NSUserDefaults standardUserDefaults] setValue:kNO forKey:kSendHeaders];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    ///*
    
    //---POSTMAN CODE---//
    

    NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:kHeaderToken];
       NSString *tokenWithBear = [NSString stringWithFormat:@"Bearer %@", token];
    NSString *lang = @"en";
       
       if([[NSUserDefaults.standardUserDefaults stringForKey:@"userlanguage"] isEqual:nil] || [[NSUserDefaults.standardUserDefaults stringForKey:@"userlanguage"] isEqual:[NSNull null]]){
           
           lang  = [[NSLocale preferredLanguages] firstObject];
       }else{
           
           lang = [NSUserDefaults.standardUserDefaults stringForKey:@"userlanguage"];
       }
   NSDictionary *headers = @{ @"content-type": @"application/json",@"lang":lang,@"Authorization":tokenWithBear};
    //                               @"cache-control": @"no-cache"};
    //@"postman-token": @"6e578cdb-f39e-3560-6119-b7f28bec6681" };
    
   // NSMutableData *postData = [[NSMutableData alloc] initWithData:[paramsStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    [request setHTTPMethod:kPostMethod];
    [request setAllHTTPHeaderFields:headers];
   // [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *responsee, NSError *serverError) {
        if (serverError) {
            NSLog(@"%@", serverError);
        } else {
            
            
            if(data == nil)
            {
                NSLog(@"Response data is nil for API = %@", url);
                response(nil, 1, [kErrorGeneral myModification]);
            }
            else{
                // Parse the JSON that came in into an NSDictionary
                NSError * parseError = nil;
                NSDictionary * json  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parseError];
                
                
                NSLog(@"Post api response after parsing = %@ and server error = %@", json, serverError);
                NSString *msg = [json valueForKey:@"message"] == nil ? [kErrorGeneral myModification] : [json valueForKey:@"message"];
                
                
                NSLog(@"parsed json =%@ and parsing error =%@", json, parseError);
                
                if (!serverError && !parseError){
                    response(json, [[json valueForKey:@"status"] intValue], msg);
                }
                else
                    response(json, [[json valueForKey:@"status"] intValue], [kErrorGeneral myModification]);
            }
            
            
        }
    }];
    [dataTask resume];
    
    //*/
}

- (void)mesh_putApiWithParamString:(NSDictionary*)paramsStr withApi:(NSString *)url withResponse:(void (^)(NSDictionary *json, NSInteger errorCode, NSString *message))response{
    NSLog(@"post api URL = %@ and params = %@",url, paramsStr);
    
    
    //---NATIVE API CALLING---//
    //---SEND_HEADERS----//
    [[NSUserDefaults standardUserDefaults] setValue:kNO forKey:kSendHeaders];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    ///*
    
    //---POSTMAN CODE---//
    

    NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:kHeaderToken];
       NSString *tokenWithBear = [NSString stringWithFormat:@"Bearer %@", token];
    NSString *lang = @"en";
       
       if([[NSUserDefaults.standardUserDefaults stringForKey:@"userlanguage"] isEqual:nil] || [[NSUserDefaults.standardUserDefaults stringForKey:@"userlanguage"] isEqual:[NSNull null]]){
           
           lang  = [[NSLocale preferredLanguages] firstObject];
       }else{
           
           lang = [NSUserDefaults.standardUserDefaults stringForKey:@"userlanguage"];
       }
    
   NSDictionary *headers = @{ @"content-type": @"application/json",@"lang":lang,@"Authorization":tokenWithBear};
    //                               @"cache-control": @"no-cache"};
    //@"postman-token": @"6e578cdb-f39e-3560-6119-b7f28bec6681" };
    
    NSError *paramsError;
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:paramsStr options:0 error:&paramsError];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    [request setHTTPMethod:kPutMethod];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *responsee, NSError *serverError) {
        if (serverError) {
            NSLog(@"%@", serverError);
        } else {
            
            
            if(data == nil)
            {
                NSLog(@"Response data is nil for API = %@", url);
                response(nil, 1, [kErrorGeneral myModification]);
            }
            else{
                // Parse the JSON that came in into an NSDictionary
                NSError * parseError = nil;
                NSDictionary * json  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parseError];
                
                
                NSLog(@"Post api response after parsing = %@ and server error = %@", json, serverError);
                NSString *msg = [json valueForKey:@"message"] == nil ? [kErrorGeneral myModification] : [json valueForKey:@"message"];
                
                
                NSLog(@"parsed json =%@ and parsing error =%@", json, parseError);
                
                if (!serverError && !parseError){
                    response(json, [[json valueForKey:@"status"] intValue], msg);
                }
                else
                    response(json, [[json valueForKey:@"status"] intValue], [kErrorGeneral myModification]);
            }
            
            
        }
    }];
    [dataTask resume];
    //*/
}


- (void)mesh_putApiNotiWithParamString:(NSString*)paramsStr withApi:(NSString *)url withResponse:(void (^)(NSDictionary *json, NSInteger errorCode, NSString *message))response{
    NSLog(@"post api URL = %@ and params = %@",url, paramsStr);
    
    
    //---NATIVE API CALLING---//
    //---SEND_HEADERS----//
    [[NSUserDefaults standardUserDefaults] setValue:kNO forKey:kSendHeaders];
    [[NSUserDefaults standardUserDefaults] synchronize];
    ///*
    
    //---POSTMAN CODE---//

    NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:kHeaderToken];
       NSString *tokenWithBear = [NSString stringWithFormat:@"Bearer %@", token];
    NSString *lang = @"en";
       
       if([[NSUserDefaults.standardUserDefaults stringForKey:@"userlanguage"] isEqual:nil] || [[NSUserDefaults.standardUserDefaults stringForKey:@"userlanguage"] isEqual:[NSNull null]]){
           
           lang  = [[NSLocale preferredLanguages] firstObject];
       }else{
           
           lang = [NSUserDefaults.standardUserDefaults stringForKey:@"userlanguage"];
       }
    
   NSDictionary *headers = @{ @"content-type": @"application/json",@"lang":lang,@"Authorization":tokenWithBear};
    //                               @"cache-control": @"no-cache"};
    //@"postman-token": @"6e578cdb-f39e-3560-6119-b7f28bec6681" };
    
    //NSError *paramsError;
    
    NSMutableData *postData = [[NSMutableData alloc] initWithData:[paramsStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    [request setHTTPMethod:kPutMethod];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *responsee, NSError *serverError) {
        if (serverError) {
            NSLog(@"%@", serverError);
        } else {
            
            
            if(data == nil)
            {
                NSLog(@"Response data is nil for API = %@", url);
                response(nil, 1, [kErrorGeneral myModification]);
            }
            else{
                // Parse the JSON that came in into an NSDictionary
                NSError * parseError = nil;
                NSDictionary * json  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parseError];
                
                
                NSLog(@"Post api response after parsing = %@ and server error = %@", json, serverError);
                NSString *msg = [json valueForKey:@"message"] == nil ? [kErrorGeneral myModification] : [json valueForKey:@"message"];
                
                
                NSLog(@"parsed json =%@ and parsing error =%@", json, parseError);
                
                if (!serverError && !parseError){
                    response(json, [[json valueForKey:@"status"] intValue], msg);
                }
                else
                    response(json, [[json valueForKey:@"status"] intValue], [kErrorGeneral myModification]);
            }
        }
    }];
    [dataTask resume];
    //*/
}



- (void)mesh_getApiWithApi:(NSString *)url withResponse:(void (^)(NSDictionary *json, NSInteger errorCode, NSString *message))response{
    NSLog(@"Mesh Get api URL = %@",url);
    
    
    //---NATIVE API CALLING---//
    //---SEND_HEADERS----//
    
    NSMutableURLRequest *request;
    NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:kHeaderToken];
    NSString *tokenWithBear = [NSString stringWithFormat:@"Bearer %@", token];
    NSString *lang = @"en";
    
    NSLog(@"token = %@",token);
    NSLog(@"Mesh Get api URL = %@",[[NSLocale currentLocale] languageCode]);
    
    
    if([[NSUserDefaults.standardUserDefaults stringForKey:@"userlanguage"] isEqual:nil] || [[NSUserDefaults.standardUserDefaults stringForKey:@"userlanguage"] isEqual:[NSNull null]]){
        
        lang  = [[NSLocale currentLocale] languageCode];
        NSLog(@"Mesh Get api URL = %@",lang);
    }else{
        
        lang = [NSUserDefaults.standardUserDefaults stringForKey:@"userlanguage"];
        NSLog(@"Mesh Get api URL = %@",lang);
    }
    
    if ([url.lowercaseString containsString:@"/contentfilters/"]) {
        request = [ApiManager getMesh2NativeApiRequestWithUrl:url andMethod:kGetMethod sendHeader:kYES];
    }
    else {
        
        NSDictionary *headers = @{ @"content-type": @"application/json",@"lang":lang,@"Authorization":tokenWithBear};
        [[NSUserDefaults standardUserDefaults] setValue:kNO forKey:kSendHeaders];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        [request setHTTPMethod:kGetMethod];
        [request setAllHTTPHeaderFields:headers];
        
    }
    
    //---POSTMAN CODE---//
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *responsee, NSError *serverError) {
        if (serverError) {
            NSLog(@"%@", serverError);
        } else {
            
            
            if(data == nil)
            {
                NSLog(@"Response data is nil for API = %@", url);
                response(nil, 1, [kErrorGeneral myModification]);
            }
            else{
                // Parse the JSON that came in into an NSDictionary
                NSError * parseError = nil;
                NSDictionary * json  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parseError];
                
                
                NSLog(@"Get api response after parsing = %@ and server error = %@", json, serverError);
                NSString *msg = [json valueForKey:@"message"] == nil ? [kErrorGeneral myModification] : [json valueForKey:@"message"];
                
                
                NSLog(@"parsed json =%@ and parsing error =%@", json, parseError);
                
                if (!serverError && !parseError){
                    response(json, [[json valueForKey:@"status"] intValue], msg);
                }
                else
                    response(json, [[json valueForKey:@"status"] intValue], [kErrorGeneral myModification]);
            }
            
            
        }
    }];
    [dataTask resume];
    
    //*/
}


- (void)mesh2_getApiWithApi:(NSString *)url sendHeader:(BOOL)shouldSend withResponse:(void (^)(NSDictionary *json, NSInteger errorCode, NSString *message))response{
    NSLog(@"Mesh Get api URL = %@",url);
    
    
    //---NATIVE API CALLING---//
    //---SEND_HEADERS----//
    
    NSURLSession *session        = [ApiManager getMesh2NativeApiSession];
    NSMutableURLRequest *request = [ApiManager getMesh2NativeApiRequestWithUrl:url andMethod:kGetMethod sendHeader:kYES];
    
    //---POSTMAN CODE---//
    
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *responsee, NSError *serverError) {
        if (serverError) {
            NSLog(@"Error: %@", serverError);
        } else {
            
            
            if(data == nil) {
                response(nil, 1, [kErrorGeneral myModification]);
            }
            else {
                // Parse the JSON that came in into an NSDictionary
                NSError * parseError = nil;
                NSDictionary * json  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parseError];
                
                NSString *msg = [json valueForKey:@"message"] == nil ? [kErrorGeneral myModification] : [json valueForKey:@"message"];
                
                if (!serverError && !parseError){
                    response(json, [[json valueForKey:@"status"] intValue], msg);
                }
                else
                    response(json, [[json valueForKey:@"status"] intValue], [kErrorGeneral myModification]);
            }
            
            
        }
    }];
    [dataTask resume];
    
    //*/
}


- (void)mesh_patchApiWithParamString:(NSString*)paramsStr withApi:(NSString *)url withResponse:(void (^)(NSDictionary *json, NSInteger errorCode, NSString *message))response{
    NSLog(@"patch api URL = %@ and params = %@",url, paramsStr);
    
    
    //---NATIVE API CALLING---//
    //---SEND_HEADERS----//
     [[NSUserDefaults standardUserDefaults] setValue:kNO forKey:kSendHeaders];
       [[NSUserDefaults standardUserDefaults] synchronize];
       
       
       ///*
       
       //---POSTMAN CODE---//

       NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:kHeaderToken];
       NSString *tokenWithBear = [NSString stringWithFormat:@"Bearer %@", token];
       NSString *lang = @"en";
       
       if([[NSUserDefaults.standardUserDefaults stringForKey:@"userlanguage"] isEqual:[NSNull null]] || [[NSUserDefaults.standardUserDefaults stringForKey:@"userlanguage"] isEqual:[NSNull null]]){
           
           lang  = [[NSLocale preferredLanguages] firstObject];
       }else{
           
           lang = [NSUserDefaults.standardUserDefaults stringForKey:@"userlanguage"];
       }
       
       NSDictionary *headers = @{ @"content-type": @"application/json",@"lang":lang,@"Authorization":tokenWithBear};   
    //                               @"cache-control": @"no-cache"};
    //@"postman-token": @"6e578cdb-f39e-3560-6119-b7f28bec6681" };
    
    NSMutableData *postData = [[NSMutableData alloc] initWithData:[paramsStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    [request setHTTPMethod:kPatchMethod];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *responsee, NSError *serverError) {
        if (serverError) {
            NSLog(@"Patch api server error = %@", serverError);
        } else {
            
            
            if(data == nil)
            {
                NSLog(@"Response data is nil for API = %@", url);
                response(nil, 1, [kErrorGeneral myModification]);
            }
            else{
                // Parse the JSON that came in into an NSDictionary
                NSError * parseError = nil;
                NSDictionary * json  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parseError];
                
                
                NSLog(@"Patch api response after parsing = %@ and server error = %@", json, serverError);
                NSString *msg = [json valueForKey:@"message"] == nil ? [kErrorGeneral myModification] : [json valueForKey:@"message"];
                
                
                NSLog(@"parsed json =%@ and parsing error =%@", json, parseError);
                
                if (!serverError && !parseError){
                    response(json, [[json valueForKey:@"status"] intValue], msg);
                }
                else
                    response(json, [[json valueForKey:@"status"] intValue], [kErrorGeneral myModification]);
            }
        }
    }];
    [dataTask resume];
    
    //*/
}

- (void)mesh_patch_withJson_ApiWithParamString:(NSString*)paramsStr withApi:(NSString *)url withResponse:(void (^)(NSDictionary *json, NSInteger errorCode, NSString *message))response{
    NSLog(@"patch json api URL = %@ and params = %@",url, paramsStr);
    
    NSLog(@"%@", url);
    //---NATIVE API CALLING---//
    //---SEND_HEADERS----//
    [[NSUserDefaults standardUserDefaults] setValue:kNO forKey:kSendHeaders];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //---POSTMAN CODE---//

    NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:kHeaderToken];
    NSString *tokenWithBear = [NSString stringWithFormat:@"Bearer %@", token];
    NSString *lang = @"en";
    
    if([[NSUserDefaults.standardUserDefaults stringForKey:@"userlanguage"] isEqual:[NSNull null]] || [[NSUserDefaults.standardUserDefaults stringForKey:@"userlanguage"] isEqual:[NSNull null]]){
        
        lang  = [[NSLocale preferredLanguages] firstObject];
    }else{
        
        lang = [NSUserDefaults.standardUserDefaults stringForKey:@"userlanguage"];
    }
    
    NSDictionary *headers = @{ @"content-type": @"application/json",@"lang":lang,@"Authorization":tokenWithBear};
    NSMutableData *postData = [[NSMutableData alloc] initWithData:[paramsStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    [request setHTTPMethod:kPatchMethod];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *responsee, NSError *serverError) {
        if (serverError) {
            NSLog(@"Patch api server error = %@", serverError);
        } else {
            
            if(data == nil)
            {
                NSLog(@"Response data is nil for API = %@", url);
                response(nil, 1, [kErrorGeneral myModification]);
            }
            else{
                // Parse the JSON that came in into an NSDictionary
                NSError * parseError = nil;
                NSDictionary * json  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parseError];
                
                NSLog(@"Patch api response after parsing = %@ and server error = %@", json, serverError);
                NSString *msg = [json valueForKey:@"message"] == nil ? [kErrorGeneral myModification] : [json valueForKey:@"message"];
    
                NSLog(@"parsed json =%@ and parsing error =%@", json, parseError);
                
                if (!serverError && !parseError){
                    response(json, [[json valueForKey:@"status"] intValue], msg);
                }
                else
                    response(json, [[json valueForKey:@"status"] intValue], [kErrorGeneral myModification]);
            }
        }
    }];
    [dataTask resume];
    
    //*/
}

- (void)mesh_deleteApiWithStringParam:(NSString*)paramsStr withApi:(NSString *)url withResponse:(void (^)(NSDictionary *json, NSInteger errorCode, NSString *message))response{
    NSLog(@"Mesh Delete api URL = %@",paramsStr);
    
    //---NATIVE API CALLING---//
    //---SEND_HEADERS----//
    [[NSUserDefaults standardUserDefaults] setValue:kNO forKey:kSendHeaders];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //---POSTMAN CODE---//
    NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:kHeaderToken];
        NSString *tokenWithBear = [NSString stringWithFormat:@"Bearer %@", token];
    NSString *lang = @"en";
       
       if([[NSUserDefaults.standardUserDefaults stringForKey:@"userlanguage"] isEqual:nil] || [[NSUserDefaults.standardUserDefaults stringForKey:@"userlanguage"] isEqual:[NSNull null]]){
           
           lang  = [[NSLocale preferredLanguages] firstObject];
       }else{
           
           lang = [NSUserDefaults.standardUserDefaults stringForKey:@"userlanguage"];
       }
    NSDictionary *headers = @{ @"content-type": @"application/json",@"lang":lang,@"Authorization":tokenWithBear};
   // NSError *paramsError;
    NSMutableData *postData = [[NSMutableData alloc] initWithData:[paramsStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    [request setHTTPMethod:kDeleteMethod];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *responsee, NSError *serverError) {
        if (serverError) {
            NSLog(@"%@", serverError);
        } else {
            
            if(data == nil)
            {
                NSLog(@"Response data is nil for API = %@", url);
                response(nil, 1, [kErrorGeneral myModification]);
            }
            else{
                // Parse the JSON that came in into an NSDictionary
                NSError * parseError = nil;
                NSDictionary * json  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parseError];
                
                NSLog(@"Delete Mesh native api response after parsing = %@ and server error = %@", json, serverError);
                NSString *msg = [json valueForKey:@"message"] == nil ? [kErrorGeneral myModification] : [json valueForKey:@"message"];
                
                NSLog(@"parsed json =%@ and parsing error =%@", json, parseError);
                
                if (!serverError && !parseError){
                    response(json, [[json valueForKey:@"status"] intValue], msg);
                }
                else
                    response(json, [[json valueForKey:@"status"] intValue], [kErrorGeneral myModification]);
            }
        }
    }];
    [dataTask resume];
}

- (void)mesh_deleteApiWithApi:(NSString *)url withResponse:(void (^)(NSDictionary *json, NSInteger errorCode, NSString *message))response{
    NSLog(@"Mesh Delete api URL = %@",url);
    
    
    //---NATIVE API CALLING---//
    //---SEND_HEADERS----//
    [[NSUserDefaults standardUserDefaults] setValue:kNO forKey:kSendHeaders];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    ///*
    
    //---POSTMAN CODE---//
    
    
    NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:kHeaderToken];
        NSString *tokenWithBear = [NSString stringWithFormat:@"Bearer %@", token];
    NSString *lang = @"en";
       
       if([[NSUserDefaults.standardUserDefaults stringForKey:@"userlanguage"] isEqual:nil] || [[NSUserDefaults.standardUserDefaults stringForKey:@"userlanguage"] isEqual:[NSNull null]]){
           
           lang  = [[NSLocale preferredLanguages] firstObject];
       }else{
           
           lang = [NSUserDefaults.standardUserDefaults stringForKey:@"userlanguage"];
       }
    NSDictionary *headers = @{ @"content-type": @"application/json",@"lang":lang,@"Authorization":tokenWithBear};
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
   
    [request setHTTPMethod:kDeleteMethod];
    [request setAllHTTPHeaderFields:headers];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *responsee, NSError *serverError) {
        if (serverError) {
            NSLog(@"%@", serverError);
        } else {
            
            if(data == nil)
            {
                NSLog(@"Response data is nil for API = %@", url);
                response(nil, 1, [kErrorGeneral myModification]);
            }
            else{
                // Parse the JSON that came in into an NSDictionary
                NSError * parseError = nil;
                NSDictionary * json  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parseError];
                
                
                NSLog(@"Delete Mesh native api response after parsing = %@ and server error = %@", json, serverError);
                NSString *msg = [json valueForKey:@"message"] == nil ? [kErrorGeneral myModification] : [json valueForKey:@"message"];
                
                
                NSLog(@"parsed json =%@ and parsing error =%@", json, parseError);
                
                if (!serverError && !parseError){
                    response(json, [[json valueForKey:@"status"] intValue], msg);
                }
                else
                    response(json, [[json valueForKey:@"status"] intValue], [kErrorGeneral myModification]);
            }
            
            
        }
    }];
    [dataTask resume];
    
    //*/
}



#pragma mark - DELETE APIS

- (void)deleteApiWithParams:(NSDictionary *)params andUrl:(NSString *)url andController:(UIViewController *)vc withResponse:(void (^)(NSString *error, NSInteger errorCode))response{
    NSLog(@"Delete api URL = %@ and params = %@",url,params);
    
    
    /*
     //---SEND_HEADERS----//
     [[NSUserDefaults standardUserDefaults] setValue:kYES forKey:kSendHeaders];
     [[NSUserDefaults standardUserDefaults] synchronize];
     
     
     [JSONHTTPClient deleteJSONFromURLWithString:url
     params:params
     completion:^(id json, JSONModelError *err) {
     
     //---SEND_HEADERS----//
     [[NSUserDefaults standardUserDefaults] setValue:kNO forKey:kSendHeaders];
     [[NSUserDefaults standardUserDefaults] synchronize];
     
     NSLog(@"delete api response = %@", json);
     NSString *msg = [json valueForKey:@"message"] == nil ? [kErrorGeneral myModification] : [json valueForKey:@"message"];
     
     
     //---CHECK FOR EX00401 CODE,---UNAUTHENTICATEED STATUS---//
     if ([[json valueForKey:@"status"] isKindOfClass:[NSString class]]){
     if ([[json valueForKey:@"status"] isEqualToString:kLogoutStatus])
     [CommonModel showAlertAndLogoutOnVC:vc isPresentedVC:NO];
     }
     else
     response(msg, [[json valueForKey:@"status"] intValue]);
     }];
     
     */
    
    ///*
    //---NATIVE API CALLING---//
    
    
    NSURLSession *session        = [ApiManager getMesh2NativeApiSession];
    NSMutableURLRequest *request = [ApiManager getMesh2NativeApiRequestWithUrl:url andMethod:kDeleteMethod sendHeader:YES];
    
    NSError *paramsError;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&paramsError];
    [request setHTTPBody:postData];
    
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *responsee, NSError *serverError) {
        //        NSLog(@"data = %@ response = %@ and error = %@", data, response, error);
        
        
        if(data == nil)
        {
            NSLog(@"Response data is nil for API = %@", url);
            response([kErrorGeneral myModification], 1);
        }
        else{
            // Parse the JSON that came in into an NSDictionary
            NSError * parseError = nil;
            NSDictionary * json  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parseError];
            
            
            NSLog(@"delete api response after parsing = %@ and server error = %@", json, serverError);
            
            NSString *msg = [json valueForKey:@"message"] == nil ? [kErrorGeneral myModification] : [json valueForKey:@"message"];
            
            
            NSLog(@"parsed json =%@ and parsing error =%@", json, parseError);
            
            if (!serverError && !parseError){
                //---CHECK FOR EX00401 CODE,---UNAUTHENTICATEED STATUS---//
                if ([[json valueForKey:@"status"] isKindOfClass:[NSString class]]){
                    if ([[json valueForKey:@"status"] isEqualToString:kLogoutStatus])
                        [CommonModel showAlertAndLogoutOnVC:vc isPresentedVC:NO];
                }
                else
                    response(msg, [[json valueForKey:@"status"] intValue]);
            }
            else
                response([kErrorGeneral myModification], [[json valueForKey:@"status"] intValue]);
        }
        
        
        
    }];
    
    [postDataTask resume];
    
    //*/
    
}


- (void)postApiWithParamsLogout:(NSDictionary *)params andUrl:(NSString *)url andController:(UIViewController *)vc withResponse:(void (^)(NSString *error, Boolean errorCode))response{
    NSLog(@"Delete api URL = %@ and params = %@",url,params);
    
    
    /*
     //---SEND_HEADERS----//
     [[NSUserDefaults standardUserDefaults] setValue:kYES forKey:kSendHeaders];
     [[NSUserDefaults standardUserDefaults] synchronize];
     
     
     [JSONHTTPClient deleteJSONFromURLWithString:url
     params:params
     completion:^(id json, JSONModelError *err) {
     
     //---SEND_HEADERS----//
     [[NSUserDefaults standardUserDefaults] setValue:kNO forKey:kSendHeaders];
     [[NSUserDefaults standardUserDefaults] synchronize];
     
     NSLog(@"delete api response = %@", json);
     NSString *msg = [json valueForKey:@"message"] == nil ? [kErrorGeneral myModification] : [json valueForKey:@"message"];
     
     
     //---CHECK FOR EX00401 CODE,---UNAUTHENTICATEED STATUS---//
     if ([[json valueForKey:@"status"] isKindOfClass:[NSString class]]){
     if ([[json valueForKey:@"status"] isEqualToString:kLogoutStatus])
     [CommonModel showAlertAndLogoutOnVC:vc isPresentedVC:NO];
     }
     else
     response(msg, [[json valueForKey:@"status"] intValue]);
     }];
     
     */
    
    ///*
    //---NATIVE API CALLING---//
    
    
    NSURLSession *session        = [ApiManager getMesh2NativeApiSession];
    NSMutableURLRequest *request = [ApiManager getMesh2NativeApiRequestWithUrl:url andMethod:kPostMethod sendHeader:YES];
    
    NSError *paramsError;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&paramsError];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *responsee, NSError *serverError) {
        if(data == nil)
        {
            NSLog(@"Response data is nil for API = %@", url);
            response([kErrorGeneral myModification], 1);
        }
        else{
            // Parse the JSON that came in into an NSDictionary
            NSError * parseError = nil;
            NSDictionary * json  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parseError];
            
            NSLog(@"delete api response after parsing = %@ and server error = %@", json, serverError);
            NSString *msg = [json valueForKey:@"error"] == nil ? [kErrorGeneral myModification] : [json valueForKey:@"message"];
            NSLog(@"parsed json =%@ and parsing error =%@", json, parseError);
            
            if (!serverError && !parseError){
                //---CHECK FOR EX00401 CODE,---UNAUTHENTICATEED STATUS---//
                if ([[json valueForKey:@"status"] isKindOfClass:[NSString class]]){
                    if ([[json valueForKey:@"status"] isEqualToString:kLogoutStatus])
                        [CommonModel showAlertAndLogoutOnVC:vc isPresentedVC:NO];
                }
                else
                    response(msg, [[json valueForKey:@"status"] boolValue]);
            }
            else
                response([kErrorGeneral myModification], [[json valueForKey:@"status"] boolValue]);
        }
    }];
    [postDataTask resume];
    
}

#pragma mark - GET APIS

- (void)commonGetApiWithVC:(UIViewController *)vc andUrl:(NSString *)url withResponse:(void (^)(id response, JSONModelError *error))response failure:(void (^)(NSString *error, NSInteger errorCode))failure{
    NSLog(@"Common Get api URL = %@",url);
    
    //---NATIVE API CALLING---//
    
    NSURLSession *session        = [ApiManager getMesh2NativeApiSession];
    NSMutableURLRequest *request = [ApiManager getMesh2NativeApiRequestWithUrl:url andMethod:kGetMethod sendHeader:YES];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *responsee, NSError *apiError) {
        
        if(data == nil)
        {
            NSLog(@"Response data is nil for API = %@", url);
            failure([kErrorGeneral myModification], 1);
        }
        else{
            // Parse the JSON that came in into an NSDictionary
            NSError * parsingError = nil;
            NSDictionary * json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parsingError];
            
            NSString *msg = [json valueForKey:@"message"] == nil ? [kErrorGeneral myModification] : [json valueForKey:@"message"];
            NSLog(@"dict after parsing = %@ and error = %@", json, parsingError);
            
            
            if (!apiError && !parsingError){ // if no error occurred, parse the array of objects as normal
                // Parse the JSON dictionary 'jsonDict' here
                
                NSLog(@"parsing done and json dict = %@", json);
                
                if([[json valueForKey:@"status"] intValue] != 200)
                {
                    //---CHECK FOR EX00401 CODE,---UNAUTHENTICATEED STATUS---//
                    if ([[json valueForKey:@"status"] isKindOfClass:[NSString class]]){
                        if ([[json valueForKey:@"status"] isEqualToString:kLogoutStatus])
                            [CommonModel showAlertAndLogoutOnVC:vc isPresentedVC:NO];
                    }
                    else
                        failure(msg, [[json valueForKey:@"status"] intValue]);
                }
                else{
                    NSError *error;
                    AppBlockerModel_mesh2 *model2 = [[AppBlockerModel_mesh2 alloc] initWithDictionary:json error:&error];
                    
                    NSLog(@"model after = %d and message = %@ and count = %lu", model2.status, model2.message, (unsigned long)model2.app_list.count);
                    NSString *msg = [json valueForKey:@"message"] == nil ? [kErrorGeneral myModification] : [json valueForKey:@"message"];
                    
                    
                    if (json)
                        response(json, nil);
                    else{
                        failure(msg, 1);
                    }
                }
            }else{ // an error occurred so we need to let the user know
                // Handle your error here
                NSLog(@"Api Error = %@ and parsing error = %@", apiError, parsingError);
                failure(msg, 1);
            }
        }
    }];
    
    [postDataTask resume];
}

- (void)getFuntimeApiWithVC:(UIViewController *)vc andUrl:(NSString *)url withResponse:(void (^)(FuntimeModel *funtimeModel, NSString *msg, NSInteger statusCode))response{
    NSLog(@"Get api URL = %@",url);
    //---NATIVE API CALLING---//
    
    NSURLSession *session        = [ApiManager getMesh2NativeApiSession];
    NSMutableURLRequest *request = [ApiManager getMesh2NativeApiRequestWithUrl:url andMethod:kGetMethod sendHeader:YES];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *responsee, NSError *apiError) {
        if(data == nil)
        {
            NSLog(@"Response data is nil for API = %@", url);
            response(nil, [kErrorGeneral myModification], 1);
        }
        else{
            // Parse the JSON that came in into an NSDictionary
            NSError * parsingError = nil;
            NSDictionary * json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parsingError];
            
            //        NSString *msg = [json valueForKey:@"message"] == nil ? [kErrorGeneral myModification] : [json valueForKey:@"message"];
            NSLog(@"dict after parsing = %@ and error = %@", json, parsingError);
            
            NSLog(@"parsing done and json dict = %@", json);
            //---CHECK FOR EX00401 CODE,---UNAUTHENTICATEED STATUS---//
            if ([[json valueForKey:@"status"] isKindOfClass:[NSString class]]){
                if ([[json valueForKey:@"status"] isEqualToString:kLogoutStatus])
                    [CommonModel showAlertAndLogoutOnVC:vc isPresentedVC:NO];
            }
            else{
                NSLog(@"funtime mesh2 response = %@",json);
                
                FuntimeModel *funtime = [[FuntimeModel alloc] init];
                [funtime mts_setValuesForKeysWithDictionary:json];
                
                response(funtime, @"", [funtime status]);
            }
        }
    }];
    
    [postDataTask resume];
}

- (void)getIOSAppBlockerApiWithVC:(UIViewController *)vc andUrl:(NSString *)url withResponse:(void (^)(IOSAppBlockerModel *model, NSString *msg, NSInteger statusCode))response{
    NSLog(@"Get api URL = %@",url);
    
    //---NATIVE API CALLING---//
    
    NSURLSession *session        = [ApiManager getMesh2NativeApiSession];
    NSMutableURLRequest *request = [ApiManager getMesh2NativeApiRequestWithUrl:url andMethod:kGetMethod sendHeader:YES];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *responsee, NSError *apiError) {
        NSLog(@"Get api URL = %@",url);
        
        //---NATIVE API CALLING---//
        
        NSURLSession *session        = [ApiManager getMesh2NativeApiSession];
        NSMutableURLRequest *request = [ApiManager getMesh2NativeApiRequestWithUrl:url andMethod:kGetMethod sendHeader:YES];
        NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *responsee, NSError *apiError) {
            
            if(data == nil)
            {
                NSLog(@"Response data is nil for API = %@", url);
                response(nil, [kErrorGeneral myModification], 1);
            }
            else{
                // Parse the JSON that came in into an NSDictionary
                NSError * parsingError = nil;
                NSDictionary * json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parsingError];
                
                NSLog(@"dict after parsing = %@ and error = %@", json, parsingError);
                NSLog(@"parsing done and json dict = %@", json);
                //---CHECK FOR EX00401 CODE,---UNAUTHENTICATEED STATUS---//
                if ([[json valueForKey:@"status"] isKindOfClass:[NSString class]]){
                    if ([[json valueForKey:@"status"] isEqualToString:kLogoutStatus])
                        [CommonModel showAlertAndLogoutOnVC:vc isPresentedVC:NO];
                }
                else{
                    NSLog(@"IOS AppBlocker mesh2 response = %@",json);
                    //
                    NSError *error;
                    IOSAppBlockerModel *model = [[IOSAppBlockerModel alloc] initWithDictionary:json error:&error];
                    
                    response(model, model.message, model.status);
                }
            }
        }];
        
        [postDataTask resume];
    }];
    
    [postDataTask resume];
}

- (void)getPlacesApiWithVC:(UIViewController *)vc andUrl:(NSString *)url withResponse:(void (^)(AllPlacesModel *model, NSString *msg, NSInteger statusCode))response{
    NSLog(@"Get api URL = %@",url);
    
    //---NATIVE API CALLING---//
    
    NSURLSession *session        = [ApiManager getMesh2NativeApiSession];
    NSMutableURLRequest *request = [ApiManager getMesh2NativeApiRequestWithUrl:url andMethod:kGetMethod sendHeader:YES];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *responsee, NSError *apiError) {
        
        if(data == nil)
        {
            NSLog(@"Response data is nil for API = %@", url);
            response(nil, [kErrorGeneral myModification], 1);
        }
        else{
            // Parse the JSON that came in into an NSDictionary
            NSError * parsingError = nil;
            NSDictionary * json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parsingError];
            
            //NSLog(@"dict after parsing = %@ and error = %@", json, parsingError);
            //NSLog(json);
            
            
            //---CHECK FOR EX00401 CODE,---UNAUTHENTICATEED STATUS---//
            if ([[json valueForKey:@"status"] isKindOfClass:[NSString class]]){
                if ([[json valueForKey:@"status"] isEqualToString:kLogoutStatus])
                    [CommonModel showAlertAndLogoutOnVC:vc isPresentedVC:NO];
            }
            else{
                NSLog(@"get places mesh2 api = %@",json);
                //
                NSError *error;
                AllPlacesModel *model = [[AllPlacesModel alloc] initWithDictionary:json error:&error];
                response(model, @"", [[json valueForKey:@"status"] intValue]);
            }
        }
        
    }];
    
    [postDataTask resume];
}


- (void)mesh2_commonGetApiWithVC:(UIViewController *)vc andUrl:(NSString *)url withResponse:(void (^)(id json))response{
    NSLog(@"Common Get api URL = %@",url);
    //---NATIVE API CALLING---//
    
    NSURLSession *session        = [ApiManager getMesh2NativeApiSession];
    NSMutableURLRequest *request = [ApiManager getMesh2NativeApiRequestWithUrl:url andMethod:kGetMethod sendHeader:YES];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *responsee, NSError *apiError) {
        
        if(data == nil)
        {
            NSLog(@"Response data is nil for API = %@", url);
            //            failure([kErrorGeneral myModification], 1);
        }
        else{
            // Parse the JSON that came in into an NSDictionary
            NSError * parsingError = nil;
            NSDictionary * json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parsingError];
            
            //        NSString *msg = [json valueForKey:@"message"] == nil ? [kErrorGeneral myModification] : [json valueForKey:@"message"];
            NSLog(@"dict after parsing = %@ and error = %@", json, parsingError);
            
            //            if([[json valueForKey:@"status"] intValue] != 200)
            //            {
            //---CHECK FOR EX00401 CODE,---UNAUTHENTICATEED STATUS---//
            if ([[json valueForKey:@"status"] isKindOfClass:[NSString class]]){
                if ([[json valueForKey:@"status"] isEqualToString:kLogoutStatus])
                    [CommonModel showAlertAndLogoutOnVC:vc isPresentedVC:NO];
            }
            else{
                NSLog(@"common get mesh2 api response = %@", json);
                response(json);
            }
        }
    }];
    
    [postDataTask resume];
}

- (void)getIAProductsApiWithVC:(UIViewController *)vc withResponse:(void (^)(IAP_Dashboard *model, NSString *msg, NSInteger statusCode))response{
    NSLog(@"Get IAP products api URL = %@",kIAP_Products_Mesh2);
    
    //---NATIVE API CALLING---//
    NSURLSession *session        = [ApiManager getMesh2NativeApiSession];
    NSMutableURLRequest *request = [ApiManager getMesh2NativeApiRequestWithUrl:kIAP_Products_Mesh2 andMethod:kGetMethod sendHeader:YES];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *responsee, NSError *apiError) {
        if(data == nil)
        {
            NSLog(@"Response data is nil for API = %@", kIAP_Products_Mesh2);
            response(nil, [kErrorGeneral myModification], 1);
        }
        else{
            // Parse the JSON that came in into an NSDictionary
            NSError * parsingError = nil;
            NSDictionary * json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parsingError];
            
            NSLog(@"dict after parsing = %@ and error = %@", json, parsingError);
            NSLog(@"parsing done and json dict = %@", json);
            //---CHECK FOR EX00401 CODE,---UNAUTHENTICATEED STATUS---//
            if ([[json valueForKey:@"status"] isKindOfClass:[NSString class]]){
                if ([[json valueForKey:@"status"] isEqualToString:kLogoutStatus])
                    [CommonModel showAlertAndLogoutOnVC:vc isPresentedVC:NO];
            }
            else{
                NSError *error;
                IAP_Dashboard *model = [[IAP_Dashboard alloc] initWithDictionary:json error:&error];
                NSLog(@"error after parsing = %@", error.localizedDescription);
                NSLog(@"iap dashboard model after parsing = %@", model);
                response(model, @"", 0);
            }
        }
        
    }];
    
    [postDataTask resume];
    
}


#pragma mark - PUT APIS

- (void)putApi:(NSString *)url params:(NSDictionary*)params controller:(UIViewController *)vc isContPresented:(BOOL)isPresent withResponse:(void (^)(NSString *error, NSInteger errorCode))response{
    
    NSLog(@"Put api URL = %@ and params = %@",url, params);
        
    //---NATIVE API CALLING---//
    // methodchange
    NSURLSession *session        = [ApiManager getMesh2NativeApiSession];
    NSMutableURLRequest *request = [ApiManager getMesh2NativeApiRequestWithUrl:url andMethod:kPutMethod sendHeader:YES];
    
    NSError *paramsError;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&paramsError];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *responsee, NSError *serverError) {
                
        if(data == nil)
        {
            NSLog(@"Response data is nil for API = %@", url);
            response([kErrorGeneral myModification], 1);
        }
        else{
            // Parse the JSON that came in into an NSDictionary
            NSError * parseError = nil;
            
            NSLog(@"data before parsing = %@ and response = %@", data, response);
            
            NSDictionary * json  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parseError];
            NSString *msg        = [json valueForKey:@"message"] == nil ? [kErrorGeneral myModification] : [json valueForKey:@"message"];
            
            NSLog(@"parsing error = %@ and server error = %@", parseError, serverError);
            NSLog(@"put api json after parsing = %@", json);
            
            if (!serverError && !parseError){
                //---CHECK FOR EX00401 CODE,---UNAUTHENTICATEED STATUS---//
                if ([[json valueForKey:@"status"] isKindOfClass:[NSString class]]){
                    if ([[json valueForKey:@"status"] isEqualToString:kLogoutStatus])
                        NSLog(@"Put api URL = %@ and params = %@",url, params);
                        [CommonModel showAlertAndLogoutOnVC:vc isPresentedVC:NO];
                }
                else
                    response(msg, [[json valueForKey:@"status"] intValue]);
            }
            else
                response([kErrorGeneral myModification], [[json valueForKey:@"status"] intValue]);
        }
        
    }];
    
    [postDataTask resume];
}

- (void)putApiSOS:(NSString *)url params:(NSDictionary*)params controller:(UIViewController *)vc isContPresented:(BOOL)isPresent withResponse:(void (^)(NSString *error, NSInteger errorCode)) response {
    NSLog(@"Put api URL = %@ and params = %@",url, params);

    NSURLSession *session        = [ApiManager getMesh2NativeApiSession];
    NSMutableURLRequest *request = [ApiManager getMesh2NativeApiRequestWithUrl:url andMethod:kPostMethod sendHeader:YES];
    NSError *paramsError;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&paramsError];
    [request setHTTPBody:postData];
    NSString *token = UserDefaultsManager.bearerTokenCore2;
    NSString *tokenWithBear = [NSString stringWithFormat:@"Bearer %@", token];
    [request addValue:tokenWithBear   forHTTPHeaderField:@"Authorization"];

//    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *responsee, NSError *serverError){
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)responsee;
        NSInteger status = httpResponse.statusCode;
        if (status == 200 || status == 201 || status == 202 || status == 204 || status == 206){
            NSLog(@"Response data is nil for API = %@", url);
            NSError * parseError = nil;
            NSLog(@"data before parsing = %@ and response = %@", data, response);
            if(data == nil) {
                NSLog(@"Response data is nil for API = %@", url);
                response([kErrorGeneral myModification], status);
                return;
            }
            NSDictionary * json  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parseError];
            NSString *msg = [json valueForKey:@"message"] == nil ? [kErrorGeneral myModification] : [json valueForKey:@"message"];
            NSLog(@"parsing error = %@ and server error = %@", parseError, serverError);
            NSLog(@"put api json after parsing = %@", json);
            response(msg,status);
        } else {
            if(data == nil) {
                NSLog(@"Response data is nil for API = %@", url);
                response([kErrorGeneral myModification], status);
                return;
            }
            NSDictionary * json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&serverError];
            NSString *msg  = [json valueForKey:@"message"] == nil ? [kErrorGeneral myModification] : [json valueForKey:@"message"];
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)responsee;
            NSInteger status = httpResponse.statusCode;
            response(msg, status);
        }
    }];
    [postDataTask resume];
}


- (void)putApi:(NSString *)url params:(NSDictionary*)params withResponse:(void (^)(NSString *error, NSInteger errorCode))response{
    
    NSLog(@"Put api URL = %@ and params = %@",url, params);
    //---NATIVE API CALLING---//
    
    NSURLSession *session        = [ApiManager getMesh2NativeApiSession];
    NSMutableURLRequest *request = [ApiManager getMesh2NativeApiRequestWithUrl:url andMethod:kPutMethod sendHeader:YES];
    
    NSError *paramsError;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&paramsError];
    [request setHTTPBody:postData];
    
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *responsee, NSError *serverError) {
        
        if(data == nil)
        {
            NSLog(@"Response data is nil for API = %@", url);
            response([kErrorGeneral myModification], 1);
        }
        else{
            // Parse the JSON that came in into an NSDictionary
            NSError * parseError = nil;
            NSLog(@"data before parsing = %@ and response = %@", data, response);
            
            NSDictionary * json  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parseError];
            NSString *msg        = [json valueForKey:@"message"] == nil ? [kErrorGeneral myModification] : [json valueForKey:@"message"];
            
            NSLog(@"parsing error = %@ and server error = %@", parseError, serverError);
            NSLog(@"put api json after parsing = %@", json);
            
            if (!serverError && !parseError){
                //---CHECK FOR EX00401 CODE,---UNAUTHENTICATEED STATUS---//
                response(msg, [[json valueForKey:@"status"] intValue]);
            }
            else
                response([kErrorGeneral myModification], [[json valueForKey:@"status"] intValue]);
        }
    }];
    [postDataTask resume];
}

-(void)putApiToVerifySignupWithParams:(NSDictionary *)params onController:(UIViewController *)vc isContPresented:(BOOL)isPresent withResponse:(void (^)(NSString *error, NSInteger errorCode, UserModel *userModel))response{
    //---NATIVE API CALLING---//
    
    NSURLSession *session        = [ApiManager getMesh2NativeApiSession];
    NSMutableURLRequest *request = [ApiManager getMesh2NativeApiRequestWithUrl:kVerifyEmail_mesh2 andMethod:kPutMethod sendHeader:YES];
    
    NSError *paramsError;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&paramsError];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *responsee, NSError *serverError) {
       
        if(data == nil)
        {
            NSLog(@"Response data is nil for API = %@", kVerifyEmail_mesh2);
            response([kErrorGeneral myModification], 1, [UserModel new]);
        }
        else{
            // Parse the JSON that came in into an NSDictionary
            NSError * parseError = nil;
            
            NSLog(@"data before parsing = %@ and response = %@", data, response);
            
            NSDictionary * json  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parseError];
            NSString *msg        = [json valueForKey:@"message"] == nil ? [kErrorGeneral myModification] : [json valueForKey:@"message"];
            
            NSLog(@"parsing error = %@ and server error = %@", parseError, serverError);
            NSLog(@"put api json after parsing = %@", json);
            
            if (!serverError && !parseError){
                //---CHECK FOR EX00401 CODE,---UNAUTHENTICATEED STATUS---//
                if ([[json valueForKey:@"status"] isKindOfClass:[NSString class]]){
                    if ([[json valueForKey:@"status"] isEqualToString:kLogoutStatus])
                        [CommonModel showAlertAndLogoutOnVC:vc isPresentedVC:isPresent];
                }
                else{
                    NSString *strToken=  [[json valueForKey:@"success"]valueForKey:@"token"];
                    NSLog(@"auth token to save = %@", strToken);
                    
                    //---AUTH TOKEN SAVED TO USERDEFAULTS---//
                    [[NSUserDefaults standardUserDefaults] setObject:strToken forKey:kHeaderToken];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    NSError *error;
                    UserModel *userData = [[UserModel alloc] initWithDictionary:[json valueForKey:@"user"] error:&error];
                    
                    NSLog(@"msg = %@, status = %d and userModel = %@", msg, [[json valueForKey:@"status"] intValue], userData);
                    response(msg, [[json valueForKey:@"status"] intValue], userData);
                }
            }
            else
                response([kErrorGeneral myModification], [[json valueForKey:@"status"] intValue], [UserModel new]);
        }
    }];
    [postDataTask resume];
}
@end
