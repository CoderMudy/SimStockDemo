//
//  MyTranceNewViewController.m
//  SimuStock
//
//  Created by Yuemeng on 15/7/20.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "TrancingViewController.h"
#import "NoTrancingView.h"
#import "MyTranceTableHeaderView.h"
#import "TrancingXIBCell.h"
#import "TracingPageRequest.h"
#import "HomepageViewController.h"
#import "TraceItem.h"
#import "WeiboToolTip.h"
#import "DeadlineItem.h"
#import "StockFriendsViewController.h"
#import "AttentionEventObserver.h"
#import "SimuConfigConst.h"
#import "NetShoppingMallBaseViewController.h"

@implementation TrancingTableAdapter

- (NSString *)nibName {
  static NSString *nibFileName;
  if (nibFileName == nil) {
    nibFileName = NSStringFromClass([TrancingXIBCell class]);
  }
  return nibFileName;
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 60.f;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  //释放选中效果
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  //切换到主页
  TraceItem *item = self.baseTableViewController.dataArray.array[indexPath.row];
  [HomepageViewController showWithUserId:item.mFollowUid
                               titleName:item.mNick
                                 matchId:item.mFollowMid];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  TraceItem *item = self.baseTableViewController.dataArray.array[indexPath.row];
  TrancingXIBCell *cell =
      [tableView dequeueReusableCellWithIdentifier:self.nibName];
  [cell bindInfo:item];
  //是否页面是"我的追踪"
  if (_isMyTrance) {
    [cell.cancelTranceBtn setOnButtonPressedHandler:^{
      [WeiboToolTip showMakeSureWithTitle:@"温馨提示"
          largeContent:@"确定要取消追踪该牛人吗？"
          lineSpacing:10
          contentTopSpacing:10
          contentBottomSpacing:10
          sureButtonTitle:@"取消追踪"
          cancelButtonTitle:@"继续追踪"
          sureblock:^{
            [self cancelTracing:item];
          }
          cancleblock:^{
          }];
    }];
  } else {
    cell.cancelTranceBtn.hidden = YES;
    cell.traceBtnWidth.constant = 0;
  }
  return cell;
}

//取消追踪
- (void)cancelTracing:(TraceItem *)item {
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel setMessageContent:REQUEST_FAILED_MESSAGE];
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  //解析
  __weak TrancingTableAdapter *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    TrancingTableAdapter *strongSelf = weakSelf;
    if (strongSelf) {
      return NO;
    } else
      return YES;
  };

  callback.onSuccess = ^(NSObject *obj) {
    TrancingTableAdapter *strongSelf = weakSelf;
    if (strongSelf) {
      [self.superTableVC deleteItemAndReloadTable:item];
    }
  };

  callback.onError = ^(BaseRequestObject *error, NSException *ex) {
    [BaseRequester defaultErrorHandler](error, ex);
  };
  [CancelTracing cancelTracingWithFollowUid:item.mFollowUid
                              withFollowMid:item.mFollowMid
                               withCallback:callback];
}

@end

/*
 *
 */
@implementation TrancingTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.littleCattleView
      setInformation:(_isMyTrance ? @"快去追踪一些牛人吧"
                                  : @"暂无追踪")];
}

/** 返回表格数据适配器，此方法子类必须实现 */
- (BaseTableAdapter *)getBaseTableAdaperWithDataList:(DataArray *)dataList {
  if (_tableAdapter == nil) {
    _tableAdapter = [[TrancingTableAdapter alloc]
        initWithTableViewController:self
                      withDataArray:self.dataArray];
    UINib *cellNib = [UINib nibWithNibName:_tableAdapter.nibName bundle:nil];
    [self.tableView registerNib:cellNib
         forCellReuseIdentifier:_tableAdapter.nibName];
    ((TrancingTableAdapter *)_tableAdapter).superTableVC = self;
    ((TrancingTableAdapter *)_tableAdapter).isMyTrance = _isMyTrance;
  }
  return _tableAdapter;
}

/** 请求最新数据，此方法子类必须实现 */
- (void)requestDataListWithRefreshType:(RefreshType)refreshType
                         withDataArray:(DataArray *)existDataList
                          withCallBack:(HttpRequestCallBack *)callback {
  [TracingPageRequest tracingListWithParameters:
                          [self getRequestParamertsWithRefreshType:refreshType]
                                   withCallback:callback];
}

