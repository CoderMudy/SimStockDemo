//
//  SecuritiesTrendVC.m
//  SimuStock
//
//  Created by Mac on 15/5/13.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SecuritiesTrendVC.h"
#import "ComposePartTimeVC.h"
#import "BaseKLineVC.h"
#import "BaseFiveDaysVC.h"
#import "LandscapeKLineViewController.h"

///头部Tab的高度
static CGFloat TabHeight = 36.5f;

static CGFloat TabMargin = 5.f;

@implementation SecuritiesTrendVC

- (instancetype)initWithFrame:(CGRect)frame
           withSecuritiesInfo:(SecuritiesInfo *)securitiseInfo {
  if (self = [super initWithFrame:frame]) {
    self.securitiesInfo = securitiseInfo;
    trendVCs = [[NSMutableArray alloc] init];
    tvc_pageType = 0;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self createTabViews];
  [self tabSelected:tvc_pageType];

  //点按弹出横屏视图
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
      initWithTarget:self
              action:@selector(showLandscapeKLineVC)];
  [self.view addGestureRecognizer:tap];
}

- (CGRect)trendViewFrame {
  return CGRectMake(0, TabHeight, self.view.bounds.size.width,
                    self.view.bounds.size.height - TabHeight);
}

- (void)showLandscapeKLineVC {
  self.securitiesInfo.otherInfoDic = [@{} mutableCopy];
  LandscapeKLineViewController *landscapeVC =
      [[LandscapeKLineViewController alloc]
          initWithSecuritiesInfo:self.securitiesInfo
                   withPageIndex:tvc_pageType];
  [AppDelegate pushViewControllerFromBottom:landscapeVC];
}

- (NSArray *)tabStringArray {
  NSString *firstType = self.securitiesInfo.securitiesFirstType();
  if ([StockUtil isFund:firstType]) {
    return @[ @"分时", @"净值", @"日线", @"周线", @"月线" ];
  } else {
    return @[ @"分时", @"五日", @"日线", @"周线", @"月线" ];
  }
}

- (void)resetWithFrame:(CGRect)frame
    withSecuritiesInfo:(SecuritiesInfo *)securitiesInfo {
  self.securitiesInfo = securitiesInfo;
  [self createTabViews];
}

//创建走势，日线的切换Tab小控件
- (void)createTabViews {
  if (tvc_centerTabView) {
    [tvc_centerTabView removeFromSuperview];
  }
  tvc_centerTabView = [[SimuCenterTabView alloc]
      initWithFrame:CGRectMake(TabMargin, 1,
                               self.view.bounds.size.width - TabMargin * 2,
                               TabHeight - TabMargin * 2)
         titleArray:self.tabStringArray];
  tvc_centerTabView.delegate = self;

  [self.view addSubview:tvc_centerTabView];

  //重建TabViewController
  [trendVCs removeAllObjects];
  for (int i = 0; i < self.tabStringArray.count; i++) {
    BaseTrendVC *trendVC = [self createTrendVConTab:i];
    trendVC.beginRefreshCallBack = self.beginRefreshCallBack;
    trendVC.endRefreshCallBack = self.endRefreshCallBack;
    trendVCs[i] = trendVC;
  }
}

- (BaseTrendVC *)createTrendVConTab:(NSInteger)index {
  NSString *firstType = self.securitiesInfo.securitiesFirstType();

  switch (index) {
  case 0: {
    ComposePartTimeVC *baseTrendVC =
        [[ComposePartTimeVC alloc] initWithFrame:self.trendViewFrame
                              withSecuritiesInfo:self.securitiesInfo];
    baseTrendVC.stockQuotationInfoReady = self.stockQuotationInfoReady;
    return baseTrendVC;
  }
  case 1: {
    if ([StockUtil isFund:firstType]) { //净值
      return [[PortaitFundNetValueVC alloc] initWithFrame:self.trendViewFrame
                                       withSecuritiesInfo:self.securitiesInfo];
    } else { //五日
      return [[PortaitFiveDaysVC alloc] initWithFrame:self.trendViewFrame
                                   withSecuritiesInfo:self.securitiesInfo];
    }
  }
  case 2: {
    return [[BaseKLineVC alloc] initWithFrame:self.trendViewFrame
                           withSecuritiesInfo:self.securitiesInfo
                                withKLineType:@"D"];
  }
  case 3: {
    return [[BaseKLineVC alloc] initWithFrame:self.trendViewFrame
                           withSecuritiesInfo:self.securitiesInfo
                                withKLineType:@"W"];
  }
  case 4: {
    return [[BaseKLineVC alloc] initWithFrame:self.trendViewFrame
                           withSecuritiesInfo:self.securitiesInfo
                                withKLineType:@"M"];
  }

  default:
    return nil;
  }
}
#pragma mark
#pragma mark SimuCenterTabViewDelegate 分时和K线，周线切换函数协议
- (void)tabSelected:(NSInteger)index {
  if (currentVC) {
    [currentVC.view removeFromSuperview];
    [currentVC removeFromParentViewController];
  }
  tvc_pageType = index;
  BaseTrendVC *baseTrendVC = trendVCs[index];
  baseTrendVC.view.frame = self.trendViewFrame;
  baseTrendVC.securitiesInfo = self.securitiesInfo;
  [self.view addSubview:baseTrendVC.view];
  [self addChildViewController:baseTrendVC];

  currentVC = baseTrendVC;

  if (!baseTrendVC.dataBinded) {
    [baseTrendVC refreshView];
  }
}

- (void)refreshView {
  BaseTrendVC *baseTrendVC = trendVCs[tvc_pageType];
  [baseTrendVC refreshView];

  //刷新时，分时页面强制刷新
  if (tvc_pageType != 0) {
    baseTrendVC = trendVCs[0];
    [baseTrendVC refreshView];
  }
}

#pragma mark
- (void)setNoNetwork {
  [NewShowLabel showNoNetworkTip];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  NSNumber *pageIndexObj =
      self.securitiesInfo.otherInfoDic[SelectTrendViewIndexKey];
  if (pageIndexObj) {
    NSInteger pageIndex = [pageIndexObj integerValue] < trendVCs.count
                              ? [pageIndexObj integerValue]
                              : 0;
    if (pageIndex != tvc_pageType) {
      [tvc_centerTabView buttonSelected:pageIndex];
    }
  }
}

@end
