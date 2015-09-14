//
//  SimuMainViewController.h
//  SimuStock
//
//  Created by Mac on 14-7-8.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimuCoverageView.h"
#import "SimuIndicatorView.h"
#import "UIButton+Block.h"
#import "LoginLogoutNotification.h"

/*
 *类说明：主页面类
 */
@interface SimuMainViewController : UIViewController <UITextFieldDelegate, SimuIndicatorDelegate> {
  /** 添加删除自选股的观察者 */
  BaseNotificationObserverMgr *observers;
  //搜索框
  UILabel *searchLab;
  //用于判断是否滑动
  NSInteger _slideInt;
  //主页面覆盖页面
  SimuCoverageView *_coverView;

  ///当前正在显示页面 (0:交易 1：牛人 2：行情 3：比赛 4：聊股),
  ///也可以用于搜索框跳转
  NSInteger _page_Type;

  /** 登录或者退出通知回调管理器 */
  LoginLogoutNotification *loginLogoutNotification;

  BOOL _popToRoot;
}

//当前承载视图的scrollView，为了解决其他次级主页侧滑，不过暂时未使用
@property(nonatomic, strong) UIScrollView *currentScrollView;

//移动手势
@property(nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

///刷新按钮
@property(nonatomic, strong) SimuIndicatorView *indicatorView;

///创建比赛按钮、自选股管理按钮、发表聊股按钮
@property(nonatomic, strong) BGColorUIButton *btnOperation;

//设定侧边栏的登录成功和不成功页面，用来实现微滑动效果
- (void)setLoginView:(UIView *)loginView NotLoginView:(UIView *)nologinView;

//修改当前显示页面
- (void)resetShowChangeView:(NSInteger)index;

//-(void)timesVisible:(BOOL)visible;
- (void)pan:(UIPanGestureRecognizer *)recognizer;

- (void)moveToMainView;

- (void)simuUserLogInMethod;

- (void)showIndicatorOrOperationButton;

- (void)buttonPressDown:(NSInteger)index;
@end
