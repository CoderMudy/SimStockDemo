//
//  WeiboListViewController.m
//  SimuStock
//
//  Created by Mac on 15/4/19.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "WeiboListViewController.h"

#import "WeiboCell.h"
#import "WBCoreDataUtil.h"
#import "WBDetailsViewController.h"
#import "MatchStockChatController.h"
#import "UITableView+Reload.h"

@implementation WeiboListViewController {
  ///分享
  __weak id observerShare;
  ///赞
  __weak id observerPraise;
  ///评论
  __weak id observerComment;
  ///收藏
  __weak id observerFavorite;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:observerShare];
  [[NSNotificationCenter defaultCenter] removeObserver:observerPraise];
  [[NSNotificationCenter defaultCenter] removeObserver:observerComment];
  [[NSNotificationCenter defaultCenter] removeObserver:observerFavorite];
  [_headerView free];
  [_footerView free];
}

- (void)addObservers {
  observerShare = [[NSNotificationCenter defaultCenter]
      addObserverForName:ShareWeiboSuccessNotification
                  object:nil
                   queue:[NSOperationQueue mainQueue]
              usingBlock:^(NSNotification *notif) {
                NSDictionary *userInfo = [notif userInfo];
                TweetListItem *homeData = userInfo[@"data"];
                if (homeData) {
                  for (int i = 0; i < _dataList.array.count; i++) {
                    TweetListItem *weiboItem = _dataList.array[i];
                    if (weiboItem.tstockid.longLongValue ==
                        homeData.tstockid.longLongValue) {
                      weiboItem.share = weiboItem.share + 1;
                      //刷新单行数据，如果存在的话
                      NSIndexPath *indexPath =
                          [NSIndexPath indexPathForRow:i inSection:0];
                      [_tableView reloadVisibleRowWithIndexPath:indexPath];
                      break;
                    }
                  }
                }
              }];
  observerPraise = [[NSNotificationCenter defaultCenter]
      addObserverForName:PraiseWeiboSuccessNotification
                  object:nil
                   queue:[NSOperationQueue mainQueue]
              usingBlock:^(NSNotification *notif) {
                NSDictionary *userInfo = [notif userInfo];
                TweetListItem *homeData = userInfo[@"data"];
                if (homeData) {
                  for (int i = 0; i < _dataList.array.count; i++) {
                    TweetListItem *weiboItem = _dataList.array[i];
                    if (weiboItem.tstockid.longLongValue ==
                        homeData.tstockid.longLongValue) {
                      weiboItem.praise += 1;
                      weiboItem.isPraised = YES;
                      [NewShowLabel setMessageContent:@"赞成功"];

                      //刷新单行数据，如果存在的话
                      NSIndexPath *indexPath =
                          [NSIndexPath indexPathForRow:i inSection:0];
                      [_tableView reloadVisibleRowWithIndexPath:indexPath];
                      break;
                    }
                  }
                }
              }];
  observerComment = [[NSNotificationCenter defaultCenter]
      addObserverForName:CommentWeiboSuccessNotification
                  object:nil
                   queue:[NSOperationQueue mainQueue]
              usingBlock:^(NSNotification *notif) {
                NSDictionary *userInfo = [notif userInfo];
                TweetListItem *homeData = userInfo[@"data"];
                if (homeData) {
                  for (int i = 0; i < _dataList.array.count; i++) {
                    TweetListItem *weiboItem = _dataList.array[i];
                    if (weiboItem.tstockid.longLongValue ==
                        homeData.tstockid.longLongValue) {
                      weiboItem.comment =
                          weiboItem.comment + [userInfo[@"operation"] intValue];
                      //刷新单行数据，如果存在的话
                      NSIndexPath *indexPath =
                          [NSIndexPath indexPathForRow:i inSection:0];
                      [_tableView reloadVisibleRowWithIndexPath:indexPath];
                      break;
                    }
                  }
                }
              }];
  observerFavorite = [[NSNotificationCenter defaultCenter]
      addObserverForName:CollectWeiboSuccessNotification
                  object:nil
                   queue:[NSOperationQueue mainQueue]
              usingBlock:^(NSNotification *notif) {
                NSDictionary *userInfo = [notif userInfo];
                TweetListItem *homeData = userInfo[@"data"];
                NSNumber *operation = userInfo[@"operation"];
                if (homeData) {
                  for (int i = 0; i < _dataList.array.count; i++) {
                    TweetListItem *weiboItem = _dataList.array[i];
                    if (weiboItem.tstockid.longLongValue ==
                        homeData.tstockid.longLongValue) {
                      weiboItem.isCollected = [operation integerValue] == 1;
                      if (_showFavorite) {
                        //刷新单行数据，如果存在的话
                        NSIndexPath *indexPath =
                            [NSIndexPath indexPathForRow:i inSection:0];
                        [_tableView reloadVisibleRowWithIndexPath:indexPath];
                      } else {
                        [_dataList.array removeObjectAtIndex:i];
                        [_tableView reloadData];
                      }
                      break;
                    }
                  }
                }
              }];
}

