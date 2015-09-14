//
//  UpDateMarketView.h
//  SimuStock
//
//  Created by moulin wang on 14-9-22.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RealTradeStockPriceInfo.h"

//配资数据
#import "WFStockByData.h"



/** 买5卖5 */
@interface UpDateMarketView : UIView
@property(nonatomic, strong) UIView *mainView;
/**合计*/
@property(nonatomic, strong) NSMutableArray *amountArr;
/**价格*/
@property(nonatomic, strong) NSMutableArray *priceArr;
/**
 *可买可卖数量数据
 */
@property(nonatomic, strong) RealTradeStockPriceInfo *realTradeData;
/**
 *数据请求完成
 */
- (void)dataRequestComplete:(RealTradeStockPriceInfo *)realTradeData;
/**清空数据*/
- (void)clearData;

/** 配资数据 */
@property(strong, nonatomic) WFStockByInfoData *stockInforData;

/** 绑定配资数据 */
-(void)capitalBindData:(WFStockByInfoData *)stockInfoData;

@property(nonatomic, assign) BOOL capitalOrFirm;

@end
