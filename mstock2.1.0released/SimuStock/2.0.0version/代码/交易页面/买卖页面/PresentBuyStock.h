//
//  PresentBuyStock.h
//  SimuStock
//
//  Created by Mac on 15/7/7.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StockBuySellView.h"

@interface PresentBuyStockCommon : NSObject

@property(nonatomic, weak) StockBuySellView *buySellView;

/** 校验是否选择股票 */
- (BOOL)validateStockSelected;

//判断输入的价格是否在正确的价格区间
- (BOOL)validateBuyPrice:(NSString *)priceStr;

@end

@interface PresentBuyStock : PresentBuyStockCommon

- (void)doBuyStockRequest;

@end
