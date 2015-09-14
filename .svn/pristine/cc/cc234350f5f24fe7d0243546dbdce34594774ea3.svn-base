//
//  realTradeFoundView.h
//  SimuStock
//
//  Created by Mac on 14-9-19.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PositionData.h"

@protocol realTradeFoundViewDelegate <NSObject>
//资金转账按钮点击
- (void)fundButtonPressDwon:(NSInteger)tag;

@end
/*
 *类说明：账户资金小控件
 */
@interface RealTradeFoundView : UIView {
  //总资产（名称）
  UILabel *rtfv_tofundsNameLable;
  //总资产（数值）
  UILabel *rtfv_tofundsValueLable;
  //股票市值（名称）
  UILabel *rtfv_stockCapNameLable;
  //股票市值（数值）
  UILabel *rtfv_stockCapValueLable;
  //可用金额（名称）
  UILabel *rtfv_amountAvailNameLable;
  //可用金额（数值）
  UILabel *rtfv_amountAvailValueLable;
  //冻结金额（名称）
  UILabel *rtfv_frozenAmountNameLable;
  //冻结金额 （数值）
  UILabel *rtfv_frozenAmountValueLable;
}
@property(weak, nonatomic) id<realTradeFoundViewDelegate> delegate;
//重新设定账户信息
- (void)resetData:(PositionData *)pagedata;

@end
