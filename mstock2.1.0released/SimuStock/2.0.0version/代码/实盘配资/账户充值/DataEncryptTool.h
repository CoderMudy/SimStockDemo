//
//  DataEncryptTool.h
//  SimuStock
//
//  Created by jhss_wyz on 15/6/8.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataEncryptTool : NSObject

+ (NSString *)signTheDataSHA1WithRSA:(NSString *)plainText
               andPrivateKeyFilePath:(NSString *)filePath
                         andPassword:(NSString *)password;

+ (NSString *)sortDictionary:(NSDictionary *)dataDictionary;

@end
