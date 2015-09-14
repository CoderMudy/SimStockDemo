//
//  FoundMasterPurchViewConroller.h
//  SimuStock
//
//  Created by Mac on 14-3-24.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "MasterPurchesViewController.h"
#import "SimTopBannerView.h"
#import "TrackCardItemView.h"
#import "BaseViewController.h"
#import "SimTopBannerView.h"
#import "SimuTouchMoveView.h"
//交易
#import "EBPurchase.h"
#import "CompetitionCycleView.h"
#import "BaseViewcontroller.h"
#import "StoreUtil.h"
/*
 *类说明：资金卡商店页面
 */
@interface FoundMasterPurchViewConroller
    : BaseViewController <CompetitionCycleViewDelegate, UIAlertViewDelegate> {
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

  UIScrollView *scrollView;

  //商城兑换、支付工具类
  StoreUtil *storeUtil;
}

@end
