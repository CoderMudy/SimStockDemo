//
//  simuFundFowView.h
//  SimuStock
//
//  Created by Mac on 14-8-13.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomPageData.h"
#import "TrendKLineModel.h"
/*
 *类说明：资金流画图 (饼状图)
 */
@interface SimuFundFlowView : UIView {
  //昨日资金流动数据
  NSMutableArray *_yesFundArray;
  long totalfund;
  ///上一个扇形的中心弧度角
  float lastcenterAngle;
  // 5日资金流向数据
  NSMutableArray *_5DayFundArray;
  // 5日资金流向的日期数据
  NSMutableArray *_5DayDateArray;
  //累计资金流量数据
  NSMutableArray *_totalFundArray;
  //累计资金流量
  NSMutableArray *_totalLabelArray;
  //昨日资金流动图形区域
  CGRect _yesRect;
  // 5日资金流动区域
  CGRect _5dayRect;
  //累计资金流动区域
  CGRect _totalRect;
}

- (void)setPageData:(FundsFlowData *)pagedata;
//清理数据
- (void)clearData;

@end
