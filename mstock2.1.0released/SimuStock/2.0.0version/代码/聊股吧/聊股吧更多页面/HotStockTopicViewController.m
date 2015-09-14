//
//  HotStockTopicViewController.m
//  SimuStock
//
//  Created by Yuemeng on 14/12/23.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "HotStockTopicViewController.h"
#import "AppDelegate.h"
#import "NewShowLabel.h"
#import "SimuUtil.h"
#import "BaseRequester.h"
#import "StockUtil.h"
#import "HotStockTopicCell.h"
#import "HotStockTopicListData.h"
#import "TrendViewController.h"

@implementation HotStockTopicViewController{
  ///股吧聊股总数变化通知
  __weak id observerBarWeiboSum;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:observerBarWeiboSum];
  [_headerView free];
  [_footerView free];
}

- (void)addObserver {
  __weak UITableView *weakTableView = _tableView;
  __weak DataArray *dataArray = _hotStockTopicList;
  observerBarWeiboSum = [[NSNotificationCenter defaultCenter]
      addObserverForName:StockBarWeiboSumChangeNotification
                  object:nil
                   queue:[NSOperationQueue mainQueue]
              usingBlock:^(NSNotification *notif) {
                  NSDictionary *userInfo = [notif userInfo];
                  NSString *stockCode = userInfo[@"stockCode"];
                  if (stockCode) {
                    for (HotStockTopicData *stockTopicData in dataArray.array) {
                      if ([stockTopicData.stockCode
                              isEqualToString:stockCode]) {
                        NSInteger post = stockTopicData.postNum.integerValue +
                                         [userInfo[@"operation"] intValue];
                        stockTopicData.postNum = @(post);
                        [weakTableView reloadData];
                        break;
                      }
                    }
                  }
              }];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [_littleCattleView setInformation:@"暂无数据"];

  [self resetTitle:@"热门个股吧"];

  _hotStockTopicList = [[DataArray alloc] init];

  _tableView = [[UITableView alloc]
      initWithFrame:CGRectMake(0.0, 0.0, WIDTH_OF_VIEWCONTROLLER,
                               _clientView.bounds.size.height)
              style:UITableViewStylePlain];
  _tableView.delegate = self;
  _tableView.dataSource = self;
  _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  _tableView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];

  [_clientView addSubview:_tableView];

  _headerView = [[MJRefreshHeaderView alloc] initWithScrollView:_tableView];
  _headerView.delegate = self;
  _footerView = [[MJRefreshFooterView alloc] initWithScrollView:_tableView];
  _footerView.delegate = self;
  _footerView.hidden = YES;

  [_indicatorView startAnimating];
  [self requestHotStockTopicListDataWithFromId:@0];
  [self addObserver];
}

#pragma mark - 菊花刷新
- (void)refreshButtonPressDown {
  [self refreshViewBeginRefreshing:_headerView];
}

#pragma mark - MJ 代理
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView {
  if (![SimuUtil isExistNetwork]) {
    [self performBlock:^{
        [_headerView endRefreshing];
        [_footerView endRefreshing];
    } withDelaySeconds:0.5];
    [NewShowLabel showNoNetworkTip]; //显示无网络提示
    _hotStockTopicList.dataBinded ? (_littleCattleView.hidden = YES)
                                  : [_littleCattleView isCry:YES];
    return;
  }

  if (refreshView == _headerView) {
    [_indicatorView startAnimating];
    [self requestHotStockTopicListDataWithFromId:@0];
    if (_hotStockTopicList.dataBinded) {
      _footerView.hidden = NO;
    }
  } else {
    if (_isLoadMore || _hotStockTopicList.dataComplete ||
        _hotStockTopicList.array.count == 0) {
      return;
    }
    _isLoadMore = YES;
    NSNumber *fromId =
        [(HotStockTopicData *)_hotStockTopicList.array.lastObject seqId];
    [self requestHotStockTopicListDataWithFromId:fromId];
  }
}

