//
//  ShortLineExpertRequest.h
//  SimuStock
//
//  Created by Jhss on 15/5/27.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonFormatRequester.h"

/** 短线牛人接口返回数据模型 */
@interface ShortLineExpertDataModel : JsonRequestObject
/** 排行列表 */
@property (nonatomic,copy)NSMutableArray *rankList;
/** 用户列表 */
@property (nonatomic,copy)NSMutableArray *userList;

@end


/** 短线牛人接口返回数据模型  排行列表 */
@interface RankListDataModel : NSObject
/** 粉丝数 */
@property(copy, nonatomic) NSString *fansCount;
/** 发表聊股数 */
@property(copy, nonatomic) NSString *istockCount;
/** 持仓数 */
@property(copy, nonatomic) NSString *positionCount;
/** 盈利 */
@property(copy, nonatomic) NSString *profit;
/** 盈利率 */
@property(copy, nonatomic) NSString *profitRate;
/** 排名 */
@property(copy, nonatomic) NSString *rank;
/** 成功率 */
@property(copy, nonatomic) NSString *successRate;
/** 交易次数 */
@property(copy, nonatomic) NSString *tradeCount;
/** 用户ID */
@property(copy, nonatomic) NSString *uid;

+(instancetype)rankListDataWithDictionary:(NSDictionary *)dic;

@end




@interface ShortLineExpertRequest : NSObject


+ (void)conductShortLineExpertRequestWithReqNum:(NSString *)reqNum WithFromId:(NSString *)fromId  WithCallback:(HttpRequestCallBack *)callback;


@end
