//
//  AuthenticationService.m
//  FamilyTime - Dashboard
//
//  Created by Muhammad Ajmal on 14/05/2017.
//  Copyright © 2017 SoraCode. All rights reserved.
//

#import "AuthenticationService.h"
#import <Foundation/Foundation.h>
//#import "JSONHTTPClient.h"
#import "Constant.h"
#import "CommonModel.h"
#import "AppDelegate.h"

//---REMOVE FACEBOOK DUE TO MDM---//
//#import <FBSDKLoginKit/FBSDKLoginKit.h>
//#import <FBSDKCoreKit/FBSDKCoreKit.h>


@class APIConstants;

@implementation NSDictionary (BVJSONString)

-(NSString*) bv_jsonStringWithPrettyPrint:(BOOL) prettyPrint {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:(NSJSONWritingOptions)    (prettyPrint ? NSJSONWritingPrettyPrinted : 0)
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"bv_jsonStringWithPrettyPrint: error: %@", error.localizedDescription);
        return @"{}";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}
@end


@implementation AuthenticationService
+(AuthenticationService *)shared
{
    static AuthenticationService *sharedService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedService = [[self alloc] init];
    });
    return sharedService;
}


- (void)nativePost_loginWithParms:(NSDictionary *)params success:(void (^)(UserModel *userModel))success failure:(void (^)(NSString *error, NSInteger errorCode))failure
{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session                    = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSURL *url                               = [NSURL URLWithString:KPLoginUrl];
    NSMutableURLRequest *request             = [NSMutableURLRequest requestWithURL:url
                                                                       cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                                   timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:@"en" forHTTPHeaderField:@"language"];
    
    [request setHTTPMethod:@"POST"];
    
    NSError *paramsError;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&paramsError];
    [request setHTTPBody:postData];
    
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *serverError) {
//        NSLog(@"data = %@ response = %@ and error = %@", data, response, error);
        

        // Parse the JSON that came in into an NSDictionary
        NSError * parsingError = nil;
        
        
        if(data == nil){
            
            NSLog(@"Data is nil for API = %@", url);
            failure([kErrorGeneral myModification], 1);
        }
        else{
            NSDictionary * json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parsingError];
            
            
            NSLog(@"Login Dict after parsing = %@ and error = %@", json, parsingError);
            
            
            NSString *msg = [json valueForKey:@"message"] == nil ? [kErrorGeneral myModification] : [json valueForKey:@"message"];
            if(!serverError && !parsingError && [[json valueForKey:@"status"] intValue] == 200 )
            {
                
                NSLog(@"success login json reponse = %@", [json valueForKey:@"success"]);
                NSString *strToken =  [[json valueForKey:@"success"] valueForKey:@"token"];
                
                
                [[NSUserDefaults standardUserDefaults] setObject:strToken forKey:kHeaderToken];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                NSError *modelParsError;
                UserModel *userData = [[UserModel alloc] initWithDictionary:[[json valueForKey:@"success"] valueForKey:@"user"] error:&modelParsError];
                NSLog(@"user model after parsing to dict = %@", userData);
                
                success(userData);
            }
            else
            {
                NSLog(@"Error login api = %@", serverError);
                failure(msg, [[json valueForKey:@"status"] intValue]);
            }
        }
        
    }];
    
    [postDataTask resume];
}

- (void)nativePost_apiWithParams:(NSDictionary *)params andUrl:(NSString *)url success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error, NSInteger errorCode))failure{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session                    = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
//    NSURL *url                               = [NSURL URLWithString:KPSignUpUrlNew];
    NSMutableURLRequest *request             = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                                       cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                                   timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:@"en" forHTTPHeaderField:@"language"];
    
    [request setHTTPMethod:@"POST"];
    
    NSError *paramsError;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&paramsError];
    [request setHTTPBody:postData];
    
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *serverError) {
        //        NSLog(@"data = %@ response = %@ and error = %@", data, response, error);
        
        
        if (data == nil)
        {
            NSLog(@"Data is nil for API = %@", url);
            failure([kErrorGeneral myModification], 1);
        }
        else{
            // Parse the JSON that came in into an NSDictionary
            NSError * parsingError = nil;
            NSDictionary * json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parsingError];
            
            
            NSLog(@"signup Dict after parsing = %@ and error = %@", json, parsingError);
            
            
            if([[json valueForKey:@"status"] intValue] != 200 ) {
                failure([json valueForKey:@"message"], [[json valueForKey:@"status"] intValue]);
            }
            else
            {
                NSLog(@"signup JSON response : %@", json);
                success(json);
            }
        }
        
        
        
    }];
    
    [postDataTask resume];
}


