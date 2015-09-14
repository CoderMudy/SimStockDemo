//
//  MessageListTableViewCell.m
//  SimuStock
//
//  Created by jhss on 15/6/25.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "MessageListTableViewCell.h"
#import "HomepageViewController.h"
#import "WBDetailsViewController.h"
#import "ReviewViewController.h"
#import "BlueViewAndArrow.h"

@implementation WeiBoExtendButtons (MessageCellView)

+ (void)showButtonsWithCommentMessage:(MessageListItem *)message
                              offsetY:(CGFloat)offsetY
                                 cell:(NSObject *)cell {
  WeiBoExtendButtons *wbButtons = [WeiBoExtendButtons sharedExtendButtons];
  wbButtons.cell = cell;
  //第一步 清空全部按钮和竖线
  [wbButtons.blueViewAndArrow removeAllSubviews];
  ButtonPressed replyAction = ^{
    [wbButtons hideAndScaleSmall];
    TweetListItem *weibo = [[TweetListItem alloc] init];
    weibo.userListItem = message.writer;
    ReviewViewController *reviewViewController =
        [[ReviewViewController alloc] initWithTstockID:[message.tweetid stringValue]
                                           andSourceid:[message.relateid stringValue]
                                      andTweetListItem:weibo
                                           andCallBack:^(TweetListItem *tweetItemObject){
                                           }];
    [AppDelegate pushViewControllerFromRight:reviewViewController];
  };
  ButtonPressed viewWeibo = ^{
    [wbButtons hideAndScaleSmall];
    [WBDetailsViewController showTSViewWithTStockId:message.tweetid];
  };

  [wbButtons buttonMaker:@"回复评论" action:replyAction];
  [wbButtons buttonMaker:@"查看原聊股" action:viewWeibo];

  //重设宽度、重设箭头
  [wbButtons resetBlueViewAndArrowsFrameWithOffsetY:offsetY];
  //上面最好封装进GCD
  [wbButtons showAndScaleLarge];
}

@end

@interface MessageListTableViewCell () {
  int _replyWidth;
  int _bubbleWidth;
  float _fontSize;
  NSString *_reuseIdentifier;
  MessageListItem *_message;
}

@end

@implementation MessageListTableViewCell
static const CGFloat heightUserInfo = 65;

+ (CGFloat)cellHeightWithMessage:(MessageListItem *)message withFontSize:(float)fontSize {
  CGFloat replyWidth = WIDTH_OF_SCREEN - 74;
  CGFloat bubbleWidth = WIDTH_OF_SCREEN - 80;
  CGFloat height = 0;
  CGFloat replyHeight = 0;
  CGFloat bubbleHeight = 0;

  CGFloat heightBubbleExtra = 29;
  if (message.des && [message.des length] > 0) {
    replyHeight = [FTCoreTextView heightWithText:message.content width:replyWidth font:fontSize];
    bubbleHeight = [FTCoreTextView heightWithText:message.des width:bubbleWidth font:fontSize];
    height = heightUserInfo + replyHeight + bubbleHeight + heightBubbleExtra;
  } else {
    replyHeight = [FTCoreTextView heightWithText:message.content width:bubbleWidth font:fontSize];
    height = heightUserInfo + replyHeight;
  }
  return height;
}

- (void)awakeFromNib {
  [self.redDotImageView.layer setCornerRadius:4.0f];
  [self.redDotImageView.layer setMasksToBounds:YES];
  [self.replayCoreTextView setTextColor:[Globle colorFromHexRGB:@"#5a5a5a"]];
  [self.grayCoreTextView setTextColor:[Globle colorFromHexRGB:@"#5a5a5a"]];
  [self.bubbleView.layer setCornerRadius:2.5f];
  self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
  self.selectedBackgroundView.backgroundColor = [Globle colorFromHexRGB:@"#d9ecf2"];
}

- (void)calculationTableHeight {
  self.replayCoreTextView.width = WIDTH_OF_SCREEN - 74;
  self.replayCoreTextView.text = _message.content; //文本赋值
  [self.replayCoreTextView fitToSuggestedHeight];
  self.replyHeight.constant = self.replayCoreTextView.height;

  //判断是否des为空
  if (_message.des && [_message.des length] > 0) {
    self.grayCoreTextView.hidden = NO;
    self.bubbleView.hidden = NO;
    self.arrowImageView.hidden = NO;
    //灰色回复部分
    self.grayCoreTextView.width = WIDTH_OF_SCREEN - 80;
    self.grayCoreTextView.text = _message.des;
    [self.grayCoreTextView fitToSuggestedHeight];

    self.sourceHeight.constant = self.grayCoreTextView.height + 20;
  } else {
    self.grayCoreTextView.hidden = YES;
    self.bubbleView.hidden = YES;
    self.arrowImageView.hidden = YES;
    self.sourceHeight.constant = 80;
  }
}

- (void)bindMessageListItem:(MessageListItem *)message andBtnClick:(UserpicAndnameClick)block {
  _message = message;
  //通过文字设置cell行高（content是内容，des是引用别人的回复）
  [self calculationTableHeight];
  //计算发帖日期
  _ctimeLabel.text = [SimuUtil getDateFromCtime:message.ctime];
  UserListItem *user = message.writer;
  _nickMarks.width = WIDTH_OF_SCREEN - 67;
  [_nickMarks bindUserListItem:user isOriginalPoster:NO];
  [_headerImageView bindUserListItem:user];
  if (message.read) {
    _redDotImageView.hidden = YES;
  } else {
    _redDotImageView.hidden = NO;
  }
}

@end
