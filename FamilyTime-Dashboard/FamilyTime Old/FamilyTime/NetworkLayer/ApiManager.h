//
//  ApiManager.h
//  FamilyTime
//
//  Created by Sana Ullah on 27/11/2018.
//  Copyright © 2018 YumyApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Dashboard.h"
#import "DataModel.h"



NS_ASSUME_NONNULL_BEGIN

@interface ApiManager : NSObject

+(ApiManager *)shared;


- (void)hitDashboardApiwithController:(UIViewController *)vc isRefresh:(BOOL)isRefresh andSuccess:(void (^)(Dashboard *dashboardModel))success failure:(void (^)(NSString *error, NSInteger errorCode))failure;
- (void)hitDashboardApi2withController:(UIViewController *)vc andSuccess:(void (^)(Dashboard *dashboardModel))success failure:(void (^)(NSString *error, NSInteger errorCode))failure;

- (void)hitDailyLimitApiwithController:(UIViewController *)vc andSuccess:(void (^)(DailyLimitDashboard *dashboardModel))success failure:(void (^)(NSString *error, NSInteger errorCode))failure;


#pragma mark - POST APIS

- (void)postApiWithVC:(UIViewController *)vc isPresentedCont:(BOOL)isPresent andParams:(NSDictionary*)params withApi:(NSString *)url withResponse:(void (^)(NSString *error, NSInteger errorCode))response;

- (void)postApiWithPwdVC:(UIViewController *)vc isPresentedCont:(BOOL)isPresent andParams:(NSDictionary*)params withApi:(NSString *)url withResponse:(void (^)(NSString *error, NSInteger errorCode))response;

- (void)postApiToValidateReceiptWithVC:(UIViewController *)vc andParams:(NSDictionary*)params withApi:(NSString *)url withResponse:(void (^)(NSString *error, NSInteger errorCode, NSInteger verifyReceiptStatus))response;


//---OLD MESH APIS---//

- (void)mesh_postApiWithParamString:(NSString*)paramsStr withApi:(NSString *)url withResponse:(void (^)(NSDictionary *json, NSInteger errorCode, NSString *message))response;
- (void)mesh_postApiWithOutParam:(NSString *)url withResponse:(void (^)(NSDictionary *json, NSInteger errorCode, NSString *message))response;
- (void)mesh_putApiWithParamString:(NSString*)paramsStr withApi:(NSString *)url withResponse:(void (^)(NSDictionary *json, NSInteger errorCode, NSString *message))response;
- (void)mesh_getApiWithApi:(NSString *)url withResponse:(void (^)(NSDictionary *json, NSInteger errorCode, NSString *message))response;
- (void)mesh2_getApiWithApi:(NSString *)url sendHeader:(BOOL)shouldSend withResponse:(void (^)(NSDictionary *json, NSInteger errorCode, NSString *message))response;
- (void)mesh_patchApiWithParamString:(NSString*)paramsStr withApi:(NSString *)url withResponse:(void (^)(NSDictionary *json, NSInteger errorCode, NSString *message))response;
- (void)mesh_patch_withJson_ApiWithParamString:(NSString*)paramsStr withApi:(NSString *)url withResponse:(void (^)(NSDictionary *json, NSInteger errorCode, NSString *message))response;
- (void)mesh_deleteApiWithApi:(NSString *)url withResponse:(void (^)(NSDictionary *json, NSInteger errorCode, NSString *message))response;

#pragma mark - GET APIS

//- (void)getApiWithUrl:(NSString *)url withResponse:(void (^)(NSString *error, NSInteger errorCode))response;
- (void)commonGetApiWithVC:(UIViewController *)vc andUrl:(NSString *)url withResponse:(void (^)(id response, JSONModelError *error))response failure:(void (^)(NSString *error, NSInteger errorCode))failure;
//- (void)getApiWithVC:(UIViewController *)vc andUrl:(NSString *)url withResponse:(void (^)(NSString *error, NSInteger errorCode))response;

- (void)getFuntimeApiWithVC:(UIViewController *)vc andUrl:(NSString *)url withResponse:(void (^)(FuntimeModel *funtimeModel, NSString *msg, NSInteger statusCode))response;

- (void)getIOSAppBlockerApiWithVC:(UIViewController *)vc andUrl:(NSString *)url withResponse:(void (^)(IOSAppBlockerModel *model, NSString *msg, NSInteger statusCode))response;

- (void)getPlacesApiWithVC:(UIViewController *)vc andUrl:(NSString *)url withResponse:(void (^)(AllPlacesModel *model, NSString *msg, NSInteger statusCode))response;

- (void)mesh2_commonGetApiWithVC:(UIViewController *)vc andUrl:(NSString *)url withResponse:(void (^)(id json))response;

- (void)getIAProductsApiWithVC:(UIViewController *)vc withResponse:(void (^)(IAP_Dashboard *model, NSString *msg, NSInteger statusCode))response;

#pragma mark - DELETE APIS

- (void)deleteApiWithParams:(NSDictionary *)params andUrl:(NSString *)url andController:(UIViewController *)vc withResponse:(void (^)(NSString *error, NSInteger errorCode))response;

- (void)postApiWithParamsLogout:(NSDictionary *)params andUrl:(NSString *)url andController:(UIViewController *)vc withResponse:(void (^)(NSString *error, Boolean errorCode))response;

- (void)mesh_deleteApiWithStringParam:(NSString*)paramsStr withApi:(NSString *)url withResponse:(void (^)(NSDictionary *json, NSInteger errorCode, NSString *message))response;

#pragma mark - PUT APIS

//- (void)putApi:(NSString *)url data:(NSString*)jsonString withResponse:(void (^)(NSString *error, NSInteger errorCode))response;

//- (void)putApi:(NSString *)url params:(NSDictionary*)params controller:(UIViewController *)vc withResponse:(void (^)(NSString *error, NSInteger errorCode))response;
- (void)putApi:(NSString *)url params:(NSDictionary*)params controller:(UIViewController *)vc isContPresented:(BOOL)isPresent withResponse:(void (^)(NSString *error, NSInteger errorCode))response;

- (void)mesh_putApiNotiWithParamString:(NSString*)paramsStr withApi:(NSString *)url withResponse:(void (^)(NSDictionary *json, NSInteger errorCode, NSString *message))response;

- (void)putApi:(NSString *)url params:(NSDictionary*)params withResponse:(void (^)(NSString *error, NSInteger errorCode))response;

-(void)putApiToVerifySignupWithParams:(NSDictionary *)params onController:(UIViewController *)vc isContPresented:(BOOL)isPresent withResponse:(void (^)(NSString *error, NSInteger errorCode, UserModel *userModel))response;
- (void)putApiSOS:(NSString *)url params:(NSDictionary*)params controller:(UIViewController *)vc isContPresented:(BOOL)isPresent withResponse:(void (^)(NSString *error, NSInteger errorCode)) response;


+(NSURLSession *) getMesh2NativeApiSession;
+(NSMutableURLRequest *) getMesh2NativeApiRequestWithUrl:(NSString *)url andMethod:(NSString *)method sendHeader:(BOOL)shouldSend;

@end

NS_ASSUME_NONNULL_END
