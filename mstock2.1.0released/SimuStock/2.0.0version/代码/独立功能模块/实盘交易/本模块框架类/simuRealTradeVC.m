//
//  simuRealTradeVC.m
//  SimuStock
//
//  Created by Mac on 14-9-18.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "simuRealTradeVC.h"
#import "SimTopBannerView.h"
#import "SimuIndicatorView.h"
#import "SimuUtil.h"
#import "SimuRTBottomToolBar.h"
#import "RealTradeAccountVC.h"
#import "RealTradeMoreFeaturesVC.h"
#import "RTCancleEntrustVC.h"

@interface simuRealTradeVC () <SimTopBannerViewDelegate, simuBottomTrendBarViewDelegate, SimuIndicatorDelegate> {
}

@end

@implementation simuRealTradeVC

- (id)initWithDictionary:(NSDictionary *)inputParameters {
  if (self = [super init]) {
    self.inputParameters = inputParameters;
  }
  return self;
}
- (void)viewDidLoad {
  [super viewDidLoad];

  srtvc_realtradeVC = nil;
  self.view.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];

  //创建所有需要的页面内控件
  [self creatAllContrViews];

  //创建底部工具栏
  [self creatbottomToolBar];

  //创建账户
  if (_inputParameters == nil) {
    [self creatAccountVC];
  } else {
    NSNumber *selectedIndex = _inputParameters[@"selectedIndex"];
    UIButton *button = (UIButton *)[srtvc_bottomToolBar viewWithTag:selectedIndex.integerValue];
    [srtvc_bottomToolBar buttonpressdown:button];
  }
}

- (void)dealloc {

  if (srtvc_moreVC) {
    [srtvc_moreVC.view removeFromSuperview];
    [srtvc_moreVC removeFromParentViewController];
    srtvc_moreVC = nil;
  }
  if (srtvc_realtradeVC) {
    [srtvc_realtradeVC.view removeFromSuperview];
    [srtvc_realtradeVC removeFromParentViewController];
    srtvc_realtradeVC = nil;
  }

  if (entrustRevokeVC) {
    [entrustRevokeVC.view removeFromSuperview];
    [entrustRevokeVC removeFromParentViewController];
    entrustRevokeVC = nil;
  }
  //买入页面
  if (_firmBuyVC) {
    [_firmBuyVC.view removeFromSuperview];
    [_firmBuyVC removeFromParentViewController];
    _firmBuyVC = nil;
  }
  //卖出页面
  if (_firmSellVC) {
    [_firmSellVC.view removeFromSuperview];
    [_firmSellVC removeFromParentViewController];
    _firmSellVC = nil;
  }
}

#pragma mark
#pragma mark 创建各个控件
//创建所有需要的控件
- (void)creatAllContrViews {

  //创建客户区视图
  self.baseContainerView =
      [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - BOTTOM_TOOL_BAR_HEIGHT)];
  [self.view addSubview:self.baseContainerView];
  __weak simuRealTradeVC *weakSelf = self;
  self.commonBackHandler = ^{
    simuRealTradeVC *strongSelf = weakSelf;
    if (strongSelf) {
      [AppDelegate popViewController:YES];
    }
  };
}

//创建底部工具栏
- (void)creatbottomToolBar {
  NSArray *nameArray = @[
    @"账户",
    @"买入",
    @"卖出",
    @"查委托", //
    @"更多"
  ];
  //普通图片名称
  NSArray *upnameArray = @[ @"交易_UP", @"买入_up", @"卖出_up", @"查委托_up", @"更"
                                                                                       @"多小图标_"
                                                                                       @"up" ];
  //按下图片名称数组
  NSArray *downnameArray =
      @[ @"交易_down",
         @"买入_down",
         @"卖出_down",
         @"查委托_down",
         @"更多小图标_down" ];

  NSMutableArray *arra = [[NSMutableArray alloc] init];
  for (int i = 0; i < [nameArray count]; i++) {
    MarketBottomButtonInfo *info = [[MarketBottomButtonInfo alloc] init];
    info.notSellectedImageName = upnameArray[i];
    info.sellectedImageName = downnameArray[i];
    info.titleName = nameArray[i];
    [arra addObject:info];
  }
  srtvc_bottomToolBar =
      [[SimuRTBottomToolBar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - BOTTOM_TOOL_BAR_HEIGHT,
                                                            self.view.bounds.size.width, BOTTOM_TOOL_BAR_HEIGHT)
                                     ContenArray:arra];
  srtvc_bottomToolBar.delegate = self;
  [self.view addSubview:srtvc_bottomToolBar];
}

//创建或激活账户页面VC
- (void)creatAccountVC {
  if (srtvc_realtradeVC == nil) {
    srtvc_realtradeVC = [[RealTradeAccountVC alloc] initWithFrame:_baseContainerView.bounds
                                                     withNavTitle:@"股票交易"
                                          withOneViewOrSecondView:YES];
    [srtvc_realtradeVC setBackButtonPressedHandler:self.commonBackHandler];
    [self addChildViewController:srtvc_realtradeVC];
    [_baseContainerView addSubview:srtvc_realtradeVC.view];
  } else {
    [_baseContainerView bringSubviewToFront:srtvc_realtradeVC.view];
  }
}

