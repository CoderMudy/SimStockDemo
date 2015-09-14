//
//  ChatStockPageBaseTVC.m
//  SimuStock
//
//  Created by jhss_wyz on 15/7/21.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "ChatStockPageBaseTVC.h"
#import "TweetListItem.h"
#import "FTCoreTextView.h"
#import "WBDetailsViewController.h"
#import "UITableView+Reload.h"
#import "PraiseTStockData.h"
#import "ReplyViewController.h"
#import "ShareController.h"
#import "MakingScreenShot.h"
#import "SimuScreenAdapter.h"

@implementation ChatStockPageBaseTableAdapter

- (NSString *)nibName {
  static NSString *nibFileName;
  if (nibFileName == nil) {
    nibFileName = @"ChatStockPageTVCell";
  }
  return nibFileName;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.dataArray.array count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  [self tableView:tableView didDeselectRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row > self.dataArray.array.count) {
    return;
  }
  TweetListItem *item = self.dataArray.array[indexPath.row];
  if (item.tstockid) {
    [WBDetailsViewController showTSViewWithTStockId:item.tstockid];
  }
  return;
}

/** 删除某一条聊股数据（删除或者取消收藏都会触发） */
- (void)tableView:(UITableView *)tableView
       delateCell:(NSNumber *)tid
            atRow:(NSInteger)row
          andType:(ChatStockPageDeleteCellType)deleteType {
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
  if (deleteType == ChatStockPageDelete) {
    if (self.deleteOneCellCallBack) {
      self.deleteOneCellCallBack(@(row));
    }
  } else if (deleteType == ChatStockPageCancleCollect) {
    if (self.cancleCollectCallBack) {
      self.cancleCollectCallBack(@(row));
    }
  }
}

/** 绑定聊股标题、聊股内容、聊股图片数据 */
+ (CGFloat)bindTittleAndContentAndContentImageAtCell:(ChatStockPageTVCell *)cell
                                        andIndexPath:(NSIndexPath *)indexPath
                                    andTopViewBottom:(CGFloat)bottom
                                        andTableView:(UITableView *)tableView
                                  andHasUserNameView:(BOOL)hasNameView {
  TweetListItem *item = cell.tweetListItem;
  CGFloat cellHeight = bottom;
  CGFloat height = 0.f;
  if (item.title == nil || [@"" isEqualToString:item.title]) {
    cell.tittleLabel.hidden = YES;
  } else {
    cell.tittleLabel.text = item.title;

    cell.tittleLabel.backgroundColor = [UIColor clearColor];
    cell.tittleLabel.hidden = NO;

    [cell.tittleLabel fitToSuggestedHeight];
    CGFloat titleheight = cell.tittleLabel.height;
    cell.tittleLabelHeight.constant = titleheight;

    cell.tittleToTimeVS.constant = cellHeight - CSPTVCell_Time_Bottom_HasUserNameView;
    /// 加入聊股标题高度
    cellHeight += titleheight + CSPTVCell_Space_Between_Tittle_Content;
    height += titleheight + CSPTVCell_Space_Between_Tittle_Content;
  }
  height += [ChatStockPageBaseTableAdapter bindContentAndContentImageAtCell:cell
                                                               andIndexPath:indexPath
                                                           andTopViewBottom:cellHeight
                                                               andTableView:tableView
                                                         andHasUserNameView:hasNameView];

  return height;
}

/** 绑定聊股内容及聊股图片数据 */
+ (CGFloat)bindContentAndContentImageAtCell:(ChatStockPageTVCell *)cell
                               andIndexPath:(NSIndexPath *)indexPath
                           andTopViewBottom:(CGFloat)bottom
                               andTableView:(UITableView *)tableView
                         andHasUserNameView:(BOOL)hasNameView {
  TweetListItem *item = cell.tweetListItem;
  CGFloat cellHeight = bottom;
  CGFloat height = 0.f;
  /// 设置加精
  cell.eliteImageView.hidden = !item.elite;
  /// 设置聊股内容
  if (item.content == nil || [@"" isEqualToString:item.content]) {
    cell.contentLabel.hidden = YES;
  } else {
    cell.contentLabel.text = item.content;
    cell.contentLabel.backgroundColor = [UIColor clearColor];
    cell.contentLabel.hidden = NO;
    CGFloat contentLabelWidth = tableView.width - CSPTVCell_Content_Left_Space - CSPTVCell_Content_Right_Space;
    CGFloat contentHight = [ChatStockPageBaseTableAdapter weiboContentHeightWithWeibo:item
                                                                     withContontWidth:contentLabelWidth];
    cell.contentLabelHeight.constant = contentHight;
    cell.contentToTimeVS.constant = cellHeight - CSPTVCell_Time_Bottom_HasUserNameView;
    /// 加入聊股内容高度
    cellHeight += contentHight;
    height += contentHight;
  }
  /// 设置聊股图片
  if (item.imgs && [item.imgs count] > 0) {
    cellHeight += CSPTVCell_Space_Between_Content_ContentImage;
    height += CSPTVCell_Space_Between_Content_ContentImage;

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
    cell.contentImageToTimeVS.constant = cellHeight - CSPTVCell_Time_Bottom_HasUserNameView;
    cellHeight += imageHeight;
    height += imageHeight;
    cell.contentImage.hidden = NO;
  } else {
    cell.contentImage.hidden = YES;
  }
  return height;
}

