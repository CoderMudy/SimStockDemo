//
//  StockPersonTransactionViewController.m
//  SimuStock
//
//  Created by moulin wang on 14-4-10.
//  Copyright (c) 2014年 Mac. All rights reserved.
//
#import "StockPersonTransactionViewController.h"

@implementation StockPersonTransactionViewController

- (id)initWithUserID:(NSString *)userId
        withUserName:(NSString *)userName
         withMatchID:(NSString *)matchID {
  if (self = [super init]) {
    self.uid = userId;
    self.titleName = userName;
    self.matchid = matchID;
    pageIndex = 0;
  }
  return self;
}

//点击标签回调
- (void)changeToIndex:(NSInteger)index {
  pageIndex = index;
  CGFloat screenWidth = self.view.bounds.size.width;
  [_scrollView setContentOffset:CGPointMake(screenWidth * index, 0)
                       animated:YES];
  if (index == 0) {
  } else {
    
    double delayInSeconds = 0.5;
    dispatch_time_t popTime =
    dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
          if (!closedPositionVC.dataBinded) {
            [closedPositionVC refreshButtonPressDown];
          }
      
    });
    

  }
}

- (void)refreshButtonPressDown {
  [_indicatorView startAnimating];
  if (pageIndex == 0) {
    [stockTradeListViewController refreshButtonPressDown];
  } else {
    [closedPositionVC refreshButtonPressDown];
  }
}

- (void)viewDidLoad {
  [super viewDidLoad];

  topToolbarView = [[TopToolBarView alloc]
            initWithFrame:CGRectMake(0, 0, _clientView.bounds.size.width, TOP_TABBAR_HEIGHT)
                DataArray:@[ @"交易明细", @"已经清仓" ]
      withInitButtonIndex:0];
  topToolbarView.delegate = self;
  [_clientView addSubview:topToolbarView];
  _littleCattleView.hidden = YES;

  [self createScrollView];
  [self creatAllViews];

  _indicatorView.delegate = self;
  _indicatorView.hidden = NO;
  [self createTableView];
  //创建另一个视图
  [self createOtherView];
  [self refreshButtonPressDown];
}

- (void)viewDidAppear:(BOOL)animated {

  [super viewDidAppear:animated];
  _scrollView.contentSize =
      CGSizeMake(WIDTH_OF_SCREEN * 2, _scrollView.bounds.size.height);
}

- (void)createTableView {
  if (stockTradeListViewController == nil) {
    CGRect frame =
    CGRectMake(0, 0, WIDTH_OF_SCREEN, CGRectGetHeight(_scrollView.bounds));
    //交易明细
    stockTradeListViewController =
    [[StockTradeListViewController alloc] initWithFrame:frame
                                             withUserId:self.uid
                                          withStockCode:self.stockCode
                                           withUserName:self.titleName
                                            withMatckId:self.matchid];
    
    __weak StockPersonTransactionViewController *weakSelf = self;
    stockTradeListViewController.beginRefreshCallBack = ^{
      [weakSelf.indicatorView startAnimating];
    };
    
    stockTradeListViewController.endRefreshCallBack = ^{
      [weakSelf.indicatorView stopAnimating];
    };
  }
   [_scrollView addSubview:stockTradeListViewController.view];
  [self addChildViewController:stockTradeListViewController];
}

- (void)createOtherView {
  if (closedPositionVC == nil) {
    //创建已清仓股票
    CGRect frame = CGRectMake(WIDTH_OF_SCREEN, 0, WIDTH_OF_SCREEN,
                              CGRectGetHeight(_scrollView.bounds));
    closedPositionVC =
    [[ClosedPositionViewController alloc] initWithFrame:frame
                                             withUserId:self.uid
                                            withMatckId:self.matchid];
    [closedPositionVC.littleCattleView setInformation:@"暂无交易数据"];
    __weak StockPersonTransactionViewController *weakSelf = self;
    closedPositionVC.beginRefreshCallBack = ^{
      [weakSelf.indicatorView startAnimating];
    };
    
    closedPositionVC.endRefreshCallBack = ^{
      [weakSelf.indicatorView stopAnimating];
    };
  }
  [_scrollView addSubview:closedPositionVC.view];
  [self addChildViewController:closedPositionVC];
}

//创建滚动视图
- (void)createScrollView {
  _scrollView = [[UIScrollView alloc]
      initWithFrame:CGRectMake(0, TOP_TABBAR_HEIGHT, self.view.bounds.size.width,
                               CGRectGetHeight(_clientView.bounds) - TOP_TABBAR_HEIGHT)];
  _scrollView.contentSize = CGSizeMake(CGRectGetWidth(_clientView.bounds) * 2,
                                       CGRectGetHeight(_clientView.bounds));
  _scrollView.pagingEnabled = YES;
  _scrollView.delegate = self;
  _scrollView.showsHorizontalScrollIndicator = NO;
  _scrollView.showsVerticalScrollIndicator = YES;
  //_scrollView.contentInset = UIEdgeInsetsZero;
  _scrollView.bounces = NO;
  _scrollView.backgroundColor = [UIColor clearColor];
  [_clientView addSubview:_scrollView];
}
//设置标示线 在滚动是代理方法里
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

  if (scrollView == _scrollView) {
    if (scrollView.contentOffset.x >= 0 &&
        scrollView.contentOffset.x <= self.view.frame.size.width) {
      topToolbarView.maxlineView.frame = CGRectMake(
          scrollView.contentOffset.x / 2, topToolbarView.bounds.size.height - 3,
          self.view.frame.size.width / 2, 2.5);
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
    }
  }
}

#pragma mark 区分上层界面
//总函数
- (void)creatAllViews {
  NSString *user_id = [SimuUtil getUserID];
  if ([user_id isEqualToString:self.uid]) {
    [_topToolBar resetContentAndFlage:@"我的交易" Mode:TTBM_Mode_Leveltwo];
  } else {
    [_topToolBar resetContentAndFlage:@"TA的交易" Mode:TTBM_Mode_Leveltwo];
  }
}

@end
