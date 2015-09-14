//
//  MyChatStockViewController.m
//  SimuStock
//
//  Created by jhss_wyz on 15/5/24.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "MyChatStockViewController.h"
#import "TopToolBarView.h"
#import "MyIssuanceViewController.h"
#import "MyCollectTweetViewController.h"
#import "MyCommentViewController.h"
#import "MyIssuanceTableVC.h"
#import "MyCollectTweetTableVC.h"
#import "MyCommentTableVC.h"

@interface MyChatStockViewController () <TopToolBarViewDelegate,
                                         UIScrollViewDelegate>
@end

@implementation MyChatStockViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  [_topToolBar resetContentAndFlage:@"我的聊股" Mode:TTBM_Mode_Leveltwo];

  [self createMainView];
  [self createScrollView];

  self.indicatorView.delegate = self;
  self.indicatorView.hidden = NO;

  [self.scrollView addSubview:self.myIssuanceVC.view];
  [self.scrollView addSubview:self.myCommentVC.view];
  [self.scrollView addSubview:self.myCollectTweetVC.view];

  [self refreshButtonPressDown];
}

- (void)viewDidAppear:(BOOL)animated {

  [super viewDidAppear:animated];
  self.scrollView.contentSize =
      CGSizeMake(self.clientView.width * 3, self.scrollView.bounds.size.height);
}

#pragma mark
#pragma mark------------------界面---------------
- (void)createMainView {

  self.view.backgroundColor = [Globle colorFromHexRGB:@"ffffff"];

  self.topToolbarView = [[TopToolBarView alloc]
            initWithFrame:CGRectMake(0, 0, self.clientView.width, TOP_TABBAR_HEIGHT)
                DataArray:@[ @"我发表的", @"我的评论", @"我的收藏" ]
      withInitButtonIndex:0];
  self.topToolbarView.delegate = self;
  [self.clientView addSubview:self.topToolbarView];
}

/** 创建滚动视图 */
- (void)createScrollView {
  self.scrollView = [[UIScrollView alloc]
      initWithFrame:CGRectMake(0, TOP_TABBAR_HEIGHT, self.view.bounds.size.width,
                               CGRectGetHeight(self.clientView.bounds) -
                                   TOP_TABBAR_HEIGHT)];
  self.scrollView.contentSize =
      CGSizeMake(CGRectGetWidth(self.clientView.bounds) * 3,
                 CGRectGetHeight(self.clientView.bounds));
  self.scrollView.pagingEnabled = YES;
  self.scrollView.delegate = self;
  self.scrollView.showsHorizontalScrollIndicator = NO;
  self.scrollView.showsVerticalScrollIndicator = YES;
  self.scrollView.bounces = NO;
  self.scrollView.backgroundColor = [UIColor clearColor];
  [self.clientView addSubview:self.scrollView];
}

/** 设置标示线 在滚动是代理方法里 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

  if (scrollView == self.scrollView) {
    if (scrollView.contentOffset.x >= 0 &&
        scrollView.contentOffset.x <= self.clientView.width * 2) {
      self.topToolbarView.maxlineView.frame =
          CGRectMake(scrollView.contentOffset.x / 3,
                     self.topToolbarView.bounds.size.height - 3,
                     self.view.frame.size.width / 3, 2.5);
    }
  }
}

/** 点击标签回调 */
- (void)changeToIndex:(NSInteger)index {
  self.pageIndex = index;
  CGFloat screenWidth = self.view.bounds.size.width;
  [self.scrollView setContentOffset:CGPointMake(screenWidth * index, 0)
                           animated:YES];
  if (index == 0) {

    if (![self.myIssuanceVC.tableController dataBinded]) {
      [self.myIssuanceVC refreshButtonPressDown];
    }
  } else if (index == 1) {
    if (![self.myCommentVC.tableController dataBinded]) {
      [self.myCommentVC refreshButtonPressDown];
    }
  } else {
    if (!self.myCollectTweetVC.tableController.dataBinded) {
      [self.myCollectTweetVC refreshButtonPressDown];
    }
  }
}

- (void)refreshButtonPressDown {
  [_indicatorView startAnimating];
  if (self.pageIndex == 0) {
    [self.myIssuanceVC refreshButtonPressDown];
  } else if (self.pageIndex == 1) {
    [self.myCommentVC refreshButtonPressDown];
  } else {
    [self.myCollectTweetVC refreshButtonPressDown];
  }
}

#pragma mark scrollView代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  if (scrollView == _scrollView) {
    CGPoint offset = scrollView.contentOffset;

    if (offset.x == 0) {
      [self.topToolbarView changTapToIndex:0];
    } else if (offset.x == WIDTH_OF_VIEWCONTROLLER) {
      [self.topToolbarView changTapToIndex:1];
    } else if (offset.x == WIDTH_OF_VIEWCONTROLLER * 2) {
      [self.topToolbarView changTapToIndex:2];
    }
  }
}

- (MyIssuanceViewController *)myIssuanceVC {
  if (_myIssuanceVC == nil) {
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.scrollView.bounds),
                              CGRectGetHeight(self.scrollView.bounds));
    _myIssuanceVC = [[MyIssuanceViewController alloc] initWithFrame:frame];
    _myIssuanceVC.tableController.clientView = self.clientView;
    __weak MyChatStockViewController *weakSelf = self;
    _myIssuanceVC.beginRefreshCallBack = ^{
      [weakSelf.indicatorView startAnimating];
    };

    _myIssuanceVC.endRefreshCallBack = ^{
      [weakSelf.indicatorView stopAnimating];
    };
    [self addChildViewController:_myIssuanceVC];
  }
  return _myIssuanceVC;
}

- (MyCommentViewController *)myCommentVC {
  if (_myCommentVC == nil) {
    CGRect frame = CGRectMake(CGRectGetWidth(self.scrollView.bounds), 0,
                              CGRectGetWidth(self.scrollView.bounds),
                              CGRectGetHeight(self.scrollView.bounds));
    _myCommentVC = [[MyCommentViewController alloc] initWithFrame:frame];
    __weak MyChatStockViewController *weakSelf = self;
    _myCommentVC.beginRefreshCallBack = ^{
      [weakSelf.indicatorView startAnimating];
    };

    _myCommentVC.endRefreshCallBack = ^{
      [weakSelf.indicatorView stopAnimating];
    };
    [self addChildViewController:_myCommentVC];
  }
  return _myCommentVC;
}

- (MyCollectTweetViewController *)myCollectTweetVC {
  if (_myCollectTweetVC == nil) {
    CGRect frame = CGRectMake(CGRectGetWidth(self.scrollView.bounds) * 2, 0,
                              CGRectGetWidth(self.scrollView.bounds),
                              CGRectGetHeight(self.scrollView.bounds));
    _myCollectTweetVC =
        [[MyCollectTweetViewController alloc] initWithFrame:frame];
    __weak MyChatStockViewController *weakSelf = self;
    _myCollectTweetVC.beginRefreshCallBack = ^{
      [weakSelf.indicatorView startAnimating];
    };

    _myCollectTweetVC.endRefreshCallBack = ^{
      [weakSelf.indicatorView stopAnimating];
    };
    [self addChildViewController:_myCollectTweetVC];
  }
  return _myCollectTweetVC;
}

@end
