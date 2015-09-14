//
//  BrokerageAccountListVC.m
//  SimuStock
//
//  Created by 刘小龙 on 15/6/4.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BrokerageAccountListVC.h"
#import "SimuUtil.h"
#import "CutomerServiceButton.h"
#import "NewShowLabel.h"

@interface BrokerageAccountListVC () {
  //开户简介承载页面
  UIView *_datailView;
}

@end

@implementation BrokerageAccountListVC

- (id)initWithOnLoginCallbalck:(OnLoginCallBack)onLoginCallback {
  self = [super init];
  if (self) {
    self.onLoginCallBack = onLoginCallback;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  //创建新牛
  _littleCattleView = nil;
  _littleCattleView = [[LittleCattleView alloc] initWithFrame:_clientView.bounds
                                                  information:nil];
  [_clientView addSubview:_littleCattleView];

  _indicatorView.hidden = YES;
  [_topToolBar resetContentAndFlage:@"实盘开户转户" Mode:TTBM_Mode_Leveltwo];
  //右侧承载页面
  _datailView = [[UIView alloc]
      initWithFrame:CGRectMake(60.0f, 0,
                               CGRectGetWidth(_clientView.bounds) - 60.0f,
                               CGRectGetHeight(_clientView.bounds))];
  _datailView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  [self.clientView addSubview:_datailView];

  //创建客服电话
  [[CutomerServiceButton shareDataCenter]
      establisthCustomerServiceTelephonetopToolBar:_topToolBar
                                     indicatorView:_indicatorView
                                              hide:YES];

  //右侧 券商简介页面
  [self createBrokerStockBriefIntroduction];
  //创建券商列表
  [self createOpenAccount];
  
  //判断网络情况
  [self judgeNetWorkSituation];
}

#pragma makr - 创建券商列表j
- (void)createOpenAccount {
  self.brokerNameTableView = [[BrokerNameListTableView alloc]
      initWithNibName:@"BrokerNameListTableView"
               bundle:nil
           withStirng:BrokerOpenAccount];
  __weak BrokerageAccountListVC *weakSelf = self;
  self.brokerNameTableView.brokerCompanyListBlock =
  ^(RealTradeSecuritiesCompany *company, BrokerOpenLogin openLogin,
    NSDictionary *dic, BrokersDownloadType brokerType) {
    if (openLogin == BrokerOpenAccount) {
      [weakSelf.openAccountVC getBrokerSetNo:dic
                         withBrokerSetNoType:brokerType];
      [weakSelf.openAccountVC refreshOpenAccountInfo:company];
    }
  };
  self.brokerNameTableView.failedOrErrorBlock = ^(){
    weakSelf.openAccountVC.noDataOrNoCache = NO;
  };
  CGRect frame = CGRectMake(0, 0, 60.0f, CGRectGetHeight(_clientView.bounds));
  self.brokerNameTableView.tableView.frame = frame;
  [self.clientView addSubview:self.brokerNameTableView.tableView];
  [self addChildViewController:self.brokerNameTableView];
  [self.brokerNameTableView getStockAccountsCompanyList];
  
}
#pragma makr - 创建券商简介
- (void)createBrokerStockBriefIntroduction {
  if (!self.openAccountVC) {
    self.openAccountVC = [[OpenAccountViewController alloc] init];
    CGRect frame =
        CGRectMake(CGRectGetMaxX(_brokerNameTableView.tableView.frame), 0,
                   CGRectGetWidth(_clientView.bounds) -
                       CGRectGetWidth(_brokerNameTableView.tableView.bounds),
                   CGRectGetHeight(_clientView.bounds));
    self.openAccountVC.view.frame = frame;
    [_datailView addSubview:self.openAccountVC.view];
    [self addChildViewController:self.openAccountVC];
  } else {
    [self.clientView bringSubviewToFront:self.openAccountVC.view];
  }
}
#pragma mark-- 判断网络情况 显示小牛
- (void)judgeNetWorkSituation {
  //无网情况
  if (![SimuUtil isExistNetwork]) {
    //看看数据
    [NewShowLabel showNoNetworkTip];
    if (!self.brokerNameTableView.stockListsArray.dataBinded) {
      _datailView.hidden = YES;
      self.brokerNameTableView.tableView.hidden = YES;
      [_littleCattleView isCry:YES];
    } else {
      _datailView.hidden = NO;
      self.brokerNameTableView.tableView.hidden = NO;
      _littleCattleView.hidden = YES;
    }
  }
}

@end
