//
//  MasterTradeListWrapper.h
//  SimuStock
//
//  Created by jhss on 15-4-28.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequester.h"
#import "UserListItem.h"
#import "WeiboUtil.h"
@class HttpRequestCallBack;
/**牛人交易数据*/
@interface ConcludesListItem : NSObject <ParseJson>
/**concludes数据部分*/
/**交易内容*/
@property(strong, nonatomic) NSString *content;
/**盈利性*/
@property(nonatomic, retain) NSNumber *profitability;
/**稳定性*/
@property(nonatomic, retain) NSNumber *stability;
/**准确性*/
@property(nonatomic, retain) NSNumber *accuracy;
/**五日收益*/
@property(strong, nonatomic) NSString *fiveDaysPr;
/**时间*/
@property(nonatomic, retain) NSNumber *time;
/**股票代码*/
@property(strong, nonatomic) NSString *stockCode;
/**股票名称*/
@property(strong, nonatomic) NSString *stockName;

/** 新增字段 总盈利率 */
@property(strong, nonatomic) NSString *profitRate;

/** 用户评级数据 */
@property(strong, nonatomic) UserListItem *writer;

@end

@interface MasterTradeListWrapper : JsonRequestObject <Collectionable>

@property(strong, nonatomic) NSMutableArray *concludesListArray;

/** 请求牛人交易 */
+ (void)requestMasterTradeListWithInput:(NSDictionary *)dic
                           withCallback:(HttpRequestCallBack *)callback;
/** 请求VIP专属牛人交易 */
+ (void)requestVipTradeListWithInput:(NSDictionary *)dic
                        withCallback:(HttpRequestCallBack *)callback;

@end
