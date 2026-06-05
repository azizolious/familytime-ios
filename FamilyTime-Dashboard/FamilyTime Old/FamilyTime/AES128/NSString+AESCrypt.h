//
//  NSString+AESCrypt.h
//
//  AES128Encryption + Base64Encoding
//

#import <Foundation/Foundation.h>
#import "NSData+AESCrypt.h"

@interface NSString (AESCrypt)

/**
 This method is used to encrypt data with specific key and return encryped string
 
 @param key Encryption key
 @return Encrypted string
 */
- (NSString *)AES128EncryptWithKey:(NSString *)key;

/**
 This method is used to decrypt data with specific key and return encryped string

 @param key Decryption key
 @return Decrypted string
 */
- (NSString *)AES128DecryptWithKey:(NSString *)key;

- (NSString *) encrypt:(NSString*) key;
@end
