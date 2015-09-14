//
//  MyChatStockHasSCPTableVC.m
//  SimuStock
//
//  Created by jhss_wyz on 15/7/20.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "MyChatStockHasSCPTableVC.h"
#import "TweetListItem.h"
#import "PraiseTStockData.h"
#import "ReplyViewController.h"
#import "ShareController.h"
#import "MakingScreenShot.h"
#import "FTCoreTextView.h"
#import "WBImageView.h"
#import "UITableView+Reload.h"

@implementation MyChatStockHasSCPTableAdapter

+ (CGFloat)bindRPContentAndRPComtentImageAtCell:(MyChatStockTVCell *)cell
                                   andIndexPath:(NSIndexPath *)indexPath
                                   andTableView:(UITableView *)tableView
                               andTopViewBottom:(CGFloat)topViewBottom
                             andHasUserNameView:(BOOL)hasNameView {
  TweetListItem *item = cell.tweetListItem;
  cell.replayTopBKView.hidden = YES;
  cell.replayBKView.hidden = YES;
  CGFloat cellHeight = topViewBottom + MCSTVCell_Space_Between_RPTopView_Top;
  if (item.type == 2) {
    cell.replayTopBKView.hidden = NO;
    cell.replayBKView.hidden = NO;
    cell.rpTopBKToTimeVS.constant =
        cellHeight - (hasNameView ? MCSTVCell_Time_Bottom_HasUserNameView
                                  : MCSTVCell_Time_Bottom);
    cellHeight += MCSTVCell_Height_RPTopBKView;
    CGFloat replayBKViewHeight = 0.f;

    /// 设置回复内容位置
    if ((item.o_content == nil || [item.o_content isEqualToString:@""])) {
      cell.replayContentView.hidden = YES;
    } else {
      cell.replayContentView.text = item.o_content;

      CGFloat replayContentViewWidth =
          tableView.width -
          (hasNameView ? MCSTVCell_Content_Left_Space_HasUserNameView
                       : MCSTVCell_Content_Left_Space) -
          MCSTVCell_Content_Right_Space -
          MCSTVCell_Space_Between_ReplayBKViewRight_RPContentViewRight -
          MCSTVCell_Space_Between_ReplayBKViewLeft_RPContentViewLeft;
      CGFloat replayContentViewHeight = [MyChatStockHasSCPTableAdapter
          weiboReplayContentHeightWithWeibo:item
                           withContontWidth:replayContentViewWidth];
      cell.rpContentViewHeight.constant = replayContentViewHeight;
      replayBKViewHeight += replayContentViewHeight;
      cellHeight += replayContentViewHeight;

      cell.replayContentView.hidden = NO;
    }

    /// 设置回复图片位置
    if (item.o_imgs && [item.o_imgs count] > 0) {
      cellHeight += MCSTVCell_Space_Between_Content_ContentImage;
      replayBKViewHeight += MCSTVCell_Space_Between_RPContent_RPContentImage;
      cell.rpImageViewToRpBKViewVS.constant = replayBKViewHeight;

      __weak TweetListItem *weakitem = item;
      NSString *imageUrl = item.o_imgs[0];
      UIImage *image = [cell.replayImageView
              loadImageWithUrl:imageUrl
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
      cell.replayImageView.image =
          image ? image : [UIImage imageNamed:@"buttonPressDown"];

      /// 加入回复聊股图片高度
      cellHeight += imageHeight;
      replayBKViewHeight += imageHeight;

      cell.replayImageView.hidden = NO;
    } else {
      cell.replayImageView.hidden = YES;
    }
    cellHeight += MCSTVCell_RPBKView_Bottom_Extra_Height;
    cell.rpBKViewHeight.constant =
        replayBKViewHeight + MCSTVCell_RPBKView_Bottom_Extra_Height;
  }
  return (cellHeight - topViewBottom);
}

- (void)bidButtonTriggersCallbackMethod:(NSInteger)tag row:(NSInteger)row {
  TweetListItem *homeData = self.dataArray.array[row];
  switch (homeData.type) {

  case WeiboTypeOrigianl:
  case WeiboTypeForward: {
    switch (tag) {
    case 7303: { /// 分享
      [self shareWeiBo:row];

    } break;

    case 7300: { /// 评论

      [FullScreenLogonViewController
          checkLoginStatusWithCallBack:^(BOOL isLogined) {
            [self commentWeiBo:row];
          }];
    } break;

    case 7301: { /// 点赞

      [FullScreenLogonViewController
          checkLoginStatusWithCallBack:^(BOOL isLogined) {
            TweetListItem *weibo = self.dataArray.array[row];
            [PraiseTStockData requestPraiseTStockData:weibo];
          }];
    } break;

    default:
      break;
    }
  } break;

  default:
    break;
  }
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
  MyChatStockTVCell *cell = (MyChatStockTVCell *)[tempTV
      cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];

  MakingScreenShot *makingScreenShot = [[MakingScreenShot alloc] init];

  CGRect homeRect = [tempTV
      convertRect:[tempTV rectForRowAtIndexPath:[NSIndexPath indexPathForRow:row
                                                                   inSection:0]]
           toView:self.clientView];
  UIImage *shareImage = [makingScreenShot
      makingScreenShotWithFrame:homeRect
                       withView:cell.contentView
                       withType:MakingScreenShotType_TradePage];
  [[[ShareController alloc] init] shareWeibo:homeData
                              withShareImage:shareImage];
}

/** 评论微博 */
- (void)commentWeiBo:(NSInteger)row {
  UITableView *tempTV = self.baseTableViewController.tableView;
  MyChatStockTVCell *cell = (MyChatStockTVCell *)[tempTV
      cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
  TweetListItem *homeData = self.dataArray.array[row];
  ReplyViewController *replyVC = [[ReplyViewController alloc]
      initWithTstockID:[homeData.tstockid stringValue]
           andCallBack:^(TweetListItem *item) {
             //评论数+1
             [cell.commentBtn
                 setTitle:[NSString stringWithFormat:@"%ld",
                                                     (long)(++homeData.comment)]
                 forState:UIControlStateNormal];
           }];
  [AppDelegate pushViewControllerFromRight:replyVC];
}

@end

@implementation MyChatStockHasSCPTableVC {
  __weak id observerShare;
  __weak id observerPraise;
  __weak id observerComment;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:observerShare];
  [[NSNotificationCenter defaultCenter] removeObserver:observerPraise];
  [[NSNotificationCenter defaultCenter] removeObserver:observerComment];
}

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)addObservers {

  observerShare = [[NSNotificationCenter defaultCenter]
      addObserverForName:ShareWeiboSuccessNotification
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
                    if (weiboItem.tstockid.longLongValue ==
                        homeData.tstockid.longLongValue) {
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
                    if (weiboItem.tstockid.longLongValue ==
                        homeData.tstockid.longLongValue) {
                      weiboItem.comment =
                          weiboItem.comment + [userInfo[@"operation"] intValue];
                      [self.tableView reloadData];
                      break;
                    }
                  }
                }
              }];
}

@end
