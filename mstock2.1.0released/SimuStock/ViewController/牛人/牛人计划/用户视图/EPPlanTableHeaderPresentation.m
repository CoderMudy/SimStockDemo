//
//  EPPlanTableHeaderPresentation.m
//  SimuStock
//
//  Created by Mac on 15/7/9.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "EPPlanTableHeaderPresentation.h"
#import "SimuUtil.h"

@implementation EPPlanTableHeaderPresentation

- (id)initWithEPPlanTableHeader:(EPPlanTableHeader *)tableHeader
             withExpertPlanData:(ExpertPlanData *)expertPlanData {
  if (self = [super init]) {
    self.tableHeader = tableHeader;
    self.expertPlanData = expertPlanData;

    [self resetViews];
    _tableHeader.height = [self computeHeight];
  }
  return self;
}

- (void)removeAllViews {
  [self.tableHeader removeAllSubviews];
}

//计算 高度
- (CGFloat)computeHeight {
  return self.tableHeader.expertInfoViewHeight.constant +
         self.tableHeader.planTimeHeight.constant +
         self.tableHeader.planGoalHeight.constant +
         self.tableHeader.profileGraphHeight.constant +
         self.tableHeader.planDescHeight.constant +
         self.tableHeader.accountAssestHeight.constant;
}

/** 隐藏或显示子Views，子类必须实现此方法 */
- (void)resetViews {
}

- (void)refreshExpertPlanHeadeData:(ExpertPlanData *)refreshExpertData {
}

//创建曲线
- (void)createYieldCurve {

  NSString *statTime = [SimuUtil
      getDayDateFromCtime:@(self.expertPlanData.userProject.planStartTime)];

  NSString *string =
      [statTime stringByReplacingOccurrencesOfString:@"-" withString:@""];

  [self createYieldCurveWithAccountID:self.expertPlanData.accoundId
                        withTargetUid:
                            [NSString stringWithFormat:@"%ld",
                                                       (long)self.expertPlanData
                                                           .targetUid]
                        withStartTime:string];
}

#pragma makr-- 添加曲线
- (void)createYieldCurveWithAccountID:(NSString *)accountId
                        withTargetUid:(NSString *)targetUid
                        withStartTime:(NSString *)statrTime {
  if (_cattlePlanYieldCurve == nil) {
    _cattlePlanYieldCurve =
        [[CattlePlanYieldCurveVC alloc] initWithPlanId:accountId
                                          andTargetUID:targetUid
                                          andStartDate:statrTime];
    [self.tableHeader.profileGraphView addSubview:_cattlePlanYieldCurve.view];
  } else {
    [_cattlePlanYieldCurve refreshData];
  }
}

@end

// 第一种 用户视角 未购买和已购买  计划在未运行
@implementation UserWithPlanPrepareEPTHPresentation

- (void)resetViews {

  //隐藏 收益运行天数控件  账号资产
  self.tableHeader.planGoalHeight.constant = 0.0f;
  self.tableHeader.planGoalView.hidden = YES;

  self.tableHeader.accountAssestHeight.constant = 0.0f;
  self.tableHeader.accountAssestView.hidden = YES;

  //未购买 和 已购买 在计划未运行 都显示 时间运行控件
  self.tableHeader.planTimeView.hidden = NO;
  self.tableHeader.planTimeHeight.constant = 110.0f;
  //绑定数据
  [self.tableHeader.planTimeView
      bindDataForCell:self.expertPlanData.userProject];
  [self.tableHeader.expertInfoView bindUserInfo:self.expertPlanData.userHead];
  if (self.expertPlanData.state == UserPurchasedState) {
    //已购买 未运行 简介隐藏
    self.tableHeader.planDescHeight.constant = 0.0f;
    self.tableHeader.planDescView.hidden = YES;
    //曲线图 显示
    self.tableHeader.profileGraphHeight.constant = 202.0f;
    self.tableHeader.profileGraphView.hidden = NO;
    [self createYieldCurve];
  } else if (self.expertPlanData.state == UserNotPurchasedState) {
    //未购买 未运行
    //曲线图隐藏
    self.tableHeader.profileGraphHeight.constant = 0.0f;
    self.tableHeader.profileGraphView.hidden = YES;
    //简介 显示
    self.tableHeader.planDescView.hidden = NO;
    CGFloat planDescHeight = [self.tableHeader.planDescView
        bindData:self.expertPlanData.userDescData];
    self.tableHeader.planDescHeight.constant = planDescHeight;
  }
}

- (void)refreshExpertPlanHeadeData:(ExpertPlanData *)refreshExpertData {
  //刷新数据
  [self.tableHeader.planTimeView bindDataForCell:refreshExpertData.userProject];
  [self.tableHeader.expertInfoView bindUserInfo:refreshExpertData.userHead];
  if (self.expertPlanData.state == UserPurchasedState) {
    [self.cattlePlanYieldCurve refreshData];
  } else if (self.expertPlanData.state == UserNotPurchasedState) {
    CGFloat planDescHeight =
        [self.tableHeader.planDescView bindData:refreshExpertData.userDescData];
    self.tableHeader.planDescHeight.constant = planDescHeight;
  }
}

