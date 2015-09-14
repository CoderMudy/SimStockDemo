//
//  HotRunViewController.m
//  SimuStock
//
//  Created by Jhss on 15/6/30.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "HotRunViewController.h"
#import "HotRunInfoItem.h"
#import "HotRunViewCell.h"
#import "CacheUtil.h"
#import "EPPexpertPlanViewController.h"

@implementation HotRunTableAdapter

- (NSString *)nibName {
  static NSString *nibFileName;
  if (nibFileName == nil) {
    nibFileName = NSStringFromClass([HotRunViewCell class]);
  }
  return nibFileName;
}
- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 109.0f;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.dataArray.array == nil ||
      [self.dataArray.array count] <= indexPath.row)
    return;
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
  //切换详情页
  HotRunInfoItem *item = self.dataArray.array[indexPath.row];
  EPPexpertPlanViewController *vc =
      [[EPPexpertPlanViewController alloc] initAccountId:item.accountId
                                           withTargetUid:item.uid
                                           withTitleName:item.name];
  [AppDelegate pushViewControllerFromRight:vc];
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  HotRunViewCell *cell = (HotRunViewCell *)
      [tableView dequeueReusableCellWithIdentifier:self.nibName];
  // set选中效果
  UIView *backView = [[UIView alloc] initWithFrame:cell.frame];
  backView.backgroundColor = [Globle colorFromHexRGB:@"#9be5f2"];
  cell.selectedBackgroundView = backView;
  HotRunInfoItem *item = self.dataArray.array[indexPath.row];
  [cell bindHotRunPlanCellData:item];
  return cell;
}

@end

@implementation HotRunViewController {
  NSInteger start;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.littleCattleView setInformation:@"暂无运行列表信息"];
  [self.littleCattleView
      resetFrame:CGRectMake(0, 0, self.view.size.width, 200)];
}

/** 将入参封装成一个dic， */
- (NSDictionary *)getRequestParamertsWithRefreshType:(RefreshType)refreshType {
  NSString *fromId = @"0";
  NSString *reqNum = @"20";
  if (refreshType == RefreshTypeLoaderMore) {
    fromId = [@(start + 20) stringValue];
    reqNum = [@(start + 40 - 1) stringValue];
  }
  NSDictionary *dic = @{
    @"fromId" : fromId,
    @"reqNum" : reqNum,
    @"saveToCache" : refreshType == RefreshTypeLoaderMore ? @0 : @1
  };
  return dic;
}
/** 判断返回数据是否有效 */
- (BOOL)isDataValidWithResponseObject:(NSObject<Collectionable> *)latestData
                withRequestParameters:(NSDictionary *)parameters
                      withRefreshType:(RefreshType)refreshType {
  if (refreshType == RefreshTypeLoaderMore) {
    NSString *fromId = parameters[@"fromId"];
    NSString *lastId = [@(start + 20) stringValue];
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
  [HotRunInfoDataRequest
      hotRunPlanListRequest:[self
                                getRequestParamertsWithRefreshType:refreshType]
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
    HotRunInfoDataRequest *hotRunData = (HotRunInfoDataRequest *)latestData;
    if ([parameters[@"saveToCache"] integerValue] == 1) {
      [CacheUtil saveHotRunList:hotRunData];
    }
    if (refreshType == RefreshTypeLoaderMore) {
      start += 20;
    } else {
      start = 0;
    }
  }
}
/** 返回表格数据适配器，此方法子类必须实现 */
- (BaseTableAdapter *)getBaseTableAdaperWithDataList:(DataArray *)dataList {
  if (_tableAdapter == nil) {
    _tableAdapter =
        [[HotRunTableAdapter alloc] initWithTableViewController:self
                                                  withDataArray:self.dataArray];
    UINib *cellNib = [UINib nibWithNibName:_tableAdapter.nibName bundle:nil];
    [self.tableView registerNib:cellNib
         forCellReuseIdentifier:_tableAdapter.nibName];
  }
  return _tableAdapter;
}

#pragma mark
- (void)refreshButtonPressDown {
  [self requestResponseWithRefreshType:RefreshTypeRefresh];
}

- (void)requestResponseWithRefreshType:(RefreshType)refreshType {
  if (!self.dataArray.dataBinded) {
    if (refreshType != RefreshTypeLoaderMore) {
      HotRunInfoDataRequest *hotRunList = [CacheUtil loadHotRunList];
      if (hotRunList) {
        [self bindRequestObject:hotRunList
            withRequestParameters:@{
              @"saveToCache" : @0
            } withRefreshType:RefreshTypeRefresh];
      }
    }
  }
  [super requestResponseWithRefreshType:refreshType];
  //下拉刷新时刷新表头
  if (refreshType == RefreshTypeHeaderRefresh) {
    if (_headerRefreshCallBack) {
      _headerRefreshCallBack();
    }
  }
}

@end
