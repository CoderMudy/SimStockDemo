//
//  TradeDetailNewCell.m
//  SimuStock
//
//  Created by jhss on 15/7/8.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "TradeDetailNewCell.h"

@implementation TradeDetailNewCell

- (void)awakeFromNib {

  self.selectionStyle = UITableViewCellSelectionStyleDefault;
  //取消选中效果
  UIView *backView = [[UIView alloc] initWithFrame:self.frame];
  self.selectedBackgroundView = backView;
  self.selectedBackgroundView.backgroundColor = [Globle colorFromHexRGB:@"#d9ecf2"];

  self.backgroundColor = [Globle colorFromHexRGB:@"f7f7f7"];

  _tradeBackImage.layer.cornerRadius = 12;
  _tradeBackImage.layer.masksToBounds = YES;
  _whiteImageView.layer.cornerRadius = 14;
  _whiteImageView.layer.masksToBounds = YES;

  _grayLineHeightV.constant = .5f;
  _bigGrayWidth.constant = 1;
  _smallGrayWidth.constant = 1;
  //设置股票信息字体
  [_coreTextView setTextColor:[Globle colorFromHexRGB:@"454545"]];
  [_coreTextView setTextSize:15];
}

//设置页面信息
- (void)bindClosedDetailInfo:(ClosedDetailInfo *)info {

  self.info = info;
  _timeLabel.text = info.createTime;
  info.content = [SimuUtil stringReplaceSpace:(info.content.length > 0 ? info.content : @"")];
  _coreTextView.text = info.content;
  [_coreTextView fitToSuggestedHeight];
  _coreTextHeight.constant = _coreTextView.height;

  if ([info.type isEqualToString:@"8"]) {
    _tradeImageView.image = [UIImage imageNamed:@"买入"];

  } else if ([info.type isEqualToString:@"32"]) {
    _tradeImageView.image = [UIImage imageNamed:@"分红派送小标"];

  } else {
    _tradeImageView.image = [UIImage imageNamed:@"卖出"];
  }
}

- (void)enableSellButton:(BOOL)enable {
  if (enable) {
    _selBtn.enabled = YES;
    [_selBtn setImage:[UIImage imageNamed:@"卖出蓝色图标"] forState:UIControlStateNormal];
    [_selBtn setTitleColor:[Globle colorFromHexRGB:Color_Blue_but] forState:UIControlStateNormal];
    [_selBtn setBackgroundImage:[UIImage imageNamed:@"点击背景图"]
                       forState:UIControlStateHighlighted];
  } else {
    _selBtn.enabled = NO;
    [_selBtn setImage:[UIImage imageNamed:@"卖出_不能操作状态"] forState:UIControlStateNormal];
    [_selBtn setTitleColor:[Globle colorFromHexRGB:Color_Gray] forState:UIControlStateNormal];
    [_selBtn setBackgroundImage:[UIImage imageNamed:nil] forState:UIControlStateHighlighted];
  }
}

+ (CGFloat)cellHeightWithTweetListItem:(ClosedDetailInfo *)info withShowButtons:(BOOL)showButtons {

  info.heightCache[HeightCachKeyContent] =
      @([FTCoreTextView heightWithText:info.content width:271 font:Font_Height_14_0]);
  CGFloat otherHeight = showButtons ? 80.f : 50.f;
  return otherHeight + [info.heightCache[HeightCachKeyContent] floatValue];
}

@end