//创建或激活撤销委托页面
- (void)creatEntrustRevokeVC {
  if (entrustRevokeVC == nil) {
    entrustRevokeVC =
        [[RTCancleEntrustVC alloc] initWithFrame:_baseContainerView.bounds withFirmOrCapital:YES];
    [entrustRevokeVC setBackButtonPressedHandler:self.commonBackHandler];
    [self addChildViewController:entrustRevokeVC];
    [_baseContainerView addSubview:entrustRevokeVC.view];
  } else {
    [_baseContainerView bringSubviewToFront:entrustRevokeVC.view];
  }
}

//创建或激活更多页面
- (void)creatOrActiveMoreVC {
  if (srtvc_moreVC == nil) {
    srtvc_moreVC = [[RealTradeMoreFeaturesVC alloc] initWithFrame:_baseContainerView.bounds];
    [srtvc_moreVC setBackButtonPressedHandler:self.commonBackHandler];
    [self addChildViewController:srtvc_moreVC];
    [_baseContainerView addSubview:srtvc_moreVC.view];
  }
  [_baseContainerView bringSubviewToFront:srtvc_moreVC.view];
}

#pragma mark
#pragma mark 协议回调函数
//点击左边按钮，切换股票
- (void)leftPressDown {
}
//点击右边按钮，切换股票
- (void)rightPressDown {
}
//点击中间按钮
- (void)pressDownIndex:(NSInteger)index {
  if (index == 0) {
    //账户
    [self creatAccountVC];
  } else if (index == 1) {
    //买入
    NSLog(@"买入页面");
    [self createFirmSaleVCisBuy:YES];
  } else if (index == 2) {
    //卖出
    NSLog(@"卖出页面");
    [self createFirmSaleVCisBuy:NO];
  } else if (index == 3) {
    //查委托
    [self creatEntrustRevokeVC];
  } else if (index == 4) {
    //更多
    [self creatOrActiveMoreVC];
  }
}

//创建或激活买卖页面
- (void)createFirmSaleVCisBuy:(BOOL)isBuy {
  //买
  if (isBuy) {
    if (!_firmBuyVC) {
      _firmBuyVC = [[FirmSaleViewController alloc] initWithBuyOrSell:isBuy
                                                           withFrame:_baseContainerView.bounds
                                                   withFirmOrCapital:YES];
      _firmBuyVC.superVC = self;
      _firmBuyVC.positionRes = srtvc_bottomToolBar.posResult;
      [_firmBuyVC setBackButtonPressedHandler:self.commonBackHandler];
      [_firmBuyVC updataDataAssignment:_inputParameters];
      if (_inputParameters && _inputParameters[@"stockCode"]) {
        [_firmBuyVC getEntrustAmountWithStockCode:_inputParameters[@"stockCode"] stockPrice:@""];
      }

      [self addChildViewController:_firmBuyVC];
      [_baseContainerView addSubview:_firmBuyVC.view];

    } else {
      [self dataIsShowOrDisappear:_firmBuyVC];
      [_baseContainerView bringSubviewToFront:_firmBuyVC.view];
    }
    //卖
  } else {
    if (!_firmSellVC) {

      _firmSellVC = [[FirmSaleViewController alloc] initWithBuyOrSell:isBuy
                                                            withFrame:_baseContainerView.bounds
                                                    withFirmOrCapital:YES];
      _firmSellVC.superVC = self;
      _firmSellVC.positionRes = srtvc_bottomToolBar.posResult;
      [_firmSellVC setBackButtonPressedHandler:self.commonBackHandler];

      [self addChildViewController:_firmSellVC];
      [_baseContainerView addSubview:_firmSellVC.view];

      [_firmSellVC updataDataAssignment:_inputParameters];
      if (_inputParameters && _inputParameters[@"stockCode"]) {
        [_firmSellVC getEntrustAmountWithStockCode:_inputParameters[@"stockCode"] stockPrice:@""];
      }
    } else {
      [self dataIsShowOrDisappear:_firmSellVC];
      [_baseContainerView bringSubviewToFront:_firmSellVC.view];
    }
  }
}

//根据点击的按钮 不同 让证券名和价格 显示或着不显示
- (void)dataIsShowOrDisappear:(FirmSaleViewController *)firmBuyOrSell {
  if (srtvc_bottomToolBar.posResult) {
    NSDictionary *dic = @{
      @"stockCode" : srtvc_bottomToolBar.posResult.stockCode,
      @"stockName" : srtvc_bottomToolBar.posResult.stockName
    };
    [firmBuyOrSell updataDataAssignment:dic];
    [firmBuyOrSell getEntrustAmountWithStockCode:srtvc_bottomToolBar.posResult.stockCode
                                      stockPrice:@""];
    srtvc_bottomToolBar.posResult = nil;
  }
}

@end
