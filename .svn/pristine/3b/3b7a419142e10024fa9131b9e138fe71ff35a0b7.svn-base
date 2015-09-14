//
//  StockMasterViewController.m
//  SimuStock
//
//  Created by jhss on 13-11-29.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "StockMasterViewController.h"
#import "MasterRankingViewController.h"
#import "event_view_log.h"
#import "MobClick.h"

//是否有追踪权限
//最高值下载
//#import "SimuWebViewContrler.h"

#import "MasterPurchesViewController.h"

//配资实盘界面
#import "SimuConfigConst.h"
#import "NetShoppingMallBaseViewController.h"

@implementation StockMasterViewController

- (id)initGetMainObject:(SimuMainViewController *)controller
              withFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    if (controller) {
      _simuMainVC = controller;
    }
    pageIndex = 0;
  }
  return self;
}

//统计页面停留时间
- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [MobClick beginLogPageView:@"炒股牛人"];
  NSLog(@"1 will appear");
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  NSLog(@"1 will viewDidDisappear");
  [MobClick endLogPageView:@"炒股牛人"];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.isOpenMasterPlan = NO;

  [self createScrollView];
  //刷新下关注数据（总共一次）
  [self createMainView];

  //创建手动滑动控件
  //  [self creatTouchView];//？？？干什么用的？
  [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_PV
                                                   andCode:@"炒股牛人"];
  [self refreshButtonPressDown];
}

//点击标签回调
- (void)changeToIndex:(NSInteger)index {
  pageIndex = index;
  CGFloat screenWidth = self.view.bounds.size.width;
  [_scrollView setContentOffset:CGPointMake(screenWidth * index, 0)
                       animated:YES];
  if (index == 0) {
    //        if (!followMasterVC.dataBinded) {
    //          [followMasterVC refreshButtonPressDown];
    //        }
    if (!self.isOpenMasterPlan) {
      if (!tradingVC.dataBinded) {
        [tradingVC refreshButtonPressDown];
      }
    }
  } else if (index == 1) {
    if (self.isOpenMasterPlan) {
      if (!tradingVC.dataBinded) {
        [tradingVC refreshButtonPressDown];
      }
    } else {
      if (!heroRankListVC.dataBinded) {
        [heroRankListVC refreshButtonPressDown];
      }
    }
  } else {
    if (!heroRankListVC.dataBinded) {
      [heroRankListVC refreshButtonPressDown];
    }
  }
}
//创建滚动视图
- (void)createScrollView {
  CGFloat width = self.view.bounds.size.width;
  CGFloat height = CGRectGetHeight(self.view.bounds) - TOP_TABBAR_HEIGHT;

  _scrollView =
      [[UIScrollView alloc] initWithFrame:CGRectMake(0, TOP_TABBAR_HEIGHT, width, height)];
  _scrollView.contentSize =
      CGSizeMake(self.isOpenMasterPlan ? width * 3 : width * 2, height);
  _scrollView.pagingEnabled = YES;
  _scrollView.delegate = self;
  _scrollView.showsHorizontalScrollIndicator = NO;
  _scrollView.showsVerticalScrollIndicator = YES;
  //_scrollView.contentInset = UIEdgeInsetsZero;
  _scrollView.bounces = NO;
  _scrollView.backgroundColor = [UIColor clearColor];
  //  [_scrollView.panGestureRecognizer addTarget:self
  //                                       action:@selector(scrollViewPan:)];
  [self.view addSubview:_scrollView];
}

#pragma mark - 向下传递滑动手势
- (void)scrollViewPan:(UIPanGestureRecognizer *)panner {
  CGPoint point = [panner velocityInView:_scrollView];
  if (_scrollView.contentOffset.x == 0 && point.x > 0) {
    [_simuMainVC pan:panner];
    _scrollView.userInteractionEnabled = NO;
    _simuMainVC.currentScrollView = _scrollView;
  }
}

//设置标示线 在滚动是代理方法里
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  if (scrollView == _scrollView) {
    if (scrollView.contentOffset.x >= 0 &&
                scrollView.contentOffset.x <= self.isOpenMasterPlan
            ? self.view.frame.size.width * 2
            : self.view.frame.size.width) {

      CGRect frameTwo = CGRectMake(scrollView.contentOffset.x / 2,
                                   topToolbarView.bounds.size.height - 3,
                                   self.view.frame.size.width / 2, 2.5);
      CGRect frameThird = CGRectMake(scrollView.contentOffset.x / 3,
                                     topToolbarView.bounds.size.height - 3,
                                     self.view.frame.size.width / 3, 2.5);
      topToolbarView.maxlineView.frame =
          self.isOpenMasterPlan ? frameThird : frameTwo;
    }
  }
}

