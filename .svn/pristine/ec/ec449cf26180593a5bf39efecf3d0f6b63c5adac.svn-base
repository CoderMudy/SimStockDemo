//
//  StockMasterTradingViewController.m
//  SimuStock
//
//  Created by jhss on 15-4-28.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "StockMasterTradingViewController.h"
#import "FollowBuyClientVC.h"
#import "MasterTradeListWrapper.h"
#import "HomepageViewController.h"
#import "MasterTradingTableViewCell.h"

@implementation StockMasterTradeTableAdapter

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 179;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
  ConcludesListItem *item = self.dataArray.array[indexPath.row];
  if (item.writer.userId)
    [HomepageViewController showWithUserId:[item.writer.userId stringValue]
                                 titleName:item.writer.nickName
                                   matchId:MATCHID];
  return;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  static NSString *ideCell = @"MasterTradingTableViewCell";
  MasterTradingTableViewCell *cell = (MasterTradingTableViewCell *)
      [tableView dequeueReusableCellWithIdentifier:ideCell];
  cell.selectionStyle = UITableViewCellSelectionStyleNone;

  ConcludesListItem *item = self.dataArray.array[indexPath.row];

  [cell bindConcludesListItem:item];

  return cell;
}

@end

@implementation StockMasterTradingViewController

/** 请求最新数据，此方法子类必须实现 */
- (void)requestDataListWithRefreshType:(RefreshType)refreshType
                         withDataArray:(DataArray *)existDataList
                          withCallBack:(HttpRequestCallBack *)callback {

  [MasterTradeListWrapper
      requestMasterTradeListWithInput:
          [self getRequestParamertsWithRefreshType:refreshType]
                         withCallback:callback];
}

- (NSDictionary *)getRequestParamertsWithRefreshType:(RefreshType)refreshType {
  NSString *start = @"0";
  NSString *reqnum = @"-20";
  //诡异的接口设计，取最新的20条为（0，-20）
  if (refreshType == RefreshTypeLoaderMore) {
    start = [((ConcludesListItem *)[self.dataArray.array lastObject])
                 .time stringValue];
    reqnum = @"20";
  }
  return @{ @"from" : start, @"reqNum" : reqnum };
}

/** 判断返回数据是否非法，此方法子类必须实现 */
- (BOOL)isDataValidWithResponseObject:(NSObject<Collectionable> *)latestData
                withRequestParameters:(NSDictionary *)parameters
                      withRefreshType:(RefreshType)refreshType {
  if (refreshType == RefreshTypeLoaderMore) {
    NSString *fromId = parameters[@"from"];
    NSString *lastId = [((ConcludesListItem *)[self.dataArray.array lastObject])
                            .time stringValue];
    if (![fromId isEqualToString:lastId]) {
      return NO;
    }
  }
  return YES;
}

/** 返回表格数据适配器，此方法子类必须实现 */
- (BaseTableAdapter *)getBaseTableAdaperWithDataList:(DataArray *)dataList {
  if (_tableAdapter == nil) {
    _tableAdapter = [[StockMasterTradeTableAdapter alloc]
        initWithTableViewController:self
                      withDataArray:self.dataArray];
    //注册复用Cell
    UINib *cellNib = [UINib
        nibWithNibName:NSStringFromClass([MasterTradingTableViewCell class])
                bundle:nil];
    [self.tableView registerNib:cellNib
         forCellReuseIdentifier:@"MasterTradingTableViewCell"];
  }
  return _tableAdapter;
}

#pragma mark
#pragma mark------菊花控件-------
- (void)refreshButtonPressDown {
  [self requestResponseWithRefreshType:RefreshTypeRefresh];
}
- (void)viewDidLoad {
  [super viewDidLoad];
  [self.littleCattleView setInformation:@"暂无数据"];
}

@end
