//
//  CommentsTableViewController.m
//  SimuStock
//
//  Created by Jhss on 15/6/25.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "CommentsTableViewController.h"
#import "HomepageViewController.h"
#import "ReviewViewController.h"
#import "CommentsTableCell.h"
#import "WBDetailsTableHeaderView.h"
#import "SimuScreenAdapter.h"

@implementation CommentsTableAdapter

- (id)initWithTableViewController:(BaseTableViewController *)baseTableViewController
                    withDataArray:(DataArray *)dataList
                         withHuid:(NSString *)hostUserId
                withTalkStockItem:(TweetListItem *)talkStockItems {
  if (self = [super initWithTableViewController:baseTableViewController withDataArray:dataList]) {
    _hostUserId = hostUserId;
    talkStockItem = talkStockItems;
  }
  return self;
}

- (NSString *)nibName {
  static NSString *nibFileName;
  if (nibFileName == nil) {
    nibFileName = NSStringFromClass([CommentsTableCell class]);
  }
  return nibFileName;
}

/** 设置评论cell的高度 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  TweetListItem *item = (TweetListItem *)self.dataArray.array[indexPath.row];
  CGFloat cellHeight = Time_Bottom_HasUserNameView + Space_Between_Time_Tittle;
  CGFloat contentWidth = tableView.width - Content_Left_Space_HasUserNameView - Content_Right_Space;
  cellHeight += [CommentsTableCell getTitleAndContentAndImageHeightWithWeibo:item
                                                             andContontWidth:contentWidth];

  if (item.type == 4) {
    cellHeight += Space_Between_RPTopView_Top;
    cellHeight += Height_RPTopBKView;
    if ([item.o_content isEqualToString:@"已经被作者删除"]) {
      cellHeight -= 18.f;
    }

    CGFloat replyContentWidth = tableView.width - Content_Left_Space_HasUserNameView -
                                Content_Right_Space - Space_Between_ReplayBKViewRight_RPContentViewRight -
                                Space_Between_ReplayBKViewLeft_RPContentViewLeft;
    CGFloat contentHight = [FTCoreTextView heightWithText:item.o_content
                                                    width:replyContentWidth
                                                     font:WB_DETAILS_CONTENT_FONT];

    cellHeight += contentHight;
    if (item.o_imgs && item.o_imgs.count > 0) {
      NSNumber *imageHeight = [ImageUtil imageHeightFromUrl:item.o_imgs[0] withWeibo:item];
      cellHeight += Space_Between_Content_ContentImage + [imageHeight integerValue];
    }
    cellHeight += RPBKView_Bottom_Extra_Height + 18;
  }
  cellHeight += Bottom_Extra_Height;
  return cellHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  CommentsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentsTableCell"];

  TweetListItem *item = self.dataArray.array[indexPath.row];
  if (!item.tstockid) {
    cell.commentFloorLabel.hidden = YES;
    cell.longPress.enabled = NO;
  } else {
    cell.longPress.enabled = YES;
    cell.commentFloorLabel.hidden = NO;
    //长按手势_删除_设置block回调
    __weak CommentsTableAdapter *weakSelf = self;
    cell.deleteBtnBlock = ^(NSNumber *tid) {
      [weakSelf deleteCommentCell:tid];
    };
  }
  cell.row = indexPath.row;
  cell.tweetListItem = item;
  [cell.userImage bindUserListItem:item.userListItem];
  //判断是否是楼主
  BOOL isOriginalPoster = NO;
  if ([self.hostUserId isEqualToString:[item.uid stringValue]]) {
    isOriginalPoster = YES;
  }
  cell.userNameView.width = WIDTH_OF_SCREEN - 106;
  [cell.userNameView bindUserListItem:item.userListItem isOriginalPoster:isOriginalPoster];

  cell.timeLabel.text = [SimuUtil getDateFromCtime:@([item.ctime longLongValue])];

  [CommentsTableCell setTimeLineInCell:cell andRow:indexPath.row andData:self.dataArray];

  CGFloat height = Time_Bottom_HasUserNameView + Space_Between_Time_Tittle;

  /// 绑定聊股标题、聊股内容、聊股图片数据
  height += [CommentsTableCell bindTittleAndContentAndContentImageAtCell:cell
                                                            andIndexPath:indexPath
                                                        andTopViewBottom:height
                                                            andTableView:tableView
                                                      andHasUserNameView:YES];

  height += [CommentsTableCell bindRPContentAndRPComtentImageAtCell:cell
                                                       andIndexPath:indexPath
                                                       andTableView:tableView
                                                   andTopViewBottom:height
                                                 andHasUserNameView:YES];
  [cell.bottomLineView resetViewWidth:tableView.width];
  [cell.relayButton addTarget:self
                       action:@selector(replyFloor:)
             forControlEvents:UIControlEventTouchUpInside];
  return cell;
}
///** 删除某一行评论 */
- (void)deleteCommentCell:(NSNumber *)tid {
  NSInteger i = 0;
  for (TweetListItem *item in self.dataArray.array) {
    if ([[item.tstockid stringValue] isEqualToString:[tid stringValue]]) {
      //数据源、tableView中删除该对象
      [self.dataArray.array removeObjectAtIndex:i];
      break;
    }
    i++;
  }
  NSDictionary *userInfo = @{ @"data" : talkStockItem, @"operation" : @"-1" };
  [[NSNotificationCenter defaultCenter] postNotificationName:CommentWeiboSuccessNotification
                                                      object:nil
                                                    userInfo:userInfo];
  [self.baseTableViewController.tableView reloadData];
  [self.baseTableViewController refreshButtonPressDown];
}
- (void)replyFloor:(UIButton *)button {
  NSInteger index = button.tag - 1000;
  //后台错误数据bug
  if (index > [tweetListsArray count] - 1) {
    return;
  }
  TweetListItem *item = self.dataArray.array[index];
  if (!item.tstockid) {
    return;
  }
  __weak CommentsTableAdapter *weakSelf = self;
  [FullScreenLogonViewController checkLoginStatusWithCallBack:^(BOOL isLogined) {
    //登录成功后调用
    ReviewViewController *reViewVC =
        [[ReviewViewController alloc] initWithTstockID:[talkStockItem.tstockid stringValue]
                                           andSourceid:[item.tstockid stringValue]
                                      andTweetListItem:item
                                           andCallBack:^(TweetListItem *_item) {
                                             CommentsTableAdapter *strongSelf = weakSelf;
                                             if (strongSelf) {
                                               [strongSelf replyFloorSuccess:_item];
                                             }
                                           }];
    [AppDelegate pushViewControllerFromRight:reViewVC];
  }];
}
- (void)replyFloorSuccess:(TweetListItem *)_item {

  [self.dataArray.array insertObject:_item atIndex:0];
  _item.floor = 0;
  NSDictionary *userInfo = @{ @"data" : talkStockItem, @"operation" : @"+1" };
  [[NSNotificationCenter defaultCenter] postNotificationName:CommentWeiboSuccessNotification
                                                      object:nil
                                                    userInfo:userInfo];
  [self.baseTableViewController.tableView reloadData];
}

