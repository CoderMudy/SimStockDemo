//
//  StockMatchViewController.m
//  SimuStock
//
//  Created by jhss on 14-5-6.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "StockMatchViewController.h"
#import "SimuUtil.h"
#import "MatchTableViewController.h"
#import "MatchCreateViewController.h"

#import "AwardsMatchViewController.h"

static const NSInteger kViewControllersCount = 4;

@interface StockMatchViewController () {
  /** 得到导航条下面的线的frame */
  CGRect _lineFrame;
  /** 创建一个 数组 保存tableview实例 */
  NSMutableArray *_saveMatchTableViewArray;
}

@end

@implementation StockMatchViewController

- (id)initGetMainObject:(SimuMainViewController *)controller {
  if (self = [super init]) {
    _simuMainVC = controller;
    __weak StockMatchViewController *weakSelf = self;
    _loginLogoutNotification = [[LoginLogoutNotification alloc] init];
    _loginLogoutNotification.onLoginLogout = ^{
      [weakSelf onLoginLogoutEvent];
    };
  }
  return self;
}

- (void)viewDidLayoutSubviews {
  _scrollView.frame = CGRectMake(0, TOP_TABBAR_HEIGHT, self.view.bounds.size.width,
                                 self.view.bounds.size.height - TOP_TABBAR_HEIGHT);
  _scrollView.contentSize = CGSizeMake(self.view.bounds.size.width * kViewControllersCount,
                                       self.view.bounds.size.height - TOP_TABBAR_HEIGHT);
}

#pragma mark - TopToolBarView代理回调
- (void)changeToIndex:(NSInteger)index {
  currentTab = index;
  [self enableScrollsToTopWithPageIndex:currentTab];
  CGFloat screenWidth = self.view.bounds.size.width;
  [_scrollView setContentOffset:CGPointMake(screenWidth * index, 0) animated:YES];
  MatchTableViewController *tableVC = (MatchTableViewController *)_saveMatchTableViewArray[index];
  if (index == MyMathc && ![self judgeUserIsLogin]) {
    return;
  }

  if (!tableVC.dataBinded) {
    [tableVC refreshButtonPressDown];
  }
}

- (void)enableScrollsToTop:(BOOL)scrollsToTop {
  if (scrollsToTop) {
    [self enableScrollsToTopWithPageIndex:currentTab];
  } else {
    _scrollView.scrollsToTop = NO;
    [_saveMatchTableViewArray enumerateObjectsUsingBlock:^(MatchTableViewController *tableVC, NSUInteger idx, BOOL *stop) {
      tableVC.tableView.scrollsToTop = NO;
    }];
  }
}

- (void)enableScrollsToTopWithPageIndex:(NSInteger)index {
  _scrollView.scrollsToTop = NO;
  [_saveMatchTableViewArray enumerateObjectsUsingBlock:^(MatchTableViewController *tableVC, NSUInteger idx, BOOL *stop) {
    if (index == idx) {
      tableVC.tableView.scrollsToTop = YES;
    } else {
      tableVC.tableView.scrollsToTop = NO;
    }
  }];
}

#pragma mark - 判断是否登录
- (BOOL)judgeUserIsLogin {
  if ([SimuUtil isLogined]) {
    //登录
    return YES;
  } else {
    [_topToolBarView changTapToIndex:0];
    [FullScreenLogonViewController checkLoginStatusWithCallBack:^(BOOL isLogined) {
      if (!isLogined) {
        [_topToolBarView changTapToIndex:MyMathc];
      }
    }];
    return NO;
  }
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:@"canjiaobisaichenggong"
                                                object:nil];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  //  //创建一个 通知
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(refreshMatchTableView)
                                               name:@"canjiaobisaichenggong"
                                             object:nil];

  self.view.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];

  self.view.frame =
      CGRectMake(0, NAVIGATION_VIEW_HEIGHT + HEIGHT_0F_STATUSBAR, self.view.width,
                 self.view.height - BOTTOM_TOOL_BAR_HEIGHT - NAVIGATION_VIEW_HEIGHT - HEIGHT_0F_STATUSBAR);

  //创建导航栏
  _topToolBarView =
      [[TopToolBarView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, TOP_TABBAR_HEIGHT)
                                  DataArray:@[ @"所有比赛", @"校园", @"有奖", @"我的" ]
                        withInitButtonIndex:0];
  _topToolBarView.delegate = self;
  //记录下面导航条线的frame
  _lineFrame = _topToolBarView.maxlineView.frame;
  [self.view addSubview:_topToolBarView];
  //创建 滚动视图
  _saveMatchTableViewArray = [[NSMutableArray alloc] init];
  [self createScrollerView];
  [self enableScrollsToTopWithPageIndex:0];
}

