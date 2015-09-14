//
//  MarketConst.h
//  SimuStock
//
//  Created by Mac on 15/4/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequestObject.h"

/** 股票榜单类型 */
typedef NS_ENUM(NSUInteger, StockListType) {
  ///大盘指数
  StockListTypeIndex = 2000,
  ///热门行业
  StockListTypeIndustry = 2001,
  ///热门概念
  StockListTypeNotion = 2002,
  ///智能选股
  StockListTypeRecommend = 2003,
  ///涨幅榜
  StockListTypeRise = 2004,
  ///跌幅榜
  StockListTypeFall = 2005,
  ///换手榜
  StockListTypeExchange = 2006,
  ///振幅榜
  StockListTypeAmplitude = 2007,
  ///新股发行
  StockListTypeIPO = 2008,
  ///行业、概念下股票列表
  StockListTypeIndustryNotion = 2009,
  ///智能选股下股票列表
  StockListTypeStocksOfRecommnendType = 2010,
};

/** 行情section类型 */
typedef NS_ENUM(NSUInteger, MarketHomeSectionIndex) {
  /** 大盘指数 */
  MHSectionTypeIndex = 0,

  /** 热门行业 */
  MHSectionTypeHotIndustry = 1,

  /** 热门概念 */
  MHSectionTypeHotNotion = 2,

  /** 智能选股 */
  MHSectionTypeRecommend = 3,

  /** 涨幅榜 */
  MHSectionTypeRiseRank = 4,

  /** 跌幅榜 */
  MHSectionTypeFailRank = 5,

  /** 换手榜 */
  MHSectionTypeChangeHandRank = 6,

  /** 振幅榜 */
  MHSectionTypeAmplitudeRank = 7,

  /** 新股发行 */
  MHSectionTypeIPOStocks = 8
};

/** 智能选股指标类型 */
typedef NS_ENUM(NSUInteger, RecommendStockType) {
  /** 放量上冲 */
  RecommendStockTypeRocket = 0,

  /** 创21日新高 */
  RecommendStockTypeTopest = 1,

  /** 5日净流入 */
  RecommendStockType5Coming = 2,

  /** MACD买点 */
  RecommendStockTypeMACD = 3,

  /** 优顾买入热门 */
  RecommendStockTypeHotBuy = 9
};

@protocol ISecurities <NSObject>

/** 股票代码 */
- (NSString *)code;

/** 代码（6位交易所代码） */
- (NSString *)stockCode;

/** 股票名称 */
- (NSString *)name;
/** 一级类型（详见附录类型说明） */
- (NSInteger)firstType;

@end

/** 有价证券,包括股票、债券、基金、金融衍生品等 */
@interface Securities : BaseRequestObject2 <ParseJson, ISecurities>

/** 股票代码 */
@property(nonatomic, strong) NSString *code;
/** 代码（6位交易所代码） */
@property(nonatomic, strong) NSString *stockCode;

/** 股票名称 */
@property(nonatomic, strong) NSString *name;

/** 市场id */
@property(nonatomic, assign) NSInteger marketId;
/** 一级类型（详见附录类型说明） */
@property(nonatomic, assign) NSInteger firstType;
/** 二级类型（详见附录类型说明） */
@property(nonatomic, assign) NSInteger secondType;
/** 小数位数 */
@property(nonatomic, assign) NSInteger decimalDigits;

/** 显示证券详情页面 */
- (void)showDetail;

- (BOOL)isMarketIndex;

@end

@interface B5S5TradingInfo : BaseRequestObject2 <ParseJson>

/** 购买价列表 */
@property(nonatomic, strong) NSArray *buyPriceArray;

/** 购买量列表 */
@property(nonatomic, strong) NSArray *buyAmountArray;

/** 卖出价列表 */
@property(nonatomic, strong) NSArray *sellPriceArray;

/** 卖出量列表 */
@property(nonatomic, strong) NSArray *sellAmountArray;

@end

@interface MarketConst : NSObject

@end
