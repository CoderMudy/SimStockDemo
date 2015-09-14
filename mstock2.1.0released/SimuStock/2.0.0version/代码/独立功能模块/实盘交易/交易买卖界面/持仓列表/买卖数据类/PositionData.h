//
//  PositionData.h
//  SimuStock
//
//  Created by moulin wang on 14-9-19.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequestObject.h"
@class PositionResult;
@interface PositionData : JsonRequestObject<Collectionable>
/**总记录数*/
@property(nonatomic, assign) NSInteger num;
/**资金余额*/
@property(nonatomic, strong) NSString *zjye;
/**可用资金*/
@property(nonatomic, strong) NSString *kyzj;
/**冻结金额*/
@property(nonatomic, strong) NSString *djje;
/**最新市值*/
@property(nonatomic, strong) NSString *zrsz;
/**总资产*/
@property(nonatomic, strong) NSString *zzc;
/**持仓盈亏金额*/
@property(nonatomic, strong) NSString *ccykje;
/**股票市值*/
@property(nonatomic, strong) NSString *zxsz;
@property(nonatomic, strong) NSMutableArray *resultArr;
@end

@interface PositionResult : NSObject
/**证券名称*/
@property(nonatomic, strong) NSString *stockName;
/**证券代码*/
@property(nonatomic, strong) NSString *stockCode;
/**证券数量*/
@property(nonatomic, strong) NSString *stockNum;
/**证券类别*/
@property(nonatomic, strong) NSString *stockCategory;
/**最新市值*/
@property(nonatomic, strong) NSString *latestValue;
/**最新价*/
@property(nonatomic, strong) NSString *latestPrice;
/**冻结数量*/
@property(nonatomic, strong) NSString *eastKnotNum;
/**买入均价*/
@property(nonatomic, strong) NSString *buyAPrice;
/**保本价*/
@property(nonatomic, strong) NSString *break_evenPrice;
/**买入金额*/
@property(nonatomic, strong) NSString *buyAmount;
/**持仓均价*/
@property(nonatomic, strong) NSString *positionAverage;
/**累计盈亏*/
@property(nonatomic, strong) NSString *Profitloss;
/**浮动盈亏*/
@property(nonatomic, strong) NSString *floatProfitLoss;
/**盈亏率*/
@property(nonatomic, strong) NSString *profitLossRate;
/**可用股份*/
@property(nonatomic, strong) NSNumber *availableStock;

@end
