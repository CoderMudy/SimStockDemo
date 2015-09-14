//
//  MasterRankingViewController.m
//  SimuStock
//
//  Created by jhss on 13-11-29.
//  Copyright (c) 2013年 Mac. All rights reserved.
//
#import "MasterRankingViewController.h"
#import "SimuUtil.h"
#import "RankTableViewCell.h"

#import "event_view_log.h"
#import "MobClick.h"
#import "StockPositionViewController.h"
#import "HomepageViewController.h"
#import "AttentionEventObserver.h"

//最高值下载

@implementation MasterRankingViewController {
  AttentionEventObserver *attentionEventObserver;
}

- (void)dealloc {
  NSString *type = self.rankingSortNumber;
  if (type) {
    if ([type isEqualToString:@"5"] == YES) {
      [MobClick endLogPageView:@"炒股牛人-优顾推荐榜"];
    } else if ([type isEqualToString:@"4"] == YES) {
      [MobClick endLogPageView:@"炒股牛人-人气榜单"];
    } else if ([type isEqualToString:@"0"] == YES) {
      [MobClick endLogPageView:@"炒股牛人-今日盈利榜"];
    } else if ([type isEqualToString:@"1"] == YES) {
      [MobClick endLogPageView:@"炒股牛人-周盈利榜"];
    } else if ([type isEqualToString:@"2"] == YES) {
      [MobClick endLogPageView:@"炒股牛人-月盈利榜"];
    }
  }
  [_masterRankingTableView setDataSource:nil];
  [_masterRankingTableView setDelegate:nil];
  _masterRankingTableView = nil;
  [_footerView free];
  [_headerView free];
}

//统计页面停留时间
- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [MobClick beginLogPageView:@"炒股牛人"];
  //加缓存策略
  NSInteger clearPreviousTime =
      [[NSUserDefaults standardUserDefaults] integerForKey:@"clearCacheTime"];
  // NSInteger clearCurrentTime = [NSDate timeIntervalSinceReferenceDate];
  // 1.获得年月日
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSCalendarUnit unitFlags =
      NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
  NSDateComponents *cmp =
      [calendar components:unitFlags fromDate:[NSDate date]];
  //不在同一天
  if ([cmp day] != clearPreviousTime) {
    [self clearCache];
  }
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [MobClick endLogPageView:@"炒股牛人"];
}

- (id)init {
  self = [super init];
  if (self) {
    //初始化值
    tempOpenRow = @"-1";
    //数据
    dataArray = [[DataArray alloc] init];
    selfInRank = NO;
    //初始都关闭
    isOpenRow = NO;
    previousIndexPath = [[NSIndexPath alloc] init];

    attentionEventObserver = [[AttentionEventObserver alloc] init];
    __weak MasterRankingViewController *weakSelf = self;
    attentionEventObserver.onAttentionAction = ^{
      [weakSelf refreshAttentionData];
    };
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  //视图部分
  [self createMainView];
  [self createData];
  [_littleCattleView setInformation:@"暂无排行信息"];
  _headerView =
      [[MJRefreshHeaderView alloc] initWithScrollView:_masterRankingTableView];
  _headerView.delegate = self;
  _footerView =
      [[MJRefreshFooterView alloc] initWithScrollView:_masterRankingTableView];
  _footerView.delegate = self;
  _footerView.hidden = YES;

  //表格数据生成
  [self refreshButtonPressDown];
}
#pragma mark 自动上拉加载
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == dataArray.array.count - 1 &&
      (cell.frame.origin.y > HEIGHT_OF_SCREEN)) {
    [self refreshViewBeginRefreshing:_footerView];
  }
}
#pragma mark
#pragma mark----------------------界面-------------------------
- (void)createMainView {
  _indicatorView.hidden = NO;
  self.view.backgroundColor = [Globle colorFromHexRGB:@"ffffff"];
  //导航条
  [_topToolBar resetContentAndFlage:_rankingTitle Mode:TTBM_Mode_Leveltwo];
  //动画选择(调试动画)
  //表格
  _masterRankingTableView =
      [[UITableView alloc] initWithFrame:_clientView.bounds];

  _masterRankingTableView.delegate = self;
  _masterRankingTableView.dataSource = self;
  _masterRankingTableView.backgroundColor =
      [Globle colorFromHexRGB:Color_BG_Common];

  _masterRankingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  [_clientView addSubview:_masterRankingTableView];

  UINib *cellNib =
      [UINib nibWithNibName:NSStringFromClass([RankTableViewCell class])
                     bundle:nil];
  [_masterRankingTableView registerNib:cellNib
                forCellReuseIdentifier:@"RankTableViewCell"];
}
- (void)changeAntiSort:(UIButton *)sender {
  NSInteger tempValue = [animationType integerValue];
  animationType = [NSString stringWithFormat:@"%ld", (long)(tempValue + 1)];
  if (tempValue == 6) {
    animationType = @"0";
    [sender setTitle:@"0" forState:UIControlStateNormal];
  } else {
    [sender setTitle:animationType forState:UIControlStateNormal];
  }
}

