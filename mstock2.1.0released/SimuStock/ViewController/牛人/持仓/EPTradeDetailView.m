//
//  TradeDetailView.m
//  SimuStock
//
//  Created by moulin wang on 14-2-17.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "EPTradeDetailView.h"
#import "FollowBuyClientVC.h"

@implementation EPTradeAdapter

- (NSString *)nibName {
  return NSStringFromClass([TradeRecordTableViewCell class]);
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  ClosedDetailInfo *item =
      (ClosedDetailInfo *)self.dataArray.array[indexPath.row];
  return [TradeRecordTableViewCell adjustHeightForTradeRecord:item];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  TradeRecordTableViewCell *cell = (TradeRecordTableViewCell *)
      [tableView dequeueReusableCellWithIdentifier:self.nibName];

  ClosedDetailInfo *item = self.dataArray.array[indexPath.row];
  cell.buyAction = self.buyAction;
  cell.sellAction = self.sellAction;
  [cell bindClosedDetailInfo:item];

  cell.timeLineUp.hidden = indexPath.row == 0;
  cell.timeLineDown.hidden = self.dataArray.dataComplete &&
                             indexPath.row == self.dataArray.array.count - 1;

  //用户无权限查看计划，则隐藏买卖按钮
  BOOL userCanFollow = [self.owner.planData judgeUserPurchased];
  cell.btnBuy.hidden = !userCanFollow;
  cell.btnSell.hidden = !userCanFollow;

  return cell;
}

- (EPTradeTableVC *)owner {
  return (EPTradeTableVC *)self.baseTableViewController;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
  BOOL userCanFollow = [self.owner.planData judgeExpert] ||
                       [self.owner.planData judgeUserPurchased];
  if (!userCanFollow) {
    return;
  }

  TradeRecordTableViewCell *cell =
      (TradeRecordTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
  [cell.btnBuy setHighlighted:NO];
  [cell.btnSell setHighlighted:NO];
  ClosedDetailInfo *item = self.dataArray.array[indexPath.row];
  [TrendViewController showDetailWithStockCode:item.stockCode
                                 withStockName:item.stockName
                                 withFirstType:FIRST_TYPE_UNSPEC
                                   withMatchId:@"1"
                                withIsExperter:YES];
}

@end

@implementation EPTradeTableVC

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.littleCattleView setInformation:@"暂无交易记录"];
}

/** 将入参封装成一个dic， */
- (NSDictionary *)getRequestParamertsWithRefreshType:(RefreshType)refreshType {
  NSString *fromId = @"0";
  if (refreshType == RefreshTypeLoaderMore) {
    ClosedDetailInfo *item = [self.dataArray.array lastObject];
    fromId = item.seqID;
  }

  NSString *target =
      [NSString stringWithFormat:@"%ld", (long)_planData.targetUid];

  NSMutableDictionary *dic = [@{
    @"accountId" : _planData.accoundId,
    @"targetUid" : target,
    @"fromId" : fromId,
    @"reqNum" : @"20"
  } mutableCopy];
  if (_positionId) {
    dic[@"positionId"] = _positionId;
  }
  return dic;
}
/** 判断返回数据是否有效 */
- (BOOL)isDataValidWithResponseObject:(NSObject<Collectionable> *)latestData
                withRequestParameters:(NSDictionary *)parameters
                      withRefreshType:(RefreshType)refreshType {
  if (refreshType == RefreshTypeLoaderMore) {
    NSString *fromId = parameters[@"fromId"];
    ClosedDetailInfo *item = [self.dataArray.array lastObject];
    if (![fromId isEqualToString:item.seqID]) {
      return NO;
    }
  }
  return YES;
}
/** 请求最新数据，此方法子类必须实现 */
- (void)requestDataListWithRefreshType:(RefreshType)refreshType
                         withDataArray:(DataArray *)existDataList
                          withCallBack:(HttpRequestCallBack *)callback {
  [SimuClosedDetailPageData
      requestSuperTradeListWithParams:
          [self getRequestParamertsWithRefreshType:refreshType]
                         withCallback:callback];
}

- (BaseTableAdapter *)getBaseTableAdaperWithDataList:(DataArray *)dataList {
  if (_tradeAdapter == nil) {
    _tradeAdapter =
        [[EPTradeAdapter alloc] initWithTableViewController:self
                                              withDataArray:self.dataArray];
    UINib *cellNib = [UINib nibWithNibName:_tradeAdapter.nibName bundle:nil];
    [self.tableView registerNib:cellNib
         forCellReuseIdentifier:_tradeAdapter.nibName];

    __weak EPTradeTableVC *weakSelf = self;
    TradeInfoCellButtonCallback buyAction = ^(ClosedDetailInfo *positionInfo) {
      EPTradeTableVC *strongSelf = weakSelf;
      if (strongSelf) {

        FollowBuyClientVC *vc =
            [[FollowBuyClientVC alloc] initWithStockCode:positionInfo.stockCode
                                           withStockName:positionInfo.stockName
                                               withIsBuy:YES];
        [AppDelegate pushViewControllerFromRight:vc];
      }
    };
    TradeInfoCellButtonCallback sellAction = ^(ClosedDetailInfo *positionInfo) {
      EPTradeTableVC *strongSelf = weakSelf;
      if (strongSelf) {

        FollowBuyClientVC *vc =
            [[FollowBuyClientVC alloc] initWithStockCode:positionInfo.stockCode
                                           withStockName:positionInfo.stockName
                                               withIsBuy:NO];
        [AppDelegate pushViewControllerFromRight:vc];
      }
    };
    _tradeAdapter.buyAction = buyAction;
    _tradeAdapter.sellAction = sellAction;
  }
  return _tradeAdapter;
}

@end

@implementation EPTradeDetailView

- (id)initWithExpertPlanData:(ExpertPlanData *)planData {
  return [self initWithExpertPlanData:planData withPositonId:nil];
}

- (id)initWithExpertPlanData:(ExpertPlanData *)planData
               withPositonId:(PositionInfo *)positionInfo {
  if (self = [super init]) {
    self.planData = planData;
    self.positionInfo = positionInfo;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  NSString *title;
  NSString *target =
      [NSString stringWithFormat:@"%ld", (long)_planData.targetUid];
  if (_positionInfo) {
    title = [NSString stringWithFormat:@"%@(%@)", _positionInfo.stockName,
                                       _positionInfo.stockCode];

  } else if ([target isEqualToString:[SimuUtil getUserID]]) {
    title = @"我的交易";
  } else {
    title = @"TA的交易";
  }
  [_topToolBar resetContentAndFlage:title Mode:TTBM_Mode_Leveltwo];

  _tradeHistoryTableVC =
      [[EPTradeTableVC alloc] initWithFrame:self.clientView.bounds];
  _tradeHistoryTableVC.planData = _planData;
  _tradeHistoryTableVC.positionId = _positionInfo.seqid;

  __weak EPTradeDetailView *weakSelf = self;
  _tradeHistoryTableVC.beginRefreshCallBack = ^{
    [weakSelf.indicatorView startAnimating];
  };
  _tradeHistoryTableVC.endRefreshCallBack = ^{
    [weakSelf.indicatorView stopAnimating];
  };

  [self.clientView addSubview:_tradeHistoryTableVC.view];
  [self addChildViewController:_tradeHistoryTableVC];

  [_tradeHistoryTableVC refreshButtonPressDown];
}

- (void)refreshButtonPressDown {
  [_tradeHistoryTableVC refreshButtonPressDown];
}
@end
