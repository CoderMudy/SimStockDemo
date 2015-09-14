//
//  SimuMainViewController.m
//  SimuStock
//
//  Created by Mac on 14-7-8.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "SimuMainViewController.h"
#import "SimuUtil.h"
#import "SimuTopToolBarView.h"
#import "SimuBottomToolBarView.h"
#import "MarketHomeContainerVC.h"
#import "SimuUserConterViewController.h"
#import "StockMasterViewController.h"
#import "StockMatchViewController.h"
#import "StockSearchViewController.h"
#import "SearchMatchesViewController.h"
#import "StockFriendsViewController.h"
#import "StockBarsViewController.h"
#import "MessageCenterViewController.h"
#import "PortfolioStockModel.h"
#import "NetLoadingWaitView.h"
/** 测试类 */
#import "ExpertViewController.h"
#import "ExpertScreenViewController.h"

@interface SimuMainViewController () <simuBottomToolBarViewDelegate, UIGestureRecognizerDelegate, SimuTopToolBarDelegate,
                                      simuUserConterViewControllerDelegate, SimuCoverDelegate> {

  ///当前页面的子页面
  NSMutableDictionary *_viewControllerDic;
  ///子页面搜索区显示的文字
  NSMutableDictionary *_searchTitleDic;
  //显示区域
  CGRect _clientRect;
  //基本承载页面(视图都建立在承载页面上)
  UIView *_baseView;
  //顶部导航栏
  SimuTopToolBarView *_topToolBarView;
  //底部导航
  SimuBottomToolBarView *_bottomToolBarView;
  //当前使用页面，灰色最底层页面
  UIView *_currentView;
  //登录页面，灰色最底层页面
  UIView *_userInfoView;
  //未登录页面，灰色最底层页面
  UIView *_loginView;
  //创建搜索框视图
  UIView *_searchBoxView;
  // ios 适配高度
  float _stateBarHeight;
}

@end

@implementation SimuMainViewController

///搜索框的left
static CGFloat SearchBoxLeft = 49.f;

///登录后，搜索框距右边界的距离
static CGFloat SearchBoxRightGapLogined = 90.f; // 91.f;

///未登录后，搜索框距右边界的距离
static CGFloat SearchBoxRightGapNotLogined = 49.f;

- (id)init {
  if (self = [super init]) {
    _viewControllerDic = [[NSMutableDictionary alloc] init];
    _searchTitleDic = [@{
      @0 : @"搜股票",
      @1 : @"搜牛人",
      @2 : @"搜股票",
      @3 : @"搜比赛",
      @4 : @"搜股票"
    } mutableCopy];
  }
  return self;
}

- (void)viewDidLayoutSubviews {
  NSLog(@"SimuMainViewController ");
  _bottomToolBarView.frame = CGRectMake(0, self.view.bounds.size.height - BOTTOM_TOOL_BAR_HEIGHT,
                                        self.view.bounds.size.width, BOTTOM_TOOL_BAR_HEIGHT);
  _clientRect = CGRectMake(0, NAVIGATION_VIEW_HEIGHT + _stateBarHeight, self.view.bounds.size.width,
                           self.view.bounds.size.height - NAVIGATION_VIEW_HEIGHT -
                               BOTTOM_TOOL_BAR_HEIGHT - _stateBarHeight);
  //创建基本承载视图
  _baseView.frame = _clientRect;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  _popToRoot = NO;
  _slideInt = 0;
  _page_Type = 0;

  if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
    _stateBarHeight = 20;
  } else {
    _stateBarHeight = 0;
  }
  self.view.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  [self creatAllControler];

  [self registNotifationServerse];
  [self enableScrollsToTopWithPageIndex:_page_Type];
}

#pragma mark
#pragma mark 通知注册
- (void)registNotifationServerse {
  __weak SimuMainViewController *weakSelf = self;
  loginLogoutNotification = [[LoginLogoutNotification alloc] init];
  loginLogoutNotification.onLoginLogout = ^{
    [weakSelf onLoginEvent];
  };

  observers = [[BaseNotificationObserverMgr alloc] init];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(illegalLogon)
                                               name:Illegal_Logon_SimuStock
                                             object:nil];
  ///未登入时，点击配资跑马灯和动画鱼
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(WFonLoginEvent)
                                               name:WFLogonNotification
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(onRealTradeTimeout:)
                                               name:illegal_Logon_realtrade
                                             object:nil];
}

