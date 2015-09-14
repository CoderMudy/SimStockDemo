//
//  TrendWeiboViewController.m
//  SimuStock
//
//  Created by Yuemeng on 14/12/25.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "TrendWeiboViewController.h"
#import "TrendChatStockPageTableVC.h"
#import "TweetListItem.h"
#import "TrendViewController.h"

@implementation TrendWeiboViewController

- (id)initCode:(NSString *)stockCode
          name:(NSString *)stockName
    controller:(TrendViewController *)trendVC {
  if (self = [super init]) {
    _stockCode = stockCode;
    _stockName = stockName;
    _trendVC = trendVC;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  _topToolBar.hidden = YES;

  [_littleCattleView resetOffsetY:-100];
  [_littleCattleView setInformation:@"暂无数据"];

  /// 35：行情页上toolbar，45：下toolBar，共计80
  tableVC = [[TrendChatStockPageTableVC alloc]
      initWithFrame:CGRectMake(0.f, 0.f, WIDTH_OF_VIEWCONTROLLER, _clientView.bounds.size.height - 80.f)];
  tableVC.stockCode = self.stockCode;
  __weak TrendWeiboViewController *weakSelf = self;
  tableVC.showTableFooter = YES;
  tableVC.beginRefreshCallBack = ^{
    [weakSelf callLadIndicator:YES];
  };

  tableVC.endRefreshCallBack = ^{
    [weakSelf callLadIndicator:NO];
  };
  [self addChildViewController:tableVC];
  [_clientView addSubview:tableVC.view];

  CGRect clientFrame = _clientView.frame;
  clientFrame.origin.y -= topToolBarHeight;
  clientFrame.size.height = tableVC.tableView.height;
  _clientView.frame = clientFrame;

  /// 行情菊花转动
  [self callLadIndicator:YES];

  /// 延迟请求，否则卡顿
  [self performBlock:^{
    [self refreshButtonPressDown];
  } withDelaySeconds:0.25];
}

- (void)refreshButtonPressDown {
  //点击刷新按钮时网络请求
  [tableVC refreshButtonPressDown];
}

#pragma mark - 添加发布聊股后的，第一条假数据
- (void)disVC_data:(TweetListItem *)tweetObject {
  if (tweetObject) {
    //直接本地刷新
    [tableVC.dataArray.array insertObject:tweetObject atIndex:0];
    tableVC.dataArray.dataBinded = YES;
    _littleCattleView.hidden = YES;
    tableVC.view.hidden = NO;
    [tableVC.tableView reloadData];
  }
}

#pragma mark - -网络请求-

- (void)stopLoading {
  //行情页菊花停止
  [self callLadIndicator:NO];
}

#pragma mark - 对行情页代理
/** 调用加载圈 */
- (void)callLadIndicator:(BOOL)refresh {
  [_trendVC refreshData:refresh];
}
//调用加载圈
- (void)interfaceSwitchingTriggerLoadIndicator {
  [self callLadIndicator:YES];
}

/** 行情切换股票时刷新数据 */
- (void)refreshDataWithStockCode:(NSString *)stockCode {
  if (_stockCode && [_stockCode isEqualToString:stockCode]) {
    return;
  }
  _stockCode = stockCode;
  tableVC.stockCode = stockCode;
  [self refreshButtonPressDown];
}

@end
