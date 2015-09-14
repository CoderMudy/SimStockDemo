//
//  MessageListTableVC.m
//  SimuStock
//
//  Created by jhss on 15/6/24.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "MessageListTableVC.h"
#import "WBDetailsViewController.h"
#import "MessageListTableViewCell.h"



@implementation MessageListTableAdapter

- (NSString *)nibName {
  static NSString *nibFileName;
  if (nibFileName == nil) {
    nibFileName = NSStringFromClass([MessageListTableViewCell class]);
  }
  return nibFileName;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.dataArray.array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  MessageListItem *message = self.dataArray.array[indexPath.row];
  if (!message.height) {
    int height = [MessageListTableViewCell cellHeightWithMessage:message
                                                    withFontSize:Font_Height_14_0];
    message.height = @(height);
  }
  return [message.height intValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  MessageListTableViewCell *cell =
      (MessageListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:self.nibName];


  /**----------数据绑定部分----------*/
  MessageListItem *message = self.dataArray.array[indexPath.row];

  __weak MessageListTableAdapter *weakSelf = self;

  [cell bindMessageListItem:message
                andBtnClick:^{
                  [weakSelf RefrashredDotImage:indexPath andTableView:tableView];
                }];

  [cell.bottomSplitView resetViewWidth:tableView.width];

  return cell;
}

///刷新小红点
- (void)RefrashredDotImage:(NSIndexPath *)indexPath andTableView:(UITableView *)tableView {
  MessageListTableVC *owner = (MessageListTableVC *)self.baseTableViewController;
  // 3、改变红点
  MessageListItem *message = self.dataArray.array[indexPath.row];
  NSString *uid = [NSString stringWithFormat:@"%d", [message.uid intValue]];
  if (!message.read) {
    NSString *msgId = [NSString stringWithFormat:@"%@", message.msgid];
    message.read = YES;
    [MesCallMeCoreDataUtil clearUnReadStatusWithUid:uid messageId:msgId type:owner.requestType];
  }
  //刷新行
  [tableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  MessageListTableVC *owner = (MessageListTableVC *)self.baseTableViewController;
  // 3、改变红点
  MessageListItem *message = self.dataArray.array[indexPath.row];
  NSString *uid = [NSString stringWithFormat:@"%d", [message.uid intValue]];
  if (!message.read) {
    NSString *msgId = [NSString stringWithFormat:@"%@", message.msgid];
    message.read = YES;
    [MesCallMeCoreDataUtil clearUnReadStatusWithUid:uid messageId:msgId type:owner.requestType];
  }

  if (owner.type == MessageTypeAtMe) {
    //聊股id
    [WBDetailsViewController showTSViewWithTStockId:message.tweetid];
  } else if (owner.type == MessageTypeComment) {
    MessageListTableViewCell *cell = (MessageListTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    MessageListItem *message = self.dataArray.array[indexPath.row];

    float offsetY = cell.centerY - tableView.contentOffset.y + 50;
    [WeiBoExtendButtons showButtonsWithCommentMessage:message offsetY:offsetY cell:cell];
  } else if (owner.type == MessageTypePraise || owner.type == MessageTypeAttention) {
    HomepageViewController *pageVC = [[HomepageViewController alloc] initUserId:uid
                                                                      titleName:message.writer.nickName
                                                                        matchID:@"1"];
    [AppDelegate pushViewControllerFromRight:pageVC];
  }

  //刷新行
  [tableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationNone];
}

@end

@implementation MessageListTableVC

- (id)initWithFrame:(CGRect)frame
    withMessageType:(MessageType)type
    withRequestType:(NSString *)requestType {
  if (self = [super initWithFrame:frame]) {
    _type = type;
    _requestType = requestType;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.littleCattleView setInformation:@"您暂时没有消息"
                             detailInfo:@"快去 <font color=\"#0081c4\" size=\"15dp\" "
                             @"text=\"炒股牛人\"> 那儿关注一些人吧"];
  [self refreshButtonPressDown];
}
/** 请求最新数据，此方法子类必须实现 */
- (void)requestDataListWithRefreshType:(RefreshType)refreshType
                         withDataArray:(DataArray *)existDataList
                          withCallBack:(HttpRequestCallBack *)callback {
  [MessageCenterListWrapper requestPositionDataWithInput:[self getRequestParamertsWithRefreshType:refreshType]
                                            withCallback:callback];
}

- (NSDictionary *)getRequestParamertsWithRefreshType:(RefreshType)refreshType {
  NSString *fromId = @"0";
  NSString *reqNum = @"20";
  if (refreshType == RefreshTypeLoaderMore) {
    MessageListItem *lastInfo = (MessageListItem *)[self.dataArray.array lastObject];
    fromId = [NSString stringWithFormat:@"%@", lastInfo.msgid];
    ;
  }
  return @{ @"type" : _requestType, @"fromId" : fromId, @"reqNum" : reqNum };
}

/** 判断返回数据是否非法，此方法子类必须实现 */
- (BOOL)isDataValidWithResponseObject:(NSObject<Collectionable> *)latestData
                withRequestParameters:(NSDictionary *)parameters
                      withRefreshType:(RefreshType)refreshType {
  if (refreshType == RefreshTypeLoaderMore) {
    NSString *fromId = parameters[@"fromId"];
    MessageListItem *lastInfo = (MessageListItem *)[self.dataArray.array lastObject];
    NSString *lastId = [NSString stringWithFormat:@"%@", lastInfo.msgid];
    if (![fromId isEqualToString:lastId]) {
      return NO;
    }
  }
  return YES;
}

- (void)bindRequestObject:(NSObject<Collectionable> *)latestData
    withRequestParameters:(NSDictionary *)parameters
          withRefreshType:(RefreshType)refreshType {
  NSArray *array = [latestData getArray];

  for (MessageListItem *message in array) {
    [MesCallMeCoreDataUtil initMessageStatus:message withType:_requestType];
    if (_type == MessageTypePraise || _type == MessageTypeAttention) {
      message.content = message.des;
      message.des = nil;
    }
  }
  [super bindRequestObject:latestData withRequestParameters:parameters withRefreshType:refreshType];
}

/** 返回表格数据适配器，此方法子类必须实现 */
- (BaseTableAdapter *)getBaseTableAdaperWithDataList:(DataArray *)dataList {
  if (_tableAdapter == nil) {
    _tableAdapter = [[MessageListTableAdapter alloc] initWithTableViewController:self
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
