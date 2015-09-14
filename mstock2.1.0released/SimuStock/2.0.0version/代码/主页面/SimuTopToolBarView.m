//
//  simuTopToolBarView.m
//  SimuStock
//
//  Created by Mac on 14-7-8.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "SimuTopToolBarView.h"
#import "JhssImageCache.h"

@implementation SimuTopToolBarView
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
      isvc_stateBarHeight = 20;
    } else {
      isvc_stateBarHeight = 0;
    }

    self.backgroundColor = [Globle colorFromHexRGB:Color_Blue_but];
    [self creatview:frame];
    [self updateHeadPic];
    [self addObserver];
  }
  return self;
}

- (void)creatview:(CGRect)frame {

  //头像 原版本的
  sttbv_headimageview =
  [[UIImageView alloc] initWithFrame:CGRectMake((51.0 - TOP_TABBAR_HEIGHT) / 2, (41.0 - TOP_TABBAR_HEIGHT) / 2 + isvc_stateBarHeight,
                                                TOP_TABBAR_HEIGHT, TOP_TABBAR_HEIGHT)];
  
//  //头像 现在版本
//  sttbv_headimageview = [[UIImageView alloc] initWithFrame:CGRectMake(12, self.height - TOP_TABBAR_HEIGHT - 6.5, TOP_TABBAR_HEIGHT, TOP_TABBAR_HEIGHT)];
  [sttbv_headimageview setBackgroundColor:[Globle colorFromHexRGB:@"87c8f1"]];
  CALayer *layer = sttbv_headimageview.layer;
  //原版本的 带白线的 头像
  [layer setBorderWidth:2.0f];
  [layer setBorderColor:[UIColor whiteColor].CGColor];
  [layer setMasksToBounds:YES];
  [layer setCornerRadius:TOP_TABBAR_HEIGHT / 2];
  sttbv_headimageview.tag = 101;
  [self addSubview:sttbv_headimageview];

  //设置用户头像按钮
  UIButton *avatarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  avatarBtn.backgroundColor = [UIColor clearColor];
  //原版本的 button frame
  avatarBtn.frame = CGRectMake((51.0 - 36.0) / 2, (41.0 - 36.0) / 2 + isvc_stateBarHeight, 36.0, 36.0);
  //改版后的 button frame
//  avatarBtn.frame = sttbv_headimageview.frame;
  [avatarBtn.layer setMasksToBounds:YES];
  avatarBtn.layer.cornerRadius = TOP_TABBAR_HEIGHT / 2;
  UIImage *backImage = [UIImage imageNamed:@"比赛按钮高亮状态"];
  avatarBtn.alpha = 0.75;
  [avatarBtn setBackgroundImage:backImage forState:UIControlStateHighlighted];
  avatarBtn.tag = 1001;
  [avatarBtn addTarget:self
                action:@selector(sysmsgButtonDown:)
      forControlEvents:UIControlEventTouchUpInside];
  [self addSubview:avatarBtn];
  //设置信封
  _btnSystemMessage = [UIButton buttonWithType:UIButtonTypeCustom];
  _btnSystemMessage.tag = 1002;
  //原版本 信封的 frame
  _btnSystemMessage.frame = CGRectMake(self.bounds.size.width - 47, isvc_stateBarHeight, 47, 43);
  //改版后 信息的 frame
//  _btnSystemMessage.frame = CGRectMake(self.bounds.size.width - NAVIGATION_VIEW_HEIGHT, 0 , NAVIGATION_VIEW_HEIGHT, NAVIGATION_VIEW_HEIGHT);
//  _btnSystemMessage.center = CGPointMake(_btnSystemMessage.center.x, 52 * 0.5 + isvc_stateBarHeight);
  [_btnSystemMessage setImage:[UIImage imageNamed:@"信息小图标"] forState:UIControlStateNormal];
  [_btnSystemMessage setBackgroundImage:[UIImage imageNamed:@"return_touch_down.png"]
                               forState:UIControlStateHighlighted];
  [_btnSystemMessage addTarget:self
                        action:@selector(sysmsgButtonDown:)
              forControlEvents:UIControlEventTouchUpInside];
  [self addSubview:_btnSystemMessage];

  //大红点
  redDotImage =
      [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width - 22, isvc_stateBarHeight, 20, 20)];
  redDotImage.backgroundColor = [Globle colorFromHexRGB:@"#dd2526"];
  [redDotImage.layer setMasksToBounds:YES];
  [redDotImage.layer setCornerRadius:10.0f];
  [self addSubview:redDotImage];
  //大红点内容
  redDotLabel =
      [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width - 22, isvc_stateBarHeight, 20, 20)];
  redDotLabel.text = @"99";
  redDotLabel.backgroundColor = [UIColor clearColor];
  redDotLabel.textColor = [Globle colorFromHexRGB:@"#ffffff"];
  redDotLabel.textAlignment = NSTextAlignmentCenter;
  redDotLabel.font = [UIFont systemFontOfSize:13];
  [self addSubview:redDotLabel];
  [self setUnReadMessageNum:0];
  [self resetUnReadNum];

  if (![SimuUtil isLogined]) {
    _btnSystemMessage.hidden = YES;
  }
}

