//
//  CattlePlanYieldCurveVC.h
//  SimuStock
//
//  Created by jhss_wyz on 15/6/30.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CPYieldCurveView;
@class CPYieldCurveData;

@interface CattlePlanYieldCurveVC : UIViewController

/** 收益曲线纵轴最高坐标（最高收益率） */
@property(weak, nonatomic) IBOutlet UILabel *highestYieldLabel;
/** 收益曲线纵轴较高坐标（较高收益率） */
@property(weak, nonatomic) IBOutlet UILabel *highYieldLabel;
/** 收益曲线纵轴较低坐标（较低收益率） */
@property(weak, nonatomic) IBOutlet UILabel *lowYieldLabel;
/** 收益曲线纵轴最低坐标（最低收益率） */
@property(weak, nonatomic) IBOutlet UILabel *lowestYieldLabel;

/** 收益曲线横轴开始坐标（牛人计划开始时间） */
@property(weak, nonatomic) IBOutlet UILabel *startDateLabel;
/** 收益曲线横轴结束坐标（牛人计划结束时间） */
@property(weak, nonatomic) IBOutlet UILabel *endDateLabel;

/** 收益曲线View */
@property(weak, nonatomic) IBOutlet CPYieldCurveView *yieldCurveView;

/** 内容View */
@property(weak, nonatomic) IBOutlet UIView *contentView;

/** 牛人计划ID */
@property(copy, nonatomic) NSString *planID;
/** 目标用户ID */
@property(copy, nonatomic) NSString *targetUID;
/** 数据是否绑定 */
@property(assign, nonatomic) BOOL isDataBind;

/** 计划开始日期 */
@property(copy, nonatomic) NSString *startDate;

/**
 收益曲线构造函数
  planID:牛人计划ID
 targetUID:目标用户ID
 endDate:牛人计划结束时间
 */
- (instancetype)initWithPlanId:(NSString *)planID
                  andTargetUID:(NSString *)targetUID
                  andStartDate:(NSString *)startDate;

- (void)refreshData;

@end
