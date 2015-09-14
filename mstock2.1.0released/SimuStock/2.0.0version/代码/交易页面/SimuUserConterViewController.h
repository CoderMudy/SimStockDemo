//
//  simuUserConterViewController.h
//  SimuStock
//
//  Created by Mac on 14-7-11.
//  Copyright (c) 2014年 Mac. All rights reserved.
//
#import "SimuMainViewController.h"
#import "SimuTopToolBarView.h"
///配资合同
#import "SingleCapitaldetailsCell.h"
#import "SimuRankPositionPageData.h"
#import "UserAccountPageData.h"
#import "DataArray.h"
#import "SimulationViewCell.h"
#import "SimuScrollButView.h"
#import "SimuRoundButView.h"
#import "LoginLogoutNotification.h"

///跑马灯cell
@class CapitalFirstViewCell;
///配资账户cell
@class CapitalDetailViewCell;
///喷水鱼cell
@class FishanimationViewCell;
///模拟账户cell
@class SimulationViewCell;
#import "TableViewHeaderView.h"

///配资单笔详情网络请求
#import "WFProductContract.h"
@class SimuTopTimeBarView;
@class SimulationViewCell;
@protocol simuUserConterViewControllerDelegate <NSObject>

@optional
- (void)simuUserLogInMethod;
@end
/*
 *我的账号首页 用户的帐户页面
 */
@interface SimuUserConterViewController
    : UIViewController <SimuleftButtonDelegate, UITableViewDataSource, UITableViewDelegate, SimuIndicatorDelegate,
                        SimulationViewCellDelegate, SingleCapitaldetailsCellDelegate, UIAlertViewDelegate, ScrollToTopVC> {

  /**上访闹钟和时间控件*/
  SimuTopTimeBarView *scvc_topTimeBarView;
  //自选股等滑动按钮
  SimuScrollButView *scvc_scrollButView;

  /**表格*/
  UITableView *scvc_tableView;
  /**持仓数据*/
  SimuRankPositionPageData *scvc_positionInfo;
  /**当前选中的用户*/
  SelectedRow scvc_selectedRow;
  /**当前持仓，选中前表格cell高度*/
  float scvc_notselHeight;
  /**记录帐户信息数据*/
  UserAccountPageData *scvc_pagedata;
  /**记录帐户持仓信息数据*/
  DataArray *positionList;
  /**持仓仓位信息*/
  UILabel *ssvc_positionLable;
  /**设定状态栏高度*/
  float isvc_stateBarHeight;
  /** 最新版本 */
  NSString *_newestVersion;

  ///根据网络请求，是否要开启配资界面
  BOOL isPeizi;
}
/**表格*/
@property(weak, nonatomic) IBOutlet UITableView *Main_tableView;

/** 小牛视图，使用isCry:(BOOL)来切换哭牛和笑牛。setInformation设置笑牛标签*/
@property(strong, nonatomic) LittleCattleView *littleCattleView;

///登录、退出事件通知
@property(nonatomic, strong) LoginLogoutNotification *loginLogoutNotification;

@property(weak, nonatomic) SimuMainViewController *mainVC;

@property(strong, nonatomic) DataArray *wfContractInfoArray;
@property(strong, nonatomic) WFCurrentContractList *wfcurrentlist;

///跑马灯
@property(strong, nonatomic) CapitalFirstViewCell *capitalfirstviewCell;
///配资账户cell
@property(strong, nonatomic) CapitalDetailViewCell *capitaldetailviewCell;
///喷水鱼cell
@property(strong, nonatomic) FishanimationViewCell *fishanimationviewCell;
///模拟账户cell
@property(strong, nonatomic) SimulationViewCell *simulationviewCell;

/// 刷新按钮  配资跑马灯
@property(strong, nonatomic) TableViewHeaderView *wftableviewHeaderView;

/// 刷新按钮  模拟账户
@property(strong, nonatomic) TableViewHeaderView *simutableviewHeaderView;

/** 开始加载，通知父容器*/
@property(copy, nonatomic) CallBackAction beginRefreshCallBack;

/** 结束加载，通知父容器*/
@property(copy, nonatomic) CallBackAction endRefreshCallBack;

/** 初始化函数，程序主页面使用 */
- (id)initWithMainViewController:(SimuMainViewController *)controller;

/** 重新刷新页面数据 */
- (void)refreshpagedata;
/**
 *  是否支持点击状态栏，返回顶部
 *
 *  @param scrollsToTop BOOL 支持=YES
 */
- (void)enableScrollsToTop:(BOOL)scrollsToTop;

@end
