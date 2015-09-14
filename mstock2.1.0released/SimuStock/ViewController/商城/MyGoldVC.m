//
//  MyGoldVC.m
//  SimuStock
//
//  Created by jhss on 15/5/11.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "MyGoldVC.h"
#import "MyGoldTableViewCell.h"

@implementation MyGoldTableAdapter
- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  TaskListItem *item = self.dataArray.array[indexPath.row];
  if ([item.taskId isEqualToString:TASK_SHARE] ||
      [item.taskId isEqualToString:TASK_REAL_TRADE_SHOW_OFF] ||
      [item.taskId isEqualToString:TASK_SHOW_ENTRUST] ||
      [item.taskId isEqualToString:TASK_DELETE_BY_ADMIN]) {
    return 75;
  }
  return 61;
}
- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
  return;
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  static NSString *ideCell = @"MyGoldCell";
  MyGoldTableViewCell *cell = (MyGoldTableViewCell *)
      [tableView dequeueReusableCellWithIdentifier:ideCell];
  if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:@"MyGoldTableViewCell"
                                          owner:self
                                        options:nil] firstObject];
  }
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  cell.descriptionLab.hidden = NO;
  cell.specialLabel.hidden = YES;
  TaskListItem *item = self.dataArray.array[indexPath.row];
  [cell bindTaskListItem:item];

  __weak MyGoldTableAdapter *weakSelf = self;
  cell.buttonClickCallBack = ^(GetGoldWrapper *getGold) {
    [weakSelf getBalanceNumValue:getGold];
  };
  if (indexPath.row == self.dataArray.array.count - 1) {
    cell.separatorLine.hidden = YES;
  } else {
    cell.separatorLine.hidden = NO;
  }
  return cell;
}

- (void)getBalanceNumValue:(GetGoldWrapper *)getGold {
  self.refreshBlock(getGold);
}
@end

@implementation MyGoldVC

- (void)viewDidLoad {
  [super viewDidLoad];
  if (!myGoldTopVC) {
    myGoldTopVC =
        [[MyGoldTopVC alloc] initWithNibName:@"MyGoldTopVC" bundle:nil];
  }
  self.tableView.tableHeaderView = myGoldTopVC.view;
  [self initUI];
  [self refreshButtonPressDown];
}

- (BOOL)supportAutoLoadMore {
  return NO;
}

- (void)initUI {
  self.headerView.hidden = NO;
  self.footerView.hidden = YES;
}

/** 请求最新数据，此方法子类必须实现 */
- (void)requestDataListWithRefreshType:(RefreshType)refreshType
                         withDataArray:(DataArray *)existDataList
                          withCallBack:(HttpRequestCallBack *)callback {
  [MyGoldListWrapper requestmyTaskListWithCallback:callback];
}

- (void)bindRequestObject:(NSObject<Collectionable> *)latestData
    withRequestParameters:(NSDictionary *)parameters
          withRefreshType:(RefreshType)refreshType {
  [super bindRequestObject:latestData
      withRequestParameters:parameters
            withRefreshType:refreshType];

  self.dataArray.dataComplete = YES;
  self.footerView.hidden = YES;
  if (refreshType == RefreshTypeLoaderMore) {
    [NewShowLabel setMessageContent:@"暂无更多数据"];
  }
  data = (MyGoldListWrapper *)latestData;
  myGoldTopVC.balanceNumLab.text = [data.balanceNum stringValue];
  myGoldTopVC.goldNumLab.text =
      [NSString stringWithFormat:@"%@金币", [data.tomorrowNum stringValue]];

  switch ([data.arrowDay integerValue]) {
  case 1:
    myGoldTopVC.arrow1ImaView.hidden = NO;
    break;
  case 2:
    myGoldTopVC.arrow2ImageView.hidden = NO;
    break;
  case 3:
    myGoldTopVC.arrow3ImageView.hidden = NO;
    break;
  case 4:
    myGoldTopVC.arrow4ImageView.hidden = NO;
    break;
  case 5:
    myGoldTopVC.arrow5ImageView.hidden = NO;
    break;
  default:
    break;
  }
  [self.tableView reloadData];
}

- (NSDictionary *)requestParamertsWithRefreshType:(RefreshType)refreshType {
  return nil;
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
    _tableAdapter =
        [[MyGoldTableAdapter alloc] initWithTableViewController:self
                                                  withDataArray:self.dataArray];
    tableView = (MyGoldTableAdapter *)_tableAdapter;
    __weak MyGoldVC *weakSelf = self;
    tableView.refreshBlock = ^(GetGoldWrapper *getgold) {
      [weakSelf getBalanceNumber:getgold];
    };
  }
  return _tableAdapter;
}

- (void)getBalanceNumber:(GetGoldWrapper *)getGold {
  myGoldTopVC.balanceNumLab.text = [getGold.balance stringValue];
}

#pragma mark
#pragma mark------菊花控件-------
- (void)refreshButtonPressDown {
  [self requestResponseWithRefreshType:RefreshTypeRefresh];
}
@end
