//
//  ExpertPlanData.h
//  SimuStock
//
//  Created by 刘小龙 on 15/7/3.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"
#import "ExpertPlanConst.h"
@class HttpRequestCallBack;

//收益控件的 数据
@interface EPPlanGoalViewData : BaseRequestObject2

/** 目标收益 */
@property(assign, nonatomic) double targetProfit;

/** 当前收益 */
@property(assign, nonatomic) double currentProfit;

/** 计划期限 */
@property(assign, nonatomic) NSInteger planTimeLimit;

/** 运行天数 */
@property(assign, nonatomic) NSInteger runningDays;

@end

/** 用户未购买 或者 已购买 项目未运行 */
@interface UserOrProjectNotPurchasedNotRunning : BaseRequestObject2

/** 计划开始运行时间 */
@property(assign, nonatomic) long long planStartTime;

/** 目标收益 */
@property(assign, nonatomic) double targetProfit;

/** 止损线 */
@property(assign, nonatomic) double stopLossLine;

/** 计划期限 */
@property(assign, nonatomic) NSInteger planTimeLimit;

/****** 借用一下 ****/

/** 状态  1:牛人视角 2：已购买 3：未购买 */
@property(assign, nonatomic) RolePerspectiveState state;

/** 计划状态 （0：未上架，1：募集期，2：运行中，3：冻结， 4：成功关闭,
 * 5：失败关闭, 6：下架）*/
@property(assign, nonatomic) PlanState status;

/** 买卖状态   1 已购买 0 可以购买 2 售完 */
@property(assign, nonatomic) ProductSaleState itemState;
@end

/** 在数组的 第二位 */
@interface UserDescData : NSObject

//用户资历介绍
@property(strong, nonatomic) NSString *userDesc;

@end

// tableview头上面的数据
@interface UserHeadData : BaseRequestObject2

/** 状态  1:牛人视角 2：已购买 3：未购买 */
@property(assign, nonatomic) RolePerspectiveState state;

/** accoundId */
@property(strong, nonatomic) NSString *accoundId;

/** targetUid */
@property(assign, nonatomic) NSInteger targetUid;

/** 头像 */
@property(strong, nonatomic) NSString *headImage;

/** 牛头数 */
@property(assign, nonatomic) NSInteger receive_cow_num;

/** 名字 */
@property(strong, nonatomic) NSString *name;

/** 昵称 */
@property(strong, nonatomic) NSString *nickname;

/** 简介 */
@property(strong, nonatomic) NSString *desc;

/** 已经购买的数量 */
@property(assign, nonatomic) NSInteger purchasedNum;

/** 上期收益 */
@property(assign, nonatomic) double lastPlanProfit;

/** 历史计划 */
@property(assign, nonatomic) NSInteger closePlans;

/** 成功计划 */
@property(assign, nonatomic) NSInteger sucPlans;

/** 成功率 */
@property(assign, nonatomic) double sucRate;

@end

/** 未购买用户 下面提示抢购的View的数据 */
@interface BuyingTipsData : BaseRequestObject2

/** 追踪价格 */
@property(assign, nonatomic) double trackPrice;

/** 买卖状态 1 已购买 0 可以购买 2 售完 */
@property(assign, nonatomic) ProductSaleState itemState;

@end

//数据请求类
@interface ExpertPlanData : JsonRequestObject

/** 状态  1:牛人视角 2：已购买 3：未购买 */
@property(assign, nonatomic) RolePerspectiveState state;

/** 计划状态 */
@property(assign, nonatomic) PlanState planState;

/** 计划的id： accoundId */
@property(strong, nonatomic) NSString *accoundId;

/** 创建计划的牛人的id：targetUid */
@property(assign, nonatomic) NSInteger targetUid;

/** 用户未购买 或者 已购买 项目未运行 */
@property(strong, nonatomic) UserOrProjectNotPurchasedNotRunning *userProject;

// tableview头上面的数据
@property(strong, nonatomic) UserHeadData *userHead;

//价格买入提示
@property(strong, nonatomic) BuyingTipsData *buyingTips;

@property(strong, nonatomic) UserDescData *userDescData;

///收益控件数据
@property(strong, nonatomic) EPPlanGoalViewData *planGoalData;

/** 计划名称 */
@property(strong, nonatomic) NSString *planName;

///返回 用户视角  计划是否处于募集期
- (BOOL)isUserWithPlanPrepare;

///返回 用户视角 计划处于运行状态
- (BOOL)isUserWithPlanRunning;

///返回 牛人视角 计划处于运行时的状态
- (BOOL)isExpertPlanWithRunning;

///返回 牛人视角 计划处于募集期
- (BOOL)isExpertPlanRecruitmengPeriod;

//判断1 是否为 用户未购买 计划未运行
- (BOOL)judgeUserNotPurchasedPlanNotRunning;

//判断2 如果用户购买了
- (BOOL)judgeUserPurchased;

//判断3 用户未购买 计划运行
- (BOOL)judgeUserNoPurchasedPlanRunning;

//判断4 牛人视角
- (BOOL)judgeExpert;

//判断5 计划处于 冻结 下架 成功关闭 或者 失败关闭
- (BOOL)judgePlanIsSuccounCloseOrOffShef;
/** 牛人计划主页数据请求 */
+ (void)requestHomeDataForExpertPlanWithDictionary:
            (NSDictionary *)dic withCallback:(HttpRequestCallBack *)callback;

@end
