//
//  WBReplyBox.m
//  SimuStock
//
//  Created by jhss on 14-12-1.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "WBReplyBox.h"
#import "FTCoreTextView.h"
#import "ImageUtil.h"
#import "WBImageView.h"

@implementation WBReplyBox

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
  }
  return self;
}
/** 聊股吧可变高度 */
+ (float)heightOfReplyBoxWithContent:(TweetListItem *)item {

  if (!item.o_content.length > 0) {
    return 0;
  }

  //可变文本
  float height = [FTCoreTextView heightWithText:item.o_content width:279 font:Font_Height_14_0];
  //小箭头
  height = height + 6.5f;
  //三部分 分割 模块
  //上
  height += 10.0f;
  //中图
  height += 5.0f;
  //下
  height += 10.0f;
  //图片高度
  if (item.imgs && [item.imgs count] > 0) {
    NSString *imageUrl = item.imgs.count > 0 && item.imgs[0] ? item.imgs[0] : nil;
    CGFloat imageHeight =
    [[ImageUtil imageHeightFromUrl:imageUrl withWeibo:item] floatValue];
    height = height + imageHeight;
  }
  return height;
}
/** l聊股吧 回复框 */
+ (UIView *)createReplyBoxOfTalkBarWithItem:(TweetListItem *)item {
  /** 承载view */
  CGRect screenFrame = [[UIScreen mainScreen] bounds];
  UIView *replyView = [[UIView alloc]
      initWithFrame:CGRectMake(20, 58, screenFrame.size.width - 32, 15)];
  CGRect frame = replyView.frame;
  replyView.backgroundColor = [UIColor clearColor];
  UIImage *replyBGImage = [UIImage imageNamed:@"聊股回复框小图标"];
  UIImageView *arowImageview =
      [[UIImageView alloc] initWithFrame:CGRectMake(9, 0, 12, 6.5f)];
  arowImageview.image = replyBGImage;
  [replyView addSubview:arowImageview];
  /** 灰色气泡 */
  UIView *grayView = [[UIView alloc]
      initWithFrame:CGRectMake(frame.origin.x, frame.origin.y + 6.5f,
                               frame.size.width, frame.size.height)];
  [grayView.layer setMasksToBounds:YES];
  [grayView.layer setCornerRadius:2.5f];
  grayView.backgroundColor = [Globle colorFromHexRGB:Color_ReplyBubble];
  [replyView addSubview:grayView];
  /** content (6.5 + 9)*/
  NSInteger contentHeight = [FTCoreTextView heightWithText:item.content width:279 font:14];
  FTCoreTextView *contentView = [[FTCoreTextView alloc]
      initWithFrame:CGRectMake(12.0f, 16.5f, frame.size.width - 24.0f,
                               contentHeight)];
  contentView.text = item.content;
  [contentView fitToSuggestedHeight];
  [replyView addSubview:contentView];
  frame.size.height = contentHeight + 26.5f;

  if (item.imgs && [item.imgs count] > 0) {
    WBImageView *imageView = [[WBImageView alloc]
        initWithFrame:CGRectMake(12.0f, 16.5f + contentHeight + 5.0f, 0, 0)];
    NSString *imageUrl = item.imgs.count > 0 && item.imgs[0] ? item.imgs[0] : nil;
    CGFloat imageHeight =
    [[ImageUtil imageHeightFromUrl:imageUrl withWeibo:item] floatValue];
    frame.size.height = frame.size.height + imageHeight;
    [replyView addSubview:imageView];
  }
  //重新设置下气泡高度
  grayView.frame =
      CGRectMake(0, 6.5f, frame.size.width, frame.size.height - 6.5f);
  replyView.frame = frame;
  return replyView;
}
/** 聊股内容页 */
+ (UIView *)createReplyBoxOfTitleWithTitle:(NSString *)replyContent
                            withReplyImage:(NSString *)replyImageStr
                                  withTSid:(NSString *)tstockId
                                  withRect:(CGRect)frame
                                  withItem:(TweetListItem *)item{
  /** 承载view */
  UIView *replyView = [[UIView alloc] initWithFrame:frame];
  replyView.userInteractionEnabled = YES;
  replyView.backgroundColor = [UIColor clearColor];
  UIImage *replyBGImage = [UIImage imageNamed:@"聊股回复框小图标"];
  UIImageView *arowImageview =
      [[UIImageView alloc] initWithFrame:CGRectMake(9, 0, 12, 6.5f)];
  arowImageview.image = replyBGImage;
  [replyView addSubview:arowImageview];
  /** 灰色气泡 */
  UIView *grayView = [[UIView alloc]
      initWithFrame:CGRectMake(frame.origin.x, frame.origin.y + 6.5f,
                               frame.size.width, frame.size.height)];
  [grayView.layer setMasksToBounds:YES];
  [grayView.layer setCornerRadius:2.5f];
  grayView.backgroundColor = [Globle colorFromHexRGB:@"eaeaea"];
  [replyView addSubview:grayView];
  
  NSInteger contentHeight =
      [FTCoreTextView heightWithText:replyContent width:(frame.size.width - 24.0f) font:Font_Height_14_0];
  FTCoreTextView *contentView = [[FTCoreTextView alloc]
      initWithFrame:CGRectMake(12.0f, 15.5f, frame.size.width - 24.0f,
                               contentHeight)];
  contentView.text = replyContent;
  [contentView setTextSize:14.0f];
  [contentView setTextColor:[Globle colorFromHexRGB:Color_Icon_Title]];
  [replyView addSubview:contentView];
  [contentView fitToSuggestedHeight]; 
  frame.size.height = contentHeight + 24.5f;
  if (replyImageStr && [replyImageStr length] > 0) {
    CGRect imageFrame = CGRectMake(12.0f, 15.5f + contentHeight + 5.0f, 0, 0);
    WBImageView *imageView = [[WBImageView alloc] initWithFrame:imageFrame];
    
    __weak UIImageView *weakImageView =imageView;
    UIImage *image = [imageView loadImageWithUrl:replyImageStr onImageReadyCallback:^(UIImage *downloadImage, NSString* imageUrl) {
      if (downloadImage) {
        weakImageView.image = downloadImage;
      }
    }];
    imageView.image = image ? image : [UIImage imageNamed:@"buttonPressDown"];
    imageFrame.size.width = image ? image.size.width / ThumbnailFactor : 114;
    imageFrame.size.height = image ? image.size.height / ThumbnailFactor : 114;
    imageView.frame = imageFrame;

    frame.size.height = frame.size.height + imageFrame.size.height;
    [replyView addSubview:imageView];
  }
  //重新设置下气泡高度
  grayView.frame =
      CGRectMake(0, 6.5f, frame.size.width, frame.size.height - 6.5f);
  replyView.frame = frame;
  
  return replyView;
}
- (void)clickReplyScale:(UIGestureRecognizer *)ges
{
  NSLog(@"click");
}
/** 聊股内容页回复*/
+ (UIView *)createReplyBoxOfFloorWithNickName:(NSString *)nickName
                             withReplyContent:(NSString *)content
                                withReplyTime:(NSString *)replyTime
                              withFloorNumber:(NSString *)floorNum
                               withReplyImage:(NSString *)replyImage
                                     withRect:(CGRect)frame {
  /** 承载view */
  UIView *replyView = [[UIView alloc] initWithFrame:frame];
  replyView.backgroundColor = [UIColor clearColor];
  UIImageView *arowImageview =
      [[UIImageView alloc] initWithFrame:CGRectMake(9, 0, 12, 6.5f)];
  arowImageview.image = [UIImage imageNamed:@"聊股回复框小图标"];
  [replyView addSubview:arowImageview];
  UIView *grayView = [[UIView alloc]
      initWithFrame:CGRectMake(frame.origin.x, frame.origin.y + 6.5f,
                               frame.size.width, frame.size.height)];
  [grayView.layer setMasksToBounds:YES];
  [grayView.layer setCornerRadius:2.5f];
  grayView.backgroundColor = [Globle colorFromHexRGB:@"eaeaea"];
  [replyView addSubview:grayView];
  /** nickname */
  UILabel *nickNameLabel =
      [[UILabel alloc] initWithFrame:CGRectMake(12.0f, 15.5f, 200, 14)];
  nickNameLabel.backgroundColor = [UIColor clearColor];
  nickNameLabel.textAlignment = NSTextAlignmentLeft;
  nickNameLabel.textColor = [Globle colorFromHexRGB:Color_Blue_but];
  nickNameLabel.font = [UIFont systemFontOfSize:13.0f];
  [replyView addSubview:nickNameLabel];
  /** content (6.5 + 9)*/
  UILabel *contentLabel = [[UILabel alloc]
      initWithFrame:CGRectMake(12.0f, 38.5f, frame.size.width - 24.0f,
                               frame.size.height - 49.5f)];
  contentLabel.backgroundColor = [UIColor clearColor];
  contentLabel.font = [UIFont systemFontOfSize:12.0f];
  contentLabel.textAlignment = NSTextAlignmentLeft;
  contentLabel.textColor = [Globle colorFromHexRGB:Color_Icon_Title];
  CGSize size =
      [content sizeWithFont:[UIFont systemFontOfSize:12.0f]
          constrainedToSize:CGSizeMake(contentLabel.frame.size.width, 1000)
              lineBreakMode:0];
  contentLabel.frame = CGRectMake(12.0f, 38.5f, size.width, size.height);
  [replyView addSubview:contentLabel];
  frame.size.height = size.height + 49.5f;
  grayView.frame =
      CGRectMake(0, 6.5f, frame.size.width, frame.size.height - 6.5f);
  replyView.frame = frame;
  return replyView;
}

@end
