//
//  CustomPageDada.m
//  SimuStock
//
//  Created by Mac on 13-9-5.
//  Refactored by Yuemeng on 15-4-3.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "CustomPageData.h"
#import "NSDataCategory.h"
#import "JsonFormatRequester.h"

/**
 *类说明：股票信息数组
 */
@implementation StockInfo

- (id)init {
  self = [super init];
  if (self) {
    self.stockname = @"--";
    self.stockCode = @"--";
    self.valuePercent = @"--";
    self.closePrice = @"--";
    self.valume = @"--";
    self.cornewPrices = @"--";
    self.hightPrice = @"--";
    self.lowestPrice = @"--";
    self.openPrice = @"--";
    self.Cordate = @"--";
    self.allVolume = @"--";
    self.allAutome = @"--";
    self.gains = @"--";
    self.updownValue = @"--";
    self.amplitude = @"--";
  }
  return self;
}

@end

/**
 *类说明：股票信息数组
 */
@implementation StockInfoArray

- (void)streamToObject:(NSData *)data {
  _stockTable = [[NSMutableArray alloc] init];
  //得到记录数量
  NSInteger ItemCount = [data readIntAt:4];
  NSInteger corindex = 8;
  for (int i = 0; i < ItemCount; i++) {
    StockInfo *stockItemInfo = [[StockInfo alloc] init];
    Byte *lenth = (Byte *)[data bytes];
    int m_lenth = lenth[corindex] & 0xff;
    corindex++;
    //股票名称
    NSString *m_stockName = [[NSString alloc]
        initWithData:[data subdataWithRange:NSMakeRange(corindex, m_lenth)]
            encoding:NSUTF8StringEncoding];
    corindex = corindex + m_lenth;
    stockItemInfo.stockname = m_stockName;
    //股票代码
    NSString *m_stockCode = [[NSString alloc]
        initWithData:[data subdataWithRange:NSMakeRange(corindex, 6)]
            encoding:NSUTF8StringEncoding];
    corindex = corindex + 6;
    stockItemInfo.stockCode = m_stockCode;
    //量比
    double m_valuePercent = [data readDoubleAt:corindex];
    NSString *s_valuePercent =
        [NSString stringWithFormat:@"%.2f", m_valuePercent];
    corindex = corindex + 8;
    stockItemInfo.valuePercent = s_valuePercent;
    //收盘价
    float m_closePrice = [data readFloatAt:corindex];
    NSString *s_closePrice = [NSString stringWithFormat:@"%.2f", m_closePrice];
    corindex = corindex + 4;
    if (m_closePrice >= 0)
      stockItemInfo.closePrice = s_closePrice;
    //八位股票代码
    int n_stockCode = [data readIntAt:corindex];
    NSString *sc_stockCode = [NSString stringWithFormat:@"%d", n_stockCode];
    corindex = corindex + 4;
    stockItemInfo.eightstockCode = sc_stockCode;
    //现量
    int64_t n_volum = [data readInt64At:corindex];
    NSString *s_volum = [NSString stringWithFormat:@"%lld", n_volum];
    corindex = corindex + 8;
    stockItemInfo.valume = s_volum;
    //最新价
    float f_newprice = [data readFloatAt:corindex];
    NSString *s_newPrice = [NSString stringWithFormat:@"%.2f", f_newprice];
    corindex = corindex + 4;
    if (f_newprice >= 0)
      stockItemInfo.cornewPrices = s_newPrice;
    //最高价
    float f_hightPrice = [data readFloatAt:corindex];
    NSString *s_highPrice = [NSString stringWithFormat:@"%.2f", f_hightPrice];
    corindex = corindex + 4;
    if (f_hightPrice >= 0)
      stockItemInfo.hightPrice = s_highPrice;
    //最低价
    float f_lowerPrice = [data readFloatAt:corindex];
    NSString *s_lowerPrice = [NSString stringWithFormat:@"%.2f", f_lowerPrice];
    corindex = corindex + 4;
    if (f_lowerPrice >= 0)
      stockItemInfo.lowestPrice = s_lowerPrice;
    //开盘价
    float f_openPrice = [data readFloatAt:corindex];
    NSString *s_openPrice = [NSString stringWithFormat:@"%.2f", f_openPrice];
    corindex = corindex + 4;
    if (f_openPrice >= 0)
      stockItemInfo.openPrice = s_openPrice;
    //日期
    int64_t n_date = [data readInt64At:corindex];
    NSString *s_date = [NSString stringWithFormat:@"%lld", n_date];
    corindex = corindex + 8;
    stockItemInfo.Cordate = s_date;
    //成交总量
    int64_t n_allVolum = [data readInt64At:corindex];
    NSString *s_allVolum = [NSString stringWithFormat:@"%llu", n_allVolum];
    corindex = corindex + 8;
    stockItemInfo.allVolume = s_allVolum;
    stockItemInfo.headsAmount = n_allVolum;
    //成交总额
    NSString *s_unit = @"";
    double n_allAutomFound = [data readDoubleAt:corindex];
    stockItemInfo.dealsAmount = n_allAutomFound;
    float f_allAutomFound = 0;
    if (n_allAutomFound >= 100000000) {
      f_allAutomFound = n_allAutomFound / 100000000;
      s_unit = @"亿";
    } else if (n_allAutomFound >= 10000) {
      f_allAutomFound = n_allAutomFound / 10000;
      s_unit = @"万";
    } else {
      f_allAutomFound = n_allAutomFound;
    }
    NSString *s_allAutomFound =
        [NSString stringWithFormat:@"%.2f", f_allAutomFound];
    s_allAutomFound = [s_allAutomFound stringByAppendingString:s_unit];
    corindex = corindex + 8;
    stockItemInfo.allAutome = s_allAutomFound;

    //涨幅计算
    if (f_newprice <= 0 || m_closePrice <= 0) {

    } else {
      //涨跌数组
      CGFloat f_updwonVaues = (f_newprice - m_closePrice);
      NSString *s_updownValue;
      if (f_updwonVaues > 0.0)
        s_updownValue = [NSString stringWithFormat:@"+%.2f", f_updwonVaues];
      else
        s_updownValue = [NSString stringWithFormat:@"%.2f", f_updwonVaues];
      stockItemInfo.updownValue = s_updownValue;
      stockItemInfo.updownprice = f_updwonVaues;
      //涨跌率
      CGFloat f_gains = f_updwonVaues / m_closePrice;
      stockItemInfo.fgins = f_gains * 100;
      NSString *s_gains;
      if (f_gains > 0.0)
        s_gains = [NSString stringWithFormat:@"+%.2f", f_gains * 100];
      else
        s_gains = [NSString stringWithFormat:@"%.2f", f_gains * 100];
      s_gains = [s_gains stringByAppendingString:@"%"];
      stockItemInfo.gains = s_gains;
      //振幅计算
      float f_divideprice = f_hightPrice - f_lowerPrice;
      float f_amplitude = f_divideprice / m_closePrice;
      stockItemInfo.famplitude = f_amplitude;
      NSString *s_amplitude =
          [NSString stringWithFormat:@"%.2f", f_amplitude * 100];
      s_amplitude = [s_amplitude stringByAppendingString:@"%"];
      stockItemInfo.amplitude = s_amplitude;
    }

    [_stockTable addObject:stockItemInfo];
  }
}

