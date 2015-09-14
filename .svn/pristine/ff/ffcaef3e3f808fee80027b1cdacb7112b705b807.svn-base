//
//  FollowStockBarData.h
//  SimuStock
//
//  Created by Yuemeng on 14-12-10.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"

@class HttpRequestCallBack;

/** 关注（加入）股吧接口 */
@interface FollowStockBarData : JsonRequestObject

/** 用户还可以关注的股吧数 */
@property(nonatomic, strong) NSNumber *remain;

/** 关注（加入）股吧 */
+ (void)requestFollowStockBarDataWithBarId:(NSNumber *)barId
                              withCallback:(HttpRequestCallBack *)callback;

@end
