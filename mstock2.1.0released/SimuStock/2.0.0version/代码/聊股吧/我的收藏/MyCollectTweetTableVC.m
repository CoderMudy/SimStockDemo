//
//  MyCollectTweetTableVC.m
//  SimuStock
//
//  Created by jhss_wyz on 15/7/15.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "MyCollectTweetTableVC.h"
#import "MyCollectList.h"
#import "TweetListItem.h"
#import "ImageUtil.h"
#import "FTCoreTextView.h"
#import "RoundHeadImage.h"
#import "UserGradeView.h"
#import "CellBottomLinesView.h"

@implementation MyCollectTweetTableAdapter

- (NSString *)nibName {
  static NSString *nibFileName;
  if (nibFileName == nil) {
    nibFileName = @"MyCollectTweetTVCell";
  }
  return nibFileName;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  TweetListItem *item = (TweetListItem *)self.dataArray.array[indexPath.row];
  CGFloat cellHeight = MCSTVCell_Time_Bottom_HasUserNameView + MCSTVCell_Space_Between_Time_Tittle;
  CGFloat contentWidth =
      tableView.width - MCSTVCell_Content_Left_Space_HasUserNameView - MCSTVCell_Content_Right_Space;

  cellHeight += [MyCollectTweetTableAdapter getTitleAndContentAndImageHeightWithWeibo:item
                                                                      andContontWidth:contentWidth];

  if (item.type == 2) {
    cellHeight += MCSTVCell_Space_Between_RPTopView_Top;
    cellHeight += MCSTVCell_Height_RPTopBKView;

    CGFloat replyContentWidth = tableView.width - MCSTVCell_Content_Left_Space_HasUserNameView -
                                MCSTVCell_Content_Right_Space -
                                MCSTVCell_Space_Between_ReplayBKViewRight_RPContentViewRight -
                                MCSTVCell_Space_Between_ReplayBKViewLeft_RPContentViewLeft;
    CGFloat contentHight = [FTCoreTextView heightWithText:item.o_content
                                                    width:replyContentWidth
                                                     font:Font_Height_14_0];

    cellHeight += contentHight;
    if (item.o_imgs && item.o_imgs.count > 0) {
      NSNumber *imageHeight = [ImageUtil imageHeightFromUrl:item.o_imgs[0] withWeibo:item];
      cellHeight += MCSTVCell_Space_Between_Content_ContentImage + [imageHeight integerValue];
    }
    cellHeight += MCSTVCell_RPBKView_Bottom_Extra_Height;
  }
  cellHeight += MCSTVCell_Bottom_Extra_Height;
  return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  MyChatStockTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCollectTweetTVCell"];
  TweetListItem *item = self.dataArray.array[indexPath.row];
  cell.row = indexPath.row;
  cell.tweetListItem = item;

  [cell.userImage bindUserListItem:item.userListItem];

  if (item.userListItem.userName) {
    cell.userNameView.width = WIDTH_OF_SCREEN - 46;
    [cell.userNameView bindUserListItem:item.userListItem isOriginalPoster:NO];
  }

  cell.timeLabel.text = [SimuUtil getDateFromCtime:@([item.ctime longLongValue])];

  [MyCollectTweetTableAdapter setTimeLineInCell:cell andRow:indexPath.row andData:self.dataArray];

  CGFloat height = MCSTVCell_Time_Bottom_HasUserNameView + MCSTVCell_Space_Between_Time_Tittle;

  /// 绑定聊股标题、聊股内容、聊股图片数据
  height += [MyCollectTweetTableAdapter bindTittleAndContentAndContentImageAtCell:cell
                                                                     andIndexPath:indexPath
                                                                 andTopViewBottom:height
                                                                     andTableView:tableView
                                                               andHasUserNameView:YES];

  height += [MyCollectTweetTableAdapter bindRPContentAndRPComtentImageAtCell:cell
                                                                andIndexPath:indexPath
                                                                andTableView:tableView
                                                            andTopViewBottom:height
                                                          andHasUserNameView:YES];

  /// 设置下方toolBar
  [cell initToolBar];
  cell.delegate = self;

  [cell.bottomLineView resetViewWidth:tableView.width];

  [self setLongPressGRAtCell:cell andTableView:tableView andIndexPath:indexPath];

  return cell;
}

@end

@implementation MyCollectTweetTableVC

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.littleCattleView setInformation:@"快去收藏喜欢的聊股吧"];
  [self addObservers];
}

/** 请求最新数据，此方法子类必须实现 */
- (void)requestDataListWithRefreshType:(RefreshType)refreshType
                         withDataArray:(DataArray *)existDataList
                          withCallBack:(HttpRequestCallBack *)callback {
  NSDictionary *dic = [self getRequestParamertsWithRefreshType:refreshType];

  [MyCollectList requestCollectDataWithCallback:callback
                                  requestFromID:dic[@"fromId"]
                                  requestReqNum:dic[@"pageSize"]];
}

/** 返回表格数据适配器，此方法子类必须实现 */
- (BaseTableAdapter *)getBaseTableAdaperWithDataList:(DataArray *)dataList {
  if (_tableAdapter == nil) {
    _tableAdapter = [[MyCollectTweetTableAdapter alloc] initWithTableViewController:self
                                                                      withDataArray:self.dataArray];
    UINib *cellNib = [UINib nibWithNibName:_tableAdapter.nibName bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:_tableAdapter.nibName];

    /// 取消收藏时的回调
    __weak MyCollectTweetTableVC *weakSelf = self;
    MyCollectTweetTableAdapter *adapter = (MyCollectTweetTableAdapter *)_tableAdapter;
    adapter.clientView = self.clientView;
    adapter.cancleCollectCallBack = ^(NSNumber *num) {
      if (weakSelf.dataArray.array.count == 0 && weakSelf.dataArray.dataBinded == YES) {
        [weakSelf refreshButtonPressDown];
      }
    };
  }
  return _tableAdapter;
}

@end