///请求多支股票信息
+ (void)requestStocksWithStocks:(NSString *)stocks
                   withCallback:(HttpRequestCallBack *)callback {
  NSString *url = [data_address
      stringByAppendingString:
          @"youguu/quote/querycurstatusesbyte/{ak}/{sid}/{codes}"];
  NSDictionary *parameters = @{ @"codes" : stocks };
  StreamFormatRequester *requester = [[StreamFormatRequester alloc] init];

  [requester asynExecuteWithRequestUrl:url
                     WithRequestMethod:@"GET"
                 withRequestParameters:parameters
                withRequestObjectClass:[StockInfoArray class]
               withHttpRequestCallBack:callback];
};

@end

/*
 我的关注股友交易数据单项元素
 */
@implementation MFMyAttentionTradeDataItem

@end

/*
 我的关注和我的粉丝单项数据类
 */
@implementation MFMyAttentionItem

@end

/*
 数组通用数据页
 */
@implementation CustomPageData

- (id)init {
  self = [super init];
  if (self) {
    _stockTrendArray = [[NSMutableArray alloc] init];
    _dictionary = [[NSDictionary alloc] init];
  }
  return self;
}

@end

/*
 *类说明：走势数据页面
 */
@implementation TrendDataPage

- (id)init {
  self = [super init];
  if (self) {
    self.pagetype = DataPageType_Market_TrendLineInfo;
  }
  return self;
}

