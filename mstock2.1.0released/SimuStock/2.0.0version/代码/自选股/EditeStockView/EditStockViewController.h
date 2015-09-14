//
//  EditStockView.h
//  SimuStock
//
//  Created by Mac on 13-9-23.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimuAction.h"
#import "SimuUtil.h"
#import "CommonFunc.h"
#import "FMMoveTableView.h"
#import "FMMoveTableViewCell.h"
#import "BaseViewController.h"
#import "SelfStockViewController.h"
#import "StockAlarmNotification.h"
#import "SelfStockUtil.h"

/**
 *类说明：自选股管理、编辑页面
 */
@interface EditStockViewController
    : BaseViewController <UITableViewDelegate, UITableViewDataSource> {

  /** 表格页面 */
  UITableView *_tableView;
  /** 数组 */
  NSMutableArray *_dataArray;
  /** 删除按钮 */
  BGColorUIButton *_deleteButton;
  /** 选择 */
  UILabel *_selectLabel;
  /** 股票名称 */
  UILabel *_stockNameLabel;
  /** 拖动排序 */
  UILabel *_sorttingLabel;

  StockAlarmNotification *stockAlarmNotification;

  /**增删自选股观察者*/
  SelfStockChangeNotification *selfStockChangeNotification;

  /** 登录或者退出通知回调管理器 */
  LoginLogoutNotification *loginLogoutNotification;
}

@property(nonatomic, copy) NSString *groupName;
@property(nonatomic, copy) NSString *groupId;

@property(nonatomic, copy) onTableRowSelected onTableRowSelectedCallback;

- (id)initWithWithGroupId:(NSString *)groupId groupName:(NSString *)groupName;

@end
