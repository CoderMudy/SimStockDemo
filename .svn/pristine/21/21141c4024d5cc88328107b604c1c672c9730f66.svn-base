//
//  MyAttentionViewController.m
//  SimuStock
//
//  Created by Jhss on 15/6/23.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "MyAttentionViewController.h"
#import "myAttentionsCell.h"
#import "HomepageViewController.h"

#import "event_view_log.h"
#import "StockFriendsViewController.h"
#import "AttentionEventObserver.h"

@implementation MyAttentionTableAdapter

- (NSString *)nibName {
  static NSString *nibFileName;
  if (nibFileName == nil) {
    nibFileName = NSStringFromClass([myAttentionsCell class]);
  }
  return nibFileName;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 61.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.dataArray.array == nil || [self.dataArray.array count] == 0 ||
      [self.dataArray.array count] <= indexPath.row) {
    return;
  }
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
  //某行的切换
  MyAttentionInfoItem *item = self.dataArray.array[indexPath.row];
  [HomepageViewController showWithUserId:[item.userListItem.userId stringValue]
                               titleName:item.userListItem.nickName
                                 matchId:MATCHID];
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  myAttentionsCell *cell = (myAttentionsCell *)[tableView dequeueReusableCellWithIdentifier:self.nibName];

  MyAttentionInfoItem *item = self.dataArray.array[indexPath.row];
  [cell bindMyAttentionInfoItem:item withIndexPath:indexPath];
  cell.delegate = self;
  [cell.bottomSplitLineView resetViewWidth:tableView.width];

  cell.bottomSplitLineView.hidden = NO;
  if ((self.dataArray.array.count == (indexPath.row + 1)) && (self.dataArray.dataComplete)) {
    cell.bottomSplitLineView.hidden = YES;
  }

  return cell;
}

#pragma mark
#pragma mark-------FriendFollowDelegate------
- (void)pressButtonWithFollowFlag:(BOOL)isAttention withRow:(NSInteger)index {
  [FullScreenLogonViewController checkLoginStatusWithCallBack:^(BOOL isLogined) {
    //已登录
    if (index == -1)
      return;

    if (isAttention) {
      [self attentionRequest:index attentionOperation:@"1"];
    } else {
      [self attentionRequest:index attentionOperation:@"0"];
    }
  }];
}
#pragma mark - 关注请求
- (void)startRefresh {
  if (self.baseTableViewController.beginRefreshCallBack) {
    self.baseTableViewController.beginRefreshCallBack();
  }
}

- (void)endRefresh {
  if (self.baseTableViewController.endRefreshCallBack) {
    self.baseTableViewController.endRefreshCallBack();
  }
}
- (void)attentionRequest:(NSInteger)buttonIndex attentionOperation:(NSString *)attentionOperation {
  if (buttonIndex < 0 || buttonIndex > [self.dataArray.array count] - 1) {
    return;
  }

  MyAttentionInfoItem *item = self.dataArray.array[buttonIndex];
  if (item.userListItem.userId == nil)
    return;
  [self startRefresh];

  NSString *selfUid = [SimuUtil getUserID];
  if ([selfUid isEqualToString:[item.userListItem.userId stringValue]]) {
    [NewShowLabel setMessageContent:@"土豪，不能关注自己哦"];
    [self.baseTableViewController.tableView reloadData];
    [self endRefresh];
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak MyAttentionTableAdapter *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    MyAttentionTableAdapter *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf endRefresh];
      return NO;
    } else {
      return YES;
    }
  };
  callback.onSuccess = ^(NSObject *obj) {
    MyAttentionTableAdapter *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf payAttentionWithUser:item withIsAttention:attentionOperation];
    }
  };
  [FollowFriendResult addCancleFollowWithUid:[item.userListItem.userId stringValue]
                              withFollowFlag:attentionOperation
                                withCallBack:callback];
}

