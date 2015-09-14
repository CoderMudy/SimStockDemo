//
//  StockPriceStateCell.h
//  SimuStock
//
//  Created by Yuemeng on 15/4/24.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StockPriceStateData;
/*
 *股票分价cell
 */
@interface StockPriceStateCell : UITableViewCell
///成交价
@property(strong, nonatomic) IBOutlet UILabel *priceLabel;
///买入量
@property(strong, nonatomic) IBOutlet UILabel *amountLabel;
///总成交量
@property(strong, nonatomic) IBOutlet UILabel *percentLabel;

/** 复用Id */
@property(copy, nonatomic) NSString *reuseId;

///绑定数据
- (void)bindStockPriceStateData:(StockPriceStateData *)data
                 lastClosePrice:(CGFloat)lastClosePrice
                    totalAmount:(long)totalAmount
                    priceFormat:(NSString *)priceFormat;

@end
