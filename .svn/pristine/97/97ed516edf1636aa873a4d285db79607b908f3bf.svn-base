//
//  SameStockSupermanListViewController.h
//  SimuStock
//
//  Created by Mac on 15/4/29.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseTableViewController.h"
#import "SameStockHero.h"
#import "StockUtil.h"

@interface SameStockHeroTableAdapter : BaseTableAdapter

/** 返回价格格式化字符串 */
@property(nonatomic, copy) PriceFormatAction priceFormat;

@end

@interface SameStockHeroListViewController : BaseTableViewController

/** 股票代码 */
@property(nonatomic, strong) NSString *stockCode;

/** 同股牛人页面数据 */
@property(nonatomic, strong) SameStockHeroList *heroList;

/** 返回价格格式化字符串 */
@property(nonatomic, copy) PriceFormatAction priceFormat;

- (id)initWithFrame:(CGRect)frame withStockCode:(NSString *)stockCode;

/** 重置股票代码 */
- (void)resetStockCode:(NSString *)stockCode;

@end
