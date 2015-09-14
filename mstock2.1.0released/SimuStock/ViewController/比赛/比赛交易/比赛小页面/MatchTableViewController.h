//
//  MatchTableViewController.h
//  SimuStock
//
//  Created by 刘小龙 on 15/6/24.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseTableViewController.h"
#import "GameAdvertisingViewController.h"
#import "StockMatchViewController.h"

typedef void(^EndEditBlock)();

//控制器类
@interface MatchTableAdaper : BaseTableAdapter

@property(copy, nonatomic) EndEditBlock endTableAdapterBlcok;

@end

// tableView 基类
@interface MatchTableViewController
    : BaseTableViewController <GameAdvertisingDelegate> {
  //广告
  GameAdvertisingViewController *advViewVC;
}
//区分 是我的比赛 还是 全部比赛  校园、 有奖 还是搜索比赛
@property(assign, nonatomic) MatchStockType mathcTypeRequest;

/** 搜索比赛 需要的参数 搜索框里的内容 */
@property(copy, nonatomic) NSString *textFiled;
///登录、退出事件通知
@property(nonatomic, strong) LoginLogoutNotification *loginLogoutNotification;
/**搜索框*/
@property(weak, nonatomic) UITextField *searchField;

@property(copy, nonatomic) EndEditBlock endEditBlock;

/** 重新 init */
- (id)initWithFrame:(CGRect)frame withMatchStockType:(MatchStockType)matchType;
@end
