//
//  ExpertPlanViewController.h
//  SimuStock
//
//  Created by 刘小龙 on 15/7/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseViewController.h"
#import "MoreShareExplainRefreshView.h"
#import "ExpertPlanData.h"
#import "StockPositionInfoTableViewCell.h"
#import "ExpertPlanConst.h"

/** 用于判断买卖判断回调 */

typedef void (^ReturnPlanData)(ExpertPlanData *);

@class SimuRTBottomToolBar;

@interface ExpertPlanViewController : BaseViewController {
  NSDictionary *_dic;
}

@property(strong, nonatomic) SimuRTBottomToolBar *simuBottomToolBar;
//初始化
- (id)initWithAccountId:(NSString *)accountId
          withTargetUid:(NSString *)targetUid
               withName:(NSString *)name;
@property(nonatomic, strong)
    MoreShareExplainRefreshView *moreShareExplainRefreshView;

@property(nonatomic, strong) ExpertPlanData *expertPlan;

@property(copy, nonatomic) PositonCellButtonCallback buyAction;
@property(copy, nonatomic) PositonCellButtonCallback sellAction;

@property(copy, nonatomic) ReturnPlanData planExpertData;

/** 刷新类型 */
@property(copy, nonatomic) NSString *refreshType;

@end
