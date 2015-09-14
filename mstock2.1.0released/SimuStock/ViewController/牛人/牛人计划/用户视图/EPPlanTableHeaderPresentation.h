//
//  EPPlanTableHeaderPresentation.h
//  SimuStock
//
//  Created by Mac on 15/7/9.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EPPlanTableHeader.h"
#import "CattlePlanYieldCurveVC.h"

@interface EPPlanTableHeaderPresentation : NSObject

@property(nonatomic, weak) EPPlanTableHeader *tableHeader;
@property(nonatomic, weak) ExpertPlanData *expertPlanData;

@property(nonatomic, strong) CattlePlanYieldCurveVC *cattlePlanYieldCurve;

- (id)initWithEPPlanTableHeader:(EPPlanTableHeader *)tableHeader
             withExpertPlanData:(ExpertPlanData *)expertPlanData;

/** 计算表头高度 */
- (CGFloat)computeHeight;

/** 隐藏或显示子Views，子类必须实现此方法 */
- (void)resetViews;

//创建曲线
-(void)createYieldCurve;

//刷新 数据
-(void)refreshExpertPlanHeadeData:(ExpertPlanData *)refreshExpertData;

-(void)removeAllViews;

@end

/** 用户视图+计划未运行：包括购买和未购买2种情况，区别在于是否有购买底部栏 */
@interface UserWithPlanPrepareEPTHPresentation : EPPlanTableHeaderPresentation

@end


/** 用户视图 购买或者未购买 计划 运行状态 **/
@interface UserWithPlanRunningEPTHPresentation : EPPlanTableHeaderPresentation

@end

/** 牛人视图 计划未运行 */
@interface ExpertWithPlanNotRunningEPTHPresentation :EPPlanTableHeaderPresentation

@end

/** 牛人视图 计划运行中 */
@interface ExpertWithPlanRunningEPTHPresentation : EPPlanTableHeaderPresentation

@end

