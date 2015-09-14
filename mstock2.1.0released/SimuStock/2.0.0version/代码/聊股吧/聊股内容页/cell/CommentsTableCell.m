//
//  CommentsTableCell.m
//  SimuStock
//
//  Created by Jhss on 15/7/30.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "CommentsTableCell.h"
#import "UITableView+Reload.h"
#import "HomepageViewController.h"
#import "WeiBoExtendButtons.h"
#import "UIImage+ColorTransformToImage.h"
#import "SimuScreenAdapter.h"

@implementation CommentsTableCell

- (void)awakeFromNib {
  //设置聊股内容
  [self.contentLabel setTextColor:[Globle colorFromHexRGB:Color_Icon_Title]];
  [self.replayContentView setTextColor:[Globle colorFromHexRGB:Color_Icon_Title]];
  [self.contentLabel setTextSize:WB_DETAILS_CONTENT_FONT];

  //回复框的背景色
  //评论中图片
  UITapGestureRecognizer *commentConGes =
      [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCommentCon)];
  commentConGes.numberOfTouchesRequired = 1;
  commentConGes.numberOfTapsRequired = 1;
  [self.contentImage addGestureRecognizer:commentConGes];
  //回复中昵称
  UITapGestureRecognizer *relayNickGes =
      [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickRelayNick)];
  relayNickGes.numberOfTapsRequired = 1;
  relayNickGes.numberOfTouchesRequired = 1;
  [self.userNameView addGestureRecognizer:relayNickGes];
  //回复按钮的高亮状态
  [self.relayButton setBackgroundImage:[UIImage imageFromView:self.relayButton
                                           withBackgroundColor:[Globle colorFromHexRGB:@"#dee0e1"]]
                              forState:UIControlStateHighlighted];

  // ftcoretextview可交互
  self.contentLabel.userInteractionEnabled = YES;
  self.replayContentView.userInteractionEnabled = YES;

  //回复框圆边
  [self.replayBKView.layer setMasksToBounds:YES];
  [self.replayBKView.layer setCornerRadius:2.5f];

  //长按按钮
  self.longPress =
      [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cellClickAction:)];
  [self addGestureRecognizer:self.longPress];
}
//改变cell的高亮颜色
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
  if (highlighted) {
    self.backgroundColor = [Globle colorFromHexRGB:@"d9d9d9"];
  } else {
    self.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  }
}
//长按出现拓展按钮
- (void)cellClickAction:(UILongPressGestureRecognizer *)gesture {
  //长按位置
  if (gesture.state == UIGestureRecognizerStateBegan) {
    CGPoint loc = [gesture locationInView:[[UIApplication sharedApplication].delegate window]];
    if ([SimuUtil isLogined]) {
      //必须每次长按时指向block，否则会被cell复用机制覆盖掉
      [self setExtendButtonsBlock];
      //显示拓展按钮
      [WeiBoExtendButtons showButtonWithTweetListItem:self.tweetListItem offsetY:loc.y cell:self];
    }
  }
}
#pragma mark 设置拓展按钮的block
- (void)setExtendButtonsBlock {
  //实现拓展按钮block
  WeiBoExtendButtons *extendButtons = [WeiBoExtendButtons sharedExtendButtons];
  //删除按钮
  [extendButtons setExtendDeleteButtonClickBlock:^(NSNumber *tid, NSObject *cell) {
    CommentsTableCell *strongCell = (CommentsTableCell *)cell;
    if (strongCell.deleteBtnBlock) {
      strongCell.deleteBtnBlock(tid);
    }
  }];
}
/** 点击图片的方法，需要进行适配 */
- (void)clickCommentCon {
  NSLog(@"commentImageView click");
}
- (void)clickRelayNick {
  [HomepageViewController showWithUserId:[self.tweetListItem.o_uid stringValue]
                               titleName:self.relayUserNameView.text
                                 matchId:@"1"];
}
/** 返回聊股标题、聊股内容、聊股图片的高度 */
+ (CGFloat)getTitleAndContentAndImageHeightWithWeibo:(TweetListItem *)item
                                     andContontWidth:(CGFloat)contentWidth {
  CGFloat cellHeight = 0.f;
  cellHeight += [self getContentAndImageHeightWithWeibo:item andContontWidth:contentWidth];
  return cellHeight;
}

