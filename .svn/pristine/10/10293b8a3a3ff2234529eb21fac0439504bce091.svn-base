//
//  SimuConfigConst.m
//  SimuStock
//
//  Created by Mac on 15/8/3.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SimuConfigConst.h"
#import "SimuUtil.h"
#import "JsonFormatRequester.h"

@implementation SimuConfigConst

#pragma mark
#pragma mark 配资业务
/**
 *  默认不显示配资
 */
static BOOL showWithFund = NO;

+ (BOOL)isShowWithFund {
  return showWithFund;
};

+ (void)setShowWithFund:(BOOL)show {
  BOOL changed = showWithFund != show;
  showWithFund = show;
  if (changed) {
    [[NSNotificationCenter defaultCenter] postNotificationName:WFShowValueChangedNotificationName
                                                        object:nil];
  }
}

#pragma mark
#pragma mark app review时的道具列表

/**
 *  默认显示app review时的道具列表
 */
static BOOL showPropsForReview = YES;

+ (BOOL)isShowPropsForReview {
  return showPropsForReview;
};

+ (void)setShowPropsForReview:(BOOL)show {
  showPropsForReview = show;
}

#pragma mark
#pragma mark 牛人计划

/**
 *  默认不显示牛人计划
 */
static BOOL showExpertPlan = NO;

+ (BOOL)isShowExpertPlan {
  return showExpertPlan;
};

+ (void)setShowExpertPlan:(BOOL)show {
  showExpertPlan = show;
}

#pragma mark
#pragma mark 数据解析和请求

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  /// 匹配后台返回数据，是否有配资界面，type = 1(配资) 2商城(IOS)
  NSArray *funcno = dic[@"funcno"];
  [funcno enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
    if ([obj isEqualToString:SHOW_WITH_FOND]) {
      [SimuConfigConst setShowWithFund:YES];
    } else if ([obj isEqualToString:SHOW_PROPS_FOR_EXCHANGE]) {
      [SimuConfigConst setShowPropsForReview:NO];
    } else if ([obj isEqualToString:SHOW_EXPERT_PLAN]) {
      [SimuConfigConst setShowExpertPlan:YES];
    }
  }];
}

//获取全局配置信息
+ (void)requestServerOnlineConfig {
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];

  callback.onSuccess = ^(NSObject *obj) {

  };

  callback.onFailed = ^{
    ///网络请求，判断是否要显示配资
    [SimuUtil performBlockOnMainThread:^{
      [SimuConfigConst requestServerOnlineConfig];
    } withDelaySeconds:600.0f];

  };
  [SimuConfigConst requestServerOnlineConfigWithCallback:callback];
}

///获取全局配置信息
+ (void)requestServerOnlineConfigWithCallback:(HttpRequestCallBack *)callback {
  NSString *url = [NSString stringWithFormat:@"%@asteroid/menu/list?ak=%@", adData_address, [SimuUtil getAK]];

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[SimuConfigConst class]
             withHttpRequestCallBack:callback];
}

@end

@implementation OnWFShowValueChangedNotification

- (id)init {
  if (self = [super init]) {
    [self addObservers];
  }
  return self;
}

- (void)addObservers {
  __weak OnWFShowValueChangedNotification *weakSelf = self;
  [self addObserverName:WFShowValueChangedNotificationName
           withObserver:^(NSNotification *notif) {
             weakSelf.onWFShowValueChanged();
           }];
}

@end
