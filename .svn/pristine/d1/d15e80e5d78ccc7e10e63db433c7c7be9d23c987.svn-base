//
//  RealTradeCancllationViewController.m
//  SimuStock
//
//  Created by Mac on 14-9-27.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "RTCancleEntrustVC.h"
#import "WFCancellationCapitalData.h"
#import "FirmBySellStatisticsInterface.h"

@interface RTCancleEntrustVC () {
  BOOL _firmOrCapital;
}

@end

@implementation RTCancleEntrustVC

- (id)initWithFrame:(CGRect)frame withFirmOrCapital:(BOOL)firmOrCapital {
  self = [super initWithFrame:frame];
  if (self) {
    _firmOrCapital = firmOrCapital;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.topToolBar resetContentAndFlage:@"股票交易" Mode:TTBM_Mode_Leveltwo];
  [self createCancleEntrustButton];
  self.tableViewHolder =
      [[StockEntrustViewHolder alloc] initWithRootView:self.clientView];
  self.tableViewHolder.tableView.userInteractionEnabled = NO;
  // 3. 选中、反选一行
  __weak RTCancleEntrustVC *weakSelf = self;
  _tableViewHolder.dataSource.onTableRowSelectedCallback = ^(NSInteger rowIndex,
                                                             BOOL isSecected) {
    RTCancleEntrustVC *strongSelf = weakSelf;
    if (strongSelf) {
      NSString *commonid = [strongSelf.tableViewHolder getSelectedEntrustIDs];
      if ([commonid isEqualToString:@""]) {
        strongSelf.btnCancleEntrust.hidden = YES;
      } else {
        strongSelf.btnCancleEntrust.hidden = NO;
      }
    }
  };
  //设置小牛
  CGRect tempFrame = self.view.bounds;
  tempFrame.origin.y += BOTTOM_TOOL_BAR_HEIGHT;
  _littleCattleView.frame = tempFrame;
  _littleCattleView.backgroundColor = [UIColor clearColor];
  [_littleCattleView setInformation:@"暂无委托数据"];

  [self performBlock:^{
    [_indicatorView startAnimating];
    [self doqueryWithRequestFromUser:NO];
  } withDelaySeconds:0.1];
}

//创建撤单按钮
- (void)createCancleEntrustButton {
  _btnCancleEntrust = [UIButton buttonWithType:UIButtonTypeCustom];
  _btnCancleEntrust.frame =
      CGRectMake(self.view.bounds.size.width - 70 - 30, startY, 70, 45);
  _btnCancleEntrust.backgroundColor = [UIColor clearColor];
  [_btnCancleEntrust
      setBackgroundImage:[UIImage imageNamed:@"return_touch_down"]
                forState:UIControlStateHighlighted];
  [_btnCancleEntrust setTitle:@"撤单" forState:UIControlStateNormal];
  [_btnCancleEntrust setTitle:@"撤单" forState:UIControlStateHighlighted];
  [_btnCancleEntrust setTitleColor:[Globle colorFromHexRGB:@"#4dfdff"]
                          forState:UIControlStateNormal];
  [_btnCancleEntrust setTitleColor:[Globle colorFromHexRGB:@"#4dfdff"]
                          forState:UIControlStateHighlighted];
  _btnCancleEntrust.hidden = YES;

  [_topToolBar addSubview:_btnCancleEntrust];

  __weak RTCancleEntrustVC *weakSelf = self;
  ButtonPressed buttonPressed = ^{
    RTCancleEntrustVC *strongSelf = weakSelf;
    if (strongSelf) {
      NSString *commonid = [strongSelf.tableViewHolder getSelectedEntrustIDs];
      if (commonid == nil || [commonid length] <= 0) {
        //无撤单数据
        UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                       message:@"请选择您想撤单的委托"
                                      delegate:nil
                             cancelButtonTitle:@"确定"
                             otherButtonTitles:nil, nil];
        [alert show];

        return;
      }

      UIAlertView *alert =
          [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                     message:@"您确定要撤单吗？"
                                    delegate:strongSelf
                           cancelButtonTitle:@"取消"
                           otherButtonTitles:@"确定", nil];
      [alert show];
    }
  };
  [_btnCancleEntrust setOnButtonPressedHandler:buttonPressed];
}

