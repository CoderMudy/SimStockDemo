//
//  StockBuySellView.h
//  SimuStock
//
//  Created by 刘小龙 on 15/6/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BuySellConstant.h"
#import "SimuTradeBaseData.h"

/** 创建搜索股票界面 */
typedef void (^CreateStockView)(BuySellType);
/** 网络请求 */
typedef void (^RequsetForBuyAmount)(NSString *);
/** 改变显示资金label */
typedef void (^ShowPriceLabel)(NSString *, BOOL, BuySellType);
/** 价格不合理时改变价格 */
typedef void (^PriceUnreasonable)(NSString *);

@interface StockBuySellView : UIView <UITextFieldDelegate>
/** 标题 股票代码和名称 */
@property(weak, nonatomic) IBOutlet UILabel *stockNameLabel;
/** 标题 买入价格 */
@property(weak, nonatomic) IBOutlet UILabel *buyPrice;
/** 标题 买入数量 */
@property(weak, nonatomic) IBOutlet UILabel *buyAmount;
/** 股票代码 */
@property(weak, nonatomic) IBOutlet UITextField *stockCodeTF;
/** 股票名称 */
@property(weak, nonatomic) IBOutlet UITextField *stockNameTF;
/** 股票价格 */
@property(weak, nonatomic) IBOutlet UITextField *buyPriceTF;
/** 股票数量 */
@property(weak, nonatomic) IBOutlet UITextField *buyAmountTF;
/** 第一个股票代码背景框 */
@property(weak, nonatomic) IBOutlet UIView *stockNameBackView;
/** 股票价格背景框 */
@property(weak, nonatomic) IBOutlet UIView *buyPriceBackView;
/** 股票数量背景框 */
@property(weak, nonatomic) IBOutlet UIView *buyAmountBackView;

/** 判断是否在本界面 */
@property(assign, nonatomic) BOOL isOriginalView;

/** 创建搜索股票界面 */
@property(copy, nonatomic) CreateStockView createStockViewBlock;
/** 网络请求 */
@property(copy, nonatomic) RequsetForBuyAmount requsetBuyAmountBlock;
/** 改变显示资金label */
@property(copy, nonatomic) ShowPriceLabel showPriceLabelBlock;
/** 价格不合理时改变价格 */
@property(copy, nonatomic) PriceUnreasonable priceUnreasonableBlock;

/** 对外提供一个初始化方法 */
+ (StockBuySellView *)staticInitalizationStockBuySellView;

/** 根据情况 重新设定 买入卖出 限价市价 */
- (void)reSituationWithBuySellType:(BuySellType)buySellType
               withMarketFixedType:(MarketFixedPriceType)marketFixedType;

/** 绑定数据方法 */
- (void)bindData:(NSArray *)array;

/** 绑定数据 */
- (void)bindWithSimuTradeBaseData:(SimuTradeBaseData *)data
                  withBuySellType:(BuySellType)type;

/** 释放 */
- (void)textfieldDealloc;
/** 释放键盘 */
- (void)textfieldResignFirstRsp;

/** 清空 */
- (void)clearData;

/** 判断股票是否为空 内容 */
- (BOOL)judgeTextFieldContent;

/** 判断价格 */
- (NSString *)judgePriceTextFieldContent;

/** 判断数量 */
- (NSString *)judgeAmountTextFieldContent;

/** 校验数据 */
-(BOOL)checkDataForBuySellTextFiled;

@end
