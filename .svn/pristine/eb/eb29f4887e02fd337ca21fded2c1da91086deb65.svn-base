//
//  AllChatStockTVCell.m
//  SimuStock
//
//  Created by jhss_wyz on 15/7/31.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "AllChatStockTopTVCell.h"
#import "WeiBoExtendButtons.h"
#import "GetBarTopListData.h"
#import "CellBottomLinesView.h"
#import "FTCoreTextView.h"

@implementation AllChatStockTopTVCell

- (void)awakeFromNib {
  self.selectionStyle = UITableViewCellSelectionStyleNone;
  self.exclusiveTouch = YES;
  self.contentView.exclusiveTouch = YES;

  //长按弹出按钮
  UILongPressGestureRecognizer *longPress =
      [[UILongPressGestureRecognizer alloc]
          initWithTarget:self
                  action:@selector(showExtendButtons:)];
  longPress.minimumPressDuration = LongPressTime;
  [self addGestureRecognizer:longPress];
  self.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];

  [CellBottomLinesView addBottomLinesToCell:self];
}

//长按出现拓展按钮
- (void)showExtendButtons:(UILongPressGestureRecognizer *)gesture {
  //长按位置
  if (gesture.state == UIGestureRecognizerStateBegan) {
    CGPoint loc = [gesture
        locationInView:[[UIApplication sharedApplication].delegate window]];
    if ([SimuUtil isLogined]) {
      //必须每次长按时指向block，否则会被cell复用机制覆盖掉
      [self setExtendButtonsBlock];
      //显示拓展按钮
      [WeiBoExtendButtons showWithBarTopTweetData:_topData
                                          offsetY:loc.y
                                             cell:self];
    }
  }
}

#pragma mark 设置拓展按钮的block
- (void)setExtendButtonsBlock {
  //实现拓展按钮block
  WeiBoExtendButtons *extendButtons = [WeiBoExtendButtons sharedExtendButtons];
  //置顶按钮
  [extendButtons
      setExtendTopButtonClickBlock:^(TweetListItem *item, NSObject *cell) {
        AllChatStockTopTVCell *strongCell = (AllChatStockTopTVCell *)cell;
        if ([strongCell isKindOfClass:[AllChatStockTopTVCell class]] &&
            strongCell.topTopButtonClickBlock) {
          strongCell.topTopButtonClickBlock(); //直接刷新置顶区
        }
      }];
  //取消置顶按钮
  [extendButtons
      setExtendUnTopButtonClickBlock:^(NSNumber *tid, NSObject *cell) {
        AllChatStockTopTVCell *strongCell = (AllChatStockTopTVCell *)cell;
        if ([strongCell isKindOfClass:[AllChatStockTopTVCell class]] &&
            strongCell.topUnTopButtonClickBlock) {
          strongCell.topUnTopButtonClickBlock(); //直接刷新置顶区
        }
      }];

  //加精按钮
  [extendButtons setExtendEliteButtonClickBlock:^(BOOL isElite, NSNumber *tid,
                                                  NSObject *cell) {
    AllChatStockTopTVCell *strongCell = (AllChatStockTopTVCell *)cell;
    if ([strongCell isKindOfClass:[AllChatStockTopTVCell class]] &&
        strongCell.topEliteButtonClickBlock) {
      strongCell.topEliteButtonClickBlock(isElite, tid);
    }
  }];

  //删除按钮
  [extendButtons
      setExtendDeleteButtonClickBlock:^(NSNumber *tid, NSObject *cell) {
        AllChatStockTopTVCell *strongCell = (AllChatStockTopTVCell *)cell;
        if ([strongCell isKindOfClass:[AllChatStockTopTVCell class]] &&
            strongCell.topDeleteButtonClickBlock) {
          strongCell.topDeleteButtonClickBlock(tid);
        }
      }];
}

#pragma mark 重设信息
- (void)refreshInfoWithBarTopTweetData:(BarTopTweetData *)topData {
  //处理'\n','\r'
  NSString *tweetTitle = topData.title;
  tweetTitle = [SimuUtil stringReplaceSpaceAndNewlinew:tweetTitle];

  _titleView.text = tweetTitle;
  [_titleView setBoldTextSize:Font_Height_14_0];
  [_titleView fitToSuggestedHeight];
  _titleViewHeight.constant = _titleView.height;
  _topData = topData;

  //如果为1，显示加精
  _eliteImageView.hidden = !(topData.elite == 1);
}

- (void)resetEliteIcon:(BOOL)isElite {
  _eliteImageView.hidden = !isElite;
}

+ (CGFloat)heightFromTitle:(NSString *)title {
  title = [SimuUtil stringReplaceSpaceAndNewlinew:title];
  return [FTCoreTextView heightWithText:title
                                  width:(WIDTH_OF_SCREEN - 68.f)
                                   font:Font_Height_14_0] +
         20.f;
}

#pragma mark - 重设cell选中和未选中状态颜色
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
  if (highlighted) {
    self.backgroundColor = [Globle colorFromHexRGB:Color_WeiboButtonPressDown];
  } else {
    self.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  }
}

#pragma mark - cell左右滑动背景色还原
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  self.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
}

@end
