//
//  BaseBuySellWorkRequset.h
//  SimuStock
//
//  Created by 刘小龙 on 15/7/27.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExpertPlanConst.h"
#import "BuySellConstant.h"
#import "BaseRequestObject.h"

/** 成功返回 */
typedef void (^RequsetSuccountData)(NSObject *,BOOL);
/** 失败返回 */
typedef void (^RequsetFialdData)();
/** 返回无网络 或者 页面不存在 */
typedef void (^RequsetNotWork)();
/** 返回错误 */
typedef void (^RequsetErroeData)(BaseRequestObject *, NSException *);

/** 网络请求类 */
@interface BaseBuySellWorkRequset : NSObject

@property(copy, nonatomic) RequsetSuccountData succountData;
@property(copy, nonatomic) RequsetFialdData fialdData;
@property(copy, nonatomic) RequsetNotWork viewNotWork;
@property(copy, nonatomic) RequsetErroeData erroeData;

/** 查询可买数量 */
- (void)getAmountFromNet:(NSString *)stockCode
               withPrice:(NSString *)price
               withFunds:(NSString *)funds
           withAccountId:(NSString *)accountId
             withMatchId:(NSString *)matchId
     withMarketFixedType:(MarketFixedPriceType)marketFixedType
            withUserType:(StockBuySellType)userType;

/** 卖出股票查询 */
- (void)querySellInfoWidthStockCode:(NSString *)stockCode
                      withAccountId:(NSString *)accountId
                        withMatchId:(NSString *)matchId
                withMarketFixedType:(MarketFixedPriceType)marketFixedType
                       withUserType:(StockBuySellType)userType;
/** 点击买入卖出按钮 */
- (void)tradeEntrustWithCode:(NSString *)stockCode
             withFrozendFund:(NSString *)frozendFund
                  withAmount:(NSString *)amount
                   withPrice:(NSString *)price
                 withMatchId:(NSString *)matchId
                   withToken:(NSString *)token
             withBuySellType:(BuySellType)buySellType
         withMarketFixedType:(MarketFixedPriceType)marketFixedType
                withUserType:(StockBuySellType)userType;

@end
