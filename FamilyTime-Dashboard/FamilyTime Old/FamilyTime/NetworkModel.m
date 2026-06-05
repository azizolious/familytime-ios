
//
//  NetworkModel.m
//  Whepp
//
//  Created by Ahad Nawaz on 15/11/2014.
//  Copyright (c) 2014 AhadNawaz. All rights reserved.
//

#import "NetworkModel.h"


UIViewController *currentCont;

@implementation NetworkModel

//@synthesize _delegate;

-(void) postRequestContent:(NSString *)urlStr param:(NSDictionary *)postData img:(NSData *)imageData view:(UIViewController *)viewCont
{
    currentCont = viewCont;
    
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd"];
    NSString *imageName = [NSString stringWithFormat:@"IMG_%@.png",[f stringFromDate:[NSDate date]]];
    
    // Create the request.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    //
    //    NSDictionary *postDict = [NSDictionary dictionaryWithObjectsAndKeys:email,@"email", nil];
    
    //set http method
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = [NSString stringWithFormat:@"---------------------------14737809831466499882746641449"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    //adding other param
    // add params (all params are strings)
    for (NSString *param in postData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [postData objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    //adding image
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image\"; filename=\"%@\"\r\n",imageName ] dataUsingEncoding:NSUTF8StringEncoding]]; //[postData valueForKey:@"first_name"]
    
    [body appendData:[[NSString stringWithFormat:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[NSData dataWithData:imageData]];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //     [body appendData:[[NSString stringWithFormat:@"%@",_userID] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    
    
    //set post data of request
    //    [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    NSLog(@"%@",conn);
    
}

-(void) postRequestContent:(NSString *)urlStr param:(NSString *)postString
{
//    NSURL *aUrl = [NSURL URLWithString:urlStr];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[postString length]] forHTTPHeaderField:@"Content-Length"];
      
    [request setHTTPMethod:@"POST"];
   // NSString *postString = @"company=Locassa&quality=AWESOME!";
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request
                                                                 delegate:self];
    NSLog(@"%@",connection);
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    self.responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [self.responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    
    
//    NSString *JSONString = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
    
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:self.responseData
                                                         options:kNilOptions
                                                           error:&error];

    NSLog(@"%@",json);
    //below only calling the method but it is impelmented in AwindowController class
    if([[self delegate]respondsToSelector:@selector(profileResonpnse:)])
        [[self delegate] profileResonpnse:json];
    
    //    [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateMenu object:JSON];
    
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    //NSString *errorStr = @"Something goes wrong please check your network.";
    
    
}


@end
