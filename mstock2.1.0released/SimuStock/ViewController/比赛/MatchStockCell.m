//
//  MatchStockCell.m
//  SimuStock
//
//  Created by 刘小龙 on 15/6/24.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "MatchStockCell.h"
#import "SimuUtil.h"
#import "JhssImageCache.h"

@implementation MatchStockCell

- (void)awakeFromNib {
  self.width = WIDTH_OF_SCREEN;
  self.backgroundColor = [Globle colorFromHexRGB:@"#efefef"];
  //修改某些控件的属性
  _createMarkLabel.layer.cornerRadius = _createMarkLabel.bounds.size.height * 0.5;
  _createMarkLabel.layer.masksToBounds = YES;
  _topLable = [[TopAndBottomAlignmentLabel alloc] initWithFrame:CGRectZero];
  _topLable.backgroundColor = [UIColor clearColor];
  _topLable.font = [UIFont systemFontOfSize:Font_Height_13_0];
  _topLable.textAlignment = NSTextAlignmentLeft;
  _topLable.numberOfLines = 0;
  _topLable.textColor = [Globle colorFromHexRGB:Color_Icon_Title];
  [_matchView addSubview:_topLable];
  _isAwardLabel.layer.cornerRadius = 5.0;
  _isAwardLabel.layer.masksToBounds = YES;
  _isAwardLabel.hidden = YES;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  [self layoutIfNeeded];
  _topLable.frame = _matchView.bounds;
}

- (void)bindDataWithStockMatchItem:(StockMatchListItem *)stockMatchItem {
  //创 字的显示 和 隐藏
  NSString *selfUserID = [SimuUtil getUserID];
  if (stockMatchItem.inviteFlag) {
    self.createMarkLabel.text = @"验";
    self.createMarkLabel.hidden = NO;
    //创字
    if ([stockMatchItem.userId isEqualToString:selfUserID]) {
      self.createMarkLabel.text = @"创";
    }
  } else {
    if ([stockMatchItem.userId isEqualToString:selfUserID]) {
      self.createMarkLabel.text = @"创";
      self.createMarkLabel.hidden = NO;
    } else {
      self.createMarkLabel.hidden = YES;
    }
  }

  if (stockMatchItem.isReward) {
    self.isAwardLabel.hidden = NO;
    _matchDesViewHeight.constant = 40.0f;
  } else {
    self.isAwardLabel.hidden = YES;
    _matchDesViewHeight.constant = 30.0f;
  }

  //图片 先加载默认图
  [JhssImageCache setImageView:_matchIconImageView
                       withUrl:stockMatchItem.matchLogo
          withDefaultImageName:@"比赛默认图"];
  //比赛 名称
  self.matchNameLabel.text = stockMatchItem.matchName;
  [SimuUtil widthOfLabel:self.matchNameLabel font:14];
  _matchNameLabelW.constant = self.matchNameLabel.frame.size.width;
  self.diamondImageView.frame = CGRectMake(CGRectGetMaxX(self.matchNameLabel.frame) + 10, 6, 22, 16);
  //是否为钻石比赛
  self.diamondImageView.hidden = !stockMatchItem.signupFlag;

  //创建人
  self.creatorLabel.text = [NSString stringWithFormat:@"创建人：%@", stockMatchItem.creator];

  //时间
  self.matchDeadLineLabel.text =
      [NSString stringWithFormat:@"%@至%@", stockMatchItem.openTime, stockMatchItem.closeTime];
  // self.matchDetailLabel.text = sotckListItem.mMatchDescp;
  self.topLable.text = stockMatchItem.matchDescp;
  self.joinNumberLable.text = [NSString stringWithFormat:@"%ld", (long)stockMatchItem.matchNum];
}

@end
