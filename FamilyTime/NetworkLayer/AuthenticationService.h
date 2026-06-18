//
//  AuthenticationService.h
//  FamilyTime - Dashboard
//
//  Created by Muhammad Ajmal on 14/05/2017.
//  Copyright © 2017 SoraCode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DataModel.h"

@interface NSDictionary (BVJSONString)
-(NSString*) bv_jsonStringWithPrettyPrint:(BOOL) prettyPrint;
@end

@interface AuthenticationService : NSObject

+(AuthenticationService *)shared;

//---REMOVE FACEBOOK DUE TO MDM---//
//- (void)loginWithFBWithController:(UIViewController *)controller success:(void (^)(NSString *name, NSString *email, NSString *fbId, NSString *fbToken))success failure:(void (^)(NSString *error))failure;

//- (void)doGoogleloginWithUserName:(NSString *)userName email:(NSString *)email fbId:(NSString *)fbId fbToken:(NSString *)fbToken success:(void (^)(UserModel *userModel))success failure:(void (^)(NSString *error, NSInteger errorCode))failure;

//- (void)doGoogleloginWithUserName:(NSString *)userName email:(NSString *)email fbId:(NSString *)fbId fbToken:(NSString *)fbToken isLogin:(BOOL)isLogin success:(void (^)(UserModel *userModel))success failure:(void (^)(NSString *error, NSInteger errorCode))failure;



//- (void)loginWithGoogleWithController:(UIViewController *)controller success:(void (^)(NSString *name, NSString *email, NSString *fbId, NSString *fbToken))success failure:(void (^)(NSString *error))failure;


//---NATIVE API CALLING---//

- (void)nativePost_loginWithParms:(NSDictionary *)params success:(void (^)(UserModel *userModel))success failure:(void (^)(NSString *error, NSInteger errorCode))failure;
- (void)nativePost_apiWithParams:(NSDictionary *)params andUrl:(NSString *)url success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error, NSInteger errorCode))failure;
- (void)nativeGet_api:(NSDictionary *)params andUrl:(NSString *)url success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error, NSInteger errorCode))failure;

- (void)nativePost_apiWithParamsLaunch:(NSDictionary *)params andUrl:(NSString *)url success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error, NSInteger errorCode))failure;

- (void)nativePost_googleloginWithUserName:(NSString *)userName email:(NSString *)email fbId:(NSString *)fbId fbToken:(NSString *)fbToken isLogin:(BOOL)isLogin success:(void (^)(UserModel *userModel))success failure:(void (^)(NSString *error, NSInteger errorCode))failure;


//---REMOVE FACEBOOK DUE TO MDM---//

//- (void)nativePost_fBloginWithUserName:(NSString *)userName email:(NSString *)email fbId:(NSString *)fbId fbToken:(NSString *)fbToken isFbLogin:(BOOL)isFbLogin success:(void (^)(UserModel *userModel))success failure:(void (^)(NSString *error, NSInteger errorCode))failure;



@end
