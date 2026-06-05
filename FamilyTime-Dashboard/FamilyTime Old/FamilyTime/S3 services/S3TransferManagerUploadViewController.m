/*
 * Copyright 2010-2013 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License").
 * You may not use this file except in compliance with the License.
 * A copy of the License is located at
 *
 *  http://aws.amazon.com/apache2.0
 *
 * or in the "license" file accompanying this file. This file is distributed
 * on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 * express or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */

#import "S3TransferManagerUploadViewController.h"
#import "Constant.h"
//#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"
#import "NSString+AESCrypt.h"

AmazonS3Client *s3 ;
AppDelegate *delegate;


@interface S3TransferManagerUploadViewController ()

@property (nonatomic, strong) NSString *pathForBigFile;

@end

@implementation S3TransferManagerUploadViewController

@synthesize s3Delegate;

- (void)initS3Bucket
{
    delegate = [AppDelegate appDelegate];
    if(self.tm == nil){
        
        if([delegate.accessKey  length] > 1){
            
            // Initialize the S3 Client.
            s3 = [[AmazonS3Client alloc] initWithAccessKey:delegate.accessKey  withSecretKey:delegate.secretKey]; //[delegate.accessKey AES128DecryptWithKey:kEncryptionString]
            s3.endpoint = [AmazonEndpoints s3Endpoint:US_EAST_1];
            
            // Initialize the S3TransferManager
            self.tm = [S3TransferManager new];
            self.tm.s3 = s3;
            self.tm.delegate = self;
            //            s3.timeout = 1000;
            
            // Create the bucket
            S3CreateBucketRequest *createBucketRequest = [[S3CreateBucketRequest alloc] initWithName:[Constant transferManagerBucket] andRegion: [S3Region USStandard]];
            
            @try {
                S3CreateBucketResponse *createBucketResponse = [s3 createBucket:createBucketRequest];
                if(createBucketResponse.error != nil)
                {
                    NSLog(@"Error: %@", createBucketResponse.error);
                }
            }@catch(AmazonServiceException *exception){
                if(![@"BucketAlreadyOwnedByYou" isEqualToString: exception.errorCode]){
                    NSLog(@"Unable to create bucket: %@", exception.error);
                }
            }
            
        }else {
            NSLog(@"%@ ...%@",CREDENTIALS_ERROR_TITLE,CREDENTIALS_ERROR_MESSAGE);
            
        }
    }
}

#pragma mark - Transfer Manager actions

- (void)uploadBigFile:(NSString *)filePath key:(NSString *)nameOfFile{
    
    if(self.uploadBigFileOperation == nil || (self.uploadBigFileOperation.isFinished && !self.uploadBigFileOperation.isPaused)){
        
        NSLog(@"uploading file path %@......",nameOfFile);
        self.pathForBigFile = filePath;
        //            nameOfFile = [NSString stringWithFormat:@"%@/%@",[Preference getPreference:@"userBucketName"],nameOfFile];
        
        self.uploadBigFileOperation = [self.tm uploadFile:filePath bucket: [Constant transferManagerBucket] key:nameOfFile];
    }
    
}


- (IBAction)pauseUploads:(id)sender {
    [self.tm pauseAllTransfers];
}

- (IBAction)resumeUploads:(id)sender {
    NSArray *ops = [self.tm resumeAllTransfers:self];
    
    // When you resume, the original handle to the S3TransferOperation
    // is no longer valid.  Obtain the new handles
    for (S3TransferOperation *op in ops)
    {
        self.uploadBigFileOperation = op;
        
    }
}


- (IBAction)cancelBigUpload:(id)sender {
    [self.uploadBigFileOperation cancel];
    self.uploadBigFileOperation = nil;
    
}

- (IBAction)cancelAllTransfers:(id)sender {
    [self.tm cancelAllTransfers];
    self.uploadBigFileOperation = nil;
}

#pragma mark - AmazonServiceRequestDelegate

-(void)request:(AmazonServiceRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"didReceiveResponse called: %@", response);
}

-(void)request:(AmazonServiceRequest *)request didSendData:(long long) bytesWritten totalBytesWritten:(long long)totalBytesWritten totalBytesExpectedToWrite:(long long)totalBytesExpectedToWrite
{

}

-(void)request:(AmazonServiceRequest *)request didCompleteWithResponse:(AmazonServiceResponse *)response
{
    
    NSLog(@"File Transfer Done***");
    if ([[self s3Delegate] respondsToSelector:@selector(photoUploadStatus:msg:)]) {
        [[self s3Delegate] photoUploadStatus:true msg:@"Image uploaded"];
    }
//    [[DataSource sharedInstance] removeMultimediaFileAtpath:self.pathForBigFile];
    
}

-(void)request:(AmazonServiceRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError called: %@", error);
    if ([[self s3Delegate] respondsToSelector:@selector(photoUploadStatus:msg:)]) {
        [[self s3Delegate] photoUploadStatus:false msg:@"didFailWithError"];
    }
}

-(void)request:(AmazonServiceRequest *)request didFailWithServiceException:(NSException *)exception
{
    NSLog(@"didFailWithServiceException called: %@", exception);
    if ([[self s3Delegate] respondsToSelector:@selector(photoUploadStatus:msg:)]) {
        [[self s3Delegate] photoUploadStatus:false msg:@"didFailWithServiceException"];
    }
}


@end
