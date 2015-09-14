//
//  TopTweetStockData.h
//  SimuStock
//
//  Created by Yuemeng on 14-12-9.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"

@class HttpRequestCallBack;

/** 聊股置顶请求 */
@interface TopTweetStockData : JsonRequestObject

/** 请求聊股置顶,（1 股吧内置顶；2 全局置顶） */
+ (void)requestTopTweetStockDataWithBarId:(NSNumber *)barId
                              withTweetId:(NSNumber *)tweetId
                                 withType:(NSInteger)type
                             withCallback:(HttpRequestCallBack *)callback;

@end
