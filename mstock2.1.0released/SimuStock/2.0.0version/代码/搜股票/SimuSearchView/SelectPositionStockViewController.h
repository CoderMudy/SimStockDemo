//
//  SimuSellStockView.h
//  SimuStock
//
//  Created by Mac on 13-12-18.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectStocksViewController.h"
#import "ExpertPlanConst.h"
#import "SiuSellHeadView.h"

/** 选择卖出股票的页面的来源页面*/
typedef NS_ENUM(NSUInteger, SellStartPageType) {
  /** 卖出页面 */
  InSellStockPage = 0,
  /** 有卖出按钮的非卖出页面*/
  OtherSellPage = 9
};

@interface SelectPositionStockAdaper : BaseTableAdapter

@property(nonatomic, strong) NSString *macthId;

@property(assign, nonatomic) SellStartPageType startPageType;

@property(nonatomic, copy) OnStockSelected onStockSelectedCallback;

@end

@interface SelectPositionStockController : BaseTableViewController {

  OnStockSelected onStockSelectedCallback;

  SellStartPageType startPageType;
}
@property(nonatomic, strong) NSString *macthId;
/** accountId */
@property(strong, nonatomic) NSString *accountId;
/** targetUid */
@property(strong, nonatomic) NSString *targetUid;
/** 普通用户 或者 牛人用户 */
@property(assign, nonatomic) StockBuySellType userOrExpert;

- (id)initWithFrame:(CGRect)frame
             WithMatchId:(NSString *)matchId
       withStartPageType:(SellStartPageType)pageType
    withStockBuySellType:(StockBuySellType)type
            withCallBack:(OnStockSelected)callback;

@end
/*
 *类说明：选择可以卖出的股票列表页面
 */

@interface SelectPositionStockViewController : BaseViewController {

  DataArray *dataArray;

  OnStockSelected onStockSelectedCallback;

  SellStartPageType startPageType;

  SelectPositionStockController *selectPositionVC;
  
  SiuSellHeadView *sellHeadView;
}
/** 当前持仓所使用的比赛id */
@property(nonatomic, strong) NSString *macthId;
/** accountId */
@property(strong, nonatomic) NSString *accountId;
/** targetUid */
@property(strong, nonatomic) NSString *targetUid;
/** 普通用户 或者 牛人用户 */
@property(assign, nonatomic) StockBuySellType userOrExpert;

- (id)initWithMatchId:(NSString *)matchId
    withStartPageType:(SellStartPageType)pageType
        withAccountId:(NSString *)accountId
        withTargetUid:(NSString *)targetUid
     withUserOrExpert:(StockBuySellType)type
         withCallBack:(OnStockSelected)callback;



@end