- (void)onRealTradeTimeout:(NSNotification *)notification {
  if ([@"" isEqualToString:[RealTradeAuthInfo singleInstance].cookie]) {
    return;
  }
  [RealTradeAuthInfo singleInstance].cookie = @"";
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                      message:notification.object
                                                     delegate:self
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil, nil];
  alertView.tag = 9999;
  [alertView show];
}

- (void)WFonLoginEvent {
  if ([[SimuUtil getUserID] isEqualToString:@"-1"]) {
    [self buttonPressDown:1001];
  }
  return;
}

- (void)illegalLogon {
  //防止重复弹出
  if (![SimuUtil isLogined]) {
    return;
  }

  [SimuUser onLoginOut];

  UIAlertView *alertView =
      [[UIAlertView alloc] initWithTitle:@"提示"
                                 message:@"登录状态已失效，请重新登录"
                                delegate:self
                       cancelButtonTitle:@"确定"
                       otherButtonTitles:nil, nil];
  alertView.tag = 9000;
  [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  UINavigationController *navigationController = self.navigationController;
  if (alertView.tag == 9000) {
    // 1. 刷新主界面
    [[NSNotificationCenter defaultCenter] postNotificationName:LogoutSuccess object:nil];
    [navigationController popToRootViewControllerAnimated:NO];
    [navigationController pushViewController:[[FullScreenLogonViewController alloc] init]
                                    animated:YES];
  } else {
    [NetLoadingWaitView stopAnimating];
    [navigationController popToRootViewControllerAnimated:NO];
    [SimuUser setUserFirmLogonSuccessTime:0];
  }
}

#pragma mark----------------------
#pragma mark----------------------登录和退出通知-------------------------
//登录成功通知
- (void)onLoginEvent {
  if ([SimuUtil isLogined]) {
    [PortfolioStockManager synchronizePortfolioStockWithIncrementFlag:NO];

    ///更新未读消息
    [UserBpushInformationNum requestUnReadStaticData];

    _currentView = _userInfoView;
    // 1. 当从比赛等页面登陆成功时，当前不显示侧边栏，此时登陆成功，什么也不做；
    if (_currentView.frame.origin.x >= 0) {
      // 2. 当从侧边栏登陆成功时，右移动主界面，遮住侧边栏
      [self moveToMainView];
    }
  } else {
    _currentView = _loginView;
    //当退出登陆时，右移动主界面，遮住侧边栏
    if (_page_Type != 0) {
      [self resetShowChangeView:0];
    }
  }

  [self create_searchBoxView];
  [self changeToolBarState];
}

#pragma mark
#pragma mark 对外接口
- (void)resetShowChangeView:(NSInteger)index {
  [self bottomButtonPressDown:index];
  if (_bottomToolBarView) {
    [_bottomToolBarView resetSelectedState:index];
  }
}

#pragma mark 能否侧滑判定
- (void)JudgmentsSideslip:(NSNotification *)notification {
  /*
   1.1进入不可侧滑界面
   2.2侧滑重置
   3.-1退出不可侧滑界面
   */
  NSString *slideDefaults = [notification object];
  if ([slideDefaults integerValue] == 0) {
    _slideInt = 0;
  } else if ([slideDefaults integerValue] == 1) {
    _slideInt += 1;
  } else if ([slideDefaults integerValue] == 2) {
    _slideInt = 0;
  } else if ([slideDefaults integerValue] == -1) {
    _slideInt -= 1;
  }
  if (_slideInt < 0) {
    _slideInt = 0;
  }
}
#pragma mark
#pragma mark---------创建框架的需要控件---------------
- (void)creatAllControler {
  [self creatTopToolBarView];
  [self creatBottomToolBarView];
  [self creatGestureRecognizer];
  [self creatBaseView];

  [self creatCoverageView];

  [self createIndicatorView];
  [self createOperationButton];
  [self bottomButtonPressDown:0];
}
//创建上标题栏
- (void)creatTopToolBarView {
  _topToolBarView =
      [[SimuTopToolBarView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, NAVIGATION_VIEW_HEIGHT + _stateBarHeight)];
  _topToolBarView.tag = 9955;
  _topToolBarView.delegate = self;
  [self.view addSubview:_topToolBarView];
  [self create_searchBoxView];
}
//创建下标题栏
- (void)creatBottomToolBarView {
  SimuBottomToolBarView *bottomToolBar = _bottomToolBarView =
      [[SimuBottomToolBarView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - BOTTOM_TOOL_BAR_HEIGHT,
                                                              self.view.bounds.size.width, BOTTOM_TOOL_BAR_HEIGHT)];
  bottomToolBar.delegate = self;
  [self.view addSubview:bottomToolBar];
}
//创建基本承载页面
- (void)creatBaseView {
  //创建显示区域区域
  _clientRect = CGRectMake(0, NAVIGATION_VIEW_HEIGHT + _stateBarHeight, self.view.bounds.size.width,
                           self.view.bounds.size.height - NAVIGATION_VIEW_HEIGHT -
                               BOTTOM_TOOL_BAR_HEIGHT - _stateBarHeight);
  //创建基本承载视图
  if (_baseView == Nil) {
    _baseView = [[UIView alloc] initWithFrame:_clientRect];
    _baseView.backgroundColor = [UIColor clearColor];
    _baseView.clipsToBounds = YES;
    [self.view addSubview:_baseView];
  }
}
//创建手势
- (void)creatGestureRecognizer {
  if (_panGestureRecognizer == nil) {
    _panGestureRecognizer =
        [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [_panGestureRecognizer setDelegate:self];
    [self.view addGestureRecognizer:_panGestureRecognizer];
  }
}

#pragma mark----------1----------

//创建覆盖页面
- (void)creatCoverageView {
  _coverView = [SimuCoverageView sharedCoverageView];
  _coverView.delegate = self;
  [self.view addSubview:_coverView];
  _coverView.hidden = YES;
}

#pragma mark
#pragma mark simuCoverDelegate 覆盖页代理方法
- (void)mouseTouchUp {

  [self needShowCoverView:(self.view.left > MAX_SIDESLIP_WIDTH)];

  //主页向左滑动
  [UIView animateWithDuration:.25f
                   animations:^{
                     self.view.left = 0;
                     _userInfoView.left = -MAX_SIDESLIP_WIDTH / 8;
                     _loginView.left = -MAX_SIDESLIP_WIDTH / 8;
                   }];
}

#pragma mark
#pragma mark--底部按钮点击回调 simuBottomToolBarViewDelegate------
- (void)enableScrollsToTopWithPageIndex:(NSInteger)index {
  _currentScrollView.scrollsToTop = NO;
  [_viewControllerDic enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, id<ScrollToTopVC> viewController, BOOL *stop) {
    if (key.integerValue == index) {
      [viewController enableScrollsToTop:YES];
    } else {
      [viewController enableScrollsToTop:NO];
    }
  }];
}

//底部按钮点击
- (void)bottomButtonPressDown:(NSInteger)index {
  // this automatically calls view did/will disappear
  UIViewController *selectedViewController = _viewControllerDic[@(_page_Type)];
  [selectedViewController.view removeFromSuperview];
  [self enableScrollsToTopWithPageIndex:index];

  UIViewController *viewController = _viewControllerDic[@(index)];

  if (viewController == nil) {
    viewController = [self createSubViewControllerWithTabIndex:index];
    _viewControllerDic[@(index)] = viewController;

    [viewController willMoveToParentViewController:nil];
    [viewController removeFromParentViewController];
    [self addChildViewController:viewController];
    [viewController didMoveToParentViewController:self];
  }

  _page_Type = index;
  [self changeToolBarState];
  searchLab.text = _searchTitleDic[@(index)];

  viewController.view.frame = _baseView.bounds;
  [_baseView addSubview:viewController.view];
}

#pragma mark
#pragma mark simuTopToolBarDelegate 上工具栏导航按钮点击协议
- (void)buttonPressDown:(NSInteger)index {
  if (index == 1001) {
    //点击用户头像
    NSInteger offset = 0;
    if (self.view.frame.origin.x < MAX_SIDESLIP_WIDTH) {
      offset = MAX_SIDESLIP_WIDTH;
      [self needShowCoverView:YES];
    } else if ((NSInteger)self.view.frame.origin.x == MAX_SIDESLIP_WIDTH) {
      offset = -MAX_SIDESLIP_WIDTH;
      [self needShowCoverView:NO];
    }

    [UIView animateWithDuration:.25f
                     animations:^{
                       self.view.left = offset;
                       _userInfoView.left = offset > 0 ? 0 : (-MAX_SIDESLIP_WIDTH / 8);
                       _loginView.left = offset > 0 ? 0 : (-MAX_SIDESLIP_WIDTH / 8);
                     }];

  } else if (index == 1002) {
    // 3. 创建消息中心页面
    [AppDelegate pushViewControllerFromRight:[[MessageCenterViewController alloc] init]];
  }
}

#pragma mark---------simuUserConterViewControllerDelegate---------
- (void)simuUserLogInMethod {
  if (self.view.frame.origin.x < MAX_SIDESLIP_WIDTH) {
    [self needShowCoverView:YES];
    [UIView animateWithDuration:.25f
                     animations:^{
                       self.view.left = MAX_SIDESLIP_WIDTH;
                       _loginView.left = 0;
                       _userInfoView.left = 0;
                     }];
  }
}
#pragma mark
#pragma mark---------- UIGestureRecognizerDelegate--------
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
  // Check for horizontal pan gesture
  if (gestureRecognizer == _panGestureRecognizer) {
    UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer *)gestureRecognizer;
    CGPoint translation = [panGesture translationInView:self.view];
    if ([panGesture velocityInView:self.view].x < 600 && ABS(translation.x) / ABS(translation.y) > 1) {
      return _slideInt == 0;
    }
    return NO;
  }
  return _slideInt == 0;
}

