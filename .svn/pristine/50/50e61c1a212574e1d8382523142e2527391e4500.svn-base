//
//  simuBuyViewController.h
//  SimuStock
//
//  Created by Mac on 14-7-17.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopToolBarView.h"
#import "BaseViewController.h"
/*** 重构买卖页面  **/
#import "BaseBuySellVC.h"


/** 买入股票页面 */
@interface simuBuyViewController

    : BaseViewController <TopToolBarViewDelegate> {
  ///创建上方导航栏
  TopToolBarView *topToolbarView;
  CGRect oldFrame;
}
/** 买卖界面 */
@property(strong, nonatomic) BaseBuySellVC *buyVC;

/** 记录股票信息 */
@property(copy, nonatomic) NSString *tempStockCode;
@property(copy, nonatomic) NSString *tempStockName;
@property(copy, nonatomic) NSString *matchId;
@property(copy, nonatomic) NSString *tempStockNumber;
@property(assign, nonatomic) StockBuySellType stockSellBuyType;

@property(copy, nonatomic) NSString *accoundId;
@property(copy, nonatomic) NSString *titleName;
@property(copy, nonatomic) NSString *targetUid;

@property(nonatomic)
    BOOL isFromMatch; /** 是否从比赛页面进入的，如果是，则不需要请求 */
/** 设定初始的股票代码和股票名称 */
- (id)initWithStockCode:(NSString *)stockCode
          withStockName:(NSString *)stockName
            withMatchId:(NSString *)matchId
          withAccountId:(NSString *)accountId
   withStockSellBuyType:(StockBuySellType)type
          withTitleName:(NSString *)titleName
          withTargetUid:(NSString *)targetUid;

- (void)resetWithStockCode:(NSString *)stockCode
             withStockName:(NSString *)stockName;

/** 点击"买入"按钮 */
+ (void)buyStockInMatch:(NSString *)matchId;

/** 买入指定的股票 */
+ (void)buyStockWithStockCode:(NSString *)stockCode
                withStockName:(NSString *)stockName
                  withMatchId:(NSString *)matchId;
@end