- (void)refreshButtonPressDown {

  [self doqueryWithRequestFromUser:YES];
}

- (void)setNoNetwork:(BOOL)requestFromUser {
  //无网络且数据已经绑定，不显示小牛，但是弹窗显示：网络不给力；

  if (self.dataBinded) {
    [NewShowLabel showNoNetworkTip];
    _littleCattleView.hidden = YES;
  } else {
    self.dataBinded = NO;
    //无网络且数据未绑定，显示无网络的小牛；
    [_littleCattleView isCry:YES];
    if (requestFromUser) {
      [NewShowLabel showNoNetworkTip];
    }
  }
}

- (void)doqueryWithRequestFromUser:(BOOL)requestFromUser {

  if (_firmOrCapital) {
    [self requestFirmOfferCancleEntrustWithRequsetFromuser:requestFromUser];
  } else {
    [self requestWithCapitalCancleEntrustWithRequsetFromuser:requestFromUser];
  }
}

//实盘界面 执行这个方法
- (void)requestFirmOfferCancleEntrustWithRequsetFromuser:(BOOL)requestFromUser {
  [_indicatorView startAnimating];

  if (![SimuUtil isExistNetwork]) {
    //停止刷新菊花
    [_indicatorView stopAnimating];
    [self setNoNetwork:requestFromUser];
    return;
  };

  __weak RTCancleEntrustVC *weakSelf = self;
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  callback.onCheckQuitOrStopProgressBar = ^{
    RTCancleEntrustVC *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf.indicatorView stopAnimating];
      return NO;
    } else {
      return YES;
    }
  };
  callback.onSuccess = ^(NSObject *obj) {
    RTCancleEntrustVC *strongSelf = weakSelf;
    if (strongSelf) {
      [weakSelf bindEntrustData:(RealTradeTodayEntrust *)obj];
    }
  };
  callback.onFailed = ^() {
    //请求失败
    [weakSelf setNoNetwork:requestFromUser];
  };

  [RealTradeTodayEntrust loadTodayEntruestList:callback];
}

//优顾实盘 配资界面 -- 执行这个方法
- (void)requestWithCapitalCancleEntrustWithRequsetFromuser:
        (BOOL)requestFromUser {
  [_indicatorView startAnimating];

  if (![SimuUtil isExistNetwork]) {
    //停止刷新菊花
    [_indicatorView stopAnimating];
    [self setNoNetwork:requestFromUser];
    return;
  };
  __weak RTCancleEntrustVC *weakSelf = self;
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  callback.onCheckQuitOrStopProgressBar = ^() {
    RTCancleEntrustVC *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf.indicatorView stopAnimating];
      return NO;
    } else {
      return YES;
    }
  };
  callback.onSuccess = ^(NSObject *obj) {
    //绑定数据
    [weakSelf bingCapitalEntrustData:(WFcancellData *)obj];
    self.btnCancleEntrust.hidden = YES;
  };
  callback.onFailed = ^() {
    [weakSelf setNoNetwork:requestFromUser];
  };

  //请求数据
  [WFCancellationCapitalData requestCancellationCapitalData:callback];
}

//实盘 绑定数据的方法
- (void)bindEntrustData:(RealTradeTodayEntrust *)todayEntrusts {
  self.dataBinded = YES;
  [self.tableViewHolder bindEntrustList:todayEntrusts.result];
  if (todayEntrusts.result.count == 0) {
    [_littleCattleView isCry:NO];
    self.tableViewHolder.tableView.userInteractionEnabled = NO;
  } else {
    _littleCattleView.hidden = YES;
    self.tableViewHolder.tableView.userInteractionEnabled = YES;
  }
}

