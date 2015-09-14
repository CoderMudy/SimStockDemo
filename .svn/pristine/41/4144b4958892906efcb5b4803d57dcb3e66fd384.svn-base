//
//  AllChatStockTableVC.m
//  SimuStock
//
//  Created by jhss_wyz on 15/7/30.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "AllChatStockTableVC.h"
#import "TweetListItem.h"
#import "FTCoreTextView.h"
#import "ImageUtil.h"
#import "UserGradeView.h"
#import "RoundHeadImage.h"
#import "CellBottomLinesView.h"
#import "ShowBarInfoData.h"
#import "GetBarTopListData.h"
#import "WBCoreDataUtil.h"
#import "AllChatStockTopTVCell.h"
#import "WBDetailsViewController.h"
#import "ReplyViewController.h"
#import "MakingScreenShot.h"
#import "ShareController.h"

@implementation AllChatStockTableAdapter

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  [self tableView:tableView didDeselectRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSArray *itemArray;
  if (indexPath.section == 0) {
    itemArray = [self.barTopList.array copy];
  } else {
    itemArray = [self.dataArray.array copy];
  }
  if (indexPath.row > itemArray.count) {
    return;
  }
  TweetListItem *item = itemArray[indexPath.row];
  if (item.tstockid) {
    [WBDetailsViewController showTSViewWithTStockId:item.tstockid];
  }
  return;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == 0) {
    return self.barTopList.array.count;
  } else {
    return self.dataArray.array.count;
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0) {
    BarTopTweetData *topData = _barTopList.array[indexPath.row];
    return topData.cellHeight;
  } else {
    TweetListItem *item = (TweetListItem *)self.dataArray.array[indexPath.row];
    CGFloat cellHeight = CSPTVCell_Time_Bottom_HasUserNameView + CSPTVCell_Space_Between_Time_Tittle;
    CGFloat contentWidth = tableView.width - CSPTVCell_Content_Left_Space - CSPTVCell_Content_Right_Space;

    cellHeight += [AllChatStockTableAdapter getTitleAndContentAndImageHeightWithWeibo:item
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
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  //置顶股聊
  if (indexPath.section == 0) {
    static NSString *topCellID = @"AllChatStockTopTVCell";
    AllChatStockTopTVCell *topCell = [tableView dequeueReusableCellWithIdentifier:topCellID];
    if (!topCell) {
      topCell = [[[NSBundle mainBundle] loadNibNamed:@"AllChatStockTopTVCell"
                                               owner:self
                                             options:nil] firstObject];
    }
    __weak AllChatStockTableVC *weakTableVC = (AllChatStockTableVC *)self.baseTableViewController;

    /// 置顶按钮回调，只需重新请求置顶数据
    [topCell setTopTopButtonClickBlock:^() {
      [weakTableVC requestBarTopListData];
    }];

    /// 取消置顶回调，只需重新请求置顶数据
    [topCell setTopUnTopButtonClickBlock:^() {
      [weakTableVC requestBarTopListData];
    }];

    /// 加精回调，刷新所有表格对应cell的精图标
    [topCell setTopEliteButtonClickBlock:^(BOOL isElite, NSNumber *tid) {
      if (weakTableVC.topEliteButtonClickBlock) {
        weakTableVC.topEliteButtonClickBlock(isElite, tid);
      }
    }];

    /// 删除回调
    __weak AllChatStockTableAdapter *weakSelf = self;
    [topCell setTopDeleteButtonClickBlock:^(NSNumber *tid) {
      [weakSelf tableView:tableView delateCell:tid];
    }];

    BarTopTweetData *topData = self.barTopList.array[indexPath.row];
    [topCell refreshInfoWithBarTopTweetData:topData];

    return topCell;

  } else {

    ChatStockPageTVCell *cell = [tableView dequeueReusableCellWithIdentifier:self.nibName];
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
    height += [AllChatStockTableAdapter bindTittleAndContentAndContentImageAtCell:cell
                                                                     andIndexPath:indexPath
                                                                 andTopViewBottom:height
                                                                     andTableView:tableView
                                                               andHasUserNameView:NO];

    height += [AllChatStockTableAdapter bindRPContentAndRPComtentImageAtCell:cell
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

    __weak AllChatStockTableAdapter *weakSelf = self;
    /// 重写取消收藏回调函数，屏蔽默认实现
    cell.cancleCollectBtnBlock = ^(NSNumber *tid) {
    };
    __weak AllChatStockTableVC *weakTableVC = (AllChatStockTableVC *)self.baseTableViewController;
    /// 刷新置顶聊股
    cell.topButtonClickBlock = ^(TweetListItem *item) {
      /// 置顶后需要更新cell的高度，因为没标题的会有标题
      [weakSelf refreshTableViewCellHeightWithItem:item inTableView:tableView];
      [weakTableVC requestBarTopListData];
    };
    cell.deleteBtnBlock = ^(NSNumber *tid) {
      [weakSelf tableView:tableView delateCell:tid];
    };
    cell.eliteButtonClickBlock = ^(BOOL isElite, NSNumber *tid) {
      if (weakTableVC.topEliteButtonClickBlock) {
        weakTableVC.topEliteButtonClickBlock(isElite, tid);
      }
    };

    return cell;
  }
}

/** 刷新表格cell高度，置顶后必须刷新 */
- (void)refreshTableViewCellHeightWithItem:(TweetListItem *)tweetItem
                               inTableView:(UITableView *)tableView {
  NSInteger i = 0;
  for (TweetListItem *item in self.dataArray.array) {
    if ([[item.tstockid stringValue] isEqualToString:[tweetItem.tstockid stringValue]]) {
      item.title = tweetItem.title;
      [item.heightCache removeObjectForKey:HeightCacheKeyAll];
      [tableView reloadRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:i inSection:1] ]
                       withRowAnimation:UITableViewRowAnimationNone];
      break;
    }
    i++;
  }
}

