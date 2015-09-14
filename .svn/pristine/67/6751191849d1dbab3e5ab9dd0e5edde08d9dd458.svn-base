//
//  MarketHomeContainerVC.m
//  SimuStock
//
//  Created by Mac on 15/4/24.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "MarketHomeContainerVC.h"

@implementation MarketHomeContainerVC

- (id)initGetMainObject:(SimuMainViewController *)controller withFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    if (controller) {
      _simuMainVC = controller;
    }
    _pageIndex = 0;
  }
  return self;
}

//点击标签回调
- (void)changeToIndex:(NSInteger)index {
  _pageIndex = index;
  [self enableScrollsToTopWithPageIndex:_pageIndex];

  CGFloat screenWidth = self.view.bounds.size.width;
  [_scrollView setContentOffset:CGPointMake(screenWidth * index, 0) animated:YES];
  if (index == 0) {
    if (!marketViewController.dataBinded) {
      [marketViewController refreshButtonPressDown];
    }
  } else {
    if (!selfStockViewController.dataBinded) {
      [selfStockViewController refreshButtonPressDown];
    }
  }
  [_simuMainVC showIndicatorOrOperationButton];
}

- (void)refreshButtonPressDown {
  if (self.beginRefreshCallBack) {
    self.beginRefreshCallBack();
  }

  if (_pageIndex == 0) {
    [marketViewController refreshButtonPressDown];
  } else {
    [selfStockViewController refreshButtonPressDown];
  }
}

- (void)enableScrollsToTop:(BOOL)scrollsToTop {
  if (scrollsToTop) {
    [self enableScrollsToTopWithPageIndex:_pageIndex];
  } else {
    _scrollView.scrollsToTop = NO;
    marketViewController.tableView.scrollsToTop = NO;
    selfStockViewController.tableView.scrollsToTop = NO;
  }
}

- (void)enableScrollsToTopWithPageIndex:(NSInteger)index {
  _scrollView.scrollsToTop = NO;
  if (index == 0) {
    marketViewController.tableView.scrollsToTop = YES;
    selfStockViewController.tableView.scrollsToTop = NO;
  } else {
    marketViewController.tableView.scrollsToTop = NO;
    selfStockViewController.tableView.scrollsToTop = YES;
  }
}

- (void)viewDidLoad {
  [super viewDidLoad];
  //我的金币页面，首次添加自选股任务通知跳转
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(changeTopBarIndex)
                                               name:@"pushToMaketHomeContainerVC"
                                             object:nil];

  _topToolbarView = [[TopToolBarView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, TOP_TABBAR_HEIGHT)
                                                DataArray:@[ @"行情", @"自选股" ]
                                      withInitButtonIndex:0];
  _topToolbarView.delegate = self;
  [self.view addSubview:_topToolbarView];
  self.littleCattleView.hidden = YES;

  [self createScrollView];

  [self createTableView];
  //创建另一个视图
  [self createOtherView];

  [self refreshButtonPressDown];
  [self enableScrollsToTopWithPageIndex:0];
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)changeTopBarIndex {
  [self.topToolbarView changTapToIndex:1];
}
#pragma mark 区分上层界面

- (void)createTableView {
  CGRect frame = CGRectMake(0, 0, WIDTH_OF_SCREEN, CGRectGetHeight(_scrollView.bounds));
  marketViewController = [[MarketHomeTableViewController alloc] initWithFrame:frame];

  __weak MarketHomeContainerVC *weakSelf = self;
  marketViewController.beginRefreshCallBack = ^{
    if (weakSelf.beginRefreshCallBack) {
      weakSelf.beginRefreshCallBack();
    }
  };

  marketViewController.endRefreshCallBack = ^{
    if (weakSelf.endRefreshCallBack) {
      weakSelf.endRefreshCallBack();
    }
  };
  [_scrollView addSubview:marketViewController.view];
  [self addChildViewController:marketViewController];
}

- (void)createOtherView {
  //创建已清仓股票
  CGRect frame = CGRectMake(WIDTH_OF_SCREEN, 0, WIDTH_OF_SCREEN, CGRectGetHeight(_scrollView.bounds));
  selfStockViewController = [[SelfStockTableViewController alloc] initWithFrame:frame];
  __weak MarketHomeContainerVC *weakSelf = self;
  selfStockViewController.beginRefreshCallBack = ^{
    if (weakSelf.beginRefreshCallBack) {
      weakSelf.beginRefreshCallBack();
    }
  };

  selfStockViewController.endRefreshCallBack = ^{
    if (weakSelf.endRefreshCallBack) {
      weakSelf.endRefreshCallBack();
    }
  };

  selfStockViewController.onDataReadyCallBack = ^{
    [weakSelf onEndRefresh];
  };

  [_scrollView addSubview:selfStockViewController.view];
  [self addChildViewController:selfStockViewController];
}

- (void)onEndRefresh {
  [_simuMainVC showIndicatorOrOperationButton];
}

//创建滚动视图
- (void)createScrollView {
  CGFloat width = self.view.bounds.size.width;
  CGFloat height = CGRectGetHeight(self.view.bounds) - TOP_TABBAR_HEIGHT;

  _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, TOP_TABBAR_HEIGHT, width, height)];
  _scrollView.contentSize = CGSizeMake(width * 2, height);

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
    if (scrollView.contentOffset.x >= 0 && scrollView.contentOffset.x <= self.view.frame.size.width) {
      _topToolbarView.maxlineView.frame =
          CGRectMake(scrollView.contentOffset.x / 2, _topToolbarView.bounds.size.height - 3,
                     self.view.frame.size.width / 2, 2.5);
    }
  }
}

#pragma mark scrollView代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  if (scrollView == _scrollView) {
    CGPoint offset = scrollView.contentOffset;

    if (offset.x == 0) {
      [_topToolbarView changTapToIndex:0];
    } else if (offset.x == WIDTH_OF_VIEWCONTROLLER) {
      [_topToolbarView changTapToIndex:1];
    }
  }
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  NSLog(@"2 will appear");
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  NSLog(@"2 will viewWillDisappear");
}

- (BOOL)shouldShowManageButton {
  return [selfStockViewController shouldShowManageButton];
}

- (void)manageSelfStocks {
  [selfStockViewController manageSelfStocks];
}

@end
