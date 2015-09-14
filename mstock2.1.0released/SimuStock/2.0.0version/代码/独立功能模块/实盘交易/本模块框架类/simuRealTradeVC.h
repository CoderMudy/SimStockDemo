//
//  simuRealTradeVC.h
//  SimuStock
//
//  Created by Mac on 14-9-18.
//  Copyright (c) 2014年 Mac. All rights reserved.
//
/**
 *实盘交易小模块框架类
 */
#import <UIKit/UIKit.h>
#import "Globle.h"
@class SimuRTBottomToolBar;
@class FirmSaleViewController;
@class RTCancleEntrustVC;
@class RealTradeAccountVC;
@class RealTradeMoreFeaturesVC;

@interface simuRealTradeVC : UIViewController {
  //底部工具栏
  SimuRTBottomToolBar *srtvc_bottomToolBar;
  //买入页面
  FirmSaleViewController *_firmBuyVC;
  //卖出页面
  FirmSaleViewController *_firmSellVC;
  //撤单页面
  RTCancleEntrustVC *entrustRevokeVC;
  //账户类
  RealTradeAccountVC *srtvc_realtradeVC;
  //更多页面
  RealTradeMoreFeaturesVC *srtvc_moreVC;
}

/** 承载页面 */
@property(nonatomic, strong) UIView *baseContainerView;

/** 外部传入的输入参数，可以定义显示哪一页及相关的参数 */
@property(strong, nonatomic) NSDictionary *inputParameters;

/** 公用的返回处理 */
@property(nonatomic, copy) onBackButtonPressed commonBackHandler;

//创建或激活账户页面VC
- (void)creatAccountVC;

//创建或激活撤销委托页面
- (void)creatEntrustRevokeVC;

//创建或激活更多页面
- (void)creatOrActiveMoreVC;

//创建或激活买卖页面
- (void)createFirmSaleVCisBuy:(BOOL)isBuy;

/**初始化传值传入股票代码*/
- (id)initWithDictionary:(NSDictionary *)inputParameters;

@end
