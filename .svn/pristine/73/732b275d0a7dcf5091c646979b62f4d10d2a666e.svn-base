//
//  StockDetailTableViewController.m
//  SimuStock
//
//  Created by Yuemeng on 15/6/10.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "StockDetailTableViewController.h"
#import "StockTradeDetailCell.h"
#import "TimerUtil.h"
#import "SimuTradeStatus.h"

@implementation StockDetailTableAdapter

- (NSString *)nibName {
  static NSString *nibFileName;
  if (nibFileName == nil) {
    nibFileName = NSStringFromClass([StockTradeDetailCell class]);
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

  StockTradeDetailCell *cell =
      [tableView dequeueReusableCellWithIdentifier:self.nibName];

  StockTradeDetailData *detailData = self.dataArray.array[indexPath.row];
  [cell bindStockTradeDetailData:detailData
                  lastClosePrice:self.lastClosePrice
                     priceFormat:self.priceFormat]; //昨收价

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
  titleLabel.text = @"时间   成交价   成交量";
  titleLabel.textAlignment = NSTextAlignmentCenter;
  titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
  titleLabel.font = [UIFont systemFontOfSize:Font_Height_10_0];
  titleLabel.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  return titleLabel;
}

@end

/*
 *  交易明细
 */

@implementation StockDetailTableViewController {
  TimerUtil *_timer;
}

- (void)dealloc {
  [_timer stopTimer];
}

- (id)initWithFrame:(CGRect)frame
 withSecuritiesInfo:(SecuritiesInfo *)securitiesInfo {
  if (self = [super initWithFrame:frame]) {
    self.securitiesInfo = securitiesInfo;
    __weak StockDetailTableViewController *weakSelf = self;
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
  [StockTradeDetailInfo
      getStockTradeDetailWithStockCode:_securitiesInfo.securitiesCode()
                          withCallback:callback];
}

- (BOOL)supportAutoLoadMore {
  return YES;
}

/** 返回表格数据适配器，此方法子类必须实现 */
- (BaseTableAdapter *)getBaseTableAdaperWithDataList:(DataArray *)dataList {
  if (_tableAdapter == nil) {
    _tableAdapter = [[StockDetailTableAdapter alloc]
        initWithTableViewController:self
                      withDataArray:self.dataArray];
    ((StockDetailTableAdapter *)_tableAdapter).securitiesInfo =
        self.securitiesInfo;
    UINib *cellNib = [UINib nibWithNibName:_tableAdapter.nibName bundle:nil];
    [self.tableView registerNib:cellNib
         forCellReuseIdentifier:_tableAdapter.nibName];
  }
  return _tableAdapter;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.littleCattleView = nil;
  self.tableView.bounces = NO;
  [self.tableView addWidth:5];
  self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(15, 0, 0, 0);
}

- (void)bindRequestObject:(NSObject<Collectionable> *)latestData
    withRequestParameters:(NSDictionary *)parameters
          withRefreshType:(RefreshType)refreshType {
  [super bindRequestObject:latestData
      withRequestParameters:parameters
            withRefreshType:refreshType];
  self.dataArray.dataComplete = YES;
  self.footerView.hidden = YES;
  self.headerView.hidden = YES;
}

@end
