//
//  FirmSaleSearchStockVC.h
//  SimuStock
//
//  Created by Yuemeng on 14-9-25.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseViewController.h"
#import "StockSearchTableVC.h"

@interface RealStockSearchTableAdapter : BaseTableAdapter

@end

@interface RealStockSearchTableVC : StockSearchTableVC

@end

/**
 类说明：实盘交易买入页面选择股票弹出的股票搜索页面
 */
@interface FirmSaleSearchStockVC : BaseViewController {
  /**股票搜索栏*/
  UITextField *_stockSearchTextField;
}
/** 是否过滤指数股 */
@property(nonatomic, assign) BOOL filterStockIndex;

/** 得到股票代码的回调函数 */
@property(nonatomic, copy) OnStockSelected searchStockCodeBlock;
@end
