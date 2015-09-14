//
//  TradeDetailView.m
//  SimuStock
//
//  Created by moulin wang on 14-2-17.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "TradeDetailView.h"
#import "UIButton+Block.h"

@implementation TradeDetailAdaper

- (NSString *)nibName {
  static NSString *nibFileName;
  if (nibFileName == nil) {
    nibFileName = NSStringFromClass([TradeDetailNewCell class]);
  }
  return nibFileName;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  ClosedDetailInfo *tweetItem = self.dataArray.array[indexPath.row];
  tweetItem.heightCache = [[NSMutableDictionary alloc] init];
  if (!tweetItem.heightCache[HeightCacheKeyAll]) {
    tweetItem.heightCache[HeightCacheKeyAll] =
        @([TradeDetailNewCell cellHeightWithTweetListItem:tweetItem withShowButtons:_showButtons]);
  }
  return [tweetItem.heightCache[HeightCacheKeyAll] floatValue];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  //取消按钮的点击状态
  TradeDetailNewCell *cell = (TradeDetailNewCell *)[tableView cellForRowAtIndexPath:indexPath];
  [cell.selBtn setHighlighted:NO];
  [cell.buyBtn setHighlighted:NO];
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
  //切换详情页
  [TrendViewController showDetailWithStockCode:_stockCode
                                 withStockName:_name
                                 withFirstType:FIRST_TYPE_UNSPEC
                                   withMatchId:_macthId];
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  TradeDetailNewCell *cell = (TradeDetailNewCell *)[tableView dequeueReusableCellWithIdentifier:self.nibName];
  if (_showButtons) {
    cell.buyBtn.hidden = NO;
    cell.selBtn.hidden = NO;
    [cell enableSellButton:_canSell];
  } else {
    cell.buyBtn.hidden = YES;
    cell.selBtn.hidden = YES;
  }
  __weak TradeDetailAdaper *weakSelf = self;
  [cell.buyBtn setOnButtonPressedHandler:^{
    [weakSelf buyBtnClick];
  }];
  [cell.selBtn setOnButtonPressedHandler:^{
    [weakSelf sellBtnClick];
  }];

  //获取数据
  [cell bindClosedDetailInfo:self.dataArray.array[indexPath.row]];

  //第一条和第二条分割线隐藏与否判断
  if (indexPath.row == 0) {
    cell.firstLineView.hidden = YES;
  } else {
    cell.firstLineView.hidden = NO;
  }
  if (indexPath.row == ([self.dataArray.array count] - 1)) {
    cell.secondLineView.hidden = YES;
  } else {
    cell.secondLineView.hidden = NO;
  }
  //隐藏分割线
  if (self.dataArray.array.count == 1) {
    cell.cuttingLine.hidden = YES;
  }
  return cell;
}
//买入按钮
- (void)buyBtnClick {

  [FullScreenLogonViewController checkLoginStatusWithCallBack:^(BOOL isLogined) {
    [simuBuyViewController buyStockWithStockCode:_stockCode
                                   withStockName:_name
                                     withMatchId:_macthId];
  }];
}
//卖出按钮
- (void)sellBtnClick {

  [FullScreenLogonViewController checkLoginStatusWithCallBack:^(BOOL isLogined) {
    [simuSellViewController sellStockWithStockCode:_stockCode
                                     withStockName:_name
                                       withMatchId:_macthId];
  }];
}
@end

@implementation TradeDetailTableViewController

- (id)initWithFrame:(CGRect)frame
         withUserId:(NSString *)userId
     withPositionId:(NSString *)positionId
        withMatchId:(NSString *)matchId
      withStockCode:(NSString *)stockCode
      withStockName:(NSString *)stockName
     withIsPosition:(BOOL)isPosition
      withIsCanSell:(BOOL)canSell {
  if (self = [super initWithFrame:frame]) {
    self.userId = userId;
    self.positionId = positionId;
    self.matchId = matchId;
    self.stockCode = stockCode;
    self.stockName = stockName;
    self.isPosition = isPosition;
    self.isCansell = canSell;
  }
  return self;
}

static NSInteger REQ_NUM = 1;

