
//
//  HomepageViewController.m
//  SimuStock
//
//  Created by moulin wang on 14-5-21.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "StockPersonTransactionViewController.h"
#import "HomepageViewController.h"

#import "SimuTouchMoveView.h"

#import "StockTradeList.h"

#import "MoreSelectedView.h"
#import "EPPexpertPlanViewController.h"
#import "AttentionEventObserver.h"

#import "ChatStockPageTVCell.h"

@interface HomepageViewController () {
  AttentionEventObserver *attentionEventObserver;
}

///交易数
@property(nonatomic, assign) NSInteger tradeNum;
///聊股信息条数
@property(nonatomic, assign) NSInteger shareNumber;
///刷新判断
@property(nonatomic) BOOL refreshbool;

@end

@implementation HomepageViewController

- (id)initUserId:(NSString *)userId titleName:(NSString *)titleName matchID:(NSString *)matchID {
  if (self = [super init]) {
    self.userId = userId;
    self.titleName = titleName;
    self.matchID = matchID;
  }
  return self;
}

+ (void)showWithUserId:(NSString *)userId
             titleName:(NSString *)nickname
               matchId:(NSString *)matchId {
  if (!userId) {
    NSLog(@"invalid userId = nil");
    return;
  }
  HomepageViewController *viewController =
      [[HomepageViewController alloc] initUserId:userId titleName:nickname matchID:MATCHID];
  [AppDelegate pushViewControllerFromRight:viewController];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.tableHeaderData = [[HomePageTableHeaderData alloc] init];
  self.tableHeaderData.matchID = self.matchID;
  //分享的数量
  self.shareNumber = 0;

  //设置标题
  [self navigationTopToolView];
  //创建菊花
  [self resetIndicatorView];
  //李群分享
  [self createShareControl];
  [self createMoreSelectedFloatView];
  //关注状态观察者
  [self addObserWithMyAttention];

  [self creatChatStockTableView];
  //⭐️刷新并请求数据
  [self refreshButtonPressDown];

  //手动侧滑页面
  if (self.jumpBool) {
    [self creatTouchView];
  }
  [self updateTableHeaderView];
}
//创建聊股列表
- (void)creatChatStockTableView {
  if (tableVC == nil) {
    tableVC = [[HomePageChatStockTableVC alloc] initWithFrame:self.clientView.frame];
    tableVC.scrollViewdelegate = self;
    tableVC.clientView = self.clientView;
    tableVC.userID = self.userId;

    __weak HomepageViewController *weakSelf = self;
    tableVC.showTableFooter = YES;
    tableVC.beginRefreshCallBack = ^{
      [weakSelf.indicatorView startAnimating];
    };

    tableVC.endRefreshCallBack = ^{
      [weakSelf.indicatorView stopAnimating];
    };
  }
  [self addChildViewController:tableVC];
  [self.view addSubview:tableVC.view];
  if (!tableVC.dataBinded) {
    [tableVC refreshButtonPressDown];
  }
}

- (void)updateTableHeaderView {
  tableVC.tableView.tableHeaderView = self.tableHeadView;
}