#pragma mark 滑动手势
- (void)pan:(UIPanGestureRecognizer *)panner {
  if ([panner state] == UIGestureRecognizerStateBegan) {

  } else if ([panner state] == UIGestureRecognizerStateChanged) {

    CGPoint translatedPoint = [panner translationInView:self.view];
    //如果未滑到头
    if (self.view.frame.origin.x <= MAX_SIDESLIP_WIDTH) {
      self.view.left += translatedPoint.x;
      _currentView.leftNF += translatedPoint.x / 8;
      _loginView.leftNF += translatedPoint.x / 8;

      //如果右侧到头
    } else {
      self.view.left = MAX_SIDESLIP_WIDTH;
      _currentView.left = 0;
      _loginView.left = 0;
    }

    //左侧到头
    if (self.view.frame.origin.x <= 0) {
      self.view.left = 0;
      _currentView.left = -MAX_SIDESLIP_WIDTH / 8;
      _loginView.left = -MAX_SIDESLIP_WIDTH / 8;
    }

    [panner setTranslation:CGPointMake(0, 0) inView:self.view];

    //滑动结束或取消
  } else if (([panner state] == UIGestureRecognizerStateEnded) ||
             ([panner state] == UIGestureRecognizerStateCancelled)) {
    //如果手指小于屏幕一半，自动返回
    if (self.view.frame.origin.x <= self.view.bounds.size.width / 2) {
      //视图靠左边停止
      [UIView animateWithDuration:.25f
                       animations:^{
                         self.view.left = 0;
                         _userInfoView.left = -MAX_SIDESLIP_WIDTH / 8;
                         _loginView.left = -MAX_SIDESLIP_WIDTH / 8;
                       }];
      [self needShowCoverView:NO];
      //视图靠右边停止
    } else {
      [UIView animateWithDuration:.25f
                       animations:^{
                         self.view.left = MAX_SIDESLIP_WIDTH;
                         _userInfoView.left = 0;
                         _loginView.left = 0;
                       }];
      [self needShowCoverView:YES];
    }
  }
}

