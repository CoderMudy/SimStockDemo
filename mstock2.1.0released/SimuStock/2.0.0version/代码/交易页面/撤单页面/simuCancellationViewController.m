//
//  simuCancellationViewController.m
//  SimuStock
//
//  Created by Mac on 14-7-17.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "simuCancellationViewController.h"
#import "CancellationRequest.h"
#import "NetLoadingWaitView.h"

@implementation simuCancellationViewController

- (id)initWithMatchId:(NSString *)matchId
        withAccountId:(NSString *)accountId
        withTitleName:(NSString *)titleName
     withUserOrExpert:(StockBuySellType)type {
  self = [super init];
  if (self) {
    self.matchId = matchId;
    self.userOrExpertType = type;
    self.accountId = accountId;
    self.titleName = titleName;
  }
  return self;
}
- (void)viewDidLoad {
  [super viewDidLoad];

  if ([self.titleName isEqualToString:@""]) {
    self.titleName = @"查委托/撤单";
  }
  [_topToolBar resetContentAndFlage:self.titleName Mode:TTBM_Mode_Leveltwo];

  //创建 撤单按钮
  [self createCancleEntrustButton];

  //创建 tableview
  self.tableViewHolder = [[StockEntrustViewHolder alloc] initWithRootView:self.clientView];

  //创建表
  //  [self createTableView];

  //设置小牛信息
  [_littleCattleView setInformation:@"暂无可撤单委托"];
  [_littleCattleView resetFrame:CGRectMake(0, CGRectGetMinY(_clientView.frame), self.view.frame.size.width, _clientView.height - BOTTOM_TOOL_BAR_HEIGHT)];

  // 3. 选中、反选一行
  __weak simuCancellationViewController *weakSelf = self;
  _tableViewHolder.dataSource.onTableRowSelectedCallback = ^(NSInteger rowIndex, BOOL isSecected) {
    simuCancellationViewController *strongSelf = weakSelf;
    if (strongSelf) {
      NSString *commonid = [strongSelf.tableViewHolder getSelectedEntrustIDs];
      if ([commonid isEqualToString:@""]) {
        strongSelf.btnCancleEntrust.hidden = YES;
      } else {
        strongSelf.btnCancleEntrust.hidden = NO;
      }
    }
  };

  //取得页面初始化需要的信息
  [self performBlock:^{
    [_indicatorView startAnimating];
    [self doqueryWithRequestFromUser:NO];
  } withDelaySeconds:0.1];
}

#pragma mark
#pragma mark 创建各个控件

///创建撤单按钮
- (void)createCancleEntrustButton {
  _btnCancleEntrust = [UIButton buttonWithType:UIButtonTypeCustom];
  _btnCancleEntrust.frame = CGRectMake(self.view.bounds.size.width - 70 - 30, startY, 70, 45);
  _btnCancleEntrust.backgroundColor = [UIColor clearColor];
  [_btnCancleEntrust setBackgroundImage:[UIImage imageNamed:@"return_touch_down"]
                               forState:UIControlStateHighlighted];
  [_btnCancleEntrust setTitle:@"撤单" forState:UIControlStateNormal];
  [_btnCancleEntrust setTitle:@"撤单" forState:UIControlStateHighlighted];
  [_btnCancleEntrust setTitleColor:[Globle colorFromHexRGB:@"#4dfdff"]
                          forState:UIControlStateNormal];
  [_btnCancleEntrust setTitleColor:[Globle colorFromHexRGB:@"#4dfdff"]
                          forState:UIControlStateHighlighted];
  _btnCancleEntrust.hidden = YES;

  [_topToolBar addSubview:_btnCancleEntrust];

  __weak simuCancellationViewController *weakSelf = self;
  ButtonPressed buttonPressed = ^{
    simuCancellationViewController *strongSelf = weakSelf;
    if (strongSelf) {
      NSString *commonid = [strongSelf.tableViewHolder getSelectedEntrustIDs];
      if (commonid == nil || [commonid length] <= 0) {
        //无撤单数据
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:@"请选择您想撤单的委托"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];

        return;
      }

      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
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
  [_indicatorView startAnimating];
  [self doqueryWithRequestFromUser:YES];
}

#pragma mark
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

  if (buttonIndex == 1) {
    //确定
    [self doCancelAction];
  } else {
    //取消
  }
}

