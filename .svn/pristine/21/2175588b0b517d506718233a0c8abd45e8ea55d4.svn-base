//
//  PartTimeView2+controller.h
//  SimuStock
//
//  Created by Mac on 15/6/4.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "PartTimeView.h"
#import "TrendKLineModel.h"
#import "StockUtil+view.h"
#import "StockUtil+float_window.h"
#import "BaseTrendVC.h"
#import "TimerUtil.h"
#import "PartTimeTradeVC.h"

/** 分时图点击时的浮窗显示，竖屏在图形中左右显示，横屏在图形上方显示*/
@interface FloatWindowViewForPartTime : UIView

///时刻
@property(weak, nonatomic) IBOutlet UILabel *timeLabel;

///现价
@property(weak, nonatomic) IBOutlet UILabel *curPriceLabel;

///涨幅
@property(weak, nonatomic) IBOutlet UILabel *riseValueLabel;

///均价
@property(weak, nonatomic) IBOutlet UILabel *avgPriceLabel;

///现量
@property(weak, nonatomic) IBOutlet UILabel *curAmountLabel;

/** 显示分时数据 */
- (void)bindPartTimeFloatData:(PartTimeFloatData *)itemInfo;

/** 设置样式为浮窗：圆边，有底色和阴影 */
- (void)setFloatWindowStyle;

@end

@interface BasePartTimeVC : BaseTrendVC <IViewVC> {
  TimerUtil *timerUtil;
}

///分时趋势图
@property(nonatomic, strong) PartTimeView *partTimeView;
///查看分时信息的浮窗
@property(nonatomic, strong) FloatWindowViewForPartTime *floatWindowView;

@end

/**
 * 竖屏情况下使用分时图的控制器，组合了分时图、浮窗和证券信息，当证券类型为指数时，显示指数的浮窗，否则显示基金或股票的浮窗*/
@interface PortaitPartTimeVC : BasePartTimeVC <IViewVC>

@end

/** 横屏情况下使用的分时图控制器 */
@interface HorizontalPartTimeVC : BasePartTimeVC <IViewVC>

@property(nonatomic, strong) PartTimeTradeVC *partTimeTradeVC;

///报价信息返回，通知观察者
@property(nonatomic, copy) OnStockQuotationInfoReady stockQuotationInfoReady;

///给横屏视图传递时间string
@property(nonatomic, copy) passTimeLabelText passTimeLabelText;

@end

