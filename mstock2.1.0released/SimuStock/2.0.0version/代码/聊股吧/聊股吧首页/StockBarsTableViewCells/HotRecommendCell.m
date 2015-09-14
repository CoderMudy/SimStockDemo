//
//  HotRecommendTableViewCell.m
//  SimuStock
//
//  Created by Yuemeng on 14-11-24.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "HotRecommendCell.h"
#import "Globle.h"
#import "CellBottomLinesView.h"
#import "SimuUtil.h"

#define LEFT_DISTANCE 12.5f //左间距25
#define TOP_DISTANCE 14.0f  //上间距28
#define CELL_HEIGHT 61.0f   // cell高122

@implementation HotRecommendCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // Initialization code
    self.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
    [self createUI];
  }
  return self;
}

#pragma mark - 创建UI
- (void)createUI {
  // cell 自身高度138
  //标题 距左25，距上28，字体粗体28， 颜色#454545
  _titleLabel = [[UILabel alloc]
      initWithFrame:CGRectMake(LEFT_DISTANCE, TOP_DISTANCE,
                               WIDTH_OF_VIEW - LEFT_DISTANCE * 2,
                               TOP_DISTANCE)];
  _titleLabel.textColor = [Globle colorFromHexRGB:Color_Text_Common];
  _titleLabel.font = [UIFont systemFontOfSize:Font_Height_14_0];
  _titleLabel.backgroundColor = [UIColor clearColor];
  [self.contentView addSubview:_titleLabel];

  //用户名button，为了方便用户点击，button范围最大化
  //点击进入主页 距左25 距上56 宽26*7=156（6个中文字） 高66
  _userNameButton = [UIButton buttonWithType:UIButtonTypeCustom];
  _userNameButton.frame = CGRectMake(LEFT_DISTANCE, 28.0f, 91.0f, 33.0f);
  _userNameButton.backgroundColor = [UIColor clearColor];
  [_userNameButton setTitleColor:[Globle colorFromHexRGB:Color_Icon_Title] forState:UIControlStateHighlighted];
  _userNameButton.contentHorizontalAlignment =
      UIControlContentHorizontalAlignmentLeft;
  _userNameButton.titleLabel.font = [UIFont systemFontOfSize:Font_Height_13_0];
  [_userNameButton addTarget:self
                      action:@selector(userNameButtonClick:)
            forControlEvents:UIControlEventTouchUpInside];
  [self.contentView addSubview:_userNameButton];

  //评论 剧右242 剧上56+22=78 宽136 高22 颜色#939393
  _commentLabel = [[UILabel alloc]
      initWithFrame:CGRectMake(WIDTH_OF_VIEW - 121.0f, 39.0f, 68.0f, 11.0f)];
  _commentLabel.textColor = [Globle colorFromHexRGB:Color_Gray];
  _commentLabel.font = [UIFont systemFontOfSize:Font_Height_11_0];
  _commentLabel.backgroundColor = [UIColor clearColor];
  [self.contentView addSubview:_commentLabel];

  //赞
  //评论 剧左106 剧上56+22=78 宽106 高22 颜色#939393
  _praiseLabel = [[UILabel alloc]
      initWithFrame:CGRectMake(WIDTH_OF_VIEW - 53.0f, 39.0f, 53.0f, 11.0f)];
  _praiseLabel.textColor = [Globle colorFromHexRGB:Color_Gray];
  _praiseLabel.font = [UIFont systemFontOfSize:Font_Height_11_0];
  _praiseLabel.backgroundColor = [UIColor clearColor];
  [self.contentView addSubview:_praiseLabel];

    //底线
  _cellBottomLinesView = [CellBottomLinesView addBottomLinesToCell:self];
}

#pragma mark - 用户名回调
- (void)userNameButtonClick:(UIButton *)userNameButton {
  //打开个人主页
  __weak HotRecommendCell *weakSelf = self;
  [_userNameButton setTitleColor:[Globle colorFromHexRGB:Color_Icon_Title] forState:UIControlStateNormal];
  [SimuUtil performBlockOnMainThread:^{
    [_userNameButton setTitleColor:[weakSelf colorWithVIPType:_vipType] forState:UIControlStateNormal];
    _userNameButtonBlock(_uid, _nickName);
  } withDelaySeconds:0.2];
}

#pragma mark - 对法方法
- (void)setInfo {
  _titleLabel.text = _title;
  
  [SimuUtil widthOfButton:_userNameButton title:_nickName titleColor:[self colorWithVIPType:_vipType] font:Font_Height_14_0];

  NSMutableAttributedString *commentAttr = [[NSMutableAttributedString alloc]
      initWithString:[NSString stringWithFormat:@"评论：%@", _comment]];
  [commentAttr addAttribute:NSForegroundColorAttributeName
                      value:[Globle colorFromHexRGB:Color_Blue_but]
                      range:NSMakeRange(3, commentAttr.length-3)];
  _commentLabel.attributedText = commentAttr;

  NSMutableAttributedString *praiseAttr = [[NSMutableAttributedString alloc]
      initWithString:[NSString stringWithFormat:@"赞：%@", _praise]];
  [praiseAttr addAttribute:NSForegroundColorAttributeName
                     value:[Globle colorFromHexRGB:Color_Blue_but]
                     range:NSMakeRange(2, praiseAttr.length-2)];
  _praiseLabel.attributedText = praiseAttr;
}

  //根据vip类型返回颜色
- (UIColor *)colorWithVIPType:(NSInteger)vipType {
  if (vipType == 1 || vipType == 2) {
    return [Globle colorFromHexRGB:Color_Red];
  } else {
    return [Globle colorFromHexRGB:Color_Blue_but];
  }
}
  ///隐藏底线方法
- (void)hideCellBottomLinesView:(BOOL)hide
{
  hide ? (_cellBottomLinesView.hidden = YES) : (_cellBottomLinesView.hidden = NO);
}

- (void)awakeFromNib {
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}

@end
