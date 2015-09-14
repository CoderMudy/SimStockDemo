//
//  StockPriceStateViewController.m
//  SimuStock
//
//  Created by Yuemeng on 15/6/10.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "StockPriceStateViewController.h"
#import "StockPriceStateCell.h"
#import "TimerUtil.h"
#import "SimuTradeStatus.h"

@implementation StockPriceStateTableAdapter

- (NSString *)nibName {
  static NSString *nibFileName;
  if (nibFileName == nil) {
    nibFileName = NSStringFromClass([StockPriceStateCell class]);
  }
  return nibFileName;
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 15;
}

- (CGFloat)lastClosePrice {
  NSString *lastClosePrice = _securitiesInfo.otherInfoDic[LastClosePriceKey];
  return lastClosePrice ? [lastClosePrice floatValue] : 0.f;
}

- (NSString *)priceFormat {
  return [StockUtil
      getPriceFormatWithFirstType:_securitiesInfo.securitiesFirstType()];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  StockPriceStateCell *cell =
      [tableView dequeueReusableCellWithIdentifier:self.nibName];

  StockPriceStateData *data = self.dataArray.array[indexPath.row];
  [cell bindStockPriceStateData:data
                 lastClosePrice:self.lastClosePrice
                    totalAmount:_totalAmount
                    priceFormat:self.priceFormat]; //昨收价,总交易量

  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForHeaderInSection:(NSInteger)section {

  return 20;
}

- (UIView *)tableView:(UITableView *)tableView
    viewForHeaderInSection:(NSInteger)section {

  UILabel *titleLabel = [[UILabel alloc]
      initWithFrame:CGRectMake(0, 0, self.baseTableViewController.view.width,
                               20)];
  titleLabel.text = @"成交价  成交量    占比";
  titleLabel.textAlignment = NSTextAlignmentLeft;
  titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
  titleLabel.font = [UIFont systemFontOfSize:Font_Height_10_0];
  titleLabel.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  return titleLabel;
}

@end

/*
 *  分价
 */

@implementation StockPriceStateViewController {
  TimerUtil *_timer;
}

- (void)dealloc {
  [_timer stopTimer];
}

- (id)initWithFrame:(CGRect)frame
 withSecuritiesInfo:(SecuritiesInfo *)securitiesInfo {
  if (self = [super initWithFrame:frame]) {
    self.securitiesInfo = securitiesInfo;
    __weak StockPriceStateViewController *weakSelf = self;
    NSInteger refreshTime = [SimuUtil getCorRefreshTime];
    _timer = [[TimerUtil alloc] initWithTimeInterval:refreshTime
                                    withTimeCallBack:^{
                                      [weakSelf refreshByTimer];
                                    }];
  }
  return self;
}

- (void)refreshByTimer {
  //如果无网络，则什么也不做；
  if (![SimuUtil isExistNetwork]) {
    return;
  }
  //如果当前交易所状态为闭市，则什么也不做
  if ([[SimuTradeStatus instance] getExchangeStatus] == TradeClosed) {
    return;
  }

  [self requestResponseWithRefreshType:RefreshTypeTimerRefresh];
}

/** 请求最新数据，此方法子类必须实现 */
- (void)requestDataListWithRefreshType:(RefreshType)refreshType
                         withDataArray:(DataArray *)existDataList
                          withCallBack:(HttpRequestCallBack *)callback {

  [StockPriceStateInfo
      getStockPriceStateWithStockCode:_securitiesInfo.securitiesCode()
                         wichCallback:callback];
}

- (BOOL)supportAutoLoadMore {
  return YES;
}

/** 返回表格数据适配器，此方法子类必须实现 */
- (BaseTableAdapter *)getBaseTableAdaperWithDataList:(DataArray *)dataList {
  if (_tableAdapter == nil) {
    _tableAdapter = [[StockPriceStateTableAdapter alloc]
        initWithTableViewController:self
                      withDataArray:self.dataArray];
    UINib *cellNib = [UINib nibWithNibName:_tableAdapter.nibName bundle:nil];
    [self.tableView registerNib:cellNib
         forCellReuseIdentifier:_tableAdapter.nibName];
    ((StockPriceStateTableAdapter *)_tableAdapter).securitiesInfo =
        self.securitiesInfo;
  }
  return _tableAdapter;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.littleCattleView = nil;
  self.tableView.bounces = NO;
  [self.tableView addWidth:8];
  self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(15, 0, 0, 0);
}

- (void)bindRequestObject:(NSObject<Collectionable> *)latestData
    withRequestParameters:(NSDictionary *)parameters
          withRefreshType:(RefreshType)refreshType {
  StockPriceStateInfo *stockPriceStateInfo = (StockPriceStateInfo *)latestData;
  __block int64_t totalAmount = 0;
  [stockPriceStateInfo.dataArray
      enumerateObjectsUsingBlock:^(StockPriceStateData *data, NSUInteger idx,
                                   BOOL *stop) {
        totalAmount += data.amount;
      }];
  if (totalAmount > 0) {
    ((StockPriceStateTableAdapter *)_tableAdapter).totalAmount = totalAmount;
  }

  [super bindRequestObject:latestData
      withRequestParameters:parameters
            withRefreshType:refreshType];
  self.dataArray.dataComplete = YES;
  self.footerView.hidden = YES;
  self.headerView.hidden = YES;
}

@end
