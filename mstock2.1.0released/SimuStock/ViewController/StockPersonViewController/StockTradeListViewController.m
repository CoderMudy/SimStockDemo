//
//  StockTradeListViewController.m
//  SimuStock
//
//  Created by Mac on 15/4/23.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "StockTradeListViewController.h"
#import "TrendViewController.h"
#import "StockTradeList.h"
#import "WeiboUtil.h"

@implementation StockTradeAdaper

- (NSString *)nibName {
  static NSString *nibFileName;
  if (nibFileName == nil) {
    nibFileName = NSStringFromClass([HomeTradeDeatilTableViewCell class]);
  }
  return nibFileName;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

  TweetListItem *tweetItem = self.dataArray.array[indexPath.row];
  if (!tweetItem.heightCache[HeightCacheKeyAll]) {
    tweetItem.heightCache[HeightCacheKeyAll] =
        @([HomeTradeDeatilTableViewCell cellHeightWithTweetListItem:tweetItem
                                                    withShowButtons:_showButtons]);
  }
  return [tweetItem.heightCache[HeightCacheKeyAll] floatValue];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

  TweetListItem *homeData = self.dataArray.array[indexPath.row];

  if (homeData.type == 10) {

    HomeTradeDeatilTableViewCell *cell =
        (HomeTradeDeatilTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell.sellBtn setHighlighted:NO];
    [cell.buyBtn setHighlighted:NO];
    [cell.shareBtn setHighlighted:NO];
    NSString *stock =
        [WeiboUtil getAttrValueWithSource:homeData.content withElement:@"stock" withAttr:@"code"];
    NSString *stockName =
        [WeiboUtil getAttrValueWithSource:homeData.content withElement:@"stock" withAttr:@"name"];
    [TrendViewController showDetailWithStockCode:stock
                                   withStockName:stockName
                                   withFirstType:FIRST_TYPE_UNSPEC
                                     withMatchId:@"1"];
  }
  //取消按钮的点击状态
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
  return;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *identifier = @"HomeTradeDeatilTableViewCell";
  HomeTradeDeatilTableViewCell *cell =
      (HomeTradeDeatilTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
  TweetListItem *homeData = self.dataArray.array[indexPath.row];
  cell.row = indexPath.row;
  [cell bindTradeData:homeData];
  [cell hiddenButtons:!_showButtons];
  cell.delegate = self;
  return cell;
}

- (void)bidButtonTriggersCallbackMethod:(NSInteger)tag row:(NSInteger)row {
  TweetListItem *homeData = self.dataArray.array[row];
  tempRow = row;

  //分享
  if (tag == 7303) {
    //      // cell 截取成功，做分享
    MakingScreenShot *makingScreenShot = [[MakingScreenShot alloc] init];
    HomeTradeDeatilTableViewCell *cell = (HomeTradeDeatilTableViewCell *)[self.baseTableViewController.tableView
        cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
    shareImage = [makingScreenShot makingScreenShotWithFrame:cell.bounds
                                                    withView:cell
                                                    withType:MakingScreenShotType_TradePage];
  }

  [HomeTradeDeatilTableViewCell bidButtonTriggersCallbackMethod:tag
                                                            row:tempRow
                                                     shareImage:shareImage
                                                  shareUserName:self.userName
                                                       homeData:homeData];
}

@end

@implementation StockTradeTableViewController {

  NSInteger start;
}
/** 初始化*/
- (id)initWithFrame:(CGRect)frame
         withUserId:(NSString *)userid
       withUserName:(NSString *)userName
        withMatckId:(NSString *)matchId {
  if (self = [super initWithFrame:frame]) {
    _userId = userid;
    _userName = userName;
    _matchId = matchId;
  }
  return self;
}
/** 将入参封装成一个dic， */
- (NSDictionary *)getRequestParamertsWithRefreshType:(RefreshType)refreshType {
  NSString *startId = @"0";
  if (refreshType == RefreshTypeLoaderMore) {
    TweetListItem *tweetItem = [self.dataArray.array lastObject];
    startId = [tweetItem.tstockid stringValue];
  }

  NSDictionary *dic = @{
    @"uid" : self.userId,
    @"matchid" : self.matchId,
    @"fromtid" : startId,
    @"reqnum" : @"20"
  };

  return dic;
}
/** 判断返回数据是否有效 */
- (BOOL)isDataValidWithResponseObject:(NSObject<Collectionable> *)latestData
                withRequestParameters:(NSDictionary *)parameters
                      withRefreshType:(RefreshType)refreshType {
  if (refreshType == RefreshTypeLoaderMore) {
    NSString *fromId = parameters[@"fromtid"];
    TweetListItem *tweetItem = [self.dataArray.array lastObject];
    NSString *lastId = [tweetItem.tstockid stringValue];
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

  [StockTradeList requestTradeDetailWithDic:[self getRequestParamertsWithRefreshType:refreshType]
                               withCallback:callback];
}
/** 绑定数据(调用默认的绑定方法)，首先判断是否有效 */
- (void)bindRequestObject:(NSObject<Collectionable> *)latestData
    withRequestParameters:(NSDictionary *)parameters
          withRefreshType:(RefreshType)refreshType {
  if ([self isDataValidWithResponseObject:latestData
                    withRequestParameters:parameters
                          withRefreshType:refreshType]) {
    [super bindRequestObject:latestData
        withRequestParameters:parameters
              withRefreshType:refreshType];
    if (refreshType == RefreshTypeLoaderMore) {
      start += 20;
    } else {
      start = 1;
    }
  }
}
- (void)viewDidLoad {
  [super viewDidLoad];
  //设置小牛信息
  [self.littleCattleView setInformation:@"暂无交易数据"];
}
/** 返回表格数据适配器，此方法子类必须实现 */
- (BaseTableAdapter *)getBaseTableAdaperWithDataList:(DataArray *)dataList {
  if (_tableAdapter == nil) {

    _tableAdapter =
        [[StockTradeAdaper alloc] initWithTableViewController:self withDataArray:self.dataArray];
    StockTradeAdaper *temp = (StockTradeAdaper *)_tableAdapter;
    temp.userName = self.userName;
    temp.matchId = self.matchId;
    temp.showButtons = [@"1" isEqualToString:self.matchId];

    UINib *cellNib = [UINib nibWithNibName:_tableAdapter.nibName bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:_tableAdapter.nibName];
  }
  return _tableAdapter;
}
@end

@implementation StockTradeListViewController

- (void)dealloc {
  milliontableView.delegate = nil;
  milliontableView.dataSource = nil;
  if (footerView) {
    [footerView free];
    footerView.scrollView = nil;
  }
  if (headerView) {
    [headerView free];
    headerView.scrollView = nil;
  }
}
- (id)initWithFrame:(CGRect)frame
         withUserId:(NSString *)userid
      withStockCode:(NSString *)stockCode
       withUserName:(NSString *)userName
        withMatckId:(NSString *)matchId {
  if (self = [super initWithFrame:frame]) {
    self.userId = userid;
    self.matchId = matchId;
    self.userName = userName;
    self.stockCode = stockCode;
  }
  return self;
}
- (void)viewDidLoad {
  [super viewDidLoad];
  [self createTradeDetailTableView];
  [stockTradeTableVC refreshButtonPressDown];
}
//创建交易表格
- (void)createTradeDetailTableView {
  stockTradeTableVC = [[StockTradeTableViewController alloc] initWithFrame:self.view.bounds
                                                                withUserId:self.userId
                                                              withUserName:self.userName
                                                               withMatckId:self.matchId];
  __weak StockTradeListViewController *weakSelf = self;
  stockTradeTableVC.beginRefreshCallBack = ^{
    weakSelf.beginRefreshCallBack();
  };
  stockTradeTableVC.endRefreshCallBack = ^{
    weakSelf.endRefreshCallBack();
  };

  [self.view addSubview:stockTradeTableVC.view];
  [self addChildViewController:stockTradeTableVC];
  if (!stockTradeTableVC.dataBinded) {
    [stockTradeTableVC refreshButtonPressDown];
  }
}

#pragma mark 代理方法 - 进入刷新状态就会调用
- (void)refreshButtonPressDown {
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }
  [stockTradeTableVC refreshButtonPressDown];
}

@end