@end

/*
 *股票信息页面
 */
@implementation StockTrendItemInfo

- (id)init {
  self = [super init];
  if (self) {
    self.currentPrice = -1;
    self.closePrice = -1;
    self.highestPrice = -1;
    self.lowestPrice = -1;
    self.date = -1;
    self.totalvolume = -1;
    self.totalamount = -1;
    self.corhands = -1;
  }
  return self;
}

@end

/*
 *k线图数据
 */
@implementation KLineDataItem

- (id)init {
  self = [super init];
  if (self) {
    self.closeprice = -1;
    self.highprice = -1;
    self.lowprice = -1;
    self.openprice = -1;
    self.yestodaycloseprice = -1;
    self.date = -1;
    self.volume = -1;
    self.amount = -1;
  }
  return self;
}

@end

/*
 *类说明：表格field说明
 */
@implementation tableFeildItemInfo

@end

/*
 *类说明：表格数据结构
 */
@implementation PacketTableData

- (id)init {
  self = [super init];
  if (self) {
    _fieldItemArray = [[NSMutableArray alloc] init];
    _tableItemDataArray = [[NSMutableArray alloc] init];
  }
  return self;
}

@end

/*
 *类说明：聊股学堂 文章接口单项数据
 */
@implementation SchoolArticleData

- (void)jsonToObject:(NSDictionary *)obj {
  self.articleID = [SimuUtil changeIDtoStr:obj[@"id"]];
  self.articleTitle = [SimuUtil changeIDtoStr:obj[@"title"]];
  self.articleUrl = [SimuUtil changeIDtoStr:obj[@"staticurl"]];
}

@end

/**
 类说明：文章接口列表
 */
@implementation SchoolArticleDataList

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  self.schoolDataArray = [[NSMutableArray alloc] init];
  NSArray *array = dic[@"result"][@"articleList"];
  for (NSDictionary *dic in array) {
    SchoolArticleData *item = [[SchoolArticleData alloc] init];
    [item jsonToObject:dic];
    [self.schoolDataArray addObject:item];
  }
}

- (NSArray *)getArray {
  return self.schoolDataArray;
}

/** 文章接口列表*/
+ (void)requestPositionDataWithParameters:(NSDictionary *)dic
                             withCallback:(HttpRequestCallBack *)callback {

  NSString *url =
      [NSString stringWithFormat:
                    @"%@/wap/app/classroom/articleAction/"
                    @"moduleStaticArticleList?moduleId={moduleId}&start={start}"
                    @"&pagesize={length}",
                    wap_address];

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[SchoolArticleDataList class]
             withHttpRequestCallBack:callback];
}

@end

/*
 *类说明：主页 查询用户账户信息显示数据
 */
@implementation HomeIndividualRankingData

@end

/*
 *类说明：主页 完整交易统计
 */
@implementation TradeStatisticsData

@end

/*
 *类说明：个人信息 成功邀请好友列表
 */
@implementation SuccessfullyInvitedList

@end

/*
 *类说明：个股报价信息
 */
@implementation stockheadinfoItem

@end

/*
 *类说明：明细数据
 */
@implementation StockTradeDetailData

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
  NSLog(@"⭐️StockTradeDetailData,UndefinedKey:%@", key);
}

@end

/*
 *类说明：分价
 */
@implementation StockPriceStateData

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
  NSLog(@"⭐️StockPriceStateData,UndefinedKey:%@", key);
}

@end
