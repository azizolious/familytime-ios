/**
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

 

#import <AWSRuntime/AWSRuntime.h>
#import <AWSS3/AWSS3.h>
//#import "DataSource.h"

@protocol photoStatus <NSObject>

@required
-(void) photoUploadStatus:(BOOL)status msg:(NSString *)msg;

@end
@interface S3TransferManagerUploadViewController : NSObject <AmazonServiceRequestDelegate>
{
   // id <photoStatus> s3Delegate;
}
@property (readwrite,assign) id <photoStatus> s3Delegate;
/**A reference for handling delegate functions*/
@property (nonatomic, strong) S3TransferManager *tm;
@property (nonatomic, strong) S3TransferOperation *uploadBigFileOperation;

/**
 This method intialize Amazon bucket

 */
- (void)initS3Bucket;

/**
 This method is used to upload file to user's Amazon bucket
 @param filePath A  local file path 
 @param nameOfFile A live file path
 
 */
- (void)uploadBigFile:(NSString *)filePath key:(NSString *)nameOfFile;

/**
 This is S3 delegate method its self expressive
 
 @param sender A reference of control
 */
- (IBAction)pauseUploads:(id)sender;

/**
 This is S3 delegate method its self expressive
 
 @param sender A reference of control
 */
- (IBAction)resumeUploads:(id)sender;

/**
 This is S3 delegate method its self expressive
 
 @param sender A reference of control
 */
- (IBAction)cancelBigUpload:(id)sender;

/**
 This is S3 delegate method its self expressive
 
 @param sender A reference of control
 */
- (IBAction)cancelAllTransfers:(id)sender;

@end

