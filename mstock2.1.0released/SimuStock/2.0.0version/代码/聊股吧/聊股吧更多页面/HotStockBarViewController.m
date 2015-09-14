//
//  HotStockBarViewController.m
//  SimuStock
//
//  Created by Yuemeng on 14/12/23.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "HotStockBarViewController.h"
#import "MyStockBarsCell.h"
#import "HotStockBarListData.h"
#import "StockBarDetailViewController.h"
#import "AppDelegate.h"
#import "NewShowLabel.h"
#import "SimuUtil.h"
#import "BaseRequester.h"
#import "WBCoreDataUtil.h"

@implementation HotStockBarViewController

- (void)dealloc {
  [_headerView free];
  [_footerView free];
}

- (id)initWithType:(NSInteger)type {
  self = [super init];
  if (self) {
    _type = type;
  }
  return self;
}

- (id)initWithReturnBarIDCallBack:(returnBarIDBlock)callback {
  self = [super init];
  if (self) {
    _style = ReturnBarIDStyle;
    _returnBarIDBlock = callback;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [_littleCattleView setInformation:@"暂无数据"];

  if (_style == DefaultStyle) {
    [self resetTitle:_type == 0 ? @"主题吧" : @"牛人吧"];
  } else if (_style == ReturnBarIDStyle) {
    [self resetTitle:@"选择聊股吧"];
  }

  _hotStockBarList = [[DataArray alloc] init];

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
  
  [self requestThemeAndMasterOrHotBarListDataWithSeqId:@(-1)];
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
    _hotStockBarList.dataBinded ? (_littleCattleView.hidden = YES)
                                : [_littleCattleView isCry:YES];
    return;
  }

  if (refreshView == _headerView) {
    [_indicatorView startAnimating];
    [self requestThemeAndMasterOrHotBarListDataWithSeqId:@(-1)];
    if (_hotStockBarList.dataBinded) {
      _footerView.hidden = NO;
    }
  } else {
    if (_isLoadMore || _hotStockBarList.dataComplete ||
        _hotStockBarList.array.count == 0) {
      return;
    }
    _isLoadMore = YES;
    NSNumber *seqId =
        [(HotStockBarData *)_hotStockBarList.array.lastObject seqId];
    [self requestThemeAndMasterOrHotBarListDataWithSeqId:seqId];
  }
}

#pragma mark - UITableView 代理
- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  return _hotStockBarList.array.count;
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 59.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *hotStockBarCellID = @"hotStockBarCell";
  MyStockBarsCell *hotStockBarCell =
      [tableView dequeueReusableCellWithIdentifier:hotStockBarCellID];
  if (!hotStockBarCell) {
    hotStockBarCell = [[[NSBundle mainBundle] loadNibNamed:@"MyStockBarsCell"
                                                     owner:self
                                                   options:nil] firstObject];
    hotStockBarCell.reuseId = hotStockBarCellID;
  }

  HotStockBarData *hotStockBarData = _hotStockBarList.array[indexPath.row];
    //设置数据
  [hotStockBarCell refreshCellInfoWithData:hotStockBarData];

  return hotStockBarCell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
  [self tableView:tableView didDeselectRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView
    didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
  HotStockBarData *hotStockBarData = _hotStockBarList.array[indexPath.row];

  if (_style == DefaultStyle) {
    StockBarDetailViewController *stockBarDetailVC =
        [[StockBarDetailViewController alloc] init];
    stockBarDetailVC.barTitle = hotStockBarData.name;
    stockBarDetailVC.barId = hotStockBarData.barId;
    stockBarDetailVC.isFollowed =
        [WBCoreDataUtil fetchBarId:hotStockBarData.barId];

    __weak UITableView *weakTableView = _tableView;
    stockBarDetailVC.updateBarTStock = ^(NSNumber *barId, BOOL isAdd) {
        //刷新聊股数
        NSInteger post = hotStockBarData.postNum.integerValue;
        post += (isAdd ? 1 : -1);
        hotStockBarData.postNum = @(post);
        [weakTableView reloadData];
    };
    [AppDelegate pushViewControllerFromRight:stockBarDetailVC];

    //为主页发表返回barID
  } else if (_style == ReturnBarIDStyle) {
    if (_returnBarIDBlock) {
      _returnBarIDBlock(hotStockBarData.barId, hotStockBarData.name);
    }
    [self leftButtonPress];
  }
}

#pragma mark 自动上拉加载
- (void)tableView:(UITableView *)tableView
      willDisplayCell:(UITableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == _hotStockBarList.array.count - 1 &&
      (cell.frame.origin.y > HEIGHT_OF_SCREEN)) {
    [self refreshViewBeginRefreshing:_footerView];
  }
}

#pragma mark - -网络请求-
#pragma mark 无网提示
- (void)setNoNetwork {
  [NewShowLabel showNoNetworkTip]; //显示无网络提示
  [_indicatorView stopAnimating];  //停止菊花
  _hotStockBarList.dataBinded ? (_littleCattleView.hidden = YES)
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

#pragma mark 主题或牛人聊股吧
- (void)requestThemeAndMasterOrHotBarListDataWithSeqId:(NSNumber *)seqId {

  if (![SimuUtil isExistNetwork]) {
    [self setNoNetwork];
    [self stopLoading];
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak HotStockBarViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
      HotStockBarViewController *strongSelf = weakSelf;
      if (strongSelf) {
        [strongSelf stopLoading];
        return NO;
      } else {
        return YES;
      }
  };

  callback.onSuccess = ^(NSObject *obj) {
      HotStockBarViewController *strongSelf = weakSelf;
      if (strongSelf) {
        [strongSelf bindHotStockBarListData:(HotStockBarListData *) obj
                                  withseqId:seqId];
      }
  };
  callback.onFailed = ^{ [weakSelf setNoNetwork]; };

  if (_style == DefaultStyle) {
    [HotStockBarListData requestHotStockBarListDataWithFromId:seqId
                                                   withReqNum:20
                                                     withType:_type
                                                 withCallback:callback];
  } else if (_style == ReturnBarIDStyle) {
    [HotStockBarListData requestHotStockBarListDataWithFromId:seqId
                                                   withReqNum:20
                                                 withCallback:callback];
  }
}

- (void)bindHotStockBarListData:(HotStockBarListData *)hotStockBarList
                      withseqId:(NSNumber *)seqId {

  _hotStockBarList.dataBinded = YES;
  //如果不是刷新
  if (![@"-1" isEqualToString:[seqId stringValue]]) {
    NSNumber *lastId =
        ((HotStockBarData *)_hotStockBarList.array.lastObject).seqId;
    //如果不是连续请求
    if (![[seqId stringValue] isEqualToString:[lastId stringValue]]) {
      return;
    }
  } else {
    [_hotStockBarList.array removeAllObjects];
    [_tableView setContentOffset:CGPointZero animated:NO];
  }

  if (hotStockBarList.dataArray.count == 0) {
    [NewShowLabel setMessageContent:(_hotStockBarList.array.count == 0
                                         ? @"暂无数据"
                                         : @"暂无更多数据")];
    _hotStockBarList.dataComplete = YES;
    _footerView.hidden = YES;
  } else {
    [_hotStockBarList.array addObjectsFromArray:hotStockBarList.dataArray];
    _hotStockBarList.dataComplete = NO;
    _footerView.hidden = NO;
  }

  if (_hotStockBarList.array.count == 0) {
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

#pragma mark -

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