+ (CGFloat)bindRPContentAndRPComtentImageAtCell:(ChatStockPageTVCell *)cell
                                   andIndexPath:(NSIndexPath *)indexPath
                                   andTableView:(UITableView *)tableView
                               andTopViewBottom:(CGFloat)topViewBottom
                             andHasUserNameView:(BOOL)hasNameView {
  TweetListItem *item = cell.tweetListItem;
  cell.replayTopBKView.hidden = YES;
  cell.replayBKView.hidden = YES;
  CGFloat cellHeight = topViewBottom + CSPTVCell_Space_Between_RPTopView_Top;
  if (item.type == 2) {
    cell.replayTopBKView.hidden = NO;
    cell.replayBKView.hidden = NO;
    cell.rpTopBKToTimeVS.constant = cellHeight - CSPTVCell_Time_Bottom_HasUserNameView;
    cellHeight += CSPTVCell_Height_RPTopBKView;
    CGFloat replayBKViewHeight = 0.f;

    /// 设置回复内容位置
    if ((item.o_content == nil || [item.o_content isEqualToString:@""])) {
      cell.replayContentView.hidden = YES;
    } else {
      cell.replayContentView.text = item.o_content;

      CGFloat replayContentLabelWidth = tableView.width - CSPTVCell_Content_Left_Space -
                                        CSPTVCell_Content_Right_Space -
                                        CSPTVCell_Space_Between_ReplayBKViewRight_RPContentViewRight -
                                        CSPTVCell_Space_Between_ReplayBKViewLeft_RPContentViewLeft;
      CGFloat replayContentViewHeight =
          [ChatStockPageBaseTableAdapter weiboReplayContentHeightWithWeibo:item
                                                          withContontWidth:replayContentLabelWidth];
      cell.rpContentViewHeight.constant = replayContentViewHeight;
      replayBKViewHeight += replayContentViewHeight;
      cellHeight += replayContentViewHeight;
      cell.replayContentView.hidden = NO;
    }

    /// 设置回复图片位置
    if (item.o_imgs && [item.o_imgs count] > 0) {
      cellHeight += CSPTVCell_Space_Between_Content_ContentImage;
      replayBKViewHeight += CSPTVCell_Space_Between_RPContent_RPContentImage;
      cell.rpImageViewToRpBKViewVS.constant = replayBKViewHeight;

      __weak TweetListItem *weakitem = item;
      NSString *imageUrl = item.o_imgs[0];
      UIImage *image = [cell.replayImageView loadImageWithUrl:imageUrl
                                         onImageReadyCallback:^(UIImage *downloadImage, NSString *imageUrl) {
                                           if (downloadImage) {
                                             [weakitem.heightCache removeObjectForKey:HeightCacheKeyAll];
                                             [tableView reloadVisibleRowWithIndexPath:indexPath];
                                           }
                                         }];
      CGFloat imageWidth = image ? image.size.width / ThumbnailFactor : 114.f;
      CGFloat imageHeight = image ? image.size.height / ThumbnailFactor : 114.f;
      if (image) {
        item.heightCache[imageUrl] = @(imageHeight);
      }
      cell.rpImageViewHeight.constant = imageHeight;
      cell.rpImageViewWidth.constant = imageWidth;
      cell.replayImageView.image = image ? image : [UIImage imageNamed:@"buttonPressDown"];

      /// 加入回复聊股图片高度
      cellHeight += imageHeight;
      replayBKViewHeight += imageHeight;

      cell.replayImageView.hidden = NO;
    } else {
      cell.replayImageView.hidden = YES;
    }
    cellHeight += CSPTVCell_RPBKView_Bottom_Extra_Height;
    cell.rpBKViewHeight.constant = replayBKViewHeight + CSPTVCell_RPBKView_Bottom_Extra_Height;
  }
  return (cellHeight - topViewBottom);
}

