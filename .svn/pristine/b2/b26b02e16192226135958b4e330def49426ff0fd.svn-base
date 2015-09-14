//
//  SimuStockInfoData.h
//  SimuStock
//
//  Created by Mac on 13-9-29.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "CustomPageData.h"

/*
 *类描述：画出量线图需要的显示数据
 */
@interface DrawVolumeElement : NSObject

//开始点
@property(assign) CGPoint startPoint;
//结束点
@property(assign) CGPoint endPoint;
//颜色
@property(strong, nonatomic) UIColor *color;

- (id)initWithStartPoint:(CGPoint)startPoint
                endPoint:(CGPoint)endPoint
                   color:(UIColor *)color;

@end

/*
 *类描述：走势页面基本数据元素
 *
 */
@interface SMinDateElement : NSObject

//股票当前价格
@property(assign) int64_t price;
//股票当前量
@property(assign) int64_t volume;

- (id)initWithPrice:(int64_t)price volume:(int64_t)volume;

@end

/*
 *类说明：股票信息
 */
@interface SimuStockInfoItem : NSObject

//股票名称
@property(copy, nonatomic) NSString *stockname;
//股票代码(8位)
@property(copy, nonatomic) NSString *stockcode;
//股票代码（6位）
@property(copy, nonatomic) NSString *stockcodesix;
//时间
@property(copy, nonatomic) NSString *time;
//收盘价
@property(copy, nonatomic) NSString *closeprice;
//开盘价
@property(copy, nonatomic) NSString *openprice;
//最高价
@property(copy, nonatomic) NSString *highestprice;
//最低价
@property(copy, nonatomic) NSString *lowestprice;
//当前最新价
@property(copy, nonatomic) NSString *newprice;
//总成交金额
@property(copy, nonatomic) NSString *totalAtuom;
//总成交量
@property(copy, nonatomic) NSString *totalVolum;
//量比
@property(copy, nonatomic) NSString *corVolume;
//现手
@property(copy, nonatomic) NSString *corHands;
//外盘
@property(copy, nonatomic) NSString *outHands;
//内盘
@property(copy, nonatomic) NSString *inHands;
//市盈率（个股）平盘数 （指数）
@property(copy, nonatomic) NSString *perate;
//买卖盘
//买1价格 （指数：涨数）
@property(copy, nonatomic) NSString *buyPrice1;
//卖1价格 (指数：跌数）
@property(copy, nonatomic) NSString *sellPrice1;
//买1数量  (指数：总申买量)
@property(copy, nonatomic) NSString *buyAmount1;
//卖1数量  (指数：总申卖量)
@property(copy, nonatomic) NSString *sellAmount1;

//买2价格 （指数：涨数）
@property(copy, nonatomic) NSString *buyPrice2;
//卖2价格 (指数：跌数）
@property(copy, nonatomic) NSString *sellPrice2;
//买2数量  (指数：总申买量)
@property(copy, nonatomic) NSString *buyAmount2;
//卖2数量  (指数：总申卖量)
@property(copy, nonatomic) NSString *sellAmount2;

//买3价格 （指数：涨数）
@property(copy, nonatomic) NSString *buyPrice3;
//卖3价格 (指数：跌数）
@property(copy, nonatomic) NSString *sellPrice3;
//买3数量  (指数：总申买量)
@property(copy, nonatomic) NSString *buyAmount3;
//卖3数量  (指数：总申卖量)
@property(copy, nonatomic) NSString *sellAmount3;

//买4价格 （指数：涨数）
@property(copy, nonatomic) NSString *buyPrice4;
//卖4价格 (指数：跌数）
@property(copy, nonatomic) NSString *sellPrice4;
//买4数量  (指数：总申买量)
@property(copy, nonatomic) NSString *buyAmount4;
//卖4数量  (指数：总申卖量)
@property(copy, nonatomic) NSString *sellAmount4;

//买5价格 （指数：涨数）
@property(copy, nonatomic) NSString *buyPrice5;
//卖5价格 （指数：跌数）
@property(copy, nonatomic) NSString *sellPrice5;
//买5数量  (指数：总申买量)
@property(copy, nonatomic) NSString *buyAmount5;
//卖5数量  (指数：总申卖量)
@property(copy, nonatomic) NSString *sellAmount5;

//一级市场
@property(copy, nonatomic) NSString *firsttype;
//二级市场
@property(copy, nonatomic) NSString *secondtype;
//是否大盘
@property(assign) BOOL isIndexStock;

@end

/*
 *
 */
@interface SimuStockInfoPageData : CustomPageData {
  //数量
  NSString *ssip_num;
}

@end
