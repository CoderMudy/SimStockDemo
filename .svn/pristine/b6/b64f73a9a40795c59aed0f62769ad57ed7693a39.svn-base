//
//  MatchTableViewController.m
//  SimuStock
//
//  Created by 刘小龙 on 15/6/24.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "MatchTableViewController.h"
#import "MatchStockCell.h"
#import "CompetitionDetailsViewController.h"
#import "SimuHavePrizeViewController.h"

// tableView 的协议
@implementation MatchTableAdaper

//继承了 BaseTableAdapter 下面是子类必须实现的方法

- (NSString *)nibName {
  static NSString *nibFileName;
  if (nibFileName == nil) {
    nibFileName = NSStringFromClass([MatchStockCell class]);
  }
  return nibFileName;
}

#pragma mark-- cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 100.0f;
}

#pragma mark-- 有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.dataArray.array count];
}

#pragma mark-- cell的复用
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  MatchStockCell *cell = [tableView dequeueReusableCellWithIdentifier:self.nibName];
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  StockMatchListItem *item = self.dataArray.array[indexPath.row];
  [cell bindDataWithStockMatchItem:item];
  return cell;
}

#pragma mark-- cell的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  //取消点击状态
  if (self.endTableAdapterBlcok) {
    self.endTableAdapterBlcok();
  }

  StockMatchListItem *item = self.dataArray.array[indexPath.row];
  if (item.wapJump) {
    SimuHavePrizeViewController *havePrizeVC =
        [[SimuHavePrizeViewController alloc] initWithTitleName:item.matchName
                                                   withMatchID:item.matchId
                                                 withMatchType:item.type
                                                   withMainUrl:item.mainUrl];
    havePrizeVC.webBool = item.isWapReg;
    havePrizeVC.webStringURL = item.wapRegUrl;
    [AppDelegate pushViewControllerFromRight:havePrizeVC];
  } else {
    //创建跳转页面
    CompetitionDetailsViewController *competitionVC =
        [[CompetitionDetailsViewController alloc] initWithMatchID:item.matchId
                                                    withTitleName:item.matchName
                                                        withMtype:item.type];
    competitionVC.webBool = item.isWapReg;
    competitionVC.webStringURL = item.wapRegUrl;
    [AppDelegate pushViewControllerFromRight:competitionVC];
  }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  int contentOffsetY = scrollView.contentOffset.y;
  if (contentOffsetY != 0) {
    if ([self.dataArray.array count] > 0) {
      [((MatchTableViewController *)self.baseTableViewController).searchField resignFirstResponder];
    }
  }
}

@end

// tableView
@implementation MatchTableViewController {
  NSInteger _pageIndex;
}

// init初始化
- (id)initWithFrame:(CGRect)frame withMatchStockType:(MatchStockType)matchType {
  self = [super initWithFrame:frame];
  if (self) {
    self.mathcTypeRequest = matchType;
    [self refreshCurrentData];
  }
  return self;
}

/** 登陆、退出进行刷新 */
- (void)refreshCurrentData {
  __weak MatchTableViewController *weakSelf = self;
  _loginLogoutNotification = [[LoginLogoutNotification alloc] init];
  _loginLogoutNotification.onLoginLogout = ^{
    [weakSelf refreshButtonPressDown];
  };
}

- (void)viewDidLoad {
  [super viewDidLoad];
  //给小牛一个文案
  switch (self.mathcTypeRequest) {
  case AllMathc:
    [self.littleCattleView setInformation:@"暂无比赛数据"];
    //添加广告
    [self addBanner];
    break;
  case SchoolMatc:
  case RewardMatc:
    [self.littleCattleView setInformation:@"暂无比赛数据"];
    break;
  case MyMathc:
    [self.littleCattleView setInformation:@"您还没有参加任何比赛，\n"
                           @"您可以选择参与比赛或创建比赛。"];
    break;
  case SearchMatch:
    [self.littleCattleView setInformation:@"没有找到相关比赛"];
    break;
  }
  _pageIndex = 1;
}
//顶部广告栏
- (void)addBanner {
  advViewVC = [[GameAdvertisingViewController alloc] initWithAdListType:AdListTypeCompetion];
  advViewVC.delegate = self;
  advViewVC.view.userInteractionEnabled = YES;
  [self addChildViewController:advViewVC];
  advViewVC.view.backgroundColor = [Globle colorFromHexRGB:@"#efefef"];
  //数据请求
  [advViewVC requestImageAdvertiseList];
}

#pragma mark-- GameAdvertisingViewController 的协议
- (void)advertisingPageJudgment:(BOOL)AdBool intg:(NSInteger)intg {
  //判断有没有 广告
  if (AdBool) {
    self.tableView.userInteractionEnabled = YES;
    self.tableView.tableHeaderView.hidden = NO;
    CGFloat factor = WIDTH_OF_SCREEN / 320;
    advViewVC.view.frame = CGRectMake(0, 0, self.view.frame.size.width, competionAdvHeight * factor);
    self.tableView.tableHeaderView = advViewVC.view;
    advViewVC.view.userInteractionEnabled = YES;
    self.tableView.tableHeaderView.backgroundColor = [Globle colorFromHexRGB:@"#efefef"];
  } else {
    [advViewVC.view removeFromSuperview];
    self.tableView.tableHeaderView = nil;
    self.tableView.tableHeaderView.hidden = YES;
  }
}