- (void)nativePost_apiWithParamsLaunch:(NSDictionary *)params andUrl:(NSString *)url success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error, NSInteger errorCode))failure{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session                    = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
//    NSURL *url                               = [NSURL URLWithString:KPSignUpUrlNew];
    NSMutableURLRequest *request             = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                                       cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                                   timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:@"en" forHTTPHeaderField:@"language"];
    
    [request setHTTPMethod:@"POST"];
    
    NSError *paramsError;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&paramsError];
    [request setHTTPBody:postData];
    
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *serverError) {
        //        NSLog(@"data = %@ response = %@ and error = %@", data, response, error);
        
        
        if (data == nil)
        {
            NSLog(@"Data is nil for API = %@", url);
            failure([kErrorGeneral myModification], 1);
        }
        else{
            // Parse the JSON that came in into an NSDictionary
            NSError * parsingError = nil;
            NSDictionary * json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parsingError];
            
            
            NSLog(@"signup Dict after parsing = %@ and error = %@", json, parsingError);
            
            
            if([[json valueForKey:@"status"] boolValue] != true ) {
                failure([json valueForKey:@"error"], [[json valueForKey:@"status"] intValue]);
            }
            else
            {
                NSLog(@"signup JSON response : %@", json);
                success(json);
            }
        }
      
    }];
    
    [postDataTask resume];
}


//---REMOVE FACEBOOK DUE TO MDM---//

