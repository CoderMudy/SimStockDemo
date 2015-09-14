//
//  FundTrendLineViewController.m
//  SimuStock
//
//  Created by Mac on 15/5/12.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "FundTrendLineViewController.h"

@implementation FundTrendLineViewController {
  //走势，日线，周线等切换控件
  simuCenterTabView *tvc_centerTabView;
  //创建走势和K线的基本承载页面
  UIView *tvc_baseVeiw;
  UIView *tvc_fromView;
  UIView *tvc_toView;
  //走势页面
  TrendView *tvc_trendView;
  //日K线
  KLineView *tvc_dayKLineView;
  //周K线
  KLineView *tvc_weekKLineView;
  //月K线
  KLineView *tvc_monthKLineView;

  Securities *securites;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
}

#pragma mark
#pragma mark simuCenterTabViewDelegate 分时和K线，周线切换函数协议
- (void)tabSelected:(NSInteger)index {
  if (index == 0) {
    //切换到走势页面
    tvc_pageType = 0;
    [self creatOrActiveTrendView];
  } else if (index == 1) {
    //切换到日K页面
    tvc_pageType = 1;
    [self creatOrActiveDayKLineView];
  } else if (index == 2) {
    // 切换到周K页面
    tvc_pageType = 2;
    [self creatOrActiveweekKLineView];
  } else if (index == 3) {
    //切换到月K页面
    tvc_pageType = 3;
    [self creatOrActiveMonthKLineView];
  }
  [self hideTrendFloatViews];
}

//走势页面浮窗消息
- (void)hideTrendFloatViews {
  if (tvc_trendView) {
    [tvc_trendView HideFloatView];
  }
  if (tvc_dayKLineView) {
    [tvc_dayKLineView hideFloatView];
  }
  if (tvc_weekKLineView) {
    [tvc_weekKLineView hideFloatView];
  }
  if (tvc_monthKLineView) {
    [tvc_monthKLineView hideFloatView];
  }
}

//创建走势，日线的切换Tab小控件
- (void)creatTabViews {
  NSArray *array = @[ @"分时", @"日线", @"周线", @"月线" ];
  tvc_centerTabView = [[simuCenterTabView alloc]
      initWithFrame:CGRectMake(5,
                               tvc_topStockInfoView.frame.origin.y +
                                   tvc_topStockInfoView.frame.size.height + 1,
                               self.view.bounds.size.width - 10, 25.5)
         titleArray:array];
  tvc_centerTabView.delegate = self;
  [tvc_scrollView addSubview:tvc_centerTabView];
}
//创建走势和K线的基本承载页面
- (void)creatBaseView {
  tvc_baseVeiw = [[UIView alloc]
      initWithFrame:CGRectMake(0, tvc_centerTabView.frame.origin.y +
                                      tvc_centerTabView.frame.size.height + 10,
                               self.view.bounds.size.width, 340 / 2 + 17)];
  tvc_baseVeiw.backgroundColor = [UIColor clearColor];
  [tvc_scrollView addSubview:tvc_baseVeiw];
}

//创建走势页面
- (void)creatTrendViews {
  if (tvc_trendView == nil) {
    tvc_trendView =
        [[TrendView alloc] initWithFrame:tvc_baseVeiw.bounds StockType:NO];
    tvc_trendView.tag = 0;
    [tvc_baseVeiw addSubview:tvc_trendView];
    tvc_fromView = tvc_trendView;
  } else {
    tvc_trendView.frame = tvc_baseVeiw.bounds;
  }
}
//创建并激活走势
- (void)creatOrActiveTrendView {
  if (tvc_trendView == nil) {
    tvc_trendView =
        [[TrendView alloc] initWithFrame:tvc_baseVeiw.bounds StockType:NO];
    tvc_trendView.tag = 0;
    [tvc_baseVeiw addSubview:tvc_trendView];
  }
  tvc_trendView.frame = tvc_baseVeiw.bounds;
  tvc_fromView.hidden = YES;
  tvc_trendView.hidden = NO;
  tvc_fromView = tvc_trendView;
  [tvc_baseVeiw bringSubviewToFront:tvc_trendView];
  [self getInitDataFromNet];
}
//创建并激活日K走势
- (void)creatOrActiveDayKLineView {
  if (tvc_dayKLineView == nil) {
    tvc_dayKLineView = [[KLineView alloc] initWithFrame:tvc_baseVeiw.bounds];
    tvc_dayKLineView.tag = 1;
    [tvc_baseVeiw addSubview:tvc_dayKLineView];
  }
  tvc_dayKLineView.frame = tvc_baseVeiw.bounds;

  tvc_fromView.hidden = YES;
  tvc_dayKLineView.hidden = NO;
  tvc_fromView = tvc_dayKLineView;
  [tvc_baseVeiw bringSubviewToFront:tvc_dayKLineView];

  if (!tvc_dayKLineView.isNotDownLoad) {
    [self getStockKLineDataFromNet:mtvc_stockCode Type:@"D"];
  }
}
//创建并激活周K走势
- (void)creatOrActiveweekKLineView {
  if (tvc_weekKLineView == nil) {
    tvc_weekKLineView = [[KLineView alloc] initWithFrame:tvc_baseVeiw.bounds];
    tvc_weekKLineView.tag = 2;
    [tvc_baseVeiw addSubview:tvc_weekKLineView];
  }
  tvc_weekKLineView.frame = tvc_baseVeiw.bounds;
  tvc_fromView.hidden = YES;
  tvc_weekKLineView.hidden = NO;
  tvc_fromView = tvc_weekKLineView;
  [tvc_baseVeiw bringSubviewToFront:tvc_weekKLineView];
  if (!tvc_weekKLineView.isNotDownLoad) {
    [self getStockKLineDataFromNet:mtvc_stockCode Type:@"W"];
  }
}

//创建并激活月K走势
- (void)creatOrActiveMonthKLineView {
  if (tvc_monthKLineView == nil) {
    tvc_monthKLineView = [[KLineView alloc] initWithFrame:tvc_baseVeiw.bounds];
    tvc_monthKLineView.tag = 1;
    [tvc_baseVeiw addSubview:tvc_monthKLineView];
  }
  tvc_monthKLineView.frame = tvc_baseVeiw.bounds;
  tvc_fromView.hidden = YES;
  tvc_monthKLineView.hidden = NO;
  tvc_fromView = tvc_monthKLineView;
  [tvc_baseVeiw bringSubviewToFront:tvc_monthKLineView];

  if (!tvc_monthKLineView.isNotDownLoad) {
    [self getStockKLineDataFromNet:mtvc_stockCode Type:@"M"];
  }
  //[self getKlineDataWithPaketFormNet:mtvc_stockCode KLineType:@"M"];
}

@end