#pragma mark
#pragma mark--------------普通功能函数---------------

- (void)setLoginView:(UIView *)loginView NotLoginView:(UIView *)nologinView {
  _userInfoView = _currentView = loginView;
  _loginView = nologinView;
}

//隐藏或者显示覆盖视图 (yes:展示覆盖页面 no:隐藏覆盖页面)
- (void)needShowCoverView:(BOOL)needShow {
  if (needShow) {
    //展示覆盖页面
    _coverView.hidden = NO;
    [self.view bringSubviewToFront:_coverView];
  } else {
    //隐藏覆盖页面
    _coverView.hidden = YES;
  }
}
//移动到交易页面
- (void)moveToMainView {

  [self resetShowChangeView:_page_Type];

  [self needShowCoverView:(self.view.left > MAX_SIDESLIP_WIDTH)];

  //主页向左滑动
  [UIView animateWithDuration:.25f
                   animations:^{

                     self.view.left = 0;
                     _userInfoView.left = -MAX_SIDESLIP_WIDTH / 8;
                     _loginView.left = -MAX_SIDESLIP_WIDTH / 8;
                   }];
}

#pragma mark
#pragma mark-------------动画相关函数----------------

//创建搜索框视图
- (void)create_searchBoxView {
  if (_searchBoxView) {
    [_searchBoxView removeFromSuperview];
  }
  CGFloat _searchBoxViewWidth =
  WIDTH_OF_SCREEN - SearchBoxLeft - ([SimuUtil isLogined]
                                     ? SearchBoxRightGapLogined
                                     : SearchBoxRightGapNotLogined);
  
  if (_page_Type == 0 && [SimuUtil isLogined]) {
    _searchBoxViewWidth =
    WIDTH_OF_SCREEN - SearchBoxLeft - SearchBoxRightGapNotLogined;
  }
  
  CGRect _searchBoxViewFrame =
  CGRectMake(SearchBoxLeft, _stateBarHeight, _searchBoxViewWidth, 41.0);
  _searchBoxView = [[UIView alloc] initWithFrame:_searchBoxViewFrame];
  
  _searchBoxView.backgroundColor = [UIColor clearColor];
  [_topToolBarView addSubview:_searchBoxView];
  UIView *brackView = [[UIView alloc]
                       initWithFrame:CGRectMake(2.0, (41.0 - 69.0 / 2) / 2,
                                                _searchBoxView.bounds.size.width - 67.0 / 2,
                                                69.0 / 2)];
  brackView.backgroundColor = [UIColor whiteColor];
  [_searchBoxView addSubview:brackView];
  searchLab = [[UILabel alloc]
               initWithFrame:CGRectMake(6.0, (41.0 - 69.0 / 2) / 2,
                                        _searchBoxView.bounds.size.width - 67.0 / 2,
                                        69.0 / 2)];
  searchLab.backgroundColor = [UIColor whiteColor];
  searchLab.textAlignment = NSTextAlignmentLeft;
  searchLab.text = @"搜股票";
  searchLab.textColor = [Globle colorFromHexRGB:Color_Gray];
  searchLab.font = [UIFont systemFontOfSize:Font_Height_14_0];
  [_searchBoxView addSubview:searchLab];
  //增大点击区域
  UIButton *areaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  areaBtn.frame =
  CGRectMake(0.0, (41.0 - 69.0 / 2) / 2,
             _searchBoxView.bounds.size.width - 67.0 / 2, 69.0 / 2);
  areaBtn.backgroundColor = [UIColor clearColor];
  [areaBtn addTarget:self
              action:@selector(clickTriggeringMethodIncreaseArea)
    forControlEvents:UIControlEventTouchUpInside];
  [_searchBoxView addSubview:areaBtn];
  UIView *lineView = [[UIView alloc]
                      initWithFrame:CGRectMake(0.0 + _searchBoxView.bounds.size.width -
                                               67.0 / 2 - 0.5,
                                               (41.0 - 44.0 / 2) / 2, 0.5, 44.0 / 2)];
  lineView.backgroundColor = [Globle colorFromHexRGB:Color_Blue_but];
  [_searchBoxView addSubview:lineView];
  //搜索图标
  UIView *searchView = [[UIView alloc]
                        initWithFrame:CGRectMake(0.0 + _searchBoxView.bounds.size.width -
                                                 67.0 / 2,
                                                 (41.0 - 69.0 / 2) / 2, 66.0 / 2, 69.0 / 2)];
  searchView.backgroundColor = [Globle colorFromHexRGB:@"#eeeaea"];
  [_searchBoxView addSubview:searchView];
  UIImageView *searchImage =
  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"搜索"]];
  searchImage.frame =
  CGRectMake((66.0 - 39.0) / 4, (69.0 - 37.0) / 4, 39.0 / 2, 37.0 / 2);
  [searchView addSubview:searchImage];
}

