//
//  ChatStockPageTVCell.m
//  SimuStock
//
//  Created by jhss_wyz on 15/7/20.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "ChatStockPageTVCell.h"
#import "FTCoreTextView.h"
#import "SimuUtil.h"
#import "WeiBoExtendButtons.h"
#import "WBCoreDataUtil.h"
#import "SimuScreenAdapter.h"

@implementation ChatStockPageTVCell

- (void)awakeFromNib {
  self.longPressGR = [[UILongPressGestureRecognizer alloc]
      initWithTarget:self
              action:@selector(cellClickAction:)];
  [self addGestureRecognizer:_longPressGR];
  [self.tittleLabel setBoldTextSize:CHAT_STOCK_TITTLE_FONT];
  [self.tittleLabel setTextColor:[Globle colorFromHexRGB:Color_Text_Common]];
  [self.contentLabel setTextColor:[Globle colorFromHexRGB:Color_Icon_Title]];
  [self.contentLabel setTextSize:CHAT_STOCK_CONTENT_FONT];
  [self.replayContentView
      setTextColor:[Globle colorFromHexRGB:Color_Icon_Title]];
  [self.replayContentView setTextSize:CHAT_STOCK_REPLY_CONTENT_FONT];

  self.contentView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];

  self.eliteImageView.hidden = YES;

  if (self.bottomToolView) {
    /// 专门给分享、评论、赞底部view设置的长按手势，用于屏蔽弹出拓展框
    NSArray *forbitLongPressedViews =
        @[ self.shareBtn, self.commentBtn, self.applaudBtn ];
    for (UIView *view in forbitLongPressedViews) {
      UILongPressGestureRecognizer *shieldLongPress1 =
          [[UILongPressGestureRecognizer alloc] initWithTarget:view action:nil];
      shieldLongPress1.minimumPressDuration = LongPressTime;
      [view addGestureRecognizer:shieldLongPress1];
    }
  }
}

/** 长按出现拓展按钮 */
- (void)cellClickAction:(UILongPressGestureRecognizer *)gesture {
  /// 长按位置
  if (gesture.state == UIGestureRecognizerStateBegan) {
    CGPoint loc = [gesture
        locationInView:[[UIApplication sharedApplication].delegate window]];
    if ([SimuUtil isLogined]) {
      /// 必须每次长按时指向block，否则会被cell复用机制覆盖掉
      [self setExtendButtonsBlock];
      /// 显示拓展按钮
      [WeiBoExtendButtons showWithTweetListItem:self.tweetListItem
                                        offsetY:loc.y
                                           cell:self];
    }
  }
}

#pragma mark 设置拓展按钮的block
- (void)setExtendButtonsBlock {
  /// 实现拓展按钮block
  WeiBoExtendButtons *extendButtons = [WeiBoExtendButtons sharedExtendButtons];

  /// 删除按钮
  [extendButtons
      setExtendDeleteButtonClickBlock:^(NSNumber *tid, NSObject *cell) {
        ChatStockPageTVCell *strongCell = (ChatStockPageTVCell *)cell;
        if (strongCell.deleteBtnBlock) {
          strongCell.deleteBtnBlock(tid);
        }
      }];
  /// 置顶按钮
  [extendButtons
      setExtendTopButtonClickBlock:^(TweetListItem *item, NSObject *cell) {
        ChatStockPageTVCell *strongCell = (ChatStockPageTVCell *)cell;
        if (strongCell.topButtonClickBlock) {
          strongCell.topButtonClickBlock(item);
        }
      }];
  /// 加精按钮
  [extendButtons setExtendEliteButtonClickBlock:^(BOOL isElite, NSNumber *tid,
                                                  NSObject *cell) {
    ChatStockPageTVCell *strongCell = (ChatStockPageTVCell *)cell;
    strongCell.eliteImageView.hidden = !isElite;
    if (strongCell.eliteButtonClickBlock) {
      strongCell.eliteButtonClickBlock(isElite, tid);
    }
  }];
}

- (void)bidButtonTriggeringMethod:(UIButton *)btn {

  if ([self.delegate
          respondsToSelector:@selector(bidButtonTriggersCallbackMethod:row:)]) {
    [self.delegate bidButtonTriggersCallbackMethod:btn.tag row:self.row];
  }
}

