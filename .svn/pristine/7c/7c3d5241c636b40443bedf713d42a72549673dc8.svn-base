//
//  WithdrawDetailViewController.m
//  SimuStock
//
//  Created by Mac on 15/4/29.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "WithdrawDetailViewController.h"
#import "WFAccountInterface.h"
#import "WithdrawDetailCell.h"
#import "ProcessInputData.h"

@implementation WithdrawDetailTableAdapter
- (NSString *)nibName {
  static NSString *nibFileName;
  if (nibFileName == nil) {
    nibFileName = NSStringFromClass([WithdrawDetailCell class]);
  }
  return nibFileName;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {

  return [self.dataArray.array count];
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 57;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  WithdrawDetailCell *cell =
      [tableView dequeueReusableCellWithIdentifier:self.nibName];
  WFWithdrawDetailInfo *wfdetailinfo =
      [self.dataArray.array objectAtIndex:indexPath.row];
  NSString *dateStr =
      [SimuUtil getFullDateFromCtime:wfdetailinfo.withdrawDatetime];
  /// 注意这里一定要先去除天的0再去除月的0
  if ([[dateStr substringWithRange:NSMakeRange(8, 1)] isEqualToString:@"0"]) {
    dateStr = [dateStr stringByReplacingCharactersInRange:NSMakeRange(8, 1)
                                               withString:@""];
  }
  if ([[dateStr substringWithRange:NSMakeRange(5, 1)] isEqualToString:@"0"]) {
    dateStr = [dateStr stringByReplacingCharactersInRange:NSMakeRange(5, 1)
                                               withString:@""];
  }
  cell.withdrawDatetime.text = dateStr;
  cell.withdrawAmount.text = [NSString
      stringWithFormat:@"%@元",
                       [ProcessInputData
                           convertMoneyString:wfdetailinfo.withdrawAmount]];
  cell.withdrawStatus.text = wfdetailinfo.withdrawStatus;
  cell.userInteractionEnabled = NO;
  return cell;
}

@end

@implementation WithdrawDetailTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.littleCattleView setInformation:@"暂无提现明细"];
}

- (NSDictionary *)getRequestParamertsWithRefreshType:(RefreshType)refreshType {
  NSString *fromId = @"0";
  NSString *pageSize = @"20";
  if (refreshType == RefreshTypeLoaderMore) {
    WFWithdrawDetailInfo *lastInfo =
        (WFWithdrawDetailInfo *)[self.dataArray.array lastObject];
    fromId = [NSString stringWithFormat:@"%d", lastInfo.NumberId];
  }
  return @{ @"fromId" : fromId, @"pageSize" : pageSize };
}

/** 判断返回数据是否非法，此方法子类必须实现 */
- (BOOL)isDataValidWithResponseObject:(NSObject<Collectionable> *)latestData
                withRequestParameters:(NSDictionary *)parameters
                      withRefreshType:(RefreshType)refreshType {
  if (refreshType == RefreshTypeLoaderMore) {
    NSString *fromId = parameters[@"fromId"];
    WFWithdrawDetailInfo *lastInfo =
        (WFWithdrawDetailInfo *)[self.dataArray.array lastObject];
    NSString *lastId = [NSString stringWithFormat:@"%d", lastInfo.NumberId];
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
  [WFAccountInterface
      getWFWithdrawWithInput:[self
                                 getRequestParamertsWithRefreshType:refreshType]
                withCallback:callback];
}

- (BOOL)supportAutoLoadMore {
  return YES;
}

/** 返回表格数据适配器，此方法子类必须实现 */
- (BaseTableAdapter *)getBaseTableAdaperWithDataList:(DataArray *)dataList {
  if (_tableAdapter == nil) {
    _tableAdapter = [[WithdrawDetailTableAdapter alloc]
        initWithTableViewController:self
                      withDataArray:self.dataArray];
    UINib *cellNib = [UINib nibWithNibName:_tableAdapter.nibName bundle:nil];
    [self.tableView registerNib:cellNib
         forCellReuseIdentifier:_tableAdapter.nibName];
  }
  return _tableAdapter;
}

- (void)refreshButtonPressDown {
  [self requestResponseWithRefreshType:RefreshTypeRefresh];
}

@end

@implementation WithdrawDetailViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.topToolBar resetContentAndFlage:@"提现明细" Mode:TTBM_Mode_Sideslip];

  //数据
  CGRect frame = CGRectMake(0, 0, CGRectGetWidth(_clientView.bounds),
                            CGRectGetHeight(_clientView.bounds));
  tableVC = [[WithdrawDetailTableViewController alloc] initWithFrame:frame];

  __weak WithdrawDetailViewController *weakSelf = self;
  tableVC.showTableFooter = YES;
  tableVC.beginRefreshCallBack = ^{
    [weakSelf.indicatorView startAnimating];
  };

  tableVC.endRefreshCallBack = ^{
    [weakSelf.indicatorView stopAnimating];
  };

  [_clientView addSubview:tableVC.view];
  [self addChildViewController:tableVC];
  [self refreshButtonPressDown];
}

#pragma mark - 刷新按钮代理方法
- (void)refreshButtonPressDown {
  [tableVC refreshButtonPressDown];
}

@end