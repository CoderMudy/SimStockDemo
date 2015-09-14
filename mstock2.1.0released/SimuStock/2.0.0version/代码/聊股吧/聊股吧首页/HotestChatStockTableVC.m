//
//  HotestChatStockTableVC.m
//  SimuStock
//
//  Created by jhss_wyz on 15/7/28.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "HotestChatStockTableVC.h"
#import "TweetListItem.h"
#import "FTCoreTextView.h"
#import "ImageUtil.h"
#import "UserGradeView.h"
#import "RoundHeadImage.h"
#import "CellBottomLinesView.h"

@implementation HotestChatStockTableAdapter

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  TweetListItem *item = (TweetListItem *)self.dataArray.array[indexPath.row];
  CGFloat cellHeight = CSPTVCell_Time_Bottom_HasUserNameView + CSPTVCell_Space_Between_Time_Tittle;
  CGFloat contentWidth = tableView.width - CSPTVCell_Content_Left_Space - CSPTVCell_Content_Right_Space;

  cellHeight += [HotestChatStockTableAdapter getTitleAndContentAndImageHeightWithWeibo:item
                                                                       andContontWidth:contentWidth];

  if (item.type == 2) {
    cellHeight += CSPTVCell_Height_RPTopBKView;
    cellHeight += CSPTVCell_Space_Between_RPTopView_Top;

    CGFloat replyContentWidth = tableView.width - CSPTVCell_Content_Left_Space - CSPTVCell_Content_Right_Space -
                                CSPTVCell_Space_Between_ReplayBKViewRight_RPContentViewRight -
                                CSPTVCell_Space_Between_ReplayBKViewLeft_RPContentViewLeft;
    CGFloat contentHight = [FTCoreTextView heightWithText:item.o_content
                                                    width:replyContentWidth
                                                     font:Font_Height_14_0];

    cellHeight += contentHight;
    if (item.o_imgs && item.o_imgs.count > 0) {
      NSNumber *imageHeight = [ImageUtil imageHeightFromUrl:item.o_imgs[0] withWeibo:item];
      cellHeight += CSPTVCell_Space_Between_Content_ContentImage + [imageHeight integerValue];
    }
    cellHeight += CSPTVCell_RPBKView_Bottom_Extra_Height;
  }

  cellHeight += CSPTVCell_Bottom_Extra_Height;

  return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  ChatStockPageTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatStockPageTVCell"];
  TweetListItem *item = self.dataArray.array[indexPath.row];
  cell.row = indexPath.row;
  cell.tweetListItem = item;

  [cell.userImage bindUserListItem:item.userListItem];
  if (item.userListItem.userName) {
    cell.userNameView.width = WIDTH_OF_SCREEN - 109;
    [cell.userNameView bindUserListItem:item.userListItem isOriginalPoster:NO];
  }

  cell.timeLabel.text = [SimuUtil getDateFromCtime:@([item.ctime longLongValue])];

  CGFloat height = CSPTVCell_Time_Bottom_HasUserNameView + CSPTVCell_Space_Between_Time_Tittle;

  /// 绑定聊股标题、聊股内容、聊股图片数据
  height += [HotestChatStockTableAdapter bindTittleAndContentAndContentImageAtCell:cell
                                                                      andIndexPath:indexPath
                                                                  andTopViewBottom:height
                                                                      andTableView:tableView
                                                                andHasUserNameView:NO];

  height += [HotestChatStockTableAdapter bindRPContentAndRPComtentImageAtCell:cell
                                                                 andIndexPath:indexPath
                                                                 andTableView:tableView
                                                             andTopViewBottom:height
                                                           andHasUserNameView:NO];

  /// 设置下方toolBar
  [cell initToolBar];
  cell.delegate = self;

  [cell.bottomLineView resetViewWidth:tableView.width];

  /// 设置长按手势
  [self setLongPressGRAtCell:cell andTableView:tableView andIndexPath:indexPath];

  /// 重置底部分割线
  [self resetBottomLineViewInCell:cell andRow:indexPath.row andData:self.dataArray];

  __weak HotestChatStockTableAdapter *weakSelf = self;
  /// 重写取消收藏回调函数，屏蔽默认实现
  cell.cancleCollectBtnBlock = ^(NSNumber *tid) {
  };
  /// 刷新置顶聊股
  cell.topButtonClickBlock = ^(TweetListItem *item) {
    //置顶后需要更新cell的高度，因为没标题的会有标题
    [weakSelf refreshTableViewCellHeightWithItem:item inTableView:tableView];
  };

  return cell;
}

/** 刷新表格cell高度，置顶后必须刷新 */
- (void)refreshTableViewCellHeightWithItem:(TweetListItem *)tweetItem
                               inTableView:(UITableView *)tableView {
  NSInteger i = 0;
  for (TweetListItem *item in self.dataArray.array) {
    if ([[item.tstockid stringValue] isEqualToString:[tweetItem.tstockid stringValue]]) {
      item.title = tweetItem.title;
      [item.heightCache removeObjectForKey:HeightCacheKeyAll];
      [tableView reloadRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:i inSection:0] ]
                       withRowAnimation:UITableViewRowAnimationNone];
      break;
    }
    i++;
  }
}

@end

@implementation HotestChatStockTableVC

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (NSDictionary *)getRequestParamertsWithRefreshType:(RefreshType)refreshType {
  NSNumber *fromId = @0;
  NSNumber *pageSize = @20;
  if (refreshType == RefreshTypeLoaderMore) {
    if (![(TweetListItem *)self.dataArray.array.lastObject timelineid]) {
      return nil;
    }
    TweetListItem *myChatList = [self.dataArray.array lastObject];
    fromId = myChatList.timelineid;
  }
  return @{ @"fromId" : fromId, @"pageSize" : pageSize };
}

/** 请求最新数据，此方法子类必须实现 */
- (void)requestDataListWithRefreshType:(RefreshType)refreshType
                         withDataArray:(DataArray *)existDataList
                          withCallBack:(HttpRequestCallBack *)callback {
  NSDictionary *dic = [self getRequestParamertsWithRefreshType:refreshType];

  if (dic == nil) {
    return;
  }

  [TweetList requestHotListWithFormId:dic[@"fromId"]
                           withReqNum:[dic[@"pageSize"] integerValue]
                         withCallback:callback];
}

/** 返回表格数据适配器，此方法子类必须实现 */
- (BaseTableAdapter *)getBaseTableAdaperWithDataList:(DataArray *)dataList {
  if (_tableAdapter == nil) {
    _tableAdapter = [[HotestChatStockTableAdapter alloc] initWithTableViewController:self
                                                                       withDataArray:self.dataArray];
    UINib *cellNib = [UINib nibWithNibName:_tableAdapter.nibName bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:_tableAdapter.nibName];

    /// 删除聊股时的回调
    __weak ChatStockPageBaseTVC *weakSelf = self;
    HotestChatStockTableAdapter *adapter = (HotestChatStockTableAdapter *)_tableAdapter;
    adapter.clientView = self.clientView;
    adapter.deleteOneCellCallBack = ^(NSNumber *num) {
      if (weakSelf.dataArray.array.count == 0 && weakSelf.dataArray.dataBinded == YES) {
        [weakSelf refreshButtonPressDown];
      }
    };
  }
  return _tableAdapter;
}

@end
