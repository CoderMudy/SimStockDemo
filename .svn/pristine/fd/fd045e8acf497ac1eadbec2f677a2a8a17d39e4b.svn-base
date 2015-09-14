//
//  StockBuySellView.h
//  SimuStock
//
//  Created by 刘小龙 on 15/6/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

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

//对外提供一个初始化方法
+ (StockBuySellView *)staticInitalizationStockBuySellView;
///区别买入卖出 YES 为买 NO 为卖  YES 为市价 NO 为限价
- (void)accordingIncomingParametersShowBuyOrSell:(BOOL)buySell
                                 withMarketFixed:(BOOL)marketFixed;

/** 赋值 */
- (void)bindData:(NSArray *)array;

/** 清空 */
- (void)clearData;

@end
