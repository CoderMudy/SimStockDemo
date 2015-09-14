//
//  MasterPurchesViewController.h
//  SimuStock
//
//  Created by Mac on 14-2-13.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimTopBannerView.h"
#import "TrackCardItemView.h"
#import "BaseViewController.h"
#import "SimTopBannerView.h"
#import "SimuTouchMoveView.h"
//交易
#import "EBPurchase.h"
#import "SimuIndicatorView.h"
#import "CompetitionCycleView.h"
#import "BaseViewcontroller.h"
#import "StoreUtil.h"
#import "DataArray.h"

@protocol refreshMyTrancingViewDelegate <NSObject>

- (void)refreshMyTrancingView;

@end
/*
 *类说明：牛人追踪销售卡页面
 */
@interface MasterPurchesViewController
    : BaseViewController <TrackCardDelegate, CompetitionCycleViewDelegate,
                          UIAlertViewDelegate,AfterPurchaseRefreshData> {
  //下方区域
  CGRect mpvc_ContentRect;
  //卡片数组
  NSMutableArray *mpvc_CardArray;
  //数据数组
  NSMutableArray *mpvc_DataArray;
  //钻石购买数据窗口
  NSMutableArray *cycleArr;
  //代理
  id delegate;

  //说明2
  UIView *DiscraptView2;
  DataArray *dataArray;

  //商城兑换、支付工具类
  StoreUtil *storeUtil;
}
// lq
@property(weak, nonatomic) id<refreshMyTrancingViewDelegate> traceDelegate;
@property(weak, nonatomic) id delegate;

@end
