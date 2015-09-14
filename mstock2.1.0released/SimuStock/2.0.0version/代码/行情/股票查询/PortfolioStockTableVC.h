//
//  PortfolioStockTableVC.h
//  SimuStock
//
//  Created by Mac on 15/6/29.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseTableViewController.h"
#import "GainersTableViewCell.h"
#import "StockUtil.h"
#import "SelfStockUtil.h"

@interface PortfolioStockTableAdapter
    : BaseTableAdapter <GainersTableViewCellDelegate> {
}

@end

@interface PortfolioStockTableVC : BaseTableViewController

@property(copy, nonatomic) OnStockSelected onStockSelectedCallback;

/** 是否过滤指数股 */
@property(assign, nonatomic) BOOL filterStockIndex;

@end