- (id)initWithFrame:(CGRect)frame withTitle:(NSString *)parentContainerTitle {
  self = CGRectIsEmpty(frame) ? [super init] : [super initWithFrame:frame];
  if (self) {
    _dataList = [[DataArray alloc] init];
    _containerTitle = parentContainerTitle;
    _showFavorite = YES;
    self.fromId = @0;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.littleCattleView setInformation:@"暂无数据"];
  _tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                            style:UITableViewStylePlain];
  _tableView.delegate = self;
  _tableView.dataSource = self;
  _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  _tableView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];

  [self.view addSubview:_tableView];

  _headerView = [[MJRefreshHeaderView alloc] initWithScrollView:_tableView];
  _headerView.delegate = self;
  _footerView = [[MJRefreshFooterView alloc] initWithScrollView:_tableView];
  _footerView.delegate = self;
  _footerView.hidden = YES;
  [self addObservers];
}

#pragma mark - MJ 代理
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView {
  if (![SimuUtil isExistNetwork]) {
    [self performBlock:^{
      [self setNoNetwork];
      [self stopLoading];
    } withDelaySeconds:0.5];
    return;
  }

  if (refreshView == _headerView) {
    [self requestSubjectTweetListWithFromId:self.fromId];
  } else {
    if (_isLoadMore || _dataList.dataComplete || _dataList.array.count == 0) {
      return;
    }

    NSNumber *nextPageFromId =
        ((TweetListItem *)_dataList.array.lastObject).timelineid;
    if (nextPageFromId) {
      _isLoadMore = YES;
      [self requestSubjectTweetListWithFromId:nextPageFromId];
    }
  }
}

#pragma mark - UITableView 代理
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  return _dataList.array.count;
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  //取得数据绑定时计算的coreTextHeight
  TweetListItem *tweetItem = _dataList.array[indexPath.row];
  if (!tweetItem.heightCache[HeightCacheKeyAll]) {
    tweetItem.heightCache[HeightCacheKeyAll] =
        @([WeiboCell heightWithTweetListItem:tweetItem]);
  }
  return [tweetItem.heightCache[HeightCacheKeyAll] floatValue];
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
  weiboCell.barNameView.hidden = YES;
  //设置block回调
  __weak WeiboListViewController *weakSelf = self;
  //刷新置顶聊股
  weiboCell.topButtonClickBlock = ^(TweetListItem *item) {
    //置顶后需要更新cell的高度，因为没标题的会有标题
    [weakSelf refreshTableViewCellHeightWithItem:item];
  };

  //删除
  weiboCell.deleteButtonClickBlock = ^(NSNumber *tid) {
    [weakSelf tableViewDeleteTStock:tid];
  };

  TweetListItem *tweetListItem = _dataList.array[indexPath.row];
  [weiboCell refreshCellInfoWithItem:tweetListItem
                       withTableView:tableView
               cellForRowAtIndexPath:indexPath];
  return weiboCell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
  [self tableView:tableView didDeselectRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView
    didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
  //股票行情页面
  //李群
  TweetListItem *item = _dataList.array[indexPath.row];
  if (item.tstockid) {
    [WBDetailsViewController showTSViewWithTStockId:item.tstockid];
  }
}

#pragma mark 自动上拉加载
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == _dataList.array.count - 1 &&
      (cell.frame.origin.y > HEIGHT_OF_SCREEN - 45.0f)) {
    //当有假数据时，不为0，但fromId为0，必须判断
    if (![(TweetListItem *)_dataList.array.lastObject timelineid]) {
      return;
    }
    [self refreshViewBeginRefreshing:_footerView];
  }
}

#pragma mark - -网络请求-
#pragma mark 无网提示
- (void)setNoNetwork {
  [NewShowLabel showNoNetworkTip]; //显示无网络提示}
  self.endRefreshCallBack();
  _dataList.dataBinded ? (self.littleCattleView.hidden = YES)
                       : [self.littleCattleView isCry:YES];
}

- (void)stopLoading {
  self.endRefreshCallBack();
  if ([_headerView isRefreshing]) {
    [_headerView endRefreshing];
  }

  if ([_footerView isRefreshing]) {
    [_footerView endRefreshing];
  }
}

