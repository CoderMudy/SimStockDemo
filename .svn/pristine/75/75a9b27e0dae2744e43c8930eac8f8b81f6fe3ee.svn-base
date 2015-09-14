//
//  simuMarchCounterVC.m
//  SimuStock
//
//  Created by Mac on 14-7-28.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "simuMarchCounterVC.h"

@implementation simuMarchCounterVC

- (id)init:(NSString *)marchId name:(NSString *)name userListItemMatch:(UserListItemMatch *)item {
  if (self = [super init]) {
    NSString *uid = item.userID;
    NSString *userName = item.userName;
    _marchid = (!marchId ? @"" : marchId);
    _name = (!name ? @"炒股比赛" : name);
    _userid = (!uid ? @"" : uid);
    _username = (!userName ? @"" : userName);
  }
  return self;
}
- (id)init:(NSString *)marchId
                   name:(NSString *)name
    schoolListMatchItem:(SimuSchoolMatchItem *)item {

  if (self = [super init]) {
    NSString *uid = item.uid;
    NSString *userName = item.personalName;
    _marchid = (!marchId ? @"" : marchId);
    _name = (!name ? @"炒股比赛" : name);
    _userid = (!uid ? @"" : uid);
    _username = (!userName ? @"" : userName);
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [_topToolBar resetContentAndFlage:_name Mode:TTBM_Mode_Leveltwo];
  _indicatorView.hidden = NO;

  //创建下导航栏
  [self creatbottomToolBar];
  //创建用户主账户
  [self creatACountVC];
}

#pragma mark
#pragma mark 创建各个控件

//参加比赛下工具栏控件
- (void)creatbottomToolBar {
  simumarchToolBarView *bottomToolBar =
      [[simumarchToolBarView alloc] initWithFrame:CGRectMake(0, _clientView.bounds.size.height - BOTTOM_TOOL_BAR_HEIGHT,
                                                             _clientView.bounds.size.width, BOTTOM_TOOL_BAR_HEIGHT)];
  bottomToolBar.delegate = self;
  [_clientView addSubview:bottomToolBar];
}

//创建账户主页
- (void)creatACountVC {
  if (_userContVC == nil) {
    CGRect frame = CGRectMake(0, 0, _clientView.width, _clientView.height - BOTTOM_TOOL_BAR_HEIGHT);
    _userContVC = [[SimuACountVC alloc] initWithFrame:frame
                                          withMatchId:_marchid
                                           withUserID:_userid
                                         withUserName:_username];
    __weak simuMarchCounterVC *weakSelf = self;
    _userContVC.beginRefreshCallBack = ^{
      [weakSelf.indicatorView startAnimating];
    };
    _userContVC.endRefreshCallBack = ^{
      [weakSelf.indicatorView stopAnimating];
    };
  }
  [self addChildViewController:_userContVC];
  [_clientView addSubview:_userContVC.view];
  if (!_userContVC.dataBinded) {
    [_userContVC refreshButtonPressDown];
  }
  currentVC = _userContVC;
}

//创建或激活交易明细
- (void)creatOrMillionDetailVC {
  if (stockTradeTableVC == nil) {
    CGRect frame = CGRectMake(0, 0, _clientView.width, _clientView.height - BOTTOM_TOOL_BAR_HEIGHT);
    stockTradeTableVC = [[StockTradeTableViewController alloc] initWithFrame:frame
                                                                  withUserId:_userid
                                                                withUserName:_name
                                                                 withMatckId:_marchid];
    __weak simuMarchCounterVC *weakSelf = self;
    stockTradeTableVC.beginRefreshCallBack = ^{
      [weakSelf.indicatorView startAnimating];
    };
    stockTradeTableVC.endRefreshCallBack = ^{
      [weakSelf.indicatorView stopAnimating];
    };
  }

  [_clientView addSubview:stockTradeTableVC.view];
  [self addChildViewController:stockTradeTableVC];
  if (!stockTradeTableVC.dataBinded) {
    [stockTradeTableVC refreshButtonPressDown];
  }
  currentVC = stockTradeTableVC;
}
//创建或激活历史持仓
- (void)creatOrMillionPositionVC {
  if (historyPositionsVC == nil) {
    CGRect frame = CGRectMake(0, 0, _clientView.width, _clientView.height - BOTTOM_TOOL_BAR_HEIGHT);
    historyPositionsVC = [[ClosedPositionViewController alloc] initWithFrame:frame
                                                                  withUserId:_userid
                                                                 withMatckId:_marchid];
    __weak simuMarchCounterVC *weakSelf = self;
    historyPositionsVC.beginRefreshCallBack = ^{
      [weakSelf.indicatorView startAnimating];
    };
    historyPositionsVC.endRefreshCallBack = ^{
      [weakSelf.indicatorView stopAnimating];
    };
  }
  [self addChildViewController:historyPositionsVC];
  [_clientView addSubview:historyPositionsVC.view];
  [historyPositionsVC.littleCattleView setInformation:@"暂无历史持仓"];
  if (!historyPositionsVC.dataBinded) {
    [historyPositionsVC refreshButtonPressDown];
  }
  currentVC = historyPositionsVC;
}
#pragma mark
#pragma mark--底部按钮点击回调 simuBottomToolBarViewDelegate------
//底部按钮点击
- (void)bottomButtonPressDown:(NSInteger)index {
  if (currentVC) {
    [currentVC removeFromParentViewController];
    [currentVC.view removeFromSuperview];
  }
  switch (index) {
  case 0: {
    //账户持仓
    [self creatACountVC];
    break;
  }
  case 1: {
    //交易明细
    [self creatOrMillionDetailVC];
    break;
  }
  case 2: {
    //历史持仓
    [self creatOrMillionPositionVC];
    break;
  }

  default:
    break;
  }
}

- (void)refreshButtonPressDown {
  if (currentVC == _userContVC) {
    [_userContVC refreshButtonPressDown];
  } else if (currentVC == stockTradeTableVC) {
    [stockTradeTableVC refreshButtonPressDown];
  } else if (currentVC == historyPositionsVC) {
    [historyPositionsVC refreshButtonPressDown];
  }
}

@end