//导航视图
- (void)navigationTopToolView {
  NSString *flage = @"我的主页";
  NSString *userID = [SimuUtil getUserID];
  NSString *userStr = [NSString stringWithFormat:@"%@", self.userId];
  if ([userStr isEqualToString:userID]) {
    _isSelf = YES;
  } else {
    flage = @"TA的主页";
  }
  if (_topToolBar) {
    [_topToolBar resetContentAndFlage:flage Mode:TTBM_Mode_Leveltwo];
  }
}
//创建联网指示器
- (void)resetIndicatorView {
  if (_indicatorView) {
    _indicatorView.frame =
        CGRectMake(self.view.bounds.size.width - 80, _topToolBar.bounds.size.height - 45, 40, 45);
  }
}
#pragma mark 背景图拉伸距离
/** HomePageChatStockTVCProtocol代理方法的实现 */
- (void)homePageChatStockTableViewDidScroll:(UIScrollView *)scrollView {
  tableVC.headerView.hidden = YES;
  /// 保留上次坐标
  static CGFloat contentOffsetY = 0.0f;
  static NSInteger MAXsetY = 0.0f;
  if (scrollView.contentOffset.y < 0.0f) {
    self.tableHeaderView.userInfoView.stretchImage.frame =
        CGRectMake(scrollView.contentOffset.y, scrollView.contentOffset.y,
                   WIDTH_OF_SCREEN - scrollView.contentOffset.y * 2, 163.5f - scrollView.contentOffset.y);
  }
  if ((NSInteger)scrollView.contentOffset.y == 0 && contentOffsetY < scrollView.contentOffset.y &&
      (NSInteger)contentOffsetY != 0 && MAXsetY == 65) {
    contentOffsetY = 0.0f;
    MAXsetY = 0;
    if (![_indicatorView isAnimating]) {
      [self refreshButtonPressDown];
    }
  }
  if (scrollView.contentOffset.y < -65.0f && ![_indicatorView isAnimating]) {
    MAXsetY = 65;
  }
  contentOffsetY = scrollView.contentOffset.y;
}
- (void)questUserTradeGradeItem {
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak HomepageViewController *weakSelf = self;

  callback.onSuccess = ^(NSObject *obj) {
    __weak HomepageViewController *strongSelf = weakSelf;
    if (strongSelf) {
      UserTradeGradeItem *userTradeItem = (UserTradeGradeItem *)obj;
      [strongSelf bindUserTradeGradeInfoWithItem:userTradeItem];
    }
  };
  callback.onFailed = ^() {
    NSLog(@"用户交易评级信息请求失败！");
  };
  [UserTradeGradeItem requestUserTradeGradeItemWithUID:_userId withCallback:callback];
}
#pragma mark 用户交易评级控件生成及数据绑定
- (void)bindUserTradeGradeInfoWithItem:(UserTradeGradeItem *)userTradeItem {
  self.tableHeaderData.tradeGradeItem = userTradeItem;
  [self.tableHeaderPresentation refreshTableHeaderInfoData:self.tableHeaderData];
  self.tableHeaderView.frame =
      CGRectMake(0, 0, WIDTH_OF_SCREEN, [self.tableHeaderPresentation returnTheHeaderHeight]);
  [self updateTableHeaderView];
}
- (UIView *)tableHeadView {
  if (self.tableHeaderView == nil) {
    self.tableHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"HomePageTableHeaderView"
                                                          owner:self
                                                        options:nil] lastObject];
    if (self.isSelf) {
      self.tableHeaderPresentation =
          [[HomePageUserPersonalView alloc] initWithTableHeaderView:self.tableHeaderView
                                                withTableHeaderData:self.tableHeaderData];
    } else {
      self.tableHeaderPresentation =
          [[HomePageUserOthersView alloc] initWithTableHeaderView:self.tableHeaderView
                                              withTableHeaderData:self.tableHeaderData];
    }
  }
  UIView *headerView = [[UIView alloc] initWithFrame:self.tableHeaderView.frame];
  [self.tableHeaderView removeFromSuperview];
  [headerView addSubview:self.tableHeaderView];
  return headerView;
}
#pragma mark UIAlertView ***提示框视图***
- (void)showAlert:(NSString *)message {
  _alertbrackView = [[UIView alloc] initWithFrame:self.view.bounds];
  _alertbrackView.backgroundColor = [UIColor clearColor];
  [self.view addSubview:_alertbrackView];
  UIView *alertView =
      [[UIView alloc] initWithFrame:CGRectMake((_alertbrackView.bounds.size.width - 260.0f) / 2,
                                               (_alertbrackView.bounds.size.height - 60.0f) / 2, 260.0f, 60.0f)];
  alertView.backgroundColor = [[Globle colorFromHexRGB:@"#cccccc"] colorWithAlphaComponent:0.75];
  [alertView.layer setMasksToBounds:YES];
  alertView.layer.cornerRadius = 6.0f;
  [_alertbrackView addSubview:alertView];
  UILabel *alertLab = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, (60.0f - 32.0f) / 2, 250.0f, 32.0f)];
  alertLab.font = [UIFont boldSystemFontOfSize:Font_Height_14_0];
  alertLab.textAlignment = NSTextAlignmentCenter;
  alertLab.text = message;
  alertLab.backgroundColor = [UIColor clearColor];
  alertLab.numberOfLines = 0;
  [alertView addSubview:alertLab];
  [self performSelector:@selector(dimissAlert:) withObject:nil afterDelay:2.0f];
}
- (void)dimissAlert:(UIAlertView *)alert {
  if (_alertbrackView) {
    [_alertbrackView removeFromSuperview];
  }
}
- (void)stopLoading {
  [_indicatorView stopAnimating]; //停止菊花
}
///请求headerView的网络数据
- (void)requestHostData {
  __weak HomepageViewController *weakSelf = self;
  if (self.matchID && self.userId) {
    //判断是否有headerView的楼主信息
    [self queryUserAccountInformationInterfacesAuserId:self.userId
                                               matchID:self.matchID
                                             withBlock:^(BOOL isReqSuccess) {
                                               HomepageViewController *strongSelf = weakSelf;
                                               if (strongSelf) {
                                                 [strongSelf gethomeTableDataOnSuccess:isReqSuccess];
                                               }
                                             }];
  }
}
- (void)gethomeTableDataOnSuccess:(BOOL)isReqSuccess {
  if (isReqSuccess) {
    //交易评级信息
    [self questUserTradeGradeItem];
    //个人盈利排行，只存储数据，不与UI绑定
    [self getPersonalTopAuserId:self.userId matchID:self.matchID];
  } else {
    [NewShowLabel showNoNetworkTip];
  }
}
//获取个人排行
- (void)getPersonalTopAuserId:(NSString *)userId matchID:(NSString *)matchID {

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak HomepageViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    HomepageViewController *strongSelf = weakSelf;
    if (strongSelf) {
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    HomepageViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindRankInfo:(SimuRankPageData *)obj];
    }
  };
  [SimuRankPageData requestRankInfoWithUser:userId withMatchId:matchID withCallback:callback];
}
- (void)bindRankInfo:(SimuRankPageData *)rankingData {
  self.tableHeaderData.rankData = rankingData;
  [self.tableHeaderPresentation refreshTableHeaderInfoData:self.tableHeaderData];
  self.tableHeaderView.frame =
      CGRectMake(0, 0, WIDTH_OF_SCREEN, [self.tableHeaderPresentation returnTheHeaderHeight]);
  [self updateTableHeaderView];
}

