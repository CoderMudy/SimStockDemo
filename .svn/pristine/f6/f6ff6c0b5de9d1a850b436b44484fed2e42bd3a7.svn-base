//
//  SystemMessageTableVC.m
//  SimuStock
//
//  Created by jhss on 15/7/7.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SystemMessageTableVC.h"
#import "SystemMessageTableViewCell.h"

@implementation SystemMessageTableAdapter
- (NSString *)nibName {
  static NSString *nibFileName;
  if (nibFileName == nil) {
    nibFileName = NSStringFromClass([SystemMessageTableViewCell class]);
  }
  return nibFileName;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  SystemMsgData *message = self.dataArray.array[indexPath.row];
  CGFloat messageViewWidth = WIDTH_OF_SCREEN - 30;
  if (!message.height) {
    int height = [SystemMessageTableViewCell cellHeightWithSystemMsg:message
                                                        withMsgWidth:messageViewWidth
                                                        withFontSize:Font_Height_14_0];
    message.height = @(height);
  }
  return [message.height intValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  SystemMessageTableViewCell *cell =
      (SystemMessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:self.nibName];
  cell.selectionStyle = UITableViewCellSelectionStyleNone;

  /**----------数据绑定部分----------*/
  SystemMsgData *systemMsgData = self.dataArray.array[indexPath.row];
  [cell bindTraceMessage:systemMsgData];
  [cell.bottomSplitView resetViewWidth:tableView.width];
  return cell;
}
@end

@implementation SystemMessageTableVC

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
  [SystemMessageList requestMessageListWithDic:[self getRequestParamertsWithRefreshType:refreshType]
                                  withCallback:callback];
}

- (NSDictionary *)getRequestParamertsWithRefreshType:(RefreshType)refreshType {
  NSString *fromid = @"0";
  NSString *reqnum = @"20";
  if (refreshType == RefreshTypeLoaderMore) {
    SystemMsgData *lastInfo = (SystemMsgData *)[self.dataArray.array lastObject];
    fromid = [NSString stringWithFormat:@"%@", lastInfo.mID];
    ;
  }
  return @{ @"fromid" : fromid, @"reqnum" : reqnum };
}

- (void)bindRequestObject:(NSObject<Collectionable> *)latestData
    withRequestParameters:(NSDictionary *)parameters
          withRefreshType:(RefreshType)refreshType {
  [super bindRequestObject:latestData withRequestParameters:parameters withRefreshType:refreshType];
}

/** 判断返回数据是否非法，此方法子类必须实现 */
- (BOOL)isDataValidWithResponseObject:(NSObject<Collectionable> *)latestData
                          withRequest:(NSDictionary *)parameters
                      withRefreshType:(RefreshType)refreshType {
  if (refreshType == RefreshTypeLoaderMore) {
    NSString *fromId = parameters[@"fromId"];
    SystemMsgData *lastInfo = (SystemMsgData *)[self.dataArray.array lastObject];
    NSString *lastId = [NSString stringWithFormat:@"%@", lastInfo.mID];
    if (![fromId isEqualToString:lastId]) {
      return NO;
    }
  }
  return YES;
}

/** 返回表格数据适配器，此方法子类必须实现 */
- (BaseTableAdapter *)getBaseTableAdaperWithDataList:(DataArray *)dataList {

  if (_tableAdapter == nil) {
    _tableAdapter = [[SystemMessageTableAdapter alloc] initWithTableViewController:self
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
