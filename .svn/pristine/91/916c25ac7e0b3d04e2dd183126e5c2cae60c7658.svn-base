//
//  StockPriceRemindTableVC.m
//  SimuStock
//
//  Created by jhss on 15/7/8.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "StockPriceRemindTableVC.h"
///将预警推送保存在coredata数据库中
#import "StockWarningController.h"
#import "StockAlarmData.h"
#import "TrendViewController.h"

static const NSInteger REQ_NUM = 20;

@implementation StockPriceRemindTableAdapter : BaseTableAdapter

- (NSString *)nibName {
  static NSString *nibFileName;
  if (nibFileName == nil) {
    nibFileName = NSStringFromClass([StockAlarmTableViewCell class]);
  }
  return nibFileName;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  StockAlarmEntity *itemMessageData = self.dataArray.array[indexPath.row];
  return [StockAlarmTableViewCell cellHeightWithStockAlarmMessage:itemMessageData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
  StockAlarmEntity *itemMessageData = self.dataArray.array[indexPath.row];
  [FullScreenLogonViewController checkLoginStatusWithCallBack:^(BOOL isLogined) {
    [TrendViewController showDetailWithStockCode:itemMessageData.stockcode
                                   withStockName:itemMessageData.stockname
                                   withFirstType:[itemMessageData.firstType stringValue]
                                     withMatchId:@"1"];
  }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  StockAlarmTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.nibName];
  StockAlarmEntity *itemMessageData = self.dataArray.array[indexPath.row];
  [cell bindStockAlarmMessage:itemMessageData];
  [cell.topSplitView resetViewWidth:tableView.width];
  return cell;
}

@end

@implementation StockPriceRemindTableVC

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.littleCattleView setInformation:@"您暂时没有股票提醒消息"];
  self.headerView.hidden = YES;
  self.footerView.hidden = YES;
  [self refreshButtonPressDown];
}

- (void)clearStockAlarmData {
  [[StockWarningController sharedManager] deleteWithruid:[SimuUtil getUserID]];
  [self.dataArray reset];
  [self.tableView reloadData];
}

- (BOOL)supportAutoLoadMore {
  return NO;
}

/** 请求最新数据，此方法子类必须实现 */
- (void)requestDataListWithRefreshType:(RefreshType)refreshType
                         withDataArray:(DataArray *)existDataList
                          withCallBack:(HttpRequestCallBack *)callback {
  NSArray *array = [[NSArray alloc] init];
  if (refreshType == RefreshTypeLoaderMore) {
    StockAlarmEntity *closedInfo = (StockAlarmEntity *)[self.dataArray.array lastObject];
    NSDate *nextPageFromId = closedInfo.ctime;
    array = [[StockWarningController sharedManager] getStockAlarmsWithStartDate:nextPageFromId
                                                                  withReqestNum:REQ_NUM];
  } else {
    array = [[StockWarningController sharedManager] getStockAlarmsWithStartDate:nil
                                                                  withReqestNum:REQ_NUM];
    if ([array count] > 0) {
      self.clearBtnDisplay();
    } else {
      self.clearBtnHidden();
    }
  }
  StockAlarmData *list = [[StockAlarmData alloc] init];
  list.dataArray = array;

  __weak StockPriceRemindTableVC *weakSelf = self;
  [SimuUtil performBlockOnMainThread:^{
    [weakSelf endRefreshLoading];
    [weakSelf bindRequestObject:list withRequestParameters:nil withRefreshType:refreshType];
  } withDelaySeconds:0.5];
}

- (void)bindRequestObject:(NSObject<Collectionable> *)latestData
    withRequestParameters:(NSDictionary *)parameters
          withRefreshType:(RefreshType)refreshType {
  [super bindRequestObject:latestData withRequestParameters:parameters withRefreshType:refreshType];
  if (latestData.getArray.count == 0) {
    self.dataArray.dataComplete = YES;
  } else {
    self.dataArray.dataComplete = NO;
  }
}

/** 判断返回数据是否非法，此方法子类必须实现 */
- (BOOL)isDataValidWithResponseObject:(NSObject<Collectionable> *)latestData
                          withRequest:(NSDictionary *)parameters
                      withRefreshType:(RefreshType)refreshType {
  return YES;
}

/** 返回表格数据适配器，此方法子类必须实现 */
- (BaseTableAdapter *)getBaseTableAdaperWithDataList:(DataArray *)dataList {

  if (_tableAdapter == nil) {
    _tableAdapter = [[StockPriceRemindTableAdapter alloc] initWithTableViewController:self
                                                                        withDataArray:self.dataArray];
    UINib *cellNib = [UINib nibWithNibName:_tableAdapter.nibName bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:_tableAdapter.nibName];
  }
  return _tableAdapter;
}
- (void)refreshButtonPressDown {
  [self requestResponseWithRefreshType:RefreshTypeRefresh];
}
@end
