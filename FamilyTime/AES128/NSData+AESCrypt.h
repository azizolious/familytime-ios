//
//  NSData+AESCrypt.h
//
//  AES128Encryption + Base64Encoding
//

#import <Foundation/Foundation.h>

@interface NSData (AESCrypt)
/**
 This method is used to encrypt data with specific key
 
 @param key Encryption key
 @return Encrypted data
 */
- (NSData *)AES128EncryptWithKey:(NSString *)key;

/**
 This method is used to decrypt data with specific key
 
 @param key Decryption key
 @return Decrypted data
 */
- (NSData*)AES128Decrypt:(NSString *)key;

/**
 This method will convert data into base64 string
 
 @return Base64 string
 */
- (NSString *)base64Encoding;

@end
