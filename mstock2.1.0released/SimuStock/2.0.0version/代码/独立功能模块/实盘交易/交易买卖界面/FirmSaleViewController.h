//
//  FirmSaleViewController.h
//  SimuStock
//
//  Created by moulin wang on 14-9-18.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "simuRealTradeVC.h"
#import "BaseViewController.h"
#import "FSPositionsViewController.h"
#import "UpDateMarketView.h"
#import "FirmSaleBuyOrSellInputView.h"
#import "PositionData.h"
#import "GetStockFirmPositionData.h"

/** 实盘买卖页面 */
@interface FirmSaleViewController : BaseViewController {
  /**实时行情*/
  UpDateMarketView *_upDateView;
  //左上角股票买卖数量输入组件
  // FirmSaleBuyOrSellInputView *_firmSaleBuyOrSellInputView;
  //下面的持仓tableView
  FSPositionsViewController *_fsPositions;
  //指定是买入还是卖出
  BOOL _isBuy;
  // 在实盘调用还是配资里
  BOOL _firmOrCapital;
}

/**为了点击返回，取得父类 */
@property(nonatomic, weak) simuRealTradeVC *superVC;

@property(nonatomic, strong) PositionResult *positionRes;

@property(nonatomic, strong) WFfirmStockListData *stockListData;

@property(nonatomic, strong)
    FirmSaleBuyOrSellInputView *firmSaleBuyOrSellInputView;

@property(nonatomic, strong) FSPositionsViewController *fsPositions;

/**
 初始化指定买入还是卖出页面 在加个bool值判断是在 实盘 还是 配资
 */
- (id)initWithBuyOrSell:(BOOL)isBuy
              withFrame:(CGRect)frame
      withFirmOrCapital:(BOOL)firmOrCapital;

/**
 刷新所有数据
 */
- (void)updataData;

//委托数量
- (void)getEntrustAmountWithStockCode:(NSString *)stockCode
                           stockPrice:(NSString *)stockPrice;
//配资实盘 委托数量
- (void)capitalByStockWithStockCode:(NSString *)stockCode
                     withStockPrice:(NSString *)stockPrice
                 withAddAndSubtract:(BOOL)addAndSubtract;

///用来清空和赋值买入卖出控件
- (void)updataDataAssignment:(NSDictionary *)dic;

@end