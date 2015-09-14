//
//  MyChatStockTableVC.m
//  SimuStock
//
//  Created by jhss_wyz on 15/7/15.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "MyChatStockTableVC.h"
#import "TweetListItem.h"
#import "FTCoreTextView.h"
#import "WBDetailsViewController.h"
#import "UITableView+Reload.h"
#import "SimuScreenAdapter.h"

@implementation MyChatStockTableAdapter

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.dataArray.array count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  [self tableView:tableView didDeselectRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {

  TweetListItem *homeData = self.dataArray.array[indexPath.row];
  switch (homeData.type) {

  case WeiboTypeOrigianl: { /// 原创，没回复
    [WBDetailsViewController showTSViewWithTStockId:@([homeData.tstockid longLongValue])];
  } break;

  case WeiboTypeForward: { /// 转发（有回复）

    [WBDetailsViewController showTSViewWithTStockId:@([homeData.tstockid longLongValue])];
  } break;

  case WeiboTypeComment: { /// 评论
    [WBDetailsViewController showTSViewWithTStockId:@([homeData.tweetId longLongValue])];
  } break;
  default:
    break;
  }
  return;
}

/** 删除某一条聊股数据（删除或者取消收藏都会触发） */
- (void)tableView:(UITableView *)tableView
       delateCell:(NSNumber *)tid
            atRow:(NSInteger)row
          andType:(MyChatStockDeleteCellType)deleteType {
  NSInteger i = 0;
  for (TweetListItem *homeData in self.dataArray.array) {
    if (homeData.tstockid.longLongValue == tid.longLongValue) {
      //数据源、tableView中删除该对象
      [self.dataArray.array removeObjectAtIndex:i];
      break;
    }
    i++;
  }
  [tableView reloadData];
  if (deleteType == MyChatStockDelete) {
    if (self.deleteOneCellCallBack) {
      self.deleteOneCellCallBack(@(row));
    }
  } else if (deleteType == MyChatStockCancleCollect) {
    if (self.cancleCollectCallBack) {
      self.cancleCollectCallBack(@(row));
    }
  }
}

/** 设置左侧时间线 */
+ (void)setTimeLineInCell:(MyChatStockTVCell *)cell
                   andRow:(NSInteger)row
                  andData:(DataArray *)dataArray {
  cell.timeLineDown.hidden = NO;
  cell.timeLineUp.hidden = NO;
  cell.bottomLineView.hidden = NO;
  if ((dataArray.array.count == (row + 1)) && (dataArray.dataComplete)) {
    cell.timeLineDown.hidden = YES;
    cell.bottomLineView.hidden = YES;
  }
  if (row == 0) {
    cell.timeLineUp.hidden = YES;
  }
}

/** 绑定聊股标题、聊股内容、聊股图片数据 */
+ (CGFloat)bindTittleAndContentAndContentImageAtCell:(MyChatStockTVCell *)cell
                                        andIndexPath:(NSIndexPath *)indexPath
                                    andTopViewBottom:(CGFloat)bottom
                                        andTableView:(UITableView *)tableView
                                  andHasUserNameView:(BOOL)hasNameView {
  TweetListItem *item = cell.tweetListItem;
  CGFloat cellHeight = bottom;
  CGFloat height = 0.f;
  cell.tittleLabel.width = WIDTH_OF_SCREEN - 52;
  if (item.title == nil || [@"" isEqualToString:item.title]) {
    cell.tittleLabel.hidden = YES;
  } else {
    cell.tittleLabel.text = item.title;

    cell.tittleLabel.backgroundColor = [UIColor clearColor];
    cell.tittleLabel.hidden = NO;

    [cell.tittleLabel fitToSuggestedHeight];
    CGFloat titleheight = cell.tittleLabel.height;
    cell.tittleLabelHeight.constant = titleheight;

    cell.tittleToTimeVS.constant =
        cellHeight - (hasNameView ? MCSTVCell_Time_Bottom_HasUserNameView : MCSTVCell_Time_Bottom);
    /// 加入聊股标题高度
    cellHeight += titleheight + MCSTVCell_Space_Between_Tittle_Content;
    height += titleheight + MCSTVCell_Space_Between_Tittle_Content;
  }
  height += [MyChatStockTableAdapter bindContentAndContentImageAtCell:cell
                                                         andIndexPath:indexPath
                                                     andTopViewBottom:cellHeight
                                                         andTableView:tableView
                                                   andHasUserNameView:hasNameView];

  return height;
}

/** 绑定聊股内容及聊股图片数据 */
+ (CGFloat)bindContentAndContentImageAtCell:(MyChatStockTVCell *)cell
                               andIndexPath:(NSIndexPath *)indexPath
                           andTopViewBottom:(CGFloat)bottom
                               andTableView:(UITableView *)tableView
                         andHasUserNameView:(BOOL)hasNameView {
  TweetListItem *item = cell.tweetListItem;
  CGFloat cellHeight = bottom;
  CGFloat height = 0.f;
  if (item.content == nil || [@"" isEqualToString:item.content]) {
    cell.contentLabel.hidden = YES;
  } else {
    cell.contentLabel.text = item.content;
    cell.contentLabel.backgroundColor = [UIColor clearColor];
    cell.contentLabel.hidden = NO;
    [cell.contentLabel fitToSuggestedHeight];
    cell.contentLabelHeight.constant = cell.contentLabel.frame.size.height;
    CGFloat contentLableWidth = tableView.width - (hasNameView ? MCSTVCell_Content_Left_Space_HasUserNameView
                                                               : MCSTVCell_Content_Left_Space) -
                                MCSTVCell_Content_Right_Space;
    CGFloat contentHight = [MyChatStockTableAdapter weiboContentHeightWithWeibo:item
                                                               withContontWidth:contentLableWidth];
    cell.contentToTimeVS.constant =
        cellHeight - (hasNameView ? MCSTVCell_Time_Bottom_HasUserNameView : MCSTVCell_Time_Bottom);
    /// 加入聊股内容高度
    cellHeight += contentHight;
    height += contentHight;
  }

  if (item.imgs && [item.imgs count] > 0) {
    cellHeight += MCSTVCell_Space_Between_Content_ContentImage;
    height += MCSTVCell_Space_Between_Content_ContentImage;

    __weak TweetListItem *weakWeibo = item;
    NSString *imageUrl = item.imgs[0];
    UIImage *image = [cell.contentImage loadImageWithUrl:item.imgs[0]
                                    onImageReadyCallback:^(UIImage *downloadImage, NSString *imageUrl) {
                                      if (downloadImage) {
                                        [weakWeibo.heightCache removeObjectForKey:HeightCacheKeyAll];
                                        [tableView reloadVisibleRowWithIndexPath:indexPath];
                                      }
                                    }];
    CGFloat imageWidth = image ? image.size.width / ThumbnailFactor : 114.f;
    CGFloat imageHeight = image ? image.size.height / ThumbnailFactor : 114.f;
    if (image) {
      item.heightCache[imageUrl] = @(imageHeight);
    }

    cell.contentImageWidth.constant = imageWidth;
    cell.contentImageHeight.constant = imageHeight;

    cell.contentImage.image = image ? image : [UIImage imageNamed:@"buttonPressDown"];

    /// 加入聊股图片高度
    cell.contentImageToTimeVS.constant =
        cellHeight - (hasNameView ? MCSTVCell_Time_Bottom_HasUserNameView : MCSTVCell_Time_Bottom);
    cellHeight += imageHeight;
    height += imageHeight;
    cell.contentImage.hidden = NO;
  } else {
    cell.contentImage.hidden = YES;
  }
  return height;
}

/** cell长按手势的设定 */
- (void)setLongPressGRAtCell:(MyChatStockTVCell *)cell
                andTableView:(UITableView *)tableView
                andIndexPath:(NSIndexPath *)indexPath {
  TweetListItem *homeData = cell.tweetListItem;
  if (1 == homeData.type || 2 == homeData.type || 3 == homeData.type) {
    cell.longPressGR.enabled = YES;
    /// 长按手势_删除_设置block回调
    __weak MyChatStockTableAdapter *weakSelf = self;
    cell.deleteBtnBlock = ^(NSNumber *tid) {
      [weakSelf tableView:tableView delateCell:tid atRow:indexPath.row andType:MyChatStockDelete];
    };
    /// 长按手势_取消收藏_设置block回调
    cell.cancleCollectBtnBlock = ^(NSNumber *tid) {
      [weakSelf tableView:tableView
               delateCell:tid
                    atRow:indexPath.row
                  andType:MyChatStockCancleCollect];
    };
  } else {
    cell.longPressGR.enabled = NO;
  }
}

/** 返回聊股标题、聊股内容、聊股图片的高度 */
+ (CGFloat)getTitleAndContentAndImageHeightWithWeibo:(TweetListItem *)item
                                     andContontWidth:(CGFloat)contentWidth {
  CGFloat cellHeight = 0.f;
  if (item.title && ![item.title isEqualToString:@""]) {
    CGFloat titleHight =
        [MyChatStockTableAdapter weiboTitleHeightWithWeibo:item withContontWidth:contentWidth];
    cellHeight += titleHight + MCSTVCell_Space_Between_Tittle_Content;
  }
  cellHeight +=
      [MyChatStockTableAdapter getContentAndImageHeightWithWeibo:item andContontWidth:contentWidth];
  return cellHeight;
}

/** 返回聊股内容和聊股图片的高度 */
+ (CGFloat)getContentAndImageHeightWithWeibo:(TweetListItem *)item
                             andContontWidth:(CGFloat)contentWidth {
  CGFloat cellHeight = 0.f;
  if (item.content) {
    CGFloat contentHight =
        [MyChatStockTableAdapter weiboContentHeightWithWeibo:item withContontWidth:contentWidth];
    cellHeight += contentHight;
  }

  if (item.imgs && item.imgs.count > 0) {
    NSNumber *imageHeight = [ImageUtil imageHeightFromUrl:item.imgs[0] withWeibo:item];
    cellHeight += MCSTVCell_Space_Between_Content_ContentImage + [imageHeight doubleValue];
  }
  return cellHeight;
}

/** 返回聊股标题高度*/
+ (CGFloat)weiboTitleHeightWithWeibo:(TweetListItem *)weibo withContontWidth:(CGFloat)contentWidth {
  if (weibo.heightCache[HeightCacheKeyTitle]) {
    return [weibo.heightCache[HeightCacheKeyTitle] doubleValue];
  }
  CGFloat titleHeight =
      [FTCoreTextView heightWithText:weibo.title width:contentWidth font:CHAT_STOCK_TITTLE_FONT];
  weibo.heightCache[HeightCacheKeyTitle] = @(titleHeight);
  return titleHeight;
}

/** 返回聊股内容高度*/
+ (CGFloat)weiboContentHeightWithWeibo:(TweetListItem *)weibo
                      withContontWidth:(CGFloat)contentWidth {
  if (weibo.heightCache[HeightCacheKeyContent]) {
    return [weibo.heightCache[HeightCacheKeyContent] doubleValue];
  }
  CGFloat contentHeight =
      [FTCoreTextView heightWithText:weibo.content width:contentWidth font:CHAT_STOCK_CONTENT_FONT];
  weibo.heightCache[HeightCacheKeyContent] = @(contentHeight);
  return contentHeight;
}

/** 返回转发聊股内容高度*/
+ (CGFloat)weiboReplayContentHeightWithWeibo:(TweetListItem *)weibo
                            withContontWidth:(CGFloat)contentWidth {
  if (weibo.heightCache[HeightCacheKeySourceContent]) {
    return [weibo.heightCache[HeightCacheKeySourceContent] doubleValue];
  }
  CGFloat o_contentHeight =
      [FTCoreTextView heightWithText:weibo.o_content width:contentWidth font:CHAT_STOCK_REPLY_CONTENT_FONT];
  weibo.heightCache[HeightCacheKeySourceContent] = @(o_contentHeight);
  return o_contentHeight;
}

@end

@implementation MyChatStockTableVC

- (void)viewDidLoad {
  [super viewDidLoad];
  self.showTableFooter = YES;
}

/** 判断返回数据是否非法，此方法子类必须实现 */
- (BOOL)isDataValidWithResponseObject:(NSObject<Collectionable> *)latestData
                withRequestParameters:(NSDictionary *)parameters
                      withRefreshType:(RefreshType)refreshType {
  if (refreshType == RefreshTypeLoaderMore) {
    NSString *fromId = parameters[@"fromId"];
    TweetListItem *lastInfo = (TweetListItem *)[self.dataArray.array lastObject];
    NSString *lastId = [lastInfo.timelineid stringValue];
    if (![fromId isEqualToString:lastId]) {
      return NO;
    }
  }
  return YES;
}

- (NSDictionary *)getRequestParamertsWithRefreshType:(RefreshType)refreshType {
  NSString *userID = [SimuUtil getUserID];
  NSString *fromId = @"0";
  NSString *pageSize = @"20";
  if (refreshType == RefreshTypeLoaderMore) {
    TweetListItem *myChatList = [self.dataArray.array lastObject];
    fromId = [myChatList.timelineid stringValue];
  }
  return @{ @"userID" : userID, @"fromId" : fromId, @"pageSize" : pageSize };
}

- (BOOL)supportAutoLoadMore {
  return YES;
}

- (void)refreshButtonPressDown {
  [self requestResponseWithRefreshType:RefreshTypeRefresh];
}

@end
