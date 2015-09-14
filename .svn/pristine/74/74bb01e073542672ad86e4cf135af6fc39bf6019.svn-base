//
//  StockPositionViewController.h
//  SimuStock
//
//  Created by moulin wang on 14-2-11.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StockPositionSwitchButtonsView.h"
#import "ClosedPositionViewController.h"
#import "CurrentPositionViewController.h"
#import "PositionCell.h"

@class UserListItem;
@class SimuRankPositionPageData;

/** 我的持仓 或ta的持仓 */
@interface StockPositionViewController : BaseViewController {
  NSString *spvc_userID;
  /** 用户头像部分页面 */
  UIView *_userMideView;
  TradeDetailView *_detailView;
  SelectedRow spve_selectedRow;
  /** 追踪按钮 */
  UIButton *trackButton;
  /** 持仓盈亏标题 */
  UILabel *spvc_posprofatNameLable;
  /** 持仓盈亏数据 */
  UILabel *spvc_posprofatValueLable;
  /** 持仓追踪点击后，防止连续点击等待框 */
  UIActivityIndicatorView *spvc_indicator;
  /** 记录对追踪多次操作后的状态 */
  BOOL _isTracing;
  /** 清仓数量 */
  NSString *_closeStockNumber;
  /** 昵称 */
  UILabel *_nicklabel;
  /** 头像 */
  UIImageView *_headImageView;
  /** 持仓清仓切换按钮控件 */
  StockPositionSwitchButtonsView *_switchButtons;
  /** 当前持仓按钮 */
  UIButton *_positionedButton;
  /** 已清仓按钮 */
  UIButton *_closePositionButton;
  /** 当前按下的是持仓按钮还是清仓按钮 */
  BOOL _isPositionButtonClicked;
  /** 用户评级控件数据 */
  UserListItem *_userListItem;
  /** 持仓 */
  CurrentPositionViewController *currentPositionViewController;
  /** 清仓 */
  ClosedPositionViewController *closedPositionViewController;
}

@property(copy, nonatomic) NSString *userID;
@property(copy, nonatomic) NSString *nickName;
@property(copy, nonatomic) NSString *headPicName;
@property(copy, nonatomic) NSString *matchID;
@property(assign, nonatomic) NSInteger stock_vipType;
@property(nonatomic) UITableView *tableView;

/** 持仓数据模型 */
@property(strong, nonatomic) SimuRankPositionPageData *currentPositionInfo;

/** 记录追踪页面用户位置 */
@property(assign, nonatomic) NSInteger selectedUserIndex;
@property(assign, nonatomic) BOOL isTracing;
/** 股票名称和代码 */
@property(copy, nonatomic) NSString *stockNameAndCode;

- (id)initWithID:(NSString *)userid
    withNickName:(NSString *)nickName
     withHeadPic:(NSString *)imageName
     withMatchID:(NSString *)matchID
     withViptype:(NSInteger)vipType
    withUserItem:(UserListItem *)userItem;

- (void)leftButtonPress;

/** 增加追踪 */
- (void)addTrace;

/** 取消追踪 */
- (void)delTrace;

@end