- (NSDictionary *)getRequestParamertsWithRefreshType:(RefreshType)refreshType {
  NSString *fromid = @"0";
  if (refreshType == RefreshTypeLoaderMore) {
    fromid = _seqID;
  }
  return @{
    @"fromid" : fromid,
    @"reqnum" : @"20",
    @"userid" : (!_userID ? [SimuUtil getUserID] : _userID)
  };
}

- (BOOL)isDataValidWithResponseObject:(NSObject<Collectionable> *)latestData
                withRequestParameters:(NSDictionary *)parameters
                      withRefreshType:(RefreshType)refreshType {
  if (refreshType == RefreshTypeLoaderMore) {
    if (_seqID != parameters[@"fromid"]) {
      return NO;
    }
  }
  return YES;
}

- (void)bindRequestObject:(NSObject<Collectionable> *)latestData
    withRequestParameters:(NSDictionary *)parameters
          withRefreshType:(RefreshType)refreshType {
  [super bindRequestObject:latestData
      withRequestParameters:parameters
            withRefreshType:refreshType];
  if ([self.dataArray.array count] == 0) {
    //隐藏上下拉刷新
    self.footerView.hidden = YES;
    self.headerView.hidden = YES;
  }
  if ([self isDataValidWithResponseObject:latestData
                    withRequestParameters:parameters
                          withRefreshType:refreshType]) {
    TraceItem *lastItem =
        ((TracingPageRequest *)latestData).dataArray.lastObject;
    _seqID = lastItem.mSeqid;
  }
}

- (void)deleteItemAndReloadTable:(TraceItem *)item {
  [self.dataArray.array removeObject:item];
  [self.tableView reloadData];
  //考虑数据为空，小牛显示情况
  if (self.dataArray.array.count == 0) {
    [self.littleCattleView isCry:NO];
  }
}

@end

/*
 *
 */
@implementation TrancingViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  _isMyTrance = [_userID isEqualToString:[SimuUtil getUserID]];
  _headViewHeight = _isMyTrance ? 31 : 0;

  [self resetTitle:(_isMyTrance ? @"我的追踪" : @"TA的追踪")];
  [self createSearchButton];

  if (_isMyTrance) {
    [self registerObserWithTrace];
    [self isAuthority];

    //推送开启提示
    if (![SimuUtil hasNotificationsEnabled]) {
      NSString *Opend = [[NSUserDefaults standardUserDefaults]
          objectForKey:@"SwitchBPushNotificationsEnabled"];
      if ([Opend intValue] != 1) {
        [WeiboToolTip showMakeSureWithTitle:@"温馨提示"
            largeContent:@"通" @"知" @"功"
            @"能未开启，您将接收不到追踪牛人的交易提"
            @"醒消" @"息。请" @"在iPhone的【设置】-" @"【" @"通"
            @"知】功能中，找到应用【优"
            @"顾炒股】开启通知。"
            lineSpacing:10
            contentTopSpacing:10
            contentBottomSpacing:10
            sureButtonTitle:@"不再提示"
            cancelButtonTitle:@"我知道了"
            sureblock:^{
              [[NSUserDefaults standardUserDefaults]
                  setObject:@"1"
                     forKey:@"SwitchBPushNotificationsEnabled"];
            }
            cancleblock:^{
            }];
      }
    }
    // ta的追踪则直接请求
  } else {
    [self createTableView];
  }
}

- (void)createSearchButton {
  //搜索按钮
  UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
  searchButton.frame = CGRectMake(self.view.frame.size.width - 40,
                                  _topToolBar.frame.size.height - 45, 40, 45);
  [searchButton setImage:[UIImage imageNamed:@"搜索小图标"]
                forState:UIControlStateNormal];
  [searchButton setBackgroundImage:[UIImage imageNamed:@"return_touch_down"]
                          forState:UIControlStateHighlighted];
  [searchButton addTarget:self
                   action:@selector(searchFriendList:)
         forControlEvents:UIControlEventTouchUpInside];
  [_topToolBar addSubview:searchButton];

  //菊花左移
  _indicatorView.frame =
      CGRectMake(self.view.bounds.size.width - 85,
                 _topToolBar.bounds.size.height - 45, 45, 45);

  [_indicatorView setButonIsVisible:NO];
}

- (void)createNoTrancingView {
  _noTranceView = [[[NSBundle mainBundle] loadNibNamed:@"NoTrancingView"
                                                 owner:self
                                               options:nil] firstObject];
  _noTranceView.frame = _clientView.bounds;
  [_clientView addSubview:_noTranceView];

  [_noTranceView.trancingButton setOnButtonPressedHandler:^{
    [self creatTrackMasgerPurchesController];
  }];
}

