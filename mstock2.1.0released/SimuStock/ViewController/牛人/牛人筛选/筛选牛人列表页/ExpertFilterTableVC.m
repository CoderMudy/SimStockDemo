//
//  ExpertFilterViewController.m
//  SimuStock
//
//  Created by jhss on 15/8/31.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "ExpertFilterTableVC.h"
#import "ExpertFilterTableViewCell.h"
#import "ExpertFilterListWrapper.h"

@implementation ExpertFilterTableAdapter

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([self.cellSelected containsObject:indexPath]) {
    return EFTableViewCellUnFoldHeight;
  } else {
    return EFTableViewCellFoldHeight;
  }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  ExpertFilterTableViewCell *cell = (ExpertFilterTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
  [tableView beginUpdates];
  if ([self.cellSelected containsObject:indexPath]) {
    [cell cellFold:YES];
    [self.cellSelected removeObject:indexPath];
  } else {
    [cell cellFold:NO];
    [self.cellSelected addObject:indexPath];
  }
  [tableView endUpdates];
  return;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  static NSString *ideCell = @"ExpertFilterTableViewCell";
  ExpertFilterTableViewCell *cell =
      (ExpertFilterTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ideCell];
  cell.selectionStyle = UITableViewCellSelectionStyleNone;

  ExpertFilterListItem *item = self.dataArray.array[indexPath.row];

  [cell bindExpertFilterItem:item
                 withSortNum:@(indexPath.row + 1)
                withSelected:[self.cellSelected containsObject:indexPath]];

  return cell;
}
@end

@implementation ExpertFilterTableVC

/** 请求最新数据，此方法子类必须实现 */
- (void)requestDataListWithRefreshType:(RefreshType)refreshType
                         withDataArray:(DataArray *)existDataList
                          withCallBack:(HttpRequestCallBack *)callback {

  [ExpertFilterListWrapper requestExpertFilterListWithInput:[self getRequestParamertsWithRefreshType:refreshType]
                                               withCallback:callback];
}

- (NSDictionary *)getRequestParamertsWithRefreshType:(RefreshType)refreshType {
  NSString *pageStart = @"0";
  NSString *pageSize = @"20";
  if (refreshType == RefreshTypeLoaderMore) {
    ExpertFilterListItem *lastInfo = (ExpertFilterListItem *)[self.dataArray.array lastObject];

    pageStart = [@(lastInfo.seqId) stringValue];
  }

  NSDictionary *filterConditionDic = @{
    @"maxBackRate" : [@(self.conditions.condiMaxBackRate) stringValue],
    @"backRate" : [@(self.conditions.condiBackRate) stringValue],
    @"winRate" : [@(self.conditions.condiWinRate) stringValue],
    @"annualProfit" : [@(self.conditions.condiAnnualProfit) stringValue],
    @"monthAvgProfitRate" : [@(self.conditions.monthAvgProfitRate) stringValue],
    @"profitDaysRate" : [@(self.conditions.condiProfitDaysRate) stringValue],
    @"sucRate" : [@(self.conditions.condiSucRate) stringValue],
    @"avgDays" : [@(self.conditions.condiAvgDays) stringValue],
    @"closeNum" : [@(self.conditions.condiCloseNum) stringValue],
    @"pageStart" : pageStart,
    @"pageSize" : pageSize
  };

  return filterConditionDic;
}

/** 判断返回数据是否非法，此方法子类必须实现 */
- (BOOL)isDataValidWithResponseObject:(NSObject<Collectionable> *)latestData
                withRequestParameters:(NSDictionary *)parameters
                      withRefreshType:(RefreshType)refreshType {
  if (refreshType == RefreshTypeLoaderMore) {
    NSString *fromId = parameters[@"pageStart"];
    ExpertFilterListItem *lastInfo = (ExpertFilterListItem *)[self.dataArray.array lastObject];
    NSString *lastId = [@(lastInfo.seqId) stringValue];
    if (![fromId isEqualToString:lastId]) {
      return NO;
    }
  }
  return YES;
}

/** 返回表格数据适配器，此方法子类必须实现 */
- (BaseTableAdapter *)getBaseTableAdaperWithDataList:(DataArray *)dataList {
  if (_expertPlanAdapter == nil) {
    _expertPlanAdapter = [[ExpertFilterTableAdapter alloc] initWithTableViewController:self
                                                                         withDataArray:self.dataArray];
    //注册复用Cell
    UINib *cellNib =
        [UINib nibWithNibName:NSStringFromClass([ExpertFilterTableViewCell class]) bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"ExpertFilterTableViewCell"];
  }
  return _expertPlanAdapter;
}

#pragma mark
#pragma mark------菊花控件-------
- (void)refreshButtonPressDown {
  _expertPlanAdapter.cellSelected = [NSMutableArray array];
  [self requestResponseWithRefreshType:RefreshTypeRefresh];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.littleCattleView setInformation:@"未找到满足该条件的牛人"];
  [self.littleCattleView resetCryInformationFrame];
}

- (id)initWithFrame:(CGRect)frame withExpertFilterCondition:(ExpertFilterCondition *)conditions {
  if (self = [super initWithFrame:frame]) {
    self.conditions = conditions;
  }
  return self;
}

@end