- (void)bidButtonTriggersCallbackMethod:(NSInteger)tag row:(NSInteger)row {
  TweetListItem *homeData = self.dataArray.array[row];
  if (!homeData.tstockid) {
    return;
  }
  switch (homeData.type) {

  case WeiboTypeOrigianl:
  case WeiboTypeForward: {
    switch (tag) {
    case 7303: { /// 分享
      [self shareWeiBo:row];

    } break;

    case 7300: { /// 评论
      [FullScreenLogonViewController checkLoginStatusWithCallBack:^(BOOL isLogined) {
        [self commentWeiBo:row];
      }];
    } break;
    case 7301: { /// 点赞
      [self praiseForWeibo:row];
    } break;

    default:
      break;
    }
  } break;

  default:
    break;
  }
}

/** 点赞 */
- (void)praiseForWeibo:(NSInteger)indext {
  [FullScreenLogonViewController checkLoginStatusWithCallBack:^(BOOL isLogined) {
    TweetListItem *weibo = self.dataArray.array[indext];
    [PraiseTStockData requestPraiseTStockData:weibo];
  }];
}

/** 分享微博 */
- (void)shareWeiBo:(NSInteger)row {
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }
  TweetListItem *homeData = self.dataArray.array[row];
  UITableView *tempTV = self.baseTableViewController.tableView;
  /// 分享
  ChatStockPageTVCell *cell = (ChatStockPageTVCell *)
      [tempTV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];

  MakingScreenShot *makingScreenShot = [[MakingScreenShot alloc] init];

  CGRect homeRect = [tempTV
      convertRect:[tempTV rectForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]]
           toView:self.clientView];
  UIImage *shareImage = [makingScreenShot makingScreenShotWithFrame:homeRect
                                                           withView:cell.contentView
                                                           withType:MakingScreenShotType_HomePage];
  [[[ShareController alloc] init] shareWeibo:homeData withShareImage:shareImage];
}

