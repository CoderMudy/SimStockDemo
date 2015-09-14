//
//  ExpertPlanTableViewController.h
//  SimuStock
//
//  Created by 刘小龙 on 15/7/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseTableViewController.h"
#import "ExpertPlanData.h"
#import "ExpertPlanConst.h"
#import "EPPLockCell.h"
#import "EPexpertPositionData.h"
#import "StockPositionInfoTableViewCell.h"
#import "EPPlanPositionView.h"

//写个blcok 返回状态
typedef void (^ExpertOrUser)(ExpertPlanData *);

//适配器
@interface ExpertPlanAdapter : BaseTableAdapter

@property(assign, nonatomic) NSInteger selectedRowIndex;
@property(strong, nonatomic) EPPlanPositionView *planPositionView;

@end

// tableview
@interface ExpertPlanTableViewController : BaseTableViewController

@property(strong, nonatomic) ExpertPlanAdapter *expertPlanAdapter;

//数据返回的类
@property(strong, nonatomic) ExpertPlanData *expertPlanData;

@property(copy, nonatomic) ExpertOrUser experOrUserBlock;

//锁定cell
@property(strong, nonatomic) EPPLockCell *lockCell;

//账户资产数据
@property(strong, nonatomic) EPexpertPositionData *expertAccountData;

@property(copy, nonatomic) PositonCellButtonCallback buyAction;
@property(copy, nonatomic) PositonCellButtonCallback sellAction;

@property(copy, nonatomic) NSString *accountID;
@property(copy, nonatomic) NSString *targetUid;

///下拉刷新时，通知父容器刷新
@property(copy, nonatomic) CallBackAction pullDownRefreshAction;

/** 重新 初始化  */
- (id)initWithFrame:(CGRect)frame
      withAccountID:(NSString *)accountId
      withTargetUid:(NSString *)targetUid
 withExpertPlanData:(ExpertPlanData *)expertPlanData;

/** 得到一个持仓数组 */
- (NSArray *)getExpertPlanPositionArray;

@end