#pragma mark
#pragma mark------菊花控件-------
- (void)refreshButtonPressDown {
  [self refreshViewBeginRefreshing:_headerView];
}

- (void)createData {
  tempSelectRow = -1;
  isRequestSuccess = NO;
  tempRow = @"20";
  indicatorIndex = -1;
}

- (void)refreshAttentionData {
  myAttentionsArray = [[NSMutableArray alloc]
      initWithArray:[[MyAttentionInfo sharedInstance] getAttentionArray]];
  BOOL attentionStatus = 0;
  for (RankingListItem *subItem in dataArray.array) {
    for (MyAttentionInfoItem *item in myAttentionsArray) {
      if ([item.userListItem.userId integerValue] ==
          [subItem.mUserID integerValue]) {
        attentionStatus = 1;
      }
    }
    if (attentionStatus == 1) {
      subItem.mAttention = @"1";
      attentionStatus = 0;
    } else {
      subItem.mAttention = @"0";
    }
  }
  //刷新关注信息
  [_masterRankingTableView reloadData];
}

#pragma mark
#pragma mark------数据加载------
/** 判断小牛状态 */
- (void)setNoNetwork {
  if (dataArray.dataBinded) {
    _littleCattleView.hidden = YES; //数据已经绑定（==显示），隐藏小牛
  } else {
    [_littleCattleView
        isCry:YES]; //数据未绑定（==未显示），显示哭泣的无网络小牛
  }
}

- (void)stopLoading {
  [_indicatorView stopAnimating]; //停止菊花
  _indicatorView.hidden = YES;
  if ([_headerView isRefreshing]) {
    [_headerView endRefreshing];
  }

  if ([_footerView isRefreshing]) {
    [_footerView endRefreshing];
  }
}