@end

@implementation CommentsTableViewController {
  NSInteger start;
}
- (NSDictionary *)getRequestParamertsWithRefreshType:(RefreshType)refreshType {
  NSString *startId = @"0";
  NSString *endId = @"20";
  if (refreshType == RefreshTypeLoaderMore) {
    TweetListItem *lastItem = [self.dataArray.array lastObject];
    startId = [lastItem.timelineid stringValue];
  }
  if (!self.isHost) {
    //评论部分
    NSDictionary *dic = @{
      @"tweetid" : [_talkId stringValue],
      @"fromId" : startId,
      @"reqNum" : endId,
      @"order" : self.earliestOrNewest
    };
    return dic;
  } else {
    //楼主部分
    NSDictionary *dic = @{
      @"tweetId" : [self.talkId stringValue],
      @"fromId" : startId,
      @"reqNum" : endId,
      @"order" : self.earliestOrNewest
    };
    return dic;
  }
}
/** 请求最新数据，此方法子类必须实现 */
- (void)requestDataListWithRefreshType:(RefreshType)refreshType
                         withDataArray:(DataArray *)existDataList
                          withCallBack:(HttpRequestCallBack *)callback {
  if (!self.isHost) {
    //评论
    [TweetList getTalkStockListsContentWithTweetdic:[self getRequestParamertsWithRefreshType:refreshType]
                                       withCallback:callback];
  } else {
    //楼主
    [TweetList justLookAtTheBuildingLordListsContentWithTweetDic:[self getRequestParamertsWithRefreshType:refreshType]
                                                    withCallback:callback];
  }
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
    if (refreshType == RefreshTypeLoaderMore) {
      start += 20;
    } else {
      start = 0;
    }
  }
}
/** 判断返回数据是否有效 */
- (BOOL)isDataValidWithResponseObject:(NSObject<Collectionable> *)latestData
                withRequestParameters:(NSDictionary *)parameters
                      withRefreshType:(RefreshType)refreshType {
  if (refreshType == RefreshTypeLoaderMore) {
    NSString *fromId = parameters[@"fromId"];
    TweetListItem *lastItem = [self.dataArray.array lastObject];
    NSString *lastId = [lastItem.timelineid stringValue];
    if (![fromId isEqualToString:lastId]) {
      return NO;
    }
  }
  return YES;
}
/** 返回表格数据适配器，此方法子类必须实现 */
- (BaseTableAdapter *)getBaseTableAdaperWithDataList:(DataArray *)dataList {
  if (_tableAdapter == nil) {
    _tableAdapter = [[CommentsTableAdapter alloc] initWithTableViewController:self
                                                                withDataArray:self.dataArray
                                                                     withHuid:self.hostUid
                                                            withTalkStockItem:self.talkStockItem];
    UINib *cellNib = [UINib nibWithNibName:_tableAdapter.nibName bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:_tableAdapter.nibName];
  }
  return _tableAdapter;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.tableView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  [self.littleCattleView setInformation:@"快去评论吧"];
  [self.littleCattleView resetFrame:CGRectMake(0, 0, self.view.size.width, 300)];
}
- (void)refreshButtonPressDown {
  [self requestResponseWithRefreshType:RefreshTypeRefresh];
}
- (void)requestResponseWithRefreshType:(RefreshType)refreshType {
  [super requestResponseWithRefreshType:refreshType];
  if (refreshType == RefreshTypeHeaderRefresh) {
    if (_headerRefreshCallBack) {
      _headerRefreshCallBack();
    }
  }
}
- (id)initWithFrame:(CGRect)frame
              withIsHost:(BOOL)isHost
    withEarliestOrNewest:(NSString *)earliestOrNewest
             withtTalkId:(NSNumber *)talkId {
  if (self = [super initWithFrame:frame]) {
    _isHost = isHost;
    _earliestOrNewest = earliestOrNewest;
    _talkId = talkId;
  }
  return self;
}

@end
