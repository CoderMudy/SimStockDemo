//
//  ProfitOrPlanDaysView.h
//  SimuStock
//
//  Created by 刘小龙 on 15/7/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpertPlanData.h"

@interface ProfitOrPlanDaysView : UIView
/** 当前收益/目标收益*/
@property(weak, nonatomic) IBOutlet UILabel *currentRateLabel;

/** 运行天数/计划期限 */
@property(weak, nonatomic) IBOutlet UILabel *runDayPlanLabel;

@property(assign, nonatomic) BOOL dataBinded;

///绑定数据，如果数据已经绑定，默认不重新设置
- (void)bindDataForProfitOrPlanDays:(EPPlanGoalViewData *)planGoalData;
///绑定数据，可以指定强制刷新参数，强制重新绑定
- (void)bindDataForProfitOrPlanDays:(EPPlanGoalViewData *)planGoalData
                   withForceRefresh:(BOOL)forceRefresh;

@end
