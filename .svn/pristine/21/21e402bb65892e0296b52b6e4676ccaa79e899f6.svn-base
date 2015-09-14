//
//  SelfAddStockGroupVC.m
//  SimuStock
//
//  Created by jhss on 15/6/18.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SelfGroupsTableViewController.h"
#import "NewGroupsTableViewCell.h"
#import "PortfolioStockModel.h"
#import "RemoveSelfGroupData.h"
#import "NetLoadingWaitView.h"
#import "EditStockTip.h"

@implementation SelfGroupsTableAdapter

- (id)initWithTableViewController:
          (BaseTableViewController *)baseTableViewController
                    withDataArray:(DataArray *)dataList {
  self = [super initWithTableViewController:baseTableViewController
                              withDataArray:dataList];
  if (self) {
    self.dataArray = [[DataArray alloc] init];
  }

  return self;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  return [self.dataArray.array count]; //加上分界线
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 50;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
  return;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  static NSString *ideCell = @"NewGroupsTableViewCell";
  NewGroupsTableViewCell *cell = (NewGroupsTableViewCell *)
      [tableView dequeueReusableCellWithIdentifier:ideCell];
  if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:@"NewGroupsTableViewCell"
                                          owner:self
                                        options:nil] firstObject];
  }
  QuerySelfStockElement *element =
      (QuerySelfStockElement *)self.dataArray.array[indexPath.row];
  cell.groupNameLabel.text = element.groupName;
  cell.groupId = element.groupId;
  return cell;
}

//移动cell时的操作
- (void)tableView:(UITableView *)tableView
    moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
           toIndexPath:(NSIndexPath *)destinationIndexPath {

  if (sourceIndexPath != destinationIndexPath) {

    //⭐️本地化存储排序
    QuerySelfStockElement *copyGroup =
        self.dataArray.array[sourceIndexPath.row];
    QuerySelfStockData *data =
        [PortfolioStockManager currentPortfolioStockModel].local;
    [data.dataArray removeObject:copyGroup];
    [data.dataArray insertObject:copyGroup
                         atIndex:destinationIndexPath.row + 1];
    [[PortfolioStockManager currentPortfolioStockModel] save];

    //列表数据变更
    id object = [self.dataArray.array objectAtIndex:sourceIndexPath.row];
    [self.dataArray.array removeObjectAtIndex:sourceIndexPath.row];
    if (destinationIndexPath.row > [self.dataArray.array count]) {
      [self.dataArray.array addObject:object];
    } else {
      [self.dataArray.array insertObject:object
                                 atIndex:destinationIndexPath.row];
    }
  }
}

//继承该方法时,左右滑动会出现删除按钮(自定义按钮),点击按钮时的操作
- (void)tableView:(UITableView *)tableView
    commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
     forRowAtIndexPath:(NSIndexPath *)indexPath {
  //弹出提示框
  [EditStockTip
      showEditStockTipWithContent:@"将"
                                  @"会删除该分组中的股票，不会影响其他列表，确"
                                  @"认删除？"
                  andSureCallBack:^{
                    [NetLoadingWaitView startAnimating];
                    [self doDeleteGroupRequest:
                              [(QuerySelfStockElement *)self.dataArray
                                      .array[indexPath.row] groupId]];
                    [self.dataArray.array removeObjectAtIndex:indexPath.row];
                    NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
                    [tableView
                        deleteRowsAtIndexPaths:indexPaths
                              withRowAnimation:UITableViewRowAnimationFade];
                  }];
}

///删除分组请求
- (void)doDeleteGroupRequest:(NSString *)groupId {

  if (![SimuUtil isExistNetwork]) {

    [NetLoadingWaitView stopAnimating];
    [NewShowLabel showNoNetworkTip];
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];

  callback.onCheckQuitOrStopProgressBar = ^{
    if ([NetLoadingWaitView isAnimating]) {
      [NetLoadingWaitView stopAnimating];
    }
    return NO;
  };

  __weak SelfGroupsTableAdapter *weakSelf = self;
  callback.onSuccess = ^(NSObject *obj) {
    SelfGroupsTableAdapter *strongSelf = weakSelf;
    if (strongSelf) {
      if ([[(JsonRequestObject *)obj status] isEqualToString:@"0000"]) {
        NSMutableArray *deleArray =
            [PortfolioStockManager currentPortfolioStockModel].local.dataArray;
        [deleArray enumerateObjectsUsingBlock:^(QuerySelfStockElement *element,
                                                NSUInteger idx, BOOL *stop) {
          if ([element.groupId isEqualToString:groupId]) {
            NSLog(@"删除分组成功！%@", groupId);
            //如果删除的分组正好是当前用户选中的，则恢复成“全部”
            if ([element.groupId
                    isEqualToString:[SimuUtil currentSelectedSelfGroupID]]) {
              [SimuUtil saveCurrentSelectedSelfGroupID:GROUP_ALL_ID];
            }
            [[PortfolioStockManager currentPortfolioStockModel]
                    .local.dataArray removeObject:element];
            [[PortfolioStockManager currentPortfolioStockModel] save];
            *stop = YES;
          }
        }];
      }
    }
  };

  [RemoveSelfGroupData requestSelfStockGroupListDataWithGroupId:groupId
                                                       callback:callback];
}

@end

@implementation SelfGroupsTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  if (!selfAddStockGroupTopVC) {
    selfAddStockGroupTopVC = [[SelfAddStockGroupTopVC alloc]
        initWithNibName:@"SelfAddStockGroupTopVC"
                 bundle:nil];
    selfAddStockGrouoFooterVC = [[SelfAddStockGroupFooterVC alloc]
        initWithNibName:@"SelfAddStockGroupFooterVC"
                 bundle:nil];
  }
  self.tableView.tableHeaderView = selfAddStockGroupTopVC.view;
  self.tableView.tableFooterView = selfAddStockGrouoFooterVC.view;
  [self.tableView setEditing:YES animated:NO];
  self.tableView.scrollEnabled = NO;
  self.headerView.hidden = NO;
  self.footerView.hidden = YES;
  [self refreshButtonPressDown];
}

- (void)reloadLocalSelfGroupData {
  NSMutableArray *tempArray =
      [[PortfolioStockManager currentPortfolioStockModel]
              .local.dataArray mutableCopy];
  [tempArray enumerateObjectsUsingBlock:^(QuerySelfStockElement *element,
                                          NSUInteger idx, BOOL *stop) {
    if ([element.groupId isEqualToString:GROUP_ALL_ID]) {
      [tempArray removeObject:element];
      *stop = YES;
    };
  }];
  _tableAdapter.dataArray.array = tempArray;
  [self.tableView reloadData];
}

- (BOOL)supportAutoLoadMore {
  return NO;
}

/** 请求最新数据，此方法子类必须实现 */
- (void)requestDataListWithRefreshType:(RefreshType)refreshType
                         withDataArray:(DataArray *)existDataList
                          withCallBack:(HttpRequestCallBack *)callback {
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
    _tableAdapter = [[SelfGroupsTableAdapter alloc]
        initWithTableViewController:self
                      withDataArray:self.dataArray];
  }
  return _tableAdapter;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self reloadLocalSelfGroupData];
}

@end
