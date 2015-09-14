//
//  simuTopToolBarView.h
//  SimuStock
//
//  Created by Mac on 14-7-8.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimuUtil.h"
#import "UserInfoNotificationUtil.h"
#import "LoginLogoutNotification.h"

@protocol SimuTopToolBarDelegate <NSObject>

- (void)buttonPressDown:(NSInteger)index;

@end

/*
 *类说明：主页面上标题栏工具类
 */
@interface SimuTopToolBarView : UIView {
  //用户头像
  UIImageView *sttbv_headimageview;

  // ios7 适配
  float isvc_stateBarHeight;

  UIImageView *redDotImage;
  UILabel *redDotLabel;
}

///登录、退出事件通知
@property(nonatomic, strong) LoginLogoutNotification *loginLogoutNotification;

///用户信息变更通知
@property(nonatomic, strong) UserInfoNotificationUtil *userInfoNotificationUtil;

///信封图片
@property(nonatomic, strong) UIButton *btnSystemMessage;

@property(weak, nonatomic) id<SimuTopToolBarDelegate> delegate;

/** 设置信封 */
- (void)setUnReadMessageNum:(NSInteger)unReadMessageNum;

@end
