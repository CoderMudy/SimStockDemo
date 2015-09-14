//
//  simuTopTimeBarView.h
//  SimuStock
//
//  Created by Mac on 14-7-11.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 *类说明：交易页面上方的时间展示小控件
 */
@interface SimuTopTimeBarView : UIView {
  ///定时器
  NSTimer *_timer;
  ///刷新时间间隔
  NSInteger _refreshTime;
}
@property (weak, nonatomic) IBOutlet UILabel *sttbv_openMarketLB;
@property (weak, nonatomic) IBOutlet UILabel *sttbv_timeShowLB;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
///定时器停止和开启
- (void)timeVisible:(BOOL)visible;

///强制刷新开盘状态和时间
- (void)forceRefresh;

-(void)startUpdateTime;
@end
