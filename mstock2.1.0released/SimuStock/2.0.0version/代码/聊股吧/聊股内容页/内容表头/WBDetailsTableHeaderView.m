//
//  WBDetailsTableHeaderView.m
//  SimuStock
//
//  Created by Jhss on 15/8/5.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "WBDetailsTableHeaderView.h"
#import "WeiBoExtendButtons.h"
#import "WBCoreDataUtil.h"
#import "WBDetailsViewController.h"
#import "SimuScreenAdapter.h"

@implementation WBDetailsTableHeaderView

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
  }
  return self;
}
- (void)awakeFromNib {
  // Initialization code
  //吧名文字颜色
  [self.barNameCoreTextView setTextSize:Font_Height_11_0];
  self.barNameCoreTextView.hidden = YES;
  [self.tittleLabel setBoldTextSize:WB_DETAILS_TITTLE_FONT];
  [self.tittleLabel setTextColor:[Globle colorFromHexRGB:Color_Text_Common]];
  [self.contentLabel setTextColor:[Globle colorFromHexRGB:Color_Icon_Title]];
  [self.replayContentView setTextColor:[Globle colorFromHexRGB:Color_Icon_Title]];
  [self.replayContentView setTextSize:WB_DETAILS_REPLY_CONTENT_FONT];
  [self.contentLabel setTextSize:WB_DETAILS_CONTENT_FONT];
  // ftcoretextview可交互
  //  self.contentLabel.userInteractionEnabled = YES;
  //  self.replayContentView.userInteractionEnabled = YES;
  //
  //回复框圆边
  [self.replayBKView.layer setMasksToBounds:YES];
  [self.replayBKView.layer setCornerRadius:2.5f];
  [self.commentBtn setTitleColor:[Globle colorFromHexRGB:Color_Text_Common]
                        forState:UIControlStateNormal];
  [self.applaudBtn setTitleColor:[Globle colorFromHexRGB:Color_Gray] forState:UIControlStateNormal];
  //折线
  self.downLine.directionStatus = @"1";
  [self.downLine setNeedsDisplay];
  [self addGesture];
}
- (void)addGesture {
  //聊股内容 长按复制
  UILongPressGestureRecognizer *longGes =
      [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
  longGes.minimumPressDuration = 1.0f;
  [self addGestureRecognizer:longGes];

  //回复框加手势
  UITapGestureRecognizer *tapGes =
      [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickReplyScale:)];
  [self.replayBKView addGestureRecognizer:tapGes];
}
- (void)clickReplyScale:(UIGestureRecognizer *)ges {
  if (ges.state == UIGestureRecognizerStateEnded) {
    UIView *tapView = ges.view;
    CGPoint pointInWindow = [ges locationInView:tapView];
    //坐标转换
    pointInWindow = [tapView convertPoint:pointInWindow toView:WINDOW];
    FTCoreTextView *tapFTView;
    for (UIView *view in tapView.subviews) {
      if ([view isKindOfClass:[FTCoreTextView class]]) {
        tapFTView = (FTCoreTextView *)view;
      }
    }
    if ([tapFTView performClickOnPoint:pointInWindow]) {
      NSLog(@"long press event deal by coreTextView");
      return;
    }
  }
  [WBDetailsViewController showTSViewWithTStockId:self.tweetListItem.o_tstockid];
}
/** 聊股内容长按操作 */
- (void)longPressAction:(UILongPressGestureRecognizer *)gesture {
  if (gesture.state == UIGestureRecognizerStateEnded) {
    //长按位置
    CGPoint loc = [gesture locationInView:[[UIApplication sharedApplication].delegate window]];
    //显示拓展按钮
    [WeiBoExtendButtons showButtonWithCopyContent:[_contentLabel getVisibleFTCoreText]
                                          offsetY:loc.y
                                           bgView:self];
  }
}

