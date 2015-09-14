//
//  IndexStockWindVaneView.h
//  SimuStock
//
//  Created by Yuemeng on 15/5/15.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTrendVC.h"
#import "TimerUtil.h"

@class WindVaneView;
@class CowThanBearView;
@class RiseFallStatView;

/*
 *  指数股专用的 市场风向标 每日牛熊比 涨跌数统计 父视图
 */
@interface IndexStockWindVaneView : BaseTrendVC {
  WindVaneView *_windVaneView;
  CowThanBearView *_cowThanBearView;
  RiseFallStatView *_riseFallStatView;

  TimerUtil *timerUtil;
}

- (instancetype)initWithFrame:(CGRect)frame;

@end
