//
//  TradeRecordTableViewCell.m
//  SimuStock
//
//  Created by Mac on 15/7/15.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "TradeRecordTableViewCell.h"
#import "UIButton+Block.h"

@implementation TradeRecordTableViewCell

- (void)awakeFromNib {
  //设置点击背景
  UIImageView *backGroundView = [[UIImageView alloc]
      initWithImage:[UIImage imageNamed:@"select_middle.png"]];
  self.backgroundView = backGroundView;
  self.backgroundView.hidden = YES;

  _bgWhite.layer.cornerRadius = 13.f;
  _bgLogo.layer.cornerRadius = 11.f;

  UIImage *sellDownImage = [UIImage imageNamed:@"点击背景图.png"];
  [_btnBuy setBackgroundImage:sellDownImage forState:UIControlStateHighlighted];
  [_btnSell setBackgroundImage:sellDownImage
                      forState:UIControlStateHighlighted];

  [_btnSell setTitleColor:[Globle colorFromHexRGB:Color_Gray]
                 forState:UIControlStateDisabled];
  [_btnSell setImage:[UIImage imageNamed:@"卖出_不能操作状态.png"]
            forState:UIControlStateDisabled];

  __weak TradeRecordTableViewCell *weakSelf = self;
  [_btnBuy setOnButtonPressedHandler:^{
    TradeRecordTableViewCell *strongSelf = weakSelf;
    if (strongSelf.buyAction) {
      strongSelf.buyAction(strongSelf.tradeRecordInfo);
    }
  }];

  [_btnSell setOnButtonPressedHandler:^{
    TradeRecordTableViewCell *strongSelf = weakSelf;
    if (strongSelf.sellAction) {
      strongSelf.sellAction(strongSelf.tradeRecordInfo);
    }
  }];
  _tradeInfoView.beginTouchAction = ^{
    weakSelf.highlighted = YES;
  };
  _tradeInfoView.endTouchAction = ^{
    weakSelf.highlighted = NO;
  };
}

CGFloat adjustHeightForRichContent(ClosedDetailInfo *tradeRecord) {
  CGFloat richContentHeight;
  if (tradeRecord.adjustHeight == nil) {
    CGFloat contentWidth = WIDTH_OF_SCREEN - 70.f;
    richContentHeight = [FTCoreTextView heightWithText:tradeRecord.content
                                                 width:contentWidth
                                                  font:Font_Height_14_0];
    tradeRecord.adjustHeight = @(richContentHeight);
  } else {
    richContentHeight = [tradeRecord.adjustHeight doubleValue];
  }
  return richContentHeight;
}

+ (CGFloat)adjustHeightForTradeRecord:(ClosedDetailInfo *)tradeRecord {
  return adjustHeightForRichContent(tradeRecord) + 70.f;
}

- (void)bindClosedDetailInfo:(ClosedDetailInfo *)tradeRecordInfo {
  self.tradeRecordInfo = tradeRecordInfo;
  _lblTime.text = tradeRecordInfo.createTime;
  _tradeInfoView.text = tradeRecordInfo.content;
  [_tradeInfoView fitToSuggestedHeight];
  _tradeInfoHeight.constant = adjustHeightForRichContent(tradeRecordInfo);

  if ([tradeRecordInfo.type isEqualToString:@"8"]) {
    _ivLogo.image = [UIImage imageNamed:@"买入"];
  } else if ([tradeRecordInfo.type isEqualToString:@"32"]) {
    _ivLogo.image = [UIImage imageNamed:@"分红派送小标"];
  } else {
    _ivLogo.image = [UIImage imageNamed:@"卖出"];
  }
}

@end
