//
//  NetworkModel.h
//  Whepp
//
//  Created by Ahad Nawaz on 15/11/2014.
//  Copyright (c) 2014 AhadNawaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol refreshContent <NSObject>
@required
-(void) profileResonpnse:(NSDictionary *) JSON;

@end


@interface NetworkModel : NSObject < NSURLConnectionDelegate, NSURLConnectionDelegate>
{
    id<refreshContent>delegate;
}
@property(readwrite,assign)id<refreshContent>delegate;

@property (nonatomic,strong) NSMutableData *responseData;

-(void) postRequestContent:(NSString *)urlStr param:(NSDictionary *)postData img:(NSData *)imageData view:(UIViewController *)viewCont;
-(void) postRequestContent:(NSString *)urlStr param:(NSString *)postString ;
@end
