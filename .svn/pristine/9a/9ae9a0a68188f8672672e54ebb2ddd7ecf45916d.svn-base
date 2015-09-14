//
//  UserGradeWidget.m
//  SimuStock
//
//  Created by Yuemeng on 15/3/3.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "UserGradeWidget.h"
#import "UserListItem.h"
#import "Flowers.h"

#define SPACE_BETWEEN_UI 3

@implementation UserGradeWidget

///可限定长度
- (void)resetInfoAndFrameWithItem:(UserListItem *)item
                     nickNameView:(UIView *)nickNameView
                        maxLength:(CGFloat)maxLength {
  self.hidden = !item;

  CGFloat offsetY = (nickNameView.bounds.size.height - 14) / 2.0f;
  self.frame = CGRectMake(nickNameView.frame.origin.x + nickNameView.bounds.size.width + 5,
                          nickNameView.frame.origin.y + offsetY, 100, 14);
  [self drawFlowersWithItem:item];
  //自身宽度不能改变，只能缩小nickNameView宽度
  CGFloat overWidth = nickNameView.bounds.size.width + _currentWidth - maxLength;
  if (overWidth > 0) {
    //缩小nickNameView宽度
    CGRect frame = nickNameView.frame;
    frame.size.width -= overWidth;
    nickNameView.frame = frame;
    //再重设自身宽度
    self.frame = CGRectMake(nickNameView.frame.origin.x + nickNameView.bounds.size.width + 5,
                            nickNameView.frame.origin.y + offsetY, 100, 14);
  }
}

/// 320宽度时，整体居中
- (void)resetInfoAndCenterFrameWithItem:(UserListItem *)item nickNameView:(UIView *)nickNameView {
  self.hidden = !item;

  CGFloat offsetY = (nickNameView.bounds.size.height - 14) / 2.0f;
  self.frame = CGRectMake(nickNameView.frame.origin.x + nickNameView.bounds.size.width + 5,
                          nickNameView.frame.origin.y + offsetY, 100, 14);
  [self drawFlowersWithItem:item];
  //自身宽度不能改变，只能缩小nickNameView宽度
  CGFloat overWidth = nickNameView.bounds.size.width + _currentWidth - WIDTH_OF_SCREEN;
  //连320屏幕宽度都超了。。。
  if (overWidth > 0) {
    //缩小nickNameView宽度
    CGRect frame = nickNameView.frame;
    frame.size.width -= overWidth;
    nickNameView.frame = frame;
    //再重设自身宽度
    self.frame = CGRectMake(nickNameView.frame.origin.x + nickNameView.bounds.size.width + 5,
                            nickNameView.frame.origin.y + offsetY, 100, 14);
    //如果没有超过320屏幕宽度，调整用户名起始坐标
  } else {
    CGFloat offsetX = -overWidth / 2.0f;
    CGRect frame = nickNameView.frame;
    frame.origin.x = offsetX;
    nickNameView.frame = frame;
    //再重设自身宽度
    self.frame = CGRectMake(nickNameView.frame.origin.x + nickNameView.bounds.size.width + 5,
                            nickNameView.frame.origin.y + offsetY, 100, 14);
  }
}

//不带花，牛人排行专用
- (void)resetInfoAndFrameNoFlowerWithItem:(UserListItem *)item
                             nickNameView:(UIView *)nickNameView
                                maxLength:(CGFloat)maxLength {
  UserListItem *noFlowerItem = [[UserListItem alloc] init];
  noFlowerItem.rating = nil;
  noFlowerItem.vipType = item.vipType;
  noFlowerItem.stockFirmFlag = item.stockFirmFlag;

  [self resetInfoAndFrameWithItem:noFlowerItem nickNameView:nickNameView maxLength:maxLength];
}

//不带花，主页专用(320居中)
- (void)resetInfoAndCenterFrameNoFlowerWithItem:(UserListItem *)item
                                   nickNameView:(UIView *)nickNameView {
  UserListItem *noFlowerItem = [[UserListItem alloc] init];
  noFlowerItem.rating = nil;
  noFlowerItem.vipType = item.vipType;
  noFlowerItem.stockFirmFlag = item.stockFirmFlag;

  [self resetInfoAndCenterFrameWithItem:noFlowerItem nickNameView:nickNameView];
}