- (void)payAttentionWithUser:(MyAttentionInfoItem *)item withIsAttention:(NSString *)isAttention {
  //保存下更新数据
  if ([isAttention integerValue] == 0) {
    item.mIsAttention = @"0";
  } else {
    item.mIsAttention = @"1";
  }
  //先更新下当前页面数据，再请求网络,回传的数据才刷新
  [self.baseTableViewController.tableView reloadData];

  //先更新下当前页面数据，再请求网络,回传的数据才刷新
  if ([isAttention integerValue] == 1) {
    [[MyAttentionInfo sharedInstance] addItemToAttentionArray:item];
  } else {
    [[MyAttentionInfo sharedInstance] deleteItemFromAttentionArray:[item.userListItem.userId stringValue]];
  }
}

@end

@implementation MyAttentionTableViewController {
  NSInteger start;

  AttentionEventObserver *attentionEventObserver;
}

/** 将入参封装成一个dic */
- (NSDictionary *)getRequestParamertsWithRefreshType:(RefreshType)refreshType {
  NSString *startId = @"1";
  NSString *endId = @"20";
  if (refreshType == RefreshTypeLoaderMore) {
    startId = [@(start + 20) stringValue];
    endId = [@(start + 40 - 1) stringValue];
  }
  NSDictionary *dic = @{ @"uid" : self.userId, @"startnum" : startId, @"endnum" : endId };
  return dic;
}
/** 判断返回数据是否有效 */
- (BOOL)isDataValidWithResponseObject:(NSObject<Collectionable> *)latestData
                withRequestParameters:(NSDictionary *)parameters
                      withRefreshType:(RefreshType)refreshType {
  if (refreshType == RefreshTypeLoaderMore) {
    NSString *fromId = parameters[@"startnum"];
    NSString *lastId = [@(start + 20) stringValue];
    if (![fromId isEqualToString:lastId]) {
      return NO;
    }
  }
  return YES;
}
/** 请求最新数据，此方法子类必须实现 */
- (void)requestDataListWithRefreshType:(RefreshType)refreshType
                         withDataArray:(DataArray *)existDataList
                          withCallBack:(HttpRequestCallBack *)callback {
  [MyAttentionList requestPositionDataWithParams:[self getRequestParamertsWithRefreshType:refreshType]
                                    withCallback:callback];
}
/** 绑定数据（调用默认的绑定方法），首先判断是否有效 */
- (void)bindRequestObject:(NSObject<Collectionable> *)latestData
    withRequestParameters:(NSDictionary *)parameters
          withRefreshType:(RefreshType)refreshType {
  if ([self isDataValidWithResponseObject:latestData
                    withRequestParameters:parameters
                          withRefreshType:refreshType]) {
    [super bindRequestObject:latestData
        withRequestParameters:parameters
              withRefreshType:refreshType];
    if ([self.dataArray.array count] == 0) {
      //隐藏上下拉刷新
      self.footerView.hidden = YES;
      self.headerView.hidden = YES;
    }
    [self refreshAttentionData];
    [self.tableView reloadData];
    if (refreshType == RefreshTypeLoaderMore) {
      start += 20;
    } else {
      start = [parameters[@"startnum"] integerValue];
    }
  }
}

- (id)initWithFrame:(CGRect)frame withUserId:(NSString *)userId {
  if (self = [super initWithFrame:frame]) {
    _userId = userId;
    attentionEventObserver = [[AttentionEventObserver alloc] init];
    __weak MyAttentionTableViewController *weakSelf = self;
    attentionEventObserver.onAttentionAction = ^{
      [weakSelf refreshAttentionData];
    };
  }
  return self;
}
- (void)viewDidLoad {
  [super viewDidLoad];
  [self.littleCattleView setInformation:@"暂无关注股友"];
}

