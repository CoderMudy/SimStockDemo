//
//  ViewController.h
//  SimuStock
//
//  Created by Mac on 13-8-7.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EBPurchase.h"
#import "SimuMainViewController.h"
#import "LoginLogoutNotification.h"
#import "UserInfoNotificationUtil.h"
#import "SimuUser.h"
#import "SliderUserCounterWapper.h"
#import "StockFunds.h"

#define SIDE_SLIP_WIDTH WIDTH_OF_SCREEN * 0.75

@class BaseViewController;
@class SimuStockRegisterView;
@class BindSuperManTrace;
@class AttentionEventObserver;
@class StoreBuySuccessResponse;

@interface ViewController
    : UIViewController <UIApplicationDelegate, UITableViewDelegate,
                        UITableViewDataSource, UIAlertViewDelegate,
                        EBPurchaseDelegate> {
  //当前正在展示的视图控制器
  BaseViewController *_showingViewController;
  //登录页面
  SimuStockRegisterView *_loginView;
  //背景图片
  UIImageView *_backImageView;
  //用户资产
  UILabel *_userFundLabel;
  //用户头像
  UIImageView *_userHeadImageView;
  //交易
  EBPurchase *_productPurchase;
  //提示
  UIAlertView *_showAlertView;
  //菊花
  UIActivityIndicatorView *_actIndicatorView;
  //菜单项
  NSArray *_menuNameArray;
  //表格
  UITableView *_tableView;
  //区分购买卡型
  NSString *_cardSort;
  //登录后的页面头部
  UIView *_loginSuccessView;
  //进度条数组
  NSMutableArray *_processViewArray;
  //进度数字数组
  NSMutableArray *_processLabelArray;
  //关注更新后数据
  NSString *_tempAttentionStr;
  //设置按钮
  UIButton *_settingBtn;
  ///商城按钮
  UIButton *_mallBtn;
  ///主页跳转透明按钮
  UIButton *_homeButton;

  BindSuperManTrace *_bindSuperManTrace;

  AttentionEventObserver *_attentionEventObserver;

  StoreBuySuccessResponse *_sendBuySuccessUtil;
}

@property(strong, nonatomic) BaseViewController *curShowVC;

@property(strong, nonatomic) EBPurchase *productPurchase;

@property(nonatomic, strong) SimuMainViewController *mainVC;

///登录、退出事件通知
@property(nonatomic, strong) LoginLogoutNotification *loginLogoutNotification;

///用户信息变更通知
@property(nonatomic, strong) UserInfoNotificationUtil *userInfoNotificationUtil;

///侧边栏数据是否已经绑定
@property(assign, nonatomic) BOOL sliderDataBinded;

+ (void)updateMyInfo;

@end
