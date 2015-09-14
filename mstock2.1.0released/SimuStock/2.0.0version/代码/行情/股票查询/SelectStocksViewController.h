//
//  SelectStocksViewController.h
//  SimuStock
//
//  Created by moulin wang on 14-7-16.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseViewController.h"
#import "DataArray.h"
#import "BaseTableViewController.h"
#import "StockUtil.h"

/** 选择股票的页面的来源页面*/
typedef NS_ENUM(NSUInteger, StartPageType) {
  /** 自选股相关的页面*/
  SelfStockPage = 0,
  /** 有买入按钮的页面*/
  BuyStockPage = 1,
  /** 买入页面*/
  InBuyStockPage = 2,
  /** 行情相关的页面*/
  StockmarketPage = 3,
  /** 其他页面*/
  OtherPage = 9
};

@interface SelectStocksViewController : BaseViewController {
  //滑动
  UIScrollView *slideScrollView;
}
@property(nonatomic, copy) OnStockSelected onStockSelectedCallback;

@property(nonatomic, assign) StartPageType buyStr;

- (id)initStartPageType:(StartPageType)startPageType
           withCallBack:(OnStockSelected)onStockSelectedCallback;

@end
