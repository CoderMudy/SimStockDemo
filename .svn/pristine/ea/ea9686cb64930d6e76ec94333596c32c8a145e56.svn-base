//
//  PlanListView.m
//  SimuStock
//
//  Created by 刘小龙 on 15/7/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "PlanListView.h"
#import "StockUtil.h"

@implementation PlanListView

- (id)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super initWithCoder:aDecoder]) {
    UIView *containerView = [[[UINib nibWithNibName:@"PlanListView" bundle:nil]
        instantiateWithOwner:self
                     options:nil] objectAtIndex:0];
    CGRect newFrame =
        CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    containerView.frame = newFrame;
    [self addSubview:containerView];
  }
  return self;
}

- (void)awakeFromNib {
}

//绑定数据
- (void)bindDataWithExpertAccount:(EPexpertPositionData *)accountData {
  //持仓盈亏
  UIColor *color = [StockUtil getColorByFloat:accountData.stockProfit];
  _positionProfitLossLable.textColor = color;
  _positionProfitLossLable.text = [NSString stringWithFormat:@"%0.2f",accountData.stockProfit];
  //持股市值
  _stockMarketValueLabel.text = [NSString stringWithFormat:@"%0.2f",accountData.stockAssets];

  //资金余额
  _capitalBalanceLabel.text = [NSString stringWithFormat:@"%0.2f",accountData.currentBalance];

  //总资产
  _totalAssetsLabel.text = [NSString stringWithFormat:@"%0.2f",accountData.totalAssets];
}
@end
