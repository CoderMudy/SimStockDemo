//
//  TracingPageRequest.h
//  SimuStock
//
//  Created by jhss on 14-11-19.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"
#import "JsonFormatRequester.h"

@class HttpRequestCallBack;

@interface TracingPageRequest : JsonRequestObject<Collectionable>

/** 保存追踪列表 */
@property(strong, nonatomic) NSMutableArray *dataArray;

/** 追踪列表获取接口 */
+ (void)tracingListWithFromId:(NSString *)fromId
                   withNumber:(NSString *)number
                   withUserID:(NSString *)userId
                 withCallback:(HttpRequestCallBack *)callback;
/// new
+ (void)tracingListWithParameters:(NSDictionary *)parameters
                     withCallback:(HttpRequestCallBack *)callback;
@end

@interface CancelTracing : JsonRequestObject

/** 取消追踪 */
+ (void)cancelTracingWithFollowUid:(NSString *)followUid
                     withFollowMid:(NSString *)followMid
                      withCallback:(HttpRequestCallBack *)callback;

@end

@interface DeadLineRequest : JsonRequestObject

@property(strong, nonatomic) NSMutableArray *dataArray;

/** 获取追踪期限 */
+ (void)getDeadLineWithCallback:(HttpRequestCallBack *)callback;

@end