#pragma mark scrollView代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  if (scrollView == _scrollView) {
    CGPoint offset = scrollView.contentOffset;

    if (offset.x == 0) {
      [topToolbarView changTapToIndex:0];
    } else if (offset.x == WIDTH_OF_VIEWCONTROLLER) {
      [topToolbarView changTapToIndex:1];
    } else {
      [topToolbarView changTapToIndex:2];
    }
  }
}
#pragma mark
#pragma mark------------------界面---------------
- (void)createMainView {

  self.view.backgroundColor = [Globle colorFromHexRGB:@"ffffff"];

  topToolbarView = [[TopToolBarView alloc]
            initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, TOP_TABBAR_HEIGHT)
                DataArray:
                    self.isOpenMasterPlan
                        ? @[ @"追踪牛人", @"牛人交易", @"牛人榜单" ]
                        : @[ @"牛人交易", @"牛人榜单" ]
      withInitButtonIndex:0];
  topToolbarView.delegate = self;
  [self.view addSubview:topToolbarView];
  __weak StockMasterViewController *weakSelf = self;

  CGRect frame1 =
      CGRectMake(0, 0, WIDTH_OF_SCREEN, CGRectGetHeight(_scrollView.bounds));
  CGRect frame2 = CGRectMake(WIDTH_OF_SCREEN, 0, WIDTH_OF_SCREEN,
                             CGRectGetHeight(_scrollView.bounds));
  CGRect frame3 = CGRectMake(WIDTH_OF_SCREEN * 2, 0, WIDTH_OF_SCREEN,
                             CGRectGetHeight(_scrollView.bounds));
  if (self.isOpenMasterPlan) {
    //追踪牛人
    followMasterVC = [[FollowMasterViewController alloc] initWithFrame:frame1];
    followMasterVC.beginRefreshCallBack = ^{
      if (weakSelf.beginRefreshCallBack) {
        weakSelf.beginRefreshCallBack();
      }
    };

    followMasterVC.endRefreshCallBack = ^{
      if (weakSelf.endRefreshCallBack) {
        weakSelf.endRefreshCallBack();
      }
    };
    [_scrollView addSubview:followMasterVC.view];
    [self addChildViewController:followMasterVC];
  }

  //数据
  tradingVC = [[StockMasterTradingViewController alloc]
      initWithFrame:self.isOpenMasterPlan ? frame2 : frame1];
  tradingVC.beginRefreshCallBack = ^{
    if (weakSelf.beginRefreshCallBack) {
      weakSelf.beginRefreshCallBack();
    }
  };

  tradingVC.endRefreshCallBack = ^{
    if (weakSelf.endRefreshCallBack) {
      weakSelf.endRefreshCallBack();
    }
  };

  [_scrollView addSubview:tradingVC.view];
  [self addChildViewController:tradingVC];

  //数据
  heroRankListVC = [[StockHeroRankListViewController alloc]
      initWithFrame:self.isOpenMasterPlan ? frame3 : frame2];

  heroRankListVC.beginRefreshCallBack = ^{
    if (weakSelf.beginRefreshCallBack) {
      weakSelf.beginRefreshCallBack();
    }
  };

  heroRankListVC.endRefreshCallBack = ^{
    if (weakSelf.endRefreshCallBack) {
      weakSelf.endRefreshCallBack();
    }
  };

  [_scrollView addSubview:heroRankListVC.view];
  [self addChildViewController:heroRankListVC];
}

#pragma mark-----------------------end-----------------------

- (void)refreshButtonPressDown {
  if (pageIndex == 0) {
    self.isOpenMasterPlan ? [followMasterVC refreshButtonPressDown]
                          : [tradingVC refreshButtonPressDown];
  } else if (pageIndex == 1) {
    self.isOpenMasterPlan ? [tradingVC refreshButtonPressDown]
                          : [heroRankListVC refreshButtonPressDown];
  } else {
    [heroRankListVC refreshButtonPressDown];
  }
}

#pragma mark
#pragma mark - 追踪牛人商店相关函数
- (void)creatTrackMasgerPurchesController {
  if ([SimuConfigConst isShowPropsForReview]) {
    [AppDelegate
        pushViewControllerFromRight:[[NetShoppingMallBaseViewController alloc]
                                        initWithPageType:Mall_Buy_Props]];
  } else {
    MasterPurchesViewController *mfvc_masterPruchesViewController =
        [[MasterPurchesViewController alloc] init];
    mfvc_masterPruchesViewController.delegate = self;
    [AppDelegate pushViewControllerFromRight:mfvc_masterPruchesViewController];
  }
}

@end