#pragma mark - UITableView 代理
- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  return _hotStockTopicList.array.count;
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 59.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *hotStockTopicCellID = @"hotStockTopicCell";
  HotStockTopicCell *hotStockTopicCell =
      [tableView dequeueReusableCellWithIdentifier:hotStockTopicCellID];
  if (!hotStockTopicCell) {
    hotStockTopicCell =
        [[[NSBundle mainBundle] loadNibNamed:@"HotStockTopicCell"
                                       owner:self
                                     options:nil] firstObject];
    hotStockTopicCell.reuseId = hotStockTopicCellID;
  }

  HotStockTopicData *hotStockTopicData =
      _hotStockTopicList.array[indexPath.row];

  [hotStockTopicCell refreshCellInfoWithData:hotStockTopicData];

  return hotStockTopicCell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
  [self tableView:tableView didDeselectRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView
    didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
  //股票分页
  HotStockTopicData *hotStockTopicData =
      _hotStockTopicList.array[indexPath.row];

  [TrendViewController showDetailWithStockCode:hotStockTopicData.stockCode
                                 withStockName:hotStockTopicData.stockName
                                 withFirstType:FIRST_TYPE_UNSPEC
                                   withMatchId:@"1"
                                 withStartPage:TPT_WB_Mode];
}

#pragma mark 自动上拉加载
- (void)tableView:(UITableView *)tableView
      willDisplayCell:(UITableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == _hotStockTopicList.array.count - 1) {
    [self refreshViewBeginRefreshing:_footerView];
  }
}

#pragma mark - -网络请求-
#pragma mark 无网提示
- (void)setNoNetwork {
  [NewShowLabel showNoNetworkTip]; //显示无网络提示
  [_indicatorView stopAnimating];  //停止菊花
  _hotStockTopicList.dataBinded ? (_littleCattleView.hidden = YES)
                                : [_littleCattleView isCry:YES];
}

- (void)stopLoading {
  [_indicatorView stopAnimating]; //停止菊花

  if ([_headerView isRefreshing]) {
    [_headerView endRefreshing];
  }

  if ([_footerView isRefreshing]) {
    [_footerView endRefreshing];
  }
}

#pragma mark 热门个股吧
- (void)requestHotStockTopicListDataWithFromId:(NSNumber *)fromId {
  if (![SimuUtil isExistNetwork]) {
    [self setNoNetwork];
    [self stopLoading];
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak HotStockTopicViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
      HotStockTopicViewController *strongSelf = weakSelf;
      if (strongSelf) {
        [strongSelf stopLoading];
        return NO;
      } else {
        return YES;
      }
  };

  callback.onSuccess = ^(NSObject *obj) {
      HotStockTopicViewController *strongSelf = weakSelf;
      if (strongSelf) {
        [strongSelf bindHotStockTopicListData:(HotStockTopicListData *) obj
                                   withFromId:fromId];
      }
  };
  callback.onFailed = ^{ [weakSelf setNoNetwork]; };

  [HotStockTopicListData requestHotStockTopicListDataWithFromId:fromId
                                                     withReqNum:20
                                                   withCallback:callback];
}

- (void)bindHotStockTopicListData:(HotStockTopicListData *)hotStockTopicListData
                       withFromId:(NSNumber *)fromId {

  _hotStockTopicList.dataBinded = YES;

  //如果不是刷新
  if (![@"0" isEqualToString:[fromId stringValue]]) {
    NSNumber *lastId =
        ((HotStockTopicData *)_hotStockTopicList.array.lastObject).seqId;
    //如果不是连续请求
    if (![[fromId stringValue] isEqualToString:[lastId stringValue]]) {
      return;
    }
  } else {
    [_hotStockTopicList.array removeAllObjects];
    [_tableView setContentOffset:CGPointZero animated:NO];
  }

  if (hotStockTopicListData.dataArray.count == 0) {
    [NewShowLabel setMessageContent:(_hotStockTopicList.array.count == 0
                                         ? @"暂无数据"
                                         : @"暂无更多数据")];
    _hotStockTopicList.dataComplete = YES;
    _footerView.hidden = YES;
  } else {
    [_hotStockTopicList.array
        addObjectsFromArray:hotStockTopicListData.dataArray];
    _hotStockTopicList.dataComplete = NO;
    _footerView.hidden = NO;
  }

  if (_hotStockTopicList.array.count == 0) {
    [_littleCattleView isCry:NO];
    _tableView.hidden = YES;
  } else {
    _littleCattleView.hidden = YES;
    _tableView.hidden = NO;
  }

  //如果是加载更多操作，只停止mjfooterView;
  if (_isLoadMore) {
    [_footerView endRefreshing];
    _isLoadMore = NO;
  } else {
    [_headerView endRefreshing];
    [_indicatorView stopAnimating]; //停止菊花
  }

  [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
