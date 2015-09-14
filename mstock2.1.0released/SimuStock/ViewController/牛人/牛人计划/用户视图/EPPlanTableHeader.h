//
//  EPPlanTableHeader.h
//  SimuStock
//
//  Created by 刘小龙 on 15/7/7.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserHeadImageView.h"
#import "PlanTimeView.h"
#import "ProfitOrPlanDaysView.h"
#import "IntroductionCattleView.h"
#import "PlanListView.h"
#import "ExpertPlanConst.h"
#import "ExpertPlanData.h"



@interface EPPlanTableHeader : UIView
/** 头高 */
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *expertInfoViewHeight;

/** 头  = 0 */
@property(weak, nonatomic) IBOutlet UserHeadImageView *expertInfoView;
/** 计划运行时间  = 1 */
@property(weak, nonatomic) IBOutlet PlanTimeView *planTimeView;

/** 计划运行时间控件的高度 */
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *planTimeHeight;

/** 收益控件 目前收益和目前运行天数  = 2 */
@property(weak, nonatomic) IBOutlet ProfitOrPlanDaysView *planGoalView;
/**  ProfitOrPlanDaysView 的高度 */
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *planGoalHeight;

/** 简介 牛人简介  = 3 */
@property(weak, nonatomic) IBOutlet IntroductionCattleView *planDescView;
/** 简介的高度 */
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *planDescHeight;

/** 曲线图 手动添加 = 4 */
@property(weak, nonatomic) IBOutlet UIView *profileGraphView;
/** 曲线图的高度 */
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *profileGraphHeight;

/** 账户资产  = 5 */
@property(weak, nonatomic) IBOutlet PlanListView *accountAssestView;
/** 账户资产的高度 */
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *accountAssestHeight;

@end