- (void)loadRankingDataWithType:(NSString *)sortNumber
                     withFromId:(NSString *)start
                     withReqnum:(NSString *)reqnum {
  //    [_indicatorView startAnimating];

  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip]; //显示无网络提示
    [self setNoNetwork];
    [self stopLoading];
    [_headerView endRefreshing];
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak MasterRankingViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    MasterRankingViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf stopLoading];
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    MasterRankingViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindRankList:(MasterRankList *)obj withFromId:start];
    }
  };
  callback.onFailed = ^{
    [self setNoNetwork];
  };

  [MasterRankList requestMasterRankListWithType:[sortNumber intValue]
                                     withFromId:start
                                     withReqnum:reqnum
                                   withCallback:callback];
}
#pragma mark----------zxc数据绑定----------
- (void)bindRankList:(MasterRankList *)obj withFromId:(NSString *)fromId {

  //设置数据已经绑定
  dataArray.dataBinded = YES;
  if (![@"1" isEqualToString:fromId]) {
    if (![fromId isEqualToString:[self getFromId]]) {
      return;
    }
  }

  //刷新操作需要移除数组中所有数据，且tableview回到头部
  if ([@"1" isEqualToString:fromId]) {
    [dataArray.array removeAllObjects];
    [_masterRankingTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1)
                                        animated:NO];
    //对于月盈利榜、周盈利榜，如果存在排名，则显示自己的排名信息
    if (obj.myRankInfo && [obj.myRankInfo.mRank intValue] > 0) {
      selfInRank = YES;
      RankingListItem *itemNull = [[RankingListItem alloc] init];
      itemNull.mUserID = @"-1";
      [obj.dataArray insertObject:itemNull atIndex:0];
      [obj.dataArray insertObject:obj.myRankInfo atIndex:0];
    }
  }

  //当返回数据为0，可视为数据已经全部加载完
  if ([obj.dataArray count] == 0) {
    [NewShowLabel
        setMessageContent:(dataArray.array.count == 0 ? @"暂无数据"
                                                      : @"暂无更多数据")];
    dataArray.dataComplete = YES;
    _footerView.hidden = YES;
  } else {
    [dataArray.array addObjectsFromArray:obj.dataArray];
    dataArray.dataComplete = NO;
    _footerView.hidden = NO;
  }

  if ([dataArray.array count] == 0) {
    //最终显示数据为空，显示无数据的小牛，隐藏tableview
    [_littleCattleView isCry:NO];
    _masterRankingTableView.hidden = YES;
  } else {
    //最终显示数据不为空，隐藏小牛，显示tableview
    _littleCattleView.hidden = YES;
    _masterRankingTableView.hidden = NO;
  }

  if (_isLoadMore) {
    [_footerView endRefreshing];
    _isLoadMore = NO;
  } else {
    [_headerView endRefreshing];
    //    [_indicatorView stopAnimating];
  }

  //取首元素判断是否显示用户自己(严谨)
  if (dataArray.array.count > 0) {
    RankingListItem *firstItem = dataArray.array[0];
    NSString *selfUID = [SimuUtil getUserID];
    if ([firstItem.mUserID isEqualToString:selfUID]) {

      if (selfInRank) {
        _stepNumber = 2;
      } else {
        _stepNumber = 0;
      }
    } else {
      _stepNumber = 0;
    }
  } else {
    _stepNumber = 0;
  }

  //重新加载数据
  [self refreshAttentionData];
  [_masterRankingTableView reloadData];
}

#pragma mark
#pragma mark 代理方法------------------进入刷新状态就会调用---------------
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView {
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    [self performBlock:^{
      [_headerView endRefreshing];
      [_footerView endRefreshing];
    } withDelaySeconds:0.5];
    dataArray.dataBinded ? (_littleCattleView.hidden = YES)
                         : [_littleCattleView isCry:YES];
    return;
  }
  if (refreshView == _headerView) {
    [_indicatorView startAnimating];
    [self loadRankingDataWithType:_rankingSortNumber
                       withFromId:@"1"
                       withReqnum:@"20"];
    if (dataArray.dataBinded) {
      _footerView.hidden = NO;
    }
  } else {
    if (_isLoadMore || dataArray.dataComplete || dataArray.array.count == 0) {
      return;
    }
    _isLoadMore = YES;
    [self loadRankingDataWithType:_rankingSortNumber
                       withFromId:[self getFromId]
                       withReqnum:@"20"];
  }
}

- (NSString *)getFromId {
  NSString *fromId;
  if (selfInRank) {
    fromId =
        [NSString stringWithFormat:@"%ld", (long)([dataArray.array count] - 1)];
  } else {
    fromId =
        [NSString stringWithFormat:@"%ld", (long)([dataArray.array count] + 1)];
  }
  return fromId;
}

