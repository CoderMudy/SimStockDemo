//
//  StockTradeDetailCell.h
//  SimuStock
//
//  Created by Yuemeng on 15/4/24.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StockTradeDetailData;
/*
 *股票明细cell
 */
@interface StockTradeDetailCell : UITableViewCell
///时间标签
@property(strong, nonatomic) IBOutlet UILabel *timeLabel;
///价格标签
@property(strong, nonatomic) IBOutlet UILabel *priceLabel;
///成交量标签
@property(strong, nonatomic) IBOutlet UILabel *amountLabel;
/** 复用Id */
@property(copy, nonatomic) NSString *reuseId;
///设置标签数据
- (void)bindStockTradeDetailData:(StockTradeDetailData *)data
                  lastClosePrice:(float)lastClosePrice
                     priceFormat:(NSString *)priceFormat;

@end
