//
//  MyFollowListViewController.m
//  SimuStock
//
//  Created by Yuemeng on 14/12/22.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "MyFollowListViewController.h"
#import "NewShowLabel.h"
#import "TweetListItem.h"
#import "WBCoreDataUtil.h"
#import "WeiboCell.h"
#import "WBDetailsViewController.h"

@implementation MyFollowListViewController

- (void)dealloc {
  [_headerView free];
  [_footerView free];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.

  [_littleCattleView setInformation:@"暂无数据"];

  [_indicatorView startAnimating];
  //设置tabbar
  if (_topToolBar) {
    [_topToolBar resetContentAndFlage:@"好友圈" Mode:TTBM_Mode_Leveltwo];
  }
  _myFollowList = [[DataArray alloc] init];
  [self createTableViewAndMJRefreshers];
  [self requestMyFollowListDataWithFromId:@0];

}

#pragma mark - 创建TableView
- (void)createTableViewAndMJRefreshers {
  _tableView = [[UITableView alloc]
      initWithFrame:CGRectMake(0, 0, WIDTH_OF_VIEWCONTROLLER,
                               _clientView.bounds.size.height)
              style:UITableViewStylePlain];
  [_clientView addSubview:_tableView];
  _tableView.dataSource = self;
  _tableView.delegate = self;
  _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  _tableView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  
  _headerView = [[MJRefreshHeaderView alloc] initWithScrollView:_tableView];
  _headerView.delegate = self;
  _footerView = [[MJRefreshFooterView alloc] initWithScrollView:_tableView];
  _footerView.delegate = self;
  _footerView.hidden = YES;
}

#pragma mark - 菊花代理
- (void)refreshButtonPressDown {
  [self refreshViewBeginRefreshing:_headerView];
}

#pragma mark - MJ代理
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView {
  if (![SimuUtil isExistNetwork]) {
    [self performBlock:^{
        [_headerView endRefreshing];
        [_footerView endRefreshing];
    } withDelaySeconds:0.5];
    [NewShowLabel showNoNetworkTip]; //显示无网络提示
    _myFollowList.dataBinded ? (_littleCattleView.hidden = YES)
                             : [_littleCattleView isCry:YES];
    return;
  }

  if (refreshView == _headerView) {
    [_indicatorView startAnimating];
    [self requestMyFollowListDataWithFromId:@0];
    if (_myFollowList.dataBinded) {
      _footerView.hidden = NO;
    }
  } else {
    if (_isLoadMore || _myFollowList.dataComplete ||
        _myFollowList.array.count == 0) {
      return;
    }
    _isLoadMore = YES;
    NSNumber *fromId =
        [(TweetListItem *)_myFollowList.array.lastObject timelineid];
    [self requestMyFollowListDataWithFromId:fromId];
  }
}

#pragma mark - UITableView 代理
- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  return _myFollowList.array.count;
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  TweetListItem *tweetItem = _myFollowList.array[indexPath.row];
  if (!tweetItem.heightCache[HeightCacheKeyAll]) {
    tweetItem.heightCache[HeightCacheKeyAll] =
    @([WeiboCell heightWithTweetListItem:tweetItem]);
  }
  return [tweetItem.heightCache[HeightCacheKeyAll] floatValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *myFollowCellID = @"myFollowCell";
  WeiboCell *weiboCell =
      [_tableView dequeueReusableCellWithIdentifier:myFollowCellID];

  if (!weiboCell) {
    weiboCell = [[[NSBundle mainBundle] loadNibNamed:@"WeiboCell"
                                               owner:self
                                             options:nil] firstObject];
    weiboCell.reuseId = myFollowCellID;
  }
  //设置block回调
  __weak MyFollowListViewController *weakSelf = self;
    //刷新置顶聊股
  weiboCell.topButtonClickBlock = ^(TweetListItem *item) {
      //置顶后需要更新cell的高度，因为没标题的会有标题
    [weakSelf refreshTableViewCellHeightWithItem:item];
  };

  //删除
  weiboCell.deleteButtonClickBlock =
      ^(NSNumber *tid) { [weakSelf tableViewDeleteTStock:tid]; };

  TweetListItem *tweetListItem = _myFollowList.array[indexPath.row];
  [weiboCell refreshCellInfoWithItem:tweetListItem
                       withTableView:tableView
               cellForRowAtIndexPath:indexPath];
  return weiboCell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [self tableView:tableView didDeselectRowAtIndexPath:indexPath];
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)tableView:(UITableView *)tableView
    didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
  //跳转聊股详情页 李群
  TweetListItem *item = _myFollowList.array[indexPath.row];
  [WBDetailsViewController showTSViewWithTStockId:item.tstockid];
}

