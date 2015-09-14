//
//  ApplicationRecomendListWrapper.h
//  SimuStock
//
//  Created by moulin wang on 14-11-19.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequestObject.h"

@class HttpRequestCallBack;
@interface ApplicationRecomendListWrapper : JsonRequestObject
/** APP的所有数据数组*/
@property(strong, nonatomic) NSMutableArray *AppDataArray;
/** 请求数据 */
+ (void)requestPositionDataWithGetAK:(NSString *)GetAK
                     withGetSesionID:(NSString *)GetSesionID
                        withCallback:(HttpRequestCallBack *)callback;
//数据项
@property(copy, nonatomic) NSString *appMessage;
@property(copy, nonatomic) NSString *appStatus;
@property(copy, nonatomic) NSString *appUrl;
@property(copy, nonatomic) NSString *appDetail;
@property(copy, nonatomic) NSString *appName;
@property(copy, nonatomic) NSString *appNameSpace;
@property(copy, nonatomic) NSString *appVersion;
@property(copy, nonatomic) NSString *appLogo;
@end
