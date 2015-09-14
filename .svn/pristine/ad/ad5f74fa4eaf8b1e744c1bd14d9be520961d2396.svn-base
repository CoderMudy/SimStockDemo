//
//  HotRecommendStockViewController.m
//  SimuStock
//
//  Created by Yuemeng on 14/12/23.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "HotRecommendStockViewController.h"
#import "AppDelegate.h"

@implementation HotRecommendStockViewController

- (void)dealloc {
  [_headerView free];
  [_footerView free];
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [_littleCattleView setInformation:@"暂无数据"];

  [self resetTitle:@"热门推荐"];

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
  [self requestGetEliteListDataWithFromId:@0];
}

-(void) addObservers{

  [[NSNotificationCenter defaultCenter]
   addObserverForName:ShareWeiboSuccessNotification
   object:nil
   queue:[NSOperationQueue mainQueue]
   usingBlock:^(NSNotification *notif) {
     NSDictionary *userInfo = [notif userInfo];
     TweetListItem *homeData = userInfo[@"data"];
     if (homeData) {
       for (int i = 0; i < _hotStockBarList.array.count; i++) {
         TweetListItem *weiboItem = _hotStockBarList.array[i];
         if (weiboItem.tstockid.longLongValue ==
             homeData.tstockid.longLongValue) {
           weiboItem.share = weiboItem.share + 1;
           //刷新单行数据，如果存在的话
           NSIndexPath *indexPath =
           [NSIndexPath indexPathForRow:i inSection:0];
           UITableViewCell *cell =
           [_tableView cellForRowAtIndexPath:indexPath];
           if (cell) {
             NSArray *rows = @[ indexPath ];
             [_tableView reloadRowsAtIndexPaths:rows
                               withRowAnimation:NO];
           }
           break;
         }
       }
     }
   }];
  [[NSNotificationCenter defaultCenter]
   addObserverForName:PraiseWeiboSuccessNotification
   object:nil
   queue:[NSOperationQueue mainQueue]
   usingBlock:^(NSNotification *notif) {
     NSDictionary *userInfo = [notif userInfo];
     TweetListItem *homeData = userInfo[@"data"];
     if (homeData) {
       for (int i = 0; i < _hotStockBarList.array.count; i++) {
         TweetListItem *weiboItem = _hotStockBarList.array[i];
         if (weiboItem.tstockid.longLongValue ==
             homeData.tstockid.longLongValue) {
           weiboItem.praise += 1;
           weiboItem.isPraised = YES;
           [NewShowLabel setMessageContent:@"赞成功"];
           
           //刷新单行数据，如果存在的话
           NSIndexPath *indexPath =
           [NSIndexPath indexPathForRow:i inSection:0];
           UITableViewCell *cell =
           (UITableViewCell *)
           [_tableView cellForRowAtIndexPath:indexPath];
           if (cell) {
             NSArray *rows = @[ indexPath ];
             [_tableView reloadRowsAtIndexPaths:rows
                               withRowAnimation:NO];
           }
           break;
         }
       }
     }
   }];
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
    [self requestGetEliteListDataWithFromId:@0];

    if (_hotStockBarList.dataBinded) {
      _footerView.hidden = NO;
    }
  } else {
    if (_isLoadMore || _hotStockBarList.dataComplete ||
        _hotStockBarList.array.count == 0) {
      return;
    }
    _isLoadMore = YES;
    NSNumber *fromId =
        [(TweetListItem *)_hotStockBarList.array.lastObject timelineid];
    [self requestGetEliteListDataWithFromId:fromId];
  }
}

#pragma mark - UITableView 代理
- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  return _hotStockBarList.array.count;
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  //取得数据绑定时计算的coreTextHeight
  TweetListItem *tweetItem = _hotStockBarList.array[indexPath.row];
  return tweetItem.weiboCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *weiboCellID = @"weiboCellID";
  WeiboCell *weiboCell =
      [_tableView dequeueReusableCellWithIdentifier:weiboCellID];

  if (!weiboCell) {
    weiboCell = [[[NSBundle mainBundle] loadNibNamed:@"WeiboCell"
                                               owner:self
                                             options:nil] firstObject];
    weiboCell.reuseId = weiboCellID;
  }

  //设置block回调
  __weak HotRecommendStockViewController *weakSelf = self;
  
    //刷新置顶聊股
  weiboCell.topButtonClickBlock = ^(TweetListItem *item) {
      //置顶后需要更新cell的高度，因为没标题的会有标题
    [weakSelf refreshTableViewCellHeightWithItem:item];
  };

  //刷新列表
  weiboCell.eliteButtonClickBlock = ^(BOOL isElite, NSNumber *tid) {
      //精华列表只能取消加精，所以两侧列表均本地删除数据
      [weakSelf tableViewDeleteTStock:tid];
  };

  //删除
  weiboCell.deleteButtonClickBlock =
      ^(NSNumber *tid) { [weakSelf tableViewDeleteTStock:tid]; };

  TweetListItem *tweetListItem = _hotStockBarList.array[indexPath.row];
  [weiboCell refreshCellInfoWithItem:tweetListItem];
  return weiboCell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
  [self tableView:tableView didDeselectRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView
    didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
  WeiboCell *cell = (WeiboCell *)[tableView cellForRowAtIndexPath:indexPath];
  TweetListItem *item = _hotStockBarList.array[indexPath.row];
  [WBDetailsViewController showTSViewWithTStockId:item.tstockid withBlock:^(BOOL praiseSuccess, BOOL commentSuccess, BOOL shareSuccess, NSInteger commentStatus) {
    if (commentSuccess) {
      if (commentStatus > 0) {
        item.comment = item.comment + 1;
      }
      else if (commentStatus < 0)
      {
        item.comment = item.comment - 1;
      }
      [cell.commentButton setTitle:[NSString stringWithFormat:@"%d", item.comment]
                          forState:UIControlStateNormal];
    }
  }];
}

