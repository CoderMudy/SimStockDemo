//
//  WFHistoryListViewController.h
//  SimuStock
//
//  Created by moulin wang on 15/4/9.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseViewController.h"
#import "WFAccountInterface.h"

@interface WFHistoryListViewController : BaseViewController

/** 查询优顾账户的资产 数据结构 */
@property(nonatomic, strong) WFAccountBalance *accountBalanceInfo;
@property(nonatomic, strong) WFAccountBalanceAccountList *accountList;

@end
