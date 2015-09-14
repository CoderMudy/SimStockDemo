//
//  simuSellViewController.h
//  SimuStock
//
//  Created by Mac on 14-7-17.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SchollWebViewController.h"
#import "BaseViewController.h"
#import "TopToolBarView.h"
#import "BuySellConstant.h"
#import "BaseBuySellVC.h"
#import "OpenMembershipViewController.h"

/** 类说明：卖出股票页面 */
@interface simuSellViewController
    : BaseViewController <TopToolBarViewDelegate> {
  OpenMembershipViewController *openMembershipVC;
  ///记录当前在那个页面
  NSInteger pageIndex;
  ///创建上方导航栏
  TopToolBarView *topToolbarView;
  CGRect oldFrame;
}
/** 买卖界面 */
@property(strong, nonatomic) BaseBuySellVC *buyVC;

/** 记录股票信息 */
@property(copy, nonatomic) NSString *tempStockCode;
@property(copy, nonatomic) NSString *tempStockName;
@property(copy, nonatomic) NSString *tempStockNumber;
/** 比赛ID */
@property(copy, nonatomic) NSString *scv_marichid;

/** accountId */
@property(copy, nonatomic) NSString *accountId;
/** targetUid */
@property(copy, nonatomic) NSString *targetUid;
/** titleName */
@property(copy, nonatomic) NSString *titleName;
/** 区分是 普通用户 还是 牛人用户 */
@property(assign, nonatomic) StockBuySellType sellType;


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

/** 点击"卖出"按钮 */
+ (void)sellStockInMatch:(NSString *)matchId;

/** 卖出指定的股票 */
+ (void)sellStockWithStockCode:(NSString *)stockCode
                 withStockName:(NSString *)stockName
                   withMatchId:(NSString *)matchId;
@end