- (void)searchFriendList:(UIButton *)button {
  StockFriendsViewController *stockFriendVC =
      [[StockFriendsViewController alloc] init];
  [AppDelegate pushViewControllerFromRight:stockFriendVC];
}

/** 检测追踪信息变化_注册观察者 */
- (void)registerObserWithTrace {
  __weak TrancingViewController *weakSelf = self;
  _receiveObser = [[NSNotificationCenter defaultCenter]
      addObserverForName:TraceChangeNotification
                  object:nil
                   queue:[NSOperationQueue mainQueue]
              usingBlock:^(NSNotification *note) {
                TrancingViewController *strongSelf = weakSelf;
                if (strongSelf) {
                  //重新刷新
                  [strongSelf refreshButtonPressDown];
                }
              }];
}

- (void)createTableHeaderView {
  _headerView = [[[NSBundle mainBundle] loadNibNamed:@"MyTranceTableHeaderView"
                                               owner:self
                                             options:nil] firstObject];
  _headerView.frame = CGRectMake(0, 0, _clientView.width, _headViewHeight);
  [_clientView addSubview:_headerView];

  [_headerView.renewButton setOnButtonPressedHandler:^{
    [self creatTrackMasgerPurchesController];
  }];
}

- (void)createTableView {
  _tableVC = [[TrancingTableViewController alloc]
      initWithFrame:CGRectMake(0, _headViewHeight, _clientView.width,
                               _clientView.height - _headViewHeight)];
  _tableVC.isMyTrance = _isMyTrance;
  _tableVC.userID = _userID;
  [_clientView addSubview:_tableVC.view];
  [self addChildViewController:_tableVC];

  __weak TrancingViewController *weakSelf = self;

  _tableVC.beginRefreshCallBack = ^{
    [weakSelf.indicatorView startAnimating];
  };
  _tableVC.endRefreshCallBack = ^{
    [weakSelf.indicatorView stopAnimating];
  };

  //开始网络请求
  [_tableVC refreshButtonPressDown];
}

- (void)refreshButtonPressDown {
  [_tableVC refreshButtonPressDown];
}

#pragma mark - 判断用户是否有跟踪权限
- (void)isAuthority {
  if (![SimuUtil isExistNetwork]) {
    [_indicatorView stopAnimating];
    [_littleCattleView isCry:YES];
    [NewShowLabel setMessageContent:REQUEST_FAILED_MESSAGE];
    return;
  }

  [_indicatorView startAnimating];
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  //解析
  __weak TrancingViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    TrancingViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [_indicatorView stopAnimating];
      return NO;
    } else
      return YES;
  };
  callback.onSuccess = ^(NSObject *obj) {
    TrancingViewController *strongSelf = weakSelf;
    if (strongSelf) {
      DeadLineRequest *request = (DeadLineRequest *)obj;
      DeadlineItem *item = request.dataArray[0];
      [_noTranceView removeFromSuperview];
      [self createTableHeaderView];
      [self createTableView];
      _headerView.deadLineLabel.text = [@"截止日期："
          stringByAppendingString:(item.isShowDeadline ? @"已到期"
                                                       : item.deadLineStr)];
      _headerView.renewButton.hidden = !item.isShowRenewBtn;
    }
  };
  callback.onError = ^(BaseRequestObject *error, NSException *ex) {
    //未开通追踪权限
    if ([error.status isEqualToString:@"0299"]) {
      [self createNoTrancingView];
      return;
    }
  };

  [DeadLineRequest getDeadLineWithCallback:callback];
}

#pragma mark - 购买成功，获得追踪权限
- (void)refreshMyTrancingView {
  //购买界面返回
  [self isAuthority];
}

#pragma mark - 追踪牛人商店相关函数
- (void)creatTrackMasgerPurchesController {
  if ([SimuConfigConst isShowPropsForReview]) {
    [AppDelegate
        pushViewControllerFromRight:[[NetShoppingMallBaseViewController alloc]
                                        initWithPageType:Mall_Buy_Props]];
  } else {
    MasterPurchesViewController *mfvc_masterPruchesViewController =
        [[MasterPurchesViewController alloc] init];
    mfvc_masterPruchesViewController.delegate = self;
    mfvc_masterPruchesViewController.traceDelegate = self;
    [AppDelegate pushViewControllerFromRight:mfvc_masterPruchesViewController];
  }
}

- (void)leftButtonPress {
  //释放观察者
  [[NSNotificationCenter defaultCenter] removeObserver:_receiveObser];
  _receiveObser = nil;
  [AttentionEventObserver postAttentionEvent];
  [super leftButtonPress];
}

@end