- (void)resetUnReadNum {
  UserBpushInformationNum *savedCount = [UserBpushInformationNum getUnReadObject];
  [self setUnReadMessageNum:[savedCount getCount:UserBpushAllCount]];
}

- (void)setUnReadMessageNum:(NSInteger)unReadMessageNum {
  ///当信封被隐藏以后，红气泡也要yinc
  if (_btnSystemMessage.hidden) {
    redDotImage.hidden = YES;
    redDotLabel.hidden = YES;
    return;
  }
  redDotLabel.hidden = unReadMessageNum <= 0;
  redDotImage.hidden = unReadMessageNum <= 0;

  if (unReadMessageNum < 100) {
    redDotLabel.text = [NSString stringWithFormat:@"%ld", (long)unReadMessageNum];
    redDotLabel.font = [UIFont systemFontOfSize:13];
  } else {
    redDotLabel.text = @"99+";
    redDotLabel.font = [UIFont systemFontOfSize:9];
  }
}

- (void)sysmsgButtonDown:(UIButton *)button {
  if (button.tag == 1001) {
    //点击图片
    if (_delegate && [_delegate respondsToSelector:@selector(buttonPressDown:)]) {
      [_delegate buttonPressDown:1001];
    }
  } else if (button.tag == 1002) {
    //点击信封
    if (_delegate && [_delegate respondsToSelector:@selector(buttonPressDown:)]) {
      [_delegate buttonPressDown:1002];
    }
  }
}

- (void)addObserver {
  _userInfoNotificationUtil = [[UserInfoNotificationUtil alloc] init];
  __weak SimuTopToolBarView *weakSelf = self;
  OnUserInfoChanging action = ^{
    [weakSelf updateHeadPic];
  };
  _userInfoNotificationUtil.onNicknameChangeAction = action;
  _userInfoNotificationUtil.onHeadPicChangeAction = action;

  _loginLogoutNotification = [[LoginLogoutNotification alloc] init];
  _loginLogoutNotification.onLoginLogout = ^{
    [weakSelf updateHeadPic];
  };

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(resetUnReadNum)
                                               name:MessageCenterNotification
                                             object:nil];
}

- (void)updateHeadPic {
  if ([SimuUtil isLogined]) {
    [JhssImageCache setImageView:sttbv_headimageview
                         withUrl:[SimuUtil getUserImageURL]
            withDefaultImageName:@"用户默认头像"];
    _btnSystemMessage.hidden = NO;
    [self resetUnReadNum];
  } else {
    _btnSystemMessage.hidden = YES;
    redDotLabel.hidden = YES;
    redDotImage.hidden = YES;
    sttbv_headimageview.image = [UIImage imageNamed:@"用户默认头像"];
  }
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
