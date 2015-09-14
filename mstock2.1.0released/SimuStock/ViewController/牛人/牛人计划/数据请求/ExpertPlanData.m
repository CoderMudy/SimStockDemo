//
//  ExpertPlanData.m
//  SimuStock
//
//  Created by 刘小龙 on 15/7/3.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "ExpertPlanData.h"
#import "JsonFormatRequester.h"

@implementation UserOrProjectNotPurchasedNotRunning

@end

@implementation UserHeadData

@end

@implementation BuyingTipsData

@end

@implementation UserDescData

@end

@implementation EPPlanGoalViewData

@end

//解析类
@implementation ExpertPlanData

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];

  NSDictionary *result = dic[@"result"];

  //账户资产信息
  NSDictionary *account = result[@"account"];
  //牛人计划信息
  NSDictionary *planInfo = result[@"plan"];
  //用户 头像
  NSDictionary *userInfo = result[@"user"];
  //数据 user里的内容
  NSDictionary *extendMap = userInfo[@"extendMap"];

  //状态
  self.state = [result[@"state"] integerValue];
  //计划状态
  self.planState = [planInfo[@"status"] integerValue];
  self.accoundId = planInfo[@"accountId"];
  self.targetUid = [planInfo[@"uid"] integerValue];

  //数据tableview 头里面需要是数据
  self.userHead = [[UserHeadData alloc] init];

  ///计划名称
  self.planName = planInfo[@"name"];

  //状态 1 牛人视角 2 已购买 3 未购买
  self.userHead.state = [result[@"state"] integerValue];

  self.userHead.accoundId = planInfo[@"accountId"];
  self.userHead.targetUid = [planInfo[@"uid"] integerValue];

  //头像
  self.userHead.headImage = extendMap[@"head_pic"];

  self.userHead.receive_cow_num = [extendMap[@"receive_cow_num"] integerValue];

  //名字
  self.userHead.name = account[@"realName"];
  self.userHead.nickname = userInfo[@"nickName"];
  //简介
  self.userHead.desc = account[@"desc"];
  //已经购买数量 = 购买人数
  self.userHead.purchasedNum = [planInfo[@"buyerCount"] integerValue];

  //上期收益
  self.userHead.lastPlanProfit = [account[@"lastPlanProfit"] doubleValue];

  //历史计划
  self.userHead.closePlans = [account[@"closePlans"] integerValue];

  //成功计划
  self.userHead.sucPlans = [account[@"sucPlans"] integerValue];

  //成功率
  self.userHead.sucRate = [account[@"sucRate"] doubleValue];

  /*********************************************/

  //用户未购买或者 计划未运行cell数据
  self.userProject = [[UserOrProjectNotPurchasedNotRunning alloc] init];
  //计划运行时间
  self.userProject.planStartTime = [planInfo[@"startTime"] longLongValue];

  //目标收益
  self.userProject.targetProfit = [planInfo[@"goalProfit"] doubleValue];

  //止损线
  self.userProject.stopLossLine = [planInfo[@"stopLossLine"] doubleValue];

  //计划期限
  self.userProject.planTimeLimit = [planInfo[@"goalMonths"] integerValue];

  //状态 1 牛人视角 2 已购买 3 未购买
  self.userProject.state = [result[@"state"] integerValue];

  //计划状态
  self.userProject.status = [planInfo[@"status"] integerValue];
  //抢购状态
  self.userProject.itemState = [planInfo[@"buystatus"] integerValue];

  /*********************************************/

  self.userDescData = [[UserDescData alloc] init];
  self.userDescData.userDesc = planInfo[@"desc"];

  //未购买用户 下面提示抢购的View的数据
  self.buyingTips = [[BuyingTipsData alloc] init];
  //计划价格
  self.buyingTips.trackPrice = [planInfo[@"price"] doubleValue];

  //计划可购买状态
  self.buyingTips.itemState = [planInfo[@"buystatus"] integerValue];

  /********************** 收益控件数据 ***********/

  self.planGoalData = [[EPPlanGoalViewData alloc] init];
  //目标收益
  self.planGoalData.targetProfit = [planInfo[@"goalProfit"] doubleValue];

  //当前收益
  self.planGoalData.currentProfit = [planInfo[@"profitRate"] doubleValue];

  //计划期限
  self.planGoalData.planTimeLimit = [planInfo[@"goalMonths"] integerValue];

  //当前运行天数
  self.planGoalData.runningDays = [planInfo[@"runDay"] integerValue];
}

