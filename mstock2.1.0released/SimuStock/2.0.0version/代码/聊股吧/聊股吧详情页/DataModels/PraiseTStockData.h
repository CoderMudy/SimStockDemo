//
//  PraiseTStockData.h
//  SimuStock
//
//  Created by Yuemeng on 14-12-9.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"
#import "TweetListItem.h"

@class HttpRequestCallBack;

/** 赞聊股接口 */
@interface PraiseTStockData : JsonRequestObject
/** 正在发送赞 */
@property(nonatomic)BOOL _isRequesting;
/** 请求赞
 act
 -1：减|删除
 1：添加
 */
+ (void)requestPraiseTStockData:(TweetListItem *)homeData;

@end