//增大点击区域
- (void)clickTriggeringMethodIncreaseArea {
  switch (_page_Type) {
  case 0: { //搜股票(首页)
    [AppDelegate pushViewControllerFromRight:[[StockSearchViewController alloc] init]];
  } break;
  case 1: { //搜牛人(牛人)
    [AppDelegate pushViewControllerFromRight:[[StockFriendsViewController alloc] init]];
  } break;
  case 2: { //搜股票(行情)
    [AppDelegate pushViewControllerFromRight:[[StockSearchViewController alloc] init]];
  } break;
  case 3: { //搜比赛(比赛)
    [AppDelegate pushViewControllerFromRight:[[SearchMatchesViewController alloc] init]];
  } break;
  case 4: { //搜股票(聊股)
    [AppDelegate pushViewControllerFromRight:[[StockSearchViewController alloc] init]];
  } break;
  default:
    break;
  }
}

- (void)refreshButtonPressDown {
  UIViewController *viewController = _viewControllerDic[@(_page_Type)];
  switch (_page_Type) {
  case 0: //交易页面切换
    [((SimuUserConterViewController *)viewController)refreshButtonPressDown];
    break;
  case 1: //牛人
    [((StockMasterViewController *)viewController)refreshButtonPressDown];
    break;
  case 2: //行情
    [((MarketHomeContainerVC *)viewController)refreshButtonPressDown];
    break;
  default:
    break;
  }
}

