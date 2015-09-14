//
//  SimuConfigConst.h
//  SimuStock
//
//  Created by Mac on 15/8/3.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequestObject.h"
#import "BaseNotificationObserverMgr.h"

static NSString *const WFShowValueChangedNotificationName = @"WFShowValueChangedNotificationName";

/** 变更后回调 */
typedef void (^OnWFShowValueChangedAction)();

@interface OnWFShowValueChangedNotification : BaseNotificationObserverMgr

/** 自选股变更后回调 */
@property(copy, nonatomic) OnWFShowValueChangedAction onWFShowValueChanged;

@end

#pragma
#pragma mark SimuConfigConst

@class HttpRequestCallBack;

static NSString *const SHOW_WITH_FOND = @"1";
static NSString *const SHOW_PROPS_FOR_EXCHANGE = @"2";
static NSString *const SHOW_EXPERT_PLAN = @"3";

@interface SimuConfigConst : JsonRequestObject

/**
 *  是否显示配资业务
 *
 *  @return BOOL
 */
+ (BOOL)isShowWithFund;

/**
 *  设置是否显示配资业务
 *
 *  @param show BOOL
 */
+ (void)setShowWithFund:(BOOL)show;

/**
 *  是否显示牛人计划业务
 *
 *  @return BOOL
 */
+ (BOOL)isShowExpertPlan;

/**
 *  设置是否显示牛人计划业务
 *
 *  @param show BOOL
 */
+ (void)setShowExpertPlan:(BOOL)show;

/**
 *  是否显示app review时的道具列表
 *
 *  @return BOOL
 */
+ (BOOL)isShowPropsForReview;

/**
 *  设置是否显示app review时的道具列表
 *
 *  @param show BOOL
 */
+ (void)setShowPropsForReview:(BOOL)show;

/**
 *  获取全局配置信息
 */
+ (void)requestServerOnlineConfig;

@end