//- (void)loginWithFBWithController:(UIViewController *)controller success:(void (^)(NSString *name, NSString *email, NSString *fbId, NSString *fbToken))success failure:(void (^)(NSString *error))failure;
//{
//    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
//
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] <= 9) {
//            // After iOS9 we can not use it anymore
//        login.loginBehavior = FBSDKLoginBehaviorSystemAccount;
//    } else {
//        login.loginBehavior = FBSDKLoginBehaviorWeb;
//    }
////    login.loginBehavior = FBSDKLoginBehaviorBrowser;
//
//    if ([FBSDKAccessToken currentAccessToken]) {
//
//        FBSDKAccessToken *accessToken = [FBSDKAccessToken currentAccessToken];
//        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"name, email"}]
//         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id userinfo, NSError *error) {
//             if (!error) {
//                 // you are authorised and can access user data from user info object
//                 NSLog(@"%@",userinfo);
//                 NSString *name  = userinfo[@"name"];
//                 NSString *email = userinfo[@"email"];
//                 NSString *fbId  = userinfo[@"id"];
//
//                 success(name, email, fbId, accessToken.tokenString);
//             }
//             else{
//                 failure([error localizedDescription]);
//                 NSLog(@"%@", [error localizedDescription]);
//             }
//         }];
//    }
//    else {
//        [login logInWithReadPermissions:@[@"public_profile", @"email"] fromViewController:controller handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
//            if (error)
//            {
//                NSLog(@"Unexpected login error: %@", error);
//                failure([error localizedDescription]);
//            }
//            else
//            {
//                if(result.token)
//                {
//                    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"name, email"}]
//                     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id userinfo, NSError *error) {
//                         if (!error) {
//                             // you are authorised and can access user data from user info object
//                             NSLog(@"%@",userinfo);
//                             NSString *name  = userinfo[@"name"];
//                             NSString *email = userinfo[@"email"];
//                             NSString *fbId  = userinfo[@"id"];
//
//                             success(name, email, fbId, result.token.tokenString);
//                         }
//                         else{
//                             failure([error localizedDescription]);
//                             NSLog(@"%@", [error localizedDescription]);
//                         }
//                     }];
//                }
//            }
//        }];
//    }
//}


//---REMOVE FACEBOOK DUE TO MDM---//

//- (void)nativePost_fBloginWithUserName:(NSString *)userName email:(NSString *)email fbId:(NSString *)fbId fbToken:(NSString *)fbToken isFbLogin:(BOOL)isFbLogin success:(void (^)(UserModel *userModel))success failure:(void (^)(NSString *error, NSInteger errorCode))failure
//{
//    int r = (arc4random() % 4) + 1;
//    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"deviceToken"];
//
//    NSDictionary *params = @{@"name":userName,
//                             @"email": email,
//                             @"access_token":fbToken,
//                             @"fbid":fbId,
//                             @"relationship":@"Mother",
//                             @"gender": @"female",
//                             @"device": @"iphone",
//                             @"token": (deviceToken == NULL) ? @"" : deviceToken,
//                             @"color": [CommonModel randomColor:r],
//                             @"signup_plateform": @"iphone",
//                             @"id" : @""
//                             };
//
//
//    NSString *jsonRequest = [params bv_jsonStringWithPrettyPrint:YES];
//    NSLog(@"%@",jsonRequest);
//
//    NSString *fbUrl = isFbLogin ? kLoginWithFBNew : kSignUpWithFBNew;
//
//    NSLog(@"fblogin url = %@, params = %@", fbUrl, params);
//
//
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *session                    = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
//    //    NSURL *url                               = [NSURL URLWithString:KPSignUpUrlNew];
//    NSMutableURLRequest *request             = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:fbUrl]
//                                                                       cachePolicy:NSURLRequestUseProtocolCachePolicy
//                                                                   timeoutInterval:60.0];
//
//    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request addValue:@"en" forHTTPHeaderField:@"lang"];
//
//    [request setHTTPMethod:@"POST"];
//
//    NSError *paramsError;
//    NSData *postData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&paramsError];
//    [request setHTTPBody:postData];
//
//
//    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *serverError) {
//        //        NSLog(@"data = %@ response = %@ and error = %@", data, response, error);
//
//
//        // Parse the JSON that came in into an NSDictionary
//        NSError * parsingError = nil;
//        NSDictionary * json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parsingError];
//
//
//        NSLog(@"Fb signup Dict after parsing = %@ and error = %@", json, parsingError);
//
//
//        NSString *msg = [json valueForKey:@"message"] == nil ? [kErrorGeneral myModification] : [json valueForKey:@"message"];
//        if(!serverError && !parsingError && [[json valueForKey:@"status"] intValue] == 200 )
//        {
//
//            NSLog(@"fb login json = %@", json);
//
//            NSString *strToken  =  [[json valueForKey:@"success"] valueForKey:@"token"];
//            NSString *isNewUser =  [[json valueForKey:@"success"] valueForKey:@"is_new"];
//
//            [[NSUserDefaults standardUserDefaults] setObject:strToken forKey:kHeaderToken];
//            [[NSUserDefaults standardUserDefaults] setValue:isNewUser forKey:kIsNewUser]; //setObject:isNewUser forKey:kIsNewUser];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//
//            NSError *modelParseError;
//
//            UserModel *userData = [[UserModel alloc] initWithDictionary:[[json valueForKey:@"success"]valueForKey:@"user"] error:&modelParseError];
//            NSLog(@"user model after parsing = %@", userData);
//            success(userData);
//        }
//        else
//        {
//            NSLog(@"Error fb login api = %@", serverError);
//            failure(msg, [[json valueForKey:@"status"] intValue]);
//        }
//
//    }];
//
//    [postDataTask resume];
//
//}


- (void)nativePost_googleloginWithUserName:(NSString *)userName email:(NSString *)email fbId:(NSString *)fbId fbToken:(NSString *)fbToken isLogin:(BOOL)isLogin success:(void (^)(UserModel *userModel))success failure:(void (^)(NSString *error, NSInteger errorCode))failure
{
    //signup_plateform
    NSDictionary *params = @{@"name":userName,
                             @"email": email,
                             @"access_token":fbToken,
                             @"gid":fbId,
                             @"gender": @"female",
                             @"relationship":@"Mother",
                             @"device": @"iphone",
                             @"token":@"",
                             @"signup_plateform": @"ios",
                             @"id" : @""
                             };
    
    NSString *jsonRequest = [params bv_jsonStringWithPrettyPrint:YES];
    
    NSLog(@"%@",jsonRequest);
    NSString *googleUrl = isLogin ? kLoginWithGoogleNew : kSignUpWithGoogleNew;
    
    NSLog(@"login with google url = %@, params = %@", googleUrl, params);
    
    
    //---NATIVE API CALLING---//
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session                    = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSMutableURLRequest *request             = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:googleUrl]
                                                                       cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                                   timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"en" forHTTPHeaderField:@"language"];
    
    [request setHTTPMethod:@"POST"];
    
    NSError *paramsError;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&paramsError];
    [request setHTTPBody:postData];
    
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *serverError) {
        //        NSLog(@"data = %@ response = %@ and error = %@", data, response, error);
        
        
        if (data == nil)
        {
            NSLog(@"Data is nil for API = %@", googleUrl);
            failure([kErrorGeneral myModification], 1);
        }
        else{
            
            // Parse the JSON that came in into an NSDictionary
            NSError * parsingError = nil;
            NSDictionary * json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parsingError];
            
            
            NSLog(@"Google signup Dict after parsing = %@ and error = %@", json, parsingError);
            
            
            NSString *msg = [json valueForKey:@"message"] == nil ? [kErrorGeneral myModification] : [json valueForKey:@"message"];
            if(!serverError && !parsingError && [[json valueForKey:@"status"] intValue] == 200 )
            {
                NSString *strToken  =  [[json valueForKey:@"success"]valueForKey:@"token"];
                
                [[NSUserDefaults standardUserDefaults] setObject:strToken forKey:kHeaderToken];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                NSError *modelParsError;
                
                UserModel *userData = [[UserModel alloc] initWithDictionary:[[json valueForKey:@"success"]valueForKey:@"user"] error:&modelParsError];
                NSLog(@"google user model after parsing = %@ and parsingError = %@", userData, modelParsError);
                success(userData);
            }
            else
            {
                NSLog(@"Error google login api = %@", serverError);
                failure(msg, [[json valueForKey:@"status"] intValue]);
            }
        }
        
        
    }];
    
    [postDataTask resume];
}