//配资界面绑定数据
- (void)bingCapitalEntrustData:(WFcancellData *)cancell {
  self.dataBinded = YES;
  [self.tableViewHolder bindEntrustList:cancell.tradeTodayEntrustItemArray];
  if (cancell.tradeTodayEntrustItemArray.count == 0) {
    [_littleCattleView isCry:NO];
    self.tableViewHolder.tableView.userInteractionEnabled = NO;
  } else {
    _littleCattleView.hidden = YES;
    self.tableViewHolder.tableView.userInteractionEnabled = YES;
  }
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView
    clickedButtonAtIndex:(NSInteger)buttonIndex {

  if (buttonIndex == 1) {
    //确定
    [self doCancelAction];
  } else {
    //取消
  }
}
- (void)doCancelAction {
  //加入阻塞
  if (![NetLoadingWaitView isAnimating]) {
    [NetLoadingWaitView startAnimating];
  }

  if (_firmOrCapital == YES) {
    //实盘界面 -- 执行这个方法
    [self requestForFirmOfferEvacuateBill];
  } else {
    //优顾配资界面 -- 执行这个方法
    [self requestCapitalEvacuateBill];
  }
}
//实盘界面 -- 撤单请求
- (void)requestForFirmOfferEvacuateBill {
  __weak RTCancleEntrustVC *weakSelf = self;
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  callback.onCheckQuitOrStopProgressBar = ^{
    if ([NetLoadingWaitView isAnimating]) {
      [NetLoadingWaitView stopAnimating];
    }
    return NO;
  };
  callback.onSuccess = ^(NSObject *object) {
    RTCancleEntrustVC *strongSelf = weakSelf;
    if (strongSelf) {
      //刷新数据
      [strongSelf doqueryWithRequestFromUser:NO];
      [self cencleEntrustSuccessSendNotice];
      //撤单成功后调用
      [self cancleEntrustStatisticsInterfaceWithType:@"撤单"];
    }
  };
  NSString *chechanString = [self.tableViewHolder getSelectedEntrustIDs];
  if (chechanString.length != 0) {
    NSArray *entrusArray = [chechanString componentsSeparatedByString:@","];
    for (NSString *entrus in entrusArray) {
      [RealTradeTodayEntrust revokeTodayEntrusts:entrus withCallBack:callback];
    }
  }
}
///撤单成功后 发送通知 持仓界面刷新最新数据
- (void)cencleEntrustSuccessSendNotice {
  [[NSNotificationCenter defaultCenter]
      postNotificationName:@"cencleEntrustSuccess"
                    object:nil];
}

//优顾配资界面 撤单请求
- (void)requestCapitalEvacuateBill {
  __weak RTCancleEntrustVC *weakSelf = self;
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  callback.onCheckQuitOrStopProgressBar = ^() {
    RTCancleEntrustVC *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf.indicatorView stopAnimating];
      if ([NetLoadingWaitView isAnimating]) {
        [NetLoadingWaitView stopAnimating];
      }
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    RTCancleEntrustVC *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf doqueryWithRequestFromUser:NO];
      [self cencleEntrustSuccessSendNotice];
    }
  };

  NSString *chechanString = [self.tableViewHolder getSelectedEntrustIDs];
  if (chechanString.length != 0) {
    NSArray *entrusArray = [chechanString componentsSeparatedByString:@","];
    for (NSString *entrus in entrusArray) {
      [WFCancellationCapitalData
          requestCapitalEvacuateBillWithEntrustNo:entrus
                                     withCallback:callback];
    }
  }
  [self.indicatorView startAnimating];
}

#pragma mark - 撤单页面 统计接口
- (void)cancleEntrustStatisticsInterfaceWithType:(NSString *)type {
  __weak RTCancleEntrustVC *weakSelf = self;
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  callback.onCheckQuitOrStopProgressBar = ^() {
    RTCancleEntrustVC *strongSelf = weakSelf;
    if (strongSelf) {
      return NO;
    } else {
      return YES;
    }
  };
  callback.onSuccess = ^(NSObject *obj) {
    NSLog(@"撤单统计接口成功");
  };
  [FirmBySellStatisticsInterface
      requestFirmByOrSellStatisticeWithSotckName:nil
                                   withStockCode:nil
                                  withStockPrice:nil
                                 withStockAmount:nil
                                    withByOrSell:type
                                    withCallback:callback];
}

@end
