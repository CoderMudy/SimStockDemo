//
//  simuMarchCounterVC.h
//  SimuStock
//
//  Created by Mac on 14-7-28.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "simumarchToolBarView.h"
#import "SimuACountVC.h"
#import "SimuMatchInfo.h"
#import "StockTradeListViewController.h"
#import "ClosedPositionViewController.h"

@class UserListItem;
/*
 *类说明：比赛帐户页面
 */
@interface simuMarchCounterVC : BaseViewController <simuBottomToolBarViewDelegate> {
  //  /** 需要切换到的视图控制器 */
  //  UIViewController *_toViewController;
  //  /** 当前正在展示的视图控制器 */
  //  UIViewController *_fromViewController;
  //  /** 承载页面 */
  //  UIView *_baseView;
  /**  marchID */
  NSString *_marchid;
  /**  user_id */
  NSString *_userid;
  /** 标题名称 */
  NSString *_name;
  /** 当前用户名称 */
  NSString *_username;
  /** 账户主页 */
  SimuACountVC *_userContVC;
  /** 交易明细 */
  StockTradeTableViewController *stockTradeTableVC;
  /** 历史持仓 */
  ClosedPositionViewController *historyPositionsVC;

  BaseNoTitleViewController *currentVC;
}

/** 初始化方法 */
- (id)init:(NSString *)marchId name:(NSString *)name userListItemMatch:(UserListItemMatch *)item;

/** 初始化方法 */
- (id)init:(NSString *)marchId
                   name:(NSString *)name
    schoolListMatchItem:(SimuSchoolMatchItem *)item;

@end
