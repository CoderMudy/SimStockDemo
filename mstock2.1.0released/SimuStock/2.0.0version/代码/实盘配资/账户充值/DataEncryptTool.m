//
//  DataEncryptTool.m
//  SimuStock
//
//  Created by jhss_wyz on 15/6/8.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "DataEncryptTool.h"
#import <CommonCrypto/CommonDigest.h>

#define kChosenDigestLength CC_SHA1_DIGEST_LENGTH

@implementation DataEncryptTool

- (NSData *)getHashBytes:(NSData *)plainText {
  CC_SHA1_CTX ctx;
  uint8_t *hashBytes = NULL;
  NSData *hash = nil;

  // Malloc a buffer to hold hash.
  hashBytes = malloc(kChosenDigestLength * sizeof(uint8_t));
  memset((void *)hashBytes, 0x0, kChosenDigestLength);
  // Initialize the context.
  CC_SHA1_Init(&ctx);
  // Perform the hash.
  CC_SHA1_Update(&ctx, (void *)[plainText bytes],
                 (unsigned int)[plainText length]);
  // Finalize the output.
  CC_SHA1_Final(hashBytes, &ctx);

  // Build up the SHA1 blob.
  hash = [NSData dataWithBytes:(const void *)hashBytes
                        length:(NSUInteger)kChosenDigestLength];
  if (hashBytes)
    free(hashBytes);

  return hash;
}

+ (NSString *)signTheDataSHA1WithRSA:(NSString *)plainText
               andPrivateKeyFilePath:(NSString *)filePath
                         andPassword:(NSString *)password {
  if (filePath == nil || [filePath isEqualToString:@""] || password == nil) {
    return @"";
  }

  DataEncryptTool *dataEncryptTool = [[DataEncryptTool alloc] init];

  uint8_t *signedBytes = NULL;
  size_t signedBytesSize = 0;
  OSStatus sanityCheck = noErr;
  NSData *signedHash = nil;

  //此处设置签名使用的私钥
  NSString *path =
      [[NSBundle mainBundle] pathForResource:filePath ofType:@"p12"];
  NSData *data = [NSData dataWithContentsOfFile:path];
  NSMutableDictionary *options =
      [[NSMutableDictionary alloc] init]; // Set the private key query
                                          // dictionary.
  //此处testMemberKey是私钥密码
  [options setObject:password forKey:(__bridge id)kSecImportExportPassphrase];
  CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
  OSStatus securityError = SecPKCS12Import(
      (__bridge CFDataRef)data, (__bridge CFDictionaryRef)options, &items);
  if (securityError != noErr) {
    return nil;
  }
  CFDictionaryRef identityDict = CFArrayGetValueAtIndex(items, 0);
  SecIdentityRef identityApp = (SecIdentityRef)CFDictionaryGetValue(
      identityDict, kSecImportItemIdentity);
  SecKeyRef privateKeyRef = nil;
  SecIdentityCopyPrivateKey(identityApp, &privateKeyRef);
  signedBytesSize = SecKeyGetBlockSize(privateKeyRef);

  NSData *plainTextBytes = [plainText dataUsingEncoding:NSUTF8StringEncoding];

  signedBytes = malloc(signedBytesSize *
                       sizeof(uint8_t)); // Malloc a buffer to hold signature.
  memset((void *)signedBytes, 0x0, signedBytesSize);

  sanityCheck = SecKeyRawSign(
      privateKeyRef, kSecPaddingPKCS1SHA1,
      (const uint8_t *)[[dataEncryptTool getHashBytes:plainTextBytes] bytes],
      kChosenDigestLength, (uint8_t *)signedBytes, &signedBytesSize);

  if (sanityCheck == noErr) {
    signedHash = [NSData dataWithBytes:(const void *)signedBytes
                                length:(NSUInteger)signedBytesSize];
  } else {
    return nil;
  }

  if (signedBytes) {
    free(signedBytes);
  }
  
  NSString *signatureResult = [signedHash base64EncodedStringWithOptions:0];
  
  return signatureResult;
}

- (SecKeyRef)getPrivateKeyRef:(NSString *)keyTag {

  SecKeyRef privateKey;

  OSStatus resultCode = noErr;
  SecKeyRef privateKeyReference = NULL;
  NSData *keyTagData = [keyTag dataUsingEncoding:NSUTF8StringEncoding];

  NSMutableDictionary *queryPrivateKey = [[NSMutableDictionary alloc] init];

  // Set the private key query dictionary.
  [queryPrivateKey setObject:(__bridge id)kSecClassKey
                      forKey:(__bridge id)kSecClass];
  [queryPrivateKey setObject:keyTagData
                      forKey:(__bridge id)kSecAttrApplicationTag];
  [queryPrivateKey setObject:(__bridge id)kSecAttrKeyTypeRSA
                      forKey:(__bridge id)kSecAttrKeyType];
  [queryPrivateKey setObject:[NSNumber numberWithBool:YES]
                      forKey:(__bridge id)kSecReturnRef];

  // Get the key.
  resultCode = SecItemCopyMatching((__bridge CFDictionaryRef)queryPrivateKey,
                                   (CFTypeRef *)&privateKeyReference);
  NSLog(@"getPrivateKey: result code: %d %@", (int)resultCode,
        privateKeyReference);

  if (resultCode != noErr) {
    privateKeyReference = NULL;
  }

  privateKey = privateKeyReference;

  return privateKey;
}

+ (NSString *)sortDictionary:(NSDictionary *)dataDictionary {
  if (dataDictionary.count == 0 && dataDictionary == nil) {
    return @"";
  }

  __block NSString *dataStr = @"";
  __block NSMutableArray *dataArray = [NSMutableArray array];
  [dataDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key,
                                                      NSString *obj,
                                                      BOOL *stop) {
    if (dataArray.count == 0) {
      [dataArray addObject:key];
    } else {
      __block BOOL objInserted = NO;
      [dataArray
          enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
            if ([obj compare:key options:NSCaseInsensitiveSearch] ==
                NSOrderedDescending) {
              [dataArray insertObject:key atIndex:idx];
              objInserted = YES;
              *stop = YES;
            }
          }];
      if (objInserted == NO) {
        [dataArray addObject:key];
      }
    }
  }];
  [dataArray
      enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        NSString *tempStr =
            [NSString stringWithFormat:@"%@=%@&", key, dataDictionary[key]];
        dataStr = [dataStr stringByAppendingString:tempStr];
      }];
  dataStr = [dataStr substringToIndex:(dataStr.length - 1)];

  return dataStr;
}

@end
