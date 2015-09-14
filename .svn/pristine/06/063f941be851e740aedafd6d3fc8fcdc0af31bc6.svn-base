//
//  MyGoldTableViewCell.h
//  SimuStock
//
//  Created by jhss on 15/5/9.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SeperatorLine.h"
#import "MyGoldListWrapper.h"
#import "SimuUtil.h"
#import "TaskIdUtil.h"
#import "AppDelegate.h"
#import "StockBarsViewController.h"
#import "TopToolBarView.h"
#import "GetGoldWrapper.h"
/**
 Int任务状态：
 0:待完成
 1:做任务
 2:领取金币
 3:今日已领
 4:已领取
 */
typedef NS_ENUM(NSUInteger, TaskState) {
  /**待完成*/
  STATE_ToDo = 0,
  /**做任务*/
  STATE_DoTask = 1,
  /**领取金币*/
  STATE_ReceiveGold = 2,
  /**今日已领*/
  STATE_TodayAlreadyReceived = 3,
  /**已领取*/
  STATE_AlreadyReceived = 4
};
/**任务状态*/
typedef NS_ENUM(NSUInteger, TaskyType) {
  /**常规任务*/
  TYPE_Normal = 27001,
  /**累加任务*/
  TYPE_Accumulate = 2702,
  /**一次性任务*/
  TYPE_Once = 2703,
  /**扣金币任务*/
  TYPE_GoldBuckle = 2704,
  /**签到*/
  TYPE_Registration = 2705
};
/**领取金币数回调*/
typedef void (^PassingBalanceNumBlock)(GetGoldWrapper *num);

/**我的金币页面cell显示*/
@interface MyGoldTableViewCell : UITableViewCell

@property(weak, nonatomic) IBOutlet UILabel *specialLabel;
/**任务描述*/
@property(weak, nonatomic) IBOutlet UILabel *descriptionLab;
/**完成任务可领取金币数*/
@property(weak, nonatomic) IBOutlet UILabel *goldNumberLab;
/**按钮文字*/
@property(weak, nonatomic) IBOutlet UIButton *taskTextBtn;
/**任务名称*/
@property(weak, nonatomic) IBOutlet UILabel *nameLab;
/**cell底部分割线*/
@property(weak, nonatomic) IBOutlet HorizontalSeperatorLine *separatorLine;
/**绑定我的任务列表*/
- (void)bindTaskListItem:(TaskListItem *)item;
@property(copy, nonatomic) PassingBalanceNumBlock buttonClickCallBack;
@end
