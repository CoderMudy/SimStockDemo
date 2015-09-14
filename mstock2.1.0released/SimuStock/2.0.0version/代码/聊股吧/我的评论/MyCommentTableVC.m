//
//  MyCommentTableVC.m
//  SimuStock
//
//  Created by jhss_wyz on 15/7/16.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "MyCommentTableVC.h"
#import "UserCommentList.h"
#import "TweetListItem.h"
#import "CellBottomLinesView.h"

@implementation MyCommentTableAdapter
- (NSString *)nibName {
  static NSString *nibFileName;
  if (nibFileName == nil) {
    nibFileName = @"MyCommentTVCell";
  }
  return nibFileName;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  TweetListItem *item = (TweetListItem *)self.dataArray.array[indexPath.row];
  CGFloat cellHeight = MCSTVCell_Time_Bottom + MCSTVCell_Space_Between_Tittle_Content;
  CGFloat contentWidth =
      tableView.width - MCSTVCell_Content_Left_Space - MCSTVCell_Content_Right_Space;
  cellHeight +=
      [MyCommentTableAdapter getContentAndImageHeightWithWeibo:item andContontWidth:contentWidth];

  cellHeight += MCSTVCell_Space_Between_Bottom_Top;

  return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  MyChatStockTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCommentTVCell"];
  TweetListItem *item = self.dataArray.array[indexPath.row];
  cell.row = indexPath.row;
  cell.tweetListItem = item;
  cell.timeLabel.text = [SimuUtil getDateFromCtime:@([item.ctime longLongValue])];

  /// 设置左侧时间线
  [MyCommentTableAdapter setTimeLineInCell:cell andRow:indexPath.row andData:self.dataArray];

  CGFloat height = MCSTVCell_Time_Bottom + MCSTVCell_Space_Between_Tittle_Content;

  /// 绑定聊股内容、聊股图片数据
  height += [MyCommentTableAdapter bindContentAndContentImageAtCell:cell
                                                       andIndexPath:indexPath
                                                   andTopViewBottom:height
                                                       andTableView:tableView
                                                 andHasUserNameView:NO];

  [cell.bottomLineView resetViewWidth:tableView.width];

  /// 设置长按手势
  [self setLongPressGRAtCell:cell andTableView:tableView andIndexPath:indexPath];

  return cell;
}

@end

@implementation MyCommentTableVC

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.littleCattleView setInformation:@"您还没有评论"];
}

/** 请求最新数据，此方法子类必须实现 */
- (void)requestDataListWithRefreshType:(RefreshType)refreshType
                         withDataArray:(DataArray *)existDataList
                          withCallBack:(HttpRequestCallBack *)callback {
  NSDictionary *dic = [self getRequestParamertsWithRefreshType:refreshType];

  [UserCommentList requestCommentDataWithCallback:callback
                                    requestUserID:dic[@"userID"]
                                    requestFromID:dic[@"fromId"]
                                    requestReqNum:dic[@"pageSize"]];
}

/** 返回表格数据适配器，此方法子类必须实现 */
- (BaseTableAdapter *)getBaseTableAdaperWithDataList:(DataArray *)dataList {
  if (_tableAdapter == nil) {
    _tableAdapter = [[MyCommentTableAdapter alloc] initWithTableViewController:self
                                                                 withDataArray:self.dataArray];
    UINib *cellNib = [UINib nibWithNibName:_tableAdapter.nibName bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:_tableAdapter.nibName];

    /// 删除聊股时的回调
    __weak MyCommentTableVC *weakSelf = self;
    MyCommentTableAdapter *adapter = (MyCommentTableAdapter *)_tableAdapter;
    adapter.deleteOneCellCallBack = ^(NSNumber *num) {
      if (weakSelf.dataArray.array.count == 0 && weakSelf.dataArray.dataBinded == YES) {
        [weakSelf refreshButtonPressDown];
      }
    };
  }
  return _tableAdapter;
}

@end
