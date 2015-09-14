//
//  SellStockViewController.h
//  SimuStock
//
//  Created by 刘小龙 on 15/7/24.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StockBuySellView.h"
#import "SliederBuySellView.h"
#import "SimuStockInfoView.h"


@interface SellStockViewController : UIViewController
/** 买入卖出 输入框 */
@property(strong,nonatomic) StockBuySellView *stockBuySellView;
/** 资金选择 添加资金 滑块 View */
@property(strong, nonatomic) SliederBuySellView *sliederBuySellView;
/** 信息展示view */
@property(strong, nonatomic) SimuStockInfoView *simuStockInfoView;


@end
