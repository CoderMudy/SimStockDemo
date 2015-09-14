//
//  EPTradeDetailView.h
//  SimuStock
//
//  Created by moulin wang on 14-2-17.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"
#import "BaseViewController.h"
#import "SimuClosedDetailPageData.h"
#import "SimuIndicatorView.h"
#import "TrendViewController.h"
#import "SimuUtil.h"
#import "MJRefreshFooterView.h"
#import "SimuPositionPageData.h"
#import "DataArray.h"
#import "StockUtil.h"
#import "TradeRecordTableViewCell.h"
#import "ExpertPlanData.h"
#import "SimuRankPositionPageData.h"

@interface EPTradeAdapter : BaseTableAdapter

@property(copy, nonatomic) TradeInfoCellButtonCallback buyAction;
@property(copy, nonatomic) TradeInfoCellButtonCallback sellAction;

@end

@interface EPTradeTableVC : BaseTableViewController
///牛人计划的数据
@property(strong, nonatomic) ExpertPlanData *planData;
@property(strong, nonatomic) NSString *positionId;

@property(strong, nonatomic) EPTradeAdapter *tradeAdapter;

@end

@interface EPTradeDetailView : BaseViewController
///牛人计划的数据
@property(strong, nonatomic) ExpertPlanData *planData;
@property(strong, nonatomic) PositionInfo *positionInfo;

@property(strong, nonatomic) EPTradeTableVC *tradeHistoryTableVC;

///牛人计划的持仓明细
- (id)initWithExpertPlanData:(ExpertPlanData *)planData;
- (id)initWithExpertPlanData:(ExpertPlanData *)planData
               withPositonId:(PositionInfo *)positionInfo;

@end