#pragma mark 自动上拉加载
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
  if (indexPath.row == _myFollowList.array.count -1 && (cell.frame.origin.y > HEIGHT_OF_SCREEN)) {
    [self refreshViewBeginRefreshing:_footerView];
  }
}

#pragma mark - -网络请求-
#pragma mark 无网提示
- (void)setNoNetwork {
  [NewShowLabel showNoNetworkTip]; //显示无网络提示
  [_indicatorView stopAnimating];  //停止菊花
  _myFollowList.dataBinded ? (_littleCattleView.hidden = YES)
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

#pragma mark 热门推荐
- (void)requestMyFollowListDataWithFromId:(NSNumber *)fromId {

  if (![SimuUtil isExistNetwork]) {
    [self setNoNetwork];
    [self stopLoading];
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak MyFollowListViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
      MyFollowListViewController *strongSelf = weakSelf;
      if (strongSelf) {
        [strongSelf stopLoading];
        return NO;
      } else {
        return YES;
      }
  };

  callback.onSuccess = ^(NSObject *obj) {
      MyFollowListViewController *strongSelf = weakSelf;
      if (strongSelf) {
        [strongSelf resetFriendDataStatus:(TweetList *) obj
                                   fromId:fromId];
      }
  };
  callback.onFailed = ^{ [weakSelf setNoNetwork]; };

  [TweetList requestGetMyFollowListWithFromId:fromId
                                       withReqNum:20
                                     withCallback:callback];
}
#pragma mark 查询赞等
- (void)resetFriendDataStatus:(TweetList *)tweetListItem
                   fromId:(NSNumber *)fromId {
  //如果不是刷新
  if (![@"0" isEqualToString:[fromId stringValue]]) {
    NSNumber *lastId =
        ((TweetListItem *)_myFollowList.array.lastObject).timelineid;
    //如果不是连续请求
    if (![[fromId stringValue] isEqualToString:[lastId stringValue]]) {
      return;
    }
  }

  for (TweetListItem *tweetItem in tweetListItem.tweetListArray) {

    //查询coredata，是否已加赞，检测登录
    if (![SimuUtil isLogined]) {
      tweetItem.isPraised = NO;
    } else {
      tweetItem.isPraised =
      [WBCoreDataUtil fetchPraiseTid:tweetItem.tstockid];
    }
  }
  [self bindMyFollowListData:tweetListItem fromId:fromId];
}

- (void)bindMyFollowListData:(TweetList *)tweetListItem
                      fromId:(NSNumber *)fromId {

  _myFollowList.dataBinded = YES;
    //如果是刷新操作 清空
  if ([@"0" isEqualToString:[fromId stringValue]]) {
    [_myFollowList.array removeAllObjects];
    [_tableView setContentOffset:CGPointZero animated:NO];
  }
  
  if (tweetListItem.tweetListArray.count == 0) {
    if (_myFollowList.array.count != 0) {
      [NewShowLabel setMessageContent:@"暂无更多数据"];
    }
//    [NewShowLabel setMessageContent:(_myFollowList.array.count == 0 ? @"暂无数据" : @"暂无更多数据")];
    _myFollowList.dataComplete = YES;
    _footerView.hidden = YES;
  } else {
    [_myFollowList.array addObjectsFromArray:tweetListItem.tweetListArray];
    _myFollowList.dataComplete = NO;
    _footerView.hidden = NO;
  }
  
  if (_myFollowList.array.count == 0) {
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
  for (TweetListItem *item in _myFollowList.array) {
    if ([[item.tstockid stringValue]
         isEqualToString:[tweetItem.tstockid stringValue]]) {
      item.title = tweetItem.title;
      [item.heightCache removeObjectForKey:HeightCacheKeyAll];
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
  for (TweetListItem *item in _myFollowList.array) {
    if ([[item.tstockid stringValue] isEqualToString:[tid stringValue]]) {
      //数据源、tableView中删除该对象
      [_myFollowList.array removeObjectAtIndex:i];
      [_tableView reloadData];
      break;
    }
    i++;
  }
  
    //判断数据是否为空，如果为空，显示小牛
  if (_myFollowList.array.count == 0) {
    _myFollowList.dataBinded = NO;
    [_littleCattleView isCry:NO];
    _tableView.hidden = YES;
  }
}

#pragma mark -
- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