/// 1返回 用户视角 计划处于募集期
- (BOOL)isUserWithPlanPrepare {
  return _planState == PlanStateRecruitmengPeriod &&
         (_state == UserPurchasedState || _state == UserNotPurchasedState);
}
/// 2返回 用户视角 计划处于运行状态
- (BOOL)isUserWithPlanRunning {
  // 当计划 处于 冻结 成功关闭 失败关闭 提前终止 等状态 都显示 运行时的 状态
  return (_planState == PlanStateRunning || _planState == PlanStateFrozen ||
          _planState == PlanStateSuccessfullyClosed ||
          _planState == PlanStateFailedClosed ||
          _planState == PlanStateOffShelf ||
          _planState == PlanStateAdvanceStopClosed) &&
         (_state == UserPurchasedState || _state == UserNotPurchasedState);
}

/// 3返回 牛人视角 计划处于运行时的状态
- (BOOL)isExpertPlanWithRunning {
  return (_state == ExpertPerspectiveState) &&
         (_planState == PlanStateRunning || _planState == PlanStateFrozen ||
          _planState == PlanStateFailedClosed ||
          _planState == PlanStateSuccessfullyClosed ||
          _planState == PlanStateOffShelf ||
          _planState == PlanStateAdvanceStopClosed);
}

/// 4返回 牛人视角 计划处于募集期
- (BOOL)isExpertPlanRecruitmengPeriod {
  return _state == ExpertPerspectiveState &&
         _planState == PlanStateRecruitmengPeriod;
}

//判断1 是否为 用户未购买 计划未运行
- (BOOL)judgeUserNotPurchasedPlanNotRunning {
  return _state == UserNotPurchasedState &&
         _planState == PlanStateRecruitmengPeriod;
}

//判断2 如果用户购买了
- (BOOL)judgeUserPurchased {
  return _state == UserPurchasedState;
}

//判断3 用户未购买 计划运行
- (BOOL)judgeUserNoPurchasedPlanRunning {
  return _state == UserNotPurchasedState &&
         (_planState == PlanStateRunning ||
          _planState == PlanStateAdvanceStopClosed ||
          _planState == PlanStateSuccessfullyClosed ||
          _planState == PlanStateOffShelf ||
          _planState == PlanStateFailedClosed || _planState == PlanStateFrozen);
}

//判断4 牛人视角
- (BOOL)judgeExpert {
  return _state == ExpertPerspectiveState;
}

//判断5 计划处于 冻结 下架 成功关闭 或者 失败关闭 提前终止
- (BOOL)judgePlanIsSuccounCloseOrOffShef {
  return _planState == PlanStateOffShelf ||
         _planState == PlanStateSuccessfullyClosed ||
         _planState == PlanStateFailedClosed ||
         _planState == PlanStateAdvanceStopClosed ||
         _planState == PlanStateFrozen;
}

/** 牛人计划主页数据请求 */
+ (void)requestHomeDataForExpertPlanWithDictionary:
            (NSDictionary *)dic withCallback:(HttpRequestCallBack *)callback {
  NSString *url = [data_address stringByAppendingString:@"youguu/super_trade/"
                                @"plan_main?accountId={accountId}&"
                                @"targetUid={targetUid}"];
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[ExpertPlanData class]
             withHttpRequestCallBack:callback];
}

@end