/** 绑定聊股标题、聊股内容、聊股图片数据 */
- (CGFloat)bindWBDetailHeadViewInfo:(TweetListItem *)item
                   andTopViewBottom:(CGFloat)bottom
                 andHasUserNameView:(BOOL)hasNameView {
  self.tweetListItem = item;
  [self.userImage bindUserListItem:item.userListItem];
  self.userNameView.width = WIDTH_OF_SCREEN - 109;
  [self.userNameView bindUserListItem:item.userListItem isOriginalPoster:NO];
  self.timeLabel.text = [SimuUtil getDateFromCtime:@([item.ctime longLongValue])];

  //评论数，赞数
  //评论按钮title
  NSString *commentStr = [NSString stringWithFormat:@"评论  %ld", (long)item.comment];
  [self.commentBtn setTitle:commentStr forState:UIControlStateNormal];
  //赞按钮title
  NSString *praiseStr = [NSString stringWithFormat:@"赞   %ld", (long)item.praise];
  [self.applaudBtn setTitle:praiseStr forState:UIControlStateNormal];
  //赞的状态
  if (![SimuUtil isLogined]) {
    item.isPraised = NO;
  } else {
    item.isPraised = [WBCoreDataUtil fetchPraiseTid:item.tstockid];
  }
  //来自。。。。。
  if (item.clickableBarName && !([item.clickableBarName isEqualToString:@""])) {
    self.barNameCoreTextView.hidden = NO;
    //来自xxx的吧
    [self.barNameCoreTextView setTextSize:Font_Height_11_0];
    self.barNameCoreTextView.text = item.clickableBarName;
    [self.barNameCoreTextView fitToSuggestedHeight];
    self.barNameHeight.constant = self.barNameCoreTextView.height;
  }
  /// 设置加精
  self.eliteImageView.hidden = !item.elite;
  CGFloat cellHeight = Space_Time_Bottom_HasUserNameView + Space_Between_Time_Tittle;
  CGFloat height = 0.f;
  if (item.title == nil || [@"" isEqualToString:item.title]) {
    self.tittleLabel.text = item.title;
    self.tittleLabel.hidden = YES;
  } else {
    self.tittleLabel.text = item.title;
    self.tittleLabel.hidden = NO;
    [self.tittleLabel fitToSuggestedHeight];
    CGFloat titleheight = self.tittleLabel.height;
    self.tittleLabelHeight.constant = titleheight;
    self.tittleToTimeVS.constant = cellHeight - Space_Time_Bottom_HasUserNameView;
    /// 加入聊股标题高度
    cellHeight += titleheight + Space_Between_Tittle_Content;
    height += titleheight + Space_Between_Tittle_Content;
  }
  cellHeight += [self bindConmmentImageViewAndCommentInfo:item
                                         andTopViewBottom:cellHeight
                                       andHasUserNameView:hasNameView];

  return cellHeight;
}
- (CGFloat)bindConmmentImageViewAndCommentInfo:(TweetListItem *)item
                              andTopViewBottom:(CGFloat)bottom
                            andHasUserNameView:(BOOL)hasNameView {
  CGFloat cellHeight = bottom;
  CGFloat height = 0.f;
  if (item.content == nil || [@"" isEqualToString:item.content]) {
    self.contentLabel.hidden = YES;
  } else {
    self.contentLabel.text = item.content;
    self.contentLabel.backgroundColor = [UIColor clearColor];
    self.contentLabel.hidden = NO;
    [self.contentLabel fitToSuggestedHeight];
    CGFloat contentLableWidth = WIDTH_OF_SCREEN - Content_Left_Space - Content_Right_Space;
    CGFloat contentHight =
        [self weiboContentHeightWithWeibo:item withContontWidth:contentLableWidth];
    self.contentLabelHeight.constant = contentHight;
    self.contentToTimeVS.constant = cellHeight - Space_Time_Bottom_HasUserNameView;
    /// 加入聊股内容高度
    cellHeight += contentHight;
    height += contentHight;
  }

  if (item.imgs && [item.imgs count] > 0) {
    cellHeight += Space_Between_Content_ContentImage;
    height += Space_Between_Content_ContentImage;
    __weak TweetListItem *weakWeibo = item;
    NSString *imageUrl = item.imgs && item.imgs.count > 0 ? item.imgs[0] : nil;
    UIImage *image = [self.contentImage loadImageWithUrl:imageUrl
                                    onImageReadyCallback:^(UIImage *downloadImage, NSString *imageUrl) {
                                      if (downloadImage) {
                                        [weakWeibo.heightCache removeObjectForKey:HeightCacheKeyAll];
                                      }
                                    }];
    self.contentImage.image = image ? image : [UIImage imageNamed:@"buttonPressDown"];
    if (image && imageUrl) {
      item.heightCache[imageUrl] = @(image.size.height / ThumbnailFactor);
    }
    CGFloat imageWidth = image ? image.size.width / ThumbnailFactor : 114.f;
    CGFloat imageHeight = image ? image.size.height / ThumbnailFactor : 114.f;
    if (image && imageUrl) {
      item.heightCache[imageUrl] = @(imageHeight);
    }
    self.contentImageWidth.constant = imageWidth;
    self.contentImageHeight.constant = imageHeight;

    self.contentImage.image = image ? image : [UIImage imageNamed:@"buttonPressDown"];

    /// 加入聊股图片高度
    self.contentImageToTimeVS.constant =
        cellHeight - (hasNameView ? Space_Time_Bottom_HasUserNameView : Space_Time_Bottom_HasUserNameView);
    cellHeight += imageHeight;
    height += imageHeight;
    self.contentImage.hidden = NO;
  } else {
    self.contentImage.hidden = YES;
  }
  return height;
}
//绑定聊股图片和内容（回复）
- (CGFloat)bindContentAndHeadViewInfo:(TweetListItem *)item
                     andTopViewBottom:(CGFloat)bottom
                   andHasUserNameView:(BOOL)hasNameView {
  self.replayTopBKView.hidden = YES;
  self.replayBKView.hidden = YES;
  CGFloat cellHeight = bottom + Space_Between_RPTopView_Top;
  if (item.o_content != nil || item.o_imgs != nil) {
    self.replayTopBKView.hidden = NO;
    self.replayBKView.hidden = NO;
    self.rpTopBKToTimeVS.constant = cellHeight - Space_Time_Bottom_HasUserNameView;
    cellHeight += RPTopBKView_Height;
    CGFloat replayBKViewHeight = 0.f;

    /// 设置回复内容位置
    if (!item.o_content) {
      item.o_content = @"";
    }
    if (item.o_content == nil) {
      self.replayContentView.hidden = YES;
    } else {
      NSString *replyContent;
      if ([[item.userListItem.userId stringValue] isEqualToString:[item.o_uid stringValue]]) {
        item.o_nick = item.userListItem.nickName;
      }
      if (item.o_nick) {
        replyContent =
            [NSString stringWithFormat:@"<atuser uid=\"%@\" nick=\"%@\"/> : %@", item.o_uid, item.o_nick, item.o_content];
      } else {
        replyContent = item.o_content;
      }
      self.replayContentView.text = replyContent;
      CGFloat replayContentLableWidth = WIDTH_OF_SCREEN - Content_Left_Space - Content_Right_Space -
                                        Space_Between_ReplayBKViewRight_RPContentViewRight -
                                        Space_Between_ReplayBKViewLeft_RPContentViewLeft;
      CGFloat replayContentViewHeight = [self weiboReplayContentHeightWithWeibo:item
                                                                       withname:replyContent
                                                               withContontWidth:replayContentLableWidth];
      self.rpContentViewHeight.constant = replayContentViewHeight;
      replayBKViewHeight += replayContentViewHeight;
      cellHeight += replayContentViewHeight;
      self.replayContentView.hidden = NO;
    }

    /// 设置回复图片位置
    if (item.o_imgs && [item.o_imgs count] > 0) {
      cellHeight += Space_Between_Content_ContentImage;
      replayBKViewHeight += Space_Between_RPContent_RPContentImage;
      self.rpImageViewToRpBKViewVS.constant = replayBKViewHeight;

      __weak TweetListItem *weakitem = item;
      NSString *imageUrl = item.o_imgs[0];
      UIImage *image = [self.replayImageView loadImageWithUrl:imageUrl
                                         onImageReadyCallback:^(UIImage *downloadImage, NSString *imageUrl) {
                                           if (downloadImage) {
                                             [weakitem.heightCache removeObjectForKey:HeightCacheKeyAll];
                                           }
                                         }];
      CGFloat imageWidth = image ? image.size.width / ThumbnailFactor : 114.f;
      CGFloat imageHeight = image ? image.size.height / ThumbnailFactor : 114.f;
      if (image) {
        item.heightCache[imageUrl] = @(imageHeight);
      }
      self.rpImageViewHeight.constant = imageHeight;
      self.rpImageViewWidth.constant = imageWidth;
      self.replayImageView.image = image ? image : [UIImage imageNamed:@"buttonPressDown"];

      /// 加入回复聊股图片高度
      cellHeight += imageHeight;
      replayBKViewHeight += imageHeight;

      self.replayImageView.hidden = NO;
    } else {
      self.replayImageView.hidden = YES;
    }
    cellHeight += RPBKView_Bottom_Extra_Height;
    self.rpBKViewHeight.constant = replayBKViewHeight + RPBKView_Bottom_Extra_Height;
  }
  return (cellHeight - bottom + Botton_Down_View_Height);
}
/** 返回聊股内容高度*/
- (CGFloat)weiboContentHeightWithWeibo:(TweetListItem *)weibo
                      withContontWidth:(CGFloat)contentWidth {
  if (weibo.heightCache[HeightCacheKeyContent]) {
    return [weibo.heightCache[HeightCacheKeyContent] doubleValue];
  }
  CGFloat contentHeight =
      [FTCoreTextView heightWithText:weibo.content width:contentWidth font:WB_DETAILS_CONTENT_FONT];
  weibo.heightCache[HeightCacheKeyContent] = @(contentHeight);
  return contentHeight;
}
/** 返回转发聊股内容高度*/
- (CGFloat)weiboReplayContentHeightWithWeibo:(TweetListItem *)weibo
                                    withname:(NSString *)str
                            withContontWidth:(CGFloat)contentWidth {
  if (weibo.heightCache[HeightCacheKeySourceContent]) {
    return [weibo.heightCache[HeightCacheKeySourceContent] doubleValue];
  }
  CGFloat o_contentHeight =
      [FTCoreTextView heightWithText:str width:contentWidth font:WB_DETAILS_REPLY_CONTENT_FONT];
  weibo.heightCache[HeightCacheKeySourceContent] = @(o_contentHeight);
  return o_contentHeight;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [super.nextResponder touchesBegan:touches withEvent:event];
}

@end