/** 返回聊股内容和聊股图片的高度 */
+ (CGFloat)getContentAndImageHeightWithWeibo:(TweetListItem *)item
                             andContontWidth:(CGFloat)contentWidth {
  CGFloat cellHeight = 0.f;
  if (item.content) {
    CGFloat contentHight = [self weiboContentHeightWithWeibo:item withContontWidth:contentWidth];
    cellHeight += contentHight;
  }

  if (item.imgs && item.imgs.count > 0) {
    NSNumber *imageHeight = [ImageUtil imageHeightFromUrl:item.imgs[0] withWeibo:item];
    cellHeight += Space_Between_Content_ContentImage + [imageHeight doubleValue];
  }
  return cellHeight;
}
/** 返回聊股内容高度*/
+ (CGFloat)weiboContentHeightWithWeibo:(TweetListItem *)weibo
                      withContontWidth:(CGFloat)contentWidth {
  if (weibo.heightCache[HeightCacheKeyContent]) {
    return [weibo.heightCache[HeightCacheKeyContent] doubleValue];
  }
  CGFloat contentHeight =
      [FTCoreTextView heightWithText:weibo.content width:contentWidth font:WB_DETAILS_CONTENT_FONT];
  weibo.heightCache[HeightCacheKeyContent] = @(contentHeight);
  return contentHeight;
}
/** 设置左侧时间线 */
+ (void)setTimeLineInCell:(CommentsTableCell *)cell
                   andRow:(NSInteger)row
                  andData:(DataArray *)dataArray {
  cell.timeLineDown.hidden = NO;
  cell.timeLineUp.hidden = NO;
  if ((dataArray.array.count == (row + 1)) && (dataArray.dataComplete)) {
    cell.timeLineDown.hidden = YES;
  }
  if (row == 0) {
    cell.timeLineUp.hidden = YES;
  }
}

