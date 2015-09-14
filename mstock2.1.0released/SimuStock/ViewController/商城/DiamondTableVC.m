//
//  DiamondTableVC.m
//  SimuStock
//
//  Created by Mac on 15/8/1.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "DiamondTableVC.h"
#import "CacheUtil.h"

@implementation DiamondTableAdapter

- (NSString *)nibName {
  static NSString *nibFileName;
  if (nibFileName == nil) {
    nibFileName = NSStringFromClass([DiamondRechargeCell class]);
  }
  return nibFileName;
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 52.5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  DiamondRechargeCell *cell =
  [tableView dequeueReusableCellWithIdentifier:self.nibName];
  cell.delegate =
  ((DiamondTableVC *)self.baseTableViewController).propBuyDelegate;
  
  TrackCardInfo *Item = self.dataArray.array[indexPath.row];
  [cell setCellData:Item];

  return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

@end

@implementation DiamondTableVC

/** 请求最新数据，此方法子类必须实现 */
- (void)requestDataListWithRefreshType:(RefreshType)refreshType
                         withDataArray:(DataArray *)existDataList
                          withCallBack:(HttpRequestCallBack *)callback {
  //先读取缓存
  if (!self.dataBinded) {
    DiamondList *diamondList = [CacheUtil loadDiamondList];
    if (diamondList && diamondList.dataArray.count > 0) {
      [self bindRequestObject:diamondList
          withRequestParameters:@{
            @"saveToCache" : @NO
          } withRefreshType:RefreshTypeRefresh];
    }
  }
  [DiamondList requestDiamondListWithCallback:callback];
}



- (BOOL)supportAutoLoadMore {
  return NO;
}

/** 返回表格数据适配器，此方法子类必须实现 */
- (BaseTableAdapter *)getBaseTableAdaperWithDataList:(DataArray *)dataList {
  if (_tableAdapter == nil) {
    _tableAdapter = [[DiamondTableAdapter alloc]
        initWithTableViewController:self
                      withDataArray:self.dataArray];
    UINib *cellNib = [UINib nibWithNibName:_tableAdapter.nibName bundle:nil];
    [self.tableView registerNib:cellNib
         forCellReuseIdentifier:_tableAdapter.nibName];
  }
  return _tableAdapter;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.littleCattleView setInformation:@"暂无数据"];
}

- (void)bindRequestObject:(NSObject<Collectionable> *)latestData
    withRequestParameters:(NSDictionary *)parameters
          withRefreshType:(RefreshType)refreshType {
  if (parameters == nil) {
    [CacheUtil saveDiamondList:(DiamondList *)latestData];
  }
  [super bindRequestObject:latestData
      withRequestParameters:parameters
            withRefreshType:refreshType];
  self.dataArray.dataComplete = YES;
  self.footerView.hidden = YES;
  self.headerView.hidden = YES;
}

@end