#pragma mark-- 创建滚动视图
- (void)createScrollerView {
  //底部表格
  CGRect frame = self.view.frame;
  //滚动视图
  _scrollView =
      [[UIScrollView alloc] initWithFrame:CGRectMake(0, TOP_TABBAR_HEIGHT, frame.size.width, frame.size.height - TOP_TABBAR_HEIGHT)];
  _scrollView.userInteractionEnabled = YES;
  _scrollView.pagingEnabled = YES;
  _scrollView.bounces = NO;
  _scrollView.delegate = self;
  _scrollView.showsHorizontalScrollIndicator = NO;
  _scrollView.showsVerticalScrollIndicator = NO;
  _scrollView.contentSize =
      CGSizeMake(frame.size.width * kViewControllersCount, frame.size.height - TOP_TABBAR_HEIGHT);
  [self.view addSubview:_scrollView];

  //创建 比赛视图
  [self createTableViewForMathc];
}

#pragma mark-- 创建tableview 比赛视图
- (void)createTableViewForMathc {
  NSInteger type[] = {AllMathc, SchoolMatc, RewardMatc, MyMathc};

  for (int i = 0; i < 4; i++) {
    CGRect frame = CGRectMake(CGRectGetWidth(self.view.bounds) * i, 0, CGRectGetWidth(self.view.bounds),
                              CGRectGetHeight(self.view.bounds) - TOP_TABBAR_HEIGHT);
    MatchTableViewController *mathcTbaleView =
        [[MatchTableViewController alloc] initWithFrame:frame withMatchStockType:type[i]];
    mathcTbaleView.view.frame = frame;
    mathcTbaleView.showTableFooter = YES;
    [_scrollView addSubview:mathcTbaleView.view];
    [self addChildViewController:mathcTbaleView];
    [_saveMatchTableViewArray addObject:mathcTbaleView];
    [mathcTbaleView refreshButtonPressDown];
  }
}

- (void)refreshMatchTableView {
  MatchTableViewController *matchTableVC = _saveMatchTableViewArray[1];
  [matchTableVC refreshButtonPressDown];
}

#pragma makr - 刷新数据
//设置标示线 在滚动时代理方法里
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  if (scrollView == _scrollView) {
    if (scrollView.contentOffset.x >= 0 &&
        scrollView.contentOffset.x <= self.view.width * (kViewControllersCount - 1)) {
      _topToolBarView.maxlineView.frame = CGRectMake(
          scrollView.contentOffset.x / kViewControllersCount, _topToolBarView.bounds.size.height - 3,
          self.view.frame.size.width / kViewControllersCount, 2.5);
    }
  }
}

#pragma mark scrollView代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  if (scrollView == _scrollView) {
    CGPoint offset = scrollView.contentOffset;
    [_topToolBarView changTapToIndex:(offset.x / self.view.width)];
  }
}

//创建比赛成功delegate，刷新列表
- (void)refreshCurrentPage {
}

#pragma mark
#pragma mark---------界面设计----------
/**退出登录:我参与的->所有比赛*/
- (void)onLoginLogoutEvent {
  if ([SimuUtil isLogined]) {
  } else {
    //当用户退出登录时  移除我的比赛 并切换到 所有比赛
    MatchTableViewController *myMatchTableView = (MatchTableViewController *)_saveMatchTableViewArray[MyMathc];
    [myMatchTableView.dataArray reset];
    [myMatchTableView.tableView reloadData];
    myMatchTableView.littleCattleView.hidden = YES;
    //切换所有比赛
    [_topToolBarView changTapToIndex:AllMathc];
  }
}

- (void)createMatch {
  //是否登录
  [FullScreenLogonViewController checkLoginStatusWithCallBack:^(BOOL isLogined) {
    [AppDelegate pushViewControllerFromRight:[[MatchCreateViewController alloc] init]];
  }];
}
@end