/** 删除某一条聊股数据 */
- (void)tableView:(UITableView *)tableView delateCell:(NSNumber *)tid {
  NSInteger i = 0;
  for (TweetListItem *homeData in self.dataArray.array) {
    if (homeData.tstockid.longLongValue == tid.longLongValue) {
      //数据源、tableView中删除该对象
      [self.dataArray.array removeObjectAtIndex:i];
      break;
    }
    i++;
  }
  i = 0;
  for (TweetListItem *homeData in self.barTopList.array) {
    if (homeData.tstockid.longLongValue == tid.longLongValue) {
      //数据源、tableView中删除该对象
      [self.barTopList.array removeObjectAtIndex:i];
      break;
    }
    i++;
  }
  /// 判断数据是否为空，如果为空，显示小牛
  if (self.dataArray.array.count == 0) {
    self.dataArray.dataBinded = NO;
  }
  [tableView reloadData];
}
/** 评论微博 重写父类的方法 */
- (void)commentWeiBo:(NSInteger)row {
  UITableView *tempTV = ((AllChatStockTableVC *)self.baseTableViewController).tableView;
  ChatStockPageTVCell *cell = (ChatStockPageTVCell *)
      [tempTV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:1]];
  TweetListItem *homeItem = self.dataArray.array[row];
  ReplyViewController *replyVC = [[ReplyViewController alloc]
      initWithTstockID:[homeItem.tstockid stringValue]
           andCallBack:^(TweetListItem *item) {
             //评论数+1
             [cell.commentBtn setTitle:[NSString stringWithFormat:@"%ld", (long)(++homeItem.comment)]
                              forState:UIControlStateNormal];
           }];
  [AppDelegate pushViewControllerFromRight:replyVC];
}

/** 分享微博 重写父类的方法*/
- (void)shareWeiBo:(NSInteger)row {
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }
  TweetListItem *homeData = self.dataArray.array[row];
  UITableView *tempTV = self.baseTableViewController.tableView;
  /// 分享
  ChatStockPageTVCell *cell = (ChatStockPageTVCell *)
      [tempTV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:1]];

  MakingScreenShot *makingScreenShot = [[MakingScreenShot alloc] init];

  CGRect homeRect = [tempTV
      convertRect:[tempTV rectForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:1]]
           toView:self.clientView];
  UIImage *shareImage = [makingScreenShot makingScreenShotWithFrame:homeRect
                                                           withView:cell.contentView
                                                           withType:MakingScreenShotType_HomePage];
  [[[ShareController alloc] init] shareWeibo:homeData withShareImage:shareImage];
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
  if ((AllChatStockTableVC *)self.baseTableViewController == nil ||
      ![(AllChatStockTableVC *)self.baseTableViewController supportAutoLoadMore]) {
    return;
  }
  if (indexPath.section == 0) {
    return;
  }

  if (indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] - 1) {

    NSArray *indexes = [tableView indexPathsForVisibleRows];
    if (indexes && indexes.count > 0) {
      NSIndexPath *firstRow = indexes[0];
      if (firstRow.row == 0) {
        //如果第一行和最后一行都显示了，不自动加载，让用户手动加载吧
        return;
      }
    }

    if (self.dataArray.dataComplete) {
      return;
    }

    if ((AllChatStockTableVC *)self.baseTableViewController) {
      [(AllChatStockTableVC *)self.baseTableViewController requestResponseWithRefreshType:RefreshTypeLoaderMore];
    }
  }
}

