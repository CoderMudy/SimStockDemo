//
//  VipSectionViewController.m
//  SimuStock
//
//  Created by Mac on 15/5/24.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "VipSectionViewController.h"
#import "MasterTradeListWrapper.h"
#import "ExpertHomePageTbaleVC.h"

@implementation VIPStockTradeAdapter
/** 头高 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return 0;
}

/** 头 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  return nil;
}

@end

@implementation VIPStockTradeTableViewController
/** 返回表格数据适配器，此方法子类必须实现 */
- (BaseTableAdapter *)getBaseTableAdaperWithDataList:(DataArray *)dataList {
  if (_tableAdapter == nil) {
    _tableAdapter = [[VIPStockTradeAdapter alloc] initWithTableViewController:self
                                                                withDataArray:self.dataArray];
    UINib *cellNib = [UINib nibWithNibName:_tableAdapter.nibName bundle:nil];
    //注册cell
    [self.tableView registerNib:cellNib forCellReuseIdentifier:_tableAdapter.nibName];
  }
  return _tableAdapter;
}

/** 请求最新数据，此方法子类必须实现 */
- (void)requestDataListWithRefreshType:(RefreshType)refreshType
                         withDataArray:(DataArray *)existDataList
                          withCallBack:(HttpRequestCallBack *)callback {
  [MasterTradeListWrapper requestVipTradeListWithInput:[self getRequestParamertsWithRefreshType:refreshType]
                                          withCallback:callback];
}

@end

@implementation VipSectionViewController

static CGFloat TabBarHeight = 40.f;

- (void)viewDidLoad {
  [super viewDidLoad];
  [_topToolBar resetContentAndFlage:@"VIP专区" Mode:TTBM_Mode_Leveltwo];

  [self createBottomTabBar];
  [self createScrollView];
  [self createTabViewController];

  [topToolbarView buttonSelectedAtIndex:0 animation:NO];

  [self refreshButtonPressDown];
}
- (void)createBottomTabBar {
  CGRect toolbarFrame = CGRectMake(0, self.clientView.bounds.size.height - TabBarHeight,
                                   self.view.bounds.size.width, TabBarHeight);
  __weak VipSectionViewController *weakSelf = self;
  topToolbarView =
      [[SimuBottomTabView alloc] initWithFrame:toolbarFrame
                                    titleArray:@[ @"精选牛人交易", @"精选股市资讯" ]];

  topToolbarView.tabSelectedAtIndex = ^(NSInteger index) {
    [weakSelf changeToIndex:index];
  };
  [self.clientView addSubview:topToolbarView];
}

- (void)createTabViewController {
  CGFloat width = self.view.size.width;

  CGRect frame1 = CGRectMake(width * 0, 0, width, CGRectGetHeight(_scrollView.bounds));
  vipOrientedTradesVC = [[VIPStockTradeTableViewController alloc] initWithFrame:frame1];
  __weak VipSectionViewController *weakSelf = self;
  vipOrientedTradesVC.beginRefreshCallBack = ^{
    [weakSelf.indicatorView startAnimating];
  };

  vipOrientedTradesVC.endRefreshCallBack = ^{
    [weakSelf.indicatorView stopAnimating];
  };
  [_scrollView addSubview:vipOrientedTradesVC.view];
  [self addChildViewController:vipOrientedTradesVC];

  CGRect frame2 = CGRectMake(width * 1, 0, width, CGRectGetHeight(_scrollView.bounds));
  NSString *url =
      [wap_address stringByAppendingString:@"/mobile/wap_vip_bus/fragment/html/vipEarlyBus.html"];
  vipOrientedWebViewVC =
      [[BaseWebViewController alloc] initWithFrame:frame2 withNameTitle:nil andPath:url];
  vipOrientedWebViewVC.beginRefreshCallBack = ^{
    [weakSelf.indicatorView startAnimating];
  };

  vipOrientedWebViewVC.endRefreshCallBack = ^{
    [weakSelf.indicatorView stopAnimating];
  };
  [_scrollView addSubview:vipOrientedWebViewVC.view];
  [self addChildViewController:vipOrientedWebViewVC];
}

- (void)refreshButtonPressDown {
  if (pageIndex == 0) {
    [vipOrientedTradesVC refreshButtonPressDown];
  } else {
    [vipOrientedWebViewVC refreshButtonPressDown];
  }
}

//点击标签回调
- (void)changeToIndex:(NSInteger)index {
  pageIndex = index;
  CGFloat screenWidth = self.view.bounds.size.width;
  [_scrollView setContentOffset:CGPointMake(screenWidth * index, 0) animated:YES];
  if (pageIndex == 0) {
    if (!vipOrientedTradesVC.dataBinded) {
      [vipOrientedTradesVC refreshButtonPressDown];
    }
  } else {
    if (!vipOrientedWebViewVC.dataBinded) {
      [vipOrientedWebViewVC refreshButtonPressDown];
    }
  }
}

//创建滚动视图
- (void)createScrollView {
  CGFloat width = self.view.bounds.size.width;
  CGFloat height = CGRectGetHeight(self.clientView.bounds) - TabBarHeight;

  _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
  _scrollView.contentSize = CGSizeMake(width * 2, height);
  _scrollView.pagingEnabled = YES;
  _scrollView.delegate = self;
  _scrollView.showsHorizontalScrollIndicator = NO;
  _scrollView.showsVerticalScrollIndicator = YES;
  _scrollView.bounces = NO;
  _scrollView.backgroundColor = [UIColor clearColor];
  [self.clientView addSubview:_scrollView];
}

#pragma mark scrollView代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  if (scrollView == _scrollView) {
    CGPoint offset = scrollView.contentOffset;
    NSInteger index = (NSInteger)offset.x / WIDTH_OF_VIEWCONTROLLER;
    [topToolbarView buttonSelectedAtIndex:index animation:YES];
  }
}
//设置标示线 在滚动是代理方法里
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

  if (scrollView == _scrollView) {
    if (scrollView.contentOffset.x >= 0 && scrollView.contentOffset.x <= self.view.frame.size.width) {
      topToolbarView.blueLineView.frame =
          CGRectMake(scrollView.contentOffset.x / 2, 0, self.view.frame.size.width / 2, 3);
    }
  }
}
@end