#pragma mark 请求用户信息
- (void)queryUserAccountInformationInterfacesAuserId:(NSString *)userId
                                             matchID:(NSString *)matchID
                                           withBlock:(homePageTableOnSuccess)block {
  [_indicatorView startAnimating];
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak HomepageViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    HomepageViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf stopLoading];
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    HomepageViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindHomeUserInformationData:(HomeUserInformationData *)obj];
      if (block) {
        block(YES);
      }
    }
  };
  callback.onError = ^(BaseRequestObject *error, NSException *ex) {
    if (block) {
      block(NO);
    }
  };
  callback.onFailed = ^{
    [BaseRequester defaultFailedHandler]();
    if (block) {
      block(NO);
    }
  };
  [HomeUserInformationData requestUserInfoWithUid:userId withCallback:callback];
}

#pragma mark - ⭐️绑定个人重要信息，重设坐标，请求交易评级，
- (void)bindHomeUserInformationData:(HomeUserInformationData *)informationData {
  self.tableHeaderData.userInfoData = informationData;
  //牛人计划
  self.isShowSuper = informationData.isShowSuper;
  self.accountId = informationData.accountId;

  self.tradeNum = informationData.tradeNum;
  //获取完整交易统计信息
  [self getForCompleteTradeStatisticsAuserId:self.userId matchID:self.matchID];
  [self.tableHeaderPresentation refreshTableHeaderInfoData:self.tableHeaderData];
  self.tableHeaderView.frame =
      CGRectMake(0, 0, WIDTH_OF_SCREEN, [self.tableHeaderPresentation returnTheHeaderHeight]);
  [self updateTableHeaderView];
}

#pragma mark 获取完整交易统计
- (void)getForCompleteTradeStatisticsAuserId:(NSString *)userId matchID:(NSString *)matchID {
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak HomepageViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    HomepageViewController *strongSelf = weakSelf;
    if (strongSelf) {
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    HomeTradeInfoInfo *tradeInfo = (HomeTradeInfoInfo *)obj;
    if (tradeInfo) {
      TradeStatisticsData *statisticsData = tradeInfo.dataArray[0];
      self.tableHeaderData.tradeData = statisticsData;
    }
  };
  [HomeTradeInfoInfo getForCompleteTradeStatisticsAuserId:userId
                                                  matchID:matchID
                                             withCallback:callback];
}
#pragma mark-------SimuIndicatorDelegate-----------
- (void)refreshButtonPressDown {
  [_indicatorView startAnimating];
  if (![SimuUtil isExistNetwork]) {
    [self.indicatorView stopAnimating];
    [NewShowLabel showNoNetworkTip];
    return;
  }
  [self requestHostData];
  [tableVC refreshButtonPressDown];
}
#pragma mark-------牛人计划--------
- (void)pushToSuperPlanVC {
  EPPexpertPlanViewController *vc = [[EPPexpertPlanViewController alloc] initAccountId:self.accountId
                                                                         withTargetUid:self.userId
                                                                         withTitleName:@""];
  [AppDelegate pushViewControllerFromRight:vc];
}

