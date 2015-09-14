//
//  MyChatStockBaseTableVC.m
//  SimuStock
//
//  Created by jhss_wyz on 15/7/8.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "MyIssuanceTableVC.h"
#import "MyChatStockListWrapper.h"
#import "TweetListItem.h"
#import "ImageUtil.h"
#import "FTCoreTextView.h"
#import "CellBottomLinesView.h"
#import "SimuScreenAdapter.h"

@implementation MyIssuanceTableAdapter

- (NSString *)nibName {
  static NSString *nibFileName;
  if (nibFileName == nil) {
    nibFileName = @"MyIssuanceTVCell";
  }
  return nibFileName;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  TweetListItem *item = (TweetListItem *)self.dataArray.array[indexPath.row];
  CGFloat cellHeight = MCSTVCell_Time_Bottom + MCSTVCell_Space_Between_Time_Tittle;
  CGFloat contentWidth =
      tableView.width - MCSTVCell_Content_Left_Space - MCSTVCell_Content_Right_Space;

  cellHeight += [MyIssuanceTableAdapter getTitleAndContentAndImageHeightWithWeibo:item
                                                                  andContontWidth:contentWidth];

  if (item.type == 2) {
    cellHeight += MCSTVCell_Height_RPTopBKView;
    cellHeight += MCSTVCell_Space_Between_RPTopView_Top;

    CGFloat replyContentWidth = tableView.width - MCSTVCell_Content_Left_Space -
                                MCSTVCell_Content_Right_Space -
                                MCSTVCell_Space_Between_ReplayBKViewRight_RPContentViewRight -
                                MCSTVCell_Space_Between_ReplayBKViewLeft_RPContentViewLeft;
    CGFloat contentHight = [FTCoreTextView heightWithText:item.o_content
                                                    width:replyContentWidth
                                                     font:CHAT_STOCK_REPLY_CONTENT_FONT];

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
  MyChatStockTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIssuanceTVCell"];
  TweetListItem *item = self.dataArray.array[indexPath.row];
  cell.row = indexPath.row;
  cell.tweetListItem = item;
  cell.timeLabel.text = [SimuUtil getDateFromCtime:@([item.ctime longLongValue])];

  /// 设置左侧时间线
  [MyIssuanceTableAdapter setTimeLineInCell:cell andRow:indexPath.row andData:self.dataArray];

  CGFloat height = MCSTVCell_Time_Bottom + MCSTVCell_Space_Between_Time_Tittle;

  /// 绑定聊股标题、聊股内容、聊股图片数据
  height += [MyIssuanceTableAdapter bindTittleAndContentAndContentImageAtCell:cell
                                                                 andIndexPath:indexPath
                                                             andTopViewBottom:height
                                                                 andTableView:tableView
                                                           andHasUserNameView:NO];

  height += [MyIssuanceTableAdapter bindRPContentAndRPComtentImageAtCell:cell
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

  /// 重写取消收藏回调函数，屏蔽默认实现
  cell.cancleCollectBtnBlock = ^(NSNumber *tid) {
  };

  return cell;
}

@end

@implementation MyIssuanceTableVC

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.littleCattleView setInformation:@"您还没有聊股"];
  [self addObservers];
}

/** 请求最新数据，此方法子类必须实现 */
- (void)requestDataListWithRefreshType:(RefreshType)refreshType
                         withDataArray:(DataArray *)existDataList
                          withCallBack:(HttpRequestCallBack *)callback {
  NSDictionary *dic = [self getRequestParamertsWithRefreshType:refreshType];

  [MyChatStockListWrapper requestPositionDataWithCallback:callback
                                            requestUserID:dic[@"userID"]
                                            requestFromID:dic[@"fromId"]
                                            requestReqNum:dic[@"pageSize"]];
}

/** 返回表格数据适配器，此方法子类必须实现 */
- (BaseTableAdapter *)getBaseTableAdaperWithDataList:(DataArray *)dataList {
  if (_tableAdapter == nil) {
    _tableAdapter = [[MyIssuanceTableAdapter alloc] initWithTableViewController:self
                                                                  withDataArray:self.dataArray];
    UINib *cellNib = [UINib nibWithNibName:_tableAdapter.nibName bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:_tableAdapter.nibName];

    /// 删除聊股时的回调
    __weak MyIssuanceTableVC *weakSelf = self;
    MyIssuanceTableAdapter *adapter = (MyIssuanceTableAdapter *)_tableAdapter;
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