@end

/** 用户视图 不管购买没购买 计划 运行状态 **/
@implementation UserWithPlanRunningEPTHPresentation

- (void)resetViews {

  //计划时间 隐藏
  self.tableHeader.planTimeHeight.constant = 0.0f;
  self.tableHeader.planTimeView.hidden = YES;

  //账号资产 隐藏
  self.tableHeader.accountAssestHeight.constant = 0.0f;
  self.tableHeader.accountAssestView.hidden = YES;

  //牛人简介 隐藏
  self.tableHeader.planDescHeight.constant = 0.0f;
  self.tableHeader.planDescView.hidden = YES;

  //显示 曲线 显示 收益运行天数
  self.tableHeader.planGoalHeight.constant = 89.0f;
  self.tableHeader.planGoalView.hidden = NO;

  self.tableHeader.profileGraphView.hidden = NO;
  self.tableHeader.profileGraphHeight.constant = 202.0f;
  //曲线
  [self createYieldCurve];
  //铺数据
  [self.tableHeader.expertInfoView bindUserInfo:self.expertPlanData.userHead];
  //收益数据 续写
  [self.tableHeader.planGoalView
      bindDataForProfitOrPlanDays:self.expertPlanData.planGoalData];
}

- (void)refreshExpertPlanHeadeData:(ExpertPlanData *)refreshExpertData {
  [self.cattlePlanYieldCurve refreshData];
  //铺数据
  [self.tableHeader.expertInfoView bindUserInfo:refreshExpertData.userHead];
  //收益数据 续写
  [self.tableHeader.planGoalView
      bindDataForProfitOrPlanDays:refreshExpertData.planGoalData];
}

@end

/** 牛人视图 计划未运行 */
@implementation ExpertWithPlanNotRunningEPTHPresentation

- (void)resetViews {

  //显示 计划时间 曲线图 账号资产
  self.tableHeader.planTimeHeight.constant = 110.0f;
  self.tableHeader.planTimeView.hidden = NO;

  [self.tableHeader.planTimeView
      bindDataForCell:self.expertPlanData.userProject];
  //曲线
  [self createYieldCurve];
  self.tableHeader.profileGraphHeight.constant = 202.0f;
  self.tableHeader.profileGraphView.hidden = NO;

  self.tableHeader.accountAssestView.hidden = NO;
  self.tableHeader.accountAssestHeight.constant = 79.0f;

  //隐藏 收益运行天数 简介
  self.tableHeader.planGoalHeight.constant = 0.0f;
  self.tableHeader.planGoalView.hidden = YES;

  self.tableHeader.planDescView.hidden = YES;
  self.tableHeader.planDescHeight.constant = 0.0f;

  //铺 数据
  [self.tableHeader.expertInfoView bindUserInfo:self.expertPlanData.userHead];
}

- (void)refreshExpertPlanHeadeData:(ExpertPlanData *)refreshExpertData {
  [self.cattlePlanYieldCurve refreshData];
  //铺 数据
  [self.tableHeader.expertInfoView bindUserInfo:refreshExpertData.userHead];
  [self.tableHeader.planTimeView bindDataForCell:refreshExpertData.userProject];
}

@end

/** 牛人视图 计划运行中 */
@implementation ExpertWithPlanRunningEPTHPresentation

- (void)resetViews {
  //显示 收益运行天数 曲线图 账号资产
  self.tableHeader.planGoalHeight.constant = 89.0f;
  self.tableHeader.planGoalView.hidden = NO;

  self.tableHeader.profileGraphView.hidden = NO;
  self.tableHeader.profileGraphHeight.constant = 202.0f;
  //曲线
  [self createYieldCurve];

  self.tableHeader.accountAssestView.hidden = NO;
  self.tableHeader.accountAssestHeight.constant = 79.0f;

  //隐藏 计划时间控件  牛人简介
  self.tableHeader.planTimeHeight.constant = 0.0f;
  self.tableHeader.planTimeView.hidden = YES;

  self.tableHeader.planDescHeight.constant = 0.0f;
  self.tableHeader.planDescView.hidden = YES;

  //铺数据
  [self.tableHeader.expertInfoView bindUserInfo:self.expertPlanData.userHead];
  //收益数据 续写
  [self.tableHeader.planGoalView
      bindDataForProfitOrPlanDays:self.expertPlanData.planGoalData];
}

- (void)refreshExpertPlanHeadeData:(ExpertPlanData *)refreshExpertData {
  [self.cattlePlanYieldCurve refreshData];
  //铺数据
  [self.tableHeader.expertInfoView bindUserInfo:refreshExpertData.userHead];
  //收益数据 续写
  [self.tableHeader.planGoalView
      bindDataForProfitOrPlanDays:refreshExpertData.planGoalData];
}

@end