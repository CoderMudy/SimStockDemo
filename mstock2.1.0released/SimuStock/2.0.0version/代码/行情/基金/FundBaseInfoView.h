//
//  FundBaseInfoView.h
//  SimuStock
//
//  Created by Mac on 15/5/11.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FundCurStatus.h"

///建议使用时设置此View的高度
static const CGFloat FundBaseInfoViewSuggestHeight = 105.f;

/** 基金基本信息显示控件 */
@interface FundBaseInfoView : UIView {
  FundCurStatus *stockInfo;

  NSMutableArray *valuesTop;
  NSMutableArray *valuesBottom;
  NSString *currentPrice;
  NSString *changeValueAndRate;

  UIColor *priceColor;

  CGRect curPriceRect;
  CGRect changeValueAndRateRect;
}

/** 绑定基金数据 */
- (void)bindFundCurStatus:(FundCurStatus *)data;

@end
