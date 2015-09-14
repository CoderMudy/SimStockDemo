//
//  CollectTStockData.h
//  SimuStock
//
//  Created by Yuemeng on 14-12-9.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"

@class HttpRequestCallBack;

/** 收藏聊股 */
@interface CollectTStockData : JsonRequestObject

/** 请求收藏聊股act
 -1：减|删除
 1：添加
 */
+ (void)requestCollectTStockDataWithTStockId:(NSNumber *)tstockid
                                     withAct:(NSInteger)act
                                withCallback:(HttpRequestCallBack *)callback;

@end