#pragma mark 普通聊股和加精聊股公用的解析方法
- (void)resetPraiseStatus:(TweetList *)tweetList withFromId:(NSNumber *)fromId {
  _isLoadMore = NO;

  BOOL refresh = [fromId isEqualToNumber:self.fromId];

  if (!refresh) {
    NSNumber *lastId =
        ((TweetListItem *)[_dataList.array lastObject]).timelineid;

    if (![fromId isEqualToNumber:lastId]) {
      return;
    }
  }

  //动态计算并保存高度,在非UI线程中执行
  for (TweetListItem *tweetItem in tweetList.tweetListArray) {
    //查询coredata，是否已加赞，收藏等 ，检测登录
    if (![SimuUtil isLogined]) {
      tweetItem.isPraised = NO;
      tweetItem.isCollected = NO;
    } else {
      tweetItem.isPraised = [WBCoreDataUtil fetchPraiseTid:tweetItem.tstockid];
      tweetItem.isCollected =
          [WBCoreDataUtil fetchCollectTid:tweetItem.tstockid];
    }
  }

  [self bindTweetList:tweetList withFromId:fromId];
}

/** 绑定数据列表 */
- (void)bindTweetList:(TweetList *)tweetList withFromId:(NSNumber *)fromId {

  BOOL refresh = [fromId isEqualToNumber:self.fromId];

  self.preWeiboListBindingCallBack(tweetList);

  _dataList.dataBinded = YES;
  //如果是刷新操作 清空
  if (refresh) {
    [_dataList.array removeAllObjects];
    [_tableView setContentOffset:CGPointZero animated:NO];
  }

  [_dataList.array addObjectsFromArray:tweetList.tweetListArray];

  if (tweetList.tweetListArray.count == 0) {
    if (_dataList.array.count != 0) {
      [NewShowLabel setMessageContent:@"暂无更多数据"];
    }
    _dataList.dataComplete = YES;
    _footerView.hidden = YES;
  } else {
    _dataList.dataComplete = NO;
    _footerView.hidden = NO;
  }

  if (_dataList.array.count == 0) {
    [self.littleCattleView isCry:NO];
    _tableView.hidden = YES;
  } else {
    self.littleCattleView.hidden = YES;
    _tableView.hidden = NO;
  }

  [_tableView reloadData];
}

#pragma mark 刷新表格cell高度，置顶后必须刷新
- (void)refreshTableViewCellHeightWithItem:(TweetListItem *)tweetItem {
  NSInteger i = 0;
  for (TweetListItem *item in _dataList.array) {
    if ([[item.tstockid stringValue]
            isEqualToString:[tweetItem.tstockid stringValue]]) {
      item.title = tweetItem.title;
      [item.heightCache removeObjectForKey:HeightCacheKeyAll];
      [_tableView reloadRowsAtIndexPaths:@[
        [NSIndexPath indexPathForRow:i inSection:0]
      ] withRowAnimation:UITableViewRowAnimationNone];
      break;
    }
    i++;
  }
}

#pragma mark 删除列表相应数据
- (void)tableViewDeleteTStock:(NSNumber *)tid {
  NSInteger i = 0;
  for (TweetListItem *item in _dataList.array) {
    if ([[item.tstockid stringValue] isEqualToString:[tid stringValue]]) {
      //数据源、tableView中删除该对象
      [_dataList.array removeObjectAtIndex:i];
      [_tableView reloadData];
      break;
    }
    i++;
  }

  //判断数据是否为空，如果为空，显示小牛
  if (_dataList.array.count == 0) {
    [self.littleCattleView isCry:NO];
    _tableView.hidden = YES;
  }
}

#pragma mark - 菊花刷新
- (void)refreshButtonPressDown {
  [self refreshViewBeginRefreshing:_headerView];
}

#pragma mark 比赛聊股列表请求

- (void)requestSubjectTweetListWithFromId:(NSNumber *)fromId {
  self.beginRefreshCallBack();

  if (![SimuUtil isExistNetwork]) {
    [self setNoNetwork];
    [self stopLoading];
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak WeiboListViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    WeiboListViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf stopLoading];
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    WeiboListViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf resetPraiseStatus:(TweetList *)obj withFromId:fromId];
    }
  };
  callback.onFailed = ^{
    [weakSelf setNoNetwork];
  };
  self.requestWeiboListCallBack(fromId, 20, callback);
}

#pragma mark 发表
- (void)publishWeibo {

  if (![SimuUtil isExistNetwork]) {
    [self setNoNetwork];
    [self stopLoading];
    return;
  }

  /// 发表聊股
  [FullScreenLogonViewController
      checkLoginStatusWithCallBack:^(BOOL isLogined) {

        MatchStockChatController *disVC = [[MatchStockChatController alloc]
            initWithContent:_containerTitle
                andCallBack:^(TweetListItem *item) {
                  [_tableView reloadData];
                  /// 直接本地刷新
                  item.heightCache[HeightCacheKeyAll] =
                      @([WeiboCell heightWithTweetListItem:item]);
                  [_dataList.array insertObject:item atIndex:0];
                  _dataList.dataBinded = YES;
                  self.littleCattleView.hidden = YES;
                  _tableView.hidden = NO;
                  [_tableView reloadData];
                }];
        [AppDelegate pushViewControllerFromRight:disVC];
      }];
}

@end
