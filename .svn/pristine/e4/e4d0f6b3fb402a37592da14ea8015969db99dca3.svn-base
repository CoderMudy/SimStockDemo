//
//  InviteCodeView.m
//  SimuStock
//
//  Created by Mac on 15/4/3.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "InviteCodeView.h"

#import "SimuUtil.h"
#import "UIImage+ColorTransformToImage.h"
#import "MyInformationCenterData.h"
#import "BaseRequester.h"

//邀请码页
#import "InviteFriendViewController.h"
#import "CacheUtil.h"

@implementation InviteCodeView

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    [self createViews];
  }
  return self;
}

- (void)createViews {
  //底部透明背景
  self.backgroundColor = [UIColor clearColor];
  //邀请码名称
  UILabel *inviteNameLabel =
      [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 50, 16)];
  inviteNameLabel.backgroundColor = [UIColor clearColor];
  inviteNameLabel.textAlignment = NSTextAlignmentLeft;
  inviteNameLabel.font = [UIFont systemFontOfSize:Font_Height_16_0];
  inviteNameLabel.text = @"邀请码";
  [self addSubview:inviteNameLabel];
  //邀请码
  inviteCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(73, 15, 110, 16)];
  inviteCodeLabel.backgroundColor = [UIColor clearColor];
  inviteCodeLabel.textAlignment = NSTextAlignmentLeft;
  inviteCodeLabel.textColor = [Globle colorFromHexRGB:@"086dae"];
  inviteCodeLabel.font = [UIFont systemFontOfSize:Font_Height_16_0];
  [self addSubview:inviteCodeLabel];
  //奖励提示
  UILabel *rewardContentLabel =
      [[UILabel alloc] initWithFrame:CGRectMake(20, 40, 200, 10)];
  rewardContentLabel.backgroundColor = [UIColor clearColor];
  rewardContentLabel.font = [UIFont systemFontOfSize:Font_Height_10_0];
  rewardContentLabel.textAlignment = NSTextAlignmentLeft;
  rewardContentLabel.text = @"每" @"成" @"功" @"邀"
      @"请一位好友注册，即获赠50金" @"币";
  rewardContentLabel.textColor = [Globle colorFromHexRGB:@"f79100"];
  [self addSubview:rewardContentLabel];
  //邀请好友按钮
  inviteFriendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  inviteFriendBtn.frame = CGRectMake(WIDTH_OF_SCREEN - 99, 17, 83, 28);
  UIImage *inviteFriendImage =
      [UIImage imageFromView:inviteFriendBtn
          withBackgroundColor:[Globle colorFromHexRGB:@"d18501"]];
  inviteFriendBtn.backgroundColor = [Globle colorFromHexRGB:@"eb9500"];
  [inviteFriendBtn setTitleColor:[UIColor whiteColor]
                        forState:UIControlStateNormal];

  [inviteFriendBtn setBackgroundImage:inviteFriendImage
                             forState:UIControlStateHighlighted];
  [inviteFriendBtn.layer setMasksToBounds:YES];
  [inviteFriendBtn.layer setCornerRadius:13.0f];
  [inviteFriendBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];

  [self addSubview:inviteFriendBtn];
  //帐号绑定
  UILabel *IDbindingLabel = [[UILabel alloc]
      initWithFrame:CGRectMake(0, 60, self.frame.size.width, 18)];
  IDbindingLabel.backgroundColor = [Globle colorFromHexRGB:@"e1e3e8"];
  IDbindingLabel.textAlignment = NSTextAlignmentLeft;
  IDbindingLabel.text = @"     帐号绑定";
  IDbindingLabel.font = [UIFont systemFontOfSize:Font_Height_12_0];
  IDbindingLabel.textColor = [Globle colorFromHexRGB:@"5a5a5a"];
  [self addSubview:IDbindingLabel];
  //绑定以下账号，可以用它们登录模拟炒股label
  UILabel *followLabel =
      [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 24,
                                                self.frame.size.width, 14)];
  followLabel.backgroundColor = [UIColor clearColor];
  followLabel.textAlignment = NSTextAlignmentCenter;
  followLabel.text = @"绑" @"定" @"以" @"下" @"帐"
      @"号，可以用它们登录优顾炒" @"股";
  followLabel.font = [UIFont systemFontOfSize:Font_Height_14_0];
  followLabel.textColor = [Globle colorFromHexRGB:@"939393"];
  [self addSubview:followLabel];
}

- (void)bindInviteCode:(MyInfomationItem *)item {
  self.item = item;
  //邀请码一栏
  if ([[SimuUtil changeIDtoStr:item.mInviteCode] length] > 1) {
    inviteCodeLabel.text = item.mInviteCode;
    [inviteFriendBtn setTitle:@"邀请好友" forState:UIControlStateNormal];
  } else {
    [inviteFriendBtn setTitle:@"生成邀请码" forState:UIControlStateNormal];
  }

  __weak InviteCodeView *weakSelf = self;
  [inviteFriendBtn setOnButtonPressedHandler:^{
    InviteCodeView *strongSelf = weakSelf;
    if (!strongSelf) {
      return;
    }
    if ([strongSelf.item.mInviteCode length] < 1) {
      //生成邀请码
      [strongSelf getInviteCode];
    } else {
      //存在邀请码
      [AppDelegate pushViewControllerFromRight:
                       [[InviteFriendViewController alloc] init]];
    }
  }];
}

///生成邀请码
- (void)getInviteCode {
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  //解析
  __weak InviteCodeView *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    InviteCodeView *strongSelf = weakSelf;
    if (strongSelf) {
      return NO;
    } else
      return YES;
  };
  callback.onSuccess = ^(NSObject *obj) {
    InviteCodeView *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindInviteCodeString:(GetInviteCode *)obj];
    }
  };
  [GetInviteCode getInviteCodeWithCallBack:callback];
}

///邀请码获得后续处理, 刷新邀请码
- (void)bindInviteCodeString:(GetInviteCode *)localItem {
  self.item.mInviteCode = localItem.message;
  MyInfomationItem *saved = [CacheUtil myInfomation];
  saved.mInviteCode = localItem.message;
  [CacheUtil saveUserInfomation:saved];
  [self bindInviteCode:self.item];
}

@end
