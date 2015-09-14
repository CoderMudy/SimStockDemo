//
//  SameStockHero.h
//  SimuStock
//
//  Created by Mac on 15/4/29.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequestObject.h"
#import "UserListItem.h"

@class HttpRequestCallBack;

/** 同股牛人 */
@interface SameStockHero : BaseRequestObject2 <ParseJson>

/** 用户信息 */
@property(nonatomic, strong) UserListItem *user;

/** 排名 */
@property(nonatomic, assign) NSInteger rank;

/** 周盈利率 */
@property(nonatomic, assign) CGFloat positionProfitRate;

/** 成本价 */
@property(nonatomic, assign) CGFloat costPrice;

/** 持股时长 */
@property(nonatomic, assign) NSInteger positionDays;

@end

@interface SameStockHeroList : JsonRequestObject <Collectionable>

/** 总人数 */
@property(nonatomic, assign) NSInteger count;

/** 获利占比 */
@property(nonatomic, assign) CGFloat rate;

/** 平均成本 */
@property(nonatomic, assign) CGFloat avgCostPrice;

/** 平均盈利 */
@property(nonatomic, assign) CGFloat avgProfitRate;

/** 对象数组，同股牛人榜 */
@property(nonatomic, strong) NSMutableArray *rankList;

/** 请求同股牛人数据列表 */
+ (void)requestHeroListWithStockCode:(NSString *)stockCode
                        withCallback:(HttpRequestCallBack *)callback;

@end