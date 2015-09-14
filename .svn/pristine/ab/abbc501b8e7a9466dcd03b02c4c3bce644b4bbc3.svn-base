//
//  UserGradeView.m
//  SimuStock
//
//  Created by Mac on 15/5/5.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "UserGradeView.h"

#import "UserListItem.h"
#import "Flowers.h"

#import "HomepageViewController.h"

#define SPACE_BETWEEN_UI 3

@implementation UserGradeView

- (void)awakeFromNib {
  [super awakeFromNib];
  if (_lblNickName == nil) {
    [self createSubViews];
  }
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    if (_lblNickName == nil) {
      [self createSubViews];
    }
  }
  return self;
}

- (void)createSubViews {
  self.backgroundColor = [UIColor clearColor];
  CGFloat height = 16.0f;
  _lblNickName = [[TitleColorChangedUIButton alloc] initWithFrame:CGRectMake(0, 0, 0, height)];
  _lblNickName.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
  _lblNickName.titleLabel.font = [UIFont systemFontOfSize:Font_Height_14_0];
  _lblNickName.highlightTitleColor = [Globle colorFromHexRGB:Color_Text_Common];

  _flowers = [[Flowers alloc] initWithFrame:CGRectMake(0, 0, height, height)];
  _flowers.backgroundColor = [UIColor clearColor];

  _crownImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 19, height)];
  _realTradeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, height, height)];
  _realTradeImageView.image = [UIImage imageNamed:@"real_logo"];
  _originalPosterImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 22, height)];
  _originalPosterImageView.image = [UIImage imageNamed:@"originalPoster"];

  _showUserGrade = YES;
  _showVip = YES;
  _showRealTrade = YES;
  _showOriginalPoster = YES;

  [self addSubview:_lblNickName];
  [self addSubview:_flowers];
  [self addSubview:_crownImageView];
  [self addSubview:_realTradeImageView];
  [self addSubview:_originalPosterImageView];

  _flowers.hidden = YES;
  _crownImageView.hidden = YES;
  _realTradeImageView.hidden = YES;
  _originalPosterImageView.hidden = YES;

  __weak UserGradeView *weakSelf = self;
  [_lblNickName setOnButtonPressedHandler:^{
    UserGradeView *strongSelf = weakSelf;
    if (strongSelf) {
      [HomepageViewController showWithUserId:[strongSelf.user.userId stringValue]
                                   titleName:strongSelf.user.nickName
                                     matchId:@"1"];
    }
  }];
}

- (void)bindUserListItem:(UserListItem *)item isOriginalPoster:(BOOL)isOriginalPoster {
  _user = item;
  _isOriginalPoster = isOriginalPoster;

  BOOL isVip = (item.vipType == VipUser || item.vipType == SVipUser);
  _lblNickName.normalTitleColor = [Globle colorFromHexRGB:isVip ? Color_Red : Color_Blue_but];

  //计算实际frame大小，并将label的frame变成实际大小
  CGSize labelsize = [item.nickName sizeWithFont:_lblNickName.titleLabel.font
                               constrainedToSize:CGSizeMake(600, 30)
                                   lineBreakMode:NSLineBreakByCharWrapping];

  CGFloat nicknameWidth = labelsize.width + 1; // pang010导致问题，加1即可

  CGFloat markWidth = 0.0f;
  int markNum = 0;

  _flowers.hidden = YES;
  if (_showUserGrade) {
    if (item.rating.length > 0) {
      [_flowers resetWithRating:item.rating];
      _flowers.hidden = NO;
      markWidth += _flowers.width;
      markNum++;
    }
  }

  //皇冠，38*28
  _crownImageView.hidden = YES;

  if (_showVip) {
    if (isVip) {
      _crownImageView.hidden = NO;
      _crownImageView.image =
          [UIImage imageNamed:(item.vipType == VipUser ? @"vip_logo" : @"svip_logo")];
      markWidth += _crownImageView.width;
      markNum++;
    }
  }

  //实盘标识，28*28
  _realTradeImageView.hidden = YES;

  if (_showRealTrade) {
    if (item.hasRealTradeAccount) {
      _realTradeImageView.hidden = NO;
      markWidth += _realTradeImageView.width;
      markNum++;
    }
  }

  //楼主44*28
  _originalPosterImageView.hidden = YES;
  if (_showOriginalPoster) {
    if (_isOriginalPoster) {
      _originalPosterImageView.hidden = NO;
      markWidth += _originalPosterImageView.width;
      markNum++;
    }
  }

  markWidth += SPACE_BETWEEN_UI * markNum;

  //绘制阶段
  if (markWidth + nicknameWidth > self.frame.size.width) {
    _contentWidth = self.frame.size.width;
    nicknameWidth = self.frame.size.width - markWidth;
  } else {
    _contentWidth = markWidth + nicknameWidth;
  }
  [_lblNickName setTitle:_user.nickName forState:UIControlStateNormal];
  _lblNickName.width = nicknameWidth;

  CGFloat start = nicknameWidth + SPACE_BETWEEN_UI;
  if (!_flowers.hidden) {
    _flowers.left = start;
    start += _flowers.width + SPACE_BETWEEN_UI;
  }

  if (!_crownImageView.hidden) {
    _crownImageView.left = start;
    start += _crownImageView.width + SPACE_BETWEEN_UI;
  }

  if (!_realTradeImageView.hidden) {
    _realTradeImageView.left = start;
    start += _realTradeImageView.width + SPACE_BETWEEN_UI;
  }

  if (!_originalPosterImageView.hidden) {
    _originalPosterImageView.left = start;
  }
}

/** 新的绑定方法 必须传入字体的大小 */
- (void)bindUserListItem:(UserListItem *)item
                withFont:(CGFloat)font
      withOriginalPoster:(BOOL)isOriginalPoster {
  _lblNickName.titleLabel.font = [UIFont systemFontOfSize:font];
  CGFloat tempHeight = font + 2.0f;
  _lblNickName.height = tempHeight;
  _flowers.width = tempHeight;
  _flowers.height = tempHeight;
  _crownImageView.height = tempHeight;
  _realTradeImageView.width = tempHeight;
  _realTradeImageView.height = tempHeight;
  _originalPosterImageView.height = tempHeight;
  [self bindUserListItem:item isOriginalPoster:isOriginalPoster];
}

@end
