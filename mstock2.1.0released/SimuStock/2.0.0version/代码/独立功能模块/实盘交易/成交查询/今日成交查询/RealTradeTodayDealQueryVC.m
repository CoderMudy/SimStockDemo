//
//  RealTradeTodayDealVC.m
//  SimuStock
//
//  Created by Mac on 14-9-24.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "RealTradeTodayDealQueryVC.h"

@interface RealTradeTodayDealQueryVC () {
  //判断从哪个界面跳转过来的
  BOOL _judgingFromWhatInterface;

  //用来判定数据有没有绑定
  BOOL _dataBind;
}
@end
@implementation RealTradeTodayDealQueryVC

- (id)initWithBool:(BOOL)isEnd {
  self = [super init];
  if (self) {
    _judgingFromWhatInterface = isEnd;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  //初始化
  _dataBind = NO;

  [self creatControlerViews];
  [_littleCattleView setInformation:@"暂无今日成交"];
  [self performSelector:@selector(getInitDataFromNet) withObject:nil afterDelay:0.3];
}

#pragma mark
#pragma mark 创建控件
- (void)creatControlerViews {
  [self resetTopToolBarView];
  [self creatTableViews];
}

//创建表格
- (void)creatTableViews {
  //创建表格
  sqv_TableView =
      [[SimuTableView alloc] initWithFrame:CGRectMake(0, _topToolBar.frame.size.height, self.view.bounds.size.width,
                                                      self.view.bounds.size.height - _topToolBar.frame.size.height)];
  [self.view addSubview:sqv_TableView];
  // sqv_TableView.hidden = YES;

  //创建表格数据源
  sqv_tableViewDataResouce = [[SimuTableDataResouce alloc] initWithIdentifier:@"今日成交"];
}

//创建上导航栏控件
- (void)resetTopToolBarView {
  [_topToolBar resetContentAndFlage:@"今日成交" Mode:TTBM_Mode_Leveltwo];
}

#pragma mark
#pragma mark 协议回调函数
// SimuIndicatorDelegate
- (void)refreshButtonPressDown {
  [self getInitDataFromNet];
}

//没网的情况下
- (void)setNoNetworkStatus {
  [NewShowLabel showNoNetworkTip];
  if (self.dataBinded) {
    _littleCattleView.hidden = YES;
  } else {
    [_littleCattleView isCry:YES];
    sqv_TableView.dataResource = sqv_tableViewDataResouce;
    [sqv_TableView resetTable];
    // sqv_TableView.hidden = YES;
  }
}

#pragma mark
#pragma mark 网络函数
//从网络上下载今日成交数据
- (void)getInitDataFromNet {

  if (_judgingFromWhatInterface == YES) {
    //实盘界面 执行这个方法
    [self requestTodayDataWithTransaction];
  } else {
    //优顾实盘界面 执行这个方法
    [self requestCapitalTodayDataWithTransaction];
  }
}
#pragma mark-- 请求 今天成交数据 -- 实盘界面
- (void)requestTodayDataWithTransaction {
  [_indicatorView startAnimating];

  if (![SimuUtil isExistNetwork]) {
    [self setNoNetworkStatus];
    [_indicatorView stopAnimating];
    return;
  }
  __weak RealTradeTodayDealQueryVC *myself = self;
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  callback.onCheckQuitOrStopProgressBar = ^{
    RealTradeTodayDealQueryVC *strongSelf = myself;
    if (strongSelf) {
      [strongSelf.indicatorView stopAnimating];
      return NO;
    } else {
      return YES;
    }
  };
  callback.onSuccess = ^(NSObject *obj) {
    RealTradeTodayDealQueryVC *strongSelf = myself;
    if (strongSelf) {
      RealTradeDealList *result = (RealTradeDealList *)obj;
      if (result) {
        [strongSelf bindDealList:result withCapitalBool:YES];
      }
    }
  };
  callback.onFailed = ^() {
    [myself setNoNetworkStatus];
  };
  [RealTradeDealList loadTodayDealListWithCallback:callback];
}

#pragma mark-- 优顾实盘界面 配资界面
- (void)requestCapitalTodayDataWithTransaction {
  [_indicatorView startAnimating];

  if (![SimuUtil isExistNetwork]) {
    [self setNoNetworkStatus];
    [_indicatorView stopAnimating];
    return;
  }

  __weak RealTradeTodayDealQueryVC *weakRSelf = self;
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  callback.onCheckQuitOrStopProgressBar = ^() {
    RealTradeTodayDealQueryVC *realStrongSelf = weakRSelf;
    if (realStrongSelf) {
      [realStrongSelf.indicatorView stopAnimating];
      return NO;
    } else {
      return YES;
    }
  };
  callback.onSuccess = ^(NSObject *obj) {
    WFTodayJosnData *todayData = (WFTodayJosnData *)obj;
    //绑定数据
    RealTradeTodayDealQueryVC *strongSelf = weakRSelf;
    if (strongSelf) {
      RealTradeDealList *result = (RealTradeDealList *)obj;
      if (result) {
        [strongSelf bindDealList:todayData withCapitalBool:NO];
      }
    }
  };
  callback.onFailed = ^() {
    [weakRSelf setNoNetworkStatus];
  };

  [WFTodayTransactionData requestTodayTransactionDataWithCallback:callback];
}

#pragma mark - 绑定数据
- (void)bindDealList:(NSObject *)result withCapitalBool:(BOOL)isCapital {
  self.dataBinded = YES;
  RealTradeDealList *realList = nil;
  WFTodayJosnData *todayData = nil;
  if (isCapital) {
    realList = (RealTradeDealList *)result;
    if ([realList.list count] == 0) {
      [_littleCattleView isCry:NO];
    } else {
      _littleCattleView.hidden = YES;
    }
    sqv_TableView.hidden = NO;
    [sqv_tableViewDataResouce resetDealList:realList withBool:isCapital];
  } else {
    todayData = (WFTodayJosnData *)result;
    if ([todayData.todayDataMutableArray count] == 0) {
      [_littleCattleView isCry:NO];
      // sqv_TableView.userInteractionEnabled = NO;
    } else {
      _littleCattleView.hidden = YES;
      // sqv_TableView.userInteractionEnabled = YES;
    }
    // sqv_TableView.hidden = NO;
    [sqv_tableViewDataResouce resetDealList:todayData withBool:isCapital];
  }
  sqv_TableView.dataResource = sqv_tableViewDataResouce;
  [sqv_TableView resetTable];
}

@end
