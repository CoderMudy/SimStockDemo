//
//  SimuStockInfoView.h
//  SimuStock
//
//  Created by Mac on 13-8-29.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SimuUtil.h"
#import "SimuTradeBaseData.h"

/*
 *类说明：买卖股票的相关信息
 */
@interface SimuStockInfoView : UIView

//最新标签
@property(nonatomic, strong) IBOutlet UILabel *curPriceLable;
//最新价格
@property(nonatomic, strong) IBOutlet UILabel *curPriceValueLable;
//涨停
@property(nonatomic, strong) IBOutlet UILabel *riseLimitLable;
//涨停值
@property(nonatomic, strong) IBOutlet UILabel *riseLimitValueLable;
//最高
@property(nonatomic, strong) IBOutlet UILabel *highestPriceLable;
//最高值
@property(nonatomic, strong) IBOutlet UILabel *highestPriceValueLable;
//跌停
@property(nonatomic, strong) IBOutlet UILabel *downLimitLable;
//跌停值
@property(nonatomic, strong) IBOutlet UILabel *downLimitValueLable;
//最低
@property(nonatomic, strong) IBOutlet UILabel *lowestPriceLable;
//最低值
@property(nonatomic, strong) IBOutlet UILabel *lowestPriceValueLable;
//可买
@property(nonatomic, strong) IBOutlet UILabel *aumoutLable;
//可买值
@property(nonatomic, strong) IBOutlet UILabel *aumoutValueLable;
//可用资金
@property(nonatomic, strong) IBOutlet UILabel *moneyLable;
//可用资金值
@property(nonatomic, strong) IBOutlet UILabel *moneyValueLable;

//设定买卖状态
- (void)setTradeType:(BOOL)isBuyType;
//设定显示数据
- (void)setUserPageData:(SimuTradeBaseData *)stockInfo isBuy:(BOOL)isBuy;
//设定可买数量
- (void)setBuyAmount:(NSString *)amount;
//清除所有数据
- (void)clearControlData;

@end
