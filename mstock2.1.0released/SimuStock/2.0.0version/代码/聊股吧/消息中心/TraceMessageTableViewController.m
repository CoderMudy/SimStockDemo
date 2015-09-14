//
//  TraceMessageTableViewController.m
//  SimuStock
//
//  Created by jhss on 15/6/30.
//  Copyright (c) 2015年 Mac. All rights reserved.
//
#import "TraceMessageTableViewController.h"
#import "TraceMessageTableViewCell.h"
#import "EPPexpertPlanViewController.h"
static const int MessageViewWidth = 282;

@implementation TraceMessageTableAdapter : BaseTableAdapter

- (NSString *)nibName {
  static NSString *nibFileName;
  if (nibFileName == nil) {
    nibFileName = NSStringFromClass([TraceMessageTableViewCell class]);
  }
  return nibFileName;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  return [self.dataArray.array count];
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  TraceMsgData *message = self.dataArray.array[indexPath.row];
  if (!message.height) {
    int height =
        [TraceMessageTableViewCell cellHeightWithMessage:message
                                            withMsgWidth:MessageViewWidth
                                            withFontSize:Font_Height_14_0];
    message.height = @(height);
  }
  return [message.height intValue];
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [SimuUtil performBlockOnMainThread:^{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
  } withDelaySeconds:0.2f];

  TraceMsgData *message = self.dataArray.array[indexPath.row];

  if (!message) {
    return;
  }

  EPPexpertPlanViewController *masterPlanVC =
      [[EPPexpertPlanViewController alloc] initAccountId:message.accountId
                                           withTargetUid:message.superUid
                                           withTitleName:message.title];
  [AppDelegate pushViewControllerFromRight:masterPlanVC];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  TraceMessageTableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:self.nibName];
  cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
  cell.selectedBackgroundView.backgroundColor =
      [Globle colorFromHexRGB:@"#d9ecf2"];
  cell.backgroundColor = [Globle colorFromHexRGB:@"#f7f7f7"];
  TraceMsgData *traceMsgData = self.dataArray.array[indexPath.row];
  [cell bindTraceMessage:traceMsgData];
  return cell;
}

@end

@implementation TraceMessageTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.littleCattleView setInformation:@"您暂时没有消息"];
  [self refreshButtonPressDown];
}

- (BOOL)supportAutoLoadMore {
  return YES;
}

/** 请求最新数据，此方法子类必须实现 */
- (void)requestDataListWithRefreshType:(RefreshType)refreshType
                         withDataArray:(DataArray *)existDataList
                          withCallBack:(HttpRequestCallBack *)callback {
  [TraceMessageList requestTraceMessageListWithInput:
                        [self getRequestParamertsWithRefreshType:refreshType]
                                        withCallback:callback];
}

- (NSDictionary *)getRequestParamertsWithRefreshType:(RefreshType)refreshType {
  NSString *seq = @"0";
  NSString *limit = @"20";
  if (refreshType == RefreshTypeLoaderMore) {
    TraceMsgData *lastInfo = (TraceMsgData *)[self.dataArray.array lastObject];
    seq = [NSString stringWithFormat:@"%@", lastInfo.seq];
  }
  return @{ @"seq" : seq, @"limit" : limit };
}

- (void)bindRequestObject:(NSObject<Collectionable> *)latestData
    withRequestParameters:(NSDictionary *)parameters
          withRefreshType:(RefreshType)refreshType {
  [super bindRequestObject:latestData
      withRequestParameters:parameters
            withRefreshType:refreshType];
}

/** 判断返回数据是否非法，此方法子类必须实现 */
- (BOOL)isDataValidWithResponseObject:(NSObject<Collectionable> *)latestData
                          withRequest:(NSDictionary *)parameters
                      withRefreshType:(RefreshType)refreshType {
  if (refreshType == RefreshTypeLoaderMore) {
    NSString *fromId = parameters[@"seq"];
    TraceMsgData *lastInfo = (TraceMsgData *)[self.dataArray.array lastObject];
    NSString *lastId = [NSString stringWithFormat:@"%@", lastInfo.seq];
    if (![fromId isEqualToString:lastId]) {
      return NO;
    }
  }
  return YES;
}

/** 返回表格数据适配器，此方法子类必须实现 */
- (BaseTableAdapter *)getBaseTableAdaperWithDataList:(DataArray *)dataList {

  if (_tableAdapter == nil) {
    _tableAdapter = [[TraceMessageTableAdapter alloc]
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