//- (void)doGoogleloginWithUserName:(NSString *)userName email:(NSString *)email fbId:(NSString *)fbId fbToken:(NSString *)fbToken isLogin:(BOOL)isLogin success:(void (^)(UserModel *userModel))success failure:(void (^)(NSString *error, NSInteger errorCode))failure
//{
//    int r = (arc4random() % 4) + 1;
////    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"deviceToken"];
//    //signup_plateform
//    NSDictionary *params = @{@"name":userName, @"email": email,
//                             @"access_token":fbToken,
//                             @"gid":fbId,
//                             @"relationship":@"Mother",
//                             @"gender": @"female",
//                             @"relationship":@"Mother",
////                             @"device": @"ios",
//                             @"device": @"iphone",
//                             @"token":@"",
//                             @"signup_plateform": @"ios",
//                             @"id" : @""
//                             };
//
//    NSString *jsonRequest = [params bv_jsonStringWithPrettyPrint:YES];
//
//    NSLog(@"%@",jsonRequest);
//    NSString *googleUrl = isLogin ? kLoginWithGoogleNew : kSignUpWithGoogleNew;
//
//    NSLog(@"login with google url = %@, params = %@", googleUrl, params);
//
//    [JSONHTTPClient postJSONFromURLWithString:googleUrl bodyString:jsonRequest
//                                   completion:^(id json, JSONModelError *err) {
//                                       NSError *error;
//                                       NSLog(@"json response = %@",json);
//
//                                       NSString *msg = [json valueForKey:@"message"] == nil ? [kErrorGeneral myModification] : [json valueForKey:@"message"];
//                                       if([[json valueForKey:@"status"] intValue] != 200 )
//                                       {
//                                           failure(msg, [[json valueForKey:@"status"] intValue]);
//                                       }
//                                       else
//                                       {
//                                           NSString *strToken  =  [[json valueForKey:@"success"]valueForKey:@"token"];
//                                           //                                           NSString *isNewUser =  [[json valueForKey:@"success"]valueForKey:@"is_new"];
//
//                                           [[NSUserDefaults standardUserDefaults] setObject:strToken forKey:kHeaderToken];
//                                           //                                           [[NSUserDefaults standardUserDefaults] setValue:isNewUser forKey:kIsGoogleNewUser];
//                                           [[NSUserDefaults standardUserDefaults] synchronize];
//
//                                           UserModel *userData = [[UserModel alloc] initWithDictionary:[[json valueForKey:@"success"]valueForKey:@"user"] error:&error];
//                                           success(userData);
//                                       }
//                                   }];
//}




@end