@end

@implementation AllChatStockTableVC

- (void)viewDidLoad {
  [super viewDidLoad];
  self.barTopList = [[DataArray alloc] init];
}

- (NSDictionary *)getRequestParamertsWithRefreshType:(RefreshType)refreshType {
  NSNumber *barID = self.barID;
  NSNumber *fromId = @0;
  NSNumber *pageSize = @20;
  if (refreshType == RefreshTypeLoaderMore) {
    if (![(TweetListItem *)self.dataArray.array.lastObject timelineid]) {
      return nil;
    }
    TweetListItem *myChatList = [self.dataArray.array lastObject];
    fromId = myChatList.timelineid;
  }
  return @{ @"barID" : barID, @"fromId" : fromId, @"pageSize" : pageSize };
}

/** 请求最新数据，此方法子类必须实现 */
- (void)requestDataListWithRefreshType:(RefreshType)refreshType
                         withDataArray:(DataArray *)existDataList
                          withCallBack:(HttpRequestCallBack *)callback {
  NSDictionary *dic = [self getRequestParamertsWithRefreshType:refreshType];

  if (dic == nil) {
    /// 当前页面只有发表的假数据或者网络不稳定时会dic == nil
    [self requestResponseWithRefreshType:RefreshTypeRefresh];
    return;
  }
  [TweetList requestGetBarNewTweetListDataWithBarId:dic[@"barID"]
                                         withFromId:dic[@"fromId"]
                                         withReqNum:[dic[@"pageSize"] integerValue]
                                       withCallback:callback];
}

/** 返回表格数据适配器，此方法子类必须实现 */
- (BaseTableAdapter *)getBaseTableAdaperWithDataList:(DataArray *)dataList {
  if (_tableAdapter == nil) {
    _tableAdapter = [[AllChatStockTableAdapter alloc] initWithTableViewController:self
                                                                    withDataArray:self.dataArray];
    UINib *cellNib = [UINib nibWithNibName:_tableAdapter.nibName bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:_tableAdapter.nibName];

    /// 删除聊股时的回调
    __weak AllChatStockTableVC *weakSelf = self;
    AllChatStockTableAdapter *adapter = (AllChatStockTableAdapter *)_tableAdapter;
    adapter.clientView = self.clientView;
    adapter.deleteOneCellCallBack = ^(NSNumber *num) {
      if (weakSelf.dataArray.array.count == 0 && weakSelf.dataArray.dataBinded == YES) {
        [weakSelf refreshButtonPressDown];
      }
    };
  }
  return _tableAdapter;
}

- (void)requestResponseWithRefreshType:(RefreshType)refreshType {
  [super requestResponseWithRefreshType:refreshType];
  if (refreshType != RefreshTypeLoaderMore) {
    /// 请求股吧信息
    [self requestShowBarInfoData];
    /// 请求置顶股聊信息
    [self requestBarTopListData];
  }
}

- (void)requestShowBarInfoData {
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak AllChatStockTableVC *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    AllChatStockTableVC *strongSelf = weakSelf;
    if (strongSelf) {
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    AllChatStockTableVC *strongSelf = weakSelf;
    if (strongSelf && strongSelf.resetBarInfoBlock) {
      strongSelf.resetBarInfoBlock(obj);
    }
  };

  [ShowBarInfoData requestShowBarInfoDataWithBarId:self.barID withCallback:callback];
}

- (void)requestBarTopListData {
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak AllChatStockTableVC *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    AllChatStockTableVC *strongSelf = weakSelf;
    if (strongSelf) {
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    AllChatStockTableVC *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindGetBarTopListData:(GetBarTopListData *)obj];
    }
  };

  [GetBarTopListData requestGetBarTopListDataWithBarId:self.barID withCallback:callback];
}

- (void)bindGetBarTopListData:(GetBarTopListData *)barTopListData {
  [_barTopList reset];

  /// 不用考虑数据为空时的情况
  [_barTopList.array addObjectsFromArray:barTopListData.dataArray];
  for (BarTopTweetData *topData in _barTopList.array) {
    topData.cellHeight = [AllChatStockTopTVCell heightFromTitle:topData.title];
    /// 查询coredata，是否已收藏，检测登录
    if (![SimuUtil isLogined]) {
      topData.isCollected = NO;
    } else {
      topData.isCollected = [WBCoreDataUtil fetchCollectTid:topData.tstockid];
    }
  }
  _barTopList.dataBinded = YES;
  _barTopList.dataComplete = YES;
  AllChatStockTableAdapter *tableAdapter = (AllChatStockTableAdapter *)_tableAdapter;
  tableAdapter.barTopList = _barTopList;
  [self.tableView reloadData];
}

@end