/** 返回表格数据适配器，此方法子类必须实现 */
- (BaseTableAdapter *)getBaseTableAdaperWithDataList:(DataArray *)dataList {
  if (_tableAdapter == nil) {
    _tableAdapter = [[MyAttentionTableAdapter alloc] initWithTableViewController:self
                                                                   withDataArray:self.dataArray];
    UINib *cellNib = [UINib nibWithNibName:_tableAdapter.nibName bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:_tableAdapter.nibName];
  }
  return _tableAdapter;
}

//由于此类包含了他人关注信息，所以并不是所有用户为关注状态
- (void)refreshAttentionData {
  NSArray *array = [[MyAttentionInfo sharedInstance] getAttentionArray];

  for (MyAttentionInfoItem *currentItem in self.dataArray.array) {
    BOOL attentionStatus = NO;
    for (MyAttentionInfoItem *savedItem in array) {
      //遍历
      if ([currentItem.userListItem.userId integerValue] == [savedItem.userListItem.userId integerValue]) {
        attentionStatus = YES;
        break;
      }
    }
    if (attentionStatus) {
      currentItem.mIsAttention = @"1";
    } else {
      currentItem.mIsAttention = @"0";
    }
  }
  //刷新关注信息
  [self.tableView reloadData];
}

@end

@implementation MyAttentionViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  //导航条
  if ([self.userID isEqualToString:[SimuUtil getUserID]]) {
    [_topToolBar resetContentAndFlage:@"我的关注" Mode:TTBM_Mode_Leveltwo];
  } else {
    [_topToolBar resetContentAndFlage:@"TA的关注" Mode:TTBM_Mode_Leveltwo];
  }

  [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_PV
                                                   andCode:@"个人中心-我的关注"];

  _indicatorView.frame =
      CGRectMake(self.view.bounds.size.width - 85, _topToolBar.frame.size.height - 44, 45, 44);
  _indicatorView.delegate = self;
  /** 创建表格  */
  [self createMyFansTableView];
  [self createSearchButton];
  [self refreshButtonPressDown];
}
- (void)createMyFansTableView {
  myAttentionTableVC =
      [[MyAttentionTableViewController alloc] initWithFrame:_clientView.bounds withUserId:_userID];
  myAttentionTableVC.showTableFooter = YES;
  __weak MyAttentionViewController *weakSelf = self;
  myAttentionTableVC.beginRefreshCallBack = ^{
    [weakSelf.indicatorView startAnimating];
    weakSelf.indicatorView.hidden = NO;
  };
  myAttentionTableVC.endRefreshCallBack = ^{
    [weakSelf.indicatorView stopAnimating];
    weakSelf.indicatorView.hidden = YES;
  };

  [_clientView addSubview:myAttentionTableVC.view];
  [self addChildViewController:myAttentionTableVC];
}
/** 创建搜索小图标 */
- (void)createSearchButton {
  //搜索按钮
  UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
  searchButton.frame =
      CGRectMake(self.view.frame.size.width - 40, _topToolBar.frame.size.height - 44, 40, 44);
  [searchButton setImage:[UIImage imageNamed:@"搜索小图标"] forState:UIControlStateNormal];
  [searchButton setBackgroundImage:nil forState:UIControlStateNormal];
  //按钮选中视图
  UIImage *mtvc_centerImage =
      [[UIImage imageNamed:@"return_touch_down.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(14, 14, 14, 14)];
  [searchButton setBackgroundImage:mtvc_centerImage forState:UIControlStateHighlighted];
  [searchButton addTarget:self
                   action:@selector(searchFriendList:)
         forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:searchButton];
}
- (void)searchFriendList:(UIButton *)button {
  StockFriendsViewController *stockFriendVC = [[StockFriendsViewController alloc] init];
  [AppDelegate pushViewControllerFromRight:stockFriendVC];
}

#pragma mark - 刷新按钮代理方法
- (void)refreshButtonPressDown {
  [myAttentionTableVC refreshButtonPressDown];
}

@end