//创建侧滑控件
- (void)creatTouchView {
  _stmv_touchView =
      [[SimuTouchMoveView alloc] initWithFrame:CGRectOffset(self.view.bounds, 0, HEIGHT_OF_NAVIGATIONBAR)];
  [self.view addSubview:_stmv_touchView];
  _stmv_touchView.hidden = YES;
}
#pragma mark------分享部分------------------------
// lq分享控件
- (void)createShareControl {
  CGRect frame = self.view.frame;
  UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
  shareButton.frame = CGRectMake(frame.size.width - 43, _topToolBar.bounds.size.height - 45, 44, 45);
  UIImage *shareImage = [UIImage imageNamed:@"MoreLogo"];
  [shareButton setImage:shareImage forState:UIControlStateNormal];
  [shareButton setImage:shareImage forState:UIControlStateHighlighted];
  [shareButton setBackgroundImage:nil forState:UIControlStateNormal];
  //按钮选中中视图
  UIImage *mtvc_centerImage =
      [[UIImage imageNamed:@"return_touch_down.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(14, 14, 14, 14)];
  [shareButton setBackgroundImage:mtvc_centerImage forState:UIControlStateHighlighted];
  [shareButton addTarget:self
                  action:@selector(showMoreSelectedView)
        forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:shareButton];
}

- (void)showMoreSelectedView {
  _moreSelectedView.hidden = NO;
  _moreSelectedView.width = WIDTH_OF_SCREEN;
  [_moreSelectedView reloadTableViewWithQuerySelfStockData:self.isShowSuper];
  [self.view bringSubviewToFront:self.moreSelectedView];
}

- (void)createMoreSelectedFloatView {
  _moreSelectedView =
      [[[NSBundle mainBundle] loadNibNamed:@"MoreSelectedView" owner:self options:nil] firstObject];
  _moreSelectedView.hidden = YES;
  _moreSelectedView.layer.masksToBounds = YES;
  [_moreSelectedView reloadTableViewWithQuerySelfStockData:self.isShowSuper];
  __weak HomepageViewController *weakSelf = self;
  _moreSelectedView.sharePressCallBack = ^() {
    [weakSelf shareUserInfo];
  };
  _moreSelectedView.pushToSuperPlanVCCallBack = ^() {
    [weakSelf pushToSuperPlanVC];
  };
  [WINDOW addSubview:_moreSelectedView];
}

- (void)shareUserInfo {
  //判断有没有网络
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }
  //未登录
  NSString *selfUserID = [SimuUtil getUserID];
  if ([selfUserID isEqualToString:_userId]) {
    //自己主页
    //截屏
    _makingScreenShot = [[MakingScreenShot alloc] init];
    //分享
    UIImage *shareImage = [_makingScreenShot makingScreenShotWithFrame:self.tableHeaderView.frame
                                                              withView:self.tableHeaderView
                                                              withType:MakingScreenShotType_HomePage];
    if (_tableHeaderData) {
      _endProfitRate = _tableHeaderData.userInfoData.profitRate;
      _userRanking = _tableHeaderData.rankData.tRank;
    }
    if (shareImage) {
      _shareAction = [[MakingShareAction alloc] init];
      _shareAction.shareModuleType = ShareModuleTypeHomePage;
      _shareAction.shareUserID = selfUserID;
      NSString *userInfoShareUrl =
          [NSString stringWithFormat:@"%@/wap/personal.shtml?uid=%@&mid=%@", wap_address, _userId, self.matchID];
      //分享内容加在otherInfo中
      [_shareAction shareTitle:@"分享"
                       content:[NSString stringWithFormat:@"#优顾炒股# "
                                                          @"%@/wap/personal.shtml?uid=%@&mid=%@ " @"(分享自@优顾炒股官方)",
                                                          wap_address, _userId, self.matchID]
                         image:shareImage
                withOtherImage:nil
                  withShareUrl:userInfoShareUrl
                 withOtherInfo:[NSString stringWithFormat:@"【%@" @"】在优顾炒股的总盈利" @"率为%@%%，排名【%@】",
                                                          [SimuUtil getUserNickName], _endProfitRate, _userRanking]];
    }
  } else {
    //他人主页
    //截屏
    _makingScreenShot = [[MakingScreenShot alloc] init];
    NSString *userInfoUrl =
        [NSString stringWithFormat:@"%@/wap/personal.shtml?uid=%@&mid=%@ ", wap_address, _userId, self.matchID];
    //分享
    UIImage *shareImage = [_makingScreenShot makingScreenShotWithFrame:self.tableHeaderView.frame
                                                              withView:self.tableHeaderView
                                                              withType:MakingScreenShotType_HomePage];
    if (shareImage) {
      _shareAction = [[MakingShareAction alloc] init];
      _shareAction.shareModuleType = ShareModuleTypeHomePage;
      _shareAction.shareUserID = _userId;
      [_shareAction shareTitle:@"分享"
                       content:[NSString stringWithFormat:@"#优顾炒股# "
                                                          @"%@/wap/personal.shtml?uid=%@&mid=%@ " @"(分享自@优顾炒股官方)",
                                                          wap_address, _userId, self.matchID]
                         image:shareImage
                withOtherImage:nil
                  withShareUrl:userInfoUrl
                 withOtherInfo:[NSString stringWithFormat:@"【%@" @"】在优顾炒股的总盈利" @"率为%@%%，排名【%@】",
                                                          self.titleName, _endProfitRate, _userRanking]];
    }
  }
}
//个人主页信息请求数据
- (void)shareRefreshMethod:(NSInteger)row {
  ChatStockPageTVCell *cell = (ChatStockPageTVCell *)
      [tableVC.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
  if ([cell.shareBtn.titleLabel.text isEqualToString:@"分享"]) {
    cell.shareBtn.titleLabel.text = @"1";
  } else {
    NSInteger shareInt = [cell.shareBtn.titleLabel.text integerValue];
    shareInt += 1;
    cell.shareBtn.titleLabel.text = [NSString stringWithFormat:@"%ld", (long)shareInt];
  }
}

#pragma mark------分享统计_回传-----
- (void)refreshShareNumber {
  //取得所选的股票代码
  TweetListItem *homeData = tableVC.dataArray.array[_tempRow];
  NSString *url = istock_address;
  NSString *real_url = nil;
  if ([[SimuUtil getUserID] isEqualToString:@"-1"]) {
    real_url =
        [url stringByAppendingFormat:@"istock/talkstock/share/%@/%@/%@/%@", [SimuUtil getAK], @"-1", @"-1", homeData.tstockid];
  } else {
    real_url = [url stringByAppendingFormat:@"istock/talkstock/share/%@/%@/%@/%@", [SimuUtil getAK],
                                            [SimuUtil getSesionID], [SimuUtil getUserID], homeData.tstockid];
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak HomepageViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    HomepageViewController *strongSelf = weakSelf;
    if (strongSelf) {
      //[strongSelf.indicatorView stopAnimating];
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    ShareInfo *tradeInfo = (ShareInfo *)obj;
    if (tradeInfo) {
      [self shareRefreshMethod:_tempRow];
    }
  };
  callback.onFailed = ^() {
    NSLog(@"onfailed");
  };
  callback.onError = ^(BaseRequestObject *error, NSException *ex) {
    NSLog(@"onerror");
  };
  [ShareInfo refreshShareNumber:real_url withCallback:callback];
}

#pragma mark------观察者部分------------------------
/** 注册观察者 */
- (void)addObserWithMyAttention {
  _userInfoNotificationUtil = [[UserInfoNotificationUtil alloc] init];
  __weak HomepageViewController *weakSelf = self;
  OnUserInfoChanging action = ^{
    if ([weakSelf.userId isEqualToString:[SimuUtil getUserID]]) {
    }
  };
  _userInfoNotificationUtil.onNicknameChangeAction = action;
  _userInfoNotificationUtil.onHeadPicChangeAction = action;
  _userInfoNotificationUtil.onSignatureChangeAction = action;
}
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
  if ([change[@"old"] isEqualToString:change[@"new"]]) {
    return;
  }

  NSString *selfStatus = [NSString stringWithFormat:@"attentionStatus_%@", self.userId];
  if ([keyPath isEqualToString:selfStatus]) {
    //关注个数发生变化
  }
}

@end
