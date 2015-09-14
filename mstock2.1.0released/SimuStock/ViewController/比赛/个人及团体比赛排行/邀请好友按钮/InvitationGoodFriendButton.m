//
//  InvitationGoodFriendButton.m
//  SimuStock
//
//  Created by 刘小龙 on 15/8/21.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "InvitationGoodFriendButton.h"
#import "Globle.h"
#import "SimuIndicatorView.h"
#import "SimTopBannerView.h"

@implementation InvitationGoodFriendButton

/** init 初始化  参数： 导航栏条 和 菊花控件 */
- (id)initInvitationButtonWithTopBar:(SimTopBannerView *)topToolBar
                   withIndicatorView:(SimuIndicatorView *)indicatorView
                             {
  self = [super init];
  if (self) {
    CGRect frame = CGRectMake(CGRectGetWidth(topToolBar.bounds) - 80, CGRectGetMinY(indicatorView.frame),
                              70, CGRectGetHeight(indicatorView.bounds));
    self.frame = frame;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:Font_Height_16_0];
    [self setTitle:@"邀请好友" forState:UIControlStateNormal];
    self.clipsToBounds = NO;
    [self setTitleColor:[Globle colorFromHexRGB:@"4dfdff"] forState:UIControlStateNormal];
    self.normalBGColor = [UIColor clearColor];
    [self setBackgroundImage:[UIImage imageNamed:@"return_touch_down.png"]
                    forState:UIControlStateHighlighted];
    [self setBackgroundImage:[UIImage imageNamed:@"return_touch_down.png"] forState:UIControlStateSelected];
    
    //设置菊花位置
    indicatorView.frame = CGRectMake(CGRectGetMinX(self.frame) - CGRectGetWidth(indicatorView.bounds),
                                     CGRectGetMinY(self.frame), CGRectGetWidth(indicatorView.bounds),
                                     CGRectGetHeight(indicatorView.bounds));
    __weak InvitationGoodFriendButton *weakSelf = self;
    [self setOnButtonPressedHandler:^{
      InvitationGoodFriendButton *strongSelf = weakSelf;
      if (strongSelf) {
        [strongSelf buttonDownForInvitationButton];
      }
    }];
    [topToolBar addSubview:self];
  }
  return self;
}

/** 点击时间回调 */
- (void)buttonDownForInvitationButton {
  if (self.invitationButtonBlock) {
    self.invitationButtonBlock();
  }
}
@end
