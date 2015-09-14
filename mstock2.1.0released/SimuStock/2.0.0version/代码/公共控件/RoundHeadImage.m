//
//  RoundHeadImage.m
//  SimuStock
//
//  Created by Mac on 15/5/5.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "RoundHeadImage.h"
#import "Globle.h"
#import "HomepageViewController.h"
#import "UIImageView+WebCache.h"

@implementation RoundHeadImage {
  UserListItem *_user;
}

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self createSubViews];
  }
  return self;
}
- (void)awakeFromNib {
  [super awakeFromNib];
  if (_headPicImageView == nil) {
    [self createSubViews];
  }
}

- (void)createSubViews {
  static CGFloat gap = 2.0f;
  if (fabs(self.frame.size.width - self.frame.size.height) > 0.1) {
    [NSException raise:@"not equal" format:@"head image's width and height are not equal"];
  }
  CGFloat width = self.frame.size.width;
  _headPicImageView.clipsToBounds = YES;
  self.layer.cornerRadius = width / 2.0f;
  self.backgroundColor = [UIColor whiteColor];

  //创建头像
  _headPicImageView =
      [[UIImageView alloc] initWithFrame:CGRectMake(gap, gap, width - 2 * gap, width - 2 * gap)];
  _headPicImageView.backgroundColor = [Globle colorFromHexRGB:@"87c8f1"];
  _headPicImageView.layer.cornerRadius = _headPicImageView.bounds.size.width / 2.0f;
  _headPicImageView.clipsToBounds = YES;
  [self addSubview:_headPicImageView];

  //创建点击按钮
  _headPicBotton = [[BGColorUIButton alloc] initWithFrame:self.bounds];
  _headPicBotton.layer.borderWidth = 0.5f;
  _headPicBotton.layer.borderColor = [[Globle colorFromHexRGB:Color_Border] CGColor];
  _headPicBotton.layer.cornerRadius = width / 2.0f;
  _headPicBotton.normalBGColor = [UIColor clearColor];
  _headPicBotton.highlightBGColor = [Globle colorFromHexRGB:@"#939393" alpha:0.33f];
  [self addSubview:_headPicBotton];

  __weak RoundHeadImage *weakSelf = self;

  [_headPicBotton setOnButtonPressedHandler:^{
    RoundHeadImage *strongSelf = weakSelf;
    if (strongSelf) {
      [HomepageViewController showWithUserId:[strongSelf.user.userId stringValue]
                                   titleName:strongSelf.user.nickName
                                     matchId:MATCHID];
    }
  }];
}

- (void)bindUserListItem:(UserListItem *)user {
  _user = user;
  //  [_headPicImageView setImage:[UIImage imageNamed:@"用户默认头像"]];
  [_headPicImageView setImageWithURL:[NSURL URLWithString:user.headPic]
                    placeholderImage:[UIImage imageNamed:@"用户默认头像"]];
}

- (void)bindlittleCattleUserListItem:(UserListItem *)user {
  _user = user;
  [_headPicImageView setImageWithURL:[NSURL URLWithString:user.headPic]
                    placeholderImage:[UIImage imageNamed:@"最终牛"]];
}

@end
