//
//  NSString+AESCrypt.h
//
//  AES128Encryption + Base64Encoding
//

#import "NSString+AESCrypt.h"
#import <CommonCrypto/CommonCryptor.h>

@implementation NSString (AESCrypt)

- (NSString *)AES128EncryptWithKey:(NSString *)key
{
    NSData *plainData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptedData = [plainData AES128EncryptWithKey:key];
    
    NSString *encryptedString = [encryptedData base64Encoding];
    
    return encryptedString;
}

- (NSString *)AES128DecryptWithKey:(NSString *)key
{
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:self options:0];
    NSData *encryptedData = [decodedData AES128Decrypt:key];
    
    NSString* encryptedString = [[NSString alloc] initWithData:encryptedData encoding:NSUTF8StringEncoding];
    
    return encryptedString;
}

- (NSString *) encrypt:(NSString*) key{
    
    
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *mData = [key dataUsingEncoding:NSUTF8StringEncoding];
    
    CCCryptorStatus ccStatus = kCCSuccess;
    
    
    // Begin to calculate bytesNeeded....
    
    size_t bytesNeeded = 0;
    
    ccStatus = CCCrypt(kCCEncrypt,
                       kCCAlgorithmAES128,
                       kCCOptionECBMode | kCCOptionPKCS7Padding,
                       [mData bytes],
                       [mData length],
                       nil,
                       [data bytes],
                       [data length],
                       NULL,
                       0,
                       &bytesNeeded);
    
    if(kCCBufferTooSmall != ccStatus){
        
        NSLog(@"Here it must return BUFFER TOO SMALL !!");
        return nil;
    }
    
    // .....End
    // Now i do the real Crypting
    
    char* cypherBytes = malloc(bytesNeeded);
    size_t bufferLength = bytesNeeded;
    
    if(NULL == cypherBytes)
        NSLog(@"cypherBytes NULL");
    
    ccStatus = CCCrypt(kCCEncrypt,
                       kCCAlgorithmAES128,
                       kCCOptionECBMode | kCCOptionPKCS7Padding,
                       [mData bytes],
                       [mData length],
                       nil,
                       [data bytes],
                       [data length],
                       cypherBytes,
                       bufferLength,
                       &bytesNeeded);
    
    if(kCCSuccess != ccStatus){
        NSLog(@"kCCSuccess NO!");
        return nil;
    }
    
    return [[NSData dataWithBytes:cypherBytes length:bufferLength] base64Encoding];//[Base64 encode:];
}


@end