#pragma mark---------------------------------------------
/** 绑定聊股标题、聊股内容、聊股图片数据 */
+ (CGFloat)bindTittleAndContentAndContentImageAtCell:(CommentsTableCell *)cell
                                        andIndexPath:(NSIndexPath *)indexPath
                                    andTopViewBottom:(CGFloat)bottom
                                        andTableView:(UITableView *)tableView
                                  andHasUserNameView:(BOOL)hasNameView {
  CGFloat cellHeight = bottom;
  CGFloat height = 0.f;
  height += [self bindContentAndContentImageAtCell:cell
                                      andIndexPath:indexPath
                                  andTopViewBottom:cellHeight
                                      andTableView:tableView
                                andHasUserNameView:hasNameView];
  cell.relayButton.tag = indexPath.row + 1000;
  return height;
}
/** 绑定聊股内容及聊股图片数据 */
+ (CGFloat)bindContentAndContentImageAtCell:(CommentsTableCell *)cell
                               andIndexPath:(NSIndexPath *)indexPath
                           andTopViewBottom:(CGFloat)bottom
                               andTableView:(UITableView *)tableView
                         andHasUserNameView:(BOOL)hasNameView {
  TweetListItem *item = cell.tweetListItem;
  CGFloat cellHeight = bottom;
  CGFloat height = 0.f;
  //评论楼层数
  if (item.floor > 0) {
    cell.commentFloorLabel.text = [NSString stringWithFormat:@"%ld 楼", (long)item.floor];
    cell.commentFloorLabel.hidden = NO;
  } else {
    cell.commentFloorLabel.hidden = YES;
  }

  if (item.content == nil || [@"" isEqualToString:item.content]) {
    cell.contentLabel.hidden = YES;
  } else {
    cell.contentLabel.width = WIDTH_OF_SCREEN - 56;
    cell.contentLabel.text = item.content;
    [cell.contentLabel fitToSuggestedHeight];
    cell.contentLabel.backgroundColor = [UIColor clearColor];
    cell.contentLabel.hidden = NO;
    CGFloat contentHight = cell.contentLabel.height;
    cell.contentLabelHeight.constant = cell.contentLabel.height;
    cell.contentToTimeVS.constant = cellHeight - Time_Bottom_HasUserNameView;
    /// 加入聊股内容高度
    cellHeight += contentHight;
    height += contentHight;
  }

  if (item.imgs && [item.imgs count] > 0) {
    cellHeight += Space_Between_Content_ContentImage;
    height += Space_Between_Content_ContentImage;
    __weak TweetListItem *weakWeibo = item;
    NSString *imageUrl = item.imgs && item.imgs.count > 0 ? item.imgs[0] : nil;
    UIImage *image = [cell.contentImage loadImageWithUrl:imageUrl
                                    onImageReadyCallback:^(UIImage *downloadImage, NSString *imageUrl) {
                                      if (downloadImage) {
                                        [weakWeibo.heightCache removeObjectForKey:HeightCacheKeyAll];
                                        [tableView reloadVisibleRowWithIndexPath:indexPath];
                                      }
                                    }];
    cell.contentImage.image = image ? image : [UIImage imageNamed:@"buttonPressDown"];
    if (image && imageUrl) {
      item.heightCache[imageUrl] = @(image.size.height / ThumbnailFactor);
    }
    CGFloat imageWidth = image ? image.size.width / ThumbnailFactor : 114.f;
    CGFloat imageHeight = image ? image.size.height / ThumbnailFactor : 114.f;
    if (image && imageUrl) {
      item.heightCache[imageUrl] = @(imageHeight);
    }
    cell.contentImageWidth.constant = imageWidth;
    cell.contentImageHeight.constant = imageHeight;

    cell.contentImage.image = image ? image : [UIImage imageNamed:@"buttonPressDown"];

    /// 加入聊股图片高度
    cell.contentImageToTimeVS.constant =
        cellHeight - (hasNameView ? Time_Bottom_HasUserNameView : Time_Bottom_HasUserNameView);
    cellHeight += imageHeight;
    height += imageHeight;
    cell.contentImage.hidden = NO;
  } else {
    cell.contentImage.hidden = YES;
  }
  return height;
}
/** 回复框内部内容计算 */
+ (CGFloat)bindRPContentAndRPComtentImageAtCell:(CommentsTableCell *)cell
                                   andIndexPath:(NSIndexPath *)indexPath
                                   andTableView:(UITableView *)tableView
                               andTopViewBottom:(CGFloat)topViewBottom
                             andHasUserNameView:(BOOL)hasNameView {
  TweetListItem *item = cell.tweetListItem;
  cell.replayTopBKView.hidden = YES;
  cell.replayBKView.hidden = YES;
  CGFloat cellHeight = topViewBottom + Space_Between_RPTopView_Top;
  if (item.type == 4) {
    cell.replayTopBKView.hidden = NO;
    cell.replayBKView.hidden = NO;
    if (item.o_floor > 0) {
      cell.relayFloorLabel.text = [NSString stringWithFormat:@"%ld 楼", (long)item.o_floor];
    }
    cell.relayUserNameView.text = [item.o_nick stringByAppendingString:@" :"];

    cell.rpTopBKToTimeVS.constant = cellHeight - Time_Bottom_HasUserNameView;
    cellHeight += Height_RPTopBKView;
    //初始回复背景的高度
    CGFloat replayBKViewHeight = 21.f;
    cell.rpContentVerticalHeight.constant = 21.f;
    //如果是删除的需要隐藏回复楼层以及昵称
    if ([item.o_content isEqualToString:@"已经被作者删除"]) {
      cell.relayFloorLabel.hidden = YES;
      cell.relayUserNameView.hidden = YES;
      replayBKViewHeight = 0.f;
      cell.rpContentVerticalHeight.constant = 0.f;
    }

    /// 设置回复内容位置
    if ((item.o_content == nil || [item.o_content isEqualToString:@""])) {
      cell.replayContentView.hidden = YES;
    } else {
      if (item.o_content2 != nil) {
        item.o_content = item.o_content2;
      }
      cell.replayContentView.width = WIDTH_OF_SCREEN - 66;
      cell.replayContentView.text = item.o_content;
      [cell.replayContentView fitToSuggestedHeight];
      CGFloat replayContentViewHeight = cell.replayContentView.height;
      cell.rpContentViewHeight.constant = replayContentViewHeight;
      replayBKViewHeight += replayContentViewHeight;
      cellHeight += replayContentViewHeight;
      cell.replayContentView.hidden = NO;
    }

    /// 设置回复图片位置
    if (item.o_imgs && [item.o_imgs count] > 0) {
      cellHeight += Space_Between_Content_ContentImage;
      replayBKViewHeight += Space_Between_RPContent_RPContentImage;
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
    cellHeight += RPBKView_Bottom_Extra_Height;
    cell.rpBKViewHeight.constant = replayBKViewHeight + RPBKView_Bottom_Extra_Height;
  }
  return (cellHeight - topViewBottom + 25);
}
/** 返回转发聊股内容高度*/
+ (CGFloat)weiboReplayContentHeightWithWeibo:(TweetListItem *)weibo
                            withContontWidth:(CGFloat)contentWidth {
  if (weibo.heightCache[HeightCacheKeySourceContent]) {
    return [weibo.heightCache[HeightCacheKeySourceContent] doubleValue];
  }
  CGFloat o_contentHeight = [FTCoreTextView heightWithText:weibo.o_content
                                                     width:contentWidth
                                                      font:WB_DETAILS_REPLY_CONTENT_FONT];
  weibo.heightCache[HeightCacheKeySourceContent] = @(o_contentHeight);
  return o_contentHeight;
}

@end
