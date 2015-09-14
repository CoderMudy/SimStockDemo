//
//  GetMyStockBarListData.h
//  SimuStock
//
//  Created by Yuemeng on 14-12-10.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"

@class HttpRequestCallBack;

/** 股吧信息 */
@interface BarInfo : JsonRequestObject
/** 股吧ID */
@property(nonatomic, strong) NSNumber *barId;
/** 股吧名称 */
@property(nonatomic, strong) NSString *name;
/** 股吧描述 */
@property(nonatomic, strong) NSString *des;
/** 股吧logo */
@property(nonatomic, strong) NSString *logo;
/** 聊股数 */
@property(nonatomic) NSInteger postNum;

@end

/** 我关注的股吧接口 */
@interface GetMyStockBarListData : JsonRequestObject
/** 是否有更新 */
@property(nonatomic) BOOL hasNew;
/** 我关注的股吧 */
@property(nonatomic, strong) NSMutableArray *myBars;

/** 获取我关注的股吧 */
+ (void)requestGetMyStockBarListDataWithTweetId:(NSNumber *)tweetId
                                   withCallback:(HttpRequestCallBack *)callback;

@end
