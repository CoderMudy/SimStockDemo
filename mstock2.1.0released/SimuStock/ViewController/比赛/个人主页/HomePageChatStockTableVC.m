//
//  HomePageChatStockTableVC.m
//  SimuStock
//
//  Created by jhss_wyz on 15/8/3.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "HomePageChatStockTableVC.h"
#import "StockTradeList.h"
#import "TweetListItem.h"
#import "ImageUtil.h"
#import "FTCoreTextView.h"
#import "CellBottomLinesView.h"

@implementation HomePageChatStockTableAdapter
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
  CGFloat contentWidth = tableView.width - MCSTVCell_Content_Left_Space - MCSTVCell_Content_Right_Space;

  cellHeight += [HomePageChatStockTableAdapter getTitleAndContentAndImageHeightWithWeibo:item
                                                                         andContontWidth:contentWidth];

  if (item.type == 2) {
    cellHeight += MCSTVCell_Height_RPTopBKView;
    cellHeight += MCSTVCell_Space_Between_RPTopView_Top;

    CGFloat replyContentWidth = tableView.width - MCSTVCell_Content_Left_Space - MCSTVCell_Content_Right_Space -
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

  if (item.type != WeiboTypeSystem) {
    cellHeight += MCSTVCell_Bottom_Extra_Height;
  } else {
    cellHeight += MCSTVCell_RPBKView_Bottom_Extra_Height + MCSTVCell_Space_Between_Bottom_Top;
  }

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
  [HomePageChatStockTableAdapter setTimeLineInCell:cell
                                            andRow:indexPath.row
                                           andData:self.dataArray];

  CGFloat height = MCSTVCell_Time_Bottom + MCSTVCell_Space_Between_Time_Tittle;

  /// 绑定聊股标题、聊股内容、聊股图片数据
  height += [HomePageChatStockTableAdapter bindTittleAndContentAndContentImageAtCell:cell
                                                                        andIndexPath:indexPath
                                                                    andTopViewBottom:height
                                                                        andTableView:tableView
                                                                  andHasUserNameView:NO];

  height += [HomePageChatStockTableAdapter bindRPContentAndRPComtentImageAtCell:cell
                                                                   andIndexPath:indexPath
                                                                   andTableView:tableView
                                                               andTopViewBottom:height
                                                             andHasUserNameView:NO];

  /// 如果是系统消息则隐藏分享、评论、点赞的工具栏，并且更换时间线中间的图片
  if (item.type == WeiboTypeSystem) {
    cell.bottomToolView.hidden = YES;
    cell.typeImage.image = [UIImage imageNamed:@"系统通知图标"];
    height += MCSTVCell_Space_Between_Bottom_Top;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  } else {
    cell.bottomToolView.hidden = NO;
    cell.typeImage.image = [UIImage imageNamed:@"我的聊股_发表小图标"];
    /// 设置下方toolBar
    [cell initToolBar];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
  }

  [cell.bottomLineView resetViewWidth:tableView.width];

  /// 设置长按手势
  [self setLongPressGRAtCell:cell andTableView:tableView andIndexPath:indexPath];

  /// 重写取消收藏回调函数，屏蔽默认实现
  cell.cancleCollectBtnBlock = ^(NSNumber *tid) {
  };

  return cell;
}

#pragma mark
#pragma scrollowView拉伸距离
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  if (_scrollViewdelegate &&
      [_scrollViewdelegate respondsToSelector:@selector(homePageChatStockTableViewDidScroll:)]) {
    [_scrollViewdelegate homePageChatStockTableViewDidScroll:scrollView];
  }
}

@end

@implementation HomePageChatStockTableVC

- (void)viewDidLoad {
  [super viewDidLoad];
  [self addObservers];
  [self.littleCattleView setInformation:@"暂无数据"];
  [self.littleCattleView resetFrame:CGRectMake(0, 0, WIDTH_OF_SCREEN, 200)];
}

- (NSDictionary *)getRequestParamertsWithRefreshType:(RefreshType)refreshType {
  NSString *userID = self.userID;
  NSString *fromId = @"0";
  NSString *pageSize = @"20";
  if (refreshType == RefreshTypeLoaderMore) {
    TweetListItem *myChatList = [self.dataArray.array lastObject];
    fromId = [myChatList.timelineid stringValue];
  }
  return @{ @"userID" : userID, @"fromId" : fromId, @"pageSize" : pageSize };
}

/** 请求最新数据，此方法子类必须实现 */
- (void)requestDataListWithRefreshType:(RefreshType)refreshType
                         withDataArray:(DataArray *)existDataList
                          withCallBack:(HttpRequestCallBack *)callback {
  NSDictionary *dic = [self getRequestParamertsWithRefreshType:refreshType];

  [StockTradeList requestNewTalksOfUserId:dic[@"userID"]
                                   fromId:dic[@"fromId"]
                                   reqNum:dic[@"pageSize"]
                             withCallback:callback];
}

/** 返回表格数据适配器，此方法子类必须实现 */
- (BaseTableAdapter *)getBaseTableAdaperWithDataList:(DataArray *)dataList {
  if (_tableAdapter == nil) {
    _tableAdapter = [[HomePageChatStockTableAdapter alloc] initWithTableViewController:self
                                                                         withDataArray:self.dataArray];
    UINib *cellNib = [UINib nibWithNibName:_tableAdapter.nibName bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:_tableAdapter.nibName];

    HomePageChatStockTableAdapter *adapter = (HomePageChatStockTableAdapter *)_tableAdapter;
    adapter.scrollViewdelegate = self.scrollViewdelegate;

    /// 删除聊股时的回调
    __weak HomePageChatStockTableVC *weakSelf = self;
    adapter.clientView = self.clientView;
    adapter.deleteOneCellCallBack = ^(NSNumber *num) {
      if (weakSelf.dataArray.array.count == 0 && weakSelf.dataArray.dataBinded == YES) {
        [weakSelf refreshButtonPressDown];
      }
    };
  }
  return _tableAdapter;
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
    //隐藏下拉刷新
    self.headerView.hidden = YES;
  }
}
- (void)refreshButtonPressDown {
  [self requestResponseWithRefreshType:RefreshTypeRefresh];
}
- (void)requestResponseWithRefreshType:(RefreshType)refreshType {
  [super requestResponseWithRefreshType:refreshType];
  if (refreshType == RefreshTypeHeaderRefresh) {
    if (_homeHeaderRefreshCallBack) {
      _homeHeaderRefreshCallBack();
    }
  }
}


@end
