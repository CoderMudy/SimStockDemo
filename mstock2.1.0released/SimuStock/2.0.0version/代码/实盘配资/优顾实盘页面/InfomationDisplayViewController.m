//
//  InfomationDisplayViewController.m
//  SimuStock
//
//  Created by moulin wang on 15/4/1.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "InfomationDisplayViewController.h"
#import "SimuUtil.h"
#import "RealTradeAccountVC.h"
#import "FirmSaleViewController.h"
#import "SimuRTBottomToolBar.h"
#import "RTCancleEntrustVC.h"
#import "InfomationMoreViewController.h"

#import "WFDataSharingCenter.h"

@interface InfomationDisplayViewController () <InfomationMoreSellDelegate> {
  InfomationMoreViewController *more_VC;
}
@end

@implementation InfomationDisplayViewController

- (id)init {
  self = [super init];
  if (self) {
    [self useSimpleInterestPreservationData];
  }
  return self;
}
//对外提供的初始化方式
- (id)initWithHsUserId:(NSString *)hsUserId
   withHomsFundAccount:(NSString *)homsFundAccount
     withHomsCombineld:(NSString *)homsCombineld
        withOperatorNo:(NSString *)operatorNo
         withContracNo:(NSString *)contracNo {
  self = [super init];
  if (self) {
    //
    self.hsUserId = hsUserId;
    self.homsFundAccount = homsFundAccount;
    self.homsCombineld = homsCombineld;
    self.operatorNo = operatorNo;
    self.contracNo = contracNo;
    [self useSimpleInterestPreservationData];
  }
  return self;
}

//用单利保存值
- (void)useSimpleInterestPreservationData {
  [WFDataSharingCenter shareDataCenter].hsUserId = self.hsUserId;
  [WFDataSharingCenter shareDataCenter].homsFundAccount = self.homsFundAccount;
  [WFDataSharingCenter shareDataCenter].homsCombineld = self.homsCombineld;
  [WFDataSharingCenter shareDataCenter].operatorNo = self.operatorNo;
  [WFDataSharingCenter shareDataCenter].contracNo = self.contracNo;
}

- (void)loadView {
  [super loadView];
}
- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)jumpToSellViewAndSendNum:(NSInteger)number {
  [srtvc_bottomToolBar buttonPressDownWithNum:2];
}

//重写账户信息界面
- (void)creatAccountVC {
  if (srtvc_realtradeVC == nil) {
    srtvc_realtradeVC =
        [[RealTradeAccountVC alloc] initWithFrame:self.baseContainerView.bounds
                                     withNavTitle:@"股票交易"
                          withOneViewOrSecondView:NO];
    [srtvc_realtradeVC setBackButtonPressedHandler:self.commonBackHandler];
    srtvc_realtradeVC.hsUserId = self.hsUserId;
    srtvc_realtradeVC.homsFundAccount = self.homsFundAccount;
    srtvc_realtradeVC.homsCombineld = self.homsCombineld;
    srtvc_realtradeVC.operatorNo = self.operatorNo;
    [self addChildViewController:srtvc_realtradeVC];
    [self.baseContainerView addSubview:srtvc_realtradeVC.view];
  } else {
    [self.baseContainerView bringSubviewToFront:srtvc_realtradeVC.view];
    [srtvc_realtradeVC.ravc_positionView reloadDataWithTableView];
  }
}

- (void)createFirmSaleVCisBuy:(BOOL)isBuy {
  //买
  if (isBuy) {
    if (!_firmBuyVC) {
      _firmBuyVC = [[FirmSaleViewController alloc]
          initWithBuyOrSell:isBuy
                  withFrame:self.baseContainerView.bounds
          withFirmOrCapital:NO];
      _firmBuyVC.superVC = self;
      _firmBuyVC.stockListData = srtvc_bottomToolBar.stockListData;
      [_firmBuyVC setBackButtonPressedHandler:self.commonBackHandler];
      [self addChildViewController:_firmBuyVC];
      [self.baseContainerView addSubview:_firmBuyVC.view];

    } else {
      [self dataIsShowOrDisappear:_firmBuyVC];
      [self.baseContainerView bringSubviewToFront:_firmBuyVC.view];
      [_firmBuyVC.fsPositions reloadDataWithTableView];
    }
    //卖
  } else {
    if (!_firmSellVC) {

      _firmSellVC = [[FirmSaleViewController alloc]
          initWithBuyOrSell:isBuy
                  withFrame:self.baseContainerView.bounds
          withFirmOrCapital:NO];
      _firmSellVC.superVC = self;
      _firmSellVC.stockListData = srtvc_bottomToolBar.stockListData;
      [_firmSellVC setBackButtonPressedHandler:self.commonBackHandler];
      [self addChildViewController:_firmSellVC];
      [self.baseContainerView addSubview:_firmSellVC.view];
    } else {
      [self dataIsShowOrDisappear:_firmSellVC];
      [self.baseContainerView bringSubviewToFront:_firmSellVC.view];
      [_firmSellVC.fsPositions reloadDataWithTableView];
    }
  }
}

//根据点击的按钮 不同 让证券名和价格 显示或着不显示
- (void)dataIsShowOrDisappear:(FirmSaleViewController *)firmBuyOrSell {
  if (srtvc_bottomToolBar.stockListData) {
    NSDictionary *dic = @{
      @"stockCode" : srtvc_bottomToolBar.stockListData.stockCode,
      @"stockName" : srtvc_bottomToolBar.stockListData.stockName
    };
    [firmBuyOrSell updataDataAssignment:dic];
    [firmBuyOrSell
        capitalByStockWithStockCode:srtvc_bottomToolBar.stockListData.stockCode
                     withStockPrice:@""
                 withAddAndSubtract:NO];
    srtvc_bottomToolBar.stockListData = nil;
  }
}

//创建或激活撤销委托页面
- (void)creatEntrustRevokeVC {
  if (entrustRevokeVC == nil) {
    entrustRevokeVC =
        [[RTCancleEntrustVC alloc] initWithFrame:self.baseContainerView.bounds
                               withFirmOrCapital:NO];
    [entrustRevokeVC setBackButtonPressedHandler:self.commonBackHandler];
    [self addChildViewController:entrustRevokeVC];
    [self.baseContainerView addSubview:entrustRevokeVC.view];
  } else {
    [self.baseContainerView bringSubviewToFront:entrustRevokeVC.view];
    [entrustRevokeVC refreshButtonPressDown];
  }
}
//更多页面
- (void)creatOrActiveMoreVC {
  if (more_VC == nil) {
    more_VC = [[InfomationMoreViewController alloc]
        initWithFrame:self.baseContainerView.bounds];
    [more_VC setBackButtonPressedHandler:self.commonBackHandler];
    more_VC.infoDelegate = self;
    [self addChildViewController:more_VC];
    [self.baseContainerView addSubview:more_VC.view];
  } else {
    [self.baseContainerView bringSubviewToFront:more_VC.view];
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