#pragma mark
#pragma mark 网络相关函数

- (void)setNoNetwork:(BOOL)requestFromUser {
  //无网络且数据已经绑定，不显示小牛，但是弹窗显示：网络不给力；
  if (self.tableViewHolder.dataArray.dataBinded) {
    [NewShowLabel showNoNetworkTip];
  } else {
    //无网络且数据未绑定，显示无网络的小牛；
    [_littleCattleView isCry:YES];
    self.tableViewHolder.tableView.hidden = YES;
    if (requestFromUser) {
      [NewShowLabel showNoNetworkTip];
    }
  }
}

//撤单列表查询
- (void)doqueryWithRequestFromUser:(BOOL)requestFromUser {

  if (![SimuUtil isExistNetwork]) {
    //停止刷新菊花
    [_indicatorView stopAnimating];
    [self setNoNetwork:requestFromUser];
    return;
  };
  simuCancellationViewController *weakSelf = self;
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  callback.onCheckQuitOrStopProgressBar = ^{
    simuCancellationViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf.indicatorView stopAnimating];
      return NO;
    } else {
      return YES;
    }
  };
  callback.onSuccess = ^(NSObject *object) {
    [weakSelf bindEntrustData:(SimuTradeRevokeWrapper *)object];
  };
  //无网络且数据未绑定，显示无网络；
  callback.onFailed = ^() {
    [weakSelf setNoNetwork:requestFromUser];
  };

  if (self.userOrExpertType == StockBuySellOrdinaryType) {
    //普通请求
    [SimuTradeRevokeWrapper queryTradeCancleInfoesWithMatchId:self.matchId
                                                withPageIndex:@"1"
                                                 withCallBack:callback];

  } else if (self.userOrExpertType == StockBuySellExpentType) {
    //牛人 用户
    [SimuTradeRevokeWrapper requestTradeCancleInfoesWithAccountId:self.accountId
                                                     withCallback:callback];
  }
}

- (void)bindEntrustData:(SimuTradeRevokeWrapper *)todayEntrusts {
  [self.tableViewHolder bindEntrustList:todayEntrusts.dataArray];
  if (todayEntrusts.dataArray.count == 0) {
    [_littleCattleView isCry:NO];
    self.tableViewHolder.tableView.hidden = YES;
  } else {
    _littleCattleView.hidden = YES;
  }
}

/*
 *功能：撤单动作接口
 */
- (void)doCancelAction {

  //加入阻塞
  if (![NetLoadingWaitView isAnimating]) {
    [NetLoadingWaitView startAnimating];
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  callback.onCheckQuitOrStopProgressBar = ^{
    if ([NetLoadingWaitView isAnimating]) {
      [NetLoadingWaitView stopAnimating];
    }
    return NO;
  };
  callback.onSuccess = ^(NSObject *object) {
    //刷新数据
    [self doqueryWithRequestFromUser:NO];
  };

  callback.onFailed = ^() {
    NSLog(@"撤单失败了");
  };
  NSString *entrustIDs = [self.tableViewHolder getSelectedEntrustIDs];

  if (entrustIDs.length != 0) {
    NSArray *entrusArray = [entrustIDs componentsSeparatedByString:@","];
    for (NSString *entrus in entrusArray) {
      if (_userOrExpertType == StockBuySellOrdinaryType) {
        [CancellationRequest requstUserCancellation:self.matchId
                                         withEntrus:entrus
                                       withCallback:callback];
      } else if (_userOrExpertType == StockBuySellExpentType) {
        [CancellationRequest requestExpertCancellation:self.accountId
                                      withCommissionId:entrus
                                          withCallback:callback];
      }
    }
  }
}

@end
