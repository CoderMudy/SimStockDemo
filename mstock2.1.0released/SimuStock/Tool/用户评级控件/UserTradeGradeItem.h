//
//  UserTradeGradeItem.h
//  SimuStock
//
//  Created by Yuemeng on 15/3/8.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"

@class HttpRequestCallBack;

/** 用户交易评级数据 */
@interface UserTradeGradeItem : JsonRequestObject

///账户id
@property(nonatomic, copy) NSString *accountId;
///昵称
@property(nonatomic, copy) NSString *nick;
///交易评级
@property(nonatomic, copy) NSString *ratingGrade;
///准确性
@property(nonatomic, strong) NSNumber *accuracy;
///盈利性
@property(nonatomic, strong) NSNumber *profitability;
///稳定性
@property(nonatomic, strong) NSNumber *stability;
///总分
@property(nonatomic, strong) NSNumber *totalScore;
///总天数
@property(nonatomic, strong) NSNumber *totalDays;
///是否为空
@property(nonatomic) BOOL isNil;

/** 用户交易评级数据 */
+ (void)requestUserTradeGradeItemWithUID:(NSString *)uid
                            withCallback:(HttpRequestCallBack *)callback;

@end