#pragma mark 自动上拉加载
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
  if (indexPath.row == _hotStockBarList.array.count -1) {
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

#pragma mark 热门列表请求
- (void)requestGetEliteListDataWithFromId:(NSNumber *)fromId {
  if (![SimuUtil isExistNetwork]) {
    [self setNoNetwork];
    [self stopLoading];
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak HotRecommendStockViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
      HotRecommendStockViewController *strongSelf = weakSelf;
      if (strongSelf) {
        [strongSelf stopLoading];
        return NO;
      } else {
        return YES;
      }
  };

  callback.onSuccess = ^(NSObject *obj) {
      HotRecommendStockViewController *strongSelf = weakSelf;
      if (strongSelf) {
        [strongSelf resetPraiseStatus:(TweetList *)obj withFromId:fromId];
      }
  };
  callback.onFailed = ^{ [weakSelf setNoNetwork]; };

  [TweetList requestGetEliteListDataWithBarId:@(-1)
                                       withFromId:fromId
                                       withReqNum:20
                                     withCallback:callback];
}

#pragma mark 普通聊股和加精聊股公用的解析方法
- (void)resetPraiseStatus:(TweetList *)tweetListItem
               withFromId:(NSNumber *)fromId {
  //如果不是刷新
  if (![@"0" isEqualToString:[fromId stringValue]]) {
    NSNumber *lastId =
        ((TweetListItem *)_hotStockBarList.array.lastObject).timelineid;
    //如果不是连续请求
    if (![[fromId stringValue] isEqualToString:[lastId stringValue]]) {
      return;
    }
  }

  dispatch_async(dispatch_get_global_queue(0, 0),
                 ^{
      //动态计算并保存高度,在非UI线程中执行
      for (TweetListItem *tweetItem in tweetListItem.tweetListArray) {
//        tweetItem.weiboCellHeight = [WeiboCell heightWithTweetListItem:tweetItem];
        //查询coredata，是否已加赞，收藏等 ，检测登录
        if (![SimuUtil isLogined]) {
          tweetItem.isPraised = NO;
          tweetItem.isCollected = NO;
        } else {
          tweetItem.isPraised =
              [WBCoreDataUtil fetchPraiseTid:tweetItem.tstockid];
          tweetItem.isCollected =
              [WBCoreDataUtil fetchCollectTid:tweetItem.tstockid];
        }
      }
      //更新界面，切换回UI线程
      dispatch_async(dispatch_get_main_queue(), ^{
        for (TweetListItem *tweetItem in tweetListItem.tweetListArray) {
          tweetItem.weiboCellHeight =
          [WeiboCell heightWithTweetListItem:tweetItem];
        }
          [self bindEliteListData:tweetListItem withFromId:fromId];
      });
  });
}

- (void)bindEliteListData:(TweetList *)tweetListItem
               withFromId:(NSNumber *)fromId {
  
  _hotStockBarList.dataBinded = YES;
    //如果是刷新操作 清空
  if ([@"0" isEqualToString:[fromId stringValue]]) {
    [_hotStockBarList.array removeAllObjects];
    [_tableView setContentOffset:CGPointZero animated:NO];
  }
  
  if (tweetListItem.tweetListArray.count == 0) {
    [NewShowLabel setMessageContent:(_hotStockBarList.array.count == 0 ? @"暂无数据" : @"暂无更多数据")];
    _hotStockBarList.dataComplete = YES;
    _footerView.hidden = YES;
  } else {
    [_hotStockBarList.array addObjectsFromArray:tweetListItem.tweetListArray];
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

#pragma mark 刷新表格cell高度，置顶后必须刷新
- (void)refreshTableViewCellHeightWithItem:(TweetListItem *)tweetItem {
  NSInteger i = 0;
  for (TweetListItem *item in _hotStockBarList.array) {
    if ([[item.tstockid stringValue]
         isEqualToString:[tweetItem.tstockid stringValue]]) {
      item.title = tweetItem.title;
      item.weiboCellHeight = [WeiboCell heightWithTweetListItem:item];
      [_tableView
       reloadRowsAtIndexPaths:
           @[[NSIndexPath indexPathForRow:i inSection:0]]
       withRowAnimation:UITableViewRowAnimationNone];
      break;
    }
    i++;
  }
}

#pragma mark 删除列表相应数据
- (void)tableViewDeleteTStock:(NSNumber *)tid {
  NSInteger i = 0;
  for (TweetListItem *item in _hotStockBarList.array) {
    if ([[item.tstockid stringValue] isEqualToString:[tid stringValue]]) {
      //数据源、tableView中删除该对象
      [_hotStockBarList.array removeObjectAtIndex:i];
      [_tableView reloadData];
      break;
    }
    i++;
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
