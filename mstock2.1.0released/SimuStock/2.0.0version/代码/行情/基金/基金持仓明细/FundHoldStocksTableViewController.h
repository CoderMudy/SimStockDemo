//
//  FundHoldStocksViewController.h
//  SimuStock
//
//  Created by Mac on 15/5/11.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseTableViewController.h"
#import "FundHoldStockList.h"

@interface FundHoldStocksAdapter : BaseTableAdapter

@end

@interface FundHoldStocksTableViewController : BaseTableViewController

/** 基金代码 */
@property(nonatomic, strong) NSString *fundCode;

/** 基金名称 */
@property(nonatomic, strong) NSString *fundName;

/** 返回的持仓股票列表 */
@property(nonatomic, strong) FundHoldStockList *stockList;

/** 列表的头部 */
@property(nonatomic, strong) UIView *tableHeader;

@end
