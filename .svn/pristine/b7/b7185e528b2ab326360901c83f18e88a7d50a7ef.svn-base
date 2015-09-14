//
//  FollowMasterViewController.h
//  SimuStock
//
//  Created by Jhss on 15/7/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseNoTitleViewController.h"
#import "GameAdvertisingViewController.h"
#import "NewOnlineViewController.h"
#import "HotRunViewController.h"
#import "SimuMainViewController.h"
#import "LoginLogoutNotification.h"

/** 评论与赞 */
#define leftNewOnlineBtn @"new"
#define rightHotRunBtn @"hot"

#define Notification_Refresh_NewOnlie @"WFNotification_Refresh_NewOnlie"

@interface FollowMasterViewController
    : BaseNoTitleViewController <GameAdvertisingDelegate> {

  //按钮视图
  UIView *buttonView;
  //按钮驻留态
  UIView *residentView;
  //分段选择器的显示view
  UIView *segmentView;
  // banner与segmentView
  UIView *tableHeadView;
  /** 全新上线列表 */
  NewOnlineViewController *newOnlineTableVC;
  /** 火热运行列表 */
  HotRunViewController *hotRunTableVC;
  /** 判断当前列表 */
  NSString *tempPosition;

  BaseTableViewController *currentTableVC;
}
//广告
@property(nonatomic, strong) GameAdvertisingViewController *advViewVC;

///登录、退出事件通知
@property(nonatomic, strong) LoginLogoutNotification *loginLogoutNotification;
/** 开始加载，通知父容器*/
@property(copy, nonatomic) CallBackAction beginRefreshCallBack;
@property(strong, nonatomic) SimuMainViewController *simuMainVC;
/** 结束加载，通知父容器*/
@property(copy, nonatomic) CallBackAction endRefreshCallBack;
/** 刷新列表数据的方法 */
- (void)refreshButtonPressDown;

@end