- (void)operationButtonPressed {
  UIViewController *viewController = _viewControllerDic[@(_page_Type)];
  switch (_page_Type) {
  case 1:
    [AppDelegate pushViewControllerFromRight:[[ExpertScreenViewController alloc] init]];
    break;
  case 2: ///行情
    [((MarketHomeContainerVC *)viewController)manageSelfStocks];
    break;
  case 3: //比赛
    [((StockMatchViewController *)viewController)createMatch];
    break;
  case 4: //聊股吧
    [((StockBarsViewController *)viewController)publishButtonClick];
    break;
  default:
    break;
  }
}

- (UIViewController *)createSubViewControllerWithTabIndex:(NSInteger)index {
  __weak SimuMainViewController *weakSelf = self;

  UIViewController *viewController;
  switch (index) {
  case 0: //交易页面切换
  {
    viewController = [[SimuUserConterViewController alloc] initWithMainViewController:self];
    SimuUserConterViewController *vc = (SimuUserConterViewController *)viewController;
    vc.beginRefreshCallBack = ^{
      [weakSelf showIndicator];
    };
    vc.endRefreshCallBack = ^{
      [weakSelf stopIndicator];
    };
    break;
  }
  case 1: //牛人
  {

    viewController = [[ExpertViewController alloc] initWithFrame:_baseView.bounds
                                      withSimuMainViewController:self];
    break;
  }
  case 2: //行情
  {
    viewController =
        [[MarketHomeContainerVC alloc] initGetMainObject:self withFrame:_baseView.bounds];
    MarketHomeContainerVC *vc = (MarketHomeContainerVC *)viewController;
    vc.beginRefreshCallBack = ^{
      [weakSelf showIndicator];
    };
    vc.endRefreshCallBack = ^{
      [weakSelf stopIndicator];
    };
    break;
  }
  case 3: //比赛
  {
    viewController = [[StockMatchViewController alloc] initGetMainObject:self];
    StockMatchViewController *vc = (StockMatchViewController *)viewController;
    vc.beginRefreshCallBack = ^{
      [weakSelf showIndicator];
    };
    vc.endRefreshCallBack = ^{
      [weakSelf stopIndicator];
    };
    break;
  }
  case 4: //聊股吧
  {
    viewController = [[StockBarsViewController alloc] initGetMainObject:self];
    StockBarsViewController *vc = (StockBarsViewController *)viewController;
    vc.beginRefreshCallBack = ^{
      [weakSelf showIndicator];
    };
    vc.endRefreshCallBack = ^{
      [weakSelf stopIndicator];
    };
    break;
  }
  default:
    NSLog(@"主页上的Tab数不对导致崩溃了");
    abort();
    break;
  }
  return viewController;
}

///创建操作按钮：比赛按钮、自选股管理按钮、发表聊股按钮
- (void)createOperationButton {
  _btnOperation = [[BGColorUIButton alloc] initWithFrame:CGRectZero];
  _btnOperation.normalBGColor = [UIColor clearColor];
  [_btnOperation setTitleColor:[Globle colorFromHexRGB:Color_White] forState:UIControlStateNormal];
  [_btnOperation setBackgroundImage:[UIImage imageNamed:@"return_touch_down.png"]
                           forState:UIControlStateHighlighted];
  _btnOperation.titleLabel.font = [UIFont systemFontOfSize:Font_Height_18_0];
  [_topToolBarView addSubview:_btnOperation];
  [_btnOperation addTarget:self
                    action:@selector(operationButtonPressed)
          forControlEvents:UIControlEventTouchUpInside];
}

