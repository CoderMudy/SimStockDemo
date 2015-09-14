//
//  UnTopTweetStockData.h
//  SimuStock
//
//  Created by Yuemeng on 14-12-9.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"

@class HttpRequestCallBack;

/** 取消股聊列表 */
@interface UnTopTweetStockData : JsonRequestObject

/** 请求取消股聊 */
+ (void)requestUnTopTweetStockWithBarId:(NSNumber *)barId
                            withTweetId:(NSNumber *)tweetId
                               withType:(NSInteger)type
                           withCallback:(HttpRequestCallBack *)callback;

@end