/** 将入参封装成一个dic， */
- (NSDictionary *)getRequestParamertsWithRefreshType:(RefreshType)refreshType {
  NSString *startId = @"0";
  if (refreshType == RefreshTypeLoaderMore) {
    ClosedDetailInfo *info = self.dataArray.array.lastObject;
    startId = info.seqID;
  }
  NSDictionary *dic = @{
    @"userid" : self.userId,
    @"positionid" : self.positionId,
    @"matchid" : self.matchId,
    @"fromid" : startId,
    @"reqnum" : [@(REQ_NUM) stringValue]
  };
  return dic;
}
/** 判断返回数据是否有效 */
- (BOOL)isDataValidWithResponseObject:(NSObject<Collectionable> *)latestData
                withRequestParameters:(NSDictionary *)parameters
                      withRefreshType:(RefreshType)refreshType {
  if (refreshType == RefreshTypeLoaderMore) {
    NSString *fromId = parameters[@"fromid"];
    ClosedDetailInfo *info = self.dataArray.array.lastObject;
    NSString *lastId = info.seqID;
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

  if (self.isPosition) {
    [SimuClosedDetailPageData requestPositionTradeDetailWithDic:[self getRequestParamertsWithRefreshType:refreshType]
                                                   withCallback:callback];
  } else {
    [SimuClosedDetailPageData requestClosedTradeDetailWithDic:[self getRequestParamertsWithRefreshType:refreshType]
                                                 withCallback:callback];
  }
}

- (void)viewDidLoad {
  [super viewDidLoad];
  //设置小牛信息
  [self.littleCattleView setInformation:@"暂无数据"];
}
/** 返回表格数据适配器，此方法子类必须实现 */
- (BaseTableAdapter *)getBaseTableAdaperWithDataList:(DataArray *)dataList {
  if (_tableAdapter == nil) {

    _tableAdapter =
        [[TradeDetailAdaper alloc] initWithTableViewController:self withDataArray:self.dataArray];
    TradeDetailAdaper *temp = (TradeDetailAdaper *)_tableAdapter;
    temp.stockCode = self.stockCode;
    temp.name = self.stockName;
    temp.macthId = self.matchId;
    temp.canSell = self.isCansell;
    temp.showButtons = [@"1" isEqualToString:self.matchId];
    UINib *cellNib = [UINib nibWithNibName:_tableAdapter.nibName bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:_tableAdapter.nibName];
  }
  return _tableAdapter;
}

@end

@implementation TradeDetailView {
  PositionInfo *_positionInfo;
  ClosedPositionInfo *_closedPositionInfo;
}

- (NSString *)stockCode {
  return _isPosition ? _positionInfo.stockCode : _closedPositionInfo.stockCode;
}
- (NSString *)stockName {
  return _isPosition ? _positionInfo.stockName : _closedPositionInfo.stockName;
}
- (NSString *)positionID {
  return _isPosition ? _positionInfo.seqid : _closedPositionInfo.positionID;
}

- (id)initWithUserId:(NSString *)uid
         withMatchId:(NSString *)matchId
    withPositionInfo:(PositionInfo *)positionInfo {
  if (self = [super init]) {
    self.uid = uid;
    self.matchId = matchId;
    self.isPosition = YES;
    _positionInfo = positionInfo;
    self.isCansell = [@"1" isEqualToString:matchId] && [SimuPositionPageData isStockSellable:self.stockCode];
  }
  return self;
}

- (id)initWithUserId:(NSString *)uid
               withMatchId:(NSString *)matchId
    withClosedPositionInfo:(ClosedPositionInfo *)closedPositionInfo {
  if (self = [super init]) {
    self.uid = uid;
    self.matchId = matchId;
    self.isPosition = NO;
    _closedPositionInfo = closedPositionInfo;
    self.isCansell = [@"1" isEqualToString:matchId] && [SimuPositionPageData isStockSellable:self.stockCode];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  NSString *code = [StockUtil sixStockCode:self.stockCode];

  NSString *title = [NSString stringWithFormat:@"%@(%@)", self.stockName, code];
  [_topToolBar resetContentAndFlage:title Mode:TTBM_Mode_Leveltwo];

  [self createTradeDetailTableView];
  [tradeDeailTableVC refreshButtonPressDown];
}
//创建交易表格
- (void)createTradeDetailTableView {
  tradeDeailTableVC = [[TradeDetailTableViewController alloc] initWithFrame:_clientView.bounds
                                                                 withUserId:self.uid
                                                             withPositionId:self.positionID
                                                                withMatchId:self.matchId
                                                              withStockCode:self.stockCode
                                                              withStockName:self.stockName
                                                             withIsPosition:self.isPosition
                                                              withIsCanSell:self.isCansell];
  __weak TradeDetailView *weakSelf = self;
  tradeDeailTableVC.showTableFooter = YES;
  tradeDeailTableVC.beginRefreshCallBack = ^{
    [weakSelf.indicatorView startAnimating];
    weakSelf.indicatorView.hidden = NO;
  };

  tradeDeailTableVC.endRefreshCallBack = ^{
    [weakSelf.indicatorView stopAnimating];
    weakSelf.indicatorView.hidden = YES;
  };

  [_clientView addSubview:tradeDeailTableVC.view];
  [self addChildViewController:tradeDeailTableVC];
}

@end