#pragma mark
#pragma mark-----------------数据解析-----------
- (void)stopIndicatorAnimating {
  //菊花效果(结束)
  if (indicatorIndex != -1) {
    UIButton *attentionButton =
        (UIButton *)[self.view viewWithTag:indicatorIndex - 10000];
    attentionButton.hidden = NO;
    UIActivityIndicatorView *clickIndicatorView =
        (UIActivityIndicatorView *)[self.view viewWithTag:indicatorIndex];
    if ([clickIndicatorView isAnimating]) {
      [clickIndicatorView stopAnimating];
    }
    indicatorIndex = -1;
  }
}

#pragma mark
#pragma mark-------------信息读入缓存------------

#pragma mark
#pragma mark - -----------------------------tableView协议函数-----------------------
- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == 0 && _stepNumber == 2) {
    return 68;
  }
  //周、月盈利row = 2
  if (indexPath.row == 1 && _stepNumber == 2) {
    return 0;
  }
  return 108;
}
- (BOOL)tableView:(UITableView *)tableView
    canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  return YES;
}
- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
  RankingListItem *item = dataArray.array[indexPath.row];
  if (item.mUserID)
    [HomepageViewController showWithUserId:item.mUserID
                                 titleName:item.mNickName
                                   matchId:MATCHID];
  return;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  //周盈利和月盈利
  if (_stepNumber == 2) {
    return [dataArray.array count];
  }
  return [dataArray.array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  static NSString *cellID = @"RankTableViewCell";
  RankTableViewCell *cell =
      (RankTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  if (indexPath.row > [dataArray.array count]) {
    return cell;
  }

  //当显示自己账户信息时，隐藏cell的部分控件
  if (indexPath.row == 0 && _stepNumber == 2) {
    cell.centerLineView.hidden = YES;
    cell.leftDownView.hidden = YES;
    cell.rightDownView.hidden = YES;
  }

  if (_stepNumber == 2 && indexPath.row == 1) {
    cell.hidden = YES;
  }

  RankingListItem *item = dataArray.array[indexPath.row];
  NSInteger startIndex = indexPath.row - _stepNumber + 1;
  [cell leftNumberShowView:cell.leftViewSets
             withCellIndex:startIndex
                withMyRank:item.mRank];
  [cell bindRankingListItem:item withRankingSortName:_rankingSortName];
  return cell;
}

- (CGFloat)widthOfString:(NSString *)str withUILabel:(UILabel *)lbl {
  CGSize maximumSize = CGSizeMake(3000.0f, 70.0f);
  CGSize myStringSize =
      [str sizeWithFont:lbl.font constrainedToSize:maximumSize];
  return myStringSize.width;
}
#pragma mark
#pragma mark - --------------------------主页、持仓切换，及关注操作---------------------

#pragma mark
#pragma mark------------------------ pv事件添加------------------------------
- (void)addPVselectorIndex:(NSString *)rankSortNumber
           withSelectIndex:(NSInteger)bottomButtonIndex {
  NSInteger pvIndex;
  switch ([rankSortNumber integerValue]) {
  case 5:
    pvIndex = 325;
    break;
  case 4:
    pvIndex = 329;
    break;
  case 0:
    pvIndex = 333;
    break;
  case 1:
    pvIndex = 337;
    break;
  default:
    pvIndex = 341;
    break;
  }
  NSString *pvString =
      [NSString stringWithFormat:@"%ld", (long)(pvIndex + bottomButtonIndex)];
  //纪录日志
  [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_Button
                                                   andCode:pvString];
}

#pragma mark
#pragma mark-------------------------- 回拉效果 --------------------------

//一天期限
- (void)clearCache {
  // 1.获得年月日
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSCalendarUnit unitFlags =
      NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
  NSDateComponents *cmp =
      [calendar components:unitFlags fromDate:[NSDate date]];

  [[NSUserDefaults standardUserDefaults] setInteger:[cmp day]
                                             forKey:@"clearCacheTime"];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