///创建菊花
- (void)createIndicatorView {
  CGFloat searchBoxRight =
  [SimuUtil isLogined] ? (WIDTH_OF_SCREEN - SearchBoxRightGapLogined)
  : (WIDTH_OF_SCREEN - SearchBoxRightGapNotLogined);
  CGFloat indicatorStartX = searchBoxRight + 2;
  CGRect indicatorViewFrameForLogined = CGRectMake(
                                                   indicatorStartX, _stateBarHeight, 47, NAVIGATION_VIEW_HEIGHT);
  _indicatorView =
  [[SimuIndicatorView alloc] initWithFrame:indicatorViewFrameForLogined];
  _indicatorView.delegate = self;
  [_topToolBarView addSubview:_indicatorView];
}

/** 改变 菊花和按钮的 位置 */
- (void)showIndicatorOrOperationButton {
  CGFloat searchBoxRight =
  [SimuUtil isLogined] ? (WIDTH_OF_SCREEN - SearchBoxRightGapLogined)
  : (WIDTH_OF_SCREEN - SearchBoxRightGapNotLogined);
  
  CGFloat indicatorStartX = searchBoxRight + 2;
  CGFloat btnOperationStartX =
  [SimuUtil isLogined] ? (searchBoxRight + 2) : (searchBoxRight + 1.6f);
  CGRect operationFrame =
  CGRectMake(indicatorStartX, _topToolBarView.height - 43.5f, 41.5f, 43.5f);
  _indicatorView.hidden = ![self shouldShowIndicator];
  _btnOperation.frame =
  [self shouldShowOperationButton] ? operationFrame : CGRectZero;
  _btnOperation.hidden = ![self shouldShowOperationButton];
  _indicatorView.left = indicatorStartX;
  _btnOperation.left = btnOperationStartX;
  NSLog(@"_btnOperation: 0");
  NSLog(@"_btnOperation: frame");
}

/** 显示菊花 */
- (void)showIndicator {
  if ([self shouldShowIndicator]) {
    [_indicatorView startAnimating];
  }
}

/** 停止 菊花 */
- (void)stopIndicator {
  [_indicatorView stopAnimating];
}

/** 根据哪个页面 看情况 是否显示 菊花 */
- (BOOL)shouldShowIndicator {
  switch (_page_Type) {
  case 0: //交易页面切换
    return NO;
  case 1: //牛人
    return NO;
  case 2: { //行情
    MarketHomeContainerVC *viewController = (MarketHomeContainerVC *)_viewControllerDic[@(_page_Type)];
    if (viewController.pageIndex == 0) {
      return YES;
    } else {
      return NO;
    }
  }
  case 3: //比赛
    return NO;
  case 4: //聊股吧
    return NO;
  default:
    return YES;
  }
}
/** 根据哪个页面 看情况显示 按钮 */
- (BOOL)shouldShowOperationButton {
  switch (_page_Type) {
  case 0: //交易页面切换
    return NO;
  case 1: //牛人
    return YES;
  case 2: { //行情
    MarketHomeContainerVC *viewController = (MarketHomeContainerVC *)_viewControllerDic[@(_page_Type)];
    if (viewController.pageIndex == 0) {
      return NO;
    } else {
      return [viewController shouldShowManageButton];
    }
  }
  case 3: //比赛
    return YES;
  case 4: //聊股吧
    return YES;
  default:
    return YES;
  }
}

/** 改变按钮上面的 文案 */
- (void)changeToolBarState {
  [self create_searchBoxView];
  [self showIndicatorOrOperationButton];
  switch (_page_Type) {
  case 1: //牛人
    [_btnOperation setTitle:@"筛选" forState:UIControlStateNormal];
    break;
  case 2: //行情
    [_btnOperation setTitle:@"管理" forState:UIControlStateNormal];
    break;
  case 3: //比赛
    [_btnOperation setTitle:@"创建" forState:UIControlStateNormal];
    break;
  case 4: //聊股吧
    [_btnOperation setTitle:@"发表" forState:UIControlStateNormal];
    break;
  default:
    break;
  }
}

@end
