//
//  myAttentionsCell.m
//  SimuStock
//
//  Created by jhss on 13-12-18.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "myAttentionsCell.h"

#import "NewShowLabel.h"
#import "SimuUtil.h"

#import "StockUtil.h"

@implementation myAttentionsCell

- (void)awakeFromNib {
  //设置选中颜色
  UIView *backView = [[UIView alloc] initWithFrame:self.frame];
  self.selectedBackgroundView = backView;
  self.selectedBackgroundView.backgroundColor = [Globle colorFromHexRGB:@"#d9ecf2"];
  isAnimationRun = NO;
  _line_index = -1;
}

- (IBAction)attentionSelected:(UIButton *)sender forEvent:(UIEvent *)event {
  if (isAnimationRun == YES)
    return;
  isAnimationRun = YES;
  //[self cancellbuttonselected];
  [UIView beginAnimations:nil context:nil];
  //持续时间
  [UIView setAnimationDuration:0.3];
  //在出动画的时候减缓速度
  [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
  //添加动画开始及结束的代理
  [UIView setAnimationDelegate:self];
  //[UIView setAnimationWillStartSelector:@selector(begin)];
  [UIView setAnimationDidStopSelector:@selector(stopAnimation)];
  CGRect initRect = CGRectMake(WIDTH_OF_SCREEN - 78, 20, 78, 21);
  _attentionImageView.frame = CGRectOffset(initRect, 90, 0);
  [UIView commitAnimations];
}
//弃用
- (IBAction)attentionSelected:(id)sender {

  if (isAnimationRun == YES)
    return;
  isAnimationRun = YES;
  //[self cancellbuttonselected];
  [UIView beginAnimations:nil context:nil];
  //持续时间
  [UIView setAnimationDuration:0.3];
  //在出动画的时候减缓速度
  [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
  //添加动画开始及结束的代理
  [UIView setAnimationDelegate:self];
  //[UIView setAnimationWillStartSelector:@selector(begin)];
  [UIView setAnimationDidStopSelector:@selector(stopAnimation)];
  CGRect initRect = CGRectMake(WIDTH_OF_SCREEN - 78, 20, 78, 21);
  _attentionImageView.frame = CGRectOffset(initRect, 90, 0);
  [UIView commitAnimations];
}
- (void)stopAnimation {
  //无网动画重复原图
  if (![SimuUtil isExistNetwork]) {
    //        [MPNotificationView notifyWithText:REQUEST_FAILED_MESSAGE
    //        andDuration:1.5];
    [NewShowLabel setMessageContent:REQUEST_FAILED_MESSAGE];
    //动画效果
    if (_isAttention) {
      [self performSelectorOnMainThread:@selector(setPicNotActive) withObject:nil waitUntilDone:NO];
    } else {
      //取消关注
      [self performSelectorOnMainThread:@selector(setPicActive) withObject:nil waitUntilDone:NO];
    }
  } else {
    //关注改变
    _isAttention = !_isAttention;
    if (_delegate) {
      [_delegate pressButtonWithFollowFlag:_isAttention withRow:_line_index];
    }
    //动画效果
    if (_isAttention) {
      [self performSelectorOnMainThread:@selector(setPicNotActive) withObject:nil waitUntilDone:NO];
    } else {
      //取消关注
      [self performSelectorOnMainThread:@selector(setPicActive) withObject:nil waitUntilDone:NO];
      //_attentionImageView.image=[UIImage
      // imageNamed:@"MF_atention_cancel.png"];
    }
  }
  [UIView beginAnimations:nil context:nil];
  //持续时间
  [UIView setAnimationDuration:0.3];
  //在出动画的时候减缓速度
  [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
  //添加动画开始及结束的代理
  [UIView setAnimationDelegate:self];
  //[UIView setAnimationWillStartSelector:@selector(begin)];
  [UIView setAnimationDidStopSelector:@selector(stopAnimationAgain)];
  CGRect initRect = CGRectMake(WIDTH_OF_SCREEN - 78, 20, 78, 21);
  _attentionImageView.frame = CGRectOffset(initRect, 0, 0);
  [UIView commitAnimations];
}
- (void)stopAnimationAgain {
  isAnimationRun = NO;
}

- (void)setPicActive {
  _attentionImageView.image = [UIImage imageNamed:@"MF_atention_ok.png"];
}

- (void)setPicNotActive {
  _attentionImageView.image = [UIImage imageNamed:@"MF_atention_cancel.png"];
}

/** 关注 */
- (void)bindMyAttentionInfoItem:(MyAttentionInfoItem *)item withIndexPath:(NSIndexPath *)indexPath {
  self.selectImageView.hidden = YES;

  self.tag = 1000 + indexPath.row;
  //区分button关注
  self.attentionButton.tag = indexPath.row + 300;
  //关注标示图片
  self.attentionImageView.tag = 400 + indexPath.row;
  //右侧头像
  [self.userHeadImage bindUserListItem:item.userListItem];

  self.profitRateLabel.text = item.mProfit;
  self.profitRateLabel.textColor = [StockUtil getColorByProfit:item.mProfit];

  // profitNameLabel
  self.profitNameLabel.textColor = [Globle colorFromHexRGB:@"939393"];
  self.profitNameLabel.highlightedTextColor = [Globle colorFromHexRGB:@"939393"];

  //用户评级控件
  
  _userGradeView.width = WIDTH_OF_SCREEN - 157;
  [_userGradeView bindUserListItem:item.userListItem isOriginalPoster:NO];

  self.line_index = indexPath.row;
  //右侧关注按钮显示
  if ([item.mIsAttention integerValue] == 1) {
    self.isAttention = YES;
    self.attentionImageView.image = [UIImage imageNamed:@"MF_atention_cancel.png"];
  } else {
    self.isAttention = NO;
    self.attentionImageView.image = [UIImage imageNamed:@"MF_atention_ok.png"];
  }
}
/** 粉丝 */
- (void)bindMyFansItem:(MyAttentionInfoItem *)item WithRowAtIndexPath:(NSIndexPath *)indexPath {
  [self bindMyAttentionInfoItem:item withIndexPath:indexPath];

  self.attentionImageView.hidden = YES;
  self.attentionButton.opaque = NO;
  self.attentionButton.alpha = 0.0;
}

@end
