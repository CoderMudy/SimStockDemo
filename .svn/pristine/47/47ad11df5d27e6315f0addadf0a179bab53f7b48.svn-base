//
//  MyFansViewController.m
//  SimuStock
//
//  Created by Jhss on 15/6/19.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "MyFansViewController.h"
#import "HomepageViewController.h"

@implementation MyFansTableAdapter

- (NSString *)nibName {
  static NSString *nibFileName;
  if (nibFileName == nil) {
    nibFileName = NSStringFromClass([myAttentionsCell class]);
  }
  return nibFileName;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 61.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.dataArray.array == nil || [self.dataArray.array count] <= indexPath.row)
    return;
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
  //切换详情页
  MyAttentionInfoItem *item = self.dataArray.array[indexPath.row];
  [HomepageViewController showWithUserId:[item.userListItem.userId stringValue]
                               titleName:item.userListItem.nickName
                                 matchId:MATCHID];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  myAttentionsCell *cell = (myAttentionsCell *)[tableView dequeueReusableCellWithIdentifier:self.nibName];http://192.168.1.92/jira/issues/?filter=11706

  [cell.bottomSplitLineView resetViewWidth:tableView.width];

  MyAttentionInfoItem *item = self.dataArray.array[indexPath.row];
  [cell bindMyFansItem:item WithRowAtIndexPath:indexPath];

  cell.bottomSplitLineView.hidden = NO;
  if ((self.dataArray.array.count == (indexPath.row + 1)) && (self.dataArray.dataComplete)) {
    cell.bottomSplitLineView.hidden = YES;
  }

  return cell;
}

@end

@implementation MyFansTableViewController {
  NSInteger start;
}
/** 将入参封装成一个dic， */
- (NSDictionary *)getRequestParamertsWithRefreshType:(RefreshType)refreshType {
  NSString *startId = @"1";
  NSString *endId = @"20";
  if (refreshType == RefreshTypeLoaderMore) {
    startId = [@(start + 20) stringValue];
    endId = [@(start + 40 - 1) stringValue];
  }
  NSDictionary *dic = @{
    @"uid" : self.userId,
    @"startnum" : startId,
    @"endnum" : endId,
  };
  return dic;
}
/** 判断返回数据是否有效 */
- (BOOL)isDataValidWithResponseObject:(NSObject<Collectionable> *)latestData
                withRequestParameters:(NSDictionary *)parameters
                      withRefreshType:(RefreshType)refreshType {
  if (refreshType == RefreshTypeLoaderMore) {
    NSString *fromId = parameters[@"startnum"];
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
  [MyFansList requestFansWithParams:[self getRequestParamertsWithRefreshType:refreshType]
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
    if ([self.dataArray.array count] == 0) {
      //隐藏上下拉刷新
      self.footerView.hidden = YES;
      self.headerView.hidden = YES;
    }
    if (refreshType == RefreshTypeLoaderMore) {
      start += 20;
    } else {
      start = 1;
    }
  }
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.littleCattleView setInformation:@"暂无粉丝"];
}
/** 返回表格数据适配器，此方法子类必须实现 */
- (BaseTableAdapter *)getBaseTableAdaperWithDataList:(DataArray *)dataList {
  if (_tableAdapter == nil) {
    _tableAdapter =
        [[MyFansTableAdapter alloc] initWithTableViewController:self withDataArray:self.dataArray];
    UINib *cellNib = [UINib nibWithNibName:_tableAdapter.nibName bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:_tableAdapter.nibName];
  }
  return _tableAdapter;
}

@end

@implementation MyFansViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  //导航条
  if ([self.userID isEqualToString:[SimuUtil getUserID]]) {
    [_topToolBar resetContentAndFlage:@"我的粉丝" Mode:TTBM_Mode_Leveltwo];
  } else {
    [_topToolBar resetContentAndFlage:@"TA的粉丝" Mode:TTBM_Mode_Leveltwo];
  }
  /** 创建表格  */
  [self createMyFansTableView];
  [self refreshButtonPressDown];
}
- (void)createMyFansTableView {
  fansTableVC = [[MyFansTableViewController alloc] initWithFrame:_clientView.bounds];
  fansTableVC.userId = self.userID;
  __weak MyFansViewController *weakSelf = self;
  fansTableVC.showTableFooter = YES;
  fansTableVC.beginRefreshCallBack = ^{
    [weakSelf.indicatorView startAnimating];
    weakSelf.indicatorView.hidden = NO;
  };

  fansTableVC.endRefreshCallBack = ^{
    [weakSelf.indicatorView stopAnimating];
    weakSelf.indicatorView.hidden = YES;
  };

  [_clientView addSubview:fansTableVC.view];
  [self addChildViewController:fansTableVC];
}

#pragma mark - 刷新按钮代理方法
- (void)refreshButtonPressDown {
  [fansTableVC refreshButtonPressDown];
}

@end
