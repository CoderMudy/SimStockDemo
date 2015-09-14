//
//  AppItem.h
//  SimuStock
//
//  Created by jhss on 13-9-13.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppItem : NSObject

@property(copy, nonatomic) NSString *appMessage;
@property(copy, nonatomic) NSString *appStatus;
@property(copy, nonatomic) NSString *appUrl;
@property(copy, nonatomic) NSString *appDetail;
@property(copy, nonatomic) NSString *appName;
@property(copy, nonatomic) NSString *appNameSpace;
@property(copy, nonatomic) NSString *appVersion;
@property(copy, nonatomic) NSString *appLogo;

@end