/** 请求最新数据，此方法子类必须实现 */
- (void)requestDataListWithRefreshType:(RefreshType)refreshType
                         withDataArray:(DataArray *)existDataList
                          withCallBack:(HttpRequestCallBack *)callback {
  switch (self.mathcTypeRequest) {
  case AllMathc:
  case SchoolMatc:
  case RewardMatc:
    [StockMatchList requestAllStockMatchListWithDictionary:[self getRequestParamertsWithRefreshType:refreshType]
                                              withCallback:callback];
    break;
  case MyMathc:
    [StockMatchList requestMyStockMatchListWithDictionary:[self getRequestParamertsWithRefreshType:refreshType]
                                             withCallback:callback];
    break;
  case SearchMatch:
    [StockMatchList requestSeatchStockMatchListWithDictionary:[self getRequestParamertsWithRefreshType:refreshType]
                                                 withCallback:callback];
    break;
  }
}

- (BOOL)supportAutoLoadMore {
  return YES;
}

//请求参数
- (NSDictionary *)getRequestParamertsWithRefreshType:(RefreshType)refreshType {

  NSString *pageIndex = @"1";
  NSString *pageSize = @"10";
  NSString *type;

  switch (self.mathcTypeRequest) {
  case AllMathc:
    type = @"0";
    break;
  case RewardMatc:
    type = @"1";
    break;
  case SchoolMatc:
    type = @"2";
    break;
  default:
    type = @"0";
    break;
  }

  if (refreshType == RefreshTypeLoaderMore) {
    pageIndex = [NSString stringWithFormat:@"%ld", (long)_pageIndex + 1];
  }

  NSDictionary *dic = nil;
  if (self.mathcTypeRequest == SearchMatch) {
    self.textFiled = [CommonFunc base64StringFromText:self.searchField.text];
    dic = @{
      @"likeMatchName" : self.textFiled,
      @"pageIndex" : pageIndex,
      @"pageSize" : pageSize,
    };
  } else if (self.mathcTypeRequest == MyMathc) {
    dic = @{ @"pageIndex" : pageIndex, @"pageSize" : pageSize };
  } else {
    dic = @{ @"pageIndex" : pageIndex, @"pageSize" : pageSize, @"type" : type };
  }
  return dic;
}

/** 判断返回数据是否非法，此方法子类必须实现 */
- (BOOL)isDataValidWithResponseObject:(NSObject<Collectionable> *)latestData
                withRequestParameters:(NSDictionary *)parameters
                      withRefreshType:(RefreshType)refreshType {
  if (refreshType == RefreshTypeLoaderMore) {
    NSString *pageIndex = parameters[@"pageIndex"];
    NSString *lastPageIndex = [NSString stringWithFormat:@"%ld", (long)_pageIndex + 1];
    if (![pageIndex isEqualToString:lastPageIndex]) {
      return NO;
    }
  }
  return YES;
}

- (void)bindRequestObject:(NSObject<Collectionable> *)latestData
    withRequestParameters:(NSDictionary *)parameters
          withRefreshType:(RefreshType)refreshType {

  [super bindRequestObject:latestData withRequestParameters:parameters withRefreshType:refreshType];
  if ([self isDataValidWithResponseObject:latestData
                    withRequestParameters:parameters
                          withRefreshType:refreshType]) {
    if (refreshType == RefreshTypeLoaderMore) {
      _pageIndex++;
    } else {
      _pageIndex = 1;
    }
  }
}

/** 返回表格数据适配器，此方法子类必须实现 */
- (BaseTableAdapter *)getBaseTableAdaperWithDataList:(DataArray *)dataList {
  if (_tableAdapter == nil) {
    _tableAdapter =
        [[MatchTableAdaper alloc] initWithTableViewController:self withDataArray:self.dataArray];
    MatchTableAdaper *adaper = (MatchTableAdaper *)_tableAdapter;
    //    self.endEditBlock = adaper.endTableAdapterBlcok;
    adaper.endTableAdapterBlcok = self.endEditBlock;
    UINib *cellNib = [UINib nibWithNibName:_tableAdapter.nibName bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:_tableAdapter.nibName];
  }
  return _tableAdapter;
}

- (void)requestResponseWithRefreshType:(RefreshType)refreshType {
  if (refreshType == RefreshTypeHeaderRefresh && advViewVC) {
    [advViewVC requestImageAdvertiseList];
  }
  if (self.mathcTypeRequest == SearchMatch) {
    if (self.searchField.text == nil || self.searchField.text.length == 0) {
      [self performSelector:@selector(endRefreshLoading) withObject:nil afterDelay:0.5];
      return;
    }
    self.textFiled = [CommonFunc base64StringFromText:self.searchField.text];
  }
  [super requestResponseWithRefreshType:refreshType];
}

#pragma mark
#pragma mark------菊花控件-------
- (void)refreshButtonPressDown {
  [self requestResponseWithRefreshType:RefreshTypeRefresh];
}
@end
