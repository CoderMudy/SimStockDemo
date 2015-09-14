//
//  SelfStockTableViewController.h
//  SimuStock
//
//  Created by Mac on 15/4/26.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseTableViewController.h"
#import "SelfStockTableModel.h"
#import "BaseNotificationObserverMgr.h"
#import "NoSelfStockView.h"
#import "LoginLogoutNotification.h"
#import "SelfStockTableHeaderView.h"
#import "TimerUtil.h"
#import "SelfStockUtil.h"
#import "QuerySelfStockData.h"

@class AllGroupsView;

@interface SelfStockTableAdapter : BaseTableAdapter

@end

@interface SelfStockTableViewController : BaseTableViewController {
  /** 添加删除自选股的观察者 */
  SelfStockChangeNotification *portfolioStockChangeObserver;

  /** 自选股排序 */
  ListOrder ssvc_order;

  /** 无自选股调用此页面 */
  NoSelfStockView *noSelfStockView;

  /** 登录或者退出通知回调管理器 */
  LoginLogoutNotification *loginLogoutNotification;

  SelfStockChangeNotification *selfStockChangeNotification;

  /** 定时器 */
  TimerUtil *timerUtil;
}

/** 分组浮窗 */
@property(nonatomic, strong) AllGroupsView *allGroupView;

@property(nonatomic, strong) SelfStockTableHeaderView *tableHeader;

@property(nonatomic, strong) NSString *groupName;
@property(nonatomic, strong) NSString *groupId;

@property(nonatomic, strong) QuerySelfStockData *local;

- (void)showBottomLoginView:(BOOL)show;

///是否应该显示“管理”自选股的按钮
- (BOOL)shouldShowManageButton;

///点击“管理”按钮的回调函数
- (void)manageSelfStocks;

@end