/** 评论微博 */
- (void)commentWeiBo:(NSInteger)row {

  UITableView *tempTV = self.baseTableViewController.tableView;
  ChatStockPageTVCell *cell = (ChatStockPageTVCell *)
      [tempTV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
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

/** cell长按手势的设定 */
- (void)setLongPressGRAtCell:(ChatStockPageTVCell *)cell
                andTableView:(UITableView *)tableView
                andIndexPath:(NSIndexPath *)indexPath {
  TweetListItem *homeData = cell.tweetListItem;
  if (1 == homeData.type || 2 == homeData.type || 3 == homeData.type) {
    cell.longPressGR.enabled = YES;
    /// 长按手势_删除_设置block回调
    __weak ChatStockPageBaseTableAdapter *weakSelf = self;
    cell.deleteBtnBlock = ^(NSNumber *tid) {
      [weakSelf tableView:tableView delateCell:tid atRow:indexPath.row andType:ChatStockPageDelete];
    };
    /// 长按手势_取消收藏_设置block回调
    cell.cancleCollectBtnBlock = ^(NSNumber *tid) {
      [weakSelf tableView:tableView
               delateCell:tid
                    atRow:indexPath.row
                  andType:ChatStockPageCancleCollect];
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
    CGFloat titleHight = [ChatStockPageBaseTableAdapter weiboTitleHeightWithWeibo:item
                                                                 withContontWidth:contentWidth];
    cellHeight += titleHight + CSPTVCell_Space_Between_Tittle_Content;
  }
  cellHeight += [ChatStockPageBaseTableAdapter getContentAndImageHeightWithWeibo:item
                                                                 andContontWidth:contentWidth];
  return cellHeight;
}

/** 返回聊股内容和聊股图片的高度 */
+ (CGFloat)getContentAndImageHeightWithWeibo:(TweetListItem *)item
                             andContontWidth:(CGFloat)contentWidth {
  CGFloat cellHeight = 0.f;
  if (item.content) {
    CGFloat contentHight = [ChatStockPageBaseTableAdapter weiboContentHeightWithWeibo:item
                                                                     withContontWidth:contentWidth];
    cellHeight += contentHight;
  }

  if (item.imgs && item.imgs.count > 0) {
    NSNumber *imageHeight = [ImageUtil imageHeightFromUrl:item.imgs[0] withWeibo:item];
    cellHeight += CSPTVCell_Space_Between_Content_ContentImage + [imageHeight doubleValue];
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
  CGFloat o_contentHeight = [FTCoreTextView heightWithText:weibo.o_content
                                                     width:contentWidth
                                                      font:CHAT_STOCK_REPLY_CONTENT_FONT];
  weibo.heightCache[HeightCacheKeySourceContent] = @(o_contentHeight);
  return o_contentHeight;
}

/** 设置左侧时间线 */
- (void)resetBottomLineViewInCell:(ChatStockPageTVCell *)cell
                           andRow:(NSInteger)row
                          andData:(DataArray *)dataArray {
  cell.bottomLineView.hidden = NO;
  if ((dataArray.array.count == (row + 1)) && (dataArray.dataComplete)) {
    cell.bottomLineView.hidden = YES;
  }
};

@end

@implementation ChatStockPageBaseTVC {
  __weak id observerShare;
  __weak id observerPraise;
  __weak id observerComment;
  __weak id observerLogonSuccess;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:observerShare];
  [[NSNotificationCenter defaultCenter] removeObserver:observerPraise];
  [[NSNotificationCenter defaultCenter] removeObserver:observerComment];
  [[NSNotificationCenter defaultCenter] removeObserver:observerLogonSuccess];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.littleCattleView setInformation:@"暂无数据"];
  [self addObservers];
  self.showTableFooter = YES;
}

- (BOOL)supportAutoLoadMore {
  return YES;
}

- (void)refreshButtonPressDown {
  [self requestResponseWithRefreshType:RefreshTypeRefresh];
}

- (void)addObservers {

  observerShare =
      [[NSNotificationCenter defaultCenter] addObserverForName:ShareWeiboSuccessNotification
                                                        object:nil
                                                         queue:[NSOperationQueue mainQueue]
                                                    usingBlock:^(NSNotification *notif) {
                                                      NSDictionary *userInfo = [notif userInfo];
                                                      TweetListItem *homeData = userInfo[@"data"];
                                                      if (homeData) {
                                                        for (int i = 0; i < self.dataArray.array.count; i++) {
                                                          TweetListItem *weiboItem = self.dataArray.array[i];
                                                          if (weiboItem.tstockid.longLongValue ==
                                                              homeData.tstockid.longLongValue) {
                                                            weiboItem.share = weiboItem.share + 1;
                                                            [self.tableView reloadData];
                                                            break;
                                                          }
                                                        }
                                                      }
                                                    }];

  observerPraise = [[NSNotificationCenter defaultCenter]
      addObserverForName:PraiseWeiboSuccessNotification
                  object:nil
                   queue:[NSOperationQueue mainQueue]
              usingBlock:^(NSNotification *notif) {
                NSDictionary *userInfo = [notif userInfo];
                TweetListItem *homeData = userInfo[@"data"];
                if (homeData) {
                  for (int i = 0; i < self.dataArray.array.count; i++) {
                    TweetListItem *weiboItem = self.dataArray.array[i];
                    if (weiboItem.tstockid.longLongValue == homeData.tstockid.longLongValue) {
                      weiboItem.praise += 1;
                      weiboItem.isPraised = YES;
                      [NewShowLabel setMessageContent:@"赞成功"];

                      [self.tableView reloadData];
                      break;
                    }
                  }
                }
              }];
  observerComment = [[NSNotificationCenter defaultCenter]
      addObserverForName:CommentWeiboSuccessNotification
                  object:nil
                   queue:[NSOperationQueue mainQueue]
              usingBlock:^(NSNotification *notif) {
                NSDictionary *userInfo = [notif userInfo];
                TweetListItem *homeData = userInfo[@"data"];
                if (homeData) {
                  for (int i = 0; i < self.dataArray.array.count; i++) {
                    TweetListItem *weiboItem = self.dataArray.array[i];
                    if (weiboItem.tstockid.longLongValue == homeData.tstockid.longLongValue) {
                      weiboItem.comment = weiboItem.comment + [userInfo[@"operation"] intValue];
                      [self.tableView reloadData];
                      break;
                    }
                  }
                }
              }];
  observerLogonSuccess = [[NSNotificationCenter defaultCenter] addObserverForName:LogonSuccess
                                                                           object:nil
                                                                            queue:[NSOperationQueue mainQueue]
                                                                       usingBlock:^(NSNotification *note) {
                                                                         [self.tableView reloadData];
                                                                       }];
}

- (void)setClientView:(UIView *)clientView {
  _clientView = clientView;
  ChatStockPageBaseTableAdapter *tableAdapter = (ChatStockPageBaseTableAdapter *)_tableAdapter;
  tableAdapter.clientView = _clientView;
}

@end