- (void)drawFlowersWithItem:(UserListItem *)item {
  //本控件的宽度随个数改变，高度固定16

  _currentWidth = 0.0f;

  //花，14*14
  if (item.rating.length > 0) {
    _isHasFlowers = YES;
    if (_flowers) {
      [_flowers resetWithRating:item.rating];
    } else {
      _flowers = [[Flowers alloc] initWithRating:item.rating];
      [self addSubview:_flowers];
    }
    _flowers.hidden = NO;
    _currentWidth += _flowers.bounds.size.width;
  } else {
    _isHasFlowers = NO;
    _flowers.hidden = YES;
  }

  //皇冠，38*28
  if (item.vipType == VipUser || item.vipType == SVipUser) {
    _isHasCrown = YES;

    CGFloat offsetX = 0;
    offsetX += (_isHasFlowers ? (_flowers.bounds.size.width + SPACE_BETWEEN_UI) : 0);
    CGRect offsetRect = CGRectMake(offsetX, 0, 19, 14);

    if (!_crown) {
      _crown = [[UIImageView alloc] initWithFrame:offsetRect];
      [self addSubview:_crown];
    } else {
      //调整位置
      _crown.frame = offsetRect;
    }

    if (item.vipType == VipUser) {
      _crown.image = [UIImage imageNamed:@"vip_logo"];
    } else if (item.vipType == SVipUser) {
      _crown.image = [UIImage imageNamed:@"svip_logo"];
    }
    _crown.hidden = NO;
    _currentWidth += SPACE_BETWEEN_UI + _crown.bounds.size.width;
  } else {
    _isHasCrown = NO;
    _crown.hidden = YES;
  }

  //实盘标识，28*28
  if (item.hasRealTradeAccount) {
    _isHasReal = YES;

    CGFloat offsetX = 0;
    offsetX += (_isHasFlowers ? (_flowers.bounds.size.width + SPACE_BETWEEN_UI) : 0);
    offsetX += (_isHasCrown ? (_crown.bounds.size.width + SPACE_BETWEEN_UI) : 0);
    CGRect offsetRect = CGRectMake(offsetX, 0, 14, 14);

    if (!_realTrade) {
      _realTrade = [[UIImageView alloc] initWithFrame:offsetRect];
      _realTrade.image = [UIImage imageNamed:@"real_logo"];
      [self addSubview:_realTrade];
    } else {
      _realTrade.frame = offsetRect;
    }
    _realTrade.hidden = NO;
    _currentWidth += SPACE_BETWEEN_UI + _realTrade.bounds.size.width;
  } else {
    _isHasReal = NO;
    _realTrade.hidden = YES;
  }

  //楼主44*28
  if (_isOriginalPoster) {

    CGFloat offsetX = 0;
    offsetX += (_isHasFlowers ? (_flowers.bounds.size.width + SPACE_BETWEEN_UI) : 0);
    offsetX += (_isHasCrown ? (_crown.bounds.size.width + SPACE_BETWEEN_UI) : 0);
    offsetX += (_isHasReal ? (_realTrade.bounds.size.width + SPACE_BETWEEN_UI) : 0);

    CGRect offsetRect = CGRectMake(offsetX, 0, 22, 14);

    if (!_originalPoster) {
      _originalPoster = [[UIImageView alloc] initWithFrame:offsetRect];
      _originalPoster.image = [UIImage imageNamed:@"originalPoster"];
      [self addSubview:_originalPoster];
    } else {
      _originalPoster.frame = offsetRect;
    }
    _originalPoster.hidden = NO;
    self.isOriginalPoster = NO; //防止复用后其他人也变楼主
    _currentWidth += SPACE_BETWEEN_UI + _originalPoster.bounds.size.width;
  } else {
    _originalPoster.hidden = YES;
  }

  //重设自身宽度
  CGRect frame = self.frame;
  frame.size.width = _currentWidth;
  self.frame = frame;
}

@end