- (void)timerFiredShareBtn:(NSTimer *)timer {
  [_shareBtn setBackgroundImage:[UIImage imageNamed:nil]
                       forState:UIControlStateNormal];
}

/** 取消按钮的点击状态 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesBegan:touches withEvent:event];
  [(UIButton *)self.accessoryView setHighlighted:NO];
  [self.shareBtn setHighlighted:NO];
  [self.commentBtn setHighlighted:NO];
  [self.applaudBtn setHighlighted:NO];
}

/** 初始化工具栏：分享、评论、赞*/
- (void)initToolBar {
  [self setBottomToolBtnClickAction];
  [self resetBottomToolBtnTitle];
}

/** 设置分享、评论、点赞按钮点击响应 */
- (void)setBottomToolBtnClickAction {
  /// 设置分享按钮
  self.shareBtn.highlightBGColor = [UIColor colorWithWhite:0 alpha:0.25];
  self.shareBtn.normalBGColor = [UIColor clearColor];
  ;
  [self.shareBtn setOnButtonPressedHandler:^{
    [self bidButtonTriggeringMethod:self.shareBtn];
  }];

  /// 设置评论按钮
  self.commentBtn.highlightBGColor = [UIColor colorWithWhite:0 alpha:0.25];
  self.commentBtn.normalBGColor = [UIColor clearColor];
  ;
  [self.commentBtn setOnButtonPressedHandler:^{
    [self bidButtonTriggeringMethod:self.commentBtn];
  }];

  /// 设置点赞按钮
  self.applaudBtn.highlightBGColor = [UIColor colorWithWhite:0 alpha:0.25];
  self.applaudBtn.normalBGColor = [UIColor clearColor];
  ;
  [self.applaudBtn setOnButtonPressedHandler:^{
    [self bidButtonTriggeringMethod:self.applaudBtn];
  }];
}

/** 设置分享、评论、点赞数目 */
- (void)resetBottomToolBtnTitle {
  /// 设置分享数
  if (self.tweetListItem.share > 0) {
    [self.shareBtn
        setTitle:[NSString stringWithFormat:@"%ld", (long)_tweetListItem.share]
        forState:UIControlStateNormal];
  } else {
    [self.shareBtn setTitle:@"分享" forState:UIControlStateNormal];
  }

  /// 设置评论数
  if (self.tweetListItem.comment > 0) {
    [self.commentBtn
        setTitle:[NSString
                     stringWithFormat:@"%ld", (long)_tweetListItem.comment]
        forState:UIControlStateNormal];
  } else {
    [self.commentBtn setTitle:@"评论" forState:UIControlStateNormal];
  }

  /// 设置点赞数
  if (_tweetListItem.praise > 0) {
    [self.applaudBtn
        setTitle:[NSString stringWithFormat:@"%ld", (long)_tweetListItem.praise]
        forState:UIControlStateNormal];
  } else {
    [self.applaudBtn setTitle:@"赞" forState:UIControlStateNormal];
  }
  /// 是否点过赞
  self.tweetListItem.isPraised = [WBCoreDataUtil
      fetchPraiseTid:@([_tweetListItem.tstockid longLongValue])];
  if (_tweetListItem.isPraised) {
    self.applaudBtn.userInteractionEnabled = NO;
    [self.applaudBtn
        setTitle:[NSString stringWithFormat:@"%ld", (long)_tweetListItem.praise]
        forState:UIControlStateNormal];
    [self.applaudBtn setImage:[UIImage imageNamed:@"赞小图标_down"]
                     forState:UIControlStateNormal];
    //设置点赞数字体颜色(红色)
    [self.applaudBtn setTitleColor:[Globle colorFromHexRGB:@"#F36C6C"]
                          forState:UIControlStateNormal];

  } else {
    self.applaudBtn.userInteractionEnabled = YES;
    [self.applaudBtn setImage:[UIImage imageNamed:@"赞小图标_up.png"]
                     forState:UIControlStateNormal];
    //设置点赞数字体颜色（蓝色）
    [self.applaudBtn setTitleColor:[Globle colorFromHexRGB:Color_Blue_but]
                          forState:UIControlStateNormal];
  }

  [self.commentBtn setImage:[UIImage imageNamed:@"评论小图标1"]
                   forState:UIControlStateNormal];
}

@end
